1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 pragma solidity >=0.6.0 <0.8.0;
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 pragma solidity >=0.6.2 <0.8.0;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies on extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: value }(data);
360         return _verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
370         return functionStaticCall(target, data, "Address: low-level static call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return _verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
408 
409 pragma solidity >=0.6.0 <0.8.0;
410 
411 
412 
413 
414 /**
415  * @title SafeERC20
416  * @dev Wrappers around ERC20 operations that throw on failure (when the token
417  * contract returns false). Tokens that return no value (and instead revert or
418  * throw on failure) are also supported, non-reverting calls are assumed to be
419  * successful.
420  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
421  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
422  */
423 library SafeERC20 {
424     using SafeMath for uint256;
425     using Address for address;
426 
427     function safeTransfer(IERC20 token, address to, uint256 value) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429     }
430 
431     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
433     }
434 
435     /**
436      * @dev Deprecated. This function has issues similar to the ones found in
437      * {IERC20-approve}, and its usage is discouraged.
438      *
439      * Whenever possible, use {safeIncreaseAllowance} and
440      * {safeDecreaseAllowance} instead.
441      */
442     function safeApprove(IERC20 token, address spender, uint256 value) internal {
443         // safeApprove should only be called when setting an initial allowance,
444         // or when resetting it to zero. To increase and decrease it, use
445         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
446         // solhint-disable-next-line max-line-length
447         require((value == 0) || (token.allowance(address(this), spender) == 0),
448             "SafeERC20: approve from non-zero to non-zero allowance"
449         );
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
451     }
452 
453     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).add(value);
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
461     }
462 
463     /**
464      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
465      * on the return value: the return value is optional (but if data is returned, it must not be false).
466      * @param token The token targeted by the call.
467      * @param data The call data (encoded using abi.encode or one of its variants).
468      */
469     function _callOptionalReturn(IERC20 token, bytes memory data) private {
470         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
471         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
472         // the target address contains contract code and also asserts for success in the low-level call.
473 
474         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
475         if (returndata.length > 0) { // Return data is optional
476             // solhint-disable-next-line max-line-length
477             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
478         }
479     }
480 }
481 
482 // File: @openzeppelin/contracts/GSN/Context.sol
483 
484 pragma solidity >=0.6.0 <0.8.0;
485 
486 /*
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with GSN meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address payable) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes memory) {
502         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
503         return msg.data;
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
508 
509 pragma solidity >=0.6.0 <0.8.0;
510 
511 
512 
513 
514 /**
515  * @dev Implementation of the {IERC20} interface.
516  *
517  * This implementation is agnostic to the way tokens are created. This means
518  * that a supply mechanism has to be added in a derived contract using {_mint}.
519  * For a generic mechanism see {ERC20PresetMinterPauser}.
520  *
521  * TIP: For a detailed writeup see our guide
522  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
523  * to implement supply mechanisms].
524  *
525  * We have followed general OpenZeppelin guidelines: functions revert instead
526  * of returning `false` on failure. This behavior is nonetheless conventional
527  * and does not conflict with the expectations of ERC20 applications.
528  *
529  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
530  * This allows applications to reconstruct the allowance for all accounts just
531  * by listening to said events. Other implementations of the EIP may not emit
532  * these events, as it isn't required by the specification.
533  *
534  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
535  * functions have been added to mitigate the well-known issues around setting
536  * allowances. See {IERC20-approve}.
537  */
538 contract ERC20 is Context, IERC20 {
539     using SafeMath for uint256;
540 
541     mapping (address => uint256) private _balances;
542 
543     mapping (address => mapping (address => uint256)) private _allowances;
544 
545     uint256 private _totalSupply;
546 
547     string private _name;
548     string private _symbol;
549     uint8 private _decimals;
550 
551     /**
552      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
553      * a default value of 18.
554      *
555      * To select a different value for {decimals}, use {_setupDecimals}.
556      *
557      * All three of these values are immutable: they can only be set once during
558      * construction.
559      */
560     constructor (string memory name_, string memory symbol_) public {
561         _name = name_;
562         _symbol = symbol_;
563         _decimals = 18;
564     }
565 
566     /**
567      * @dev Returns the name of the token.
568      */
569     function name() public view returns (string memory) {
570         return _name;
571     }
572 
573     /**
574      * @dev Returns the symbol of the token, usually a shorter version of the
575      * name.
576      */
577     function symbol() public view returns (string memory) {
578         return _symbol;
579     }
580 
581     /**
582      * @dev Returns the number of decimals used to get its user representation.
583      * For example, if `decimals` equals `2`, a balance of `505` tokens should
584      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
585      *
586      * Tokens usually opt for a value of 18, imitating the relationship between
587      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
588      * called.
589      *
590      * NOTE: This information is only used for _display_ purposes: it in
591      * no way affects any of the arithmetic of the contract, including
592      * {IERC20-balanceOf} and {IERC20-transfer}.
593      */
594     function decimals() public view returns (uint8) {
595         return _decimals;
596     }
597 
598     /**
599      * @dev See {IERC20-totalSupply}.
600      */
601     function totalSupply() public view override returns (uint256) {
602         return _totalSupply;
603     }
604 
605     /**
606      * @dev See {IERC20-balanceOf}.
607      */
608     function balanceOf(address account) public view override returns (uint256) {
609         return _balances[account];
610     }
611 
612     /**
613      * @dev See {IERC20-transfer}.
614      *
615      * Requirements:
616      *
617      * - `recipient` cannot be the zero address.
618      * - the caller must have a balance of at least `amount`.
619      */
620     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
621         _transfer(_msgSender(), recipient, amount);
622         return true;
623     }
624 
625     /**
626      * @dev See {IERC20-allowance}.
627      */
628     function allowance(address owner, address spender) public view virtual override returns (uint256) {
629         return _allowances[owner][spender];
630     }
631 
632     /**
633      * @dev See {IERC20-approve}.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      */
639     function approve(address spender, uint256 amount) public virtual override returns (bool) {
640         _approve(_msgSender(), spender, amount);
641         return true;
642     }
643 
644     /**
645      * @dev See {IERC20-transferFrom}.
646      *
647      * Emits an {Approval} event indicating the updated allowance. This is not
648      * required by the EIP. See the note at the beginning of {ERC20}.
649      *
650      * Requirements:
651      *
652      * - `sender` and `recipient` cannot be the zero address.
653      * - `sender` must have a balance of at least `amount`.
654      * - the caller must have allowance for ``sender``'s tokens of at least
655      * `amount`.
656      */
657     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
658         _transfer(sender, recipient, amount);
659         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
660         return true;
661     }
662 
663     /**
664      * @dev Atomically increases the allowance granted to `spender` by the caller.
665      *
666      * This is an alternative to {approve} that can be used as a mitigation for
667      * problems described in {IERC20-approve}.
668      *
669      * Emits an {Approval} event indicating the updated allowance.
670      *
671      * Requirements:
672      *
673      * - `spender` cannot be the zero address.
674      */
675     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
676         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
677         return true;
678     }
679 
680     /**
681      * @dev Atomically decreases the allowance granted to `spender` by the caller.
682      *
683      * This is an alternative to {approve} that can be used as a mitigation for
684      * problems described in {IERC20-approve}.
685      *
686      * Emits an {Approval} event indicating the updated allowance.
687      *
688      * Requirements:
689      *
690      * - `spender` cannot be the zero address.
691      * - `spender` must have allowance for the caller of at least
692      * `subtractedValue`.
693      */
694     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
695         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
696         return true;
697     }
698 
699     /**
700      * @dev Moves tokens `amount` from `sender` to `recipient`.
701      *
702      * This is internal function is equivalent to {transfer}, and can be used to
703      * e.g. implement automatic token fees, slashing mechanisms, etc.
704      *
705      * Emits a {Transfer} event.
706      *
707      * Requirements:
708      *
709      * - `sender` cannot be the zero address.
710      * - `recipient` cannot be the zero address.
711      * - `sender` must have a balance of at least `amount`.
712      */
713     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
714         require(sender != address(0), "ERC20: transfer from the zero address");
715         require(recipient != address(0), "ERC20: transfer to the zero address");
716 
717         _beforeTokenTransfer(sender, recipient, amount);
718 
719         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
720         _balances[recipient] = _balances[recipient].add(amount);
721         emit Transfer(sender, recipient, amount);
722     }
723 
724     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
725      * the total supply.
726      *
727      * Emits a {Transfer} event with `from` set to the zero address.
728      *
729      * Requirements:
730      *
731      * - `to` cannot be the zero address.
732      */
733     function _mint(address account, uint256 amount) internal virtual {
734         require(account != address(0), "ERC20: mint to the zero address");
735 
736         _beforeTokenTransfer(address(0), account, amount);
737 
738         _totalSupply = _totalSupply.add(amount);
739         _balances[account] = _balances[account].add(amount);
740         emit Transfer(address(0), account, amount);
741     }
742 
743     /**
744      * @dev Destroys `amount` tokens from `account`, reducing the
745      * total supply.
746      *
747      * Emits a {Transfer} event with `to` set to the zero address.
748      *
749      * Requirements:
750      *
751      * - `account` cannot be the zero address.
752      * - `account` must have at least `amount` tokens.
753      */
754     function _burn(address account, uint256 amount) internal virtual {
755         require(account != address(0), "ERC20: burn from the zero address");
756 
757         _beforeTokenTransfer(account, address(0), amount);
758 
759         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
760         _totalSupply = _totalSupply.sub(amount);
761         emit Transfer(account, address(0), amount);
762     }
763 
764     /**
765      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
766      *
767      * This internal function is equivalent to `approve`, and can be used to
768      * e.g. set automatic allowances for certain subsystems, etc.
769      *
770      * Emits an {Approval} event.
771      *
772      * Requirements:
773      *
774      * - `owner` cannot be the zero address.
775      * - `spender` cannot be the zero address.
776      */
777     function _approve(address owner, address spender, uint256 amount) internal virtual {
778         require(owner != address(0), "ERC20: approve from the zero address");
779         require(spender != address(0), "ERC20: approve to the zero address");
780 
781         _allowances[owner][spender] = amount;
782         emit Approval(owner, spender, amount);
783     }
784 
785     /**
786      * @dev Sets {decimals} to a value other than the default one of 18.
787      *
788      * WARNING: This function should only be called from the constructor. Most
789      * applications that interact with token contracts will not expect
790      * {decimals} to ever change, and may work incorrectly if it does.
791      */
792     function _setupDecimals(uint8 decimals_) internal {
793         _decimals = decimals_;
794     }
795 
796     /**
797      * @dev Hook that is called before any transfer of tokens. This includes
798      * minting and burning.
799      *
800      * Calling conditions:
801      *
802      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
803      * will be to transferred to `to`.
804      * - when `from` is zero, `amount` tokens will be minted for `to`.
805      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
806      * - `from` and `to` are never both zero.
807      *
808      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
809      */
810     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
811 }
812 
813 // File: @openzeppelin/contracts/access/Ownable.sol
814 
815 pragma solidity >=0.6.0 <0.8.0;
816 
817 /**
818  * @dev Contract module which provides a basic access control mechanism, where
819  * there is an account (an owner) that can be granted exclusive access to
820  * specific functions.
821  *
822  * By default, the owner account will be the one that deploys the contract. This
823  * can later be changed with {transferOwnership}.
824  *
825  * This module is used through inheritance. It will make available the modifier
826  * `onlyOwner`, which can be applied to your functions to restrict their use to
827  * the owner.
828  */
829 abstract contract Ownable is Context {
830     address private _owner;
831 
832     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
833 
834     /**
835      * @dev Initializes the contract setting the deployer as the initial owner.
836      */
837     constructor () internal {
838         address msgSender = _msgSender();
839         _owner = msgSender;
840         emit OwnershipTransferred(address(0), msgSender);
841     }
842 
843     /**
844      * @dev Returns the address of the current owner.
845      */
846     function owner() public view returns (address) {
847         return _owner;
848     }
849 
850     /**
851      * @dev Throws if called by any account other than the owner.
852      */
853     modifier onlyOwner() {
854         require(_owner == _msgSender(), "Ownable: caller is not the owner");
855         _;
856     }
857 
858     /**
859      * @dev Leaves the contract without owner. It will not be possible to call
860      * `onlyOwner` functions anymore. Can only be called by the current owner.
861      *
862      * NOTE: Renouncing ownership will leave the contract without an owner,
863      * thereby removing any functionality that is only available to the owner.
864      */
865     function renounceOwnership() public virtual onlyOwner {
866         emit OwnershipTransferred(_owner, address(0));
867         _owner = address(0);
868     }
869 
870     /**
871      * @dev Transfers ownership of the contract to a new account (`newOwner`).
872      * Can only be called by the current owner.
873      */
874     function transferOwnership(address newOwner) public virtual onlyOwner {
875         require(newOwner != address(0), "Ownable: new owner is the zero address");
876         emit OwnershipTransferred(_owner, newOwner);
877         _owner = newOwner;
878     }
879 }
880 
881 // File: contracts/SEIToken.sol
882 
883 pragma solidity 0.6.12;
884 
885 
886 
887 
888 // SEIToken with Governance.
889 contract SEIToken is ERC20("SEI Token", "SEI"), Ownable {
890     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
891     function mint(address _to, uint256 _amount) public onlyOwner {
892         _mint(_to, _amount);
893         _moveDelegates(address(0), _delegates[_to], _amount);
894     }
895 
896     // Copied and modified from YAM code:
897     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
898     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
899     // Which is copied and modified from COMPOUND:
900     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
901 
902     /// @notice A record of each accounts delegate
903     mapping (address => address) internal _delegates;
904 
905     /// @notice A checkpoint for marking number of votes from a given block
906     struct Checkpoint {
907         uint32 fromBlock;
908         uint256 votes;
909     }
910 
911     /// @notice A record of votes checkpoints for each account, by index
912     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
913 
914     /// @notice The number of checkpoints for each account
915     mapping (address => uint32) public numCheckpoints;
916 
917     /// @notice The EIP-712 typehash for the contract's domain
918     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
919 
920     /// @notice The EIP-712 typehash for the delegation struct used by the contract
921     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
922 
923     /// @notice A record of states for signing / validating signatures
924     mapping (address => uint) public nonces;
925 
926       /// @notice An event thats emitted when an account changes its delegate
927     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
928 
929     /// @notice An event thats emitted when a delegate account's vote balance changes
930     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
931 
932     /**
933      * @notice Delegate votes from `msg.sender` to `delegatee`
934      * @param delegator The address to get delegatee for
935      */
936     function delegates(address delegator)
937         external
938         view
939         returns (address)
940     {
941         return _delegates[delegator];
942     }
943 
944    /**
945     * @notice Delegate votes from `msg.sender` to `delegatee`
946     * @param delegatee The address to delegate votes to
947     */
948     function delegate(address delegatee) external {
949         return _delegate(msg.sender, delegatee);
950     }
951 
952     /**
953      * @notice Delegates votes from signatory to `delegatee`
954      * @param delegatee The address to delegate votes to
955      * @param nonce The contract state required to match the signature
956      * @param expiry The time at which to expire the signature
957      * @param v The recovery byte of the signature
958      * @param r Half of the ECDSA signature pair
959      * @param s Half of the ECDSA signature pair
960      */
961     function delegateBySig(
962         address delegatee,
963         uint nonce,
964         uint expiry,
965         uint8 v,
966         bytes32 r,
967         bytes32 s
968     )
969         external
970     {
971         bytes32 domainSeparator = keccak256(
972             abi.encode(
973                 DOMAIN_TYPEHASH,
974                 keccak256(bytes(name())),
975                 getChainId(),
976                 address(this)
977             )
978         );
979 
980         bytes32 structHash = keccak256(
981             abi.encode(
982                 DELEGATION_TYPEHASH,
983                 delegatee,
984                 nonce,
985                 expiry
986             )
987         );
988 
989         bytes32 digest = keccak256(
990             abi.encodePacked(
991                 "\x19\x01",
992                 domainSeparator,
993                 structHash
994             )
995         );
996 
997         address signatory = ecrecover(digest, v, r, s);
998         require(signatory != address(0), "SEI::delegateBySig: invalid signature");
999         require(nonce == nonces[signatory]++, "SEI::delegateBySig: invalid nonce");
1000         require(now <= expiry, "SEI::delegateBySig: signature expired");
1001         return _delegate(signatory, delegatee);
1002     }
1003 
1004     /**
1005      * @notice Gets the current votes balance for `account`
1006      * @param account The address to get votes balance
1007      * @return The number of current votes for `account`
1008      */
1009     function getCurrentVotes(address account)
1010         external
1011         view
1012         returns (uint256)
1013     {
1014         uint32 nCheckpoints = numCheckpoints[account];
1015         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1016     }
1017 
1018     /**
1019      * @notice Determine the prior number of votes for an account as of a block number
1020      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1021      * @param account The address of the account to check
1022      * @param blockNumber The block number to get the vote balance at
1023      * @return The number of votes the account had as of the given block
1024      */
1025     function getPriorVotes(address account, uint blockNumber)
1026         external
1027         view
1028         returns (uint256)
1029     {
1030         require(blockNumber < block.number, "SEI::getPriorVotes: not yet determined");
1031 
1032         uint32 nCheckpoints = numCheckpoints[account];
1033         if (nCheckpoints == 0) {
1034             return 0;
1035         }
1036 
1037         // First check most recent balance
1038         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1039             return checkpoints[account][nCheckpoints - 1].votes;
1040         }
1041 
1042         // Next check implicit zero balance
1043         if (checkpoints[account][0].fromBlock > blockNumber) {
1044             return 0;
1045         }
1046 
1047         uint32 lower = 0;
1048         uint32 upper = nCheckpoints - 1;
1049         while (upper > lower) {
1050             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1051             Checkpoint memory cp = checkpoints[account][center];
1052             if (cp.fromBlock == blockNumber) {
1053                 return cp.votes;
1054             } else if (cp.fromBlock < blockNumber) {
1055                 lower = center;
1056             } else {
1057                 upper = center - 1;
1058             }
1059         }
1060         return checkpoints[account][lower].votes;
1061     }
1062 
1063     function _delegate(address delegator, address delegatee)
1064         internal
1065     {
1066         address currentDelegate = _delegates[delegator];
1067         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SEIs (not scaled);
1068         _delegates[delegator] = delegatee;
1069 
1070         emit DelegateChanged(delegator, currentDelegate, delegatee);
1071 
1072         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1073     }
1074 
1075     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1076         if (srcRep != dstRep && amount > 0) {
1077             if (srcRep != address(0)) {
1078                 // decrease old representative
1079                 uint32 srcRepNum = numCheckpoints[srcRep];
1080                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1081                 uint256 srcRepNew = srcRepOld.sub(amount);
1082                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1083             }
1084 
1085             if (dstRep != address(0)) {
1086                 // increase new representative
1087                 uint32 dstRepNum = numCheckpoints[dstRep];
1088                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1089                 uint256 dstRepNew = dstRepOld.add(amount);
1090                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1091             }
1092         }
1093     }
1094 
1095     function _writeCheckpoint(
1096         address delegatee,
1097         uint32 nCheckpoints,
1098         uint256 oldVotes,
1099         uint256 newVotes
1100     )
1101         internal
1102     {
1103         uint32 blockNumber = safe32(block.number, "SEI::_writeCheckpoint: block number exceeds 32 bits");
1104 
1105         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1106             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1107         } else {
1108             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1109             numCheckpoints[delegatee] = nCheckpoints + 1;
1110         }
1111 
1112         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1113     }
1114 
1115     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1116         require(n < 2**32, errorMessage);
1117         return uint32(n);
1118     }
1119 
1120     function getChainId() internal pure returns (uint) {
1121         uint256 chainId;
1122         assembly { chainId := chainid() }
1123         return chainId;
1124     }
1125 }
1126 
1127 // File: contracts/SEIMasterchef.sol
1128 
1129 pragma solidity ^0.6.12;
1130 
1131 
1132 
1133 contract SEIMasterchef is Ownable {
1134     using SafeMath for uint256;
1135     using SafeERC20 for IERC20;
1136 
1137     // Info of each user.
1138     struct UserInfo {
1139         uint256 amount;     // How many LP tokens the user has provided.
1140         uint256 rewardDebt; // Reward debt. See explanation below.
1141         //
1142         // We do some fancy math here. Basically, any point in time, the amount of rewards
1143         // entitled to a user but is pending to be distributed is:
1144         //
1145         //   pending reward = (user.amount * pool.accRewardPerShare) - user.rewardDebt
1146         //
1147         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1148         //   1. The pool's `accRewardPerShare` (and `lastRewardBlock`) gets updated.
1149         //   2. User receives the pending reward sent to his/her address.
1150         //   3. User's `amount` gets updated.
1151         //   4. User's `rewardDebt` gets updated.
1152     }
1153 
1154     // Info of each pool.
1155     struct PoolInfo {
1156         IERC20 lpToken;           // Address of LP token contract.
1157         uint256 allocPoint;       // How many allocation points assigned to this pool. Rewards to distribute per block.
1158         uint256 lastRewardBlock;  // Last block number that reward distribution occurs.
1159         uint256 accRewardPerShare; // Accumulated rewards per share, times 1e12. See below.
1160     }
1161 
1162     // The SEI Reward TOKEN.
1163     SEIToken public seiToken;
1164     // Dev address.
1165     address public devaddr;
1166     // Block number when bonus rewards period ends.
1167     uint256 public bonusEndBlock;
1168     // Reward tokens created per block.
1169     uint256 public rewardPerBlock;
1170     // Bonus multiplier for early contributors.
1171     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
1172 
1173     // Info of each pool.
1174     PoolInfo[] public poolInfo;
1175     // Info of each user that stakes LP tokens.
1176     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1177     // Total allocation points. Must be the sum of all allocation points in all pools.
1178     uint256 public totalAllocPoint = 0;
1179     // The block number when reward mining starts.
1180     uint256 public startBlock;
1181 
1182     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1183     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1184     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1185 
1186     constructor(
1187         SEIToken _seiToken,
1188         address _devaddr,
1189         uint256 _rewardPerBlock,
1190         uint256 _startBlock,
1191         uint256 _bonusEndBlock
1192     ) public {
1193         seiToken = _seiToken;
1194         devaddr = _devaddr;
1195         rewardPerBlock = _rewardPerBlock;
1196         bonusEndBlock = _bonusEndBlock;
1197         startBlock = _startBlock;
1198     }
1199 
1200     function poolLength() external view returns (uint256) {
1201         return poolInfo.length;
1202     }
1203 
1204     // Add a new lp to the pool. Can only be called by the owner.
1205     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1206     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1207         if (_withUpdate) {
1208             massUpdatePools();
1209         }
1210         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1211         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1212         poolInfo.push(PoolInfo({
1213             lpToken: _lpToken,
1214             allocPoint: _allocPoint,
1215             lastRewardBlock: lastRewardBlock,
1216             accRewardPerShare: 0
1217         }));
1218     }
1219 
1220     // Update the given pool's rewards allocation point. Can only be called by the owner.
1221     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1222         if (_withUpdate) {
1223             massUpdatePools();
1224         }
1225         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1226         poolInfo[_pid].allocPoint = _allocPoint;
1227     }
1228 
1229     // Return reward multiplier over the given _from to _to block.
1230     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1231         if (_to <= bonusEndBlock) {
1232             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1233         } else if (_from >= bonusEndBlock) {
1234             return _to.sub(_from);
1235         } else {
1236             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1237                 _to.sub(bonusEndBlock)
1238             );
1239         }
1240     }
1241 
1242     // View function to see pending rewards on frontend.
1243     function pendingRewards(uint256 _pid, address _user) external view returns (uint256) {
1244         PoolInfo storage pool = poolInfo[_pid];
1245         UserInfo storage user = userInfo[_pid][_user];
1246         uint256 accRewardPerShare = pool.accRewardPerShare;
1247         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1248         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1249             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1250             uint256 reward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1251             accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
1252         }
1253         return user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
1254     }
1255 
1256     // Update reward variables for all pools. Be careful of gas spending!
1257     function massUpdatePools() public {
1258         uint256 length = poolInfo.length;
1259         for (uint256 pid = 0; pid < length; ++pid) {
1260             updatePool(pid);
1261         }
1262     }
1263 
1264     // Update reward variables of the given pool to be up-to-date.
1265     function updatePool(uint256 _pid) public {
1266         PoolInfo storage pool = poolInfo[_pid];
1267         if (block.number <= pool.lastRewardBlock) {
1268             return;
1269         }
1270         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1271         if (lpSupply == 0) {
1272             pool.lastRewardBlock = block.number;
1273             return;
1274         }
1275         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1276         uint256 reward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1277         seiToken.mint(devaddr, reward.div(20)); // 5%
1278         seiToken.mint(address(this), reward);
1279         pool.accRewardPerShare = pool.accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
1280         pool.lastRewardBlock = block.number;
1281     }
1282 
1283     // Deposit LP tokens to MasterChef for reward allocation.
1284     function deposit(uint256 _pid, uint256 _amount) public {
1285         PoolInfo storage pool = poolInfo[_pid];
1286         UserInfo storage user = userInfo[_pid][msg.sender];
1287         updatePool(_pid);
1288         if (user.amount > 0) {
1289             uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);
1290             safeTokenTransfer(msg.sender, pending);
1291         }
1292         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1293         user.amount = user.amount.add(_amount);
1294         user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
1295         emit Deposit(msg.sender, _pid, _amount);
1296     }
1297 
1298     // Withdraw LP tokens from MasterChef.
1299     function withdraw(uint256 _pid, uint256 _amount) public {
1300         PoolInfo storage pool = poolInfo[_pid];
1301         UserInfo storage user = userInfo[_pid][msg.sender];
1302         require(user.amount >= _amount, "withdraw: not good");
1303         updatePool(_pid);
1304         uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);
1305         safeTokenTransfer(msg.sender, pending);
1306         user.amount = user.amount.sub(_amount);
1307         user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
1308         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1309         emit Withdraw(msg.sender, _pid, _amount);
1310     }
1311 
1312     // Withdraw without caring about rewards. EMERGENCY ONLY.
1313     function emergencyWithdraw(uint256 _pid) public {
1314         PoolInfo storage pool = poolInfo[_pid];
1315         UserInfo storage user = userInfo[_pid][msg.sender];
1316         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1317         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1318         user.amount = 0;
1319         user.rewardDebt = 0;
1320     }
1321 
1322     // Safe token transfer function, just in case if rounding error causes pool to not have enough tokens.
1323     function safeTokenTransfer(address _to, uint256 _amount) internal {
1324         uint256 rewardBal = seiToken.balanceOf(address(this));
1325         if (_amount > rewardBal) {
1326             seiToken.transfer(_to, rewardBal);
1327         } else {
1328             seiToken.transfer(_to, _amount);
1329         }
1330     }
1331 
1332     // Update dev address by the previous dev.
1333     function dev(address _devaddr) public {
1334         require(msg.sender == devaddr, "dev: wut?");
1335         devaddr = _devaddr;
1336     }
1337 
1338     // Update rewardPerBlock value
1339     function updateRewardPerBlock(uint256 _rewardPerBlock) public {
1340         require(msg.sender == devaddr, "dev: wut?");
1341         rewardPerBlock = _rewardPerBlock;
1342         massUpdatePools();
1343     }
1344 }