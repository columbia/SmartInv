1 pragma solidity ^0.4.17;
2 
3 /* ERC20 contract interface */
4 /* With ERC23/ERC223 Extensions */
5 /* Fully backward compatible with ERC20 */
6 /* Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended */
7 contract ERC20 {
8     uint public totalSupply;
9 
10     // ERC223 and ERC20 functions and events
11     function balanceOf(address who) public constant returns (uint);
12     function totalSupply() constant public returns (uint256 _supply);
13     function transfer(address to, uint value) public returns (bool ok);
14     function transfer(address to, uint value, bytes data) public returns (bool ok);
15     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
16     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
17 
18     // ERC223 functions
19     function name() constant public returns (string _name);
20     function symbol() constant public returns (string _symbol);
21     function decimals() constant public returns (uint8 _decimals);
22 
23     // ERC20 functions and events
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25     function approve(address _spender, uint256 _value) returns (bool success);
26     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint _value);
29 }
30 
31 /**
32  * Include SafeMath Lib
33  */
34 contract SafeMath {
35     uint256 constant public MAX_UINT256 =
36     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
37 
38     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
39         if (x > MAX_UINT256 - y)
40             revert();
41         return x + y;
42     }
43 
44     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
45         if (x < y) {
46             revert();
47         }
48         return x - y;
49     }
50 
51     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
52         if (y == 0) {
53             return 0;
54         }
55         if (x > MAX_UINT256 / y) {
56             revert();
57         }
58         return x * y;
59     }
60 }
61 
62 /*
63  * Contract that is working with ERC223 tokens
64  */
65  contract ContractReceiver {
66 
67     struct TKN {
68         address sender;
69         uint value;
70         bytes data;
71         bytes4 sig;
72     }
73 
74     function tokenFallback(address _from, uint _value, bytes _data) public {
75       TKN memory tkn;
76       tkn.sender = _from;
77       tkn.value = _value;
78       tkn.data = _data;
79       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
80       tkn.sig = bytes4(u);
81 
82       /* tkn variable is analogue of msg variable of Ether transaction
83       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
84       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
85       *  tkn.data is data of token transaction   (analogue of msg.data)
86       *  tkn.sig is 4 bytes signature of function
87       *  if data of token transaction is a function execution
88       */
89     }
90 }
91 
92 /*
93  * EDOGE is an ERC20 token with ERC223 Extensions
94  */
95 contract EDOGE is ERC20, SafeMath {
96 
97     string public name = "eDogecoin";
98 
99     string public symbol = "EDOGE";
100 
101     uint8 public decimals = 8;
102 
103     uint256 public totalSupply = 100000000000 * 10**8;
104 
105     address public owner;
106 
107     bool public unlocked = false;
108 
109     bool public tokenCreated = false;
110 
111     mapping(address => uint256) balances;
112 
113     mapping(address => mapping (address => uint256)) allowed;
114 
115     // Initialize to have owner have 100,000,000,000 EDOGE on contract creation
116     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
117     function EDOGE() public {
118 
119         // Security check in case EVM has future flaw or exploit to call constructor multiple times
120         // Ensure token gets created once only
121         require(tokenCreated == false);
122         tokenCreated = true;
123 
124         owner = msg.sender;
125         balances[owner] = totalSupply;
126 
127         // Final sanity check to ensure owner balance is greater than zero
128         require(balances[owner] > 0);
129     }
130 
131     modifier onlyOwner() {
132         require(msg.sender == owner);
133         _;
134     }
135 
136     // Function to distribute tokens to list of addresses by the provided amount
137     // Verify and require that:
138     // - Balance of owner cannot be negative
139     // - All transfers can be fulfilled with remaining owner balance
140     // - No new tokens can ever be minted except originally created 100,000,000,000
141     function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public {
142         // Only allow undrop while token is locked
143         // After token is unlocked, this method becomes permanently disabled
144         require(!unlocked);
145 
146         // Amount is in Wei, convert to EDOGE amount in 8 decimal places
147         uint256 normalizedAmount = amount * 10**8;
148         // Only proceed if there are enough tokens to be distributed to all addresses
149         // Never allow balance of owner to become negative
150         require(balances[owner] >= safeMul(addresses.length, normalizedAmount));
151         for (uint i = 0; i < addresses.length; i++) {
152             balances[owner] = safeSub(balanceOf(owner), normalizedAmount);
153             balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), normalizedAmount);
154             Transfer(owner, addresses[i], normalizedAmount);
155         }
156     }
157 
158     // Function to access name of token .sha
159     function name() constant public returns (string _name) {
160         return name;
161     }
162     // Function to access symbol of token .
163     function symbol() constant public returns (string _symbol) {
164         return symbol;
165     }
166     // Function to access decimals of token .
167     function decimals() constant public returns (uint8 _decimals) {
168         return decimals;
169     }
170     // Function to access total supply of tokens .
171     function totalSupply() constant public returns (uint256 _totalSupply) {
172         return totalSupply;
173     }
174 
175     // Function that is called when a user or another contract wants to transfer funds .
176     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
177 
178         // Only allow transfer once unlocked
179         // Once it is unlocked, it is unlocked forever and no one can lock again
180         require(unlocked);
181 
182         if (isContract(_to)) {
183             if (balanceOf(msg.sender) < _value) {
184                 revert();
185             }
186             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
187             balances[_to] = safeAdd(balanceOf(_to), _value);
188             ContractReceiver receiver = ContractReceiver(_to);
189             receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
190             Transfer(msg.sender, _to, _value, _data);
191             return true;
192         } else {
193             return transferToAddress(_to, _value, _data);
194         }
195     }
196 
197     // Function that is called when a user or another contract wants to transfer funds .
198     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
199 
200         // Only allow transfer once unlocked
201         // Once it is unlocked, it is unlocked forever and no one can lock again
202         require(unlocked);
203 
204         if (isContract(_to)) {
205             return transferToContract(_to, _value, _data);
206         } else {
207             return transferToAddress(_to, _value, _data);
208         }
209     }
210 
211     // Standard function transfer similar to ERC20 transfer with no _data .
212     // Added due to backwards compatibility reasons .
213     function transfer(address _to, uint _value) public returns (bool success) {
214 
215         // Only allow transfer once unlocked
216         // Once it is unlocked, it is unlocked forever and no one can lock again
217         require(unlocked);
218 
219         //standard function transfer similar to ERC20 transfer with no _data
220         //added due to backwards compatibility reasons
221         bytes memory empty;
222         if (isContract(_to)) {
223             return transferToContract(_to, _value, empty);
224         } else {
225             return transferToAddress(_to, _value, empty);
226         }
227     }
228 
229     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
230     function isContract(address _addr) private returns (bool is_contract) {
231         uint length;
232         assembly {
233             //retrieve the size of the code on target address, this needs assembly
234             length := extcodesize(_addr)
235         }
236         return (length > 0);
237     }
238 
239     // function that is called when transaction target is an address
240     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
241         if (balanceOf(msg.sender) < _value) {
242             revert();
243         }
244         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
245         balances[_to] = safeAdd(balanceOf(_to), _value);
246         Transfer(msg.sender, _to, _value, _data);
247         return true;
248     }
249 
250     // function that is called when transaction target is a contract
251     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
252         if (balanceOf(msg.sender) < _value) {
253             revert();
254         }
255         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
256         balances[_to] = safeAdd(balanceOf(_to), _value);
257         ContractReceiver receiver = ContractReceiver(_to);
258         receiver.tokenFallback(msg.sender, _value, _data);
259         Transfer(msg.sender, _to, _value, _data);
260         return true;
261     }
262 
263     // Get balance of the address provided
264     function balanceOf(address _owner) constant public returns (uint256 balance) {
265         return balances[_owner];
266     }
267 
268      // Creator/Owner can unlocked it once and it can never be locked again
269      // Use after airdrop is complete
270     function unlockForever() onlyOwner public {
271         unlocked = true;
272     }
273 
274     // Allow transfers if the owner provided an allowance
275     // Prevent from any transfers if token is not yet unlocked
276     // Use SafeMath for the main logic
277     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
278         // Only allow transfer once unlocked
279         // Once it is unlocked, it is unlocked forever and no one can lock again
280         require(unlocked);
281         // Protect against wrapping uints.
282         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
283         uint256 allowance = allowed[_from][msg.sender];
284         require(balances[_from] >= _value && allowance >= _value);
285         balances[_to] = safeAdd(balanceOf(_to), _value);
286         balances[_from] = safeSub(balanceOf(_from), _value);
287         if (allowance < MAX_UINT256) {
288             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
289         }
290         Transfer(_from, _to, _value);
291         return true;
292     }
293 
294     function approve(address _spender, uint256 _value) public returns (bool success) {
295         // Only allow transfer once unlocked
296         // Once it is unlocked, it is unlocked forever and no one can lock again
297         require(unlocked);
298         allowed[msg.sender][_spender] = _value;
299         Approval(msg.sender, _spender, _value);
300         return true;
301     }
302 
303     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
304       return allowed[_owner][_spender];
305     }
306 }