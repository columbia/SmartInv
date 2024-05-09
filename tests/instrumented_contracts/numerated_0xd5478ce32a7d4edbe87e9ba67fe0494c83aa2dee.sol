1 pragma solidity ^0.6.0;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's uintXX casting operators with added overflow
6  * checks.
7  *
8  * Downcasting from uint256 in Solidity does not revert on overflow. This can
9  * easily result in undesired exploitation or bugs, since developers usually
10  * assume that overflows raise errors. `SafeCast` restores this intuition by
11  * reverting the transaction when such an operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  *
16  * Can be combined with {SafeMath} to extend it to smaller types, by performing
17  * all math on `uint256` and then downcasting.
18  */
19 library SafeCast {
20 
21     /**
22      * @dev Returns the downcasted uint128 from uint256, reverting on
23      * overflow (when the input is greater than largest uint128).
24      *
25      * Counterpart to Solidity's `uint128` operator.
26      *
27      * Requirements:
28      *
29      * - input must fit into 128 bits
30      */
31     function toUint128(uint256 value) internal pure returns (uint128) {
32         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
33         return uint128(value);
34     }
35 
36     /**
37      * @dev Returns the downcasted uint64 from uint256, reverting on
38      * overflow (when the input is greater than largest uint64).
39      *
40      * Counterpart to Solidity's `uint64` operator.
41      *
42      * Requirements:
43      *
44      * - input must fit into 64 bits
45      */
46     function toUint64(uint256 value) internal pure returns (uint64) {
47         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
48         return uint64(value);
49     }
50 
51     /**
52      * @dev Returns the downcasted uint32 from uint256, reverting on
53      * overflow (when the input is greater than largest uint32).
54      *
55      * Counterpart to Solidity's `uint32` operator.
56      *
57      * Requirements:
58      *
59      * - input must fit into 32 bits
60      */
61     function toUint32(uint256 value) internal pure returns (uint32) {
62         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
63         return uint32(value);
64     }
65 
66     /**
67      * @dev Returns the downcasted uint16 from uint256, reverting on
68      * overflow (when the input is greater than largest uint16).
69      *
70      * Counterpart to Solidity's `uint16` operator.
71      *
72      * Requirements:
73      *
74      * - input must fit into 16 bits
75      */
76     function toUint16(uint256 value) internal pure returns (uint16) {
77         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
78         return uint16(value);
79     }
80 
81     /**
82      * @dev Returns the downcasted uint8 from uint256, reverting on
83      * overflow (when the input is greater than largest uint8).
84      *
85      * Counterpart to Solidity's `uint8` operator.
86      *
87      * Requirements:
88      *
89      * - input must fit into 8 bits.
90      */
91     function toUint8(uint256 value) internal pure returns (uint8) {
92         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
93         return uint8(value);
94     }
95 
96     /**
97      * @dev Converts a signed int256 into an unsigned uint256.
98      *
99      * Requirements:
100      *
101      * - input must be greater than or equal to 0.
102      */
103     function toUint256(int256 value) internal pure returns (uint256) {
104         require(value >= 0, "SafeCast: value must be positive");
105         return uint256(value);
106     }
107 
108     /**
109      * @dev Converts an unsigned uint256 into a signed int256.
110      *
111      * Requirements:
112      *
113      * - input must be less than or equal to maxInt256.
114      */
115     function toInt256(uint256 value) internal pure returns (int256) {
116         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
117         return int256(value);
118     }
119 }
120 
121 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
122 
123 pragma solidity >=0.4.24 <0.7.0;
124 
125 
126 /**
127  * @title Initializable
128  *
129  * @dev Helper contract to support initializer functions. To use it, replace
130  * the constructor with a function that has the `initializer` modifier.
131  * WARNING: Unlike constructors, initializer functions must be manually
132  * invoked. This applies both to deploying an Initializable contract, as well
133  * as extending an Initializable contract via inheritance.
134  * WARNING: When used with inheritance, manual care must be taken to not invoke
135  * a parent initializer twice, or ensure that all initializers are idempotent,
136  * because this is not dealt with automatically as with constructors.
137  */
138 contract Initializable {
139 
140   /**
141    * @dev Indicates that the contract has been initialized.
142    */
143   bool private initialized;
144 
145   /**
146    * @dev Indicates that the contract is in the process of being initialized.
147    */
148   bool private initializing;
149 
150   /**
151    * @dev Modifier to use in the initializer function of a contract.
152    */
153   modifier initializer() {
154     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
155 
156     bool isTopLevelCall = !initializing;
157     if (isTopLevelCall) {
158       initializing = true;
159       initialized = true;
160     }
161 
162     _;
163 
164     if (isTopLevelCall) {
165       initializing = false;
166     }
167   }
168 
169   /// @dev Returns true if and only if the function is running in the constructor
170   function isConstructor() private view returns (bool) {
171     // extcodesize checks the size of the code stored in an address, and
172     // address returns the current address. Since the code is still not
173     // deployed when running a constructor, any checks on its code size will
174     // yield zero, making it an effective way to detect if a contract is
175     // under construction or not.
176     address self = address(this);
177     uint256 cs;
178     assembly { cs := extcodesize(self) }
179     return cs == 0;
180   }
181 
182   // Reserved storage space to allow for layout changes in the future.
183   uint256[50] private ______gap;
184 }
185 
186 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
187 
188 pragma solidity ^0.6.0;
189 
190 
191 /*
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with GSN meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 contract ContextUpgradeSafe is Initializable {
202     // Empty internal constructor, to prevent people from mistakenly deploying
203     // an instance of this contract, which should be used via inheritance.
204 
205     function __Context_init() internal initializer {
206         __Context_init_unchained();
207     }
208 
209     function __Context_init_unchained() internal initializer {
210 
211 
212     }
213 
214 
215     function _msgSender() internal view virtual returns (address payable) {
216         return msg.sender;
217     }
218 
219     function _msgData() internal view virtual returns (bytes memory) {
220         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
221         return msg.data;
222     }
223 
224     uint256[50] private __gap;
225 }
226 
227 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol
228 
229 pragma solidity ^0.6.0;
230 
231 
232 /**
233  * @dev Contract module which provides a basic access control mechanism, where
234  * there is an account (an owner) that can be granted exclusive access to
235  * specific functions.
236  *
237  * By default, the owner account will be the one that deploys the contract. This
238  * can later be changed with {transferOwnership}.
239  *
240  * This module is used through inheritance. It will make available the modifier
241  * `onlyOwner`, which can be applied to your functions to restrict their use to
242  * the owner.
243  */
244 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
245     address private _owner;
246 
247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249     /**
250      * @dev Initializes the contract setting the deployer as the initial owner.
251      */
252 
253     function __Ownable_init() internal initializer {
254         __Context_init_unchained();
255         __Ownable_init_unchained();
256     }
257 
258     function __Ownable_init_unchained() internal initializer {
259 
260 
261         address msgSender = _msgSender();
262         _owner = msgSender;
263         emit OwnershipTransferred(address(0), msgSender);
264 
265     }
266 
267 
268     /**
269      * @dev Returns the address of the current owner.
270      */
271     function owner() public view returns (address) {
272         return _owner;
273     }
274 
275     /**
276      * @dev Throws if called by any account other than the owner.
277      */
278     modifier onlyOwner() {
279         require(_owner == _msgSender(), "Ownable: caller is not the owner");
280         _;
281     }
282 
283     /**
284      * @dev Leaves the contract without owner. It will not be possible to call
285      * `onlyOwner` functions anymore. Can only be called by the current owner.
286      *
287      * NOTE: Renouncing ownership will leave the contract without an owner,
288      * thereby removing any functionality that is only available to the owner.
289      */
290     function renounceOwnership() public virtual onlyOwner {
291         emit OwnershipTransferred(_owner, address(0));
292         _owner = address(0);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Can only be called by the current owner.
298      */
299     function transferOwnership(address newOwner) public virtual onlyOwner {
300         require(newOwner != address(0), "Ownable: new owner is the zero address");
301         emit OwnershipTransferred(_owner, newOwner);
302         _owner = newOwner;
303     }
304 
305     uint256[49] private __gap;
306 }
307 
308 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
309 
310 pragma solidity ^0.6.0;
311 
312 /**
313  * @dev Interface of the ERC20 standard as defined in the EIP.
314  */
315 interface IERC20 {
316     /**
317      * @dev Returns the amount of tokens in existence.
318      */
319     function totalSupply() external view returns (uint256);
320 
321     /**
322      * @dev Returns the amount of tokens owned by `account`.
323      */
324     function balanceOf(address account) external view returns (uint256);
325 
326     /**
327      * @dev Moves `amount` tokens from the caller's account to `recipient`.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transfer(address recipient, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Returns the remaining number of tokens that `spender` will be
337      * allowed to spend on behalf of `owner` through {transferFrom}. This is
338      * zero by default.
339      *
340      * This value changes when {approve} or {transferFrom} are called.
341      */
342     function allowance(address owner, address spender) external view returns (uint256);
343 
344     /**
345      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * IMPORTANT: Beware that changing an allowance with this method brings the risk
350      * that someone may use both the old and the new allowance by unfortunate
351      * transaction ordering. One possible solution to mitigate this race
352      * condition is to first reduce the spender's allowance to 0 and set the
353      * desired value afterwards:
354      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
355      *
356      * Emits an {Approval} event.
357      */
358     function approve(address spender, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Moves `amount` tokens from `sender` to `recipient` using the
362      * allowance mechanism. `amount` is then deducted from the caller's
363      * allowance.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Emitted when `value` tokens are moved from one account (`from`) to
373      * another (`to`).
374      *
375      * Note that `value` may be zero.
376      */
377     event Transfer(address indexed from, address indexed to, uint256 value);
378 
379     /**
380      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
381      * a call to {approve}. `value` is the new allowance.
382      */
383     event Approval(address indexed owner, address indexed spender, uint256 value);
384 }
385 
386 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
387 
388 pragma solidity ^0.6.0;
389 
390 /**
391  * @dev Wrappers over Solidity's arithmetic operations with added overflow
392  * checks.
393  *
394  * Arithmetic operations in Solidity wrap on overflow. This can easily result
395  * in bugs, because programmers usually assume that an overflow raises an
396  * error, which is the standard behavior in high level programming languages.
397  * `SafeMath` restores this intuition by reverting the transaction when an
398  * operation overflows.
399  *
400  * Using this library instead of the unchecked operations eliminates an entire
401  * class of bugs, so it's recommended to use it always.
402  */
403 library SafeMath {
404     /**
405      * @dev Returns the addition of two unsigned integers, reverting on
406      * overflow.
407      *
408      * Counterpart to Solidity's `+` operator.
409      *
410      * Requirements:
411      * - Addition cannot overflow.
412      */
413     function add(uint256 a, uint256 b) internal pure returns (uint256) {
414         uint256 c = a + b;
415         require(c >= a, "SafeMath: addition overflow");
416 
417         return c;
418     }
419 
420     /**
421      * @dev Returns the subtraction of two unsigned integers, reverting on
422      * overflow (when the result is negative).
423      *
424      * Counterpart to Solidity's `-` operator.
425      *
426      * Requirements:
427      * - Subtraction cannot overflow.
428      */
429     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
430         return sub(a, b, "SafeMath: subtraction overflow");
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
435      * overflow (when the result is negative).
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      * - Subtraction cannot overflow.
441      */
442     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
443         require(b <= a, errorMessage);
444         uint256 c = a - b;
445 
446         return c;
447     }
448 
449     /**
450      * @dev Returns the multiplication of two unsigned integers, reverting on
451      * overflow.
452      *
453      * Counterpart to Solidity's `*` operator.
454      *
455      * Requirements:
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
460         // benefit is lost if 'b' is also tested.
461         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
462         if (a == 0) {
463             return 0;
464         }
465 
466         uint256 c = a * b;
467         require(c / a == b, "SafeMath: multiplication overflow");
468 
469         return c;
470     }
471 
472     /**
473      * @dev Returns the integer division of two unsigned integers. Reverts on
474      * division by zero. The result is rounded towards zero.
475      *
476      * Counterpart to Solidity's `/` operator. Note: this function uses a
477      * `revert` opcode (which leaves remaining gas untouched) while Solidity
478      * uses an invalid opcode to revert (consuming all remaining gas).
479      *
480      * Requirements:
481      * - The divisor cannot be zero.
482      */
483     function div(uint256 a, uint256 b) internal pure returns (uint256) {
484         return div(a, b, "SafeMath: division by zero");
485     }
486 
487     /**
488      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
489      * division by zero. The result is rounded towards zero.
490      *
491      * Counterpart to Solidity's `/` operator. Note: this function uses a
492      * `revert` opcode (which leaves remaining gas untouched) while Solidity
493      * uses an invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      * - The divisor cannot be zero.
497      */
498     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         // Solidity only automatically asserts when dividing by 0
500         require(b > 0, errorMessage);
501         uint256 c = a / b;
502         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
503 
504         return c;
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * Reverts when dividing by zero.
510      *
511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
512      * opcode (which leaves remaining gas untouched) while Solidity uses an
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      * - The divisor cannot be zero.
517      */
518     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
519         return mod(a, b, "SafeMath: modulo by zero");
520     }
521 
522     /**
523      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
524      * Reverts with custom message when dividing by zero.
525      *
526      * Counterpart to Solidity's `%` operator. This function uses a `revert`
527      * opcode (which leaves remaining gas untouched) while Solidity uses an
528      * invalid opcode to revert (consuming all remaining gas).
529      *
530      * Requirements:
531      * - The divisor cannot be zero.
532      */
533     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
534         require(b != 0, errorMessage);
535         return a % b;
536     }
537 }
538 
539 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
540 
541 pragma solidity ^0.6.2;
542 
543 /**
544  * @dev Collection of functions related to the address type
545  */
546 library Address {
547     /**
548      * @dev Returns true if `account` is a contract.
549      *
550      * [IMPORTANT]
551      * ====
552      * It is unsafe to assume that an address for which this function returns
553      * false is an externally-owned account (EOA) and not a contract.
554      *
555      * Among others, `isContract` will return false for the following
556      * types of addresses:
557      *
558      *  - an externally-owned account
559      *  - a contract in construction
560      *  - an address where a contract will be created
561      *  - an address where a contract lived, but was destroyed
562      * ====
563      */
564     function isContract(address account) internal view returns (bool) {
565         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
566         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
567         // for accounts without code, i.e. `keccak256('')`
568         bytes32 codehash;
569         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
570         // solhint-disable-next-line no-inline-assembly
571         assembly { codehash := extcodehash(account) }
572         return (codehash != accountHash && codehash != 0x0);
573     }
574 
575     /**
576      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
577      * `recipient`, forwarding all available gas and reverting on errors.
578      *
579      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
580      * of certain opcodes, possibly making contracts go over the 2300 gas limit
581      * imposed by `transfer`, making them unable to receive funds via
582      * `transfer`. {sendValue} removes this limitation.
583      *
584      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
585      *
586      * IMPORTANT: because control is transferred to `recipient`, care must be
587      * taken to not create reentrancy vulnerabilities. Consider using
588      * {ReentrancyGuard} or the
589      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
590      */
591     function sendValue(address payable recipient, uint256 amount) internal {
592         require(address(this).balance >= amount, "Address: insufficient balance");
593 
594         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
595         (bool success, ) = recipient.call{ value: amount }("");
596         require(success, "Address: unable to send value, recipient may have reverted");
597     }
598 }
599 
600 // SPDX-License-Identifier: MIT
601 
602 pragma solidity ^0.6.0;
603 
604 /**
605  * @dev Implementation of the {IERC20} interface.
606  *
607  * This implementation is agnostic to the way tokens are created. This means
608  * that a supply mechanism has to be added in a derived contract using {_mint}.
609  * For a generic mechanism see {ERC20MinterPauser}.
610  *
611  * TIP: For a detailed writeup see our guide
612  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
613  * to implement supply mechanisms].
614  *
615  * We have followed general OpenZeppelin guidelines: functions revert instead
616  * of returning `false` on failure. This behavior is nonetheless conventional
617  * and does not conflict with the expectations of ERC20 applications.
618  *
619  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
620  * This allows applications to reconstruct the allowance for all accounts just
621  * by listening to said events. Other implementations of the EIP may not emit
622  * these events, as it isn't required by the specification.
623  *
624  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
625  * functions have been added to mitigate the well-known issues around setting
626  * allowances. See {IERC20-approve}.
627  */
628 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
629     using SafeMath for uint256;
630     using Address for address;
631 
632     mapping (address => uint256) private _balances;
633 
634     mapping (address => mapping (address => uint256)) private _allowances;
635 
636     uint256 private _totalSupply;
637 
638     string private _name;
639     string private _symbol;
640     uint8 private _decimals;
641 
642     /**
643      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
644      * a default value of 18.
645      *
646      * To select a different value for {decimals}, use {_setupDecimals}.
647      *
648      * All three of these values are immutable: they can only be set once during
649      * construction.
650      */
651 
652     function __ERC20_init(string memory name, string memory symbol) internal initializer {
653         __Context_init_unchained();
654         __ERC20_init_unchained(name, symbol);
655     }
656 
657     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
658 
659 
660         _name = name;
661         _symbol = symbol;
662         _decimals = 18;
663 
664     }
665 
666 
667     /**
668      * @dev Returns the name of the token.
669      */
670     function name() public view returns (string memory) {
671         return _name;
672     }
673 
674     /**
675      * @dev Returns the symbol of the token, usually a shorter version of the
676      * name.
677      */
678     function symbol() public view returns (string memory) {
679         return _symbol;
680     }
681 
682     /**
683      * @dev Returns the number of decimals used to get its user representation.
684      * For example, if `decimals` equals `2`, a balance of `505` tokens should
685      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
686      *
687      * Tokens usually opt for a value of 18, imitating the relationship between
688      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
689      * called.
690      *
691      * NOTE: This information is only used for _display_ purposes: it in
692      * no way affects any of the arithmetic of the contract, including
693      * {IERC20-balanceOf} and {IERC20-transfer}.
694      */
695     function decimals() public view returns (uint8) {
696         return _decimals;
697     }
698 
699     /**
700      * @dev See {IERC20-totalSupply}.
701      */
702     function totalSupply() public view virtual override returns (uint256) {
703         return _totalSupply;
704     }
705 
706     /**
707      * @dev See {IERC20-balanceOf}.
708      */
709     function balanceOf(address account) public view virtual override returns (uint256) {
710         return _balances[account];
711     }
712 
713     /**
714      * @dev See {IERC20-transfer}.
715      *
716      * Requirements:
717      *
718      * - `recipient` cannot be the zero address.
719      * - the caller must have a balance of at least `amount`.
720      */
721     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
722         _transfer(_msgSender(), recipient, amount);
723         return true;
724     }
725 
726     /**
727      * @dev See {IERC20-allowance}.
728      */
729     function allowance(address owner, address spender) public view virtual override returns (uint256) {
730         return _allowances[owner][spender];
731     }
732 
733     /**
734      * @dev See {IERC20-approve}.
735      *
736      * Requirements:
737      *
738      * - `spender` cannot be the zero address.
739      */
740     function approve(address spender, uint256 amount) public virtual override returns (bool) {
741         _approve(_msgSender(), spender, amount);
742         return true;
743     }
744 
745     /**
746      * @dev See {IERC20-transferFrom}.
747      *
748      * Emits an {Approval} event indicating the updated allowance. This is not
749      * required by the EIP. See the note at the beginning of {ERC20};
750      *
751      * Requirements:
752      * - `sender` and `recipient` cannot be the zero address.
753      * - `sender` must have a balance of at least `amount`.
754      * - the caller must have allowance for ``sender``'s tokens of at least
755      * `amount`.
756      */
757     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
758         _transfer(sender, recipient, amount);
759         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
760         return true;
761     }
762 
763     /**
764      * @dev Atomically increases the allowance granted to `spender` by the caller.
765      *
766      * This is an alternative to {approve} that can be used as a mitigation for
767      * problems described in {IERC20-approve}.
768      *
769      * Emits an {Approval} event indicating the updated allowance.
770      *
771      * Requirements:
772      *
773      * - `spender` cannot be the zero address.
774      */
775     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
776         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
777         return true;
778     }
779 
780     /**
781      * @dev Atomically decreases the allowance granted to `spender` by the caller.
782      *
783      * This is an alternative to {approve} that can be used as a mitigation for
784      * problems described in {IERC20-approve}.
785      *
786      * Emits an {Approval} event indicating the updated allowance.
787      *
788      * Requirements:
789      *
790      * - `spender` cannot be the zero address.
791      * - `spender` must have allowance for the caller of at least
792      * `subtractedValue`.
793      */
794     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
795         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
796         return true;
797     }
798 
799     /**
800      * @dev Moves tokens `amount` from `sender` to `recipient`.
801      *
802      * This is internal function is equivalent to {transfer}, and can be used to
803      * e.g. implement automatic token fees, slashing mechanisms, etc.
804      *
805      * Emits a {Transfer} event.
806      *
807      * Requirements:
808      *
809      * - `sender` cannot be the zero address.
810      * - `recipient` cannot be the zero address.
811      * - `sender` must have a balance of at least `amount`.
812      */
813     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
814         require(sender != address(0), "ERC20: transfer from the zero address");
815         require(recipient != address(0), "ERC20: transfer to the zero address");
816 
817         _beforeTokenTransfer(sender, recipient, amount);
818 
819         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
820         _balances[recipient] = _balances[recipient].add(amount);
821         emit Transfer(sender, recipient, amount);
822     }
823 
824     /**
825      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
826      *
827      * This is internal function is equivalent to `approve`, and can be used to
828      * e.g. set automatic allowances for certain subsystems, etc.
829      *
830      * Emits an {Approval} event.
831      *
832      * Requirements:
833      *
834      * - `owner` cannot be the zero address.
835      * - `spender` cannot be the zero address.
836      */
837     function _approve(address owner, address spender, uint256 amount) internal virtual {
838         require(owner != address(0), "ERC20: approve from the zero address");
839         require(spender != address(0), "ERC20: approve to the zero address");
840 
841         _allowances[owner][spender] = amount;
842         emit Approval(owner, spender, amount);
843     }
844 
845     /**
846      * @dev Sets {decimals} to a value other than the default one of 18.
847      *
848      * WARNING: This function should only be called from the constructor. Most
849      * applications that interact with token contracts will not expect
850      * {decimals} to ever change, and may work incorrectly if it does.
851      */
852     function _setupDecimals(uint8 decimals_) internal {
853         _decimals = decimals_;
854     }
855 
856     /**
857      * @dev Hook that is called before any transfer of tokens. This includes
858      * minting and burning.
859      *
860      * Calling conditions:
861      *
862      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
863      * will be to transferred to `to`.
864      * - when `from` is zero, `amount` tokens will be minted for `to`.
865      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
866      * - `from` and `to` are never both zero.
867      *
868      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
869      */
870     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
871 
872     uint256[44] private __gap;
873 }
874 
875 
876 contract RBASX is ERC20UpgradeSafe, OwnableUpgradeSafe {
877     
878     using SafeCast for int256;
879     using SafeMath for uint256;
880     using Address for address;
881     
882     struct Transaction {
883         bool enabled;
884         address destination;
885         bytes data;
886     }
887 
888     event TransactionFailed(address indexed destination, uint index, bytes data);
889 	
890 	// Stable ordering is not guaranteed.
891 
892     Transaction[] public transactions;
893 
894     uint256 private _epoch;
895     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
896 
897     mapping (address => uint256) private _rOwned;
898     mapping (address => uint256) private _tOwned;
899     mapping (address => mapping (address => uint256)) private _allowances;
900 
901     mapping (address => bool) private _isExcluded;
902     address[] private _excluded;
903 	
904 	uint256 private _totalSupply;
905    
906     uint256 private constant MAX = ~uint256(0);
907     uint256 private _rTotal;
908     uint256 private _tFeeTotal;
909     
910     uint256 private constant DECIMALS = 9;
911     uint256 private constant RATE_PRECISION = 10 ** DECIMALS;
912     
913     uint256 public _tFeePercent;
914     uint256 public _tFeeTimestamp;
915     
916     address public _rebaser;
917     
918     uint256 public _limitExpiresTimestamp;
919     uint256 public _limitTransferAmount;
920     uint256 public _limitMaxBalance;
921     uint256 public _limitSellFeePercent;
922     
923     uint256 public _limitTimestamp;
924     
925     constructor() public{
926         initialize(30000000000000);
927     }
928     
929     function initialize(uint256 initialSupply)
930         public
931         initializer
932     {
933         __ERC20_init("rbasx.finance", "RBASX");
934         _setupDecimals(uint8(DECIMALS));
935         __Ownable_init();
936         
937         _totalSupply = initialSupply;
938         _rTotal = (MAX - (MAX % _totalSupply));
939         
940         _rebaser = _msgSender();
941         
942         _tFeePercent = 300; 
943         _tFeeTimestamp = now;
944 
945         _rOwned[_msgSender()] = _rTotal;
946         emit Transfer(address(0), _msgSender(), _totalSupply);
947         
948         excludeAccount(_msgSender());
949     }
950     
951     function setRebaser(address rebaser) external onlyOwner() {
952         _rebaser = rebaser;
953     }
954     
955     
956     
957     function setLimit(uint256 expiresTimestamp, uint256 transferAmount, uint256 maxBalance, uint256 sellFeePercent) external onlyOwner() {
958         require(_limitTimestamp == 0, "Limit changes not allowed");
959         
960         _limitExpiresTimestamp = expiresTimestamp;
961         _limitTransferAmount = transferAmount;
962         _limitMaxBalance = maxBalance;
963         _limitSellFeePercent = sellFeePercent;
964 
965         _limitTimestamp = now;
966     }
967     
968     function totalSupply() public view override returns (uint256) {
969         return _totalSupply;
970     }
971     
972     function rebase(int256 supplyDelta)
973         external
974         returns (uint256)
975     {
976         require(_msgSender() == owner() || _msgSender() == _rebaser, "Sender not authorized");
977         
978         _epoch = _epoch.add(1);
979 		
980         if (supplyDelta == 0) {
981             emit LogRebase(_epoch, _totalSupply);
982             return _totalSupply;
983         }
984         
985         uint256 uSupplyDelta = (supplyDelta < 0 ? -supplyDelta : supplyDelta).toUint256();
986         uint256 rate = uSupplyDelta.mul(RATE_PRECISION).div(_totalSupply);
987         uint256 multiplier;
988         
989         if (supplyDelta < 0) {
990             multiplier = RATE_PRECISION.sub(rate);
991         } else {
992             multiplier = RATE_PRECISION.add(rate);
993         }
994         
995         if (supplyDelta < 0) {
996             _totalSupply = _totalSupply.sub(uSupplyDelta);
997         } else {
998             _totalSupply = _totalSupply.add(uSupplyDelta);
999         }
1000         
1001         if (_totalSupply > MAX) {
1002             _totalSupply = MAX;
1003         }
1004         
1005         for (uint256 i = 0; i < _excluded.length; i++) {
1006             if(_tOwned[_excluded[i]] > 0) {
1007                 _tOwned[_excluded[i]] = _tOwned[_excluded[i]].mul(multiplier).div(RATE_PRECISION);
1008             }
1009         }
1010         
1011         emit LogRebase(_epoch, _totalSupply);
1012 
1013 		for (uint i = 0; i < transactions.length; i++) {
1014             Transaction storage t = transactions[i];
1015             if (t.enabled) {
1016                 bool result = externalCall(t.destination, t.data);
1017                 if (!result) {
1018                     emit TransactionFailed(t.destination, i, t.data);
1019                     revert("Transaction Failed");
1020                 }
1021             }
1022         }
1023 
1024         return _totalSupply;
1025     }
1026     
1027     /**
1028      * @notice Adds a transaction that gets called for a downstream receiver of rebases
1029      * @param destination Address of contract destination
1030      * @param data Transaction data payload
1031      */
1032 	
1033     function addTransaction(address destination, bytes memory data)
1034         external
1035         onlyOwner
1036     {
1037         transactions.push(Transaction({
1038             enabled: true,
1039             destination: destination,
1040             data: data
1041         }));
1042     }
1043 	
1044 	/**
1045      * @param index Index of transaction to remove.
1046      *              Transaction ordering may have changed since adding.
1047      */
1048 
1049     function removeTransaction(uint index)
1050         external
1051         onlyOwner
1052     {
1053         require(index < transactions.length, "index out of bounds");
1054 
1055         if (index < transactions.length - 1) {
1056             transactions[index] = transactions[transactions.length - 1];
1057         }
1058 
1059         transactions.pop();
1060     }
1061 	
1062 	/**
1063      * @param index Index of transaction. Transaction ordering may have changed since adding.
1064      * @param enabled True for enabled, false for disabled.
1065      */
1066 
1067     function setTransactionEnabled(uint index, bool enabled)
1068         external
1069         onlyOwner
1070     {
1071         require(index < transactions.length, "index must be in range of stored tx list");
1072         transactions[index].enabled = enabled;
1073     }
1074 	
1075 	/**
1076      * @return Number of transactions, both enabled and disabled, in transactions list.
1077      */
1078 
1079     function transactionsSize()
1080         external
1081         view
1082         returns (uint256)
1083     {
1084         return transactions.length;
1085     }
1086 	
1087 	/**
1088      * @dev wrapper to call the encoded transactions on downstream consumers.
1089      * @param destination Address of destination contract.
1090      * @param data The encoded data payload.
1091      * @return True on success
1092      */
1093 
1094     function externalCall(address destination, bytes memory data)
1095         internal
1096         returns (bool)
1097     {
1098         bool result;
1099         assembly {  // solhint-disable-line no-inline-assembly
1100             // "Allocate" memory for output
1101             // (0x40 is where "free memory" pointer is stored by convention)
1102             let outputAddress := mload(0x40)
1103 
1104             // First 32 bytes are the padded length of data, so exclude that
1105             let dataAddress := add(data, 32)
1106 
1107             result := call(
1108                 // 34710 is the value that solidity is currently emitting
1109                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
1110                 // + callValueTransferGas (9000) + callNewAccountGas
1111                 // (25000, in case the destination address does not exist and needs creating)
1112                 sub(gas(), 34710),
1113 
1114 
1115                 destination,
1116                 0, // transfer value in wei
1117                 dataAddress,
1118                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
1119                 outputAddress,
1120                 0  // Output is ignored, therefore the output size is zero
1121             )
1122         }
1123         return result;
1124     }
1125 
1126     function balanceOf(address account) public view override returns (uint256) {
1127         if (_isExcluded[account]) return _tOwned[account];
1128         return tokenFromRefraction(_rOwned[account]);
1129     }
1130 
1131     function transfer(address recipient, uint256 amount) public override returns (bool) {
1132         _transfer(_msgSender(), recipient, amount);
1133         return true;
1134     }
1135 
1136     function allowance(address owner, address spender) public view override returns (uint256) {
1137         return _allowances[owner][spender];
1138     }
1139 
1140     function approve(address spender, uint256 amount) public override returns (bool) {
1141         _approve(_msgSender(), spender, amount);
1142         return true;
1143     }
1144 
1145     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1146         _transfer(sender, recipient, amount);
1147         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1148         return true;
1149     }
1150 
1151     function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
1152         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1153         return true;
1154     }
1155 
1156     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
1157         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1158         return true;
1159     }
1160 
1161     function isExcluded(address account) public view returns (bool) {
1162         return _isExcluded[account];
1163     }
1164 
1165     function totalFees() public view returns (uint256) {
1166         return _tFeeTotal;
1167     }
1168 
1169     function refract(uint256 tAmount) public {
1170         address sender = _msgSender();
1171         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1172         (uint256 rAmount,,,,) = _getValues(tAmount, _tFeePercent);
1173         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1174         _rTotal = _rTotal.sub(rAmount);
1175         _tFeeTotal = _tFeeTotal.add(tAmount);
1176     }
1177 
1178     function refractionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1179         require(tAmount <= _totalSupply, "Amount must be less than supply");
1180         if (!deductTransferFee) {
1181             (uint256 rAmount,,,,) = _getValues(tAmount, _tFeePercent);
1182             return rAmount;
1183         } else {
1184             (,uint256 rTransferAmount,,,) = _getValues(tAmount, _tFeePercent);
1185             return rTransferAmount;
1186         }
1187     }
1188 
1189     function tokenFromRefraction(uint256 rAmount) public view returns(uint256) {
1190         require(rAmount <= _rTotal, "Amount must be less than total refractions");
1191         uint256 currentRate =  _getRate();
1192         return rAmount.div(currentRate);
1193     }
1194 
1195     function excludeAccount(address account) public onlyOwner() {
1196         require(!_isExcluded[account], "Account is already excluded");
1197         if(_rOwned[account] > 0) {
1198             _tOwned[account] = tokenFromRefraction(_rOwned[account]);
1199         }
1200         _isExcluded[account] = true;
1201         _excluded.push(account);
1202     }
1203 
1204     function includeAccount(address account) public onlyOwner() {
1205         require(_isExcluded[account], "Account is not excluded");
1206         for (uint256 i = 0; i < _excluded.length; i++) {
1207             if (_excluded[i] == account) {
1208                 _excluded[i] = _excluded[_excluded.length - 1];
1209                 _tOwned[account] = 0;
1210                 _isExcluded[account] = false;
1211                 _excluded.pop();
1212                 break;
1213             }
1214         }
1215     }
1216 
1217     function _approve(address owner, address spender, uint256 amount) internal override {
1218         require(owner != address(0), "ERC20: approve from the zero address");
1219         require(spender != address(0), "ERC20: approve to the zero address");
1220 
1221         _allowances[owner][spender] = amount;
1222         emit Approval(owner, spender, amount);
1223     }
1224 
1225     function _transfer(address sender, address recipient, uint256 amount) internal override {
1226         require(sender != address(0), "ERC20: transfer from the zero address");
1227         require(recipient != address(0), "ERC20: transfer to the zero address");
1228         require(amount > 0, "Transfer amount must be greater than zero");
1229         
1230         
1231         if(_isExcluded[sender] && !_isExcluded[recipient]) {
1232             
1233             if(_limitExpiresTimestamp >= now) {
1234                 require(amount <= _limitTransferAmount, "Initial Uniswap listing - amount exceeds transfer limit");
1235                 require(balanceOf(recipient).add(amount) <= _limitMaxBalance, "Initial Uniswap listing - max balance limit");
1236             }
1237             
1238             _transferFromExcluded(sender, recipient, amount, _tFeePercent);
1239             
1240         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1241             
1242             if(_limitExpiresTimestamp >= now) {
1243                 _transferToExcluded(sender, recipient, amount, _limitSellFeePercent);
1244             } else {
1245                 _transferToExcluded(sender, recipient, amount, _tFeePercent);
1246             }
1247 
1248         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1249             require(_limitExpiresTimestamp < now, "Initial Uniswap listing - Wallet to Wallet transfers temporarily disabled");
1250             _transferStandard(sender, recipient, amount, _tFeePercent);
1251             
1252         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1253             _transferBothExcluded(sender, recipient, amount, 0);
1254             
1255         } else {
1256             require(_limitExpiresTimestamp < now, "Initial Uniswap listing - Wallet to Wallet transfers temporarily disabled");
1257             _transferStandard(sender, recipient, amount, _tFeePercent);
1258             
1259         }
1260     }
1261     
1262 
1263     function _transferStandard(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1264         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1265         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1266         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
1267         _refractFee(rFee, tFee);
1268         emit Transfer(sender, recipient, tTransferAmount);
1269     }
1270 
1271     function _transferToExcluded(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1272         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1273         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1274         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1275         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1276         _refractFee(rFee, tFee);
1277         emit Transfer(sender, recipient, tTransferAmount);
1278     }
1279 
1280     function _transferFromExcluded(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1281         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1282         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1283         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1284         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1285         _refractFee(rFee, tFee);
1286         emit Transfer(sender, recipient, tTransferAmount);
1287     }
1288 
1289     function _transferBothExcluded(address sender, address recipient, uint256 tAmount, uint256 tFeePercent) private {
1290         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, tFeePercent);
1291         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1292         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1293         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1294         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1295         _refractFee(rFee, tFee);
1296         emit Transfer(sender, recipient, tTransferAmount);
1297     }
1298 
1299     function _refractFee(uint256 rFee, uint256 tFee) private {
1300         _rTotal = _rTotal.sub(rFee);
1301         _tFeeTotal = _tFeeTotal.add(tFee);
1302     }
1303 
1304     function _getValues(uint256 tAmount, uint256 tFeePercent) private view returns (uint256, uint256, uint256, uint256, uint256) {
1305         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, tFeePercent);
1306         uint256 currentRate =  _getRate();
1307         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1308         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1309     }
1310 
1311     function _getTValues(uint256 tAmount, uint256 tFeePercent) private pure returns (uint256, uint256) {
1312         uint256 tFee = tAmount.mul(tFeePercent).div(10000);
1313         uint256 tTransferAmount = tAmount.sub(tFee);
1314         return (tTransferAmount, tFee);
1315     }
1316 
1317     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1318         uint256 rAmount = tAmount.mul(currentRate);
1319         uint256 rFee = tFee.mul(currentRate);
1320         uint256 rTransferAmount = rAmount.sub(rFee);
1321         return (rAmount, rTransferAmount, rFee);
1322     }
1323 
1324     function _getRate() private view returns(uint256) {
1325         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1326         return rSupply.div(tSupply);
1327     }
1328 
1329     function _getCurrentSupply() private view returns(uint256, uint256) {
1330         uint256 rSupply = _rTotal;
1331         uint256 tSupply = _totalSupply;      
1332         for (uint256 i = 0; i < _excluded.length; i++) {
1333             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _totalSupply);
1334             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1335             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1336         }
1337         if (rSupply < _rTotal.div(_totalSupply)) return (_rTotal, _totalSupply);
1338         return (rSupply, tSupply);
1339     }
1340 }