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
11     function transfer(address to, uint256 value, bytes data) public returns (bool ok);
12     function name() constant public returns (string _name);
13     function symbol() constant public returns (string _symbol);
14     function decimals() constant public returns (uint8 _decimals);
15 
16     // ERC20 Event 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
19     event FrozenFunds(address target, bool frozen);
20 	event Burn(address indexed from, uint256 value);
21     
22 }
23 
24 /// Include SafeMath Lib
25 contract SafeMath {
26     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
27 
28     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
29         if (x > MAX_UINT256 - y) revert();
30         return x + y;
31     }
32 
33     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
34         if (x < y) revert();
35         return x - y;
36     }
37 
38     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
39         if (y == 0) return 0;
40         if (x > MAX_UINT256 / y) revert();
41         return x * y;
42     }
43 }
44 
45 /// Contract that is working with ERC223 tokens
46 contract ContractReceiver {
47 	struct TKN {
48         address sender;
49         uint256 value;
50         bytes data;
51         bytes4 sig;
52     }
53 
54     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
55       TKN memory tkn;
56       tkn.sender = _from;
57       tkn.value = _value;
58       tkn.data = _data;
59       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
60       tkn.sig = bytes4(u);
61     }
62 	
63 	function rewiewToken  () public pure returns (address, uint, bytes, bytes4) {
64         TKN memory tkn;
65         return (tkn.sender, tkn.value, tkn.data, tkn.sig);
66     }
67 }
68 
69 /// Realthium is an ERC20 token with ERC223 Extensions
70 contract TokenRHT is ERC20, SafeMath {
71     string public name;
72     string public symbol;
73     uint8 public decimals;
74     uint256 public totalSupply;
75     address public owner;
76     bool public SC_locked = false;
77     bool public tokenCreated = false;
78 	uint public DateCreateToken;
79 
80     mapping(address => uint256) balances;
81     mapping(address => bool) public frozenAccount;
82 	mapping(address => bool) public SmartContract_Allowed;
83 
84     // Initialize
85     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
86     function TokenRHT() public {
87         // Security check in case EVM has future flaw or exploit to call constructor multiple times
88         require(tokenCreated == false);
89 
90         owner = msg.sender;
91         
92 		name = "Realthium";
93         symbol = "RHT";
94         decimals = 5;
95         totalSupply = 500000000 * 10 ** uint256(decimals);
96         balances[owner] = totalSupply;
97         emit Transfer(owner, owner, totalSupply);
98 		
99         tokenCreated = true;
100 
101         // Final sanity check to ensure owner balance is greater than zero
102         require(balances[owner] > 0);
103 
104 		// Date Deploy Contract
105 		DateCreateToken = now;
106     }
107 	
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113 	// Function to create date token.
114     function DateCreateToken() public view returns (uint256 _DateCreateToken) {
115 		return DateCreateToken;
116 	}
117    	
118     // Function to access name of token .
119     function name() view public returns (string _name) {
120 		return name;
121 	}
122 	
123     // Function to access symbol of token .
124     function symbol() public view returns (string _symbol) {
125 		return symbol;
126     }
127 
128     // Function to access decimals of token .
129     function decimals() public view returns (uint8 _decimals) {	
130 		return decimals;
131     }
132 
133     // Function to access total supply of tokens .
134     function totalSupply() public view returns (uint256 _totalSupply) {
135 		return totalSupply;
136 	}
137 	
138 	// Get balance of the address provided
139     function balanceOf(address _owner) constant public returns (uint256 balance) {
140         return balances[_owner];
141     }
142 
143 	// Get Smart Contract of the address approved
144     function SmartContract_Allowed(address _target) constant public returns (bool _sc_address_allowed) {
145         return SmartContract_Allowed[_target];
146     }
147 
148     // Function that is called when a user or another contract wants to transfer funds .
149     function transfer(address _to, uint256 _value, bytes _data) public  returns (bool success) {
150         // Only allow transfer once Locked
151         // Once it is Locked, it is Locked forever and no one can lock again
152 		require(!SC_locked);
153 		require(!frozenAccount[msg.sender]);
154 		require(!frozenAccount[_to]);
155 		
156         if (isContract(_to)) {
157             return transferToContract(_to, _value, _data);
158         } 
159         else {
160             return transferToAddress(_to, _value, _data);
161         }
162     }
163 
164     // Standard function transfer similar to ERC20 transfer with no _data .
165     // Added due to backwards compatibility reasons .
166     function transfer(address _to, uint256 _value) public returns (bool success) {
167         // Only allow transfer once Locked
168         require(!SC_locked);
169 		require(!frozenAccount[msg.sender]);
170 		require(!frozenAccount[_to]);
171 
172         //standard function transfer similar to ERC20 transfer with no _data
173         //added due to backwards compatibility reasons
174         bytes memory empty;
175         if (isContract(_to)) {
176             return transferToContract(_to, _value, empty);
177         } 
178         else {
179             return transferToAddress(_to, _value, empty);
180         }
181     }
182 
183 	// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
184     function isContract(address _addr) private view returns (bool is_contract) {
185         uint length;
186         assembly {
187             //retrieve the size of the code on target address, this needs assembly
188             length := extcodesize(_addr)
189         }
190         return (length > 0);
191     }
192 
193     // function that is called when transaction target is an address
194     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
195         if (balanceOf(msg.sender) < _value) revert();
196         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
197         balances[_to] = safeAdd(balanceOf(_to), _value);
198         emit Transfer(msg.sender, _to, _value, _data);
199         return true;
200     }
201 
202     // function that is called when transaction target is a contract
203     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
204         require(SmartContract_Allowed[_to]);
205 		
206 		if (balanceOf(msg.sender) < _value) revert();
207         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
208         balances[_to] = safeAdd(balanceOf(_to), _value);
209         emit Transfer(msg.sender, _to, _value, _data);
210         return true;
211     }
212 
213 	// Function to activate Ether reception in the smart Contract address only by the Owner
214     function () public payable { 
215 		if(msg.sender != owner) { revert(); }
216     }
217 
218 	// Creator/Owner can Locked/Unlock smart contract
219     function OWN_contractlocked(bool _locked) onlyOwner public {
220         SC_locked = _locked;
221     }
222 	
223 	// Destroy tokens amount from another account (Caution!!! the operation is destructive and you can not go back)
224     function OWN_burnToken(address _from, uint256 _value)  onlyOwner public returns (bool success) {
225         require(balances[_from] >= _value);
226         balances[_from] -= _value;
227         totalSupply -= _value;
228         emit Burn(_from, _value);
229         return true;
230     }
231 	
232 	//Generate other tokens after starting the program
233     function OWN_mintToken(uint256 mintedAmount) onlyOwner public {
234         //aggiungo i decimali al valore che imposto
235         balances[owner] += mintedAmount;
236         totalSupply += mintedAmount;
237         emit Transfer(0, this, mintedAmount);
238         emit Transfer(this, owner, mintedAmount);
239     }
240 	
241 	// Block / Unlock address handling tokens
242     function OWN_freezeAddress(address target, bool freeze) onlyOwner public {
243         frozenAccount[target] = freeze;
244         emit FrozenFunds(target, freeze);
245     }
246 		
247 	// Function to destroy the smart contract
248     function OWN_kill() onlyOwner public { 
249 		selfdestruct(owner); 
250     }
251 	
252 	// Function Change Owner
253 	function OWN_transferOwnership(address newOwner) onlyOwner public {
254         // function allowed only if the address is not smart contract
255         if (!isContract(newOwner)) {	
256 			owner = newOwner;
257 		}
258     }
259 	
260 	// Smart Contract approved
261     function OWN_SmartContract_Allowed(address target, bool _allowed) onlyOwner public {
262 		// function allowed only for smart contract
263         if (isContract(target)) {
264 			SmartContract_Allowed[target] = _allowed;
265 		}
266     }
267 
268 	// Distribution Token from Admin
269 	function OWN_DistributeTokenAdmin_Multi(address[] addresses, uint256 _value, bool freeze) onlyOwner public {
270 		for (uint i = 0; i < addresses.length; i++) {
271 			//Block / Unlock address handling tokens
272 			frozenAccount[addresses[i]] = freeze;
273 			emit FrozenFunds(addresses[i], freeze);
274 			
275 			bytes memory empty;
276 			if (isContract(addresses[i])) {
277 				transferToContract(addresses[i], _value, empty);
278 			} 
279 			else {
280 				transferToAddress(addresses[i], _value, empty);
281 			}
282 		}
283 	}
284 }