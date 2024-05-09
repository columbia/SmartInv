1 pragma solidity ^0.4.19;
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
130 }
131 
132 contract INZEI is ERC223, Ownable {
133   using SafeMath for uint256;
134 
135   string public name = "INZEI";
136   string public symbol = "INZ";
137   uint8 public decimals = 8;
138   uint256 public initialSupply = 10e9 * 1e8;
139   uint256 public totalSupply;
140   uint256 public distributeAmount = 0;
141   bool public mintingFinished = false;
142   
143   mapping (address => uint) balances;
144   mapping (address => bool) public frozenAccount;
145   mapping (address => uint256) public unlockUnixTime;
146 
147   event FrozenFunds(address indexed target, bool frozen);
148   event LockedFunds(address indexed target, uint256 locked);
149   event Burn(address indexed burner, uint256 value);
150   event Mint(address indexed to, uint256 amount);
151   event MintFinished();
152 
153   function INZEI() public {
154     totalSupply = initialSupply;
155     balances[msg.sender] = totalSupply;
156   }
157 
158   function name() public view returns (string _name) {
159       return name;
160   }
161 
162   function symbol() public view returns (string _symbol) {
163       return symbol;
164   }
165 
166   function decimals() public view returns (uint8 _decimals) {
167       return decimals;
168   }
169 
170   function totalSupply() public view returns (uint256 _totalSupply) {
171       return totalSupply;
172   }
173 
174   function balanceOf(address _owner) public view returns (uint balance) {
175     return balances[_owner];
176   }
177 
178   modifier onlyPayloadSize(uint256 size){
179     assert(msg.data.length >= size + 4);
180     _;
181   }
182 
183   // Function that is called when a user or another contract wants to transfer funds .
184   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
185     require(_value > 0
186             && frozenAccount[msg.sender] == false
187             && frozenAccount[_to] == false
188             && now > unlockUnixTime[msg.sender]
189             && now > unlockUnixTime[_to]);
190 
191     if(isContract(_to)) {
192         if (balanceOf(msg.sender) < _value) revert();
193         balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
194         balances[_to] = SafeMath.add(balanceOf(_to), _value);
195         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
196         Transfer(msg.sender, _to, _value, _data);
197         return true;
198     }
199     else {
200         return transferToAddress(_to, _value, _data);
201     }
202   }
203 
204 
205   // Function that is called when a user or another contract wants to transfer funds .
206   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
207     require(_value > 0
208             && frozenAccount[msg.sender] == false
209             && frozenAccount[_to] == false
210             && now > unlockUnixTime[msg.sender]
211             && now > unlockUnixTime[_to]);
212 
213     if(isContract(_to)) {
214         return transferToContract(_to, _value, _data);
215     }
216     else {
217         return transferToAddress(_to, _value, _data);
218     }
219   }
220 
221   // Standard function transfer similar to ERC20 transfer with no _data .
222   // Added due to backwards compatibility reasons .
223   function transfer(address _to, uint _value) public returns (bool success) {
224     require(_value > 0
225             && frozenAccount[msg.sender] == false
226             && frozenAccount[_to] == false
227             && now > unlockUnixTime[msg.sender]
228             && now > unlockUnixTime[_to]);
229 
230     //standard function transfer similar to ERC20 transfer with no _data
231     //added due to backwards compatibility reasons
232     bytes memory empty;
233     if(isContract(_to)) {
234         return transferToContract(_to, _value, empty);
235     }
236     else {
237         return transferToAddress(_to, _value, empty);
238     }
239   }
240 
241   // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
242   function isContract(address _addr) private view returns (bool is_contract) {
243     uint length;
244     assembly {
245       // retrieve the size of the code on target address, this needs assembly
246       length := extcodesize(_addr)
247     }
248     return (length>0);
249   }
250 
251   // function that is called when transaction target is an address
252   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
253     if (balanceOf(msg.sender) < _value) revert();
254     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
255     balances[_to] = SafeMath.add(balanceOf(_to), _value);
256     Transfer(msg.sender, _to, _value, _data);
257     return true;
258   }
259 
260   //function that is called when transaction target is a contract
261   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
262     if (balanceOf(msg.sender) < _value) revert();
263     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
264     balances[_to] = SafeMath.add(balanceOf(_to), _value);
265     ContractReceiver receiver = ContractReceiver(_to);
266     receiver.tokenFallback(msg.sender, _value, _data);
267     Transfer(msg.sender, _to, _value, _data);
268     return true;
269   }
270 
271   /**
272    * @dev Prevent targets from sending or receiving tokens
273    * @param targets Addresses to be frozen
274    * @param isFrozen either to freeze it or not
275    */
276   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
277     require(targets.length > 0);
278 
279     for (uint i = 0; i < targets.length; i++) {
280       require(targets[i] != 0x0);
281       frozenAccount[targets[i]] = isFrozen;
282       FrozenFunds(targets[i], isFrozen);
283     }
284   }
285 
286   /**
287    * @dev Prevent targets from sending or receiving tokens by setting Unix times
288    * @param targets Addresses to be locked funds
289    * @param unixTimes Unix times when locking up will be finished
290    */
291   function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
292     require(targets.length > 0
293             && targets.length == unixTimes.length);
294 
295     for(uint i = 0; i < targets.length; i++){
296       require(unlockUnixTime[targets[i]] < unixTimes[i]);
297       unlockUnixTime[targets[i]] = unixTimes[i];
298       LockedFunds(targets[i], unixTimes[i]);
299     }
300   }
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param _from The address that will burn the tokens.
305    * @param _unitAmount The amount of token to be burned.
306    */
307   function burn(address _from, uint256 _unitAmount) onlyOwner public {
308     require(_unitAmount > 0
309             && balanceOf(_from) >= _unitAmount);
310 
311     balances[_from] = SafeMath.sub(balances[_from], _unitAmount);
312     totalSupply = SafeMath.sub(totalSupply, _unitAmount);
313     Burn(_from, _unitAmount);
314   }
315 
316   modifier canMint() {
317     require(!mintingFinished);
318     _;
319   }
320 
321   /**
322    * @dev Function to mint tokens
323    * @param _to The address that will receive the minted tokens.
324    * @param _unitAmount The amount of tokens to mint.
325    */
326   function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
327     require(_unitAmount > 0);
328 
329     totalSupply = SafeMath.add(totalSupply, _unitAmount);
330     balances[_to] = SafeMath.add(balances[_to], _unitAmount);
331     Mint(_to, _unitAmount);
332     bytes memory empty;
333     Transfer(address(0), _to, _unitAmount, empty);
334     return true;
335   }
336 
337   /**
338    * @dev Function to stop minting new tokens.
339    */
340   function finishMinting() onlyOwner canMint public returns (bool) {
341     mintingFinished = true;
342     MintFinished();
343     return true;
344   }
345 
346   /**
347    * @dev Function to distribute tokens to the list of addresses by the provided amount
348    */
349   function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {
350     require(amount > 0
351             && addresses.length > 0
352             && frozenAccount[msg.sender] == false
353             && now > unlockUnixTime[msg.sender]);
354 
355     amount = SafeMath.mul(amount, 1e8);
356     uint256 totalAmount = SafeMath.mul(amount, addresses.length);
357     require(balances[msg.sender] >= totalAmount);
358 
359     bytes memory empty;
360     for (uint i = 0; i < addresses.length; i++) {
361       require(addresses[i] != 0x0
362               && frozenAccount[addresses[i]] == false
363               && now > unlockUnixTime[addresses[i]]);
364 
365       balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amount);
366       Transfer(msg.sender, addresses[i], amount, empty);
367     }
368     balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
369     return true;
370   }
371 
372   /**
373    * @dev Function to collect tokens from the list of addresses
374    */
375   function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
376     require(addresses.length > 0
377             && addresses.length == amounts.length);
378 
379     uint256 totalAmount = 0;
380 
381     bytes memory empty;
382     for (uint i = 0; i < addresses.length; i++) {
383       require(amounts[i] > 0
384               && addresses[i] != 0x0
385               && frozenAccount[addresses[i]] == false
386               && now > unlockUnixTime[addresses[i]]);
387 
388       amounts[i] = SafeMath.mul(amounts[i], 1e8);
389       require(balances[addresses[i]] >= amounts[i]);
390       balances[addresses[i]] = SafeMath.sub(balances[addresses[i]], amounts[i]);
391       totalAmount = SafeMath.add(totalAmount, amounts[i]);
392       Transfer(addresses[i], msg.sender, amounts[i], empty);
393     }
394     balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
395     return true;
396   }
397 
398   function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
399     distributeAmount = _unitAmount;
400   }
401 
402   /**
403    * @dev Function to distribute tokens to the msg.sender automatically
404    *      If distributeAmount is 0, this function doesn't work
405    */
406   function autoDistribute() payable public {
407     require(distributeAmount > 0
408             && balanceOf(owner) >= distributeAmount
409             && frozenAccount[msg.sender] == false
410             && now > unlockUnixTime[msg.sender]);
411     if (msg.value > 0) owner.transfer(msg.value);
412     
413     bytes memory empty;
414     balances[owner] = SafeMath.sub(balances[owner], distributeAmount);
415     balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);
416     Transfer(owner, msg.sender, distributeAmount, empty);
417   }
418 
419   /**
420    * @dev token fallback function
421    */
422   function() payable public {
423     autoDistribute();
424   }
425 }