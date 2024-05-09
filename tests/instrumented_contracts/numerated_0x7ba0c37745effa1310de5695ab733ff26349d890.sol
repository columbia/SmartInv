1 pragma solidity ^0.4.8;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) constant returns (uint256);
30   function transfer(address to, uint256 value) returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) constant returns (uint256);
36   function transferFrom(address from, address to, uint256 value) returns (bool);
37   function approve(address spender, uint256 value) returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract QuantumXICO is ERC20, SafeMath {
42 	mapping(address => uint256) balances;
43 	uint256 public totalSupply;
44 
45 	function balanceOf(address _owner) constant returns (uint256 balance) {
46 	    return balances[_owner];
47 	}
48 
49 	function transfer(address _to, uint256 _value) returns (bool success) {
50 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
51 	    balances[_to] = safeAdd(balances[_to], _value);
52 	    Transfer(msg.sender, _to, _value);
53 	    return true;
54 	}
55 
56 	mapping (address => mapping (address => uint256)) allowed;
57 
58 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
59 	    var _allowance = allowed[_from][msg.sender];
60 	    balances[_to] = safeAdd(balances[_to], _value);
61 	    balances[_from] = safeSub(balances[_from], _value);
62 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
63 	    Transfer(_from, _to, _value);
64 	    return true;
65 	}
66 
67 	function approve(address _spender, uint256 _value) returns (bool success) {
68 	    allowed[msg.sender][_spender] = _value;
69 	    Approval(msg.sender, _spender, _value);
70 	    return true;
71 	}
72 
73 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74 	    return allowed[_owner][_spender];
75 	}
76 
77 	uint256 public endTime;
78 
79 	modifier during_offering_time(){
80 		if (now >= endTime) {
81 			throw;
82 		}else {
83 			_;
84 		}
85 	}
86 
87 	function () payable during_offering_time {
88 		createTokens(msg.sender);
89 	}
90 
91 	function createTokens(address recipient) payable {
92 		if (msg.value == 0) {
93 		  throw;
94 		}
95 		uint tokens = safeDiv(safeMul(msg.value, price), 1 ether);
96 		totalSupply = safeAdd(totalSupply, tokens);
97 		balances[recipient] = safeAdd(balances[recipient], tokens);
98 		if (!owner.send(msg.value)) {
99 		  throw;
100 		}
101 	}
102 
103 	string 	public name = "QuantumXCoin";
104 	string 	public symbol = "QTMX";
105 	uint 	public decimals = 0;
106 	uint256 public INITIAL_SUPPLY = 1000000;
107 	uint256 public price;
108 	address public owner;
109 
110 	function QuantumXICO() {
111 		totalSupply = INITIAL_SUPPLY;
112 		// Give all of the initial tokens to the contract deployer.
113 		balances[msg.sender] = INITIAL_SUPPLY;
114 		endTime = now + 1 weeks;
115 		owner = msg.sender;
116 		price = 100;
117 	}
118 
119 }