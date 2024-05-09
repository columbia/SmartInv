1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
79 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
80 
81 pragma solidity >=0.6.0 <0.8.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
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
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
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
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
240 
241 pragma solidity >=0.6.2 <0.8.0;
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
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: value }(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 // solhint-disable-next-line no-inline-assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
406 
407 pragma solidity >=0.6.0 <0.8.0;
408 
409 
410 
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure (when the token
415  * contract returns false). Tokens that return no value (and instead revert or
416  * throw on failure) are also supported, non-reverting calls are assumed to be
417  * successful.
418  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
419  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
420  */
421 library SafeERC20 {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     function safeTransfer(IERC20 token, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
427     }
428 
429     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
431     }
432 
433     /**
434      * @dev Deprecated. This function has issues similar to the ones found in
435      * {IERC20-approve}, and its usage is discouraged.
436      *
437      * Whenever possible, use {safeIncreaseAllowance} and
438      * {safeDecreaseAllowance} instead.
439      */
440     function safeApprove(IERC20 token, address spender, uint256 value) internal {
441         // safeApprove should only be called when setting an initial allowance,
442         // or when resetting it to zero. To increase and decrease it, use
443         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
444         // solhint-disable-next-line max-line-length
445         require((value == 0) || (token.allowance(address(this), spender) == 0),
446             "SafeERC20: approve from non-zero to non-zero allowance"
447         );
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
449     }
450 
451     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).add(value);
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454     }
455 
456     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     /**
462      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
463      * on the return value: the return value is optional (but if data is returned, it must not be false).
464      * @param token The token targeted by the call.
465      * @param data The call data (encoded using abi.encode or one of its variants).
466      */
467     function _callOptionalReturn(IERC20 token, bytes memory data) private {
468         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
469         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
470         // the target address contains contract code and also asserts for success in the low-level call.
471 
472         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
473         if (returndata.length > 0) { // Return data is optional
474             // solhint-disable-next-line max-line-length
475             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
476         }
477     }
478 }
479 
480 
481 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
482 
483 pragma solidity >=0.6.0 <0.8.0;
484 
485 /*
486  * @dev Provides information about the current execution context, including the
487  * sender of the transaction and its data. While these are generally available
488  * via msg.sender and msg.data, they should not be accessed in such a direct
489  * manner, since when dealing with GSN meta-transactions the account sending and
490  * paying for execution may not be the actual sender (as far as an application
491  * is concerned).
492  *
493  * This contract is only required for intermediate, library-like contracts.
494  */
495 abstract contract Context {
496     function _msgSender() internal view virtual returns (address payable) {
497         return msg.sender;
498     }
499 
500     function _msgData() internal view virtual returns (bytes memory) {
501         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
502         return msg.data;
503     }
504 }
505 
506 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
507 
508 pragma solidity >=0.6.0 <0.8.0;
509 
510 
511 
512 
513 /**
514  * @dev Implementation of the {IERC20} interface.
515  *
516  * This implementation is agnostic to the way tokens are created. This means
517  * that a supply mechanism has to be added in a derived contract using {_mint}.
518  * For a generic mechanism see {ERC20PresetMinterPauser}.
519  *
520  * TIP: For a detailed writeup see our guide
521  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
522  * to implement supply mechanisms].
523  *
524  * We have followed general OpenZeppelin guidelines: functions revert instead
525  * of returning `false` on failure. This behavior is nonetheless conventional
526  * and does not conflict with the expectations of ERC20 applications.
527  *
528  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
529  * This allows applications to reconstruct the allowance for all accounts just
530  * by listening to said events. Other implementations of the EIP may not emit
531  * these events, as it isn't required by the specification.
532  *
533  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
534  * functions have been added to mitigate the well-known issues around setting
535  * allowances. See {IERC20-approve}.
536  */
537 contract ERC20 is Context, IERC20 {
538     using SafeMath for uint256;
539 
540     mapping (address => uint256) private _balances;
541 
542     mapping (address => mapping (address => uint256)) private _allowances;
543 
544     uint256 private _totalSupply;
545 
546     string private _name;
547     string private _symbol;
548     uint8 private _decimals;
549 
550     /**
551      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
552      * a default value of 18.
553      *
554      * To select a different value for {decimals}, use {_setupDecimals}.
555      *
556      * All three of these values are immutable: they can only be set once during
557      * construction.
558      */
559     constructor (string memory name_, string memory symbol_) {
560         _name = name_;
561         _symbol = symbol_;
562         _decimals = 18;
563     }
564 
565     /**
566      * @dev Returns the name of the token.
567      */
568     function name() public view returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the symbol of the token, usually a shorter version of the
574      * name.
575      */
576     function symbol() public view returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the number of decimals used to get its user representation.
582      * For example, if `decimals` equals `2`, a balance of `505` tokens should
583      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
584      *
585      * Tokens usually opt for a value of 18, imitating the relationship between
586      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
587      * called.
588      *
589      * NOTE: This information is only used for _display_ purposes: it in
590      * no way affects any of the arithmetic of the contract, including
591      * {IERC20-balanceOf} and {IERC20-transfer}.
592      */
593     function decimals() public view returns (uint8) {
594         return _decimals;
595     }
596 
597     /**
598      * @dev See {IERC20-totalSupply}.
599      */
600     function totalSupply() public view override returns (uint256) {
601         return _totalSupply;
602     }
603 
604     /**
605      * @dev See {IERC20-balanceOf}.
606      */
607     function balanceOf(address account) public view override returns (uint256) {
608         return _balances[account];
609     }
610 
611     /**
612      * @dev See {IERC20-transfer}.
613      *
614      * Requirements:
615      *
616      * - `recipient` cannot be the zero address.
617      * - the caller must have a balance of at least `amount`.
618      */
619     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
620         _transfer(_msgSender(), recipient, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-allowance}.
626      */
627     function allowance(address owner, address spender) public view virtual override returns (uint256) {
628         return _allowances[owner][spender];
629     }
630 
631     /**
632      * @dev See {IERC20-approve}.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      */
638     function approve(address spender, uint256 amount) public virtual override returns (bool) {
639         _approve(_msgSender(), spender, amount);
640         return true;
641     }
642 
643     /**
644      * @dev See {IERC20-transferFrom}.
645      *
646      * Emits an {Approval} event indicating the updated allowance. This is not
647      * required by the EIP. See the note at the beginning of {ERC20}.
648      *
649      * Requirements:
650      *
651      * - `sender` and `recipient` cannot be the zero address.
652      * - `sender` must have a balance of at least `amount`.
653      * - the caller must have allowance for ``sender``'s tokens of at least
654      * `amount`.
655      */
656     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
657         _transfer(sender, recipient, amount);
658         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
659         return true;
660     }
661 
662     /**
663      * @dev Atomically increases the allowance granted to `spender` by the caller.
664      *
665      * This is an alternative to {approve} that can be used as a mitigation for
666      * problems described in {IERC20-approve}.
667      *
668      * Emits an {Approval} event indicating the updated allowance.
669      *
670      * Requirements:
671      *
672      * - `spender` cannot be the zero address.
673      */
674     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
675         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
676         return true;
677     }
678 
679     /**
680      * @dev Atomically decreases the allowance granted to `spender` by the caller.
681      *
682      * This is an alternative to {approve} that can be used as a mitigation for
683      * problems described in {IERC20-approve}.
684      *
685      * Emits an {Approval} event indicating the updated allowance.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      * - `spender` must have allowance for the caller of at least
691      * `subtractedValue`.
692      */
693     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
694         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
695         return true;
696     }
697 
698     /**
699      * @dev Moves tokens `amount` from `sender` to `recipient`.
700      *
701      * This is internal function is equivalent to {transfer}, and can be used to
702      * e.g. implement automatic token fees, slashing mechanisms, etc.
703      *
704      * Emits a {Transfer} event.
705      *
706      * Requirements:
707      *
708      * - `sender` cannot be the zero address.
709      * - `recipient` cannot be the zero address.
710      * - `sender` must have a balance of at least `amount`.
711      */
712     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
713         require(sender != address(0), "ERC20: transfer from the zero address");
714         require(recipient != address(0), "ERC20: transfer to the zero address");
715 
716         _beforeTokenTransfer(sender, recipient, amount);
717 
718         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
719         _balances[recipient] = _balances[recipient].add(amount);
720         emit Transfer(sender, recipient, amount);
721     }
722 
723     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
724      * the total supply.
725      *
726      * Emits a {Transfer} event with `from` set to the zero address.
727      *
728      * Requirements:
729      *
730      * - `to` cannot be the zero address.
731      */
732     function _mint(address account, uint256 amount) internal virtual {
733         require(account != address(0), "ERC20: mint to the zero address");
734 
735         _beforeTokenTransfer(address(0), account, amount);
736 
737         _totalSupply = _totalSupply.add(amount);
738         _balances[account] = _balances[account].add(amount);
739         emit Transfer(address(0), account, amount);
740     }
741 
742     /**
743      * @dev Destroys `amount` tokens from `account`, reducing the
744      * total supply.
745      *
746      * Emits a {Transfer} event with `to` set to the zero address.
747      *
748      * Requirements:
749      *
750      * - `account` cannot be the zero address.
751      * - `account` must have at least `amount` tokens.
752      */
753     function _burn(address account, uint256 amount) internal virtual {
754         require(account != address(0), "ERC20: burn from the zero address");
755 
756         _beforeTokenTransfer(account, address(0), amount);
757 
758         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
759         _totalSupply = _totalSupply.sub(amount);
760         emit Transfer(account, address(0), amount);
761     }
762 
763     /**
764      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
765      *
766      * This internal function is equivalent to `approve`, and can be used to
767      * e.g. set automatic allowances for certain subsystems, etc.
768      *
769      * Emits an {Approval} event.
770      *
771      * Requirements:
772      *
773      * - `owner` cannot be the zero address.
774      * - `spender` cannot be the zero address.
775      */
776     function _approve(address owner, address spender, uint256 amount) internal virtual {
777         require(owner != address(0), "ERC20: approve from the zero address");
778         require(spender != address(0), "ERC20: approve to the zero address");
779 
780         _allowances[owner][spender] = amount;
781         emit Approval(owner, spender, amount);
782     }
783 
784     /**
785      * @dev Sets {decimals} to a value other than the default one of 18.
786      *
787      * WARNING: This function should only be called from the constructor. Most
788      * applications that interact with token contracts will not expect
789      * {decimals} to ever change, and may work incorrectly if it does.
790      */
791     function _setupDecimals(uint8 decimals_) internal {
792         _decimals = decimals_;
793     }
794 
795     /**
796      * @dev Hook that is called before any transfer of tokens. This includes
797      * minting and burning.
798      *
799      * Calling conditions:
800      *
801      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
802      * will be to transferred to `to`.
803      * - when `from` is zero, `amount` tokens will be minted for `to`.
804      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
805      * - `from` and `to` are never both zero.
806      *
807      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
808      */
809     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
810 }
811 
812 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
813 
814 pragma solidity >=0.6.0 <0.8.0;
815 
816 
817 
818 /**
819  * @dev Extension of {ERC20} that allows token holders to destroy both their own
820  * tokens and those that they have an allowance for, in a way that can be
821  * recognized off-chain (via event analysis).
822  */
823 abstract contract ERC20Burnable is Context, ERC20 {
824     using SafeMath for uint256;
825 
826     /**
827      * @dev Destroys `amount` tokens from the caller.
828      *
829      * See {ERC20-_burn}.
830      */
831     function burn(uint256 amount) public virtual {
832         _burn(_msgSender(), amount);
833     }
834 
835     /**
836      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
837      * allowance.
838      *
839      * See {ERC20-_burn} and {ERC20-allowance}.
840      *
841      * Requirements:
842      *
843      * - the caller must have allowance for ``accounts``'s tokens of at least
844      * `amount`.
845      */
846     function burnFrom(address account, uint256 amount) public virtual {
847         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
848 
849         _approve(account, _msgSender(), decreasedAllowance);
850         _burn(account, amount);
851     }
852 }
853 
854 // File: contracts\ENERGY.sol
855 
856 pragma solidity 0.7.6;
857 
858 
859 
860 
861 contract ENERGY is ERC20Burnable {
862   using SafeMath for uint256;
863 
864   uint256 public constant initialSupply = 89099136 * 10 ** 3;
865   uint256 public lastWeekTime;
866   uint256 public weekCount;
867   //staking start when week count set to 1 -> rewards calculated before just updating week
868   uint256 public constant totalWeeks = 100;
869   address public stakingContrAddr;
870   address public liquidityContrAddr;
871   uint256 public constant timeStep = 1 weeks;
872   
873   modifier onlyStaking() {
874     require(_msgSender() == stakingContrAddr, "Not staking contract");
875     _;
876   }
877 
878   constructor (address _liquidityContrAddr) ERC20("ENERGY", "NRGY") {
879     //89099.136 coins
880     _setupDecimals(6);
881     lastWeekTime = block.timestamp;
882     liquidityContrAddr = _liquidityContrAddr;
883     _mint(_msgSender(), initialSupply.mul(4).div(10)); //40%
884     _mint(liquidityContrAddr, initialSupply.mul(6).div(10)); //60%
885   }
886 
887   function mintNewCoins(uint256[3] memory lastWeekRewards) public onlyStaking returns(bool) {
888     if(weekCount >= 1) {
889         uint256 newMint = lastWeekRewards[0].add(lastWeekRewards[1]).add(lastWeekRewards[2]);
890         uint256 liquidityMint = (newMint.mul(20)).div(100);
891         _mint(liquidityContrAddr, liquidityMint);
892         _mint(stakingContrAddr, newMint);
893     } else {
894         _mint(liquidityContrAddr, initialSupply);
895     }
896     return true;
897   }
898 
899   //updates only at end of week
900   function updateWeek() public onlyStaking {
901     weekCount++;
902     lastWeekTime = block.timestamp;
903   }
904 
905   function updateStakingContract(address _stakingContrAddr) public {
906     require(stakingContrAddr == address(0), "Staking contract is already set");
907     stakingContrAddr = _stakingContrAddr;
908   }
909 
910   function burnOnUnstake(address account, uint256 amount) public onlyStaking {
911       _burn(account, amount);
912   }
913 
914   function getLastWeekUpdateTime() public view returns(uint256) {
915     return lastWeekTime;
916   }
917 
918   function isMintingCompleted() public view returns(bool) {
919     if(weekCount > totalWeeks) {
920       return true;
921     } else {
922       return false;
923     }
924   }
925 
926   function isGreaterThanAWeek() public view returns(bool) {
927     if(block.timestamp > getLastWeekUpdateTime().add(timeStep)) {
928       return true;
929     } else {
930       return false;
931     }
932   }
933 }
934 
935 // File: contracts\NRGYMarketMaker.sol
936 
937 pragma solidity 0.7.6;
938 
939 
940 
941 contract NRGYMarketMaker  {
942     using SafeERC20 for IERC20;
943     using SafeMath for uint256;
944     
945     struct UserData {
946         address user;
947         bool isActive;
948         uint256 rewards;
949         uint256 feeRewards;
950         uint256 depositTime;
951         uint256 share;
952         //update when user came first time or after unstaking to stake
953         uint256 startedWeek;
954         //update everytime whenever user comes to unstake
955         uint256 endedWeek;
956         mapping(uint256 => uint256) shareByWeekNo;
957     }
958     
959     struct FeeRewardData {
960         uint256 value;
961         uint256 timeStamp;
962         uint256 totalStakersAtThatTime;
963         uint256 weekGiven;
964         mapping(address => bool) isClaimed;
965     }
966 
967     ENERGY public energy;
968     IERC20 public lpToken;
969     uint256 public totalShares;
970     //initially it will be 27000
971     uint256[] public stakingLimit;
972     uint256 public constant minStakeForFeeRewards = 25 * 10 ** 6;
973     uint256 public totalRewards;
974     uint256 public totalFeeRewards;
975     uint256 public rewardsAvailableInContract;
976     uint256 public feeRewardsAvailableInContract;
977     uint256 public feeRewardsCount;
978     uint256 public totalStakeUsers;
979     uint256 public constant percentageDivider = 100;
980     //10%, 30%, 60%
981     uint256[3] private rewardPercentages = [10, 30, 60];
982     //7.5%
983     uint256 public constant unstakeFees = 75;
984     //total weeks
985     uint256 public totalWeeks;
986     
987     //user informations
988     mapping(uint256 => address) public userList;
989     mapping(address => UserData) public userInfo;
990     mapping (address => bool) public smartContractStakers;
991     
992     //contract info
993     mapping(uint256 => uint256) private stakePerWeek;
994     mapping(uint256 => uint256) private totalSharesByWeek;
995     mapping(uint256 => uint256[3]) private rewardByWeek;
996     mapping(uint256 => FeeRewardData) private feeRewardData;
997 
998     event Staked(address indexed _user, uint256 _amountStaked, uint256 _balanceOf);
999     event Withdrawn(address indexed _user,
1000                     uint256 _amountTransferred,
1001                     uint256 _amountUnstaked,
1002                     uint256 _shareDeducted,
1003                     uint256 _rewardsDeducted,
1004                     uint256 _feeRewardsDeducted);
1005     event RewardDistributed(uint256 _weekNo, uint256[3] _lastWeekRewards);
1006     event FeeRewardDistributed(uint256 _amount, uint256 _totalFeeRewards);
1007 
1008     constructor(address _energy) {
1009         energy = ENERGY(_energy);
1010         lpToken = IERC20(_energy);
1011         totalWeeks = energy.totalWeeks();
1012         stakingLimit.push(27000 * 10 ** 6);
1013     }
1014 
1015     // stake the coins
1016     function stake(uint256 amount) public {
1017         _stake(amount, tx.origin);
1018     }
1019     
1020     function stakeOnBehalf(uint256 amount, address _who) public {
1021         _stake(amount, _who);
1022     }
1023 
1024     function _stake(uint256 _amount, address _who) internal {
1025         uint256 _weekCount = energy.weekCount();
1026         bool isWeekOver = energy.isGreaterThanAWeek();
1027 
1028         if((_weekCount >= 1 && !isWeekOver) || _weekCount == 0) {
1029             require(!isStakingLimitReached(_amount, _weekCount), "Stake limit has been reached");
1030         }
1031 
1032         //if week over or week is 0
1033         if(!isWeekOver || _weekCount == 0) {
1034             //add current week stake
1035             stakePerWeek[_weekCount] = getStakeByWeekNo(_weekCount).add(_amount);
1036             // update current week cumulative stake
1037             //store total shares by week no at time of stake
1038             totalSharesByWeek[_weekCount] = totalShares.add(_amount);
1039             userInfo[_who].shareByWeekNo[_weekCount] = getUserShareByWeekNo(_who, _weekCount).add(_amount);
1040 
1041             //if current week share is 0 get share for previous week
1042             if(_weekCount == 0) {
1043                 if(stakingLimit[0] == totalShares.add(_amount)) {
1044                     setStakingLimit(_weekCount, stakingLimit[0]);
1045                     energy.mintNewCoins(getRewardsByWeekNo(0));
1046                     energy.updateWeek();
1047                 }
1048             }
1049         } else/*is week is greater than 1 and is over */ {
1050             //update this week shae by adding previous week share
1051             userInfo[_who].shareByWeekNo[_weekCount.add(1)] = getUserShareByWeekNo(_who, _weekCount).add(_amount);
1052             //update next week stake
1053             stakePerWeek[_weekCount.add(1)] = getStakeByWeekNo(_weekCount.add(1)).add(_amount);
1054             //update next week cumulative stake
1055             //store total shares of next week no at time of stake
1056             totalSharesByWeek[_weekCount.add(1)] = totalShares.add(_amount);
1057             setStakingLimit(_weekCount, totalShares);
1058             energy.updateWeek();
1059             //if week over update followings and greater than 1
1060             /*give rewards only after week end and till 3 more weeks of total weeks */
1061             if(_weekCount <= totalWeeks.add(3)) {
1062                 //store rewards generated that week by week no at end of week
1063                 //eg: when week 1 is over, it will store rewards generated that week before week changed from 1 to 2
1064                 setRewards(_weekCount);
1065                 uint256 rewardDistributed = (rewardByWeek[_weekCount][0])
1066                                 .add(rewardByWeek[_weekCount][1])
1067                                 .add(rewardByWeek[_weekCount][2]);
1068                 totalRewards = totalRewards.add(rewardDistributed);
1069                 energy.mintNewCoins(getRewardsByWeekNo(_weekCount));
1070                 rewardsAvailableInContract = rewardsAvailableInContract.add(rewardDistributed);
1071                 emit RewardDistributed(_weekCount, getRewardsByWeekNo(_weekCount));
1072             }
1073         }
1074         
1075         //if user not active, set current week as his start week
1076         if(!getUserStatus(_who)) {
1077             userInfo[_who].isActive = true;
1078             if(getUserShare(_who) < minStakeForFeeRewards) {
1079                 userInfo[_who].startedWeek = _weekCount;
1080                 userInfo[_who].depositTime = block.timestamp;
1081             }
1082         }
1083         
1084         if(!isUserPreviouslyStaked(_who)) {
1085             userList[totalStakeUsers] = _who;
1086             totalStakeUsers++;
1087             smartContractStakers[_who] = true;
1088             userInfo[_who].user = _who;
1089         }
1090         
1091         userInfo[_who].share = userInfo[_who].share.add(_amount);
1092         //update total shares in the end
1093         totalShares = totalShares.add(_amount);
1094         
1095         //if-> user is directly staking
1096         if(msg.sender == tx.origin) {
1097             // now we can issue shares
1098             lpToken.safeTransferFrom(_who, address(this), _amount);
1099         } else /*through liquity contract */ {
1100             // now we can issue shares
1101             //transfer from liquidty contract
1102             lpToken.safeTransferFrom(msg.sender, address(this), _amount);
1103         }
1104         emit Staked(_who, _amount, claimedBalanceOf(_who));
1105     }
1106     
1107     function setStakingLimit(uint256 _weekCount, uint256 _share) internal {
1108         uint256 lastWeekStakingLeft = stakingLimit[_weekCount].sub(getStakeByWeekNo(_weekCount));
1109         // first 4 weeks are: 0,1,2,3
1110         if(_weekCount <= 3) {
1111             //32%
1112             stakingLimit.push((_share.mul(32)).div(percentageDivider));
1113         }
1114         if(_weekCount > 3) {
1115             //0.04%
1116             stakingLimit.push((_share.mul(4)).div(percentageDivider));
1117         }
1118         stakingLimit[_weekCount.add(1)] = stakingLimit[_weekCount.add(1)].add(lastWeekStakingLeft);
1119     }
1120     
1121     function setRewards(uint256 _weekCount) internal {
1122         (rewardByWeek[_weekCount][0],
1123         rewardByWeek[_weekCount][1],
1124         rewardByWeek[_weekCount][2]) = calculateRewardsByWeekCount(_weekCount);
1125     }
1126     
1127     function calculateRewards() public view returns(uint256 _lastWeekReward, uint256 _secondLastWeekReward, uint256 _thirdLastWeekReward) {
1128         return calculateRewardsByWeekCount(energy.weekCount());
1129     }
1130     
1131     function calculateRewardsByWeekCount(uint256 _weekCount) public view returns(uint256 _lastWeekReward, uint256 _secondLastWeekReward, uint256 _thirdLastWeekReward) {
1132         bool isLastWeek = (_weekCount >= totalWeeks);
1133         if(isLastWeek) {
1134             if(_weekCount.sub(totalWeeks) == 0) {
1135                 _lastWeekReward = (getStakeByWeekNo(_weekCount).mul(rewardPercentages[0])).div(percentageDivider);
1136                 _secondLastWeekReward = (getStakeByWeekNo(_weekCount.sub(1)).mul(rewardPercentages[1])).div(percentageDivider);
1137                 _thirdLastWeekReward = (getStakeByWeekNo(_weekCount.sub(2)).mul(rewardPercentages[2])).div(percentageDivider);
1138             } else if(_weekCount.sub(totalWeeks) == 1) {
1139                 _secondLastWeekReward = (getStakeByWeekNo(_weekCount.sub(1)).mul(rewardPercentages[1])).div(percentageDivider);
1140                 _thirdLastWeekReward = (getStakeByWeekNo(_weekCount.sub(2)).mul(rewardPercentages[2])).div(percentageDivider);
1141             } else if(_weekCount.sub(totalWeeks) == 2) {
1142                 _thirdLastWeekReward = (getStakeByWeekNo(_weekCount.sub(2)).mul(rewardPercentages[2])).div(percentageDivider);
1143             }
1144         } else {
1145             if(_weekCount == 1) {
1146                 _lastWeekReward = (getStakeByWeekNo(_weekCount).mul(rewardPercentages[0])).div(percentageDivider);
1147             } else if(_weekCount == 2) {
1148                 _lastWeekReward = (getStakeByWeekNo(_weekCount).mul(rewardPercentages[0])).div(percentageDivider);
1149                 _secondLastWeekReward = (getStakeByWeekNo(_weekCount.sub(1)).mul(rewardPercentages[1])).div(percentageDivider);
1150             } else if(_weekCount >= 3) {
1151                 _lastWeekReward = (getStakeByWeekNo(_weekCount).mul(rewardPercentages[0])).div(percentageDivider);
1152                 _secondLastWeekReward = (getStakeByWeekNo(_weekCount.sub(1)).mul(rewardPercentages[1])).div(percentageDivider);
1153                 _thirdLastWeekReward = (getStakeByWeekNo(_weekCount.sub(2)).mul(rewardPercentages[2])).div(percentageDivider);
1154             }
1155         }
1156     }
1157     function isStakingLimitReached(uint256 _amount, uint256 _weekCount) public view returns(bool) {
1158         return (getStakeByWeekNo(_weekCount).add(_amount) > stakingLimit[_weekCount]);
1159     }
1160 
1161     function remainingStakingLimit(uint256 _weekCount) public view returns(uint256) {
1162         return (stakingLimit[_weekCount].sub(getStakeByWeekNo(_weekCount)));
1163     }
1164 
1165     function distributeFees(uint256 _amount) public {
1166         uint256 _weekCount = energy.weekCount();
1167         FeeRewardData storage _feeRewardData = feeRewardData[feeRewardsCount];
1168         _feeRewardData.value = _amount;
1169         _feeRewardData.timeStamp = block.timestamp;
1170         _feeRewardData.totalStakersAtThatTime = totalStakeUsers;
1171         _feeRewardData.weekGiven = _weekCount;
1172         feeRewardsCount++;
1173         totalFeeRewards = totalFeeRewards.add(_amount);
1174         feeRewardsAvailableInContract = feeRewardsAvailableInContract.add(_amount);
1175         lpToken.safeTransferFrom(msg.sender, address(this), _amount);
1176         emit FeeRewardDistributed(_amount, totalFeeRewards);
1177     }
1178 
1179     ///unstake the coins
1180     function unstake(uint256 _amount) public {
1181         UserData storage _user = userInfo[msg.sender];
1182         uint256 _weekCount = energy.weekCount();
1183         //get user rewards till date(week) and add to claimed rewards
1184         userInfo[msg.sender].rewards = _user.rewards
1185                                         .add(getUserRewardsByWeekNo(msg.sender, _weekCount));
1186         //get user fee rewards till date(week) and add to claimed fee rewards
1187         userInfo[msg.sender].feeRewards = _user.feeRewards.add(_calculateFeeRewards(msg.sender));
1188         require(_amount <= claimedBalanceOf(msg.sender), "Unstake amount is greater than user balance");
1189         //calculate unstake fee
1190         uint256 _fees = (_amount.mul(unstakeFees)).div(1000);
1191         //calulcate amount to transfer to user
1192         uint256 _toTransfer = _amount.sub(_fees);
1193         //burn unstake fees
1194         energy.burnOnUnstake(address(this), _fees);
1195         lpToken.safeTransfer(msg.sender, _toTransfer);
1196         //if amount can be paid from rewards
1197         if(_amount <= getUserTotalRewards(msg.sender)) {
1198             //if amount can be paid from rewards
1199             if(_user.rewards >= _amount) {
1200                 _user.rewards = _user.rewards.sub(_amount);
1201                 rewardsAvailableInContract = rewardsAvailableInContract.sub(_amount);
1202                 emit Withdrawn(msg.sender, _toTransfer, _amount, 0, _amount, 0);
1203             } else/*else take sum of fee rewards and rewards */ {
1204                 //get remaining amount less than rewards
1205                 uint256 remAmount = _amount.sub(_user.rewards);
1206                 rewardsAvailableInContract = rewardsAvailableInContract.sub(_user.rewards);
1207                 feeRewardsAvailableInContract = feeRewardsAvailableInContract.sub(remAmount);
1208                 emit Withdrawn(msg.sender, _toTransfer, _amount, 0, _user.rewards, remAmount);
1209                 //update fee rewards from remaining amount
1210                 _user.rewards = 0;
1211                 _user.feeRewards = _user.feeRewards.sub(remAmount);
1212             }
1213         } else/* take from total shares*/ {
1214             //get remaining amount less than rewards
1215             uint256 remAmount = _amount.sub(getUserTotalRewards(msg.sender));
1216             rewardsAvailableInContract = rewardsAvailableInContract.sub(_user.rewards);
1217             feeRewardsAvailableInContract = feeRewardsAvailableInContract.sub(_user.feeRewards);
1218             emit Withdrawn(msg.sender, _toTransfer, _amount, remAmount, _user.rewards, _user.feeRewards);
1219             _user.rewards = 0;
1220             _user.feeRewards = 0;
1221             //update user share from remaining amount
1222             _user.share = _user.share.sub(remAmount);
1223             //update total shares
1224             totalShares = totalShares.sub(remAmount);
1225             //update total shares by week no at time of unstake
1226             totalSharesByWeek[_weekCount] = totalSharesByWeek[_weekCount].sub(remAmount);
1227         }
1228         lpToken.safeApprove(address(this), 0);
1229         //set user status to false
1230         _user.isActive = false;
1231         //update user end(unstake) week
1232         _user.endedWeek = _weekCount == 0 ? _weekCount : _weekCount.sub(1);
1233     }
1234     
1235     function _calculateFeeRewards(address _who) internal returns(uint256) {
1236         uint256 _accumulatedRewards;
1237         //check if user have minimum share too claim fee rewards
1238         if(getUserShare(_who) >= minStakeForFeeRewards) {
1239             //loop through all the rewards
1240             for(uint256 i = 0; i < feeRewardsCount; i++) {
1241                 //if rewards week and timestamp is greater than user deposit time and rewards. 
1242                 //Also only if user has not claimed particular fee rewards
1243                 if(getUserStartedWeek(_who) <= feeRewardData[i].weekGiven
1244                     && getUserLastDepositTime(_who) < feeRewardData[i].timeStamp 
1245                     && !feeRewardData[i].isClaimed[_who]) {
1246                     _accumulatedRewards = _accumulatedRewards.add(feeRewardData[i].value.div(feeRewardData[i].totalStakersAtThatTime));
1247                     feeRewardData[i].isClaimed[_who] = true;
1248                 }
1249             }
1250         }
1251         return _accumulatedRewards;
1252     }
1253 
1254     /*
1255     *   ------------------Getter inteface for user---------------------
1256     *
1257     */
1258     
1259     function getUserUnclaimedFeesRewards(address _who) public view returns(uint256) {
1260         uint256 _accumulatedRewards;
1261         //check if user have minimum share too claim fee rewards
1262         if(getUserShare(_who) >= minStakeForFeeRewards) {
1263             //loop through all the rewards
1264             for(uint256 i = 0; i < feeRewardsCount; i++) {
1265                 //if rewards week and timestamp is greater than user deposit time and rewards. 
1266                 //Also only if user has not claimed particular fee rewards
1267                 if(getUserStartedWeek(_who) <= feeRewardData[i].weekGiven
1268                     && getUserLastDepositTime(_who) < feeRewardData[i].timeStamp 
1269                     && !feeRewardData[i].isClaimed[_who]) {
1270                     _accumulatedRewards = _accumulatedRewards.add(feeRewardData[i].value.div(feeRewardData[i].totalStakersAtThatTime));
1271                 }
1272             }
1273         }
1274         return _accumulatedRewards;
1275     }
1276     
1277     //return rewards till weekcount passed
1278     function getUserCurrentRewards(address _who) public view returns(uint256) {
1279         uint256 _weekCount = energy.weekCount();
1280         uint256[3] memory thisWeekReward;
1281         (thisWeekReward[0],
1282         thisWeekReward[1],
1283         thisWeekReward[2]) = calculateRewardsByWeekCount(_weekCount);
1284         uint256 userShareAtThatWeek = getUserPercentageShareByWeekNo(_who, _weekCount);
1285         return getUserRewardsByWeekNo(_who, _weekCount)
1286                 .add(_calculateRewardByUserShare(thisWeekReward, userShareAtThatWeek))
1287                 .add(getUserRewards(_who));
1288     }
1289     
1290     //return rewards till one week less than the weekcount passed
1291     //calculate rewards till previous week and deduct rewards claimed at time of unstake
1292     //return rewards available to claim
1293     function getUserRewardsByWeekNo(address _who, uint256 _weekCount) public view returns(uint256) {
1294         uint256 rewardsAccumulated;
1295         uint256 userEndWeek = getUserEndedWeek(_who);
1296         //clculate rewards only if user is active or user share is greater than 1
1297         if(getUserStatus(_who) || (getUserShare(_who) > 0)) {
1298             for(uint256 i = userEndWeek.add(1); i < _weekCount; i++) {
1299                 uint256 userShareAtThatWeek = getUserPercentageShareByWeekNo(_who, i);
1300                 rewardsAccumulated = rewardsAccumulated.add(_calculateRewardByUserShare(getRewardsByWeekNo(i), userShareAtThatWeek));
1301             }
1302         }
1303         return rewardsAccumulated;
1304     }
1305     
1306     function _calculateRewardByUserShare(uint256[3] memory rewardAtThatWeek, uint256 userShareAtThatWeek) internal pure returns(uint256) {
1307         return (((rewardAtThatWeek[0]
1308                     .add(rewardAtThatWeek[1])
1309                     .add(rewardAtThatWeek[2]))
1310                     .mul(userShareAtThatWeek))
1311                     .div(percentageDivider.mul(percentageDivider)));
1312     }
1313 
1314     function getUserPercentageShareByWeekNo(address _who, uint256 _weekCount) public view returns(uint256) {
1315         return _getUserPercentageShareByValue(getSharesByWeekNo(_weekCount), getUserShareByWeekNo(_who, _weekCount));
1316     }
1317 
1318     function _getUserPercentageShareByValue(uint256 _totalShares, uint256 _userShare) internal pure returns(uint256) {
1319         if(_totalShares == 0 || _userShare == 0) {
1320             return 0;
1321         } else {
1322             //two times percentageDivider multiplied because of decimal percentage which are less than 1
1323             return (_userShare.mul(percentageDivider.mul(percentageDivider))).div(_totalShares);
1324         }
1325     }
1326 
1327     //give sum of share(staked amount) + rewards is user have a claimed it through unstaking
1328     function claimedBalanceOf(address _who) public view returns(uint256) {
1329         return getUserShare(_who).add(getUserRewards(_who)).add(getUserFeeRewards(_who));
1330     }
1331     
1332     function getUserRewards(address _who) public view returns(uint256) {
1333         return userInfo[_who].rewards;
1334     }
1335 
1336     function getUserFeeRewards(address _who) public view returns(uint256) {
1337         return userInfo[_who].feeRewards;
1338     }
1339     
1340     function getUserTotalRewards(address _who) public view returns(uint256) {
1341         return userInfo[_who].feeRewards.add(userInfo[_who].rewards);
1342     }
1343 
1344     function getUserShare(address _who) public view returns(uint256) {
1345         return userInfo[_who].share;
1346     }
1347     
1348     function getUserShareByWeekNo(address _who, uint256 _weekCount) public view returns(uint256) {
1349         if(getUserStatus(_who)) {
1350             return (_userShareByWeekNo(_who, _weekCount) > 0 || _weekCount == 0)
1351                     ? _userShareByWeekNo(_who, _weekCount)
1352                     : getUserShareByWeekNo(_who, _weekCount.sub(1));
1353         } else if(getUserShare(_who) > 0) {
1354             return getUserShare(_who);            
1355         }
1356         return 0;
1357     }
1358     
1359     function _userShareByWeekNo(address _who, uint256 _weekCount) internal view returns(uint256) {
1360         return userInfo[_who].shareByWeekNo[_weekCount];
1361     }
1362 
1363     function getUserStatus(address _who) public view returns(bool) {
1364         return userInfo[_who].isActive;
1365     }
1366     
1367     function getUserStartedWeek(address _who) public view returns(uint256) {
1368         return userInfo[_who].startedWeek;
1369     }
1370     
1371     function getUserEndedWeek(address _who) public view returns(uint256) {
1372         return userInfo[_who].endedWeek;
1373     }
1374     
1375     function getUserLastDepositTime(address _who) public view returns(uint256) {
1376         return userInfo[_who].depositTime;
1377     }
1378 
1379     function isUserPreviouslyStaked(address _who) public view returns(bool) {
1380         return smartContractStakers[_who];
1381     }
1382     
1383     function getUserFeeRewardClaimStatus(address _who, uint256 _index) public view returns(bool) {
1384         return feeRewardData[_index].isClaimed[_who];
1385     }
1386     
1387     /*
1388     *   ------------------Getter inteface for contract---------------------
1389     *
1390     */
1391     
1392     function getRewardsByWeekNo(uint256 _weekCount) public view returns(uint256[3] memory) {
1393         return rewardByWeek[_weekCount];
1394     }
1395     
1396     function getFeeRewardsByIndex(uint256 _index) public view returns(uint256, uint256, uint256, uint256) {
1397         return (feeRewardData[_index].value,
1398                 feeRewardData[_index].timeStamp,
1399                 feeRewardData[_index].totalStakersAtThatTime,
1400                 feeRewardData[_index].weekGiven);
1401     }
1402     
1403     function getRewardPercentages() public view returns(uint256[3] memory) {
1404         return rewardPercentages;
1405     }
1406     
1407     function getStakeByWeekNo(uint256 _weekCount) public view returns(uint256) {
1408         return stakePerWeek[_weekCount];
1409     }
1410     
1411     function getSharesByWeekNo(uint256 _weekCount) public view returns(uint256) {
1412         return totalSharesByWeek[_weekCount];
1413     }
1414 }