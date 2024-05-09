1 pragma solidity ^0.4.18;
2 
3 /**************************************************************
4 *
5 * Alteum Token
6 * AUMX ERC223 Token Standard
7 * Author: Lex Garza 
8 * by ALTEUM / Copanga
9 *
10 **************************************************************/
11 
12 /**
13  * ERC223 token by Dexaran
14  * retreived from
15  * https://github.com/Dexaran/ERC223-token-standard
16  */
17 contract ERC223 {
18   uint public totalSupply;
19   function balanceOf(address who) public view returns (uint);
20   
21   function name() public view returns (string _name);
22   function symbol() public view returns (string _symbol);
23   function decimals() public view returns (uint8 _decimals);
24   function totalSupply() public view returns (uint256 _supply);
25 
26   function transfer(address to, uint value) public returns (bool ok);
27   function transfer(address to, uint value, bytes data) public returns (bool ok);
28   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
29   
30   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
31 }
32 
33 
34 contract ContractReceiver {
35 	function tokenFallback(address _from, uint _value, bytes _data) public pure;
36 }
37 
38 /*
39 * Safe Math Library from Zeppelin Solidity
40 * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
41 */
42 contract SafeMath
43 {
44     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48       }
49     
50 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
51 		assert(b <= a);
52 		return a - b;
53 	}
54 	
55 	function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
56 		uint256 c = a / b;
57 		return c;
58 	}
59 	
60 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
61 		if (a == 0) {
62 			return 0;
63 		}
64 		uint256 c = a * b;
65 		assert(c / a == b);
66 		return c;
67 	}
68 }
69 
70 contract AUMXToken is ERC223, SafeMath{
71 	mapping(address => mapping(address => uint)) allowed;
72 	mapping(address => uint) balances;
73 	string public name = "Alteum";
74 	string public symbol = "AUM";
75 	uint8 public decimals = 8; // Using a Satoshi as base for our decimals: 0.00000001;
76 	uint256 public totalSupply = 50000000; // 50,000,000 AUM's, not mineable, not mintable;
77 	
78 	bool locked;
79 	address Owner;
80 	address swapperAddress;
81 	
82 	function AUMXToken() public {
83 		locked = true;
84 		Owner = msg.sender;
85 		swapperAddress = msg.sender;
86 		balances[msg.sender] = totalSupply * 100000000;
87 		allowed[msg.sender][swapperAddress] = totalSupply * 100000000;
88 	}
89 	
90 	modifier isUnlocked()
91 	{
92 		if(locked && msg.sender != Owner) revert();
93 		_;
94 	}
95 	
96 	modifier onlyOwner()
97 	{
98 		if(msg.sender != Owner) revert();
99 		_;
100 	}
101 	  
102 	// Function to access name of token .
103 	function name() public view returns (string _name) {
104 		return name;
105 	}
106 	// Function to access symbol of token .
107 	function symbol() public view returns (string _symbol) {
108 		return symbol;
109 	}
110 	// Function to access decimals of token .
111 	function decimals() public view returns (uint8 _decimals) {
112 		return decimals;
113 	}
114 	// Function to access total supply of tokens .
115 	function totalSupply() public view returns (uint256 _totalSupply) {
116 		return totalSupply;
117 	}
118 	  
119 	function ChangeSwapperAddress(address newSwapperAddress) public onlyOwner
120 	{
121 		address oldSwapperAddress = swapperAddress;
122 		swapperAddress = newSwapperAddress;
123 		uint setAllowance = allowed[msg.sender][oldSwapperAddress];
124 		allowed[msg.sender][oldSwapperAddress] = 0;
125 		allowed[msg.sender][newSwapperAddress] = setAllowance;
126 	}
127 	
128 	function UnlockToken() public onlyOwner
129 	{
130 		locked = false;
131 	}
132 	  
133 	  
134 	  
135 	// Function that is called when a user or another contract wants to transfer funds .
136 	function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public isUnlocked returns (bool success) {
137 		if(isContract(_to)) {
138 			if (balanceOf(msg.sender) < _value) revert();
139 			balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
140 			balances[_to] = safeAdd(balanceOf(_to), _value);
141 			assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
142 			Transfer(msg.sender, _to, _value, _data);
143 			return true;
144 		}
145 		else {
146 			return transferToAddress(_to, _value, _data);
147 		}
148 	}
149 	  
150 
151 	// Function that is called when a user or another contract wants to transfer funds .
152 	function transfer(address _to, uint _value, bytes _data) public isUnlocked returns (bool success) {
153 		if(isContract(_to)) {
154 			return transferToContract(_to, _value, _data);
155 		}
156 		else {
157 			return transferToAddress(_to, _value, _data);
158 		}
159 	}
160 	  
161 	// Standard function transfer similar to ERC20 transfer with no _data .
162 	// Added due to backwards compatibility reasons .
163 	function transfer(address _to, uint _value) public isUnlocked returns (bool success) {
164 		//standard function transfer similar to ERC20 transfer with no _data
165 		//added due to backwards compatibility reasons
166 		bytes memory empty;
167 		if(isContract(_to)) {
168 			return transferToContract(_to, _value, empty);
169 		}
170 		else {
171 			return transferToAddress(_to, _value, empty);
172 		}
173 	}
174 
175 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
176 	function isContract(address _addr) private view returns (bool is_contract) {
177 		uint length;
178 		assembly {
179 			//retrieve the size of the code on target address, this needs assembly
180 			length := extcodesize(_addr)
181 		}
182 		return (length>0);
183 	}
184 
185 	//function that is called when transaction target is an address
186 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
187 		if (balanceOf(msg.sender) < _value) revert();
188 		balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
189 		balances[_to] = safeAdd(balanceOf(_to), _value);
190 		Transfer(msg.sender, _to, _value, _data);
191 		return true;
192 	}
193 	  
194 	//function that is called when transaction target is a contract
195 	function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
196 		if (balanceOf(msg.sender) < _value) revert();
197 		balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
198 		balances[_to] = safeAdd(balanceOf(_to), _value);
199 		ContractReceiver receiver = ContractReceiver(_to);
200 		receiver.tokenFallback(msg.sender, _value, _data);
201 		Transfer(msg.sender, _to, _value, _data);
202 		return true;
203 	}
204 	
205 	function transferFrom(address _from, address _to, uint _value) public returns(bool)
206 	{
207 		if(locked && msg.sender != swapperAddress) revert();
208 		if (balanceOf(_from) < _value) revert();
209 		if(_value > allowed[_from][msg.sender]) revert();
210 		
211 		balances[_from] = safeSub(balanceOf(_from), _value);
212 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
213 		balances[_to] = safeAdd(balanceOf(_to), _value);
214 		bytes memory empty;
215 		Transfer(_from, _to, _value, empty);
216 		return true;
217 	}
218 
219 	function balanceOf(address _owner) public view returns (uint balance) {
220 		return balances[_owner];
221 	}
222 }