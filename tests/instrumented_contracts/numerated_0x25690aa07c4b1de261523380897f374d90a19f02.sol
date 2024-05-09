1 pragma solidity ^0.4.0;
2 
3 contract GBank {
4 
5     address creator;
6 
7     mapping (address => uint) balances;
8 
9     function GBank(uint startAmount) {
10         balances[msg.sender] = startAmount;
11         creator = msg.sender;
12     }
13 
14     function getBalance(address a) constant returns (uint) {
15         return balances[a];
16     }
17 
18     function transfer(address to, uint amount) {
19 
20         // Don't allow sending to self
21         if (msg.sender == to) {
22             throw;
23         }
24 
25         // Check if sender has sufficient balance to send
26         if (amount > balances[msg.sender]) {
27             throw;
28         }
29 
30         balances[msg.sender] -= amount;
31         balances[to] += amount;
32     }
33 }