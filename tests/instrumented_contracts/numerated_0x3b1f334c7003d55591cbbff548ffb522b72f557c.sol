1 pragma solidity ^0.4.21;
2 
3 /* ERC20 contract interface */
4 /* With ERC23/ERC223 Extensions */
5 /* Fully backward compatible with ERC20 */
6 /* Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended */
7 
8 contract ERC20 {
9     uint public totalSupply;
10 
11     // ERC223 and ERC20 functions and events
12     function balanceOf(address who) public constant returns (uint);
13     function totalSupply() constant public returns (uint256 _supply);
14     function transfer(address to, uint value) public returns (bool ok);
15     function transfer(address to, uint value, bytes data) public returns (bool ok);
16     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
17     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
18 
19     // ERC223 functions
20     function name() constant public returns (string _name);
21     function symbol() constant public returns (string _symbol);
22     function decimals() constant public returns (uint8 _decimals);
23 
24     // ERC20 functions and events
25     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
26     function approve(address _spender, uint256 _value) returns (bool success);
27     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint _value);
30 }
31 
32 /**
33  * Include SafeMath Lib
34  */
35  
36 contract SafeMath {
37     uint256 constant public MAX_UINT256 =
38     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
39 
40     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
41         if (x > MAX_UINT256 - y)
42             revert();
43         return x + y;
44     }
45 
46     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
47         if (x < y) {
48             revert();
49         }
50         return x - y;
51     }
52 
53     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
54         if (y == 0) {
55             return 0;
56         }
57         if (x > MAX_UINT256 / y) {
58             revert();
59         }
60         return x * y;
61     }
62 }
63 
64 /*
65  * Contract that is working with ERC223 tokens
66  */
67  
68  contract ContractReceiver {
69 
70     struct TKN {
71         address sender;
72         uint value;
73         bytes data;
74         bytes4 sig;
75     }
76 
77     function tokenFallback(address _from, uint _value, bytes _data) public {
78       TKN memory tkn;
79       tkn.sender = _from;
80       tkn.value = _value;
81       tkn.data = _data;
82       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
83       tkn.sig = bytes4(u);
84 
85       /* tkn variable is analogue of msg variable of Ether transaction
86       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
87       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
88       *  tkn.data is data of token transaction   (analogue of msg.data)
89       *  tkn.sig is 4 bytes signature of function
90       *  if data of token transaction is a function execution
91       */
92     }
93 }
94 
95 /*
96  * Pharamore is an ERC20 token with ERC223 Extensions
97  */
98 contract Pharamore is ERC20, SafeMath {
99 
100     string public name = "Pharamore";
101 
102     string public symbol = "MORE";
103 
104     uint8 public decimals = 8;
105 
106     uint256 public totalSupply = 950000 * 10**8;
107 
108     address public owner;
109 
110     bool public unlocked = false;
111 
112     bool public tokenCreated = false;
113 
114     mapping(address => uint256) balances;
115 
116     mapping(address => mapping (address => uint256)) allowed;
117 
118 
119     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
120 	
121     function Pharamore() public {
122 
123         // Security check in case EVM has future flaw or exploit to call constructor multiple times
124         // Ensure token gets created once only
125         require(tokenCreated == false);
126         tokenCreated = true;
127 
128         owner = msg.sender;
129         balances[owner] = totalSupply;
130 
131         // Final sanity check to ensure owner balance is greater than zero
132         require(balances[owner] > 0);
133     }
134 
135     modifier onlyOwner() {
136         require(msg.sender == owner);
137         _;
138     }
139 
140     // Function to distribute tokens to list of addresses by the provided amount
141     // Verify and require that:
142     // - Balance of owner cannot be negative
143     // - All transfers can be fulfilled with remaining owner balance
144     // - No new tokens can ever be minted except originally created 100,000,000,000
145 	
146     function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public {
147         // Only allow undrop while token is locked
148         // After token is unlocked, this method becomes permanently disabled
149         require(!unlocked);
150 
151         uint256 normalizedAmount = amount * 10**8;
152 		
153         // Only proceed if there are enough tokens to be distributed to all addresses
154         // Never allow balance of owner to become negative
155 		
156         require(balances[owner] >= safeMul(addresses.length, normalizedAmount));
157         for (uint i = 0; i < addresses.length; i++) {
158             balances[owner] = safeSub(balanceOf(owner), normalizedAmount);
159             balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), normalizedAmount);
160             Transfer(owner, addresses[i], normalizedAmount);
161         }
162     }
163 
164     // Function to access name of token .sha
165     function name() constant public returns (string _name) {
166         return name;
167     }
168     // Function to access symbol of token .
169     function symbol() constant public returns (string _symbol) {
170         return symbol;
171     }
172     // Function to access decimals of token .
173     function decimals() constant public returns (uint8 _decimals) {
174         return decimals;
175     }
176     // Function to access total supply of tokens .
177     function totalSupply() constant public returns (uint256 _totalSupply) {
178         return totalSupply;
179     }
180 
181     // Function that is called when a user or another contract wants to transfer funds .
182     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
183 
184         // Only allow transfer once unlocked
185         // Once it is unlocked, it is unlocked forever and no one can lock again
186         require(unlocked);
187 
188         if (isContract(_to)) {
189             if (balanceOf(msg.sender) < _value) {
190                 revert();
191             }
192             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
193             balances[_to] = safeAdd(balanceOf(_to), _value);
194             ContractReceiver receiver = ContractReceiver(_to);
195             receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
196             Transfer(msg.sender, _to, _value, _data);
197             return true;
198         } else {
199             return transferToAddress(_to, _value, _data);
200         }
201     }
202 
203     // Function that is called when a user or another contract wants to transfer funds .
204     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
205 
206         // Only allow transfer once unlocked
207         // Once it is unlocked, it is unlocked forever and no one can lock again
208         require(unlocked);
209 
210         if (isContract(_to)) {
211             return transferToContract(_to, _value, _data);
212         } else {
213             return transferToAddress(_to, _value, _data);
214         }
215     }
216 
217     // Standard function transfer similar to ERC20 transfer with no _data .
218     // Added due to backwards compatibility reasons .
219     function transfer(address _to, uint _value) public returns (bool success) {
220 
221         // Only allow transfer once unlocked
222         // Once it is unlocked, it is unlocked forever and no one can lock again
223         require(unlocked);
224 
225         //standard function transfer similar to ERC20 transfer with no _data
226         //added due to backwards compatibility reasons
227         bytes memory empty;
228         if (isContract(_to)) {
229             return transferToContract(_to, _value, empty);
230         } else {
231             return transferToAddress(_to, _value, empty);
232         }
233     }
234 
235     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
236     function isContract(address _addr) private returns (bool is_contract) {
237         uint length;
238         assembly {
239             //retrieve the size of the code on target address, this needs assembly
240             length := extcodesize(_addr)
241         }
242         return (length > 0);
243     }
244 
245     // function that is called when transaction target is an address
246     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
247         if (balanceOf(msg.sender) < _value) {
248             revert();
249         }
250         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
251         balances[_to] = safeAdd(balanceOf(_to), _value);
252         Transfer(msg.sender, _to, _value, _data);
253         return true;
254     }
255 
256     // function that is called when transaction target is a contract
257     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
258         if (balanceOf(msg.sender) < _value) {
259             revert();
260         }
261         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
262         balances[_to] = safeAdd(balanceOf(_to), _value);
263         ContractReceiver receiver = ContractReceiver(_to);
264         receiver.tokenFallback(msg.sender, _value, _data);
265         Transfer(msg.sender, _to, _value, _data);
266         return true;
267     }
268 
269     // Get balance of the address provided
270     function balanceOf(address _owner) constant public returns (uint256 balance) {
271         return balances[_owner];
272     }
273 
274      // Creator/Owner can unlocked it once and it can never be locked again
275      // Use after airdrop is complete
276     function unlockForever() onlyOwner public {
277         unlocked = true;
278     }
279 
280     // Allow transfers if the owner provided an allowance
281     // Prevent from any transfers if token is not yet unlocked
282     // Use SafeMath for the main logic
283     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
284         // Only allow transfer once unlocked
285         // Once it is unlocked, it is unlocked forever and no one can lock again
286         require(unlocked);
287         // Protect against wrapping uints.
288         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
289         uint256 allowance = allowed[_from][msg.sender];
290         require(balances[_from] >= _value && allowance >= _value);
291         balances[_to] = safeAdd(balanceOf(_to), _value);
292         balances[_from] = safeSub(balanceOf(_from), _value);
293         if (allowance < MAX_UINT256) {
294             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
295         }
296         Transfer(_from, _to, _value);
297         return true;
298     }
299 
300     function approve(address _spender, uint256 _value) public returns (bool success) {
301         // Only allow transfer once unlocked
302         // Once it is unlocked, it is unlocked forever and no one can lock again
303         require(unlocked);
304         allowed[msg.sender][_spender] = _value;
305         Approval(msg.sender, _spender, _value);
306         return true;
307     }
308 
309     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
310       return allowed[_owner][_spender];
311     }
312 }