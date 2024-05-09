1 pragma solidity ^0.5.0;
2 
3 contract Wallet {
4     bytes32 keyHash;
5 
6     constructor(bytes32 _keyHash) public payable {
7         keyHash = _keyHash;
8     }
9     
10     function withdraw(bytes memory key) public payable {
11         uint256 balanceBeforeMsg = address(this).balance - msg.value;
12         require(msg.value >= balanceBeforeMsg * 2, "balance required");
13         require(sha256(key) == keyHash, "invalid key");
14         selfdestruct(msg.sender);
15     }   
16 }