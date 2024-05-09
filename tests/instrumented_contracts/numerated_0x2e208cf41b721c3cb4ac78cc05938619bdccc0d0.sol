1 pragma solidity ^0.4.18;
2 
3 contract ERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) public view returns (uint);
6   
7   function name() public view returns (string _name);
8   function symbol() public view returns (string _symbol);
9   function decimals() public view returns (uint8 _decimals);
10   function totalSupply() public view returns (uint256 _supply);
11 
12   function transfer(address to, uint value) public returns (bool ok);
13   function transfer(address to, uint value, bytes data) public returns (bool ok);
14   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
15   
16   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
17 }
18 
19 
20 contract ContractReceiver {
21 	function tokenFallback(address _from, uint _value, bytes _data) public pure;
22 }
23 
24 contract SafeMath
25 {
26     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30       }
31     
32 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
33 		assert(b <= a);
34 		return a - b;
35 	}
36 	
37 	function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
38 		uint256 c = a / b;
39 		return c;
40 	}
41 	
42 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
43 		if (a == 0) {
44 			return 0;
45 		}
46 		uint256 c = a * b;
47 		assert(c / a == b);
48 		return c;
49 	}
50 }
51 
52 contract protoLEXToken is ERC223, SafeMath{
53 	mapping(address => uint) balances;
54 	string public name = "proto-Limited Exchange Token";
55 	string public symbol = "pLEX";
56 	uint8 public decimals = 0; // Using a Satoshi as base for our decimals: 0.00000001;
57 	uint256 public totalSupply = 2000000000; // 2,000,000,000 LEX's, not mineable, not mintable;
58 	
59 	address admin;
60 	
61 	modifier onlyAdmin()
62 	{
63 	    require(msg.sender == admin);
64 	    _;
65 	}
66 	
67 	function protoLEXToken() public {
68 		balances[msg.sender] = totalSupply;
69 	}
70 	  
71 	// Function to access name of token .
72 	function name() public view returns (string _name) {
73 		return name;
74 	}
75 	// Function to access symbol of token .
76 	function symbol() public view returns (string _symbol) {
77 		return symbol;
78 	}
79 	// Function to access decimals of token .
80 	function decimals() public view returns (uint8 _decimals) {
81 		return decimals;
82 	}
83 	// Function to access total supply of tokens .
84 	function totalSupply() public view returns (uint256 _totalSupply) {
85 		return totalSupply;
86 	}
87 	  
88 	  
89 	// Function that is called when a user or another contract wants to transfer funds .
90 	function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
91 		if(isContract(_to)) {
92 			if (balanceOf(msg.sender) < _value) revert();
93 			balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
94 			balances[_to] = safeAdd(balanceOf(_to), _value);
95 			assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
96 			Transfer(msg.sender, _to, _value, _data);
97 			return true;
98 		}
99 		else {
100 			return transferToAddress(_to, _value, _data);
101 		}
102 	}
103 	  
104 
105 	// Function that is called when a user or another contract wants to transfer funds .
106 	function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
107 		if(isContract(_to)) {
108 			return transferToContract(_to, _value, _data);
109 		}
110 		else {
111 			return transferToAddress(_to, _value, _data);
112 		}
113 	}
114 	  
115 	// Standard function transfer similar to ERC20 transfer with no _data .
116 	// Added due to backwards compatibility reasons .
117 	function transfer(address _to, uint _value) public returns (bool success) {
118 		//standard function transfer similar to ERC20 transfer with no _data
119 		//added due to backwards compatibility reasons
120 		bytes memory empty;
121 		if(isContract(_to)) {
122 			return transferToContract(_to, _value, empty);
123 		}
124 		else {
125 			return transferToAddress(_to, _value, empty);
126 		}
127 	}
128 
129 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
130 	function isContract(address _addr) private view returns (bool is_contract) {
131 		uint length;
132 		assembly {
133 			//retrieve the size of the code on target address, this needs assembly
134 			length := extcodesize(_addr)
135 		}
136 		return (length>0);
137 	}
138 
139 	//function that is called when transaction target is an address
140 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
141 		if (balanceOf(msg.sender) < _value) revert();
142 		balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
143 		balances[_to] = safeAdd(balanceOf(_to), _value);
144 		Transfer(msg.sender, _to, _value, _data);
145 		return true;
146 	}
147 	  
148 	  //function that is called when transaction target is a contract
149 	function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
150 		if (balanceOf(msg.sender) < _value) revert();
151 		balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
152 		balances[_to] = safeAdd(balanceOf(_to), _value);
153 		ContractReceiver receiver = ContractReceiver(_to);
154 		receiver.tokenFallback(msg.sender, _value, _data);
155 		Transfer(msg.sender, _to, _value, _data);
156 		return true;
157 	}
158 		
159 	function balanceOf(address _owner) public view returns (uint balance) {
160 		return balances[_owner];
161 	}
162 	
163 	/*
164 	* Prototype functions for the full LEX Token
165 	*/
166 	
167 	function AddToWhitelist(address addressToWhitelist) public onlyAdmin
168 	{
169 	}
170 	
171 	function RegisterContract() public
172 	{
173 	}
174 	
175 	function RecallTokensFromContract() public onlyAdmin
176 	{
177 	}
178 	
179 	function supplyAvailable() public view returns (uint supply) {
180 		return 0;
181 	}
182 	function supplyInCirculation() public view returns (uint inCirculation) {
183 		return 0;
184 	}
185 	
186 }