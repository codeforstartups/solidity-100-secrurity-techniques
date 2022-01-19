# ridox-contract
 
# create smart structure
brownie init

# test contract
brownie test

# compile smart contract
brownie compile

# deploy locally
brownie run scripts/deploy.py
brownie run scripts/1_deploy_token.py
brownie run scripts/helpful_scripts.py

# deploy on rinkeby network
brownie run scripts/1_deploy_token.py --network rinkeby

# single-function and cross-function reentrancy attack

# 
- 1. update your state variable before making call to another contract
- 2. using a modifier | only one funtion is executed at a time


