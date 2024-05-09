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
19 }
20 
21 /// Include SafeMath Lib
22 contract SafeMath {
23     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
24 
25     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
26         if (x > MAX_UINT256 - y) revert();
27         return x + y;
28     }
29 
30     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
31         if (x < y) revert();
32         return x - y;
33     }
34 
35     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
36         if (y == 0) return 0;
37         if (x > MAX_UINT256 / y) revert();
38         return x * y;
39     }
40 }
41 
42 /// Contract that is working with ERC223 tokens
43 contract ContractReceiver {
44 	struct TKN {
45         address sender;
46         uint256 value;
47         bytes data;
48         bytes4 sig;
49     }
50 
51     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
52       TKN memory tkn;
53       tkn.sender = _from;
54       tkn.value = _value;
55       tkn.data = _data;
56       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
57       tkn.sig = bytes4(u);
58     }
59 	
60 	function rewiewToken  () public pure returns (address, uint, bytes, bytes4) {
61         TKN memory tkn;
62         return (tkn.sender, tkn.value, tkn.data, tkn.sig);
63     }
64 }
65 
66 /// REALTHIUM inc.
67 contract TokenRHT is ERC20, SafeMath {
68     string public name;
69     string public symbol;
70     uint8 public decimals;
71     uint256 public totalSupply;
72     address public owner;
73     bool public SC_locked = true;
74     bool public tokenCreated = false;
75 	uint public DateCreateToken;
76 
77     mapping(address => uint256) balances;
78     mapping(address => bool) public frozenAccount;
79 	mapping(address => bool) public SmartContract_Allowed;
80 
81     // Initialize
82     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
83     function TokenRHT() public {
84         // Security check in case EVM has future flaw or exploit to call constructor multiple times
85         require(tokenCreated == false);
86 
87         owner = msg.sender;
88         
89 		name = "REALTHIUM";
90         symbol = "RHT";
91         decimals = 5;
92         totalSupply = 500000000 * 10 ** uint256(decimals);
93         balances[owner] = totalSupply;
94         emit Transfer(owner, owner, totalSupply);
95 		
96         tokenCreated = true;
97 
98         // Final sanity check to ensure owner balance is greater than zero
99         require(balances[owner] > 0);
100 
101 		// Date Deploy Contract
102 		DateCreateToken = now;
103     }
104 	
105     modifier onlyOwner() {
106         require(msg.sender == owner);
107         _;
108     }
109 
110 	// Function to create date token.
111     function DateCreateToken() public view returns (uint256 _DateCreateToken) {
112 		return DateCreateToken;
113 	}
114    	
115     // Function to access name of token .
116     function name() view public returns (string _name) {
117 		return name;
118 	}
119 	
120     // Function to access symbol of token .
121     function symbol() public view returns (string _symbol) {
122 		return symbol;
123     }
124 
125     // Function to access decimals of token .
126     function decimals() public view returns (uint8 _decimals) {	
127 		return decimals;
128     }
129 
130     // Function to access total supply of tokens .
131     function totalSupply() public view returns (uint256 _totalSupply) {
132 		return totalSupply;
133 	}
134 	
135 	// Get balance of the address provided
136     function balanceOf(address _owner) constant public returns (uint256 balance) {
137         return balances[_owner];
138     }
139 
140 	// Get Smart Contract of the address approved
141     function SmartContract_Allowed(address _target) constant public returns (bool _sc_address_allowed) {
142         return SmartContract_Allowed[_target];
143     }
144 
145     // Added due to backwards compatibility reasons .
146     function transfer(address _to, uint256 _value) public returns (bool success) {
147         // Only allow transfer once Locked
148         require(!SC_locked);
149 		require(!frozenAccount[msg.sender]);
150 		require(!frozenAccount[_to]);
151 
152         //standard function transfer similar to ERC20 transfer with no _data
153         if (isContract(_to)) {
154             return transferToContract(_to, _value);
155         } 
156         else {
157             return transferToAddress(_to, _value);
158         }
159     }
160 
161 	// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
162     function isContract(address _addr) private view returns (bool is_contract) {
163         uint length;
164         assembly {
165             //retrieve the size of the code on target address, this needs assembly
166             length := extcodesize(_addr)
167         }
168         return (length > 0);
169     }
170 
171     // function that is called when transaction target is an address
172     function transferToAddress(address _to, uint256 _value) private returns (bool success) {
173         if (balanceOf(msg.sender) < _value) revert();
174         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
175         balances[_to] = safeAdd(balanceOf(_to), _value);
176         emit Transfer(msg.sender, _to, _value);
177         return true;
178     }
179 
180     // function that is called when transaction target is a contract
181     function transferToContract(address _to, uint256 _value) private returns (bool success) {
182         require(SmartContract_Allowed[_to]);
183 		
184 		if (balanceOf(msg.sender) < _value) revert();
185         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
186         balances[_to] = safeAdd(balanceOf(_to), _value);
187         emit Transfer(msg.sender, _to, _value);
188         return true;
189     }
190 
191 	// Function to activate Ether reception in the smart Contract address only by the Owner
192     function () public payable { 
193 		if(msg.sender != owner) { revert(); }
194     }
195 
196 	// Creator/Owner change name and symbol
197     function OWN_ChangeToken(string _name, string _symbol, uint8 _decimals) onlyOwner public {
198 		name = _name;
199         symbol = _symbol;
200 		decimals = _decimals;
201     }
202 
203 	// Creator/Owner can Locked/Unlock smart contract
204     function OWN_contractlocked(bool _locked) onlyOwner public {
205         SC_locked = _locked;
206     }
207 	
208 	// Destroy tokens amount from another account (Caution!!! the operation is destructive and you can not go back)
209     function OWN_burnToken(address _from, uint256 _value)  onlyOwner public returns (bool success) {
210         require(balances[_from] >= _value);
211         balances[_from] -= _value;
212         totalSupply -= _value;
213         emit Burn(_from, _value);
214         return true;
215     }
216 	
217 	//Generate other tokens after starting the program
218     function OWN_mintToken(uint256 mintedAmount) onlyOwner public {
219         //aggiungo i decimali al valore che imposto
220         balances[owner] += mintedAmount;
221         totalSupply += mintedAmount;
222         emit Transfer(0, this, mintedAmount);
223         emit Transfer(this, owner, mintedAmount);
224     }
225 	
226 	// Block / Unlock address handling tokens
227     function OWN_freezeAddress(address target, bool freeze) onlyOwner public {
228         frozenAccount[target] = freeze;
229         emit FrozenFunds(target, freeze);
230     }
231 		
232 	// Function to destroy the smart contract
233     function OWN_kill() onlyOwner public { 
234 		selfdestruct(owner); 
235     }
236 	
237 	// Function Change Owner
238 	function OWN_transferOwnership(address newOwner) onlyOwner public {
239         // function allowed only if the address is not smart contract
240         if (!isContract(newOwner)) {	
241 			owner = newOwner;
242 		}
243     }
244 	
245 	// Smart Contract approved
246     function OWN_SmartContract_Allowed(address target, bool _allowed) onlyOwner public {
247 		// function allowed only for smart contract
248         if (isContract(target)) {
249 			SmartContract_Allowed[target] = _allowed;
250 		}
251     }
252 
253 	// Distribution Token from Admin
254 	function OWN_DistributeTokenAdmin_Multi(address[] addresses, uint256 _value, bool freeze) onlyOwner public {
255 		for (uint i = 0; i < addresses.length; i++) {
256 			//Block / Unlock address handling tokens
257 			frozenAccount[addresses[i]] = freeze;
258 			emit FrozenFunds(addresses[i], freeze);
259 			
260 			if (isContract(addresses[i])) {
261 				transferToContract(addresses[i], _value);
262 			} 
263 			else {
264 				transferToAddress(addresses[i], _value);
265 			}
266 		}
267 	}
268 }