1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title ContractReceiver
5  * @dev Receiver for ERC223 tokens
6  */
7 contract ContractReceiver {
8 
9   struct TKN {
10     address sender;
11     uint value;
12     bytes data;
13     bytes4 sig;
14   }
15 
16   function tokenFallback(address _from, uint _value, bytes _data) public pure {
17     TKN memory tkn;
18     tkn.sender = _from;
19     tkn.value = _value;
20     tkn.data = _data;
21     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
22     tkn.sig = bytes4(u);
23 
24     /* tkn variable is analogue of msg variable of Ether transaction
25     *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
26     *  tkn.value the number of tokens that were sent   (analogue of msg.value)
27     *  tkn.data is data of token transaction   (analogue of msg.data)
28     *  tkn.sig is 4 bytes signature of function
29     *  if data of token transaction is a function execution
30     */
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77   /**
78   * @dev Multiplies two numbers, throws on overflow.
79   */
80   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81     if (a == 0) {
82       return 0;
83     }
84     uint256 c = a * b;
85     assert(c / a == b);
86     return c;
87   }
88 
89   /**
90   * @dev Integer division of two numbers, truncating the quotient.
91   */
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return c;
97   }
98 
99   /**
100   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   /**
108   * @dev Adds two numbers, throws on overflow.
109   */
110   function add(uint256 a, uint256 b) internal pure returns (uint256) {
111     uint256 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 contract ERC223 {
118   uint public totalSupply;
119 
120   function name() public view returns (string _name);
121   function symbol() public view returns (string _symbol);
122   function decimals() public view returns (uint8 _decimals);
123   function totalSupply() public view returns (uint256 _supply);
124   function balanceOf(address who) public view returns (uint);
125 
126   function transfer(address to, uint value) public returns (bool ok);
127   function transfer(address to, uint value, bytes data) public returns (bool ok);
128   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
129   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
130   event Transfer(address indexed _from, address indexed _to, uint256 _value);
131 }
132 
133 contract Excalibur is ERC223, Ownable {
134   using SafeMath for uint256;
135 
136   string public name = "ExcaliburCoin";
137   string public symbol = "EXC";
138   uint8 public decimals = 8;
139   uint256 public initialSupply = 10e11 * 1e8;
140   uint256 public totalSupply;
141   uint256 public distributeAmount = 0;
142   bool public mintingFinished = false;
143 
144   mapping (address => uint) balances;
145   mapping (address => bool) public frozenAccount;
146   mapping (address => uint256) public unlockUnixTime;
147 
148   event FrozenFunds(address indexed target, bool frozen);
149   event LockedFunds(address indexed target, uint256 locked);
150   event Burn(address indexed burner, uint256 value);
151   event Mint(address indexed to, uint256 amount);
152   event MintFinished();
153 
154   function Excalibur() public {
155     totalSupply = initialSupply;
156     balances[msg.sender] = totalSupply;
157   }
158 
159   function name() public view returns (string _name) {
160       return name;
161   }
162 
163   function symbol() public view returns (string _symbol) {
164       return symbol;
165   }
166 
167   function decimals() public view returns (uint8 _decimals) {
168       return decimals;
169   }
170 
171   function totalSupply() public view returns (uint256 _totalSupply) {
172       return totalSupply;
173   }
174 
175   function balanceOf(address _owner) public view returns (uint balance) {
176     return balances[_owner];
177   }
178 
179   modifier onlyPayloadSize(uint256 size){
180     assert(msg.data.length >= size + 4);
181     _;
182   }
183 
184   // Function that is called when a user or another contract wants to transfer funds .
185   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
186     require(_value > 0
187             && frozenAccount[msg.sender] == false
188             && frozenAccount[_to] == false
189             && now > unlockUnixTime[msg.sender]
190             && now > unlockUnixTime[_to]);
191 
192     if(isContract(_to)) {
193         if (balanceOf(msg.sender) < _value) revert();
194         balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
195         balances[_to] = SafeMath.add(balanceOf(_to), _value);
196         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
197         Transfer(msg.sender, _to, _value, _data);
198         Transfer(msg.sender, _to, _value);
199         return true;
200     }
201     else {
202         return transferToAddress(_to, _value, _data);
203     }
204   }
205 
206 
207   // Function that is called when a user or another contract wants to transfer funds .
208   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
209     require(_value > 0
210             && frozenAccount[msg.sender] == false
211             && frozenAccount[_to] == false
212             && now > unlockUnixTime[msg.sender]
213             && now > unlockUnixTime[_to]);
214 
215     if(isContract(_to)) {
216         return transferToContract(_to, _value, _data);
217     }
218     else {
219         return transferToAddress(_to, _value, _data);
220     }
221   }
222 
223   // Standard function transfer similar to ERC20 transfer with no _data .
224   // Added due to backwards compatibility reasons .
225   function transfer(address _to, uint _value) public returns (bool success) {
226     require(_value > 0
227             && frozenAccount[msg.sender] == false
228             && frozenAccount[_to] == false
229             && now > unlockUnixTime[msg.sender]
230             && now > unlockUnixTime[_to]);
231 
232     //standard function transfer similar to ERC20 transfer with no _data
233     //added due to backwards compatibility reasons
234     bytes memory empty;
235     if(isContract(_to)) {
236         return transferToContract(_to, _value, empty);
237     }
238     else {
239         return transferToAddress(_to, _value, empty);
240     }
241   }
242 
243   // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
244   function isContract(address _addr) private view returns (bool is_contract) {
245     uint length;
246     assembly {
247       // retrieve the size of the code on target address, this needs assembly
248       length := extcodesize(_addr)
249     }
250     return (length>0);
251   }
252 
253   // function that is called when transaction target is an address
254   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
255     if (balanceOf(msg.sender) < _value) revert();
256     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
257     balances[_to] = SafeMath.add(balanceOf(_to), _value);
258     Transfer(msg.sender, _to, _value, _data);
259     Transfer(msg.sender, _to, _value);
260     return true;
261   }
262 
263   //function that is called when transaction target is a contract
264   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
265     if (balanceOf(msg.sender) < _value) revert();
266     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
267     balances[_to] = SafeMath.add(balanceOf(_to), _value);
268     ContractReceiver receiver = ContractReceiver(_to);
269     receiver.tokenFallback(msg.sender, _value, _data);
270     Transfer(msg.sender, _to, _value, _data);
271     Transfer(msg.sender, _to, _value);
272     return true;
273   }
274 
275   /**
276    * @dev Prevent targets from sending or receiving tokens
277    * @param targets Addresses to be frozen
278    * @param isFrozen either to freeze it or not
279    */
280   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
281     require(targets.length > 0);
282 
283     for (uint i = 0; i < targets.length; i++) {
284       require(targets[i] != 0x0);
285       frozenAccount[targets[i]] = isFrozen;
286       FrozenFunds(targets[i], isFrozen);
287     }
288   }
289 
290   /**
291    * @dev Prevent targets from sending or receiving tokens by setting Unix times
292    * @param targets Addresses to be locked funds
293    * @param unixTimes Unix times when locking up will be finished
294    */
295   function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
296     require(targets.length > 0
297             && targets.length == unixTimes.length);
298 
299     for(uint i = 0; i < targets.length; i++){
300       require(unlockUnixTime[targets[i]] < unixTimes[i]);
301       unlockUnixTime[targets[i]] = unixTimes[i];
302       LockedFunds(targets[i], unixTimes[i]);
303     }
304   }
305 
306   /**
307    * @dev Burns a specific amount of tokens.
308    * @param _from The address that will burn the tokens.
309    * @param _unitAmount The amount of token to be burned.
310    */
311   function burn(address _from, uint256 _unitAmount) onlyOwner public {
312     require(_unitAmount > 0
313             && balanceOf(_from) >= _unitAmount);
314 
315     balances[_from] = SafeMath.sub(balances[_from], _unitAmount);
316     totalSupply = SafeMath.sub(totalSupply, _unitAmount);
317     Burn(_from, _unitAmount);
318   }
319 
320   modifier canMint() {
321     require(!mintingFinished);
322     _;
323   }
324 
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _unitAmount The amount of tokens to mint.
329    */
330   function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
331     require(_unitAmount > 0);
332 
333     totalSupply = SafeMath.add(totalSupply, _unitAmount);
334     balances[_to] = SafeMath.add(balances[_to], _unitAmount);
335     Mint(_to, _unitAmount);
336     Transfer(address(0), _to, _unitAmount);
337     return true;
338   }
339 
340   /**
341    * @dev Function to stop minting new tokens.
342    */
343   function finishMinting() onlyOwner canMint public returns (bool) {
344     mintingFinished = true;
345     MintFinished();
346     return true;
347   }
348 
349   /**
350    * @dev Function to distribute tokens to the list of addresses by the provided amount
351    */
352   function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {
353     require(amount > 0
354             && addresses.length > 0
355             && frozenAccount[msg.sender] == false
356             && now > unlockUnixTime[msg.sender]);
357 
358     amount = SafeMath.mul(amount, 1e8);
359     uint256 totalAmount = SafeMath.mul(amount, addresses.length);
360     require(balances[msg.sender] >= totalAmount);
361 
362     for (uint i = 0; i < addresses.length; i++) {
363       require(addresses[i] != 0x0
364               && frozenAccount[addresses[i]] == false
365               && now > unlockUnixTime[addresses[i]]);
366 
367       balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amount);
368       Transfer(msg.sender, addresses[i], amount);
369     }
370     balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
371     return true;
372   }
373 
374   /**
375    * @dev Function to collect tokens from the list of addresses
376    */
377   function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
378     require(addresses.length > 0
379             && addresses.length == amounts.length);
380 
381     uint256 totalAmount = 0;
382 
383     for (uint i = 0; i < addresses.length; i++) {
384       require(amounts[i] > 0
385               && addresses[i] != 0x0
386               && frozenAccount[addresses[i]] == false
387               && now > unlockUnixTime[addresses[i]]);
388 
389       amounts[i] = SafeMath.mul(amounts[i], 1e8);
390       require(balances[addresses[i]] >= amounts[i]);
391       balances[addresses[i]] = SafeMath.sub(balances[addresses[i]], amounts[i]);
392       totalAmount = SafeMath.add(totalAmount, amounts[i]);
393       Transfer(addresses[i], msg.sender, amounts[i]);
394     }
395     balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
396     return true;
397   }
398 
399   function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
400     distributeAmount = _unitAmount;
401   }
402 
403   /**
404    * @dev Function to distribute tokens to the msg.sender automatically
405    *      If distributeAmount is 0, this function doesn't work
406    */
407   function autoDistribute() payable public {
408     require(distributeAmount > 0
409             && balanceOf(owner) >= distributeAmount
410             && frozenAccount[msg.sender] == false
411             && now > unlockUnixTime[msg.sender]);
412     if (msg.value > 0) owner.transfer(msg.value);
413 
414     balances[owner] = SafeMath.sub(balances[owner], distributeAmount);
415     balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);
416     Transfer(owner, msg.sender, distributeAmount);
417   }
418 
419   /**
420    * @dev token fallback function
421    */
422   function() payable public {
423     autoDistribute();
424   }
425 }