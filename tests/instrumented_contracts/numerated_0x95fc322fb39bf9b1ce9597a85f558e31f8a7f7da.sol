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
250      * This test is non-exhaustive, and there may be false-negatives: during the
251      * execution of a contract's constructor, its address will be reported as
252      * not containing a contract.
253      *
254      * IMPORTANT: It is unsafe to assume that an address for which this
255      * function returns false is an externally-owned account (EOA) and not a
256      * contract.
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != 0x0 && codehash != accountHash);
271     }
272 
273     /**
274      * @dev Converts an `address` into `address payable`. Note that this is
275      * simply a type cast: the actual underlying value is not changed.
276      *
277      * _Available since v2.4.0._
278      */
279     function toPayable(address account) internal pure returns (address payable) {
280         return address(uint160(account));
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      *
299      * _Available since v2.4.0._
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-call-value
305         (bool success, ) = recipient.call.value(amount)("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 }
309 
310 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
311 
312 pragma solidity ^0.5.0;
313 
314 
315 
316 
317 /**
318  * @title SafeERC20
319  * @dev Wrappers around ERC20 operations that throw on failure (when the token
320  * contract returns false). Tokens that return no value (and instead revert or
321  * throw on failure) are also supported, non-reverting calls are assumed to be
322  * successful.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327     using SafeMath for uint256;
328     using Address for address;
329 
330     function safeTransfer(IERC20 token, address to, uint256 value) internal {
331         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332     }
333 
334     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336     }
337 
338     function safeApprove(IERC20 token, address spender, uint256 value) internal {
339         // safeApprove should only be called when setting an initial allowance,
340         // or when resetting it to zero. To increase and decrease it, use
341         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
342         // solhint-disable-next-line max-line-length
343         require((value == 0) || (token.allowance(address(this), spender) == 0),
344             "SafeERC20: approve from non-zero to non-zero allowance"
345         );
346         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
347     }
348 
349     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350         uint256 newAllowance = token.allowance(address(this), spender).add(value);
351         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352     }
353 
354     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
355         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
356         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
357     }
358 
359     /**
360      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
361      * on the return value: the return value is optional (but if data is returned, it must not be false).
362      * @param token The token targeted by the call.
363      * @param data The call data (encoded using abi.encode or one of its variants).
364      */
365     function callOptionalReturn(IERC20 token, bytes memory data) private {
366         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
367         // we're implementing it ourselves.
368 
369         // A Solidity high level call has three parts:
370         //  1. The target address is checked to verify it contains contract code
371         //  2. The call itself is made, and success asserted
372         //  3. The return value is decoded, which in turn checks the size of the returned data.
373         // solhint-disable-next-line max-line-length
374         require(address(token).isContract(), "SafeERC20: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = address(token).call(data);
378         require(success, "SafeERC20: low-level call failed");
379 
380         if (returndata.length > 0) { // Return data is optional
381             // solhint-disable-next-line max-line-length
382             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
383         }
384     }
385 }
386 
387 // File: contracts/Interfaces/IBZxLoanToken.sol
388 
389 pragma solidity >=0.4.0;
390 
391 interface IBZxLoanToken {
392     function transfer(address dst, uint256 amount) external returns (bool);
393     function transferFrom(address src, address dst, uint256 amount) external returns (bool);
394     function approve(address spender, uint256 amount) external returns (bool);
395     function allowance(address owner, address spender) external view returns (uint256);
396     function balanceOf(address owner) external view returns (uint256);
397 
398     function loanTokenAddress() external view returns (address);
399     function tokenPrice() external view returns (uint256 price);
400 //    function mintWithEther(address receiver) external payable returns (uint256 mintAmount);
401     function mint(address receiver, uint256 depositAmount) external returns (uint256 mintAmount);
402 //    function burnToEther(address payable receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
403     function burn(address receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
404 }
405 
406 contract IBZxLoanEther is IBZxLoanToken {
407     function mintWithEther(address receiver) external payable returns (uint256 mintAmount);
408     function burnToEther(address payable receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
409 }
410 
411 // File: openzeppelin-solidity/contracts/GSN/Context.sol
412 
413 pragma solidity ^0.5.0;
414 
415 /*
416  * @dev Provides information about the current execution context, including the
417  * sender of the transaction and its data. While these are generally available
418  * via msg.sender and msg.data, they should not be accessed in such a direct
419  * manner, since when dealing with GSN meta-transactions the account sending and
420  * paying for execution may not be the actual sender (as far as an application
421  * is concerned).
422  *
423  * This contract is only required for intermediate, library-like contracts.
424  */
425 contract Context {
426     // Empty internal constructor, to prevent people from mistakenly deploying
427     // an instance of this contract, which should be used via inheritance.
428     constructor () internal { }
429     // solhint-disable-previous-line no-empty-blocks
430 
431     function _msgSender() internal view returns (address payable) {
432         return msg.sender;
433     }
434 
435     function _msgData() internal view returns (bytes memory) {
436         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
437         return msg.data;
438     }
439 }
440 
441 // File: openzeppelin-solidity/contracts/Ownership/Ownable.sol
442 
443 pragma solidity ^0.5.0;
444 
445 /**
446  * @dev Contract module which provides a basic access control mechanism, where
447  * there is an account (an owner) that can be granted exclusive access to
448  * specific functions.
449  *
450  * This module is used through inheritance. It will make available the modifier
451  * `onlyOwner`, which can be applied to your functions to restrict their use to
452  * the owner.
453  */
454 contract Ownable is Context {
455     address private _owner;
456 
457     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
458 
459     /**
460      * @dev Initializes the contract setting the deployer as the initial owner.
461      */
462     constructor () internal {
463         _owner = _msgSender();
464         emit OwnershipTransferred(address(0), _owner);
465     }
466 
467     /**
468      * @dev Returns the address of the current owner.
469      */
470     function owner() public view returns (address) {
471         return _owner;
472     }
473 
474     /**
475      * @dev Throws if called by any account other than the owner.
476      */
477     modifier onlyOwner() {
478         require(isOwner(), "Ownable: caller is not the owner");
479         _;
480     }
481 
482     /**
483      * @dev Returns true if the caller is the current owner.
484      */
485     function isOwner() public view returns (bool) {
486         return _msgSender() == _owner;
487     }
488 
489     /**
490      * @dev Leaves the contract without owner. It will not be possible to call
491      * `onlyOwner` functions anymore. Can only be called by the current owner.
492      *
493      * NOTE: Renouncing ownership will leave the contract without an owner,
494      * thereby removing any functionality that is only available to the owner.
495      */
496     function renounceOwnership() public onlyOwner {
497         emit OwnershipTransferred(_owner, address(0));
498         _owner = address(0);
499     }
500 
501     /**
502      * @dev Transfers ownership of the contract to a new account (`newOwner`).
503      * Can only be called by the current owner.
504      */
505     function transferOwnership(address newOwner) public onlyOwner {
506         _transferOwnership(newOwner);
507     }
508 
509     /**
510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
511      */
512     function _transferOwnership(address newOwner) internal {
513         require(newOwner != address(0), "Ownable: new owner is the zero address");
514         emit OwnershipTransferred(_owner, newOwner);
515         _owner = newOwner;
516     }
517 }
518 
519 // File: contracts/Utils/Destructible.sol
520 
521 pragma solidity >=0.5.0;
522 
523 
524 /**
525  * @title Destructible
526  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
527  */
528 contract Destructible is Ownable {
529   /**
530    * @dev Transfers the current balance to the owner and terminates the contract.
531    */
532   function destroy() public onlyOwner {
533     selfdestruct(address(bytes20(owner())));
534   }
535 
536   function destroyAndSend(address payable _recipient) public onlyOwner {
537     selfdestruct(_recipient);
538   }
539 }
540 
541 // File: contracts/Utils/Pausable.sol
542 
543 pragma solidity >=0.4.24;
544 
545 
546 /**
547  * @title Pausable
548  * @dev Base contract which allows children to implement an emergency stop mechanism.
549  */
550 contract Pausable is Ownable {
551   event Pause();
552   event Unpause();
553 
554   bool public paused = false;
555 
556 
557   /**
558    * @dev Modifier to make a function callable only when the contract is not paused.
559    */
560   modifier whenNotPaused() {
561     require(!paused, "The contract is paused");
562     _;
563   }
564 
565   /**
566    * @dev Modifier to make a function callable only when the contract is paused.
567    */
568   modifier whenPaused() {
569     require(paused, "The contract is not paused");
570     _;
571   }
572 
573   /**
574    * @dev called by the owner to pause, triggers stopped state
575    */
576   function pause() public onlyOwner whenNotPaused {
577     paused = true;
578     emit Pause();
579   }
580 
581   /**
582    * @dev called by the owner to unpause, returns to normal state
583    */
584   function unpause() public onlyOwner whenPaused {
585     paused = false;
586     emit Unpause();
587   }
588 }
589 
590 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
591 
592 pragma solidity ^0.5.0;
593 
594 
595 
596 
597 /**
598  * @dev Implementation of the {IERC20} interface.
599  *
600  * This implementation is agnostic to the way tokens are created. This means
601  * that a supply mechanism has to be added in a derived contract using {_mint}.
602  * For a generic mechanism see {ERC20Mintable}.
603  *
604  * TIP: For a detailed writeup see our guide
605  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
606  * to implement supply mechanisms].
607  *
608  * We have followed general OpenZeppelin guidelines: functions revert instead
609  * of returning `false` on failure. This behavior is nonetheless conventional
610  * and does not conflict with the expectations of ERC20 applications.
611  *
612  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
613  * This allows applications to reconstruct the allowance for all accounts just
614  * by listening to said events. Other implementations of the EIP may not emit
615  * these events, as it isn't required by the specification.
616  *
617  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
618  * functions have been added to mitigate the well-known issues around setting
619  * allowances. See {IERC20-approve}.
620  */
621 contract ERC20 is Context, IERC20 {
622     using SafeMath for uint256;
623 
624     mapping (address => uint256) private _balances;
625 
626     mapping (address => mapping (address => uint256)) private _allowances;
627 
628     uint256 private _totalSupply;
629 
630     /**
631      * @dev See {IERC20-totalSupply}.
632      */
633     function totalSupply() public view returns (uint256) {
634         return _totalSupply;
635     }
636 
637     /**
638      * @dev See {IERC20-balanceOf}.
639      */
640     function balanceOf(address account) public view returns (uint256) {
641         return _balances[account];
642     }
643 
644     /**
645      * @dev See {IERC20-transfer}.
646      *
647      * Requirements:
648      *
649      * - `recipient` cannot be the zero address.
650      * - the caller must have a balance of at least `amount`.
651      */
652     function transfer(address recipient, uint256 amount) public returns (bool) {
653         _transfer(_msgSender(), recipient, amount);
654         return true;
655     }
656 
657     /**
658      * @dev See {IERC20-allowance}.
659      */
660     function allowance(address owner, address spender) public view returns (uint256) {
661         return _allowances[owner][spender];
662     }
663 
664     /**
665      * @dev See {IERC20-approve}.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      */
671     function approve(address spender, uint256 amount) public returns (bool) {
672         _approve(_msgSender(), spender, amount);
673         return true;
674     }
675 
676     /**
677      * @dev See {IERC20-transferFrom}.
678      *
679      * Emits an {Approval} event indicating the updated allowance. This is not
680      * required by the EIP. See the note at the beginning of {ERC20};
681      *
682      * Requirements:
683      * - `sender` and `recipient` cannot be the zero address.
684      * - `sender` must have a balance of at least `amount`.
685      * - the caller must have allowance for `sender`'s tokens of at least
686      * `amount`.
687      */
688     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
689         _transfer(sender, recipient, amount);
690         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
691         return true;
692     }
693 
694     /**
695      * @dev Atomically increases the allowance granted to `spender` by the caller.
696      *
697      * This is an alternative to {approve} that can be used as a mitigation for
698      * problems described in {IERC20-approve}.
699      *
700      * Emits an {Approval} event indicating the updated allowance.
701      *
702      * Requirements:
703      *
704      * - `spender` cannot be the zero address.
705      */
706     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
707         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
708         return true;
709     }
710 
711     /**
712      * @dev Atomically decreases the allowance granted to `spender` by the caller.
713      *
714      * This is an alternative to {approve} that can be used as a mitigation for
715      * problems described in {IERC20-approve}.
716      *
717      * Emits an {Approval} event indicating the updated allowance.
718      *
719      * Requirements:
720      *
721      * - `spender` cannot be the zero address.
722      * - `spender` must have allowance for the caller of at least
723      * `subtractedValue`.
724      */
725     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
726         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
727         return true;
728     }
729 
730     /**
731      * @dev Moves tokens `amount` from `sender` to `recipient`.
732      *
733      * This is internal function is equivalent to {transfer}, and can be used to
734      * e.g. implement automatic token fees, slashing mechanisms, etc.
735      *
736      * Emits a {Transfer} event.
737      *
738      * Requirements:
739      *
740      * - `sender` cannot be the zero address.
741      * - `recipient` cannot be the zero address.
742      * - `sender` must have a balance of at least `amount`.
743      */
744     function _transfer(address sender, address recipient, uint256 amount) internal {
745         require(sender != address(0), "ERC20: transfer from the zero address");
746         require(recipient != address(0), "ERC20: transfer to the zero address");
747 
748         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
749         _balances[recipient] = _balances[recipient].add(amount);
750         emit Transfer(sender, recipient, amount);
751     }
752 
753     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
754      * the total supply.
755      *
756      * Emits a {Transfer} event with `from` set to the zero address.
757      *
758      * Requirements
759      *
760      * - `to` cannot be the zero address.
761      */
762     function _mint(address account, uint256 amount) internal {
763         require(account != address(0), "ERC20: mint to the zero address");
764 
765         _totalSupply = _totalSupply.add(amount);
766         _balances[account] = _balances[account].add(amount);
767         emit Transfer(address(0), account, amount);
768     }
769 
770      /**
771      * @dev Destroys `amount` tokens from `account`, reducing the
772      * total supply.
773      *
774      * Emits a {Transfer} event with `to` set to the zero address.
775      *
776      * Requirements
777      *
778      * - `account` cannot be the zero address.
779      * - `account` must have at least `amount` tokens.
780      */
781     function _burn(address account, uint256 amount) internal {
782         require(account != address(0), "ERC20: burn from the zero address");
783 
784         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
785         _totalSupply = _totalSupply.sub(amount);
786         emit Transfer(account, address(0), amount);
787     }
788 
789     /**
790      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
791      *
792      * This is internal function is equivalent to `approve`, and can be used to
793      * e.g. set automatic allowances for certain subsystems, etc.
794      *
795      * Emits an {Approval} event.
796      *
797      * Requirements:
798      *
799      * - `owner` cannot be the zero address.
800      * - `spender` cannot be the zero address.
801      */
802     function _approve(address owner, address spender, uint256 amount) internal {
803         require(owner != address(0), "ERC20: approve from the zero address");
804         require(spender != address(0), "ERC20: approve to the zero address");
805 
806         _allowances[owner][spender] = amount;
807         emit Approval(owner, spender, amount);
808     }
809 
810     /**
811      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
812      * from the caller's allowance.
813      *
814      * See {_burn} and {_approve}.
815      */
816     function _burnFrom(address account, uint256 amount) internal {
817         _burn(account, amount);
818         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
819     }
820 }
821 
822 // File: contracts/Utils/Withdrawable.sol
823 
824 pragma solidity >=0.4.24;
825 
826 
827 
828 
829 contract Withdrawable is Ownable {
830   using SafeERC20 for ERC20;
831   address constant ETHER = address(0);
832 
833   event LogWithdrawToken(
834     address indexed _from,
835     address indexed _token,
836     uint amount
837   );
838 
839   /**
840    * @dev Withdraw asset.
841    * @param _tokenAddress Asset to be withdrawed.
842    * @return bool.
843    */
844   function withdrawToken(address _tokenAddress) public onlyOwner {
845     uint tokenBalance;
846     if (_tokenAddress == ETHER) {
847       address self = address(this); // workaround for a possible solidity bug
848       tokenBalance = self.balance;
849       msg.sender.transfer(tokenBalance);
850     } else {
851       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
852       ERC20(_tokenAddress).safeTransfer(msg.sender, tokenBalance);
853     }
854     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
855   }
856 
857 }
858 
859 // File: contracts/Utils/WithFee.sol
860 
861 pragma solidity ^0.5.0;
862 
863 
864 
865 
866 
867 contract WithFee is Ownable {
868   using SafeERC20 for IERC20;
869   using SafeMath for uint;
870   address payable public feeWallet;
871   uint public storedSpread;
872   uint constant spreadDecimals = 6;
873   uint constant spreadUnit = 10 ** spreadDecimals;
874 
875   event LogFee(address token, uint amount);
876 
877   constructor(address payable _wallet, uint _spread) public {
878     require(_wallet != address(0), "_wallet == address(0)");
879     require(_spread < spreadUnit, "spread >= spreadUnit");
880     feeWallet = _wallet;
881     storedSpread = _spread;
882   }
883 
884   function setFeeWallet(address payable _wallet) external onlyOwner {
885     require(_wallet != address(0), "_wallet == address(0)");
886     feeWallet = _wallet;
887   }
888 
889   function setSpread(uint _spread) external onlyOwner {
890     storedSpread = _spread;
891   }
892 
893   function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
894     return underlyingTokenTotal.mul(storedSpread).div(spreadUnit);
895   }
896 
897   function _payFee(address feeToken, uint fee) internal {
898     if (fee > 0) {
899       if (feeToken == address(0)) {
900         feeWallet.transfer(fee);
901       } else {
902         IERC20(feeToken).safeTransfer(feeWallet, fee);
903       }
904       emit LogFee(feeToken, fee);
905     }
906   }
907 
908 }
909 
910 // File: contracts/Interfaces/IErc20Swap.sol
911 
912 pragma solidity >=0.4.0;
913 
914 interface IErc20Swap {
915     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
916     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
917 
918     event LogTokenSwap(
919         address indexed _userAddress,
920         address indexed _userSentTokenAddress,
921         uint _userSentTokenAmount,
922         address indexed _userReceivedTokenAddress,
923         uint _userReceivedTokenAmount
924     );
925 }
926 
927 // File: contracts/Interfaces/IBadStaticCallERC20.sol
928 
929 pragma solidity ^0.5.0;
930 
931 /**
932  * @dev Interface to be safe with not so good proxy contracts.
933  */
934 interface IBadStaticCallERC20 {
935 
936     /**
937      * @dev Returns the amount of tokens owned by `account`.
938      */
939     function balanceOf(address account) external returns (uint256);
940 
941     /**
942      * @dev Returns the remaining number of tokens that `spender` will be
943      * allowed to spend on behalf of `owner` through {transferFrom}. This is
944      * zero by default.
945      *
946      * This value changes when {approve} or {transferFrom} are called.
947      */
948     function allowance(address owner, address spender) external returns (uint256);
949 
950     /**
951      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
952      *
953      * Returns a boolean value indicating whether the operation succeeded.
954      *
955      * IMPORTANT: Beware that changing an allowance with this method brings the risk
956      * that someone may use both the old and the new allowance by unfortunate
957      * transaction ordering. One possible solution to mitigate this race
958      * condition is to first reduce the spender's allowance to 0 and set the
959      * desired value afterwards:
960      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
961      *
962      * Emits an {Approval} event.
963      */
964     function approve(address spender, uint256 amount) external returns (bool);
965 }
966 
967 // File: contracts/base/NetworkBasedTokenSwap.sol
968 
969 pragma solidity >=0.5.0;
970 
971 
972 
973 
974 
975 
976 
977 
978 
979 
980 contract NetworkBasedTokenSwap is Withdrawable, Pausable, Destructible, WithFee, IErc20Swap
981 {
982   using SafeMath for uint;
983   using SafeERC20 for IERC20;
984   address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
985 
986   mapping (address => mapping (address => uint)) spreadCustom;
987 
988   event UnexpectedIntialBalance(address token, uint amount);
989 
990   constructor(
991     address payable _wallet,
992     uint _spread
993   )
994     public WithFee(_wallet, _spread)
995   {}
996 
997   function() external payable {
998     // can receive ethers
999   }
1000 
1001   // spread value >= spreadUnit means no fee
1002   function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
1003     uint value = spread > spreadUnit ? spreadUnit : spread;
1004     spreadCustom[tokenA][tokenB] = value;
1005     spreadCustom[tokenB][tokenA] = value;
1006   }
1007 
1008   function getSpread(address tokenA, address tokenB) public view returns(uint) {
1009     uint value = spreadCustom[tokenA][tokenB];
1010     if (value == 0) return storedSpread;
1011     if (value >= spreadUnit) return 0;
1012     else return value;
1013   }
1014 
1015   // kyber network style rate
1016   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view returns(uint expectedRate, uint slippageRate);
1017 
1018   function getRate(address src, address dest, uint256 srcAmount) external view
1019     returns(uint expectedRate, uint slippageRate)
1020   {
1021     (uint256 kExpected, uint256 kSplippage) = getNetworkRate(src, dest, srcAmount);
1022     uint256 spread = getSpread(src, dest);
1023     expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
1024     slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
1025   }
1026 
1027   function _freeUnexpectedTokens(address token) private {
1028     uint256 unexpectedBalance = token == ETHER
1029       ? _myEthBalance().sub(msg.value)
1030       : IBadStaticCallERC20(token).balanceOf(address(this));
1031     if (unexpectedBalance > 0) {
1032       _transfer(token, address(bytes20(owner())), unexpectedBalance);
1033       emit UnexpectedIntialBalance(token, unexpectedBalance);
1034     }
1035   }
1036 
1037   function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
1038     require(src != dest, "src == dest");
1039     require(srcAmount > 0, "srcAmount == 0");
1040 
1041     // empty unexpected initial balances
1042     _freeUnexpectedTokens(src);
1043     _freeUnexpectedTokens(dest);
1044 
1045     if (src == ETHER) {
1046       require(msg.value == srcAmount, "msg.value != srcAmount");
1047     } else {
1048       require(
1049         IBadStaticCallERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
1050         "ERC20 allowance < srcAmount"
1051       );
1052       // get user's tokens
1053       IERC20(src).safeTransferFrom(msg.sender, address(this), srcAmount);
1054     }
1055 
1056     uint256 spread = getSpread(src, dest);
1057 
1058     // calculate the minConversionRate and maxDestAmount keeping in mind the fee
1059     uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
1060     uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
1061     uint256 destTradedAmount = doNetworkTrade(src, srcAmount, dest, adaptedMaxDestAmount, adaptedMinRate);
1062 
1063     uint256 notTraded = _myBalance(src);
1064     uint256 srcTradedAmount = srcAmount.sub(notTraded);
1065     require(srcTradedAmount > 0, "no traded tokens");
1066     require(
1067       _myBalance(dest) >= destTradedAmount,
1068       "No enough dest tokens after trade"
1069     );
1070     // pay fee and user
1071     uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
1072     _transfer(dest, msg.sender, toUserAmount);
1073     // returns not traded tokens if any
1074     if (notTraded > 0) {
1075       _transfer(src, msg.sender, notTraded);
1076     }
1077 
1078     emit LogTokenSwap(
1079       msg.sender,
1080       src,
1081       srcTradedAmount,
1082       dest,
1083       toUserAmount
1084     );
1085   }
1086 
1087   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) internal returns(uint256);
1088 
1089   function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
1090     uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
1091     toUserAmount = destTradedAmount.sub(fee);
1092     // pay fee
1093     super._payFee(token == ETHER ? address(0) : token, fee);
1094   }
1095 
1096   // workaround for a solidity bug
1097   function _myEthBalance() private view returns(uint256) {
1098     address self = address(this);
1099     return self.balance;
1100   }
1101 
1102   function _myBalance(address token) private returns(uint256) {
1103     return token == ETHER
1104       ? _myEthBalance()
1105       : IBadStaticCallERC20(token).balanceOf(address(this));
1106   }
1107 
1108   function _transfer(address token, address payable recipient, uint256 amount) private {
1109     if (token == ETHER) {
1110       recipient.transfer(amount);
1111     } else {
1112       IERC20(token).safeTransfer(recipient, amount);
1113     }
1114   }
1115 
1116 }
1117 
1118 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1119 
1120 pragma solidity ^0.5.0;
1121 
1122 
1123 /**
1124  * @dev Optional functions from the ERC20 standard.
1125  */
1126 contract ERC20Detailed is IERC20 {
1127     string private _name;
1128     string private _symbol;
1129     uint8 private _decimals;
1130 
1131     /**
1132      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1133      * these values are immutable: they can only be set once during
1134      * construction.
1135      */
1136     constructor (string memory name, string memory symbol, uint8 decimals) public {
1137         _name = name;
1138         _symbol = symbol;
1139         _decimals = decimals;
1140     }
1141 
1142     /**
1143      * @dev Returns the name of the token.
1144      */
1145     function name() public view returns (string memory) {
1146         return _name;
1147     }
1148 
1149     /**
1150      * @dev Returns the symbol of the token, usually a shorter version of the
1151      * name.
1152      */
1153     function symbol() public view returns (string memory) {
1154         return _symbol;
1155     }
1156 
1157     /**
1158      * @dev Returns the number of decimals used to get its user representation.
1159      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1160      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1161      *
1162      * Tokens usually opt for a value of 18, imitating the relationship between
1163      * Ether and Wei.
1164      *
1165      * NOTE: This information is only used for _display_ purposes: it in
1166      * no way affects any of the arithmetic of the contract, including
1167      * {IERC20-balanceOf} and {IERC20-transfer}.
1168      */
1169     function decimals() public view returns (uint8) {
1170         return _decimals;
1171     }
1172 }
1173 
1174 // File: contracts/Utils/LowLevel.sol
1175 
1176 pragma solidity ^0.5.0;
1177 
1178 library LowLevel {
1179   function callContractAddr(address target, bytes memory payload) internal view
1180     returns (bool success_, address result_)
1181   {
1182     (bool success, bytes memory result) = address(target).staticcall(payload);
1183     if (success && result.length == 32) {
1184       assembly {
1185         result_ := mload(add(result,32))
1186       }
1187       success_ = true;
1188     }
1189   }
1190 
1191   function callContractUint(address target, bytes memory payload) internal view
1192     returns (bool success_, uint result_)
1193   {
1194     (bool success, bytes memory result) = address(target).staticcall(payload);
1195     if (success && result.length == 32) {
1196       assembly {
1197         result_ := mload(add(result,32))
1198       }
1199       success_ = true;
1200     }
1201   }
1202 }
1203 
1204 // File: contracts/Utils/RateNormalization.sol
1205 
1206 pragma solidity ^0.5.0;
1207 
1208 
1209 
1210 
1211 
1212 contract RateNormalization is Ownable {
1213   using SafeMath for uint;
1214 
1215   struct RateAdjustment {
1216     uint factor;
1217     bool multiply;
1218   }
1219 
1220   mapping (address => mapping(address => RateAdjustment)) public rateAdjustment;
1221   mapping (address => uint) public forcedDecimals;
1222 
1223   // return normalized rate
1224   function normalizeRate(address src, address dest, uint256 rate) public view
1225     returns(uint)
1226   {
1227     RateAdjustment memory adj = rateAdjustment[src][dest];
1228     if (adj.factor == 0) {
1229       uint srcDecimals = _getDecimals(src);
1230       uint destDecimals = _getDecimals(dest);
1231       if (srcDecimals != destDecimals) {
1232         if (srcDecimals > destDecimals) {
1233           adj.multiply = true;
1234           adj.factor = 10 ** (srcDecimals - destDecimals);
1235         } else {
1236           adj.multiply = false;
1237           adj.factor = 10 ** (destDecimals - srcDecimals);
1238         }
1239       }
1240     }
1241     if (adj.factor > 1) {
1242       rate = adj.multiply
1243       ? rate.mul(adj.factor)
1244       : rate.div(adj.factor);
1245     }
1246     return rate;
1247   }
1248 
1249   function _getDecimals(address token) internal view returns(uint) {
1250     uint forced = forcedDecimals[token];
1251     if (forced > 0) return forced;
1252     bytes memory payload = abi.encodeWithSignature("decimals()");
1253     (bool success, uint decimals) = LowLevel.callContractUint(token, payload);
1254     require(success, "the token doesn't expose the decimals number");
1255     return decimals;
1256   }
1257 
1258   function setRateAdjustmentFactor(address src, address dest, uint factor, bool multiply) public onlyOwner {
1259     rateAdjustment[src][dest] = RateAdjustment(factor, multiply);
1260     rateAdjustment[dest][src] = RateAdjustment(factor, !multiply);
1261   }
1262 
1263   function setForcedDecimals(address token, uint decimals) public onlyOwner {
1264     forcedDecimals[token] = decimals;
1265   }
1266 
1267 }
1268 
1269 // File: contracts/BZxLoanEtherSwap.sol
1270 
1271 pragma solidity >=0.5.0;
1272 
1273 
1274 
1275 
1276 
1277 
1278 
1279 contract BZxLoanEtherSwap is RateNormalization, NetworkBasedTokenSwap
1280 {
1281   using SafeMath for uint;
1282   using SafeERC20 for IERC20;
1283   uint constant expScale = 1e18;
1284   uint constant expScaleSquare = 1e18 * 1e18;
1285 
1286   IBZxLoanEther public ieth;
1287 
1288   constructor(
1289     address _ieth,
1290     address payable _wallet,
1291     uint _spread
1292   )
1293     public NetworkBasedTokenSwap(_wallet, _spread)
1294   {
1295     setForcedDecimals(ETHER, 18);
1296     ieth = IBZxLoanEther(_ieth);
1297   }
1298 
1299   function getNetworkRate(address src, address dest, uint256 /*srcAmount*/) internal view
1300     returns(uint expectedRate, uint slippageRate)
1301   {
1302     uint rateStored = ieth.tokenPrice();
1303     uint rate = 0;
1304     if (src == ETHER && dest == address(ieth)) {
1305       rate = expScaleSquare.div(rateStored);
1306     } else if (src == address(ieth) && dest == ETHER) {
1307       rate = rateStored;
1308     }
1309     rate = normalizeRate(src, dest, rate);
1310     return (rate, rate);
1311   }
1312 
1313   function doNetworkTrade(address src, uint srcAmount, address dest, uint /*maxDestAmount*/, uint minConversionRate)
1314     internal returns(uint256)
1315   {
1316     (uint rate, ) = getNetworkRate(src, dest, srcAmount);
1317     require(rate >= minConversionRate, "rate < minConversionRate");
1318 
1319     if (src == ETHER && dest == address(ieth)) {
1320       return ieth.mintWithEther.value(srcAmount)(address(this));
1321     } else if (src == address(ieth) && dest == ETHER) {
1322       return ieth.burnToEther(address(this), srcAmount);
1323     } else {
1324       return 0;
1325     }
1326   }
1327 }