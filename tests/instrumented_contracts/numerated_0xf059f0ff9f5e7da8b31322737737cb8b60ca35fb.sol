1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC223 {
5   uint public totalSupply;
6   function balanceOf(address who) public view returns (uint);
7   
8   function name() public view returns (string _name);
9   function symbol() public view returns (string _symbol);
10   function decimals() public view returns (uint256 _decimals);
11   function totalSupply() public view returns (uint256 _supply);
12 
13   function transfer(address to, uint value) public returns (bool ok);
14   function transfer(address to, uint value, bytes data) public returns (bool ok);
15   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
16   
17   event Transfer(address indexed from, address indexed to, uint value, bytes data);
18 }
19 
20 
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     if (a == 0) {
28       return 0;
29     }
30     c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     // uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return a / b;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     emit OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97 }
98 
99 
100 
101 contract ContractReceiver {
102      
103   struct TKN {
104     address sender;
105     uint value;
106     bytes data;
107     bytes4 sig;
108   }
109   
110   
111   function tokenFallback(address _from, uint _value, bytes _data) public {
112     TKN memory tkn;
113     tkn.sender = _from;
114     tkn.value = _value;
115     tkn.data = _data;
116     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
117     tkn.sig = bytes4(u);
118     
119     /* tkn variable is analogue of msg variable of Ether transaction
120     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
121     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
122     *  tkn.data is data of token transaction   (analogue of msg.data)
123     *  tkn.sig is 4 bytes signature of function
124     *  if data of token transaction is a function execution
125     */
126   }
127 }
128 
129 
130 contract ERC223Token is ERC223 {
131   using SafeMath for uint;
132 
133   mapping(address => uint) balances;
134   
135   string public name;
136   string public symbol;
137   uint256 public decimals;
138   uint256 public totalSupply;
139 
140   modifier validDestination( address to ) {
141     require(to != address(0x0));
142     _;
143   }
144   
145   
146   // Function to access name of token .
147   function name() public view returns (string _name) {
148     return name;
149   }
150   // Function to access symbol of token .
151   function symbol() public view returns (string _symbol) {
152     return symbol;
153   }
154   // Function to access decimals of token .
155   function decimals() public view returns (uint256 _decimals) {
156     return decimals;
157   }
158   // Function to access total supply of tokens .
159   function totalSupply() public view returns (uint256 _totalSupply) {
160     return totalSupply;
161   }
162   
163   
164   // Function that is called when a user or another contract wants to transfer funds .
165   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) validDestination(_to) public returns (bool success) {
166       
167     if(isContract(_to)) {
168       if (balanceOf(msg.sender) < _value) revert();
169       balances[msg.sender] = balanceOf(msg.sender).sub(_value);
170       balances[_to] = balanceOf(_to).add(_value);
171       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
172       emit Transfer(msg.sender, _to, _value, _data);
173       return true;
174     }
175     else {
176       return transferToAddress(_to, _value, _data);
177     }
178 }
179   
180 
181   // Function that is called when a user or another contract wants to transfer funds .
182   function transfer(address _to, uint _value, bytes _data) validDestination(_to) public returns (bool success) {
183       
184     if(isContract(_to)) {
185       return transferToContract(_to, _value, _data);
186     }
187     else {
188       return transferToAddress(_to, _value, _data);
189     }
190   }
191   
192   // Standard function transfer similar to ERC20 transfer with no _data .
193   // Added due to backwards compatibility reasons .
194   function transfer(address _to, uint _value) validDestination(_to) public returns (bool success) {
195       
196     //standard function transfer similar to ERC20 transfer with no _data
197     //added due to backwards compatibility reasons
198     bytes memory empty;
199     if(isContract(_to)) {
200       return transferToContract(_to, _value, empty);
201     }
202     else {
203         return transferToAddress(_to, _value, empty);
204     }
205   }
206 
207   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
208   function isContract(address _addr) private view returns (bool is_contract) {
209     uint length;
210     assembly {
211       //retrieve the size of the code on target address, this needs assembly
212       length := extcodesize(_addr)
213     }
214     return (length>0);
215   }
216 
217   //function that is called when transaction target is an address
218   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
219     if (balanceOf(msg.sender) < _value) revert();
220     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
221     balances[_to] = balanceOf(_to).add(_value);
222     emit Transfer(msg.sender, _to, _value, _data);
223     return true;
224   }
225   
226   //function that is called when transaction target is a contract
227   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
228     if (balanceOf(msg.sender) < _value) revert();
229     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
230     balances[_to] = balanceOf(_to).add(_value);
231     ContractReceiver receiver = ContractReceiver(_to);
232     receiver.tokenFallback(msg.sender, _value, _data);
233     emit Transfer(msg.sender, _to, _value, _data);
234     return true;
235 }
236 
237 
238   function balanceOf(address _owner) public view returns (uint balance) {
239     return balances[_owner];
240   }
241 }
242 
243 
244 contract ReleasableToken is ERC223Token, Ownable {
245 
246   /* The finalizer contract that allows unlift the transfer limits on this token */
247   address public releaseAgent;
248 
249   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
250   bool public released = false;
251 
252   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
253   mapping (address => bool) public transferAgents;
254 
255   /**
256   * Limit token transfer until the crowdsale is over.
257   *
258   */
259   modifier canTransfer(address _sender) {
260 
261     if(!released) {
262       require(transferAgents[_sender]);
263     }
264 
265     _;
266   }
267 
268   /**
269   * Set the contract that can call release and make the token transferable.
270   *
271   * Design choice. Allow reset the release agent to fix fat finger mistakes.
272   */
273   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
274 
275     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
276     releaseAgent = addr;
277   }
278 
279   /**
280   * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
281   */
282   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
283     transferAgents[addr] = state;
284   }
285 
286   /**
287   * One way function to release the tokens to the wild.
288   *
289   * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
290   */
291   function releaseTokenTransfer() public onlyReleaseAgent {
292     released = true;
293   }
294 
295   /** The function can be called only before or after the tokens have been releasesd */
296   modifier inReleaseState(bool releaseState) {
297     require(releaseState == released);
298     _;
299   }
300 
301   /** The function can be called only by a whitelisted release agent. */
302   modifier onlyReleaseAgent() {
303     require(msg.sender == releaseAgent);
304     _;
305   }
306 
307   function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
308     // Call StandardToken.transfer()
309     return super.transfer(_to, _value);
310   }
311 
312   function transfer(address _to, uint _value, bytes _data) public canTransfer(msg.sender) returns (bool success) {
313     // Call StandardToken.transfer()
314     return super.transfer(_to, _value, _data);
315   }
316 
317   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public canTransfer(msg.sender) returns (bool success) {
318     return super.transfer(_to, _value, _data, _custom_fallback);
319   }
320 }
321 
322 
323 contract AMLToken is ReleasableToken {
324 
325   // An event when the owner has reclaimed non-released tokens
326   event OwnerReclaim(address fromWhom, uint amount);
327 
328   constructor(string _name, string _symbol, uint _initialSupply, uint _decimals) public {
329     owner = msg.sender;
330     name = _name;
331     symbol = _symbol;
332     totalSupply = _initialSupply;
333     decimals = _decimals;
334 
335     balances[owner] = totalSupply;
336   }
337 
338   /// @dev Here the owner can reclaim the tokens from a participant if
339   ///      the token is not released yet. Refund will be handled offband.
340   /// @param fromWhom address of the participant whose tokens we want to claim
341   function transferToOwner(address fromWhom) public onlyOwner {
342     if (released) revert();
343 
344     uint amount = balanceOf(fromWhom);
345     balances[fromWhom] = balances[fromWhom].sub(amount);
346     balances[owner] = balances[owner].add(amount);
347     bytes memory empty;
348     emit Transfer(fromWhom, owner, amount, empty);
349     emit OwnerReclaim(fromWhom, amount);
350   }
351 }
352 
353 
354 contract MediarToken is AMLToken {
355 
356   uint256 public constant INITIAL_SUPPLY = 420000000 * (10 ** uint256(18));
357 
358   /**
359     * @dev Constructor that gives msg.sender all of existing tokens.
360     */
361   constructor() public 
362     AMLToken("Mediar", "MDR", INITIAL_SUPPLY, 18) {
363   }
364 }