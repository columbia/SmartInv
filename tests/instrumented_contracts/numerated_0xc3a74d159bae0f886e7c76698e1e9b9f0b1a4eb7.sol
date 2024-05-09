1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/GSN/Context.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
223 
224 pragma solidity ^0.5.0;
225 
226 /**
227  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
228  * the optional functions; to access them see {ERC20Detailed}.
229  */
230 interface IERC20 {
231     /**
232      * @dev Returns the amount of tokens in existence.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns the amount of tokens owned by `account`.
238      */
239     function balanceOf(address account) external view returns (uint256);
240 
241     /**
242      * @dev Moves `amount` tokens from the caller's account to `recipient`.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transfer(address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Returns the remaining number of tokens that `spender` will be
252      * allowed to spend on behalf of `owner` through {transferFrom}. This is
253      * zero by default.
254      *
255      * This value changes when {approve} or {transferFrom} are called.
256      */
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `sender` to `recipient` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Emitted when `value` tokens are moved from one account (`from`) to
288      * another (`to`).
289      *
290      * Note that `value` may be zero.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /**
295      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
296      * a call to {approve}. `value` is the new allowance.
297      */
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
302 
303 pragma solidity ^0.5.0;
304 
305 
306 
307 
308 /**
309  * @dev Implementation of the {IERC20} interface.
310  *
311  * This implementation is agnostic to the way tokens are created. This means
312  * that a supply mechanism has to be added in a derived contract using {_mint}.
313  * For a generic mechanism see {ERC20Mintable}.
314  *
315  * TIP: For a detailed writeup see our guide
316  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
317  * to implement supply mechanisms].
318  *
319  * We have followed general OpenZeppelin guidelines: functions revert instead
320  * of returning `false` on failure. This behavior is nonetheless conventional
321  * and does not conflict with the expectations of ERC20 applications.
322  *
323  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
324  * This allows applications to reconstruct the allowance for all accounts just
325  * by listening to said events. Other implementations of the EIP may not emit
326  * these events, as it isn't required by the specification.
327  *
328  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
329  * functions have been added to mitigate the well-known issues around setting
330  * allowances. See {IERC20-approve}.
331  */
332 contract ERC20 is Context, IERC20 {
333     using SafeMath for uint256;
334 
335     mapping (address => uint256) private _balances;
336 
337     mapping (address => mapping (address => uint256)) private _allowances;
338 
339     uint256 private _totalSupply;
340 
341     /**
342      * @dev See {IERC20-totalSupply}.
343      */
344     function totalSupply() public view returns (uint256) {
345         return _totalSupply;
346     }
347 
348     /**
349      * @dev See {IERC20-balanceOf}.
350      */
351     function balanceOf(address account) public view returns (uint256) {
352         return _balances[account];
353     }
354 
355     /**
356      * @dev See {IERC20-transfer}.
357      *
358      * Requirements:
359      *
360      * - `recipient` cannot be the zero address.
361      * - the caller must have a balance of at least `amount`.
362      */
363     function transfer(address recipient, uint256 amount) public returns (bool) {
364         _transfer(_msgSender(), recipient, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-allowance}.
370      */
371     function allowance(address owner, address spender) public view returns (uint256) {
372         return _allowances[owner][spender];
373     }
374 
375     /**
376      * @dev See {IERC20-approve}.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      */
382     function approve(address spender, uint256 amount) public returns (bool) {
383         _approve(_msgSender(), spender, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-transferFrom}.
389      *
390      * Emits an {Approval} event indicating the updated allowance. This is not
391      * required by the EIP. See the note at the beginning of {ERC20};
392      *
393      * Requirements:
394      * - `sender` and `recipient` cannot be the zero address.
395      * - `sender` must have a balance of at least `amount`.
396      * - the caller must have allowance for `sender`'s tokens of at least
397      * `amount`.
398      */
399     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
400         _transfer(sender, recipient, amount);
401         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
402         return true;
403     }
404 
405     /**
406      * @dev Atomically increases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
419         return true;
420     }
421 
422     /**
423      * @dev Atomically decreases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      * - `spender` must have allowance for the caller of at least
434      * `subtractedValue`.
435      */
436     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
438         return true;
439     }
440 
441     /**
442      * @dev Moves tokens `amount` from `sender` to `recipient`.
443      *
444      * This is internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `sender` cannot be the zero address.
452      * - `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      */
455     function _transfer(address sender, address recipient, uint256 amount) internal {
456         require(sender != address(0), "ERC20: transfer from the zero address");
457         require(recipient != address(0), "ERC20: transfer to the zero address");
458 
459         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
460         _balances[recipient] = _balances[recipient].add(amount);
461         emit Transfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements
470      *
471      * - `to` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _totalSupply = _totalSupply.add(amount);
477         _balances[account] = _balances[account].add(amount);
478         emit Transfer(address(0), account, amount);
479     }
480 
481      /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
496         _totalSupply = _totalSupply.sub(amount);
497         emit Transfer(account, address(0), amount);
498     }
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
502      *
503      * This is internal function is equivalent to `approve`, and can be used to
504      * e.g. set automatic allowances for certain subsystems, etc.
505      *
506      * Emits an {Approval} event.
507      *
508      * Requirements:
509      *
510      * - `owner` cannot be the zero address.
511      * - `spender` cannot be the zero address.
512      */
513     function _approve(address owner, address spender, uint256 amount) internal {
514         require(owner != address(0), "ERC20: approve from the zero address");
515         require(spender != address(0), "ERC20: approve to the zero address");
516 
517         _allowances[owner][spender] = amount;
518         emit Approval(owner, spender, amount);
519     }
520 
521     /**
522      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
523      * from the caller's allowance.
524      *
525      * See {_burn} and {_approve}.
526      */
527     function _burnFrom(address account, uint256 amount) internal {
528         _burn(account, amount);
529         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
530     }
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
534 
535 pragma solidity ^0.5.0;
536 
537 
538 
539 /**
540  * @dev Extension of {ERC20} that allows token holders to destroy both their own
541  * tokens and those that they have an allowance for, in a way that can be
542  * recognized off-chain (via event analysis).
543  */
544 contract ERC20Burnable is Context, ERC20 {
545     /**
546      * @dev Destroys `amount` tokens from the caller.
547      *
548      * See {ERC20-_burn}.
549      */
550     function burn(uint256 amount) public {
551         _burn(_msgSender(), amount);
552     }
553 
554     /**
555      * @dev See {ERC20-_burnFrom}.
556      */
557     function burnFrom(address account, uint256 amount) public {
558         _burnFrom(account, amount);
559     }
560 }
561 
562 // File: @openzeppelin/contracts/utils/Address.sol
563 
564 pragma solidity ^0.5.5;
565 
566 /**
567  * @dev Collection of functions related to the address type
568  */
569 library Address {
570     /**
571      * @dev Returns true if `account` is a contract.
572      *
573      * This test is non-exhaustive, and there may be false-negatives: during the
574      * execution of a contract's constructor, its address will be reported as
575      * not containing a contract.
576      *
577      * IMPORTANT: It is unsafe to assume that an address for which this
578      * function returns false is an externally-owned account (EOA) and not a
579      * contract.
580      */
581     function isContract(address account) internal view returns (bool) {
582         // This method relies in extcodesize, which returns 0 for contracts in
583         // construction, since the code is only stored at the end of the
584         // constructor execution.
585 
586         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
587         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
588         // for accounts without code, i.e. `keccak256('')`
589         bytes32 codehash;
590         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
591         // solhint-disable-next-line no-inline-assembly
592         assembly { codehash := extcodehash(account) }
593         return (codehash != 0x0 && codehash != accountHash);
594     }
595 
596     /**
597      * @dev Converts an `address` into `address payable`. Note that this is
598      * simply a type cast: the actual underlying value is not changed.
599      *
600      * _Available since v2.4.0._
601      */
602     function toPayable(address account) internal pure returns (address payable) {
603         return address(uint160(account));
604     }
605 
606     /**
607      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
608      * `recipient`, forwarding all available gas and reverting on errors.
609      *
610      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
611      * of certain opcodes, possibly making contracts go over the 2300 gas limit
612      * imposed by `transfer`, making them unable to receive funds via
613      * `transfer`. {sendValue} removes this limitation.
614      *
615      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
616      *
617      * IMPORTANT: because control is transferred to `recipient`, care must be
618      * taken to not create reentrancy vulnerabilities. Consider using
619      * {ReentrancyGuard} or the
620      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
621      *
622      * _Available since v2.4.0._
623      */
624     function sendValue(address payable recipient, uint256 amount) internal {
625         require(address(this).balance >= amount, "Address: insufficient balance");
626 
627         // solhint-disable-next-line avoid-call-value
628         (bool success, ) = recipient.call.value(amount)("");
629         require(success, "Address: unable to send value, recipient may have reverted");
630     }
631 }
632 
633 // File: @openzeppelin/contracts/ownership/Ownable.sol
634 
635 pragma solidity ^0.5.0;
636 
637 /**
638  * @dev Contract module which provides a basic access control mechanism, where
639  * there is an account (an owner) that can be granted exclusive access to
640  * specific functions.
641  *
642  * This module is used through inheritance. It will make available the modifier
643  * `onlyOwner`, which can be applied to your functions to restrict their use to
644  * the owner.
645  */
646 contract Ownable is Context {
647     address private _owner;
648 
649     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
650 
651     /**
652      * @dev Initializes the contract setting the deployer as the initial owner.
653      */
654     constructor () internal {
655         _owner = _msgSender();
656         emit OwnershipTransferred(address(0), _owner);
657     }
658 
659     /**
660      * @dev Returns the address of the current owner.
661      */
662     function owner() public view returns (address) {
663         return _owner;
664     }
665 
666     /**
667      * @dev Throws if called by any account other than the owner.
668      */
669     modifier onlyOwner() {
670         require(isOwner(), "Ownable: caller is not the owner");
671         _;
672     }
673 
674     /**
675      * @dev Returns true if the caller is the current owner.
676      */
677     function isOwner() public view returns (bool) {
678         return _msgSender() == _owner;
679     }
680 
681     /**
682      * @dev Leaves the contract without owner. It will not be possible to call
683      * `onlyOwner` functions anymore. Can only be called by the current owner.
684      *
685      * NOTE: Renouncing ownership will leave the contract without an owner,
686      * thereby removing any functionality that is only available to the owner.
687      */
688     function renounceOwnership() public onlyOwner {
689         emit OwnershipTransferred(_owner, address(0));
690         _owner = address(0);
691     }
692 
693     /**
694      * @dev Transfers ownership of the contract to a new account (`newOwner`).
695      * Can only be called by the current owner.
696      */
697     function transferOwnership(address newOwner) public onlyOwner {
698         _transferOwnership(newOwner);
699     }
700 
701     /**
702      * @dev Transfers ownership of the contract to a new account (`newOwner`).
703      */
704     function _transferOwnership(address newOwner) internal {
705         require(newOwner != address(0), "Ownable: new owner is the zero address");
706         emit OwnershipTransferred(_owner, newOwner);
707         _owner = newOwner;
708     }
709 }
710 
711 // File: contracts/GenesisSC.sol
712 
713 pragma solidity ^0.5.15;
714 
715 
716 
717 
718 
719 
720 contract GenesisSC is Ownable {
721 
722     using SafeMath for uint256;
723     using Math for uint256;
724     using Address for address;
725 
726     enum States{Initializing, Staking, Validating, Finalized, Retired}
727 
728     // EVENTS
729     event StakeDeposited(address indexed account, uint256 amount);
730     event StakeWithdrawn(address indexed account, uint256 amount);
731     event StateChanged(States fromState, States toState);
732 
733     // STRUCT DECLARATIONS
734     struct StakingNode {
735         bytes32 blsKeyHash;
736         bytes32 elrondAddressHash;
737         bool approved;
738         bool exists;
739     }
740 
741     struct WhitelistedAccount {
742         uint256 numberOfNodes;
743         uint256 amountStaked;
744         StakingNode[] stakingNodes;
745         bool exists;
746         mapping(bytes32 => uint256) blsKeyHashToStakingNodeIndex;
747     }
748 
749     struct DelegationDeposit {
750         uint256 amount;
751         bytes32 elrondAddressHash;
752         bool exists;
753     }
754 
755     // CONTRACT STATE VARIABLES
756     uint256 public nodePrice;
757     uint256 public delegationNodesLimit;
758     uint256 public delegationAmountLimit;
759     uint256 public currentTotalDelegated;
760     address[] private _whitelistedAccountAddresses;
761 
762     ERC20Burnable public token;
763     States public contractState = States.Initializing;
764 
765     mapping(address => WhitelistedAccount) private _whitelistedAccounts;
766     mapping(address => DelegationDeposit) private _delegationDeposits;
767     mapping (bytes32 => bool) private _approvedBlsKeyHashes;
768 
769     // MODIFIERS
770     modifier onlyContract(address account)
771     {
772         require(account.isContract(), "[Validation] The address does not contain a contract");
773         _;
774     }
775 
776     modifier guardMaxDelegationLimit(uint256 amount)
777     {
778         require(amount <= (delegationAmountLimit - currentTotalDelegated), "[DepositDelegateStake] Your deposit would exceed the delegation limit");
779         _;
780     }
781 
782     modifier onlyWhitelistedAccounts(address who)
783     {
784         WhitelistedAccount memory account = _whitelistedAccounts[who];
785         require(account.exists, "[Validation] The provided address is not whitelisted");
786         _;
787     }
788 
789     modifier onlyAccountsWithNodes()
790     {
791         require(_whitelistedAccounts[msg.sender].stakingNodes.length > 0, "[Validation] Your account has 0 nodes submitted");
792         _;
793     }
794 
795     modifier onlyNotWhitelistedAccounts(address who)
796     {
797         WhitelistedAccount memory account = _whitelistedAccounts[who];
798         require(!account.exists, "[Validation] Address is already whitelisted");
799         _;
800     }
801 
802     // STATE GUARD MODIFIERS
803     modifier whenStaking()
804     {
805         require(contractState == States.Staking, "[Validation] This function can be called only when contract is in staking phase");
806         _;
807     }
808 
809     modifier whenInitializedAndNotValidating()
810     {
811         require(contractState != States.Initializing, "[Validation] This function cannot be called in the initialization phase");
812         require(contractState != States.Validating, "[Validation] This function cannot be called while your submitted nodes are in the validation process");
813         _;
814     }
815 
816     modifier whenFinalized()
817     {
818         require(contractState == States.Finalized, "[Validation] This function can be called only when the contract is finalized");
819         _;
820     }
821 
822     modifier whenNotFinalized()
823     {
824         require(contractState != States.Finalized, "[Validation] This function cannot be called when the contract is finalized");
825         _;
826     }
827 
828     modifier whenNotRetired()
829     {
830         require(contractState != States.Retired, "[Validation] This function cannot be called when the contract is retired");
831         _;
832     }
833 
834     modifier whenRetired()
835     {
836         require(contractState == States.Retired, "[Validation] This function can be called only when the contract is retired");
837         _;
838     }
839 
840     // PUBLIC FUNCTIONS
841     constructor(ERC20Burnable _token, uint256 _nodePrice, uint256 _delegationNodesLimit)
842     public
843     {
844         require(_nodePrice > 0, "[Validation] Node price must be greater than 0");
845 
846         token = _token;
847         nodePrice = _nodePrice;
848         delegationNodesLimit = _delegationNodesLimit;
849         delegationAmountLimit = _delegationNodesLimit.mul(_nodePrice);
850     }
851 
852     /**
853     * submitStake can be called in the staking phase by any account that has been previously whitelisted by the Elrond
854     *  team. An account can submit hashes of BLS keys to this contract (in a number that adds up to less or equal than
855     *  what has been set up for that account) and an associated reward address hash for them. The total amount of ERD
856     *  tokens that will be transferred from that account will be fixed to nrOfSubmittedNodes*nodePrice
857     *
858     * @param blsKeyHashes A list where each element represents the hash of an Elrond's native node public key
859     * @param elrondAddressHash Represents the hash of an Elrond's native wallet address
860     */
861     function submitStake(bytes32[] calldata blsKeyHashes, bytes32 elrondAddressHash)
862     external
863     whenStaking
864     onlyWhitelistedAccounts(msg.sender)
865     {
866         require(elrondAddressHash != 0, "[Validation] Elrond address hash should not be 0");
867 
868         WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[msg.sender];
869         _validateStakeParameters(whitelistedAccount, blsKeyHashes);
870         _addStakingNodes(whitelistedAccount, blsKeyHashes, elrondAddressHash);
871 
872         uint256 transferAmount = nodePrice.mul(blsKeyHashes.length);
873         require(token.transferFrom(msg.sender, address(this), transferAmount));
874 
875         whitelistedAccount.amountStaked = whitelistedAccount.amountStaked.add(transferAmount);
876 
877         emit StakeDeposited(msg.sender, transferAmount);
878     }
879 
880     /**
881     * withdraw can be called by any account that has been whitelisted and has submitted BLS key hashes for their nodes
882     *  and implicitly ERD tokens as staking value for them. This function will withdraw all associated tokens for
883     *  nodes that have not been validated off-chain and approved by the Elrond team. If an account wants to give up
884     *  and withdraw tokens for an already approved node (if the phase the contract is in still permits it), he/she
885     *  can use withdrawPerNodes function
886     */
887     function withdraw()
888     external
889     whenInitializedAndNotValidating
890     onlyWhitelistedAccounts(msg.sender)
891     onlyAccountsWithNodes
892     {
893         uint256 totalSumToWithdraw;
894         WhitelistedAccount storage account = _whitelistedAccounts[msg.sender];
895 
896         uint256 length = account.stakingNodes.length - 1;
897         for (uint256 i = length; i <= length; i--) {
898             StakingNode storage stakingNode = account.stakingNodes[i];
899             if ((!stakingNode.exists) || (stakingNode.approved)) {
900                 continue;
901             }
902 
903             totalSumToWithdraw = totalSumToWithdraw.add(nodePrice);
904 
905             _removeStakingNode(account, stakingNode.blsKeyHash);
906         }
907 
908         if (totalSumToWithdraw == 0) {
909             emit StakeWithdrawn(msg.sender, 0);
910             return;
911         }
912 
913         account.amountStaked = account.amountStaked.sub(totalSumToWithdraw);
914 
915         require(token.transfer(msg.sender, totalSumToWithdraw));
916 
917         emit StakeWithdrawn(msg.sender, totalSumToWithdraw);
918     }
919 
920     /**
921     * withdrawPerNodes gives the user the possibility to withdraw funds associated with the provided BLS key hashes.
922     *  This function allows withdrawal also for nodes that were approved by the Elrond team, with the mention that
923     *  it should happen before the contract gets in the finalized or retired state (meaning the genesis of the Elrond blockchain
924     *  is established and those tokens will be minted on the main chain)
925     *
926     * @param blsKeyHashes A list where each element represents the hash of an Elrond's native node public key
927     */
928     function withdrawPerNodes(bytes32[] calldata blsKeyHashes)
929     external
930     whenInitializedAndNotValidating
931     onlyWhitelistedAccounts(msg.sender)
932     onlyAccountsWithNodes
933     {
934         require(blsKeyHashes.length > 0, "[Validation] You must provide at least one BLS key");
935 
936         WhitelistedAccount storage account = _whitelistedAccounts[msg.sender];
937         for (uint256 i; i < blsKeyHashes.length; i++) {
938             _validateBlsKeyHashForWithdrawal(account, blsKeyHashes[i]);
939             _removeStakingNode(account, blsKeyHashes[i]);
940         }
941 
942         uint256 totalSumToWithdraw = nodePrice.mul(blsKeyHashes.length);
943         account.amountStaked = account.amountStaked.sub(totalSumToWithdraw);
944 
945         require(token.transfer(msg.sender, totalSumToWithdraw));
946 
947         emit StakeWithdrawn(msg.sender, totalSumToWithdraw);
948     }
949 
950     /**
951     * depositDelegateStake provides users that were not whitelisted to run nodes at the start of the
952     *  Elrond blockchain with the possibility to take part anyway in the genesis of the network
953     *  by delegating stake to nodes that will be ran by Elrond. The rewards will be received
954     *  by the user according to the Elrond's delegation smart contract in the provided wallet address
955     *
956     * @param elrondAddressHash The Elrond native address hash where the user wants to receive the rewards
957     * @param amount The ERD amount to be staked
958     */
959     function depositDelegateStake(uint256 amount, bytes32 elrondAddressHash)
960     external
961     whenStaking
962     guardMaxDelegationLimit(amount)
963     {
964         require(amount > 0, "[Validation] The stake amount has to be larger than 0");
965         require(!_delegationDeposits[msg.sender].exists, "[Validation] You already delegated a stake");
966 
967         _delegationDeposits[msg.sender] = DelegationDeposit(amount, elrondAddressHash, true);
968 
969         currentTotalDelegated = currentTotalDelegated.add(amount);
970 
971         require(token.transferFrom(msg.sender, address(this), amount));
972 
973         emit StakeDeposited(msg.sender, amount);
974     }
975 
976     /**
977     * increaseDelegatedAmount lets a user that has already delegated a number of tokens to increase that amount
978     *
979     * @param amount The ERD amount to be added to the existing stake
980     */
981     function increaseDelegatedAmount(uint256 amount)
982     external
983     whenStaking
984     guardMaxDelegationLimit(amount)
985     {
986         require(amount > 0, "[Validation] The amount has to be larger than 0");
987 
988         DelegationDeposit storage deposit = _delegationDeposits[msg.sender];
989         require(deposit.exists, "[Validation] You don't have a delegated stake");
990 
991         deposit.amount = deposit.amount.add(amount);
992         currentTotalDelegated = currentTotalDelegated.add(amount);
993 
994         require(token.transferFrom(msg.sender, address(this), amount));
995 
996         emit StakeDeposited(msg.sender, amount);
997     }
998 
999     /**
1000     * withdrawDelegatedStake lets a user that has already delegated a number of tokens to decrease that amount
1001     *
1002     * @param amount The ERD amount to be removed to the existing stake
1003     */
1004     function withdrawDelegatedStake(uint256 amount)
1005     external
1006     whenStaking
1007     {
1008         require(amount > 0, "[Validation] The withdraw amount has to be larger than 0");
1009 
1010         DelegationDeposit storage deposit = _delegationDeposits[msg.sender];
1011         require(deposit.exists, "[Validation] You don't have a delegated stake");
1012         require(amount <= deposit.amount, "[Validation] Not enough stake deposit to withdraw");
1013 
1014         deposit.amount = deposit.amount.sub(amount);
1015         currentTotalDelegated = currentTotalDelegated.sub(amount);
1016         require(token.transfer(msg.sender, amount));
1017 
1018         emit StakeWithdrawn(msg.sender, amount);
1019     }
1020 
1021     // OWNER ONLY FUNCTIONS
1022 
1023     /**
1024     * changeStateToStaking allows the owner to change the state of the contract into the staking phase
1025     */
1026     function changeStateToStaking()
1027     external
1028     onlyOwner
1029     whenNotRetired
1030     {
1031         emit StateChanged(contractState, States.Staking);
1032         contractState = States.Staking;
1033     }
1034 
1035     /**
1036     * changeStateToValidating allows the owner to change the state of the contract into the validating phase. With the
1037     *  mention that we can go into validating phase only from the staking phase.
1038     */
1039     function changeStateToValidating()
1040     external
1041     onlyOwner
1042     whenStaking
1043     {
1044         emit StateChanged(contractState, States.Validating);
1045         contractState = States.Validating;
1046     }
1047 
1048     /**
1049     * changeStateToFinalized allows the owner to change the state of the contract into the finalized phase
1050     */
1051     function changeStateToFinalized()
1052     external
1053     onlyOwner
1054     whenNotRetired
1055     {
1056         emit StateChanged(contractState, States.Finalized);
1057         contractState = States.Finalized;
1058     }
1059 
1060     /**
1061    * changeStateToRetired allows the owner to change the state of the contract into the retired phase.
1062    *  this can only happen if the contract is finalized - in order to prevent retiring it by mistake,
1063    *  since there is no turning back from this state
1064    */
1065     function changeStateToRetired()
1066     external
1067     onlyOwner
1068     whenFinalized
1069     {
1070         emit StateChanged(contractState, States.Retired);
1071         contractState = States.Retired;
1072     }
1073 
1074     /**
1075     * whitelistAccount allows the owner to whitelist an ethereum address to stake ERD and add nodes to run
1076     *  on the Elrond blockchain
1077     */
1078     function whitelistAccount(address who, uint256 numberOfNodes)
1079     external
1080     onlyOwner
1081     whenNotFinalized
1082     whenNotRetired
1083     onlyNotWhitelistedAccounts(who)
1084     {
1085         WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];
1086         whitelistedAccount.numberOfNodes = numberOfNodes;
1087         whitelistedAccount.exists = true;
1088 
1089         _whitelistedAccountAddresses.push(who);
1090     }
1091 
1092     /**
1093     * approveBlsKeyHashes gives the owner the possibility to mark some BLS key hashes submitted by an account
1094     *  as approved after an off-chain validation
1095     */
1096     function approveBlsKeyHashes(address who, bytes32[] calldata blsHashes)
1097     external
1098     onlyOwner
1099     whenNotFinalized
1100     whenNotRetired
1101     onlyWhitelistedAccounts(who)
1102     {
1103         WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];
1104 
1105         for (uint256 i = 0; i < blsHashes.length; i++) {
1106             require(_accountHasNode(whitelistedAccount, blsHashes[i]), "[Validation] BLS key does not exist for this account");
1107             require(!_approvedBlsKeyHashes[blsHashes[i]], "[Validation] Provided BLS key was already approved");
1108 
1109             uint256 accountIndex = whitelistedAccount.blsKeyHashToStakingNodeIndex[blsHashes[i]];
1110             StakingNode storage stakingNode = whitelistedAccount.stakingNodes[accountIndex];
1111             require(stakingNode.exists, '[Validation] Bls key does not exist for this account');
1112             stakingNode.approved = true;
1113             _approvedBlsKeyHashes[blsHashes[i]] = true;
1114         }
1115     }
1116 
1117     /**
1118     * unapproveBlsKeyHashes the same as approveBlsKeyHashes, but changing the approved flag to false for selected keys
1119     */
1120     function unapproveBlsKeyHashes(address who, bytes32[] calldata blsHashes)
1121     external
1122     onlyOwner
1123     whenNotFinalized
1124     whenNotRetired
1125     onlyWhitelistedAccounts(who)
1126     {
1127         WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];
1128 
1129         for (uint256 i = 0; i < blsHashes.length; i++) {
1130             require(_accountHasNode(whitelistedAccount, blsHashes[i]), "[Validation] BLS key does not exist for this account");
1131             require(_approvedBlsKeyHashes[blsHashes[i]], "[Validation] Provided BLS key was not previously approved");
1132 
1133             uint256 accountIndex = whitelistedAccount.blsKeyHashToStakingNodeIndex[blsHashes[i]];
1134             StakingNode storage stakingNode = whitelistedAccount.stakingNodes[accountIndex];
1135             require(stakingNode.exists, '[Validation] Bls key does not exist for this account');
1136             stakingNode.approved = false;
1137             _approvedBlsKeyHashes[blsHashes[i]] = false;
1138         }
1139     }
1140 
1141     /**
1142     * editWhitelistedAccountNumberOfNodes gives the owner the possibility to change the number of nodes a user can
1143     *  stake for. The number cannot be set lower than the number of nodes the user already submitted
1144     */
1145     function editWhitelistedAccountNumberOfNodes(address who, uint256 numberOfNodes)
1146     external
1147     onlyOwner
1148     whenNotFinalized
1149     whenNotRetired
1150     onlyWhitelistedAccounts(who)
1151     {
1152         WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[who];
1153         require(numberOfNodes >= whitelistedAccount.stakingNodes.length, "[Validation] Whitelisted account already submitted more nodes than you wish to allow");
1154 
1155         whitelistedAccount.numberOfNodes = numberOfNodes;
1156     }
1157 
1158     /**
1159     * burnCommittedFunds can be called by the owner after this contract is retired. This function burns the amount
1160     *  of tokens associated with approved nodes and delegated stake. The equivalent will be minted on the
1161     *  Elrond blockchain
1162     */
1163     function burnCommittedFunds()
1164     external
1165     onlyOwner
1166     whenRetired
1167     {
1168         uint256 totalToBurn = currentTotalDelegated;
1169         for(uint256 i; i < _whitelistedAccountAddresses.length; i++) {
1170             WhitelistedAccount memory account = _whitelistedAccounts[_whitelistedAccountAddresses[i]];
1171             if (!account.exists) {
1172                 continue;
1173             }
1174 
1175             uint256 approvedNodes = _approvedNodesCount(account);
1176             totalToBurn = totalToBurn.add(nodePrice.mul(approvedNodes));
1177         }
1178 
1179         token.burn(totalToBurn);
1180     }
1181 
1182     /**
1183     * recoverLostFunds helps us recover funds for users that accidentally send tokens directly to this contract
1184     */
1185     function recoverLostFunds(address who, uint256 amount)
1186     external
1187     onlyOwner
1188     {
1189         uint256 currentBalance = token.balanceOf(address(this));
1190         require(amount <= currentBalance, "[Validation] Recover amount exceeds contract balance");
1191 
1192         uint256 correctDepositAmount = _correctDepositAmount();
1193         uint256 lostFundsAmount = currentBalance.sub(correctDepositAmount);
1194         require(amount <= lostFundsAmount, "[Validation] Recover amount exceeds lost funds amount");
1195 
1196         token.transfer(who, amount);
1197     }
1198 
1199     // VIEW FUNCTIONS
1200     function whitelistedAccountAddresses()
1201     external
1202     view
1203     returns (address[] memory, uint256[] memory)
1204     {
1205         address[] memory whitelistedAddresses = new address[](_whitelistedAccountAddresses.length);
1206         uint256[] memory whitelistedAddressesNodes = new uint256[](_whitelistedAccountAddresses.length);
1207 
1208         for (uint256 i = 0; i < _whitelistedAccountAddresses.length; i++) {
1209             whitelistedAddresses[i] = _whitelistedAccountAddresses[i];
1210             WhitelistedAccount storage whitelistedAccount = _whitelistedAccounts[_whitelistedAccountAddresses[i]];
1211             whitelistedAddressesNodes[i] = whitelistedAccount.numberOfNodes;
1212 
1213         }
1214 
1215         return (whitelistedAddresses, whitelistedAddressesNodes);
1216     }
1217 
1218     function whitelistedAccount(address who)
1219     external
1220     view
1221     returns (uint256 maxNumberOfNodes, uint256 amountStaked)
1222     {
1223         require(_whitelistedAccounts[who].exists, "[WhitelistedAddress] Address is not whitelisted");
1224 
1225         return (_whitelistedAccounts[who].numberOfNodes, _whitelistedAccounts[who].amountStaked);
1226     }
1227 
1228     function stakingNodesHashes(address who)
1229     external
1230     view
1231     returns (bytes32[] memory, bool[] memory, bytes32[] memory)
1232     {
1233         require(_whitelistedAccounts[who].exists, "[StakingNodesHashes] Address is not whitelisted");
1234 
1235         StakingNode[] memory stakingNodes = _whitelistedAccounts[who].stakingNodes;
1236         bytes32[] memory blsKeyHashes = new bytes32[](stakingNodes.length);
1237         bool[] memory blsKeyHashesStatus = new bool[](stakingNodes.length);
1238         bytes32[] memory rewardAddresses = new bytes32[](stakingNodes.length);
1239 
1240         for (uint256 i = 0; i < stakingNodes.length; i++) {
1241             blsKeyHashes[i] = stakingNodes[i].blsKeyHash;
1242             blsKeyHashesStatus[i] = stakingNodes[i].approved;
1243             rewardAddresses[i] = stakingNodes[i].elrondAddressHash;
1244         }
1245 
1246         return (blsKeyHashes, blsKeyHashesStatus, rewardAddresses);
1247     }
1248 
1249     function stakingNodeInfo(address who, bytes32 blsKeyHash)
1250     external
1251     view
1252     returns(bytes32, bool)
1253     {
1254         require(_whitelistedAccounts[who].exists, "[StakingNodeInfo] Address is not whitelisted");
1255         require(_accountHasNode(_whitelistedAccounts[who], blsKeyHash), "[StakingNodeInfo] Address does not have the provided node");
1256 
1257         WhitelistedAccount storage account = _whitelistedAccounts[who];
1258         uint256 nodeIndex = account.blsKeyHashToStakingNodeIndex[blsKeyHash];
1259         return (account.stakingNodes[nodeIndex].elrondAddressHash, account.stakingNodes[nodeIndex].approved);
1260     }
1261 
1262     function delegationDeposit(address who)
1263     external
1264     view
1265     returns (uint256, bytes32)
1266     {
1267         return (_delegationDeposits[who].amount, _delegationDeposits[who].elrondAddressHash);
1268     }
1269 
1270     function lostFundsAmount()
1271     external
1272     view
1273     returns (uint256)
1274     {
1275         uint256 currentBalance = token.balanceOf(address(this));
1276         uint256 correctDepositAmount = _correctDepositAmount();
1277 
1278         return currentBalance.sub(correctDepositAmount);
1279     }
1280 
1281     // PRIVATE FUNCTIONS
1282     function _addStakingNodes(WhitelistedAccount storage account, bytes32[] memory blsKeyHashes, bytes32 elrondAddressHash)
1283     internal
1284     {
1285         for (uint256 i = 0; i < blsKeyHashes.length; i++) {
1286             _insertStakingNode(account, blsKeyHashes[i], elrondAddressHash);
1287         }
1288     }
1289 
1290     function _validateStakeParameters(WhitelistedAccount memory account, bytes32[] memory blsKeyHashes)
1291     internal
1292     pure
1293     {
1294         require(
1295             account.numberOfNodes >= account.stakingNodes.length + blsKeyHashes.length,
1296             "[Validation] Adding this many nodes would exceed the maximum number of allowed nodes per this account"
1297         );
1298     }
1299 
1300     function _correctDepositAmount()
1301     internal
1302     view
1303     returns (uint256)
1304     {
1305         uint256 correctDepositAmount = currentTotalDelegated;
1306         for(uint256 i; i < _whitelistedAccountAddresses.length; i++) {
1307             WhitelistedAccount memory account = _whitelistedAccounts[_whitelistedAccountAddresses[i]];
1308             if (!account.exists) {
1309                 continue;
1310             }
1311 
1312             correctDepositAmount = correctDepositAmount.add(nodePrice.mul(account.stakingNodes.length));
1313         }
1314 
1315         return correctDepositAmount;
1316     }
1317 
1318     // StakingNode list manipulation
1319     function _accountHasNode(WhitelistedAccount storage account, bytes32 blsKeyHash)
1320     internal
1321     view
1322     returns (bool)
1323     {
1324         if (account.stakingNodes.length == 0) {
1325             return false;
1326         }
1327 
1328         uint256 nodeIndex = account.blsKeyHashToStakingNodeIndex[blsKeyHash];
1329 
1330         return (account.stakingNodes[nodeIndex].blsKeyHash == blsKeyHash) && account.stakingNodes[nodeIndex].exists;
1331     }
1332 
1333     function _approvedNodesCount(WhitelistedAccount memory account)
1334     internal
1335     pure
1336     returns(uint256)
1337     {
1338         uint256 nodesCount = 0;
1339 
1340         for(uint256 i = 0; i < account.stakingNodes.length; i++) {
1341             if (account.stakingNodes[i].exists && account.stakingNodes[i].approved) {
1342                 nodesCount++;
1343             }
1344         }
1345 
1346         return nodesCount;
1347     }
1348 
1349     // Node operations
1350     function _insertStakingNode(WhitelistedAccount storage account, bytes32 blsKeyHash, bytes32 elrondAddressHash)
1351     internal
1352     {
1353         require(blsKeyHash != 0, "[Validation] BLS key hash should not be 0");
1354         require(!_accountHasNode(account, blsKeyHash), "[Validation] BLS key was already added for this account");
1355 
1356         account.blsKeyHashToStakingNodeIndex[blsKeyHash] = account.stakingNodes.length;
1357         StakingNode memory newNode = StakingNode(blsKeyHash, elrondAddressHash, false, true);
1358         account.stakingNodes.push(newNode);
1359     }
1360 
1361     function _removeStakingNode(WhitelistedAccount storage account, bytes32 blsKeyHash)
1362     internal
1363     {
1364         uint256 nodeIndex = account.blsKeyHashToStakingNodeIndex[blsKeyHash];
1365         uint256 lastNodeIndex = account.stakingNodes.length - 1;
1366 
1367         bool stakingNodeIsApproved = account.stakingNodes[nodeIndex].approved;
1368 
1369         // It's not the last StakingNode so we replace this one with the last one
1370         if (nodeIndex != lastNodeIndex) {
1371             bytes32 lastHash = account.stakingNodes[lastNodeIndex].blsKeyHash;
1372             account.blsKeyHashToStakingNodeIndex[lastHash] = nodeIndex;
1373             account.stakingNodes[nodeIndex] = account.stakingNodes[lastNodeIndex];
1374         }
1375 
1376         if (stakingNodeIsApproved) {
1377             delete _approvedBlsKeyHashes[blsKeyHash];
1378         }
1379 
1380         account.stakingNodes.pop();
1381         delete account.blsKeyHashToStakingNodeIndex[blsKeyHash];
1382     }
1383 
1384     function _validateBlsKeyHashForWithdrawal(WhitelistedAccount storage account, bytes32 blsKeyHash)
1385     internal
1386     view
1387     {
1388         require(_accountHasNode(account, blsKeyHash), "[Validation] BLS key does not exist for this account");
1389         if (contractState == States.Finalized || contractState == States.Retired) {
1390             require(
1391                 !account.stakingNodes[account.blsKeyHashToStakingNodeIndex[blsKeyHash]].approved,
1392                 "[Validation] BLS key was already approved, you cannot withdraw the associated amount"
1393             );
1394         }
1395     }
1396 }