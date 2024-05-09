1 // Sources flattened with hardhat v2.6.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/utils/math/Math.sol@v4.3.2
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Standard math utilities missing in the Solidity language.
94  */
95 library Math {
96     /**
97      * @dev Returns the largest of two numbers.
98      */
99     function max(uint256 a, uint256 b) internal pure returns (uint256) {
100         return a >= b ? a : b;
101     }
102 
103     /**
104      * @dev Returns the smallest of two numbers.
105      */
106     function min(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a < b ? a : b;
108     }
109 
110     /**
111      * @dev Returns the average of two numbers. The result is rounded towards
112      * zero.
113      */
114     function average(uint256 a, uint256 b) internal pure returns (uint256) {
115         // (a + b) / 2 can overflow.
116         return (a & b) + (a ^ b) / 2;
117     }
118 
119     /**
120      * @dev Returns the ceiling of the division of two numbers.
121      *
122      * This differs from standard division with `/` in that it rounds up instead
123      * of rounding down.
124      */
125     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
126         // (a + b - 1) / b can overflow on addition, so we distribute.
127         return a / b + (a % b == 0 ? 0 : 1);
128     }
129 }
130 
131 
132 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Collection of functions related to the address type
138  */
139 library Address {
140     /**
141      * @dev Returns true if `account` is a contract.
142      *
143      * [IMPORTANT]
144      * ====
145      * It is unsafe to assume that an address for which this function returns
146      * false is an externally-owned account (EOA) and not a contract.
147      *
148      * Among others, `isContract` will return false for the following
149      * types of addresses:
150      *
151      *  - an externally-owned account
152      *  - a contract in construction
153      *  - an address where a contract will be created
154      *  - an address where a contract lived, but was destroyed
155      * ====
156      */
157     function isContract(address account) internal view returns (bool) {
158         // This method relies on extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         uint256 size;
163         assembly {
164             size := extcodesize(account)
165         }
166         return size > 0;
167     }
168 
169     /**
170      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
171      * `recipient`, forwarding all available gas and reverting on errors.
172      *
173      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
174      * of certain opcodes, possibly making contracts go over the 2300 gas limit
175      * imposed by `transfer`, making them unable to receive funds via
176      * `transfer`. {sendValue} removes this limitation.
177      *
178      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
179      *
180      * IMPORTANT: because control is transferred to `recipient`, care must be
181      * taken to not create reentrancy vulnerabilities. Consider using
182      * {ReentrancyGuard} or the
183      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
184      */
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         (bool success, ) = recipient.call{value: amount}("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 
192     /**
193      * @dev Performs a Solidity function call using a low level `call`. A
194      * plain `call` is an unsafe replacement for a function call: use this
195      * function instead.
196      *
197      * If `target` reverts with a revert reason, it is bubbled up by this
198      * function (like regular Solidity function calls).
199      *
200      * Returns the raw returned data. To convert to the expected return value,
201      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
202      *
203      * Requirements:
204      *
205      * - `target` must be a contract.
206      * - calling `target` with `data` must not revert.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionCall(target, data, "Address: low-level call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
216      * `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, 0, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but also transferring `value` wei to `target`.
231      *
232      * Requirements:
233      *
234      * - the calling contract must have an ETH balance of at least `value`.
235      * - the called Solidity function must be `payable`.
236      *
237      * _Available since v3.1._
238      */
239     function functionCallWithValue(
240         address target,
241         bytes memory data,
242         uint256 value
243     ) internal returns (bytes memory) {
244         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
249      * with `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(address(this).balance >= value, "Address: insufficient balance for call");
260         require(isContract(target), "Address: call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.call{value: value}(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
273         return functionStaticCall(target, data, "Address: low-level static call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal view returns (bytes memory) {
287         require(isContract(target), "Address: static call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.staticcall(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but performing a delegate call.
296      *
297      * _Available since v3.4._
298      */
299     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(isContract(target), "Address: delegate call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.delegatecall(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
322      * revert reason using the provided one.
323      *
324      * _Available since v4.3._
325      */
326     function verifyCallResult(
327         bool success,
328         bytes memory returndata,
329         string memory errorMessage
330     ) internal pure returns (bytes memory) {
331         if (success) {
332             return returndata;
333         } else {
334             // Look for revert reason and bubble it up if present
335             if (returndata.length > 0) {
336                 // The easiest way to bubble the revert reason is using memory via assembly
337 
338                 assembly {
339                     let returndata_size := mload(returndata)
340                     revert(add(32, returndata), returndata_size)
341                 }
342             } else {
343                 revert(errorMessage);
344             }
345         }
346     }
347 }
348 
349 
350 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.2
351 
352 pragma solidity ^0.8.0;
353 
354 
355 /**
356  * @title SafeERC20
357  * @dev Wrappers around ERC20 operations that throw on failure (when the token
358  * contract returns false). Tokens that return no value (and instead revert or
359  * throw on failure) are also supported, non-reverting calls are assumed to be
360  * successful.
361  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
362  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
363  */
364 library SafeERC20 {
365     using Address for address;
366 
367     function safeTransfer(
368         IERC20 token,
369         address to,
370         uint256 value
371     ) internal {
372         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
373     }
374 
375     function safeTransferFrom(
376         IERC20 token,
377         address from,
378         address to,
379         uint256 value
380     ) internal {
381         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
382     }
383 
384     /**
385      * @dev Deprecated. This function has issues similar to the ones found in
386      * {IERC20-approve}, and its usage is discouraged.
387      *
388      * Whenever possible, use {safeIncreaseAllowance} and
389      * {safeDecreaseAllowance} instead.
390      */
391     function safeApprove(
392         IERC20 token,
393         address spender,
394         uint256 value
395     ) internal {
396         // safeApprove should only be called when setting an initial allowance,
397         // or when resetting it to zero. To increase and decrease it, use
398         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
399         require(
400             (value == 0) || (token.allowance(address(this), spender) == 0),
401             "SafeERC20: approve from non-zero to non-zero allowance"
402         );
403         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
404     }
405 
406     function safeIncreaseAllowance(
407         IERC20 token,
408         address spender,
409         uint256 value
410     ) internal {
411         uint256 newAllowance = token.allowance(address(this), spender) + value;
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
413     }
414 
415     function safeDecreaseAllowance(
416         IERC20 token,
417         address spender,
418         uint256 value
419     ) internal {
420         unchecked {
421             uint256 oldAllowance = token.allowance(address(this), spender);
422             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
423             uint256 newAllowance = oldAllowance - value;
424             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425         }
426     }
427 
428     /**
429      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
430      * on the return value: the return value is optional (but if data is returned, it must not be false).
431      * @param token The token targeted by the call.
432      * @param data The call data (encoded using abi.encode or one of its variants).
433      */
434     function _callOptionalReturn(IERC20 token, bytes memory data) private {
435         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
436         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
437         // the target address contains contract code and also asserts for success in the low-level call.
438 
439         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
440         if (returndata.length > 0) {
441             // Return data is optional
442             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
443         }
444     }
445 }
446 
447 
448 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.3.2
449 
450 pragma solidity ^0.8.0;
451 
452 /**
453  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
454  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
455  *
456  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
457  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
458  * need to send a transaction, and thus is not required to hold Ether at all.
459  */
460 interface IERC20Permit {
461     /**
462      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
463      * given ``owner``'s signed approval.
464      *
465      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
466      * ordering also apply here.
467      *
468      * Emits an {Approval} event.
469      *
470      * Requirements:
471      *
472      * - `spender` cannot be the zero address.
473      * - `deadline` must be a timestamp in the future.
474      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
475      * over the EIP712-formatted function arguments.
476      * - the signature must use ``owner``'s current nonce (see {nonces}).
477      *
478      * For more information on the signature format, see the
479      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
480      * section].
481      */
482     function permit(
483         address owner,
484         address spender,
485         uint256 value,
486         uint256 deadline,
487         uint8 v,
488         bytes32 r,
489         bytes32 s
490     ) external;
491 
492     /**
493      * @dev Returns the current nonce for `owner`. This value must be
494      * included whenever a signature is generated for {permit}.
495      *
496      * Every successful call to {permit} increases ``owner``'s nonce by one. This
497      * prevents a signature from being used multiple times.
498      */
499     function nonces(address owner) external view returns (uint256);
500 
501     /**
502      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
503      */
504     // solhint-disable-next-line func-name-mixedcase
505     function DOMAIN_SEPARATOR() external view returns (bytes32);
506 }
507 
508 
509 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
510 
511 pragma solidity ^0.8.0;
512 
513 /**
514  * @dev Interface for the optional metadata functions from the ERC20 standard.
515  *
516  * _Available since v4.1._
517  */
518 interface IERC20Metadata is IERC20 {
519     /**
520      * @dev Returns the name of the token.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the symbol of the token.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the decimals places of the token.
531      */
532     function decimals() external view returns (uint8);
533 }
534 
535 
536 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
537 
538 pragma solidity ^0.8.0;
539 
540 /**
541  * @dev Provides information about the current execution context, including the
542  * sender of the transaction and its data. While these are generally available
543  * via msg.sender and msg.data, they should not be accessed in such a direct
544  * manner, since when dealing with meta-transactions the account sending and
545  * paying for execution may not be the actual sender (as far as an application
546  * is concerned).
547  *
548  * This contract is only required for intermediate, library-like contracts.
549  */
550 abstract contract Context {
551     function _msgSender() internal view virtual returns (address) {
552         return msg.sender;
553     }
554 
555     function _msgData() internal view virtual returns (bytes calldata) {
556         return msg.data;
557     }
558 }
559 
560 
561 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
562 
563 pragma solidity ^0.8.0;
564 
565 
566 
567 /**
568  * @dev Implementation of the {IERC20} interface.
569  *
570  * This implementation is agnostic to the way tokens are created. This means
571  * that a supply mechanism has to be added in a derived contract using {_mint}.
572  * For a generic mechanism see {ERC20PresetMinterPauser}.
573  *
574  * TIP: For a detailed writeup see our guide
575  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
576  * to implement supply mechanisms].
577  *
578  * We have followed general OpenZeppelin Contracts guidelines: functions revert
579  * instead returning `false` on failure. This behavior is nonetheless
580  * conventional and does not conflict with the expectations of ERC20
581  * applications.
582  *
583  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
584  * This allows applications to reconstruct the allowance for all accounts just
585  * by listening to said events. Other implementations of the EIP may not emit
586  * these events, as it isn't required by the specification.
587  *
588  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
589  * functions have been added to mitigate the well-known issues around setting
590  * allowances. See {IERC20-approve}.
591  */
592 contract ERC20 is Context, IERC20, IERC20Metadata {
593     mapping(address => uint256) private _balances;
594 
595     mapping(address => mapping(address => uint256)) private _allowances;
596 
597     uint256 private _totalSupply;
598 
599     string private _name;
600     string private _symbol;
601 
602     /**
603      * @dev Sets the values for {name} and {symbol}.
604      *
605      * The default value of {decimals} is 18. To select a different value for
606      * {decimals} you should overload it.
607      *
608      * All two of these values are immutable: they can only be set once during
609      * construction.
610      */
611     constructor(string memory name_, string memory symbol_) {
612         _name = name_;
613         _symbol = symbol_;
614     }
615 
616     /**
617      * @dev Returns the name of the token.
618      */
619     function name() public view virtual override returns (string memory) {
620         return _name;
621     }
622 
623     /**
624      * @dev Returns the symbol of the token, usually a shorter version of the
625      * name.
626      */
627     function symbol() public view virtual override returns (string memory) {
628         return _symbol;
629     }
630 
631     /**
632      * @dev Returns the number of decimals used to get its user representation.
633      * For example, if `decimals` equals `2`, a balance of `505` tokens should
634      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
635      *
636      * Tokens usually opt for a value of 18, imitating the relationship between
637      * Ether and Wei. This is the value {ERC20} uses, unless this function is
638      * overridden;
639      *
640      * NOTE: This information is only used for _display_ purposes: it in
641      * no way affects any of the arithmetic of the contract, including
642      * {IERC20-balanceOf} and {IERC20-transfer}.
643      */
644     function decimals() public view virtual override returns (uint8) {
645         return 18;
646     }
647 
648     /**
649      * @dev See {IERC20-totalSupply}.
650      */
651     function totalSupply() public view virtual override returns (uint256) {
652         return _totalSupply;
653     }
654 
655     /**
656      * @dev See {IERC20-balanceOf}.
657      */
658     function balanceOf(address account) public view virtual override returns (uint256) {
659         return _balances[account];
660     }
661 
662     /**
663      * @dev See {IERC20-transfer}.
664      *
665      * Requirements:
666      *
667      * - `recipient` cannot be the zero address.
668      * - the caller must have a balance of at least `amount`.
669      */
670     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
671         _transfer(_msgSender(), recipient, amount);
672         return true;
673     }
674 
675     /**
676      * @dev See {IERC20-allowance}.
677      */
678     function allowance(address owner, address spender) public view virtual override returns (uint256) {
679         return _allowances[owner][spender];
680     }
681 
682     /**
683      * @dev See {IERC20-approve}.
684      *
685      * Requirements:
686      *
687      * - `spender` cannot be the zero address.
688      */
689     function approve(address spender, uint256 amount) public virtual override returns (bool) {
690         _approve(_msgSender(), spender, amount);
691         return true;
692     }
693 
694     /**
695      * @dev See {IERC20-transferFrom}.
696      *
697      * Emits an {Approval} event indicating the updated allowance. This is not
698      * required by the EIP. See the note at the beginning of {ERC20}.
699      *
700      * Requirements:
701      *
702      * - `sender` and `recipient` cannot be the zero address.
703      * - `sender` must have a balance of at least `amount`.
704      * - the caller must have allowance for ``sender``'s tokens of at least
705      * `amount`.
706      */
707     function transferFrom(
708         address sender,
709         address recipient,
710         uint256 amount
711     ) public virtual override returns (bool) {
712         _transfer(sender, recipient, amount);
713 
714         uint256 currentAllowance = _allowances[sender][_msgSender()];
715         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
716         unchecked {
717             _approve(sender, _msgSender(), currentAllowance - amount);
718         }
719 
720         return true;
721     }
722 
723     /**
724      * @dev Atomically increases the allowance granted to `spender` by the caller.
725      *
726      * This is an alternative to {approve} that can be used as a mitigation for
727      * problems described in {IERC20-approve}.
728      *
729      * Emits an {Approval} event indicating the updated allowance.
730      *
731      * Requirements:
732      *
733      * - `spender` cannot be the zero address.
734      */
735     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
736         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
737         return true;
738     }
739 
740     /**
741      * @dev Atomically decreases the allowance granted to `spender` by the caller.
742      *
743      * This is an alternative to {approve} that can be used as a mitigation for
744      * problems described in {IERC20-approve}.
745      *
746      * Emits an {Approval} event indicating the updated allowance.
747      *
748      * Requirements:
749      *
750      * - `spender` cannot be the zero address.
751      * - `spender` must have allowance for the caller of at least
752      * `subtractedValue`.
753      */
754     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
755         uint256 currentAllowance = _allowances[_msgSender()][spender];
756         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
757         unchecked {
758             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
759         }
760 
761         return true;
762     }
763 
764     /**
765      * @dev Moves `amount` of tokens from `sender` to `recipient`.
766      *
767      * This internal function is equivalent to {transfer}, and can be used to
768      * e.g. implement automatic token fees, slashing mechanisms, etc.
769      *
770      * Emits a {Transfer} event.
771      *
772      * Requirements:
773      *
774      * - `sender` cannot be the zero address.
775      * - `recipient` cannot be the zero address.
776      * - `sender` must have a balance of at least `amount`.
777      */
778     function _transfer(
779         address sender,
780         address recipient,
781         uint256 amount
782     ) internal virtual {
783         require(sender != address(0), "ERC20: transfer from the zero address");
784         require(recipient != address(0), "ERC20: transfer to the zero address");
785 
786         _beforeTokenTransfer(sender, recipient, amount);
787 
788         uint256 senderBalance = _balances[sender];
789         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
790         unchecked {
791             _balances[sender] = senderBalance - amount;
792         }
793         _balances[recipient] += amount;
794 
795         emit Transfer(sender, recipient, amount);
796 
797         _afterTokenTransfer(sender, recipient, amount);
798     }
799 
800     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
801      * the total supply.
802      *
803      * Emits a {Transfer} event with `from` set to the zero address.
804      *
805      * Requirements:
806      *
807      * - `account` cannot be the zero address.
808      */
809     function _mint(address account, uint256 amount) internal virtual {
810         require(account != address(0), "ERC20: mint to the zero address");
811 
812         _beforeTokenTransfer(address(0), account, amount);
813 
814         _totalSupply += amount;
815         _balances[account] += amount;
816         emit Transfer(address(0), account, amount);
817 
818         _afterTokenTransfer(address(0), account, amount);
819     }
820 
821     /**
822      * @dev Destroys `amount` tokens from `account`, reducing the
823      * total supply.
824      *
825      * Emits a {Transfer} event with `to` set to the zero address.
826      *
827      * Requirements:
828      *
829      * - `account` cannot be the zero address.
830      * - `account` must have at least `amount` tokens.
831      */
832     function _burn(address account, uint256 amount) internal virtual {
833         require(account != address(0), "ERC20: burn from the zero address");
834 
835         _beforeTokenTransfer(account, address(0), amount);
836 
837         uint256 accountBalance = _balances[account];
838         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
839         unchecked {
840             _balances[account] = accountBalance - amount;
841         }
842         _totalSupply -= amount;
843 
844         emit Transfer(account, address(0), amount);
845 
846         _afterTokenTransfer(account, address(0), amount);
847     }
848 
849     /**
850      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
851      *
852      * This internal function is equivalent to `approve`, and can be used to
853      * e.g. set automatic allowances for certain subsystems, etc.
854      *
855      * Emits an {Approval} event.
856      *
857      * Requirements:
858      *
859      * - `owner` cannot be the zero address.
860      * - `spender` cannot be the zero address.
861      */
862     function _approve(
863         address owner,
864         address spender,
865         uint256 amount
866     ) internal virtual {
867         require(owner != address(0), "ERC20: approve from the zero address");
868         require(spender != address(0), "ERC20: approve to the zero address");
869 
870         _allowances[owner][spender] = amount;
871         emit Approval(owner, spender, amount);
872     }
873 
874     /**
875      * @dev Hook that is called before any transfer of tokens. This includes
876      * minting and burning.
877      *
878      * Calling conditions:
879      *
880      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
881      * will be transferred to `to`.
882      * - when `from` is zero, `amount` tokens will be minted for `to`.
883      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
884      * - `from` and `to` are never both zero.
885      *
886      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
887      */
888     function _beforeTokenTransfer(
889         address from,
890         address to,
891         uint256 amount
892     ) internal virtual {}
893 
894     /**
895      * @dev Hook that is called after any transfer of tokens. This includes
896      * minting and burning.
897      *
898      * Calling conditions:
899      *
900      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
901      * has been transferred to `to`.
902      * - when `from` is zero, `amount` tokens have been minted for `to`.
903      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
904      * - `from` and `to` are never both zero.
905      *
906      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
907      */
908     function _afterTokenTransfer(
909         address from,
910         address to,
911         uint256 amount
912     ) internal virtual {}
913 }
914 
915 
916 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.2
917 
918 pragma solidity ^0.8.0;
919 
920 /**
921  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
922  *
923  * These functions can be used to verify that a message was signed by the holder
924  * of the private keys of a given address.
925  */
926 library ECDSA {
927     enum RecoverError {
928         NoError,
929         InvalidSignature,
930         InvalidSignatureLength,
931         InvalidSignatureS,
932         InvalidSignatureV
933     }
934 
935     function _throwError(RecoverError error) private pure {
936         if (error == RecoverError.NoError) {
937             return; // no error: do nothing
938         } else if (error == RecoverError.InvalidSignature) {
939             revert("ECDSA: invalid signature");
940         } else if (error == RecoverError.InvalidSignatureLength) {
941             revert("ECDSA: invalid signature length");
942         } else if (error == RecoverError.InvalidSignatureS) {
943             revert("ECDSA: invalid signature 's' value");
944         } else if (error == RecoverError.InvalidSignatureV) {
945             revert("ECDSA: invalid signature 'v' value");
946         }
947     }
948 
949     /**
950      * @dev Returns the address that signed a hashed message (`hash`) with
951      * `signature` or error string. This address can then be used for verification purposes.
952      *
953      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
954      * this function rejects them by requiring the `s` value to be in the lower
955      * half order, and the `v` value to be either 27 or 28.
956      *
957      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
958      * verification to be secure: it is possible to craft signatures that
959      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
960      * this is by receiving a hash of the original message (which may otherwise
961      * be too long), and then calling {toEthSignedMessageHash} on it.
962      *
963      * Documentation for signature generation:
964      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
965      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
966      *
967      * _Available since v4.3._
968      */
969     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
970         // Check the signature length
971         // - case 65: r,s,v signature (standard)
972         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
973         if (signature.length == 65) {
974             bytes32 r;
975             bytes32 s;
976             uint8 v;
977             // ecrecover takes the signature parameters, and the only way to get them
978             // currently is to use assembly.
979             assembly {
980                 r := mload(add(signature, 0x20))
981                 s := mload(add(signature, 0x40))
982                 v := byte(0, mload(add(signature, 0x60)))
983             }
984             return tryRecover(hash, v, r, s);
985         } else if (signature.length == 64) {
986             bytes32 r;
987             bytes32 vs;
988             // ecrecover takes the signature parameters, and the only way to get them
989             // currently is to use assembly.
990             assembly {
991                 r := mload(add(signature, 0x20))
992                 vs := mload(add(signature, 0x40))
993             }
994             return tryRecover(hash, r, vs);
995         } else {
996             return (address(0), RecoverError.InvalidSignatureLength);
997         }
998     }
999 
1000     /**
1001      * @dev Returns the address that signed a hashed message (`hash`) with
1002      * `signature`. This address can then be used for verification purposes.
1003      *
1004      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1005      * this function rejects them by requiring the `s` value to be in the lower
1006      * half order, and the `v` value to be either 27 or 28.
1007      *
1008      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1009      * verification to be secure: it is possible to craft signatures that
1010      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1011      * this is by receiving a hash of the original message (which may otherwise
1012      * be too long), and then calling {toEthSignedMessageHash} on it.
1013      */
1014     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1015         (address recovered, RecoverError error) = tryRecover(hash, signature);
1016         _throwError(error);
1017         return recovered;
1018     }
1019 
1020     /**
1021      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1022      *
1023      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1024      *
1025      * _Available since v4.3._
1026      */
1027     function tryRecover(
1028         bytes32 hash,
1029         bytes32 r,
1030         bytes32 vs
1031     ) internal pure returns (address, RecoverError) {
1032         bytes32 s;
1033         uint8 v;
1034         assembly {
1035             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1036             v := add(shr(255, vs), 27)
1037         }
1038         return tryRecover(hash, v, r, s);
1039     }
1040 
1041     /**
1042      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1043      *
1044      * _Available since v4.2._
1045      */
1046     function recover(
1047         bytes32 hash,
1048         bytes32 r,
1049         bytes32 vs
1050     ) internal pure returns (address) {
1051         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1052         _throwError(error);
1053         return recovered;
1054     }
1055 
1056     /**
1057      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1058      * `r` and `s` signature fields separately.
1059      *
1060      * _Available since v4.3._
1061      */
1062     function tryRecover(
1063         bytes32 hash,
1064         uint8 v,
1065         bytes32 r,
1066         bytes32 s
1067     ) internal pure returns (address, RecoverError) {
1068         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1069         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1070         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1071         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1072         //
1073         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1074         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1075         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1076         // these malleable signatures as well.
1077         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1078             return (address(0), RecoverError.InvalidSignatureS);
1079         }
1080         if (v != 27 && v != 28) {
1081             return (address(0), RecoverError.InvalidSignatureV);
1082         }
1083 
1084         // If the signature is valid (and not malleable), return the signer address
1085         address signer = ecrecover(hash, v, r, s);
1086         if (signer == address(0)) {
1087             return (address(0), RecoverError.InvalidSignature);
1088         }
1089 
1090         return (signer, RecoverError.NoError);
1091     }
1092 
1093     /**
1094      * @dev Overload of {ECDSA-recover} that receives the `v`,
1095      * `r` and `s` signature fields separately.
1096      */
1097     function recover(
1098         bytes32 hash,
1099         uint8 v,
1100         bytes32 r,
1101         bytes32 s
1102     ) internal pure returns (address) {
1103         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1104         _throwError(error);
1105         return recovered;
1106     }
1107 
1108     /**
1109      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1110      * produces hash corresponding to the one signed with the
1111      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1112      * JSON-RPC method as part of EIP-191.
1113      *
1114      * See {recover}.
1115      */
1116     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1117         // 32 is the length in bytes of hash,
1118         // enforced by the type signature above
1119         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1120     }
1121 
1122     /**
1123      * @dev Returns an Ethereum Signed Typed Data, created from a
1124      * `domainSeparator` and a `structHash`. This produces hash corresponding
1125      * to the one signed with the
1126      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1127      * JSON-RPC method as part of EIP-712.
1128      *
1129      * See {recover}.
1130      */
1131     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1132         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1133     }
1134 }
1135 
1136 
1137 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.3.2
1138 
1139 pragma solidity ^0.8.0;
1140 
1141 /**
1142  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1143  *
1144  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1145  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1146  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1147  *
1148  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1149  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1150  * ({_hashTypedDataV4}).
1151  *
1152  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1153  * the chain id to protect against replay attacks on an eventual fork of the chain.
1154  *
1155  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1156  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1157  *
1158  * _Available since v3.4._
1159  */
1160 abstract contract EIP712 {
1161     /* solhint-disable var-name-mixedcase */
1162     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1163     // invalidate the cached domain separator if the chain id changes.
1164     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1165     uint256 private immutable _CACHED_CHAIN_ID;
1166 
1167     bytes32 private immutable _HASHED_NAME;
1168     bytes32 private immutable _HASHED_VERSION;
1169     bytes32 private immutable _TYPE_HASH;
1170 
1171     /* solhint-enable var-name-mixedcase */
1172 
1173     /**
1174      * @dev Initializes the domain separator and parameter caches.
1175      *
1176      * The meaning of `name` and `version` is specified in
1177      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1178      *
1179      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1180      * - `version`: the current major version of the signing domain.
1181      *
1182      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1183      * contract upgrade].
1184      */
1185     constructor(string memory name, string memory version) {
1186         bytes32 hashedName = keccak256(bytes(name));
1187         bytes32 hashedVersion = keccak256(bytes(version));
1188         bytes32 typeHash = keccak256(
1189             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1190         );
1191         _HASHED_NAME = hashedName;
1192         _HASHED_VERSION = hashedVersion;
1193         _CACHED_CHAIN_ID = block.chainid;
1194         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1195         _TYPE_HASH = typeHash;
1196     }
1197 
1198     /**
1199      * @dev Returns the domain separator for the current chain.
1200      */
1201     function _domainSeparatorV4() internal view returns (bytes32) {
1202         if (block.chainid == _CACHED_CHAIN_ID) {
1203             return _CACHED_DOMAIN_SEPARATOR;
1204         } else {
1205             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1206         }
1207     }
1208 
1209     function _buildDomainSeparator(
1210         bytes32 typeHash,
1211         bytes32 nameHash,
1212         bytes32 versionHash
1213     ) private view returns (bytes32) {
1214         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1215     }
1216 
1217     /**
1218      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1219      * function returns the hash of the fully encoded EIP712 message for this domain.
1220      *
1221      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1222      *
1223      * ```solidity
1224      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1225      *     keccak256("Mail(address to,string contents)"),
1226      *     mailTo,
1227      *     keccak256(bytes(mailContents))
1228      * )));
1229      * address signer = ECDSA.recover(digest, signature);
1230      * ```
1231      */
1232     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1233         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1234     }
1235 }
1236 
1237 
1238 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1239 
1240 pragma solidity ^0.8.0;
1241 
1242 /**
1243  * @title Counters
1244  * @author Matt Condon (@shrugs)
1245  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1246  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1247  *
1248  * Include with `using Counters for Counters.Counter;`
1249  */
1250 library Counters {
1251     struct Counter {
1252         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1253         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1254         // this feature: see https://github.com/ethereum/solidity/issues/4637
1255         uint256 _value; // default: 0
1256     }
1257 
1258     function current(Counter storage counter) internal view returns (uint256) {
1259         return counter._value;
1260     }
1261 
1262     function increment(Counter storage counter) internal {
1263         unchecked {
1264             counter._value += 1;
1265         }
1266     }
1267 
1268     function decrement(Counter storage counter) internal {
1269         uint256 value = counter._value;
1270         require(value > 0, "Counter: decrement overflow");
1271         unchecked {
1272             counter._value = value - 1;
1273         }
1274     }
1275 
1276     function reset(Counter storage counter) internal {
1277         counter._value = 0;
1278     }
1279 }
1280 
1281 
1282 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.3.2
1283 
1284 pragma solidity ^0.8.0;
1285 
1286 
1287 
1288 
1289 
1290 /**
1291  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1292  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1293  *
1294  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1295  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1296  * need to send a transaction, and thus is not required to hold Ether at all.
1297  *
1298  * _Available since v3.4._
1299  */
1300 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1301     using Counters for Counters.Counter;
1302 
1303     mapping(address => Counters.Counter) private _nonces;
1304 
1305     // solhint-disable-next-line var-name-mixedcase
1306     bytes32 private immutable _PERMIT_TYPEHASH =
1307         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1308 
1309     /**
1310      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1311      *
1312      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1313      */
1314     constructor(string memory name) EIP712(name, "1") {}
1315 
1316     /**
1317      * @dev See {IERC20Permit-permit}.
1318      */
1319     function permit(
1320         address owner,
1321         address spender,
1322         uint256 value,
1323         uint256 deadline,
1324         uint8 v,
1325         bytes32 r,
1326         bytes32 s
1327     ) public virtual override {
1328         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1329 
1330         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1331 
1332         bytes32 hash = _hashTypedDataV4(structHash);
1333 
1334         address signer = ECDSA.recover(hash, v, r, s);
1335         require(signer == owner, "ERC20Permit: invalid signature");
1336 
1337         _approve(owner, spender, value);
1338     }
1339 
1340     /**
1341      * @dev See {IERC20Permit-nonces}.
1342      */
1343     function nonces(address owner) public view virtual override returns (uint256) {
1344         return _nonces[owner].current();
1345     }
1346 
1347     /**
1348      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1349      */
1350     // solhint-disable-next-line func-name-mixedcase
1351     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1352         return _domainSeparatorV4();
1353     }
1354 
1355     /**
1356      * @dev "Consume a nonce": return the current value and increment.
1357      *
1358      * _Available since v4.1._
1359      */
1360     function _useNonce(address owner) internal virtual returns (uint256 current) {
1361         Counters.Counter storage nonce = _nonces[owner];
1362         current = nonce.current();
1363         nonce.increment();
1364     }
1365 }
1366 
1367 
1368 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.3.2
1369 
1370 pragma solidity ^0.8.0;
1371 
1372 /**
1373  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1374  * checks.
1375  *
1376  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1377  * easily result in undesired exploitation or bugs, since developers usually
1378  * assume that overflows raise errors. `SafeCast` restores this intuition by
1379  * reverting the transaction when such an operation overflows.
1380  *
1381  * Using this library instead of the unchecked operations eliminates an entire
1382  * class of bugs, so it's recommended to use it always.
1383  *
1384  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1385  * all math on `uint256` and `int256` and then downcasting.
1386  */
1387 library SafeCast {
1388     /**
1389      * @dev Returns the downcasted uint224 from uint256, reverting on
1390      * overflow (when the input is greater than largest uint224).
1391      *
1392      * Counterpart to Solidity's `uint224` operator.
1393      *
1394      * Requirements:
1395      *
1396      * - input must fit into 224 bits
1397      */
1398     function toUint224(uint256 value) internal pure returns (uint224) {
1399         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1400         return uint224(value);
1401     }
1402 
1403     /**
1404      * @dev Returns the downcasted uint128 from uint256, reverting on
1405      * overflow (when the input is greater than largest uint128).
1406      *
1407      * Counterpart to Solidity's `uint128` operator.
1408      *
1409      * Requirements:
1410      *
1411      * - input must fit into 128 bits
1412      */
1413     function toUint128(uint256 value) internal pure returns (uint128) {
1414         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1415         return uint128(value);
1416     }
1417 
1418     /**
1419      * @dev Returns the downcasted uint96 from uint256, reverting on
1420      * overflow (when the input is greater than largest uint96).
1421      *
1422      * Counterpart to Solidity's `uint96` operator.
1423      *
1424      * Requirements:
1425      *
1426      * - input must fit into 96 bits
1427      */
1428     function toUint96(uint256 value) internal pure returns (uint96) {
1429         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1430         return uint96(value);
1431     }
1432 
1433     /**
1434      * @dev Returns the downcasted uint64 from uint256, reverting on
1435      * overflow (when the input is greater than largest uint64).
1436      *
1437      * Counterpart to Solidity's `uint64` operator.
1438      *
1439      * Requirements:
1440      *
1441      * - input must fit into 64 bits
1442      */
1443     function toUint64(uint256 value) internal pure returns (uint64) {
1444         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1445         return uint64(value);
1446     }
1447 
1448     /**
1449      * @dev Returns the downcasted uint32 from uint256, reverting on
1450      * overflow (when the input is greater than largest uint32).
1451      *
1452      * Counterpart to Solidity's `uint32` operator.
1453      *
1454      * Requirements:
1455      *
1456      * - input must fit into 32 bits
1457      */
1458     function toUint32(uint256 value) internal pure returns (uint32) {
1459         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1460         return uint32(value);
1461     }
1462 
1463     /**
1464      * @dev Returns the downcasted uint16 from uint256, reverting on
1465      * overflow (when the input is greater than largest uint16).
1466      *
1467      * Counterpart to Solidity's `uint16` operator.
1468      *
1469      * Requirements:
1470      *
1471      * - input must fit into 16 bits
1472      */
1473     function toUint16(uint256 value) internal pure returns (uint16) {
1474         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1475         return uint16(value);
1476     }
1477 
1478     /**
1479      * @dev Returns the downcasted uint8 from uint256, reverting on
1480      * overflow (when the input is greater than largest uint8).
1481      *
1482      * Counterpart to Solidity's `uint8` operator.
1483      *
1484      * Requirements:
1485      *
1486      * - input must fit into 8 bits.
1487      */
1488     function toUint8(uint256 value) internal pure returns (uint8) {
1489         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1490         return uint8(value);
1491     }
1492 
1493     /**
1494      * @dev Converts a signed int256 into an unsigned uint256.
1495      *
1496      * Requirements:
1497      *
1498      * - input must be greater than or equal to 0.
1499      */
1500     function toUint256(int256 value) internal pure returns (uint256) {
1501         require(value >= 0, "SafeCast: value must be positive");
1502         return uint256(value);
1503     }
1504 
1505     /**
1506      * @dev Returns the downcasted int128 from int256, reverting on
1507      * overflow (when the input is less than smallest int128 or
1508      * greater than largest int128).
1509      *
1510      * Counterpart to Solidity's `int128` operator.
1511      *
1512      * Requirements:
1513      *
1514      * - input must fit into 128 bits
1515      *
1516      * _Available since v3.1._
1517      */
1518     function toInt128(int256 value) internal pure returns (int128) {
1519         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1520         return int128(value);
1521     }
1522 
1523     /**
1524      * @dev Returns the downcasted int64 from int256, reverting on
1525      * overflow (when the input is less than smallest int64 or
1526      * greater than largest int64).
1527      *
1528      * Counterpart to Solidity's `int64` operator.
1529      *
1530      * Requirements:
1531      *
1532      * - input must fit into 64 bits
1533      *
1534      * _Available since v3.1._
1535      */
1536     function toInt64(int256 value) internal pure returns (int64) {
1537         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1538         return int64(value);
1539     }
1540 
1541     /**
1542      * @dev Returns the downcasted int32 from int256, reverting on
1543      * overflow (when the input is less than smallest int32 or
1544      * greater than largest int32).
1545      *
1546      * Counterpart to Solidity's `int32` operator.
1547      *
1548      * Requirements:
1549      *
1550      * - input must fit into 32 bits
1551      *
1552      * _Available since v3.1._
1553      */
1554     function toInt32(int256 value) internal pure returns (int32) {
1555         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1556         return int32(value);
1557     }
1558 
1559     /**
1560      * @dev Returns the downcasted int16 from int256, reverting on
1561      * overflow (when the input is less than smallest int16 or
1562      * greater than largest int16).
1563      *
1564      * Counterpart to Solidity's `int16` operator.
1565      *
1566      * Requirements:
1567      *
1568      * - input must fit into 16 bits
1569      *
1570      * _Available since v3.1._
1571      */
1572     function toInt16(int256 value) internal pure returns (int16) {
1573         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1574         return int16(value);
1575     }
1576 
1577     /**
1578      * @dev Returns the downcasted int8 from int256, reverting on
1579      * overflow (when the input is less than smallest int8 or
1580      * greater than largest int8).
1581      *
1582      * Counterpart to Solidity's `int8` operator.
1583      *
1584      * Requirements:
1585      *
1586      * - input must fit into 8 bits.
1587      *
1588      * _Available since v3.1._
1589      */
1590     function toInt8(int256 value) internal pure returns (int8) {
1591         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1592         return int8(value);
1593     }
1594 
1595     /**
1596      * @dev Converts an unsigned uint256 into a signed int256.
1597      *
1598      * Requirements:
1599      *
1600      * - input must be less than or equal to maxInt256.
1601      */
1602     function toInt256(uint256 value) internal pure returns (int256) {
1603         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1604         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1605         return int256(value);
1606     }
1607 }
1608 
1609 
1610 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol@v4.3.2
1611 
1612 pragma solidity ^0.8.0;
1613 
1614 
1615 
1616 
1617 /**
1618  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1619  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1620  *
1621  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1622  *
1623  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1624  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1625  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1626  *
1627  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1628  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1629  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1630  * will significantly increase the base gas cost of transfers.
1631  *
1632  * _Available since v4.2._
1633  */
1634 abstract contract ERC20Votes is ERC20Permit {
1635     struct Checkpoint {
1636         uint32 fromBlock;
1637         uint224 votes;
1638     }
1639 
1640     bytes32 private constant _DELEGATION_TYPEHASH =
1641         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1642 
1643     mapping(address => address) private _delegates;
1644     mapping(address => Checkpoint[]) private _checkpoints;
1645     Checkpoint[] private _totalSupplyCheckpoints;
1646 
1647     /**
1648      * @dev Emitted when an account changes their delegate.
1649      */
1650     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1651 
1652     /**
1653      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1654      */
1655     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1656 
1657     /**
1658      * @dev Get the `pos`-th checkpoint for `account`.
1659      */
1660     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1661         return _checkpoints[account][pos];
1662     }
1663 
1664     /**
1665      * @dev Get number of checkpoints for `account`.
1666      */
1667     function numCheckpoints(address account) public view virtual returns (uint32) {
1668         return SafeCast.toUint32(_checkpoints[account].length);
1669     }
1670 
1671     /**
1672      * @dev Get the address `account` is currently delegating to.
1673      */
1674     function delegates(address account) public view virtual returns (address) {
1675         return _delegates[account];
1676     }
1677 
1678     /**
1679      * @dev Gets the current votes balance for `account`
1680      */
1681     function getVotes(address account) public view returns (uint256) {
1682         uint256 pos = _checkpoints[account].length;
1683         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1684     }
1685 
1686     /**
1687      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1688      *
1689      * Requirements:
1690      *
1691      * - `blockNumber` must have been already mined
1692      */
1693     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1694         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1695         return _checkpointsLookup(_checkpoints[account], blockNumber);
1696     }
1697 
1698     /**
1699      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1700      * It is but NOT the sum of all the delegated votes!
1701      *
1702      * Requirements:
1703      *
1704      * - `blockNumber` must have been already mined
1705      */
1706     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1707         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1708         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1709     }
1710 
1711     /**
1712      * @dev Lookup a value in a list of (sorted) checkpoints.
1713      */
1714     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1715         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1716         //
1717         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1718         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1719         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1720         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1721         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1722         // out of bounds (in which case we're looking too far in the past and the result is 0).
1723         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1724         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1725         // the same.
1726         uint256 high = ckpts.length;
1727         uint256 low = 0;
1728         while (low < high) {
1729             uint256 mid = Math.average(low, high);
1730             if (ckpts[mid].fromBlock > blockNumber) {
1731                 high = mid;
1732             } else {
1733                 low = mid + 1;
1734             }
1735         }
1736 
1737         return high == 0 ? 0 : ckpts[high - 1].votes;
1738     }
1739 
1740     /**
1741      * @dev Delegate votes from the sender to `delegatee`.
1742      */
1743     function delegate(address delegatee) public virtual {
1744         return _delegate(_msgSender(), delegatee);
1745     }
1746 
1747     /**
1748      * @dev Delegates votes from signer to `delegatee`
1749      */
1750     function delegateBySig(
1751         address delegatee,
1752         uint256 nonce,
1753         uint256 expiry,
1754         uint8 v,
1755         bytes32 r,
1756         bytes32 s
1757     ) public virtual {
1758         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1759         address signer = ECDSA.recover(
1760             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1761             v,
1762             r,
1763             s
1764         );
1765         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1766         return _delegate(signer, delegatee);
1767     }
1768 
1769     /**
1770      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1771      */
1772     function _maxSupply() internal view virtual returns (uint224) {
1773         return type(uint224).max;
1774     }
1775 
1776     /**
1777      * @dev Snapshots the totalSupply after it has been increased.
1778      */
1779     function _mint(address account, uint256 amount) internal virtual override {
1780         super._mint(account, amount);
1781         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1782 
1783         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1784     }
1785 
1786     /**
1787      * @dev Snapshots the totalSupply after it has been decreased.
1788      */
1789     function _burn(address account, uint256 amount) internal virtual override {
1790         super._burn(account, amount);
1791 
1792         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1793     }
1794 
1795     /**
1796      * @dev Move voting power when tokens are transferred.
1797      *
1798      * Emits a {DelegateVotesChanged} event.
1799      */
1800     function _afterTokenTransfer(
1801         address from,
1802         address to,
1803         uint256 amount
1804     ) internal virtual override {
1805         super._afterTokenTransfer(from, to, amount);
1806 
1807         _moveVotingPower(delegates(from), delegates(to), amount);
1808     }
1809 
1810     /**
1811      * @dev Change delegation for `delegator` to `delegatee`.
1812      *
1813      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1814      */
1815     function _delegate(address delegator, address delegatee) internal virtual {
1816         address currentDelegate = delegates(delegator);
1817         uint256 delegatorBalance = balanceOf(delegator);
1818         _delegates[delegator] = delegatee;
1819 
1820         emit DelegateChanged(delegator, currentDelegate, delegatee);
1821 
1822         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1823     }
1824 
1825     function _moveVotingPower(
1826         address src,
1827         address dst,
1828         uint256 amount
1829     ) private {
1830         if (src != dst && amount > 0) {
1831             if (src != address(0)) {
1832                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1833                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1834             }
1835 
1836             if (dst != address(0)) {
1837                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1838                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1839             }
1840         }
1841     }
1842 
1843     function _writeCheckpoint(
1844         Checkpoint[] storage ckpts,
1845         function(uint256, uint256) view returns (uint256) op,
1846         uint256 delta
1847     ) private returns (uint256 oldWeight, uint256 newWeight) {
1848         uint256 pos = ckpts.length;
1849         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1850         newWeight = op(oldWeight, delta);
1851 
1852         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1853             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1854         } else {
1855             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1856         }
1857     }
1858 
1859     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1860         return a + b;
1861     }
1862 
1863     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1864         return a - b;
1865     }
1866 }
1867 
1868 
1869 // File contracts/interfaces/IBasePool.sol
1870 
1871 pragma solidity 0.8.7;
1872 interface IBasePool {
1873     function distributeRewards(uint256 _amount) external;
1874 }
1875 
1876 
1877 // File contracts/interfaces/ITimeLockPool.sol
1878 
1879 pragma solidity 0.8.7;
1880 interface ITimeLockPool {
1881     function deposit(uint256 _amount, uint256 _duration, address _receiver) external;
1882 }
1883 
1884 
1885 // File contracts/interfaces/IAbstractRewards.sol
1886 
1887 pragma solidity 0.8.7;
1888 
1889 interface IAbstractRewards {
1890 	/**
1891 	 * @dev Returns the total amount of rewards a given address is able to withdraw.
1892 	 * @param account Address of a reward recipient
1893 	 * @return A uint256 representing the rewards `account` can withdraw
1894 	 */
1895 	function withdrawableRewardsOf(address account) external view returns (uint256);
1896 
1897   /**
1898 	 * @dev View the amount of funds that an address has withdrawn.
1899 	 * @param account The address of a token holder.
1900 	 * @return The amount of funds that `account` has withdrawn.
1901 	 */
1902 	function withdrawnRewardsOf(address account) external view returns (uint256);
1903 
1904 	/**
1905 	 * @dev View the amount of funds that an address has earned in total.
1906 	 * accumulativeFundsOf(account) = withdrawableRewardsOf(account) + withdrawnRewardsOf(account)
1907 	 * = (pointsPerShare * balanceOf(account) + pointsCorrection[account]) / POINTS_MULTIPLIER
1908 	 * @param account The address of a token holder.
1909 	 * @return The amount of funds that `account` has earned in total.
1910 	 */
1911 	function cumulativeRewardsOf(address account) external view returns (uint256);
1912 
1913 	/**
1914 	 * @dev This event emits when new funds are distributed
1915 	 * @param by the address of the sender who distributed funds
1916 	 * @param rewardsDistributed the amount of funds received for distribution
1917 	 */
1918 	event RewardsDistributed(address indexed by, uint256 rewardsDistributed);
1919 
1920 	/**
1921 	 * @dev This event emits when distributed funds are withdrawn by a token holder.
1922 	 * @param by the address of the receiver of funds
1923 	 * @param fundsWithdrawn the amount of funds that were withdrawn
1924 	 */
1925 	event RewardsWithdrawn(address indexed by, uint256 fundsWithdrawn);
1926 }
1927 
1928 
1929 // File contracts/base/AbstractRewards.sol
1930 
1931 pragma solidity 0.8.7;
1932 
1933 
1934 /**
1935  * @dev Based on: https://github.com/indexed-finance/dividends/blob/master/contracts/base/AbstractDividends.sol
1936  * Renamed dividends to rewards.
1937  * @dev (OLD) Many functions in this contract were taken from this repository:
1938  * https://github.com/atpar/funds-distribution-token/blob/master/contracts/FundsDistributionToken.sol
1939  * which is an example implementation of ERC 2222, the draft for which can be found at
1940  * https://github.com/atpar/funds-distribution-token/blob/master/EIP-DRAFT.md
1941  *
1942  * This contract has been substantially modified from the original and does not comply with ERC 2222.
1943  * Many functions were renamed as "rewards" rather than "funds" and the core functionality was separated
1944  * into this abstract contract which can be inherited by anything tracking ownership of reward shares.
1945  */
1946 abstract contract AbstractRewards is IAbstractRewards {
1947   using SafeCast for uint128;
1948   using SafeCast for uint256;
1949   using SafeCast for int256;
1950 
1951 /* ========  Constants  ======== */
1952   uint128 public constant POINTS_MULTIPLIER = type(uint128).max;
1953 
1954 /* ========  Internal Function References  ======== */
1955   function(address) view returns (uint256) private immutable getSharesOf;
1956   function() view returns (uint256) private immutable getTotalShares;
1957 
1958 /* ========  Storage  ======== */
1959   uint256 public pointsPerShare;
1960   mapping(address => int256) public pointsCorrection;
1961   mapping(address => uint256) public withdrawnRewards;
1962 
1963   constructor(
1964     function(address) view returns (uint256) getSharesOf_,
1965     function() view returns (uint256) getTotalShares_
1966   ) {
1967     getSharesOf = getSharesOf_;
1968     getTotalShares = getTotalShares_;
1969   }
1970 
1971 /* ========  Public View Functions  ======== */
1972   /**
1973    * @dev Returns the total amount of rewards a given address is able to withdraw.
1974    * @param _account Address of a reward recipient
1975    * @return A uint256 representing the rewards `account` can withdraw
1976    */
1977   function withdrawableRewardsOf(address _account) public view override returns (uint256) {
1978     return cumulativeRewardsOf(_account) - withdrawnRewards[_account];
1979   }
1980 
1981   /**
1982    * @notice View the amount of rewards that an address has withdrawn.
1983    * @param _account The address of a token holder.
1984    * @return The amount of rewards that `account` has withdrawn.
1985    */
1986   function withdrawnRewardsOf(address _account) public view override returns (uint256) {
1987     return withdrawnRewards[_account];
1988   }
1989 
1990   /**
1991    * @notice View the amount of rewards that an address has earned in total.
1992    * @dev accumulativeFundsOf(account) = withdrawableRewardsOf(account) + withdrawnRewardsOf(account)
1993    * = (pointsPerShare * balanceOf(account) + pointsCorrection[account]) / POINTS_MULTIPLIER
1994    * @param _account The address of a token holder.
1995    * @return The amount of rewards that `account` has earned in total.
1996    */
1997   function cumulativeRewardsOf(address _account) public view override returns (uint256) {
1998     return ((pointsPerShare * getSharesOf(_account)).toInt256() + pointsCorrection[_account]).toUint256() / POINTS_MULTIPLIER;
1999   }
2000 
2001 /* ========  Dividend Utility Functions  ======== */
2002 
2003   /** 
2004    * @notice Distributes rewards to token holders.
2005    * @dev It reverts if the total shares is 0.
2006    * It emits the `RewardsDistributed` event if the amount to distribute is greater than 0.
2007    * About undistributed rewards:
2008    *   In each distribution, there is a small amount which does not get distributed,
2009    *   which is `(amount * POINTS_MULTIPLIER) % totalShares()`.
2010    *   With a well-chosen `POINTS_MULTIPLIER`, the amount of funds that are not getting
2011    *   distributed in a distribution can be less than 1 (base unit).
2012    */
2013   function _distributeRewards(uint256 _amount) internal {
2014     uint256 shares = getTotalShares();
2015     require(shares > 0, "AbstractRewards._distributeRewards: total share supply is zero");
2016 
2017     if (_amount > 0) {
2018       pointsPerShare = pointsPerShare + (_amount * POINTS_MULTIPLIER / shares);
2019       emit RewardsDistributed(msg.sender, _amount);
2020     }
2021   }
2022 
2023   /**
2024    * @notice Prepares collection of owed rewards
2025    * @dev It emits a `RewardsWithdrawn` event if the amount of withdrawn rewards is
2026    * greater than 0.
2027    */
2028   function _prepareCollect(address _account) internal returns (uint256) {
2029     uint256 _withdrawableDividend = withdrawableRewardsOf(_account);
2030     if (_withdrawableDividend > 0) {
2031       withdrawnRewards[_account] = withdrawnRewards[_account] + _withdrawableDividend;
2032       emit RewardsWithdrawn(_account, _withdrawableDividend);
2033     }
2034     return _withdrawableDividend;
2035   }
2036 
2037   function _correctPointsForTransfer(address _from, address _to, uint256 _shares) internal {
2038     int256 _magCorrection = (pointsPerShare * _shares).toInt256();
2039     pointsCorrection[_from] = pointsCorrection[_from] + _magCorrection;
2040     pointsCorrection[_to] = pointsCorrection[_to] - _magCorrection;
2041   }
2042 
2043   /**
2044    * @dev Increases or decreases the points correction for `account` by
2045    * `shares*pointsPerShare`.
2046    */
2047   function _correctPoints(address _account, int256 _shares) internal {
2048     pointsCorrection[_account] = pointsCorrection[_account] + (_shares * (int256(pointsPerShare)));
2049   }
2050 }
2051 
2052 
2053 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.2
2054 
2055 pragma solidity ^0.8.0;
2056 
2057 /**
2058  * @dev External interface of AccessControl declared to support ERC165 detection.
2059  */
2060 interface IAccessControl {
2061     /**
2062      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2063      *
2064      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2065      * {RoleAdminChanged} not being emitted signaling this.
2066      *
2067      * _Available since v3.1._
2068      */
2069     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2070 
2071     /**
2072      * @dev Emitted when `account` is granted `role`.
2073      *
2074      * `sender` is the account that originated the contract call, an admin role
2075      * bearer except when using {AccessControl-_setupRole}.
2076      */
2077     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2078 
2079     /**
2080      * @dev Emitted when `account` is revoked `role`.
2081      *
2082      * `sender` is the account that originated the contract call:
2083      *   - if using `revokeRole`, it is the admin role bearer
2084      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2085      */
2086     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2087 
2088     /**
2089      * @dev Returns `true` if `account` has been granted `role`.
2090      */
2091     function hasRole(bytes32 role, address account) external view returns (bool);
2092 
2093     /**
2094      * @dev Returns the admin role that controls `role`. See {grantRole} and
2095      * {revokeRole}.
2096      *
2097      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2098      */
2099     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2100 
2101     /**
2102      * @dev Grants `role` to `account`.
2103      *
2104      * If `account` had not been already granted `role`, emits a {RoleGranted}
2105      * event.
2106      *
2107      * Requirements:
2108      *
2109      * - the caller must have ``role``'s admin role.
2110      */
2111     function grantRole(bytes32 role, address account) external;
2112 
2113     /**
2114      * @dev Revokes `role` from `account`.
2115      *
2116      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2117      *
2118      * Requirements:
2119      *
2120      * - the caller must have ``role``'s admin role.
2121      */
2122     function revokeRole(bytes32 role, address account) external;
2123 
2124     /**
2125      * @dev Revokes `role` from the calling account.
2126      *
2127      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2128      * purpose is to provide a mechanism for accounts to lose their privileges
2129      * if they are compromised (such as when a trusted device is misplaced).
2130      *
2131      * If the calling account had been granted `role`, emits a {RoleRevoked}
2132      * event.
2133      *
2134      * Requirements:
2135      *
2136      * - the caller must be `account`.
2137      */
2138     function renounceRole(bytes32 role, address account) external;
2139 }
2140 
2141 
2142 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.3.2
2143 
2144 pragma solidity ^0.8.0;
2145 
2146 /**
2147  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
2148  */
2149 interface IAccessControlEnumerable is IAccessControl {
2150     /**
2151      * @dev Returns one of the accounts that have `role`. `index` must be a
2152      * value between 0 and {getRoleMemberCount}, non-inclusive.
2153      *
2154      * Role bearers are not sorted in any particular way, and their ordering may
2155      * change at any point.
2156      *
2157      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2158      * you perform all queries on the same block. See the following
2159      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2160      * for more information.
2161      */
2162     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
2163 
2164     /**
2165      * @dev Returns the number of accounts that have `role`. Can be used
2166      * together with {getRoleMember} to enumerate all bearers of a role.
2167      */
2168     function getRoleMemberCount(bytes32 role) external view returns (uint256);
2169 }
2170 
2171 
2172 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
2173 
2174 pragma solidity ^0.8.0;
2175 
2176 /**
2177  * @dev String operations.
2178  */
2179 library Strings {
2180     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2181 
2182     /**
2183      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2184      */
2185     function toString(uint256 value) internal pure returns (string memory) {
2186         // Inspired by OraclizeAPI's implementation - MIT licence
2187         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2188 
2189         if (value == 0) {
2190             return "0";
2191         }
2192         uint256 temp = value;
2193         uint256 digits;
2194         while (temp != 0) {
2195             digits++;
2196             temp /= 10;
2197         }
2198         bytes memory buffer = new bytes(digits);
2199         while (value != 0) {
2200             digits -= 1;
2201             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2202             value /= 10;
2203         }
2204         return string(buffer);
2205     }
2206 
2207     /**
2208      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2209      */
2210     function toHexString(uint256 value) internal pure returns (string memory) {
2211         if (value == 0) {
2212             return "0x00";
2213         }
2214         uint256 temp = value;
2215         uint256 length = 0;
2216         while (temp != 0) {
2217             length++;
2218             temp >>= 8;
2219         }
2220         return toHexString(value, length);
2221     }
2222 
2223     /**
2224      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2225      */
2226     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2227         bytes memory buffer = new bytes(2 * length + 2);
2228         buffer[0] = "0";
2229         buffer[1] = "x";
2230         for (uint256 i = 2 * length + 1; i > 1; --i) {
2231             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2232             value >>= 4;
2233         }
2234         require(value == 0, "Strings: hex length insufficient");
2235         return string(buffer);
2236     }
2237 }
2238 
2239 
2240 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
2241 
2242 pragma solidity ^0.8.0;
2243 
2244 /**
2245  * @dev Interface of the ERC165 standard, as defined in the
2246  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2247  *
2248  * Implementers can declare support of contract interfaces, which can then be
2249  * queried by others ({ERC165Checker}).
2250  *
2251  * For an implementation, see {ERC165}.
2252  */
2253 interface IERC165 {
2254     /**
2255      * @dev Returns true if this contract implements the interface defined by
2256      * `interfaceId`. See the corresponding
2257      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2258      * to learn more about how these ids are created.
2259      *
2260      * This function call must use less than 30 000 gas.
2261      */
2262     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2263 }
2264 
2265 
2266 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
2267 
2268 pragma solidity ^0.8.0;
2269 
2270 /**
2271  * @dev Implementation of the {IERC165} interface.
2272  *
2273  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2274  * for the additional interface id that will be supported. For example:
2275  *
2276  * ```solidity
2277  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2278  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2279  * }
2280  * ```
2281  *
2282  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2283  */
2284 abstract contract ERC165 is IERC165 {
2285     /**
2286      * @dev See {IERC165-supportsInterface}.
2287      */
2288     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2289         return interfaceId == type(IERC165).interfaceId;
2290     }
2291 }
2292 
2293 
2294 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.2
2295 
2296 pragma solidity ^0.8.0;
2297 
2298 
2299 
2300 
2301 /**
2302  * @dev Contract module that allows children to implement role-based access
2303  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2304  * members except through off-chain means by accessing the contract event logs. Some
2305  * applications may benefit from on-chain enumerability, for those cases see
2306  * {AccessControlEnumerable}.
2307  *
2308  * Roles are referred to by their `bytes32` identifier. These should be exposed
2309  * in the external API and be unique. The best way to achieve this is by
2310  * using `public constant` hash digests:
2311  *
2312  * ```
2313  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2314  * ```
2315  *
2316  * Roles can be used to represent a set of permissions. To restrict access to a
2317  * function call, use {hasRole}:
2318  *
2319  * ```
2320  * function foo() public {
2321  *     require(hasRole(MY_ROLE, msg.sender));
2322  *     ...
2323  * }
2324  * ```
2325  *
2326  * Roles can be granted and revoked dynamically via the {grantRole} and
2327  * {revokeRole} functions. Each role has an associated admin role, and only
2328  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2329  *
2330  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2331  * that only accounts with this role will be able to grant or revoke other
2332  * roles. More complex role relationships can be created by using
2333  * {_setRoleAdmin}.
2334  *
2335  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2336  * grant and revoke this role. Extra precautions should be taken to secure
2337  * accounts that have been granted it.
2338  */
2339 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2340     struct RoleData {
2341         mapping(address => bool) members;
2342         bytes32 adminRole;
2343     }
2344 
2345     mapping(bytes32 => RoleData) private _roles;
2346 
2347     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2348 
2349     /**
2350      * @dev Modifier that checks that an account has a specific role. Reverts
2351      * with a standardized message including the required role.
2352      *
2353      * The format of the revert reason is given by the following regular expression:
2354      *
2355      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2356      *
2357      * _Available since v4.1._
2358      */
2359     modifier onlyRole(bytes32 role) {
2360         _checkRole(role, _msgSender());
2361         _;
2362     }
2363 
2364     /**
2365      * @dev See {IERC165-supportsInterface}.
2366      */
2367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2368         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2369     }
2370 
2371     /**
2372      * @dev Returns `true` if `account` has been granted `role`.
2373      */
2374     function hasRole(bytes32 role, address account) public view override returns (bool) {
2375         return _roles[role].members[account];
2376     }
2377 
2378     /**
2379      * @dev Revert with a standard message if `account` is missing `role`.
2380      *
2381      * The format of the revert reason is given by the following regular expression:
2382      *
2383      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2384      */
2385     function _checkRole(bytes32 role, address account) internal view {
2386         if (!hasRole(role, account)) {
2387             revert(
2388                 string(
2389                     abi.encodePacked(
2390                         "AccessControl: account ",
2391                         Strings.toHexString(uint160(account), 20),
2392                         " is missing role ",
2393                         Strings.toHexString(uint256(role), 32)
2394                     )
2395                 )
2396             );
2397         }
2398     }
2399 
2400     /**
2401      * @dev Returns the admin role that controls `role`. See {grantRole} and
2402      * {revokeRole}.
2403      *
2404      * To change a role's admin, use {_setRoleAdmin}.
2405      */
2406     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
2407         return _roles[role].adminRole;
2408     }
2409 
2410     /**
2411      * @dev Grants `role` to `account`.
2412      *
2413      * If `account` had not been already granted `role`, emits a {RoleGranted}
2414      * event.
2415      *
2416      * Requirements:
2417      *
2418      * - the caller must have ``role``'s admin role.
2419      */
2420     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2421         _grantRole(role, account);
2422     }
2423 
2424     /**
2425      * @dev Revokes `role` from `account`.
2426      *
2427      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2428      *
2429      * Requirements:
2430      *
2431      * - the caller must have ``role``'s admin role.
2432      */
2433     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2434         _revokeRole(role, account);
2435     }
2436 
2437     /**
2438      * @dev Revokes `role` from the calling account.
2439      *
2440      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2441      * purpose is to provide a mechanism for accounts to lose their privileges
2442      * if they are compromised (such as when a trusted device is misplaced).
2443      *
2444      * If the calling account had been granted `role`, emits a {RoleRevoked}
2445      * event.
2446      *
2447      * Requirements:
2448      *
2449      * - the caller must be `account`.
2450      */
2451     function renounceRole(bytes32 role, address account) public virtual override {
2452         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2453 
2454         _revokeRole(role, account);
2455     }
2456 
2457     /**
2458      * @dev Grants `role` to `account`.
2459      *
2460      * If `account` had not been already granted `role`, emits a {RoleGranted}
2461      * event. Note that unlike {grantRole}, this function doesn't perform any
2462      * checks on the calling account.
2463      *
2464      * [WARNING]
2465      * ====
2466      * This function should only be called from the constructor when setting
2467      * up the initial roles for the system.
2468      *
2469      * Using this function in any other way is effectively circumventing the admin
2470      * system imposed by {AccessControl}.
2471      * ====
2472      */
2473     function _setupRole(bytes32 role, address account) internal virtual {
2474         _grantRole(role, account);
2475     }
2476 
2477     /**
2478      * @dev Sets `adminRole` as ``role``'s admin role.
2479      *
2480      * Emits a {RoleAdminChanged} event.
2481      */
2482     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2483         bytes32 previousAdminRole = getRoleAdmin(role);
2484         _roles[role].adminRole = adminRole;
2485         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2486     }
2487 
2488     function _grantRole(bytes32 role, address account) private {
2489         if (!hasRole(role, account)) {
2490             _roles[role].members[account] = true;
2491             emit RoleGranted(role, account, _msgSender());
2492         }
2493     }
2494 
2495     function _revokeRole(bytes32 role, address account) private {
2496         if (hasRole(role, account)) {
2497             _roles[role].members[account] = false;
2498             emit RoleRevoked(role, account, _msgSender());
2499         }
2500     }
2501 }
2502 
2503 
2504 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.3.2
2505 
2506 pragma solidity ^0.8.0;
2507 
2508 /**
2509  * @dev Library for managing
2510  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2511  * types.
2512  *
2513  * Sets have the following properties:
2514  *
2515  * - Elements are added, removed, and checked for existence in constant time
2516  * (O(1)).
2517  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2518  *
2519  * ```
2520  * contract Example {
2521  *     // Add the library methods
2522  *     using EnumerableSet for EnumerableSet.AddressSet;
2523  *
2524  *     // Declare a set state variable
2525  *     EnumerableSet.AddressSet private mySet;
2526  * }
2527  * ```
2528  *
2529  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2530  * and `uint256` (`UintSet`) are supported.
2531  */
2532 library EnumerableSet {
2533     // To implement this library for multiple types with as little code
2534     // repetition as possible, we write it in terms of a generic Set type with
2535     // bytes32 values.
2536     // The Set implementation uses private functions, and user-facing
2537     // implementations (such as AddressSet) are just wrappers around the
2538     // underlying Set.
2539     // This means that we can only create new EnumerableSets for types that fit
2540     // in bytes32.
2541 
2542     struct Set {
2543         // Storage of set values
2544         bytes32[] _values;
2545         // Position of the value in the `values` array, plus 1 because index 0
2546         // means a value is not in the set.
2547         mapping(bytes32 => uint256) _indexes;
2548     }
2549 
2550     /**
2551      * @dev Add a value to a set. O(1).
2552      *
2553      * Returns true if the value was added to the set, that is if it was not
2554      * already present.
2555      */
2556     function _add(Set storage set, bytes32 value) private returns (bool) {
2557         if (!_contains(set, value)) {
2558             set._values.push(value);
2559             // The value is stored at length-1, but we add 1 to all indexes
2560             // and use 0 as a sentinel value
2561             set._indexes[value] = set._values.length;
2562             return true;
2563         } else {
2564             return false;
2565         }
2566     }
2567 
2568     /**
2569      * @dev Removes a value from a set. O(1).
2570      *
2571      * Returns true if the value was removed from the set, that is if it was
2572      * present.
2573      */
2574     function _remove(Set storage set, bytes32 value) private returns (bool) {
2575         // We read and store the value's index to prevent multiple reads from the same storage slot
2576         uint256 valueIndex = set._indexes[value];
2577 
2578         if (valueIndex != 0) {
2579             // Equivalent to contains(set, value)
2580             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2581             // the array, and then remove the last element (sometimes called as 'swap and pop').
2582             // This modifies the order of the array, as noted in {at}.
2583 
2584             uint256 toDeleteIndex = valueIndex - 1;
2585             uint256 lastIndex = set._values.length - 1;
2586 
2587             if (lastIndex != toDeleteIndex) {
2588                 bytes32 lastvalue = set._values[lastIndex];
2589 
2590                 // Move the last value to the index where the value to delete is
2591                 set._values[toDeleteIndex] = lastvalue;
2592                 // Update the index for the moved value
2593                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
2594             }
2595 
2596             // Delete the slot where the moved value was stored
2597             set._values.pop();
2598 
2599             // Delete the index for the deleted slot
2600             delete set._indexes[value];
2601 
2602             return true;
2603         } else {
2604             return false;
2605         }
2606     }
2607 
2608     /**
2609      * @dev Returns true if the value is in the set. O(1).
2610      */
2611     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2612         return set._indexes[value] != 0;
2613     }
2614 
2615     /**
2616      * @dev Returns the number of values on the set. O(1).
2617      */
2618     function _length(Set storage set) private view returns (uint256) {
2619         return set._values.length;
2620     }
2621 
2622     /**
2623      * @dev Returns the value stored at position `index` in the set. O(1).
2624      *
2625      * Note that there are no guarantees on the ordering of values inside the
2626      * array, and it may change when more values are added or removed.
2627      *
2628      * Requirements:
2629      *
2630      * - `index` must be strictly less than {length}.
2631      */
2632     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2633         return set._values[index];
2634     }
2635 
2636     /**
2637      * @dev Return the entire set in an array
2638      *
2639      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2640      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2641      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2642      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2643      */
2644     function _values(Set storage set) private view returns (bytes32[] memory) {
2645         return set._values;
2646     }
2647 
2648     // Bytes32Set
2649 
2650     struct Bytes32Set {
2651         Set _inner;
2652     }
2653 
2654     /**
2655      * @dev Add a value to a set. O(1).
2656      *
2657      * Returns true if the value was added to the set, that is if it was not
2658      * already present.
2659      */
2660     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2661         return _add(set._inner, value);
2662     }
2663 
2664     /**
2665      * @dev Removes a value from a set. O(1).
2666      *
2667      * Returns true if the value was removed from the set, that is if it was
2668      * present.
2669      */
2670     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2671         return _remove(set._inner, value);
2672     }
2673 
2674     /**
2675      * @dev Returns true if the value is in the set. O(1).
2676      */
2677     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2678         return _contains(set._inner, value);
2679     }
2680 
2681     /**
2682      * @dev Returns the number of values in the set. O(1).
2683      */
2684     function length(Bytes32Set storage set) internal view returns (uint256) {
2685         return _length(set._inner);
2686     }
2687 
2688     /**
2689      * @dev Returns the value stored at position `index` in the set. O(1).
2690      *
2691      * Note that there are no guarantees on the ordering of values inside the
2692      * array, and it may change when more values are added or removed.
2693      *
2694      * Requirements:
2695      *
2696      * - `index` must be strictly less than {length}.
2697      */
2698     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2699         return _at(set._inner, index);
2700     }
2701 
2702     /**
2703      * @dev Return the entire set in an array
2704      *
2705      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2706      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2707      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2708      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2709      */
2710     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2711         return _values(set._inner);
2712     }
2713 
2714     // AddressSet
2715 
2716     struct AddressSet {
2717         Set _inner;
2718     }
2719 
2720     /**
2721      * @dev Add a value to a set. O(1).
2722      *
2723      * Returns true if the value was added to the set, that is if it was not
2724      * already present.
2725      */
2726     function add(AddressSet storage set, address value) internal returns (bool) {
2727         return _add(set._inner, bytes32(uint256(uint160(value))));
2728     }
2729 
2730     /**
2731      * @dev Removes a value from a set. O(1).
2732      *
2733      * Returns true if the value was removed from the set, that is if it was
2734      * present.
2735      */
2736     function remove(AddressSet storage set, address value) internal returns (bool) {
2737         return _remove(set._inner, bytes32(uint256(uint160(value))));
2738     }
2739 
2740     /**
2741      * @dev Returns true if the value is in the set. O(1).
2742      */
2743     function contains(AddressSet storage set, address value) internal view returns (bool) {
2744         return _contains(set._inner, bytes32(uint256(uint160(value))));
2745     }
2746 
2747     /**
2748      * @dev Returns the number of values in the set. O(1).
2749      */
2750     function length(AddressSet storage set) internal view returns (uint256) {
2751         return _length(set._inner);
2752     }
2753 
2754     /**
2755      * @dev Returns the value stored at position `index` in the set. O(1).
2756      *
2757      * Note that there are no guarantees on the ordering of values inside the
2758      * array, and it may change when more values are added or removed.
2759      *
2760      * Requirements:
2761      *
2762      * - `index` must be strictly less than {length}.
2763      */
2764     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2765         return address(uint160(uint256(_at(set._inner, index))));
2766     }
2767 
2768     /**
2769      * @dev Return the entire set in an array
2770      *
2771      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2772      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2773      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2774      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2775      */
2776     function values(AddressSet storage set) internal view returns (address[] memory) {
2777         bytes32[] memory store = _values(set._inner);
2778         address[] memory result;
2779 
2780         assembly {
2781             result := store
2782         }
2783 
2784         return result;
2785     }
2786 
2787     // UintSet
2788 
2789     struct UintSet {
2790         Set _inner;
2791     }
2792 
2793     /**
2794      * @dev Add a value to a set. O(1).
2795      *
2796      * Returns true if the value was added to the set, that is if it was not
2797      * already present.
2798      */
2799     function add(UintSet storage set, uint256 value) internal returns (bool) {
2800         return _add(set._inner, bytes32(value));
2801     }
2802 
2803     /**
2804      * @dev Removes a value from a set. O(1).
2805      *
2806      * Returns true if the value was removed from the set, that is if it was
2807      * present.
2808      */
2809     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2810         return _remove(set._inner, bytes32(value));
2811     }
2812 
2813     /**
2814      * @dev Returns true if the value is in the set. O(1).
2815      */
2816     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2817         return _contains(set._inner, bytes32(value));
2818     }
2819 
2820     /**
2821      * @dev Returns the number of values on the set. O(1).
2822      */
2823     function length(UintSet storage set) internal view returns (uint256) {
2824         return _length(set._inner);
2825     }
2826 
2827     /**
2828      * @dev Returns the value stored at position `index` in the set. O(1).
2829      *
2830      * Note that there are no guarantees on the ordering of values inside the
2831      * array, and it may change when more values are added or removed.
2832      *
2833      * Requirements:
2834      *
2835      * - `index` must be strictly less than {length}.
2836      */
2837     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2838         return uint256(_at(set._inner, index));
2839     }
2840 
2841     /**
2842      * @dev Return the entire set in an array
2843      *
2844      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2845      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2846      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2847      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2848      */
2849     function values(UintSet storage set) internal view returns (uint256[] memory) {
2850         bytes32[] memory store = _values(set._inner);
2851         uint256[] memory result;
2852 
2853         assembly {
2854             result := store
2855         }
2856 
2857         return result;
2858     }
2859 }
2860 
2861 
2862 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.3.2
2863 
2864 pragma solidity ^0.8.0;
2865 
2866 
2867 
2868 /**
2869  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2870  */
2871 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
2872     using EnumerableSet for EnumerableSet.AddressSet;
2873 
2874     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2875 
2876     /**
2877      * @dev See {IERC165-supportsInterface}.
2878      */
2879     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2880         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
2881     }
2882 
2883     /**
2884      * @dev Returns one of the accounts that have `role`. `index` must be a
2885      * value between 0 and {getRoleMemberCount}, non-inclusive.
2886      *
2887      * Role bearers are not sorted in any particular way, and their ordering may
2888      * change at any point.
2889      *
2890      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2891      * you perform all queries on the same block. See the following
2892      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2893      * for more information.
2894      */
2895     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
2896         return _roleMembers[role].at(index);
2897     }
2898 
2899     /**
2900      * @dev Returns the number of accounts that have `role`. Can be used
2901      * together with {getRoleMember} to enumerate all bearers of a role.
2902      */
2903     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
2904         return _roleMembers[role].length();
2905     }
2906 
2907     /**
2908      * @dev Overload {grantRole} to track enumerable memberships
2909      */
2910     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
2911         super.grantRole(role, account);
2912         _roleMembers[role].add(account);
2913     }
2914 
2915     /**
2916      * @dev Overload {revokeRole} to track enumerable memberships
2917      */
2918     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
2919         super.revokeRole(role, account);
2920         _roleMembers[role].remove(account);
2921     }
2922 
2923     /**
2924      * @dev Overload {renounceRole} to track enumerable memberships
2925      */
2926     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
2927         super.renounceRole(role, account);
2928         _roleMembers[role].remove(account);
2929     }
2930 
2931     /**
2932      * @dev Overload {_setupRole} to track enumerable memberships
2933      */
2934     function _setupRole(bytes32 role, address account) internal virtual override {
2935         super._setupRole(role, account);
2936         _roleMembers[role].add(account);
2937     }
2938 }
2939 
2940 
2941 // File contracts/base/TokenSaver.sol
2942 
2943 pragma solidity 0.8.7;
2944 
2945 
2946 
2947 contract TokenSaver is AccessControlEnumerable {
2948     using SafeERC20 for IERC20;
2949 
2950     bytes32 public constant TOKEN_SAVER_ROLE = keccak256("TOKEN_SAVER_ROLE");
2951 
2952     event TokenSaved(address indexed by, address indexed receiver, address indexed token, uint256 amount);
2953 
2954     modifier onlyTokenSaver() {
2955         require(hasRole(TOKEN_SAVER_ROLE, _msgSender()), "TokenSaver.onlyTokenSaver: permission denied");
2956         _;
2957     }
2958 
2959     constructor() {
2960         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2961     }
2962 
2963     function saveToken(address _token, address _receiver, uint256 _amount) external onlyTokenSaver {
2964         IERC20(_token).safeTransfer(_receiver, _amount);
2965         emit TokenSaved(_msgSender(), _receiver, _token, _amount);
2966     }
2967 
2968 }
2969 
2970 
2971 // File contracts/base/BasePool.sol
2972 
2973 pragma solidity 0.8.7;
2974 
2975 
2976 
2977 
2978 
2979 
2980 abstract contract BasePool is ERC20Votes, AbstractRewards, IBasePool, TokenSaver {
2981     using SafeERC20 for IERC20;
2982     using SafeCast for uint256;
2983     using SafeCast for int256;
2984 
2985     IERC20 public immutable depositToken;
2986     IERC20 public immutable rewardToken;
2987     ITimeLockPool public immutable escrowPool;
2988     uint256 public immutable escrowPortion; // how much is escrowed 1e18 == 100%
2989     uint256 public immutable escrowDuration; // escrow duration in seconds
2990 
2991     event RewardsClaimed(address indexed _from, address indexed _receiver, uint256 _escrowedAmount, uint256 _nonEscrowedAmount);
2992 
2993     constructor(
2994         string memory _name,
2995         string memory _symbol,
2996         address _depositToken,
2997         address _rewardToken,
2998         address _escrowPool,
2999         uint256 _escrowPortion,
3000         uint256 _escrowDuration
3001     ) ERC20Permit(_name) ERC20(_name, _symbol) AbstractRewards(balanceOf, totalSupply) {
3002         require(_escrowPortion <= 1e18, "BasePool.constructor: Cannot escrow more than 100%");
3003         require(_depositToken != address(0), "BasePool.constructor: Deposit token must be set");
3004         depositToken = IERC20(_depositToken);
3005         rewardToken = IERC20(_rewardToken);
3006         escrowPool = ITimeLockPool(_escrowPool);
3007         escrowPortion = _escrowPortion;
3008         escrowDuration = _escrowDuration;
3009 
3010         if(_rewardToken != address(0) && _escrowPool != address(0)) {
3011             IERC20(_rewardToken).safeApprove(_escrowPool, type(uint256).max);
3012         }
3013     }
3014 
3015     function _mint(address _account, uint256 _amount) internal virtual override {
3016 		super._mint(_account, _amount);
3017         _correctPoints(_account, -(_amount.toInt256()));
3018 	}
3019 	
3020 	function _burn(address _account, uint256 _amount) internal virtual override {
3021 		super._burn(_account, _amount);
3022         _correctPoints(_account, _amount.toInt256());
3023 	}
3024 
3025     function _transfer(address _from, address _to, uint256 _value) internal virtual override {
3026 		super._transfer(_from, _to, _value);
3027         _correctPointsForTransfer(_from, _to, _value);
3028 	}
3029 
3030     function distributeRewards(uint256 _amount) external override {
3031         rewardToken.safeTransferFrom(_msgSender(), address(this), _amount);
3032         _distributeRewards(_amount);
3033     }
3034 
3035     function claimRewards(address _receiver) external {
3036         uint256 rewardAmount = _prepareCollect(_msgSender());
3037         uint256 escrowedRewardAmount = rewardAmount * escrowPortion / 1e18;
3038         uint256 nonEscrowedRewardAmount = rewardAmount - escrowedRewardAmount;
3039 
3040         if(escrowedRewardAmount != 0 && address(escrowPool) != address(0)) {
3041             escrowPool.deposit(escrowedRewardAmount, escrowDuration, _receiver);
3042         }
3043 
3044         // ignore dust
3045         if(nonEscrowedRewardAmount > 1) {
3046             rewardToken.safeTransfer(_receiver, nonEscrowedRewardAmount);
3047         }
3048 
3049         emit RewardsClaimed(_msgSender(), _receiver, escrowedRewardAmount, nonEscrowedRewardAmount);
3050     }
3051 
3052 }
3053 
3054 
3055 // File contracts/TimeLockPool.sol
3056 
3057 pragma solidity 0.8.7;
3058 
3059 
3060 
3061 
3062 contract TimeLockPool is BasePool, ITimeLockPool {
3063     using Math for uint256;
3064     using SafeERC20 for IERC20;
3065 
3066     uint256 public immutable maxBonus;
3067     uint256 public immutable maxLockDuration;
3068     uint256 public constant MIN_LOCK_DURATION = 10 minutes;
3069     
3070     mapping(address => Deposit[]) public depositsOf;
3071 
3072     struct Deposit {
3073         uint256 amount;
3074         uint64 start;
3075         uint64 end;
3076     }
3077     constructor(
3078         string memory _name,
3079         string memory _symbol,
3080         address _depositToken,
3081         address _rewardToken,
3082         address _escrowPool,
3083         uint256 _escrowPortion,
3084         uint256 _escrowDuration,
3085         uint256 _maxBonus,
3086         uint256 _maxLockDuration
3087     ) BasePool(_name, _symbol, _depositToken, _rewardToken, _escrowPool, _escrowPortion, _escrowDuration) {
3088         require(_maxLockDuration >= MIN_LOCK_DURATION, "TimeLockPool.constructor: max lock duration must be greater or equal to mininmum lock duration");
3089         maxBonus = _maxBonus;
3090         maxLockDuration = _maxLockDuration;
3091     }
3092 
3093     event Deposited(uint256 amount, uint256 duration, address indexed receiver, address indexed from);
3094     event Withdrawn(uint256 indexed depositId, address indexed receiver, address indexed from, uint256 amount);
3095 
3096     function deposit(uint256 _amount, uint256 _duration, address _receiver) external override {
3097         require(_amount > 0, "TimeLockPool.deposit: cannot deposit 0");
3098         // Don't allow locking > maxLockDuration
3099         uint256 duration = _duration.min(maxLockDuration);
3100         // Enforce min lockup duration to prevent flash loan or MEV transaction ordering
3101         duration = duration.max(MIN_LOCK_DURATION);
3102 
3103         depositToken.safeTransferFrom(_msgSender(), address(this), _amount);
3104 
3105         depositsOf[_receiver].push(Deposit({
3106             amount: _amount,
3107             start: uint64(block.timestamp),
3108             end: uint64(block.timestamp) + uint64(duration)
3109         }));
3110 
3111         uint256 mintAmount = _amount * getMultiplier(duration) / 1e18;
3112 
3113         _mint(_receiver, mintAmount);
3114         emit Deposited(_amount, duration, _receiver, _msgSender());
3115     }
3116 
3117     function withdraw(uint256 _depositId, address _receiver) external {
3118         require(_depositId < depositsOf[_msgSender()].length, "TimeLockPool.withdraw: Deposit does not exist");
3119         Deposit memory userDeposit = depositsOf[_msgSender()][_depositId];
3120         require(block.timestamp >= userDeposit.end, "TimeLockPool.withdraw: too soon");
3121 
3122         //                      No risk of wrapping around on casting to uint256 since deposit end always > deposit start and types are 64 bits
3123         uint256 shareAmount = userDeposit.amount * getMultiplier(uint256(userDeposit.end - userDeposit.start)) / 1e18;
3124 
3125         // remove Deposit
3126         depositsOf[_msgSender()][_depositId] = depositsOf[_msgSender()][depositsOf[_msgSender()].length - 1];
3127         depositsOf[_msgSender()].pop();
3128 
3129         // burn pool shares
3130         _burn(_msgSender(), shareAmount);
3131         
3132         // return tokens
3133         depositToken.safeTransfer(_receiver, userDeposit.amount);
3134         emit Withdrawn(_depositId, _receiver, _msgSender(), userDeposit.amount);
3135     }
3136 
3137     function getMultiplier(uint256 _lockDuration) public view returns(uint256) {
3138         return 1e18 + (maxBonus * _lockDuration / maxLockDuration);
3139     }
3140 
3141     function getTotalDeposit(address _account) public view returns(uint256) {
3142         uint256 total;
3143         for(uint256 i = 0; i < depositsOf[_account].length; i++) {
3144             total += depositsOf[_account][i].amount;
3145         }
3146 
3147         return total;
3148     }
3149 
3150     function getDepositsOf(address _account) public view returns(Deposit[] memory) {
3151         return depositsOf[_account];
3152     }
3153 
3154     function getDepositsOfLength(address _account) public view returns(uint256) {
3155         return depositsOf[_account].length;
3156     }
3157 }
3158 
3159 
3160 // File contracts/TimeLockNonTransferablePool.sol
3161 
3162 pragma solidity 0.8.7;
3163 
3164 contract TimeLockNonTransferablePool is TimeLockPool {
3165     constructor(
3166         string memory _name,
3167         string memory _symbol,
3168         address _depositToken,
3169         address _rewardToken,
3170         address _escrowPool,
3171         uint256 _escrowPortion,
3172         uint256 _escrowDuration,
3173         uint256 _maxBonus,
3174         uint256 _maxLockDuration
3175     ) TimeLockPool(_name, _symbol, _depositToken, _rewardToken, _escrowPool, _escrowPortion, _escrowDuration, _maxBonus, _maxLockDuration) {
3176 
3177     }
3178 
3179     // disable transfers
3180     function _transfer(address _from, address _to, uint256 _amount) internal override {
3181         revert("NON_TRANSFERABLE");
3182     }
3183 }