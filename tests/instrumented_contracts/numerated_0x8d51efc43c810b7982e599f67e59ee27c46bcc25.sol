1 pragma solidity ^0.4.11;
2 
3 contract FitToken {
4 string public symbol;
5 string public name;
6 uint256 public decimals;
7 uint256 _totalSupply;
8 
9 address public owner;
10 
11 mapping(address => uint256) balances;
12 
13 mapping(address => mapping (address => uint256)) allowed;
14 
15 modifier onlyOwner() {
16 if (msg.sender != owner) {
17 revert();
18 }
19 _;
20 }
21 
22 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 event Transfer(address indexed _from, address indexed _to, uint256 _value);
24 
25 
26 function FitToken() {
27 owner = msg.sender;
28 decimals = 18;
29 _totalSupply = 400000000 * (10**decimals);
30 balances[owner] = _totalSupply;
31 symbol = "FIT";
32 name = "FIT TOKEN";
33 }
34 
35 
36 function totalSupply() public constant returns (uint256 totalSupply) {
37 totalSupply = _totalSupply;
38 }
39 
40 
41 function balanceOf(address _owner) public constant returns (uint256 balance) {
42 return balances[_owner];
43 }
44 
45 
46 function transfer(address _to, uint256 _amount) public returns (bool success) {
47 if (balances[msg.sender] >= _amount 
48 && _amount > 0
49 && balances[_to] + _amount > balances[_to]) {
50 balances[msg.sender] -= _amount;
51 balances[_to] += _amount;
52 Transfer(msg.sender, _to, _amount);
53 return true;
54 } else {
55 return false;
56 }
57 }
58 
59 
60 function transferFrom (
61 address _from,
62 address _to,
63 uint256 _amount
64 ) public returns (bool success) {
65 if (balances[_from] >= _amount
66 && allowed[_from][msg.sender] >= _amount
67 && _amount > 0
68 && balances[_to] + _amount > balances[_to]) {
69 balances[_from] -= _amount;
70 allowed[_from][msg.sender] -= _amount;
71 balances[_to] += _amount;
72 Transfer(_from, _to, _amount);
73 return true;
74 } else {
75 return false;
76 }
77 }
78 
79 
80 function approve(address _spender, uint256 _amount) public returns (bool success) {
81 allowed[msg.sender][_spender] = _amount;
82 Approval(msg.sender, _spender, _amount);
83 return true;
84 }
85 
86 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
87 return allowed[_owner][_spender];
88 }
89 }