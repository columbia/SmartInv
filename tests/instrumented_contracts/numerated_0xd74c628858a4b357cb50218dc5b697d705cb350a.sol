1 pragma solidity >= 0.5.0;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Unsigned math operations with safety checks that revert on error
77  */
78 library SafeMath {
79     /**
80     * @dev Multiplies two unsigned integers, reverts on overflow.
81     */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b);
92 
93         return c;
94     }
95 
96     /**
97     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
98     */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
110     */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b <= a);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119     * @dev Adds two unsigned integers, reverts on overflow.
120     */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130     * reverts when dividing by zero.
131     */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0);
134         return a % b;
135     }
136 }
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 interface IERC20 {
143     function transfer(address to, uint256 value) external returns (bool);
144 
145     function approve(address spender, uint256 value) external returns (bool);
146 
147     function transferFrom(address from, address to, uint256 value) external returns (bool);
148 
149     function totalSupply() external view returns (uint256);
150 
151     function balanceOf(address who) external view returns (uint256);
152 
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  *
163  * @dev Implementation of the basic standard token.
164  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
165  * Originally based on code by FirstBlood:
166  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  *
168  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
169  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
170  * compliant implementations may not do it.
171  */
172 contract ERC20 is IERC20 {
173     using SafeMath for uint256;
174 
175     mapping (address => uint256) private _balances;
176 
177     mapping (address => mapping (address => uint256)) private _allowed;
178 
179     uint256 private _totalSupply;
180 
181     /**
182     * @dev Total number of tokens in existence
183     */
184     function totalSupply() public view returns (uint256) {
185         return _totalSupply;
186     }
187 
188     /**
189     * @dev Gets the balance of the specified address.
190     * @param owner The address to query the balance of.
191     * @return An uint256 representing the amount owned by the passed address.
192     */
193     function balanceOf(address owner) public view returns (uint256) {
194         return _balances[owner];
195     }
196 
197     /**
198      * @dev Function to check the amount of tokens that an owner allowed to a spender.
199      * @param owner address The address which owns the funds.
200      * @param spender address The address which will spend the funds.
201      * @return A uint256 specifying the amount of tokens still available for the spender.
202      */
203     function allowance(address owner, address spender) public view returns (uint256) {
204         return _allowed[owner][spender];
205     }
206 
207     /**
208     * @dev Transfer token for a specified address
209     * @param to The address to transfer to.
210     * @param value The amount to be transferred.
211     */
212     function transfer(address to, uint256 value) public returns (bool) {
213         _transfer(msg.sender, to, value);
214         return true;
215     }
216 
217     /**
218      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219      * Beware that changing an allowance with this method brings the risk that someone may use both the old
220      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      * @param spender The address which will spend the funds.
224      * @param value The amount of tokens to be spent.
225      */
226     function approve(address spender, uint256 value) public returns (bool) {
227         require(spender != address(0));
228 
229         _allowed[msg.sender][spender] = value;
230         emit Approval(msg.sender, spender, value);
231         return true;
232     }
233 
234     /**
235      * @dev Transfer tokens from one address to another.
236      * Note that while this function emits an Approval event, this is not required as per the specification,
237      * and other compliant implementations may not emit the event.
238      * @param from address The address which you want to send tokens from
239      * @param to address The address which you want to transfer to
240      * @param value uint256 the amount of tokens to be transferred
241      */
242     function transferFrom(address from, address to, uint256 value) public returns (bool) {
243         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
244         _transfer(from, to, value);
245         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
246         return true;
247     }
248 
249     /**
250      * @dev Increase the amount of tokens that an owner allowed to a spender.
251      * approve should be called when allowed_[_spender] == 0. To increment
252      * allowed value is better to use this function to avoid 2 calls (and wait until
253      * the first transaction is mined)
254      * From MonolithDAO Token.sol
255      * Emits an Approval event.
256      * @param spender The address which will spend the funds.
257      * @param addedValue The amount of tokens to increase the allowance by.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
260         require(spender != address(0));
261 
262         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
263         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
264         return true;
265     }
266 
267     /**
268      * @dev Decrease the amount of tokens that an owner allowed to a spender.
269      * approve should be called when allowed_[_spender] == 0. To decrement
270      * allowed value is better to use this function to avoid 2 calls (and wait until
271      * the first transaction is mined)
272      * From MonolithDAO Token.sol
273      * Emits an Approval event.
274      * @param spender The address which will spend the funds.
275      * @param subtractedValue The amount of tokens to decrease the allowance by.
276      */
277     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
281         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282         return true;
283     }
284 
285     /**
286     * @dev Transfer token for a specified addresses
287     * @param from The address to transfer from.
288     * @param to The address to transfer to.
289     * @param value The amount to be transferred.
290     */
291     function _transfer(address from, address to, uint256 value) internal {
292         require(to != address(0));
293 
294         _balances[from] = _balances[from].sub(value);
295         _balances[to] = _balances[to].add(value);
296         emit Transfer(from, to, value);
297     }
298 
299     /**
300      * @dev Internal function that mints an amount of the token and assigns it to
301      * an account. This encapsulates the modification of balances such that the
302      * proper events are emitted.
303      * @param account The account that will receive the created tokens.
304      * @param value The amount that will be created.
305      */
306     function _mint(address account, uint256 value) internal {
307         require(account != address(0));
308 
309         _totalSupply = _totalSupply.add(value);
310         _balances[account] = _balances[account].add(value);
311         emit Transfer(address(0), account, value);
312     }
313 
314     /**
315      * @dev Internal function that burns an amount of the token of a given
316      * account.
317      * @param account The account whose tokens will be burnt.
318      * @param value The amount that will be burnt.
319      */
320     function _burn(address account, uint256 value) internal {
321         require(account != address(0));
322 
323         _totalSupply = _totalSupply.sub(value);
324         _balances[account] = _balances[account].sub(value);
325         emit Transfer(account, address(0), value);
326     }
327 
328     /**
329      * @dev Internal function that burns an amount of the token of a given
330      * account, deducting from the sender's allowance for said account. Uses the
331      * internal burn function.
332      * Emits an Approval event (reflecting the reduced allowance).
333      * @param account The account whose tokens will be burnt.
334      * @param value The amount that will be burnt.
335      */
336     function _burnFrom(address account, uint256 value) internal {
337         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
338         _burn(account, value);
339         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
340     }
341 }
342 
343 contract Constants {
344     uint public constant UNLOCK_COUNT = 7;
345 }
346 
347 contract CardioCoin is ERC20, Ownable, Constants {
348     using SafeMath for uint256;
349 
350     uint public constant RESELLER_UNLOCK_TIME = 1559347200; 
351     uint public constant UNLOCK_PERIOD = 30 days;
352 
353     string public name = "CardioCoin";
354     string public symbol = "CRDC";
355 
356     uint8 public decimals = 18;
357     uint256 internal totalSupply_ = 50000000000 * (10 ** uint256(decimals));
358 
359     mapping (address => uint256) internal reselling;
360     uint256 internal resellingAmount = 0;
361 
362     struct locker {
363         bool isLocker;
364         string role;
365         uint lockUpPeriod;
366         uint unlockCount;
367         bool isReseller;
368     }
369 
370     mapping (address => locker) internal lockerList;
371 
372     event AddToLocker(address indexed owner, string role, uint lockUpPeriod, uint unlockCount);
373     event AddToReseller(address indexed owner);
374 
375     event ResellingAdded(address indexed seller, uint256 amount);
376     event ResellingSubtracted(address indexed seller, uint256 amount);
377     event Reselled(address indexed seller, address indexed buyer, uint256 amount);
378 
379     event TokenLocked(address indexed owner, uint256 amount);
380     event TokenUnlocked(address indexed owner, uint256 amount);
381 
382     constructor() public Ownable() {
383         balance memory b;
384 
385         b.available = totalSupply_;
386         balances[msg.sender] = b;
387     }
388 
389     function addLockedUpTokens(address _owner, uint256 amount, uint lockUpPeriod, uint unlockCount)
390     internal {
391         balance storage b = balances[_owner];
392         lockUp memory l;
393 
394         l.amount = amount;
395         l.unlockTimestamp = now + lockUpPeriod;
396         l.unlockCount = unlockCount;
397         b.lockedUp += amount;
398         b.lockUpData[b.lockUpCount] = l;
399         b.lockUpCount += 1;
400         emit TokenLocked(_owner, amount);
401     }
402 
403     // Reselling
404 
405     function addAddressToResellerList(address _operator)
406     public
407     onlyOwner {
408         locker storage existsLocker = lockerList[_operator];
409 
410         require(!existsLocker.isLocker);
411 
412         locker memory l;
413 
414         l.isLocker = true;
415         l.role = "Reseller";
416         l.lockUpPeriod = RESELLER_UNLOCK_TIME;
417         l.unlockCount = UNLOCK_COUNT;
418         l.isReseller = true;
419         lockerList[_operator] = l;
420         emit AddToReseller(_operator);
421     }
422 
423     function addResellingAmount(address seller, uint256 amount)
424     public
425     onlyOwner
426     {
427         require(seller != address(0));
428         require(amount > 0);
429         require(balances[seller].available >= amount);
430 
431         reselling[seller] = reselling[seller].add(amount);
432         balances[seller].available = balances[seller].available.sub(amount);
433         resellingAmount = resellingAmount.add(amount);
434         emit ResellingAdded(seller, amount);
435     }
436 
437     function subtractResellingAmount(address seller, uint256 _amount)
438     public
439     onlyOwner
440     {
441         uint256 amount = reselling[seller];
442 
443         require(seller != address(0));
444         require(_amount > 0);
445         require(amount >= _amount);
446 
447         reselling[seller] = reselling[seller].sub(_amount);
448         resellingAmount = resellingAmount.sub(_amount);
449         balances[seller].available = balances[seller].available.add(_amount);
450         emit ResellingSubtracted(seller, _amount);
451     }
452 
453     function cancelReselling(address seller)
454     public
455     onlyOwner {
456         uint256 amount = reselling[seller];
457 
458         require(seller != address(0));
459         require(amount > 0);
460 
461         subtractResellingAmount(seller, amount);
462     }
463 
464     function resell(address seller, address buyer, uint256 amount)
465     public
466     onlyOwner
467     returns (bool)
468     {
469         require(seller != address(0));
470         require(buyer != address(0));
471         require(amount > 0);
472         require(reselling[seller] >= amount);
473         require(balances[owner()].available >= amount);
474 
475         reselling[seller] = reselling[seller].sub(amount);
476         resellingAmount = resellingAmount.sub(amount);
477         addLockedUpTokens(buyer, amount, RESELLER_UNLOCK_TIME - now, UNLOCK_COUNT);
478         emit Reselled(seller, buyer, amount);
479 
480         return true;
481     }
482 
483     // ERC20 Custom
484 
485     struct lockUp {
486         uint256 amount;
487         uint unlockTimestamp;
488         uint unlockedCount;
489         uint unlockCount;
490     }
491 
492     struct balance {
493         uint256 available;
494         uint256 lockedUp;
495         mapping (uint => lockUp) lockUpData;
496         uint lockUpCount;
497         uint unlockIndex;
498     }
499 
500     mapping(address => balance) internal balances;
501 
502     function unlockBalance(address _owner) internal {
503         balance storage b = balances[_owner];
504 
505         if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {
506             for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {
507                 lockUp storage l = b.lockUpData[i];
508 
509                 if (l.unlockTimestamp <= now) {
510                     uint count = calculateUnlockCount(l.unlockTimestamp, l.unlockedCount, l.unlockCount);
511                     uint256 unlockedAmount = l.amount.mul(count).div(l.unlockCount);
512 
513                     if (unlockedAmount > b.lockedUp) {
514                         unlockedAmount = b.lockedUp;
515                         l.unlockedCount = l.unlockCount;
516                     } else {
517                         b.available = b.available.add(unlockedAmount);
518                         b.lockedUp = b.lockedUp.sub(unlockedAmount);
519                         l.unlockedCount += count;
520                     }
521                     emit TokenUnlocked(_owner, unlockedAmount);
522                     if (l.unlockedCount == l.unlockCount) {
523                         lockUp memory tempA = b.lockUpData[i];
524                         lockUp memory tempB = b.lockUpData[b.unlockIndex];
525 
526                         b.lockUpData[i] = tempB;
527                         b.lockUpData[b.unlockIndex] = tempA;
528                         b.unlockIndex += 1;
529                     } else {
530                         l.unlockTimestamp += UNLOCK_PERIOD * count;
531                     }
532                 }
533             }
534         }
535     }
536 
537     function calculateUnlockCount(uint timestamp, uint unlockedCount, uint unlockCount) view internal returns (uint) {
538         uint count = 0;
539         uint nowFixed = now;
540 
541         while (timestamp < nowFixed && unlockedCount + count < unlockCount) {
542             count++;
543             timestamp += UNLOCK_PERIOD;
544         }
545 
546         return count;
547     }
548 
549     function totalSupply() public view returns (uint256) {
550         return totalSupply_;
551     }
552 
553     function _transfer(address from, address to, uint256 value) internal {
554         locker storage l = lockerList[from];
555 
556         if (l.isReseller && RESELLER_UNLOCK_TIME < now) {
557             l.isLocker = false;
558             l.isReseller = false;
559 
560             uint elapsedPeriod = (now - RESELLER_UNLOCK_TIME) / UNLOCK_PERIOD;
561 
562             if (elapsedPeriod < UNLOCK_COUNT) {
563                 balance storage b = balances[from];
564                 uint256 lockUpAmount = b.available * (UNLOCK_COUNT - elapsedPeriod) / UNLOCK_COUNT;
565 
566                 b.available = b.available.sub(lockUpAmount);
567                 addLockedUpTokens(from, lockUpAmount, RESELLER_UNLOCK_TIME + UNLOCK_PERIOD * (elapsedPeriod + 1) - now, UNLOCK_COUNT - elapsedPeriod);
568             }
569         }
570         unlockBalance(from);
571 
572         require(value <= balances[from].available);
573         require(to != address(0));
574         if (l.isLocker) {
575             balances[from].available = balances[from].available.sub(value);
576             if (l.isReseller) {
577                 addLockedUpTokens(to, value, RESELLER_UNLOCK_TIME - now, UNLOCK_COUNT);
578             } else {
579                 addLockedUpTokens(to, value, l.lockUpPeriod, l.unlockCount);
580             }
581         } else {
582             balances[from].available = balances[from].available.sub(value);
583             balances[to].available = balances[to].available.add(value);
584         }
585         emit Transfer(from, to, value);
586     }
587 
588     function balanceOf(address _owner) public view returns (uint256) {
589         return balances[_owner].available.add(balances[_owner].lockedUp);
590     }
591 
592     function lockedUpBalanceOf(address _owner) public view returns (uint256) {
593         balance storage b = balances[_owner];
594         uint256 lockedUpBalance = b.lockedUp;
595 
596         if (b.lockUpCount > 0 && b.unlockIndex < b.lockUpCount) {
597             for (uint i = b.unlockIndex; i < b.lockUpCount; i++) {
598                 lockUp storage l = b.lockUpData[i];
599 
600                 if (l.unlockTimestamp <= now) {
601                     uint count = calculateUnlockCount(l.unlockTimestamp, l.unlockedCount, l.unlockCount);
602                     uint256 unlockedAmount = l.amount.mul(count).div(l.unlockCount);
603 
604                     if (unlockedAmount > lockedUpBalance) {
605                         lockedUpBalance = 0;
606                         break;
607                     } else {
608                         lockedUpBalance = lockedUpBalance.sub(unlockedAmount);
609                     }
610                 }
611             }
612         }
613 
614         return lockedUpBalance;
615     }
616 
617     function resellingBalanceOf(address _owner) public view returns (uint256) {
618         return reselling[_owner];
619     }
620 
621     function transferWithLockUp(address _to, uint256 _value, uint lockUpPeriod, uint unlockCount)
622     public
623     onlyOwner
624     returns (bool) {
625         require(_value <= balances[owner()].available);
626         require(_to != address(0));
627 
628         balances[owner()].available = balances[owner()].available.sub(_value);
629         addLockedUpTokens(_to, _value, lockUpPeriod, unlockCount);
630         emit Transfer(msg.sender, _to, _value);
631 
632         return true;
633     }
634 
635     // Burnable
636 
637     event Burn(address indexed burner, uint256 value);
638 
639     function burn(uint256 _value) public {
640         _burn(msg.sender, _value);
641     }
642 
643     function _burn(address _who, uint256 _value) internal {
644         require(_value <= balances[_who].available);
645 
646         balances[_who].available = balances[_who].available.sub(_value);
647         totalSupply_ = totalSupply_.sub(_value);
648         emit Burn(_who, _value);
649         emit Transfer(_who, address(0), _value);
650     }
651 
652     // Lockup
653 
654     function addAddressToLockerList(address _operator, string memory role, uint lockUpPeriod, uint unlockCount)
655     public
656     onlyOwner {
657         locker storage existsLocker = lockerList[_operator];
658 
659         require(!existsLocker.isLocker);
660 
661         locker memory l;
662 
663         l.isLocker = true;
664         l.role = role;
665         l.lockUpPeriod = lockUpPeriod;
666         l.unlockCount = unlockCount;
667         l.isReseller = false;
668         lockerList[_operator] = l;
669         emit AddToLocker(_operator, role, lockUpPeriod, unlockCount);
670     }
671 
672     function lockerInfo(address _operator) public view returns (string memory, uint, uint, bool) {
673         locker memory l = lockerList[_operator];
674 
675         return (l.role, l.lockUpPeriod, l.unlockCount, l.isReseller);
676     }
677 
678     // Refund
679 
680     event RefundRequested(address indexed reuqester, uint256 tokenAmount, uint256 paidAmount);
681     event RefundCanceled(address indexed requester);
682     event RefundAccepted(address indexed requester, address indexed tokenReceiver, uint256 tokenAmount, uint256 paidAmount);
683 
684     struct refundRequest {
685         bool active;
686         uint256 tokenAmount;
687         uint256 paidAmount;
688         address buyFrom;
689     }
690 
691     mapping (address => refundRequest) internal refundRequests;
692 
693     function requestRefund(uint256 paidAmount, address buyFrom) public {
694         require(!refundRequests[msg.sender].active);
695 
696         refundRequest memory r;
697 
698         r.active = true;
699         r.tokenAmount = balanceOf(msg.sender);
700         r.paidAmount = paidAmount;
701         r.buyFrom = buyFrom;
702         refundRequests[msg.sender] = r;
703 
704         emit RefundRequested(msg.sender, r.tokenAmount, r.paidAmount);
705     }
706 
707     function cancelRefund() public {
708         require(refundRequests[msg.sender].active);
709         refundRequests[msg.sender].active = false;
710         emit RefundCanceled(msg.sender);
711     }
712 
713     function acceptRefundForOwner(address payable requester, address receiver) public payable onlyOwner {
714         require(requester != address(0));
715         require(receiver != address(0));
716 
717         refundRequest storage r = refundRequests[requester];
718 
719         require(r.active);
720         require(balanceOf(requester) == r.tokenAmount);
721         require(msg.value == r.paidAmount);
722         require(r.buyFrom == owner());
723         requester.transfer(msg.value);
724         transferForRefund(requester, receiver, r.tokenAmount);
725         r.active = false;
726         emit RefundAccepted(requester, receiver, r.tokenAmount, msg.value);
727     }
728 
729     function acceptRefundForReseller(address payable requester) public payable {
730         require(requester != address(0));
731 
732         locker memory l = lockerList[msg.sender];
733 
734         require(l.isReseller);
735 
736         refundRequest storage r = refundRequests[requester];
737 
738         require(r.active);
739         require(balanceOf(requester) == r.tokenAmount);
740         require(msg.value == r.paidAmount);
741         require(r.buyFrom == msg.sender);
742         requester.transfer(msg.value);
743         transferForRefund(requester, msg.sender, r.tokenAmount);
744         r.active = false;
745         emit RefundAccepted(requester, msg.sender, r.tokenAmount, msg.value);
746     }
747 
748     function refundInfo(address requester) public view returns (bool, uint256, uint256) {
749         refundRequest memory r = refundRequests[requester];
750 
751         return (r.active, r.tokenAmount, r.paidAmount);
752     }
753 
754     function transferForRefund(address from, address to, uint256 amount) internal {
755         require(balanceOf(from) == amount);
756 
757         unlockBalance(from);
758 
759         balance storage fromBalance = balances[from];
760         balance storage toBalance = balances[to];
761 
762         fromBalance.available = 0;
763         fromBalance.lockedUp = 0;
764         fromBalance.unlockIndex = fromBalance.lockUpCount;
765         toBalance.available = toBalance.available.add(amount);
766 
767         emit Transfer(from, to, amount);
768     }
769 }