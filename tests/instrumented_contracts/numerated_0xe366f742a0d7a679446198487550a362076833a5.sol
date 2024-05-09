1 // Sources flattened with hardhat v2.8.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/utils/math/Math.sol@v4.4.2
90 // OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Standard math utilities missing in the Solidity language.
96  */
97 library Math {
98     /**
99      * @dev Returns the largest of two numbers.
100      */
101     function max(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a >= b ? a : b;
103     }
104 
105     /**
106      * @dev Returns the smallest of two numbers.
107      */
108     function min(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a < b ? a : b;
110     }
111 
112     /**
113      * @dev Returns the average of two numbers. The result is rounded towards
114      * zero.
115      */
116     function average(uint256 a, uint256 b) internal pure returns (uint256) {
117         // (a + b) / 2 can overflow.
118         return (a & b) + (a ^ b) / 2;
119     }
120 
121     /**
122      * @dev Returns the ceiling of the division of two numbers.
123      *
124      * This differs from standard division with `/` in that it rounds up instead
125      * of rounding down.
126      */
127     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
128         // (a + b - 1) / b can overflow on addition, so we distribute.
129         return a / b + (a % b == 0 ? 0 : 1);
130     }
131 }
132 
133 
134 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
354 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.4.2
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @title SafeERC20
363  * @dev Wrappers around ERC20 operations that throw on failure (when the token
364  * contract returns false). Tokens that return no value (and instead revert or
365  * throw on failure) are also supported, non-reverting calls are assumed to be
366  * successful.
367  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
368  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
369  */
370 library SafeERC20 {
371     using Address for address;
372 
373     function safeTransfer(
374         IERC20 token,
375         address to,
376         uint256 value
377     ) internal {
378         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
379     }
380 
381     function safeTransferFrom(
382         IERC20 token,
383         address from,
384         address to,
385         uint256 value
386     ) internal {
387         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
388     }
389 
390     /**
391      * @dev Deprecated. This function has issues similar to the ones found in
392      * {IERC20-approve}, and its usage is discouraged.
393      *
394      * Whenever possible, use {safeIncreaseAllowance} and
395      * {safeDecreaseAllowance} instead.
396      */
397     function safeApprove(
398         IERC20 token,
399         address spender,
400         uint256 value
401     ) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         require(
406             (value == 0) || (token.allowance(address(this), spender) == 0),
407             "SafeERC20: approve from non-zero to non-zero allowance"
408         );
409         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
410     }
411 
412     function safeIncreaseAllowance(
413         IERC20 token,
414         address spender,
415         uint256 value
416     ) internal {
417         uint256 newAllowance = token.allowance(address(this), spender) + value;
418         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
419     }
420 
421     function safeDecreaseAllowance(
422         IERC20 token,
423         address spender,
424         uint256 value
425     ) internal {
426         unchecked {
427             uint256 oldAllowance = token.allowance(address(this), spender);
428             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
429             uint256 newAllowance = oldAllowance - value;
430             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
431         }
432     }
433 
434     /**
435      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
436      * on the return value: the return value is optional (but if data is returned, it must not be false).
437      * @param token The token targeted by the call.
438      * @param data The call data (encoded using abi.encode or one of its variants).
439      */
440     function _callOptionalReturn(IERC20 token, bytes memory data) private {
441         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
442         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
443         // the target address contains contract code and also asserts for success in the low-level call.
444 
445         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
446         if (returndata.length > 0) {
447             // Return data is optional
448             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
449         }
450     }
451 }
452 
453 
454 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.4.2
455 
456 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
462  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
463  *
464  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
465  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
466  * need to send a transaction, and thus is not required to hold Ether at all.
467  */
468 interface IERC20Permit {
469     /**
470      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
471      * given ``owner``'s signed approval.
472      *
473      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
474      * ordering also apply here.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      * - `deadline` must be a timestamp in the future.
482      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
483      * over the EIP712-formatted function arguments.
484      * - the signature must use ``owner``'s current nonce (see {nonces}).
485      *
486      * For more information on the signature format, see the
487      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
488      * section].
489      */
490     function permit(
491         address owner,
492         address spender,
493         uint256 value,
494         uint256 deadline,
495         uint8 v,
496         bytes32 r,
497         bytes32 s
498     ) external;
499 
500     /**
501      * @dev Returns the current nonce for `owner`. This value must be
502      * included whenever a signature is generated for {permit}.
503      *
504      * Every successful call to {permit} increases ``owner``'s nonce by one. This
505      * prevents a signature from being used multiple times.
506      */
507     function nonces(address owner) external view returns (uint256);
508 
509     /**
510      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
511      */
512     // solhint-disable-next-line func-name-mixedcase
513     function DOMAIN_SEPARATOR() external view returns (bytes32);
514 }
515 
516 
517 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.2
518 
519 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Interface for the optional metadata functions from the ERC20 standard.
525  *
526  * _Available since v4.1._
527  */
528 interface IERC20Metadata is IERC20 {
529     /**
530      * @dev Returns the name of the token.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the symbol of the token.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the decimals places of the token.
541      */
542     function decimals() external view returns (uint8);
543 }
544 
545 
546 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Provides information about the current execution context, including the
554  * sender of the transaction and its data. While these are generally available
555  * via msg.sender and msg.data, they should not be accessed in such a direct
556  * manner, since when dealing with meta-transactions the account sending and
557  * paying for execution may not be the actual sender (as far as an application
558  * is concerned).
559  *
560  * This contract is only required for intermediate, library-like contracts.
561  */
562 abstract contract Context {
563     function _msgSender() internal view virtual returns (address) {
564         return msg.sender;
565     }
566 
567     function _msgData() internal view virtual returns (bytes calldata) {
568         return msg.data;
569     }
570 }
571 
572 
573 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.2
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 /**
582  * @dev Implementation of the {IERC20} interface.
583  *
584  * This implementation is agnostic to the way tokens are created. This means
585  * that a supply mechanism has to be added in a derived contract using {_mint}.
586  * For a generic mechanism see {ERC20PresetMinterPauser}.
587  *
588  * TIP: For a detailed writeup see our guide
589  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
590  * to implement supply mechanisms].
591  *
592  * We have followed general OpenZeppelin Contracts guidelines: functions revert
593  * instead returning `false` on failure. This behavior is nonetheless
594  * conventional and does not conflict with the expectations of ERC20
595  * applications.
596  *
597  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
598  * This allows applications to reconstruct the allowance for all accounts just
599  * by listening to said events. Other implementations of the EIP may not emit
600  * these events, as it isn't required by the specification.
601  *
602  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
603  * functions have been added to mitigate the well-known issues around setting
604  * allowances. See {IERC20-approve}.
605  */
606 contract ERC20 is Context, IERC20, IERC20Metadata {
607     mapping(address => uint256) private _balances;
608 
609     mapping(address => mapping(address => uint256)) private _allowances;
610 
611     uint256 private _totalSupply;
612 
613     string private _name;
614     string private _symbol;
615 
616     /**
617      * @dev Sets the values for {name} and {symbol}.
618      *
619      * The default value of {decimals} is 18. To select a different value for
620      * {decimals} you should overload it.
621      *
622      * All two of these values are immutable: they can only be set once during
623      * construction.
624      */
625     constructor(string memory name_, string memory symbol_) {
626         _name = name_;
627         _symbol = symbol_;
628     }
629 
630     /**
631      * @dev Returns the name of the token.
632      */
633     function name() public view virtual override returns (string memory) {
634         return _name;
635     }
636 
637     /**
638      * @dev Returns the symbol of the token, usually a shorter version of the
639      * name.
640      */
641     function symbol() public view virtual override returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev Returns the number of decimals used to get its user representation.
647      * For example, if `decimals` equals `2`, a balance of `505` tokens should
648      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
649      *
650      * Tokens usually opt for a value of 18, imitating the relationship between
651      * Ether and Wei. This is the value {ERC20} uses, unless this function is
652      * overridden;
653      *
654      * NOTE: This information is only used for _display_ purposes: it in
655      * no way affects any of the arithmetic of the contract, including
656      * {IERC20-balanceOf} and {IERC20-transfer}.
657      */
658     function decimals() public view virtual override returns (uint8) {
659         return 18;
660     }
661 
662     /**
663      * @dev See {IERC20-totalSupply}.
664      */
665     function totalSupply() public view virtual override returns (uint256) {
666         return _totalSupply;
667     }
668 
669     /**
670      * @dev See {IERC20-balanceOf}.
671      */
672     function balanceOf(address account) public view virtual override returns (uint256) {
673         return _balances[account];
674     }
675 
676     /**
677      * @dev See {IERC20-transfer}.
678      *
679      * Requirements:
680      *
681      * - `recipient` cannot be the zero address.
682      * - the caller must have a balance of at least `amount`.
683      */
684     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
685         _transfer(_msgSender(), recipient, amount);
686         return true;
687     }
688 
689     /**
690      * @dev See {IERC20-allowance}.
691      */
692     function allowance(address owner, address spender) public view virtual override returns (uint256) {
693         return _allowances[owner][spender];
694     }
695 
696     /**
697      * @dev See {IERC20-approve}.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      */
703     function approve(address spender, uint256 amount) public virtual override returns (bool) {
704         _approve(_msgSender(), spender, amount);
705         return true;
706     }
707 
708     /**
709      * @dev See {IERC20-transferFrom}.
710      *
711      * Emits an {Approval} event indicating the updated allowance. This is not
712      * required by the EIP. See the note at the beginning of {ERC20}.
713      *
714      * Requirements:
715      *
716      * - `sender` and `recipient` cannot be the zero address.
717      * - `sender` must have a balance of at least `amount`.
718      * - the caller must have allowance for ``sender``'s tokens of at least
719      * `amount`.
720      */
721     function transferFrom(
722         address sender,
723         address recipient,
724         uint256 amount
725     ) public virtual override returns (bool) {
726         _transfer(sender, recipient, amount);
727 
728         uint256 currentAllowance = _allowances[sender][_msgSender()];
729         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
730         unchecked {
731             _approve(sender, _msgSender(), currentAllowance - amount);
732         }
733 
734         return true;
735     }
736 
737     /**
738      * @dev Atomically increases the allowance granted to `spender` by the caller.
739      *
740      * This is an alternative to {approve} that can be used as a mitigation for
741      * problems described in {IERC20-approve}.
742      *
743      * Emits an {Approval} event indicating the updated allowance.
744      *
745      * Requirements:
746      *
747      * - `spender` cannot be the zero address.
748      */
749     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
751         return true;
752     }
753 
754     /**
755      * @dev Atomically decreases the allowance granted to `spender` by the caller.
756      *
757      * This is an alternative to {approve} that can be used as a mitigation for
758      * problems described in {IERC20-approve}.
759      *
760      * Emits an {Approval} event indicating the updated allowance.
761      *
762      * Requirements:
763      *
764      * - `spender` cannot be the zero address.
765      * - `spender` must have allowance for the caller of at least
766      * `subtractedValue`.
767      */
768     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
769         uint256 currentAllowance = _allowances[_msgSender()][spender];
770         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
771         unchecked {
772             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
773         }
774 
775         return true;
776     }
777 
778     /**
779      * @dev Moves `amount` of tokens from `sender` to `recipient`.
780      *
781      * This internal function is equivalent to {transfer}, and can be used to
782      * e.g. implement automatic token fees, slashing mechanisms, etc.
783      *
784      * Emits a {Transfer} event.
785      *
786      * Requirements:
787      *
788      * - `sender` cannot be the zero address.
789      * - `recipient` cannot be the zero address.
790      * - `sender` must have a balance of at least `amount`.
791      */
792     function _transfer(
793         address sender,
794         address recipient,
795         uint256 amount
796     ) internal virtual {
797         require(sender != address(0), "ERC20: transfer from the zero address");
798         require(recipient != address(0), "ERC20: transfer to the zero address");
799 
800         _beforeTokenTransfer(sender, recipient, amount);
801 
802         uint256 senderBalance = _balances[sender];
803         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
804         unchecked {
805             _balances[sender] = senderBalance - amount;
806         }
807         _balances[recipient] += amount;
808 
809         emit Transfer(sender, recipient, amount);
810 
811         _afterTokenTransfer(sender, recipient, amount);
812     }
813 
814     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
815      * the total supply.
816      *
817      * Emits a {Transfer} event with `from` set to the zero address.
818      *
819      * Requirements:
820      *
821      * - `account` cannot be the zero address.
822      */
823     function _mint(address account, uint256 amount) internal virtual {
824         require(account != address(0), "ERC20: mint to the zero address");
825 
826         _beforeTokenTransfer(address(0), account, amount);
827 
828         _totalSupply += amount;
829         _balances[account] += amount;
830         emit Transfer(address(0), account, amount);
831 
832         _afterTokenTransfer(address(0), account, amount);
833     }
834 
835     /**
836      * @dev Destroys `amount` tokens from `account`, reducing the
837      * total supply.
838      *
839      * Emits a {Transfer} event with `to` set to the zero address.
840      *
841      * Requirements:
842      *
843      * - `account` cannot be the zero address.
844      * - `account` must have at least `amount` tokens.
845      */
846     function _burn(address account, uint256 amount) internal virtual {
847         require(account != address(0), "ERC20: burn from the zero address");
848 
849         _beforeTokenTransfer(account, address(0), amount);
850 
851         uint256 accountBalance = _balances[account];
852         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
853         unchecked {
854             _balances[account] = accountBalance - amount;
855         }
856         _totalSupply -= amount;
857 
858         emit Transfer(account, address(0), amount);
859 
860         _afterTokenTransfer(account, address(0), amount);
861     }
862 
863     /**
864      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
865      *
866      * This internal function is equivalent to `approve`, and can be used to
867      * e.g. set automatic allowances for certain subsystems, etc.
868      *
869      * Emits an {Approval} event.
870      *
871      * Requirements:
872      *
873      * - `owner` cannot be the zero address.
874      * - `spender` cannot be the zero address.
875      */
876     function _approve(
877         address owner,
878         address spender,
879         uint256 amount
880     ) internal virtual {
881         require(owner != address(0), "ERC20: approve from the zero address");
882         require(spender != address(0), "ERC20: approve to the zero address");
883 
884         _allowances[owner][spender] = amount;
885         emit Approval(owner, spender, amount);
886     }
887 
888     /**
889      * @dev Hook that is called before any transfer of tokens. This includes
890      * minting and burning.
891      *
892      * Calling conditions:
893      *
894      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
895      * will be transferred to `to`.
896      * - when `from` is zero, `amount` tokens will be minted for `to`.
897      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
898      * - `from` and `to` are never both zero.
899      *
900      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
901      */
902     function _beforeTokenTransfer(
903         address from,
904         address to,
905         uint256 amount
906     ) internal virtual {}
907 
908     /**
909      * @dev Hook that is called after any transfer of tokens. This includes
910      * minting and burning.
911      *
912      * Calling conditions:
913      *
914      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
915      * has been transferred to `to`.
916      * - when `from` is zero, `amount` tokens have been minted for `to`.
917      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
918      * - `from` and `to` are never both zero.
919      *
920      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
921      */
922     function _afterTokenTransfer(
923         address from,
924         address to,
925         uint256 amount
926     ) internal virtual {}
927 }
928 
929 
930 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
931 
932 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @dev String operations.
938  */
939 library Strings {
940     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
941 
942     /**
943      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
944      */
945     function toString(uint256 value) internal pure returns (string memory) {
946         // Inspired by OraclizeAPI's implementation - MIT licence
947         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
948 
949         if (value == 0) {
950             return "0";
951         }
952         uint256 temp = value;
953         uint256 digits;
954         while (temp != 0) {
955             digits++;
956             temp /= 10;
957         }
958         bytes memory buffer = new bytes(digits);
959         while (value != 0) {
960             digits -= 1;
961             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
962             value /= 10;
963         }
964         return string(buffer);
965     }
966 
967     /**
968      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
969      */
970     function toHexString(uint256 value) internal pure returns (string memory) {
971         if (value == 0) {
972             return "0x00";
973         }
974         uint256 temp = value;
975         uint256 length = 0;
976         while (temp != 0) {
977             length++;
978             temp >>= 8;
979         }
980         return toHexString(value, length);
981     }
982 
983     /**
984      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
985      */
986     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
987         bytes memory buffer = new bytes(2 * length + 2);
988         buffer[0] = "0";
989         buffer[1] = "x";
990         for (uint256 i = 2 * length + 1; i > 1; --i) {
991             buffer[i] = _HEX_SYMBOLS[value & 0xf];
992             value >>= 4;
993         }
994         require(value == 0, "Strings: hex length insufficient");
995         return string(buffer);
996     }
997 }
998 
999 
1000 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.4.2
1001 
1002 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
1003 
1004 pragma solidity ^0.8.0;
1005 
1006 /**
1007  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1008  *
1009  * These functions can be used to verify that a message was signed by the holder
1010  * of the private keys of a given address.
1011  */
1012 library ECDSA {
1013     enum RecoverError {
1014         NoError,
1015         InvalidSignature,
1016         InvalidSignatureLength,
1017         InvalidSignatureS,
1018         InvalidSignatureV
1019     }
1020 
1021     function _throwError(RecoverError error) private pure {
1022         if (error == RecoverError.NoError) {
1023             return; // no error: do nothing
1024         } else if (error == RecoverError.InvalidSignature) {
1025             revert("ECDSA: invalid signature");
1026         } else if (error == RecoverError.InvalidSignatureLength) {
1027             revert("ECDSA: invalid signature length");
1028         } else if (error == RecoverError.InvalidSignatureS) {
1029             revert("ECDSA: invalid signature 's' value");
1030         } else if (error == RecoverError.InvalidSignatureV) {
1031             revert("ECDSA: invalid signature 'v' value");
1032         }
1033     }
1034 
1035     /**
1036      * @dev Returns the address that signed a hashed message (`hash`) with
1037      * `signature` or error string. This address can then be used for verification purposes.
1038      *
1039      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1040      * this function rejects them by requiring the `s` value to be in the lower
1041      * half order, and the `v` value to be either 27 or 28.
1042      *
1043      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1044      * verification to be secure: it is possible to craft signatures that
1045      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1046      * this is by receiving a hash of the original message (which may otherwise
1047      * be too long), and then calling {toEthSignedMessageHash} on it.
1048      *
1049      * Documentation for signature generation:
1050      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1051      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1052      *
1053      * _Available since v4.3._
1054      */
1055     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1056         // Check the signature length
1057         // - case 65: r,s,v signature (standard)
1058         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1059         if (signature.length == 65) {
1060             bytes32 r;
1061             bytes32 s;
1062             uint8 v;
1063             // ecrecover takes the signature parameters, and the only way to get them
1064             // currently is to use assembly.
1065             assembly {
1066                 r := mload(add(signature, 0x20))
1067                 s := mload(add(signature, 0x40))
1068                 v := byte(0, mload(add(signature, 0x60)))
1069             }
1070             return tryRecover(hash, v, r, s);
1071         } else if (signature.length == 64) {
1072             bytes32 r;
1073             bytes32 vs;
1074             // ecrecover takes the signature parameters, and the only way to get them
1075             // currently is to use assembly.
1076             assembly {
1077                 r := mload(add(signature, 0x20))
1078                 vs := mload(add(signature, 0x40))
1079             }
1080             return tryRecover(hash, r, vs);
1081         } else {
1082             return (address(0), RecoverError.InvalidSignatureLength);
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns the address that signed a hashed message (`hash`) with
1088      * `signature`. This address can then be used for verification purposes.
1089      *
1090      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1091      * this function rejects them by requiring the `s` value to be in the lower
1092      * half order, and the `v` value to be either 27 or 28.
1093      *
1094      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1095      * verification to be secure: it is possible to craft signatures that
1096      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1097      * this is by receiving a hash of the original message (which may otherwise
1098      * be too long), and then calling {toEthSignedMessageHash} on it.
1099      */
1100     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1101         (address recovered, RecoverError error) = tryRecover(hash, signature);
1102         _throwError(error);
1103         return recovered;
1104     }
1105 
1106     /**
1107      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1108      *
1109      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1110      *
1111      * _Available since v4.3._
1112      */
1113     function tryRecover(
1114         bytes32 hash,
1115         bytes32 r,
1116         bytes32 vs
1117     ) internal pure returns (address, RecoverError) {
1118         bytes32 s;
1119         uint8 v;
1120         assembly {
1121             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1122             v := add(shr(255, vs), 27)
1123         }
1124         return tryRecover(hash, v, r, s);
1125     }
1126 
1127     /**
1128      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1129      *
1130      * _Available since v4.2._
1131      */
1132     function recover(
1133         bytes32 hash,
1134         bytes32 r,
1135         bytes32 vs
1136     ) internal pure returns (address) {
1137         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1138         _throwError(error);
1139         return recovered;
1140     }
1141 
1142     /**
1143      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1144      * `r` and `s` signature fields separately.
1145      *
1146      * _Available since v4.3._
1147      */
1148     function tryRecover(
1149         bytes32 hash,
1150         uint8 v,
1151         bytes32 r,
1152         bytes32 s
1153     ) internal pure returns (address, RecoverError) {
1154         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1155         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1156         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1157         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1158         //
1159         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1160         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1161         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1162         // these malleable signatures as well.
1163         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1164             return (address(0), RecoverError.InvalidSignatureS);
1165         }
1166         if (v != 27 && v != 28) {
1167             return (address(0), RecoverError.InvalidSignatureV);
1168         }
1169 
1170         // If the signature is valid (and not malleable), return the signer address
1171         address signer = ecrecover(hash, v, r, s);
1172         if (signer == address(0)) {
1173             return (address(0), RecoverError.InvalidSignature);
1174         }
1175 
1176         return (signer, RecoverError.NoError);
1177     }
1178 
1179     /**
1180      * @dev Overload of {ECDSA-recover} that receives the `v`,
1181      * `r` and `s` signature fields separately.
1182      */
1183     function recover(
1184         bytes32 hash,
1185         uint8 v,
1186         bytes32 r,
1187         bytes32 s
1188     ) internal pure returns (address) {
1189         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1190         _throwError(error);
1191         return recovered;
1192     }
1193 
1194     /**
1195      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1196      * produces hash corresponding to the one signed with the
1197      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1198      * JSON-RPC method as part of EIP-191.
1199      *
1200      * See {recover}.
1201      */
1202     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1203         // 32 is the length in bytes of hash,
1204         // enforced by the type signature above
1205         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1206     }
1207 
1208     /**
1209      * @dev Returns an Ethereum Signed Message, created from `s`. This
1210      * produces hash corresponding to the one signed with the
1211      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1212      * JSON-RPC method as part of EIP-191.
1213      *
1214      * See {recover}.
1215      */
1216     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1217         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1218     }
1219 
1220     /**
1221      * @dev Returns an Ethereum Signed Typed Data, created from a
1222      * `domainSeparator` and a `structHash`. This produces hash corresponding
1223      * to the one signed with the
1224      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1225      * JSON-RPC method as part of EIP-712.
1226      *
1227      * See {recover}.
1228      */
1229     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1230         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1231     }
1232 }
1233 
1234 
1235 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.4.2
1236 
1237 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 /**
1242  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1243  *
1244  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1245  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1246  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1247  *
1248  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1249  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1250  * ({_hashTypedDataV4}).
1251  *
1252  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1253  * the chain id to protect against replay attacks on an eventual fork of the chain.
1254  *
1255  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1256  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1257  *
1258  * _Available since v3.4._
1259  */
1260 abstract contract EIP712 {
1261     /* solhint-disable var-name-mixedcase */
1262     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1263     // invalidate the cached domain separator if the chain id changes.
1264     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1265     uint256 private immutable _CACHED_CHAIN_ID;
1266     address private immutable _CACHED_THIS;
1267 
1268     bytes32 private immutable _HASHED_NAME;
1269     bytes32 private immutable _HASHED_VERSION;
1270     bytes32 private immutable _TYPE_HASH;
1271 
1272     /* solhint-enable var-name-mixedcase */
1273 
1274     /**
1275      * @dev Initializes the domain separator and parameter caches.
1276      *
1277      * The meaning of `name` and `version` is specified in
1278      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1279      *
1280      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1281      * - `version`: the current major version of the signing domain.
1282      *
1283      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1284      * contract upgrade].
1285      */
1286     constructor(string memory name, string memory version) {
1287         bytes32 hashedName = keccak256(bytes(name));
1288         bytes32 hashedVersion = keccak256(bytes(version));
1289         bytes32 typeHash = keccak256(
1290             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1291         );
1292         _HASHED_NAME = hashedName;
1293         _HASHED_VERSION = hashedVersion;
1294         _CACHED_CHAIN_ID = block.chainid;
1295         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1296         _CACHED_THIS = address(this);
1297         _TYPE_HASH = typeHash;
1298     }
1299 
1300     /**
1301      * @dev Returns the domain separator for the current chain.
1302      */
1303     function _domainSeparatorV4() internal view returns (bytes32) {
1304         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1305             return _CACHED_DOMAIN_SEPARATOR;
1306         } else {
1307             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1308         }
1309     }
1310 
1311     function _buildDomainSeparator(
1312         bytes32 typeHash,
1313         bytes32 nameHash,
1314         bytes32 versionHash
1315     ) private view returns (bytes32) {
1316         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1317     }
1318 
1319     /**
1320      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1321      * function returns the hash of the fully encoded EIP712 message for this domain.
1322      *
1323      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1324      *
1325      * ```solidity
1326      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1327      *     keccak256("Mail(address to,string contents)"),
1328      *     mailTo,
1329      *     keccak256(bytes(mailContents))
1330      * )));
1331      * address signer = ECDSA.recover(digest, signature);
1332      * ```
1333      */
1334     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1335         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1336     }
1337 }
1338 
1339 
1340 // File @openzeppelin/contracts/utils/Counters.sol@v4.4.2
1341 
1342 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 /**
1347  * @title Counters
1348  * @author Matt Condon (@shrugs)
1349  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1350  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1351  *
1352  * Include with `using Counters for Counters.Counter;`
1353  */
1354 library Counters {
1355     struct Counter {
1356         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1357         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1358         // this feature: see https://github.com/ethereum/solidity/issues/4637
1359         uint256 _value; // default: 0
1360     }
1361 
1362     function current(Counter storage counter) internal view returns (uint256) {
1363         return counter._value;
1364     }
1365 
1366     function increment(Counter storage counter) internal {
1367         unchecked {
1368             counter._value += 1;
1369         }
1370     }
1371 
1372     function decrement(Counter storage counter) internal {
1373         uint256 value = counter._value;
1374         require(value > 0, "Counter: decrement overflow");
1375         unchecked {
1376             counter._value = value - 1;
1377         }
1378     }
1379 
1380     function reset(Counter storage counter) internal {
1381         counter._value = 0;
1382     }
1383 }
1384 
1385 
1386 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.4.2
1387 
1388 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-ERC20Permit.sol)
1389 
1390 pragma solidity ^0.8.0;
1391 
1392 
1393 
1394 
1395 
1396 /**
1397  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1398  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1399  *
1400  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1401  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1402  * need to send a transaction, and thus is not required to hold Ether at all.
1403  *
1404  * _Available since v3.4._
1405  */
1406 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1407     using Counters for Counters.Counter;
1408 
1409     mapping(address => Counters.Counter) private _nonces;
1410 
1411     // solhint-disable-next-line var-name-mixedcase
1412     bytes32 private immutable _PERMIT_TYPEHASH =
1413         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1414 
1415     /**
1416      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1417      *
1418      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1419      */
1420     constructor(string memory name) EIP712(name, "1") {}
1421 
1422     /**
1423      * @dev See {IERC20Permit-permit}.
1424      */
1425     function permit(
1426         address owner,
1427         address spender,
1428         uint256 value,
1429         uint256 deadline,
1430         uint8 v,
1431         bytes32 r,
1432         bytes32 s
1433     ) public virtual override {
1434         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1435 
1436         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1437 
1438         bytes32 hash = _hashTypedDataV4(structHash);
1439 
1440         address signer = ECDSA.recover(hash, v, r, s);
1441         require(signer == owner, "ERC20Permit: invalid signature");
1442 
1443         _approve(owner, spender, value);
1444     }
1445 
1446     /**
1447      * @dev See {IERC20Permit-nonces}.
1448      */
1449     function nonces(address owner) public view virtual override returns (uint256) {
1450         return _nonces[owner].current();
1451     }
1452 
1453     /**
1454      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1455      */
1456     // solhint-disable-next-line func-name-mixedcase
1457     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1458         return _domainSeparatorV4();
1459     }
1460 
1461     /**
1462      * @dev "Consume a nonce": return the current value and increment.
1463      *
1464      * _Available since v4.1._
1465      */
1466     function _useNonce(address owner) internal virtual returns (uint256 current) {
1467         Counters.Counter storage nonce = _nonces[owner];
1468         current = nonce.current();
1469         nonce.increment();
1470     }
1471 }
1472 
1473 
1474 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.4.2
1475 
1476 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 /**
1481  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1482  * checks.
1483  *
1484  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1485  * easily result in undesired exploitation or bugs, since developers usually
1486  * assume that overflows raise errors. `SafeCast` restores this intuition by
1487  * reverting the transaction when such an operation overflows.
1488  *
1489  * Using this library instead of the unchecked operations eliminates an entire
1490  * class of bugs, so it's recommended to use it always.
1491  *
1492  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1493  * all math on `uint256` and `int256` and then downcasting.
1494  */
1495 library SafeCast {
1496     /**
1497      * @dev Returns the downcasted uint224 from uint256, reverting on
1498      * overflow (when the input is greater than largest uint224).
1499      *
1500      * Counterpart to Solidity's `uint224` operator.
1501      *
1502      * Requirements:
1503      *
1504      * - input must fit into 224 bits
1505      */
1506     function toUint224(uint256 value) internal pure returns (uint224) {
1507         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1508         return uint224(value);
1509     }
1510 
1511     /**
1512      * @dev Returns the downcasted uint128 from uint256, reverting on
1513      * overflow (when the input is greater than largest uint128).
1514      *
1515      * Counterpart to Solidity's `uint128` operator.
1516      *
1517      * Requirements:
1518      *
1519      * - input must fit into 128 bits
1520      */
1521     function toUint128(uint256 value) internal pure returns (uint128) {
1522         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1523         return uint128(value);
1524     }
1525 
1526     /**
1527      * @dev Returns the downcasted uint96 from uint256, reverting on
1528      * overflow (when the input is greater than largest uint96).
1529      *
1530      * Counterpart to Solidity's `uint96` operator.
1531      *
1532      * Requirements:
1533      *
1534      * - input must fit into 96 bits
1535      */
1536     function toUint96(uint256 value) internal pure returns (uint96) {
1537         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1538         return uint96(value);
1539     }
1540 
1541     /**
1542      * @dev Returns the downcasted uint64 from uint256, reverting on
1543      * overflow (when the input is greater than largest uint64).
1544      *
1545      * Counterpart to Solidity's `uint64` operator.
1546      *
1547      * Requirements:
1548      *
1549      * - input must fit into 64 bits
1550      */
1551     function toUint64(uint256 value) internal pure returns (uint64) {
1552         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1553         return uint64(value);
1554     }
1555 
1556     /**
1557      * @dev Returns the downcasted uint32 from uint256, reverting on
1558      * overflow (when the input is greater than largest uint32).
1559      *
1560      * Counterpart to Solidity's `uint32` operator.
1561      *
1562      * Requirements:
1563      *
1564      * - input must fit into 32 bits
1565      */
1566     function toUint32(uint256 value) internal pure returns (uint32) {
1567         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1568         return uint32(value);
1569     }
1570 
1571     /**
1572      * @dev Returns the downcasted uint16 from uint256, reverting on
1573      * overflow (when the input is greater than largest uint16).
1574      *
1575      * Counterpart to Solidity's `uint16` operator.
1576      *
1577      * Requirements:
1578      *
1579      * - input must fit into 16 bits
1580      */
1581     function toUint16(uint256 value) internal pure returns (uint16) {
1582         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1583         return uint16(value);
1584     }
1585 
1586     /**
1587      * @dev Returns the downcasted uint8 from uint256, reverting on
1588      * overflow (when the input is greater than largest uint8).
1589      *
1590      * Counterpart to Solidity's `uint8` operator.
1591      *
1592      * Requirements:
1593      *
1594      * - input must fit into 8 bits.
1595      */
1596     function toUint8(uint256 value) internal pure returns (uint8) {
1597         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1598         return uint8(value);
1599     }
1600 
1601     /**
1602      * @dev Converts a signed int256 into an unsigned uint256.
1603      *
1604      * Requirements:
1605      *
1606      * - input must be greater than or equal to 0.
1607      */
1608     function toUint256(int256 value) internal pure returns (uint256) {
1609         require(value >= 0, "SafeCast: value must be positive");
1610         return uint256(value);
1611     }
1612 
1613     /**
1614      * @dev Returns the downcasted int128 from int256, reverting on
1615      * overflow (when the input is less than smallest int128 or
1616      * greater than largest int128).
1617      *
1618      * Counterpart to Solidity's `int128` operator.
1619      *
1620      * Requirements:
1621      *
1622      * - input must fit into 128 bits
1623      *
1624      * _Available since v3.1._
1625      */
1626     function toInt128(int256 value) internal pure returns (int128) {
1627         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
1628         return int128(value);
1629     }
1630 
1631     /**
1632      * @dev Returns the downcasted int64 from int256, reverting on
1633      * overflow (when the input is less than smallest int64 or
1634      * greater than largest int64).
1635      *
1636      * Counterpart to Solidity's `int64` operator.
1637      *
1638      * Requirements:
1639      *
1640      * - input must fit into 64 bits
1641      *
1642      * _Available since v3.1._
1643      */
1644     function toInt64(int256 value) internal pure returns (int64) {
1645         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
1646         return int64(value);
1647     }
1648 
1649     /**
1650      * @dev Returns the downcasted int32 from int256, reverting on
1651      * overflow (when the input is less than smallest int32 or
1652      * greater than largest int32).
1653      *
1654      * Counterpart to Solidity's `int32` operator.
1655      *
1656      * Requirements:
1657      *
1658      * - input must fit into 32 bits
1659      *
1660      * _Available since v3.1._
1661      */
1662     function toInt32(int256 value) internal pure returns (int32) {
1663         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
1664         return int32(value);
1665     }
1666 
1667     /**
1668      * @dev Returns the downcasted int16 from int256, reverting on
1669      * overflow (when the input is less than smallest int16 or
1670      * greater than largest int16).
1671      *
1672      * Counterpart to Solidity's `int16` operator.
1673      *
1674      * Requirements:
1675      *
1676      * - input must fit into 16 bits
1677      *
1678      * _Available since v3.1._
1679      */
1680     function toInt16(int256 value) internal pure returns (int16) {
1681         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
1682         return int16(value);
1683     }
1684 
1685     /**
1686      * @dev Returns the downcasted int8 from int256, reverting on
1687      * overflow (when the input is less than smallest int8 or
1688      * greater than largest int8).
1689      *
1690      * Counterpart to Solidity's `int8` operator.
1691      *
1692      * Requirements:
1693      *
1694      * - input must fit into 8 bits.
1695      *
1696      * _Available since v3.1._
1697      */
1698     function toInt8(int256 value) internal pure returns (int8) {
1699         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
1700         return int8(value);
1701     }
1702 
1703     /**
1704      * @dev Converts an unsigned uint256 into a signed int256.
1705      *
1706      * Requirements:
1707      *
1708      * - input must be less than or equal to maxInt256.
1709      */
1710     function toInt256(uint256 value) internal pure returns (int256) {
1711         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
1712         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
1713         return int256(value);
1714     }
1715 }
1716 
1717 
1718 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol@v4.4.2
1719 
1720 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Votes.sol)
1721 
1722 pragma solidity ^0.8.0;
1723 
1724 
1725 
1726 
1727 /**
1728  * @dev Extension of ERC20 to support Compound-like voting and delegation. This version is more generic than Compound's,
1729  * and supports token supply up to 2^224^ - 1, while COMP is limited to 2^96^ - 1.
1730  *
1731  * NOTE: If exact COMP compatibility is required, use the {ERC20VotesComp} variant of this module.
1732  *
1733  * This extension keeps a history (checkpoints) of each account's vote power. Vote power can be delegated either
1734  * by calling the {delegate} function directly, or by providing a signature to be used with {delegateBySig}. Voting
1735  * power can be queried through the public accessors {getVotes} and {getPastVotes}.
1736  *
1737  * By default, token balance does not account for voting power. This makes transfers cheaper. The downside is that it
1738  * requires users to delegate to themselves in order to activate checkpoints and have their voting power tracked.
1739  * Enabling self-delegation can easily be done by overriding the {delegates} function. Keep in mind however that this
1740  * will significantly increase the base gas cost of transfers.
1741  *
1742  * _Available since v4.2._
1743  */
1744 abstract contract ERC20Votes is ERC20Permit {
1745     struct Checkpoint {
1746         uint32 fromBlock;
1747         uint224 votes;
1748     }
1749 
1750     bytes32 private constant _DELEGATION_TYPEHASH =
1751         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1752 
1753     mapping(address => address) private _delegates;
1754     mapping(address => Checkpoint[]) private _checkpoints;
1755     Checkpoint[] private _totalSupplyCheckpoints;
1756 
1757     /**
1758      * @dev Emitted when an account changes their delegate.
1759      */
1760     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1761 
1762     /**
1763      * @dev Emitted when a token transfer or delegate change results in changes to an account's voting power.
1764      */
1765     event DelegateVotesChanged(address indexed delegate, uint256 previousBalance, uint256 newBalance);
1766 
1767     /**
1768      * @dev Get the `pos`-th checkpoint for `account`.
1769      */
1770     function checkpoints(address account, uint32 pos) public view virtual returns (Checkpoint memory) {
1771         return _checkpoints[account][pos];
1772     }
1773 
1774     /**
1775      * @dev Get number of checkpoints for `account`.
1776      */
1777     function numCheckpoints(address account) public view virtual returns (uint32) {
1778         return SafeCast.toUint32(_checkpoints[account].length);
1779     }
1780 
1781     /**
1782      * @dev Get the address `account` is currently delegating to.
1783      */
1784     function delegates(address account) public view virtual returns (address) {
1785         return _delegates[account];
1786     }
1787 
1788     /**
1789      * @dev Gets the current votes balance for `account`
1790      */
1791     function getVotes(address account) public view returns (uint256) {
1792         uint256 pos = _checkpoints[account].length;
1793         return pos == 0 ? 0 : _checkpoints[account][pos - 1].votes;
1794     }
1795 
1796     /**
1797      * @dev Retrieve the number of votes for `account` at the end of `blockNumber`.
1798      *
1799      * Requirements:
1800      *
1801      * - `blockNumber` must have been already mined
1802      */
1803     function getPastVotes(address account, uint256 blockNumber) public view returns (uint256) {
1804         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1805         return _checkpointsLookup(_checkpoints[account], blockNumber);
1806     }
1807 
1808     /**
1809      * @dev Retrieve the `totalSupply` at the end of `blockNumber`. Note, this value is the sum of all balances.
1810      * It is but NOT the sum of all the delegated votes!
1811      *
1812      * Requirements:
1813      *
1814      * - `blockNumber` must have been already mined
1815      */
1816     function getPastTotalSupply(uint256 blockNumber) public view returns (uint256) {
1817         require(blockNumber < block.number, "ERC20Votes: block not yet mined");
1818         return _checkpointsLookup(_totalSupplyCheckpoints, blockNumber);
1819     }
1820 
1821     /**
1822      * @dev Lookup a value in a list of (sorted) checkpoints.
1823      */
1824     function _checkpointsLookup(Checkpoint[] storage ckpts, uint256 blockNumber) private view returns (uint256) {
1825         // We run a binary search to look for the earliest checkpoint taken after `blockNumber`.
1826         //
1827         // During the loop, the index of the wanted checkpoint remains in the range [low-1, high).
1828         // With each iteration, either `low` or `high` is moved towards the middle of the range to maintain the invariant.
1829         // - If the middle checkpoint is after `blockNumber`, we look in [low, mid)
1830         // - If the middle checkpoint is before or equal to `blockNumber`, we look in [mid+1, high)
1831         // Once we reach a single value (when low == high), we've found the right checkpoint at the index high-1, if not
1832         // out of bounds (in which case we're looking too far in the past and the result is 0).
1833         // Note that if the latest checkpoint available is exactly for `blockNumber`, we end up with an index that is
1834         // past the end of the array, so we technically don't find a checkpoint after `blockNumber`, but it works out
1835         // the same.
1836         uint256 high = ckpts.length;
1837         uint256 low = 0;
1838         while (low < high) {
1839             uint256 mid = Math.average(low, high);
1840             if (ckpts[mid].fromBlock > blockNumber) {
1841                 high = mid;
1842             } else {
1843                 low = mid + 1;
1844             }
1845         }
1846 
1847         return high == 0 ? 0 : ckpts[high - 1].votes;
1848     }
1849 
1850     /**
1851      * @dev Delegate votes from the sender to `delegatee`.
1852      */
1853     function delegate(address delegatee) public virtual {
1854         _delegate(_msgSender(), delegatee);
1855     }
1856 
1857     /**
1858      * @dev Delegates votes from signer to `delegatee`
1859      */
1860     function delegateBySig(
1861         address delegatee,
1862         uint256 nonce,
1863         uint256 expiry,
1864         uint8 v,
1865         bytes32 r,
1866         bytes32 s
1867     ) public virtual {
1868         require(block.timestamp <= expiry, "ERC20Votes: signature expired");
1869         address signer = ECDSA.recover(
1870             _hashTypedDataV4(keccak256(abi.encode(_DELEGATION_TYPEHASH, delegatee, nonce, expiry))),
1871             v,
1872             r,
1873             s
1874         );
1875         require(nonce == _useNonce(signer), "ERC20Votes: invalid nonce");
1876         _delegate(signer, delegatee);
1877     }
1878 
1879     /**
1880      * @dev Maximum token supply. Defaults to `type(uint224).max` (2^224^ - 1).
1881      */
1882     function _maxSupply() internal view virtual returns (uint224) {
1883         return type(uint224).max;
1884     }
1885 
1886     /**
1887      * @dev Snapshots the totalSupply after it has been increased.
1888      */
1889     function _mint(address account, uint256 amount) internal virtual override {
1890         super._mint(account, amount);
1891         require(totalSupply() <= _maxSupply(), "ERC20Votes: total supply risks overflowing votes");
1892 
1893         _writeCheckpoint(_totalSupplyCheckpoints, _add, amount);
1894     }
1895 
1896     /**
1897      * @dev Snapshots the totalSupply after it has been decreased.
1898      */
1899     function _burn(address account, uint256 amount) internal virtual override {
1900         super._burn(account, amount);
1901 
1902         _writeCheckpoint(_totalSupplyCheckpoints, _subtract, amount);
1903     }
1904 
1905     /**
1906      * @dev Move voting power when tokens are transferred.
1907      *
1908      * Emits a {DelegateVotesChanged} event.
1909      */
1910     function _afterTokenTransfer(
1911         address from,
1912         address to,
1913         uint256 amount
1914     ) internal virtual override {
1915         super._afterTokenTransfer(from, to, amount);
1916 
1917         _moveVotingPower(delegates(from), delegates(to), amount);
1918     }
1919 
1920     /**
1921      * @dev Change delegation for `delegator` to `delegatee`.
1922      *
1923      * Emits events {DelegateChanged} and {DelegateVotesChanged}.
1924      */
1925     function _delegate(address delegator, address delegatee) internal virtual {
1926         address currentDelegate = delegates(delegator);
1927         uint256 delegatorBalance = balanceOf(delegator);
1928         _delegates[delegator] = delegatee;
1929 
1930         emit DelegateChanged(delegator, currentDelegate, delegatee);
1931 
1932         _moveVotingPower(currentDelegate, delegatee, delegatorBalance);
1933     }
1934 
1935     function _moveVotingPower(
1936         address src,
1937         address dst,
1938         uint256 amount
1939     ) private {
1940         if (src != dst && amount > 0) {
1941             if (src != address(0)) {
1942                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[src], _subtract, amount);
1943                 emit DelegateVotesChanged(src, oldWeight, newWeight);
1944             }
1945 
1946             if (dst != address(0)) {
1947                 (uint256 oldWeight, uint256 newWeight) = _writeCheckpoint(_checkpoints[dst], _add, amount);
1948                 emit DelegateVotesChanged(dst, oldWeight, newWeight);
1949             }
1950         }
1951     }
1952 
1953     function _writeCheckpoint(
1954         Checkpoint[] storage ckpts,
1955         function(uint256, uint256) view returns (uint256) op,
1956         uint256 delta
1957     ) private returns (uint256 oldWeight, uint256 newWeight) {
1958         uint256 pos = ckpts.length;
1959         oldWeight = pos == 0 ? 0 : ckpts[pos - 1].votes;
1960         newWeight = op(oldWeight, delta);
1961 
1962         if (pos > 0 && ckpts[pos - 1].fromBlock == block.number) {
1963             ckpts[pos - 1].votes = SafeCast.toUint224(newWeight);
1964         } else {
1965             ckpts.push(Checkpoint({fromBlock: SafeCast.toUint32(block.number), votes: SafeCast.toUint224(newWeight)}));
1966         }
1967     }
1968 
1969     function _add(uint256 a, uint256 b) private pure returns (uint256) {
1970         return a + b;
1971     }
1972 
1973     function _subtract(uint256 a, uint256 b) private pure returns (uint256) {
1974         return a - b;
1975     }
1976 }
1977 
1978 
1979 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
1980 
1981 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1982 
1983 pragma solidity ^0.8.0;
1984 
1985 /**
1986  * @dev Contract module that helps prevent reentrant calls to a function.
1987  *
1988  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1989  * available, which can be applied to functions to make sure there are no nested
1990  * (reentrant) calls to them.
1991  *
1992  * Note that because there is a single `nonReentrant` guard, functions marked as
1993  * `nonReentrant` may not call one another. This can be worked around by making
1994  * those functions `private`, and then adding `external` `nonReentrant` entry
1995  * points to them.
1996  *
1997  * TIP: If you would like to learn more about reentrancy and alternative ways
1998  * to protect against it, check out our blog post
1999  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2000  */
2001 abstract contract ReentrancyGuard {
2002     // Booleans are more expensive than uint256 or any type that takes up a full
2003     // word because each write operation emits an extra SLOAD to first read the
2004     // slot's contents, replace the bits taken up by the boolean, and then write
2005     // back. This is the compiler's defense against contract upgrades and
2006     // pointer aliasing, and it cannot be disabled.
2007 
2008     // The values being non-zero value makes deployment a bit more expensive,
2009     // but in exchange the refund on every call to nonReentrant will be lower in
2010     // amount. Since refunds are capped to a percentage of the total
2011     // transaction's gas, it is best to keep them low in cases like this one, to
2012     // increase the likelihood of the full refund coming into effect.
2013     uint256 private constant _NOT_ENTERED = 1;
2014     uint256 private constant _ENTERED = 2;
2015 
2016     uint256 private _status;
2017 
2018     constructor() {
2019         _status = _NOT_ENTERED;
2020     }
2021 
2022     /**
2023      * @dev Prevents a contract from calling itself, directly or indirectly.
2024      * Calling a `nonReentrant` function from another `nonReentrant`
2025      * function is not supported. It is possible to prevent this from happening
2026      * by making the `nonReentrant` function external, and making it call a
2027      * `private` function that does the actual work.
2028      */
2029     modifier nonReentrant() {
2030         // On the first call to nonReentrant, _notEntered will be true
2031         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2032 
2033         // Any calls to nonReentrant after this point will fail
2034         _status = _ENTERED;
2035 
2036         _;
2037 
2038         // By storing the original value once again, a refund is triggered (see
2039         // https://eips.ethereum.org/EIPS/eip-2200)
2040         _status = _NOT_ENTERED;
2041     }
2042 }
2043 
2044 
2045 // File contracts/interfaces/IBasePool.sol
2046 
2047 pragma solidity 0.8.7;
2048 interface IBasePool {
2049     function distributeRewards(uint256 _amount) external;
2050 }
2051 
2052 
2053 // File contracts/interfaces/ITimeLockPool.sol
2054 
2055 pragma solidity 0.8.7;
2056 interface ITimeLockPool {
2057     function deposit(uint256 _amount, uint256 _duration, address _receiver) external;
2058 }
2059 
2060 
2061 // File contracts/interfaces/IAbstractRewards.sol
2062 
2063 pragma solidity 0.8.7;
2064 
2065 interface IAbstractRewards {
2066 	/**
2067 	 * @dev Returns the total amount of rewards a given address is able to withdraw.
2068 	 * @param account Address of a reward recipient
2069 	 * @return A uint256 representing the rewards `account` can withdraw
2070 	 */
2071 	function withdrawableRewardsOf(address account) external view returns (uint256);
2072 
2073   /**
2074 	 * @dev View the amount of funds that an address has withdrawn.
2075 	 * @param account The address of a token holder.
2076 	 * @return The amount of funds that `account` has withdrawn.
2077 	 */
2078 	function withdrawnRewardsOf(address account) external view returns (uint256);
2079 
2080 	/**
2081 	 * @dev View the amount of funds that an address has earned in total.
2082 	 * accumulativeFundsOf(account) = withdrawableRewardsOf(account) + withdrawnRewardsOf(account)
2083 	 * = (pointsPerShare * balanceOf(account) + pointsCorrection[account]) / POINTS_MULTIPLIER
2084 	 * @param account The address of a token holder.
2085 	 * @return The amount of funds that `account` has earned in total.
2086 	 */
2087 	function cumulativeRewardsOf(address account) external view returns (uint256);
2088 
2089 	/**
2090 	 * @dev This event emits when new funds are distributed
2091 	 * @param by the address of the sender who distributed funds
2092 	 * @param rewardsDistributed the amount of funds received for distribution
2093 	 */
2094 	event RewardsDistributed(address indexed by, uint256 rewardsDistributed);
2095 
2096 	/**
2097 	 * @dev This event emits when distributed funds are withdrawn by a token holder.
2098 	 * @param by the address of the receiver of funds
2099 	 * @param fundsWithdrawn the amount of funds that were withdrawn
2100 	 */
2101 	event RewardsWithdrawn(address indexed by, uint256 fundsWithdrawn);
2102 }
2103 
2104 
2105 // File contracts/base/AbstractRewards.sol
2106 
2107 pragma solidity 0.8.7;
2108 
2109 
2110 /**
2111  * @dev Based on: https://github.com/indexed-finance/dividends/blob/master/contracts/base/AbstractDividends.sol
2112  * Renamed dividends to rewards.
2113  * @dev (OLD) Many functions in this contract were taken from this repository:
2114  * https://github.com/atpar/funds-distribution-token/blob/master/contracts/FundsDistributionToken.sol
2115  * which is an example implementation of ERC 2222, the draft for which can be found at
2116  * https://github.com/atpar/funds-distribution-token/blob/master/EIP-DRAFT.md
2117  *
2118  * This contract has been substantially modified from the original and does not comply with ERC 2222.
2119  * Many functions were renamed as "rewards" rather than "funds" and the core functionality was separated
2120  * into this abstract contract which can be inherited by anything tracking ownership of reward shares.
2121  */
2122 abstract contract AbstractRewards is IAbstractRewards {
2123   using SafeCast for uint128;
2124   using SafeCast for uint256;
2125   using SafeCast for int256;
2126 
2127 /* ========  Constants  ======== */
2128   uint128 public constant POINTS_MULTIPLIER = type(uint128).max;
2129 
2130   event PointsCorrectionUpdated(address indexed account, int256 points);
2131 
2132 /* ========  Internal Function References  ======== */
2133   function(address) view returns (uint256) private immutable getSharesOf;
2134   function() view returns (uint256) private immutable getTotalShares;
2135 
2136 /* ========  Storage  ======== */
2137   uint256 public pointsPerShare;
2138   mapping(address => int256) public pointsCorrection;
2139   mapping(address => uint256) public withdrawnRewards;
2140 
2141   constructor(
2142     function(address) view returns (uint256) getSharesOf_,
2143     function() view returns (uint256) getTotalShares_
2144   ) {
2145     getSharesOf = getSharesOf_;
2146     getTotalShares = getTotalShares_;
2147   }
2148 
2149 /* ========  Public View Functions  ======== */
2150   /**
2151    * @dev Returns the total amount of rewards a given address is able to withdraw.
2152    * @param _account Address of a reward recipient
2153    * @return A uint256 representing the rewards `account` can withdraw
2154    */
2155   function withdrawableRewardsOf(address _account) public view override returns (uint256) {
2156     return cumulativeRewardsOf(_account) - withdrawnRewards[_account];
2157   }
2158 
2159   /**
2160    * @notice View the amount of rewards that an address has withdrawn.
2161    * @param _account The address of a token holder.
2162    * @return The amount of rewards that `account` has withdrawn.
2163    */
2164   function withdrawnRewardsOf(address _account) public view override returns (uint256) {
2165     return withdrawnRewards[_account];
2166   }
2167 
2168   /**
2169    * @notice View the amount of rewards that an address has earned in total.
2170    * @dev accumulativeFundsOf(account) = withdrawableRewardsOf(account) + withdrawnRewardsOf(account)
2171    * = (pointsPerShare * balanceOf(account) + pointsCorrection[account]) / POINTS_MULTIPLIER
2172    * @param _account The address of a token holder.
2173    * @return The amount of rewards that `account` has earned in total.
2174    */
2175   function cumulativeRewardsOf(address _account) public view override returns (uint256) {
2176     return ((pointsPerShare * getSharesOf(_account)).toInt256() + pointsCorrection[_account]).toUint256() / POINTS_MULTIPLIER;
2177   }
2178 
2179 /* ========  Dividend Utility Functions  ======== */
2180 
2181   /** 
2182    * @notice Distributes rewards to token holders.
2183    * @dev It reverts if the total shares is 0.
2184    * It emits the `RewardsDistributed` event if the amount to distribute is greater than 0.
2185    * About undistributed rewards:
2186    *   In each distribution, there is a small amount which does not get distributed,
2187    *   which is `(amount * POINTS_MULTIPLIER) % totalShares()`.
2188    *   With a well-chosen `POINTS_MULTIPLIER`, the amount of funds that are not getting
2189    *   distributed in a distribution can be less than 1 (base unit).
2190    */
2191   function _distributeRewards(uint256 _amount) internal {
2192     uint256 shares = getTotalShares();
2193     require(shares > 0, "AbstractRewards._distributeRewards: total share supply is zero");
2194 
2195     if (_amount > 0) {
2196       pointsPerShare = pointsPerShare + (_amount * POINTS_MULTIPLIER / shares);
2197       emit RewardsDistributed(msg.sender, _amount);
2198     }
2199   }
2200 
2201   /**
2202    * @notice Prepares collection of owed rewards
2203    * @dev It emits a `RewardsWithdrawn` event if the amount of withdrawn rewards is
2204    * greater than 0.
2205    */
2206   function _prepareCollect(address _account) internal returns (uint256) {
2207     require(_account != address(0), "AbstractRewards._prepareCollect: account cannot be zero address");
2208 
2209     uint256 _withdrawableDividend = withdrawableRewardsOf(_account);
2210     if (_withdrawableDividend > 0) {
2211       withdrawnRewards[_account] = withdrawnRewards[_account] + _withdrawableDividend;
2212       emit RewardsWithdrawn(_account, _withdrawableDividend);
2213     }
2214     return _withdrawableDividend;
2215   }
2216 
2217   function _correctPointsForTransfer(address _from, address _to, uint256 _shares) internal {
2218     require(_from != address(0), "AbstractRewards._correctPointsForTransfer: address cannot be zero address");
2219     require(_to != address(0), "AbstractRewards._correctPointsForTransfer: address cannot be zero address");
2220     require(_shares != 0, "AbstractRewards._correctPointsForTransfer: shares cannot be zero");
2221 
2222     int256 _magCorrection = (pointsPerShare * _shares).toInt256();
2223     pointsCorrection[_from] = pointsCorrection[_from] + _magCorrection;
2224     pointsCorrection[_to] = pointsCorrection[_to] - _magCorrection;
2225 
2226     emit PointsCorrectionUpdated(_from, pointsCorrection[_from]);
2227     emit PointsCorrectionUpdated(_to, pointsCorrection[_to]);
2228   }
2229 
2230   /**
2231    * @dev Increases or decreases the points correction for `account` by
2232    * `shares*pointsPerShare`.
2233    */
2234   function _correctPoints(address _account, int256 _shares) internal {
2235     require(_account != address(0), "AbstractRewards._correctPoints: account cannot be zero address");
2236     require(_shares != 0, "AbstractRewards._correctPoints: shares cannot be zero");
2237 
2238     pointsCorrection[_account] = pointsCorrection[_account] + (_shares * (pointsPerShare.toInt256()));
2239     emit PointsCorrectionUpdated(_account, pointsCorrection[_account]);
2240   }
2241 }
2242 
2243 
2244 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.4.2
2245 
2246 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
2247 
2248 pragma solidity ^0.8.0;
2249 
2250 /**
2251  * @dev External interface of AccessControl declared to support ERC165 detection.
2252  */
2253 interface IAccessControl {
2254     /**
2255      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
2256      *
2257      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
2258      * {RoleAdminChanged} not being emitted signaling this.
2259      *
2260      * _Available since v3.1._
2261      */
2262     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
2263 
2264     /**
2265      * @dev Emitted when `account` is granted `role`.
2266      *
2267      * `sender` is the account that originated the contract call, an admin role
2268      * bearer except when using {AccessControl-_setupRole}.
2269      */
2270     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
2271 
2272     /**
2273      * @dev Emitted when `account` is revoked `role`.
2274      *
2275      * `sender` is the account that originated the contract call:
2276      *   - if using `revokeRole`, it is the admin role bearer
2277      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
2278      */
2279     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
2280 
2281     /**
2282      * @dev Returns `true` if `account` has been granted `role`.
2283      */
2284     function hasRole(bytes32 role, address account) external view returns (bool);
2285 
2286     /**
2287      * @dev Returns the admin role that controls `role`. See {grantRole} and
2288      * {revokeRole}.
2289      *
2290      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
2291      */
2292     function getRoleAdmin(bytes32 role) external view returns (bytes32);
2293 
2294     /**
2295      * @dev Grants `role` to `account`.
2296      *
2297      * If `account` had not been already granted `role`, emits a {RoleGranted}
2298      * event.
2299      *
2300      * Requirements:
2301      *
2302      * - the caller must have ``role``'s admin role.
2303      */
2304     function grantRole(bytes32 role, address account) external;
2305 
2306     /**
2307      * @dev Revokes `role` from `account`.
2308      *
2309      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2310      *
2311      * Requirements:
2312      *
2313      * - the caller must have ``role``'s admin role.
2314      */
2315     function revokeRole(bytes32 role, address account) external;
2316 
2317     /**
2318      * @dev Revokes `role` from the calling account.
2319      *
2320      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2321      * purpose is to provide a mechanism for accounts to lose their privileges
2322      * if they are compromised (such as when a trusted device is misplaced).
2323      *
2324      * If the calling account had been granted `role`, emits a {RoleRevoked}
2325      * event.
2326      *
2327      * Requirements:
2328      *
2329      * - the caller must be `account`.
2330      */
2331     function renounceRole(bytes32 role, address account) external;
2332 }
2333 
2334 
2335 // File @openzeppelin/contracts/access/IAccessControlEnumerable.sol@v4.4.2
2336 
2337 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
2338 
2339 pragma solidity ^0.8.0;
2340 
2341 /**
2342  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
2343  */
2344 interface IAccessControlEnumerable is IAccessControl {
2345     /**
2346      * @dev Returns one of the accounts that have `role`. `index` must be a
2347      * value between 0 and {getRoleMemberCount}, non-inclusive.
2348      *
2349      * Role bearers are not sorted in any particular way, and their ordering may
2350      * change at any point.
2351      *
2352      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
2353      * you perform all queries on the same block. See the following
2354      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
2355      * for more information.
2356      */
2357     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
2358 
2359     /**
2360      * @dev Returns the number of accounts that have `role`. Can be used
2361      * together with {getRoleMember} to enumerate all bearers of a role.
2362      */
2363     function getRoleMemberCount(bytes32 role) external view returns (uint256);
2364 }
2365 
2366 
2367 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
2368 
2369 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2370 
2371 pragma solidity ^0.8.0;
2372 
2373 /**
2374  * @dev Interface of the ERC165 standard, as defined in the
2375  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2376  *
2377  * Implementers can declare support of contract interfaces, which can then be
2378  * queried by others ({ERC165Checker}).
2379  *
2380  * For an implementation, see {ERC165}.
2381  */
2382 interface IERC165 {
2383     /**
2384      * @dev Returns true if this contract implements the interface defined by
2385      * `interfaceId`. See the corresponding
2386      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2387      * to learn more about how these ids are created.
2388      *
2389      * This function call must use less than 30 000 gas.
2390      */
2391     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2392 }
2393 
2394 
2395 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
2396 
2397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2398 
2399 pragma solidity ^0.8.0;
2400 
2401 /**
2402  * @dev Implementation of the {IERC165} interface.
2403  *
2404  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2405  * for the additional interface id that will be supported. For example:
2406  *
2407  * ```solidity
2408  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2409  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2410  * }
2411  * ```
2412  *
2413  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2414  */
2415 abstract contract ERC165 is IERC165 {
2416     /**
2417      * @dev See {IERC165-supportsInterface}.
2418      */
2419     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2420         return interfaceId == type(IERC165).interfaceId;
2421     }
2422 }
2423 
2424 
2425 // File @openzeppelin/contracts/access/AccessControl.sol@v4.4.2
2426 
2427 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
2428 
2429 pragma solidity ^0.8.0;
2430 
2431 
2432 
2433 
2434 /**
2435  * @dev Contract module that allows children to implement role-based access
2436  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2437  * members except through off-chain means by accessing the contract event logs. Some
2438  * applications may benefit from on-chain enumerability, for those cases see
2439  * {AccessControlEnumerable}.
2440  *
2441  * Roles are referred to by their `bytes32` identifier. These should be exposed
2442  * in the external API and be unique. The best way to achieve this is by
2443  * using `public constant` hash digests:
2444  *
2445  * ```
2446  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2447  * ```
2448  *
2449  * Roles can be used to represent a set of permissions. To restrict access to a
2450  * function call, use {hasRole}:
2451  *
2452  * ```
2453  * function foo() public {
2454  *     require(hasRole(MY_ROLE, msg.sender));
2455  *     ...
2456  * }
2457  * ```
2458  *
2459  * Roles can be granted and revoked dynamically via the {grantRole} and
2460  * {revokeRole} functions. Each role has an associated admin role, and only
2461  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2462  *
2463  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2464  * that only accounts with this role will be able to grant or revoke other
2465  * roles. More complex role relationships can be created by using
2466  * {_setRoleAdmin}.
2467  *
2468  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2469  * grant and revoke this role. Extra precautions should be taken to secure
2470  * accounts that have been granted it.
2471  */
2472 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2473     struct RoleData {
2474         mapping(address => bool) members;
2475         bytes32 adminRole;
2476     }
2477 
2478     mapping(bytes32 => RoleData) private _roles;
2479 
2480     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2481 
2482     /**
2483      * @dev Modifier that checks that an account has a specific role. Reverts
2484      * with a standardized message including the required role.
2485      *
2486      * The format of the revert reason is given by the following regular expression:
2487      *
2488      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2489      *
2490      * _Available since v4.1._
2491      */
2492     modifier onlyRole(bytes32 role) {
2493         _checkRole(role, _msgSender());
2494         _;
2495     }
2496 
2497     /**
2498      * @dev See {IERC165-supportsInterface}.
2499      */
2500     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2501         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2502     }
2503 
2504     /**
2505      * @dev Returns `true` if `account` has been granted `role`.
2506      */
2507     function hasRole(bytes32 role, address account) public view override returns (bool) {
2508         return _roles[role].members[account];
2509     }
2510 
2511     /**
2512      * @dev Revert with a standard message if `account` is missing `role`.
2513      *
2514      * The format of the revert reason is given by the following regular expression:
2515      *
2516      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2517      */
2518     function _checkRole(bytes32 role, address account) internal view {
2519         if (!hasRole(role, account)) {
2520             revert(
2521                 string(
2522                     abi.encodePacked(
2523                         "AccessControl: account ",
2524                         Strings.toHexString(uint160(account), 20),
2525                         " is missing role ",
2526                         Strings.toHexString(uint256(role), 32)
2527                     )
2528                 )
2529             );
2530         }
2531     }
2532 
2533     /**
2534      * @dev Returns the admin role that controls `role`. See {grantRole} and
2535      * {revokeRole}.
2536      *
2537      * To change a role's admin, use {_setRoleAdmin}.
2538      */
2539     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
2540         return _roles[role].adminRole;
2541     }
2542 
2543     /**
2544      * @dev Grants `role` to `account`.
2545      *
2546      * If `account` had not been already granted `role`, emits a {RoleGranted}
2547      * event.
2548      *
2549      * Requirements:
2550      *
2551      * - the caller must have ``role``'s admin role.
2552      */
2553     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2554         _grantRole(role, account);
2555     }
2556 
2557     /**
2558      * @dev Revokes `role` from `account`.
2559      *
2560      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2561      *
2562      * Requirements:
2563      *
2564      * - the caller must have ``role``'s admin role.
2565      */
2566     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2567         _revokeRole(role, account);
2568     }
2569 
2570     /**
2571      * @dev Revokes `role` from the calling account.
2572      *
2573      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2574      * purpose is to provide a mechanism for accounts to lose their privileges
2575      * if they are compromised (such as when a trusted device is misplaced).
2576      *
2577      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2578      * event.
2579      *
2580      * Requirements:
2581      *
2582      * - the caller must be `account`.
2583      */
2584     function renounceRole(bytes32 role, address account) public virtual override {
2585         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2586 
2587         _revokeRole(role, account);
2588     }
2589 
2590     /**
2591      * @dev Grants `role` to `account`.
2592      *
2593      * If `account` had not been already granted `role`, emits a {RoleGranted}
2594      * event. Note that unlike {grantRole}, this function doesn't perform any
2595      * checks on the calling account.
2596      *
2597      * [WARNING]
2598      * ====
2599      * This function should only be called from the constructor when setting
2600      * up the initial roles for the system.
2601      *
2602      * Using this function in any other way is effectively circumventing the admin
2603      * system imposed by {AccessControl}.
2604      * ====
2605      *
2606      * NOTE: This function is deprecated in favor of {_grantRole}.
2607      */
2608     function _setupRole(bytes32 role, address account) internal virtual {
2609         _grantRole(role, account);
2610     }
2611 
2612     /**
2613      * @dev Sets `adminRole` as ``role``'s admin role.
2614      *
2615      * Emits a {RoleAdminChanged} event.
2616      */
2617     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2618         bytes32 previousAdminRole = getRoleAdmin(role);
2619         _roles[role].adminRole = adminRole;
2620         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2621     }
2622 
2623     /**
2624      * @dev Grants `role` to `account`.
2625      *
2626      * Internal function without access restriction.
2627      */
2628     function _grantRole(bytes32 role, address account) internal virtual {
2629         if (!hasRole(role, account)) {
2630             _roles[role].members[account] = true;
2631             emit RoleGranted(role, account, _msgSender());
2632         }
2633     }
2634 
2635     /**
2636      * @dev Revokes `role` from `account`.
2637      *
2638      * Internal function without access restriction.
2639      */
2640     function _revokeRole(bytes32 role, address account) internal virtual {
2641         if (hasRole(role, account)) {
2642             _roles[role].members[account] = false;
2643             emit RoleRevoked(role, account, _msgSender());
2644         }
2645     }
2646 }
2647 
2648 
2649 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.4.2
2650 
2651 // OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)
2652 
2653 pragma solidity ^0.8.0;
2654 
2655 /**
2656  * @dev Library for managing
2657  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2658  * types.
2659  *
2660  * Sets have the following properties:
2661  *
2662  * - Elements are added, removed, and checked for existence in constant time
2663  * (O(1)).
2664  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2665  *
2666  * ```
2667  * contract Example {
2668  *     // Add the library methods
2669  *     using EnumerableSet for EnumerableSet.AddressSet;
2670  *
2671  *     // Declare a set state variable
2672  *     EnumerableSet.AddressSet private mySet;
2673  * }
2674  * ```
2675  *
2676  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2677  * and `uint256` (`UintSet`) are supported.
2678  */
2679 library EnumerableSet {
2680     // To implement this library for multiple types with as little code
2681     // repetition as possible, we write it in terms of a generic Set type with
2682     // bytes32 values.
2683     // The Set implementation uses private functions, and user-facing
2684     // implementations (such as AddressSet) are just wrappers around the
2685     // underlying Set.
2686     // This means that we can only create new EnumerableSets for types that fit
2687     // in bytes32.
2688 
2689     struct Set {
2690         // Storage of set values
2691         bytes32[] _values;
2692         // Position of the value in the `values` array, plus 1 because index 0
2693         // means a value is not in the set.
2694         mapping(bytes32 => uint256) _indexes;
2695     }
2696 
2697     /**
2698      * @dev Add a value to a set. O(1).
2699      *
2700      * Returns true if the value was added to the set, that is if it was not
2701      * already present.
2702      */
2703     function _add(Set storage set, bytes32 value) private returns (bool) {
2704         if (!_contains(set, value)) {
2705             set._values.push(value);
2706             // The value is stored at length-1, but we add 1 to all indexes
2707             // and use 0 as a sentinel value
2708             set._indexes[value] = set._values.length;
2709             return true;
2710         } else {
2711             return false;
2712         }
2713     }
2714 
2715     /**
2716      * @dev Removes a value from a set. O(1).
2717      *
2718      * Returns true if the value was removed from the set, that is if it was
2719      * present.
2720      */
2721     function _remove(Set storage set, bytes32 value) private returns (bool) {
2722         // We read and store the value's index to prevent multiple reads from the same storage slot
2723         uint256 valueIndex = set._indexes[value];
2724 
2725         if (valueIndex != 0) {
2726             // Equivalent to contains(set, value)
2727             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2728             // the array, and then remove the last element (sometimes called as 'swap and pop').
2729             // This modifies the order of the array, as noted in {at}.
2730 
2731             uint256 toDeleteIndex = valueIndex - 1;
2732             uint256 lastIndex = set._values.length - 1;
2733 
2734             if (lastIndex != toDeleteIndex) {
2735                 bytes32 lastvalue = set._values[lastIndex];
2736 
2737                 // Move the last value to the index where the value to delete is
2738                 set._values[toDeleteIndex] = lastvalue;
2739                 // Update the index for the moved value
2740                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
2741             }
2742 
2743             // Delete the slot where the moved value was stored
2744             set._values.pop();
2745 
2746             // Delete the index for the deleted slot
2747             delete set._indexes[value];
2748 
2749             return true;
2750         } else {
2751             return false;
2752         }
2753     }
2754 
2755     /**
2756      * @dev Returns true if the value is in the set. O(1).
2757      */
2758     function _contains(Set storage set, bytes32 value) private view returns (bool) {
2759         return set._indexes[value] != 0;
2760     }
2761 
2762     /**
2763      * @dev Returns the number of values on the set. O(1).
2764      */
2765     function _length(Set storage set) private view returns (uint256) {
2766         return set._values.length;
2767     }
2768 
2769     /**
2770      * @dev Returns the value stored at position `index` in the set. O(1).
2771      *
2772      * Note that there are no guarantees on the ordering of values inside the
2773      * array, and it may change when more values are added or removed.
2774      *
2775      * Requirements:
2776      *
2777      * - `index` must be strictly less than {length}.
2778      */
2779     function _at(Set storage set, uint256 index) private view returns (bytes32) {
2780         return set._values[index];
2781     }
2782 
2783     /**
2784      * @dev Return the entire set in an array
2785      *
2786      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2787      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2788      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2789      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2790      */
2791     function _values(Set storage set) private view returns (bytes32[] memory) {
2792         return set._values;
2793     }
2794 
2795     // Bytes32Set
2796 
2797     struct Bytes32Set {
2798         Set _inner;
2799     }
2800 
2801     /**
2802      * @dev Add a value to a set. O(1).
2803      *
2804      * Returns true if the value was added to the set, that is if it was not
2805      * already present.
2806      */
2807     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2808         return _add(set._inner, value);
2809     }
2810 
2811     /**
2812      * @dev Removes a value from a set. O(1).
2813      *
2814      * Returns true if the value was removed from the set, that is if it was
2815      * present.
2816      */
2817     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
2818         return _remove(set._inner, value);
2819     }
2820 
2821     /**
2822      * @dev Returns true if the value is in the set. O(1).
2823      */
2824     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
2825         return _contains(set._inner, value);
2826     }
2827 
2828     /**
2829      * @dev Returns the number of values in the set. O(1).
2830      */
2831     function length(Bytes32Set storage set) internal view returns (uint256) {
2832         return _length(set._inner);
2833     }
2834 
2835     /**
2836      * @dev Returns the value stored at position `index` in the set. O(1).
2837      *
2838      * Note that there are no guarantees on the ordering of values inside the
2839      * array, and it may change when more values are added or removed.
2840      *
2841      * Requirements:
2842      *
2843      * - `index` must be strictly less than {length}.
2844      */
2845     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
2846         return _at(set._inner, index);
2847     }
2848 
2849     /**
2850      * @dev Return the entire set in an array
2851      *
2852      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2853      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2854      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2855      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2856      */
2857     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
2858         return _values(set._inner);
2859     }
2860 
2861     // AddressSet
2862 
2863     struct AddressSet {
2864         Set _inner;
2865     }
2866 
2867     /**
2868      * @dev Add a value to a set. O(1).
2869      *
2870      * Returns true if the value was added to the set, that is if it was not
2871      * already present.
2872      */
2873     function add(AddressSet storage set, address value) internal returns (bool) {
2874         return _add(set._inner, bytes32(uint256(uint160(value))));
2875     }
2876 
2877     /**
2878      * @dev Removes a value from a set. O(1).
2879      *
2880      * Returns true if the value was removed from the set, that is if it was
2881      * present.
2882      */
2883     function remove(AddressSet storage set, address value) internal returns (bool) {
2884         return _remove(set._inner, bytes32(uint256(uint160(value))));
2885     }
2886 
2887     /**
2888      * @dev Returns true if the value is in the set. O(1).
2889      */
2890     function contains(AddressSet storage set, address value) internal view returns (bool) {
2891         return _contains(set._inner, bytes32(uint256(uint160(value))));
2892     }
2893 
2894     /**
2895      * @dev Returns the number of values in the set. O(1).
2896      */
2897     function length(AddressSet storage set) internal view returns (uint256) {
2898         return _length(set._inner);
2899     }
2900 
2901     /**
2902      * @dev Returns the value stored at position `index` in the set. O(1).
2903      *
2904      * Note that there are no guarantees on the ordering of values inside the
2905      * array, and it may change when more values are added or removed.
2906      *
2907      * Requirements:
2908      *
2909      * - `index` must be strictly less than {length}.
2910      */
2911     function at(AddressSet storage set, uint256 index) internal view returns (address) {
2912         return address(uint160(uint256(_at(set._inner, index))));
2913     }
2914 
2915     /**
2916      * @dev Return the entire set in an array
2917      *
2918      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2919      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2920      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2921      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2922      */
2923     function values(AddressSet storage set) internal view returns (address[] memory) {
2924         bytes32[] memory store = _values(set._inner);
2925         address[] memory result;
2926 
2927         assembly {
2928             result := store
2929         }
2930 
2931         return result;
2932     }
2933 
2934     // UintSet
2935 
2936     struct UintSet {
2937         Set _inner;
2938     }
2939 
2940     /**
2941      * @dev Add a value to a set. O(1).
2942      *
2943      * Returns true if the value was added to the set, that is if it was not
2944      * already present.
2945      */
2946     function add(UintSet storage set, uint256 value) internal returns (bool) {
2947         return _add(set._inner, bytes32(value));
2948     }
2949 
2950     /**
2951      * @dev Removes a value from a set. O(1).
2952      *
2953      * Returns true if the value was removed from the set, that is if it was
2954      * present.
2955      */
2956     function remove(UintSet storage set, uint256 value) internal returns (bool) {
2957         return _remove(set._inner, bytes32(value));
2958     }
2959 
2960     /**
2961      * @dev Returns true if the value is in the set. O(1).
2962      */
2963     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
2964         return _contains(set._inner, bytes32(value));
2965     }
2966 
2967     /**
2968      * @dev Returns the number of values on the set. O(1).
2969      */
2970     function length(UintSet storage set) internal view returns (uint256) {
2971         return _length(set._inner);
2972     }
2973 
2974     /**
2975      * @dev Returns the value stored at position `index` in the set. O(1).
2976      *
2977      * Note that there are no guarantees on the ordering of values inside the
2978      * array, and it may change when more values are added or removed.
2979      *
2980      * Requirements:
2981      *
2982      * - `index` must be strictly less than {length}.
2983      */
2984     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
2985         return uint256(_at(set._inner, index));
2986     }
2987 
2988     /**
2989      * @dev Return the entire set in an array
2990      *
2991      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
2992      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
2993      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
2994      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
2995      */
2996     function values(UintSet storage set) internal view returns (uint256[] memory) {
2997         bytes32[] memory store = _values(set._inner);
2998         uint256[] memory result;
2999 
3000         assembly {
3001             result := store
3002         }
3003 
3004         return result;
3005     }
3006 }
3007 
3008 
3009 // File @openzeppelin/contracts/access/AccessControlEnumerable.sol@v4.4.2
3010 
3011 // OpenZeppelin Contracts v4.4.1 (access/AccessControlEnumerable.sol)
3012 
3013 pragma solidity ^0.8.0;
3014 
3015 
3016 
3017 /**
3018  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
3019  */
3020 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
3021     using EnumerableSet for EnumerableSet.AddressSet;
3022 
3023     mapping(bytes32 => EnumerableSet.AddressSet) private _roleMembers;
3024 
3025     /**
3026      * @dev See {IERC165-supportsInterface}.
3027      */
3028     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3029         return interfaceId == type(IAccessControlEnumerable).interfaceId || super.supportsInterface(interfaceId);
3030     }
3031 
3032     /**
3033      * @dev Returns one of the accounts that have `role`. `index` must be a
3034      * value between 0 and {getRoleMemberCount}, non-inclusive.
3035      *
3036      * Role bearers are not sorted in any particular way, and their ordering may
3037      * change at any point.
3038      *
3039      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
3040      * you perform all queries on the same block. See the following
3041      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
3042      * for more information.
3043      */
3044     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
3045         return _roleMembers[role].at(index);
3046     }
3047 
3048     /**
3049      * @dev Returns the number of accounts that have `role`. Can be used
3050      * together with {getRoleMember} to enumerate all bearers of a role.
3051      */
3052     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
3053         return _roleMembers[role].length();
3054     }
3055 
3056     /**
3057      * @dev Overload {_grantRole} to track enumerable memberships
3058      */
3059     function _grantRole(bytes32 role, address account) internal virtual override {
3060         super._grantRole(role, account);
3061         _roleMembers[role].add(account);
3062     }
3063 
3064     /**
3065      * @dev Overload {_revokeRole} to track enumerable memberships
3066      */
3067     function _revokeRole(bytes32 role, address account) internal virtual override {
3068         super._revokeRole(role, account);
3069         _roleMembers[role].remove(account);
3070     }
3071 }
3072 
3073 
3074 // File contracts/base/TokenSaver.sol
3075 
3076 pragma solidity 0.8.7;
3077 
3078 
3079 
3080 contract TokenSaver is AccessControlEnumerable {
3081     using SafeERC20 for IERC20;
3082 
3083     bytes32 public constant TOKEN_SAVER_ROLE = keccak256("TOKEN_SAVER_ROLE");
3084 
3085     event TokenSaved(address indexed by, address indexed receiver, address indexed token, uint256 amount);
3086 
3087     modifier onlyTokenSaver() {
3088         require(hasRole(TOKEN_SAVER_ROLE, _msgSender()), "TokenSaver.onlyTokenSaver: permission denied");
3089         _;
3090     }
3091 
3092     constructor() {
3093         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
3094     }
3095 
3096     function saveToken(address _token, address _receiver, uint256 _amount) external onlyTokenSaver {
3097         IERC20(_token).safeTransfer(_receiver, _amount);
3098         emit TokenSaved(_msgSender(), _receiver, _token, _amount);
3099     }
3100 
3101 }
3102 
3103 
3104 // File contracts/base/BasePool.sol
3105 
3106 pragma solidity 0.8.7;
3107 
3108 
3109 
3110 
3111 
3112 
3113 
3114 abstract contract BasePool is ERC20Votes, AbstractRewards, IBasePool, TokenSaver, ReentrancyGuard {
3115     using SafeERC20 for IERC20;
3116     using SafeCast for uint256;
3117     using SafeCast for int256;
3118 
3119     IERC20 public immutable depositToken;
3120     IERC20 public immutable rewardToken;
3121     ITimeLockPool public immutable escrowPool;
3122     uint256 public immutable escrowPortion; // how much is escrowed 1e18 == 100%
3123     uint256 public immutable escrowDuration; // escrow duration in seconds
3124 
3125     event RewardsClaimed(address indexed _from, address indexed _receiver, uint256 _escrowedAmount, uint256 _nonEscrowedAmount);
3126 
3127     constructor(
3128         string memory _name,
3129         string memory _symbol,
3130         address _depositToken,
3131         address _rewardToken,
3132         address _escrowPool,
3133         uint256 _escrowPortion,
3134         uint256 _escrowDuration
3135     ) ERC20Permit(_name) ERC20(_name, _symbol) AbstractRewards(balanceOf, totalSupply) {
3136         require(_escrowPortion <= 1e18, "BasePool.constructor: Cannot escrow more than 100%");
3137         require(_depositToken != address(0), "BasePool.constructor: Deposit token must be set");
3138         depositToken = IERC20(_depositToken);
3139         rewardToken = IERC20(_rewardToken);
3140         escrowPool = ITimeLockPool(_escrowPool);
3141         escrowPortion = _escrowPortion;
3142         escrowDuration = _escrowDuration;
3143 
3144         if(_rewardToken != address(0) && _escrowPool != address(0)) {
3145             IERC20(_rewardToken).safeApprove(_escrowPool, type(uint256).max);
3146         }
3147     }
3148 
3149     function _mint(address _account, uint256 _amount) internal virtual override {
3150 		super._mint(_account, _amount);
3151         _correctPoints(_account, -(_amount.toInt256()));
3152 	}
3153 	
3154 	function _burn(address _account, uint256 _amount) internal virtual override {
3155 		super._burn(_account, _amount);
3156         _correctPoints(_account, _amount.toInt256());
3157 	}
3158 
3159     function _transfer(address _from, address _to, uint256 _value) internal virtual override {
3160 		super._transfer(_from, _to, _value);
3161         _correctPointsForTransfer(_from, _to, _value);
3162 	}
3163 
3164     function distributeRewards(uint256 _amount) external override nonReentrant {
3165         rewardToken.safeTransferFrom(_msgSender(), address(this), _amount);
3166         _distributeRewards(_amount);
3167     }
3168 
3169     function claimRewards(address _receiver) external {
3170         uint256 rewardAmount = _prepareCollect(_msgSender());
3171         uint256 escrowedRewardAmount = rewardAmount * escrowPortion / 1e18;
3172         uint256 nonEscrowedRewardAmount = rewardAmount - escrowedRewardAmount;
3173 
3174         if(escrowedRewardAmount != 0 && address(escrowPool) != address(0)) {
3175             escrowPool.deposit(escrowedRewardAmount, escrowDuration, _receiver);
3176         }
3177 
3178         // ignore dust
3179         if(nonEscrowedRewardAmount > 1) {
3180             rewardToken.safeTransfer(_receiver, nonEscrowedRewardAmount);
3181         }
3182 
3183         emit RewardsClaimed(_msgSender(), _receiver, escrowedRewardAmount, nonEscrowedRewardAmount);
3184     }
3185 
3186 }
3187 
3188 
3189 // File contracts/TimeLockPool.sol
3190 
3191 pragma solidity 0.8.7;
3192 
3193 
3194 
3195 
3196 contract TimeLockPool is BasePool, ITimeLockPool {
3197     using Math for uint256;
3198     using SafeERC20 for IERC20;
3199 
3200     uint256 public immutable maxBonus;
3201     uint256 public immutable maxLockDuration;
3202     uint256 public constant MIN_LOCK_DURATION = 10 minutes;
3203     
3204     mapping(address => Deposit[]) public depositsOf;
3205 
3206     struct Deposit {
3207         uint256 amount;
3208         uint64 start;
3209         uint64 end;
3210     }
3211     constructor(
3212         string memory _name,
3213         string memory _symbol,
3214         address _depositToken,
3215         address _rewardToken,
3216         address _escrowPool,
3217         uint256 _escrowPortion,
3218         uint256 _escrowDuration,
3219         uint256 _maxBonus,
3220         uint256 _maxLockDuration
3221     ) BasePool(_name, _symbol, _depositToken, _rewardToken, _escrowPool, _escrowPortion, _escrowDuration) {
3222         require(_maxLockDuration >= MIN_LOCK_DURATION, "TimeLockPool.constructor: max lock duration must be greater or equal to mininmum lock duration");
3223         maxBonus = _maxBonus;
3224         maxLockDuration = _maxLockDuration;
3225     }
3226 
3227     event Deposited(uint256 amount, uint256 duration, address indexed receiver, address indexed from);
3228     event Withdrawn(uint256 indexed depositId, address indexed receiver, address indexed from, uint256 amount);
3229 
3230     function deposit(uint256 _amount, uint256 _duration, address _receiver) external override nonReentrant {
3231         require(_receiver != address(0), "TimeLockPool.deposit: receiver cannot be zero address");
3232         require(_amount > 0, "TimeLockPool.deposit: cannot deposit 0");
3233         // Don't allow locking > maxLockDuration
3234         uint256 duration = _duration.min(maxLockDuration);
3235         // Enforce min lockup duration to prevent flash loan or MEV transaction ordering
3236         duration = duration.max(MIN_LOCK_DURATION);
3237 
3238         depositToken.safeTransferFrom(_msgSender(), address(this), _amount);
3239 
3240         depositsOf[_receiver].push(Deposit({
3241             amount: _amount,
3242             start: uint64(block.timestamp),
3243             end: uint64(block.timestamp) + uint64(duration)
3244         }));
3245 
3246         uint256 mintAmount = _amount * getMultiplier(duration) / 1e18;
3247 
3248         _mint(_receiver, mintAmount);
3249         emit Deposited(_amount, duration, _receiver, _msgSender());
3250     }
3251 
3252     function withdraw(uint256 _depositId, address _receiver) external nonReentrant {
3253         require(_receiver != address(0), "TimeLockPool.withdraw: receiver cannot be zero address");
3254         require(_depositId < depositsOf[_msgSender()].length, "TimeLockPool.withdraw: Deposit does not exist");
3255         Deposit memory userDeposit = depositsOf[_msgSender()][_depositId];
3256         require(block.timestamp >= userDeposit.end, "TimeLockPool.withdraw: too soon");
3257 
3258         //                      No risk of wrapping around on casting to uint256 since deposit end always > deposit start and types are 64 bits
3259         uint256 shareAmount = userDeposit.amount * getMultiplier(uint256(userDeposit.end - userDeposit.start)) / 1e18;
3260 
3261         // remove Deposit
3262         depositsOf[_msgSender()][_depositId] = depositsOf[_msgSender()][depositsOf[_msgSender()].length - 1];
3263         depositsOf[_msgSender()].pop();
3264 
3265         // burn pool shares
3266         _burn(_msgSender(), shareAmount);
3267         
3268         // return tokens
3269         depositToken.safeTransfer(_receiver, userDeposit.amount);
3270         emit Withdrawn(_depositId, _receiver, _msgSender(), userDeposit.amount);
3271     }
3272 
3273     function getMultiplier(uint256 _lockDuration) public view returns(uint256) {
3274         return 1e18 + (maxBonus * _lockDuration / maxLockDuration);
3275     }
3276 
3277     function getTotalDeposit(address _account) public view returns(uint256) {
3278         uint256 total;
3279         for(uint256 i = 0; i < depositsOf[_account].length; i++) {
3280             total += depositsOf[_account][i].amount;
3281         }
3282 
3283         return total;
3284     }
3285 
3286     function getDepositsOf(address _account) public view returns(Deposit[] memory) {
3287         return depositsOf[_account];
3288     }
3289 
3290     function getDepositsOfLength(address _account) public view returns(uint256) {
3291         return depositsOf[_account].length;
3292     }
3293 }
3294 
3295 
3296 // File contracts/TimeLockNonTransferablePool.sol
3297 
3298 pragma solidity 0.8.7;
3299 
3300 contract TimeLockNonTransferablePool is TimeLockPool {
3301     constructor(
3302         string memory _name,
3303         string memory _symbol,
3304         address _depositToken,
3305         address _rewardToken,
3306         address _escrowPool,
3307         uint256 _escrowPortion,
3308         uint256 _escrowDuration,
3309         uint256 _maxBonus,
3310         uint256 _maxLockDuration
3311     ) TimeLockPool(_name, _symbol, _depositToken, _rewardToken, _escrowPool, _escrowPortion, _escrowDuration, _maxBonus, _maxLockDuration) {
3312 
3313     }
3314 
3315     // disable transfers
3316     function _transfer(address _from, address _to, uint256 _amount) internal override {
3317         revert("NON_TRANSFERABLE");
3318     }
3319 }