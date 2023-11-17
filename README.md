# ESILV TD Composability

This repository hosts implementation for the ESILV engineering school's TD Composability project. The work is based on the exercises outlined in [AymericNoel's TD_composability](https://github.com/AymericNoel/TD_composability).

## Contents

- Deployed ERC20 and ERC721 contracts using Solidity.
- Minted tokens and interacted with smart contract functions.
- Implemented Uniswap V3 protocol operations for token swaps and liquidity management.
- Automated contract deployment and testing with Foundry tools.

## Etherscan Verification

Verification of the most recent solution contract deployed on the Goerli test network on Etherscan [here](https://goerli.etherscan.io/address/0x7613F2c18Da470486Dee09160B221E11D506b9B2#code).

## Usage

Before using `test_deploy.sh` and `deploy_and_verify.sh` for testing and verifying contracts, define the following environment variables:
- `GOERLI_RPC_URL`: Goerli testnet RPC URL.
- `GOERLI_PRIVATE_KEY`: Private key for the Goerli testnet.
- `ETHERSCAN_API_KEY`: Etherscan API key for contract verification.
