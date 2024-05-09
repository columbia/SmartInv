1 pragma solidity ^0.4.21;
2 
3 /// RK35Z token ERC20 with Extensions ERC223
4 contract RK40Z {
5     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     address public owner;
12     bool public SC_locked = true;
13     bool public tokenCreated = false;
14 	uint public DateCreateToken;
15 
16     mapping(address => uint256) balances;
17     mapping(address => mapping (address => uint256)) allowed;
18     mapping(address => bool) public frozenAccount;
19 	mapping(address => bool) public SmartContract_Allowed;
20 
21 	// ERC20 Event 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     event FrozenFunds(address target, bool frozen);
26 	event Burn(address indexed from, uint256 value);
27     
28     // Initialize
29     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
30     function RK40Z() public {
31         // Security check in case EVM has future flaw or exploit to call constructor multiple times
32         require(tokenCreated == false);
33 
34         owner = msg.sender;
35         
36 		name = "RK40Z";
37         symbol = "RK40Z";
38         decimals = 5;
39         totalSupply = 500000000 * 10 ** uint256(decimals);
40         balances[owner] = totalSupply;
41         emit Transfer(owner, owner, totalSupply);
42 		
43         tokenCreated = true;
44 
45         // Final sanity check to ensure owner balance is greater than zero
46         require(balances[owner] > 0);
47 
48 		// Date Deploy Contract
49 		DateCreateToken = now;
50     }
51 	
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57 	// Function to create date token.
58     function DateCreateToken() public view returns (uint256 _DateCreateToken) {
59 		return DateCreateToken;
60 	}
61    	
62     // Function to access name of token .
63     function name() view public returns (string _name) {
64 		return name;
65 	}
66 	
67     // Function to access symbol of token .
68     function symbol() public view returns (string _symbol) {
69 		return symbol;
70     }
71 
72     // Function to access decimals of token .
73     function decimals() public view returns (uint8 _decimals) {	
74 		return decimals;
75     }
76 
77     // Function to access total supply of tokens .
78     function totalSupply() public view returns (uint256 _totalSupply) {
79 		return totalSupply;
80 	}
81 	
82 	// Get balance of the address provided
83     function balanceOf(address _owner) constant public returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87 	// Get Smart Contract of the address approved
88     function SmartContract_Allowed(address _target) constant public returns (bool _sc_address_allowed) {
89         return SmartContract_Allowed[_target];
90     }
91 
92     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
93         if (x > MAX_UINT256 - y) revert();
94         return x + y;
95     }
96 
97     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
98         if (x < y) revert();
99         return x - y;
100     }
101 
102     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
103         if (y == 0) return 0;
104         if (x > MAX_UINT256 / y) revert();
105         return x * y;
106     }
107 
108     // Function that is called when a user or another contract wants to transfer funds .
109     function transfer(address _to, uint256 _value, bytes _data) public  returns (bool success) {
110         // Only allow transfer once Locked
111         // Once it is Locked, it is Locked forever and no one can lock again
112 		require(!SC_locked);
113 		require(!frozenAccount[msg.sender]);
114 		require(!frozenAccount[_to]);
115 		
116         if (isContract(_to)) {
117             return transferToContract(_to, _value, _data);
118         } 
119         else {
120             return transferToAddress(_to, _value, _data);
121         }
122     }
123 
124     // Standard function transfer similar to ERC20 transfer with no _data .
125     // Added due to backwards compatibility reasons .
126     function transfer(address _to, uint256 _value) public returns (bool success) {
127         // Only allow transfer once Locked
128         require(!SC_locked);
129 		require(!frozenAccount[msg.sender]);
130 		require(!frozenAccount[_to]);
131 
132         //standard function transfer similar to ERC20 transfer with no _data
133         //added due to backwards compatibility reasons
134         bytes memory empty;
135         if (isContract(_to)) {
136             return transferToContract(_to, _value, empty);
137         } 
138         else {
139             return transferToAddress(_to, _value, empty);
140         }
141     }
142 
143 	// assemble the given address bytecode. If bytecode exists then the _addr is a contract.
144     function isContract(address _addr) private view returns (bool is_contract) {
145         uint length;
146         assembly {
147             //retrieve the size of the code on target address, this needs assembly
148             length := extcodesize(_addr)
149         }
150         return (length > 0);
151     }
152 
153     // function that is called when transaction target is an address
154     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
155         if (balanceOf(msg.sender) < _value) revert();
156         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
157         balances[_to] = safeAdd(balanceOf(_to), _value);
158         emit Transfer(msg.sender, _to, _value, _data);
159         return true;
160     }
161 
162     // function that is called when transaction target is a contract
163     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
164         require(SmartContract_Allowed[_to]);
165 		
166 		if (balanceOf(msg.sender) < _value) revert();
167         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
168         balances[_to] = safeAdd(balanceOf(_to), _value);
169         emit Transfer(msg.sender, _to, _value, _data);
170         return true;
171     }
172 
173    
174     // Allow transfers if the owner provided an allowance
175     // Use SafeMath for the main logic
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
177         // Only allow transfer once Locked
178         // Once it is Locked, it is Locked forever and no one can lock again
179         require(!SC_locked);
180 		require(!frozenAccount[_from]);
181 		require(!frozenAccount[_to]);
182 		
183         // Protect against wrapping uints.
184         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
185         uint256 allowance = allowed[_from][owner];
186         require(balances[_from] >= _value && allowance >= _value);
187         balances[_to] = safeAdd(balanceOf(_to), _value);
188         balances[_from] = safeSub(balanceOf(_from), _value);
189         if (allowance < MAX_UINT256) {
190             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
191         }
192         emit Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     function approve(address _spender, uint256 _value) public returns (bool success) {
197         // Only allow transfer once unLocked
198         require(!SC_locked);
199 		require(!frozenAccount[msg.sender]);
200 		require(!frozenAccount[_spender]);
201 		
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
208 		return allowed[_owner][_spender];
209     }
210 	
211     /// Set allowance for other address and notify
212     function approveAndCall(address _spender, uint256 _value) public returns (bool success) {
213         require(!SC_locked);
214 		require(!frozenAccount[msg.sender]);
215 		require(!frozenAccount[_spender]);
216 		
217         if (approve(_spender, _value)) {
218             return true;
219         }
220     }
221 	
222 	/// Function to activate Ether reception in the smart Contract address only by the Owner
223     function () public payable { 
224 		if(msg.sender != owner) { revert(); }
225     }
226 
227 	// Creator/Owner can Locked/Unlock smart contract
228     function OWN_ChangeState_locked(bool _locked) onlyOwner public {
229         SC_locked = _locked;
230     }
231 	
232 	 /// Destroy tokens amount (Caution!!! the operation is destructive and you can not go back)
233     function OWN_burn(uint256 _value) onlyOwner public returns (bool success) {
234         require(balances[msg.sender] >= _value);
235         balances[msg.sender] -= _value;
236         totalSupply -= _value;
237         emit Burn(msg.sender, _value);
238         return true;
239     }
240 
241     /// Destroy tokens amount from another account (Caution!!! the operation is destructive and you can not go back)
242     function OWN_burnAddress(address _from, uint256 _value)  onlyOwner public returns (bool success) {
243         require(balances[_from] >= _value);
244         require(_value <= allowed[_from][owner]);
245         balances[_from] -= _value;
246         allowed[_from][msg.sender] -= _value;             
247         totalSupply -= _value;
248         emit Burn(_from, _value);
249         return true;
250     }
251 	
252 	///Generate other tokens after starting the program
253     function OWN_mintToken(uint256 mintedAmount) onlyOwner public {
254         //aggiungo i decimali al valore che imposto
255         balances[owner] += mintedAmount;
256         totalSupply += mintedAmount;
257         emit Transfer(0, this, mintedAmount);
258         emit Transfer(this, owner, mintedAmount);
259     }
260 	
261 	/// Block / Unlock address handling tokens
262     function OWN_freezeAddress(address target, bool freeze) onlyOwner public {
263         frozenAccount[target] = freeze;
264         emit FrozenFunds(target, freeze);
265     }
266 		
267 	/// Function to destroy the smart contract
268     function OWN_kill() onlyOwner public { 
269 		selfdestruct(owner); 
270     }
271 	
272 	/// Function Change Owner
273 	function OWN_transferOwnership(address newOwner) onlyOwner public {
274         // function allowed only if the address is not smart contract
275         if (!isContract(newOwner)) {	
276 			owner = newOwner;
277 		}
278     }
279 	
280 	/// Smart Contract approved
281     function OWN_SmartContract_Allowed(address target, bool _allowed) onlyOwner public {
282 		// function allowed only for smart contract
283         if (isContract(target)) {
284 			SmartContract_Allowed[target] = _allowed;
285 		}
286     }
287 	
288 	/// Distribution Token from Admin
289 	function OWN_DistributeTokenAdmin_Multi(address[] addresses, uint256 _value, bool freeze) onlyOwner public{
290 		for (uint i = 0; i < addresses.length; i++) {
291 			//Block / Unlock address handling tokens
292 			frozenAccount[addresses[i]] = freeze;
293 			emit FrozenFunds(addresses[i], freeze);
294 			
295 			bytes memory empty;
296 			if (isContract(addresses[i])) {
297 				transferToContract(addresses[i], _value, empty);
298 			} 
299 			else {
300 				transferToAddress(addresses[i], _value, empty);
301 			}
302 		}
303 	}
304 }