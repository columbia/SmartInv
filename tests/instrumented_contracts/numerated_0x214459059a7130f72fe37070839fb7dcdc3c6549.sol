1 pragma solidity ^0.5.1;
2 
3 contract ProofOfAddress {
4     mapping (address=>string) public proofs;
5 
6     function register(string memory kinAddress) public{
7         proofs[msg.sender] = kinAddress;
8     }
9 }