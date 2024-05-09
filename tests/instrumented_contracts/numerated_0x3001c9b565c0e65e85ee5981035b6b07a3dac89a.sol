1 pragma solidity ^0.4.13;
2 
3 contract proverka6 {
4 
5 	string public symbol = "PRV6";
6 	string public name = "proverka6";
7 	uint8 public constant decimals = 12;
8 	uint256 public totalSupply = 1000000000000;
9 
10 	address owner;
11 
12 	mapping (address => uint256) public balances;
13 	mapping (address => mapping (address => uint)) public allowed;
14 
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Approval(address indexed _owner, address indexed _spender, uint _value);
17  
18 	function proverka6() {
19 		owner = msg.sender;
20 		balances[owner] = totalSupply;
21 	}
22     
23 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24 		assert(b <= a);
25 		return a - b;
26 	}
27 
28 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
29 		uint256 c = a + b;
30 		assert(c >= a);
31 		return c;
32 	}
33 
34 	function balanceOf(address _owner) constant returns (uint256 balance) {
35 		return balances[_owner];
36 	}	
37 
38 	function transfer(address _to, uint256 _value) returns (bool) {
39 		require (_to != 0x0);
40 		balances[msg.sender] = sub(balances[msg.sender], _value);
41 		balances[_to] = add(balances[_to], _value);
42 		Transfer(msg.sender, _to, _value);
43 		return true;
44 	}
45 
46 	function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
47 		require (_to != 0x0);
48 		require (_value < allowed[_from][msg.sender]);  
49 		balances[_to] = add(balances[_to], _value);
50 		balances[_from] = sub(balances[_from], _value);
51 		sub(allowed[_from][msg.sender], _value);
52 		Transfer(_from, _to, _value);
53 		return true;
54 	}
55 
56 	function approve(address _spender, uint _value) returns (bool success) {
57 		allowed[msg.sender][_spender] = _value;
58 		Approval(msg.sender, _spender, _value);
59 		return true;
60 	}
61 
62 	function allowance(address _owner, address _spender) constant returns (uint remaining) {
63 		return allowed[_owner][_spender];
64 	}
65 
66 }