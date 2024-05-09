1 pragma solidity ^0.4.18;
2 
3 /**************************************************************
4 *
5 * Alteum Token v1.1
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
30   event Transfer(address indexed from, address indexed to, uint value);
31   event ERC223Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
32 }
33 
34 
35 contract ContractReceiver {
36 	function tokenFallback(address _from, uint _value, bytes _data) public pure;
37 }
38 
39 /*
40 * Safe Math Library from Zeppelin Solidity
41 * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
42 */
43 contract SafeMath
44 {
45     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49       }
50     
51 	function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
52 		assert(b <= a);
53 		return a - b;
54 	}
55 	
56 	function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
57 		uint256 c = a / b;
58 		return c;
59 	}
60 	
61 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
62 		if (a == 0) {
63 			return 0;
64 		}
65 		uint256 c = a * b;
66 		assert(c / a == b);
67 		return c;
68 	}
69 }
70 
71 contract AUMXToken is ERC223, SafeMath{
72 	mapping(address => mapping(address => uint)) allowed;
73 	mapping(address => uint) balances;
74 	string public name = "Alteum";
75 	string public symbol = "AUM";
76 	uint8 public decimals = 8; // Using a Satoshi as base for our decimals: 0.00000001;
77 	uint256 public totalSupply = 5000000000000000; // 50,000,000 AUM's, not mineable, not mintable;
78 	
79 	bool locked;
80 	address Owner;
81 	address swapperAddress;
82 	
83 	function AUMXToken() public {
84 		locked = true;
85 		Owner = msg.sender;
86 		swapperAddress = msg.sender;
87 		balances[msg.sender] = totalSupply;
88 		allowed[msg.sender][swapperAddress] = totalSupply;
89 	}
90 	
91 	modifier isUnlocked()
92 	{
93 		if(locked && msg.sender != Owner) revert();
94 		_;
95 	}
96 	
97 	modifier onlyOwner()
98 	{
99 		if(msg.sender != Owner) revert();
100 		_;
101 	}
102 	  
103 	// Function to access name of token .
104 	function name() public view returns (string _name) {
105 		return name;
106 	}
107 	// Function to access symbol of token .
108 	function symbol() public view returns (string _symbol) {
109 		return symbol;
110 	}
111 	// Function to access decimals of token .
112 	function decimals() public view returns (uint8 _decimals) {
113 		return decimals;
114 	}
115 	// Function to access total supply of tokens .
116 	function totalSupply() public view returns (uint256 _totalSupply) {
117 		return totalSupply;
118 	}
119 	  
120 	function ChangeSwapperAddress(address newSwapperAddress) public onlyOwner
121 	{
122 		address oldSwapperAddress = swapperAddress;
123 		swapperAddress = newSwapperAddress;
124 		uint setAllowance = allowed[msg.sender][oldSwapperAddress];
125 		allowed[msg.sender][oldSwapperAddress] = 0;
126 		allowed[msg.sender][newSwapperAddress] = setAllowance;
127 	}
128 	
129 	function UnlockToken() public onlyOwner
130 	{
131 		locked = false;
132 	}
133 	  
134 	  
135 	  
136 	// Function that is called when a user or another contract wants to transfer funds .
137 	function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public isUnlocked returns (bool success) {
138 		if(isContract(_to)) {
139 			if (balanceOf(msg.sender) < _value) revert();
140 			balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
141 			balances[_to] = safeAdd(balanceOf(_to), _value);
142 			assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
143 			Transfer(msg.sender, _to, _value);
144 			ERC223Transfer(msg.sender, _to, _value, _data);
145 			return true;
146 		}
147 		else {
148 			return transferToAddress(_to, _value, _data);
149 		}
150 	}
151 	  
152 
153 	// Function that is called when a user or another contract wants to transfer funds .
154 	function transfer(address _to, uint _value, bytes _data) public isUnlocked returns (bool success) {
155 		if(isContract(_to)) {
156 			return transferToContract(_to, _value, _data);
157 		}
158 		else {
159 			return transferToAddress(_to, _value, _data);
160 		}
161 	}
162 	  
163 	// Standard function transfer similar to ERC20 transfer with no _data .
164 	// Added due to backwards compatibility reasons .
165 	function transfer(address _to, uint _value) public isUnlocked returns (bool success) {
166 		//standard function transfer similar to ERC20 transfer with no _data
167 		//added due to backwards compatibility reasons
168 		bytes memory empty;
169 		if(isContract(_to)) {
170 			return transferToContract(_to, _value, empty);
171 		}
172 		else {
173 			return transferToAddress(_to, _value, empty);
174 		}
175 	}
176 
177 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
178 	function isContract(address _addr) private view returns (bool is_contract) {
179 		uint length;
180 		assembly {
181 			//retrieve the size of the code on target address, this needs assembly
182 			length := extcodesize(_addr)
183 		}
184 		return (length>0);
185 	}
186 
187 	//function that is called when transaction target is an address
188 	function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
189 		if (balanceOf(msg.sender) < _value) revert();
190 		balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
191 		balances[_to] = safeAdd(balanceOf(_to), _value);
192 		Transfer(msg.sender, _to, _value);
193 		ERC223Transfer(msg.sender, _to, _value, _data);
194 		return true;
195 	}
196 	  
197 	//function that is called when transaction target is a contract
198 	function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
199 		if (balanceOf(msg.sender) < _value) revert();
200 		balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
201 		balances[_to] = safeAdd(balanceOf(_to), _value);
202 		ContractReceiver receiver = ContractReceiver(_to);
203 		receiver.tokenFallback(msg.sender, _value, _data);
204 		Transfer(msg.sender, _to, _value);
205 		ERC223Transfer(msg.sender, _to, _value, _data);
206 		return true;
207 	}
208 	
209 	function transferFrom(address _from, address _to, uint _value) public returns(bool)
210 	{
211 		if(locked && msg.sender != swapperAddress) revert();
212 		if (balanceOf(_from) < _value) revert();
213 		if(_value > allowed[_from][msg.sender]) revert();
214 		
215 		balances[_from] = safeSub(balanceOf(_from), _value);
216 		allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
217 		balances[_to] = safeAdd(balanceOf(_to), _value);
218 		bytes memory empty;
219 		Transfer(_from, _to, _value);
220 		ERC223Transfer(_from, _to, _value, empty);
221 		return true;
222 	}
223 
224 	function balanceOf(address _owner) public view returns (uint balance) {
225 		return balances[_owner];
226 	}
227 }