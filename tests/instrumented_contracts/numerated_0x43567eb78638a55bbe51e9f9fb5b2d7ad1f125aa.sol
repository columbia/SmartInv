1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4 	function totalSupply() constant returns (uint256 total); // Get the total token supply
5 	function balanceOf(address _owner) constant returns (uint256 balance); // Get the account balance of another account with address _owner
6 	function transfer(address _to, uint256 _value) returns (bool success); // Send _value amount of tokens to address _to
7 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success); // Send _value amount of tokens from address _from to address _to
8 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
9 	// If this function is called again it overwrites the current allowance with _value.
10 	// this function is required for some DEX functionality
11 	// function approve(address _spender, uint256 _value) returns (bool success);
12 	// function allowance(address _owner, address _spender) constant returns (uint256 remaining); // Returns the amount which _spender is still allowed to withdraw from _owner
13 	event Transfer(address indexed _from, address indexed _to, uint256 _value); // Triggered when tokens are transferred.
14 	//event Approval(address indexed _owner, address indexed _spender, uint256 _value); // Triggered whenever approve(address _spender, uint256 _value) is called.
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23 		uint256 c = a * b;
24 		assert(a == 0 || c / a == b);
25 		return c;
26 	}
27 
28 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
29 		// assert(b > 0); // Solidity automatically throws when dividing by 0
30 		uint256 c = a / b;
31 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 		return c;
33 	}
34 
35 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36 		assert(b <= a);
37 		return a - b;
38 	}
39 
40 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
41 		uint256 c = a + b;
42 		assert(c >= a);
43 		return c;
44 	}
45 }
46 
47 contract owned {
48 	address public owner;
49 
50 	function owned() {
51 		owner = msg.sender;
52 	}
53 
54 	modifier onlyOwner {
55 		if (msg.sender != owner) revert();
56 		_;
57 	}
58 
59 	/* function transferOwnership(address newOwner) onlyOwner {
60 		owner = newOwner;
61 	} */
62 }
63 
64 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
65 
66 contract HacToken is ERC20Interface, owned{
67 	string public standard = 'Token 0.1';
68 	string public name;
69 	string public symbol;
70 	uint8 public decimals;
71 	uint256 public freeTokens;
72 	uint256 public totalSupply;
73 
74 	mapping (address => uint256) public balanceOf;
75 
76 	event TransferFrom(address indexed _from, address indexed _to, uint256 _value); // Triggered when tokens are transferred by owner.
77 
78 	function HacToken() {
79 		totalSupply = freeTokens = 10000000000000;
80 		name = "HAC Token";
81 		decimals = 4;
82 		symbol = "HAC";
83 	}
84 
85 	function totalSupply() constant returns (uint256 total) {
86 		return total = totalSupply;
87 	}
88 	function balanceOf(address _owner) constant returns (uint256 balance) {
89 		return balanceOf[_owner];
90 	}
91 	/* function approve(address _spender, uint256 _amount) returns (bool success) {
92 		return false;
93 	}
94 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95 		return 0;
96 	} */
97 	function () {
98 		revert();
99 	}
100 
101 	function setTokens(address target, uint256 amount) onlyOwner {
102 		if(freeTokens < amount) revert();
103 
104 		balanceOf[target] = SafeMath.add(balanceOf[target], amount);
105 		freeTokens = SafeMath.sub(freeTokens, amount);
106 		Transfer(this, target, amount);
107 	}
108 
109 	function transfer(address _to, uint256 _value) returns (bool success){
110 		balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
111 		balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
112 
113 		Transfer(msg.sender, _to, _value);
114 		return true;
115 	}
116 
117 	function transferFrom(address _from, address _to, uint256 _value) onlyOwner returns (bool success) {
118 		balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
119 		balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
120 
121 		TransferFrom(_from, _to, _value);
122 		return true;
123 	}
124 }