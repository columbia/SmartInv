1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * _Available since v2.4.0._
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      *
194      * _Available since v2.4.0._
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         // Solidity only automatically asserts when dividing by 0
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: openzeppelin-solidity/contracts/utils/Address.sol
240 
241 pragma solidity ^0.5.5;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following 
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Converts an `address` into `address payable`. Note that this is
277      * simply a type cast: the actual underlying value is not changed.
278      *
279      * _Available since v2.4.0._
280      */
281     function toPayable(address account) internal pure returns (address payable) {
282         return address(uint160(account));
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      *
301      * _Available since v2.4.0._
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-call-value
307         (bool success, ) = recipient.call.value(amount)("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 }
311 
312 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
313 
314 pragma solidity ^0.5.0;
315 
316 
317 
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure (when the token
322  * contract returns false). Tokens that return no value (and instead revert or
323  * throw on failure) are also supported, non-reverting calls are assumed to be
324  * successful.
325  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
326  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
327  */
328 library SafeERC20 {
329     using SafeMath for uint256;
330     using Address for address;
331 
332     function safeTransfer(IERC20 token, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     function safeApprove(IERC20 token, address spender, uint256 value) internal {
341         // safeApprove should only be called when setting an initial allowance,
342         // or when resetting it to zero. To increase and decrease it, use
343         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
344         // solhint-disable-next-line max-line-length
345         require((value == 0) || (token.allowance(address(this), spender) == 0),
346             "SafeERC20: approve from non-zero to non-zero allowance"
347         );
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
349     }
350 
351     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).add(value);
353         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
357         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
358         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     /**
362      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
363      * on the return value: the return value is optional (but if data is returned, it must not be false).
364      * @param token The token targeted by the call.
365      * @param data The call data (encoded using abi.encode or one of its variants).
366      */
367     function callOptionalReturn(IERC20 token, bytes memory data) private {
368         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
369         // we're implementing it ourselves.
370 
371         // A Solidity high level call has three parts:
372         //  1. The target address is checked to verify it contains contract code
373         //  2. The call itself is made, and success asserted
374         //  3. The return value is decoded, which in turn checks the size of the returned data.
375         // solhint-disable-next-line max-line-length
376         require(address(token).isContract(), "SafeERC20: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = address(token).call(data);
380         require(success, "SafeERC20: low-level call failed");
381 
382         if (returndata.length > 0) { // Return data is optional
383             // solhint-disable-next-line max-line-length
384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
385         }
386     }
387 }
388 
389 // File: contracts/Interfaces/IKyberNetwork.sol
390 
391 pragma solidity >=0.4.21 <0.6.0;
392 
393 interface IKyberNetwork {
394 
395     function getExpectedRate(address src, address dest, uint srcQty) external view
396         returns (uint expectedRate, uint slippageRate);
397 
398     function trade(
399         address src,
400         uint srcAmount,
401         address dest,
402         address destAddress,
403         uint maxDestAmount,
404         uint minConversionRate,
405         address walletId
406     ) external payable returns(uint256);
407 }
408 
409 // File: contracts/Interfaces/IBadStaticCallERC20.sol
410 
411 pragma solidity ^0.5.0;
412 
413 /**
414  * @dev Interface to be safe with not so good proxy contracts.
415  */
416 interface IBadStaticCallERC20 {
417 
418     /**
419      * @dev Returns the amount of tokens owned by `account`.
420      */
421     function balanceOf(address account) external returns (uint256);
422 
423     /**
424      * @dev Returns the remaining number of tokens that `spender` will be
425      * allowed to spend on behalf of `owner` through {transferFrom}. This is
426      * zero by default.
427      *
428      * This value changes when {approve} or {transferFrom} are called.
429      */
430     function allowance(address owner, address spender) external returns (uint256);
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * IMPORTANT: Beware that changing an allowance with this method brings the risk
438      * that someone may use both the old and the new allowance by unfortunate
439      * transaction ordering. One possible solution to mitigate this race
440      * condition is to first reduce the spender's allowance to 0 and set the
441      * desired value afterwards:
442      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
443      *
444      * Emits an {Approval} event.
445      */
446     function approve(address spender, uint256 amount) external returns (bool);
447 }
448 
449 // File: openzeppelin-solidity/contracts/GSN/Context.sol
450 
451 pragma solidity ^0.5.0;
452 
453 /*
454  * @dev Provides information about the current execution context, including the
455  * sender of the transaction and its data. While these are generally available
456  * via msg.sender and msg.data, they should not be accessed in such a direct
457  * manner, since when dealing with GSN meta-transactions the account sending and
458  * paying for execution may not be the actual sender (as far as an application
459  * is concerned).
460  *
461  * This contract is only required for intermediate, library-like contracts.
462  */
463 contract Context {
464     // Empty internal constructor, to prevent people from mistakenly deploying
465     // an instance of this contract, which should be used via inheritance.
466     constructor () internal { }
467     // solhint-disable-previous-line no-empty-blocks
468 
469     function _msgSender() internal view returns (address payable) {
470         return msg.sender;
471     }
472 
473     function _msgData() internal view returns (bytes memory) {
474         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
475         return msg.data;
476     }
477 }
478 
479 // File: openzeppelin-solidity/contracts/Ownership/Ownable.sol
480 
481 pragma solidity ^0.5.0;
482 
483 /**
484  * @dev Contract module which provides a basic access control mechanism, where
485  * there is an account (an owner) that can be granted exclusive access to
486  * specific functions.
487  *
488  * This module is used through inheritance. It will make available the modifier
489  * `onlyOwner`, which can be applied to your functions to restrict their use to
490  * the owner.
491  */
492 contract Ownable is Context {
493     address private _owner;
494 
495     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
496 
497     /**
498      * @dev Initializes the contract setting the deployer as the initial owner.
499      */
500     constructor () internal {
501         address msgSender = _msgSender();
502         _owner = msgSender;
503         emit OwnershipTransferred(address(0), msgSender);
504     }
505 
506     /**
507      * @dev Returns the address of the current owner.
508      */
509     function owner() public view returns (address) {
510         return _owner;
511     }
512 
513     /**
514      * @dev Throws if called by any account other than the owner.
515      */
516     modifier onlyOwner() {
517         require(isOwner(), "Ownable: caller is not the owner");
518         _;
519     }
520 
521     /**
522      * @dev Returns true if the caller is the current owner.
523      */
524     function isOwner() public view returns (bool) {
525         return _msgSender() == _owner;
526     }
527 
528     /**
529      * @dev Leaves the contract without owner. It will not be possible to call
530      * `onlyOwner` functions anymore. Can only be called by the current owner.
531      *
532      * NOTE: Renouncing ownership will leave the contract without an owner,
533      * thereby removing any functionality that is only available to the owner.
534      */
535     function renounceOwnership() public onlyOwner {
536         emit OwnershipTransferred(_owner, address(0));
537         _owner = address(0);
538     }
539 
540     /**
541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
542      * Can only be called by the current owner.
543      */
544     function transferOwnership(address newOwner) public onlyOwner {
545         _transferOwnership(newOwner);
546     }
547 
548     /**
549      * @dev Transfers ownership of the contract to a new account (`newOwner`).
550      */
551     function _transferOwnership(address newOwner) internal {
552         require(newOwner != address(0), "Ownable: new owner is the zero address");
553         emit OwnershipTransferred(_owner, newOwner);
554         _owner = newOwner;
555     }
556 }
557 
558 // File: contracts/Utils/AddressTranslation.sol
559 
560 pragma solidity ^0.5.0;
561 
562 
563 contract AddressTranslation is Ownable {
564   mapping(address => address) public addressTranslationMap;
565 
566   function setAddressTranslation(address from, address to) external onlyOwner {
567     addressTranslationMap[from] = to;
568   }
569 
570   function translateAddress(address from) internal view returns(address to) {
571     to = addressTranslationMap[from];
572     if (to == address(0)) {
573       to = from;
574     }
575   }
576 }
577 
578 // File: contracts/Utils/Destructible.sol
579 
580 pragma solidity >=0.5.0;
581 
582 
583 /**
584  * @title Destructible
585  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
586  */
587 contract Destructible is Ownable {
588   /**
589    * @dev Transfers the current balance to the owner and terminates the contract.
590    */
591   function destroy() public onlyOwner {
592     selfdestruct(address(bytes20(owner())));
593   }
594 
595   function destroyAndSend(address payable _recipient) public onlyOwner {
596     selfdestruct(_recipient);
597   }
598 }
599 
600 // File: contracts/Utils/Pausable.sol
601 
602 pragma solidity >=0.4.24;
603 
604 
605 /**
606  * @title Pausable
607  * @dev Base contract which allows children to implement an emergency stop mechanism.
608  */
609 contract Pausable is Ownable {
610   event Pause();
611   event Unpause();
612 
613   bool public paused = false;
614 
615 
616   /**
617    * @dev Modifier to make a function callable only when the contract is not paused.
618    */
619   modifier whenNotPaused() {
620     require(!paused, "The contract is paused");
621     _;
622   }
623 
624   /**
625    * @dev Modifier to make a function callable only when the contract is paused.
626    */
627   modifier whenPaused() {
628     require(paused, "The contract is not paused");
629     _;
630   }
631 
632   /**
633    * @dev called by the owner to pause, triggers stopped state
634    */
635   function pause() public onlyOwner whenNotPaused {
636     paused = true;
637     emit Pause();
638   }
639 
640   /**
641    * @dev called by the owner to unpause, returns to normal state
642    */
643   function unpause() public onlyOwner whenPaused {
644     paused = false;
645     emit Unpause();
646   }
647 }
648 
649 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
650 
651 pragma solidity ^0.5.0;
652 
653 
654 
655 
656 /**
657  * @dev Implementation of the {IERC20} interface.
658  *
659  * This implementation is agnostic to the way tokens are created. This means
660  * that a supply mechanism has to be added in a derived contract using {_mint}.
661  * For a generic mechanism see {ERC20Mintable}.
662  *
663  * TIP: For a detailed writeup see our guide
664  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
665  * to implement supply mechanisms].
666  *
667  * We have followed general OpenZeppelin guidelines: functions revert instead
668  * of returning `false` on failure. This behavior is nonetheless conventional
669  * and does not conflict with the expectations of ERC20 applications.
670  *
671  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
672  * This allows applications to reconstruct the allowance for all accounts just
673  * by listening to said events. Other implementations of the EIP may not emit
674  * these events, as it isn't required by the specification.
675  *
676  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
677  * functions have been added to mitigate the well-known issues around setting
678  * allowances. See {IERC20-approve}.
679  */
680 contract ERC20 is Context, IERC20 {
681     using SafeMath for uint256;
682 
683     mapping (address => uint256) private _balances;
684 
685     mapping (address => mapping (address => uint256)) private _allowances;
686 
687     uint256 private _totalSupply;
688 
689     /**
690      * @dev See {IERC20-totalSupply}.
691      */
692     function totalSupply() public view returns (uint256) {
693         return _totalSupply;
694     }
695 
696     /**
697      * @dev See {IERC20-balanceOf}.
698      */
699     function balanceOf(address account) public view returns (uint256) {
700         return _balances[account];
701     }
702 
703     /**
704      * @dev See {IERC20-transfer}.
705      *
706      * Requirements:
707      *
708      * - `recipient` cannot be the zero address.
709      * - the caller must have a balance of at least `amount`.
710      */
711     function transfer(address recipient, uint256 amount) public returns (bool) {
712         _transfer(_msgSender(), recipient, amount);
713         return true;
714     }
715 
716     /**
717      * @dev See {IERC20-allowance}.
718      */
719     function allowance(address owner, address spender) public view returns (uint256) {
720         return _allowances[owner][spender];
721     }
722 
723     /**
724      * @dev See {IERC20-approve}.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      */
730     function approve(address spender, uint256 amount) public returns (bool) {
731         _approve(_msgSender(), spender, amount);
732         return true;
733     }
734 
735     /**
736      * @dev See {IERC20-transferFrom}.
737      *
738      * Emits an {Approval} event indicating the updated allowance. This is not
739      * required by the EIP. See the note at the beginning of {ERC20};
740      *
741      * Requirements:
742      * - `sender` and `recipient` cannot be the zero address.
743      * - `sender` must have a balance of at least `amount`.
744      * - the caller must have allowance for `sender`'s tokens of at least
745      * `amount`.
746      */
747     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
748         _transfer(sender, recipient, amount);
749         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
750         return true;
751     }
752 
753     /**
754      * @dev Atomically increases the allowance granted to `spender` by the caller.
755      *
756      * This is an alternative to {approve} that can be used as a mitigation for
757      * problems described in {IERC20-approve}.
758      *
759      * Emits an {Approval} event indicating the updated allowance.
760      *
761      * Requirements:
762      *
763      * - `spender` cannot be the zero address.
764      */
765     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
766         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
767         return true;
768     }
769 
770     /**
771      * @dev Atomically decreases the allowance granted to `spender` by the caller.
772      *
773      * This is an alternative to {approve} that can be used as a mitigation for
774      * problems described in {IERC20-approve}.
775      *
776      * Emits an {Approval} event indicating the updated allowance.
777      *
778      * Requirements:
779      *
780      * - `spender` cannot be the zero address.
781      * - `spender` must have allowance for the caller of at least
782      * `subtractedValue`.
783      */
784     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
785         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
786         return true;
787     }
788 
789     /**
790      * @dev Moves tokens `amount` from `sender` to `recipient`.
791      *
792      * This is internal function is equivalent to {transfer}, and can be used to
793      * e.g. implement automatic token fees, slashing mechanisms, etc.
794      *
795      * Emits a {Transfer} event.
796      *
797      * Requirements:
798      *
799      * - `sender` cannot be the zero address.
800      * - `recipient` cannot be the zero address.
801      * - `sender` must have a balance of at least `amount`.
802      */
803     function _transfer(address sender, address recipient, uint256 amount) internal {
804         require(sender != address(0), "ERC20: transfer from the zero address");
805         require(recipient != address(0), "ERC20: transfer to the zero address");
806 
807         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
808         _balances[recipient] = _balances[recipient].add(amount);
809         emit Transfer(sender, recipient, amount);
810     }
811 
812     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
813      * the total supply.
814      *
815      * Emits a {Transfer} event with `from` set to the zero address.
816      *
817      * Requirements
818      *
819      * - `to` cannot be the zero address.
820      */
821     function _mint(address account, uint256 amount) internal {
822         require(account != address(0), "ERC20: mint to the zero address");
823 
824         _totalSupply = _totalSupply.add(amount);
825         _balances[account] = _balances[account].add(amount);
826         emit Transfer(address(0), account, amount);
827     }
828 
829     /**
830      * @dev Destroys `amount` tokens from `account`, reducing the
831      * total supply.
832      *
833      * Emits a {Transfer} event with `to` set to the zero address.
834      *
835      * Requirements
836      *
837      * - `account` cannot be the zero address.
838      * - `account` must have at least `amount` tokens.
839      */
840     function _burn(address account, uint256 amount) internal {
841         require(account != address(0), "ERC20: burn from the zero address");
842 
843         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
844         _totalSupply = _totalSupply.sub(amount);
845         emit Transfer(account, address(0), amount);
846     }
847 
848     /**
849      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
850      *
851      * This is internal function is equivalent to `approve`, and can be used to
852      * e.g. set automatic allowances for certain subsystems, etc.
853      *
854      * Emits an {Approval} event.
855      *
856      * Requirements:
857      *
858      * - `owner` cannot be the zero address.
859      * - `spender` cannot be the zero address.
860      */
861     function _approve(address owner, address spender, uint256 amount) internal {
862         require(owner != address(0), "ERC20: approve from the zero address");
863         require(spender != address(0), "ERC20: approve to the zero address");
864 
865         _allowances[owner][spender] = amount;
866         emit Approval(owner, spender, amount);
867     }
868 
869     /**
870      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
871      * from the caller's allowance.
872      *
873      * See {_burn} and {_approve}.
874      */
875     function _burnFrom(address account, uint256 amount) internal {
876         _burn(account, amount);
877         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
878     }
879 }
880 
881 // File: contracts/Utils/Withdrawable.sol
882 
883 pragma solidity >=0.4.24;
884 
885 
886 
887 
888 contract Withdrawable is Ownable {
889   using SafeERC20 for ERC20;
890   address constant ETHER = address(0);
891 
892   event LogWithdrawToken(
893     address indexed _from,
894     address indexed _token,
895     uint amount
896   );
897 
898   /**
899    * @dev Withdraw asset.
900    * @param _tokenAddress Asset to be withdrawed.
901    * @return bool.
902    */
903   function withdrawToken(address _tokenAddress) public onlyOwner {
904     uint tokenBalance;
905     if (_tokenAddress == ETHER) {
906       address self = address(this); // workaround for a possible solidity bug
907       tokenBalance = self.balance;
908       msg.sender.transfer(tokenBalance);
909     } else {
910       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
911       ERC20(_tokenAddress).safeTransfer(msg.sender, tokenBalance);
912     }
913     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
914   }
915 
916 }
917 
918 // File: contracts/Utils/WithFee.sol
919 
920 pragma solidity ^0.5.0;
921 
922 
923 
924 
925 
926 contract WithFee is Ownable {
927   using SafeERC20 for IERC20;
928   using SafeMath for uint;
929   address payable public feeWallet;
930   uint public storedSpread;
931   uint constant spreadDecimals = 6;
932   uint constant spreadUnit = 10 ** spreadDecimals;
933 
934   event LogFee(address token, uint amount);
935 
936   constructor(address payable _wallet, uint _spread) public {
937     require(_wallet != address(0), "_wallet == address(0)");
938     require(_spread < spreadUnit, "spread >= spreadUnit");
939     feeWallet = _wallet;
940     storedSpread = _spread;
941   }
942 
943   function setFeeWallet(address payable _wallet) external onlyOwner {
944     require(_wallet != address(0), "_wallet == address(0)");
945     feeWallet = _wallet;
946   }
947 
948   function setSpread(uint _spread) external onlyOwner {
949     storedSpread = _spread;
950   }
951 
952   function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
953     return underlyingTokenTotal.mul(storedSpread).div(spreadUnit);
954   }
955 
956   function _payFee(address feeToken, uint fee) internal {
957     if (fee > 0) {
958       if (feeToken == address(0)) {
959         feeWallet.transfer(fee);
960       } else {
961         IERC20(feeToken).safeTransfer(feeWallet, fee);
962       }
963       emit LogFee(feeToken, fee);
964     }
965   }
966 
967 }
968 
969 // File: contracts/Interfaces/IErc20Swap.sol
970 
971 pragma solidity >=0.4.0;
972 
973 interface IErc20Swap {
974     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
975     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
976 
977     event LogTokenSwap(
978         address indexed _userAddress,
979         address indexed _userSentTokenAddress,
980         uint _userSentTokenAmount,
981         address indexed _userReceivedTokenAddress,
982         uint _userReceivedTokenAmount
983     );
984 }
985 
986 // File: contracts/base/NetworkBasedTokenSwap.sol
987 
988 pragma solidity >=0.5.0;
989 
990 
991 
992 
993 
994 
995 
996 
997 
998 
999 contract NetworkBasedTokenSwap is Withdrawable, Pausable, Destructible, WithFee, IErc20Swap
1000 {
1001   using SafeMath for uint;
1002   using SafeERC20 for IERC20;
1003   address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1004 
1005   mapping (address => mapping (address => uint)) spreadCustom;
1006 
1007   event UnexpectedIntialBalance(address token, uint amount);
1008 
1009   constructor(
1010     address payable _wallet,
1011     uint _spread
1012   )
1013     public WithFee(_wallet, _spread)
1014   {}
1015 
1016   function() external payable {
1017     // can receive ethers
1018   }
1019 
1020   // spread value >= spreadUnit means no fee
1021   function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
1022     uint value = spread > spreadUnit ? spreadUnit : spread;
1023     spreadCustom[tokenA][tokenB] = value;
1024     spreadCustom[tokenB][tokenA] = value;
1025   }
1026 
1027   function getSpread(address tokenA, address tokenB) public view returns(uint) {
1028     uint value = spreadCustom[tokenA][tokenB];
1029     if (value == 0) return storedSpread;
1030     if (value >= spreadUnit) return 0;
1031     else return value;
1032   }
1033 
1034   // kyber network style rate
1035   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view returns(uint expectedRate, uint slippageRate);
1036 
1037   function getRate(address src, address dest, uint256 srcAmount) external view
1038     returns(uint expectedRate, uint slippageRate)
1039   {
1040     (uint256 kExpected, uint256 kSplippage) = getNetworkRate(src, dest, srcAmount);
1041     uint256 spread = getSpread(src, dest);
1042     expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
1043     slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
1044   }
1045 
1046   function _freeUnexpectedTokens(address token) private {
1047     uint256 unexpectedBalance = token == ETHER
1048       ? _myEthBalance().sub(msg.value)
1049       : IBadStaticCallERC20(token).balanceOf(address(this));
1050     if (unexpectedBalance > 0) {
1051       _transfer(token, address(bytes20(owner())), unexpectedBalance);
1052       emit UnexpectedIntialBalance(token, unexpectedBalance);
1053     }
1054   }
1055 
1056   function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
1057     require(src != dest, "src == dest");
1058     require(srcAmount > 0, "srcAmount == 0");
1059 
1060     // empty unexpected initial balances
1061     _freeUnexpectedTokens(src);
1062     _freeUnexpectedTokens(dest);
1063 
1064     if (src == ETHER) {
1065       require(msg.value == srcAmount, "msg.value != srcAmount");
1066     } else {
1067       require(
1068         IBadStaticCallERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
1069         "ERC20 allowance < srcAmount"
1070       );
1071       // get user's tokens
1072       IERC20(src).safeTransferFrom(msg.sender, address(this), srcAmount);
1073     }
1074 
1075     uint256 spread = getSpread(src, dest);
1076 
1077     // calculate the minConversionRate and maxDestAmount keeping in mind the fee
1078     uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
1079     uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
1080     uint256 destTradedAmount = doNetworkTrade(src, srcAmount, dest, adaptedMaxDestAmount, adaptedMinRate);
1081 
1082     uint256 notTraded = _myBalance(src);
1083     uint256 srcTradedAmount = srcAmount.sub(notTraded);
1084     require(srcTradedAmount > 0, "no traded tokens");
1085     require(
1086       _myBalance(dest) >= destTradedAmount,
1087       "No enough dest tokens after trade"
1088     );
1089     // pay fee and user
1090     uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
1091     _transfer(dest, msg.sender, toUserAmount);
1092     // returns not traded tokens if any
1093     if (notTraded > 0) {
1094       _transfer(src, msg.sender, notTraded);
1095     }
1096 
1097     emit LogTokenSwap(
1098       msg.sender,
1099       src,
1100       srcTradedAmount,
1101       dest,
1102       toUserAmount
1103     );
1104   }
1105 
1106   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) internal returns(uint256);
1107 
1108   function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
1109     uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
1110     toUserAmount = destTradedAmount.sub(fee);
1111     // pay fee
1112     super._payFee(token == ETHER ? address(0) : token, fee);
1113   }
1114 
1115   // workaround for a solidity bug
1116   function _myEthBalance() private view returns(uint256) {
1117     address self = address(this);
1118     return self.balance;
1119   }
1120 
1121   function _myBalance(address token) private returns(uint256) {
1122     return token == ETHER
1123       ? _myEthBalance()
1124       : IBadStaticCallERC20(token).balanceOf(address(this));
1125   }
1126 
1127   function _transfer(address token, address payable recipient, uint256 amount) private {
1128     if (token == ETHER) {
1129       recipient.transfer(amount);
1130     } else {
1131       IERC20(token).safeTransfer(recipient, amount);
1132     }
1133   }
1134 
1135 }
1136 
1137 // File: contracts/Utils/SafeStaticCallERC20.sol
1138 
1139 pragma solidity ^0.5.0;
1140 
1141 
1142 
1143 
1144 library SafeStaticCallERC20 {
1145     using SafeMath for uint256;
1146     using Address for address;
1147 
1148     function safeApprove(IBadStaticCallERC20 token, address spender, uint256 value) internal {
1149         // safeApprove should only be called when setting an initial allowance,
1150         // or when resetting it to zero. To increase and decrease it, use
1151         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1152         // solhint-disable-next-line max-line-length
1153         require((value == 0) || (token.allowance(address(this), spender) == 0),
1154             "SafeProxyERC20: approve from non-zero to non-zero allowance"
1155         );
1156         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1157     }
1158 
1159     /**
1160      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1161      * on the return value: the return value is optional (but if data is returned, it must not be false).
1162      * @param token The token targeted by the call.
1163      * @param data The call data (encoded using abi.encode or one of its variants).
1164      */
1165     function callOptionalReturn(IBadStaticCallERC20 token, bytes memory data) private {
1166         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1167         // we're implementing it ourselves.
1168 
1169         // A Solidity high level call has three parts:
1170         //  1. The target address is checked to verify it contains contract code
1171         //  2. The call itself is made, and success asserted
1172         //  3. The return value is decoded, which in turn checks the size of the returned data.
1173         // solhint-disable-next-line max-line-length
1174         require(address(token).isContract(), "SafeProxyERC20: call to non-contract");
1175 
1176         // solhint-disable-next-line avoid-low-level-calls
1177         (bool success, bytes memory returndata) = address(token).call(data);
1178         require(success, "SafeProxyERC20: low-level call failed");
1179 
1180         if (returndata.length > 0) { // Return data is optional
1181             // solhint-disable-next-line max-line-length
1182             require(abi.decode(returndata, (bool)), "SafeProxyERC20: ERC20 operation did not succeed");
1183         }
1184     }
1185 }
1186 
1187 // File: contracts/KyberTokenSwap.sol
1188 
1189 pragma solidity >=0.5.0;
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 contract KyberTokenSwap is AddressTranslation, NetworkBasedTokenSwap
1200 {
1201   using SafeMath for uint;
1202   using SafeERC20 for IERC20;
1203   using SafeStaticCallERC20 for IBadStaticCallERC20;
1204 
1205   IKyberNetwork public kyberNetwork;
1206 
1207   address public kyberFeeWallet;
1208 
1209   constructor(
1210     address _kyberNetwork,
1211     address payable _wallet,
1212     address _kyberFeeWallet,
1213     uint _spread
1214   )
1215     public NetworkBasedTokenSwap(_wallet, _spread)
1216   {
1217     require(_kyberNetwork != address(0), "_kyberNetwork == address(0)");
1218     kyberNetwork = IKyberNetwork(_kyberNetwork);
1219     kyberFeeWallet = _kyberFeeWallet;
1220   }
1221 
1222   function setKyberNetwork(address _kyberNetwork) public onlyOwner {
1223     require(_kyberNetwork != address(0), "_kyberNetwork == address(0)");
1224     kyberNetwork = IKyberNetwork(_kyberNetwork);
1225   }
1226 
1227   function setKyberFeeWallet(address _wallet) public onlyOwner {
1228     kyberFeeWallet = _wallet;
1229   }
1230 
1231   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view
1232     returns(uint expectedRate, uint slippageRate)
1233   {
1234     return kyberNetwork.getExpectedRate(translateAddress(src), translateAddress(dest), srcAmount);
1235   }
1236 
1237   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate)
1238     internal returns(uint256)
1239   {
1240     if (src == ETHER) {
1241       return kyberNetwork.trade
1242         .value(srcAmount)(translateAddress(src), srcAmount, translateAddress(dest), address(this), maxDestAmount, minConversionRate, kyberFeeWallet);
1243     } else {
1244       if (IBadStaticCallERC20(src).allowance(address(this), address(kyberNetwork)) > 0) {
1245         IBadStaticCallERC20(src).safeApprove(address(kyberNetwork), 0);
1246       }
1247       IBadStaticCallERC20(src).safeApprove(address(kyberNetwork), srcAmount);
1248       return kyberNetwork.trade(translateAddress(src), srcAmount, translateAddress(dest), address(this), maxDestAmount, minConversionRate, kyberFeeWallet);
1249     }
1250   }
1251 
1252 }