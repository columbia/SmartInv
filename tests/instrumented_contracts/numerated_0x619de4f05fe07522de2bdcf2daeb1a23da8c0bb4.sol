1 pragma solidity ^0.4.19;
2 
3 contract SafeMath{
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 	
17 	function safeSub(uint a, uint b) internal returns (uint) {
18     	assert(b <= a);
19     	return a - b;
20   }
21 
22 	function safeAdd(uint a, uint b) internal returns (uint) {
23     	uint c = a + b;
24     	assert(c >= a);
25     	return c;
26   }
27 	function assert(bool assertion) internal {
28 	    if (!assertion) {
29 	      throw;
30 	    }
31 	}
32 }
33 
34 
35 contract ERC20{
36 
37  	function totalSupply() constant returns (uint256 totalSupply) {}
38 	function balanceOf(address _owner) constant returns (uint256 balance) {}
39 	function transfer(address _recipient, uint256 _value) returns (bool success) {}
40 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
41 	function approve(address _spender, uint256 _value) returns (bool success) {}
42 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
43 
44 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
45 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47 
48 }
49 
50 contract Xtremcoin is ERC20, SafeMath{
51 
52 	
53 	mapping(address => uint256) balances;
54 
55 	string 	public name = "Xtremcoin";
56 	string 	public symbol = "XTR";
57 	uint 	public decimals = 8;
58 	uint256 public CIR_SUPPLY;
59 	uint256 public totalSupply;
60 	uint256 public price;
61 	address public owner;
62 	uint256 public endTime;
63 	uint256 public startTime;
64 
65 	function Xtremcoin(uint256 _initial_supply, uint256 _price, uint256 _cir_supply) {
66 		totalSupply = _initial_supply;
67 		balances[msg.sender] = _initial_supply;  // Give all of the initial tokens to the contract deployer.
68 		CIR_SUPPLY = _cir_supply;
69 		endTime = now + 17 weeks;
70 		startTime = now + 15 days;
71 		owner 	= msg.sender;
72 		price 	= _price;
73 	}
74 
75 	function balanceOf(address _owner) constant returns (uint256 balance) {
76 	    return balances[_owner];
77 	}
78     
79 	function transfer(address _to, uint256 _value) returns (bool success){
80 	    require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
81         require (balances[msg.sender] > _value);                // Check if the sender has enough
82         require (safeAdd(balances[_to], _value) > balances[_to]); // Check for overflows
83 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
84 	    balances[_to] = safeAdd(balances[_to], _value);
85 	    Transfer(msg.sender, _to, _value);
86 	    return true;
87 	}
88 
89 	mapping (address => mapping (address => uint256)) allowed;
90 
91 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
92 	    var _allowance = allowed[_from][msg.sender];
93 	    require (_value < _allowance);
94 	    
95 	    require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
96         require (balances[msg.sender] > _value);                // Check if the sender has enough
97         require (safeAdd(balances[_to], _value) > balances[_to]); // Check for overflows
98 	    balances[_to] = safeAdd(balances[_to], _value);
99 	    balances[_from] = safeSub(balances[_from], _value);
100 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
101 	    Transfer(_from, _to, _value);
102 	    return true;
103 	}
104 
105 	function approve(address _spender, uint256 _value) returns (bool success) {
106 	    allowed[msg.sender][_spender] = _value;
107 	    Approval(msg.sender, _spender, _value);
108 	    return true;
109 	}
110 
111 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
112 	    return allowed[_owner][_spender];
113 	}
114 
115 
116 	modifier during_offering_time(){
117 		if (now < startTime || now >= endTime){
118 			throw;
119 		}else{
120 			_;
121 		}
122 	}
123 
124 	function () payable during_offering_time {
125 		createTokens(msg.sender);
126 	}
127 
128 	function createTokens(address recipient) payable {
129 		if (msg.value == 0) {
130 		  throw;
131 		}
132 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
133         if(safeSub(balances[owner],tokens)>safeSub(totalSupply, CIR_SUPPLY)){
134             balances[owner] = safeSub(balances[owner], tokens);
135 		    balances[recipient] = safeAdd(balances[recipient], tokens);   
136         }else{
137             throw;
138         }
139 
140 		if (!owner.send(msg.value)) {
141 		  throw;
142 		}
143 	}
144 
145 }