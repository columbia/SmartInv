1 pragma solidity ^0.4.13;
2 
3 contract jvCoin {
4     mapping (address => uint) balances;
5 
6     function jvCoin() { 
7         balances[msg.sender] = 10000;
8     }
9 
10     function sendCoin(address receiver, uint amount) returns (bool sufficient) {
11         if (balances[msg.sender] < amount) return false;
12 
13         balances[msg.sender] -= amount;
14         balances[receiver] += amount;
15         return true;
16     }
17 }