1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/claim.sol
4 pragma solidity >=0.5.15;
5 
6 ////// src/claim.sol
7 /* pragma solidity >=0.5.15; */
8 
9 contract TinlakeClaimRAD {
10     mapping (address => bytes32) public accounts;
11     event Claimed(address claimer, bytes32 account);
12 
13     function update(bytes32 account) public {
14         require(account != 0);
15         accounts[msg.sender] = account;
16         emit Claimed(msg.sender, account);
17     }
18 }
