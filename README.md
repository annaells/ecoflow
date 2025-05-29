# 🌱 EcoFlow - Sustainable Energy Marketplace


![EcoFlow Logo](https://img.shields.io/badge/EcoFlow-🌱%20Clean%20Energy-green?style=for-the-badge)

## 🌿 What is EcoFlow?

EcoFlow is a revolutionary **peer-to-peer renewable energy marketplace** built on the Stacks blockchain. Our platform enables clean energy producers to directly sell their excess power to environmentally conscious consumers, creating a transparent and efficient green energy economy.

### ✨ Key Features

- 🏭 **Clean Generator Network**: Onboard solar, wind, hydro producers
- 🏠 **Power Buyer Marketplace**: Connect with verified energy consumers  
- ⚡ **Real-Time Trading**: Instant power credit transactions
- 🏛️ **Decentralized Governance**: Community-driven platform management
- 🔍 **Transparent Tracking**: Full audit trail of energy production and consumption
- 💰 **Fair Pricing**: Market-driven rates with minimal platform fees (2%)

---

## 🚀 Quick Start

### Prerequisites

- Stacks wallet (Hiro Wallet recommended)
- Test STX for transaction fees
- Renewable energy source (for generators) or green energy demand (for buyers)

### For Clean Energy Generators 🌞

#### 1. Register as Generator
```clarity
(onboard_clean_generator initial-token-price)
```
Set your price per watt and join the network.

#### 2. Get Certified ✅
Wait for platform verification of your clean energy source.

#### 3. Log Production
```clarity
(log_clean_power_generation watts-produced)
```
Record your daily/hourly clean energy generation.

#### 4. Earn from Sales 💚
Buyers will purchase your power credits automatically.

### For Power Buyers 🏡

#### 1. Register as Buyer
```clarity
(onboard_power_buyer)
```
Create your consumer account on EcoFlow.

#### 2. Browse Generators
Explore verified clean energy producers in your region.

#### 3. Purchase Power Credits
```clarity
(initiate_power_trade generator-address watts-quantity)
```
Buy clean energy credits directly from producers.

#### 4. Track Your Impact 📊
Monitor your renewable energy consumption and carbon offset.

---

## 🏗️ Platform Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     EcoFlow Marketplace                     │
├─────────────────────────────────────────────────────────────┤
│  🌞 Generators      │  ⚡ Trading Engine  │  🏠 Consumers    │
│  ┌─────────────┐    │  ┌─────────────┐   │ ┌─────────────┐  │
│  │ Solar Farms │    │  │ P2P Trades  │   │ │ Households  │  │
│  │ Wind Parks  │    │  │ Price Match │   │ │ Businesses  │  │
│  │ Hydro Plants│    │  │ 2% Fee      │   │ │ Communities │  │
│  └─────────────┘    │  └─────────────┘   │ └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 🎯 Core Components

| Component | Description |
|-----------|-------------|
| **Generator Registry** | Verified renewable energy producers |
| **Power Token System** | Tradeable credits representing clean watts |
| **Marketplace Engine** | P2P trading with automated matching |
| **Certification Layer** | Admin verification of clean energy sources |

---

## 💡 Use Cases

### 🏠 Residential Solar Sharing
```
1. Homeowner installs solar panels
2. Register as generator on EcoFlow
3. Get certified by platform admins
4. Sell excess power to neighbors
5. Earn passive income from clean energy
```

### 🏢 Corporate Sustainability
```
1. Company wants 100% renewable energy
2. Register as power buyer
3. Purchase credits from certified generators
4. Meet ESG goals and carbon neutrality
5. Support local clean energy economy
```

### 🌾 Community Energy Cooperatives
```
1. Rural community builds wind farm
2. Register cooperative as generator
3. Sell power to urban buyers
4. Generate revenue for local development
5. Strengthen rural-urban connections
```

---

## 🔧 Development

### Smart Contract Details

**Network**: Stacks Mainnet/Testnet  
**Language**: Clarity  
**License**: MIT  

### Key State Variables

| Variable | Purpose |
|----------|---------|
| `next_transaction_id` | Unique trade identifier counter |
| `minimum_trade_threshold` | Minimum watts per transaction (100) |
| `platform_fee_percentage` | Current fee rate (2%) |
| `maximum_price_cap` | Price ceiling for market stability |

### Generator Profile Structure
```clarity
{
  total_watts_generated: uint,     // Cumulative production
  certification_active: bool,      // Verified clean source
  onboarding_block: uint,         // Registration timestamp
  watts_per_token_rate: uint      // Price per watt
}
```

### Buyer Profile Structure
```clarity
{
  total_watts_purchased: uint,     // Cumulative consumption
  available_power_tokens: uint,    // Current credit balance
  account_creation_block: uint     // Registration timestamp
}
```

---

## 🛡️ Security & Verification

### 🔒 Generator Certification Process
1. **Self-Registration**: Generator sets initial price and joins
2. **Documentation Review**: Submit proof of renewable energy source
3. **On-Site Verification**: Optional physical inspection for large producers
4. **Certification Approval**: Admin activates generator account
5. **Continuous Monitoring**: Regular production reporting required

### ⚠️ Risk Management
- Generator verification prevents fraudulent claims
- Minimum trade thresholds reduce spam transactions
- Price caps protect against market manipulation
- Admin controls for emergency platform management

### 🔍 Transparency Features
```clarity
// All transactions recorded on-chain
{
  power_supplier: principal,
  power_purchaser: principal,
  watts_traded: uint,
  final_price: uint,
  trade_block: uint,
  execution_status: string
}
```

---

## 🌍 Environmental Impact

### Carbon Footprint Calculator
```
Clean Energy Purchased × Regional Carbon Factor = CO₂ Offset
```

### Renewable Energy Certificates (RECs)
Each power token represents verified renewable energy generation, functioning as a digital REC.

### Sustainability Metrics
- **Total Clean Watts Traded**: Real-time marketplace volume
- **Generators Certified**: Number of verified renewable sources
- **Carbon Offset**: Cumulative environmental impact
- **Community Growth**: Active buyer-seller relationships

---

## 🏆 Incentive Programs

### Generator Rewards 🌞
- **Early Adopter Bonus**: Higher rates for first 100 generators
- **Consistency Rewards**: Bonuses for regular production logging
- **Clean Technology Grants**: Funding for equipment upgrades

### Buyer Benefits 🏠
- **Green Certification**: Digital badges for sustainable consumption
- **Volume Discounts**: Lower rates for large purchases
- **Community Recognition**: Leaderboards for top eco-consumers

---

## 📊 Market Analytics

### Real-Time Dashboards
- Current power prices by region
- Generator production statistics  
- Buyer consumption patterns
- Market supply/demand trends

### Historical Data
- Price evolution over time
- Seasonal production patterns
- Regional clean energy adoption
- Platform growth metrics

---

## 🤝 Contributing

We welcome contributions from the clean energy community!

### Development Setup
```bash
# Install Clarinet
npm install -g @hirosystems/clarinet-cli

# Clone the repo
git clone https://github.com/annaells/ecoflow.git
cd ecoflow

# Run tests
clarinet test

# Deploy to devnet
clarinet deploy --devnet
```

### Contribution Areas
- Smart contract improvements
- Frontend dApp development
- Mobile applications
- Data analytics tools
- Documentation and tutorials

---

## 🗺️ Roadmap

### Phase 1: Foundation (Current)
- [x] Core marketplace smart contract
- [x] Generator and buyer registration
- [x] Basic trading functionality
- [x] Admin certification system

### Phase 2: Enhancement (Q2 2025)
- [ ] Web dApp interface
- [ ] Mobile applications (iOS/Android)
- [ ] Advanced analytics dashboard
- [ ] Regional expansion features

### Phase 3: Scale (Q3 2025)
- [ ] Cross-chain bridge integration
- [ ] IoT device integration for automatic logging
- [ ] AI-powered price optimization
- [ ] Corporate partnership program

### Phase 4: Ecosystem (Q4 2025)
- [ ] DeFi integration (lending against power credits)
- [ ] Insurance products for generators
- [ ] Governance token and DAO launch
- [ ] International market expansion

---

## 📜 License

This project is licensed under the MIT License.
