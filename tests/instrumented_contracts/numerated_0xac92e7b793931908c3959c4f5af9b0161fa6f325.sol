1 pragma solidity ^0.5.0;
2 
3 contract Pgp {
4   mapping(address => string) public addressToPublicKey;
5 
6   function addPublicKey(string calldata publicKey) external {
7     addressToPublicKey[msg.sender] = publicKey;
8   }
9   
10   function revokePublicKey() external {
11       delete addressToPublicKey[msg.sender];
12   }
13 }