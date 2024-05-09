1 pragma solidity ^0.4.2;
2 contract Token {
3     address public issuer;
4     mapping (address => uint) public balances;
5 
6     function Token() {
7         issuer = msg.sender;
8         balances[issuer] = 1000000;
9     }
10 
11     function transfer(address _to, uint _amount) {
12         if (balances[msg.sender] < _amount) {
13             throw;
14         }
15 
16         balances[msg.sender] -= _amount;
17         balances[_to] += _amount;
18     }
19 }