# test_deploy.sh
echo "Testing smart contract deployment..."

source .env
forge script script/DeploymentScript.sol:DeploymentScript --rpc-url "$GOERLI_RPC_URL"
