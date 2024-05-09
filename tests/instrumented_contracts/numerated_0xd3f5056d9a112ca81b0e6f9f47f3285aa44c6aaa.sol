1 /**
2 *MOVIECREDITS: "P2P PAYMENT SYSTEM FOR THE MOVIE INDUSTRY.."
3  * CONTRACT CREATOR: MOVIECREDITS/TEAM &  CRYPTO7.BIZ
4  * The MOVIECREDITS (EMVC) token contract complies with the ERC20 standard
5 ** (see https://github.com/ethereum/EIPs/issues/20).
6  *CENSORSHIP PROTECTION=TRUE| DECIMALS=2
7  * SUPPLY = 60000000= 60 M  (EMVC) BUY: RATE= 750 EMVC/ETH
8  * */
9 pragma solidity ^0.4.8;
10 contract SafeMath{
11   function safeMul(uint a, uint b) internal returns (uint) {
12     uint c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function safeDiv(uint a, uint b) internal returns (uint) {
18     assert(b > 0);
19     uint c = a / b;
20     assert(a == b * c + a % b);
21     return c;
22   }
23 	
24 	function safeSub(uint a, uint b) internal returns (uint) {
25     	assert(b <= a);
26     	return a - b;
27   }
28 
29 	function safeAdd(uint a, uint b) internal returns (uint) {
30     	uint c = a + b;
31     	assert(c >= a);
32     	return c;
33   }
34 	function assert(bool assertion) internal {
35 	    if (!assertion) {
36 	      return;
37 
38 	    }
39 	}
40 }
41 
42        
43 
44 contract ERC20Moviecredits{
45 
46  	function totalSupply() constant returns (uint256 totalSupply) {}
47 	function balanceOf(address _owner) constant returns (uint256 balance) {}
48 
49 	function transferFrom(address _from, address _recipient, uint256 _value) returns (bool success) {}
50 	function approve(address _spender, uint256 _value) returns (bool success) {}
51 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
52 
53 	event Transfer(address indexed _from, address indexed _recipient, uint256 _value);
54 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56 
57 }
58 
59 contract MOVIECREDITS is ERC20Moviecredits, SafeMath{
60 
61 	
62 	mapping(address => uint256) balances;
63 
64 	uint256 public totalSupply;
65 
66 
67 	function balanceOf(address _owner) constant returns (uint256 balance) {
68 	    return balances[_owner];
69 	}
70 
71    //** * @dev Fix for the ERC20 short address attack. */
72  modifier onlyPayloadSize(uint size) { if(msg.data.length < size + 4) { throw; } _; } 
73 
74  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) { 
75  balances[msg.sender] = safeSub(balances[msg.sender], _value);
76 	    balances[_to] = safeAdd(balances[_to], _value);
77 	    Transfer(msg.sender,_to,_value); }
78 
79 
80 	mapping (address => mapping (address => uint256)) allowed;
81 
82 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
83 	    var _allowance = allowed[_from][msg.sender];
84 	    
85 	    balances[_to] = safeAdd(balances[_to], _value);
86 	    balances[_from] = safeSub(balances[_from], _value);
87 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
88 	    Transfer(_from, _to, _value);
89 	    return true;
90 	}
91 
92 	function approve(address _spender, uint256 _value) returns (bool success) {
93 	    allowed[msg.sender][_spender] = _value;
94 	    Approval(msg.sender, _spender, _value);
95 	    return true;
96 	}
97 
98 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99 	    return allowed[_owner][_spender];
100 	}
101 
102 
103 
104 
105 	uint256 public endTime;
106 
107 	modifier during_offering_time(){
108 		if (now >= endTime){
109 			return;
110 
111 		}else{
112 			_;
113 		}
114 	}
115 
116 	function () payable during_offering_time {
117 		createTokens(msg.sender);
118 	}
119 
120 	function createTokens(address recipient) payable {
121 		if (msg.value == 0) {
122 		 return;
123 
124 		}
125 
126 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
127 		totalSupply = safeSub(totalSupply, tokens);
128 
129 		balances[recipient] = safeAdd(balances[recipient], tokens);
130 
131 		if (!owner.send(msg.value)) {
132 		return;
133 		}
134 	}
135 	string 	public name = "MOVIECREDITS (EMVC)";
136 	string 	public symbol = "EMVC";
137 	uint 	public decimals = 2;
138 	uint256 public INITIAL_SUPPLY = 6000000000;
139     
140 	uint256 public price;
141 	address public owner;
142 
143 	function MOVIECREDITS() {
144 		totalSupply = INITIAL_SUPPLY;
145 balances[msg.sender] = INITIAL_SUPPLY;  // Give all of the initial tokens to the contract deployer.
146 		endTime = now + 5 weeks;
147 		owner 	= msg.sender;
148 		price 	= 75000;
149 	}
150 }