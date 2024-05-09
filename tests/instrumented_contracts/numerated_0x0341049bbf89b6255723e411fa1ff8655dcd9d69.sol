1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.6.12;
3 
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies in extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 
144 /**
145  * @dev Wrappers over Solidity's arithmetic operations with added overflow
146  * checks.
147  *
148  * Arithmetic operations in Solidity wrap on overflow. This can easily result
149  * in bugs, because programmers usually assume that an overflow raises an
150  * error, which is the standard behavior in high level programming languages.
151  * `SafeMath` restores this intuition by reverting the transaction when an
152  * operation overflows.
153  *
154  * Using this library instead of the unchecked operations eliminates an entire
155  * class of bugs, so it's recommended to use it always.
156  */
157 library SafeMath {
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a, "SafeMath: addition overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the subtraction of two unsigned integers, reverting on
177      * overflow (when the result is negative).
178      *
179      * Counterpart to Solidity's `-` operator.
180      *
181      * Requirements:
182      *
183      * - Subtraction cannot overflow.
184      */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         return sub(a, b, "SafeMath: subtraction overflow");
187     }
188 
189     /**
190      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
191      * overflow (when the result is negative).
192      *
193      * Counterpart to Solidity's `-` operator.
194      *
195      * Requirements:
196      *
197      * - Subtraction cannot overflow.
198      */
199     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b <= a, errorMessage);
201         uint256 c = a - b;
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the multiplication of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `*` operator.
211      *
212      * Requirements:
213      *
214      * - Multiplication cannot overflow.
215      */
216     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
218         // benefit is lost if 'b' is also tested.
219         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
220         if (a == 0) {
221             return 0;
222         }
223 
224         uint256 c = a * b;
225         require(c / a == b, "SafeMath: multiplication overflow");
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers. Reverts on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         return div(a, b, "SafeMath: division by zero");
244     }
245 
246     /**
247      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
248      * division by zero. The result is rounded towards zero.
249      *
250      * Counterpart to Solidity's `/` operator. Note: this function uses a
251      * `revert` opcode (which leaves remaining gas untouched) while Solidity
252      * uses an invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b > 0, errorMessage);
260         uint256 c = a / b;
261         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
279         return mod(a, b, "SafeMath: modulo by zero");
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * Reverts with custom message when dividing by zero.
285      *
286      * Counterpart to Solidity's `%` operator. This function uses a `revert`
287      * opcode (which leaves remaining gas untouched) while Solidity uses an
288      * invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b != 0, errorMessage);
296         return a % b;
297     }
298 }
299 
300 /*
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with GSN meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address payable) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes memory) {
316         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
317         return msg.data;
318     }
319 }
320 
321 
322 /**
323  * @dev Contract module which provides a basic access control mechanism, where
324  * there is an account (an owner) that can be granted exclusive access to
325  * specific functions.
326  *
327  * By default, the owner account will be the one that deploys the contract. This
328  * can later be changed with {transferOwnership}.
329  *
330  * This module is used through inheritance. It will make available the modifier
331  * `onlyOwner`, which can be applied to your functions to restrict their use to
332  * the owner.
333  */
334 contract Ownable is Context {
335     address private _owner;
336 
337     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
338 
339     /**
340      * @dev Initializes the contract setting the deployer as the initial owner.
341      */
342     constructor () internal {
343         address msgSender = _msgSender();
344         _owner = msgSender;
345         emit OwnershipTransferred(address(0), msgSender);
346     }
347 
348     /**
349      * @dev Returns the address of the current owner.
350      */
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     /**
356      * @dev Throws if called by any account other than the owner.
357      */
358     modifier onlyOwner() {
359         require(_owner == _msgSender(), "Ownable: caller is not the owner");
360         _;
361     }
362 
363     /**
364      * @dev Leaves the contract without owner. It will not be possible to call
365      * `onlyOwner` functions anymore. Can only be called by the current owner.
366      *
367      * NOTE: Renouncing ownership will leave the contract without an owner,
368      * thereby removing any functionality that is only available to the owner.
369      */
370     function renounceOwnership() public virtual onlyOwner {
371         emit OwnershipTransferred(_owner, address(0));
372         _owner = address(0);
373     }
374 
375     /**
376      * @dev Transfers ownership of the contract to a new account (`newOwner`).
377      * Can only be called by the current owner.
378      */
379     function transferOwnership(address newOwner) public virtual onlyOwner {
380         require(newOwner != address(0), "Ownable: new owner is the zero address");
381         emit OwnershipTransferred(_owner, newOwner);
382         _owner = newOwner;
383     }
384 }
385 
386 
387 /**
388  * @title SafeERC20
389  * @dev Wrappers around ERC20 operations that throw on failure (when the token
390  * contract returns false). Tokens that return no value (and instead revert or
391  * throw on failure) are also supported, non-reverting calls are assumed to be
392  * successful.
393  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeERC20 {
397     using SafeMath for uint256;
398     using Address for address;
399 
400     function safeTransfer(IERC20 token, address to, uint256 value) internal {
401         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
402     }
403 
404     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
406     }
407 
408     /**
409      * @dev Deprecated. This function has issues similar to the ones found in
410      * {IERC20-approve}, and its usage is discouraged.
411      *
412      * Whenever possible, use {safeIncreaseAllowance} and
413      * {safeDecreaseAllowance} instead.
414      */
415     function safeApprove(IERC20 token, address spender, uint256 value) internal {
416         // safeApprove should only be called when setting an initial allowance,
417         // or when resetting it to zero. To increase and decrease it, use
418         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
419         // solhint-disable-next-line max-line-length
420         require((value == 0) || (token.allowance(address(this), spender) == 0),
421             "SafeERC20: approve from non-zero to non-zero allowance"
422         );
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
424     }
425 
426     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
427         uint256 newAllowance = token.allowance(address(this), spender).add(value);
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429     }
430 
431     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     /**
437      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
438      * on the return value: the return value is optional (but if data is returned, it must not be false).
439      * @param token The token targeted by the call.
440      * @param data The call data (encoded using abi.encode or one of its variants).
441      */
442     function _callOptionalReturn(IERC20 token, bytes memory data) private {
443         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
444         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
445         // the target address contains contract code and also asserts for success in the low-level call.
446 
447         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
448         if (returndata.length > 0) { // Return data is optional
449             // solhint-disable-next-line max-line-length
450             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
451         }
452     }
453 }
454 
455 /**
456  * @dev Interface of the ERC20 standard as defined in the EIP.
457  */
458 interface IERC20 {
459     /**
460      * @dev Returns the amount of tokens in existence.
461      */
462     function totalSupply() external view returns (uint256);
463 
464     /**
465      * @dev Returns the amount of tokens owned by `account`.
466      */
467     function balanceOf(address account) external view returns (uint256);
468 
469     /**
470      * @dev Moves `amount` tokens from the caller's account to `recipient`.
471      *
472      * Returns a boolean value indicating whether the operation succeeded.
473      *
474      * Emits a {Transfer} event.
475      */
476     function transfer(address recipient, uint256 amount) external returns (bool);
477 
478     /**
479      * @dev Returns the remaining number of tokens that `spender` will be
480      * allowed to spend on behalf of `owner` through {transferFrom}. This is
481      * zero by default.
482      *
483      * This value changes when {approve} or {transferFrom} are called.
484      */
485     function allowance(address owner, address spender) external view returns (uint256);
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
489      *
490      * Returns a boolean value indicating whether the operation succeeded.
491      *
492      * IMPORTANT: Beware that changing an allowance with this method brings the risk
493      * that someone may use both the old and the new allowance by unfortunate
494      * transaction ordering. One possible solution to mitigate this race
495      * condition is to first reduce the spender's allowance to 0 and set the
496      * desired value afterwards:
497      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address spender, uint256 amount) external returns (bool);
502 
503     /**
504      * @dev Moves `amount` tokens from `sender` to `recipient` using the
505      * allowance mechanism. `amount` is then deducted from the caller's
506      * allowance.
507      *
508      * Returns a boolean value indicating whether the operation succeeded.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
513 
514     /**
515      * @dev Emitted when `value` tokens are moved from one account (`from`) to
516      * another (`to`).
517      *
518      * Note that `value` may be zero.
519      */
520     event Transfer(address indexed from, address indexed to, uint256 value);
521 
522     /**
523      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
524      * a call to {approve}. `value` is the new allowance.
525      */
526     event Approval(address indexed owner, address indexed spender, uint256 value);
527 }
528 
529 /**
530  * @dev Implementation of the {IERC20} interface.
531  *
532  * This implementation is agnostic to the way tokens are created. This means
533  * that a supply mechanism has to be added in a derived contract using {_mint}.
534  * For a generic mechanism see {ERC20PresetMinterPauser}.
535  *
536  * TIP: For a detailed writeup see our guide
537  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
538  * to implement supply mechanisms].
539  *
540  * We have followed general OpenZeppelin guidelines: functions revert instead
541  * of returning `false` on failure. This behavior is nonetheless conventional
542  * and does not conflict with the expectations of ERC20 applications.
543  *
544  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
545  * This allows applications to reconstruct the allowance for all accounts just
546  * by listening to said events. Other implementations of the EIP may not emit
547  * these events, as it isn't required by the specification.
548  *
549  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
550  * functions have been added to mitigate the well-known issues around setting
551  * allowances. See {IERC20-approve}.
552  */
553 contract ERC20 is Context, IERC20 {
554     using SafeMath for uint256;
555     using Address for address;
556 
557     mapping (address => uint256) private _balances;
558 
559     mapping (address => mapping (address => uint256)) private _allowances;
560 
561     uint256 private _totalSupply;
562 
563     string private _name;
564     string private _symbol;
565     uint8 private _decimals;
566 
567     /**
568      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
569      * a default value of 18.
570      *
571      * To select a different value for {decimals}, use {_setupDecimals}.
572      *
573      * All three of these values are immutable: they can only be set once during
574      * construction.
575      */
576     constructor (string memory name, string memory symbol) public {
577         _name = name;
578         _symbol = symbol;
579         _decimals = 18;
580     }
581 
582     /**
583      * @dev Returns the name of the token.
584      */
585     function name() public view returns (string memory) {
586         return _name;
587     }
588 
589     /**
590      * @dev Returns the symbol of the token, usually a shorter version of the
591      * name.
592      */
593     function symbol() public view returns (string memory) {
594         return _symbol;
595     }
596 
597     /**
598      * @dev Returns the number of decimals used to get its user representation.
599      * For example, if `decimals` equals `2`, a balance of `505` tokens should
600      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
601      *
602      * Tokens usually opt for a value of 18, imitating the relationship between
603      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
604      * called.
605      *
606      * NOTE: This information is only used for _display_ purposes: it in
607      * no way affects any of the arithmetic of the contract, including
608      * {IERC20-balanceOf} and {IERC20-transfer}.
609      */
610     function decimals() public view returns (uint8) {
611         return _decimals;
612     }
613 
614     /**
615      * @dev See {IERC20-totalSupply}.
616      */
617     function totalSupply() public view override returns (uint256) {
618         return _totalSupply;
619     }
620 
621     /**
622      * @dev See {IERC20-balanceOf}.
623      */
624     function balanceOf(address account) public view override returns (uint256) {
625         return _balances[account];
626     }
627 
628     /**
629      * @dev See {IERC20-transfer}.
630      *
631      * Requirements:
632      *
633      * - `recipient` cannot be the zero address.
634      * - the caller must have a balance of at least `amount`.
635      */
636     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
637         _transfer(_msgSender(), recipient, amount);
638         return true;
639     }
640 
641     /**
642      * @dev See {IERC20-allowance}.
643      */
644     function allowance(address owner, address spender) public view virtual override returns (uint256) {
645         return _allowances[owner][spender];
646     }
647 
648     /**
649      * @dev See {IERC20-approve}.
650      *
651      * Requirements:
652      *
653      * - `spender` cannot be the zero address.
654      */
655     function approve(address spender, uint256 amount) public virtual override returns (bool) {
656         _approve(_msgSender(), spender, amount);
657         return true;
658     }
659 
660     /**
661      * @dev See {IERC20-transferFrom}.
662      *
663      * Emits an {Approval} event indicating the updated allowance. This is not
664      * required by the EIP. See the note at the beginning of {ERC20};
665      *
666      * Requirements:
667      * - `sender` and `recipient` cannot be the zero address.
668      * - `sender` must have a balance of at least `amount`.
669      * - the caller must have allowance for ``sender``'s tokens of at least
670      * `amount`.
671      */
672     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
673         _transfer(sender, recipient, amount);
674         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
675         return true;
676     }
677 
678     /**
679      * @dev Atomically increases the allowance granted to `spender` by the caller.
680      *
681      * This is an alternative to {approve} that can be used as a mitigation for
682      * problems described in {IERC20-approve}.
683      *
684      * Emits an {Approval} event indicating the updated allowance.
685      *
686      * Requirements:
687      *
688      * - `spender` cannot be the zero address.
689      */
690     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
691         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
692         return true;
693     }
694 
695     /**
696      * @dev Atomically decreases the allowance granted to `spender` by the caller.
697      *
698      * This is an alternative to {approve} that can be used as a mitigation for
699      * problems described in {IERC20-approve}.
700      *
701      * Emits an {Approval} event indicating the updated allowance.
702      *
703      * Requirements:
704      *
705      * - `spender` cannot be the zero address.
706      * - `spender` must have allowance for the caller of at least
707      * `subtractedValue`.
708      */
709     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
710         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
711         return true;
712     }
713 
714     /**
715      * @dev Moves tokens `amount` from `sender` to `recipient`.
716      *
717      * This is internal function is equivalent to {transfer}, and can be used to
718      * e.g. implement automatic token fees, slashing mechanisms, etc.
719      *
720      * Emits a {Transfer} event.
721      *
722      * Requirements:
723      *
724      * - `sender` cannot be the zero address.
725      * - `recipient` cannot be the zero address.
726      * - `sender` must have a balance of at least `amount`.
727      */
728     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
729         require(sender != address(0), "ERC20: transfer from the zero address");
730         require(recipient != address(0), "ERC20: transfer to the zero address");
731 
732         _beforeTokenTransfer(sender, recipient, amount);
733 
734         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
735         _balances[recipient] = _balances[recipient].add(amount);
736         emit Transfer(sender, recipient, amount);
737     }
738 
739     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
740      * the total supply.
741      *
742      * Emits a {Transfer} event with `from` set to the zero address.
743      *
744      * Requirements
745      *
746      * - `to` cannot be the zero address.
747      */
748     function _mint(address account, uint256 amount) internal virtual {
749         require(account != address(0), "ERC20: mint to the zero address");
750 
751         _beforeTokenTransfer(address(0), account, amount);
752 
753         _totalSupply = _totalSupply.add(amount);
754         _balances[account] = _balances[account].add(amount);
755         emit Transfer(address(0), account, amount);
756     }
757 
758     /**
759      * @dev Destroys `amount` tokens from `account`, reducing the
760      * total supply.
761      *
762      * Emits a {Transfer} event with `to` set to the zero address.
763      *
764      * Requirements
765      *
766      * - `account` cannot be the zero address.
767      * - `account` must have at least `amount` tokens.
768      */
769     function _burn(address account, uint256 amount) internal virtual {
770         require(account != address(0), "ERC20: burn from the zero address");
771 
772         _beforeTokenTransfer(account, address(0), amount);
773 
774         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
775         _totalSupply = _totalSupply.sub(amount);
776         emit Transfer(account, address(0), amount);
777     }
778 
779     /**
780      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
781      *
782      * This internal function is equivalent to `approve`, and can be used to
783      * e.g. set automatic allowances for certain subsystems, etc.
784      *
785      * Emits an {Approval} event.
786      *
787      * Requirements:
788      *
789      * - `owner` cannot be the zero address.
790      * - `spender` cannot be the zero address.
791      */
792     function _approve(address owner, address spender, uint256 amount) internal virtual {
793         require(owner != address(0), "ERC20: approve from the zero address");
794         require(spender != address(0), "ERC20: approve to the zero address");
795 
796         _allowances[owner][spender] = amount;
797         emit Approval(owner, spender, amount);
798     }
799 
800     /**
801      * @dev Sets {decimals} to a value other than the default one of 18.
802      *
803      * WARNING: This function should only be called from the constructor. Most
804      * applications that interact with token contracts will not expect
805      * {decimals} to ever change, and may work incorrectly if it does.
806      */
807     function _setupDecimals(uint8 decimals_) internal {
808         _decimals = decimals_;
809     }
810 
811     /**
812      * @dev Hook that is called before any transfer of tokens. This includes
813      * minting and burning.
814      *
815      * Calling conditions:
816      *
817      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
818      * will be to transferred to `to`.
819      * - when `from` is zero, `amount` tokens will be minted for `to`.
820      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
821      * - `from` and `to` are never both zero.
822      *
823      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
824      */
825     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
826 }
827 
828 
829 // JoysToken with Governance.
830 contract JoysToken is ERC20("JoysToken", "JOYS"), Ownable {
831     using SafeMath for uint256;
832     using SafeERC20 for IERC20;
833 
834     // @notice Copied and modified from YAM code:
835     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
836     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
837     // Which is copied and modified from COMPOUND:
838     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
839 
840     /// @dev A record of each accounts delegate
841     mapping (address => address) internal _delegates;
842 
843     /// @notice A checkpoint for marking number of votes from a given block
844     struct Checkpoint {
845         uint32 fromBlock;
846         uint256 votes;
847     }
848 
849     /// @notice A record of votes checkpoints for each account, by index
850     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
851 
852     /// @notice The number of checkpoints for each account
853     mapping (address => uint32) public numCheckpoints;
854 
855     /// @notice The EIP-712 typehash for the contract's domain
856     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
857 
858     /// @notice The EIP-712 typehash for the delegation struct used by the contract
859     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
860 
861     /// @notice A record of states for signing / validating signatures
862     mapping (address => uint) public nonces;
863 
864       /// @notice An event thats emitted when an account changes its delegate
865     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
866 
867     /// @notice An event thats emitted when a delegate account's vote balance changes
868     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
869 
870     /**
871     * @notice JoysToken constructor with total supply 30 million
872     */
873     constructor() public {
874         uint256 totalSupply = 300000000 * 1e18;
875         _mint(_msgSender(), totalSupply);
876     }
877 
878     /**
879     * @notice Burn _amount joys
880     * @param _amount of Joys token to burn
881     */
882     function burn(uint256 _amount) public onlyOwner {
883         _burn(_msgSender(), _amount);
884     }
885 
886     /**
887      * @dev Hook that is called before any transfer of tokens. This includes
888      * minting and burning.
889      *
890      * Calling conditions:
891      *
892      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
893      * will be to transferred to `to`.
894      * - when `from` is zero, `amount` tokens will be minted for `to`.
895      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
896      * - `from` and `to` are never both zero.
897      *
898      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
899      */
900     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
901         _moveDelegates(_delegates[from], _delegates[to], amount);
902     }
903 
904     /**
905      * @notice Delegate votes from `msg.sender` to `delegatee`
906      * @param delegator The address to get delegatee for
907      */
908     function delegates(address delegator)
909         external
910         view
911         returns (address)
912     {
913         return _delegates[delegator];
914     }
915 
916    /**
917     * @notice Delegate votes from `msg.sender` to `delegatee`
918     * @param delegatee The address to delegate votes to
919     */
920     function delegate(address delegatee) external {
921         return _delegate(msg.sender, delegatee);
922     }
923 
924     /**
925      * @notice Delegates votes from signatory to `delegatee`
926      * @param delegatee The address to delegate votes to
927      * @param nonce The contract state required to match the signature
928      * @param expiry The time at which to expire the signature
929      * @param v The recovery byte of the signature
930      * @param r Half of the ECDSA signature pair
931      * @param s Half of the ECDSA signature pair
932      */
933     function delegateBySig(
934         address delegatee,
935         uint nonce,
936         uint expiry,
937         uint8 v,
938         bytes32 r,
939         bytes32 s
940     )
941         external
942     {
943         bytes32 domainSeparator = keccak256(
944             abi.encode(
945                 DOMAIN_TYPEHASH,
946                 keccak256(bytes(name())),
947                 getChainId(),
948                 address(this)
949             )
950         );
951 
952         bytes32 structHash = keccak256(
953             abi.encode(
954                 DELEGATION_TYPEHASH,
955                 delegatee,
956                 nonce,
957                 expiry
958             )
959         );
960 
961         bytes32 digest = keccak256(
962             abi.encodePacked(
963                 "\x19\x01",
964                 domainSeparator,
965                 structHash
966             )
967         );
968 
969         address signatory = ecrecover(digest, v, r, s);
970         require(signatory != address(0), "JOYS::delegateBySig: invalid signature");
971         require(nonce == nonces[signatory]++, "JOYS::delegateBySig: invalid nonce");
972         require(now <= expiry, "JOYS::delegateBySig: signature expired");
973         return _delegate(signatory, delegatee);
974     }
975 
976     /**
977      * @notice Gets the current votes balance for `account`
978      * @param account The address to get votes balance
979      * @return The number of current votes for `account`
980      */
981     function getCurrentVotes(address account)
982         external
983         view
984         returns (uint256)
985     {
986         uint32 nCheckpoints = numCheckpoints[account];
987         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
988     }
989 
990     /**
991      * @notice Determine the prior number of votes for an account as of a block number
992      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
993      * @param account The address of the account to check
994      * @param blockNumber The block number to get the vote balance at
995      * @return The number of votes the account had as of the given block
996      */
997     function getPriorVotes(address account, uint blockNumber)
998         external
999         view
1000         returns (uint256)
1001     {
1002         require(blockNumber < block.number, "JOYS::getPriorVotes: not yet determined");
1003 
1004         uint32 nCheckpoints = numCheckpoints[account];
1005         if (nCheckpoints == 0) {
1006             return 0;
1007         }
1008 
1009         // First check most recent balance
1010         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1011             return checkpoints[account][nCheckpoints - 1].votes;
1012         }
1013 
1014         // Next check implicit zero balance
1015         if (checkpoints[account][0].fromBlock > blockNumber) {
1016             return 0;
1017         }
1018 
1019         uint32 lower = 0;
1020         uint32 upper = nCheckpoints - 1;
1021         while (upper > lower) {
1022             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1023             Checkpoint memory cp = checkpoints[account][center];
1024             if (cp.fromBlock == blockNumber) {
1025                 return cp.votes;
1026             } else if (cp.fromBlock < blockNumber) {
1027                 lower = center;
1028             } else {
1029                 upper = center - 1;
1030             }
1031         }
1032         return checkpoints[account][lower].votes;
1033     }
1034 
1035     function _delegate(address delegator, address delegatee)
1036         internal
1037     {
1038         address currentDelegate = _delegates[delegator];
1039         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying JOYS (not scaled);
1040         _delegates[delegator] = delegatee;
1041 
1042         emit DelegateChanged(delegator, currentDelegate, delegatee);
1043 
1044         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1045     }
1046 
1047     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1048         if (srcRep != dstRep && amount > 0) {
1049             if (srcRep != address(0)) {
1050                 // decrease old representative
1051                 uint32 srcRepNum = numCheckpoints[srcRep];
1052                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1053                 uint256 srcRepNew = srcRepOld.sub(amount);
1054                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1055             }
1056 
1057             if (dstRep != address(0)) {
1058                 // increase new representative
1059                 uint32 dstRepNum = numCheckpoints[dstRep];
1060                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1061                 uint256 dstRepNew = dstRepOld.add(amount);
1062                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1063             }
1064         }
1065     }
1066 
1067     function _writeCheckpoint(
1068         address delegatee,
1069         uint32 nCheckpoints,
1070         uint256 oldVotes,
1071         uint256 newVotes
1072     )
1073         internal
1074     {
1075         uint32 blockNumber = safe32(block.number, "JOYS::_writeCheckpoint: block number exceeds 32 bits");
1076 
1077         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1078             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1079         } else {
1080             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1081             numCheckpoints[delegatee] = nCheckpoints + 1;
1082         }
1083 
1084         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1085     }
1086 
1087     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1088         require(n < 2**32, errorMessage);
1089         return uint32(n);
1090     }
1091 
1092     function getChainId() internal pure returns (uint) {
1093         uint256 chainId;
1094         assembly { chainId := chainid() }
1095         return chainId;
1096     }
1097 }