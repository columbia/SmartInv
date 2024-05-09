1 pragma solidity ^0.4.8;
2 
3 contract antonCoin {
4     
5     uint public decimals = 18;
6     uint public totalSupply = 1000000;
7     string public name = 'AntonCoin';
8     string public symbol = 'TONKA';
9 
10     function antonCoin() {
11         balances[msg.sender] = 1000000;
12     }
13 
14     function transfer(address _to, uint256 _value) returns (bool success) {
15         //Default assumes totalSupply can't be over max (2^256 - 1).
16         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
17         //Replace the if with this one instead.
18         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
19         if (balances[msg.sender] >= _value && _value > 0) {
20             balances[msg.sender] -= _value;
21             balances[_to] += _value;
22             return true;
23         } else { return false; }
24     }
25 
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
27         //same as above. Replace this line with the following if you want to protect against wrapping uints.
28         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
29         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30             balances[_to] += _value;
31             balances[_from] -= _value;
32             allowed[_from][msg.sender] -= _value;
33             return true;
34         } else { return false; }
35     }
36 
37     function balanceOf(address _owner) constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41     function approve(address _spender, uint256 _value) returns (bool success) {
42         allowed[msg.sender][_spender] = _value;
43 
44         return true;
45     }
46 
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
48         return allowed[_owner][_spender];
49     }
50 
51     mapping (address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53 }