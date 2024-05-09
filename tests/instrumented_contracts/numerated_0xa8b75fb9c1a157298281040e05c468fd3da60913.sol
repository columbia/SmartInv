1 pragma solidity ^0.4.8;
2 
3 contract antonCoin {
4     
5     uint public decimals = 0;
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
22             Transfer(msg.sender, _to, _value);
23             return true;
24         } else { return false; }
25     }
26 
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
28         //same as above. Replace this line with the following if you want to protect against wrapping uints.
29         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
30         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31             balances[_to] += _value;
32             balances[_from] -= _value;
33             allowed[_from][msg.sender] -= _value;
34             Transfer(_from, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function balanceOf(address _owner) constant returns (uint256 balance) {
40         return balances[_owner];
41     }
42 
43     function approve(address _spender, uint256 _value) returns (bool success) {
44         allowed[msg.sender][_spender] = _value;
45         return true;
46     }
47 
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
49         return allowed[_owner][_spender];
50     }
51 
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     mapping (address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55 }