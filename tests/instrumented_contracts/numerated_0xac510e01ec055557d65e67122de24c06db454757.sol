1 pragma solidity ^0.4.19;
2 
3 contract owned{
4 	address public owner;
5 
6 function owned() public {
7 	owner = msg.sender;
8 }
9 
10 modifier onlyOwner{
11 	require(msg.sender == owner);
12 _;
13 }
14 
15 function transferOwnership(address newOwner) onlyOwner public {
16 	owner = newOwner;
17 }
18 }
19 
20 //declare basic Events for Token Base
21 contract Token{
22 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
23 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 event Burn(address indexed _from, uint256 _amount);
25 }
26 
27 contract StandardToken is Token{
28 
29 	function transfer(address _to, uint256 _value) public returns(bool success) {
30 	if (balances[msg.sender] >= _value && _value > 0) {
31 		balances[msg.sender] -= _value;
32 		balances[_to] += _value;
33 		Transfer(msg.sender, _to, _value);
34 		return true;
35 	}
36 	else {
37 		return false;
38 	}
39 }
40 
41 function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
42 	if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43 		balances[_to] += _value;
44 		balances[_from] -= _value;
45 		allowed[_from][msg.sender] -= _value;
46 		Transfer(_from, _to, _value);
47 		return true;
48 	}
49 	else {
50 		return false;
51 	}
52 }
53 
54 function balanceOf(address _owner) constant public returns(uint256 amount) {
55 	return balances[_owner];
56 }
57 
58 function approve(address _spender, uint256 _value) public returns(bool success) {
59 	allowed[msg.sender][_spender] = _value;
60 	Approval(msg.sender, _spender, _value);
61 	return true;
62 }
63 
64 function burn(uint256 _amount) public returns(bool success) {
65 	require(balances[msg.sender] >= _amount);
66 	balances[msg.sender] -= _amount;
67 	totalSupply -= _amount;
68 	Burn(msg.sender, _amount);
69 	return true;
70 }
71 
72 function burnFrom(address from, uint256 _amount) public returns(bool success)
73 {
74 	require(balances[from] >= _amount);
75 	require(_amount <= allowed[from][msg.sender]);
76 	balances[from] -= _amount;
77 	allowed[from][msg.sender] -= _amount;
78 	totalSupply -= _amount;
79 	Burn(from, _amount);
80 	return true;
81 }
82 
83 function allowance(address _owner, address _spender) constant public returns(uint256 remaining) {
84 	return allowed[_owner][_spender];
85 }
86 
87 mapping(address => uint256) balances;
88 mapping(address => mapping(address => uint256)) allowed;
89 uint256 public totalSupply;
90 uint256 public availableSupply;
91 uint256 public releasedSupply;
92 }
93 
94 
95 /////////////////////////////////////////////
96 //Advanced Token functions - advanced layer//
97 /////////////////////////////////////////////
98 contract AuraToken is StandardToken, owned{
99 	function() public payable{
100 	if (msg.sender != owner)
101 	giveTokens(msg.sender,msg.value);
102 }
103 
104 
105 string public name;
106 uint8 public decimals;
107 string public symbol;
108 uint256 public buyPrice;  //in wei
109 
110 
111 						  //make sure this constructor name matches contract name above
112 function AuraToken() public{
113 	decimals = 18;                            // Amount of decimals for display purposes
114 	totalSupply = 50000000 * 10 ** uint256(decimals);  // Update total supply 
115 	releasedSupply = 0;
116 	availableSupply = 0;
117 	name = "AuraToken";                                   // Set the name for display purposes
118 	symbol = "AURA";                               // Set the symbol for display purposes
119 	buyPrice = 1 * 10 ** 18;			//set unreal price for the beginning to prevent attacks (in wei)
120 }
121 
122 function giveTokens(address _payer, uint256 _payment) internal returns(bool success) {
123 	require(_payment > 0);
124 	uint256 tokens = (_payment / buyPrice) * (10 ** uint256(decimals));
125 	if (availableSupply < tokens)tokens = availableSupply;
126 	require(availableSupply >= tokens);
127 	require((balances[_payer] + tokens) > balances[_payer]); //overflow test
128 	balances[_payer] += tokens;
129 	availableSupply -= tokens;
130 	return true;
131 }
132 
133 function giveReward(address _to, uint256 _amount) public onlyOwner returns(bool success) {
134 	require(_amount > 0);
135 	require(_to != 0x0); // burn instead
136 	require(availableSupply >= _amount);
137 	require((balances[_to] + _amount) > balances[_to]);
138 	balances[_to] += _amount;
139 	availableSupply -= _amount;
140 	return true;
141 }
142 
143 function setPrice(uint256 _newPrice) public onlyOwner returns(bool success) {
144 	buyPrice = _newPrice;
145 	return true;
146 }
147 
148 function release(uint256 _amount) public onlyOwner returns(bool success) {
149 	require((releasedSupply + _amount) <= totalSupply);
150 	releasedSupply += _amount;
151 	availableSupply += _amount;
152 	return true;
153 }
154 
155 function withdraw(uint256 _amount) public onlyOwner returns(bool success) {
156 	msg.sender.transfer(_amount);
157 	return true;
158 }
159 }
160 
161 //EOF