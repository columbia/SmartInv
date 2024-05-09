1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin/token/ERC20.sol
4 
5 /*
6  * ERC20 interface
7  * see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   uint public totalSupply;
11   function balanceOf(address who) constant returns (uint);
12   function allowance(address owner, address spender) constant returns (uint);
13 
14   function transfer(address to, uint value) returns (bool ok);
15   function transferFrom(address from, address to, uint value) returns (bool ok);
16   function approve(address spender, uint value) returns (bool ok);
17   event Transfer(address indexed from, address indexed to, uint value);
18   event Approval(address indexed owner, address indexed spender, uint value);
19 }
20 
21 // File: contracts/interface/ERC223.sol
22 
23 /*
24   ERC223 additions to ERC20
25 
26   Interface wise is ERC20 + data paramenter to transfer and transferFrom.
27  */
28 
29 
30 contract ERC223 is ERC20 {
31   function transfer(address to, uint value, bytes data) returns (bool ok);
32   function transferFrom(address from, address to, uint value, bytes data) returns (bool ok);
33 }
34 
35 // File: contracts/interface/ERC223Receiver.sol
36 
37 /*
38 Base class contracts willing to accept ERC223 token transfers must conform to.
39 
40 Sender: msg.sender to the token contract, the address originating the token transfer.
41           - For user originated transfers sender will be equal to tx.origin
42           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
43 Origin: the origin address from whose balance the tokens are sent
44           - For transfer(), origin = msg.sender
45           - For transferFrom() origin = _from to token contract
46 Value is the amount of tokens sent
47 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
48 
49 From, origin and value shouldn't be trusted unless the token contract is trusted.
50 If sender == tx.origin, it is safe to trust it regardless of the token.
51 */
52 
53 contract ERC223Receiver {
54   function tokenFallback(address _sender, address _origin, uint _value, bytes _data) returns (bool ok);
55 }
56 
57 // File: zeppelin/SafeMath.sol
58 
59 /**
60  * Math operations with safety checks
61  */
62 contract SafeMath {
63   function safeMul(uint a, uint b) internal returns (uint) {
64     uint c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function safeDiv(uint a, uint b) internal returns (uint) {
70     assert(b > 0);
71     uint c = a / b;
72     assert(a == b * c + a % b);
73     return c;
74   }
75 
76   function safeSub(uint a, uint b) internal returns (uint) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function safeAdd(uint a, uint b) internal returns (uint) {
82     uint c = a + b;
83     assert(c>=a && c>=b);
84     return c;
85   }
86 
87   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
88     return a >= b ? a : b;
89   }
90 
91   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
92     return a < b ? a : b;
93   }
94 
95   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
96     return a >= b ? a : b;
97   }
98 
99   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
100     return a < b ? a : b;
101   }
102 
103   function assert(bool assertion) internal {
104     if (!assertion) {
105       throw;
106     }
107   }
108 }
109 
110 // File: zeppelin/token/StandardToken.sol
111 
112 /**
113  * Standard ERC20 token
114  *
115  * https://github.com/ethereum/EIPs/issues/20
116  * Based on code by FirstBlood:
117  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, SafeMath {
120 
121   mapping(address => uint) balances;
122   mapping (address => mapping (address => uint)) allowed;
123 
124   function transfer(address _to, uint _value) returns (bool success) {
125     balances[msg.sender] = safeSub(balances[msg.sender], _value);
126     balances[_to] = safeAdd(balances[_to], _value);
127     Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
132     var _allowance = allowed[_from][msg.sender];
133 
134     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
135     // if (_value > _allowance) throw;
136 
137     balances[_to] = safeAdd(balances[_to], _value);
138     balances[_from] = safeSub(balances[_from], _value);
139     allowed[_from][msg.sender] = safeSub(_allowance, _value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   function balanceOf(address _owner) constant returns (uint balance) {
145     return balances[_owner];
146   }
147 
148   function approve(address _spender, uint _value) returns (bool success) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   function allowance(address _owner, address _spender) constant returns (uint remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 // File: contracts/implementation/Standard223Token.sol
161 
162 /* ERC223 additions to ERC20 */
163 
164 
165 
166 
167 contract Standard223Token is ERC223, StandardToken {
168   //function that is called when a user or another contract wants to transfer funds
169   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
170     //filtering if the target is a contract with bytecode inside it
171     if (!super.transfer(_to, _value)) throw; // do a normal token transfer
172     if (isContract(_to)) return contractFallback(msg.sender, _to, _value, _data);
173     return true;
174   }
175 
176   function transferFrom(address _from, address _to, uint _value, bytes _data) returns (bool success) {
177     if (!super.transferFrom(_from, _to, _value)) throw; // do a normal token transfer
178     if (isContract(_to)) return contractFallback(_from, _to, _value, _data);
179     return true;
180   }
181 
182   function transfer(address _to, uint _value) returns (bool success) {
183     return transfer(_to, _value, new bytes(0));
184   }
185 
186   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
187     return transferFrom(_from, _to, _value, new bytes(0));
188   }
189 
190   //function that is called when transaction target is a contract
191   function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
192     ERC223Receiver reciever = ERC223Receiver(_to);
193     return reciever.tokenFallback(msg.sender, _origin, _value, _data);
194   }
195 
196   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
197   function isContract(address _addr) private returns (bool is_contract) {
198     // retrieve the size of the code on target address, this needs assembly
199     uint length;
200     assembly { length := extcodesize(_addr) }
201     return length > 0;
202   }
203 }
204 
205 // File: contracts/XNR.sol
206 
207 contract XNR is Standard223Token {
208   
209   modifier onlyOwner() {
210     require(msg.sender == owner);
211     _;
212   }
213 
214   // Requires that before a function executes either:
215   // The global isThawed value is set true
216   // The sender is in a whitelisted thawedAddress
217   // It has been a year since contract deployment
218   modifier requireThawed() {
219     require(isThawed == true || thawedAddresses[msg.sender] == true || now > thawTime);
220     _;
221   }
222 
223   // Applies to thaw functions. Only the designated manager is allowed when this modifier is present
224   modifier onlyManager() {
225     require(msg.sender == owner || msg.sender == manager);
226     _;
227   }
228 
229   address owner;
230   address manager;
231   uint initialBalance;
232   string public name;
233   string public symbol;
234   uint public decimals;
235   mapping (uint=>string) public metadata;
236   mapping (uint=>string) public publicMetadata;
237   bool isThawed = false;
238   mapping (address=>bool) public thawedAddresses;
239   uint256 thawTime;
240 
241   constructor() public {
242     address bountyMgrAddress = address(0x03de5f75915dc5382c5df82538f8d5e124a7ebb8);
243     
244     initialBalance = 18666666667 * 1e8;
245     uint256 bountyMgrBalance = 933333333 * 1e8;
246     totalSupply = initialBalance;
247 
248     balances[msg.sender] = safeSub(initialBalance, bountyMgrBalance);
249     balances[bountyMgrAddress] = bountyMgrBalance;
250 
251     Transfer(address(0x0), address(msg.sender), balances[msg.sender]);
252     Transfer(address(0x0), address(bountyMgrAddress), balances[bountyMgrAddress]);
253 
254     name = "Neuroneum";
255     symbol = "XNR";
256     decimals = 8;
257     owner = msg.sender;
258     thawedAddresses[msg.sender] = true;
259     thawedAddresses[bountyMgrAddress] = true;
260     thawTime = now + 1 years;
261   }
262 
263   // **
264   // ** Manager functions **
265   // **
266   // Thaw a specific address, allowing it to send tokens
267   function thawAddress(address _address) onlyManager {
268     thawedAddresses[_address] = true;
269   }
270   // Thaw all addresses. This is irreversible
271   function thawAllAddresses() onlyManager {
272     isThawed = true;
273   }
274   // Freeze all addresses except for those whitelisted in thawedAddresses. This is irreversible
275   // This only applies if the thawTime has not yet past.
276   function freezeAllAddresses() onlyManager {
277     isThawed = false;
278   }
279 
280   // **
281   // ** Owner functions **
282   // **
283   // Set a new owner
284   function setOwner(address _newOwner) onlyOwner {
285     owner = _newOwner;
286   }
287 
288   // Set a manager, who can unfreeze wallets as needed
289   function setManager(address _address) onlyOwner {
290     manager = _address;
291   }
292 
293   // Change the ticker symbol of the token
294   function changeSymbol(string newSymbol) onlyOwner {
295     symbol = newSymbol;
296   }
297 
298   // Change the long-form name of the token
299   function changeName(string newName) onlyOwner {
300     name = newName;
301   }
302 
303   // Set any admin level metadata needed for XNR mainnet purposes
304   function setMetadata(uint key, string value) onlyOwner {
305     metadata[key] = value;
306   }
307 
308   // **
309   // ** Public functions **
310   // **
311   // Set any public metadata needed for XNR mainnet purposes
312   function setPublicMetadata(uint key, string value) {
313     publicMetadata[key] = value;
314   }
315 
316   // Standard ERC20 transfer commands, with additional requireThawed modifier
317   function transfer(address _to, uint _value, bytes _data) requireThawed returns (bool success) {
318     return super.transfer(_to, _value, _data);
319   }
320   function transferFrom(address _from, address _to, uint _value, bytes _data) requireThawed returns (bool success) {
321     return super.transferFrom(_from, _to, _value, _data);
322   }
323   function transfer(address _to, uint _value) requireThawed returns (bool success) {
324     return super.transfer(_to, _value);
325   }
326   function transferFrom(address _from, address _to, uint _value) requireThawed returns (bool success) {
327     return super.transferFrom(_from, _to, _value);
328   }
329 
330 }