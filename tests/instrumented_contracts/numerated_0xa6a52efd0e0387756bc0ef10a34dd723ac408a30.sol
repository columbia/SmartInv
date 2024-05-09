1 pragma solidity ^0.4.23;
2 
3 contract Pgp {
4   mapping(address => string) public addressToPublicKey;
5 
6   function addPublicKey(string publicKey) external {
7     addressToPublicKey[msg.sender] = publicKey;
8   }
9 }