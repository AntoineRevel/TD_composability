# test_deploy.sh
clear
echo "Testing smart contract deployment..."

forge script script/DeploymentScript.sol:DeploymentScript --rpc-url "$GOERLI_RPC_URL"
