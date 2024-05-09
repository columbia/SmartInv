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
307 // Verified
308 // ----------------------------------------------------------------------------
309 /**
310  * @title Verified
311  * @dev The Verified contract has a list of verified addresses.
312  */
313 contract Verified is Callable {
314   mapping(address => bool) public verifiedList;
315   bool public shouldVerify = true;
316 
317   function verifyAddress(address addr) onlyCaller public returns (bool success) {
318     if (!verifiedList[addr]) {
319       verifiedList[addr] = true;
320       success = true;
321     }
322   }
323 
324   function unverifyAddress(address addr) onlyCaller public returns (bool success) {
325     if (verifiedList[addr]) {
326       verifiedList[addr] = false;
327       success = true;
328     }
329   }
330 
331   function setShouldVerify(bool value) onlyCaller public returns (bool success) {
332     shouldVerify = value;
333     return true;
334   }
335 }
336 
337 // ----------------------------------------------------------------------------
338 // Allowance
339 // ----------------------------------------------------------------------------
340 /**
341  * @title Allowance
342  * @dev Storage for the Allowance List.
343  */
344 contract Allowance is Callable {
345   using SafeMath for uint256;
346 
347   mapping (address => mapping (address => uint256)) public allowanceOf;
348 
349   function addAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
350     allowanceOf[_holder][_spender] = allowanceOf[_holder][_spender].add(_value);
351   }
352 
353   function subAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
354     uint256 oldValue = allowanceOf[_holder][_spender];
355     if (_value > oldValue) {
356       allowanceOf[_holder][_spender] = 0;
357     } else {
358       allowanceOf[_holder][_spender] = oldValue.sub(_value);
359     }
360   }
361 
362   function setAllowance(address _holder, address _spender, uint256 _value) onlyCaller public {
363     allowanceOf[_holder][_spender] = _value;
364   }
365 }
366 
367 // ----------------------------------------------------------------------------
368 // Balance
369 // ----------------------------------------------------------------------------
370 /**
371  * @title Balance
372  * @dev Storage for the Balance List.
373  */
374 contract Balance is Callable {
375   using SafeMath for uint256;
376 
377   mapping (address => uint256) public balanceOf;
378 
379   uint256 public totalSupply;
380 
381   function addBalance(address _addr, uint256 _value) onlyCaller public {
382     balanceOf[_addr] = balanceOf[_addr].add(_value);
383   }
384 
385   function subBalance(address _addr, uint256 _value) onlyCaller public {
386     balanceOf[_addr] = balanceOf[_addr].sub(_value);
387   }
388 
389   function setBalance(address _addr, uint256 _value) onlyCaller public {
390     balanceOf[_addr] = _value;
391   }
392 
393   function addTotalSupply(uint256 _value) onlyCaller public {
394     totalSupply = totalSupply.add(_value);
395   }
396 
397   function subTotalSupply(uint256 _value) onlyCaller public {
398     totalSupply = totalSupply.sub(_value);
399   }
400 }
401 
402 // ----------------------------------------------------------------------------
403 // UserContract
404 // ----------------------------------------------------------------------------
405 /**
406  * @title UserContract
407  * @dev A contract for the blacklist and verified list modifiers.
408  */
409 contract UserContract {
410   Blacklist internal _blacklist;
411   Verified internal _verifiedList;
412 
413   constructor(
414     Blacklist _blacklistContract, Verified _verifiedListContract
415   ) public {
416     _blacklist = _blacklistContract;
417     _verifiedList = _verifiedListContract;
418   }
419 
420 
421   /**
422    * @dev Throws if the given address is blacklisted.
423    */
424   modifier onlyNotBlacklistedAddr(address addr) {
425     require(!_blacklist.blacklist(addr));
426     _;
427   }
428 
429   /**
430    * @dev Throws if one of the given addresses is blacklisted.
431    */
432   modifier onlyNotBlacklistedAddrs(address[] addrs) {
433     for (uint256 i = 0; i < addrs.length; i++) {
434       require(!_blacklist.blacklist(addrs[i]));
435     }
436     _;
437   }
438 
439   /**
440    * @dev Throws if the given address is not verified.
441    */
442   modifier onlyVerifiedAddr(address addr) {
443     if (_verifiedList.shouldVerify()) {
444       require(_verifiedList.verifiedList(addr));
445     }
446     _;
447   }
448 
449   /**
450    * @dev Throws if one of the given addresses is not verified.
451    */
452   modifier onlyVerifiedAddrs(address[] addrs) {
453     if (_verifiedList.shouldVerify()) {
454       for (uint256 i = 0; i < addrs.length; i++) {
455         require(_verifiedList.verifiedList(addrs[i]));
456       }
457     }
458     _;
459   }
460 
461   function blacklist(address addr) public view returns (bool) {
462     return _blacklist.blacklist(addr);
463   }
464 
465   function verifiedlist(address addr) public view returns (bool) {
466     return _verifiedList.verifiedList(addr);
467   }
468 }
469 
470 /**
471  * @title ControllerContract
472  * @dev A contract for managing the blacklist and verified list and burning and minting of the tokens.
473  */
474 contract ControllerContract is Pausable, Administratable, UserContract {
475   using SafeMath for uint256;
476   Balance internal _balances;
477 
478   uint256 constant decimals = 18;
479   uint256 constant maxBLBatch = 100;
480   uint256 public dailyMintLimit = 10000 * 10 ** decimals;
481   uint256 public dailyBurnLimit = 10000 * 10 ** decimals;
482   uint256 constant dayInSeconds = 86400;
483 
484   constructor(
485     Balance _balanceContract, Blacklist _blacklistContract, Verified _verifiedListContract
486   ) UserContract(_blacklistContract, _verifiedListContract) public {
487     _balances = _balanceContract;
488   }
489 
490   // This notifies clients about the amount burnt
491   event Burn(address indexed from, uint256 value);
492   // This notifies clients about the amount mint
493   event Mint(address indexed to, uint256 value);
494   // This notifies clients about the amount of limit mint by some admin
495   event LimitMint(address indexed admin, address indexed to, uint256 value);
496   // This notifies clients about the amount of limit burn by some admin
497   event LimitBurn(address indexed admin, address indexed from, uint256 value);
498 
499   event VerifiedAddressAdded(address indexed addr);
500   event VerifiedAddressRemoved(address indexed addr);
501 
502   event BlacklistedAddressAdded(address indexed addr);
503   event BlacklistedAddressRemoved(address indexed addr);
504 
505   // blacklist operations
506   function _addToBlacklist(address addr) internal returns (bool success) {
507     success = _blacklist.addAddressToBlacklist(addr);
508     if (success) {
509       emit BlacklistedAddressAdded(addr);
510     }
511   }
512 
513   function _removeFromBlacklist(address addr) internal returns (bool success) {
514     success = _blacklist.removeAddressFromBlacklist(addr);
515     if (success) {
516       emit BlacklistedAddressRemoved(addr);
517     }
518   }
519 
520   /**
521    * @dev add an address to the blacklist
522    * @param addr address
523    * @return true if the address was added to the blacklist, false if the address was already in the blacklist
524    */
525   function addAddressToBlacklist(address addr) onlyAdmin whenNotPaused public returns (bool) {
526     return _addToBlacklist(addr);
527   }
528 
529   /**
530    * @dev add addresses to the blacklist
531    * @param addrs addresses
532    * @return true if at least one address was added to the blacklist,
533    * false if all addresses were already in the blacklist
534    */
535   function addAddressesToBlacklist(address[] addrs) onlyAdmin whenNotPaused public returns (bool success) {
536     uint256 cnt = uint256(addrs.length);
537     require(cnt <= maxBLBatch);
538     success = true;
539     for (uint256 i = 0; i < addrs.length; i++) {
540       if (!_addToBlacklist(addrs[i])) {
541         success = false;
542       }
543     }
544   }
545 
546   /**
547    * @dev remove an address from the blacklist
548    * @param addr address
549    * @return true if the address was removed from the blacklist,
550    * false if the address wasn't in the blacklist in the first place
551    */
552   function removeAddressFromBlacklist(address addr) onlyAdmin whenNotPaused public returns (bool) {
553     return _removeFromBlacklist(addr);
554   }
555 
556   /**
557    * @dev remove addresses from the blacklist
558    * @param addrs addresses
559    * @return true if at least one address was removed from the blacklist,
560    * false if all addresses weren't in the blacklist in the first place
561    */
562   function removeAddressesFromBlacklist(address[] addrs) onlyAdmin whenNotPaused public returns (bool success) {
563     success = true;
564     for (uint256 i = 0; i < addrs.length; i++) {
565       if (!_removeFromBlacklist(addrs[i])) {
566         success = false;
567       }
568     }
569   }
570 
571   // verified list operations
572   function _verifyAddress(address addr) internal returns (bool success) {
573     success = _verifiedList.verifyAddress(addr);
574     if (success) {
575       emit VerifiedAddressAdded(addr);
576     }
577   }
578 
579   function _unverifyAddress(address addr) internal returns (bool success) {
580     success = _verifiedList.unverifyAddress(addr);
581     if (success) {
582       emit VerifiedAddressRemoved(addr);
583     }
584   }
585 
586   /**
587    * @dev add an address to the verifiedlist
588    * @param addr address
589    * @return true if the address was added to the verifiedlist, false if the address was already in the verifiedlist or if the address is in the blacklist
590    */
591   function verifyAddress(address addr) onlyAdmin onlyNotBlacklistedAddr(addr) whenNotPaused public returns (bool) {
592     return _verifyAddress(addr);
593   }
594 
595   /**
596    * @dev add addresses to the verifiedlist
597    * @param addrs addresses
598    * @return true if at least one address was added to the verifiedlist,
599    * false if all addresses were already in the verifiedlist
600    */
601   function verifyAddresses(address[] addrs) onlyAdmin onlyNotBlacklistedAddrs(addrs) whenNotPaused public returns (bool success) {
602     success = true;
603     for (uint256 i = 0; i < addrs.length; i++) {
604       if (!_verifyAddress(addrs[i])) {
605         success = false;
606       }
607     }
608   }
609 
610 
611   /**
612    * @dev remove an address from the verifiedlist
613    * @param addr address
614    * @return true if the address was removed from the verifiedlist,
615    * false if the address wasn't in the verifiedlist in the first place
616    */
617   function unverifyAddress(address addr) onlyAdmin whenNotPaused public returns (bool) {
618     return _unverifyAddress(addr);
619   }
620 
621 
622   /**
623    * @dev remove addresses from the verifiedlist
624    * @param addrs addresses
625    * @return true if at least one address was removed from the verifiedlist,
626    * false if all addresses weren't in the verifiedlist in the first place
627    */
628   function unverifyAddresses(address[] addrs) onlyAdmin whenNotPaused public returns (bool success) {
629     success = true;
630     for (uint256 i = 0; i < addrs.length; i++) {
631       if (!_unverifyAddress(addrs[i])) {
632         success = false;
633       }
634     }
635   }
636 
637   /**
638    * @dev set if to use the verified list
639    * @param value true if should verify address, false if should skip address verification
640    */
641    function shouldVerify(bool value) onlyOwner public returns (bool success) {
642      _verifiedList.setShouldVerify(value);
643      return true;
644    }
645 
646   /**
647    * Destroy tokens from other account
648    *
649    * Remove `_amount` tokens from the system irreversibly on behalf of `_from`.
650    *
651    * @param _from the address of the sender
652    * @param _amount the amount of money to burn
653    */
654   function burnFrom(address _from, uint256 _amount) onlyOwner whenNotPaused
655   public returns (bool success) {
656     require(_balances.balanceOf(_from) >= _amount);    // Check if the targeted balance is enough
657     _balances.subBalance(_from, _amount);              // Subtract from the targeted balance
658     _balances.subTotalSupply(_amount);
659     emit Burn(_from, _amount);
660     return true;
661   }
662 
663   /**
664    * Destroy tokens from other account
665    * If the burn total amount exceeds the daily threshold, this operation will fail
666    *
667    * Remove `_amount` tokens from the system irreversibly on behalf of `_from`.
668    *
669    * @param _from the address of the sender
670    * @param _amount the amount of money to burn
671    */
672   function limitBurnFrom(address _from, uint256 _amount) onlyAdmin whenNotPaused
673   public returns (bool success) {
674     require(_balances.balanceOf(_from) >= _amount && _amount <= dailyBurnLimit);
675     if (burnLimiter[msg.sender].lastBurnTimestamp.div(dayInSeconds) != now.div(dayInSeconds)) {
676       burnLimiter[msg.sender].burntTotal = 0;
677     }
678     require(burnLimiter[msg.sender].burntTotal.add(_amount) <= dailyBurnLimit);
679     _balances.subBalance(_from, _amount);              // Subtract from the targeted balance
680     _balances.subTotalSupply(_amount);
681     burnLimiter[msg.sender].lastBurnTimestamp = now;
682     burnLimiter[msg.sender].burntTotal = burnLimiter[msg.sender].burntTotal.add(_amount);
683     emit LimitBurn(msg.sender, _from, _amount);
684     emit Burn(_from, _amount);
685     return true;
686   }
687 
688   /**
689     * Add `_amount` tokens to the pool and to the `_to` address' balance.
690     * If the mint total amount exceeds the daily threshold, this operation will fail
691     *
692     * @param _to the address that will receive the given amount of tokens
693     * @param _amount the amount of tokens it will receive
694     */
695   function limitMint(address _to, uint256 _amount)
696   onlyAdmin whenNotPaused onlyNotBlacklistedAddr(_to) onlyVerifiedAddr(_to)
697   public returns (bool success) {
698     require(_to != msg.sender);
699     require(_amount <= dailyMintLimit);
700     if (mintLimiter[msg.sender].lastMintTimestamp.div(dayInSeconds) != now.div(dayInSeconds)) {
701       mintLimiter[msg.sender].mintedTotal = 0;
702     }
703     require(mintLimiter[msg.sender].mintedTotal.add(_amount) <= dailyMintLimit);
704     _balances.addBalance(_to, _amount);
705     _balances.addTotalSupply(_amount);
706     mintLimiter[msg.sender].lastMintTimestamp = now;
707     mintLimiter[msg.sender].mintedTotal = mintLimiter[msg.sender].mintedTotal.add(_amount);
708     emit LimitMint(msg.sender, _to, _amount);
709     emit Mint(_to, _amount);
710     return true;
711   }
712 
713   function setDailyMintLimit(uint256 _limit) onlyOwner public returns (bool) {
714     dailyMintLimit = _limit;
715     return true;
716   }
717 
718   function setDailyBurnLimit(uint256 _limit) onlyOwner public returns (bool) {
719     dailyBurnLimit = _limit;
720     return true;
721   }
722 
723   /**
724     * Add `_amount` tokens to the pool and to the `_to` address' balance
725     *
726     * @param _to the address that will receive the given amount of tokens
727     * @param _amount the amount of tokens it will receive
728     */
729   function mint(address _to, uint256 _amount)
730   onlyOwner whenNotPaused onlyNotBlacklistedAddr(_to) onlyVerifiedAddr(_to)
731   public returns (bool success) {
732     _balances.addBalance(_to, _amount);
733     _balances.addTotalSupply(_amount);
734     emit Mint(_to, _amount);
735     return true;
736   }
737 }
738 
739 // ----------------------------------------------------------------------------
740 // ContractInterface
741 // ----------------------------------------------------------------------------
742 contract ContractInterface {
743   function totalSupply() public view returns (uint256);
744   function balanceOf(address tokenOwner) public view returns (uint256);
745   function allowance(address tokenOwner, address spender) public view returns (uint256);
746   function transfer(address to, uint256 value) public returns (bool);
747   function approve(address spender, uint256 value) public returns (bool);
748   function transferFrom(address from, address to, uint256 value) public returns (bool);
749   function batchTransfer(address[] to, uint256 value) public returns (bool);
750   function increaseApproval(address spender, uint256 value) public returns (bool);
751   function decreaseApproval(address spender, uint256 value) public returns (bool);
752   function burn(uint256 value) public returns (bool);
753 
754   event Transfer(address indexed from, address indexed to, uint256 value);
755   event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
756   // This notifies clients about the amount burnt
757   event Burn(address indexed from, uint256 value);
758 }
759 
760 // ----------------------------------------------------------------------------
761 // USDO contract
762 // ----------------------------------------------------------------------------
763 contract USDO is ContractInterface, Pausable, UserContract {
764   using SafeMath for uint256;
765 
766   // variables of the token
767   uint8 public constant decimals = 18;
768   uint256 constant maxBatch = 100;
769 
770   string public name;
771   string public symbol;
772 
773   Balance internal _balances;
774   Allowance internal _allowance;
775 
776   constructor(string _tokenName, string _tokenSymbol,
777     Balance _balanceContract, Allowance _allowanceContract,
778     Blacklist _blacklistContract, Verified _verifiedListContract
779   ) UserContract(_blacklistContract, _verifiedListContract) public {
780     name = _tokenName;                                        // Set the name for display purposes
781     symbol = _tokenSymbol;                                    // Set the symbol for display purposes
782     _balances = _balanceContract;
783     _allowance = _allowanceContract;
784   }
785 
786   function totalSupply() public view returns (uint256) {
787     return _balances.totalSupply();
788   }
789 
790   function balanceOf(address _addr) public view returns (uint256) {
791     return _balances.balanceOf(_addr);
792   }
793 
794   /**
795    * @dev Function to check the amount of tokens that an owner allowed to a spender.
796    * @param _owner address The address which owns the funds.
797    * @param _spender address The address which will spend the funds.
798    * @return A uint256 specifying the amount of tokens still available for the spender.
799    */
800   function allowance(address _owner, address _spender) public view returns (uint256) {
801     return _allowance.allowanceOf(_owner, _spender);
802   }
803 
804   /**
805    *  @dev Internal transfer, only can be called by this contract
806    */
807   function _transfer(address _from, address _to, uint256 _value) internal {
808     require(_value > 0);                                               // transfering value must be greater than 0
809     require(_to != 0x0);                                               // Prevent transfer to 0x0 address. Use burn() instead
810     require(_balances.balanceOf(_from) >= _value);                     // Check if the sender has enough
811     uint256 previousBalances = _balances.balanceOf(_from).add(_balances.balanceOf(_to)); // Save this for an assertion in the future
812     _balances.subBalance(_from, _value);                 // Subtract from the sender
813     _balances.addBalance(_to, _value);                     // Add the same to the recipient
814     emit Transfer(_from, _to, _value);
815     // Asserts are used to use static analysis to find bugs in your code. They should never fail
816     assert(_balances.balanceOf(_from) + _balances.balanceOf(_to) == previousBalances);
817   }
818 
819   /**
820    * @dev Transfer tokens
821    * Send `_value` tokens to `_to` from your account
822    *
823    * @param _to The address of the recipient
824    * @param _value the amount to send
825    */
826   function transfer(address _to, uint256 _value)
827   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_to) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_to)
828   public returns (bool) {
829     _transfer(msg.sender, _to, _value);
830     return true;
831   }
832 
833 
834   /**
835    * @dev Transfer tokens to multiple accounts
836    * Send `_value` tokens to all addresses in `_to` from your account
837    *
838    * @param _to The addresses of the recipients
839    * @param _value the amount to send
840    */
841   function batchTransfer(address[] _to, uint256 _value)
842   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddrs(_to) onlyVerifiedAddr(msg.sender) onlyVerifiedAddrs(_to)
843   public returns (bool) {
844     uint256 cnt = uint256(_to.length);
845     require(cnt > 0 && cnt <= maxBatch && _value > 0);
846     uint256 amount = _value.mul(cnt);
847     require(_balances.balanceOf(msg.sender) >= amount);
848 
849     for (uint256 i = 0; i < cnt; i++) {
850       _transfer(msg.sender, _to[i], _value);
851     }
852     return true;
853   }
854 
855   /**
856    * @dev Transfer tokens from other address
857    * Send `_value` tokens to `_to` in behalf of `_from`
858    *
859    * @param _from The address of the sender
860    * @param _to The address of the recipient
861    * @param _value the amount to send
862    */
863   function transferFrom(address _from, address _to, uint256 _value)
864   whenNotPaused onlyNotBlacklistedAddr(_from) onlyNotBlacklistedAddr(_to) onlyVerifiedAddr(_from) onlyVerifiedAddr(_to)
865   public returns (bool) {
866     require(_allowance.allowanceOf(_from, msg.sender) >= _value);     // Check allowance
867     _allowance.subAllowance(_from, msg.sender, _value);
868     _transfer(_from, _to, _value);
869     return true;
870   }
871 
872   /**
873    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
874    *
875    * Beware that changing an allowance with this method brings the risk that someone may use both the old
876    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
877    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
878    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
879    * @param _spender The address which will spend the funds.
880    * @param _value The amount of tokens to be spent.
881    *
882    * Allows `_spender` to spend no more than `_value` tokens in your behalf
883    *
884    * @param _spender The address authorized to spend
885    * @param _value the max amount they can spend
886    */
887   function approve(address _spender, uint256 _value)
888   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_spender)
889   public returns (bool) {
890     _allowance.setAllowance(msg.sender, _spender, _value);
891     emit Approval(msg.sender, _spender, _value);
892     return true;
893   }
894 
895   /**
896    * @dev Increase the amount of tokens that an owner allowed to a spender.
897    *
898    * approve should be called when allowed[_spender] == 0. To increment
899    * allowed value is better to use this function to avoid 2 calls (and wait until
900    * the first transaction is mined)
901    * From MonolithDAO Token.sol
902    * @param _spender The address which will spend the funds.
903    * @param _addedValue The amount of tokens to increase the allowance by.
904    */
905   function increaseApproval(address _spender, uint256 _addedValue)
906   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_spender)
907   public returns (bool) {
908     _allowance.addAllowance(msg.sender, _spender, _addedValue);
909     emit Approval(msg.sender, _spender, _allowance.allowanceOf(msg.sender, _spender));
910     return true;
911   }
912 
913   /**
914    * @dev Decrease the amount of tokens that an owner allowed to a spender.
915    *
916    * approve should be called when allowed[_spender] == 0. To decrement
917    * allowed value is better to use this function to avoid 2 calls (and wait until
918    * the first transaction is mined)
919    * From MonolithDAO Token.sol
920    * @param _spender The address which will spend the funds.
921    * @param _subtractedValue The amount of tokens to decrease the allowance by.
922    */
923   function decreaseApproval(address _spender, uint256 _subtractedValue)
924   whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyNotBlacklistedAddr(_spender) onlyVerifiedAddr(msg.sender) onlyVerifiedAddr(_spender)
925   public returns (bool) {
926     _allowance.subAllowance(msg.sender, _spender, _subtractedValue);
927     emit Approval(msg.sender, _spender, _allowance.allowanceOf(msg.sender, _spender));
928     return true;
929   }
930 
931   /**
932    * @dev Destroy tokens
933    * Remove `_value` tokens from the system irreversibly
934    *
935    * @param _value the amount of money to burn
936    */
937   function burn(uint256 _value) whenNotPaused onlyNotBlacklistedAddr(msg.sender) onlyVerifiedAddr(msg.sender)
938   public returns (bool success) {
939     require(_balances.balanceOf(msg.sender) >= _value);         // Check if the sender has enough
940     _balances.subBalance(msg.sender, _value);                   // Subtract from the sender
941     _balances.subTotalSupply(_value);                           // Updates totalSupply
942     emit Burn(msg.sender, _value);
943     return true;
944   }
945 
946   /**
947    * @dev Change name and symbol of the tokens
948    *
949    * @param _name the new name of the token
950    * @param _symbol the new symbol of the token
951    */
952   function changeName(string _name, string _symbol) onlyOwner whenNotPaused public {
953     name = _name;
954     symbol = _symbol;
955   }
956 }