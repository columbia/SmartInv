1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
6 		uint256 c = a + b;
7 		assert(a <= c);
8 		return c;
9 	}
10 
11 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12 		assert(a >= b);
13 		return a - b;
14 	}
15 }
16 
17 
18 contract EthereumStandards {
19 	/* Implements ERC 20 standard */
20 	uint256 public totalSupply;
21 
22 	function balanceOf(address who) public constant returns (uint256);
23 	function allowance(address owner, address spender) public constant returns (uint256);
24 	function transfer(address to, uint256 value) public returns (bool);
25 	function approve(address spender, uint256 value) public returns (bool);
26 	function transferFrom(address from, address to, uint256 value) public returns (bool);
27 
28 	event Transfer(address indexed from, address indexed to, uint256 value);
29 	event Approval(address indexed owner, address indexed spender, uint256 value);
30 
31 	/* Added support for the ERC 223 */
32 	function transfer(address to, uint256 value, bytes data) public returns (bool);
33 	function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);
34 
35 	event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
36 }
37 
38 
39 contract ContractReceiver {
40 	function tokenFallback(address from, uint256 value, bytes data) public;
41 }
42 
43 
44 contract AuctusToken is EthereumStandards {
45 	using SafeMath for uint256;
46 	
47 	string constant public name = "Auctus Token";
48 	string constant public symbol = "AUC";
49 	uint8 constant public decimals = 18;
50 	uint256 public totalSupply;
51 
52 	mapping(address => uint256) public balances;
53 	mapping(address => mapping(address => uint256)) public allowed;
54 
55 	address public contractOwner;
56 	address public tokenSaleContract;
57 	address public preSaleDistributionContract;
58 	bool public tokenSaleIsFinished;
59 
60 	event Burn(address indexed from, uint256 value);
61 
62 	modifier onlyOwner() {
63 		require(contractOwner == msg.sender);
64 		_;
65 	}
66 
67 	function AuctusToken() public {
68 		contractOwner = msg.sender;
69 		tokenSaleContract = address(0);
70 		tokenSaleIsFinished = false;
71 	}
72 
73 	function balanceOf(address who) public constant returns (uint256) {
74 		return balances[who];
75 	}
76 
77 	function allowance(address owner, address spender) public constant returns (uint256) {
78 		return allowed[owner][spender];
79 	}
80 
81 	function approve(address spender, uint256 value) public returns (bool) {
82 		allowed[msg.sender][spender] = value;
83 		emit Approval(msg.sender, spender, value);
84 		return true;
85 	}
86 
87 	function increaseApproval(address spender, uint256 value) public returns (bool) {
88 		allowed[msg.sender][spender] = allowed[msg.sender][spender].add(value);
89 		emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
90 		return true;
91 	}
92 
93 	function decreaseApproval(address spender, uint256 value) public returns (bool) {
94 		uint256 currentValue = allowed[msg.sender][spender];
95 		if (value > currentValue) {
96 			allowed[msg.sender][spender] = 0;
97 		} else {
98 			allowed[msg.sender][spender] = currentValue.sub(value);
99 		}
100 		emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
101 		return true;
102 	}
103 
104 	function transferFrom(address from, address to, uint256 value) public returns (bool) {
105 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
106 		internalTransfer(from, to, value);
107 		emit Transfer(from, to, value);
108 		return true;
109 	}
110 
111 	function transfer(address to, uint256 value) public returns (bool) {
112 		internalTransfer(msg.sender, to, value);
113 		emit Transfer(msg.sender, to, value);
114 		return true;
115 	}
116 
117 	function transfer(address to, uint256 value, bytes data) public returns (bool) {
118 		internalTransfer(msg.sender, to, value);
119 		if (isContract(to)) {
120 			callTokenFallback(to, msg.sender, value, data);
121 		}
122 		emit Transfer(msg.sender, to, value, data);
123 		return true;
124 	}
125 
126 	function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool) {
127 		internalTransfer(msg.sender, to, value);
128 		if (isContract(to)) {
129 			assert(to.call.value(0)(bytes4(keccak256(custom_fallback)), msg.sender, value, data));
130 		} 
131 		emit Transfer(msg.sender, to, value, data);
132 		return true;
133 	}
134 
135 	function burn(uint256 value) public returns (bool) {
136 		internalBurn(msg.sender, value);
137 		return true;
138 	}
139 
140 	function burnFrom(address from, uint256 value) public returns (bool) {
141 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
142 		internalBurn(from, value);
143 		return true;
144 	}
145 
146 	function transferOwnership(address newOwner) onlyOwner public {
147 		require(newOwner != address(0));
148 		contractOwner = newOwner;
149 	}
150 
151 	function setTokenSale(address tokenSale, address preSaleDistribution, uint256 maximumSupply) onlyOwner public {
152 		require(tokenSaleContract == address(0));
153 		preSaleDistributionContract = preSaleDistribution;
154 		tokenSaleContract = tokenSale;
155 		totalSupply = maximumSupply;
156 		balances[tokenSale] = maximumSupply;
157 		bytes memory empty;
158 		callTokenFallback(tokenSale, 0x0, maximumSupply, empty);
159 		emit Transfer(0x0, tokenSale, maximumSupply);
160 	}
161 
162 	function setTokenSaleFinished() public {
163 		require(msg.sender == tokenSaleContract);
164 		tokenSaleIsFinished = true;
165 	}
166 
167 	function isContract(address _address) private constant returns (bool) {
168 		uint256 length;
169 		assembly {
170 			length := extcodesize(_address)
171 		}
172 		return (length > 0);
173 	}
174 
175 	function internalTransfer(address from, address to, uint256 value) private {
176 		require(canTransfer(from));
177 		balances[from] = balances[from].sub(value);
178 		balances[to] = balances[to].add(value);
179 	}
180 
181 	function internalBurn(address from, uint256 value) private {
182 		balances[from] = balances[from].sub(value);
183 		totalSupply = totalSupply.sub(value);
184 		emit Burn(from, value);
185 	}
186 
187 	function callTokenFallback(address to, address from, uint256 value, bytes data) private {
188 		ContractReceiver(to).tokenFallback(from, value, data);
189 	}
190 
191 	function canTransfer(address from) private view returns (bool) {
192 		return (tokenSaleIsFinished || from == tokenSaleContract || from == preSaleDistributionContract);
193 	}
194 }