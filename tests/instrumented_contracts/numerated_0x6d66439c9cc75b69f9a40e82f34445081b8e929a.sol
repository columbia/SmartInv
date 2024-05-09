1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 /// ERC20 contract interface With ERC23/ERC223 Extensions
6 contract ERC20 {
7     uint256 public totalSupply;
8 
9     // ERC223 and ERC20 functions and events
10     function totalSupply() constant public returns (uint256 _supply);
11     function balanceOf(address who) public constant returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool ok);
13     function transfer(address to, uint256 value, bytes data) public returns (bool ok);
14     function name() constant public returns (string _name);
15     function symbol() constant public returns (string _symbol);
16     function decimals() constant public returns (uint8 _decimals);
17 
18     // ERC20 functions and events
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20     function approve(address _spender, uint256 _value) public returns (bool success);
21     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
22     
23     // ERC20 Event 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     event FrozenFunds(address target, bool frozen);
28 	event Burn(address indexed from, uint256 value);
29     
30 }
31 
32 /// Include SafeMath Lib
33 contract SafeMath {
34     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
35 
36     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
37         if (x > MAX_UINT256 - y) revert();
38         return x + y;
39     }
40 
41     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
42         if (x < y) revert();
43         return x - y;
44     }
45 
46     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
47         if (y == 0) return 0;
48         if (x > MAX_UINT256 / y) revert();
49         return x * y;
50     }
51 }
52 
53 /// Contract that is working with ERC223 tokens
54 contract ContractReceiver {
55 	struct TKN {
56         address sender;
57         uint256 value;
58         bytes data;
59         bytes4 sig;
60     }
61 
62     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
63       TKN memory tkn;
64       tkn.sender = _from;
65       tkn.value = _value;
66       tkn.data = _data;
67       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
68       tkn.sig = bytes4(u);
69     }
70 	
71 	function rewiewToken  () public pure returns (address, uint, bytes, bytes4) {
72         TKN memory tkn;
73         return (tkn.sender, tkn.value, tkn.data, tkn.sig);
74     }
75 }
76 
77 /// Realthium is an ERC20 token with ERC223 Extensions
78 contract TokenRK50Z is ERC20, SafeMath {
79     string public name;
80     string public symbol;
81     uint8 public decimals;
82     uint256 public totalSupply;
83     address public owner;
84     bool public SC_locked = false;
85     bool public tokenCreated = false;
86 	uint public DateCreateToken;
87 
88     mapping(address => uint256) balances;
89     mapping(address => mapping (address => uint256)) allowed;
90     mapping(address => bool) public frozenAccount;
91 	mapping(address => bool) public SmartContract_Allowed;
92 
93     // Initialize
94     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
95     function TokenRK50Z() public {
96         // Security check in case EVM has future flaw or exploit to call constructor multiple times
97         require(tokenCreated == false);
98 
99         owner = msg.sender;
100         
101 		name = "RK50Z";
102         symbol = "RK50Z";
103         decimals = 5;
104         totalSupply = 500000000 * 10 ** uint256(decimals);
105         balances[owner] = totalSupply;
106         emit Transfer(owner, owner, totalSupply);
107 		
108         tokenCreated = true;
109 
110         // Final sanity check to ensure owner balance is greater than zero
111         require(balances[owner] > 0);
112 
113 		// Date Deploy Contract
114 		DateCreateToken = now;
115     }
116 	
117     modifier onlyOwner() {
118         require(msg.sender == owner);
119         _;
120     }
121 
122 	// Function to create date token.
123     function DateCreateToken() public view returns (uint256 _DateCreateToken) {
124 		return DateCreateToken;
125 	}
126    	
127     // Function to access name of token .
128     function name() view public returns (string _name) {
129 		return name;
130 	}
131 	
132     // Function to access symbol of token .
133     function symbol() public view returns (string _symbol) {
134 		return symbol;
135     }
136 
137     // Function to access decimals of token .
138     function decimals() public view returns (uint8 _decimals) {	
139 		return decimals;
140     }
141 
142     // Function to access total supply of tokens .
143     function totalSupply() public view returns (uint256 _totalSupply) {
144 		return totalSupply;
145 	}
146 	
147 	// Get balance of the address provided
148     function balanceOf(address _owner) constant public returns (uint256 balance) {
149         return balances[_owner];
150     }
151 
152 	// Get Smart Contract of the address approved
153     function SmartContract_Allowed(address _target) constant public returns (bool _sc_address_allowed) {
154         return SmartContract_Allowed[_target];
155     }
156 
157     // Function that is called when a user or another contract wants to transfer funds .
158     function transfer(address _to, uint256 _value, bytes _data) public  returns (bool success) {
159         // Only allow transfer once Locked
160         // Once it is Locked, it is Locked forever and no one can lock again
161 		require(!SC_locked);
162 		require(!frozenAccount[msg.sender]);
163 		require(!frozenAccount[_to]);
164 		
165         if (isContract(_to)) {
166             return transferToContract(_to, _value, _data);
167         } 
168         else {
169             return transferToAddress(_to, _value, _data);
170         }
171     }
172 
173     // Standard function transfer similar to ERC20 transfer with no _data .
174     // Added due to backwards compatibility reasons .
175     function transfer(address _to, uint256 _value) public returns (bool success) {
176         // Only allow transfer once Locked
177         require(!SC_locked);
178 		require(!frozenAccount[msg.sender]);
179 		require(!frozenAccount[_to]);
180 
181         //standard function transfer similar to ERC20 transfer with no _data
182         //added due to backwards compatibility reasons
183         bytes memory empty;
184         if (isContract(_to)) {
185             return transferToContract(_to, _value, empty);
186         } 
187         else {
188             return transferToAddress(_to, _value, empty);
189         }
190     }
191 
192 	// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
193     function isContract(address _addr) private view returns (bool is_contract) {
194         uint length;
195         assembly {
196             //retrieve the size of the code on target address, this needs assembly
197             length := extcodesize(_addr)
198         }
199         return (length > 0);
200     }
201 
202     // function that is called when transaction target is an address
203     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
204         if (balanceOf(msg.sender) < _value) revert();
205         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
206         balances[_to] = safeAdd(balanceOf(_to), _value);
207         emit Transfer(msg.sender, _to, _value, _data);
208         return true;
209     }
210 
211     // function that is called when transaction target is a contract
212     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
213         require(SmartContract_Allowed[_to]);
214 		
215 		if (balanceOf(msg.sender) < _value) revert();
216         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
217         balances[_to] = safeAdd(balanceOf(_to), _value);
218         emit Transfer(msg.sender, _to, _value, _data);
219         return true;
220     }
221 
222    
223     // Allow transfers if the owner provided an allowance
224     // Use SafeMath for the main logic
225     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
226         // Only allow transfer once Locked
227         // Once it is Locked, it is Locked forever and no one can lock again
228         require(!SC_locked);
229 		require(!frozenAccount[_from]);
230 		require(!frozenAccount[_to]);
231 		
232         // Protect against wrapping uints.
233         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
234         uint256 allowance = allowed[_from][msg.sender];
235         require(balances[_from] >= _value && allowance >= _value);
236         balances[_to] = safeAdd(balanceOf(_to), _value);
237         balances[_from] = safeSub(balanceOf(_from), _value);
238         if (allowance < MAX_UINT256) {
239             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
240         }
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244 
245     function approve(address _spender, uint256 _value) public returns (bool success) {
246         // Only allow transfer once unLocked
247         require(!SC_locked);
248 		require(!frozenAccount[msg.sender]);
249 		require(!frozenAccount[_spender]);
250 		
251         allowed[msg.sender][_spender] = _value;
252         emit Approval(msg.sender, _spender, _value);
253         return true;
254     }
255 
256     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
257 		return allowed[_owner][_spender];
258     }
259 	
260     /// Set allowance for other address and notify
261     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
262         require(!SC_locked);
263 		require(!frozenAccount[msg.sender]);
264 		require(!frozenAccount[_spender]);
265 		
266 		tokenRecipient spender = tokenRecipient(_spender);
267         if (approve(_spender, _value)) {
268             spender.receiveApproval(msg.sender, _value, this, _extraData);
269             return true;
270         }
271     }
272 	
273 	/// Function to activate Ether reception in the smart Contract address only by the Owner
274     function () public payable { 
275 		if(msg.sender != owner) { revert(); }
276     }
277 
278 	// Creator/Owner can Locked/Unlock smart contract
279     function OWN_contractlocked(bool _locked) onlyOwner public {
280         SC_locked = _locked;
281     }
282 	
283 	/// Destroy tokens amount from another account (Caution!!! the operation is destructive and you can not go back)
284     function OWN_burnToken(address _from, uint256 _value)  onlyOwner public returns (bool success) {
285         require(balances[_from] >= _value);
286         balances[_from] -= _value;
287         totalSupply -= _value;
288         emit Burn(_from, _value);
289         return true;
290     }
291 	
292 	///Generate other tokens after starting the program
293     function OWN_mintToken(uint256 mintedAmount) onlyOwner public {
294         //aggiungo i decimali al valore che imposto
295         balances[owner] += mintedAmount;
296         totalSupply += mintedAmount;
297         emit Transfer(0, this, mintedAmount);
298         emit Transfer(this, owner, mintedAmount);
299     }
300 	
301 	/// Block / Unlock address handling tokens
302     function OWN_freezeAddress(address target, bool freeze) onlyOwner public {
303         frozenAccount[target] = freeze;
304         emit FrozenFunds(target, freeze);
305     }
306 		
307 	/// Function to destroy the smart contract
308     function OWN_kill() onlyOwner public { 
309 		selfdestruct(owner); 
310     }
311 	
312 	/// Function Change Owner
313 	function OWN_transferOwnership(address newOwner) onlyOwner public {
314         // function allowed only if the address is not smart contract
315         if (!isContract(newOwner)) {	
316 			owner = newOwner;
317 		}
318     }
319 	
320 	/// Smart Contract approved
321     function OWN_SmartContract_Allowed(address target, bool _allowed) onlyOwner public {
322 		// function allowed only for smart contract
323         if (isContract(target)) {
324 			SmartContract_Allowed[target] = _allowed;
325 		}
326     }
327 
328 	/// Distribution Token from Admin
329 	function OWN_DistributeTokenAdmin_Multi(address[] addresses, uint256 _value, bool freeze) onlyOwner public {
330 		for (uint i = 0; i < addresses.length; i++) {
331 			//Block / Unlock address handling tokens
332 			frozenAccount[addresses[i]] = freeze;
333 			emit FrozenFunds(addresses[i], freeze);
334 			
335 			bytes memory empty;
336 			if (isContract(addresses[i])) {
337 				transferToContract(addresses[i], _value, empty);
338 			} 
339 			else {
340 				transferToAddress(addresses[i], _value, empty);
341 			}
342 		}
343 	}
344 }