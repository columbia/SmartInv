1 pragma solidity ^0.4.24;
2 
3 contract RecoverEosKey {
4     
5     mapping (address => string) public keys;
6     
7     event LogRegister (address user, string key);
8     
9     function register(string key) public {
10         assert(bytes(key).length <= 64);
11         keys[msg.sender] = key;
12         emit LogRegister(msg.sender, key);
13     }
14 }