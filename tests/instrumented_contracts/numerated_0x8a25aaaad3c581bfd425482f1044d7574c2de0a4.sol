1 pragma solidity ^0.4.25;
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
168 // ----------------------------------------------------------------------------
169 // Administratable contract
170 // ----------------------------------------------------------------------------
171 /**
172  * @title Administratable
173  * @dev The Admin contract has the list of admin addresses.
174  */
175 contract Administratable is Claimable {
176   struct MintStruct {
177     uint256 mintedTotal;
178     uint256 lastMintTimestamp;
179   }
180 
181   struct BurnStruct {
182     uint256 burntTotal;
183     uint256 lastBurnTimestamp;
184   }
185 
186   mapping(address => bool) public admins;
187   mapping(address => MintStruct) public mintLimiter;
188   mapping(address => BurnStruct) public burnLimiter;
189 
190   event AdminAddressAdded(address indexed addr);
191   event AdminAddressRemoved(address indexed addr);
192 
193 
194   /**
195    * @dev Throws if called by any account that's not admin or owner.
196    */
197   modifier onlyAdmin() {
198     require(admins[msg.sender] || msg.sender == owner);
199     _;
200   }
201 
202   /**
203    * @dev add an address to the admin list
204    * @param addr address
205    * @return true if the address was added to the admin list, false if the address was already in the admin list
206    */
207   function addAddressToAdmin(address addr) onlyOwner public returns(bool success) {
208     if (!admins[addr]) {
209       admins[addr] = true;
210       mintLimiter[addr] = MintStruct(0, 0);
211       burnLimiter[addr] = BurnStruct(0, 0);
212       emit AdminAddressAdded(addr);
213       success = true;
214     }
215   }
216 
217   /**
218    * @dev remove an address from the admin list
219    * @param addr address
220    * @return true if the address was removed from the admin list,
221    * false if the address wasn't in the admin list in the first place
222    */
223   function removeAddressFromAdmin(address addr) onlyOwner public returns(bool success) {
224     if (admins[addr]) {
225       admins[addr] = false;
226       delete mintLimiter[addr];
227       delete burnLimiter[addr];
228       emit AdminAddressRemoved(addr);
229       success = true;
230     }
231   }
232 }
233 /**
234  * @title Callable
235  * @dev Extension for the Claimable contract.
236  * This allows the contract only be called by certain contract.
237  */
238 contract Callable is Claimable {
239   mapping(address => bool) public callers;
240 
241   event CallerAddressAdded(address indexed addr);
242   event CallerAddressRemoved(address indexed addr);
243 
244 
245   /**
246    * @dev Modifier throws if called by any account other than the callers or owner.
247    */
248   modifier onlyCaller() {
249     require(callers[msg.sender]);
250     _;
251   }
252 
253   /**
254    * @dev add an address to the caller list
255    * @param addr address
256    * @return true if the address was added to the caller list, false if the address was already in the caller list
257    */
258   function addAddressToCaller(address addr) onlyOwner public returns(bool success) {
259     if (!callers[addr]) {
260       callers[addr] = true;
261       emit CallerAddressAdded(addr);
262       success = true;
263     }
264   }
265 
266   /**
267    * @dev remove an address from the caller list
268    * @param addr address
269    * @return true if the address was removed from the caller list,
270    * false if the address wasn't in the caller list in the first place
271    */
272   function removeAddressFromCaller(address addr) onlyOwner public returns(bool success) {
273     if (callers[addr]) {
274       callers[addr] = false;
275       emit CallerAddressRemoved(addr);
276       success = true;
277     }
278   }
279 }
280 
281 // ----------------------------------------------------------------------------
282 // Blacklist
283 // ----------------------------------------------------------------------------
284 /**
285  * @title Blacklist
286  * @dev The Blacklist contract has a blacklist of addresses, and provides basic authorization control functions.
287  */
288 contract Blacklist is Callable {
289   mapping(address => bool) public blacklist;
290 
291   function addAddressToBlacklist(address addr) onlyCaller public returns (bool success) {
292     if (!blacklist[addr]) {
293       blacklist[addr] = true;
294       success = true;
295     }
296   }
297 
298   function removeAddressFromBlacklist(address addr) onlyCaller public returns (bool success) {
299     if (blacklist[addr]) {
300       blacklist[addr] = false;
301       success = true;
302     }
303   }
304 }
305 
306 // ----------------------------------------------------------------------------
307 // Allowance
308 // ----------------------------------------------------------------------------
309 /**
310  * @title Allowance
311  * @dev Storage for the Allowance List.
312  */
313 contract Allowance is Callable {
314   using SafeMath for uint256;
315 
316   mapping (address => mapping (address => uint256)) public allowanceOf;
317 
318   function addAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
319     allowanceOf[_holder][_spender] = allowanceOf[_holder][_spender].add(_value);
320   }
321 
322   function subAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
323     uint256 oldValue = allowanceOf[_holder][_spender];
324     if (_value > oldValue) {
325       allowanceOf[_holder][_spender] = 0;
326     } else {
327       allowanceOf[_holder][_spender] = oldValue.sub(_value);
328     }
329   }
330 
331   function setAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
332     allowanceOf[_holder][_spender] = _value;
333   }
334 }
335 
336 // ----------------------------------------------------------------------------
337 // Balance
338 // ----------------------------------------------------------------------------
339 /**
340  * @title Balance
341  * @dev Storage for the Balance List.
342  */
343 contract Balance is Callable {
344   using SafeMath for uint256;
345 
346   mapping (address => uint256) public balanceOf;
347 
348   uint256 public totalSupply;
349 
350   function addBalance(address _addr, uint256 _value) onlyCaller public {
351     balanceOf[_addr] = balanceOf[_addr].add(_value);
352   }
353 
354   function subBalance(address _addr, uint256 _value) onlyCaller public {
355     balanceOf[_addr] = balanceOf[_addr].sub(_value);
356   }
357 
358   function setBalance(address _addr, uint256 _value) onlyCaller public {
359     balanceOf[_addr] = _value;
360   }
361 
362   function addTotalSupply(uint256 _value) onlyCaller public {
363     totalSupply = totalSupply.add(_value);
364   }
365 
366   function subTotalSupply(uint256 _value) onlyCaller public {
367     totalSupply = totalSupply.sub(_value);
368   }
369 }
370 
371 // ----------------------------------------------------------------------------
372 // Blacklistable
373 // ----------------------------------------------------------------------------
374 /**
375  * @title Blacklistable
376  * @dev A contract for the blacklist modifiers.
377  */
378 contract Blacklistable {
379   Blacklist internal _blacklist;
380 
381   constructor(
382     Blacklist _blacklistContract
383   ) public {
384     _blacklist = _blacklistContract;
385   }
386 
387   /**
388    * @dev Throws if the given address is blacklisted.
389    */
390   modifier onlyNotBlacklistedAddr(address addr) {
391     require(!_blacklist.blacklist(addr));
392     _;
393   }
394 
395   /**
396    * @dev Throws if one of the given addresses is blacklisted.
397    */
398   modifier onlyNotBlacklistedAddrs(address[] addrs) {
399     for (uint256 i = 0; i < addrs.length; i++) {
400       require(!_blacklist.blacklist(addrs[i]));
401     }
402     _;
403   }
404 
405   function blacklist(address addr) public view returns (bool) {
406     return _blacklist.blacklist(addr);
407   }
408 }
409 
410 /**
411  * @title ControllerTest
412  * @dev A contract for managing the minting, burning, blacklisting and administration of the tokens.
413  */
414 contract ControllerTest is Pausable, Administratable, Blacklistable {
415   using SafeMath for uint256;
416   Balance internal _balances;
417 
418   uint256 constant decimals = 18;
419   uint256 constant maxBLBatch = 100;
420   uint256 public dailyMintLimit = 10000 * 10 ** decimals;
421   uint256 public dailyBurnLimit = 10000 * 10 ** decimals;
422   uint256 constant dayInSeconds = 86400;
423 
424   constructor(
425     Balance _balanceContract, Blacklist _blacklistContract
426   ) Blacklistable(_blacklistContract) public {
427     _balances = _balanceContract;
428   }
429 
430   // This notifies clients about the amount burnt
431   event Burn(address indexed from, uint256 value);
432   // This notifies clients about the amount mint
433   event Mint(address indexed to, uint256 value);
434   // This notifies clients about the amount of limit mint by some admin
435   event LimitMint(address indexed admin, address indexed to, uint256 value);
436   // This notifies clients about the amount of limit burn by some admin
437   event LimitBurn(address indexed admin, address indexed from, uint256 value);
438 
439   event BlacklistedAddressAdded(address indexed addr);
440   event BlacklistedAddressRemoved(address indexed addr);
441 
442   // blacklist operations
443   function _addToBlacklist(address addr) internal returns (bool success) {
444     success = _blacklist.addAddressToBlacklist(addr);
445     if (success) {
446       emit BlacklistedAddressAdded(addr);
447     }
448   }
449 
450   function _removeFromBlacklist(address addr) internal returns (bool success) {
451     success = _blacklist.removeAddressFromBlacklist(addr);
452     if (success) {
453       emit BlacklistedAddressRemoved(addr);
454     }
455   }
456 
457   /**
458    * @dev add an address to the blacklist
459    * @param addr address
460    * @return true if the address was added to the blacklist, false if the address was already in the blacklist
461    */
462   function addAddressToBlacklist(address addr) onlyAdmin whenNotPaused public returns (bool) {
463     return _addToBlacklist(addr);
464   }
465 
466   /**
467    * @dev add addresses to the blacklist
468    * @param addrs addresses
469    * @return true if at least one address was added to the blacklist,
470    * false if all addresses were already in the blacklist
471    */
472   function addAddressesToBlacklist(address[] addrs) onlyAdmin whenNotPaused public returns (bool success) {
473     uint256 cnt = uint256(addrs.length);
474     require(cnt <= maxBLBatch);
475     success = true;
476     for (uint256 i = 0; i < addrs.length; i++) {
477       if (!_addToBlacklist(addrs[i])) {
478         success = false;
479       }
480     }
481   }
482 
483   /**
484    * @dev remove an address from the blacklist
485    * @param addr address
486    * @return true if the address was removed from the blacklist,
487    * false if the address wasn't in the blacklist in the first place
488    */
489   function removeAddressFromBlacklist(address addr) onlyAdmin whenNotPaused public returns (bool) {
490     return _removeFromBlacklist(addr);
491   }
492 
493   /**
494    * @dev remove addresses from the blacklist
495    * @param addrs addresses
496    * @return true if at least one address was removed from the blacklist,
497    * false if all addresses weren't in the blacklist in the first place
498    */
499   function removeAddressesFromBlacklist(address[] addrs) onlyAdmin whenNotPaused public returns (bool success) {
500     success = true;
501     for (uint256 i = 0; i < addrs.length; i++) {
502       if (!_removeFromBlacklist(addrs[i])) {
503         success = false;
504       }
505     }
506   }
507 
508   /**
509    * Destroy tokens from other account
510    *
511    * Remove `_amount` tokens from the system irreversibly on behalf of `_from`.
512    *
513    * @param _from the address of the sender
514    * @param _amount the amount of money to burn
515    */
516   function burnFrom(address _from, uint256 _amount) onlyOwner whenNotPaused
517   public returns (bool success) {
518     require(_balances.balanceOf(_from) >= _amount);    // Check if the targeted balance is enough
519     _balances.subBalance(_from, _amount);              // Subtract from the targeted balance
520     _balances.subTotalSupply(_amount);
521     emit Burn(_from, _amount);
522     return true;
523   }
524 
525   /**
526    * Destroy tokens from other account
527    * If the burn total amount exceeds the daily threshold, this operation will fail
528    *
529    * Remove `_amount` tokens from the system irreversibly on behalf of `_from`.
530    *
531    * @param _from the address of the sender
532    * @param _amount the amount of money to burn
533    */
534   function limitBurnFrom(address _from, uint256 _amount) onlyAdmin whenNotPaused
535   public returns (bool success) {
536     require(_balances.balanceOf(_from) >= _amount && _amount <= dailyBurnLimit);
537     if (burnLimiter[msg.sender].lastBurnTimestamp.div(dayInSeconds) != now.div(dayInSeconds)) {
538       burnLimiter[msg.sender].burntTotal = 0;
539     }
540     require(burnLimiter[msg.sender].burntTotal.add(_amount) <= dailyBurnLimit);
541     _balances.subBalance(_from, _amount);              // Subtract from the targeted balance
542     _balances.subTotalSupply(_amount);
543     burnLimiter[msg.sender].lastBurnTimestamp = now;
544     burnLimiter[msg.sender].burntTotal = burnLimiter[msg.sender].burntTotal.add(_amount);
545     emit LimitBurn(msg.sender, _from, _amount);
546     emit Burn(_from, _amount);
547     return true;
548   }
549 
550   /**
551     * Add `_amount` tokens to the pool and to the `_to` address' balance.
552     * If the mint total amount exceeds the daily threshold, this operation will fail
553     *
554     * @param _to the address that will receive the given amount of tokens
555     * @param _amount the amount of tokens it will receive
556     */
557   function limitMint(address _to, uint256 _amount)
558   onlyAdmin whenNotPaused onlyNotBlacklistedAddr(_to)
559   public returns (bool success) {
560     require(_to != msg.sender);
561     require(_amount <= dailyMintLimit);
562     if (mintLimiter[msg.sender].lastMintTimestamp.div(dayInSeconds) != now.div(dayInSeconds)) {
563       mintLimiter[msg.sender].mintedTotal = 0;
564     }
565     require(mintLimiter[msg.sender].mintedTotal.add(_amount) <= dailyMintLimit);
566     _balances.addBalance(_to, _amount);
567     _balances.addTotalSupply(_amount);
568     mintLimiter[msg.sender].lastMintTimestamp = now;
569     mintLimiter[msg.sender].mintedTotal = mintLimiter[msg.sender].mintedTotal.add(_amount);
570     emit LimitMint(msg.sender, _to, _amount);
571     emit Mint(_to, _amount);
572     return true;
573   }
574 
575   function setDailyMintLimit(uint256 _limit) onlyOwner public returns (bool) {
576     dailyMintLimit = _limit;
577     return true;
578   }
579 
580   function setDailyBurnLimit(uint256 _limit) onlyOwner public returns (bool) {
581     dailyBurnLimit = _limit;
582     return true;
583   }
584 
585   /**
586     * Add `_amount` tokens to the pool and to the `_to` address' balance
587     *
588     * @param _to the address that will receive the given amount of tokens
589     * @param _amount the amount of tokens it will receive
590     */
591   function mint(address _to, uint256 _amount)
592   onlyOwner whenNotPaused onlyNotBlacklistedAddr(_to)
593   public returns (bool success) {
594     _balances.addBalance(_to, _amount);
595     _balances.addTotalSupply(_amount);
596     emit Mint(_to, _amount);
597     return true;
598   }
599 }
600 
601 // ----------------------------------------------------------------------------
602 // ContractInterface
603 // ----------------------------------------------------------------------------
604 contract ContractInterface {
605   function totalSupply() public view returns (uint256);
606   function balanceOf(address tokenOwner) public view returns (uint256);
607   function allowance(address tokenOwner, address spender) public view returns (uint256);
608   function transfer(address to, uint256 value) public returns (bool);
609   function approve(address spender, uint256 value) public returns (bool);
610   function transferFrom(address from, address to, uint256 value) public returns (bool);
611   function batchTransfer(address[] to, uint256 value) public returns (bool);
612   function increaseApproval(address spender, uint256 value) public returns (bool);
613   function decreaseApproval(address spender, uint256 value) public returns (bool);
614   function burn(uint256 value) public returns (bool);
615 
616   event Transfer(address indexed from, address indexed to, uint256 value);
617   event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
618   // This notifies clients about the amount burnt
619   event Burn(address indexed from, uint256 value);
620 }
621 
622 // ----------------------------------------------------------------------------
623 // V_test contract
624 // ----------------------------------------------------------------------------
625 contract V_test is ContractInterface, Pausable, Blacklistable {
626   using SafeMath for uint256;
627 
628   // variables of the token
629   uint8 public constant decimals = 18;
630   uint256 constant maxBatch = 100;
631 
632   string public name;
633   string public symbol;
634 
635   Balance internal _balances;
636   Allowance internal _allowance;
637 
638   constructor(string _tokenName, string _tokenSymbol,
639     Balance _balanceContract, Allowance _allowanceContract,
640     Blacklist _blacklistContract
641   ) Blacklistable(_blacklistContract) public {
642     name = _tokenName;                                        // Set the name for display purposes
643     symbol = _tokenSymbol;                                    // Set the symbol for display purposes
644     _balances = _balanceContract;
645     _allowance = _allowanceContract;
646   }
647 
648   function totalSupply() public view returns (uint256) {
649     return _balances.totalSupply();
650   }
651 
652   function balanceOf(address _addr) public view returns (uint256) {
653     return _balances.balanceOf(_addr);
654   }
655 
656   /**
657    * @dev Function to check the amount of tokens that an owner allowed to a spender.
658    * @param _owner address The address which owns the funds.
659    * @param _spender address The address which will spend the funds.
660    * @return A uint256 specifying the amount of tokens still available for the spender.
661    */
662   function allowance(address _owner, address _spender) public view returns (uint256) {
663     return _allowance.allowanceOf(_owner, _spender);
664   }
665 
666   /**
667    *  @dev Internal transfer, only can be called by this contract
668    */
669   function _transfer(address _from, address _to, uint256 _value) internal {
670     require(_value > 0);                                               // transfering value must be greater than 0
671     require(_to != 0x0);                                               // Prevent transfer to 0x0 address. Use burn() instead
672     require(_balances.balanceOf(_from) >= _value);                     // Check if the sender has enough
673     uint256 previousBalances = _balances.balanceOf(_from).add(_balances.balanceOf(_to)); // Save this for an assertion in the future
674     _balances.subBalance(_from, _value);                 // Subtract from the sender
675     _balances.addBalance(_to, _value);                     // Add the same to the recipient
676     emit Transfer(_from, _to, _value);
677     // Asserts are used to use static analysis to find bugs in your code. They should never fail
678     assert(_balances.balanceOf(_from) + _balances.balanceOf(_to) == previousBalances);
679   }
680 
681   /**
682    * @dev Transfer tokens
683    * Send `_value` tokens to `_to` from your account
684    *
685    * @param _to The address of the recipient
686    * @param _value the amount to send
687    */
688   function transfer(address _to, uint256 _value)
689   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_to)
690   public returns (bool) {
691     _transfer(msg.sender, _to, _value);
692     return true;
693   }
694 
695 
696   /**
697    * @dev Transfer tokens to multiple accounts
698    * Send `_value` tokens to all addresses in `_to` from your account
699    *
700    * @param _to The addresses of the recipients
701    * @param _value the amount to send
702    */
703   function batchTransfer(address[] _to, uint256 _value)
704   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddrs(_to)
705   public returns (bool) {
706     uint256 cnt = uint256(_to.length);
707     require(cnt > 0 && cnt <= maxBatch && _value > 0);
708     uint256 amount = _value.mul(cnt);
709     require(_balances.balanceOf(msg.sender) >= amount);
710 
711     for (uint256 i = 0; i < cnt; i++) {
712       _transfer(msg.sender, _to[i], _value);
713     }
714     return true;
715   }
716 
717   /**
718    * @dev Transfer tokens from other address
719    * Send `_value` tokens to `_to` in behalf of `_from`
720    *
721    * @param _from The address of the sender
722    * @param _to The address of the recipient
723    * @param _value the amount to send
724    */
725   function transferFrom(address _from, address _to, uint256 _value)
726   whenNotPaused onlyNotBlacklistedAddr(_from) onlyNotBlacklistedAddr(_to)
727   public returns (bool) {
728     require(_allowance.allowanceOf(_from, msg.sender) >= _value);     // Check allowance
729     _allowance.subAllowance(_from, msg.sender, _value);
730     _transfer(_from, _to, _value);
731     return true;
732   }
733 
734   /**
735    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
736    *
737    * Beware that changing an allowance with this method brings the risk that someone may use both the old
738    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
739    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
740    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
741    * @param _spender The address which will spend the funds.
742    * @param _value The amount of tokens to be spent.
743    *
744    * Allows `_spender` to spend no more than `_value` tokens in your behalf
745    *
746    * @param _spender The address authorized to spend
747    * @param _value the max amount they can spend
748    */
749   function approve(address _spender, uint256 _value)
750   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender)
751   public returns (bool) {
752     _allowance.setAllowance(msg.sender, _spender, _value);
753     emit Approval(msg.sender, _spender, _value);
754     return true;
755   }
756 
757   /**
758    * @dev Increase the amount of tokens that an owner allowed to a spender.
759    *
760    * approve should be called when allowed[_spender] == 0. To increment
761    * allowed value is better to use this function to avoid 2 calls (and wait until
762    * the first transaction is mined)
763    * From MonolithDAO Token.sol
764    * @param _spender The address which will spend the funds.
765    * @param _addedValue The amount of tokens to increase the allowance by.
766    */
767   function increaseApproval(address _spender, uint256 _addedValue)
768   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender)
769   public returns (bool) {
770     _allowance.addAllowance(msg.sender, _spender, _addedValue);
771     emit Approval(msg.sender, _spender, _allowance.allowanceOf(msg.sender, _spender));
772     return true;
773   }
774 
775   /**
776    * @dev Decrease the amount of tokens that an owner allowed to a spender.
777    *
778    * approve should be called when allowed[_spender] == 0. To decrement
779    * allowed value is better to use this function to avoid 2 calls (and wait until
780    * the first transaction is mined)
781    * From MonolithDAO Token.sol
782    * @param _spender The address which will spend the funds.
783    * @param _subtractedValue The amount of tokens to decrease the allowance by.
784    */
785   function decreaseApproval(address _spender, uint256 _subtractedValue)
786   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender)
787   public returns (bool) {
788     _allowance.subAllowance(msg.sender, _spender, _subtractedValue);
789     emit Approval(msg.sender, _spender, _allowance.allowanceOf(msg.sender, _spender));
790     return true;
791   }
792 
793   /**
794    * @dev Destroy tokens
795    * Remove `_value` tokens from the system irreversibly
796    *
797    * @param _value the amount of money to burn
798    */
799   function burn(uint256 _value) whenNotPaused onlyNotBlacklistedAddr(msg.sender)
800   public returns (bool success) {
801     require(_balances.balanceOf(msg.sender) >= _value);         // Check if the sender has enough
802     _balances.subBalance(msg.sender, _value);                   // Subtract from the sender
803     _balances.subTotalSupply(_value);                           // Updates totalSupply
804     emit Burn(msg.sender, _value);
805     return true;
806   }
807 
808   /**
809    * @dev Change name and symbol of the tokens
810    *
811    * @param _name the new name of the token
812    * @param _symbol the new symbol of the token
813    */
814   function changeName(string _name, string _symbol) onlyOwner public {
815     name = _name;
816     symbol = _symbol;
817   }
818 }