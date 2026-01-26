## Blue Carbon MRV Contracts

Smart contracts for the **Blockchain-Powered Blue Carbon MRV Registry**

## Overview

This repository contains the Solidity smart contracts powering a decentralized Monitoring, Reporting, and Verification (MRV) system for blue carbon ecosystem restoration (mangroves, seagrass, etc.) in India.

## Key goals:
- Immutable on-chain storage of verified restoration data proofs
- Human-in-the-loop verification (validators + NCCR Admin approval)
- Gated minting of tokenized carbon credits
- Role-based control, especially NCCR Admin oversight

## Core contracts:
- **SubmissionRegistry** — Stores immutable submission hashes + metadata
- **VerificationRegistry** — Logs validator decisions (approve / correction / reject)
- **CarbonCreditToken** — ERC-20 style carbon credits with admin-only minting


## Project Structure (recommended)
```
bluecarbon-mry-contracts/
├── src/
│   ├── core/
│   │   ├── CarbonCreditToken.sol
│   │   ├── SubmissionRegistry.sol
│   │   └── VerificationRegistry.sol
│   └── interfaces/
│       ├── ICarbonCreditToken.sol
│       ├── ISubmissionRegistry.sol
│       └── IVerificationRegistry.sol
├── test/
```

## License
MIT

## Acknowledgments
Designed to support transparent, verifiable blue carbon restoration in India's climate strategy.  
Inspired by the need for decentralized MRV systems that onboard NGOs, communities, and coastal panchayats.
