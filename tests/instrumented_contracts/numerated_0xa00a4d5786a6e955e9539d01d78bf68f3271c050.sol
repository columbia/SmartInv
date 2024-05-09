1 pragma solidity ^0.5.0;
2 /**
3  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
4  * the optional functions; to access them see {ERC20Detailed}.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 /**
77  * @dev Collection of functions related to the address type
78  */
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * This test is non-exhaustive, and there may be false-negatives: during the
84      * execution of a contract's constructor, its address will be reported as
85      * not containing a contract.
86      *
87      * IMPORTANT: It is unsafe to assume that an address for which this
88      * function returns false is an externally-owned account (EOA) and not a
89      * contract.
90      */
91     function isContract(address account) internal view returns (bool) {
92         // This method relies in extcodesize, which returns 0 for contracts in
93         // construction, since the code is only stored at the end of the
94         // constructor execution.
95 
96         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
97         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
98         // for accounts without code, i.e. `keccak256('')`
99         bytes32 codehash;
100         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
101         // solhint-disable-next-line no-inline-assembly
102         assembly { codehash := extcodehash(account) }
103         return (codehash != 0x0 && codehash != accountHash);
104     }
105 
106     /**
107      * @dev Converts an `address` into `address payable`. Note that this is
108      * simply a type cast: the actual underlying value is not changed.
109      *
110      * _Available since v2.4.0._
111      */
112     function toPayable(address account) internal pure returns (address payable) {
113         return address(uint160(account));
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      *
132      * _Available since v2.4.0._
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-call-value
138         (bool success, ) = recipient.call.value(amount)("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 }
142 /**
143  * @dev Wrappers over Solidity's arithmetic operations with added overflow
144  * checks.
145  *
146  * Arithmetic operations in Solidity wrap on overflow. This can easily result
147  * in bugs, because programmers usually assume that an overflow raises an
148  * error, which is the standard behavior in high level programming languages.
149  * `SafeMath` restores this intuition by reverting the transaction when an
150  * operation overflows.
151  *
152  * Using this library instead of the unchecked operations eliminates an entire
153  * class of bugs, so it's recommended to use it always.
154  */
155 library SafeMath {
156     /**
157      * @dev Returns the addition of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `+` operator.
161      *
162      * Requirements:
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a, "SafeMath: addition overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182         return sub(a, b, "SafeMath: subtraction overflow");
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      * - Subtraction cannot overflow.
193      *
194      * _Available since v2.4.0._
195      */
196     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b <= a, errorMessage);
198         uint256 c = a - b;
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the multiplication of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `*` operator.
208      *
209      * Requirements:
210      * - Multiplication cannot overflow.
211      */
212     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
213         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
214         // benefit is lost if 'b' is also tested.
215         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
216         if (a == 0) {
217             return 0;
218         }
219 
220         uint256 c = a * b;
221         require(c / a == b, "SafeMath: multiplication overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return div(a, b, "SafeMath: division by zero");
239     }
240 
241     /**
242      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
243      * division by zero. The result is rounded towards zero.
244      *
245      * Counterpart to Solidity's `/` operator. Note: this function uses a
246      * `revert` opcode (which leaves remaining gas untouched) while Solidity
247      * uses an invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      * - The divisor cannot be zero.
251      *
252      * _Available since v2.4.0._
253      */
254     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         // Solidity only automatically asserts when dividing by 0
256         require(b > 0, errorMessage);
257         uint256 c = a / b;
258         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275         return mod(a, b, "SafeMath: modulo by zero");
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * Reverts with custom message when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      * - The divisor cannot be zero.
288      *
289      * _Available since v2.4.0._
290      */
291     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b != 0, errorMessage);
293         return a % b;
294     }
295 }
296 library SafeERC20 {
297     using SafeMath for uint256;
298     using Address for address;
299 
300     function safeTransfer(IERC20 token, address to, uint256 value) internal {
301         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
302     }
303 
304     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
305         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
306     }
307 
308     function safeApprove(IERC20 token, address spender, uint256 value) internal {
309         // safeApprove should only be called when setting an initial allowance,
310         // or when resetting it to zero. To increase and decrease it, use
311         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
312         // solhint-disable-next-line max-line-length
313         require((value == 0) || (token.allowance(address(this), spender) == 0),
314             "SafeERC20: approve from non-zero to non-zero allowance"
315         );
316         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
317     }
318 
319     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
320         uint256 newAllowance = token.allowance(address(this), spender).add(value);
321         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
322     }
323 
324     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
326         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     /**
330      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
331      * on the return value: the return value is optional (but if data is returned, it must not be false).
332      * @param token The token targeted by the call.
333      * @param data The call data (encoded using abi.encode or one of its variants).
334      */
335     function callOptionalReturn(IERC20 token, bytes memory data) private {
336         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
337         // we're implementing it ourselves.
338 
339         // A Solidity high level call has three parts:
340         //  1. The target address is checked to verify it contains contract code
341         //  2. The call itself is made, and success asserted
342         //  3. The return value is decoded, which in turn checks the size of the returned data.
343         // solhint-disable-next-line max-line-length
344         require(address(token).isContract(), "SafeERC20: call to non-contract");
345 
346         // solhint-disable-next-line avoid-low-level-calls
347         (bool success, bytes memory returndata) = address(token).call(data);
348         require(success, "SafeERC20: low-level call failed");
349 
350         if (returndata.length > 0) { // Return data is optional
351             // solhint-disable-next-line max-line-length
352             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
353         }
354     }
355 }
356 contract TokenTimelock {
357   using SafeERC20 for IERC20;
358 
359   // ERC20 basic token contract being held
360   IERC20 private _token;
361 
362   // beneficiary of tokens after they are released
363   address private _beneficiary;
364 
365   // timestamp when token release is enabled
366   uint256 private _releaseTime;
367 
368   // generator of the tokenLock
369   address private _owner;
370   bool private _ownable;
371 
372   event UnLock(address _receiver, uint256 _amount);
373 
374   constructor(IERC20 token, address beneficiary, uint256 releaseTime) public {
375     _token = token;
376     _beneficiary = beneficiary;
377     _releaseTime = releaseTime;
378   }
379 
380   /**
381    * @return the token being held.
382    */
383   function token() public view returns (IERC20) {
384     return _token;
385   }
386 
387   /**
388    * @return the beneficiary of the tokens.
389    */
390   function beneficiary() public view returns (address) {
391     return _beneficiary;
392   }
393 
394   /**
395    * @return the time when the tokens are released.
396    */
397   function releaseTime() public view returns (uint256) {
398     return _releaseTime;
399   }
400 
401   /**
402    * @notice Transfers tokens held by timelock to beneficiary.
403    */
404   function release() public {
405     require(block.timestamp >= _releaseTime);
406 
407     uint256 amount = _token.balanceOf(address(this));
408     require(amount > 0);
409 
410     _token.safeTransfer(_beneficiary, amount);
411     emit UnLock(_beneficiary, amount);
412   }
413 }
414 /*
415  * @dev Provides information about the current execution context, including the
416  * sender of the transaction and its data. While these are generally available
417  * via msg.sender and msg.data, they should not be accessed in such a direct
418  * manner, since when dealing with GSN meta-transactions the account sending and
419  * paying for execution may not be the actual sender (as far as an application
420  * is concerned).
421  *
422  * This contract is only required for intermediate, library-like contracts.
423  */
424 contract Context {
425     // Empty internal constructor, to prevent people from mistakenly deploying
426     // an instance of this contract, which should be used via inheritance.
427     constructor () internal { }
428     // solhint-disable-previous-line no-empty-blocks
429 
430     function _msgSender() internal view returns (address payable) {
431         return msg.sender;
432     }
433 
434     function _msgData() internal view returns (bytes memory) {
435         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
436         return msg.data;
437     }
438 }
439 
440 
441 
442 
443 
444 contract Lockable {
445     bool public    m_bIsLock;
446 
447     address public m_aOwner;
448     mapping( address => bool ) public m_mLockAddress;
449 
450     event Locked(address a_aLockAddress, bool a_bStatus);
451 
452     modifier IsOwner {
453         require(m_aOwner == msg.sender);
454         _;
455     }
456 
457 
458     modifier CheckLockAddress {
459         if (m_mLockAddress[msg.sender]) {
460             revert();
461         }
462         _;
463     }
464 
465     constructor() public {
466         m_bIsLock   = true;
467         m_aOwner    = msg.sender;
468     }
469 
470 
471     function SetLockAddress(address a_aLockAddress, bool a_bStatus)
472     external
473     IsOwner
474     {
475         require(m_aOwner != a_aLockAddress);
476 
477         m_mLockAddress[a_aLockAddress] = a_bStatus;
478         
479         emit Locked(a_aLockAddress, a_bStatus);
480     }
481 }
482 
483 
484 
485 /**
486  * @dev Implementation of the {IERC20} interface.
487  *
488  * This implementation is agnostic to the way tokens are created. This means
489  * that a supply mechanism has to be added in a derived contract using {_mint}.
490  * For a generic mechanism see {ERC20Mintable}.
491  *
492  * TIP: For a detailed writeup see our guide
493  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
494  * to implement supply mechanisms].
495  *
496  * We have followed general OpenZeppelin guidelines: functions revert instead
497  * of returning `false` on failure. This behavior is nonetheless conventional
498  * and does not conflict with the expectations of ERC20 applications.
499  *
500  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
501  * This allows applications to reconstruct the allowance for all accounts just
502  * by listening to said events. Other implementations of the EIP may not emit
503  * these events, as it isn't required by the specification.
504  *
505  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
506  * functions have been added to mitigate the well-known issues around setting
507  * allowances. See {IERC20-approve}.
508  */
509 contract ERC20 is Context, IERC20, Lockable {
510     using SafeMath for uint256;
511 
512     mapping (address => uint256) private _balances;
513 
514     mapping (address => mapping (address => uint256)) private _allowances;
515 
516     uint256 private _totalSupply;
517 
518     /**
519      * @dev See {IERC20-totalSupply}.
520      */
521     function totalSupply() public view returns (uint256) {
522         return _totalSupply;
523     }
524 
525     /**
526      * @dev See {IERC20-balanceOf}.
527      */
528     function balanceOf(address account) public view returns (uint256) {
529         return _balances[account];
530     }
531 
532     /**
533      * @dev See {IERC20-transfer}.
534      *
535      * Requirements:
536      *
537      * - `recipient` cannot be the zero address.
538      * - the caller must have a balance of at least `amount`.
539      */
540     /*
541     function transfer(address recipient, uint256 amount) public returns (bool) {
542         _transfer(_msgSender(), recipient, amount);
543         return true;
544     }
545     */
546 
547     function transfer(address recipient, uint256 amount) 
548     CheckLockAddress
549     public returns (bool success) {
550         _transfer(_msgSender(), recipient, amount);
551         return true;
552 
553     }
554 
555 
556 
557     /**
558      * @dev See {IERC20-allowance}.
559      */
560     function allowance(address owner, address spender) public view returns (uint256) {
561         return _allowances[owner][spender];
562     }
563 
564     /**
565      * @dev See {IERC20-approve}.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      */
571     function approve(address spender, uint256 amount) public returns (bool) {
572         _approve(_msgSender(), spender, amount);
573         return true;
574     }
575 
576     /**
577      * @dev See {IERC20-transferFrom}.
578      *
579      * Emits an {Approval} event indicating the updated allowance. This is not
580      * required by the EIP. See the note at the beginning of {ERC20};
581      *
582      * Requirements:
583      * - `sender` and `recipient` cannot be the zero address.
584      * - `sender` must have a balance of at least `amount`.
585      * - the caller must have allowance for `sender`'s tokens of at least
586      * `amount`.
587      */
588     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
589         _transfer(sender, recipient, amount);
590         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
591         return true;
592     }
593 
594     /**
595      * @dev Atomically increases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      */
606     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
607         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
608         return true;
609     }
610 
611     /**
612      * @dev Atomically decreases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      * - `spender` must have allowance for the caller of at least
623      * `subtractedValue`.
624      */
625     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
626         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
627         return true;
628     }
629 
630     /**
631      * @dev Moves tokens `amount` from `sender` to `recipient`.
632      *
633      * This is internal function is equivalent to {transfer}, and can be used to
634      * e.g. implement automatic token fees, slashing mechanisms, etc.
635      *
636      * Emits a {Transfer} event.
637      *
638      * Requirements:
639      *
640      * - `sender` cannot be the zero address.
641      * - `recipient` cannot be the zero address.
642      * - `sender` must have a balance of at least `amount`.
643      */
644     function _transfer(address sender, address recipient, uint256 amount) internal {
645         require(sender != address(0), "ERC20: transfer from the zero address");
646         require(recipient != address(0), "ERC20: transfer to the zero address");
647 
648         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
649         _balances[recipient] = _balances[recipient].add(amount);
650         emit Transfer(sender, recipient, amount);
651     }
652 
653     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
654      * the total supply.
655      *
656      * Emits a {Transfer} event with `from` set to the zero address.
657      *
658      * Requirements
659      *
660      * - `to` cannot be the zero address.
661      */
662     function _mint(address account, uint256 amount) internal {
663         require(account != address(0), "ERC20: mint to the zero address");
664 
665         _totalSupply = _totalSupply.add(amount);
666         _balances[account] = _balances[account].add(amount);
667         emit Transfer(address(0), account, amount);
668     }
669 
670     /**
671      * @dev Destroys `amount` tokens from `account`, reducing the
672      * total supply.
673      *
674      * Emits a {Transfer} event with `to` set to the zero address.
675      *
676      * Requirements
677      *
678      * - `account` cannot be the zero address.
679      * - `account` must have at least `amount` tokens.
680      */
681     function _burn(address account, uint256 amount) internal {
682         require(account != address(0), "ERC20: burn from the zero address");
683 
684         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
685         _totalSupply = _totalSupply.sub(amount);
686         emit Transfer(account, address(0), amount);
687     }
688 
689     /**
690      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
691      *
692      * This is internal function is equivalent to `approve`, and can be used to
693      * e.g. set automatic allowances for certain subsystems, etc.
694      *
695      * Emits an {Approval} event.
696      *
697      * Requirements:
698      *
699      * - `owner` cannot be the zero address.
700      * - `spender` cannot be the zero address.
701      */
702     function _approve(address owner, address spender, uint256 amount) internal {
703         require(owner != address(0), "ERC20: approve from the zero address");
704         require(spender != address(0), "ERC20: approve to the zero address");
705 
706         _allowances[owner][spender] = amount;
707         emit Approval(owner, spender, amount);
708     }
709 
710     /**
711      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
712      * from the caller's allowance.
713      *
714      * See {_burn} and {_approve}.
715      */
716     function _burnFrom(address account, uint256 amount) internal {
717         _burn(account, amount);
718         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
719     }
720     
721     function _multiTransfer(address[] memory _to, uint256[] memory _amount) internal {
722         require(_to.length == _amount.length);
723 
724         uint256 ui;
725         uint256 amountSum = 0;
726     
727         for (ui = 0; ui < _to.length; ui++) {
728             require(_to[ui] != address(0));
729 
730             amountSum = amountSum.add(_amount[ui]);
731         }
732 
733         require(amountSum <= _balances[msg.sender]);
734 
735         for (ui = 0; ui < _to.length; ui++) {
736             _balances[msg.sender] = _balances[msg.sender].sub(_amount[ui]);
737             _balances[_to[ui]] = _balances[_to[ui]].add(_amount[ui]);
738         
739             emit Transfer(msg.sender, _to[ui], _amount[ui]);
740         }
741     }
742 }
743 /**
744  * @dev Contract module which provides a basic access control mechanism, where
745  * there is an account (an owner) that can be granted exclusive access to
746  * specific functions.
747  *
748  * This module is used through inheritance. It will make available the modifier
749  * `onlyOwner`, which can be applied to your functions to restrict their use to
750  * the owner.
751  */
752 contract Ownable is Context {
753     address private _owner;
754 
755     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
756 
757     /**
758      * @dev Initializes the contract setting the deployer as the initial owner.
759      */
760     constructor () internal {
761         address msgSender = _msgSender();
762         _owner = msgSender;
763         emit OwnershipTransferred(address(0), msgSender);
764     }
765 
766     /**
767      * @dev Returns the address of the current owner.
768      */
769     function owner() public view returns (address) {
770         return _owner;
771     }
772 
773     /**
774      * @dev Throws if called by any account other than the owner.
775      */
776     modifier onlyOwner() {
777         require(isOwner(), "Ownable: caller is not the owner");
778         _;
779     }
780 
781     /**
782      * @dev Returns true if the caller is the current owner.
783      */
784     function isOwner() public view returns (bool) {
785         return _msgSender() == _owner;
786     }
787 
788     /**
789      * @dev Leaves the contract without owner. It will not be possible to call
790      * `onlyOwner` functions anymore. Can only be called by the current owner.
791      *
792      * NOTE: Renouncing ownership will leave the contract without an owner,
793      * thereby removing any functionality that is only available to the owner.
794      */
795     function renounceOwnership() public onlyOwner {
796         emit OwnershipTransferred(_owner, address(0));
797         _owner = address(0);
798     }
799 
800     /**
801      * @dev Transfers ownership of the contract to a new account (`newOwner`).
802      * Can only be called by the current owner.
803      */
804     function transferOwnership(address newOwner) public onlyOwner {
805         _transferOwnership(newOwner);
806     }
807 
808     /**
809      * @dev Transfers ownership of the contract to a new account (`newOwner`).
810      */
811     function _transferOwnership(address newOwner) internal {
812         require(newOwner != address(0), "Ownable: new owner is the zero address");
813         emit OwnershipTransferred(_owner, newOwner);
814         _owner = newOwner;
815     }
816 }
817 /**
818  * @title Roles
819  * @dev Library for managing addresses assigned to a Role.
820  */
821 library Roles {
822     struct Role {
823         mapping (address => bool) bearer;
824     }
825 
826     /**
827      * @dev Give an account access to this role.
828      */
829     function add(Role storage role, address account) internal {
830         require(!has(role, account), "Roles: account already has role");
831         role.bearer[account] = true;
832     }
833 
834     /**
835      * @dev Remove an account's access to this role.
836      */
837     function remove(Role storage role, address account) internal {
838         require(has(role, account), "Roles: account does not have role");
839         role.bearer[account] = false;
840     }
841 
842     /**
843      * @dev Check if an account has this role.
844      * @return bool
845      */
846     function has(Role storage role, address account) internal view returns (bool) {
847         require(account != address(0), "Roles: account is the zero address");
848         return role.bearer[account];
849     }
850 }
851 contract PauserRole is Context {
852     using Roles for Roles.Role;
853 
854     event PauserAdded(address indexed account);
855     event PauserRemoved(address indexed account);
856 
857     Roles.Role private _pausers;
858 
859     constructor () internal {
860         _addPauser(_msgSender());
861     }
862 
863     modifier onlyPauser() {
864         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
865         _;
866     }
867 
868     function isPauser(address account) public view returns (bool) {
869         return _pausers.has(account);
870     }
871 
872     function addPauser(address account) public onlyPauser {
873         _addPauser(account);
874     }
875 
876     function renouncePauser() public {
877         _removePauser(_msgSender());
878     }
879 
880     function _addPauser(address account) internal {
881         _pausers.add(account);
882         emit PauserAdded(account);
883     }
884 
885     function _removePauser(address account) internal {
886         _pausers.remove(account);
887         emit PauserRemoved(account);
888     }
889 }
890 /**
891  * @dev Contract module which allows children to implement an emergency stop
892  * mechanism that can be triggered by an authorized account.
893  *
894  * This module is used through inheritance. It will make available the
895  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
896  * the functions of your contract. Note that they will not be pausable by
897  * simply including this module, only once the modifiers are put in place.
898  */
899 contract Pausable is Context, PauserRole {
900     /**
901      * @dev Emitted when the pause is triggered by a pauser (`account`).
902      */
903     event Paused(address account);
904 
905     /**
906      * @dev Emitted when the pause is lifted by a pauser (`account`).
907      */
908     event Unpaused(address account);
909 
910     bool private _paused;
911 
912     /**
913      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
914      * to the deployer.
915      */
916     constructor () internal {
917         _paused = false;
918     }
919 
920     /**
921      * @dev Returns true if the contract is paused, and false otherwise.
922      */
923     function paused() public view returns (bool) {
924         return _paused;
925     }
926 
927     /**
928      * @dev Modifier to make a function callable only when the contract is not paused.
929      */
930     modifier whenNotPaused() {
931         require(!_paused, "Pausable: paused");
932         _;
933     }
934 
935     /**
936      * @dev Modifier to make a function callable only when the contract is paused.
937      */
938     modifier whenPaused() {
939         require(_paused, "Pausable: not paused");
940         _;
941     }
942 
943     /**
944      * @dev Called by a pauser to pause, triggers stopped state.
945      */
946     function pause() public onlyPauser whenNotPaused {
947         _paused = true;
948         emit Paused(_msgSender());
949     }
950 
951     /**
952      * @dev Called by a pauser to unpause, returns to normal state.
953      */
954     function unpause() public onlyPauser whenPaused {
955         _paused = false;
956         emit Unpaused(_msgSender());
957     }
958 }
959 /**
960  * @title Pausable token
961  * @dev ERC20 with pausable transfers and allowances.
962  *
963  * Useful if you want to stop trades until the end of a crowdsale, or have
964  * an emergency switch for freezing all token transfers in the event of a large
965  * bug.
966  */
967 contract ERC20Pausable is ERC20, Pausable {
968     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
969         return super.transfer(to, value);
970     }
971 
972     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
973         return super.transferFrom(from, to, value);
974     }
975 
976     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
977         return super.approve(spender, value);
978     }
979 
980     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
981         return super.increaseAllowance(spender, addedValue);
982     }
983 
984     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
985         return super.decreaseAllowance(spender, subtractedValue);
986     }
987 }
988 /**
989  * @dev Extension of {ERC20} that allows token holders to destroy both their own
990  * tokens and those that they have an allowance for, in a way that can be
991  * recognized off-chain (via event analysis).
992  */
993 contract ERC20Burnable is Context, ERC20 {
994     /**
995      * @dev Destroys `amount` tokens from the caller.
996      *
997      * See {ERC20-_burn}.
998      */
999     function burn(uint256 amount) public {
1000         _burn(_msgSender(), amount);
1001     }
1002 
1003     /**
1004      * @dev See {ERC20-_burnFrom}.
1005      */
1006     function burnFrom(address account, uint256 amount) public {
1007         _burnFrom(account, amount);
1008     }
1009 }
1010 contract MinterRole is Context {
1011     using Roles for Roles.Role;
1012 
1013     event MinterAdded(address indexed account);
1014     event MinterRemoved(address indexed account);
1015 
1016     Roles.Role private _minters;
1017 
1018     constructor () internal {
1019         _addMinter(_msgSender());
1020     }
1021 
1022     modifier onlyMinter() {
1023         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1024         _;
1025     }
1026 
1027     function isMinter(address account) public view returns (bool) {
1028         return _minters.has(account);
1029     }
1030 
1031     function addMinter(address account) public onlyMinter {
1032         _addMinter(account);
1033     }
1034 
1035     function renounceMinter() public {
1036         _removeMinter(_msgSender());
1037     }
1038 
1039     function _addMinter(address account) internal {
1040         _minters.add(account);
1041         emit MinterAdded(account);
1042     }
1043 
1044     function _removeMinter(address account) internal {
1045         _minters.remove(account);
1046         emit MinterRemoved(account);
1047     }
1048 }
1049 /**
1050  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1051  * which have permission to mint (create) new tokens as they see fit.
1052  *
1053  * At construction, the deployer of the contract is the only minter.
1054  */
1055 contract ERC20Mintable is ERC20, MinterRole {
1056     /**
1057      * @dev See {ERC20-_mint}.
1058      *
1059      * Requirements:
1060      *
1061      * - the caller must have the {MinterRole}.
1062      */
1063     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1064         _mint(account, amount);
1065         return true;
1066     }
1067 }
1068 // ----------------------------------------------------------------------------
1069 // @title MultiTransfer Token
1070 // @dev Only Admin
1071 // ----------------------------------------------------------------------------
1072 contract MultiTransferToken is ERC20, Ownable {
1073 
1074     function multiTransfer(address[] memory _to, uint256[] memory _amount) onlyOwner public returns (bool) {
1075         _multiTransfer(_to, _amount);
1076     
1077         return true;
1078     }
1079 }
1080 
1081 
1082 contract MultiSigWallet {
1083     event Deposit(address indexed sender, uint amount, uint balance);
1084     event SubmitTransaction(
1085         address indexed owner,
1086         uint indexed txIndex,
1087         address indexed to,
1088         uint value,
1089         bytes data
1090     );
1091     event ConfirmTransaction(address indexed owner, uint indexed txIndex);
1092     event RevokeConfirmation(address indexed owner, uint indexed txIndex);
1093     event ExecuteTransaction(address indexed owner, uint indexed txIndex);
1094 
1095     address[] public owners;
1096     mapping(address => bool) public isOwner;
1097     uint public numConfirmationsRequired;
1098 
1099     struct Transaction {
1100         address to;
1101         uint value;
1102         bytes data;
1103         bool executed;
1104         mapping(address => bool) isConfirmed;
1105         uint numConfirmations;
1106     }
1107 
1108     Transaction[] public transactions;
1109 
1110     modifier onlyOwner() {
1111         require(isOwner[msg.sender], "not owner");
1112         _;
1113     }
1114 
1115     modifier txExists(uint _txIndex) {
1116         require(_txIndex < transactions.length, "tx does not exist");
1117         _;
1118     }
1119 
1120     modifier notExecuted(uint _txIndex) {
1121         require(!transactions[_txIndex].executed, "tx already executed");
1122         _;
1123     }
1124 
1125     modifier notConfirmed(uint _txIndex) {
1126         require(!transactions[_txIndex].isConfirmed[msg.sender], "tx already confirmed");
1127         _;
1128     }
1129 
1130     constructor(address[] memory _owners, uint _numConfirmationsRequired) public {
1131         require(_owners.length > 0, "owners required");
1132         require(
1133             _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
1134             "invalid number of required confirmations"
1135         );
1136 
1137         for (uint i = 0; i < _owners.length; i++) {
1138             address owner = _owners[i];
1139 
1140             require(owner != address(0), "invalid owner");
1141             require(!isOwner[owner], "owner not unique");
1142 
1143             isOwner[owner] = true;
1144             owners.push(owner);
1145         }
1146 
1147         numConfirmationsRequired = _numConfirmationsRequired;
1148     }
1149 
1150     function () payable external {
1151         emit Deposit(msg.sender, msg.value, address(this).balance);
1152     }
1153 
1154     function submitTransaction(address _to, uint _value, bytes memory _data)
1155         public
1156         onlyOwner
1157     {
1158         uint txIndex = transactions.length;
1159 
1160         transactions.push(Transaction({
1161             to: _to,
1162             value: _value,
1163             data: _data,
1164             executed: false,
1165             numConfirmations: 0
1166         }));
1167 
1168         emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
1169     }
1170 
1171     function confirmTransaction(uint _txIndex)
1172         public
1173         onlyOwner
1174         txExists(_txIndex)
1175         notExecuted(_txIndex)
1176         notConfirmed(_txIndex)
1177     {
1178         Transaction storage transaction = transactions[_txIndex];
1179 
1180         transaction.isConfirmed[msg.sender] = true;
1181         transaction.numConfirmations += 1;
1182 
1183         emit ConfirmTransaction(msg.sender, _txIndex);
1184     }
1185 
1186     function executeTransaction(uint _txIndex)
1187         public
1188         onlyOwner
1189         txExists(_txIndex)
1190         notExecuted(_txIndex)
1191     {
1192         Transaction storage transaction = transactions[_txIndex];
1193 
1194         require(
1195             transaction.numConfirmations >= numConfirmationsRequired,
1196             "cannot execute tx"
1197         );
1198 
1199         transaction.executed = true;
1200 
1201         (bool success, ) = transaction.to.call.value(transaction.value)(transaction.data);
1202         require(success, "tx failed");
1203 
1204         emit ExecuteTransaction(msg.sender, _txIndex);
1205     }
1206 
1207     function revokeConfirmation(uint _txIndex)
1208         public
1209         onlyOwner
1210         txExists(_txIndex)
1211         notExecuted(_txIndex)
1212     {
1213         Transaction storage transaction = transactions[_txIndex];
1214 
1215         require(transaction.isConfirmed[msg.sender], "tx not confirmed");
1216 
1217         transaction.isConfirmed[msg.sender] = false;
1218         transaction.numConfirmations -= 1;
1219 
1220         emit RevokeConfirmation(msg.sender, _txIndex);
1221     }
1222 
1223     function getOwners() public view returns (address[] memory) {
1224         return owners;
1225     }
1226 
1227     function getTransactionCount() public view returns (uint) {
1228         return transactions.length;
1229     }
1230 
1231     function getTransaction(uint _txIndex)
1232         public
1233         view
1234         returns (address to, uint value, bytes memory data, bool executed, uint numConfirmations)
1235     {
1236         Transaction storage transaction = transactions[_txIndex];
1237 
1238         return (
1239             transaction.to,
1240             transaction.value,
1241             transaction.data,
1242             transaction.executed,
1243             transaction.numConfirmations
1244         );
1245     }
1246 
1247     function isConfirmed(uint _txIndex, address _owner)
1248         public
1249         view
1250         returns (bool)
1251     {
1252         Transaction storage transaction = transactions[_txIndex];
1253 
1254         return transaction.isConfirmed[_owner];
1255     }
1256 }
1257 
1258 
1259 
1260 
1261 contract QuiztokToken is ERC20Pausable, ERC20Burnable, ERC20Mintable, MultiTransferToken  {
1262   string public constant name = "Quiztok Token";
1263   string public constant symbol = "QTCON";
1264   uint public constant decimals = 18;
1265 
1266 
1267   address public quizTokMultisig;
1268 
1269 
1270   // Lock
1271   mapping (address => address) public lockStatus;
1272   event Lock(address _receiver, uint256 _amount);
1273 
1274   // Airdrop
1275   mapping (address => uint256) public airDropHistory;
1276   event AirDrop(address _receiver, uint256 _amount);
1277 
1278   //constructor() public {}
1279    constructor () public {
1280       _mint(msg.sender, 60000000000 * 10 ** uint256(decimals)); 
1281    }
1282 
1283   function dropToken(address[] memory receivers, uint256[] memory values) public {
1284     require(receivers.length != 0);
1285     require(receivers.length == values.length);
1286 
1287     for (uint256 i = 0; i < receivers.length; i++) {
1288       address receiver = receivers[i];
1289       uint256 amount = values[i];
1290 
1291       transfer(receiver, amount);
1292       airDropHistory[receiver] += amount;
1293 
1294       emit AirDrop(receiver, amount);
1295     }
1296   }
1297 
1298   function timeLockToken(address beneficiary, uint256 amount, uint256 releaseTime) onlyOwner public {
1299     TokenTimelock lockContract = new TokenTimelock(this, beneficiary, releaseTime);
1300 
1301     transfer(address(lockContract), amount);
1302     lockStatus[beneficiary] = address(lockContract);
1303     emit Lock(beneficiary, amount);
1304   }
1305 
1306 
1307 
1308 }