1 pragma solidity 0.6.6;
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 
6 // SPDX-License-Identifier: Unlicensed
7 
8 library AddressSet {
9     
10     struct Set {
11         mapping(address => uint) keyPointers;
12         address[] keyList;
13     }
14 
15     /**
16      * @notice insert a key. 
17      * @dev duplicate keys are not permitted.
18      * @param self storage pointer to a Set. 
19      * @param key value to insert.
20      */    
21     function insert(Set storage self, address key) internal {
22         require(!exists(self, key), "AddressSet: key already exists in the set.");
23         self.keyPointers[key] = self.keyList.length;
24         self.keyList.push(key);
25     }
26 
27     /**
28      * @notice remove a key.
29      * @dev key to remove must exist. 
30      * @param self storage pointer to a Set.
31      * @param key value to remove.
32      */    
33     function remove(Set storage self, address key) internal {
34         require(exists(self, key), "AddressSet: key does not exist in the set.");
35         uint last = count(self) - 1;
36         uint rowToReplace = self.keyPointers[key];
37         if(rowToReplace != last) {
38             address keyToMove = self.keyList[last];
39             self.keyPointers[keyToMove] = rowToReplace;
40             self.keyList[rowToReplace] = keyToMove;
41         }
42         delete self.keyPointers[key];
43         self.keyList.pop;
44     }
45 
46     /**
47      * @notice count the keys.
48      * @param self storage pointer to a Set. 
49      */       
50     function count(Set storage self) internal view returns(uint) {
51         return(self.keyList.length);
52     }
53 
54     /**
55      * @notice check if a key is in the Set.
56      * @param self storage pointer to a Set.
57      * @param key value to check. 
58      * @return bool true: Set member, false: not a Set member.
59      */  
60     function exists(Set storage self, address key) internal view returns(bool) {
61         if(self.keyList.length == 0) return false;
62         return self.keyList[self.keyPointers[key]] == key;
63     }
64 
65     /**
66      * @notice fetch a key by row (enumerate).
67      * @param self storage pointer to a Set.
68      * @param index row to enumerate. Must be < count() - 1.
69      */      
70     function keyAtIndex(Set storage self, uint index) internal view returns(address) {
71         return self.keyList[index];
72     }
73 }
74 
75 // SPDX-License-Identifier: MIT
76 
77 // SPDX-License-Identifier: MIT
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         // Solidity only automatically asserts when dividing by 0
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b != 0, errorMessage);
225         return a % b;
226     }
227 }
228 
229 // SPDX-License-Identifier: Unlicensed
230 
231 library Bytes32Set {
232     
233     struct Set {
234         mapping(bytes32 => uint) keyPointers;
235         bytes32[] keyList;
236     }
237     
238     /**
239      * @notice insert a key. 
240      * @dev duplicate keys are not permitted.
241      * @param self storage pointer to a Set. 
242      * @param key value to insert.
243      */
244     function insert(Set storage self, bytes32 key) internal {
245         require(!exists(self, key), "Bytes32Set: key already exists in the set.");
246         self.keyPointers[key] = self.keyList.length;
247         self.keyList.push(key);
248     }
249 
250     /**
251      * @notice remove a key.
252      * @dev key to remove must exist. 
253      * @param self storage pointer to a Set.
254      * @param key value to remove.
255      */
256     function remove(Set storage self, bytes32 key) internal {
257         require(exists(self, key), "Bytes32Set: key does not exist in the set.");
258         uint last = count(self) - 1;
259         uint rowToReplace = self.keyPointers[key];
260         if(rowToReplace != last) {
261             bytes32 keyToMove = self.keyList[last];
262             self.keyPointers[keyToMove] = rowToReplace;
263             self.keyList[rowToReplace] = keyToMove;
264         }
265         delete self.keyPointers[key];
266         self.keyList.pop();
267     }
268 
269     /**
270      * @notice count the keys.
271      * @param self storage pointer to a Set. 
272      */    
273     function count(Set storage self) internal view returns(uint) {
274         return(self.keyList.length);
275     }
276     
277     /**
278      * @notice check if a key is in the Set.
279      * @param self storage pointer to a Set.
280      * @param key value to check. 
281      * @return bool true: Set member, false: not a Set member.
282      */
283     function exists(Set storage self, bytes32 key) internal view returns(bool) {
284         if(self.keyList.length == 0) return false;
285         return self.keyList[self.keyPointers[key]] == key;
286     }
287 
288     /**
289      * @notice fetch a key by row (enumerate).
290      * @param self storage pointer to a Set.
291      * @param index row to enumerate. Must be < count() - 1.
292      */    
293     function keyAtIndex(Set storage self, uint index) internal view returns(bytes32) {
294         return self.keyList[index];
295     }
296 }
297 
298 library FIFOSet {
299     
300     using SafeMath for uint;
301     using Bytes32Set for Bytes32Set.Set;
302     
303     bytes32 constant NULL = bytes32(0);
304     
305     struct FIFO {
306         bytes32 firstKey;
307         bytes32 lastKey;
308         mapping(bytes32 => KeyStruct) keyStructs;
309         Bytes32Set.Set keySet;
310     }
311 
312     struct KeyStruct {
313             bytes32 nextKey;
314             bytes32 previousKey;
315     }
316 
317     function count(FIFO storage self) internal view returns(uint) {
318         return self.keySet.count();
319     }
320     
321     function first(FIFO storage self) internal view returns(bytes32) {
322         return self.firstKey;
323     }
324     
325     function last(FIFO storage self) internal view returns(bytes32) {
326         return self.lastKey;
327     }
328     
329     function exists(FIFO storage self, bytes32 key) internal view returns(bool) {
330         return self.keySet.exists(key);
331     }
332     
333     function isFirst(FIFO storage self, bytes32 key) internal view returns(bool) {
334         return key==self.firstKey;
335     }
336     
337     function isLast(FIFO storage self, bytes32 key) internal view returns(bool) {
338         return key==self.lastKey;
339     }    
340     
341     function previous(FIFO storage self, bytes32 key) internal view returns(bytes32) {
342         require(exists(self, key), "FIFOSet: key not found") ;
343         return self.keyStructs[key].previousKey;
344     }
345     
346     function next(FIFO storage self, bytes32 key) internal view returns(bytes32) {
347         require(exists(self, key), "FIFOSet: key not found");
348         return self.keyStructs[key].nextKey;
349     }
350     
351     function append(FIFO storage self, bytes32 key) internal {
352         require(key != NULL, "FIFOSet: key cannot be zero");
353         require(!exists(self, key), "FIFOSet: duplicate key"); 
354         bytes32 lastKey = self.lastKey;
355         KeyStruct storage k = self.keyStructs[key];
356         KeyStruct storage l = self.keyStructs[lastKey];
357         if(lastKey==NULL) {                
358             self.firstKey = key;
359         } else {
360             l.nextKey = key;
361         }
362         k.previousKey = lastKey;
363         self.keySet.insert(key);
364         self.lastKey = key;
365     }
366 
367     function remove(FIFO storage self, bytes32 key) internal {
368         require(exists(self, key), "FIFOSet: key not found");
369         KeyStruct storage k = self.keyStructs[key];
370         bytes32 keyBefore = k.previousKey;
371         bytes32 keyAfter = k.nextKey;
372         bytes32 firstKey = first(self);
373         bytes32 lastKey = last(self);
374         KeyStruct storage p = self.keyStructs[keyBefore];
375         KeyStruct storage n = self.keyStructs[keyAfter];
376         
377         if(count(self) == 1) {
378             self.firstKey = NULL;
379             self.lastKey = NULL;
380         } else {
381             if(key == firstKey) {
382                 n.previousKey = NULL;
383                 self.firstKey = keyAfter;  
384             } else 
385             if(key == lastKey) {
386                 p.nextKey = NULL;
387                 self.lastKey = keyBefore;
388             } else {
389                 p.nextKey = keyAfter;
390                 n.previousKey = keyBefore;
391             }
392         }
393         self.keySet.remove(key);
394         delete self.keyStructs[key];
395     }
396 }
397 // SPDX-License-Identifier: MIT
398 
399 
400 // SPDX-License-Identifier: MIT
401 
402 
403 /*
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with GSN meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 contract Context {
414     // Empty internal constructor, to prevent people from mistakenly deploying
415     // an instance of this contract, which should be used via inheritance.
416     constructor () internal { }
417 
418     function _msgSender() internal view virtual returns (address payable) {
419         return msg.sender;
420     }
421 
422     function _msgData() internal view virtual returns (bytes memory) {
423         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
424         return msg.data;
425     }
426 }
427 /**
428  * @dev Contract module which provides a basic access control mechanism, where
429  * there is an account (an owner) that can be granted exclusive access to
430  * specific functions.
431  *
432  * By default, the owner account will be the one that deploys the contract. This
433  * can later be changed with {transferOwnership}.
434  *
435  * This module is used through inheritance. It will make available the modifier
436  * `onlyOwner`, which can be applied to your functions to restrict their use to
437  * the owner.
438  */
439 contract Ownable is Context {
440     address private _owner;
441 
442     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
443 
444     /**
445      * @dev Initializes the contract setting the deployer as the initial owner.
446      */
447     constructor () internal {
448         address msgSender = _msgSender();
449         _owner = msgSender;
450         emit OwnershipTransferred(address(0), msgSender);
451     }
452 
453     /**
454      * @dev Returns the address of the current owner.
455      */
456     function owner() public view returns (address) {
457         return _owner;
458     }
459 
460     /**
461      * @dev Throws if called by any account other than the owner.
462      */
463     modifier onlyOwner() {
464         require(_owner == _msgSender(), "Ownable: caller is not the owner");
465         _;
466     }
467 
468     /**
469      * @dev Leaves the contract without owner. It will not be possible to call
470      * `onlyOwner` functions anymore. Can only be called by the current owner.
471      *
472      * NOTE: Renouncing ownership will leave the contract without an owner,
473      * thereby removing any functionality that is only available to the owner.
474      */
475     function renounceOwnership() public virtual onlyOwner {
476         emit OwnershipTransferred(_owner, address(0));
477         _owner = address(0);
478     }
479 
480     /**
481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
482      * Can only be called by the current owner.
483      */
484     function transferOwnership(address newOwner) public virtual onlyOwner {
485         require(newOwner != address(0), "Ownable: new owner is the zero address");
486         emit OwnershipTransferred(_owner, newOwner);
487         _owner = newOwner;
488     }
489 }
490 // SPDX-License-Identifier: MIT
491 
492 
493 /**
494  * @dev Interface of the ERC20 standard as defined in the EIP.
495  */
496 interface IERC20 {
497     /**
498      * @dev Returns the amount of tokens in existence.
499      */
500     function totalSupply() external view returns (uint256);
501 
502     /**
503      * @dev Returns the amount of tokens owned by `account`.
504      */
505     function balanceOf(address account) external view returns (uint256);
506 
507     /**
508      * @dev Moves `amount` tokens from the caller's account to `recipient`.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transfer(address recipient, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Returns the remaining number of tokens that `spender` will be
518      * allowed to spend on behalf of `owner` through {transferFrom}. This is
519      * zero by default.
520      *
521      * This value changes when {approve} or {transferFrom} are called.
522      */
523     function allowance(address owner, address spender) external view returns (uint256);
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * IMPORTANT: Beware that changing an allowance with this method brings the risk
531      * that someone may use both the old and the new allowance by unfortunate
532      * transaction ordering. One possible solution to mitigate this race
533      * condition is to first reduce the spender's allowance to 0 and set the
534      * desired value afterwards:
535      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address spender, uint256 amount) external returns (bool);
540 
541     /**
542      * @dev Moves `amount` tokens from `sender` to `recipient` using the
543      * allowance mechanism. `amount` is then deducted from the caller's
544      * allowance.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
551 
552     /**
553      * @dev Emitted when `value` tokens are moved from one account (`from`) to
554      * another (`to`).
555      *
556      * Note that `value` may be zero.
557      */
558     event Transfer(address indexed from, address indexed to, uint256 value);
559 
560     /**
561      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
562      * a call to {approve}. `value` is the new allowance.
563      */
564     event Approval(address indexed owner, address indexed spender, uint256 value);
565 }
566 // SPDX-License-Identifier: MIT
567 
568 
569 /**
570  * @dev Collection of functions related to the address type
571  */
572 library Address {
573     /**
574      * @dev Returns true if `account` is a contract.
575      *
576      * [IMPORTANT]
577      * ====
578      * It is unsafe to assume that an address for which this function returns
579      * false is an externally-owned account (EOA) and not a contract.
580      *
581      * Among others, `isContract` will return false for the following
582      * types of addresses:
583      *
584      *  - an externally-owned account
585      *  - a contract in construction
586      *  - an address where a contract will be created
587      *  - an address where a contract lived, but was destroyed
588      * ====
589      */
590     function isContract(address account) internal view returns (bool) {
591         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
592         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
593         // for accounts without code, i.e. `keccak256('')`
594         bytes32 codehash;
595         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
596         // solhint-disable-next-line no-inline-assembly
597         assembly { codehash := extcodehash(account) }
598         return (codehash != accountHash && codehash != 0x0);
599     }
600 
601     /**
602      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
603      * `recipient`, forwarding all available gas and reverting on errors.
604      *
605      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
606      * of certain opcodes, possibly making contracts go over the 2300 gas limit
607      * imposed by `transfer`, making them unable to receive funds via
608      * `transfer`. {sendValue} removes this limitation.
609      *
610      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
611      *
612      * IMPORTANT: because control is transferred to `recipient`, care must be
613      * taken to not create reentrancy vulnerabilities. Consider using
614      * {ReentrancyGuard} or the
615      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
616      */
617     function sendValue(address payable recipient, uint256 amount) internal {
618         require(address(this).balance >= amount, "Address: insufficient balance");
619 
620         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
621         (bool success, ) = recipient.call{ value: amount }("");
622         require(success, "Address: unable to send value, recipient may have reverted");
623     }
624 }
625 
626 interface Maker {
627     function read() external view returns(uint);
628 }
629 
630 contract HodlDex is Ownable {
631     
632     using Address for address payable;                              // OpenZeppelin address utility
633     using SafeMath for uint;                                        // OpenZeppelin safeMath utility
634     using Bytes32Set for Bytes32Set.Set;                            // Unordered key sets
635     using AddressSet for AddressSet.Set;                            // Unordered address sets
636     using FIFOSet for FIFOSet.FIFO;                                 // FIFO key sets
637     
638     Maker maker = Maker(0x729D19f657BD0614b4985Cf1D82531c67569197B);// EthUsd price Oracle
639 
640     bytes32 constant NULL = bytes32(0); 
641     uint constant HODL_PRECISION = 10 ** 10;                        // HODL token decimal places
642     uint constant USD_PRECISION = 10 ** 18;                         // Precision for HODL:USD
643     uint constant TOTAL_SUPPLY = 20000000 * (10**10);               // Total supply - initially goes to the reserve, which is address(this)
644     uint constant SLEEP_TIME = 30 days;                             // Grace period before time-based accrual kicks in
645     uint constant DAILY_ACCRUAL_RATE_DECAY = 999999838576236000;    // Rate of decay applied daily reduces daily accrual APR to about 5% after 30 years
646     uint constant USD_TXN_ADJUSTMENT = 10**14;                      // $0.0001 with 18 decimal places of precision - 1/100th of a cent
647     
648     uint public BIRTHDAY;                                           // Now time when the contract was deployed
649     uint public minOrderUsd = 50 * 10 ** 18;                        // Minimum order size is $50 in USD precision
650     uint public maxOrderUsd = 500 * 10 ** 18;                       // Maximum order size is $500 is USD precision
651     uint public maxThresholdUsd = 10 * 10 ** 18;                    // Order limits removed when HODL_USD exceeds $10
652     uint public maxDistributionUsd = 250 * 10 ** 18;                // Maximum distribution value
653     uint public accrualDaysProcessed;                               // Days of stateful accrual applied
654     uint public distributionNext;                                   // Next distribution to process cursor
655     uint public entropyCounter;                                     // Tally of unique order IDs and distributions generated 
656     uint public distributionDelay = 1 days;                         // Reserve sale distribution delay
657 
658     IERC20 token;                                                   // The HODL ERC20 tradable token 
659  
660     /**************************************************************************************
661      * @dev The following values are inspected through the rates() function
662      **************************************************************************************/
663 
664     uint private HODL_USD;                                          // HODL:USD exchange rate last recorded
665     uint private DAILY_ACCRUAL_RATE = 1001900837677230000;          // Initial daily accrual is 0.19% (100.19% multiplier) which is about 100% APR     
666     
667     struct User {
668         FIFOSet.FIFO sellOrderIdFifo;                               // User sell orders in no particular order
669         FIFOSet.FIFO buyOrderIdFifo;                                // User buy orders in no particular order
670         uint balanceEth;
671         uint balanceHodl;
672     }   
673     struct SellOrder {
674         address seller;
675         uint volumeHodl;
676         uint askUsd;
677     }    
678     struct BuyOrder {
679         address buyer;
680         uint bidEth;
681     }
682     struct Distribution {
683         uint amountEth;
684         uint timeStamp;
685     }
686     
687     mapping(address => User) userStruct;
688     mapping(bytes32 => SellOrder) public sellOrder;
689     mapping(bytes32 => BuyOrder) public buyOrder; 
690 
691     FIFOSet.FIFO sellOrderIdFifo;                                   // SELL orders in order of declaration
692     FIFOSet.FIFO buyOrderIdFifo;                                    // BUY orders in order of declaration
693     AddressSet.Set hodlerAddrSet;                                   // Users with a HODL balance > 0 in no particular order
694     Distribution[] public distribution;                             // Pending distributions in order of declaration
695     
696     modifier ifRunning {
697         require(isRunning(), "Contact is not initialized.");
698         _;
699     }
700     
701     // Deferred pseudo-random reserve sale proceeds distribution
702     modifier distribute {
703         uint distroEth;
704         if(distribution.length > distributionNext) {
705             Distribution storage d = distribution[distributionNext];
706             if(d.timeStamp.add(distributionDelay) < now) {
707                 uint entropy = uint(keccak256(abi.encodePacked(entropyCounter, HODL_USD, maker.read(), blockhash(block.number))));
708                 uint luckyWinnerRow = entropy % hodlerAddrSet.count();
709                 address winnerAddr = hodlerAddrSet.keyAtIndex(luckyWinnerRow);
710                 User storage w = userStruct[winnerAddr];
711                 if(convertEthToUsd(d.amountEth) > maxDistributionUsd) {
712                     distroEth = convertUsdToEth(maxDistributionUsd);
713                     d.amountEth = d.amountEth.sub(distroEth);
714                 } else {
715                     distroEth = d.amountEth;
716                     delete distribution[distributionNext];
717                     distributionNext = distributionNext.add(1);
718                 }
719                 w.balanceEth = w.balanceEth.add(distroEth);
720                 entropyCounter++;
721                 emit DistributionAwarded(msg.sender, distributionNext, winnerAddr, distroEth);
722             }
723         }
724         _;
725     }
726 
727     modifier accrueByTime {
728         _accrueByTime();
729         _;
730     }
731     
732     event DistributionAwarded(address processor, uint indexed index, address indexed recipient, uint amount);
733     event Deployed(address admin);
734     event HodlTIssued(address indexed user, uint amount);
735     event HodlTRedeemed(address indexed user, uint amount);
736     event SellHodlC(address indexed seller, uint quantityHodl, uint lowGas);
737     event SellOrderFilled(address indexed buyer, bytes32 indexed orderId, address indexed seller, uint txnEth, uint txnHodl);
738     event SellOrderOpened(bytes32 indexed orderId, address indexed seller, uint quantityHodl, uint askUsd);
739     event BuyHodlC(address indexed buyer, uint amountEth, uint lowGas);
740     event BuyOrderFilled(address indexed seller, bytes32 indexed orderId, address indexed buyer, uint txnEth, uint txnHodl);
741     event BuyOrderRefunded(address indexed seller, bytes32 indexed orderId, uint refundedEth);
742     event BuyFromReserve(address indexed buyer, uint txnEth, uint txnHodl);
743     event BuyOrderOpened(bytes32 indexed orderedId, address indexed buyer, uint amountEth);
744     event SellOrderCancelled(address indexed userAddr, bytes32 indexed orderId);
745     event BuyOrderCancelled(address indexed userAddr, bytes32 indexed orderId);
746     event UserDepositEth(address indexed user, uint amountEth);
747     event UserWithdrawEth(address indexed user, uint amountEth);
748     event UserInitialized(address admin, address indexed user, uint hodlCR, uint ethCR);
749     event UserUninitialized(address admin, address indexed user, uint hodlDB, uint ethDB);
750     event PriceSet(address admin, uint hodlUsd);
751     event TokenSet(address admin, address hodlToken);
752     event MakerSet(address admin, address maker);
753     
754     constructor() public {
755         userStruct[address(this)].balanceHodl = TOTAL_SUPPLY;
756         BIRTHDAY = now;
757         emit Deployed(msg.sender);
758     }
759 
760     function keyGen() private returns(bytes32 key) {
761         entropyCounter++;
762         return keccak256(abi.encodePacked(address(this), msg.sender, entropyCounter));
763     }
764 
765     /**************************************************************************************
766      * Anyone can nudge the time-based accrual forward
767      **************************************************************************************/ 
768 
769     function poke() external distribute ifRunning {
770         _accrueByTime();
771     }
772 
773     /**************************************************************************************
774      * 1:1 Convertability to HODLT ERC20
775      **************************************************************************************/    
776 
777     function hodlTIssue(uint amount) external distribute accrueByTime ifRunning {
778         User storage u = userStruct[msg.sender];
779         User storage t = userStruct[address(token)];
780         u.balanceHodl = u.balanceHodl.sub(amount);
781         t.balanceHodl = t.balanceHodl.add(amount);
782         _pruneHodler(msg.sender);
783         token.transfer(msg.sender, amount);
784         emit HodlTIssued(msg.sender, amount);
785     }
786 
787     function hodlTRedeem(uint amount) external distribute accrueByTime ifRunning {
788         User storage u = userStruct[msg.sender];
789         User storage t = userStruct[address(token)];
790         u.balanceHodl = u.balanceHodl.add(amount);
791         t.balanceHodl = t.balanceHodl.sub(amount);
792         _makeHodler(msg.sender);
793         token.transferFrom(msg.sender, address(this), amount);
794         emit HodlTRedeemed(msg.sender, amount);
795     }
796 
797     /**************************************************************************************
798      * Sell HodlC to buy orders, or if no buy orders open a sell order.
799      * Selectable low gas protects against future EVM price changes.
800      * Completes as much as possible (gas) and return unprocessed Hodl.
801      **************************************************************************************/ 
802 
803     function sellHodlC(uint quantityHodl, uint lowGas) external accrueByTime distribute ifRunning returns(bytes32 orderId) {
804         emit SellHodlC(msg.sender, quantityHodl, lowGas);
805         uint orderUsd = convertHodlToUsd(quantityHodl); 
806         uint orderLimit = orderLimit();
807         require(orderUsd >= minOrderUsd, "Sell order is less than minimum USD value");
808         require(orderUsd <= orderLimit || orderLimit == 0, "Order exceeds USD limit");
809         quantityHodl = _fillBuyOrders(quantityHodl, lowGas);
810         orderId = _openSellOrder(quantityHodl);
811         _pruneHodler(msg.sender);
812     }
813 
814     function _fillBuyOrders(uint quantityHodl, uint lowGas) private returns(uint remainingHodl) {
815         User storage u = userStruct[msg.sender];
816         address buyerAddr;
817         bytes32 buyId;
818         uint orderHodl;
819         uint orderEth;
820         uint txnEth;
821         uint txnHodl;
822 
823         while(buyOrderIdFifo.count() > 0 && quantityHodl > 0) { //
824             if(gasleft() < lowGas) return 0;
825             buyId = buyOrderIdFifo.first();
826             BuyOrder storage o = buyOrder[buyId]; 
827             buyerAddr = o.buyer;
828             User storage b = userStruct[o.buyer];
829             
830             orderEth = o.bidEth;
831             orderHodl = convertEthToHodl(orderEth);
832             if(orderHodl == 0) {
833                 // Order is now too small to fill. Refund eth and prune.
834                 if(orderEth > 0) {
835                     b.balanceEth = b.balanceEth.add(orderEth);
836                     emit BuyOrderRefunded(msg.sender, buyId, orderEth); 
837                 }
838                 delete buyOrder[buyId];
839                 buyOrderIdFifo.remove(buyId);
840                 b.buyOrderIdFifo.remove(buyId);                   
841             } else {
842                 txnEth  = convertHodlToEth(quantityHodl);
843                 txnHodl = quantityHodl;
844                 if(orderEth < txnEth) {
845                     txnEth = orderEth;
846                     txnHodl = orderHodl;
847                 }
848                 u.balanceHodl = u.balanceHodl.sub(txnHodl, "Insufficient Hodl for computed order volume");
849                 b.balanceHodl = b.balanceHodl.add(txnHodl);
850                 u.balanceEth = u.balanceEth.add(txnEth);
851                 o.bidEth = o.bidEth.sub(txnEth, "500 - Insufficient ETH for computed order volume");
852                 quantityHodl = quantityHodl.sub(txnHodl, "500 - Insufficient order Hodl remaining to fill order");  
853                 _makeHodler(buyerAddr);
854                 _accrueByTransaction();
855                 emit BuyOrderFilled(msg.sender, buyId, o.buyer, txnEth, txnHodl);
856             }          
857         }
858         remainingHodl = quantityHodl;
859     }
860 
861     function _openSellOrder(uint quantityHodl) private returns(bytes32 orderId) {
862         User storage u = userStruct[msg.sender];
863         // Do not allow low gas to result in small sell orders or sell orders to exist while buy orders exist
864         if(convertHodlToUsd(quantityHodl) > minOrderUsd && buyOrderIdFifo.count() == 0) { 
865             orderId = keyGen();
866             (uint askUsd, /*uint accrualRate*/) = rates();
867             SellOrder storage o = sellOrder[orderId];
868             sellOrderIdFifo.append(orderId);
869             u.sellOrderIdFifo.append(orderId);           
870             o.seller = msg.sender;
871             o.volumeHodl = quantityHodl;
872             o.askUsd = askUsd;
873             u.balanceHodl = u.balanceHodl.sub(quantityHodl, "Insufficient Hodl to open sell order");
874             emit SellOrderOpened(orderId, msg.sender, quantityHodl, askUsd);
875         }
876     }
877 
878     /**************************************************************************************
879      * Buy HodlC from sell orders, or if no sell orders, from reserve. Lastly, open a 
880      * buy order is the reserve is sold out.
881      * Selectable low gas protects against future EVM price changes.
882      * Completes as much as possible (gas) and returns unspent Eth.
883      **************************************************************************************/ 
884 
885     function buyHodlC(uint amountEth, uint lowGas) external accrueByTime distribute ifRunning returns(bytes32 orderId) {
886         emit BuyHodlC(msg.sender, amountEth, lowGas);
887         uint orderLimit = orderLimit();         
888         uint orderUsd = convertEthToUsd(amountEth);
889         require(orderUsd >= minOrderUsd, "Buy order is less than minimum USD value");
890         require(orderUsd <= orderLimit || orderLimit == 0, "Order exceeds USD limit");
891         amountEth = _fillSellOrders(amountEth, lowGas);
892         amountEth = _buyFromReserve(amountEth);
893         orderId = _openBuyOrder(amountEth);
894         _makeHodler(msg.sender);
895     }
896 
897     function _fillSellOrders(uint amountEth, uint lowGas) private returns(uint remainingEth) {
898         User storage u = userStruct[msg.sender];
899         address sellerAddr;
900         bytes32 sellId;
901         uint orderEth;
902         uint orderHodl;
903         uint txnEth;
904         uint txnHodl; 
905 
906         while(sellOrderIdFifo.count() > 0 && amountEth > 0) {
907             if(gasleft() < lowGas) return 0;
908             sellId = sellOrderIdFifo.first();
909             SellOrder storage o = sellOrder[sellId];
910             sellerAddr = o.seller;
911             User storage s = userStruct[sellerAddr];
912             
913             orderHodl = o.volumeHodl; 
914             orderEth = convertHodlToEth(orderHodl);
915             txnEth = amountEth;
916             txnHodl = convertEthToHodl(txnEth);
917             if(orderEth < txnEth) {
918                 txnEth = orderEth;
919                 txnHodl = orderHodl;
920             }
921             u.balanceEth = u.balanceEth.sub(txnEth, "Insufficient funds to buy from sell order");
922             s.balanceEth = s.balanceEth.add(txnEth);
923             u.balanceHodl = u.balanceHodl.add(txnHodl);
924             o.volumeHodl = o.volumeHodl.sub(txnHodl, "500 - order has insufficient Hodl for computed volume");
925             amountEth = amountEth.sub(txnEth, "500 - overspent buy order"); 
926             _accrueByTransaction();
927             emit SellOrderFilled(msg.sender, sellId, o.seller, txnEth, txnHodl);
928             if(o.volumeHodl == 0) {
929                 delete sellOrder[sellId];
930                 sellOrderIdFifo.remove(sellId);
931                 s.sellOrderIdFifo.remove(sellId);
932                 _pruneHodler(sellerAddr); 
933             }      
934         }
935         remainingEth = amountEth;
936     }
937     
938     function _buyFromReserve(uint amountEth) private returns(uint remainingEth) {
939         uint txnHodl;
940         uint txnEth;
941         if(amountEth > 0) {
942             Distribution memory d;
943             User storage u = userStruct[msg.sender];
944             User storage r = userStruct[address(this)];
945             txnHodl = (convertEthToHodl(amountEth) <= r.balanceHodl) ? convertEthToHodl(amountEth) : r.balanceHodl;
946             if(txnHodl > 0) {
947                 txnEth = convertHodlToEth(txnHodl);
948                 r.balanceHodl = r.balanceHodl.sub(txnHodl, "500 - reserve has insufficient Hodl for computed volume");
949                 u.balanceHodl = u.balanceHodl.add(txnHodl);
950                 u.balanceEth = u.balanceEth.sub(txnEth, "Insufficient funds to buy from reserve");            
951                 d.amountEth = txnEth;
952                 d.timeStamp = now;
953                 distribution.push(d);
954                 amountEth = amountEth.sub(txnEth, "500 - buy order has insufficient ETH to complete reserve purchase");
955                 _accrueByTransaction();    
956                 emit BuyFromReserve(msg.sender, txnEth, txnHodl);
957             }
958         }
959         remainingEth = amountEth;
960     }
961 
962     function _openBuyOrder(uint amountEth) private returns(bytes32 orderId) {
963         User storage u = userStruct[msg.sender];
964         // do not allow low gas to open a small buy order or buy orders to exist while sell orders exist
965         if(convertEthToUsd(amountEth) > minOrderUsd && sellOrderIdFifo.count() == 0) {
966             orderId = keyGen();
967             BuyOrder storage o = buyOrder[orderId];
968             buyOrderIdFifo.append(orderId);
969             u.buyOrderIdFifo.append(orderId);
970             u.balanceEth = u.balanceEth.sub(amountEth, "Insufficient funds to open buy order");
971             o.bidEth = amountEth;
972             o.buyer = msg.sender;
973             emit BuyOrderOpened(orderId, msg.sender, amountEth);
974         }
975     }
976     
977     /**************************************************************************************
978      * Cancel orders
979      **************************************************************************************/ 
980 
981     function cancelSell(bytes32 orderId) external accrueByTime distribute ifRunning {
982         SellOrder storage o = sellOrder[orderId];
983         User storage u = userStruct[o.seller];
984         require(o.seller == msg.sender, "Sender is not the seller.");
985         u.balanceHodl = u.balanceHodl.add(o.volumeHodl);
986         u.sellOrderIdFifo.remove(orderId);
987         sellOrderIdFifo.remove(orderId);
988         emit SellOrderCancelled(msg.sender, orderId);
989     }
990     function cancelBuy(bytes32 orderId) external distribute accrueByTime ifRunning {
991         BuyOrder storage o = buyOrder[orderId];
992         User storage u = userStruct[o.buyer];
993         require(o.buyer == msg.sender, "Sender is not the buyer.");
994         u.balanceEth = u.balanceEth.add(o.bidEth);
995         u.buyOrderIdFifo.remove(orderId);
996         buyOrderIdFifo.remove(orderId);
997         emit BuyOrderCancelled(msg.sender, orderId);
998     }
999 
1000     /**************************************************************************************
1001      * Prices and quotes
1002      **************************************************************************************/    
1003     
1004     function convertEthToUsd(uint amtEth) public view returns(uint inUsd) {
1005         inUsd = amtEth.mul(maker.read()).div(USD_PRECISION);
1006     }
1007     function convertUsdToEth(uint amtUsd) public view returns(uint inEth) {
1008         inEth = amtUsd.mul(USD_PRECISION).div(convertEthToUsd(USD_PRECISION));
1009     }
1010     function convertHodlToUsd(uint amtHodl) public view returns(uint inUsd) {
1011         (uint _hodlUsd, /*uint _accrualRate*/) = rates();
1012         inUsd = amtHodl.mul(_hodlUsd).div(HODL_PRECISION);
1013     }
1014     function convertUsdToHodl(uint amtUsd) public view returns(uint inHodl) {
1015          (uint _hodlUsd, /*uint _accrualRate*/) = rates();
1016         inHodl = amtUsd.mul(HODL_PRECISION).div(_hodlUsd);
1017     }
1018     function convertEthToHodl(uint amtEth) public view returns(uint inHodl) {
1019         uint inUsd = convertEthToUsd(amtEth);
1020         inHodl = convertUsdToHodl(inUsd);
1021     }
1022     function convertHodlToEth(uint amtHodl) public view returns(uint inEth) { 
1023         uint inUsd = convertHodlToUsd(amtHodl);
1024         inEth = convertUsdToEth(inUsd);
1025     }
1026 
1027     /**************************************************************************************
1028      * Eth accounts
1029      **************************************************************************************/ 
1030 
1031     function depositEth() external accrueByTime distribute ifRunning payable {
1032         require(msg.value > 0, "You must send Eth to this function");
1033         User storage u = userStruct[msg.sender];
1034         u.balanceEth = u.balanceEth.add(msg.value);
1035         emit UserDepositEth(msg.sender, msg.value);
1036     }   
1037     function withdrawEth(uint amount) external accrueByTime distribute ifRunning {
1038         User storage u = userStruct[msg.sender];
1039         u.balanceEth = u.balanceEth.sub(amount);
1040         emit UserWithdrawEth(msg.sender, amount);  
1041         msg.sender.sendValue(amount); 
1042     }
1043 
1044     /**************************************************************************************
1045      * Accrual and rate decay over time
1046      **************************************************************************************/ 
1047 
1048     // Moves forward in 1-day steps to prevent overflow
1049     function rates() public view returns(uint hodlUsd, uint dailyAccrualRate) {
1050         hodlUsd = HODL_USD;
1051         dailyAccrualRate = DAILY_ACCRUAL_RATE;
1052         uint startTime = BIRTHDAY.add(SLEEP_TIME);
1053         if(now > startTime) {
1054             uint daysFromStart = (now.sub(startTime)) / 1 days;
1055             uint daysUnprocessed = daysFromStart.sub(accrualDaysProcessed);
1056             if(daysUnprocessed > 0) {
1057                 hodlUsd = HODL_USD.mul(DAILY_ACCRUAL_RATE).div(USD_PRECISION);
1058                 dailyAccrualRate = DAILY_ACCRUAL_RATE.mul(DAILY_ACCRUAL_RATE_DECAY).div(USD_PRECISION);
1059             }
1060         }
1061     }
1062 
1063     /**************************************************************************************
1064      * Stateful activity-based and time-based rate adjustments
1065      **************************************************************************************/
1066 
1067     function _accrueByTransaction() private {
1068         HODL_USD = HODL_USD.add(USD_TXN_ADJUSTMENT);
1069     }    
1070     function _accrueByTime() private returns(uint hodlUsdNow, uint dailyAccrualRateNow) {
1071         (hodlUsdNow, dailyAccrualRateNow) = rates();
1072         if(hodlUsdNow != HODL_USD || dailyAccrualRateNow != DAILY_ACCRUAL_RATE) { 
1073             HODL_USD = hodlUsdNow;
1074             DAILY_ACCRUAL_RATE = dailyAccrualRateNow; 
1075             accrualDaysProcessed = accrualDaysProcessed.add(1);  
1076         } 
1077     }
1078     
1079     /**************************************************************************************
1080      * Add and remove from hodlerAddrSet based on total HODLC owned/controlled
1081      **************************************************************************************/
1082 
1083     function _makeHodler(address user) private {
1084         User storage u = userStruct[user];
1085         if(convertHodlToUsd(u.balanceHodl) >= minOrderUsd) {
1086             if(!hodlerAddrSet.exists(user)) hodlerAddrSet.insert(user);   
1087         }
1088     }    
1089     function _pruneHodler(address user) private {
1090         User storage u = userStruct[user];
1091         if(convertHodlToUsd(u.balanceHodl) < minOrderUsd) {
1092             if(hodlerAddrSet.exists(user)) hodlerAddrSet.remove(user);
1093         }
1094     }
1095     
1096     /**************************************************************************************
1097      * View functions to enumerate the state
1098      **************************************************************************************/
1099     
1100     // Courtesy function 
1101     function contractBalanceEth() public view returns(uint ineth) { return address(this).balance; }
1102 
1103     // Distribution queue
1104     function distributionsLength() public view returns(uint row) { return distribution.length; }
1105     
1106     // Hodlers in no particular order
1107     function hodlerCount() public view returns(uint count) { return hodlerAddrSet.count(); }
1108     function hodlerAtIndex(uint index) public view returns(address userAddr) { return hodlerAddrSet.keyAtIndex(index); }    
1109     
1110     // Open orders, FIFO
1111     function sellOrderCount() public view returns(uint count) { return sellOrderIdFifo.count(); }
1112     function sellOrderFirst() public view returns(bytes32 orderId) { return sellOrderIdFifo.first(); }
1113     function sellOrderLast() public view returns(bytes32 orderId) { return sellOrderIdFifo.last(); }  
1114     function sellOrderIterate(bytes32 orderId) public view returns(bytes32 idBefore, bytes32 idAfter) { return (sellOrderIdFifo.previous(orderId), sellOrderIdFifo.next(orderId)); }
1115     function buyOrderCount() public view returns(uint count) { return buyOrderIdFifo.count(); }
1116     function buyOrderFirst() public view returns(bytes32 orderId) { return buyOrderIdFifo.first(); }
1117     function buyOrderLast() public view returns(bytes32 orderId) { return buyOrderIdFifo.last(); }    
1118     function buyOrderIterate(bytes32 orderId) public view returns(bytes32 ifBefore, bytes32 idAfter) { return(buyOrderIdFifo.previous(orderId), buyOrderIdFifo.next(orderId)); }
1119 
1120     // open orders by user, FIFO
1121     function userSellOrderCount(address userAddr) public view returns(uint count) { return userStruct[userAddr].sellOrderIdFifo.count(); }
1122     function userSellOrderFirst(address userAddr) public view returns(bytes32 orderId) { return userStruct[userAddr].sellOrderIdFifo.first(); }
1123     function userSellOrderLast(address userAddr) public view returns(bytes32 orderId) { return userStruct[userAddr].sellOrderIdFifo.last(); }  
1124     function userSellOrderIterate(address userAddr, bytes32 orderId) public view  returns(bytes32 idBefore, bytes32 idAfter) { return(userStruct[userAddr].sellOrderIdFifo.previous(orderId), userStruct[userAddr].sellOrderIdFifo.next(orderId)); }
1125     function userBuyOrderCount(address userAddr) public view returns(uint count) { return userStruct[userAddr].buyOrderIdFifo.count(); }
1126     function userBuyOrderFirst(address userAddr) public view returns(bytes32 orderId) { return userStruct[userAddr].buyOrderIdFifo.first(); }
1127     function userBuyOrderLast(address userAddr) public view returns(bytes32 orderId) { return userStruct[userAddr].buyOrderIdFifo.last(); }
1128     function userBuyOrderIdFifo(address userAddr, bytes32 orderId) public view  returns(bytes32 idBefore, bytes32 idAfter) { return(userStruct[userAddr].buyOrderIdFifo.previous(orderId), userStruct[userAddr].buyOrderIdFifo.next(orderId)); }
1129      
1130     function user(address userAddr) public view returns(uint balanceEth, uint balanceHodl) {
1131         User storage u = userStruct[userAddr];
1132         return(u.balanceEth, u.balanceHodl);
1133     }
1134     function isAccruing() public view returns(bool accruing) {
1135         return now > BIRTHDAY.add(SLEEP_TIME);
1136     }
1137     function isRunning() public view returns(bool running) {
1138         return owner() == address(0);
1139     }
1140     function orderLimit() public view returns(uint limitUsd) {
1141         // get selling price in USD
1142         (uint askUsd, /*uint accrualRate*/) = rates();
1143         return (askUsd > maxThresholdUsd) ? 0 : maxOrderUsd;
1144     }
1145     function makerAddr() public view returns(address) {
1146         return address(maker);
1147     }
1148     function hodlTAddr() public view returns(address) {
1149         return address(token);
1150     }
1151     
1152     /**************************************************************************************
1153      * Initialization functions that support migration cannot be used after trading starts
1154      **************************************************************************************/  
1155 
1156     function initUser(address userAddr, uint hodl) external onlyOwner payable {
1157         User storage u = userStruct[userAddr];
1158         User storage r = userStruct[address(this)];
1159         u.balanceEth  = u.balanceEth.add(msg.value);
1160         u.balanceHodl = u.balanceHodl.add(hodl);
1161         r.balanceHodl = r.balanceHodl.sub(hodl);
1162         _makeHodler(userAddr);
1163         emit UserInitialized(msg.sender, userAddr, hodl, msg.value);
1164     }
1165     function initResetUser(address userAddr) external onlyOwner {
1166         User storage u = userStruct[userAddr];
1167         User storage r = userStruct[address(this)];
1168         r.balanceHodl = r.balanceHodl.add(u.balanceHodl);
1169         if(u.balanceEth > 0) msg.sender.transfer(u.balanceEth);
1170         emit UserUninitialized(msg.sender, userAddr, u.balanceHodl, u.balanceEth);
1171         delete userStruct[userAddr];
1172         _pruneHodler(userAddr);
1173     }
1174     function initSetHodlTAddress(IERC20 hodlToken) external onlyOwner {
1175         /// @dev Transfer the total supply of these tokens to this contract during migration
1176         token = IERC20(hodlToken);
1177         emit TokenSet(msg.sender, address(token));
1178     }
1179     function initSetHodlUsd(uint price) external onlyOwner {
1180         HODL_USD = price;
1181         emit PriceSet(msg.sender, price);
1182     }
1183     function initSetMaker(address _maker) external onlyOwner {
1184         maker = Maker(_maker);
1185         emit MakerSet(msg.sender, _maker);
1186     }
1187     function renounceOwnership() public override onlyOwner {
1188         require(token.balanceOf(address(this)) == TOTAL_SUPPLY, "Assign the HoldT supply to this contract before trading starts");
1189         Ownable.renounceOwnership();
1190     }
1191 }