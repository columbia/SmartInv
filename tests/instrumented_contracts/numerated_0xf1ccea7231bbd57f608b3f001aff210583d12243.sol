1 contract SafeMath{
2   function safeMul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function safeDiv(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14 	
15 	function safeSub(uint a, uint b) internal returns (uint) {
16     	assert(b <= a);
17     	return a - b;
18   }
19 
20 	function safeAdd(uint a, uint b) internal returns (uint) {
21     	uint c = a + b;
22     	assert(c >= a);
23     	return c;
24   }
25 	function assert(bool assertion) internal {
26 	    if (!assertion) {
27 	      throw;
28 	    }
29 	}
30 }
31 
32        
33 
34 contract ERC20{
35 
36  	function totalSupply() constant returns (uint256 totalSupply) {}
37 	function balanceOf(address _owner) constant returns (uint256 balance) {}
38 	function transfer(address _recipient, uint256 _value) returns (bool success) {}
39 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
40 	function approve(address _spender, uint256 _value) returns (bool success) {}
41 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
42 
43 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
44 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46 
47 }
48 
49 contract MOVIECREDITS is ERC20, SafeMath{
50 
51 	
52 	mapping(address => uint256) balances;
53 
54 	uint256 public totalSupply;
55 
56 
57 	function balanceOf(address _owner) constant returns (uint256 balance) {
58 	    return balances[_owner];
59 	}
60 
61 	function transfer(address _to, uint256 _value) returns (bool success){
62 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
63 	    balances[_to] = safeAdd(balances[_to], _value);
64 	    Transfer(msg.sender, _to, _value);
65 	    return true;
66 	}
67 
68 	mapping (address => mapping (address => uint256)) allowed;
69 
70 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
71 	    var _allowance = allowed[_from][msg.sender];
72 	    
73 	    balances[_to] = safeAdd(balances[_to], _value);
74 	    balances[_from] = safeSub(balances[_from], _value);
75 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
76 	    Transfer(_from, _to, _value);
77 	    return true;
78 	}
79 
80 	function approve(address _spender, uint256 _value) returns (bool success) {
81 	    allowed[msg.sender][_spender] = _value;
82 	    Approval(msg.sender, _spender, _value);
83 	    return true;
84 	}
85 
86 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87 	    return allowed[_owner][_spender];
88 	}
89 
90 
91 
92 
93 	uint256 public endTime;
94 
95 	modifier during_offering_time(){
96 		if (now >= endTime){
97 			throw;
98 		}else{
99 			_;
100 		}
101 	}
102 
103 	function () payable during_offering_time {
104 		createTokens(msg.sender);
105 	}
106 
107 	function createTokens(address recipient) payable {
108 		if (msg.value == 0) {
109 		  throw;
110 		}
111 
112 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
113 		totalSupply = safeAdd(totalSupply, tokens);
114 
115 		balances[recipient] = safeAdd(balances[recipient], tokens);
116 
117 		if (!owner.send(msg.value)) {
118 		  throw;
119 		}
120 	}
121 	string 	public name = "MOVIECREDITS";
122 	string 	public symbol = "MVC";
123 	uint 	public decimals = 8;
124 	uint256 public INITIAL_SUPPLY = 60000000;
125 
126 	uint256 public price;
127 	address public owner;
128 
129 	function MOVIECREDITS() {
130 		totalSupply = INITIAL_SUPPLY;
131 		balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
132 		endTime = now + 5 weeks;
133 		owner 	= msg.sender;
134 		price 	= 750;
135 	}
136 
137 }