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
