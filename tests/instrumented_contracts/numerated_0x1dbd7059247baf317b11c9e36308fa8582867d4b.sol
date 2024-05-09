1 pragma solidity ^0.4.17;
2 
3 /* New ERC23 contract interface */
4 /* Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended */
5 /* Fully backward compatible with ERC20 */
6 contract ERC223 {
7     uint public totalSupply;
8 
9     // ERC223 and ERC20 functions and events
10     function balanceOf(address who) public constant returns (uint);
11     function totalSupply() constant public returns (uint256 _supply);
12     function transfer(address to, uint value) public returns (bool ok);
13 
14     // ERC20 functions and events
15     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
16     function approve(address _spender, uint256 _value) returns (bool success);
17     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint _value);
20 
21     // ERC223 functions and events
22     function name() constant public returns (string _name);
23     function symbol() constant public returns (string _symbol);
24     function decimals() constant public returns (uint8 _decimals);
25 
26     function transfer(address to, uint value, bytes data) public returns (bool ok);
27     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
28     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
29 
30 }
31 
32 /**
33  * Include SafeMath Lib
34  */
35 contract SafeMath {
36     uint256 constant public MAX_UINT256 =
37     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
38 
39     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
40         if (x > MAX_UINT256 - y)
41             revert();
42         return x + y;
43     }
44 
45     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
46         if (x < y) {
47             revert();
48         }
49         return x - y;
50     }
51 
52     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
53         if (y == 0) {
54             return 0;
55         }
56         if (x > MAX_UINT256 / y) {
57             revert();
58         }
59         return x * y;
60     }
61 }
62 
63 
64 /*
65  * Contract that is working with ERC223 tokens
66  */
67  contract ContractReceiver {
68 
69     struct TKN {
70         address sender;
71         uint value;
72         bytes data;
73         bytes4 sig;
74     }
75 
76     function tokenFallback(address _from, uint _value, bytes _data) public {
77       TKN memory tkn;
78       tkn.sender = _from;
79       tkn.value = _value;
80       tkn.data = _data;
81       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
82       tkn.sig = bytes4(u);
83 
84       /* tkn variable is analogue of msg variable of Ether transaction
85       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
86       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
87       *  tkn.data is data of token transaction   (analogue of msg.data)
88       *  tkn.sig is 4 bytes signature of function
89       *  if data of token transaction is a function execution
90       */
91     }
92 }
93 
94 contract EDOGE is ERC223, SafeMath {
95 
96     string public name = "eDogecoin";
97 
98     string public symbol = "EDOGE";
99 
100     uint8 public decimals = 8;
101 
102     uint256 public totalSupply = 100000000000 * 10**8;
103 
104     address public owner;
105 
106     bool public unlocked = false;
107 
108     bool public tokenCreated = false;
109 
110     mapping(address => uint256) balances;
111 
112     mapping(address => mapping (address => uint256)) allowed;
113 
114     // Initialize to have owner have 100,000,000,000 EDOGE on contract creation
115     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
116     function EDOGE() public {
117 
118         // Security check in case EVM has future flaw or exploit to call constructor multiple times
119         // Ensure token gets created once only
120         require(tokenCreated == false);
121         tokenCreated = true;
122 
123         owner = msg.sender;
124         balances[owner] = totalSupply;
125 
126         // Final sanity check to ensure owner balance is greater than zero
127         require(balances[owner] > 0);
128     }
129 
130     modifier onlyOwner() {
131         require(msg.sender == owner);
132         _;
133     }
134 
135     // Function to distribute tokens to list of addresses by the provided amount
136     // Verify and require that:
137     // - Balance of owner cannot be negative
138     // - All transfers can be fulfilled with remaining owner balance
139     // - No new tokens can ever be minted except originally created 100,000,000,000
140     function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public {
141         // Only proceed if there are enough tokens to be distributed to all addresses
142         // Never allow balance of owner to become negative
143         require(balances[owner] >= safeMul(addresses.length, amount));
144         for (uint i = 0; i < addresses.length; i++) {
145             balances[owner] = safeSub(balanceOf(owner), amount);
146             // Another sanity check to make sure owner balance can never be negative
147             require(balances[owner] >= 0);
148             balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), amount);
149             transfer(addresses[i], amount);
150         }
151     }
152 
153     // Function to access name of token .sha
154     function name() constant public returns (string _name) {
155         return name;
156     }
157     // Function to access symbol of token .
158     function symbol() constant public returns (string _symbol) {
159         return symbol;
160     }
161     // Function to access decimals of token .
162     function decimals() constant public returns (uint8 _decimals) {
163         return decimals;
164     }
165     // Function to access total supply of tokens .
166     function totalSupply() constant public returns (uint256 _totalSupply) {
167         return totalSupply;
168     }
169 
170     // Function that is called when a user or another contract wants to transfer funds .
171     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
172 
173         // Only allow transfer once unlocked
174         // Once it is unlocked, it is unlocked forever and no one can lock again
175         require(unlocked);
176 
177         if (isContract(_to)) {
178             if (balanceOf(msg.sender) < _value) {
179                 revert();
180             }
181             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
182             balances[_to] = safeAdd(balanceOf(_to), _value);
183             ContractReceiver receiver = ContractReceiver(_to);
184             receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
185             Transfer(msg.sender, _to, _value, _data);
186             return true;
187         } else {
188             return transferToAddress(_to, _value, _data);
189         }
190     }
191 
192     // Function that is called when a user or another contract wants to transfer funds .
193     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
194 
195         // Only allow transfer once unlocked
196         // Once it is unlocked, it is unlocked forever and no one can lock again
197         require(unlocked);
198 
199         if (isContract(_to)) {
200             return transferToContract(_to, _value, _data);
201         } else {
202             return transferToAddress(_to, _value, _data);
203         }
204     }
205 
206     // Standard function transfer similar to ERC20 transfer with no _data .
207     // Added due to backwards compatibility reasons .
208     function transfer(address _to, uint _value) public returns (bool success) {
209 
210         // Only allow transfer once unlocked
211         // Once it is unlocked, it is unlocked forever and no one can lock again
212         require(unlocked);
213 
214         //standard function transfer similar to ERC20 transfer with no _data
215         //added due to backwards compatibility reasons
216         bytes memory empty;
217         if (isContract(_to)) {
218             return transferToContract(_to, _value, empty);
219         } else {
220             return transferToAddress(_to, _value, empty);
221         }
222     }
223 
224     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
225     function isContract(address _addr) private returns (bool is_contract) {
226         uint length;
227         assembly {
228             //retrieve the size of the code on target address, this needs assembly
229             length := extcodesize(_addr)
230         }
231         return (length > 0);
232     }
233 
234     // function that is called when transaction target is an address
235     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
236         if (balanceOf(msg.sender) < _value) {
237             revert();
238         }
239         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
240         balances[_to] = safeAdd(balanceOf(_to), _value);
241         Transfer(msg.sender, _to, _value, _data);
242         return true;
243     }
244 
245     //function that is called when transaction target is a contract
246     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
247         if (balanceOf(msg.sender) < _value) {
248             revert();
249         }
250         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
251         balances[_to] = safeAdd(balanceOf(_to), _value);
252         ContractReceiver receiver = ContractReceiver(_to);
253         receiver.tokenFallback(msg.sender, _value, _data);
254         Transfer(msg.sender, _to, _value, _data);
255         return true;
256     }
257 
258     // Get balance of the address provided
259     function balanceOf(address _owner) constant public returns (uint256 balance) {
260         return balances[_owner];
261     }
262 
263      // Creator/Owner can unlocked it once and it can never be locked again
264      // Use after airdrop is complete
265     function unlockForever() onlyOwner public {
266         unlocked = true;
267     }
268 
269     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
270         // Only allow transfer once unlocked
271         // Once it is unlocked, it is unlocked forever and no one can lock again
272         require(unlocked);
273         //same as above. Replace this line with the following if you want to protect against wrapping uints.
274         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
275         uint256 allowance = allowed[_from][msg.sender];
276         require(balances[_from] >= _value && allowance >= _value);
277         balances[_to] += _value;
278         balances[_from] -= _value;
279         if (allowance < MAX_UINT256) {
280             allowed[_from][msg.sender] -= _value;
281         }
282         Transfer(_from, _to, _value);
283         return true;
284     }
285 
286     function approve(address _spender, uint256 _value) public returns (bool success) {
287         allowed[msg.sender][_spender] = _value;
288         Approval(msg.sender, _spender, _value);
289         return true;
290     }
291 
292     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
293       return allowed[_owner][_spender];
294     }
295 }