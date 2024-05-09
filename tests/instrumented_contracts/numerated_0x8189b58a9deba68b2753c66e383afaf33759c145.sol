1 // File: contracts/src/Math/SafeMath.sol
2 
3 pragma solidity ^0.5.16;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the integer division of two unsigned integers. Reverts on
88      * division by zero. The result is rounded towards zero.
89      *
90      * Counterpart to Solidity's `/` operator. Note: this function uses a
91      * `revert` opcode (which leaves remaining gas untouched) while Solidity
92      * uses an invalid opcode to revert (consuming all remaining gas).
93      *
94      * Requirements:
95      * - The divisor cannot be zero.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      *
112      * _Available since v2.4.0._
113      */
114     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts with custom message when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      *
146      * _Available since v2.4.0._
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 // File: contracts/src/GCC/Oracle/GCCOracleInterface.sol
155 
156 pragma solidity ^0.5.16;
157 
158 contract GCCOracleInterface {
159 
160     function testConnection() public pure returns (bool);
161 
162     function getAddress() public view returns (address);
163 
164     function getFilterLength() public view returns (uint256);
165 
166     function getFilter(uint256 index) public view returns (string memory, string memory, string memory, uint256);
167 
168     function nowFilter() public view returns (string memory, string memory, string memory, uint256);
169 
170     function addProof(address addr, bytes32 txid, uint64 coin) public returns (bool);
171 
172     function addProofs(address[] memory addrList, bytes32[] memory txidList, uint64[] memory coinList) public returns (bool);
173 
174     function getProof(address addr, bytes32 txid) public view returns (address, bytes32, uint64);
175 
176     function getProofs(address addr) public view returns (address[] memory, bytes32[] memory, uint64[] memory);
177 
178     function getProofs(address addr, uint cursor, uint limit) public view returns (address[] memory, bytes32[] memory, uint64[] memory);
179 }
180 
181 // File: contracts/src/Base/Initializable.sol
182 
183 pragma solidity ^0.5.16;
184 
185 /**
186  * @title Initializable
187  *
188  * @dev Helper contract to support initializer functions. To use it, replace
189  * the constructor with a function that has the `initializer` modifier.
190  * WARNING: Unlike constructors, initializer functions must be manually
191  * invoked. This applies both to deploying an Initializable contract, as well
192  * as extending an Initializable contract via inheritance.
193  * WARNING: When used with inheritance, manual care must be taken to not invoke
194  * a parent initializer twice, or ensure that all initializers are idempotent,
195  * because this is not dealt with automatically as with constructors.
196  */
197 contract Initializable {
198 
199   /**
200    * @dev Indicates that the contract has been initialized.
201    */
202   bool private initialized;
203 
204   /**
205    * @dev Indicates that the contract is in the process of being initialized.
206    */
207   bool private initializing;
208 
209   /**
210    * @dev Modifier to use in the initializer function of a contract.
211    */
212   modifier initializer() {
213     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
214 
215     bool isTopLevelCall = !initializing;
216     if (isTopLevelCall) {
217       initializing = true;
218       initialized = true;
219     }
220 
221     _;
222 
223     if (isTopLevelCall) {
224       initializing = false;
225     }
226   }
227 
228   /// @dev Returns true if and only if the function is running in the constructor
229   function isConstructor() private view returns (bool) {
230     // extcodesize checks the size of the code stored in an address, and
231     // address returns the current address. Since the code is still not
232     // deployed when running a constructor, any checks on its code size will
233     // yield zero, making it an effective way to detect if a contract is
234     // under construction or not.
235     address self = address(this);
236     uint256 cs;
237     assembly { cs := extcodesize(self) }
238     return cs == 0;
239   }
240 
241   //uint256[50] private ______gap;
242 }
243 
244 // File: contracts/src/Base/Context.sol
245 
246 pragma solidity ^0.5.16;
247 
248 
249 /*
250  * @dev Provides information about the current execution context, including the
251  * sender of the transaction and its data. While these are generally available
252  * via msg.sender and msg.data, they should not be accessed in such a direct
253  * manner, since when dealing with GSN meta-transactions the account sending and
254  * paying for execution may not be the actual sender (as far as an application
255  * is concerned).
256  *
257  * This contract is only required for intermediate, library-like contracts.
258  */
259 contract Context is Initializable {
260     // Empty internal constructor, to prevent people from mistakenly deploying
261     // an instance of this contract, which should be used via inheritance.
262     constructor () internal { }
263     // solhint-disable-previous-line no-empty-blocks
264 
265     function _msgSender() internal view returns (address payable) {
266         return msg.sender;
267     }
268 
269     function _msgData() internal view returns (bytes memory) {
270         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
271         return msg.data;
272     }
273 }
274 
275 // File: contracts/src/Access/Ownable.sol
276 
277 pragma solidity ^0.5.16;
278 
279 
280 
281 /**
282  * @dev Contract module which provides a basic access control mechanism, where
283  * there is an account (an owner) that can be granted exclusive access to
284  * specific functions.
285  *
286  * This module is used through inheritance. It will make available the modifier
287  * `onlyOwner`, which can be applied to your functions to restrict their use to
288  * the owner.
289  */
290 contract Ownable is Initializable, Context {
291     address private _owner;
292 
293     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295     /**
296      * @dev Initializes the contract setting the deployer as the initial owner.
297      */
298     function initialize(address sender) public initializer {
299         _owner = sender;
300         emit OwnershipTransferred(address(0), _owner);
301     }
302 
303     /**
304      * @dev Returns the address of the current owner.
305      */
306     function owner() public view returns (address) {
307         return _owner;
308     }
309 
310     /**
311      * @dev Throws if called by any account other than the owner.
312      */
313     modifier onlyOwner() {
314         require(isOwner(), "Ownable: caller is not the owner");
315         _;
316     }
317 
318     /**
319      * @dev Returns true if the caller is the current owner.
320      */
321     function isOwner() public view returns (bool) {
322         return _msgSender() == _owner;
323     }
324 
325     /**
326      * @dev Leaves the contract without owner. It will not be possible to call
327      * `onlyOwner` functions anymore. Can only be called by the current owner.
328      *
329      * NOTE: Renouncing ownership will leave the contract without an owner,
330      * thereby removing any functionality that is only available to the owner.
331      */
332     function renounceOwnership() public onlyOwner {
333         emit OwnershipTransferred(_owner, address(0));
334         _owner = address(0);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      * Can only be called by the current owner.
340      */
341     function transferOwnership(address newOwner) public onlyOwner {
342         _transferOwnership(newOwner);
343     }
344 
345     /**
346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
347      */
348     function _transferOwnership(address newOwner) internal {
349         require(newOwner != address(0), "Ownable: new owner is the zero address");
350         emit OwnershipTransferred(_owner, newOwner);
351         _owner = newOwner;
352     }
353 
354     //uint256[50] private ______gap;
355 }
356 
357 // File: contracts/src/GCC/Oracle/GCCOracleReader.sol
358 
359 pragma solidity ^0.5.16;
360 
361 
362 
363 contract GCCOracleReader is Ownable {
364 
365     address internal oracleAddr = address(0);
366     GCCOracleInterface internal oracle = GCCOracleInterface(oracleAddr);
367 
368     function initialize(address sender) public initializer {
369         Ownable.initialize(sender);
370     }
371 
372     /**
373      * @dev Sets the address of the oracle contract to use
374      *
375      * @return true if connection to the new oracle address was successful
376      */
377     function setOracleAddress(address _oracleAddress) public onlyOwner returns (bool) {
378         oracleAddr = _oracleAddress;
379         oracle = GCCOracleInterface(oracleAddr);
380         return oracle.testConnection();
381     }
382 
383     /**
384      * @dev Returns the address of the boxing oracle being used
385      */
386     function getOracleAddress() public view returns (address) {
387         return oracleAddr;
388     }
389 
390     /**
391      * @dev Tests that the boxing oracle is callable
392      */
393     function testOracleConnection() public view returns (bool) {
394         return oracle.testConnection();
395     }
396 
397     /**
398      * @dev Returns length of added computation proofs
399      */
400     function getFilterLength() public view returns (uint256) {
401         return oracle.getFilterLength();
402     }
403 
404     /**
405      * @dev Returns computation strategy by index.
406      */
407     function getFilter(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
408         return oracle.getFilter(index);
409     }
410 
411     /**
412      * @dev Returns newest computation strategy.
413      */
414     function nowFilter() public view returns (string memory, string memory, string memory, uint256) {
415         return oracle.nowFilter();
416     }
417 
418     /**
419      * @dev Returns existing proof by given address and txid
420      */
421     function getProof(address addr, bytes32 txid) public view returns (address, bytes32, uint64) {
422         return oracle.getProof(addr, txid);
423     }
424 
425     /**
426      * @dev Returns list of all proofs belonging to specified address
427      */
428     function getProofs(address addr) public view returns (address[] memory, bytes32[] memory, uint64[] memory) {
429         return oracle.getProofs(addr);
430     }
431 
432     /**
433      * @dev Returns list of paged proofs belonging to specified address contrainted by cursor and limit
434      */
435     function getProofs(address addr, uint cursor, uint limit) public view returns (address[] memory, bytes32[] memory, uint64[] memory) {
436         return oracle.getProofs(addr, cursor, limit);
437     }
438 }
439 
440 // File: contracts/src/GCC/Oracle/GCCOracleProofConsumer.sol
441 
442 pragma solidity ^0.5.16;
443 
444 
445 
446 contract GCCOracleProofConsumer is GCCOracleReader {
447     using SafeMath for uint256;
448 
449     uint256 internal _fullAmount;
450     uint256 internal _usedAmount;
451     mapping(address => uint256) internal _consumedProofs;
452 
453     function initialize(address sender, uint256 maxAmount) public initializer {
454         _fullAmount = maxAmount;
455         GCCOracleReader.initialize(sender);
456     }
457 
458     /**
459      * @dev Proves amount for given address with all accessible proofs.
460      */
461     function consumeProofs(address addr) public returns (bool) {
462         _consumeProofs(addr, 1000);
463         return true;
464     }
465 
466     /**
467      * @dev Proves amount for given address with a limit of newly processed proofs.
468      */
469     function consumeLimitedProofs(address addr, uint256 limit) public returns (bool) {
470         _consumeProofs(addr, limit);
471         return true;
472     }
473 
474     /**
475      * @dev Returns full consumable amount.
476      */
477     function getConsumableFullAmount() public view returns (uint256) {
478         return _fullAmount;
479     }
480 
481     /**
482      * @dev Returns already used consumable amount.
483      */
484     function getConsumableUsedAmount() public view returns (uint256) {
485         return _usedAmount;
486     }
487 
488     /**
489      * @dev Returns list of all already consumed proofs
490      */
491     function getConsumedProofs(address addr) public view returns (address[] memory, bytes32[] memory, uint64[] memory) {
492         uint256 consumedLimit = _consumedProofs[addr];
493         return oracle.getProofs(addr, 0, consumedLimit);
494     }
495 
496     /**
497      * @dev Returns list of few already consumed proofs constrained by cursor and limit
498      */
499     function fewConsumedProofs(address addr, uint cursor, uint limit) public view returns (address[] memory, bytes32[] memory, uint64[] memory) {
500         uint256 consumedLimit = _consumedProofs[addr].sub(cursor) < limit ? _consumedProofs[addr].sub(cursor) : limit;
501         return oracle.getProofs(addr, cursor, consumedLimit);
502     }
503 
504     /**
505      * @dev Internal function for proving amount(s)
506      */
507     function _consumeProofs(address addr, uint256 limit) internal {
508         require(getOracleAddress() != address(0), "GCCOracleProofConsumer: Cannot provably mint tokens while there is no oracle!");
509 
510         uint256 prevCursor = _consumedProofs[addr];
511 
512         address[] memory addrList;
513         bytes32[] memory txidList;
514         uint64 [] memory coinList;
515 
516         (addrList, txidList, coinList) = getProofs(addr, prevCursor, limit);
517         uint256 size = addrList.length;
518         if (size == 0) return;
519 
520         uint256 nextCursor = prevCursor.add(size);
521         uint256 mintAmount = 0;
522 
523         for (uint256 i=0; i<size; i++) {
524             mintAmount = mintAmount.add(coinList[i]);
525         }
526 
527         uint256 freeAmount = _fullAmount.sub(_usedAmount);
528         require(mintAmount <= freeAmount, "GCCOracleProofConsumer: Cannot mint more tokens, limit exhausted!");
529 
530         _usedAmount = _usedAmount.add(mintAmount);
531         _consumedProofs[addr] = nextCursor;
532         _afterConsumeProofs(addr, mintAmount);
533     }
534 
535     /**
536      * @dev Hook to execute when proving amount
537      */
538     function _afterConsumeProofs(address account, uint256 amount) internal {
539     }
540 }
541 
542 // File: contracts/src/ERC20/IERC20.sol
543 
544 pragma solidity ^0.5.16;
545 
546 /**
547  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
548  * the optional functions; to access them see {ERC20Detailed}.
549  */
550 interface IERC20 {
551     /**
552      * @dev Returns the amount of tokens in existence.
553      */
554     function totalSupply() external view returns (uint256);
555 
556     /**
557      * @dev Returns the amount of tokens owned by `account`.
558      */
559     function balanceOf(address account) external view returns (uint256);
560 
561     /**
562      * @dev Moves `amount` tokens from the caller's account to `recipient`.
563      *
564      * Returns a boolean value indicating whether the operation succeeded.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transfer(address recipient, uint256 amount) external returns (bool);
569 
570     /**
571      * @dev Returns the remaining number of tokens that `spender` will be
572      * allowed to spend on behalf of `owner` through {transferFrom}. This is
573      * zero by default.
574      *
575      * This value changes when {approve} or {transferFrom} are called.
576      */
577     function allowance(address owner, address spender) external view returns (uint256);
578 
579     /**
580      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
581      *
582      * Returns a boolean value indicating whether the operation succeeded.
583      *
584      * IMPORTANT: Beware that changing an allowance with this method brings the risk
585      * that someone may use both the old and the new allowance by unfortunate
586      * transaction ordering. One possible solution to mitigate this race
587      * condition is to first reduce the spender's allowance to 0 and set the
588      * desired value afterwards:
589      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
590      *
591      * Emits an {Approval} event.
592      */
593     function approve(address spender, uint256 amount) external returns (bool);
594 
595     /**
596      * @dev Moves `amount` tokens from `sender` to `recipient` using the
597      * allowance mechanism. `amount` is then deducted from the caller's
598      * allowance.
599      *
600      * Returns a boolean value indicating whether the operation succeeded.
601      *
602      * Emits a {Transfer} event.
603      */
604     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
605 
606     /**
607      * @dev Emitted when `value` tokens are moved from one account (`from`) to
608      * another (`to`).
609      *
610      * Note that `value` may be zero.
611      */
612     event Transfer(address indexed from, address indexed to, uint256 value);
613 
614     /**
615      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
616      * a call to {approve}. `value` is the new allowance.
617      */
618     event Approval(address indexed owner, address indexed spender, uint256 value);
619 }
620 
621 // File: contracts/src/ERC20/ERC20.sol
622 
623 pragma solidity ^0.5.16;
624 
625 
626 
627 
628 
629 /**
630  * @dev Implementation of the {IERC20} interface.
631  *
632  * This implementation is agnostic to the way tokens are created. This means
633  * that a supply mechanism has to be added in a derived contract using {_mint}.
634  * For a generic mechanism see {ERC20Mintable}.
635  *
636  * We have followed general guidelines: functions revert instead
637  * of returning `false` on failure. This behavior is nonetheless conventional
638  * and does not conflict with the expectations of ERC20 applications.
639  *
640  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
641  * This allows applications to reconstruct the allowance for all accounts just
642  * by listening to said events. Other implementations of the EIP may not emit
643  * these events, as it isn't required by the specification.
644  *
645  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
646  * functions have been added to mitigate the well-known issues around setting
647  * allowances. See {IERC20-approve}.
648  */
649 contract ERC20 is Initializable, Context, IERC20 {
650     using SafeMath for uint256;
651 
652     mapping (address => uint256) internal _balances;
653 
654     mapping (address => mapping (address => uint256)) internal _allowances;
655 
656     uint256 internal _totalSupply;
657 
658     /**
659      * @dev See {IERC20-totalSupply}.
660      */
661     function totalSupply() public view returns (uint256) {
662         return _totalSupply;
663     }
664 
665     /**
666      * @dev See {IERC20-balanceOf}.
667      */
668     function balanceOf(address account) public view returns (uint256) {
669         return _balances[account];
670     }
671 
672     /**
673      * @dev See {IERC20-transfer}.
674      *
675      * Requirements:
676      *
677      * - `recipient` cannot be the zero address.
678      * - the caller must have a balance of at least `amount`.
679      */
680     function transfer(address recipient, uint256 amount) public returns (bool) {
681         _transfer(_msgSender(), recipient, amount);
682         return true;
683     }
684 
685     /**
686      * @dev See {IERC20-allowance}.
687      */
688     function allowance(address owner, address spender) public view returns (uint256) {
689         return _allowances[owner][spender];
690     }
691 
692     /**
693      * @dev See {IERC20-approve}.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      */
699     function approve(address spender, uint256 amount) public returns (bool) {
700         _approve(_msgSender(), spender, amount);
701         return true;
702     }
703 
704     /**
705      * @dev See {IERC20-transferFrom}.
706      *
707      * Emits an {Approval} event indicating the updated allowance. This is not
708      * required by the EIP. See the note at the beginning of {ERC20};
709      *
710      * Requirements:
711      * - `sender` and `recipient` cannot be the zero address.
712      * - `sender` must have a balance of at least `amount`.
713      * - the caller must have allowance for `sender`'s tokens of at least
714      * `amount`.
715      */
716     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
717         _transfer(sender, recipient, amount);
718         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
719         return true;
720     }
721 
722     /**
723      * @dev Atomically increases the allowance granted to `spender` by the caller.
724      *
725      * This is an alternative to {approve} that can be used as a mitigation for
726      * problems described in {IERC20-approve}.
727      *
728      * Emits an {Approval} event indicating the updated allowance.
729      *
730      * Requirements:
731      *
732      * - `spender` cannot be the zero address.
733      */
734     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
735         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
736         return true;
737     }
738 
739     /**
740      * @dev Atomically decreases the allowance granted to `spender` by the caller.
741      *
742      * This is an alternative to {approve} that can be used as a mitigation for
743      * problems described in {IERC20-approve}.
744      *
745      * Emits an {Approval} event indicating the updated allowance.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      * - `spender` must have allowance for the caller of at least
751      * `subtractedValue`.
752      */
753     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
754         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
755         return true;
756     }
757 
758     /**
759      * @dev Moves tokens `amount` from `sender` to `recipient`.
760      *
761      * This is internal function is equivalent to {transfer}, and can be used to
762      * e.g. implement automatic token fees, slashing mechanisms, etc.
763      *
764      * Emits a {Transfer} event.
765      *
766      * Requirements:
767      *
768      * - `sender` cannot be the zero address.
769      * - `recipient` cannot be the zero address.
770      * - `sender` must have a balance of at least `amount`.
771      */
772     function _transfer(address sender, address recipient, uint256 amount) internal {
773         require(sender != address(0), "ERC20: transfer from the zero address");
774         require(recipient != address(0), "ERC20: transfer to the zero address");
775 
776         _beforeTokenTransfer(sender, recipient, amount);
777 
778         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
779         _balances[recipient] = _balances[recipient].add(amount);
780         emit Transfer(sender, recipient, amount);
781     }
782 
783     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
784      * the total supply.
785      *
786      * Emits a {Transfer} event with `from` set to the zero address.
787      *
788      * Requirements
789      *
790      * - `to` cannot be the zero address.
791      */
792     function _mint(address account, uint256 amount) internal {
793         require(account != address(0), "ERC20: mint to the zero address");
794 
795         _beforeTokenTransfer(address(0), account, amount);
796 
797         _totalSupply = _totalSupply.add(amount);
798         _balances[account] = _balances[account].add(amount);
799         emit Transfer(address(0), account, amount);
800     }
801 
802     /**
803      * @dev Destroys `amount` tokens from `account`, reducing the
804      * total supply.
805      *
806      * Emits a {Transfer} event with `to` set to the zero address.
807      *
808      * Requirements
809      *
810      * - `account` cannot be the zero address.
811      * - `account` must have at least `amount` tokens.
812      */
813     function _burn(address account, uint256 amount) internal {
814         require(account != address(0), "ERC20: burn from the zero address");
815 
816         _beforeTokenTransfer(account, address(0), amount);
817 
818         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
819         _totalSupply = _totalSupply.sub(amount);
820         emit Transfer(account, address(0), amount);
821     }
822 
823     /**
824      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
825      *
826      * This is internal function is equivalent to `approve`, and can be used to
827      * e.g. set automatic allowances for certain subsystems, etc.
828      *
829      * Emits an {Approval} event.
830      *
831      * Requirements:
832      *
833      * - `owner` cannot be the zero address.
834      * - `spender` cannot be the zero address.
835      */
836     function _approve(address owner, address spender, uint256 amount) internal {
837         require(owner != address(0), "ERC20: approve from the zero address");
838         require(spender != address(0), "ERC20: approve to the zero address");
839 
840         _allowances[owner][spender] = amount;
841         emit Approval(owner, spender, amount);
842     }
843 
844     /**
845      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
846      * from the caller's allowance.
847      *
848      * See {_burn} and {_approve}.
849      */
850     function _burnFrom(address account, uint256 amount) internal {
851         _burn(account, amount);
852         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
853     }
854 
855     /**
856      * @dev Hook that is called before any transfer of tokens. This includes
857      * minting and burning.
858      *
859      * Calling conditions:
860      *
861      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
862      * will be to transferred to `to`.
863      * - when `from` is zero, `amount` tokens will be minted for `to`.
864      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
865      * - `from` and `to` are never both zero.
866      *
867      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
868      */
869     function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
870     }
871 
872     //uint256[50] private ______gap;
873 }
874 
875 // File: contracts/src/ERC20/ERC20Detailed.sol
876 
877 pragma solidity ^0.5.16;
878 
879 
880 /**
881  * @dev Optional functions from the ERC20 standard.
882  */
883 contract ERC20Detailed is ERC20 {
884 
885     string internal _name;
886     string internal _symbol;
887     uint8 internal _decimals;
888 
889     /**
890      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
891      * these values are immutable: they can only be set once during
892      * construction.
893      */
894     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
895         _name = name;
896         _symbol = symbol;
897         _decimals = decimals;
898     }
899 
900     /**
901      * @dev Returns the name of the token.
902      */
903     function name() public view returns (string memory) {
904         return _name;
905     }
906 
907     /**
908      * @dev Returns the symbol of the token, usually a shorter version of the
909      * name.
910      */
911     function symbol() public view returns (string memory) {
912         return _symbol;
913     }
914 
915     /**
916      * @dev Returns the number of decimals used to get its user representation.
917      * For example, if `decimals` equals `2`, a balance of `505` tokens should
918      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
919      *
920      * Tokens usually opt for a value of 18, imitating the relationship between
921      * Ether and Wei.
922      *
923      * NOTE: This information is only used for _display_ purposes: it in
924      * no way affects any of the arithmetic of the contract, including
925      * {IERC20-balanceOf} and {IERC20-transfer}.
926      */
927     function decimals() public view returns (uint8) {
928         return _decimals;
929     }
930 
931     //uint256[50] private ______gap;
932 }
933 
934 // File: contracts/src/ERC20/ERC20Burnable.sol
935 
936 pragma solidity ^0.5.16;
937 
938 
939 /**
940  * @dev Extension of {ERC20} that allows token holders to destroy both their own
941  * tokens and those that they have an allowance for, in a way that can be
942  * recognized off-chain (via event analysis).
943  */
944 contract ERC20Burnable is ERC20 {
945     /**
946      * @dev Destroys `amount` tokens from the caller.
947      *
948      * See {ERC20-_burn}.
949      */
950     function burn(uint256 amount) public {
951         _burn(_msgSender(), amount);
952     }
953 
954     /**
955      * @dev See {ERC20-_burnFrom}.
956      */
957     function burnFrom(address account, uint256 amount) public {
958         _burnFrom(account, amount);
959     }
960 
961     //uint256[50] private ______gap;
962 }
963 
964 // File: contracts/src/ERC20/ERC20StakableDiscreetly.sol
965 
966 pragma solidity ^0.5.16;
967 
968 
969 
970 /**
971  * @dev Extension of {ERC20} that adds staking mechanism.
972  */
973 contract ERC20StakableDiscreetly is ERC20, Ownable {
974 
975     uint256 internal _minTotalSupply;
976     uint256 internal _maxTotalSupply;
977 
978     uint256 internal _stakeStartCheck; //stake start time
979     uint256 internal _stakeMinAge; // (3 days) minimum age for coin age: 3D
980     uint256 internal _stakeMaxAge; // (90 days) stake age of full weight: 90D
981     uint256 internal _stakeMinAmount; // (10**18) 1 token
982     uint8 internal _stakePrecision; // (10**18)
983 
984     uint256 internal _stakeCheckpoint; // current checkpoint
985     uint256 internal _stakeInterval; // interval between checkpoints
986 
987     struct stakeStruct {
988         uint256 amount; // staked amount
989         uint256 minCheckpoint; // timestamp of min checkpoint stakes qualifies for
990         uint256 maxCheckpoint; // timestamp of max checkpoint stakes qualifies for
991     }
992 
993     uint256 internal _stakeSumReward;
994     uint256[] internal _stakeRewardAmountVals;
995     uint256[] internal _stakeRewardTimestamps;
996 
997     mapping(address => stakeStruct) internal _stakes; // stakes
998     mapping(uint256 => mapping(uint256 => uint256)) internal _history; // historical stakes per checkpoint
999 
1000     uint256[] internal _tierThresholds; // thresholds between tiers
1001     uint256[] internal _tierShares; // shares of reward per tier
1002 
1003     event Stake(address indexed from, address indexed to, uint256 value);
1004     event Checkpoint(uint256 timestamp, uint256 minted);
1005 
1006     modifier activeStake() {
1007         require(_stakeStartCheck > 0, "ERC20: Staking has not started yet!");
1008         _tick();
1009         _;
1010     }
1011 
1012     function initialize(
1013         address sender, uint256 minTotalSupply, uint256 maxTotalSupply, uint8 stakePrecision
1014     ) public initializer
1015     {
1016         Ownable.initialize(sender);
1017 
1018         _minTotalSupply = minTotalSupply;
1019         _maxTotalSupply = maxTotalSupply;
1020         _mint(sender, minTotalSupply);
1021 
1022         _stakePrecision = stakePrecision;
1023         _stakeMinAmount = 10**(uint256(_stakePrecision)); // def is 1
1024 
1025         _tierThresholds.push(10**(uint256(_stakePrecision)+6));
1026         _tierThresholds.push(0);
1027 
1028         _tierShares.push(20); // 20%
1029         _tierShares.push(80); // 80%
1030     }
1031 
1032     /**
1033      * @dev Set staking open timer and additional params.
1034      */
1035     function open(
1036         uint256 stakeMinAmount, uint64 stakeMinAge, uint64 stakeMaxAge, uint64 stakeStart, uint64 stakeInterval
1037     ) public onlyOwner returns (bool) {
1038         require(_stakeStartCheck == 0, "ERC20: Contract has been already opened!");
1039         _stakeInterval = uint256(stakeInterval);
1040         _stakeStartCheck = uint256(stakeStart);
1041         _stakeCheckpoint = uint256(stakeStart);
1042         _stakeMinAge = uint256(stakeMinAge);
1043         _stakeMaxAge = uint256(stakeMaxAge);
1044         _stakeMinAmount = stakeMinAmount;
1045         return true;
1046     }
1047 
1048     /**
1049     * @dev Sets reward by timestamp
1050     */
1051     function setReward(uint256 timestamp, uint256 amount) public onlyOwner returns (bool) {
1052         _setReward(timestamp, amount);
1053         return true;
1054     }
1055 
1056     /**
1057      * @dev Gets reward by timestamp
1058      */
1059     function getReward(uint256 timestamp) public view returns (uint256) {
1060         return _getReward(timestamp);
1061     }
1062 
1063     /**
1064      * @dev Returns number of coins staked by `account`
1065      */
1066     function stakeOf(address account) public view returns (uint256) {
1067         return _stakeOf(account);
1068     }
1069 
1070     /**
1071      * @dev Returns number of valid coins staked by `account`
1072      */
1073     function activeStakeOf(address account) public view returns (uint256) {
1074         return _stakeOf(account, _nextCheckpoint());
1075     }
1076 
1077     /**
1078      * @dev Stakes all of user tokens and reward if possible.
1079      *
1080      * Emits {Stake} event indicating amount of tokens staked.
1081      */
1082     function restake() public activeStake returns (bool) {
1083         _restake(_msgSender(), _nextCheckpoint());
1084         return true;
1085     }
1086 
1087     /**
1088      * @dev Stakes specified `amount` of user tokens.
1089      *
1090      * Emits {Stake} event indicating amount of tokens staked.
1091      */
1092     function stake(uint256 amount) public activeStake returns (bool) {
1093         _stake(_msgSender(), amount, _nextCheckpoint());
1094         return true;
1095     }
1096 
1097     /**
1098      * @dev Stake all of user tokens.
1099      *
1100      * Emits {Stake} event indicating amount of tokens staked.
1101      */
1102     function stakeAll() public activeStake returns (bool) {
1103         _stake(_msgSender(), balanceOf(_msgSender()),  _nextCheckpoint());
1104         return true;
1105     }
1106 
1107     /**
1108      * @dev Stakes specified `amount` of user tokens.
1109      *
1110      * Emits {Stake} event indicating amount of tokens staked.
1111      */
1112     function unstake(uint256 amount) public activeStake returns (bool) {
1113         _unstake(_msgSender(), amount, _nextCheckpoint());
1114         return true;
1115     }
1116 
1117     /**
1118      * @dev Unstakes all of user tokens.
1119      *
1120      * Emits {Stake} event indicating amount of tokens unstaked.
1121      */
1122     function unstakeAll() public activeStake returns (bool) {
1123         _unstake(_msgSender(), stakeOf(_msgSender()), _nextCheckpoint());
1124         return true;
1125     }
1126 
1127     /**
1128      * @dev Withdraw user's reward for staking his tokens.
1129      *
1130      * Emits {Transfer} event.
1131      * Emits {Stake} event.
1132      */
1133     function withdrawReward() public activeStake returns (bool) {
1134         _mintReward(_msgSender(), _nextCheckpoint());
1135         return true;
1136     }
1137 
1138     /**
1139      * @dev Returns the potential reward that user can get for his/her staked coins if he/she was to withdraw it.
1140      */
1141     function estimateReward() public view returns (uint256) {
1142         return _calcReward(_msgSender(), _nextCheckpoint());
1143     }
1144 
1145     /**
1146      * @dev Returns upcoming checkpoint timeout
1147      */
1148     function nextCheckpoint() public view returns (uint256) {
1149         return _nextCheckpoint();
1150     }
1151 
1152     /**
1153      * @dev Returns previous checkpoint
1154      */
1155     function lastCheckpoint() public view returns (uint256) {
1156         return _lastCheckpoint();
1157     }
1158 
1159     /**
1160      * @dev Owner's method to manually update checkpoints.
1161      */
1162     function tick(uint256 repeats) public onlyOwner returns (bool) {
1163         _tick(repeats);
1164         return true;
1165     }
1166 
1167     /**
1168      * @dev Owner's method to manually tick next checkpoint.
1169      */
1170     function tickNext() public onlyOwner returns (bool) {
1171         return _tickNext();
1172     }
1173 
1174     /**
1175      * @dev Reward user.
1176      */
1177     function rewardStaker(address account) public onlyOwner activeStake returns (bool) {
1178         _mintReward(account, _nextCheckpoint());
1179         return true;
1180     }
1181 
1182     /**
1183      * @dev Returns number of coins staked by `account`.
1184      *
1185      * This function returns number of all coins staked regardless of the time range.
1186      */
1187     function _stakeOf(address account) internal view returns (uint256) {
1188         return _stakes[account].amount;
1189     }
1190 
1191     /**
1192      * @dev Returns number of coins staked by `account`
1193      *
1194      * This function returns number of only valid staked coins.
1195      */
1196     function _stakeOf(address account, uint256 checkpoint) internal view returns (uint256) {
1197         if (_stakes[account].minCheckpoint <= checkpoint && _stakes[account].maxCheckpoint > checkpoint) {
1198             return _stakes[account].amount;
1199         }
1200         return 0;
1201     }
1202 
1203     /**
1204      * @dev Returns upcoming checkpoint timeout
1205      */
1206     function _nextCheckpoint() internal view returns (uint256) {
1207         return _stakeCheckpoint;
1208     }
1209 
1210     /**
1211      * @dev Returns previous checkpoint
1212      */
1213     function _lastCheckpoint() internal view returns (uint256) {
1214         return _stakeCheckpoint.sub(_stakeInterval);
1215     }
1216 
1217     /**
1218      * @dev Stakes given amount of coins belonging to user, with addition of any possible reward.
1219      *
1220      * Emits {Stake} event indicating amount of tokens staked.
1221      *
1222      * Requirements
1223      * - `sender` cannot be the zero address
1224      */
1225     function _restake(address _sender, uint256 _nxtCheckpoint) internal {
1226         _unstake(_sender, stakeOf(_sender), _nxtCheckpoint);
1227         _stake(_sender, balanceOf(_sender), _nxtCheckpoint);
1228     }
1229 
1230     /**
1231      * @dev Stakes given amount of coins belonging to user. New stake is always added to the old one, not replaced.
1232      *
1233      * Emits {Stake} event indicating amount of tokens staked.
1234      *
1235      * Requirements
1236      * - `sender` cannot be the zero address
1237      * - `amount` cannot be lesser than `_stakeMinAmount`
1238      */
1239     function _stake(address _sender, uint256 _amount, uint256 _nxtCheckpoint) internal {
1240         require(_sender != address(0), "ERC20Stakable: stake from the zero address!");
1241         require(_amount >= _stakeMinAmount, "ERC20Stakable: stake amount is too low!");
1242         require(_nxtCheckpoint >= _stakeStartCheck && _stakeStartCheck > 0, "ERC20Stakable: staking has not started yet!");
1243 
1244         stakeStruct memory prevStake = _stakes[_sender];
1245         uint256 _prevAmount = prevStake.amount;
1246         uint256 _nextAmount = _prevAmount.add(_amount);
1247         if (_nextAmount == 0) return;
1248 
1249         _unstake(_sender, _prevAmount, _nxtCheckpoint);
1250 
1251         uint256 _minCheckpoint = _nxtCheckpoint.add(_stakeMinAge).sub(_stakeInterval);
1252         uint256 _maxCheckpoint = _minCheckpoint.add(_stakeMaxAge);
1253 
1254         uint256 _tierNext = _tierOf(_nextAmount);
1255 
1256         uint256 _tmpCheckpoint = _minCheckpoint;
1257         uint size = _maxCheckpoint.sub(_minCheckpoint).div(_stakeInterval);
1258 
1259         for (uint i = 0; i < size; i++) {
1260             _history[_tmpCheckpoint][_tierNext] = _history[_tmpCheckpoint][_tierNext].add(_nextAmount);
1261             _tmpCheckpoint = _tmpCheckpoint.add(_stakeInterval);
1262         }
1263 
1264         stakeStruct memory nextStake = stakeStruct(_nextAmount, _minCheckpoint, _maxCheckpoint);
1265 
1266         _decreaseBalance(_sender, _nextAmount);
1267         _stakes[_sender] = nextStake;
1268 
1269         emit Stake(address(0), _sender, _nextAmount);
1270     }
1271 
1272     /**
1273      * @dev Unstakes all of the coins staked by the user and put them back into his/her balance.
1274      *
1275      * Requirements
1276      * - `sender` cannot be the zero address
1277      */
1278     function _unstake(address _sender, uint256 _amount, uint256 _nxtCheckpoint) internal {
1279         require(_sender != address(0), "ERC20Stakable: unstake from the zero address!");
1280         require(_nxtCheckpoint >= _stakeStartCheck && _stakeStartCheck > 0, "ERC20Stakable: staking has not started yet!");
1281 
1282         _mintReward(_sender, _nxtCheckpoint);
1283 
1284         stakeStruct memory prevStake = _stakes[_sender];
1285         uint256 _prevAmount = prevStake.amount;
1286         if (_prevAmount == 0) return;
1287         uint256 _nextAmount = _prevAmount.sub(_amount);
1288 
1289         uint256 _minCheckpoint = _nxtCheckpoint > prevStake.minCheckpoint ? _nxtCheckpoint : prevStake.minCheckpoint;
1290         uint256 _maxCheckpoint = prevStake.maxCheckpoint;
1291         if (_minCheckpoint > _maxCheckpoint) _minCheckpoint = _maxCheckpoint;
1292 
1293         uint256 _tierPrev = _tierOf(_prevAmount);
1294         uint256 _tierNext = _tierOf(_nextAmount);
1295 
1296         uint256 _tmpCheckpoint = _minCheckpoint;
1297         uint size = _maxCheckpoint.sub(_minCheckpoint).div(_stakeInterval);
1298 
1299         for (uint i = 0; i < size; i++) {
1300             _history[_tmpCheckpoint][_tierPrev] = _history[_tmpCheckpoint][_tierPrev].sub(_prevAmount);
1301             _history[_tmpCheckpoint][_tierNext] = _history[_tmpCheckpoint][_tierNext].add(_nextAmount);
1302             _tmpCheckpoint = _tmpCheckpoint.add(_stakeInterval);
1303         }
1304 
1305         stakeStruct memory nextStake = stakeStruct(_nextAmount, prevStake.minCheckpoint, prevStake.maxCheckpoint);
1306 
1307         _stakes[_sender] = nextStake;
1308         _increaseBalance(_sender, _amount);
1309 
1310         emit Stake(_sender, address(0), _amount);
1311     }
1312 
1313     /**
1314      * @dev Mints the reward to which `_address` is entitled to, adds this reward to his/her balance, and restakes his/her
1315      * staked coins with resetted coinAge.
1316      *
1317      * Emits a {Transfer} event indicating the reward received by the user.
1318      *
1319      * Requirements
1320      * - `_address` cannot be the zero address
1321      */
1322     function _mintReward(address _address, uint256 _nxtCheckpoint) internal {
1323         require(_address != address(0), "ERC20Stakable: withdraw from the zero address!");
1324         require(_nxtCheckpoint >= _stakeStartCheck && _stakeStartCheck > 0, "ERC20Stakable: staking has not started yet!");
1325 
1326         stakeStruct memory prevStake = _stakes[_address];
1327         uint256 _prevAmount = prevStake.amount;
1328         if (_prevAmount == 0) return;
1329 
1330         uint256 _minCheckpoint = prevStake.minCheckpoint;
1331         uint256 _maxCheckpoint = _nxtCheckpoint < prevStake.maxCheckpoint ? _nxtCheckpoint : prevStake.maxCheckpoint;
1332         if (_minCheckpoint >= _maxCheckpoint) return;
1333 
1334         uint256 rewardAmount = _getProofOfStakeReward(_address, _minCheckpoint, _maxCheckpoint);
1335         uint256 remainAmount = _maxTotalSupply.sub(_jointSupply());
1336         if (rewardAmount > remainAmount) {
1337             rewardAmount = remainAmount;
1338         }
1339 
1340         stakeStruct memory nextStake = stakeStruct(_prevAmount, _maxCheckpoint, prevStake.maxCheckpoint);
1341 
1342         _stakes[_address] = nextStake;
1343         _mint(_address, rewardAmount);
1344     }
1345 
1346     /**
1347      * @dev Returns the potential reward that user can get for his/her staked coins if he/she was to withdraw it.
1348      */
1349     function _calcReward(address _address, uint256 _nxtCheckpoint) internal view returns (uint256) {
1350         require(_address != address(0), "ERC20Stakable: calculate reward from the zero address!");
1351         require(_nxtCheckpoint >= _stakeStartCheck && _stakeStartCheck > 0, "ERC20Stakable: staking has not started yet!");
1352 
1353         stakeStruct memory prevStake = _stakes[_address];
1354         uint256 _minCheckpoint = prevStake.minCheckpoint;
1355         uint256 _maxCheckpoint = _nxtCheckpoint < prevStake.maxCheckpoint ? _nxtCheckpoint : prevStake.maxCheckpoint;
1356         if (_minCheckpoint >= _maxCheckpoint) return 0;
1357         return _getProofOfStakeReward(_address, _minCheckpoint, _maxCheckpoint);
1358     }
1359 
1360     /**
1361      * @dev Returns Proof of Stake Reward for given checkpoint
1362      */
1363     function _getProofOfStakeReward(address _address, uint256 _minCheckpoint, uint256 _maxCheckpoint) internal view returns (uint256) {
1364         if (_minCheckpoint == 0 || _maxCheckpoint == 0) return 0;
1365         uint256 _curReward = 0;
1366         uint256 _tmpCheckpoint = _minCheckpoint;
1367         uint size = _maxCheckpoint.sub(_minCheckpoint).div(_stakeInterval);
1368 
1369         for (uint i = 0; i < size; i++) {
1370             _curReward = _curReward.add(_getCheckpointReward(_address, _tmpCheckpoint));
1371             _tmpCheckpoint = _tmpCheckpoint.add(_stakeInterval);
1372         }
1373         return _curReward;
1374     }
1375 
1376     /**
1377      * @dev Returns reward that owner of _address is entitled to for staking his coins.
1378      *
1379      * Requirements:
1380      * - `_stakeStartCheck` must be lesser or equal to now time and different than zero.
1381      */
1382     function _getCheckpointReward(address _address, uint256 _checkpoint) internal view returns (uint256) {
1383         if (_checkpoint < _stakeStartCheck || _stakeStartCheck <= 0) return 0;
1384         uint256 maxReward = _getReward(_checkpoint);
1385         uint256 userStake = _stakeOf(_address);
1386         uint256 tier = _tierOf(userStake);
1387         uint256 tierStake = _history[_checkpoint][tier];
1388         if (tierStake == 0) return 0;
1389         return maxReward.mul(_tierShares[tier]).div(100).mul(userStake).div(tierStake);
1390     }
1391 
1392     /**
1393      * @dev Increases balance of tokens belonging to one user without increasing total supply!
1394      *
1395      * This is internal function designed to use when _balances variable is not the only one containing user overall
1396      * balance. This method changes state of only that variable, so it needs to be used with caution. Make sure to use it
1397      * properly and to not introduce state inconsistencies!!!
1398      *
1399      * Requirements:
1400      * - `account` cannot be the zero address
1401      * - `account` must have free space for balance of at least `amount`
1402      */
1403     function _increaseBalance(address account, uint256 amount) internal {
1404         require(account != address(0), "ERC20Stakable: balance increase from the zero address!");
1405         _balances[account] = _balances[account].add(amount);
1406     }
1407 
1408     /**
1409      * @dev Decreases balance of tokens belonging to one user without increasing total supply!
1410      *
1411      * This is internal function designed to use when _balances variable is not the only one containing user overall
1412      * balance. This method changes state of only that variable, so it needs to be used with caution. Make sure to use it
1413      * properly and to not introduce state inconsistencies!!!
1414      *
1415      * Requirements:
1416      * - `account` cannot be the zero address
1417      * - `account` must have a balance of at least `amount`
1418      */
1419     function _decreaseBalance(address account, uint256 amount) internal {
1420         require(account != address(0), "ERC20Stakable: balance decrease from the zero address!");
1421         _balances[account] = _balances[account].sub(amount, "ERC20Stakable: balance decrease amount exceeds balance!");
1422     }
1423 
1424     /**
1425      * @dev Returns initial balance with addition to all potential rewards received.
1426      */
1427     function _jointSupply() internal view returns (uint256) {
1428         return _minTotalSupply.add(_stakeSumReward);
1429     }
1430 
1431     /**
1432      * @dev Updates checkpoint to the newest one.
1433      */
1434     function _tick() internal {
1435         while (_tickNext()) {}
1436     }
1437 
1438     /**
1439      * @dev Updates checkpoint to the newest one with circuit breaker.
1440      */
1441     function _tick(uint256 limit) internal {
1442         for (uint256 max = limit; _tickNext() && max > 0; max--) {}
1443     }
1444 
1445     /**
1446      * @dev Updates checkpoint to the next one.
1447      */
1448     function _tickNext() internal returns (bool) {
1449         uint256 _now = uint256(now);
1450         if (_now >= _stakeCheckpoint && _stakeCheckpoint > 0) {
1451             _tickCheckpoint(_stakeCheckpoint, _stakeCheckpoint.add(_stakeInterval));
1452             return true;
1453         }
1454         return false;
1455     }
1456 
1457     /**
1458      * @dev Updates checkpoint to the next one.
1459      */
1460     function _tickCheckpoint(uint256 _prvCheckpoint, uint256 _newCheckpoint) internal {
1461         uint256 _maxReward = (_prvCheckpoint == _stakeStartCheck) ? 0 :_getReward(_prvCheckpoint);
1462 
1463         _stakeCheckpoint = _newCheckpoint;
1464         _stakeSumReward = _stakeSumReward.add(_maxReward);
1465 
1466         emit Checkpoint(_prvCheckpoint, _maxReward);
1467     }
1468 
1469     /**
1470      * @dev Returns tier of an amount.
1471      */
1472     function _tierOf(uint256 _amount) internal view returns (uint256) {
1473         uint256 tier = 0;
1474         uint256 tlen = _tierThresholds.length;
1475         for (uint i = 0; i < tlen; i++) {
1476             if (tier == i && _tierThresholds[i] != 0 && _tierThresholds[i] <= _amount) tier++;
1477         }
1478         return tier;
1479     }
1480 
1481     /**
1482     * @dev Sets reward by timestamp
1483     */
1484     function _setReward(uint256 timestamp, uint256 amount) internal {
1485         uint256 _newestLen = _stakeRewardTimestamps.length;
1486         uint256 _newestTimestamp = _newestLen == 0 ? 0 : _stakeRewardTimestamps[_newestLen-1];
1487         require(amount >= 0, "ERC20Stakable: future reward set too low");
1488         require(timestamp >= _newestTimestamp, "ERC20Stakable: future timestamp cannot be set before current timestamp");
1489         _stakeRewardTimestamps.push(timestamp);
1490         _stakeRewardAmountVals.push(amount);
1491     }
1492 
1493     /**
1494      * @dev Gets reward by timestamp
1495      */
1496     function _getReward(uint256 timestamp) internal view returns (uint256) {
1497         uint256 _currentTimestamp = 0;
1498         uint256 _currentRewardVal = 0;
1499         uint256 _rewardLen = _stakeRewardTimestamps.length;
1500         for (uint256 i=0; i<_rewardLen; i++) {
1501             if (timestamp >= _stakeRewardTimestamps[i]) {
1502                 _currentTimestamp = _stakeRewardTimestamps[i];
1503                 _currentRewardVal = _stakeRewardAmountVals[i];
1504             }
1505         }
1506         return _currentRewardVal;
1507     }
1508 
1509     //uint256[50] private ______gap;
1510 }
1511 
1512 // File: contracts/src/Role/Roles.sol
1513 
1514 pragma solidity ^0.5.16;
1515 
1516 /**
1517  * @title Roles
1518  * @dev Library for managing addresses assigned to a Role.
1519  */
1520 library Roles {
1521     struct Role {
1522         mapping (address => bool) bearer;
1523     }
1524 
1525     /**
1526      * @dev Give an account access to this role.
1527      */
1528     function add(Role storage role, address account) internal {
1529         require(!has(role, account), "Roles: account already has role");
1530         role.bearer[account] = true;
1531     }
1532 
1533     /**
1534      * @dev Remove an account's access to this role.
1535      */
1536     function remove(Role storage role, address account) internal {
1537         require(has(role, account), "Roles: account does not have role");
1538         role.bearer[account] = false;
1539     }
1540 
1541     /**
1542      * @dev Check if an account has this role.
1543      * @return bool
1544      */
1545     function has(Role storage role, address account) internal view returns (bool) {
1546         require(account != address(0), "Roles: account is the zero address");
1547         return role.bearer[account];
1548     }
1549 }
1550 
1551 // File: contracts/src/Role/PauserRole.sol
1552 
1553 pragma solidity ^0.5.16;
1554 
1555 
1556 
1557 
1558 contract PauserRole is Initializable, Context {
1559     using Roles for Roles.Role;
1560 
1561     event PauserAdded(address indexed account);
1562     event PauserRemoved(address indexed account);
1563 
1564     Roles.Role private _pausers;
1565 
1566     function initialize(address sender) public initializer {
1567         if (!isPauser(sender)) {
1568             _addPauser(sender);
1569         }
1570     }
1571 
1572     modifier onlyPauser() {
1573         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1574         _;
1575     }
1576 
1577     function isPauser(address account) public view returns (bool) {
1578         return _pausers.has(account);
1579     }
1580 
1581     function addPauser(address account) public onlyPauser {
1582         _addPauser(account);
1583     }
1584 
1585     function renouncePauser() public {
1586         _removePauser(_msgSender());
1587     }
1588 
1589     function _addPauser(address account) internal {
1590         _pausers.add(account);
1591         emit PauserAdded(account);
1592     }
1593 
1594     function _removePauser(address account) internal {
1595         _pausers.remove(account);
1596         emit PauserRemoved(account);
1597     }
1598 
1599     //uint256[50] private ______gap;
1600 }
1601 
1602 // File: contracts/src/Access/Pausable.sol
1603 
1604 pragma solidity ^0.5.16;
1605 
1606 
1607 /**
1608  * @dev Contract module which allows children to implement an emergency stop
1609  * mechanism that can be triggered by an authorized account.
1610  *
1611  * This module is used through inheritance. It will make available the
1612  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1613  * the functions of your contract. Note that they will not be pausable by
1614  * simply including this module, only once the modifiers are put in place.
1615  */
1616 contract Pausable is PauserRole {
1617     /**
1618      * @dev Emitted when the pause is triggered by a pauser (`account`).
1619      */
1620     event Paused(address account);
1621 
1622     /**
1623      * @dev Emitted when the pause is lifted by a pauser (`account`).
1624      */
1625     event Unpaused(address account);
1626 
1627     bool internal _paused;
1628 
1629     /**
1630      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1631      * to the deployer.
1632      */
1633     function initialize(address sender) public initializer {
1634         PauserRole.initialize(sender);
1635 
1636         _paused = false;
1637     }
1638 
1639     /**
1640      * @dev Returns true if the contract is paused, and false otherwise.
1641      */
1642     function paused() public view returns (bool) {
1643         return _paused;
1644     }
1645 
1646     /**
1647      * @dev Modifier to make a function callable only when the contract is not paused.
1648      */
1649     modifier whenNotPaused() {
1650         require(!_paused, "Pausable: paused");
1651         _;
1652     }
1653 
1654     /**
1655      * @dev Modifier to make a function callable only when the contract is paused.
1656      */
1657     modifier whenPaused() {
1658         require(_paused, "Pausable: not paused");
1659         _;
1660     }
1661 
1662     /**
1663      * @dev Called by a pauser to pause, triggers stopped state.
1664      */
1665     function pause() public onlyPauser whenNotPaused {
1666         _paused = true;
1667         emit Paused(_msgSender());
1668     }
1669 
1670     /**
1671      * @dev Called by a pauser to unpause, returns to normal state.
1672      */
1673     function unpause() public onlyPauser whenPaused {
1674         _paused = false;
1675         emit Unpaused(_msgSender());
1676     }
1677 
1678     //uint256[50] private ______gap;
1679 }
1680 
1681 // File: contracts/src/GCC/GCCDiscreteToken.sol
1682 
1683 pragma solidity ^0.5.16;
1684 
1685 
1686 
1687 
1688 
1689 
1690 
1691 contract GCCDiscreteToken is GCCOracleProofConsumer, ERC20Detailed, ERC20Burnable, ERC20StakableDiscreetly, Pausable {
1692 
1693     function initialize(
1694         address sender, string memory name, string memory symbol, uint8 decimals, uint256 minTotalSupply, uint256 maxTotalSupply,
1695         uint256 provableSupply
1696     ) public initializer {
1697         GCCOracleProofConsumer.initialize(sender, provableSupply);
1698         ERC20Detailed.initialize(name, symbol, decimals);
1699         ERC20StakableDiscreetly.initialize(sender, minTotalSupply, maxTotalSupply, decimals);
1700         Pausable.initialize(sender);
1701     }
1702 
1703     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
1704         return super.transfer(to, value);
1705     }
1706 
1707     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
1708         return super.transferFrom(from, to, value);
1709     }
1710 
1711     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
1712         return super.approve(spender, value);
1713     }
1714 
1715     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
1716         return super.increaseAllowance(spender, addedValue);
1717     }
1718 
1719     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
1720         return super.decreaseAllowance(spender, subtractedValue);
1721     }
1722 
1723     function restake() public whenNotPaused returns (bool) {
1724         return super.restake();
1725     }
1726 
1727     function stake(uint256 amount) public whenNotPaused returns (bool) {
1728         return super.stake(amount);
1729     }
1730 
1731     function stakeAll() public whenNotPaused returns (bool) {
1732         return super.stakeAll();
1733     }
1734 
1735     function unstake(uint256 amount) public whenNotPaused returns (bool) {
1736         return super.unstake(amount);
1737     }
1738 
1739     function unstakeAll() public whenNotPaused returns (bool) {
1740         return super.unstakeAll();
1741     }
1742 
1743     function withdrawReward() public whenNotPaused returns (bool) {
1744         return super.withdrawReward();
1745     }
1746 
1747     function estimateReward() public view whenNotPaused returns (uint256) {
1748         return super.estimateReward();
1749     }
1750 
1751     /**
1752      * @dev Hook to execute when proving amount
1753      */
1754     function _afterConsumeProofs(address account, uint256 amount) internal {
1755         _mint(account, amount);
1756     }
1757 
1758     //uint256[50] private ______gap;
1759 }
1760 
1761 // File: contracts/src/GCCDiscrete.sol
1762 
1763 pragma solidity ^0.5.16;
1764 
1765 
1766 contract GCCDiscrete is GCCDiscreteToken {
1767 
1768     constructor(
1769         string memory name, string memory symbol, uint8 decimals, uint256 minTotalSupply, uint256 maxTotalSupply,
1770         uint256 provableSupply
1771     ) public {
1772         GCCDiscreteToken.initialize(_msgSender(), name, symbol, decimals, minTotalSupply, maxTotalSupply, provableSupply);
1773     }
1774 }