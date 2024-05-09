1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5 function totalSupply() constant returns (uint256 supply) {}
6 
7 
8 function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10 
11 function transfer(address _to, uint256 _value) returns (bool success) {}
12 
13 
14 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
15 
16 
17 function approve(address _spender, uint256 _value) returns (bool success) {}
18 
19 
20 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
21 
22 event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25 }
26 
27 contract StandardToken is Token {
28 
29 function transfer(address _to, uint256 _value) returns (bool success) {
30 
31 if (balances[msg.sender] >= _value && _value > 0) {
32 balances[msg.sender] -= _value;
33 balances[_to] += _value;
34 Transfer(msg.sender, _to, _value);
35 return true;
36 } else { return false; }
37 }
38 
39 function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40 
41 if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
42 balances[_to] += _value;
43 balances[_from] -= _value;
44 allowed[_from][msg.sender] -= _value;
45 Transfer(_from, _to, _value);
46 return true;
47 } else { return false; }
48 }
49 
50 function balanceOf(address _owner) constant returns (uint256 balance) {
51 return balances[_owner];
52 }
53 
54 function approve(address _spender, uint256 _value) returns (bool success) {
55 allowed[msg.sender][_spender] = _value;
56 Approval(msg.sender, _spender, _value);
57 return true;
58 }
59 
60 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61 return allowed[_owner][_spender];
62 }
63 
64 mapping (address => uint256) balances;
65 mapping (address => mapping (address => uint256)) allowed;
66 uint256 public totalSupply;
67 }
68 
69 
70 contract ERC20Token is StandardToken {
71 
72 function () {
73 
74 throw;
75 }
76 
77 
78 
79 
80 string public name; 
81 uint8 public decimals; 
82 string public symbol; 
83 string public version = "H1.0"; 
84 
85 
86 
87 
88 function ERC20Token(
89 ) {
90 balances[msg.sender] = 8000000000000000; 
91 totalSupply = 8000000000000000; 
92 name = "Neo Cash"; 
93 decimals = 8; 
94 symbol = "NEOC"; 
95 }
96 
97 function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
98 allowed[msg.sender][_spender] = _value;
99 Approval(msg.sender, _spender, _value);
100 
101 
102 if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
103 return true;
104 }
105 }