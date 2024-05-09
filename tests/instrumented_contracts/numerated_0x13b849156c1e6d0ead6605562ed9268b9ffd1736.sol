1 pragma solidity ^0.4.21;
2 
3 /// ERC20 contract interface With ERC23/ERC223 Extensions
4 contract ERC20 {
5     uint256 public totalSupply;
6 
7     // ERC223 and ERC20 functions and events
8     function totalSupply() constant public returns (uint256 _supply);
9     function balanceOf(address who) public constant returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool ok);
11     function name() constant public returns (string _name);
12     function symbol() constant public returns (string _symbol);
13     function decimals() constant public returns (uint8 _decimals);
14 
15     // ERC20 Event 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event FrozenFunds(address target, bool frozen);
18 	event Burn(address indexed from, uint256 value);
19     
20 }
21 
22 /// Include SafeMath Lib
23 contract SafeMath {
24     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
25 
26     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
27         if (x > MAX_UINT256 - y) revert();
28         return x + y;
29     }
30 
31     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
32         if (x < y) revert();
33         return x - y;
34     }
35 
36     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
37         if (y == 0) return 0;
38         if (x > MAX_UINT256 / y) revert();
39         return x * y;
40     }
41 }
42 
43 /// Contract that is working with ERC223 tokens
44 contract ContractReceiver {
45 	struct TKN {
46         address sender;
47         uint256 value;
48         bytes data;
49         bytes4 sig;
50     }
51 
52     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
53       TKN memory tkn;
54       tkn.sender = _from;
55       tkn.value = _value;
56       tkn.data = _data;
57       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
58       tkn.sig = bytes4(u);
59     }
60 	
61 	function rewiewToken  () public pure returns (address, uint, bytes, bytes4) {
62         TKN memory tkn;
63         return (tkn.sender, tkn.value, tkn.data, tkn.sig);
64     }
65 }
66 
67 /// RK70Z is an ERC20 token with ERC223 Extensions
68 contract TokenRK70Z is ERC20, SafeMath {
69     string public name;
70     string public symbol;
71     uint8 public decimals;
72     uint256 public totalSupply;
73     address public owner;
74     bool public SC_locked = false;
75     bool public tokenCreated = false;
76 	uint public DateCreateToken;
77 
78     mapping(address => uint256) balances;
79     mapping(address => bool) public frozenAccount;
80 	mapping(address => bool) public SmartContract_Allowed;
81 
82     // Initialize
83     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
84     function TokenRK70Z() public {
85         // Security check in case EVM has future flaw or exploit to call constructor multiple times
86         require(tokenCreated == false);
87 
88         owner = msg.sender;
89         
90 		name = "RK70Z";
91         symbol = "RK70Z";
92         decimals = 5;
93         totalSupply = 500000000 * 10 ** uint256(decimals);
94         balances[owner] = totalSupply;
95         emit Transfer(owner, owner, totalSupply);
96 		
97         tokenCreated = true;
98 
99         // Final sanity check to ensure owner balance is greater than zero
100         require(balances[owner] > 0);
101 
102 		// Date Deploy Contract
103 		DateCreateToken = now;
104     }
105 	
106     modifier onlyOwner() {
107         require(msg.sender == owner);
108         _;
109     }
110 
111 	// Function to create date token.
112     function DateCreateToken() public view returns (uint256 _DateCreateToken) {
113 		return DateCreateToken;
114 	}
115    	
116     // Function to access name of token .
117     function name() view public returns (string _name) {
118 		return name;
119 	}
120 	
121     // Function to access symbol of token .
122     function symbol() public view returns (string _symbol) {
123 		return symbol;
124     }
125 
126     // Function to access decimals of token .
127     function decimals() public view returns (uint8 _decimals) {	
128 		return decimals;
129     }
130 
131     // Function to access total supply of tokens .
132     function totalSupply() public view returns (uint256 _totalSupply) {
133 		return totalSupply;
134 	}
135 	
136 	// Get balance of the address provided
137     function balanceOf(address _owner) constant public returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141 	// Get Smart Contract of the address approved
142     function SmartContract_Allowed(address _target) constant public returns (bool _sc_address_allowed) {
143         return SmartContract_Allowed[_target];
144     }
145 
146     // Added due to backwards compatibility reasons .
147     function transfer(address _to, uint256 _value) public returns (bool success) {
148         // Only allow transfer once Locked
149         require(!SC_locked);
150 		require(!frozenAccount[msg.sender]);
151 		require(!frozenAccount[_to]);
152 
153         //standard function transfer similar to ERC20 transfer with no _data
154         if (isContract(_to)) {
155             return transferToContract(_to, _value);
156         } 
157         else {
158             return transferToAddress(_to, _value);
159         }
160     }
161 
162 	// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
163     function isContract(address _addr) private view returns (bool is_contract) {
164         uint length;
165         assembly {
166             //retrieve the size of the code on target address, this needs assembly
167             length := extcodesize(_addr)
168         }
169         return (length > 0);
170     }
171 
172     // function that is called when transaction target is an address
173     function transferToAddress(address _to, uint256 _value) private returns (bool success) {
174         if (balanceOf(msg.sender) < _value) revert();
175         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
176         balances[_to] = safeAdd(balanceOf(_to), _value);
177         emit Transfer(msg.sender, _to, _value);
178         return true;
179     }
180 
181     // function that is called when transaction target is a contract
182     function transferToContract(address _to, uint256 _value) private returns (bool success) {
183         require(SmartContract_Allowed[_to]);
184 		
185 		if (balanceOf(msg.sender) < _value) revert();
186         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
187         balances[_to] = safeAdd(balanceOf(_to), _value);
188         emit Transfer(msg.sender, _to, _value);
189         return true;
190     }
191 
192 	// Function to activate Ether reception in the smart Contract address only by the Owner
193     function () public payable { 
194 		if(msg.sender != owner) { revert(); }
195     }
196 
197 	// Creator/Owner can Locked/Unlock smart contract
198     function OWN_contractlocked(bool _locked) onlyOwner public {
199         SC_locked = _locked;
200     }
201 	
202 	// Destroy tokens amount from another account (Caution!!! the operation is destructive and you can not go back)
203     function OWN_burnToken(address _from, uint256 _value)  onlyOwner public returns (bool success) {
204         require(balances[_from] >= _value);
205         balances[_from] -= _value;
206         totalSupply -= _value;
207         emit Burn(_from, _value);
208         return true;
209     }
210 	
211 	//Generate other tokens after starting the program
212     function OWN_mintToken(uint256 mintedAmount) onlyOwner public {
213         //aggiungo i decimali al valore che imposto
214         balances[owner] += mintedAmount;
215         totalSupply += mintedAmount;
216         emit Transfer(0, this, mintedAmount);
217         emit Transfer(this, owner, mintedAmount);
218     }
219 	
220 	// Block / Unlock address handling tokens
221     function OWN_freezeAddress(address target, bool freeze) onlyOwner public {
222         frozenAccount[target] = freeze;
223         emit FrozenFunds(target, freeze);
224     }
225 		
226 	// Function to destroy the smart contract
227     function OWN_kill() onlyOwner public { 
228 		selfdestruct(owner); 
229     }
230 	
231 	// Function Change Owner
232 	function OWN_transferOwnership(address newOwner) onlyOwner public {
233         // function allowed only if the address is not smart contract
234         if (!isContract(newOwner)) {	
235 			owner = newOwner;
236 		}
237     }
238 	
239 	// Smart Contract approved
240     function OWN_SmartContract_Allowed(address target, bool _allowed) onlyOwner public {
241 		// function allowed only for smart contract
242         if (isContract(target)) {
243 			SmartContract_Allowed[target] = _allowed;
244 		}
245     }
246 
247 	// Distribution Token from Admin
248 	function OWN_DistributeTokenAdmin_Multi(address[] addresses, uint256 _value, bool freeze) onlyOwner public {
249 		for (uint i = 0; i < addresses.length; i++) {
250 			//Block / Unlock address handling tokens
251 			frozenAccount[addresses[i]] = freeze;
252 			emit FrozenFunds(addresses[i], freeze);
253 			
254 			if (isContract(addresses[i])) {
255 				transferToContract(addresses[i], _value);
256 			} 
257 			else {
258 				transferToAddress(addresses[i], _value);
259 			}
260 		}
261 	}
262 }