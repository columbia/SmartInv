1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Safe maths
6 // ----------------------------------------------------------------------------
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Ownable contract
55 // ----------------------------------------------------------------------------
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 }
82 
83 /**
84  * @title Claimable
85  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
86  * This allows the new owner to accept the transfer.
87  */
88 contract Claimable is Ownable {
89   address public pendingOwner;
90 
91   event OwnershipTransferPending(address indexed owner, address indexed pendingOwner);
92 
93   /**
94    * @dev Modifier throws if called by any account other than the pendingOwner.
95    */
96   modifier onlyPendingOwner() {
97     require(msg.sender == pendingOwner);
98     _;
99   }
100 
101   /**
102    * @dev Allows the current owner to set the pendingOwner address.
103    * @param newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address newOwner) onlyOwner public {
106     require(newOwner != address(0));
107     emit OwnershipTransferPending(owner, pendingOwner);
108     pendingOwner = newOwner;
109   }
110 
111   /**
112    * @dev Allows the pendingOwner address to finalize the transfer.
113    */
114   function claimOwnership() onlyPendingOwner public {
115     emit OwnershipTransferred(owner, pendingOwner);
116     owner = pendingOwner;
117     pendingOwner = address(0);
118   }
119 }
120 
121 // ----------------------------------------------------------------------------
122 // Pausable contract
123 // ----------------------------------------------------------------------------
124 /**
125  * @title Pausable
126  * @dev Base contract which allows children to implement an emergency stop mechanism.
127  */
128 contract Pausable is Claimable {
129   event Pause();
130   event Unpause();
131 
132   bool public paused = false;
133 
134 
135   /**
136    * @dev Modifier to make a function callable only when the contract is not paused.
137    */
138   modifier whenNotPaused() {
139     require(!paused);
140     _;
141   }
142 
143   /**
144    * @dev Modifier to make a function callable only when the contract is paused.
145    */
146   modifier whenPaused() {
147     require(paused);
148     _;
149   }
150 
151   /**
152    * @dev called by the owner to pause, triggers stopped state
153    */
154   function pause() onlyOwner whenNotPaused public {
155     paused = true;
156     emit Pause();
157   }
158 
159   /**
160    * @dev called by the owner to unpause, returns to normal state
161    */
162   function unpause() onlyOwner whenPaused public {
163     paused = false;
164     emit Unpause();
165   }
166 }
167 
168 /**
169  * @title Callable
170  * @dev Extension for the Claimable contract.
171  * This allows the contract only be called by certain contract.
172  */
173 contract Callable is Claimable {
174   mapping(address => bool) public callers;
175 
176   event CallerAddressAdded(address indexed addr);
177   event CallerAddressRemoved(address indexed addr);
178 
179 
180   /**
181    * @dev Modifier throws if called by any account other than the callers or owner.
182    */
183   modifier onlyCaller() {
184     require(callers[msg.sender]);
185     _;
186   }
187 
188   /**
189    * @dev add an address to the caller list
190    * @param addr address
191    * @return true if the address was added to the caller list, false if the address was already in the caller list
192    */
193   function addAddressToCaller(address addr) onlyOwner public returns(bool success) {
194     if (!callers[addr]) {
195       callers[addr] = true;
196       emit CallerAddressAdded(addr);
197       success = true;
198     }
199   }
200 
201   /**
202    * @dev remove an address from the caller list
203    * @param addr address
204    * @return true if the address was removed from the caller list,
205    * false if the address wasn't in the caller list in the first place
206    */
207   function removeAddressFromCaller(address addr) onlyOwner public returns(bool success) {
208     if (callers[addr]) {
209       callers[addr] = false;
210       emit CallerAddressRemoved(addr);
211       success = true;
212     }
213   }
214 }
215 
216 // ----------------------------------------------------------------------------
217 // Blacklist
218 // ----------------------------------------------------------------------------
219 /**
220  * @title Blacklist
221  * @dev The Blacklist contract has a blacklist of addresses, and provides basic authorization control functions.
222  */
223 contract Blacklist is Callable {
224   mapping(address => bool) public blacklist;
225 
226   function addAddressToBlacklist(address addr) onlyCaller public returns (bool success) {
227     if (!blacklist[addr]) {
228       blacklist[addr] = true;
229       success = true;
230     }
231   }
232 
233   function removeAddressFromBlacklist(address addr) onlyCaller public returns (bool success) {
234     if (blacklist[addr]) {
235       blacklist[addr] = false;
236       success = true;
237     }
238   }
239 }
240 
241 // ----------------------------------------------------------------------------
242 // Verified
243 // ----------------------------------------------------------------------------
244 /**
245  * @title Verified
246  * @dev The Verified contract has a list of verified addresses.
247  */
248 contract Verified is Callable {
249   mapping(address => bool) public verifiedList;
250   bool public shouldVerify = true;
251 
252   function verifyAddress(address addr) onlyCaller public returns (bool success) {
253     if (!verifiedList[addr]) {
254       verifiedList[addr] = true;
255       success = true;
256     }
257   }
258 
259   function unverifyAddress(address addr) onlyCaller public returns (bool success) {
260     if (verifiedList[addr]) {
261       verifiedList[addr] = false;
262       success = true;
263     }
264   }
265 
266   function setShouldVerify(bool value) onlyCaller public returns (bool success) {
267     shouldVerify = value;
268     return true;
269   }
270 }
271 
272 // ----------------------------------------------------------------------------
273 // Allowance
274 // ----------------------------------------------------------------------------
275 /**
276  * @title Allowance
277  * @dev Storage for the Allowance List.
278  */
279 contract Allowance is Callable {
280   using SafeMath for uint256;
281 
282   mapping (address => mapping (address => uint256)) public allowanceOf;
283 
284   function addAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
285     allowanceOf[_holder][_spender] = allowanceOf[_holder][_spender].add(_value);
286   }
287 
288   function subAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
289     uint256 oldValue = allowanceOf[_holder][_spender];
290     if (_value > oldValue) {
291       allowanceOf[_holder][_spender] = 0;
292     } else {
293       allowanceOf[_holder][_spender] = oldValue.sub(_value);
294     }
295   }
296 
297   function setAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
298     allowanceOf[_holder][_spender] = _value;
299   }
300 }
301 
302 // ----------------------------------------------------------------------------
303 // Balance
304 // ----------------------------------------------------------------------------
305 /**
306  * @title Balance
307  * @dev Storage for the Balance List.
308  */
309 contract Balance is Callable {
310   using SafeMath for uint256;
311 
312   mapping (address => uint256) public balanceOf;
313 
314   uint256 public totalSupply;
315 
316   function addBalance(address _addr, uint256 _value) onlyCaller public {
317     balanceOf[_addr] = balanceOf[_addr].add(_value);
318   }
319 
320   function subBalance(address _addr, uint256 _value) onlyCaller public {
321     balanceOf[_addr] = balanceOf[_addr].sub(_value);
322   }
323 
324   function setBalance(address _addr, uint256 _value) onlyCaller public {
325     balanceOf[_addr] = _value;
326   }
327 
328   function addTotalSupply(uint256 _value) onlyCaller public {
329     totalSupply = totalSupply.add(_value);
330   }
331 
332   function subTotalSupply(uint256 _value) onlyCaller public {
333     totalSupply = totalSupply.sub(_value);
334   }
335 }
336 
337 // ----------------------------------------------------------------------------
338 // UserContract
339 // ----------------------------------------------------------------------------
340 /**
341  * @title UserContract
342  * @dev A contract for the blacklist and verified list modifiers.
343  */
344 contract UserContract {
345   Blacklist internal _blacklist;
346   Verified internal _verifiedList;
347 
348   constructor(
349     Blacklist _blacklistContract, Verified _verifiedListContract
350   ) public {
351     _blacklist = _blacklistContract;
352     _verifiedList = _verifiedListContract;
353   }
354 
355 
356   /**
357    * @dev Throws if the given address is blacklisted.
358    */
359   modifier onlyNotBlacklistedAddr(address addr) {
360     require(!_blacklist.blacklist(addr));
361     _;
362   }
363 
364   /**
365    * @dev Throws if one of the given addresses is blacklisted.
366    */
367   modifier onlyNotBlacklistedAddrs(address[] addrs) {
368     for (uint256 i = 0; i < addrs.length; i++) {
369       require(!_blacklist.blacklist(addrs[i]));
370     }
371     _;
372   }
373 
374   /**
375    * @dev Throws if the given address is not verified.
376    */
377   modifier onlyVerifiedAddr(address addr) {
378     if (_verifiedList.shouldVerify()) {
379       require(_verifiedList.verifiedList(addr));
380     }
381     _;
382   }
383 
384   /**
385    * @dev Throws if one of the given addresses is not verified.
386    */
387   modifier onlyVerifiedAddrs(address[] addrs) {
388     if (_verifiedList.shouldVerify()) {
389       for (uint256 i = 0; i < addrs.length; i++) {
390         require(_verifiedList.verifiedList(addrs[i]));
391       }
392     }
393     _;
394   }
395 
396   function blacklist(address addr) public view returns (bool) {
397     return _blacklist.blacklist(addr);
398   }
399 
400   function verifiedlist(address addr) public view returns (bool) {
401     return _verifiedList.verifiedList(addr);
402   }
403 }
404 
405 // ----------------------------------------------------------------------------
406 // ContractInterface
407 // ----------------------------------------------------------------------------
408 contract ContractInterface {
409   function totalSupply() public view returns (uint256);
410   function balanceOf(address tokenOwner) public view returns (uint256);
411   function allowance(address tokenOwner, address spender) public view returns (uint256);
412   function transfer(address to, uint256 value) public returns (bool);
413   function approve(address spender, uint256 value) public returns (bool);
414   function transferFrom(address from, address to, uint256 value) public returns (bool);
415   function batchTransfer(address[] to, uint256 value) public returns (bool);
416   function increaseApproval(address spender, uint256 value) public returns (bool);
417   function decreaseApproval(address spender, uint256 value) public returns (bool);
418   function burn(uint256 value) public returns (bool);
419 
420   event Transfer(address indexed from, address indexed to, uint256 value);
421   event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
422   // This notifies clients about the amount burnt
423   event Burn(address indexed from, uint256 value);
424 }
425 
426 // ----------------------------------------------------------------------------
427 // USDO contract
428 // ----------------------------------------------------------------------------
429 contract USDO is ContractInterface, Pausable, UserContract {
430   using SafeMath for uint256;
431 
432   // variables of the token
433   uint8 public constant decimals = 18;
434   uint256 constant maxBatch = 100;
435 
436   string public name;
437   string public symbol;
438 
439   Balance internal _balances;
440   Allowance internal _allowance;
441 
442   constructor(string _tokenName, string _tokenSymbol,
443     Balance _balanceContract, Allowance _allowanceContract,
444     Blacklist _blacklistContract, Verified _verifiedListContract
445   ) UserContract(_blacklistContract, _verifiedListContract) public {
446     name = _tokenName;                                        // Set the name for display purposes
447     symbol = _tokenSymbol;                                    // Set the symbol for display purposes
448     _balances = _balanceContract;
449     _allowance = _allowanceContract;
450   }
451 
452   function totalSupply() public view returns (uint256) {
453     return _balances.totalSupply();
454   }
455 
456   function balanceOf(address _addr) public view returns (uint256) {
457     return _balances.balanceOf(_addr);
458   }
459 
460   /**
461    * @dev Function to check the amount of tokens that an owner allowed to a spender.
462    * @param _owner address The address which owns the funds.
463    * @param _spender address The address which will spend the funds.
464    * @return A uint256 specifying the amount of tokens still available for the spender.
465    */
466   function allowance(address _owner, address _spender) public view returns (uint256) {
467     return _allowance.allowanceOf(_owner, _spender);
468   }
469 
470   /**
471    *  @dev Internal transfer, only can be called by this contract
472    */
473   function _transfer(address _from, address _to, uint256 _value) internal {
474     require(_value > 0);                                               // transfering value must be greater than 0
475     require(_to != 0x0);                                               // Prevent transfer to 0x0 address. Use burn() instead
476     require(_balances.balanceOf(_from) >= _value);                     // Check if the sender has enough
477     uint256 previousBalances = _balances.balanceOf(_from).add(_balances.balanceOf(_to)); // Save this for an assertion in the future
478     _balances.subBalance(_from, _value);                 // Subtract from the sender
479     _balances.addBalance(_to, _value);                     // Add the same to the recipient
480     emit Transfer(_from, _to, _value);
481     // Asserts are used to use static analysis to find bugs in your code. They should never fail
482     assert(_balances.balanceOf(_from) + _balances.balanceOf(_to) == previousBalances);
483   }
484 
485   /**
486    * @dev Transfer tokens
487    * Send `_value` tokens to `_to` from your account
488    *
489    * @param _to The address of the recipient
490    * @param _value the amount to send
491    */
492   function transfer(address _to, uint256 _value)
493   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_to) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_to)
494   public returns (bool) {
495     _transfer(msg.sender, _to, _value);
496     return true;
497   }
498 
499 
500   /**
501    * @dev Transfer tokens to multiple accounts
502    * Send `_value` tokens to all addresses in `_to` from your account
503    *
504    * @param _to The addresses of the recipients
505    * @param _value the amount to send
506    */
507   function batchTransfer(address[] _to, uint256 _value)
508   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddrs(_to) onlyVerifiedAddr(msg.sender) onlyVerifiedAddrs(_to)
509   public returns (bool) {
510     uint256 cnt = uint256(_to.length);
511     require(cnt > 0 && cnt <= maxBatch && _value > 0);
512     uint256 amount = _value.mul(cnt);
513     require(_balances.balanceOf(msg.sender) >= amount);
514 
515     for (uint256 i = 0; i < cnt; i++) {
516       _transfer(msg.sender, _to[i], _value);
517     }
518     return true;
519   }
520 
521   /**
522    * @dev Transfer tokens from other address
523    * Send `_value` tokens to `_to` in behalf of `_from`
524    *
525    * @param _from The address of the sender
526    * @param _to The address of the recipient
527    * @param _value the amount to send
528    */
529   function transferFrom(address _from, address _to, uint256 _value)
530   whenNotPaused onlyNotBlacklistedAddr(_from) onlyNotBlacklistedAddr(_to) onlyVerifiedAddr(_from) onlyVerifiedAddr(_to)
531   public returns (bool) {
532     require(_allowance.allowanceOf(_from, msg.sender) >= _value);     // Check allowance
533     _allowance.subAllowance(_from, msg.sender, _value);
534     _transfer(_from, _to, _value);
535     return true;
536   }
537 
538   /**
539    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
540    *
541    * Beware that changing an allowance with this method brings the risk that someone may use both the old
542    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
543    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
544    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
545    * @param _spender The address which will spend the funds.
546    * @param _value The amount of tokens to be spent.
547    *
548    * Allows `_spender` to spend no more than `_value` tokens in your behalf
549    *
550    * @param _spender The address authorized to spend
551    * @param _value the max amount they can spend
552    */
553   function approve(address _spender, uint256 _value)
554   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_spender)
555   public returns (bool) {
556     _allowance.setAllowance(msg.sender, _spender, _value);
557     emit Approval(msg.sender, _spender, _value);
558     return true;
559   }
560 
561   /**
562    * @dev Increase the amount of tokens that an owner allowed to a spender.
563    *
564    * approve should be called when allowed[_spender] == 0. To increment
565    * allowed value is better to use this function to avoid 2 calls (and wait until
566    * the first transaction is mined)
567    * From MonolithDAO Token.sol
568    * @param _spender The address which will spend the funds.
569    * @param _addedValue The amount of tokens to increase the allowance by.
570    */
571   function increaseApproval(address _spender, uint256 _addedValue)
572   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_spender)
573   public returns (bool) {
574     _allowance.addAllowance(msg.sender, _spender, _addedValue);
575     emit Approval(msg.sender, _spender, _allowance.allowanceOf(msg.sender, _spender));
576     return true;
577   }
578 
579   /**
580    * @dev Decrease the amount of tokens that an owner allowed to a spender.
581    *
582    * approve should be called when allowed[_spender] == 0. To decrement
583    * allowed value is better to use this function to avoid 2 calls (and wait until
584    * the first transaction is mined)
585    * From MonolithDAO Token.sol
586    * @param _spender The address which will spend the funds.
587    * @param _subtractedValue The amount of tokens to decrease the allowance by.
588    */
589   function decreaseApproval(address _spender, uint256 _subtractedValue)
590   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_spender)
591   public returns (bool) {
592     _allowance.subAllowance(msg.sender, _spender, _subtractedValue);
593     emit Approval(msg.sender, _spender, _allowance.allowanceOf(msg.sender, _spender));
594     return true;
595   }
596 
597   /**
598    * @dev Destroy tokens
599    * Remove `_value` tokens from the system irreversibly
600    *
601    * @param _value the amount of money to burn
602    */
603   function burn(uint256 _value) whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyVerifiedAddr(msg.sender)
604   public returns (bool success) {
605     require(_balances.balanceOf(msg.sender) >= _value);         // Check if the sender has enough
606     _balances.subBalance(msg.sender, _value);                   // Subtract from the sender
607     _balances.subTotalSupply(_value);                           // Updates totalSupply
608     emit Burn(msg.sender, _value);
609     return true;
610   }
611 
612   /**
613    * @dev Change name and symbol of the tokens
614    *
615    * @param _name the new name of the token
616    * @param _symbol the new symbol of the token
617    */
618   function changeName(string _name, string _symbol) onlyOwner whenNotPaused public {
619     name = _name;
620     symbol = _symbol;
621   }
622 }