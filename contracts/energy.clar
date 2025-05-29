;; EcoFlow - Sustainable Energy Marketplace
;; Seamlessly connecting clean power producers with conscious consumers

;; Error codes
(define-constant ERR_ACCESS_DENIED (err u100))
(define-constant ERR_INVALID_POWER_AMOUNT (err u101))
(define-constant ERR_INSUFFICIENT_POWER_CREDITS (err u102))
(define-constant ERR_GENERATOR_NOT_REGISTERED (err u103))
(define-constant ERR_BUYER_NOT_REGISTERED (err u104))
(define-constant ERR_ACCOUNT_ALREADY_EXISTS (err u105))
(define-constant ERR_TRADE_STATUS_INVALID (err u106))
(define-constant ERR_PRICE_OUT_OF_RANGE (err u107))
(define-constant ERR_GENERATOR_ADDRESS_INVALID (err u108))

;; Data Maps
(define-map clean_power_generators 
    principal 
    {
        total_watts_generated: uint,
        certification_active: bool,
        onboarding_block: uint,
        watts_per_token_rate: uint
    }
)

(define-map power_buyers
    principal
    {
        total_watts_purchased: uint,
        available_power_tokens: uint,
        account_creation_block: uint
    }
)

(define-map marketplace_transactions
    uint
    {
        power_supplier: principal,
        power_purchaser: principal,
        watts_traded: uint,
        final_price: uint,
        trade_block: uint,
        execution_status: (string-ascii 20)
    }
)

;; State Variables
(define-data-var next_transaction_id uint u0)
(define-data-var marketplace_owner principal tx-sender)
(define-data-var minimum_trade_threshold uint u100)
(define-data-var platform_fee_percentage uint u2)
(define-data-var maximum_price_cap uint u1000000) ;; Maximum allowed price per token

;; Read-only functions
(define-read-only (get_generator_profile (generator_wallet principal))
    (map-get? clean_power_generators generator_wallet)
)

(define-read-only (get_buyer_profile (buyer_wallet principal))
    (map-get? power_buyers buyer_wallet)
)

(define-read-only (get_transaction_record (transaction_id uint))
    (map-get? marketplace_transactions transaction_id)
)

(define-read-only (get_platform_fee_rate)
    (var-get platform_fee_percentage)
)

;; Private functions
(define-private (compute_platform_fee (watts_amount uint))
    (/ (* watts_amount (var-get platform_fee_percentage)) u100)
)

(define-private (execute_power_transfer (supplier_wallet principal) (purchaser_wallet principal) (watts_quantity uint))
    (let (
        (supplier_profile (unwrap! (map-get? clean_power_generators supplier_wallet) ERR_GENERATOR_NOT_REGISTERED))
        (purchaser_profile (unwrap! (map-get? power_buyers purchaser_wallet) ERR_BUYER_NOT_REGISTERED))
    )
    (if (>= (get total_watts_generated supplier_profile) watts_quantity)
        (begin
            (map-set clean_power_generators supplier_wallet
                (merge supplier_profile {total_watts_generated: (- (get total_watts_generated supplier_profile) watts_quantity)}))
            (map-set power_buyers purchaser_wallet
                (merge purchaser_profile {available_power_tokens: (+ (get available_power_tokens purchaser_profile) watts_quantity)}))
            (ok true))
        ERR_INSUFFICIENT_POWER_CREDITS)
    )
)

;; Public functions
(define-public (onboard_clean_generator (initial_token_price uint))
    (let ((generator_wallet tx-sender))
        (asserts! (is-none (map-get? clean_power_generators generator_wallet)) ERR_ACCOUNT_ALREADY_EXISTS)
        (asserts! (and (> initial_token_price u0) (<= initial_token_price (var-get maximum_price_cap))) ERR_PRICE_OUT_OF_RANGE)
        (ok (map-set clean_power_generators generator_wallet {
            total_watts_generated: u0,
            certification_active: false,
            onboarding_block: block-height,
            watts_per_token_rate: initial_token_price
        }))
    )
)

(define-public (onboard_power_buyer)
    (let ((buyer_wallet tx-sender))
        (asserts! (is-none (map-get? power_buyers buyer_wallet)) ERR_ACCOUNT_ALREADY_EXISTS)
        (ok (map-set power_buyers buyer_wallet {
            total_watts_purchased: u0,
            available_power_tokens: u0,
            account_creation_block: block-height
        }))
    )
)

(define-public (log_clean_power_generation (watts_produced uint))
    (let (
        (generator_wallet tx-sender)
        (generator_profile (unwrap! (map-get? clean_power_generators generator_wallet) ERR_GENERATOR_NOT_REGISTERED))
    )
    (asserts! (get certification_active generator_profile) ERR_ACCESS_DENIED)
    (ok (map-set clean_power_generators generator_wallet
        (merge generator_profile 
            {total_watts_generated: (+ (get total_watts_generated generator_profile) watts_produced)})))
    )
)

(define-public (initiate_power_trade (generator_wallet principal) (watts_quantity uint))
    (let (
        (purchaser_wallet tx-sender)
        (generator_profile (unwrap! (map-get? clean_power_generators generator_wallet) ERR_GENERATOR_NOT_REGISTERED))
        (purchaser_profile (unwrap! (map-get? power_buyers purchaser_wallet) ERR_BUYER_NOT_REGISTERED))
        (transaction_id (+ (var-get next_transaction_id) u1))
        (total_cost (* watts_quantity (get watts_per_token_rate generator_profile)))
    )
    (asserts! (is-some (map-get? clean_power_generators generator_wallet)) ERR_GENERATOR_ADDRESS_INVALID)
    (asserts! (>= watts_quantity (var-get minimum_trade_threshold)) ERR_INVALID_POWER_AMOUNT)
    (try! (execute_power_transfer generator_wallet purchaser_wallet watts_quantity))
    (var-set next_transaction_id transaction_id)
    (ok (map-set marketplace_transactions transaction_id {
        power_supplier: generator_wallet,
        power_purchaser: purchaser_wallet,
        watts_traded: watts_quantity,
        final_price: total_cost,
        trade_block: block-height,
        execution_status: "completed"
    }))
    )
)

;; Admin functions
(define-public (certify_clean_generator (generator_wallet principal))
    (let ((admin_wallet tx-sender))
        (asserts! (is-eq admin_wallet (var-get marketplace_owner)) ERR_ACCESS_DENIED)
        (asserts! (is-some (map-get? clean_power_generators generator_wallet)) ERR_GENERATOR_NOT_REGISTERED)
        (match (map-get? clean_power_generators generator_wallet)
            generator_profile (ok (map-set clean_power_generators generator_wallet 
                (merge generator_profile {certification_active: true})))
            ERR_GENERATOR_NOT_REGISTERED)
    )
)

(define-public (adjust_platform_fee_rate (new_fee_rate uint))
    (begin
        (asserts! (is-eq tx-sender (var-get marketplace_owner)) ERR_ACCESS_DENIED)
        (asserts! (<= new_fee_rate u100) ERR_INVALID_POWER_AMOUNT)
        (ok (var-set platform_fee_percentage new_fee_rate))
    )
)

(define-public (modify_minimum_trade_size (new_minimum_watts uint))
    (begin
        (asserts! (is-eq tx-sender (var-get marketplace_owner)) ERR_ACCESS_DENIED)
        (asserts! (> new_minimum_watts u0) ERR_INVALID_POWER_AMOUNT)
        (ok (var-set minimum_trade_threshold new_minimum_watts))
    )
)

;; Contract initialization
(begin
    (var-set next_transaction_id u0)
    (var-set minimum_trade_threshold u100)
    (var-set platform_fee_percentage u2)
    (var-set maximum_price_cap u1000000)
)