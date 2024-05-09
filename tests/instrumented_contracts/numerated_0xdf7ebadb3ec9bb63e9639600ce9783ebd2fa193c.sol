1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
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
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
258         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
259         // for accounts without code, i.e. `keccak256('')`
260         bytes32 codehash;
261         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { codehash := extcodehash(account) }
264         return (codehash != accountHash && codehash != 0x0);
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 /**
374  * @title SafeERC20
375  * @dev Wrappers around ERC20 operations that throw on failure (when the token
376  * contract returns false). Tokens that return no value (and instead revert or
377  * throw on failure) are also supported, non-reverting calls are assumed to be
378  * successful.
379  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
380  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
381  */
382 library SafeERC20 {
383     using SafeMath for uint256;
384     using Address for address;
385 
386     function safeTransfer(IERC20 token, address to, uint256 value) internal {
387         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
388     }
389 
390     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     /**
395      * @dev Deprecated. This function has issues similar to the ones found in
396      * {IERC20-approve}, and its usage is discouraged.
397      *
398      * Whenever possible, use {safeIncreaseAllowance} and
399      * {safeDecreaseAllowance} instead.
400      */
401     function safeApprove(IERC20 token, address spender, uint256 value) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         // solhint-disable-next-line max-line-length
406         require((value == 0) || (token.allowance(address(this), spender) == 0),
407             "SafeERC20: approve from non-zero to non-zero allowance"
408         );
409         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
410     }
411 
412     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
413         uint256 newAllowance = token.allowance(address(this), spender).add(value);
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
415     }
416 
417     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     /**
423      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
424      * on the return value: the return value is optional (but if data is returned, it must not be false).
425      * @param token The token targeted by the call.
426      * @param data The call data (encoded using abi.encode or one of its variants).
427      */
428     function _callOptionalReturn(IERC20 token, bytes memory data) private {
429         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
430         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
431         // the target address contains contract code and also asserts for success in the low-level call.
432 
433         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
434         if (returndata.length > 0) { // Return data is optional
435             // solhint-disable-next-line max-line-length
436             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
437         }
438     }
439 }
440 
441 /*
442  * @dev Provides information about the current execution context, including the
443  * sender of the transaction and its data. While these are generally available
444  * via msg.sender and msg.data, they should not be accessed in such a direct
445  * manner, since when dealing with GSN meta-transactions the account sending and
446  * paying for execution may not be the actual sender (as far as an application
447  * is concerned).
448  *
449  * This contract is only required for intermediate, library-like contracts.
450  */
451 abstract contract Context {
452     function _msgSender() internal view virtual returns (address payable) {
453         return msg.sender;
454     }
455 
456     function _msgData() internal view virtual returns (bytes memory) {
457         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
458         return msg.data;
459     }
460 }
461 
462 /**
463  * @dev Implementation of the {IERC20} interface.
464  *
465  * This implementation is agnostic to the way tokens are created. This means
466  * that a supply mechanism has to be added in a derived contract using {_mint}.
467  * For a generic mechanism see {ERC20PresetMinterPauser}.
468  *
469  * TIP: For a detailed writeup see our guide
470  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
471  * to implement supply mechanisms].
472  *
473  * We have followed general OpenZeppelin guidelines: functions revert instead
474  * of returning `false` on failure. This behavior is nonetheless conventional
475  * and does not conflict with the expectations of ERC20 applications.
476  *
477  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
478  * This allows applications to reconstruct the allowance for all accounts just
479  * by listening to said events. Other implementations of the EIP may not emit
480  * these events, as it isn't required by the specification.
481  *
482  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
483  * functions have been added to mitigate the well-known issues around setting
484  * allowances. See {IERC20-approve}.
485  */
486 contract ERC20 is Context, IERC20 {
487     using SafeMath for uint256;
488     using Address for address;
489 
490     mapping (address => uint256) private _balances;
491 
492     mapping (address => mapping (address => uint256)) private _allowances;
493 
494     uint256 private _totalSupply;
495 
496     string private _name;
497     string private _symbol;
498     uint8 private _decimals;
499 
500     /**
501      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
502      * a default value of 18.
503      *
504      * To select a different value for {decimals}, use {_setupDecimals}.
505      *
506      * All three of these values are immutable: they can only be set once during
507      * construction.
508      */
509     constructor (string memory name, string memory symbol) public {
510         _name = name;
511         _symbol = symbol;
512         _decimals = 18;
513     }
514 
515     /**
516      * @dev Returns the name of the token.
517      */
518     function name() public view returns (string memory) {
519         return _name;
520     }
521 
522     /**
523      * @dev Returns the symbol of the token, usually a shorter version of the
524      * name.
525      */
526     function symbol() public view returns (string memory) {
527         return _symbol;
528     }
529 
530     /**
531      * @dev Returns the number of decimals used to get its user representation.
532      * For example, if `decimals` equals `2`, a balance of `505` tokens should
533      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
534      *
535      * Tokens usually opt for a value of 18, imitating the relationship between
536      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
537      * called.
538      *
539      * NOTE: This information is only used for _display_ purposes: it in
540      * no way affects any of the arithmetic of the contract, including
541      * {IERC20-balanceOf} and {IERC20-transfer}.
542      */
543     function decimals() public view returns (uint8) {
544         return _decimals;
545     }
546 
547     /**
548      * @dev See {IERC20-totalSupply}.
549      */
550     function totalSupply() public view override returns (uint256) {
551         return _totalSupply;
552     }
553 
554     /**
555      * @dev See {IERC20-balanceOf}.
556      */
557     function balanceOf(address account) public view override returns (uint256) {
558         return _balances[account];
559     }
560 
561     /**
562      * @dev See {IERC20-transfer}.
563      *
564      * Requirements:
565      *
566      * - `recipient` cannot be the zero address.
567      * - the caller must have a balance of at least `amount`.
568      */
569     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
570         _transfer(_msgSender(), recipient, amount);
571         return true;
572     }
573 
574     /**
575      * @dev See {IERC20-allowance}.
576      */
577     function allowance(address owner, address spender) public view virtual override returns (uint256) {
578         return _allowances[owner][spender];
579     }
580 
581     /**
582      * @dev See {IERC20-approve}.
583      *
584      * Requirements:
585      *
586      * - `spender` cannot be the zero address.
587      */
588     function approve(address spender, uint256 amount) public virtual override returns (bool) {
589         _approve(_msgSender(), spender, amount);
590         return true;
591     }
592 
593     /**
594      * @dev See {IERC20-transferFrom}.
595      *
596      * Emits an {Approval} event indicating the updated allowance. This is not
597      * required by the EIP. See the note at the beginning of {ERC20};
598      *
599      * Requirements:
600      * - `sender` and `recipient` cannot be the zero address.
601      * - `sender` must have a balance of at least `amount`.
602      * - the caller must have allowance for ``sender``'s tokens of at least
603      * `amount`.
604      */
605     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
606         _transfer(sender, recipient, amount);
607         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
608         return true;
609     }
610 
611     /**
612      * @dev Atomically increases the allowance granted to `spender` by the caller.
613      *
614      * This is an alternative to {approve} that can be used as a mitigation for
615      * problems described in {IERC20-approve}.
616      *
617      * Emits an {Approval} event indicating the updated allowance.
618      *
619      * Requirements:
620      *
621      * - `spender` cannot be the zero address.
622      */
623     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
624         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
625         return true;
626     }
627 
628     /**
629      * @dev Atomically decreases the allowance granted to `spender` by the caller.
630      *
631      * This is an alternative to {approve} that can be used as a mitigation for
632      * problems described in {IERC20-approve}.
633      *
634      * Emits an {Approval} event indicating the updated allowance.
635      *
636      * Requirements:
637      *
638      * - `spender` cannot be the zero address.
639      * - `spender` must have allowance for the caller of at least
640      * `subtractedValue`.
641      */
642     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
643         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
644         return true;
645     }
646 
647     /**
648      * @dev Moves tokens `amount` from `sender` to `recipient`.
649      *
650      * This is internal function is equivalent to {transfer}, and can be used to
651      * e.g. implement automatic token fees, slashing mechanisms, etc.
652      *
653      * Emits a {Transfer} event.
654      *
655      * Requirements:
656      *
657      * - `sender` cannot be the zero address.
658      * - `recipient` cannot be the zero address.
659      * - `sender` must have a balance of at least `amount`.
660      */
661     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
662         require(sender != address(0), "ERC20: transfer from the zero address");
663         require(recipient != address(0), "ERC20: transfer to the zero address");
664 
665         _beforeTokenTransfer(sender, recipient, amount);
666 
667         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
668         _balances[recipient] = _balances[recipient].add(amount);
669         emit Transfer(sender, recipient, amount);
670     }
671 
672     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
673      * the total supply.
674      *
675      * Emits a {Transfer} event with `from` set to the zero address.
676      *
677      * Requirements
678      *
679      * - `to` cannot be the zero address.
680      */
681     function _mint(address account, uint256 amount) internal virtual {
682         require(account != address(0), "ERC20: mint to the zero address");
683 
684         _beforeTokenTransfer(address(0), account, amount);
685 
686         _totalSupply = _totalSupply.add(amount);
687         _balances[account] = _balances[account].add(amount);
688         emit Transfer(address(0), account, amount);
689     }
690 
691     /**
692      * @dev Destroys `amount` tokens from `account`, reducing the
693      * total supply.
694      *
695      * Emits a {Transfer} event with `to` set to the zero address.
696      *
697      * Requirements
698      *
699      * - `account` cannot be the zero address.
700      * - `account` must have at least `amount` tokens.
701      */
702     function _burn(address account, uint256 amount) internal virtual {
703         require(account != address(0), "ERC20: burn from the zero address");
704 
705         _beforeTokenTransfer(account, address(0), amount);
706 
707         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
708         _totalSupply = _totalSupply.sub(amount);
709         emit Transfer(account, address(0), amount);
710     }
711 
712     /**
713      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
714      *
715      * This is internal function is equivalent to `approve`, and can be used to
716      * e.g. set automatic allowances for certain subsystems, etc.
717      *
718      * Emits an {Approval} event.
719      *
720      * Requirements:
721      *
722      * - `owner` cannot be the zero address.
723      * - `spender` cannot be the zero address.
724      */
725     function _approve(address owner, address spender, uint256 amount) internal virtual {
726         require(owner != address(0), "ERC20: approve from the zero address");
727         require(spender != address(0), "ERC20: approve to the zero address");
728 
729         _allowances[owner][spender] = amount;
730         emit Approval(owner, spender, amount);
731     }
732 
733     /**
734      * @dev Sets {decimals} to a value other than the default one of 18.
735      *
736      * WARNING: This function should only be called from the constructor. Most
737      * applications that interact with token contracts will not expect
738      * {decimals} to ever change, and may work incorrectly if it does.
739      */
740     function _setupDecimals(uint8 decimals_) internal {
741         _decimals = decimals_;
742     }
743 
744     /**
745      * @dev Hook that is called before any transfer of tokens. This includes
746      * minting and burning.
747      *
748      * Calling conditions:
749      *
750      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
751      * will be to transferred to `to`.
752      * - when `from` is zero, `amount` tokens will be minted for `to`.
753      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
754      * - `from` and `to` are never both zero.
755      *
756      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
757      */
758     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
759 }
760 
761 interface IController {
762     function vaults(address) external view returns (address);
763     function rewards() external view returns (address);
764     function want(address) external view returns (address); // NOTE: Only StrategyControllerV2 implements this
765     function balanceOf(address) external view returns (uint);
766     function withdraw(address, uint) external;
767     function earn(address, uint) external;
768 }
769 
770 interface IStakingRewards {
771     function balanceOf(address account) external view returns (uint256);
772     function stakeFor(uint256 amount, address recipient) external;
773     function withdrawForUserByCVault(uint256 amount, address from) external;
774     function getRewardFor(address user) external;
775 }
776 
777 contract cVault is ERC20 {
778     using SafeERC20 for IERC20;
779     using Address for address;
780     using SafeMath for uint256;
781 
782     IERC20 public token;
783 
784     uint public min = 9500;
785     uint public constant max = 10000;
786 
787     address public governance;
788     address public controller;
789     address public stakingPool;
790 
791     constructor (address _token, address _controller)
792         public ERC20(
793           string(abi.encodePacked("Compounder ", ERC20(_token).name())),
794           string(abi.encodePacked("c", ERC20(_token).symbol()))
795         )
796     {
797         token = IERC20(_token);
798         _setupDecimals(ERC20(_token).decimals());
799         governance = msg.sender;
800         controller = _controller;
801     }
802 
803     // Total balance of token in both vault and corresponding strategy
804     function balance() public view returns (uint) {
805         return token.balanceOf(address(this))
806                 .add(IController(controller).balanceOf(address(token)));
807     }
808 
809     function setMin(uint _min) external {
810         require(msg.sender == governance, "!governance");
811         min = _min;
812     }
813 
814     function setGovernance(address _governance) public {
815         require(msg.sender == governance, "!governance");
816         governance = _governance;
817     }
818 
819     function setController(address _controller) public {
820         require(msg.sender == governance, "!governance");
821         controller = _controller;
822     }
823 
824     function setStakingPool(address _stakingPool) public {
825         require(msg.sender == governance, "!governance");
826         stakingPool = _stakingPool;
827     }
828 
829     function infiniteApproveStakingPool() public {
830         require(msg.sender == governance, "!governance");
831         _approve(address(this), stakingPool, uint(-1));
832     }
833 
834     function removeApprovalStakingPool() public {
835         require(msg.sender == governance, "!governance");
836         _approve(address(this), stakingPool, uint(0));
837     }
838 
839     // Custom logic in here for how much the vault allows to be borrowed
840     // Sets minimum required on-hand to keep small withdrawals cheap
841     function available() public view returns (uint) {
842         return token.balanceOf(address(this)).mul(min).div(max);
843     }
844 
845     // Called by Keeper to put deposited token into strategy
846     function earn() public {
847         uint _bal = available();
848         token.safeTransfer(controller, _bal);
849         IController(controller).earn(address(token), _bal);
850     }
851 
852     function depositAll(bool _autoStakeInStakingPool) external {
853         deposit(token.balanceOf(msg.sender), _autoStakeInStakingPool);
854     }
855 
856     function deposit(uint _amount, bool _autoStakeInStakingPool) public {
857         uint _pool = balance();
858         uint _before = token.balanceOf(address(this));
859         token.safeTransferFrom(msg.sender, address(this), _amount);
860         uint _after = token.balanceOf(address(this));
861         _amount = _after.sub(_before); // Additional check for deflationary tokens
862         uint shares = 0;
863         if (totalSupply() == 0) {
864             shares = _amount;
865         } else {
866             shares = (_amount.mul(totalSupply())).div(_pool);
867         }
868 
869         if (_autoStakeInStakingPool) {
870             _mint(address(this), shares);
871             IStakingRewards(stakingPool).stakeFor(shares, msg.sender);
872             IStakingRewards(stakingPool).getRewardFor(msg.sender);
873         } else {
874             _mint(msg.sender, shares);
875         }
876     }
877 
878     function withdrawAll() external {
879         withdraw(balanceOf(msg.sender), false);
880     }
881 
882     function withdrawAllFromRewardPool() external {
883         withdraw(IStakingRewards(stakingPool).balanceOf(msg.sender), true);
884     }
885 
886     // No rebalance implementation for lower fees and faster swaps
887     function withdraw(uint _shares, bool _autoWithdrawFromStakingPool) public {
888         if (_autoWithdrawFromStakingPool) {
889             IStakingRewards(stakingPool).withdrawForUserByCVault(_shares, msg.sender);
890             IStakingRewards(stakingPool).getRewardFor(msg.sender);
891         }
892 
893         uint r = (balance().mul(_shares)).div(totalSupply());
894         _burn(msg.sender, _shares);
895 
896         // Check balance
897         uint b = token.balanceOf(address(this));
898         if (b < r) {
899             uint _withdraw = r.sub(b);
900             IController(controller).withdraw(address(token), _withdraw);
901             uint _after = token.balanceOf(address(this));
902             uint _diff = _after.sub(b);
903             if (_diff < _withdraw) {
904                 r = b.add(_diff);
905             }
906         }
907 
908         token.safeTransfer(msg.sender, r);
909     }
910 
911     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
912     function harvest(address reserve, uint amount) external {
913         require(msg.sender == controller, "!controller");
914         require(reserve != address(token), "token");
915         IERC20(reserve).safeTransfer(controller, amount);
916     }
917 
918     function getPricePerFullShare() public view returns (uint) {
919         return balance().mul(1e18).div(totalSupply());
920     }
921 }
922 
923 contract cVault_CP3R is cVault {
924     constructor (address _token, address _controller)
925         public cVault(
926           _token,
927           _controller
928         )
929     {
930 
931     }
932 }