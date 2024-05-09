1 // SPDX-License-Identifier: MIT AND AGPLv3
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 pragma solidity >=0.6.0 <0.8.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 pragma solidity >=0.6.2 <0.8.0;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize, which returns 0 for contracts in
270         // construction, since the code is only stored at the end of the
271         // constructor execution.
272 
273         uint256 size;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { size := extcodesize(account) }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: value }(data);
362         return _verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a static call.
368      *
369      * _Available since v3.3._
370      */
371     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
372         return functionStaticCall(target, data, "Address: low-level static call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
377      * but performing a static call.
378      *
379      * _Available since v3.3._
380      */
381     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
382         require(isContract(target), "Address: static call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.staticcall(data);
386         return _verifyCallResult(success, returndata, errorMessage);
387     }
388 
389     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
410 
411 
412 pragma solidity >=0.6.0 <0.8.0;
413 
414 
415 
416 
417 /**
418  * @title SafeERC20
419  * @dev Wrappers around ERC20 operations that throw on failure (when the token
420  * contract returns false). Tokens that return no value (and instead revert or
421  * throw on failure) are also supported, non-reverting calls are assumed to be
422  * successful.
423  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
424  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
425  */
426 library SafeERC20 {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     function safeTransfer(IERC20 token, address to, uint256 value) internal {
431         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
432     }
433 
434     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
436     }
437 
438     /**
439      * @dev Deprecated. This function has issues similar to the ones found in
440      * {IERC20-approve}, and its usage is discouraged.
441      *
442      * Whenever possible, use {safeIncreaseAllowance} and
443      * {safeDecreaseAllowance} instead.
444      */
445     function safeApprove(IERC20 token, address spender, uint256 value) internal {
446         // safeApprove should only be called when setting an initial allowance,
447         // or when resetting it to zero. To increase and decrease it, use
448         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
449         // solhint-disable-next-line max-line-length
450         require((value == 0) || (token.allowance(address(this), spender) == 0),
451             "SafeERC20: approve from non-zero to non-zero allowance"
452         );
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
454     }
455 
456     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).add(value);
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464     }
465 
466     /**
467      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
468      * on the return value: the return value is optional (but if data is returned, it must not be false).
469      * @param token The token targeted by the call.
470      * @param data The call data (encoded using abi.encode or one of its variants).
471      */
472     function _callOptionalReturn(IERC20 token, bytes memory data) private {
473         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
474         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
475         // the target address contains contract code and also asserts for success in the low-level call.
476 
477         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
478         if (returndata.length > 0) { // Return data is optional
479             // solhint-disable-next-line max-line-length
480             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
481         }
482     }
483 }
484 
485 // File: @openzeppelin/contracts/GSN/Context.sol
486 
487 
488 pragma solidity >=0.6.0 <0.8.0;
489 
490 /*
491  * @dev Provides information about the current execution context, including the
492  * sender of the transaction and its data. While these are generally available
493  * via msg.sender and msg.data, they should not be accessed in such a direct
494  * manner, since when dealing with GSN meta-transactions the account sending and
495  * paying for execution may not be the actual sender (as far as an application
496  * is concerned).
497  *
498  * This contract is only required for intermediate, library-like contracts.
499  */
500 abstract contract Context {
501     function _msgSender() internal view virtual returns (address payable) {
502         return msg.sender;
503     }
504 
505     function _msgData() internal view virtual returns (bytes memory) {
506         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
507         return msg.data;
508     }
509 }
510 
511 // File: contracts/tokens/GERC20.sol
512 
513 pragma solidity >=0.6.0 <0.7.0;
514 
515 
516 
517 
518 
519 /**
520  * @dev Implementation of the {IERC20} interface.
521  *
522  * This implementation is agnostic to the way tokens are created. This means
523  * that a supply mechanism has to be added in a derived contract using {_mint}.
524  * For a generic mechanism see {ERC20MinterPauser}.
525  *
526  * TIP: For a detailed writeup see our guide
527  * https:
528  * to implement supply mechanisms].
529  *
530  * We have followed general OpenZeppelin guidelines: functions revert instead
531  * of returning `false` on failure. This behavior is nonetheless conventional
532  * and does not conflict with the expectations of ERC20 applications.
533  *
534  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
535  * This allows applications to reconstruct the allowance for all accounts just
536  * by listening to said events. Other implementations of the EIP may not emit
537  * these events, as it isn't required by the specification.
538  *
539  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
540  * functions have been added to mitigate the well-known issues around setting
541  * allowances. See {IERC20-approve}.
542  *
543  * ################### GERC20 additions to IERC20 ###################
544  *      _burn: Added paramater - burnAmount added to take rebased amount into account,
545  *          affects the Transfer event
546  *      _mint: Added paramater - mintAmount added to take rebased amount into account,
547  *          affects the Transfer event
548  *      _transfer: Added paramater - transferAmount added to take rebased amount into account,
549  *          affects the Transfer event
550  *      _decreaseApproved: Added function - internal function to allowed override of transferFrom
551  *
552  */
553 abstract contract GERC20 is Context, IERC20 {
554     using SafeMath for uint256;
555     using Address for address;
556 
557     mapping(address => uint256) private _balances;
558 
559     mapping(address => mapping(address => uint256)) private _allowances;
560 
561     uint256 private _totalSupply;
562 
563     string private _name;
564     string private _symbol;
565     uint8 private _decimals;
566 
567     constructor(
568         string memory name,
569         string memory symbol,
570         uint8 decimals
571     ) public {
572         _name = name;
573         _symbol = symbol;
574         _decimals = decimals;
575     }
576 
577     /**
578      * @dev Returns the name of the token.
579      */
580     function name() public view returns (string memory) {
581         return _name;
582     }
583 
584     /**
585      * @dev Returns the symbol of the token, usually a shorter version of the
586      * name.
587      */
588     function symbol() public view returns (string memory) {
589         return _symbol;
590     }
591 
592     /**
593      * @dev Returns the number of decimals used to get its user representation.
594      * For example, if `decimals` equals `2`, a balance of `505` tokens should
595      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
596      *
597      * Tokens usually opt for a value of 18, imitating the relationship between
598      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
599      * called.
600      *
601      * NOTE: This information is only used for _display_ purposes: it in
602      * no way affects any of the arithmetic of the contract, including
603      * {IERC20-balanceOf} and {IERC20-transfer}.
604      */
605     function decimals() public view returns (uint8) {
606         return _decimals;
607     }
608 
609     /**
610      * @dev See {IERC20-totalSupply}.
611      */
612     function totalSupplyBase() public view returns (uint256) {
613         return _totalSupply;
614     }
615 
616     /**
617      * @dev See {IERC20-balanceOf}.
618      */
619     function balanceOfBase(address account) public view returns (uint256) {
620         return _balances[account];
621     }
622 
623     /**
624      * @dev See {IERC20-transfer}.
625      *
626      * Requirements:
627      *
628      * - `recipient` cannot be the zero address.
629      * - the caller must have a balance of at least `amount`.
630      */
631     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
632         _transfer(_msgSender(), recipient, amount, amount);
633         return true;
634     }
635 
636     /**
637      * @dev See {IERC20-allowance}.
638      */
639     function allowance(address owner, address spender) public view override returns (uint256) {
640         return _allowances[owner][spender];
641     }
642 
643     /**
644      * @dev See {IERC20-approve}.
645      *
646      * Requirements:
647      *
648      * - `spender` cannot be the zero address.
649      */
650     function approve(address spender, uint256 amount) public virtual override returns (bool) {
651         _approve(_msgSender(), spender, amount);
652         return true;
653     }
654 
655     /**
656      * @dev See {IERC20-transferFrom}.
657      *
658      * Emits an {Approval} event indicating the updated allowance. This is not
659      * required by the EIP. See the note at the beginning of {ERC20};
660      *
661      * Requirements:
662      * - `sender` and `recipient` cannot be the zero address.
663      * - `sender` must have a balance of at least `amount`.
664      * - the caller must have allowance for ``sender``'s tokens of at least
665      * `amount`.
666      */
667     function transferFrom(
668         address sender,
669         address recipient,
670         uint256 amount
671     ) public virtual override returns (bool) {
672         _transfer(sender, recipient, amount, amount);
673         _approve(
674             sender,
675             _msgSender(),
676             _allowances[sender][_msgSender()].sub(
677                 amount,
678                 "ERC20: transfer amount exceeds allowance"
679             )
680         );
681         return true;
682     }
683 
684     /**
685      * @dev Atomically increases the allowance granted to `spender` by the caller.
686      *
687      * This is an alternative to {approve} that can be used as a mitigation for
688      * problems described in {IERC20-approve}.
689      *
690      * Emits an {Approval} event indicating the updated allowance.
691      *
692      * Requirements:
693      *
694      * - `spender` cannot be the zero address.
695      */
696     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
697         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
698         return true;
699     }
700 
701     /**
702      * @dev Atomically decreases the allowance granted to `spender` by the caller.
703      *
704      * This is an alternative to {approve} that can be used as a mitigation for
705      * problems described in {IERC20-approve}.
706      *
707      * Emits an {Approval} event indicating the updated allowance.
708      *
709      * Requirements:
710      *
711      * - `spender` cannot be the zero address.
712      * - `spender` must have allowance for the caller of at least
713      * `subtractedValue`.
714      */
715     function decreaseAllowance(address spender, uint256 subtractedValue)
716         public
717         virtual
718         returns (bool)
719     {
720         _approve(
721             _msgSender(),
722             spender,
723             _allowances[_msgSender()][spender].sub(
724                 subtractedValue,
725                 "ERC20: decreased allowance below zero"
726             )
727         );
728         return true;
729     }
730 
731     /**
732      * @dev Moves tokens `amount` from `sender` to `recipient`.
733      *      GERC20 addition - transferAmount added to take rebased amount into account
734      * This is internal function is equivalent to {transfer}, and can be used to
735      * e.g. implement automatic token fees, slashing mechanisms, etc.
736      *
737      * Emits a {Transfer} event.
738      *
739      * Requirements:
740      *
741      * - `sender` cannot be the zero address.
742      * - `recipient` cannot be the zero address.
743      * - `sender` must have a balance of at least `amount`.
744      */
745     function _transfer(
746         address sender,
747         address recipient,
748         uint256 transferAmount,
749         uint256 amount
750     ) internal virtual {
751         require(sender != address(0), "ERC20: transfer from the zero address");
752         require(recipient != address(0), "ERC20: transfer to the zero address");
753 
754         _beforeTokenTransfer(sender, recipient, transferAmount);
755 
756         _balances[sender] = _balances[sender].sub(
757             transferAmount,
758             "ERC20: transfer amount exceeds balance"
759         );
760         _balances[recipient] = _balances[recipient].add(transferAmount);
761         emit Transfer(sender, recipient, amount);
762     }
763 
764     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
765      * the total supply.
766      *      GERC20 addition - mintAmount added to take rebased amount into account
767      *
768      * Emits a {Transfer} event with `from` set to the zero address.
769      *
770      * Requirements
771      *
772      * - `to` cannot be the zero address.
773      */
774     function _mint(
775         address account,
776         uint256 mintAmount,
777         uint256 amount
778     ) internal virtual {
779         require(account != address(0), "ERC20: mint to the zero address");
780 
781         _beforeTokenTransfer(address(0), account, mintAmount);
782 
783         _totalSupply = _totalSupply.add(mintAmount);
784         _balances[account] = _balances[account].add(mintAmount);
785         emit Transfer(address(0), account, amount);
786     }
787 
788     /**
789      * @dev Destroys `amount` tokens from `account`, reducing the
790      * total supply.
791      *      GERC20 addition - burnAmount added to take rebased amount into account
792      *
793      * Emits a {Transfer} event with `to` set to the zero address.
794      *
795      * Requirements
796      *
797      * - `account` cannot be the zero address.
798      * - `account` must have at least `amount` tokens.
799      */
800     function _burn(
801         address account,
802         uint256 burnAmount,
803         uint256 amount
804     ) internal virtual {
805         require(account != address(0), "ERC20: burn from the zero address");
806 
807         _beforeTokenTransfer(account, address(0), burnAmount);
808 
809         _balances[account] = _balances[account].sub(
810             burnAmount,
811             "ERC20: burn amount exceeds balance"
812         );
813         _totalSupply = _totalSupply.sub(burnAmount);
814         emit Transfer(account, address(0), amount);
815     }
816 
817     /**
818      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
819      *
820      * This is internal function is equivalent to `approve`, and can be used to
821      * e.g. set automatic allowances for certain subsystems, etc.
822      *
823      * Emits an {Approval} event.
824      *
825      * Requirements:
826      *
827      * - `owner` cannot be the zero address.
828      * - `spender` cannot be the zero address.
829      */
830     function _approve(
831         address owner,
832         address spender,
833         uint256 amount
834     ) internal virtual {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842     function _decreaseApproved(
843         address owner,
844         address spender,
845         uint256 amount
846     ) internal virtual {
847         require(owner != address(0), "ERC20: approve from the zero address");
848         require(spender != address(0), "ERC20: approve to the zero address");
849 
850         _allowances[owner][spender] = _allowances[owner][spender].sub(amount);
851         emit Approval(owner, spender, _allowances[owner][spender]);
852     }
853 
854     /**
855      * @dev Sets {decimals} to a value other than the default one of 18.
856      *
857      * WARNING: This function should only be called from the constructor. Most
858      * applications that interact with token contracts will not expect
859      * {decimals} to ever change, and may work incorrectly if it does.
860      */
861     function _setupDecimals(uint8 decimals_) internal {
862         _decimals = decimals_;
863     }
864 
865     /**
866      * @dev Hook that is called before any transfer of tokens. This includes
867      * minting and burning.
868      *
869      * Calling conditions:
870      *
871      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
872      * will be to transferred to `to`.
873      * - when `from` is zero, `amount` tokens will be minted for `to`.
874      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
875      * - `from` and `to` are never both zero.
876      *
877      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
878      */
879     function _beforeTokenTransfer(
880         address from,
881         address to,
882         uint256 amount
883     ) internal virtual {}
884 }
885 
886 // File: contracts/common/DecimalConstants.sol
887 
888 pragma solidity >=0.6.0 <0.7.0;
889 
890 contract DecimalConstants {
891     uint8 public constant DEFAULT_DECIMALS = 18; // GToken and Controller use this decimals
892     uint256 public constant DEFAULT_DECIMALS_FACTOR = uint256(10)**DEFAULT_DECIMALS;
893     uint8 public constant CHAINLINK_PRICE_DECIMALS = 8;
894     uint256 public constant CHAINLINK_PRICE_DECIMAL_FACTOR = uint256(10)**CHAINLINK_PRICE_DECIMALS;
895     uint8 public constant PERCENTAGE_DECIMALS = 4;
896     uint256 public constant PERCENTAGE_DECIMAL_FACTOR = uint256(10)**PERCENTAGE_DECIMALS;
897 }
898 
899 // File: @openzeppelin/contracts/access/Ownable.sol
900 
901 
902 pragma solidity >=0.6.0 <0.8.0;
903 
904 /**
905  * @dev Contract module which provides a basic access control mechanism, where
906  * there is an account (an owner) that can be granted exclusive access to
907  * specific functions.
908  *
909  * By default, the owner account will be the one that deploys the contract. This
910  * can later be changed with {transferOwnership}.
911  *
912  * This module is used through inheritance. It will make available the modifier
913  * `onlyOwner`, which can be applied to your functions to restrict their use to
914  * the owner.
915  */
916 abstract contract Ownable is Context {
917     address private _owner;
918 
919     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
920 
921     /**
922      * @dev Initializes the contract setting the deployer as the initial owner.
923      */
924     constructor () internal {
925         address msgSender = _msgSender();
926         _owner = msgSender;
927         emit OwnershipTransferred(address(0), msgSender);
928     }
929 
930     /**
931      * @dev Returns the address of the current owner.
932      */
933     function owner() public view returns (address) {
934         return _owner;
935     }
936 
937     /**
938      * @dev Throws if called by any account other than the owner.
939      */
940     modifier onlyOwner() {
941         require(_owner == _msgSender(), "Ownable: caller is not the owner");
942         _;
943     }
944 
945     /**
946      * @dev Leaves the contract without owner. It will not be possible to call
947      * `onlyOwner` functions anymore. Can only be called by the current owner.
948      *
949      * NOTE: Renouncing ownership will leave the contract without an owner,
950      * thereby removing any functionality that is only available to the owner.
951      */
952     function renounceOwnership() public virtual onlyOwner {
953         emit OwnershipTransferred(_owner, address(0));
954         _owner = address(0);
955     }
956 
957     /**
958      * @dev Transfers ownership of the contract to a new account (`newOwner`).
959      * Can only be called by the current owner.
960      */
961     function transferOwnership(address newOwner) public virtual onlyOwner {
962         require(newOwner != address(0), "Ownable: new owner is the zero address");
963         emit OwnershipTransferred(_owner, newOwner);
964         _owner = newOwner;
965     }
966 }
967 
968 // File: contracts/common/Whitelist.sol
969 
970 pragma solidity >=0.6.0 <0.7.0;
971 
972 
973 contract Whitelist is Ownable {
974     mapping(address => bool) public whitelist;
975 
976     event LogAddToWhitelist(address indexed user);
977     event LogRemoveFromWhitelist(address indexed user);
978 
979     modifier onlyWhitelist() {
980         require(whitelist[msg.sender], "only whitelist");
981         _;
982     }
983 
984     function addToWhitelist(address user) external onlyOwner {
985         require(user != address(0), 'WhiteList: 0x');
986         whitelist[user] = true;
987         emit LogAddToWhitelist(user);
988     }
989 
990     function removeFromWhitelist(address user) external onlyOwner {
991         require(user != address(0), 'WhiteList: 0x');
992         whitelist[user] = false;
993         emit LogRemoveFromWhitelist(user);
994     }
995 }
996 
997 // File: contracts/interfaces/IController.sol
998 
999 pragma solidity >=0.6.0 <0.7.0;
1000 
1001 interface IController {
1002     function stablecoins() external view returns (address[] memory);
1003 
1004     function stablecoinsCount() external view returns (uint256);
1005 
1006     function vaults() external view returns (address[] memory);
1007 
1008     function underlyingVaults(uint256 i) external view returns (address vault);
1009 
1010     function curveVault() external view returns (address);
1011 
1012     function pnl() external view returns (address);
1013 
1014     function insurance() external view returns (address);
1015 
1016     function lifeGuard() external view returns (address);
1017 
1018     function buoy() external view returns (address);
1019 
1020     function gvt() external view returns (address);
1021 
1022     function pwrd() external view returns (address);
1023 
1024     function reward() external view returns (address);
1025 
1026     function isBigFish(uint256 amount, bool _pwrd) external view returns (bool);
1027 
1028     function withdrawHandler() external view returns (address);
1029 
1030     function depositHandler() external view returns (address);
1031 
1032     function totalAssets() external view returns (uint256);
1033 
1034     function gTokenTotalAssets() external view returns (uint256);
1035 
1036     function eoaOnly(address sender) external;
1037 
1038     function getSkimPercent() external view returns (uint256);
1039 
1040     function gToken(bool _pwrd) external view returns (address);
1041 
1042     function emergencyState() external view returns (bool);
1043 
1044     function deadCoin() external view returns (uint256);
1045 }
1046 
1047 // File: contracts/interfaces/IERC20Detailed.sol
1048 
1049 pragma solidity >=0.6.0 <0.7.0;
1050 
1051 interface IERC20Detailed {
1052 
1053     function name() external view returns (string memory);
1054 
1055     function symbol() external view returns (string memory);
1056 
1057     function decimals() external view returns (uint8);
1058 }
1059 
1060 // File: contracts/interfaces/IToken.sol
1061 
1062 pragma solidity >=0.6.0 <0.7.0;
1063 
1064 interface IToken {
1065     function factor() external view returns (uint256);
1066 
1067     function factor(uint256 totalAssets) external view returns (uint256);
1068 
1069     function mint(
1070         address account,
1071         uint256 _factor,
1072         uint256 amount
1073     ) external;
1074 
1075     function burn(
1076         address account,
1077         uint256 _factor,
1078         uint256 amount
1079     ) external;
1080 
1081     function burnAll(address account) external;
1082 
1083     function totalAssets() external view returns (uint256);
1084 
1085     function getPricePerShare() external view returns (uint256);
1086 
1087     function getShareAssets(uint256 shares) external view returns (uint256);
1088 
1089     function getAssets(address account) external view returns (uint256);
1090 }
1091 
1092 // File: contracts/tokens/GToken.sol
1093 
1094 pragma solidity >=0.6.0 <0.7.0;
1095 
1096 
1097 
1098 
1099 
1100 
1101 
1102 
1103 
1104 abstract contract GToken is GERC20, DecimalConstants, Whitelist, IToken {
1105     uint256 public constant BASE = DEFAULT_DECIMALS_FACTOR;
1106 
1107     using SafeERC20 for IERC20;
1108     using SafeMath for uint256;
1109 
1110     IController public ctrl;
1111 
1112     constructor(
1113         string memory name,
1114         string memory symbol,
1115         address controller
1116     ) public GERC20(name, symbol, DEFAULT_DECIMALS) {
1117         ctrl = IController(controller);
1118     }
1119 
1120     function setController(address controller) external onlyOwner {
1121         ctrl = IController(controller);
1122     }
1123 
1124     function factor() public view override returns (uint256) {
1125         return factor(totalAssets());
1126     }
1127 
1128     function applyFactor(
1129         uint256 a,
1130         uint256 b,
1131         bool base
1132     ) internal pure returns (uint256 resultant) {
1133         uint256 _BASE = BASE;
1134         uint256 diff;
1135         if (base) {
1136             diff = a.mul(b) % _BASE;
1137             resultant = a.mul(b).div(_BASE);
1138         } else {
1139             diff = a.mul(_BASE) % b;
1140             resultant = a.mul(_BASE).div(b);
1141         }
1142         if (diff >= 5E17) {
1143             resultant = resultant.add(1);
1144         }
1145     }
1146 
1147     function factor(uint256 totalAssets) public view override returns (uint256) {
1148         if (totalSupplyBase() == 0) {
1149             return getInitialBase();
1150         }
1151 
1152         if (totalAssets > 0) {
1153             return totalSupplyBase().mul(BASE).div(totalAssets);
1154         }
1155 
1156         return 0;
1157     }
1158 
1159     function totalAssets() public view override returns (uint256) {
1160         return ctrl.gTokenTotalAssets();
1161     }
1162 
1163     function getInitialBase() internal pure virtual returns (uint256) {
1164         return BASE;
1165     }
1166 }
1167 
1168 // File: contracts/tokens/NonRebasingGToken.sol
1169 
1170 pragma solidity >=0.6.0 <0.7.0;
1171 
1172 
1173 
1174 
1175 contract NonRebasingGToken is GToken {
1176     uint256 public constant INIT_BASE = 5000000000000000;
1177 
1178     using SafeERC20 for IERC20;
1179     using SafeMath for uint256;
1180 
1181     event LogTransfer(
1182         address indexed sender,
1183         address indexed recipient,
1184         uint256 indexed amount,
1185         uint256 factor
1186     );
1187 
1188     constructor(
1189         string memory name,
1190         string memory symbol,
1191         address controller
1192     ) public GToken(name, symbol, controller) {}
1193 
1194     function totalSupply() public view override returns (uint256) {
1195         return totalSupplyBase();
1196     }
1197 
1198     function balanceOf(address account) public view override returns (uint256) {
1199         return balanceOfBase(account);
1200     }
1201 
1202     function transfer(address recipient, uint256 amount) public override returns (bool) {
1203         super._transfer(msg.sender, recipient, amount, amount);
1204         emit LogTransfer(msg.sender, recipient, amount, factor());
1205         return true;
1206     }
1207 
1208     function getPricePerShare() public view override returns (uint256) {
1209         uint256 f = factor();
1210         return f > 0 ? applyFactor(BASE, f, false) : 0;
1211     }
1212 
1213     function getShareAssets(uint256 shares) public view override returns (uint256) {
1214         return applyFactor(shares, getPricePerShare(), true);
1215     }
1216 
1217     function getAssets(address account) external view override returns (uint256) {
1218         return getShareAssets(balanceOf(account));
1219     }
1220 
1221     function getInitialBase() internal pure override returns (uint256) {
1222         return INIT_BASE;
1223     }
1224 
1225     function mint(
1226         address account,
1227         uint256 _factor,
1228         uint256 amount
1229     ) external override onlyWhitelist {
1230         require(account != address(0), "mint: 0x");
1231         require(amount > 0, "Amount is zero.");
1232         amount = applyFactor(amount, _factor, true);
1233         _mint(account, amount, amount);
1234     }
1235 
1236     function burn(
1237         address account,
1238         uint256 _factor,
1239         uint256 amount
1240     ) external override onlyWhitelist {
1241         require(account != address(0), "burn: 0x");
1242         require(amount > 0, "Amount is zero.");
1243         amount = applyFactor(amount, _factor, true);
1244         _burn(account, amount, amount);
1245     }
1246 
1247     function burnAll(address account) external override onlyWhitelist {
1248         require(account != address(0), "burnAll: 0x");
1249         uint256 amount = balanceOfBase(account);
1250         _burn(account, amount, amount);
1251     }
1252 }