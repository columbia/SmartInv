1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-15
3 */
4 
5 // Sources flattened with hardhat v2.6.2 https://hardhat.org
6 
7 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(
71         address sender,
72         address recipient,
73         uint256 amount
74     ) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 // File @openzeppelin/contracts/utils/math/Math.sol@v4.3.2
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Standard math utilities missing in the Solidity language.
98  */
99 library Math {
100     /**
101      * @dev Returns the largest of two numbers.
102      */
103     function max(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a >= b ? a : b;
105     }
106 
107     /**
108      * @dev Returns the smallest of two numbers.
109      */
110     function min(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a < b ? a : b;
112     }
113 
114     /**
115      * @dev Returns the average of two numbers. The result is rounded towards
116      * zero.
117      */
118     function average(uint256 a, uint256 b) internal pure returns (uint256) {
119         // (a + b) / 2 can overflow.
120         return (a & b) + (a ^ b) / 2;
121     }
122 
123     /**
124      * @dev Returns the ceiling of the division of two numbers.
125      *
126      * This differs from standard division with `/` in that it rounds up instead
127      * of rounding down.
128      */
129     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
130         // (a + b - 1) / b can overflow on addition, so we distribute.
131         return a / b + (a % b == 0 ? 0 : 1);
132     }
133 }
134 
135 
136 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Collection of functions related to the address type
142  */
143 library Address {
144     /**
145      * @dev Returns true if `account` is a contract.
146      *
147      * [IMPORTANT]
148      * ====
149      * It is unsafe to assume that an address for which this function returns
150      * false is an externally-owned account (EOA) and not a contract.
151      *
152      * Among others, `isContract` will return false for the following
153      * types of addresses:
154      *
155      *  - an externally-owned account
156      *  - a contract in construction
157      *  - an address where a contract will be created
158      *  - an address where a contract lived, but was destroyed
159      * ====
160      */
161     function isContract(address account) internal view returns (bool) {
162         // This method relies on extcodesize, which returns 0 for contracts in
163         // construction, since the code is only stored at the end of the
164         // constructor execution.
165 
166         uint256 size;
167         assembly {
168             size := extcodesize(account)
169         }
170         return size > 0;
171     }
172 
173     /**
174      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
175      * `recipient`, forwarding all available gas and reverting on errors.
176      *
177      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
178      * of certain opcodes, possibly making contracts go over the 2300 gas limit
179      * imposed by `transfer`, making them unable to receive funds via
180      * `transfer`. {sendValue} removes this limitation.
181      *
182      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
183      *
184      * IMPORTANT: because control is transferred to `recipient`, care must be
185      * taken to not create reentrancy vulnerabilities. Consider using
186      * {ReentrancyGuard} or the
187      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
188      */
189     function sendValue(address payable recipient, uint256 amount) internal {
190         require(address(this).balance >= amount, "Address: insufficient balance");
191 
192         (bool success, ) = recipient.call{value: amount}("");
193         require(success, "Address: unable to send value, recipient may have reverted");
194     }
195 
196     /**
197      * @dev Performs a Solidity function call using a low level `call`. A
198      * plain `call` is an unsafe replacement for a function call: use this
199      * function instead.
200      *
201      * If `target` reverts with a revert reason, it is bubbled up by this
202      * function (like regular Solidity function calls).
203      *
204      * Returns the raw returned data. To convert to the expected return value,
205      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
206      *
207      * Requirements:
208      *
209      * - `target` must be a contract.
210      * - calling `target` with `data` must not revert.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
215         return functionCall(target, data, "Address: low-level call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
220      * `errorMessage` as a fallback revert reason when `target` reverts.
221      *
222      * _Available since v3.1._
223      */
224     function functionCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal returns (bytes memory) {
229         return functionCallWithValue(target, data, 0, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but also transferring `value` wei to `target`.
235      *
236      * Requirements:
237      *
238      * - the calling contract must have an ETH balance of at least `value`.
239      * - the called Solidity function must be `payable`.
240      *
241      * _Available since v3.1._
242      */
243     function functionCallWithValue(
244         address target,
245         bytes memory data,
246         uint256 value
247     ) internal returns (bytes memory) {
248         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
253      * with `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCallWithValue(
258         address target,
259         bytes memory data,
260         uint256 value,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         require(address(this).balance >= value, "Address: insufficient balance for call");
264         require(isContract(target), "Address: call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.call{value: value}(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
277         return functionStaticCall(target, data, "Address: low-level static call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal view returns (bytes memory) {
291         require(isContract(target), "Address: static call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.staticcall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
309      * but performing a delegate call.
310      *
311      * _Available since v3.4._
312      */
313     function functionDelegateCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         require(isContract(target), "Address: delegate call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.delegatecall(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
326      * revert reason using the provided one.
327      *
328      * _Available since v4.3._
329      */
330     function verifyCallResult(
331         bool success,
332         bytes memory returndata,
333         string memory errorMessage
334     ) internal pure returns (bytes memory) {
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 assembly {
343                     let returndata_size := mload(returndata)
344                     revert(add(32, returndata), returndata_size)
345                 }
346             } else {
347                 revert(errorMessage);
348             }
349         }
350     }
351 }
352 
353 
354 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.2
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @title SafeERC20
361  * @dev Wrappers around ERC20 operations that throw on failure (when the token
362  * contract returns false). Tokens that return no value (and instead revert or
363  * throw on failure) are also supported, non-reverting calls are assumed to be
364  * successful.
365  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
366  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
367  */
368 library SafeERC20 {
369     using Address for address;
370 
371     function safeTransfer(
372         IERC20 token,
373         address to,
374         uint256 value
375     ) internal {
376         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
377     }
378 
379     function safeTransferFrom(
380         IERC20 token,
381         address from,
382         address to,
383         uint256 value
384     ) internal {
385         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
386     }
387 
388     /**
389      * @dev Deprecated. This function has issues similar to the ones found in
390      * {IERC20-approve}, and its usage is discouraged.
391      *
392      * Whenever possible, use {safeIncreaseAllowance} and
393      * {safeDecreaseAllowance} instead.
394      */
395     function safeApprove(
396         IERC20 token,
397         address spender,
398         uint256 value
399     ) internal {
400         // safeApprove should only be called when setting an initial allowance,
401         // or when resetting it to zero. To increase and decrease it, use
402         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
403         require(
404             (value == 0) || (token.allowance(address(this), spender) == 0),
405             "SafeERC20: approve from non-zero to non-zero allowance"
406         );
407         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
408     }
409 
410     function safeIncreaseAllowance(
411         IERC20 token,
412         address spender,
413         uint256 value
414     ) internal {
415         uint256 newAllowance = token.allowance(address(this), spender) + value;
416         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
417     }
418 
419     function safeDecreaseAllowance(
420         IERC20 token,
421         address spender,
422         uint256 value
423     ) internal {
424         unchecked {
425             uint256 oldAllowance = token.allowance(address(this), spender);
426             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
427             uint256 newAllowance = oldAllowance - value;
428             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429         }
430     }
431 
432     /**
433      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
434      * on the return value: the return value is optional (but if data is returned, it must not be false).
435      * @param token The token targeted by the call.
436      * @param data The call data (encoded using abi.encode or one of its variants).
437      */
438     function _callOptionalReturn(IERC20 token, bytes memory data) private {
439         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
440         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
441         // the target address contains contract code and also asserts for success in the low-level call.
442 
443         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
444         if (returndata.length > 0) {
445             // Return data is optional
446             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
447         }
448     }
449 }
450 
451 
452 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.3.2
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
458  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
459  *
460  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
461  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
462  * need to send a transaction, and thus is not required to hold Ether at all.
463  */
464 interface IERC20Permit {
465     /**
466      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
467      * given ``owner``'s signed approval.
468      *
469      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
470      * ordering also apply here.
471      *
472      * Emits an {Approval} event.
473      *
474      * Requirements:
475      *
476      * - `spender` cannot be the zero address.
477      * - `deadline` must be a timestamp in the future.
478      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
479      * over the EIP712-formatted function arguments.
480      * - the signature must use ``owner``'s current nonce (see {nonces}).
481      *
482      * For more information on the signature format, see the
483      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
484      * section].
485      */
486     function permit(
487         address owner,
488         address spender,
489         uint256 value,
490         uint256 deadline,
491         uint8 v,
492         bytes32 r,
493         bytes32 s
494     ) external;
495 
496     /**
497      * @dev Returns the current nonce for `owner`. This value must be
498      * included whenever a signature is generated for {permit}.
499      *
500      * Every successful call to {permit} increases ``owner``'s nonce by one. This
501      * prevents a signature from being used multiple times.
502      */
503     function nonces(address owner) external view returns (uint256);
504 
505     /**
506      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
507      */
508     // solhint-disable-next-line func-name-mixedcase
509     function DOMAIN_SEPARATOR() external view returns (bytes32);
510 }
511 
512 
513 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @dev Interface for the optional metadata functions from the ERC20 standard.
519  *
520  * _Available since v4.1._
521  */
522 interface IERC20Metadata is IERC20 {
523     /**
524      * @dev Returns the name of the token.
525      */
526     function name() external view returns (string memory);
527 
528     /**
529      * @dev Returns the symbol of the token.
530      */
531     function symbol() external view returns (string memory);
532 
533     /**
534      * @dev Returns the decimals places of the token.
535      */
536     function decimals() external view returns (uint8);
537 }
538 
539 
540 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev Provides information about the current execution context, including the
546  * sender of the transaction and its data. While these are generally available
547  * via msg.sender and msg.data, they should not be accessed in such a direct
548  * manner, since when dealing with meta-transactions the account sending and
549  * paying for execution may not be the actual sender (as far as an application
550  * is concerned).
551  *
552  * This contract is only required for intermediate, library-like contracts.
553  */
554 abstract contract Context {
555     function _msgSender() internal view virtual returns (address) {
556         return msg.sender;
557     }
558 
559     function _msgData() internal view virtual returns (bytes calldata) {
560         return msg.data;
561     }
562 }
563 
564 
565 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
566 
567 pragma solidity ^0.8.0;
568 
569 
570 
571 /**
572  * @dev Implementation of the {IERC20} interface.
573  *
574  * This implementation is agnostic to the way tokens are created. This means
575  * that a supply mechanism has to be added in a derived contract using {_mint}.
576  * For a generic mechanism see {ERC20PresetMinterPauser}.
577  *
578  * TIP: For a detailed writeup see our guide
579  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
580  * to implement supply mechanisms].
581  *
582  * We have followed general OpenZeppelin Contracts guidelines: functions revert
583  * instead returning `false` on failure. This behavior is nonetheless
584  * conventional and does not conflict with the expectations of ERC20
585  * applications.
586  *
587  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
588  * This allows applications to reconstruct the allowance for all accounts just
589  * by listening to said events. Other implementations of the EIP may not emit
590  * these events, as it isn't required by the specification.
591  *
592  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
593  * functions have been added to mitigate the well-known issues around setting
594  * allowances. See {IERC20-approve}.
595  */
596 contract ERC20 is Context, IERC20, IERC20Metadata {
597     mapping(address => uint256) private _balances;
598 
599     mapping(address => mapping(address => uint256)) private _allowances;
600 
601     uint256 private _totalSupply;
602 
603     string private _name;
604     string private _symbol;
605 
606     /**
607      * @dev Sets the values for {name} and {symbol}.
608      *
609      * The default value of {decimals} is 18. To select a different value for
610      * {decimals} you should overload it.
611      *
612      * All two of these values are immutable: they can only be set once during
613      * construction.
614      */
615     constructor(string memory name_, string memory symbol_) {
616         _name = name_;
617         _symbol = symbol_;
618     }
619 
620     /**
621      * @dev Returns the name of the token.
622      */
623     function name() public view virtual override returns (string memory) {
624         return _name;
625     }
626 
627     /**
628      * @dev Returns the symbol of the token, usually a shorter version of the
629      * name.
630      */
631     function symbol() public view virtual override returns (string memory) {
632         return _symbol;
633     }
634 
635     /**
636      * @dev Returns the number of decimals used to get its user representation.
637      * For example, if `decimals` equals `2`, a balance of `505` tokens should
638      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
639      *
640      * Tokens usually opt for a value of 18, imitating the relationship between
641      * Ether and Wei. This is the value {ERC20} uses, unless this function is
642      * overridden;
643      *
644      * NOTE: This information is only used for _display_ purposes: it in
645      * no way affects any of the arithmetic of the contract, including
646      * {IERC20-balanceOf} and {IERC20-transfer}.
647      */
648     function decimals() public view virtual override returns (uint8) {
649         return 18;
650     }
651 
652     /**
653      * @dev See {IERC20-totalSupply}.
654      */
655     function totalSupply() public view virtual override returns (uint256) {
656         return _totalSupply;
657     }
658 
659     /**
660      * @dev See {IERC20-balanceOf}.
661      */
662     function balanceOf(address account) public view virtual override returns (uint256) {
663         return _balances[account];
664     }
665 
666     /**
667      * @dev See {IERC20-transfer}.
668      *
669      * Requirements:
670      *
671      * - `recipient` cannot be the zero address.
672      * - the caller must have a balance of at least `amount`.
673      */
674     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
675         _transfer(_msgSender(), recipient, amount);
676         return true;
677     }
678 
679     /**
680      * @dev See {IERC20-allowance}.
681      */
682     function allowance(address owner, address spender) public view virtual override returns (uint256) {
683         return _allowances[owner][spender];
684     }
685 
686     /**
687      * @dev See {IERC20-approve}.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function approve(address spender, uint256 amount) public virtual override returns (bool) {
694         _approve(_msgSender(), spender, amount);
695         return true;
696     }
697 
698     /**
699      * @dev See {IERC20-transferFrom}.
700      *
701      * Emits an {Approval} event indicating the updated allowance. This is not
702      * required by the EIP. See the note at the beginning of {ERC20}.
703      *
704      * Requirements:
705      *
706      * - `sender` and `recipient` cannot be the zero address.
707      * - `sender` must have a balance of at least `amount`.
708      * - the caller must have allowance for ``sender``'s tokens of at least
709      * `amount`.
710      */
711     function transferFrom(
712         address sender,
713         address recipient,
714         uint256 amount
715     ) public virtual override returns (bool) {
716         _transfer(sender, recipient, amount);
717 
718         uint256 currentAllowance = _allowances[sender][_msgSender()];
719         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
720         unchecked {
721             _approve(sender, _msgSender(), currentAllowance - amount);
722         }
723 
724         return true;
725     }
726 
727     /**
728      * @dev Atomically increases the allowance granted to `spender` by the caller.
729      *
730      * This is an alternative to {approve} that can be used as a mitigation for
731      * problems described in {IERC20-approve}.
732      *
733      * Emits an {Approval} event indicating the updated allowance.
734      *
735      * Requirements:
736      *
737      * - `spender` cannot be the zero address.
738      */
739     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
740         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
741         return true;
742     }
743 
744     /**
745      * @dev Atomically decreases the allowance granted to `spender` by the caller.
746      *
747      * This is an alternative to {approve} that can be used as a mitigation for
748      * problems described in {IERC20-approve}.
749      *
750      * Emits an {Approval} event indicating the updated allowance.
751      *
752      * Requirements:
753      *
754      * - `spender` cannot be the zero address.
755      * - `spender` must have allowance for the caller of at least
756      * `subtractedValue`.
757      */
758     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
759         uint256 currentAllowance = _allowances[_msgSender()][spender];
760         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
761         unchecked {
762             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
763         }
764 
765         return true;
766     }
767 
768     /**
769      * @dev Moves `amount` of tokens from `sender` to `recipient`.
770      *
771      * This internal function is equivalent to {transfer}, and can be used to
772      * e.g. implement automatic token fees, slashing mechanisms, etc.
773      *
774      * Emits a {Transfer} event.
775      *
776      * Requirements:
777      *
778      * - `sender` cannot be the zero address.
779      * - `recipient` cannot be the zero address.
780      * - `sender` must have a balance of at least `amount`.
781      */
782     function _transfer(
783         address sender,
784         address recipient,
785         uint256 amount
786     ) internal virtual {
787         require(sender != address(0), "ERC20: transfer from the zero address");
788         require(recipient != address(0), "ERC20: transfer to the zero address");
789 
790         _beforeTokenTransfer(sender, recipient, amount);
791 
792         uint256 senderBalance = _balances[sender];
793         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
794         unchecked {
795             _balances[sender] = senderBalance - amount;
796         }
797         _balances[recipient] += amount;
798 
799         emit Transfer(sender, recipient, amount);
800 
801         _afterTokenTransfer(sender, recipient, amount);
802     }
803 
804     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
805      * the total supply.
806      *
807      * Emits a {Transfer} event with `from` set to the zero address.
808      *
809      * Requirements:
810      *
811      * - `account` cannot be the zero address.
812      */
813     function _mint(address account, uint256 amount) internal virtual {
814         require(account != address(0), "ERC20: mint to the zero address");
815 
816         _beforeTokenTransfer(address(0), account, amount);
817 
818         _totalSupply += amount;
819         _balances[account] += amount;
820         emit Transfer(address(0), account, amount);
821 
822         _afterTokenTransfer(address(0), account, amount);
823     }
824 
825     /**
826      * @dev Destroys `amount` tokens from `account`, reducing the
827      * total supply.
828      *
829      * Emits a {Transfer} event with `to` set to the zero address.
830      *
831      * Requirements:
832      *
833      * - `account` cannot be the zero address.
834      * - `account` must have at least `amount` tokens.
835      */
836     function _burn(address account, uint256 amount) internal virtual {
837         require(account != address(0), "ERC20: burn from the zero address");
838 
839         _beforeTokenTransfer(account, address(0), amount);
840 
841         uint256 accountBalance = _balances[account];
842         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
843         unchecked {
844             _balances[account] = accountBalance - amount;
845         }
846         _totalSupply -= amount;
847 
848         emit Transfer(account, address(0), amount);
849 
850         _afterTokenTransfer(account, address(0), amount);
851     }
852 
853     /**
854      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
855      *
856      * This internal function is equivalent to `approve`, and can be used to
857      * e.g. set automatic allowances for certain subsystems, etc.
858      *
859      * Emits an {Approval} event.
860      *
861      * Requirements:
862      *
863      * - `owner` cannot be the zero address.
864      * - `spender` cannot be the zero address.
865      */
866     function _approve(
867         address owner,
868         address spender,
869         uint256 amount
870     ) internal virtual {
871         require(owner != address(0), "ERC20: approve from the zero address");
872         require(spender != address(0), "ERC20: approve to the zero address");
873 
874         _allowances[owner][spender] = amount;
875         emit Approval(owner, spender, amount);
876     }
877 
878     /**
879      * @dev Hook that is called before any transfer of tokens. This includes
880      * minting and burning.
881      *
882      * Calling conditions:
883      *
884      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
885      * will be transferred to `to`.
886      * - when `from` is zero, `amount` tokens will be minted for `to`.
887      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
888      * - `from` and `to` are never both zero.
889      *
890      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
891      */
892     function _beforeTokenTransfer(
893         address from,
894         address to,
895         uint256 amount
896     ) internal virtual {}
897 
898     /**
899      * @dev Hook that is called after any transfer of tokens. This includes
900      * minting and burning.
901      *
902      * Calling conditions:
903      *
904      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
905      * has been transferred to `to`.
906      * - when `from` is zero, `amount` tokens have been minted for `to`.
907      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
908      * - `from` and `to` are never both zero.
909      *
910      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
911      */
912     function _afterTokenTransfer(
913         address from,
914         address to,
915         uint256 amount
916     ) internal virtual {}
917 }
918 
919 
920 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.2
921 
922 pragma solidity ^0.8.0;
923 
924 /**
925  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
926  *
927  * These functions can be used to verify that a message was signed by the holder
928  * of the private keys of a given address.
929  */
930 library ECDSA {
931     enum RecoverError {
932         NoError,
933         InvalidSignature,
934         InvalidSignatureLength,
935         InvalidSignatureS,
936         InvalidSignatureV
937     }
938 
939     function _throwError(RecoverError error) private pure {
940         if (error == RecoverError.NoError) {
941             return; // no error: do nothing
942         } else if (error == RecoverError.InvalidSignature) {
943             revert("ECDSA: invalid signature");
944         } else if (error == RecoverError.InvalidSignatureLength) {
945             revert("ECDSA: invalid signature length");
946         } else if (error == RecoverError.InvalidSignatureS) {
947             revert("ECDSA: invalid signature 's' value");
948         } else if (error == RecoverError.InvalidSignatureV) {
949             revert("ECDSA: invalid signature 'v' value");
950         }
951     }
952 
953     /**
954      * @dev Returns the address that signed a hashed message (`hash`) with
955      * `signature` or error string. This address can then be used for verification purposes.
956      *
957      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
958      * this function rejects them by requiring the `s` value to be in the lower
959      * half order, and the `v` value to be either 27 or 28.
960      *
961      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
962      * verification to be secure: it is possible to craft signatures that
963      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
964      * this is by receiving a hash of the original message (which may otherwise
965      * be too long), and then calling {toEthSignedMessageHash} on it.
966      *
967      * Documentation for signature generation:
968      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
969      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
970      *
971      * _Available since v4.3._
972      */
973     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
974         // Check the signature length
975         // - case 65: r,s,v signature (standard)
976         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
977         if (signature.length == 65) {
978             bytes32 r;
979             bytes32 s;
980             uint8 v;
981             // ecrecover takes the signature parameters, and the only way to get them
982             // currently is to use assembly.
983             assembly {
984                 r := mload(add(signature, 0x20))
985                 s := mload(add(signature, 0x40))
986                 v := byte(0, mload(add(signature, 0x60)))
987             }
988             return tryRecover(hash, v, r, s);
989         } else if (signature.length == 64) {
990             bytes32 r;
991             bytes32 vs;
992             // ecrecover takes the signature parameters, and the only way to get them
993             // currently is to use assembly.
994             assembly {
995                 r := mload(add(signature, 0x20))
996                 vs := mload(add(signature, 0x40))
997             }
998             return tryRecover(hash, r, vs);
999         } else {
1000             return (address(0), RecoverError.InvalidSignatureLength);
1001         }
1002     }
1003 
1004     /**
1005      * @dev Returns the address that signed a hashed message (`hash`) with
1006      * `signature`. This address can then be used for verification purposes.
1007      *
1008      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1009      * this function rejects them by requiring the `s` value to be in the lower
1010      * half order, and the `v` value to be either 27 or 28.
1011      *
1012      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1013      * verification to be secure: it is possible to craft signatures that
1014      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1015      * this is by receiving a hash of the original message (which may otherwise
1016      * be too long), and then calling {toEthSignedMessageHash} on it.
1017      */
1018     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1019         (address recovered, RecoverError error) = tryRecover(hash, signature);
1020         _throwError(error);
1021         return recovered;
1022     }
1023 
1024     /**
1025      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1026      *
1027      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1028      *
1029      * _Available since v4.3._
1030      */
1031     function tryRecover(
1032         bytes32 hash,
1033         bytes32 r,
1034         bytes32 vs
1035     ) internal pure returns (address, RecoverError) {
1036         bytes32 s;
1037         uint8 v;
1038         assembly {
1039             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1040             v := add(shr(255, vs), 27)
1041         }
1042         return tryRecover(hash, v, r, s);
1043     }
1044 
1045     /**
1046      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1047      *
1048      * _Available since v4.2._
1049      */
1050     function recover(
1051         bytes32 hash,
1052         bytes32 r,
1053         bytes32 vs
1054     ) internal pure returns (address) {
1055         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1056         _throwError(error);
1057         return recovered;
1058     }
1059 
1060     /**
1061      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1062      * `r` and `s` signature fields separately.
1063      *
1064      * _Available since v4.3._
1065      */
1066     function tryRecover(
1067         bytes32 hash,
1068         uint8 v,
1069         bytes32 r,
1070         bytes32 s
1071     ) internal pure returns (address, RecoverError) {
1072         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1073         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1074         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1075         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1076         //
1077         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1078         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1079         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1080         // these malleable signatures as well.
1081         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1082             return (address(0), RecoverError.InvalidSignatureS);
1083         }
1084         if (v != 27 && v != 28) {
1085             return (address(0), RecoverError.InvalidSignatureV);
1086         }
1087 
1088         // If the signature is valid (and not malleable), return the signer address
1089         address signer = ecrecover(hash, v, r, s);
1090         if (signer == address(0)) {
1091             return (address(0), RecoverError.InvalidSignature);
1092         }
1093 
1094         return (signer, RecoverError.NoError);
1095     }
1096 
1097     /**
1098      * @dev Overload of {ECDSA-recover} that receives the `v`,
1099      * `r` and `s` signature fields separately.
1100      */
1101     function recover(
1102         bytes32 hash,
1103         uint8 v,
1104         bytes32 r,
1105         bytes32 s
1106     ) internal pure returns (address) {
1107         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1108         _throwError(error);
1109         return recovered;
1110     }
1111 
1112     /**
1113      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1114      * produces hash corresponding to the one signed with the
1115      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1116      * JSON-RPC method as part of EIP-191.
1117      *
1118      * See {recover}.
1119      */
1120     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1121         // 32 is the length in bytes of hash,
1122         // enforced by the type signature above
1123         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1124     }
1125 
1126     /**
1127      * @dev Returns an Ethereum Signed Typed Data, created from a
1128      * `domainSeparator` and a `structHash`. This produces hash corresponding
1129      * to the one signed with the
1130      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1131      * JSON-RPC method as part of EIP-712.
1132      *
1133      * See {recover}.
1134      */
1135     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1136         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1137     }
1138 }
1139 
1140 
1141 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.3.2
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 /**
1146  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1147  *
1148  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1149  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1150  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1151  *
1152  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1153  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1154  * ({_hashTypedDataV4}).
1155  *
1156  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1157  * the chain id to protect against replay attacks on an eventual fork of the chain.
1158  *
1159  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1160  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1161  *
1162  * _Available since v3.4._
1163  */
1164 abstract contract EIP712 {
1165     /* solhint-disable var-name-mixedcase */
1166     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1167     // invalidate the cached domain separator if the chain id changes.
1168     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1169     uint256 private immutable _CACHED_CHAIN_ID;
1170 
1171     bytes32 private immutable _HASHED_NAME;
1172     bytes32 private immutable _HASHED_VERSION;
1173     bytes32 private immutable _TYPE_HASH;
1174 
1175     /* solhint-enable var-name-mixedcase */
1176 
1177     /**
1178      * @dev Initializes the domain separator and parameter caches.
1179      *
1180      * The meaning of `name` and `version` is specified in
1181      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1182      *
1183      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1184      * - `version`: the current major version of the signing domain.
1185      *
1186      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1187      * contract upgrade].
1188      */
1189     constructor(string memory name, string memory version) {
1190         bytes32 hashedName = keccak256(bytes(name));
1191         bytes32 hashedVersion = keccak256(bytes(version));
1192         bytes32 typeHash = keccak256(
1193             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1194         );
1195         _HASHED_NAME = hashedName;
1196         _HASHED_VERSION = hashedVersion;
1197         _CACHED_CHAIN_ID = block.chainid;
1198         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1199         _TYPE_HASH = typeHash;
1200     }
1201 
1202     /**
1203      * @dev Returns the domain separator for the current chain.
1204      */
1205     function _domainSeparatorV4() internal view returns (bytes32) {
1206         if (block.chainid == _CACHED_CHAIN_ID) {
1207             return _CACHED_DOMAIN_SEPARATOR;
1208         } else {
1209             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1210         }
1211     }
1212 
1213     function _buildDomainSeparator(
1214         bytes32 typeHash,
1215         bytes32 nameHash,
1216         bytes32 versionHash
1217     ) private view returns (bytes32) {
1218         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1219     }
1220 
1221     /**
1222      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1223      * function returns the hash of the fully encoded EIP712 message for this domain.
1224      *
1225      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1226      *
1227      * ```solidity
1228      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1229      *     keccak256("Mail(address to,string contents)"),
1230      *     mailTo,
1231      *     keccak256(bytes(mailContents))
1232      * )));
1233      * address signer = ECDSA.recover(digest, signature);
1234      * ```
1235      */
1236     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1237         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1238     }
1239 }
1240 
1241 
1242 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 /**
1247  * @title Counters
1248  * @author Matt Condon (@shrugs)
1249  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1250  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1251  *
1252  * Include with `using Counters for Counters.Counter;`
1253  */
1254 library Counters {
1255     struct Counter {
1256         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1257         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1258         // this feature: see https://github.com/ethereum/solidity/issues/4637
1259         uint256 _value; // default: 0
1260     }
1261 
1262     function current(Counter storage counter) internal view returns (uint256) {
1263         return counter._value;
1264     }
1265 
1266     function increment(Counter storage counter) internal {
1267         unchecked {
1268             counter._value += 1;
1269         }
1270     }
1271 
1272     function decrement(Counter storage counter) internal {
1273         uint256 value = counter._value;
1274         require(value > 0, "Counter: decrement overflow");
1275         unchecked {
1276             counter._value = value - 1;
1277         }
1278     }
1279 
1280     function reset(Counter storage counter) internal {
1281         counter._value = 0;
1282     }
1283 }
1284 
1285 
1286 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.3.2
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 
1291 
1292 
1293 
1294 /**
1295  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1296  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1297  *
1298  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1299  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1300  * need to send a transaction, and thus is not required to hold Ether at all.
1301  *
1302  * _Available since v3.4._
1303  */
1304 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1305     using Counters for Counters.Counter;
1306 
1307     mapping(address => Counters.Counter) private _nonces;
1308 
1309     // solhint-disable-next-line var-name-mixedcase
1310     bytes32 private immutable _PERMIT_TYPEHASH =
1311         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1312 
1313     /**
1314      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1315      *
1316      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1317      */
1318     constructor(string memory name) EIP712(name, "1") {}
1319 
1320     /**
1321      * @dev See {IERC20Permit-permit}.
1322      */
1323     function permit(
1324         address owner,
1325         address spender,
1326         uint256 value,
1327         uint256 deadline,
1328         uint8 v,
1329         bytes32 r,
1330         bytes32 s
1331     ) public virtual override {
1332         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1333 
1334         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1335 
1336         bytes32 hash = _hashTypedDataV4(structHash);
1337 
1338         address signer = ECDSA.recover(hash, v, r, s);
1339         require(signer == owner, "ERC20Permit: invalid signature");
1340 
1341         _approve(owner, spender, value);
1342     }
1343 
1344     /**
1345      * @dev See {IERC20Permit-nonces}.
1346      */
1347     function nonces(address owner) public view virtual override returns (uint256) {
1348         return _nonces[owner].current();
1349     }
1350 
1351     /**
1352      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1353      */
1354     // solhint-disable-next-line func-name-mixedcase
1355     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1356         return _domainSeparatorV4();
1357     }
1358 
1359     /**
1360      * @dev "Consume a nonce": return the current value and increment.
1361      *
1362      * _Available since v4.1._
1363      */
1364     function _useNonce(address owner) internal virtual returns (uint256 current) {
1365         Counters.Counter storage nonce = _nonces[owner];
1366         current = nonce.current();
1367         nonce.increment();
1368     }
1369 }
1370 
1371 
1372 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.3.2
1373 
1374 pragma solidity ^0.8.0;
1375 
1376 /**
1377  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1378  * checks.
1379  *
1380  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1381  * easily result in undesired exploitation or bugs, since developers usually
1382  * assume that overflows raise errors. `SafeCast` restores this intuition by
1383  * reverting the transaction when such an operation overflows.
1384  *
1385  * Using this library instead of the unchecked operations eliminates an entire
1386  * class of bugs, so it's recommended to use it always.
1387  *
1388  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1389  * all math on `uint256` and `int256` and then downcasting.
1390  */
1391 library SafeCast {
1392     /**
1393      * @dev Returns the downcasted uint224 from uint256, reverting on
1394      * overflow (when the input is greater than largest uint224).
1395      *
1396      * Counterpart to Solidity's `uint224` operator.
1397      *
1398      * Requirements:
1399      *
1400      * - input must fit into 224 bits
1401      */
1402     function toUint224(uint256 value) internal pure returns (uint224) {
1403         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1404         return uint224(value);
1405     }
1406 
1407     /**
1408      * @dev Returns the downcasted uint128 from uint256, reverting on
1409      * overflow (when the input is greater than largest uint128).
1410      *
1411      * Counterpart to Solidity's `uint128` operator.
1412      *
1413      * Requirements:
1414      *
1415      * - input must fit into 128 bits
1416      */
1417     function toUint128(uint256 value) internal pure returns (uint128) {
1418         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1419         return uint128(value);
1420     }
1421 
1422     /**
1423      * @dev Returns the downcasted uint96 from uint256, reverting on
1424      * overflow (when the input is greater than largest uint96).
1425      *
1426      * Counterpart to Solidity's `uint96` operator.
1427      *
1428      * Requirements:
1429      *
1430      * - input must fit into 96 bits
1431      */
1432     function toUint96(uint256 value) internal pure returns (uint96) {
1433         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1434         return uint96(value);
1435     }
1436 
1437     /**
1438      * @dev Returns the downcasted uint64 from uint256, reverting on
1439      * overflow (when the input is greater than largest uint64).
1440      *
1441      * Counterpart to Solidity's `uint64` operator.
1442      *
1443      * Requirements:
1444      *
1445      * - input must fit into 64 bits
1446      */
1447     function toUint64(uint256 value) internal pure returns (uint64) {
1448         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1449         return uint64(value);
1450     }
1451 
1452     /**
1453      * @dev Returns the downcasted uint32 from uint256, reverting on
1454      * overflow (when the input is greater than largest uint32).
1455      *
1456      * Counterpart to Solidity's `uint32` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - input must fit into 32 bits
1461      */
1462     function toUint32(uint256 value) internal pure returns (uint32) {
1463         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1464         return uint32(value);
1465     }
1466 
1467     /**
1468      * @dev Returns the downcasted uint16 from uint256, reverting on
1469      * overflow (when the input is greater than largest uint16).
1470      *
1471      * Counterpart to Solidity's `uint16` operator.
1472      *
1473      * Requirements:
1474      *
1475      * - input must fit into 16 bits
1476      */
1477     function toUint16(uint256 value) internal pure returns (uint16) {
1478         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1479         return uint16(value);
1480     }
1481 
1482     /**
1483      * @dev Returns the downcasted uint8 from uint256, reverting on
1484      * overflow (when the input is greater than largest uint8).
1485      *
1486      * Counterpart to Solidity's `uint8` operator.
1487      *
1488      * Requirements:
1489      *
1490      * - input must fit into 8 bits.
1491      */
1492     function toUint8(uint256 value) internal pure returns (uint8) {
1493         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1494         return uint8(value);
1495     }
1496 
1497     /**
1498      * @dev Converts a signed int256 into an unsigned uint256.
1499      *
1500      * Requirements:
1501      *
1502      * - input must be greater than or equal to 0.
1503      */
1504     function toUint256(int256 value) internal pure returns (uint256) {
1505         require(value >= 0, "SafeCast: value must be positive");
1506         return uint256(value);
1507     }
1508 
1509     /**
1510      * @dev Returns the downcasted int128 from int256, reverting on
1511      * overflow (when the input is less than smallest int128 or
1512      * greater than largest int128).
1513      *
1514      * Counterpart to Solidity's `int128` operator.
1515      *
1516      * Requirements:
1517      *
1518      * - input must fit into 128 bits
1519      *
1520      * _Available since v3.1._
1521      */
1522     function toInt128(int256 value) internal pure returns (int128) {
1523         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1524         return int128(value);
1525     }
1526 
1527     /**
1528      * @dev Returns the downcasted int64 from int256, reverting on
1529      * overflow (when the input is less than smallest int64 or
1530      * greater than largest int64).
1531      *
1532      * Counterpart to Solidity's `int64` operator.
1533      *
1534      * Requirements:
1535      *
1536      * - input must fit into 64 bits
1537      *
1538      * _Available since v3.1._
1539      */
1540     function toInt64(int256 value) internal pure returns (int64) {
1541         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1542         return int64(value);
1543     }
1544 
1545     /**
1546      * @dev Returns the downcasted int32 from int256, reverting on
1547      * overflow (when the input is less than smallest int32 or
1548      * greater than largest int32).
1549      *
1550      * Counterpart to Solidity's `int32` operator.
1551      *
1552      * Requirements:
1553      *
1554      * - input must fit into 32 bits
1555      *
1556      * _Available since v3.1._
1557      */
1558     function toInt32(int256 value) internal pure returns (int32) {
1559         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1560         return int32(value);
1561     }
1562 
1563     /**
1564      * @dev Returns the downcasted int16 from int256, reverting on
1565      * overflow (when the input is less than smallest int16 or
1566      * greater than largest int16).
1567      *
1568      * Counterpart to Solidity's `int16` operator.
1569      *
1570      * Requirements:
1571      *
1572      * - input must fit into 16 bits
1573      *
1574      * _Available since v3.1._
1575      */
1576     function toInt16(int256 value) internal pure returns (int16) {
1577         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1578         return int16(value);
1579     }
1580 
1581     /**
1582      * @dev Returns the downcasted int8 from int256, reverting on
1583      * overflow (when the input is less than smallest int8 or
1584      * greater than largest int8).
1585      *
1586      * Counterpart to Solidity's `int8` operator.
1587      *
1588      * Requirements:
1589      *
1590      * - input must fit into 8 bits.
1591      *
1592      * _Available since v3.1._
1593      */
1594     function toInt8(int256 value) internal pure returns (int8) {
1595         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1596         return int8(value);
1597     }
1598 
1599     /**
1600      * @dev Converts an unsigned uint256 into a signed int256.
1601      *
1602      * Requirements:
1603      *
1604      * - input must be less than or equal to maxInt256.
1605      */
1606     function toInt256(uint256 value) internal pure returns (int256) {
1607         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1608         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1609         return int256(value);
1610     }
1611 }
1612 
1613 
1614 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol@v4.3.2
1615 
1616 pragma solidity ^0.8.0;
1617 
1618 
1619 
1620 
1621 /**
1622  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1623  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1624  *
1625  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1626  *
1627  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1628  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1629  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1630  *
1631  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1632  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1633  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1634  * will significantly increase the base gas cost of transfers.
1635  *
1636  * _Available since v4.2._
1637  */
1638 abstract contract ERC20Votes is ERC20Permit {
1639     struct Checkpoint {
1640         uint32 fromBlock;
1641         uint224 votes;
1642     }
1643 
1644     bytes32 private constant _DELEGATION_TYPEHASH =
1645         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1646 
1647     mapping(address => address) private _delegates;
1648     mapping(address => Checkpoint[]) private _checkpoints;
1649     Checkpoint[] private _totalSupplyCheckpoints;
1650 
1651     /**
1652      * @dev Emitted when an account changes their delegate.
1653      */
1654     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1655 
1656     /**
1657      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1658      */
1659     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1660 
1661     /**
1662      * @dev Get the `pos`-th checkpoint for `account`.
1663      */
1664     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1665         return _checkpoints[account][pos];
1666     }
1667 
1668     /**
1669      * @dev Get number of checkpoints for `account`.
1670      */
1671     function numCheckpoints(address account) public view virtual returns (uint32) {
1672         return SafeCast.toUint32(_checkpoints[account].length);
1673     }
1674 
1675     /**
1676      * @dev Get the address `account` is currently delegating to.
1677      */
1678     function delegates(address account) public view virtual returns (address) {
1679         return _delegates[account];
1680     }
1681 
1682     /**
1683      * @dev Gets the current votes balance for `account`
1684      */
1685     function getVotes(address account) public view returns (uint256) {
1686         uint256 pos = _checkpoints[account].length;
1687         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1688     }
1689 
1690     /**
1691      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1692      *
1693      * Requirements:
1694      *
1695      * - `blockNumber` must have been already mined
1696      */
1697     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1698         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1699         return _checkpointsLookup(_checkpoints[account], blockNumber);
1700     }
1701 
1702     /**
1703      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1704      * It is but NOT the sum of all the delegated votes!
1705      *
1706      * Requirements:
1707      *
1708      * - `blockNumber` must have been already mined
1709      */
1710     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1711         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1712         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1713     }
1714 
1715     /**
1716      * @dev Lookup a value in a list of (sorted) checkpoints.
1717      */
1718     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1719         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1720         //
1721         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1722         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1723         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1724         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1725         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1726         // out of bounds (in which case we're looking too far in the past and the result is 0).
1727         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1728         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1729         // the same.
1730         uint256 high = ckpts.length;
1731         uint256 low = 0;
1732         while (low < high) {
1733             uint256 mid = Math.average(low, high);
1734             if (ckpts[mid].fromBlock > blockNumber) {
1735                 high = mid;
1736             } else {
1737                 low = mid + 1;
1738             }
1739         }
1740 
1741         return high == 0 ? 0 : ckpts[high - 1].votes;
1742     }
1743 
1744     /**
1745      * @dev Delegate votes from the sender to `delegatee`.
1746      */
1747     function delegate(address delegatee) public virtual {
1748         return _delegate(_msgSender(), delegatee);
1749     }
1750 
1751     /**
1752      * @dev Delegates votes from signer to `delegatee`
1753      */
1754     function delegateBySig(
1755         address delegatee,
1756         uint256 nonce,
1757         uint256 expiry,
1758         uint8 v,
1759         bytes32 r,
1760         bytes32 s
1761     ) public virtual {
1762         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1763         address signer = ECDSA.recover(
1764             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1765             v,
1766             r,
1767             s
1768         );
1769         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1770         return _delegate(signer, delegatee);
1771     }
1772 
1773     /**
1774      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1775      */
1776     function _maxSupply() internal view virtual returns (uint224) {
1777         return type(uint224).max;
1778     }
1779 
1780     /**
1781      * @dev Snapshots the totalSupply after it has been increased.
1782      */
1783     function _mint(address account, uint256 amount) internal virtual override {
1784         super._mint(account, amount);
1785         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1786 
1787         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1788     }
1789 
1790     /**
1791      * @dev Snapshots the totalSupply after it has been decreased.
1792      */
1793     function _burn(address account, uint256 amount) internal virtual override {
1794         super._burn(account, amount);
1795 
1796         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1797     }
1798 
1799     /**
1800      * @dev Move voting power when tokens are transferred.
1801      *
1802      * Emits a {DelegateVotesChanged} event.
1803      */
1804     function _afterTokenTransfer(
1805         address from,
1806         address to,
1807         uint256 amount
1808     ) internal virtual override {
1809         super._afterTokenTransfer(from, to, amount);
1810 
1811         _moveVotingPower(delegates(from), delegates(to), amount);
1812     }
1813 
1814     /**
1815      * @dev Change delegation for `delegator` to `delegatee`.
1816      *
1817      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1818      */
1819     function _delegate(address delegator, address delegatee) internal virtual {
1820         address currentDelegate = delegates(delegator);
1821         uint256 delegatorBalance = balanceOf(delegator);
1822         _delegates[delegator] = delegatee;
1823 
1824         emit DelegateChanged(delegator, currentDelegate, delegatee);
1825 
1826         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1827     }
1828 
1829     function _moveVotingPower(
1830         address src,
1831         address dst,
1832         uint256 amount
1833     ) private {
1834         if (src != dst && amount > 0) {
1835             if (src != address(0)) {
1836                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1837                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1838             }
1839 
1840             if (dst != address(0)) {
1841                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1842                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1843             }
1844         }
1845     }
1846 
1847     function _writeCheckpoint(
1848         Checkpoint[] storage ckpts,
1849         function(uint256, uint256) view returns (uint256) op,
1850         uint256 delta
1851     ) private returns (uint256 oldWeight, uint256 newWeight) {
1852         uint256 pos = ckpts.length;
1853         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1854         newWeight = op(oldWeight, delta);
1855 
1856         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1857             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1858         } else {
1859             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1860         }
1861     }
1862 
1863     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1864         return a + b;
1865     }
1866 
1867     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1868         return a - b;
1869     }
1870 }
1871 
1872 
1873 // File contracts/interfaces/IBasePool.sol
1874 
1875 pragma solidity 0.8.7;
1876 interface IBasePool {
1877     function distributeRewards(uint256 _amount) external;
1878 }
1879 
1880 
1881 // File contracts/interfaces/ITimeLockPool.sol
1882 
1883 pragma solidity 0.8.7;
1884 interface ITimeLockPool {
1885     function deposit(uint256 _amount, uint256 _duration, address _receiver) external;
1886 }
1887 
1888 
1889 // File contracts/interfaces/IAbstractRewards.sol
1890 
1891 pragma solidity 0.8.7;
1892 
1893 interface IAbstractRewards {
1894 	/**
1895 	 * @dev Returns the total amount of rewards a given address is able to withdraw.
1896 	 * @param account Address of a reward recipient
1897 	 * @return A uint256 representing the rewards `account` can withdraw
1898 	 */
1899 	function withdrawableRewardsOf(address account) external view returns (uint256);
1900 
1901   /**
1902 	 * @dev View the amount of funds that an address has withdrawn.
1903 	 * @param account The address of a token holder.
1904 	 * @return The amount of funds that `account` has withdrawn.
1905 	 */
1906 	function withdrawnRewardsOf(address account) external view returns (uint256);
1907 
1908 	/**
1909 	 * @dev View the amount of funds that an address has earned in total.
1910 	 * accumulativeFundsOf(account) = withdrawableRewardsOf(account) + withdrawnRewardsOf(account)
1911 	 * = (pointsPerShare * balanceOf(account) + pointsCorrection[account]) / POINTS_MULTIPLIER
1912 	 * @param account The address of a token holder.
1913 	 * @return The amount of funds that `account` has earned in total.
1914 	 */
1915 	function cumulativeRewardsOf(address account) external view returns (uint256);
1916 
1917 	/**
1918 	 * @dev This event emits when new funds are distributed
1919 	 * @param by the address of the sender who distributed funds
1920 	 * @param rewardsDistributed the amount of funds received for distribution
1921 	 */
1922 	event RewardsDistributed(address indexed by, uint256 rewardsDistributed);
1923 
1924 	/**
1925 	 * @dev This event emits when distributed funds are withdrawn by a token holder.
1926 	 * @param by the address of the receiver of funds
1927 	 * @param fundsWithdrawn the amount of funds that were withdrawn
1928 	 */
1929 	event RewardsWithdrawn(address indexed by, uint256 fundsWithdrawn);
1930 }
1931 
1932 
1933 // File contracts/base/AbstractRewards.sol
1934 
1935 pragma solidity 0.8.7;
1936 
1937 
1938 /**
1939  * @dev Based on: https://github.com/indexed-finance/dividends/blob/master/contracts/base/AbstractDividends.sol
1940  * Renamed dividends to rewards.
1941  * @dev (OLD) Many functions in this contract were taken from this repository:
1942  * https://github.com/atpar/funds-distribution-token/blob/master/contracts/FundsDistributionToken.sol
1943  * which is an example implementation of ERC 2222, the draft for which can be found at
1944  * https://github.com/atpar/funds-distribution-token/blob/master/EIP-DRAFT.md
1945  *
1946  * This contract has been substantially modified from the original and does not comply with ERC 2222.
1947  * Many functions were renamed as "rewards" rather than "funds" and the core functionality was separated
1948  * into this abstract contract which can be inherited by anything tracking ownership of reward shares.
1949  */
1950 abstract contract AbstractRewards is IAbstractRewards {
1951   using SafeCast for uint128;
1952   using SafeCast for uint256;
1953   using SafeCast for int256;
1954 
1955 /* ========  Constants  ======== */
1956   uint128 public constant POINTS_MULTIPLIER = type(uint128).max;
1957 
1958 /* ========  Internal Function References  ======== */
1959   function(address) view returns (uint256) private immutable getSharesOf;
1960   function() view returns (uint256) private immutable getTotalShares;
1961 
1962 /* ========  Storage  ======== */
1963   uint256 public pointsPerShare;
1964   mapping(address => int256) public pointsCorrection;
1965   mapping(address => uint256) public withdrawnRewards;
1966 
1967   constructor(
1968     function(address) view returns (uint256) getSharesOf_,
1969     function() view returns (uint256) getTotalShares_
1970   ) {
1971     getSharesOf = getSharesOf_;
1972     getTotalShares = getTotalShares_;
1973   }
1974 
1975 /* ========  Public View Functions  ======== */
1976   /**
1977    * @dev Returns the total amount of rewards a given address is able to withdraw.
1978    * @param _account Address of a reward recipient
1979    * @return A uint256 representing the rewards `account` can withdraw
1980    */
1981   function withdrawableRewardsOf(address _account) public view override returns (uint256) {
1982     return cumulativeRewardsOf(_account) - withdrawnRewards[_account];
1983   }
1984 
1985   /**
1986    * @notice View the amount of rewards that an address has withdrawn.
1987    * @param _account The address of a token holder.
1988    * @return The amount of rewards that `account` has withdrawn.
1989    */
1990   function withdrawnRewardsOf(address _account) public view override returns (uint256) {
1991     return withdrawnRewards[_account];
1992   }
1993 
1994   /**
1995    * @notice View the amount of rewards that an address has earned in total.
1996    * @dev accumulativeFundsOf(account) = withdrawableRewardsOf(account) + withdrawnRewardsOf(account)
1997    * = (pointsPerShare * balanceOf(account) + pointsCorrection[account]) / POINTS_MULTIPLIER
1998    * @param _account The address of a token holder.
1999    * @return The amount of rewards that `account` has earned in total.
2000    */
2001   function cumulativeRewardsOf(address _account) public view override returns (uint256) {
2002     return ((pointsPerShare * getSharesOf(_account)).toInt256() + pointsCorrection[_account]).toUint256() / POINTS_MULTIPLIER;
2003   }
2004 
2005 /* ========  Dividend Utility Functions  ======== */
2006 
2007   /** 
2008    * @notice Distributes rewards to token holders.
2009    * @dev It reverts if the total shares is 0.
2010    * It emits the `RewardsDistributed` event if the amount to distribute is greater than 0.
2011    * About undistributed rewards:
2012    *   In each distribution, there is a small amount which does not get distributed,
2013    *   which is `(amount * POINTS_MULTIPLIER) % totalShares()`.
2014    *   With a well-chosen `POINTS_MULTIPLIER`, the amount of funds that are not getting
2015    *   distributed in a distribution can be less than 1 (base unit).
2016    */
2017   function _distributeRewards(uint256 _amount) internal {
2018     uint256 shares = getTotalShares();
2019     require(shares > 0, "AbstractRewards._distributeRewards: total share supply is zero");
2020 
2021     if (_amount > 0) {
2022       pointsPerShare = pointsPerShare + (_amount * POINTS_MULTIPLIER / shares);
2023       emit RewardsDistributed(msg.sender, _amount);
2024     }
2025   }
2026 
2027   /**
2028    * @notice Prepares collection of owed rewards
2029    * @dev It emits a `RewardsWithdrawn` event if the amount of withdrawn rewards is
2030    * greater than 0.
2031    */
2032   function _prepareCollect(address _account) internal returns (uint256) {
2033     uint256 _withdrawableDividend = withdrawableRewardsOf(_account);
2034     if (_withdrawableDividend > 0) {
2035       withdrawnRewards[_account] = withdrawnRewards[_account] + _withdrawableDividend;
2036       emit RewardsWithdrawn(_account, _withdrawableDividend);
2037     }
2038     return _withdrawableDividend;
2039   }
2040 
2041   function _correctPointsForTransfer(address _from, address _to, uint256 _shares) internal {
2042     int256 _magCorrection = (pointsPerShare * _shares).toInt256();
2043     pointsCorrection[_from] = pointsCorrection[_from] + _magCorrection;
2044     pointsCorrection[_to] = pointsCorrection[_to] - _magCorrection;
2045   }
2046 
2047   /**
2048    * @dev Increases or decreases the points correction for `account` by
2049    * `shares*pointsPerShare`.
2050    */
2051   function _correctPoints(address _account, int256 _shares) internal {
2052     pointsCorrection[_account] = pointsCorrection[_account] + (_shares * (int256(pointsPerShare)));
2053   }
2054 }
2055 
2056 
2057 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.2
2058 
2059 pragma solidity ^0.8.0;
2060 
2061 /**
2062  * @dev External interface of AccessControl declared to support ERC165 detection.
2063  */
2064 interface IAccessControl {
2065     /**
2066      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2067      *
2068      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2069      * {RoleAdminChanged} not being emitted signaling this.
2070      *
2071      * _Available since v3.1._
2072      */
2073     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2074 
2075     /**
2076      * @dev Emitted when `account` is granted `role`.
2077      *
2078      * `sender` is the account that originated the contract call, an admin role
2079      * bearer except when using {AccessControl-_setupRole}.
2080      */
2081     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2082 
2083     /**
2084      * @dev Emitted when `account` is revoked `role`.
2085      *
2086      * `sender` is the account that originated the contract call:
2087      *   - if using `revokeRole`, it is the admin role bearer
2088      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2089      */
2090     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2091 
2092     /**
2093      * @dev Returns `true` if `account` has been granted `role`.
2094      */
2095     function hasRole(bytes32 role, address account) external view returns (bool);
2096 
2097     /**
2098      * @dev Returns the admin role that controls `role`. See {grantRole} and
2099      * {revokeRole}.
2100      *
2101      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2102      */
2103     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2104 
2105     /**
2106      * @dev Grants `role` to `account`.
2107      *
2108      * If `account` had not been already granted `role`, emits a {RoleGranted}
2109      * event.
2110      *
2111      * Requirements:
2112      *
2113      * - the caller must have ``role``'s admin role.
2114      */
2115     function grantRole(bytes32 role, address account) external;
2116 
2117     /**
2118      * @dev Revokes `role` from `account`.
2119      *
2120      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2121      *
2122      * Requirements:
2123      *
2124      * - the caller must have ``role``'s admin role.
2125      */
2126     function revokeRole(bytes32 role, address account) external;
2127 
2128     /**
2129      * @dev Revokes `role` from the calling account.
2130      *
2131      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2132      * purpose is to provide a mechanism for accounts to lose their privileges
2133      * if they are compromised (such as when a trusted device is misplaced).
2134      *
2135      * If the calling account had been granted `role`, emits a {RoleRevoked}
2136      * event.
2137      *
2138      * Requirements:
2139      *
2140      * - the caller must be `account`.
2141      */
2142     function renounceRole(bytes32 role, address account) external;
2143 }
2144 
2145 
2146 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.3.2
2147 
2148 pragma solidity ^0.8.0;
2149 
2150 /**
2151  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
2152  */
2153 interface IAccessControlEnumerable is IAccessControl {
2154     /**
2155      * @dev Returns one of the accounts that have `role`. `index` must be a
2156      * value between 0 and {getRoleMemberCount}, non-inclusive.
2157      *
2158      * Role bearers are not sorted in any particular way, and their ordering may
2159      * change at any point.
2160      *
2161      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2162      * you perform all queries on the same block. See the following
2163      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2164      * for more information.
2165      */
2166     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
2167 
2168     /**
2169      * @dev Returns the number of accounts that have `role`. Can be used
2170      * together with {getRoleMember} to enumerate all bearers of a role.
2171      */
2172     function getRoleMemberCount(bytes32 role) external view returns (uint256);
2173 }
2174 
2175 
2176 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
2177 
2178 pragma solidity ^0.8.0;
2179 
2180 /**
2181  * @dev String operations.
2182  */
2183 library Strings {
2184     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2185 
2186     /**
2187      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2188      */
2189     function toString(uint256 value) internal pure returns (string memory) {
2190         // Inspired by OraclizeAPI's implementation - MIT licence
2191         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2192 
2193         if (value == 0) {
2194             return "0";
2195         }
2196         uint256 temp = value;
2197         uint256 digits;
2198         while (temp != 0) {
2199             digits++;
2200             temp /= 10;
2201         }
2202         bytes memory buffer = new bytes(digits);
2203         while (value != 0) {
2204             digits -= 1;
2205             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2206             value /= 10;
2207         }
2208         return string(buffer);
2209     }
2210 
2211     /**
2212      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2213      */
2214     function toHexString(uint256 value) internal pure returns (string memory) {
2215         if (value == 0) {
2216             return "0x00";
2217         }
2218         uint256 temp = value;
2219         uint256 length = 0;
2220         while (temp != 0) {
2221             length++;
2222             temp >>= 8;
2223         }
2224         return toHexString(value, length);
2225     }
2226 
2227     /**
2228      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2229      */
2230     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2231         bytes memory buffer = new bytes(2 * length + 2);
2232         buffer[0] = "0";
2233         buffer[1] = "x";
2234         for (uint256 i = 2 * length + 1; i > 1; --i) {
2235             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2236             value >>= 4;
2237         }
2238         require(value == 0, "Strings: hex length insufficient");
2239         return string(buffer);
2240     }
2241 }
2242 
2243 
2244 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
2245 
2246 pragma solidity ^0.8.0;
2247 
2248 /**
2249  * @dev Interface of the ERC165 standard, as defined in the
2250  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2251  *
2252  * Implementers can declare support of contract interfaces, which can then be
2253  * queried by others ({ERC165Checker}).
2254  *
2255  * For an implementation, see {ERC165}.
2256  */
2257 interface IERC165 {
2258     /**
2259      * @dev Returns true if this contract implements the interface defined by
2260      * `interfaceId`. See the corresponding
2261      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2262      * to learn more about how these ids are created.
2263      *
2264      * This function call must use less than 30 000 gas.
2265      */
2266     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2267 }
2268 
2269 
2270 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
2271 
2272 pragma solidity ^0.8.0;
2273 
2274 /**
2275  * @dev Implementation of the {IERC165} interface.
2276  *
2277  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2278  * for the additional interface id that will be supported. For example:
2279  *
2280  * ```solidity
2281  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2282  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2283  * }
2284  * ```
2285  *
2286  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2287  */
2288 abstract contract ERC165 is IERC165 {
2289     /**
2290      * @dev See {IERC165-supportsInterface}.
2291      */
2292     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2293         return interfaceId == type(IERC165).interfaceId;
2294     }
2295 }
2296 
2297 
2298 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.2
2299 
2300 pragma solidity ^0.8.0;
2301 
2302 
2303 
2304 
2305 /**
2306  * @dev Contract module that allows children to implement role-based access
2307  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2308  * members except through off-chain means by accessing the contract event logs. Some
2309  * applications may benefit from on-chain enumerability, for those cases see
2310  * {AccessControlEnumerable}.
2311  *
2312  * Roles are referred to by their `bytes32` identifier. These should be exposed
2313  * in the external API and be unique. The best way to achieve this is by
2314  * using `public constant` hash digests:
2315  *
2316  * ```
2317  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2318  * ```
2319  *
2320  * Roles can be used to represent a set of permissions. To restrict access to a
2321  * function call, use {hasRole}:
2322  *
2323  * ```
2324  * function foo() public {
2325  *     require(hasRole(MY_ROLE, msg.sender));
2326  *     ...
2327  * }
2328  * ```
2329  *
2330  * Roles can be granted and revoked dynamically via the {grantRole} and
2331  * {revokeRole} functions. Each role has an associated admin role, and only
2332  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2333  *
2334  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2335  * that only accounts with this role will be able to grant or revoke other
2336  * roles. More complex role relationships can be created by using
2337  * {_setRoleAdmin}.
2338  *
2339  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2340  * grant and revoke this role. Extra precautions should be taken to secure
2341  * accounts that have been granted it.
2342  */
2343 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2344     struct RoleData {
2345         mapping(address => bool) members;
2346         bytes32 adminRole;
2347     }
2348 
2349     mapping(bytes32 => RoleData) private _roles;
2350 
2351     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2352 
2353     /**
2354      * @dev Modifier that checks that an account has a specific role. Reverts
2355      * with a standardized message including the required role.
2356      *
2357      * The format of the revert reason is given by the following regular expression:
2358      *
2359      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2360      *
2361      * _Available since v4.1._
2362      */
2363     modifier onlyRole(bytes32 role) {
2364         _checkRole(role, _msgSender());
2365         _;
2366     }
2367 
2368     /**
2369      * @dev See {IERC165-supportsInterface}.
2370      */
2371     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2372         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2373     }
2374 
2375     /**
2376      * @dev Returns `true` if `account` has been granted `role`.
2377      */
2378     function hasRole(bytes32 role, address account) public view override returns (bool) {
2379         return _roles[role].members[account];
2380     }
2381 
2382     /**
2383      * @dev Revert with a standard message if `account` is missing `role`.
2384      *
2385      * The format of the revert reason is given by the following regular expression:
2386      *
2387      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2388      */
2389     function _checkRole(bytes32 role, address account) internal view {
2390         if (!hasRole(role, account)) {
2391             revert(
2392                 string(
2393                     abi.encodePacked(
2394                         "AccessControl: account ",
2395                         Strings.toHexString(uint160(account), 20),
2396                         " is missing role ",
2397                         Strings.toHexString(uint256(role), 32)
2398                     )
2399                 )
2400             );
2401         }
2402     }
2403 
2404     /**
2405      * @dev Returns the admin role that controls `role`. See {grantRole} and
2406      * {revokeRole}.
2407      *
2408      * To change a role's admin, use {_setRoleAdmin}.
2409      */
2410     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
2411         return _roles[role].adminRole;
2412     }
2413 
2414     /**
2415      * @dev Grants `role` to `account`.
2416      *
2417      * If `account` had not been already granted `role`, emits a {RoleGranted}
2418      * event.
2419      *
2420      * Requirements:
2421      *
2422      * - the caller must have ``role``'s admin role.
2423      */
2424     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2425         _grantRole(role, account);
2426     }
2427 
2428     /**
2429      * @dev Revokes `role` from `account`.
2430      *
2431      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2432      *
2433      * Requirements:
2434      *
2435      * - the caller must have ``role``'s admin role.
2436      */
2437     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2438         _revokeRole(role, account);
2439     }
2440 
2441     /**
2442      * @dev Revokes `role` from the calling account.
2443      *
2444      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2445      * purpose is to provide a mechanism for accounts to lose their privileges
2446      * if they are compromised (such as when a trusted device is misplaced).
2447      *
2448      * If the calling account had been granted `role`, emits a {RoleRevoked}
2449      * event.
2450      *
2451      * Requirements:
2452      *
2453      * - the caller must be `account`.
2454      */
2455     function renounceRole(bytes32 role, address account) public virtual override {
2456         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2457 
2458         _revokeRole(role, account);
2459     }
2460 
2461     /**
2462      * @dev Grants `role` to `account`.
2463      *
2464      * If `account` had not been already granted `role`, emits a {RoleGranted}
2465      * event. Note that unlike {grantRole}, this function doesn't perform any
2466      * checks on the calling account.
2467      *
2468      * [WARNING]
2469      * ====
2470      * This function should only be called from the constructor when setting
2471      * up the initial roles for the system.
2472      *
2473      * Using this function in any other way is effectively circumventing the admin
2474      * system imposed by {AccessControl}.
2475      * ====
2476      */
2477     function _setupRole(bytes32 role, address account) internal virtual {
2478         _grantRole(role, account);
2479     }
2480 
2481     /**
2482      * @dev Sets `adminRole` as ``role``'s admin role.
2483      *
2484      * Emits a {RoleAdminChanged} event.
2485      */
2486     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2487         bytes32 previousAdminRole = getRoleAdmin(role);
2488         _roles[role].adminRole = adminRole;
2489         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2490     }
2491 
2492     function _grantRole(bytes32 role, address account) private {
2493         if (!hasRole(role, account)) {
2494             _roles[role].members[account] = true;
2495             emit RoleGranted(role, account, _msgSender());
2496         }
2497     }
2498 
2499     function _revokeRole(bytes32 role, address account) private {
2500         if (hasRole(role, account)) {
2501             _roles[role].members[account] = false;
2502             emit RoleRevoked(role, account, _msgSender());
2503         }
2504     }
2505 }
2506 
2507 
2508 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.3.2
2509 
2510 pragma solidity ^0.8.0;
2511 
2512 /**
2513  * @dev Library for managing
2514  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2515  * types.
2516  *
2517  * Sets have the following properties:
2518  *
2519  * - Elements are added, removed, and checked for existence in constant time
2520  * (O(1)).
2521  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2522  *
2523  * ```
2524  * contract Example {
2525  *     // Add the library methods
2526  *     using EnumerableSet for EnumerableSet.AddressSet;
2527  *
2528  *     // Declare a set state variable
2529  *     EnumerableSet.AddressSet private mySet;
2530  * }
2531  * ```
2532  *
2533  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2534  * and `uint256` (`UintSet`) are supported.
2535  */
2536 library EnumerableSet {
2537     // To implement this library for multiple types with as little code
2538     // repetition as possible, we write it in terms of a generic Set type with
2539     // bytes32 values.
2540     // The Set implementation uses private functions, and user-facing
2541     // implementations (such as AddressSet) are just wrappers around the
2542     // underlying Set.
2543     // This means that we can only create new EnumerableSets for types that fit
2544     // in bytes32.
2545 
2546     struct Set {
2547         // Storage of set values
2548         bytes32[] _values;
2549         // Position of the value in the `values` array, plus 1 because index 0
2550         // means a value is not in the set.
2551         mapping(bytes32 => uint256) _indexes;
2552     }
2553 
2554     /**
2555      * @dev Add a value to a set. O(1).
2556      *
2557      * Returns true if the value was added to the set, that is if it was not
2558      * already present.
2559      */
2560     function _add(Set storage set, bytes32 value) private returns (bool) {
2561         if (!_contains(set, value)) {
2562             set._values.push(value);
2563             // The value is stored at length-1, but we add 1 to all indexes
2564             // and use 0 as a sentinel value
2565             set._indexes[value] = set._values.length;
2566             return true;
2567         } else {
2568             return false;
2569         }
2570     }
2571 
2572     /**
2573      * @dev Removes a value from a set. O(1).
2574      *
2575      * Returns true if the value was removed from the set, that is if it was
2576      * present.
2577      */
2578     function _remove(Set storage set, bytes32 value) private returns (bool) {
2579         // We read and store the value's index to prevent multiple reads from the same storage slot
2580         uint256 valueIndex = set._indexes[value];
2581 
2582         if (valueIndex != 0) {
2583             // Equivalent to contains(set, value)
2584             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2585             // the array, and then remove the last element (sometimes called as 'swap and pop').
2586             // This modifies the order of the array, as noted in {at}.
2587 
2588             uint256 toDeleteIndex = valueIndex - 1;
2589             uint256 lastIndex = set._values.length - 1;
2590 
2591             if (lastIndex != toDeleteIndex) {
2592                 bytes32 lastvalue = set._values[lastIndex];
2593 
2594                 // Move the last value to the index where the value to delete is
2595                 set._values[toDeleteIndex] = lastvalue;
2596                 // Update the index for the moved value
2597                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
2598             }
2599 
2600             // Delete the slot where the moved value was stored
2601             set._values.pop();
2602 
2603             // Delete the index for the deleted slot
2604             delete set._indexes[value];
2605 
2606             return true;
2607         } else {
2608             return false;
2609         }
2610     }
2611 
2612     /**
2613      * @dev Returns true if the value is in the set. O(1).
2614      */
2615     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2616         return set._indexes[value] != 0;
2617     }
2618 
2619     /**
2620      * @dev Returns the number of values on the set. O(1).
2621      */
2622     function _length(Set storage set) private view returns (uint256) {
2623         return set._values.length;
2624     }
2625 
2626     /**
2627      * @dev Returns the value stored at position `index` in the set. O(1).
2628      *
2629      * Note that there are no guarantees on the ordering of values inside the
2630      * array, and it may change when more values are added or removed.
2631      *
2632      * Requirements:
2633      *
2634      * - `index` must be strictly less than {length}.
2635      */
2636     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2637         return set._values[index];
2638     }
2639 
2640     /**
2641      * @dev Return the entire set in an array
2642      *
2643      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2644      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2645      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2646      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2647      */
2648     function _values(Set storage set) private view returns (bytes32[] memory) {
2649         return set._values;
2650     }
2651 
2652     // Bytes32Set
2653 
2654     struct Bytes32Set {
2655         Set _inner;
2656     }
2657 
2658     /**
2659      * @dev Add a value to a set. O(1).
2660      *
2661      * Returns true if the value was added to the set, that is if it was not
2662      * already present.
2663      */
2664     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2665         return _add(set._inner, value);
2666     }
2667 
2668     /**
2669      * @dev Removes a value from a set. O(1).
2670      *
2671      * Returns true if the value was removed from the set, that is if it was
2672      * present.
2673      */
2674     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2675         return _remove(set._inner, value);
2676     }
2677 
2678     /**
2679      * @dev Returns true if the value is in the set. O(1).
2680      */
2681     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2682         return _contains(set._inner, value);
2683     }
2684 
2685     /**
2686      * @dev Returns the number of values in the set. O(1).
2687      */
2688     function length(Bytes32Set storage set) internal view returns (uint256) {
2689         return _length(set._inner);
2690     }
2691 
2692     /**
2693      * @dev Returns the value stored at position `index` in the set. O(1).
2694      *
2695      * Note that there are no guarantees on the ordering of values inside the
2696      * array, and it may change when more values are added or removed.
2697      *
2698      * Requirements:
2699      *
2700      * - `index` must be strictly less than {length}.
2701      */
2702     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2703         return _at(set._inner, index);
2704     }
2705 
2706     /**
2707      * @dev Return the entire set in an array
2708      *
2709      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2710      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2711      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2712      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2713      */
2714     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2715         return _values(set._inner);
2716     }
2717 
2718     // AddressSet
2719 
2720     struct AddressSet {
2721         Set _inner;
2722     }
2723 
2724     /**
2725      * @dev Add a value to a set. O(1).
2726      *
2727      * Returns true if the value was added to the set, that is if it was not
2728      * already present.
2729      */
2730     function add(AddressSet storage set, address value) internal returns (bool) {
2731         return _add(set._inner, bytes32(uint256(uint160(value))));
2732     }
2733 
2734     /**
2735      * @dev Removes a value from a set. O(1).
2736      *
2737      * Returns true if the value was removed from the set, that is if it was
2738      * present.
2739      */
2740     function remove(AddressSet storage set, address value) internal returns (bool) {
2741         return _remove(set._inner, bytes32(uint256(uint160(value))));
2742     }
2743 
2744     /**
2745      * @dev Returns true if the value is in the set. O(1).
2746      */
2747     function contains(AddressSet storage set, address value) internal view returns (bool) {
2748         return _contains(set._inner, bytes32(uint256(uint160(value))));
2749     }
2750 
2751     /**
2752      * @dev Returns the number of values in the set. O(1).
2753      */
2754     function length(AddressSet storage set) internal view returns (uint256) {
2755         return _length(set._inner);
2756     }
2757 
2758     /**
2759      * @dev Returns the value stored at position `index` in the set. O(1).
2760      *
2761      * Note that there are no guarantees on the ordering of values inside the
2762      * array, and it may change when more values are added or removed.
2763      *
2764      * Requirements:
2765      *
2766      * - `index` must be strictly less than {length}.
2767      */
2768     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2769         return address(uint160(uint256(_at(set._inner, index))));
2770     }
2771 
2772     /**
2773      * @dev Return the entire set in an array
2774      *
2775      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2776      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2777      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2778      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2779      */
2780     function values(AddressSet storage set) internal view returns (address[] memory) {
2781         bytes32[] memory store = _values(set._inner);
2782         address[] memory result;
2783 
2784         assembly {
2785             result := store
2786         }
2787 
2788         return result;
2789     }
2790 
2791     // UintSet
2792 
2793     struct UintSet {
2794         Set _inner;
2795     }
2796 
2797     /**
2798      * @dev Add a value to a set. O(1).
2799      *
2800      * Returns true if the value was added to the set, that is if it was not
2801      * already present.
2802      */
2803     function add(UintSet storage set, uint256 value) internal returns (bool) {
2804         return _add(set._inner, bytes32(value));
2805     }
2806 
2807     /**
2808      * @dev Removes a value from a set. O(1).
2809      *
2810      * Returns true if the value was removed from the set, that is if it was
2811      * present.
2812      */
2813     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2814         return _remove(set._inner, bytes32(value));
2815     }
2816 
2817     /**
2818      * @dev Returns true if the value is in the set. O(1).
2819      */
2820     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2821         return _contains(set._inner, bytes32(value));
2822     }
2823 
2824     /**
2825      * @dev Returns the number of values on the set. O(1).
2826      */
2827     function length(UintSet storage set) internal view returns (uint256) {
2828         return _length(set._inner);
2829     }
2830 
2831     /**
2832      * @dev Returns the value stored at position `index` in the set. O(1).
2833      *
2834      * Note that there are no guarantees on the ordering of values inside the
2835      * array, and it may change when more values are added or removed.
2836      *
2837      * Requirements:
2838      *
2839      * - `index` must be strictly less than {length}.
2840      */
2841     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2842         return uint256(_at(set._inner, index));
2843     }
2844 
2845     /**
2846      * @dev Return the entire set in an array
2847      *
2848      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2849      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2850      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2851      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2852      */
2853     function values(UintSet storage set) internal view returns (uint256[] memory) {
2854         bytes32[] memory store = _values(set._inner);
2855         uint256[] memory result;
2856 
2857         assembly {
2858             result := store
2859         }
2860 
2861         return result;
2862     }
2863 }
2864 
2865 
2866 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.3.2
2867 
2868 pragma solidity ^0.8.0;
2869 
2870 
2871 
2872 /**
2873  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
2874  */
2875 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
2876     using EnumerableSet for EnumerableSet.AddressSet;
2877 
2878     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
2879 
2880     /**
2881      * @dev See {IERC165-supportsInterface}.
2882      */
2883     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2884         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
2885     }
2886 
2887     /**
2888      * @dev Returns one of the accounts that have `role`. `index` must be a
2889      * value between 0 and {getRoleMemberCount}, non-inclusive.
2890      *
2891      * Role bearers are not sorted in any particular way, and their ordering may
2892      * change at any point.
2893      *
2894      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2895      * you perform all queries on the same block. See the following
2896      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2897      * for more information.
2898      */
2899     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
2900         return _roleMembers[role].at(index);
2901     }
2902 
2903     /**
2904      * @dev Returns the number of accounts that have `role`. Can be used
2905      * together with {getRoleMember} to enumerate all bearers of a role.
2906      */
2907     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
2908         return _roleMembers[role].length();
2909     }
2910 
2911     /**
2912      * @dev Overload {grantRole} to track enumerable memberships
2913      */
2914     function grantRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
2915         super.grantRole(role, account);
2916         _roleMembers[role].add(account);
2917     }
2918 
2919     /**
2920      * @dev Overload {revokeRole} to track enumerable memberships
2921      */
2922     function revokeRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
2923         super.revokeRole(role, account);
2924         _roleMembers[role].remove(account);
2925     }
2926 
2927     /**
2928      * @dev Overload {renounceRole} to track enumerable memberships
2929      */
2930     function renounceRole(bytes32 role, address account) public virtual override(AccessControl, IAccessControl) {
2931         super.renounceRole(role, account);
2932         _roleMembers[role].remove(account);
2933     }
2934 
2935     /**
2936      * @dev Overload {_setupRole} to track enumerable memberships
2937      */
2938     function _setupRole(bytes32 role, address account) internal virtual override {
2939         super._setupRole(role, account);
2940         _roleMembers[role].add(account);
2941     }
2942 }
2943 
2944 
2945 // File contracts/base/TokenSaver.sol
2946 
2947 pragma solidity 0.8.7;
2948 
2949 
2950 
2951 contract TokenSaver is AccessControlEnumerable {
2952     using SafeERC20 for IERC20;
2953 
2954     bytes32 public constant TOKEN_SAVER_ROLE = keccak256("TOKEN_SAVER_ROLE");
2955 
2956     event TokenSaved(address indexed by, address indexed receiver, address indexed token, uint256 amount);
2957 
2958     modifier onlyTokenSaver() {
2959         require(hasRole(TOKEN_SAVER_ROLE, _msgSender()), "TokenSaver.onlyTokenSaver: permission denied");
2960         _;
2961     }
2962 
2963     constructor() {
2964         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2965     }
2966 
2967     function saveToken(address _token, address _receiver, uint256 _amount) external onlyTokenSaver {
2968         IERC20(_token).safeTransfer(_receiver, _amount);
2969         emit TokenSaved(_msgSender(), _receiver, _token, _amount);
2970     }
2971 
2972 }
2973 
2974 
2975 // File contracts/base/BasePool.sol
2976 
2977 pragma solidity 0.8.7;
2978 
2979 
2980 
2981 
2982 
2983 
2984 abstract contract BasePool is ERC20Votes, AbstractRewards, IBasePool, TokenSaver {
2985     using SafeERC20 for IERC20;
2986     using SafeCast for uint256;
2987     using SafeCast for int256;
2988 
2989     IERC20 public immutable depositToken;
2990     IERC20 public immutable rewardToken;
2991     ITimeLockPool public immutable escrowPool;
2992     uint256 public immutable escrowPortion; // how much is escrowed 1e18 == 100%
2993     uint256 public immutable escrowDuration; // escrow duration in seconds
2994 
2995     event RewardsClaimed(address indexed _from, address indexed _receiver, uint256 _escrowedAmount, uint256 _nonEscrowedAmount);
2996 
2997     constructor(
2998         string memory _name,
2999         string memory _symbol,
3000         address _depositToken,
3001         address _rewardToken,
3002         address _escrowPool,
3003         uint256 _escrowPortion,
3004         uint256 _escrowDuration
3005     ) ERC20Permit(_name) ERC20(_name, _symbol) AbstractRewards(balanceOf, totalSupply) {
3006         require(_escrowPortion <= 1e18, "BasePool.constructor: Cannot escrow more than 100%");
3007         require(_depositToken != address(0), "BasePool.constructor: Deposit token must be set");
3008         depositToken = IERC20(_depositToken);
3009         rewardToken = IERC20(_rewardToken);
3010         escrowPool = ITimeLockPool(_escrowPool);
3011         escrowPortion = _escrowPortion;
3012         escrowDuration = _escrowDuration;
3013 
3014         if(_rewardToken != address(0) && _escrowPool != address(0)) {
3015             IERC20(_rewardToken).safeApprove(_escrowPool, type(uint256).max);
3016         }
3017     }
3018 
3019     function _mint(address _account, uint256 _amount) internal virtual override {
3020 		super._mint(_account, _amount);
3021         _correctPoints(_account, -(_amount.toInt256()));
3022 	}
3023 	
3024 	function _burn(address _account, uint256 _amount) internal virtual override {
3025 		super._burn(_account, _amount);
3026         _correctPoints(_account, _amount.toInt256());
3027 	}
3028 
3029     function _transfer(address _from, address _to, uint256 _value) internal virtual override {
3030 		super._transfer(_from, _to, _value);
3031         _correctPointsForTransfer(_from, _to, _value);
3032 	}
3033 
3034     function distributeRewards(uint256 _amount) external override {
3035         rewardToken.safeTransferFrom(_msgSender(), address(this), _amount);
3036         _distributeRewards(_amount);
3037     }
3038 
3039     function claimRewards(address _receiver) external {
3040         uint256 rewardAmount = _prepareCollect(_msgSender());
3041         uint256 escrowedRewardAmount = rewardAmount * escrowPortion / 1e18;
3042         uint256 nonEscrowedRewardAmount = rewardAmount - escrowedRewardAmount;
3043 
3044         if(escrowedRewardAmount != 0 && address(escrowPool) != address(0)) {
3045             escrowPool.deposit(escrowedRewardAmount, escrowDuration, _receiver);
3046         }
3047 
3048         // ignore dust
3049         if(nonEscrowedRewardAmount > 1) {
3050             rewardToken.safeTransfer(_receiver, nonEscrowedRewardAmount);
3051         }
3052 
3053         emit RewardsClaimed(_msgSender(), _receiver, escrowedRewardAmount, nonEscrowedRewardAmount);
3054     }
3055 
3056 }
3057 
3058 
3059 // File contracts/TimeLockPool.sol
3060 
3061 pragma solidity 0.8.7;
3062 
3063 
3064 
3065 
3066 contract TimeLockPool is BasePool, ITimeLockPool {
3067     using Math for uint256;
3068     using SafeERC20 for IERC20;
3069 
3070     uint256 public immutable maxBonus;
3071     uint256 public immutable maxLockDuration;
3072     uint256 public constant MIN_LOCK_DURATION = 10 minutes;
3073     
3074     mapping(address => Deposit[]) public depositsOf;
3075 
3076     struct Deposit {
3077         uint256 amount;
3078         uint64 start;
3079         uint64 end;
3080     }
3081     constructor(
3082         string memory _name,
3083         string memory _symbol,
3084         address _depositToken,
3085         address _rewardToken,
3086         address _escrowPool,
3087         uint256 _escrowPortion,
3088         uint256 _escrowDuration,
3089         uint256 _maxBonus,
3090         uint256 _maxLockDuration
3091     ) BasePool(_name, _symbol, _depositToken, _rewardToken, _escrowPool, _escrowPortion, _escrowDuration) {
3092         require(_maxLockDuration >= MIN_LOCK_DURATION, "TimeLockPool.constructor: max lock duration must be greater or equal to mininmum lock duration");
3093         maxBonus = _maxBonus;
3094         maxLockDuration = _maxLockDuration;
3095     }
3096 
3097     event Deposited(uint256 amount, uint256 duration, address indexed receiver, address indexed from);
3098     event Withdrawn(uint256 indexed depositId, address indexed receiver, address indexed from, uint256 amount);
3099 
3100     function deposit(uint256 _amount, uint256 _duration, address _receiver) external override {
3101         require(_amount > 0, "TimeLockPool.deposit: cannot deposit 0");
3102         // Don't allow locking > maxLockDuration
3103         uint256 duration = _duration.min(maxLockDuration);
3104         // Enforce min lockup duration to prevent flash loan or MEV transaction ordering
3105         duration = duration.max(MIN_LOCK_DURATION);
3106 
3107         depositToken.safeTransferFrom(_msgSender(), address(this), _amount);
3108 
3109         depositsOf[_receiver].push(Deposit({
3110             amount: _amount,
3111             start: uint64(block.timestamp),
3112             end: uint64(block.timestamp) + uint64(duration)
3113         }));
3114 
3115         uint256 mintAmount = _amount * getMultiplier(duration) / 1e18;
3116 
3117         _mint(_receiver, mintAmount);
3118         emit Deposited(_amount, duration, _receiver, _msgSender());
3119     }
3120 
3121     function withdraw(uint256 _depositId, address _receiver) external {
3122         require(_depositId < depositsOf[_msgSender()].length, "TimeLockPool.withdraw: Deposit does not exist");
3123         Deposit memory userDeposit = depositsOf[_msgSender()][_depositId];
3124         require(block.timestamp >= userDeposit.end, "TimeLockPool.withdraw: too soon");
3125 
3126         //                      No risk of wrapping around on casting to uint256 since deposit end always > deposit start and types are 64 bits
3127         uint256 shareAmount = userDeposit.amount * getMultiplier(uint256(userDeposit.end - userDeposit.start)) / 1e18;
3128 
3129         // remove Deposit
3130         depositsOf[_msgSender()][_depositId] = depositsOf[_msgSender()][depositsOf[_msgSender()].length - 1];
3131         depositsOf[_msgSender()].pop();
3132 
3133         // burn pool shares
3134         _burn(_msgSender(), shareAmount);
3135         
3136         // return tokens
3137         depositToken.safeTransfer(_receiver, userDeposit.amount);
3138         emit Withdrawn(_depositId, _receiver, _msgSender(), userDeposit.amount);
3139     }
3140 
3141     function getMultiplier(uint256 _lockDuration) public view returns(uint256) {
3142         return 1e18 + (maxBonus * _lockDuration / maxLockDuration);
3143     }
3144 
3145     function getTotalDeposit(address _account) public view returns(uint256) {
3146         uint256 total;
3147         for(uint256 i = 0; i < depositsOf[_account].length; i++) {
3148             total += depositsOf[_account][i].amount;
3149         }
3150 
3151         return total;
3152     }
3153 
3154     function getDepositsOf(address _account) public view returns(Deposit[] memory) {
3155         return depositsOf[_account];
3156     }
3157 
3158     function getDepositsOfLength(address _account) public view returns(uint256) {
3159         return depositsOf[_account].length;
3160     }
3161 }
3162 
3163 
3164 // File contracts/TimeLockNonTransferablePool.sol
3165 
3166 pragma solidity 0.8.7;
3167 
3168 contract TimeLockNonTransferablePool is TimeLockPool {
3169     constructor(
3170         string memory _name,
3171         string memory _symbol,
3172         address _depositToken,
3173         address _rewardToken,
3174         address _escrowPool,
3175         uint256 _escrowPortion,
3176         uint256 _escrowDuration,
3177         uint256 _maxBonus,
3178         uint256 _maxLockDuration
3179     ) TimeLockPool(_name, _symbol, _depositToken, _rewardToken, _escrowPool, _escrowPortion, _escrowDuration, _maxBonus, _maxLockDuration) {
3180 
3181     }
3182 
3183     // disable transfers
3184     function _transfer(address _from, address _to, uint256 _amount) internal override {
3185         revert("NON_TRANSFERABLE");
3186     }
3187 }