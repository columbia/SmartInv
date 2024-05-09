1 pragma solidity 0.6.12;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
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
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
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
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258         // for accounts without code, i.e. `keccak256('')`
259         bytes32 codehash;
260         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261         // solhint-disable-next-line no-inline-assembly
262         assembly { codehash := extcodehash(account) }
263         return (codehash != accountHash && codehash != 0x0);
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(address(this).balance >= amount, "Address: insufficient balance");
284 
285         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286         (bool success, ) = recipient.call{ value: amount }("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain`call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309       return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319         return _functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339      * with `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         return _functionCallWithValue(target, data, value, errorMessage);
346     }
347 
348     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
349         require(isContract(target), "Address: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359 
360                 // solhint-disable-next-line no-inline-assembly
361                 assembly {
362                     let returndata_size := mload(returndata)
363                     revert(add(32, returndata), returndata_size)
364                 }
365             } else {
366                 revert(errorMessage);
367             }
368         }
369     }
370 }
371 
372 /**
373  * @title SafeERC20
374  * @dev Wrappers around ERC20 operations that throw on failure (when the token
375  * contract returns false). Tokens that return no value (and instead revert or
376  * throw on failure) are also supported, non-reverting calls are assumed to be
377  * successful.
378  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
379  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
380  */
381 library SafeERC20 {
382     using SafeMath for uint256;
383     using Address for address;
384 
385     function safeTransfer(IERC20 token, address to, uint256 value) internal {
386         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
387     }
388 
389     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
391     }
392 
393     /**
394      * @dev Deprecated. This function has issues similar to the ones found in
395      * {IERC20-approve}, and its usage is discouraged.
396      *
397      * Whenever possible, use {safeIncreaseAllowance} and
398      * {safeDecreaseAllowance} instead.
399      */
400     function safeApprove(IERC20 token, address spender, uint256 value) internal {
401         // safeApprove should only be called when setting an initial allowance,
402         // or when resetting it to zero. To increase and decrease it, use
403         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
404         // solhint-disable-next-line max-line-length
405         require((value == 0) || (token.allowance(address(this), spender) == 0),
406             "SafeERC20: approve from non-zero to non-zero allowance"
407         );
408         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
409     }
410 
411     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
412         uint256 newAllowance = token.allowance(address(this), spender).add(value);
413         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
414     }
415 
416     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
417         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
419     }
420 
421     /**
422      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
423      * on the return value: the return value is optional (but if data is returned, it must not be false).
424      * @param token The token targeted by the call.
425      * @param data The call data (encoded using abi.encode or one of its variants).
426      */
427     function _callOptionalReturn(IERC20 token, bytes memory data) private {
428         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
429         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
430         // the target address contains contract code and also asserts for success in the low-level call.
431 
432         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
433         if (returndata.length > 0) { // Return data is optional
434             // solhint-disable-next-line max-line-length
435             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
436         }
437     }
438 }
439 
440 /*
441  * @dev Provides information about the current execution context, including the
442  * sender of the transaction and its data. While these are generally available
443  * via msg.sender and msg.data, they should not be accessed in such a direct
444  * manner, since when dealing with GSN meta-transactions the account sending and
445  * paying for execution may not be the actual sender (as far as an application
446  * is concerned).
447  *
448  * This contract is only required for intermediate, library-like contracts.
449  */
450 abstract contract Context {
451     function _msgSender() internal view virtual returns (address payable) {
452         return msg.sender;
453     }
454 
455     function _msgData() internal view virtual returns (bytes memory) {
456         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
457         return msg.data;
458     }
459 }
460 
461 /**
462  * @dev Implementation of the {IERC20} interface.
463  *
464  * This implementation is agnostic to the way tokens are created. This means
465  * that a supply mechanism has to be added in a derived contract using {_mint}.
466  * For a generic mechanism see {ERC20PresetMinterPauser}.
467  *
468  * TIP: For a detailed writeup see our guide
469  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
470  * to implement supply mechanisms].
471  *
472  * We have followed general OpenZeppelin guidelines: functions revert instead
473  * of returning `false` on failure. This behavior is nonetheless conventional
474  * and does not conflict with the expectations of ERC20 applications.
475  *
476  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
477  * This allows applications to reconstruct the allowance for all accounts just
478  * by listening to said events. Other implementations of the EIP may not emit
479  * these events, as it isn't required by the specification.
480  *
481  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
482  * functions have been added to mitigate the well-known issues around setting
483  * allowances. See {IERC20-approve}.
484  */
485 contract ERC20 is Context, IERC20 {
486     using SafeMath for uint256;
487     using Address for address;
488 
489     mapping (address => uint256) private _balances;
490 
491     mapping (address => mapping (address => uint256)) private _allowances;
492 
493     uint256 private _totalSupply;
494 
495     string private _name;
496     string private _symbol;
497     uint8 private _decimals;
498 
499     /**
500      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
501      * a default value of 18.
502      *
503      * To select a different value for {decimals}, use {_setupDecimals}.
504      *
505      * All three of these values are immutable: they can only be set once during
506      * construction.
507      */
508     constructor (string memory name, string memory symbol) public {
509         _name = name;
510         _symbol = symbol;
511         _decimals = 18;
512     }
513 
514     /**
515      * @dev Returns the name of the token.
516      */
517     function name() public view returns (string memory) {
518         return _name;
519     }
520 
521     /**
522      * @dev Returns the symbol of the token, usually a shorter version of the
523      * name.
524      */
525     function symbol() public view returns (string memory) {
526         return _symbol;
527     }
528 
529     /**
530      * @dev Returns the number of decimals used to get its user representation.
531      * For example, if `decimals` equals `2`, a balance of `505` tokens should
532      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
533      *
534      * Tokens usually opt for a value of 18, imitating the relationship between
535      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
536      * called.
537      *
538      * NOTE: This information is only used for _display_ purposes: it in
539      * no way affects any of the arithmetic of the contract, including
540      * {IERC20-balanceOf} and {IERC20-transfer}.
541      */
542     function decimals() public view returns (uint8) {
543         return _decimals;
544     }
545 
546     /**
547      * @dev See {IERC20-totalSupply}.
548      */
549     function totalSupply() public view override returns (uint256) {
550         return _totalSupply;
551     }
552 
553     /**
554      * @dev See {IERC20-balanceOf}.
555      */
556     function balanceOf(address account) public view override returns (uint256) {
557         return _balances[account];
558     }
559 
560     /**
561      * @dev See {IERC20-transfer}.
562      *
563      * Requirements:
564      *
565      * - `recipient` cannot be the zero address.
566      * - the caller must have a balance of at least `amount`.
567      */
568     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
569         _transfer(_msgSender(), recipient, amount);
570         return true;
571     }
572 
573     /**
574      * @dev See {IERC20-allowance}.
575      */
576     function allowance(address owner, address spender) public view virtual override returns (uint256) {
577         return _allowances[owner][spender];
578     }
579 
580     /**
581      * @dev See {IERC20-approve}.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      */
587     function approve(address spender, uint256 amount) public virtual override returns (bool) {
588         _approve(_msgSender(), spender, amount);
589         return true;
590     }
591 
592     /**
593      * @dev See {IERC20-transferFrom}.
594      *
595      * Emits an {Approval} event indicating the updated allowance. This is not
596      * required by the EIP. See the note at the beginning of {ERC20};
597      *
598      * Requirements:
599      * - `sender` and `recipient` cannot be the zero address.
600      * - `sender` must have a balance of at least `amount`.
601      * - the caller must have allowance for ``sender``'s tokens of at least
602      * `amount`.
603      */
604     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
605         _transfer(sender, recipient, amount);
606         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
607         return true;
608     }
609 
610     /**
611      * @dev Atomically increases the allowance granted to `spender` by the caller.
612      *
613      * This is an alternative to {approve} that can be used as a mitigation for
614      * problems described in {IERC20-approve}.
615      *
616      * Emits an {Approval} event indicating the updated allowance.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      */
622     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
623         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
624         return true;
625     }
626 
627     /**
628      * @dev Atomically decreases the allowance granted to `spender` by the caller.
629      *
630      * This is an alternative to {approve} that can be used as a mitigation for
631      * problems described in {IERC20-approve}.
632      *
633      * Emits an {Approval} event indicating the updated allowance.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      * - `spender` must have allowance for the caller of at least
639      * `subtractedValue`.
640      */
641     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
642         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
643         return true;
644     }
645 
646     /**
647      * @dev Moves tokens `amount` from `sender` to `recipient`.
648      *
649      * This is internal function is equivalent to {transfer}, and can be used to
650      * e.g. implement automatic token fees, slashing mechanisms, etc.
651      *
652      * Emits a {Transfer} event.
653      *
654      * Requirements:
655      *
656      * - `sender` cannot be the zero address.
657      * - `recipient` cannot be the zero address.
658      * - `sender` must have a balance of at least `amount`.
659      */
660     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
661         require(sender != address(0), "ERC20: transfer from the zero address");
662         require(recipient != address(0), "ERC20: transfer to the zero address");
663 
664         _beforeTokenTransfer(sender, recipient, amount);
665 
666         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
667         _balances[recipient] = _balances[recipient].add(amount);
668         emit Transfer(sender, recipient, amount);
669     }
670 
671     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
672      * the total supply.
673      *
674      * Emits a {Transfer} event with `from` set to the zero address.
675      *
676      * Requirements
677      *
678      * - `to` cannot be the zero address.
679      */
680     function _mint(address account, uint256 amount) internal virtual {
681         require(account != address(0), "ERC20: mint to the zero address");
682 
683         _beforeTokenTransfer(address(0), account, amount);
684 
685         _totalSupply = _totalSupply.add(amount);
686         _balances[account] = _balances[account].add(amount);
687         emit Transfer(address(0), account, amount);
688     }
689 
690     /**
691      * @dev Destroys `amount` tokens from `account`, reducing the
692      * total supply.
693      *
694      * Emits a {Transfer} event with `to` set to the zero address.
695      *
696      * Requirements
697      *
698      * - `account` cannot be the zero address.
699      * - `account` must have at least `amount` tokens.
700      */
701     function _burn(address account, uint256 amount) internal virtual {
702         require(account != address(0), "ERC20: burn from the zero address");
703 
704         _beforeTokenTransfer(account, address(0), amount);
705 
706         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
707         _totalSupply = _totalSupply.sub(amount);
708         emit Transfer(account, address(0), amount);
709     }
710 
711     /**
712      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
713      *
714      * This is internal function is equivalent to `approve`, and can be used to
715      * e.g. set automatic allowances for certain subsystems, etc.
716      *
717      * Emits an {Approval} event.
718      *
719      * Requirements:
720      *
721      * - `owner` cannot be the zero address.
722      * - `spender` cannot be the zero address.
723      */
724     function _approve(address owner, address spender, uint256 amount) internal virtual {
725         require(owner != address(0), "ERC20: approve from the zero address");
726         require(spender != address(0), "ERC20: approve to the zero address");
727 
728         _allowances[owner][spender] = amount;
729         emit Approval(owner, spender, amount);
730     }
731 
732     /**
733      * @dev Sets {decimals} to a value other than the default one of 18.
734      *
735      * WARNING: This function should only be called from the constructor. Most
736      * applications that interact with token contracts will not expect
737      * {decimals} to ever change, and may work incorrectly if it does.
738      */
739     function _setupDecimals(uint8 decimals_) internal {
740         _decimals = decimals_;
741     }
742 
743     /**
744      * @dev Hook that is called before any transfer of tokens. This includes
745      * minting and burning.
746      *
747      * Calling conditions:
748      *
749      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
750      * will be to transferred to `to`.
751      * - when `from` is zero, `amount` tokens will be minted for `to`.
752      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
753      * - `from` and `to` are never both zero.
754      *
755      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
756      */
757     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
758 }
759 
760 /**
761  * @dev Contract module that helps prevent reentrant calls to a function.
762  *
763  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
764  * available, which can be aplied to functions to make sure there are no nested
765  * (reentrant) calls to them.
766  *
767  * Note that because there is a single `nonReentrant` guard, functions marked as
768  * `nonReentrant` may not call one another. This can be worked around by making
769  * those functions `private`, and then adding `external` `nonReentrant` entry
770  * points to them.
771  */
772 contract ReentrancyGuard {
773     /// @dev counter to allow mutex lock with only one SSTORE operation
774     uint256 private _guardCounter;
775 
776     constructor () internal {
777         // The counter starts at one to prevent changing it from zero to a non-zero
778         // value, which is a more expensive operation.
779         _guardCounter = 1;
780     }
781 
782     /**
783      * @dev Prevents a contract from calling itself, directly or indirectly.
784      * Calling a `nonReentrant` function from another `nonReentrant`
785      * function is not supported. It is possible to prevent this from happening
786      * by making the `nonReentrant` function external, and make it call a
787      * `private` function that does the actual work.
788      */
789     modifier nonReentrant() {
790         _guardCounter += 1;
791         uint256 localCounter = _guardCounter;
792         _;
793         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
794     }
795 }
796 
797 // Stake ALD to gain ALDPlus status
798 contract ALDPlus is ReentrancyGuard {
799     using SafeERC20 for IERC20;
800     using SafeMath for uint256;
801 
802     /* ========== STRUCTS ========== */
803 
804     struct Lock {
805         uint locked;
806         uint unlockTime;
807     }
808 
809     /* ========== STATE VARIABLES ========== */
810 
811     address public governance;
812 
813     IERC20 public ald;
814     uint256 public stakeAmount; // amount of ALD to stake to gain aldplus status
815 
816     // only whitelisted address can stake
817     bool public enableWhitelist = false;
818     mapping(address => bool) public isWhitelisted;
819     address[] public whitelist;
820 
821     // aldplus shares, each address should only have one share
822     mapping(address => uint) public shares; // this technically can be binary, but using uint for balance
823     mapping(address => uint) public balance; // address => staked balance
824 
825     uint private constant LOCK_DURATION = 14 days;
826     mapping(address => Lock) public locks; // address => locks
827 
828     /* ========== CONSTRUCTOR ========== */
829 
830     constructor(
831         IERC20 _ald,
832         uint _stakeAmount
833     )
834         public
835     {
836         stakeAmount = _stakeAmount;
837         ald = _ald;
838         governance = msg.sender;
839     }
840 
841     /* ========== MUTATIVE FUNCTIONS ========== */
842 
843     // Stake ALD to receive ALDPLUS shares
844     function stake() external nonReentrant onlyWhitelist {
845         require(locks[msg.sender].locked == 0, "!unlocked");
846         require(shares[msg.sender] == 0, "already staked");
847         ald.safeTransferFrom(msg.sender, address(this), stakeAmount);
848         balance[msg.sender] = balance[msg.sender].add(stakeAmount);
849         shares[msg.sender] = 1;
850         emit Stake(msg.sender, stakeAmount);
851     }
852 
853     // Unstake ALD burns ALDPLUS shares and locks ALD for lock duration
854     function unstake() external nonReentrant {
855         require(shares[msg.sender] != 0, "!staked");
856         uint256 _balance = balance[msg.sender];
857         balance[msg.sender] = 0;
858         shares[msg.sender] = 0;
859         // lock
860         locks[msg.sender].locked = _balance;
861         locks[msg.sender].unlockTime = block.timestamp.add(LOCK_DURATION);
862         emit Unstake(msg.sender, _balance);
863     }
864 
865     // Withdraw unlocked ALDs
866     function withdraw() external nonReentrant {
867         require(locks[msg.sender].locked > 0, "!locked");
868         require(block.timestamp >= locks[msg.sender].unlockTime, "!unlocked");
869         uint256 _locked = locks[msg.sender].locked;
870         // unlock
871         locks[msg.sender].locked = 0;
872         locks[msg.sender].unlockTime = 0;
873         ald.safeTransfer(msg.sender, _locked);
874         emit Withdrawn(msg.sender, _locked);
875     }
876 
877     /* ========== VIEW FUNCTIONS ========== */
878 
879     function whitelistLength() external view returns (uint256) {
880         return whitelist.length;
881     }
882 
883     /* ========== RESTRICTED FUNCTIONS ========== */
884 
885     function setGov(address _governance)
886         external
887         onlyGov
888     {
889         governance = _governance;
890     }
891 
892     function setStakeAmount(uint256 _stakeAmount)
893         external
894         onlyGov
895     {
896         stakeAmount = _stakeAmount;
897     }
898 
899     function setEnableWhitelist()
900         external
901         onlyGov
902     {
903         enableWhitelist = true;
904     }
905 
906     function setDisableWhitelist()
907         external
908         onlyGov
909     {
910         enableWhitelist = false;
911     }
912 
913     function addToWhitelist(address _user)
914         external
915         onlyGov
916     {
917         require(!isWhitelisted[_user], "already in whitelist");
918         isWhitelisted[_user] = true;
919         whitelist.push(_user);
920     }
921 
922     function removeFromWhitelist(uint _index)
923         external
924         onlyGov
925     {
926         require(_index < whitelist.length, "out of bound");
927         address _user = whitelist[_index];
928 
929         // remove from maping
930         isWhitelisted[_user] = false;
931 
932         // remove from list
933         whitelist[_index] = whitelist[whitelist.length - 1];
934         whitelist.pop();
935     }
936 
937     function removeFromWhitelist(address _user)
938         external
939         onlyGov
940     {
941         require(isWhitelisted[_user], "not in whitelist");
942         isWhitelisted[_user] = false;
943 
944         // find the index
945         uint indexToDelete = 0;
946         bool found = false;
947         for (uint i = 0; i < whitelist.length; i++) {
948             if (whitelist[i] == _user) {
949                 indexToDelete = i;
950                 found = true;
951                 break;
952             }
953         }
954 
955         // remove element
956         require(found == true, "user not found in whitelist");
957         whitelist[indexToDelete] = whitelist[whitelist.length - 1];
958         whitelist.pop();
959     }
960 
961     // Allow governance to rescue stuck tokens
962     function rescue(address _token)
963         external
964         onlyGov
965     {
966         require(_token != address(ald), "!ald");
967         uint _balance = IERC20(_token).balanceOf(address(this));
968         IERC20(_token).safeTransfer(governance, _balance);
969     }
970 
971     /* ========== MODIFIER ========== */
972 
973     modifier onlyGov() {
974         require(msg.sender == governance, "!gov");
975         _;
976     }
977 
978     modifier onlyWhitelist() {
979         if (enableWhitelist) {
980             require(isWhitelisted[msg.sender] == true, "!whitelist");
981         }
982         _;
983     }
984 
985     /* ========== EVENTS ========== */
986 
987     event Stake(address _user, uint256 _amount);
988     event Unstake(address _user, uint256 _amount);
989     event Withdrawn(address _user, uint256 _amount);
990 }