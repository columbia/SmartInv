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
27     function assert(bool assertion) internal {
28     if (!assertion) assert;
29   }
30 }
31 
32 
33 contract ERC20{
34 
35  	function totalSupply() constant returns (uint256 totalSupply) {}
36 	function balanceOf(address _owner) constant returns (uint256 balance) {}
37 	function transfer(address _recipient, uint256 _value) returns (bool success) {}
38 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
39 	function approve(address _spender, uint256 _value) returns (bool success) {}
40 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
43 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45 
46 }
47 
48 contract Foodtoken is ERC20, SafeMath{
49 	
50 	mapping(address => uint256) balances;
51 
52 	uint256 public totalSupply;
53 
54 
55 	function balanceOf(address _owner) constant public returns (uint256 balance) {
56 	    return balances[_owner];
57 	}
58 
59 	function transfer(address _to, uint256 _value) public returns (bool success){
60 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
61 	    balances[_to] = safeAdd(balances[_to], _value);
62 	    Transfer(msg.sender, _to, _value);
63 	    return true;
64 	}
65 
66 	mapping (address => mapping (address => uint256)) allowed;
67 
68 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
69 	    var _allowance = allowed[_from][msg.sender];
70 	    
71 	    balances[_to] = safeAdd(balances[_to], _value);
72 	    balances[_from] = safeSub(balances[_from], _value);
73 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
74 	    Transfer(_from, _to, _value);
75 	    return true;
76 	}
77 
78 	function approve(address _spender, uint256 _value) public returns (bool success) {
79 	    allowed[msg.sender][_spender] = _value;
80 	    Approval(msg.sender, _spender, _value);
81 	    return true;
82 	}
83 
84 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
85 	    return allowed[_owner][_spender];
86 
87 		}
88 
89 	function () public payable {
90 		createTokens(msg.sender);
91 	}
92 
93 	function createTokens(address recipient) public payable {
94 		if (msg.value == 0) {
95 		  assert;
96 		}
97 
98 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
99 		totalSupply = safeAdd(totalSupply, tokens);
100 
101 		balances[recipient] = safeAdd(balances[recipient], tokens);
102 
103 		if (!owner.send(msg.value)) {
104 		  assert;
105 		}
106 
107 	}
108 	string 	public name = "Food token";
109 	string 	public symbol = "FOOD";
110 	uint 	public decimals = 0;
111 	uint 	public INITIAL_SUPPLY = 0;
112 	uint256 public price;
113 	address public owner;
114 
115 	function Foodtoken() public {
116 	  totalSupply = INITIAL_SUPPLY;
117 	  balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
118 		owner 	= msg.sender;
119 		price 	= 3200;
120 
121 	}
122 }