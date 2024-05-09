1 pragma solidity ^0.4.19;
2 
3 contract DEMS {
4     event SendMessage(bytes iv, bytes epk, bytes ct, bytes mac, address sender);
5     
6     function sendMessage(bytes iv, bytes epk, bytes ct, bytes mac) external {
7         SendMessage(iv, epk, ct, mac, msg.sender);
8     }
9 }