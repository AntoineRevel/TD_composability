# deploy_and_verify.sh
clear
echo "Deploying and verifying smart contract..."

forge script script/DeploymentScript.sol:DeploymentScript --rpc-url "$GOERLI_RPC_URL" --broadcast --verify
