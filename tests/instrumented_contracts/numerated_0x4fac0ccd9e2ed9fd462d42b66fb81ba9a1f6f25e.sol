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
439 /**
440  * @dev Implementation of the {IERC20} interface.
441  *
442  * This implementation is agnostic to the way tokens are created. This means
443  * that a supply mechanism has to be added in a derived contract using {_mint}.
444  * For a generic mechanism see {ERC20Mintable}.
445  *
446  * TIP: For a detailed writeup see our guide
447  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
448  * to implement supply mechanisms].
449  *
450  * We have followed general OpenZeppelin guidelines: functions revert instead
451  * of returning `false` on failure. This behavior is nonetheless conventional
452  * and does not conflict with the expectations of ERC20 applications.
453  *
454  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
455  * This allows applications to reconstruct the allowance for all accounts just
456  * by listening to said events. Other implementations of the EIP may not emit
457  * these events, as it isn't required by the specification.
458  *
459  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
460  * functions have been added to mitigate the well-known issues around setting
461  * allowances. See {IERC20-approve}.
462  */
463 contract ERC20 is Context, IERC20 {
464     using SafeMath for uint256;
465 
466     mapping (address => uint256) private _balances;
467 
468     mapping (address => mapping (address => uint256)) private _allowances;
469 
470     uint256 private _totalSupply;
471 
472     /**
473      * @dev See {IERC20-totalSupply}.
474      */
475     function totalSupply() public view returns (uint256) {
476         return _totalSupply;
477     }
478 
479     /**
480      * @dev See {IERC20-balanceOf}.
481      */
482     function balanceOf(address account) public view returns (uint256) {
483         return _balances[account];
484     }
485 
486     /**
487      * @dev See {IERC20-transfer}.
488      *
489      * Requirements:
490      *
491      * - `recipient` cannot be the zero address.
492      * - the caller must have a balance of at least `amount`.
493      */
494     function transfer(address recipient, uint256 amount) public returns (bool) {
495         _transfer(_msgSender(), recipient, amount);
496         return true;
497     }
498 
499     /**
500      * @dev See {IERC20-allowance}.
501      */
502     function allowance(address owner, address spender) public view returns (uint256) {
503         return _allowances[owner][spender];
504     }
505 
506     /**
507      * @dev See {IERC20-approve}.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      */
513     function approve(address spender, uint256 amount) public returns (bool) {
514         _approve(_msgSender(), spender, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-transferFrom}.
520      *
521      * Emits an {Approval} event indicating the updated allowance. This is not
522      * required by the EIP. See the note at the beginning of {ERC20};
523      *
524      * Requirements:
525      * - `sender` and `recipient` cannot be the zero address.
526      * - `sender` must have a balance of at least `amount`.
527      * - the caller must have allowance for `sender`'s tokens of at least
528      * `amount`.
529      */
530     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
531         _transfer(sender, recipient, amount);
532         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
533         return true;
534     }
535 
536     /**
537      * @dev Atomically increases the allowance granted to `spender` by the caller.
538      *
539      * This is an alternative to {approve} that can be used as a mitigation for
540      * problems described in {IERC20-approve}.
541      *
542      * Emits an {Approval} event indicating the updated allowance.
543      *
544      * Requirements:
545      *
546      * - `spender` cannot be the zero address.
547      */
548     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
549         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
550         return true;
551     }
552 
553     /**
554      * @dev Atomically decreases the allowance granted to `spender` by the caller.
555      *
556      * This is an alternative to {approve} that can be used as a mitigation for
557      * problems described in {IERC20-approve}.
558      *
559      * Emits an {Approval} event indicating the updated allowance.
560      *
561      * Requirements:
562      *
563      * - `spender` cannot be the zero address.
564      * - `spender` must have allowance for the caller of at least
565      * `subtractedValue`.
566      */
567     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
568         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
569         return true;
570     }
571 
572     /**
573      * @dev Moves tokens `amount` from `sender` to `recipient`.
574      *
575      * This is internal function is equivalent to {transfer}, and can be used to
576      * e.g. implement automatic token fees, slashing mechanisms, etc.
577      *
578      * Emits a {Transfer} event.
579      *
580      * Requirements:
581      *
582      * - `sender` cannot be the zero address.
583      * - `recipient` cannot be the zero address.
584      * - `sender` must have a balance of at least `amount`.
585      */
586     function _transfer(address sender, address recipient, uint256 amount) internal {
587         require(sender != address(0), "ERC20: transfer from the zero address");
588         require(recipient != address(0), "ERC20: transfer to the zero address");
589 
590         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
591         _balances[recipient] = _balances[recipient].add(amount);
592         emit Transfer(sender, recipient, amount);
593     }
594 
595     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
596      * the total supply.
597      *
598      * Emits a {Transfer} event with `from` set to the zero address.
599      *
600      * Requirements
601      *
602      * - `to` cannot be the zero address.
603      */
604     function _mint(address account, uint256 amount) internal {
605         require(account != address(0), "ERC20: mint to the zero address");
606 
607         _totalSupply = _totalSupply.add(amount);
608         _balances[account] = _balances[account].add(amount);
609         emit Transfer(address(0), account, amount);
610     }
611 
612     /**
613      * @dev Destroys `amount` tokens from `account`, reducing the
614      * total supply.
615      *
616      * Emits a {Transfer} event with `to` set to the zero address.
617      *
618      * Requirements
619      *
620      * - `account` cannot be the zero address.
621      * - `account` must have at least `amount` tokens.
622      */
623     function _burn(address account, uint256 amount) internal {
624         require(account != address(0), "ERC20: burn from the zero address");
625 
626         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
627         _totalSupply = _totalSupply.sub(amount);
628         emit Transfer(account, address(0), amount);
629     }
630 
631     /**
632      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
633      *
634      * This is internal function is equivalent to `approve`, and can be used to
635      * e.g. set automatic allowances for certain subsystems, etc.
636      *
637      * Emits an {Approval} event.
638      *
639      * Requirements:
640      *
641      * - `owner` cannot be the zero address.
642      * - `spender` cannot be the zero address.
643      */
644     function _approve(address owner, address spender, uint256 amount) internal {
645         require(owner != address(0), "ERC20: approve from the zero address");
646         require(spender != address(0), "ERC20: approve to the zero address");
647 
648         _allowances[owner][spender] = amount;
649         emit Approval(owner, spender, amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
654      * from the caller's allowance.
655      *
656      * See {_burn} and {_approve}.
657      */
658     function _burnFrom(address account, uint256 amount) internal {
659         _burn(account, amount);
660         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
661     }
662     
663     function _multiTransfer(address[] memory _to, uint256[] memory _amount) internal {
664         require(_to.length == _amount.length);
665 
666         uint256 ui;
667         uint256 amountSum = 0;
668     
669         for (ui = 0; ui < _to.length; ui++) {
670             require(_to[ui] != address(0));
671 
672             amountSum = amountSum.add(_amount[ui]);
673         }
674 
675         require(amountSum <= _balances[msg.sender]);
676 
677         for (ui = 0; ui < _to.length; ui++) {
678             _balances[msg.sender] = _balances[msg.sender].sub(_amount[ui]);
679             _balances[_to[ui]] = _balances[_to[ui]].add(_amount[ui]);
680         
681             emit Transfer(msg.sender, _to[ui], _amount[ui]);
682         }
683     }
684 }
685 /**
686  * @dev Contract module which provides a basic access control mechanism, where
687  * there is an account (an owner) that can be granted exclusive access to
688  * specific functions.
689  *
690  * This module is used through inheritance. It will make available the modifier
691  * `onlyOwner`, which can be applied to your functions to restrict their use to
692  * the owner.
693  */
694 contract Ownable is Context {
695     address private _owner;
696 
697     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
698 
699     /**
700      * @dev Initializes the contract setting the deployer as the initial owner.
701      */
702     constructor () internal {
703         address msgSender = _msgSender();
704         _owner = msgSender;
705         emit OwnershipTransferred(address(0), msgSender);
706     }
707 
708     /**
709      * @dev Returns the address of the current owner.
710      */
711     function owner() public view returns (address) {
712         return _owner;
713     }
714 
715     /**
716      * @dev Throws if called by any account other than the owner.
717      */
718     modifier onlyOwner() {
719         require(isOwner(), "Ownable: caller is not the owner");
720         _;
721     }
722 
723     /**
724      * @dev Returns true if the caller is the current owner.
725      */
726     function isOwner() public view returns (bool) {
727         return _msgSender() == _owner;
728     }
729 
730     /**
731      * @dev Leaves the contract without owner. It will not be possible to call
732      * `onlyOwner` functions anymore. Can only be called by the current owner.
733      *
734      * NOTE: Renouncing ownership will leave the contract without an owner,
735      * thereby removing any functionality that is only available to the owner.
736      */
737     function renounceOwnership() public onlyOwner {
738         emit OwnershipTransferred(_owner, address(0));
739         _owner = address(0);
740     }
741 
742     /**
743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
744      * Can only be called by the current owner.
745      */
746     function transferOwnership(address newOwner) public onlyOwner {
747         _transferOwnership(newOwner);
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      */
753     function _transferOwnership(address newOwner) internal {
754         require(newOwner != address(0), "Ownable: new owner is the zero address");
755         emit OwnershipTransferred(_owner, newOwner);
756         _owner = newOwner;
757     }
758 }
759 /**
760  * @title Roles
761  * @dev Library for managing addresses assigned to a Role.
762  */
763 library Roles {
764     struct Role {
765         mapping (address => bool) bearer;
766     }
767 
768     /**
769      * @dev Give an account access to this role.
770      */
771     function add(Role storage role, address account) internal {
772         require(!has(role, account), "Roles: account already has role");
773         role.bearer[account] = true;
774     }
775 
776     /**
777      * @dev Remove an account's access to this role.
778      */
779     function remove(Role storage role, address account) internal {
780         require(has(role, account), "Roles: account does not have role");
781         role.bearer[account] = false;
782     }
783 
784     /**
785      * @dev Check if an account has this role.
786      * @return bool
787      */
788     function has(Role storage role, address account) internal view returns (bool) {
789         require(account != address(0), "Roles: account is the zero address");
790         return role.bearer[account];
791     }
792 }
793 contract PauserRole is Context {
794     using Roles for Roles.Role;
795 
796     event PauserAdded(address indexed account);
797     event PauserRemoved(address indexed account);
798 
799     Roles.Role private _pausers;
800 
801     constructor () internal {
802         _addPauser(_msgSender());
803     }
804 
805     modifier onlyPauser() {
806         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
807         _;
808     }
809 
810     function isPauser(address account) public view returns (bool) {
811         return _pausers.has(account);
812     }
813 
814     function addPauser(address account) public onlyPauser {
815         _addPauser(account);
816     }
817 
818     function renouncePauser() public {
819         _removePauser(_msgSender());
820     }
821 
822     function _addPauser(address account) internal {
823         _pausers.add(account);
824         emit PauserAdded(account);
825     }
826 
827     function _removePauser(address account) internal {
828         _pausers.remove(account);
829         emit PauserRemoved(account);
830     }
831 }
832 /**
833  * @dev Contract module which allows children to implement an emergency stop
834  * mechanism that can be triggered by an authorized account.
835  *
836  * This module is used through inheritance. It will make available the
837  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
838  * the functions of your contract. Note that they will not be pausable by
839  * simply including this module, only once the modifiers are put in place.
840  */
841 contract Pausable is Context, PauserRole {
842     /**
843      * @dev Emitted when the pause is triggered by a pauser (`account`).
844      */
845     event Paused(address account);
846 
847     /**
848      * @dev Emitted when the pause is lifted by a pauser (`account`).
849      */
850     event Unpaused(address account);
851 
852     bool private _paused;
853 
854     /**
855      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
856      * to the deployer.
857      */
858     constructor () internal {
859         _paused = false;
860     }
861 
862     /**
863      * @dev Returns true if the contract is paused, and false otherwise.
864      */
865     function paused() public view returns (bool) {
866         return _paused;
867     }
868 
869     /**
870      * @dev Modifier to make a function callable only when the contract is not paused.
871      */
872     modifier whenNotPaused() {
873         require(!_paused, "Pausable: paused");
874         _;
875     }
876 
877     /**
878      * @dev Modifier to make a function callable only when the contract is paused.
879      */
880     modifier whenPaused() {
881         require(_paused, "Pausable: not paused");
882         _;
883     }
884 
885     /**
886      * @dev Called by a pauser to pause, triggers stopped state.
887      */
888     function pause() public onlyPauser whenNotPaused {
889         _paused = true;
890         emit Paused(_msgSender());
891     }
892 
893     /**
894      * @dev Called by a pauser to unpause, returns to normal state.
895      */
896     function unpause() public onlyPauser whenPaused {
897         _paused = false;
898         emit Unpaused(_msgSender());
899     }
900 }
901 /**
902  * @title Pausable token
903  * @dev ERC20 with pausable transfers and allowances.
904  *
905  * Useful if you want to stop trades until the end of a crowdsale, or have
906  * an emergency switch for freezing all token transfers in the event of a large
907  * bug.
908  */
909 contract ERC20Pausable is ERC20, Pausable {
910     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
911         return super.transfer(to, value);
912     }
913 
914     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
915         return super.transferFrom(from, to, value);
916     }
917 
918     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
919         return super.approve(spender, value);
920     }
921 
922     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
923         return super.increaseAllowance(spender, addedValue);
924     }
925 
926     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
927         return super.decreaseAllowance(spender, subtractedValue);
928     }
929 }
930 /**
931  * @dev Extension of {ERC20} that allows token holders to destroy both their own
932  * tokens and those that they have an allowance for, in a way that can be
933  * recognized off-chain (via event analysis).
934  */
935 contract ERC20Burnable is Context, ERC20 {
936     /**
937      * @dev Destroys `amount` tokens from the caller.
938      *
939      * See {ERC20-_burn}.
940      */
941     function burn(uint256 amount) public {
942         _burn(_msgSender(), amount);
943     }
944 
945     /**
946      * @dev See {ERC20-_burnFrom}.
947      */
948     function burnFrom(address account, uint256 amount) public {
949         _burnFrom(account, amount);
950     }
951 }
952 contract MinterRole is Context {
953     using Roles for Roles.Role;
954 
955     event MinterAdded(address indexed account);
956     event MinterRemoved(address indexed account);
957 
958     Roles.Role private _minters;
959 
960     constructor () internal {
961         _addMinter(_msgSender());
962     }
963 
964     modifier onlyMinter() {
965         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
966         _;
967     }
968 
969     function isMinter(address account) public view returns (bool) {
970         return _minters.has(account);
971     }
972 
973     function addMinter(address account) public onlyMinter {
974         _addMinter(account);
975     }
976 
977     function renounceMinter() public {
978         _removeMinter(_msgSender());
979     }
980 
981     function _addMinter(address account) internal {
982         _minters.add(account);
983         emit MinterAdded(account);
984     }
985 
986     function _removeMinter(address account) internal {
987         _minters.remove(account);
988         emit MinterRemoved(account);
989     }
990 }
991 /**
992  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
993  * which have permission to mint (create) new tokens as they see fit.
994  *
995  * At construction, the deployer of the contract is the only minter.
996  */
997 contract ERC20Mintable is ERC20, MinterRole {
998     /**
999      * @dev See {ERC20-_mint}.
1000      *
1001      * Requirements:
1002      *
1003      * - the caller must have the {MinterRole}.
1004      */
1005     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1006         _mint(account, amount);
1007         return true;
1008     }
1009 }
1010 // ----------------------------------------------------------------------------
1011 // @title MultiTransfer Token
1012 // @dev Only Admin
1013 // ----------------------------------------------------------------------------
1014 contract MultiTransferToken is ERC20, Ownable {
1015 
1016     function multiTransfer(address[] memory _to, uint256[] memory _amount) onlyOwner public returns (bool) {
1017         _multiTransfer(_to, _amount);
1018     
1019         return true;
1020     }
1021 }
1022 contract AXLCoin is ERC20Pausable, ERC20Burnable, ERC20Mintable, MultiTransferToken {
1023   string public constant name = "AXiaL Entertainment Digital Asset";
1024   string public constant symbol = "AXL";
1025   uint public constant decimals = 18;
1026 
1027   // Lock
1028   mapping (address => address) public lockStatus;
1029   event Lock(address _receiver, uint256 _amount);
1030 
1031   // Airdrop
1032   mapping (address => uint256) public airDropHistory;
1033   event AirDrop(address _receiver, uint256 _amount);
1034 
1035   constructor() public {}
1036 
1037   function dropToken(address[] memory receivers, uint256[] memory values) public {
1038     require(receivers.length != 0);
1039     require(receivers.length == values.length);
1040 
1041     for (uint256 i = 0; i < receivers.length; i++) {
1042       address receiver = receivers[i];
1043       uint256 amount = values[i];
1044 
1045       transfer(receiver, amount);
1046       airDropHistory[receiver] += amount;
1047 
1048       emit AirDrop(receiver, amount);
1049     }
1050   }
1051 
1052   function timeLockToken(address beneficiary, uint256 amount, uint256 releaseTime) onlyOwner public {
1053     TokenTimelock lockContract = new TokenTimelock(this, beneficiary, releaseTime);
1054 
1055     transfer(address(lockContract), amount);
1056     lockStatus[beneficiary] = address(lockContract);
1057     emit Lock(beneficiary, amount);
1058   }
1059 }