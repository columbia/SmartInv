1 // Sources flattened with hardhat v2.0.5 https://hardhat.org
2 
3 // File contracts/ERC20/Context.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File contracts/ERC20/IERC20.sol
32 
33 // SPDX-License-Identifier: MIT
34 // adapted by udev
35 
36 pragma solidity >=0.6.0 <0.8.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 // File contracts/ERC20/SafeMath.sol
114 
115 // SPDX-License-Identifier: MIT
116 
117 pragma solidity >=0.6.0 <0.8.0;
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 
276 // File contracts/ERC20/Address.sol
277 
278 // SPDX-License-Identifier: MIT
279 
280 pragma solidity >=0.6.2 <0.8.0;
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // This method relies on extcodesize, which returns 0 for contracts in
305         // construction, since the code is only stored at the end of the
306         // constructor execution.
307 
308         uint256 size;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { size := extcodesize(account) }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{ value: amount }("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357       return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: value }(data);
397         return _verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
407         return functionStaticCall(target, data, "Address: low-level static call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a static call.
413      *
414      * _Available since v3.3._
415      */
416     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         // solhint-disable-next-line avoid-low-level-calls
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return _verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.3._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.3._
439      */
440     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
441         require(isContract(target), "Address: delegate call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.delegatecall(data);
445         return _verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 // solhint-disable-next-line no-inline-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 
469 // File contracts/ERC20/SafeERC20.sol
470 
471 // SPDX-License-Identifier: MIT
472 
473 pragma solidity >=0.6.0 <0.8.0;
474 /**
475  * @title SafeERC20
476  * @dev Wrappers around ERC20 operations that throw on failure (when the token
477  * contract returns false). Tokens that return no value (and instead revert or
478  * throw on failure) are also supported, non-reverting calls are assumed to be
479  * successful.
480  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
481  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
482  */
483 library SafeERC20 {
484     using SafeMath for uint256;
485     using Address for address;
486 
487     function safeTransfer(IERC20 token, address to, uint256 value) internal {
488         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
489     }
490 
491     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
492         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
493     }
494 
495     /**
496      * @dev Deprecated. This function has issues similar to the ones found in
497      * {IERC20-approve}, and its usage is discouraged.
498      *
499      * Whenever possible, use {safeIncreaseAllowance} and
500      * {safeDecreaseAllowance} instead.
501      */
502     function safeApprove(IERC20 token, address spender, uint256 value) internal {
503         // safeApprove should only be called when setting an initial allowance,
504         // or when resetting it to zero. To increase and decrease it, use
505         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
506         // solhint-disable-next-line max-line-length
507         require((value == 0) || (token.allowance(address(this), spender) == 0),
508             "SafeERC20: approve from non-zero to non-zero allowance"
509         );
510         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
511     }
512 
513     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
514         uint256 newAllowance = token.allowance(address(this), spender).add(value);
515         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
516     }
517 
518     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
519         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
520         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
521     }
522 
523     /**
524      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
525      * on the return value: the return value is optional (but if data is returned, it must not be false).
526      * @param token The token targeted by the call.
527      * @param data The call data (encoded using abi.encode or one of its variants).
528      */
529     function _callOptionalReturn(IERC20 token, bytes memory data) private {
530         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
531         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
532         // the target address contains contract code and also asserts for success in the low-level call.
533 
534         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
535         if (returndata.length > 0) { // Return data is optional
536             // solhint-disable-next-line max-line-length
537             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
538         }
539     }
540 }
541 
542 
543 // File contracts/ERC20/ERC20.sol
544 
545 // SPDX-License-Identifier: MIT
546 
547 pragma solidity >=0.6.0 <0.8.0;
548 //Modified 2020 udev
549 /**
550  * @dev Implementation of the {IERC20} interface.
551  *
552  * This implementation is agnostic to the way tokens are created. This means
553  * that a supply mechanism has to be added in a derived contract using {_mint}.
554  * For a generic mechanism see {ERC20PresetMinterPauser}.
555  *
556  * TIP: For a detailed writeup see our guide
557  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
558  * to implement supply mechanisms].
559  *
560  * We have followed general OpenZeppelin guidelines: functions revert instead
561  * of returning `false` on failure. This behavior is nonetheless conventional
562  * and does not conflict with the expectations of ERC20 applications.
563  *
564  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
565  * This allows applications to reconstruct the allowance for all accounts just
566  * by listening to said events. Other implementations of the EIP may not emit
567  * these events, as it isn't required by the specification.
568  *
569  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
570  * functions have been added to mitigate the well-known issues around setting
571  * allowances. See {IERC20-approve}.
572  */
573 contract ERC20 is Context, IERC20 {
574     using SafeMath for uint256;
575     using SafeERC20 for IERC20;
576 
577     mapping (address => uint256) private _balances;
578 
579     mapping (address => mapping (address => uint256)) private _allowances;
580 
581     uint256 private _totalSupply;
582 
583     string private _name;
584     string private _symbol;
585     uint8 private _decimals;
586 
587     /**
588      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
589      * a default value of 18.
590      *
591      * To select a different value for {decimals}, use {_setupDecimals}.
592      *
593      * All three of these values are immutable: they can only be set once during
594      * construction.
595      */
596     constructor (string memory name_, string memory symbol_, uint amount) public {
597         _name = name_;
598         _symbol = symbol_;
599         _decimals = 18;
600         _mint(msg.sender, amount);
601     }
602 
603     /**
604      * @dev Returns the name of the token.
605      */
606     function name() public view returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev Returns the symbol of the token, usually a shorter version of the
612      * name.
613      */
614     function symbol() public view returns (string memory) {
615         return _symbol;
616     }
617 
618     /**
619      * @dev Returns the number of decimals used to get its user representation.
620      * For example, if `decimals` equals `2`, a balance of `505` tokens should
621      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
622      *
623      * Tokens usually opt for a value of 18, imitating the relationship between
624      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
625      * called.
626      *
627      * NOTE: This information is only used for _display_ purposes: it in
628      * no way affects any of the arithmetic of the contract, including
629      * {IERC20-balanceOf} and {IERC20-transfer}.
630      */
631     function decimals() public view returns (uint8) {
632         return _decimals;
633     }
634 
635     /**
636      * @dev See {IERC20-totalSupply}.
637      */
638     function totalSupply() public view override returns (uint256) {
639         return _totalSupply;
640     }
641 
642     /**
643      * @dev See {IERC20-balanceOf}.
644      */
645     function balanceOf(address account) public view override returns (uint256) {
646         return _balances[account];
647     }
648 
649     /**
650      * @dev See {IERC20-transfer}.
651      *
652      * Requirements:
653      *
654      * - `recipient` cannot be the zero address.
655      * - the caller must have a balance of at least `amount`.
656      */
657     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
658         _transfer(_msgSender(), recipient, amount);
659         return true;
660     }
661 
662     /**
663      * @dev See {IERC20-allowance}.
664      */
665     function allowance(address owner, address spender) public view virtual override returns (uint256) {
666         return _allowances[owner][spender];
667     }
668 
669     /**
670      * @dev See {IERC20-approve}.
671      *
672      * Requirements:
673      *
674      * - `spender` cannot be the zero address.
675      */
676     function approve(address spender, uint256 amount) public virtual override returns (bool) {
677         _approve(_msgSender(), spender, amount);
678         return true;
679     }
680 
681     /**
682      * @dev See {IERC20-transferFrom}.
683      *
684      * Emits an {Approval} event indicating the updated allowance. This is not
685      * required by the EIP. See the note at the beginning of {ERC20}.
686      *
687      * Requirements:
688      *
689      * - `sender` and `recipient` cannot be the zero address.
690      * - `sender` must have a balance of at least `amount`.
691      * - the caller must have allowance for ``sender``'s tokens of at least
692      * `amount`.
693      */
694     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
695         _transfer(sender, recipient, amount);
696         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
697         return true;
698     }
699 
700     /**
701      * @dev Atomically increases the allowance granted to `spender` by the caller.
702      *
703      * This is an alternative to {approve} that can be used as a mitigation for
704      * problems described in {IERC20-approve}.
705      *
706      * Emits an {Approval} event indicating the updated allowance.
707      *
708      * Requirements:
709      *
710      * - `spender` cannot be the zero address.
711      */
712     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
713         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
714         return true;
715     }
716 
717     /**
718      * @dev Atomically decreases the allowance granted to `spender` by the caller.
719      *
720      * This is an alternative to {approve} that can be used as a mitigation for
721      * problems described in {IERC20-approve}.
722      *
723      * Emits an {Approval} event indicating the updated allowance.
724      *
725      * Requirements:
726      *
727      * - `spender` cannot be the zero address.
728      * - `spender` must have allowance for the caller of at least
729      * `subtractedValue`.
730      */
731     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
732         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
733         return true;
734     }
735 
736     /**
737      * @dev Moves tokens `amount` from `sender` to `recipient`.
738      *
739      * This is internal function is equivalent to {transfer}, and can be used to
740      * e.g. implement automatic token fees, slashing mechanisms, etc.
741      *
742      * Emits a {Transfer} event.
743      *
744      * Requirements:
745      *
746      * - `sender` cannot be the zero address.
747      * - `recipient` cannot be the zero address.
748      * - `sender` must have a balance of at least `amount`.
749      */
750     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
751         require(sender != address(0), "ERC20: transfer from the zero address");
752         require(recipient != address(0), "ERC20: transfer to the zero address");
753 
754         _beforeTokenTransfer(sender, recipient, amount);
755 
756         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
757         _balances[recipient] = _balances[recipient].add(amount);
758         emit Transfer(sender, recipient, amount);
759     }
760 
761     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
762      * the total supply.
763      *
764      * Emits a {Transfer} event with `from` set to the zero address.
765      *
766      * Requirements:
767      *
768      * - `to` cannot be the zero address.
769      */
770     function _mint(address account, uint256 amount) internal virtual {
771         require(account != address(0), "ERC20: mint to the zero address");
772 
773         _beforeTokenTransfer(address(0), account, amount);
774 
775         _totalSupply = _totalSupply.add(amount);
776         _balances[account] = _balances[account].add(amount);
777         emit Transfer(address(0), account, amount);
778     }
779 
780     /**
781      * @dev Destroys `amount` tokens from `account`, reducing the
782      * total supply.
783      *
784      * Emits a {Transfer} event with `to` set to the zero address.
785      *
786      * Requirements:
787      *
788      * - `account` cannot be the zero address.
789      * - `account` must have at least `amount` tokens.
790      */
791     function _burn(address account, uint256 amount) internal virtual {
792         require(account != address(0), "ERC20: burn from the zero address");
793 
794         _beforeTokenTransfer(account, address(0), amount);
795 
796         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
797         _totalSupply = _totalSupply.sub(amount);
798         emit Transfer(account, address(0), amount);
799     }
800 
801     /**
802      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
803      *
804      * This internal function is equivalent to `approve`, and can be used to
805      * e.g. set automatic allowances for certain subsystems, etc.
806      *
807      * Emits an {Approval} event.
808      *
809      * Requirements:
810      *
811      * - `owner` cannot be the zero address.
812      * - `spender` cannot be the zero address.
813      */
814     function _approve(address owner, address spender, uint256 amount) internal virtual {
815         require(owner != address(0), "ERC20: approve from the zero address");
816         require(spender != address(0), "ERC20: approve to the zero address");
817 
818         _allowances[owner][spender] = amount;
819         emit Approval(owner, spender, amount);
820     }
821 
822     /**
823      * @dev Sets {decimals} to a value other than the default one of 18.
824      *
825      * WARNING: This function should only be called from the constructor. Most
826      * applications that interact with token contracts will not expect
827      * {decimals} to ever change, and may work incorrectly if it does.
828      */
829     function _setupDecimals(uint8 decimals_) internal {
830         _decimals = decimals_;
831     }
832 
833     /**
834      * @dev Hook that is called before any transfer of tokens. This includes
835      * minting and burning.
836      *
837      * Calling conditions:
838      *
839      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
840      * will be to transferred to `to`.
841      * - when `from` is zero, `amount` tokens will be minted for `to`.
842      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
843      * - `from` and `to` are never both zero.
844      *
845      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
846      */
847     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
848 }
849 
850 
851 // File contracts/ERC20/ERC20TransferTax.sol
852 
853 // SPDX-License-Identifier: MIT
854 
855 pragma solidity >=0.6.0 <0.8.0;
856 //Modified 2020 udev
857 /**
858  * @dev Implementation of the {IERC20} interface.
859  *
860  * This implementation is agnostic to the way tokens are created. This means
861  * that a supply mechanism has to be added in a derived contract using {_mint}.
862  * For a generic mechanism see {ERC20PresetMinterPauser}.
863  *
864  * TIP: For a detailed writeup see our guide
865  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
866  * to implement supply mechanisms].
867  *
868  * We have followed general OpenZeppelin guidelines: functions revert instead
869  * of returning `false` on failure. This behavior is nonetheless conventional
870  * and does not conflict with the expectations of ERC20 applications.
871  *
872  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
873  * This allows applications to reconstruct the allowance for all accounts just
874  * by listening to said events. Other implementations of the EIP may not emit
875  * these events, as it isn't required by the specification.
876  *
877  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
878  * functions have been added to mitigate the well-known issues around setting
879  * allowances. See {IERC20-approve}.
880  */
881 contract ERC20TransferTax is Context, IERC20 {
882     using SafeMath for uint256;
883     using SafeERC20 for IERC20;
884 
885     mapping (address => uint256) private _balances;
886 
887     mapping (address => mapping (address => uint256)) private _allowances;
888 
889     uint256 private _totalSupply;
890 
891     string private _name;
892     string private _symbol;
893     uint8 private _decimals;
894 
895     uint public taxBips;
896     address public taxMan;
897     mapping(address => bool) public isNotTaxed;
898 
899     /**
900      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
901      * a default value of 18. Sets {taxBips} tax rate in 1/10000 with {taxMan}
902      * as tax receiver and tax status manager.
903      *
904      * To select a different value for {decimals}, use {_setupDecimals}.
905      *
906      * All three of these values are immutable: they can only be set once during
907      * construction.
908      */
909     constructor (string memory name_, string memory symbol_, uint amount, address taxMan_, uint taxBips_) public {
910         _name = name_;
911         _symbol = symbol_;
912         _decimals = 18;
913         _mint(msg.sender, amount);
914         taxMan = taxMan_;
915         taxBips = taxBips_;
916     }
917 
918     /**
919      * @dev Sets tax status for account, both on send and receive.
920      */
921     function setIsTaxed(address account, bool isTaxed_) external {
922         require(msg.sender == taxMan, "!taxMan");
923         isNotTaxed[account] = !isTaxed_;
924     }
925 
926     /**
927      * @dev Changes the {taxMan}.
928      */
929     function transferTaxman(address taxMan_) external {
930         require(msg.sender == taxMan, "!taxMan");
931         taxMan = taxMan_;
932     }
933 
934     /**
935      * @dev Returns the name of the token.
936      */
937     function name() public view returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev Returns the symbol of the token, usually a shorter version of the
943      * name.
944      */
945     function symbol() public view returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev Returns the number of decimals used to get its user representation.
951      * For example, if `decimals` equals `2`, a balance of `505` tokens should
952      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
953      *
954      * Tokens usually opt for a value of 18, imitating the relationship between
955      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
956      * called.
957      *
958      * NOTE: This information is only used for _display_ purposes: it in
959      * no way affects any of the arithmetic of the contract, including
960      * {IERC20-balanceOf} and {IERC20-transfer}.
961      */
962     function decimals() public view returns (uint8) {
963         return _decimals;
964     }
965 
966     /**
967      * @dev See {IERC20-totalSupply}.
968      */
969     function totalSupply() public view override returns (uint256) {
970         return _totalSupply;
971     }
972 
973     /**
974      * @dev See {IERC20-balanceOf}.
975      */
976     function balanceOf(address account) public view override returns (uint256) {
977         return _balances[account];
978     }
979 
980     /**
981      * @dev See {IERC20-transfer}.
982      *
983      * Requirements:
984      *
985      * - `recipient` cannot be the zero address.
986      * - the caller must have a balance of at least `amount`.
987      */
988     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
989         _transfer(_msgSender(), recipient, amount);
990         return true;
991     }
992 
993     /**
994      * @dev See {IERC20-allowance}.
995      */
996     function allowance(address owner, address spender) public view virtual override returns (uint256) {
997         return _allowances[owner][spender];
998     }
999 
1000     /**
1001      * @dev See {IERC20-approve}.
1002      *
1003      * Requirements:
1004      *
1005      * - `spender` cannot be the zero address.
1006      */
1007     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1008         _approve(_msgSender(), spender, amount);
1009         return true;
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-transferFrom}.
1014      *
1015      * Emits an {Approval} event indicating the updated allowance. This is not
1016      * required by the EIP. See the note at the beginning of {ERC20}.
1017      *
1018      * Requirements:
1019      *
1020      * - `sender` and `recipient` cannot be the zero address.
1021      * - `sender` must have a balance of at least `amount`.
1022      * - the caller must have allowance for ``sender``'s tokens of at least
1023      * `amount`.
1024      */
1025     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1026         _transfer(sender, recipient, amount);
1027         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1028         return true;
1029     }
1030 
1031     /**
1032      * @dev Atomically increases the allowance granted to `spender` by the caller.
1033      *
1034      * This is an alternative to {approve} that can be used as a mitigation for
1035      * problems described in {IERC20-approve}.
1036      *
1037      * Emits an {Approval} event indicating the updated allowance.
1038      *
1039      * Requirements:
1040      *
1041      * - `spender` cannot be the zero address.
1042      */
1043     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1044         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1045         return true;
1046     }
1047 
1048     /**
1049      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1050      *
1051      * This is an alternative to {approve} that can be used as a mitigation for
1052      * problems described in {IERC20-approve}.
1053      *
1054      * Emits an {Approval} event indicating the updated allowance.
1055      *
1056      * Requirements:
1057      *
1058      * - `spender` cannot be the zero address.
1059      * - `spender` must have allowance for the caller of at least
1060      * `subtractedValue`.
1061      */
1062     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1063         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1064         return true;
1065     }
1066 
1067     /**
1068      * @dev Moves tokens `amount` from `sender` to `recipient` with {taxBips} to
1069      * {taxMan}.
1070      *
1071      * This is internal function is equivalent to {transfer}, and can be used to
1072      * e.g. implement automatic token fees, slashing mechanisms, etc.
1073      *
1074      * Emits a {Transfer} event.
1075      *
1076      * Requirements:
1077      *
1078      * - `sender` cannot be the zero address.
1079      * - `recipient` cannot be the zero address.
1080      * - `sender` must have a balance of at least `amount`.
1081      */
1082     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1083         require(sender != address(0), "ERC20: transfer from the zero address");
1084         require(recipient != address(0), "ERC20: transfer to the zero address");
1085 
1086         if(isNotTaxed[sender] || isNotTaxed[recipient]) {
1087             _beforeTokenTransfer(sender, recipient, amount);
1088             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1089             _balances[recipient] = _balances[recipient].add(amount);
1090             emit Transfer(sender, recipient, amount);
1091         } else {
1092             uint tax = amount.mul(taxBips).div(10000);
1093             uint postTaxAmount = amount.sub(tax);
1094 
1095             _beforeTokenTransfer(sender, recipient, postTaxAmount);
1096             _beforeTokenTransfer(sender, taxMan, tax);
1097 
1098             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1099 
1100             _balances[recipient] = _balances[recipient].add(postTaxAmount);
1101             _balances[taxMan] = _balances[taxMan].add(tax);
1102 
1103             emit Transfer(sender, recipient, postTaxAmount);
1104             emit Transfer(sender, taxMan, tax);
1105         }        
1106     }
1107 
1108     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1109      * the total supply.
1110      *
1111      * Emits a {Transfer} event with `from` set to the zero address.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      */
1117     function _mint(address account, uint256 amount) internal virtual {
1118         require(account != address(0), "ERC20: mint to the zero address");
1119 
1120         _beforeTokenTransfer(address(0), account, amount);
1121 
1122         _totalSupply = _totalSupply.add(amount);
1123         _balances[account] = _balances[account].add(amount);
1124         emit Transfer(address(0), account, amount);
1125     }
1126 
1127     /**
1128      * @dev Destroys `amount` tokens from `account`, reducing the
1129      * total supply.
1130      *
1131      * Emits a {Transfer} event with `to` set to the zero address.
1132      *
1133      * Requirements:
1134      *
1135      * - `account` cannot be the zero address.
1136      * - `account` must have at least `amount` tokens.
1137      */
1138     function _burn(address account, uint256 amount) internal virtual {
1139         require(account != address(0), "ERC20: burn from the zero address");
1140 
1141         _beforeTokenTransfer(account, address(0), amount);
1142 
1143         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1144         _totalSupply = _totalSupply.sub(amount);
1145         emit Transfer(account, address(0), amount);
1146     }
1147 
1148     /**
1149      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1150      *
1151      * This internal function is equivalent to `approve`, and can be used to
1152      * e.g. set automatic allowances for certain subsystems, etc.
1153      *
1154      * Emits an {Approval} event.
1155      *
1156      * Requirements:
1157      *
1158      * - `owner` cannot be the zero address.
1159      * - `spender` cannot be the zero address.
1160      */
1161     function _approve(address owner, address spender, uint256 amount) internal virtual {
1162         require(owner != address(0), "ERC20: approve from the zero address");
1163         require(spender != address(0), "ERC20: approve to the zero address");
1164 
1165         _allowances[owner][spender] = amount;
1166         emit Approval(owner, spender, amount);
1167     }
1168 
1169     /**
1170      * @dev Sets {decimals} to a value other than the default one of 18.
1171      *
1172      * WARNING: This function should only be called from the constructor. Most
1173      * applications that interact with token contracts will not expect
1174      * {decimals} to ever change, and may work incorrectly if it does.
1175      */
1176     function _setupDecimals(uint8 decimals_) internal {
1177         _decimals = decimals_;
1178     }
1179 
1180     /**
1181      * @dev Hook that is called before any transfer of tokens. This includes
1182      * minting and burning.
1183      *
1184      * Calling conditions:
1185      *
1186      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1187      * will be to transferred to `to`.
1188      * - when `from` is zero, `amount` tokens will be minted for `to`.
1189      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1190      * - `from` and `to` are never both zero.
1191      *
1192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1193      */
1194     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1195 }
1196 
1197 
1198 // File contracts/interfaces/IXEth.sol
1199 
1200 // SPDX-License-Identifier: GPL-3.0-or-later
1201 pragma solidity =0.6.6;
1202 // Copyright (C) udev 2020
1203 interface IXEth is IERC20 {
1204     function deposit() external payable;
1205 
1206     function xlockerMint(uint256 wad, address dst) external;
1207 
1208     function withdraw(uint256 wad) external;
1209 
1210     function permit(
1211         address owner,
1212         address spender,
1213         uint256 value,
1214         uint256 deadline,
1215         uint8 v,
1216         bytes32 r,
1217         bytes32 s
1218     ) external;
1219 
1220     function nonces(address owner) external view returns (uint256);
1221 
1222     event Deposit(address indexed dst, uint256 wad);
1223     event Withdrawal(address indexed src, uint256 wad);
1224     event XlockerMint(uint256 wad, address dst);
1225 }
1226 
1227 
1228 // File contracts/Uniswap/IUniswapV2Router01.sol
1229 
1230 pragma solidity >=0.6.2;
1231 
1232 interface IUniswapV2Router01 {
1233     function factory() external pure returns (address);
1234     function WETH() external pure returns (address);
1235 
1236     function addLiquidity(
1237         address tokenA,
1238         address tokenB,
1239         uint amountADesired,
1240         uint amountBDesired,
1241         uint amountAMin,
1242         uint amountBMin,
1243         address to,
1244         uint deadline
1245     ) external returns (uint amountA, uint amountB, uint liquidity);
1246     function addLiquidityETH(
1247         address token,
1248         uint amountTokenDesired,
1249         uint amountTokenMin,
1250         uint amountETHMin,
1251         address to,
1252         uint deadline
1253     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1254     function removeLiquidity(
1255         address tokenA,
1256         address tokenB,
1257         uint liquidity,
1258         uint amountAMin,
1259         uint amountBMin,
1260         address to,
1261         uint deadline
1262     ) external returns (uint amountA, uint amountB);
1263     function removeLiquidityETH(
1264         address token,
1265         uint liquidity,
1266         uint amountTokenMin,
1267         uint amountETHMin,
1268         address to,
1269         uint deadline
1270     ) external returns (uint amountToken, uint amountETH);
1271     function removeLiquidityWithPermit(
1272         address tokenA,
1273         address tokenB,
1274         uint liquidity,
1275         uint amountAMin,
1276         uint amountBMin,
1277         address to,
1278         uint deadline,
1279         bool approveMax, uint8 v, bytes32 r, bytes32 s
1280     ) external returns (uint amountA, uint amountB);
1281     function removeLiquidityETHWithPermit(
1282         address token,
1283         uint liquidity,
1284         uint amountTokenMin,
1285         uint amountETHMin,
1286         address to,
1287         uint deadline,
1288         bool approveMax, uint8 v, bytes32 r, bytes32 s
1289     ) external returns (uint amountToken, uint amountETH);
1290     function swapExactTokensForTokens(
1291         uint amountIn,
1292         uint amountOutMin,
1293         address[] calldata path,
1294         address to,
1295         uint deadline
1296     ) external returns (uint[] memory amounts);
1297     function swapTokensForExactTokens(
1298         uint amountOut,
1299         uint amountInMax,
1300         address[] calldata path,
1301         address to,
1302         uint deadline
1303     ) external returns (uint[] memory amounts);
1304     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1305         external
1306         payable
1307         returns (uint[] memory amounts);
1308     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1309         external
1310         returns (uint[] memory amounts);
1311     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1312         external
1313         returns (uint[] memory amounts);
1314     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1315         external
1316         payable
1317         returns (uint[] memory amounts);
1318 
1319     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1320     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1321     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1322     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1323     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1324 }
1325 
1326 
1327 // File contracts/Uniswap/IUniswapV2Router02.sol
1328 
1329 pragma solidity >=0.6.2;
1330 interface IUniswapV2Router02 is IUniswapV2Router01 {
1331     function removeLiquidityETHSupportingFeeOnTransferTokens(
1332         address token,
1333         uint liquidity,
1334         uint amountTokenMin,
1335         uint amountETHMin,
1336         address to,
1337         uint deadline
1338     ) external returns (uint amountETH);
1339     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1340         address token,
1341         uint liquidity,
1342         uint amountTokenMin,
1343         uint amountETHMin,
1344         address to,
1345         uint deadline,
1346         bool approveMax, uint8 v, bytes32 r, bytes32 s
1347     ) external returns (uint amountETH);
1348 
1349     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1350         uint amountIn,
1351         uint amountOutMin,
1352         address[] calldata path,
1353         address to,
1354         uint deadline
1355     ) external;
1356     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1357         uint amountOutMin,
1358         address[] calldata path,
1359         address to,
1360         uint deadline
1361     ) external payable;
1362     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1363         uint amountIn,
1364         uint amountOutMin,
1365         address[] calldata path,
1366         address to,
1367         uint deadline
1368     ) external;
1369 }
1370 
1371 
1372 // File contracts/Uniswap/IUniswapV2Pair.sol
1373 
1374 pragma solidity >=0.5.0;
1375 
1376 interface IUniswapV2Pair {
1377     event Approval(address indexed owner, address indexed spender, uint value);
1378     event Transfer(address indexed from, address indexed to, uint value);
1379 
1380     function name() external pure returns (string memory);
1381     function symbol() external pure returns (string memory);
1382     function decimals() external pure returns (uint8);
1383     function totalSupply() external view returns (uint);
1384     function balanceOf(address owner) external view returns (uint);
1385     function allowance(address owner, address spender) external view returns (uint);
1386 
1387     function approve(address spender, uint value) external returns (bool);
1388     function transfer(address to, uint value) external returns (bool);
1389     function transferFrom(address from, address to, uint value) external returns (bool);
1390 
1391     function DOMAIN_SEPARATOR() external view returns (bytes32);
1392     function PERMIT_TYPEHASH() external pure returns (bytes32);
1393     function nonces(address owner) external view returns (uint);
1394 
1395     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1396 
1397     event Mint(address indexed sender, uint amount0, uint amount1);
1398     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1399     event Swap(
1400         address indexed sender,
1401         uint amount0In,
1402         uint amount1In,
1403         uint amount0Out,
1404         uint amount1Out,
1405         address indexed to
1406     );
1407     event Sync(uint112 reserve0, uint112 reserve1);
1408 
1409     function MINIMUM_LIQUIDITY() external pure returns (uint);
1410     function factory() external view returns (address);
1411     function token0() external view returns (address);
1412     function token1() external view returns (address);
1413     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1414     function price0CumulativeLast() external view returns (uint);
1415     function price1CumulativeLast() external view returns (uint);
1416     function kLast() external view returns (uint);
1417 
1418     function mint(address to) external returns (uint liquidity);
1419     function burn(address to) external returns (uint amount0, uint amount1);
1420     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1421     function skim(address to) external;
1422     function sync() external;
1423 
1424     function initialize(address, address) external;
1425 }
1426 
1427 
1428 // File contracts/Uniswap/UniswapV2Library.sol
1429 
1430 pragma solidity >=0.5.0;
1431 library UniswapV2Library {
1432     using SafeMath for uint;
1433 
1434     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1435     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1436         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1437         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1438         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1439     }
1440 
1441     // calculates the CREATE2 address for a pair without making any external calls
1442     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1443         (address token0, address token1) = sortTokens(tokenA, tokenB);
1444         pair = address(uint(keccak256(abi.encodePacked(
1445                 hex'ff',
1446                 factory,
1447                 keccak256(abi.encodePacked(token0, token1)),
1448                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1449             ))));
1450     }
1451 
1452     // fetches and sorts the reserves for a pair
1453     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
1454         (address token0,) = sortTokens(tokenA, tokenB);
1455         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
1456         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1457     }
1458 
1459     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1460     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
1461         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1462         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1463         amountB = amountA.mul(reserveB) / reserveA;
1464     }
1465 
1466     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1467     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
1468         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1469         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1470         uint amountInWithFee = amountIn.mul(997);
1471         uint numerator = amountInWithFee.mul(reserveOut);
1472         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1473         amountOut = numerator / denominator;
1474     }
1475 
1476     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1477     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
1478         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1479         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1480         uint numerator = reserveIn.mul(amountOut).mul(1000);
1481         uint denominator = reserveOut.sub(amountOut).mul(997);
1482         amountIn = (numerator / denominator).add(1);
1483     }
1484 
1485     // performs chained getAmountOut calculations on any number of pairs
1486     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1487         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1488         amounts = new uint[](path.length);
1489         amounts[0] = amountIn;
1490         for (uint i; i < path.length - 1; i++) {
1491             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1492             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1493         }
1494     }
1495 
1496     // performs chained getAmountIn calculations on any number of pairs
1497     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1498         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1499         amounts = new uint[](path.length);
1500         amounts[amounts.length - 1] = amountOut;
1501         for (uint i = path.length - 1; i > 0; i--) {
1502             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1503             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1504         }
1505     }
1506 }
1507 
1508 
1509 // File @openzeppelin/contracts-ethereum-package/contracts/utils/EnumerableSet.sol@v3.0.0
1510 
1511 pragma solidity ^0.6.0;
1512 
1513 /**
1514  * @dev Library for managing
1515  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1516  * types.
1517  *
1518  * Sets have the following properties:
1519  *
1520  * - Elements are added, removed, and checked for existence in constant time
1521  * (O(1)).
1522  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1523  *
1524  * ```
1525  * contract Example {
1526  *     // Add the library methods
1527  *     using EnumerableSet for EnumerableSet.AddressSet;
1528  *
1529  *     // Declare a set state variable
1530  *     EnumerableSet.AddressSet private mySet;
1531  * }
1532  * ```
1533  *
1534  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1535  * (`UintSet`) are supported.
1536  */
1537 library EnumerableSet {
1538     // To implement this library for multiple types with as little code
1539     // repetition as possible, we write it in terms of a generic Set type with
1540     // bytes32 values.
1541     // The Set implementation uses private functions, and user-facing
1542     // implementations (such as AddressSet) are just wrappers around the
1543     // underlying Set.
1544     // This means that we can only create new EnumerableSets for types that fit
1545     // in bytes32.
1546 
1547     struct Set {
1548         // Storage of set values
1549         bytes32[] _values;
1550 
1551         // Position of the value in the `values` array, plus 1 because index 0
1552         // means a value is not in the set.
1553         mapping (bytes32 => uint256) _indexes;
1554     }
1555 
1556     /**
1557      * @dev Add a value to a set. O(1).
1558      *
1559      * Returns true if the value was added to the set, that is if it was not
1560      * already present.
1561      */
1562     function _add(Set storage set, bytes32 value) private returns (bool) {
1563         if (!_contains(set, value)) {
1564             set._values.push(value);
1565             // The value is stored at length-1, but we add 1 to all indexes
1566             // and use 0 as a sentinel value
1567             set._indexes[value] = set._values.length;
1568             return true;
1569         } else {
1570             return false;
1571         }
1572     }
1573 
1574     /**
1575      * @dev Removes a value from a set. O(1).
1576      *
1577      * Returns true if the value was removed from the set, that is if it was
1578      * present.
1579      */
1580     function _remove(Set storage set, bytes32 value) private returns (bool) {
1581         // We read and store the value's index to prevent multiple reads from the same storage slot
1582         uint256 valueIndex = set._indexes[value];
1583 
1584         if (valueIndex != 0) { // Equivalent to contains(set, value)
1585             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1586             // the array, and then remove the last element (sometimes called as 'swap and pop').
1587             // This modifies the order of the array, as noted in {at}.
1588 
1589             uint256 toDeleteIndex = valueIndex - 1;
1590             uint256 lastIndex = set._values.length - 1;
1591 
1592             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1593             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1594 
1595             bytes32 lastvalue = set._values[lastIndex];
1596 
1597             // Move the last value to the index where the value to delete is
1598             set._values[toDeleteIndex] = lastvalue;
1599             // Update the index for the moved value
1600             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1601 
1602             // Delete the slot where the moved value was stored
1603             set._values.pop();
1604 
1605             // Delete the index for the deleted slot
1606             delete set._indexes[value];
1607 
1608             return true;
1609         } else {
1610             return false;
1611         }
1612     }
1613 
1614     /**
1615      * @dev Returns true if the value is in the set. O(1).
1616      */
1617     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1618         return set._indexes[value] != 0;
1619     }
1620 
1621     /**
1622      * @dev Returns the number of values on the set. O(1).
1623      */
1624     function _length(Set storage set) private view returns (uint256) {
1625         return set._values.length;
1626     }
1627 
1628    /**
1629     * @dev Returns the value stored at position `index` in the set. O(1).
1630     *
1631     * Note that there are no guarantees on the ordering of values inside the
1632     * array, and it may change when more values are added or removed.
1633     *
1634     * Requirements:
1635     *
1636     * - `index` must be strictly less than {length}.
1637     */
1638     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1639         require(set._values.length > index, "EnumerableSet: index out of bounds");
1640         return set._values[index];
1641     }
1642 
1643     // AddressSet
1644 
1645     struct AddressSet {
1646         Set _inner;
1647     }
1648 
1649     /**
1650      * @dev Add a value to a set. O(1).
1651      *
1652      * Returns true if the value was added to the set, that is if it was not
1653      * already present.
1654      */
1655     function add(AddressSet storage set, address value) internal returns (bool) {
1656         return _add(set._inner, bytes32(uint256(value)));
1657     }
1658 
1659     /**
1660      * @dev Removes a value from a set. O(1).
1661      *
1662      * Returns true if the value was removed from the set, that is if it was
1663      * present.
1664      */
1665     function remove(AddressSet storage set, address value) internal returns (bool) {
1666         return _remove(set._inner, bytes32(uint256(value)));
1667     }
1668 
1669     /**
1670      * @dev Returns true if the value is in the set. O(1).
1671      */
1672     function contains(AddressSet storage set, address value) internal view returns (bool) {
1673         return _contains(set._inner, bytes32(uint256(value)));
1674     }
1675 
1676     /**
1677      * @dev Returns the number of values in the set. O(1).
1678      */
1679     function length(AddressSet storage set) internal view returns (uint256) {
1680         return _length(set._inner);
1681     }
1682 
1683    /**
1684     * @dev Returns the value stored at position `index` in the set. O(1).
1685     *
1686     * Note that there are no guarantees on the ordering of values inside the
1687     * array, and it may change when more values are added or removed.
1688     *
1689     * Requirements:
1690     *
1691     * - `index` must be strictly less than {length}.
1692     */
1693     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1694         return address(uint256(_at(set._inner, index)));
1695     }
1696 
1697 
1698     // UintSet
1699 
1700     struct UintSet {
1701         Set _inner;
1702     }
1703 
1704     /**
1705      * @dev Add a value to a set. O(1).
1706      *
1707      * Returns true if the value was added to the set, that is if it was not
1708      * already present.
1709      */
1710     function add(UintSet storage set, uint256 value) internal returns (bool) {
1711         return _add(set._inner, bytes32(value));
1712     }
1713 
1714     /**
1715      * @dev Removes a value from a set. O(1).
1716      *
1717      * Returns true if the value was removed from the set, that is if it was
1718      * present.
1719      */
1720     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1721         return _remove(set._inner, bytes32(value));
1722     }
1723 
1724     /**
1725      * @dev Returns true if the value is in the set. O(1).
1726      */
1727     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1728         return _contains(set._inner, bytes32(value));
1729     }
1730 
1731     /**
1732      * @dev Returns the number of values on the set. O(1).
1733      */
1734     function length(UintSet storage set) internal view returns (uint256) {
1735         return _length(set._inner);
1736     }
1737 
1738    /**
1739     * @dev Returns the value stored at position `index` in the set. O(1).
1740     *
1741     * Note that there are no guarantees on the ordering of values inside the
1742     * array, and it may change when more values are added or removed.
1743     *
1744     * Requirements:
1745     *
1746     * - `index` must be strictly less than {length}.
1747     */
1748     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1749         return uint256(_at(set._inner, index));
1750     }
1751 }
1752 
1753 // File @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol@v3.0.0
1754 
1755 pragma solidity >=0.4.24 <0.7.0;
1756 
1757 
1758 /**
1759  * @title Initializable
1760  *
1761  * @dev Helper contract to support initializer functions. To use it, replace
1762  * the constructor with a function that has the `initializer` modifier.
1763  * WARNING: Unlike constructors, initializer functions must be manually
1764  * invoked. This applies both to deploying an Initializable contract, as well
1765  * as extending an Initializable contract via inheritance.
1766  * WARNING: When used with inheritance, manual care must be taken to not invoke
1767  * a parent initializer twice, or ensure that all initializers are idempotent,
1768  * because this is not dealt with automatically as with constructors.
1769  */
1770 contract Initializable {
1771 
1772   /**
1773    * @dev Indicates that the contract has been initialized.
1774    */
1775   bool private initialized;
1776 
1777   /**
1778    * @dev Indicates that the contract is in the process of being initialized.
1779    */
1780   bool private initializing;
1781 
1782   /**
1783    * @dev Modifier to use in the initializer function of a contract.
1784    */
1785   modifier initializer() {
1786     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
1787 
1788     bool isTopLevelCall = !initializing;
1789     if (isTopLevelCall) {
1790       initializing = true;
1791       initialized = true;
1792     }
1793 
1794     _;
1795 
1796     if (isTopLevelCall) {
1797       initializing = false;
1798     }
1799   }
1800 
1801   /// @dev Returns true if and only if the function is running in the constructor
1802   function isConstructor() private view returns (bool) {
1803     // extcodesize checks the size of the code stored in an address, and
1804     // address returns the current address. Since the code is still not
1805     // deployed when running a constructor, any checks on its code size will
1806     // yield zero, making it an effective way to detect if a contract is
1807     // under construction or not.
1808     address self = address(this);
1809     uint256 cs;
1810     assembly { cs := extcodesize(self) }
1811     return cs == 0;
1812   }
1813 
1814   // Reserved storage space to allow for layout changes in the future.
1815   uint256[50] private ______gap;
1816 }
1817 
1818 
1819 // File @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol@v3.0.0
1820 
1821 pragma solidity ^0.6.0;
1822 
1823 /*
1824  * @dev Provides information about the current execution context, including the
1825  * sender of the transaction and its data. While these are generally available
1826  * via msg.sender and msg.data, they should not be accessed in such a direct
1827  * manner, since when dealing with GSN meta-transactions the account sending and
1828  * paying for execution may not be the actual sender (as far as an application
1829  * is concerned).
1830  *
1831  * This contract is only required for intermediate, library-like contracts.
1832  */
1833 contract ContextUpgradeSafe is Initializable {
1834     // Empty internal constructor, to prevent people from mistakenly deploying
1835     // an instance of this contract, which should be used via inheritance.
1836 
1837     function __Context_init() internal initializer {
1838         __Context_init_unchained();
1839     }
1840 
1841     function __Context_init_unchained() internal initializer {
1842 
1843 
1844     }
1845 
1846 
1847     function _msgSender() internal view virtual returns (address payable) {
1848         return msg.sender;
1849     }
1850 
1851     function _msgData() internal view virtual returns (bytes memory) {
1852         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1853         return msg.data;
1854     }
1855 
1856     uint256[50] private __gap;
1857 }
1858 
1859 
1860 // File @openzeppelin/contracts-ethereum-package/contracts/access/AccessControl.sol@v3.0.0
1861 
1862 pragma solidity ^0.6.0;
1863 
1864 
1865 
1866 
1867 /**
1868  * @dev Contract module that allows children to implement role-based access
1869  * control mechanisms.
1870  *
1871  * Roles are referred to by their `bytes32` identifier. These should be exposed
1872  * in the external API and be unique. The best way to achieve this is by
1873  * using `public constant` hash digests:
1874  *
1875  * ```
1876  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1877  * ```
1878  *
1879  * Roles can be used to represent a set of permissions. To restrict access to a
1880  * function call, use {hasRole}:
1881  *
1882  * ```
1883  * function foo() public {
1884  *     require(hasRole(MY_ROLE, _msgSender()));
1885  *     ...
1886  * }
1887  * ```
1888  *
1889  * Roles can be granted and revoked dynamically via the {grantRole} and
1890  * {revokeRole} functions. Each role has an associated admin role, and only
1891  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1892  *
1893  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1894  * that only accounts with this role will be able to grant or revoke other
1895  * roles. More complex role relationships can be created by using
1896  * {_setRoleAdmin}.
1897  */
1898 abstract contract AccessControlUpgradeSafe is Initializable, ContextUpgradeSafe {
1899     function __AccessControl_init() internal initializer {
1900         __Context_init_unchained();
1901         __AccessControl_init_unchained();
1902     }
1903 
1904     function __AccessControl_init_unchained() internal initializer {
1905 
1906 
1907     }
1908 
1909     using EnumerableSet for EnumerableSet.AddressSet;
1910     using Address for address;
1911 
1912     struct RoleData {
1913         EnumerableSet.AddressSet members;
1914         bytes32 adminRole;
1915     }
1916 
1917     mapping (bytes32 => RoleData) private _roles;
1918 
1919     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1920 
1921     /**
1922      * @dev Emitted when `account` is granted `role`.
1923      *
1924      * `sender` is the account that originated the contract call, an admin role
1925      * bearer except when using {_setupRole}.
1926      */
1927     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1928 
1929     /**
1930      * @dev Emitted when `account` is revoked `role`.
1931      *
1932      * `sender` is the account that originated the contract call:
1933      *   - if using `revokeRole`, it is the admin role bearer
1934      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1935      */
1936     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1937 
1938     /**
1939      * @dev Returns `true` if `account` has been granted `role`.
1940      */
1941     function hasRole(bytes32 role, address account) public view returns (bool) {
1942         return _roles[role].members.contains(account);
1943     }
1944 
1945     /**
1946      * @dev Returns the number of accounts that have `role`. Can be used
1947      * together with {getRoleMember} to enumerate all bearers of a role.
1948      */
1949     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1950         return _roles[role].members.length();
1951     }
1952 
1953     /**
1954      * @dev Returns one of the accounts that have `role`. `index` must be a
1955      * value between 0 and {getRoleMemberCount}, non-inclusive.
1956      *
1957      * Role bearers are not sorted in any particular way, and their ordering may
1958      * change at any point.
1959      *
1960      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1961      * you perform all queries on the same block. See the following
1962      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1963      * for more information.
1964      */
1965     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1966         return _roles[role].members.at(index);
1967     }
1968 
1969     /**
1970      * @dev Returns the admin role that controls `role`. See {grantRole} and
1971      * {revokeRole}.
1972      *
1973      * To change a role's admin, use {_setRoleAdmin}.
1974      */
1975     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1976         return _roles[role].adminRole;
1977     }
1978 
1979     /**
1980      * @dev Grants `role` to `account`.
1981      *
1982      * If `account` had not been already granted `role`, emits a {RoleGranted}
1983      * event.
1984      *
1985      * Requirements:
1986      *
1987      * - the caller must have ``role``'s admin role.
1988      */
1989     function grantRole(bytes32 role, address account) public virtual {
1990         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1991 
1992         _grantRole(role, account);
1993     }
1994 
1995     /**
1996      * @dev Revokes `role` from `account`.
1997      *
1998      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1999      *
2000      * Requirements:
2001      *
2002      * - the caller must have ``role``'s admin role.
2003      */
2004     function revokeRole(bytes32 role, address account) public virtual {
2005         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
2006 
2007         _revokeRole(role, account);
2008     }
2009 
2010     /**
2011      * @dev Revokes `role` from the calling account.
2012      *
2013      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2014      * purpose is to provide a mechanism for accounts to lose their privileges
2015      * if they are compromised (such as when a trusted device is misplaced).
2016      *
2017      * If the calling account had been granted `role`, emits a {RoleRevoked}
2018      * event.
2019      *
2020      * Requirements:
2021      *
2022      * - the caller must be `account`.
2023      */
2024     function renounceRole(bytes32 role, address account) public virtual {
2025         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2026 
2027         _revokeRole(role, account);
2028     }
2029 
2030     /**
2031      * @dev Grants `role` to `account`.
2032      *
2033      * If `account` had not been already granted `role`, emits a {RoleGranted}
2034      * event. Note that unlike {grantRole}, this function doesn't perform any
2035      * checks on the calling account.
2036      *
2037      * [WARNING]
2038      * ====
2039      * This function should only be called from the constructor when setting
2040      * up the initial roles for the system.
2041      *
2042      * Using this function in any other way is effectively circumventing the admin
2043      * system imposed by {AccessControl}.
2044      * ====
2045      */
2046     function _setupRole(bytes32 role, address account) internal virtual {
2047         _grantRole(role, account);
2048     }
2049 
2050     /**
2051      * @dev Sets `adminRole` as ``role``'s admin role.
2052      */
2053     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2054         _roles[role].adminRole = adminRole;
2055     }
2056 
2057     function _grantRole(bytes32 role, address account) private {
2058         if (_roles[role].members.add(account)) {
2059             emit RoleGranted(role, account, _msgSender());
2060         }
2061     }
2062 
2063     function _revokeRole(bytes32 role, address account) private {
2064         if (_roles[role].members.remove(account)) {
2065             emit RoleRevoked(role, account, _msgSender());
2066         }
2067     }
2068 
2069     uint256[49] private __gap;
2070 }
2071 
2072 
2073 // File contracts/xeth.sol
2074 
2075 // SPDX-License-Identifier: GPL-3.0-or-later
2076 pragma solidity =0.6.6;
2077 // Copyright (C) 2015, 2016, 2017 Dapphub / adapted by udev 2020
2078 contract XETH is IXEth, AccessControlUpgradeSafe {
2079     string public name;
2080     string public symbol;
2081     uint8 public decimals;
2082     uint256 public override totalSupply;
2083 
2084     bytes32 public constant XETH_LOCKER_ROLE = keccak256("XETH_LOCKER_ROLE");
2085     bytes32 public immutable PERMIT_TYPEHASH =
2086         keccak256(
2087             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
2088         );
2089 
2090     event Approval(address indexed src, address indexed guy, uint256 wad);
2091     event Transfer(address indexed src, address indexed dst, uint256 wad);
2092     event Deposit(address indexed dst, uint256 wad);
2093     event Withdrawal(address indexed src, uint256 wad);
2094 
2095     mapping(address => uint256) public override balanceOf;
2096     mapping(address => uint256) public override nonces;
2097     mapping(address => mapping(address => uint256)) public override allowance;
2098 
2099     constructor() public {
2100         name = "xlock.eth Wrapped Ether";
2101         symbol = "XETH";
2102         decimals = 18;
2103         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2104     }
2105 
2106     receive() external payable {
2107         deposit();
2108     }
2109 
2110     function deposit() public payable override {
2111         balanceOf[msg.sender] += msg.value;
2112         totalSupply += msg.value;
2113         emit Deposit(msg.sender, msg.value);
2114     }
2115 
2116     function grantXethLockerRole(address account) external {
2117         grantRole(XETH_LOCKER_ROLE, account);
2118     }
2119 
2120     function revokeXethLockerRole(address account) external {
2121         revokeRole(XETH_LOCKER_ROLE, account);
2122     }
2123 
2124     function xlockerMint(uint256 wad, address dst) external override {
2125         require(
2126             hasRole(XETH_LOCKER_ROLE, msg.sender),
2127             "Caller is not xeth locker"
2128         );
2129         balanceOf[dst] += wad;
2130         totalSupply += wad;
2131         emit Transfer(address(0), dst, wad);
2132     }
2133 
2134     function withdraw(uint256 wad) external override {
2135         require(balanceOf[msg.sender] >= wad, "!balance");
2136         balanceOf[msg.sender] -= wad;
2137         totalSupply -= wad;
2138         (bool success, ) = msg.sender.call{value: wad}("");
2139         require(success, "!withdraw");
2140         emit Withdrawal(msg.sender, wad);
2141     }
2142 
2143     function _approve(
2144         address src,
2145         address guy,
2146         uint256 wad
2147     ) internal {
2148         allowance[src][guy] = wad;
2149         emit Approval(src, guy, wad);
2150     }
2151 
2152     function approve(address guy, uint256 wad)
2153         external
2154         override
2155         returns (bool)
2156     {
2157         _approve(msg.sender, guy, wad);
2158         return true;
2159     }
2160 
2161     function transfer(address dst, uint256 wad)
2162         external
2163         override
2164         returns (bool)
2165     {
2166         return transferFrom(msg.sender, dst, wad);
2167     }
2168 
2169     function transferFrom(
2170         address src,
2171         address dst,
2172         uint256 wad
2173     ) public override returns (bool) {
2174         require(balanceOf[src] >= wad, "!balance");
2175 
2176         if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
2177             require(allowance[src][msg.sender] >= wad, "!allowance");
2178             allowance[src][msg.sender] -= wad;
2179         }
2180 
2181         balanceOf[src] -= wad;
2182         balanceOf[dst] += wad;
2183 
2184         emit Transfer(src, dst, wad);
2185 
2186         return true;
2187     }
2188 
2189     function permit(
2190         address owner,
2191         address spender,
2192         uint256 value,
2193         uint256 deadline,
2194         uint8 v,
2195         bytes32 r,
2196         bytes32 s
2197     ) external override {
2198         require(block.timestamp <= deadline, "XETH::permit: Expired permit");
2199 
2200         uint256 chainId;
2201         assembly {
2202             chainId := chainid()
2203         }
2204         bytes32 DOMAIN_SEPARATOR =
2205             keccak256(
2206                 abi.encode(
2207                     keccak256(
2208                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
2209                     ),
2210                     keccak256(bytes(name)),
2211                     keccak256(bytes("1")),
2212                     chainId,
2213                     address(this)
2214                 )
2215             );
2216 
2217         bytes32 hashStruct =
2218             keccak256(
2219                 abi.encode(
2220                     PERMIT_TYPEHASH,
2221                     owner,
2222                     spender,
2223                     value,
2224                     nonces[owner]++,
2225                     deadline
2226                 )
2227             );
2228 
2229         bytes32 hash =
2230             keccak256(
2231                 abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hashStruct)
2232             );
2233 
2234         address signer = ecrecover(hash, v, r, s);
2235         require(
2236             signer != address(0) && signer == owner,
2237             "XETH::permit: invalid permit"
2238         );
2239 
2240         allowance[owner][spender] = value;
2241         emit Approval(owner, spender, value);
2242     }
2243 }
2244 
2245 
2246 // File @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol@v3.0.0
2247 
2248 pragma solidity ^0.6.0;
2249 
2250 
2251 /**
2252  * @dev Contract module which provides a basic access control mechanism, where
2253  * there is an account (an owner) that can be granted exclusive access to
2254  * specific functions.
2255  *
2256  * By default, the owner account will be the one that deploys the contract. This
2257  * can later be changed with {transferOwnership}.
2258  *
2259  * This module is used through inheritance. It will make available the modifier
2260  * `onlyOwner`, which can be applied to your functions to restrict their use to
2261  * the owner.
2262  */
2263 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
2264     address private _owner;
2265 
2266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2267 
2268     /**
2269      * @dev Initializes the contract setting the deployer as the initial owner.
2270      */
2271 
2272     function __Ownable_init() internal initializer {
2273         __Context_init_unchained();
2274         __Ownable_init_unchained();
2275     }
2276 
2277     function __Ownable_init_unchained() internal initializer {
2278 
2279 
2280         address msgSender = _msgSender();
2281         _owner = msgSender;
2282         emit OwnershipTransferred(address(0), msgSender);
2283 
2284     }
2285 
2286 
2287     /**
2288      * @dev Returns the address of the current owner.
2289      */
2290     function owner() public view returns (address) {
2291         return _owner;
2292     }
2293 
2294     /**
2295      * @dev Throws if called by any account other than the owner.
2296      */
2297     modifier onlyOwner() {
2298         require(_owner == _msgSender(), "Ownable: caller is not the owner");
2299         _;
2300     }
2301 
2302     /**
2303      * @dev Leaves the contract without owner. It will not be possible to call
2304      * `onlyOwner` functions anymore. Can only be called by the current owner.
2305      *
2306      * NOTE: Renouncing ownership will leave the contract without an owner,
2307      * thereby removing any functionality that is only available to the owner.
2308      */
2309     function renounceOwnership() public virtual onlyOwner {
2310         emit OwnershipTransferred(_owner, address(0));
2311         _owner = address(0);
2312     }
2313 
2314     /**
2315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2316      * Can only be called by the current owner.
2317      */
2318     function transferOwnership(address newOwner) public virtual onlyOwner {
2319         require(newOwner != address(0), "Ownable: new owner is the zero address");
2320         emit OwnershipTransferred(_owner, newOwner);
2321         _owner = newOwner;
2322     }
2323 
2324     uint256[49] private __gap;
2325 }
2326 
2327 
2328 // File contracts/interfaces/IXLocker.sol
2329 
2330 // SPDX-License-Identifier: GPL-3.0-or-later
2331 pragma solidity =0.6.6;
2332 
2333 // Copyright (C) udev 2020
2334 interface IXLocker {
2335     function launchERC20(
2336         string calldata name,
2337         string calldata symbol,
2338         uint256 wadToken,
2339         uint256 wadXeth
2340     ) external returns (address token_, address pair_);
2341 
2342     function launchERC20TransferTax(
2343         string calldata name,
2344         string calldata symbol,
2345         uint256 wadToken,
2346         uint256 wadXeth,
2347         uint256 taxBips,
2348         address taxMan
2349     ) external returns (address token_, address pair_);
2350 }
2351 
2352 
2353 // File contracts/xlocker.sol
2354 
2355 // SPDX-License-Identifier: GPL-3.0-or-later
2356 pragma solidity =0.6.6;
2357 contract XLOCKER is Initializable, IXLocker, OwnableUpgradeSafe {
2358     using SafeMath for uint256;
2359 
2360     IUniswapV2Router02 private _uniswapRouter;
2361     IXEth private _xeth;
2362     address private _uniswapFactory;
2363 
2364     address public _sweepReceiver;
2365     uint256 public _maxXEthWad;
2366     uint256 public _maxTokenWad;
2367 
2368     mapping(address => uint256) public pairSwept;
2369     mapping(address => bool) public pairRegistered;
2370     address[] public allRegisteredPairs;
2371     uint256 public totalRegisteredPairs;
2372 
2373     function initialize(
2374         IXEth xeth_,
2375         address sweepReceiver_,
2376         uint256 maxXEthWad_,
2377         uint256 maxTokenWad_
2378     ) public initializer {
2379         OwnableUpgradeSafe.__Ownable_init();
2380         _uniswapRouter = IUniswapV2Router02(
2381             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
2382         );
2383         _uniswapFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
2384         _xeth = xeth_;
2385         _sweepReceiver = sweepReceiver_;
2386         _maxXEthWad = maxXEthWad_;
2387         _maxTokenWad = maxTokenWad_;
2388     }
2389 
2390     function setSweepReceiver(address sweepReceiver_) external onlyOwner {
2391         _sweepReceiver = sweepReceiver_;
2392     }
2393 
2394     function setMaxXEthWad(uint256 maxXEthWad_) external onlyOwner {
2395         _maxXEthWad = maxXEthWad_;
2396     }
2397 
2398     function setMaxTokenWad(uint256 maxTokenWad_) external onlyOwner {
2399         _maxTokenWad = maxTokenWad_;
2400     }
2401 
2402     function launchERC20(
2403         string calldata name,
2404         string calldata symbol,
2405         uint256 wadToken,
2406         uint256 wadXeth
2407     ) external override returns (address token_, address pair_) {
2408         //Checks
2409         _preLaunchChecks(wadToken, wadXeth);
2410 
2411         //Launch new token
2412         token_ = address(new ERC20(name, symbol, wadToken));
2413 
2414         //Lock symbol/xeth liquidity
2415         pair_ = _lockLiquidity(wadToken, wadXeth, token_);
2416 
2417         //Register pair for sweeping
2418         _registerPair(pair_);
2419 
2420         return (token_, pair_);
2421     }
2422 
2423     function launchERC20TransferTax(
2424         string calldata name,
2425         string calldata symbol,
2426         uint256 wadToken,
2427         uint256 wadXeth,
2428         uint256 taxBips,
2429         address taxMan
2430     ) external override returns (address token_, address pair_) {
2431         //Checks
2432         _preLaunchChecks(wadToken, wadXeth);
2433         require(taxBips <= 1000, "taxBips>1000");
2434 
2435         //Launch new token
2436         ERC20TransferTax token =
2437             new ERC20TransferTax(
2438                 name,
2439                 symbol,
2440                 wadToken,
2441                 address(this),
2442                 taxBips
2443             );
2444         token.setIsTaxed(address(this), false);
2445         token.transferTaxman(taxMan);
2446         token_ = address(token);
2447 
2448         //Lock symbol/xeth liquidity
2449         pair_ = _lockLiquidity(wadToken, wadXeth, token_);
2450 
2451         //Register pair for sweeping
2452         _registerPair(pair_);
2453 
2454         return (token_, pair_);
2455     }
2456 
2457     //Sweeps liquidity provider fees for _sweepReceiver
2458     function sweep(IUniswapV2Pair[] calldata pairs) external {
2459         require(pairs.length < 256, "pairs.length>=256");
2460         uint8 i;
2461         for (i = 0; i < pairs.length; i++) {
2462             IUniswapV2Pair pair = pairs[i];
2463 
2464             uint256 availableToSweep = sweepAmountAvailable(pair);
2465             if (availableToSweep != 0) {
2466                 pairSwept[address(pair)] += availableToSweep;
2467                 _xeth.xlockerMint(availableToSweep, _sweepReceiver);
2468             }
2469         }
2470     }
2471 
2472     //Checks pair for sweep amount available
2473     function sweepAmountAvailable(IUniswapV2Pair pair)
2474         public
2475         view
2476         returns (uint256 amountAvailable)
2477     {
2478         require(pairRegistered[address(pair)], "!pairRegistered[pair]");
2479 
2480         bool xethIsToken0 = false;
2481         IERC20 token;
2482         if (pair.token0() == address(_xeth)) {
2483             xethIsToken0 = true;
2484             token = IERC20(pair.token1());
2485         } else {
2486             require(
2487                 pair.token1() == address(_xeth),
2488                 "!pair.tokenX==address(_xeth)"
2489             );
2490             token = IERC20(pair.token0());
2491         }
2492 
2493         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) =
2494             pair.getReserves();
2495 
2496         uint256 burnedLP = pair.balanceOf(address(0));
2497         uint256 totalLP = pair.totalSupply();
2498 
2499         uint256 reserveLockedXeth =
2500             uint256(xethIsToken0 ? reserve0 : reserve1).mul(burnedLP).div(
2501                 totalLP
2502             );
2503         uint256 reserveLockedToken =
2504             uint256(xethIsToken0 ? reserve1 : reserve0).mul(burnedLP).div(
2505                 totalLP
2506             );
2507 
2508         uint256 burnedXeth;
2509         if (reserveLockedToken == token.totalSupply()) {
2510             burnedXeth = reserveLockedXeth;
2511         } else {
2512             burnedXeth = reserveLockedXeth.sub(
2513                 UniswapV2Library.getAmountOut(
2514                     //Circulating supply, max that could ever be sold (amountIn)
2515                     token.totalSupply().sub(reserveLockedToken),
2516                     //Burned token in Uniswap reserves (reserveIn)
2517                     reserveLockedToken,
2518                     //Burned xEth in Uniswap reserves (reserveOut)
2519                     reserveLockedXeth
2520                 )
2521             );
2522         }
2523 
2524         return burnedXeth.sub(pairSwept[address(pair)]);
2525     }
2526 
2527     function _preLaunchChecks(uint256 wadToken, uint256 wadXeth) internal view {
2528         require(wadToken <= _maxTokenWad, "wadToken>_maxTokenWad");
2529         require(wadXeth <= _maxXEthWad, "wadXeth>_maxXEthWad");
2530     }
2531 
2532     function _lockLiquidity(
2533         uint256 wadToken,
2534         uint256 wadXeth,
2535         address token
2536     ) internal returns (address pair) {
2537         _xeth.xlockerMint(wadXeth, address(this));
2538 
2539         IERC20(token).approve(address(_uniswapRouter), wadToken);
2540         _xeth.approve(address(_uniswapRouter), wadXeth);
2541 
2542         _uniswapRouter.addLiquidity(
2543             token,
2544             address(_xeth),
2545             wadToken,
2546             wadXeth,
2547             wadToken,
2548             wadXeth,
2549             address(0),
2550             now
2551         );
2552 
2553         pair = UniswapV2Library.pairFor(_uniswapFactory, token, address(_xeth));
2554         pairSwept[pair] = wadXeth;
2555         return pair;
2556     }
2557 
2558     function _registerPair(address pair) internal {
2559         pairRegistered[pair] = true;
2560         allRegisteredPairs.push(pair);
2561         totalRegisteredPairs = totalRegisteredPairs.add(1);
2562     }
2563 }