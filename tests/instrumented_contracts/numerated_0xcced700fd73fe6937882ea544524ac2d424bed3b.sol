1 pragma solidity ^0.4.23;
2 
3 contract Token {
4 
5 	mapping(address => uint) balances;
6 	mapping (address => mapping (address => uint256)) allowed;
7 	uint public totalSupply;
8 	
9 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 	
12 	
13 	// ERC20 spec required functions
14 	function totalSupply() constant returns (uint256 supply) {}
15 	
16 	function balanceOf(address _owner) constant returns (uint balance) {
17         return balances[_owner];
18     }
19 	
20 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
21       return allowed[_owner][_spender];
22     }
23 	
24 	function approve(address _spender, uint _value) returns (bool success) {
25         allowed[msg.sender][_spender] = _value;
26         Approval(msg.sender, _spender, _value);
27         return true;
28     }
29 	
30 	function transfer(address _to, uint _value) public returns (bool success) {
31 		if (balances[msg.sender] >= _value
32 		&& _value > 0
33 		&& balances[_to] + _value > balances[_to]) {
34 			balances[msg.sender] -= _value;
35 			balances[_to] += _value;					// add value to receiver's balance
36 			Transfer(msg.sender, _to, _value);
37 			return true;
38 		} else {
39 			return false;
40 		}
41 	}
42 	
43 	function transferFrom(address _to, address _from, uint _value) returns (bool success) {
44 		if (balances[_from] >= _value
45 		&& _value > 0
46 		&& allowed[_from][msg.sender] >= _value) {
47 			balances[_to] += _value;
48 			balances[_from] -= _value;
49 			allowed[_from][msg.sender] -= _value;
50 			Transfer(_from, _to, _value);
51 			return true;
52         } else {
53 			return false;
54 		}
55     }
56     
57 }
58 
59 
60 
61 
62 
63 
64 
65 contract jDallyCoin is Token {
66 	
67 	function() {
68 		//if ether is sent to this address, send it back.
69 		throw;
70 	}
71 	
72 	
73 	// declaration of constants
74 	string public name;
75 	string public symbol;
76 	uint8 public decimals;
77 	
78 	
79 	// main constructor for setting token properties/balances
80 	function jDallyCoin(
81 	) {
82 		totalSupply = 2130000000000000000000000;
83 		balances[msg.sender] = 2130000000000000000000000;
84 		name = "jDallyCoin";
85 		decimals = 18;
86 		symbol = "JDC";
87 	}
88 }