1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         (bool success, bytes memory returndata) = target.call{value: value}(data);
139         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
144      * but performing a static call.
145      *
146      * _Available since v3.3._
147      */
148     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
149         return functionStaticCall(target, data, "Address: low-level static call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal view returns (bytes memory) {
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
194      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
195      *
196      * _Available since v4.8._
197      */
198     function verifyCallResultFromTarget(
199         address target,
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal view returns (bytes memory) {
204         if (success) {
205             if (returndata.length == 0) {
206                 // only check isContract if the call was successful and the return data is empty
207                 // otherwise we already know that it was a contract
208                 require(isContract(target), "Address: call to non-contract");
209             }
210             return returndata;
211         } else {
212             _revert(returndata, errorMessage);
213         }
214     }
215 
216     /**
217      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
218      * revert reason or using the provided one.
219      *
220      * _Available since v4.3._
221      */
222     function verifyCallResult(
223         bool success,
224         bytes memory returndata,
225         string memory errorMessage
226     ) internal pure returns (bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             _revert(returndata, errorMessage);
231         }
232     }
233 
234     function _revert(bytes memory returndata, string memory errorMessage) private pure {
235         // Look for revert reason and bubble it up if present
236         if (returndata.length > 0) {
237             // The easiest way to bubble the revert reason is using memory via assembly
238             /// @solidity memory-safe-assembly
239             assembly {
240                 let returndata_size := mload(returndata)
241                 revert(add(32, returndata), returndata_size)
242             }
243         } else {
244             revert(errorMessage);
245         }
246     }
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
258  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
259  *
260  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
261  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
262  * need to send a transaction, and thus is not required to hold Ether at all.
263  */
264 interface IERC20Permit {
265     /**
266      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
267      * given ``owner``'s signed approval.
268      *
269      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
270      * ordering also apply here.
271      *
272      * Emits an {Approval} event.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      * - `deadline` must be a timestamp in the future.
278      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
279      * over the EIP712-formatted function arguments.
280      * - the signature must use ``owner``'s current nonce (see {nonces}).
281      *
282      * For more information on the signature format, see the
283      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
284      * section].
285      */
286     function permit(
287         address owner,
288         address spender,
289         uint256 value,
290         uint256 deadline,
291         uint8 v,
292         bytes32 r,
293         bytes32 s
294     ) external;
295 
296     /**
297      * @dev Returns the current nonce for `owner`. This value must be
298      * included whenever a signature is generated for {permit}.
299      *
300      * Every successful call to {permit} increases ``owner``'s nonce by one. This
301      * prevents a signature from being used multiple times.
302      */
303     function nonces(address owner) external view returns (uint256);
304 
305     /**
306      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
307      */
308     // solhint-disable-next-line func-name-mixedcase
309     function DOMAIN_SEPARATOR() external view returns (bytes32);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Interface of the ERC20 standard as defined in the EIP.
321  */
322 interface IERC20 {
323     /**
324      * @dev Returns the amount of tokens in existence.
325      */
326     function totalSupply() external view returns (uint256);
327 
328     /**
329      * @dev Returns the amount of tokens owned by `account`.
330      */
331     function balanceOf(address account) external view returns (uint256);
332 
333     /**
334      * @dev Moves `amount` tokens from the caller's account to `recipient`.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a {Transfer} event.
339      */
340     function transfer(address recipient, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Returns the remaining number of tokens that `spender` will be
344      * allowed to spend on behalf of `owner` through {transferFrom}. This is
345      * zero by default.
346      *
347      * This value changes when {approve} or {transferFrom} are called.
348      */
349     function allowance(address owner, address spender) external view returns (uint256);
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * IMPORTANT: Beware that changing an allowance with this method brings the risk
357      * that someone may use both the old and the new allowance by unfortunate
358      * transaction ordering. One possible solution to mitigate this race
359      * condition is to first reduce the spender's allowance to 0 and set the
360      * desired value afterwards:
361      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362      *
363      * Emits an {Approval} event.
364      */
365     function approve(address spender, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Moves `amount` tokens from `sender` to `recipient` using the
369      * allowance mechanism. `amount` is then deducted from the caller's
370      * allowance.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transferFrom(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) external returns (bool);
381 
382     /**
383      * @dev Emitted when `value` tokens are moved from one account (`from`) to
384      * another (`to`).
385      *
386      * Note that `value` may be zero.
387      */
388     event Transfer(address indexed from, address indexed to, uint256 value);
389 
390     /**
391      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
392      * a call to {approve}. `value` is the new allowance.
393      */
394     event Approval(address indexed owner, address indexed spender, uint256 value);
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using Address for address;
418 
419     function safeTransfer(
420         IERC20 token,
421         address to,
422         uint256 value
423     ) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
425     }
426 
427     function safeTransferFrom(
428         IERC20 token,
429         address from,
430         address to,
431         uint256 value
432     ) internal {
433         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
434     }
435 
436     /**
437      * @dev Deprecated. This function has issues similar to the ones found in
438      * {IERC20-approve}, and its usage is discouraged.
439      *
440      * Whenever possible, use {safeIncreaseAllowance} and
441      * {safeDecreaseAllowance} instead.
442      */
443     function safeApprove(
444         IERC20 token,
445         address spender,
446         uint256 value
447     ) internal {
448         // safeApprove should only be called when setting an initial allowance,
449         // or when resetting it to zero. To increase and decrease it, use
450         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
451         require(
452             (value == 0) || (token.allowance(address(this), spender) == 0),
453             "SafeERC20: approve from non-zero to non-zero allowance"
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
456     }
457 
458     function safeIncreaseAllowance(
459         IERC20 token,
460         address spender,
461         uint256 value
462     ) internal {
463         uint256 newAllowance = token.allowance(address(this), spender) + value;
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     function safeDecreaseAllowance(
468         IERC20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         unchecked {
473             uint256 oldAllowance = token.allowance(address(this), spender);
474             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
475             uint256 newAllowance = oldAllowance - value;
476             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477         }
478     }
479 
480     function safePermit(
481         IERC20Permit token,
482         address owner,
483         address spender,
484         uint256 value,
485         uint256 deadline,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) internal {
490         uint256 nonceBefore = token.nonces(owner);
491         token.permit(owner, spender, value, deadline, v, r, s);
492         uint256 nonceAfter = token.nonces(owner);
493         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
494     }
495 
496     /**
497      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
498      * on the return value: the return value is optional (but if data is returned, it must not be false).
499      * @param token The token targeted by the call.
500      * @param data The call data (encoded using abi.encode or one of its variants).
501      */
502     function _callOptionalReturn(IERC20 token, bytes memory data) private {
503         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
504         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
505         // the target address contains contract code and also asserts for success in the low-level call.
506 
507         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
508         if (returndata.length > 0) {
509             // Return data is optional
510             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/utils/Strings.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev String operations.
524  */
525 library Strings {
526     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
527 
528     /**
529      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
530      */
531     function toString(uint256 value) internal pure returns (string memory) {
532         // Inspired by OraclizeAPI's implementation - MIT licence
533         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
534 
535         if (value == 0) {
536             return "0";
537         }
538         uint256 temp = value;
539         uint256 digits;
540         while (temp != 0) {
541             digits++;
542             temp /= 10;
543         }
544         bytes memory buffer = new bytes(digits);
545         while (value != 0) {
546             digits -= 1;
547             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
548             value /= 10;
549         }
550         return string(buffer);
551     }
552 
553     /**
554      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
555      */
556     function toHexString(uint256 value) internal pure returns (string memory) {
557         if (value == 0) {
558             return "0x00";
559         }
560         uint256 temp = value;
561         uint256 length = 0;
562         while (temp != 0) {
563             length++;
564             temp >>= 8;
565         }
566         return toHexString(value, length);
567     }
568 
569     /**
570      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
571      */
572     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
573         bytes memory buffer = new bytes(2 * length + 2);
574         buffer[0] = "0";
575         buffer[1] = "x";
576         for (uint256 i = 2 * length + 1; i > 1; --i) {
577             buffer[i] = _HEX_SYMBOLS[value & 0xf];
578             value >>= 4;
579         }
580         require(value == 0, "Strings: hex length insufficient");
581         return string(buffer);
582     }
583 }
584 
585 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
586 
587 
588 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
589 
590 pragma solidity ^0.8.0;
591 
592 /**
593  * @dev Contract module that helps prevent reentrant calls to a function.
594  *
595  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
596  * available, which can be applied to functions to make sure there are no nested
597  * (reentrant) calls to them.
598  *
599  * Note that because there is a single `nonReentrant` guard, functions marked as
600  * `nonReentrant` may not call one another. This can be worked around by making
601  * those functions `private`, and then adding `external` `nonReentrant` entry
602  * points to them.
603  *
604  * TIP: If you would like to learn more about reentrancy and alternative ways
605  * to protect against it, check out our blog post
606  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
607  */
608 abstract contract ReentrancyGuard {
609     // Booleans are more expensive than uint256 or any type that takes up a full
610     // word because each write operation emits an extra SLOAD to first read the
611     // slot's contents, replace the bits taken up by the boolean, and then write
612     // back. This is the compiler's defense against contract upgrades and
613     // pointer aliasing, and it cannot be disabled.
614 
615     // The values being non-zero value makes deployment a bit more expensive,
616     // but in exchange the refund on every call to nonReentrant will be lower in
617     // amount. Since refunds are capped to a percentage of the total
618     // transaction's gas, it is best to keep them low in cases like this one, to
619     // increase the likelihood of the full refund coming into effect.
620     uint256 private constant _NOT_ENTERED = 1;
621     uint256 private constant _ENTERED = 2;
622 
623     uint256 private _status;
624 
625     constructor() {
626         _status = _NOT_ENTERED;
627     }
628 
629     /**
630      * @dev Prevents a contract from calling itself, directly or indirectly.
631      * Calling a `nonReentrant` function from another `nonReentrant`
632      * function is not supported. It is possible to prevent this from happening
633      * by making the `nonReentrant` function external, and making it call a
634      * `private` function that does the actual work.
635      */
636     modifier nonReentrant() {
637         // On the first call to nonReentrant, _notEntered will be true
638         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
639 
640         // Any calls to nonReentrant after this point will fail
641         _status = _ENTERED;
642 
643         _;
644 
645         // By storing the original value once again, a refund is triggered (see
646         // https://eips.ethereum.org/EIPS/eip-2200)
647         _status = _NOT_ENTERED;
648     }
649 }
650 
651 // File: contracts/lib/Constants.sol
652 
653 
654 pragma solidity ^0.8.13;
655 
656 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
657 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
658 // File: contracts/IOperatorFilterRegistry.sol
659 
660 
661 pragma solidity ^0.8.13;
662 
663 interface IOperatorFilterRegistry {
664     /**
665      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
666      *         true if supplied registrant address is not registered.
667      */
668     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
669 
670     /**
671      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
672      */
673     function register(address registrant) external;
674 
675     /**
676      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
677      */
678     function registerAndSubscribe(address registrant, address subscription) external;
679 
680     /**
681      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
682      *         address without subscribing.
683      */
684     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
685 
686     /**
687      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
688      *         Note that this does not remove any filtered addresses or codeHashes.
689      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
690      */
691     function unregister(address addr) external;
692 
693     /**
694      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
695      */
696     function updateOperator(address registrant, address operator, bool filtered) external;
697 
698     /**
699      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
700      */
701     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
702 
703     /**
704      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
705      */
706     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
707 
708     /**
709      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
710      */
711     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
712 
713     /**
714      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
715      *         subscription if present.
716      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
717      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
718      *         used.
719      */
720     function subscribe(address registrant, address registrantToSubscribe) external;
721 
722     /**
723      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
724      */
725     function unsubscribe(address registrant, bool copyExistingEntries) external;
726 
727     /**
728      * @notice Get the subscription address of a given registrant, if any.
729      */
730     function subscriptionOf(address addr) external returns (address registrant);
731 
732     /**
733      * @notice Get the set of addresses subscribed to a given registrant.
734      *         Note that order is not guaranteed as updates are made.
735      */
736     function subscribers(address registrant) external returns (address[] memory);
737 
738     /**
739      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
740      *         Note that order is not guaranteed as updates are made.
741      */
742     function subscriberAt(address registrant, uint256 index) external returns (address);
743 
744     /**
745      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
746      */
747     function copyEntriesOf(address registrant, address registrantToCopy) external;
748 
749     /**
750      * @notice Returns true if operator is filtered by a given address or its subscription.
751      */
752     function isOperatorFiltered(address registrant, address operator) external returns (bool);
753 
754     /**
755      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
756      */
757     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
758 
759     /**
760      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
761      */
762     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
763 
764     /**
765      * @notice Returns a list of filtered operators for a given address or its subscription.
766      */
767     function filteredOperators(address addr) external returns (address[] memory);
768 
769     /**
770      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
771      *         Note that order is not guaranteed as updates are made.
772      */
773     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
774 
775     /**
776      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
777      *         its subscription.
778      *         Note that order is not guaranteed as updates are made.
779      */
780     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
781 
782     /**
783      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
784      *         its subscription.
785      *         Note that order is not guaranteed as updates are made.
786      */
787     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
788 
789     /**
790      * @notice Returns true if an address has registered
791      */
792     function isRegistered(address addr) external returns (bool);
793 
794     /**
795      * @dev Convenience method to compute the code hash of an arbitrary contract
796      */
797     function codeHashOf(address addr) external returns (bytes32);
798 }
799 // File: contracts/OperatorFilterer.sol
800 
801 
802 pragma solidity ^0.8.13;
803 
804 
805 /**
806  * @title  OperatorFilterer
807  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
808  *         registrant's entries in the OperatorFilterRegistry.
809  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
810  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
811  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
812  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
813  *         administration methods on the contract itself to interact with the registry otherwise the subscription
814  *         will be locked to the options set during construction.
815  */
816 
817 abstract contract OperatorFilterer {
818     /// @dev Emitted when an operator is not allowed.
819     error OperatorNotAllowed(address operator);
820 
821     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
822         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
823 
824     /// @dev The constructor that is called when the contract is being deployed.
825     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
826         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
827         // will not revert, but the contract will need to be registered with the registry once it is deployed in
828         // order for the modifier to filter addresses.
829         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
830             if (subscribe) {
831                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
832             } else {
833                 if (subscriptionOrRegistrantToCopy != address(0)) {
834                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
835                 } else {
836                     OPERATOR_FILTER_REGISTRY.register(address(this));
837                 }
838             }
839         }
840     }
841 
842     /**
843      * @dev A helper function to check if an operator is allowed.
844      */
845     modifier onlyAllowedOperator(address from) virtual {
846         // Allow spending tokens from addresses with balance
847         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
848         // from an EOA.
849         if (from != msg.sender) {
850             _checkFilterOperator(msg.sender);
851         }
852         _;
853     }
854 
855     /**
856      * @dev A helper function to check if an operator approval is allowed.
857      */
858     modifier onlyAllowedOperatorApproval(address operator) virtual {
859         _checkFilterOperator(operator);
860         _;
861     }
862 
863     /**
864      * @dev A helper function to check if an operator is allowed.
865      */
866     function _checkFilterOperator(address operator) internal view virtual {
867         // Check registry code length to facilitate testing in environments without a deployed registry.
868         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
869             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
870             // may specify their own OperatorFilterRegistry implementations, which may behave differently
871             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
872                 revert OperatorNotAllowed(operator);
873             }
874         }
875     }
876 }
877 // File: contracts/DefaultOperatorFilterer.sol
878 
879 
880 pragma solidity ^0.8.13;
881 
882 
883 /**
884  * @title  DefaultOperatorFilterer
885  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
886  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
887  *         administration methods on the contract itself to interact with the registry otherwise the subscription
888  *         will be locked to the options set during construction.
889  */
890 
891 abstract contract DefaultOperatorFilterer is OperatorFilterer {
892     /// @dev The constructor that is called when the contract is being deployed.
893     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
894 }
895 // File: @openzeppelin/contracts/utils/Context.sol
896 
897 
898 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 /**
903  * @dev Provides information about the current execution context, including the
904  * sender of the transaction and its data. While these are generally available
905  * via msg.sender and msg.data, they should not be accessed in such a direct
906  * manner, since when dealing with meta-transactions the account sending and
907  * paying for execution may not be the actual sender (as far as an application
908  * is concerned).
909  *
910  * This contract is only required for intermediate, library-like contracts.
911  */
912 abstract contract Context {
913     function _msgSender() internal view virtual returns (address) {
914         return msg.sender;
915     }
916 
917     function _msgData() internal view virtual returns (bytes calldata) {
918         return msg.data;
919     }
920 }
921 
922 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
923 
924 
925 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 
931 
932 /**
933  * @title PaymentSplitter
934  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
935  * that the Ether will be split in this way, since it is handled transparently by the contract.
936  *
937  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
938  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
939  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
940  * time of contract deployment and can't be updated thereafter.
941  *
942  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
943  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
944  * function.
945  *
946  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
947  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
948  * to run tests before sending real value to this contract.
949  */
950 contract PaymentSplitter is Context {
951     event PayeeAdded(address account, uint256 shares);
952     event PaymentReleased(address to, uint256 amount);
953     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
954     event PaymentReceived(address from, uint256 amount);
955 
956     uint256 private _totalShares;
957     uint256 private _totalReleased;
958 
959     mapping(address => uint256) private _shares;
960     mapping(address => uint256) private _released;
961     address[] private _payees;
962 
963     mapping(IERC20 => uint256) private _erc20TotalReleased;
964     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
965 
966     /**
967      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
968      * the matching position in the `shares` array.
969      *
970      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
971      * duplicates in `payees`.
972      */
973     constructor(address[] memory payees, uint256[] memory shares_) payable {
974         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
975         require(payees.length > 0, "PaymentSplitter: no payees");
976 
977         for (uint256 i = 0; i < payees.length; i++) {
978             _addPayee(payees[i], shares_[i]);
979         }
980     }
981 
982     /**
983      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
984      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
985      * reliability of the events, and not the actual splitting of Ether.
986      *
987      * To learn more about this see the Solidity documentation for
988      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
989      * functions].
990      */
991     receive() external payable virtual {
992         emit PaymentReceived(_msgSender(), msg.value);
993     }
994 
995     /**
996      * @dev Getter for the total shares held by payees.
997      */
998     function totalShares() public view returns (uint256) {
999         return _totalShares;
1000     }
1001 
1002     /**
1003      * @dev Getter for the total amount of Ether already released.
1004      */
1005     function totalReleased() public view returns (uint256) {
1006         return _totalReleased;
1007     }
1008 
1009     /**
1010      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1011      * contract.
1012      */
1013     function totalReleased(IERC20 token) public view returns (uint256) {
1014         return _erc20TotalReleased[token];
1015     }
1016 
1017     /**
1018      * @dev Getter for the amount of shares held by an account.
1019      */
1020     function shares(address account) public view returns (uint256) {
1021         return _shares[account];
1022     }
1023 
1024     /**
1025      * @dev Getter for the amount of Ether already released to a payee.
1026      */
1027     function released(address account) public view returns (uint256) {
1028         return _released[account];
1029     }
1030 
1031     /**
1032      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1033      * IERC20 contract.
1034      */
1035     function released(IERC20 token, address account) public view returns (uint256) {
1036         return _erc20Released[token][account];
1037     }
1038 
1039     /**
1040      * @dev Getter for the address of the payee number `index`.
1041      */
1042     function payee(uint256 index) public view returns (address) {
1043         return _payees[index];
1044     }
1045 
1046     /**
1047      * @dev Getter for the amount of payee's releasable Ether.
1048      */
1049     function releasable(address account) public view returns (uint256) {
1050         uint256 totalReceived = address(this).balance + totalReleased();
1051         return _pendingPayment(account, totalReceived, released(account));
1052     }
1053 
1054     /**
1055      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1056      * IERC20 contract.
1057      */
1058     function releasable(IERC20 token, address account) public view returns (uint256) {
1059         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1060         return _pendingPayment(account, totalReceived, released(token, account));
1061     }
1062 
1063     /**
1064      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1065      * total shares and their previous withdrawals.
1066      */
1067     function release(address payable account) public virtual {
1068         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1069 
1070         uint256 payment = releasable(account);
1071 
1072         require(payment != 0, "PaymentSplitter: account is not due payment");
1073 
1074         // _totalReleased is the sum of all values in _released.
1075         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
1076         _totalReleased += payment;
1077         unchecked {
1078             _released[account] += payment;
1079         }
1080 
1081         Address.sendValue(account, payment);
1082         emit PaymentReleased(account, payment);
1083     }
1084 
1085     /**
1086      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1087      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1088      * contract.
1089      */
1090     function release(IERC20 token, address account) public virtual {
1091         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1092 
1093         uint256 payment = releasable(token, account);
1094 
1095         require(payment != 0, "PaymentSplitter: account is not due payment");
1096 
1097         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
1098         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
1099         // cannot overflow.
1100         _erc20TotalReleased[token] += payment;
1101         unchecked {
1102             _erc20Released[token][account] += payment;
1103         }
1104 
1105         SafeERC20.safeTransfer(token, account, payment);
1106         emit ERC20PaymentReleased(token, account, payment);
1107     }
1108 
1109     /**
1110      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1111      * already released amounts.
1112      */
1113     function _pendingPayment(
1114         address account,
1115         uint256 totalReceived,
1116         uint256 alreadyReleased
1117     ) private view returns (uint256) {
1118         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1119     }
1120 
1121     /**
1122      * @dev Add a new payee to the contract.
1123      * @param account The address of the payee to add.
1124      * @param shares_ The number of shares owned by the payee.
1125      */
1126     function _addPayee(address account, uint256 shares_) private {
1127         require(account != address(0), "PaymentSplitter: account is the zero address");
1128         require(shares_ > 0, "PaymentSplitter: shares are 0");
1129         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1130 
1131         _payees.push(account);
1132         _shares[account] = shares_;
1133         _totalShares = _totalShares + shares_;
1134         emit PayeeAdded(account, shares_);
1135     }
1136 }
1137 
1138 // File: @openzeppelin/contracts/access/Ownable.sol
1139 
1140 
1141 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1142 
1143 pragma solidity ^0.8.0;
1144 
1145 
1146 /**
1147  * @dev Contract module which provides a basic access control mechanism, where
1148  * there is an account (an owner) that can be granted exclusive access to
1149  * specific functions.
1150  *
1151  * By default, the owner account will be the one that deploys the contract. This
1152  * can later be changed with {transferOwnership}.
1153  *
1154  * This module is used through inheritance. It will make available the modifier
1155  * `onlyOwner`, which can be applied to your functions to restrict their use to
1156  * the owner.
1157  */
1158 abstract contract Ownable is Context {
1159     address private _owner;
1160 
1161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1162 
1163     /**
1164      * @dev Initializes the contract setting the deployer as the initial owner.
1165      */
1166     constructor() {
1167         _transferOwnership(_msgSender());
1168     }
1169 
1170     /**
1171      * @dev Throws if called by any account other than the owner.
1172      */
1173     modifier onlyOwner() {
1174         _checkOwner();
1175         _;
1176     }
1177 
1178     /**
1179      * @dev Returns the address of the current owner.
1180      */
1181     function owner() public view virtual returns (address) {
1182         return _owner;
1183     }
1184 
1185     /**
1186      * @dev Throws if the sender is not the owner.
1187      */
1188     function _checkOwner() internal view virtual {
1189         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1190     }
1191 
1192     /**
1193      * @dev Leaves the contract without owner. It will not be possible to call
1194      * `onlyOwner` functions anymore. Can only be called by the current owner.
1195      *
1196      * NOTE: Renouncing ownership will leave the contract without an owner,
1197      * thereby removing any functionality that is only available to the owner.
1198      */
1199     function renounceOwnership() public virtual onlyOwner {
1200         _transferOwnership(address(0));
1201     }
1202 
1203     /**
1204      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1205      * Can only be called by the current owner.
1206      */
1207     function transferOwnership(address newOwner) public virtual onlyOwner {
1208         require(newOwner != address(0), "Ownable: new owner is the zero address");
1209         _transferOwnership(newOwner);
1210     }
1211 
1212     /**
1213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1214      * Internal function without access restriction.
1215      */
1216     function _transferOwnership(address newOwner) internal virtual {
1217         address oldOwner = _owner;
1218         _owner = newOwner;
1219         emit OwnershipTransferred(oldOwner, newOwner);
1220     }
1221 }
1222 
1223 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1224 
1225 
1226 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1227 
1228 pragma solidity ^0.8.0;
1229 
1230 /**
1231  * @dev Interface of the ERC165 standard, as defined in the
1232  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1233  *
1234  * Implementers can declare support of contract interfaces, which can then be
1235  * queried by others ({ERC165Checker}).
1236  *
1237  * For an implementation, see {ERC165}.
1238  */
1239 interface IERC165 {
1240     /**
1241      * @dev Returns true if this contract implements the interface defined by
1242      * `interfaceId`. See the corresponding
1243      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1244      * to learn more about how these ids are created.
1245      *
1246      * This function call must use less than 30 000 gas.
1247      */
1248     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1249 }
1250 
1251 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1252 
1253 
1254 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 /**
1260  * @dev Implementation of the {IERC165} interface.
1261  *
1262  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1263  * for the additional interface id that will be supported. For example:
1264  *
1265  * ```solidity
1266  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1267  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1268  * }
1269  * ```
1270  *
1271  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1272  */
1273 abstract contract ERC165 is IERC165 {
1274     /**
1275      * @dev See {IERC165-supportsInterface}.
1276      */
1277     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1278         return interfaceId == type(IERC165).interfaceId;
1279     }
1280 }
1281 
1282 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1283 
1284 
1285 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1286 
1287 pragma solidity ^0.8.0;
1288 
1289 
1290 /**
1291  * @dev Interface for the NFT Royalty Standard.
1292  *
1293  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1294  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1295  *
1296  * _Available since v4.5._
1297  */
1298 interface IERC2981 is IERC165 {
1299     /**
1300      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1301      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1302      */
1303     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1304         external
1305         view
1306         returns (address receiver, uint256 royaltyAmount);
1307 }
1308 
1309 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1310 
1311 
1312 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 /**
1319  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1320  *
1321  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1322  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1323  *
1324  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1325  * fee is specified in basis points by default.
1326  *
1327  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1328  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1329  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1330  *
1331  * _Available since v4.5._
1332  */
1333 abstract contract ERC2981 is IERC2981, ERC165 {
1334     struct RoyaltyInfo {
1335         address receiver;
1336         uint96 royaltyFraction;
1337     }
1338 
1339     RoyaltyInfo private _defaultRoyaltyInfo;
1340     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1341 
1342     /**
1343      * @dev See {IERC165-supportsInterface}.
1344      */
1345     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1346         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1347     }
1348 
1349     /**
1350      * @inheritdoc IERC2981
1351      */
1352     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1353         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1354 
1355         if (royalty.receiver == address(0)) {
1356             royalty = _defaultRoyaltyInfo;
1357         }
1358 
1359         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1360 
1361         return (royalty.receiver, royaltyAmount);
1362     }
1363 
1364     /**
1365      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1366      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1367      * override.
1368      */
1369     function _feeDenominator() internal pure virtual returns (uint96) {
1370         return 10000;
1371     }
1372 
1373     /**
1374      * @dev Sets the royalty information that all ids in this contract will default to.
1375      *
1376      * Requirements:
1377      *
1378      * - `receiver` cannot be the zero address.
1379      * - `feeNumerator` cannot be greater than the fee denominator.
1380      */
1381     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1382         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1383         require(receiver != address(0), "ERC2981: invalid receiver");
1384 
1385         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1386     }
1387 
1388     /**
1389      * @dev Removes default royalty information.
1390      */
1391     function _deleteDefaultRoyalty() internal virtual {
1392         delete _defaultRoyaltyInfo;
1393     }
1394 
1395     /**
1396      * @dev Sets the royalty information for a specific token id, overriding the global default.
1397      *
1398      * Requirements:
1399      *
1400      * - `receiver` cannot be the zero address.
1401      * - `feeNumerator` cannot be greater than the fee denominator.
1402      */
1403     function _setTokenRoyalty(
1404         uint256 tokenId,
1405         address receiver,
1406         uint96 feeNumerator
1407     ) internal virtual {
1408         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1409         require(receiver != address(0), "ERC2981: Invalid parameters");
1410 
1411         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1412     }
1413 
1414     /**
1415      * @dev Resets royalty information for the token id back to the global default.
1416      */
1417     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1418         delete _tokenRoyaltyInfo[tokenId];
1419     }
1420 }
1421 
1422 // File: contracts/IERC721A.sol
1423 
1424 
1425 // ERC721A Contracts v4.2.3
1426 // Creator: Chiru Labs
1427 
1428 pragma solidity ^0.8.4;
1429 
1430 /**
1431  * @dev Interface of ERC721A.
1432  */
1433 interface IERC721A {
1434     /**
1435      * The caller must own the token or be an approved operator.
1436      */
1437     error ApprovalCallerNotOwnerNorApproved();
1438 
1439     /**
1440      * The token does not exist.
1441      */
1442     error ApprovalQueryForNonexistentToken();
1443 
1444     /**
1445      * Cannot query the balance for the zero address.
1446      */
1447     error BalanceQueryForZeroAddress();
1448 
1449     /**
1450      * Cannot mint to the zero address.
1451      */
1452     error MintToZeroAddress();
1453 
1454     /**
1455      * The quantity of tokens minted must be more than zero.
1456      */
1457     error MintZeroQuantity();
1458 
1459     /**
1460      * The token does not exist.
1461      */
1462     error OwnerQueryForNonexistentToken();
1463 
1464     /**
1465      * The caller must own the token or be an approved operator.
1466      */
1467     error TransferCallerNotOwnerNorApproved();
1468 
1469     /**
1470      * The token must be owned by `from`.
1471      */
1472     error TransferFromIncorrectOwner();
1473 
1474     /**
1475      * Cannot safely transfer to a contract that does not implement the
1476      * ERC721Receiver interface.
1477      */
1478     error TransferToNonERC721ReceiverImplementer();
1479 
1480     /**
1481      * Cannot transfer to the zero address.
1482      */
1483     error TransferToZeroAddress();
1484 
1485     /**
1486      * The token does not exist.
1487      */
1488     error URIQueryForNonexistentToken();
1489 
1490     /**
1491      * The `quantity` minted with ERC2309 exceeds the safety limit.
1492      */
1493     error MintERC2309QuantityExceedsLimit();
1494 
1495     /**
1496      * The `extraData` cannot be set on an unintialized ownership slot.
1497      */
1498     error OwnershipNotInitializedForExtraData();
1499 
1500     // =============================================================
1501     //                            STRUCTS
1502     // =============================================================
1503 
1504     struct TokenOwnership {
1505         // The address of the owner.
1506         address addr;
1507         // Stores the start time of ownership with minimal overhead for tokenomics.
1508         uint64 startTimestamp;
1509         // Whether the token has been burned.
1510         bool burned;
1511         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1512         uint24 extraData;
1513     }
1514 
1515     // =============================================================
1516     //                         TOKEN COUNTERS
1517     // =============================================================
1518 
1519     /**
1520      * @dev Returns the total number of tokens in existence.
1521      * Burned tokens will reduce the count.
1522      * To get the total number of tokens minted, please see {_totalMinted}.
1523      */
1524     function totalSupply() external view returns (uint256);
1525 
1526     // =============================================================
1527     //                            IERC165
1528     // =============================================================
1529 
1530     /**
1531      * @dev Returns true if this contract implements the interface defined by
1532      * `interfaceId`. See the corresponding
1533      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1534      * to learn more about how these ids are created.
1535      *
1536      * This function call must use less than 30000 gas.
1537      */
1538     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1539 
1540     // =============================================================
1541     //                            IERC721
1542     // =============================================================
1543 
1544     /**
1545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1546      */
1547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1548 
1549     /**
1550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1551      */
1552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1553 
1554     /**
1555      * @dev Emitted when `owner` enables or disables
1556      * (`approved`) `operator` to manage all of its assets.
1557      */
1558     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1559 
1560     /**
1561      * @dev Returns the number of tokens in `owner`'s account.
1562      */
1563     function balanceOf(address owner) external view returns (uint256 balance);
1564 
1565     /**
1566      * @dev Returns the owner of the `tokenId` token.
1567      *
1568      * Requirements:
1569      *
1570      * - `tokenId` must exist.
1571      */
1572     function ownerOf(uint256 tokenId) external view returns (address owner);
1573 
1574     /**
1575      * @dev Safely transfers `tokenId` token from `from` to `to`,
1576      * checking first that contract recipients are aware of the ERC721 protocol
1577      * to prevent tokens from being forever locked.
1578      *
1579      * Requirements:
1580      *
1581      * - `from` cannot be the zero address.
1582      * - `to` cannot be the zero address.
1583      * - `tokenId` token must exist and be owned by `from`.
1584      * - If the caller is not `from`, it must be have been allowed to move
1585      * this token by either {approve} or {setApprovalForAll}.
1586      * - If `to` refers to a smart contract, it must implement
1587      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1588      *
1589      * Emits a {Transfer} event.
1590      */
1591     function safeTransferFrom(
1592         address from,
1593         address to,
1594         uint256 tokenId,
1595         bytes calldata data
1596     ) external payable;
1597 
1598     /**
1599      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1600      */
1601     function safeTransferFrom(
1602         address from,
1603         address to,
1604         uint256 tokenId
1605     ) external payable;
1606 
1607     /**
1608      * @dev Transfers `tokenId` from `from` to `to`.
1609      *
1610      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1611      * whenever possible.
1612      *
1613      * Requirements:
1614      *
1615      * - `from` cannot be the zero address.
1616      * - `to` cannot be the zero address.
1617      * - `tokenId` token must be owned by `from`.
1618      * - If the caller is not `from`, it must be approved to move this token
1619      * by either {approve} or {setApprovalForAll}.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function transferFrom(
1624         address from,
1625         address to,
1626         uint256 tokenId
1627     ) external payable;
1628 
1629     /**
1630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1631      * The approval is cleared when the token is transferred.
1632      *
1633      * Only a single account can be approved at a time, so approving the
1634      * zero address clears previous approvals.
1635      *
1636      * Requirements:
1637      *
1638      * - The caller must own the token or be an approved operator.
1639      * - `tokenId` must exist.
1640      *
1641      * Emits an {Approval} event.
1642      */
1643     function approve(address to, uint256 tokenId) external payable;
1644 
1645     /**
1646      * @dev Approve or remove `operator` as an operator for the caller.
1647      * Operators can call {transferFrom} or {safeTransferFrom}
1648      * for any token owned by the caller.
1649      *
1650      * Requirements:
1651      *
1652      * - The `operator` cannot be the caller.
1653      *
1654      * Emits an {ApprovalForAll} event.
1655      */
1656     function setApprovalForAll(address operator, bool _approved) external;
1657 
1658     /**
1659      * @dev Returns the account approved for `tokenId` token.
1660      *
1661      * Requirements:
1662      *
1663      * - `tokenId` must exist.
1664      */
1665     function getApproved(uint256 tokenId) external view returns (address operator);
1666 
1667     /**
1668      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1669      *
1670      * See {setApprovalForAll}.
1671      */
1672     function isApprovedForAll(address owner, address operator) external view returns (bool);
1673 
1674     // =============================================================
1675     //                        IERC721Metadata
1676     // =============================================================
1677 
1678     /**
1679      * @dev Returns the token collection name.
1680      */
1681     function name() external view returns (string memory);
1682 
1683     /**
1684      * @dev Returns the token collection symbol.
1685      */
1686     function symbol() external view returns (string memory);
1687 
1688     /**
1689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1690      */
1691     function tokenURI(uint256 tokenId) external view returns (string memory);
1692 
1693     // =============================================================
1694     //                           IERC2309
1695     // =============================================================
1696 
1697     /**
1698      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1699      * (inclusive) is transferred from `from` to `to`, as defined in the
1700      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1701      *
1702      * See {_mintERC2309} for more details.
1703      */
1704     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1705 }
1706 // File: contracts/ERC721A.sol
1707 
1708 
1709 // ERC721A Contracts v4.2.3
1710 // Creator: Chiru Labs
1711 
1712 pragma solidity ^0.8.4;
1713 
1714 
1715 /**
1716  * @dev Interface of ERC721 token receiver.
1717  */
1718 interface ERC721A__IERC721Receiver {
1719     function onERC721Received(
1720         address operator,
1721         address from,
1722         uint256 tokenId,
1723         bytes calldata data
1724     ) external returns (bytes4);
1725 }
1726 
1727 /**
1728  * @title ERC721A
1729  *
1730  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1731  * Non-Fungible Token Standard, including the Metadata extension.
1732  * Optimized for lower gas during batch mints.
1733  *
1734  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1735  * starting from `_startTokenId()`.
1736  *
1737  * Assumptions:
1738  *
1739  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1740  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1741  */
1742 contract ERC721A is IERC721A {
1743     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1744     struct TokenApprovalRef {
1745         address value;
1746     }
1747 
1748     // =============================================================
1749     //                           CONSTANTS
1750     // =============================================================
1751 
1752     // Mask of an entry in packed address data.
1753     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1754 
1755     // The bit position of `numberMinted` in packed address data.
1756     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1757 
1758     // The bit position of `numberBurned` in packed address data.
1759     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1760 
1761     // The bit position of `aux` in packed address data.
1762     uint256 private constant _BITPOS_AUX = 192;
1763 
1764     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1765     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1766 
1767     // The bit position of `startTimestamp` in packed ownership.
1768     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1769 
1770     // The bit mask of the `burned` bit in packed ownership.
1771     uint256 private constant _BITMASK_BURNED = 1 << 224;
1772 
1773     // The bit position of the `nextInitialized` bit in packed ownership.
1774     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1775 
1776     // The bit mask of the `nextInitialized` bit in packed ownership.
1777     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1778 
1779     // The bit position of `extraData` in packed ownership.
1780     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1781 
1782     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1783     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1784 
1785     // The mask of the lower 160 bits for addresses.
1786     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1787 
1788     // The maximum `quantity` that can be minted with {_mintERC2309}.
1789     // This limit is to prevent overflows on the address data entries.
1790     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1791     // is required to cause an overflow, which is unrealistic.
1792     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1793 
1794     // The `Transfer` event signature is given by:
1795     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1796     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1797         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1798 
1799     // =============================================================
1800     //                            STORAGE
1801     // =============================================================
1802 
1803     // The next token ID to be minted.
1804     uint256 private _currentIndex;
1805 
1806     // The number of tokens burned.
1807     uint256 private _burnCounter;
1808 
1809     // Token name
1810     string private _name;
1811 
1812     // Token symbol
1813     string private _symbol;
1814 
1815     // Mapping from token ID to ownership details
1816     // An empty struct value does not necessarily mean the token is unowned.
1817     // See {_packedOwnershipOf} implementation for details.
1818     //
1819     // Bits Layout:
1820     // - [0..159]   `addr`
1821     // - [160..223] `startTimestamp`
1822     // - [224]      `burned`
1823     // - [225]      `nextInitialized`
1824     // - [232..255] `extraData`
1825     mapping(uint256 => uint256) private _packedOwnerships;
1826 
1827     // Mapping owner address to address data.
1828     //
1829     // Bits Layout:
1830     // - [0..63]    `balance`
1831     // - [64..127]  `numberMinted`
1832     // - [128..191] `numberBurned`
1833     // - [192..255] `aux`
1834     mapping(address => uint256) private _packedAddressData;
1835 
1836     // Mapping from token ID to approved address.
1837     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1838 
1839     // Mapping from owner to operator approvals
1840     mapping(address => mapping(address => bool)) private _operatorApprovals;
1841 
1842     // =============================================================
1843     //                          CONSTRUCTOR
1844     // =============================================================
1845 
1846     constructor(string memory name_, string memory symbol_) {
1847         _name = name_;
1848         _symbol = symbol_;
1849         _currentIndex = _startTokenId();
1850     }
1851 
1852     // =============================================================
1853     //                   TOKEN COUNTING OPERATIONS
1854     // =============================================================
1855 
1856     /**
1857      * @dev Returns the starting token ID.
1858      * To change the starting token ID, please override this function.
1859      */
1860     function _startTokenId() internal view virtual returns (uint256) {
1861         return 0;
1862     }
1863 
1864     /**
1865      * @dev Returns the next token ID to be minted.
1866      */
1867     function _nextTokenId() internal view virtual returns (uint256) {
1868         return _currentIndex;
1869     }
1870 
1871     /**
1872      * @dev Returns the total number of tokens in existence.
1873      * Burned tokens will reduce the count.
1874      * To get the total number of tokens minted, please see {_totalMinted}.
1875      */
1876     function totalSupply() public view virtual override returns (uint256) {
1877         // Counter underflow is impossible as _burnCounter cannot be incremented
1878         // more than `_currentIndex - _startTokenId()` times.
1879         unchecked {
1880             return _currentIndex - _burnCounter - _startTokenId();
1881         }
1882     }
1883 
1884     /**
1885      * @dev Returns the total amount of tokens minted in the contract.
1886      */
1887     function _totalMinted() internal view virtual returns (uint256) {
1888         // Counter underflow is impossible as `_currentIndex` does not decrement,
1889         // and it is initialized to `_startTokenId()`.
1890         unchecked {
1891             return _currentIndex - _startTokenId();
1892         }
1893     }
1894 
1895     /**
1896      * @dev Returns the total number of tokens burned.
1897      */
1898     function _totalBurned() internal view virtual returns (uint256) {
1899         return _burnCounter;
1900     }
1901 
1902     // =============================================================
1903     //                    ADDRESS DATA OPERATIONS
1904     // =============================================================
1905 
1906     /**
1907      * @dev Returns the number of tokens in `owner`'s account.
1908      */
1909     function balanceOf(address owner) public view virtual override returns (uint256) {
1910         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1911         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1912     }
1913 
1914     /**
1915      * Returns the number of tokens minted by `owner`.
1916      */
1917     function _numberMinted(address owner) internal view returns (uint256) {
1918         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1919     }
1920 
1921     /**
1922      * Returns the number of tokens burned by or on behalf of `owner`.
1923      */
1924     function _numberBurned(address owner) internal view returns (uint256) {
1925         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1926     }
1927 
1928     /**
1929      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1930      */
1931     function _getAux(address owner) internal view returns (uint64) {
1932         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1933     }
1934 
1935     /**
1936      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1937      * If there are multiple variables, please pack them into a uint64.
1938      */
1939     function _setAux(address owner, uint64 aux) internal virtual {
1940         uint256 packed = _packedAddressData[owner];
1941         uint256 auxCasted;
1942         // Cast `aux` with assembly to avoid redundant masking.
1943         assembly {
1944             auxCasted := aux
1945         }
1946         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1947         _packedAddressData[owner] = packed;
1948     }
1949 
1950     // =============================================================
1951     //                            IERC165
1952     // =============================================================
1953 
1954     /**
1955      * @dev Returns true if this contract implements the interface defined by
1956      * `interfaceId`. See the corresponding
1957      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1958      * to learn more about how these ids are created.
1959      *
1960      * This function call must use less than 30000 gas.
1961      */
1962     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1963         // The interface IDs are constants representing the first 4 bytes
1964         // of the XOR of all function selectors in the interface.
1965         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1966         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1967         return
1968             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1969             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1970             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1971     }
1972 
1973     // =============================================================
1974     //                        IERC721Metadata
1975     // =============================================================
1976 
1977     /**
1978      * @dev Returns the token collection name.
1979      */
1980     function name() public view virtual override returns (string memory) {
1981         return _name;
1982     }
1983 
1984     /**
1985      * @dev Returns the token collection symbol.
1986      */
1987     function symbol() public view virtual override returns (string memory) {
1988         return _symbol;
1989     }
1990 
1991     /**
1992      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1993      */
1994     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1995         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1996 
1997         string memory baseURI = _baseURI();
1998         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1999     }
2000 
2001     /**
2002      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2003      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2004      * by default, it can be overridden in child contracts.
2005      */
2006     function _baseURI() internal view virtual returns (string memory) {
2007         return '';
2008     }
2009 
2010     // =============================================================
2011     //                     OWNERSHIPS OPERATIONS
2012     // =============================================================
2013 
2014     /**
2015      * @dev Returns the owner of the `tokenId` token.
2016      *
2017      * Requirements:
2018      *
2019      * - `tokenId` must exist.
2020      */
2021     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2022         return address(uint160(_packedOwnershipOf(tokenId)));
2023     }
2024 
2025     /**
2026      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2027      * It gradually moves to O(1) as tokens get transferred around over time.
2028      */
2029     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2030         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2031     }
2032 
2033     /**
2034      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2035      */
2036     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2037         return _unpackedOwnership(_packedOwnerships[index]);
2038     }
2039 
2040     /**
2041      * @dev Returns whether the ownership slot at `index` is initialized.
2042      * An uninitialized slot does not necessarily mean that the slot has no owner.
2043      */
2044     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
2045         return _packedOwnerships[index] != 0;
2046     }
2047 
2048     /**
2049      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2050      */
2051     function _initializeOwnershipAt(uint256 index) internal virtual {
2052         if (_packedOwnerships[index] == 0) {
2053             _packedOwnerships[index] = _packedOwnershipOf(index);
2054         }
2055     }
2056 
2057     /**
2058      * Returns the packed ownership data of `tokenId`.
2059      */
2060     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
2061         if (_startTokenId() <= tokenId) {
2062             packed = _packedOwnerships[tokenId];
2063             // If the data at the starting slot does not exist, start the scan.
2064             if (packed == 0) {
2065                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
2066                 // Invariant:
2067                 // There will always be an initialized ownership slot
2068                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2069                 // before an unintialized ownership slot
2070                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2071                 // Hence, `tokenId` will not underflow.
2072                 //
2073                 // We can directly compare the packed value.
2074                 // If the address is zero, packed will be zero.
2075                 for (;;) {
2076                     unchecked {
2077                         packed = _packedOwnerships[--tokenId];
2078                     }
2079                     if (packed == 0) continue;
2080                     if (packed & _BITMASK_BURNED == 0) return packed;
2081                     // Otherwise, the token is burned, and we must revert.
2082                     // This handles the case of batch burned tokens, where only the burned bit
2083                     // of the starting slot is set, and remaining slots are left uninitialized.
2084                     _revert(OwnerQueryForNonexistentToken.selector);
2085                 }
2086             }
2087             // Otherwise, the data exists and we can skip the scan.
2088             // This is possible because we have already achieved the target condition.
2089             // This saves 2143 gas on transfers of initialized tokens.
2090             // If the token is not burned, return `packed`. Otherwise, revert.
2091             if (packed & _BITMASK_BURNED == 0) return packed;
2092         }
2093         _revert(OwnerQueryForNonexistentToken.selector);
2094     }
2095 
2096     /**
2097      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2098      */
2099     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2100         ownership.addr = address(uint160(packed));
2101         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2102         ownership.burned = packed & _BITMASK_BURNED != 0;
2103         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2104     }
2105 
2106     /**
2107      * @dev Packs ownership data into a single uint256.
2108      */
2109     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2110         assembly {
2111             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2112             owner := and(owner, _BITMASK_ADDRESS)
2113             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2114             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2115         }
2116     }
2117 
2118     /**
2119      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2120      */
2121     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2122         // For branchless setting of the `nextInitialized` flag.
2123         assembly {
2124             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2125             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2126         }
2127     }
2128 
2129     // =============================================================
2130     //                      APPROVAL OPERATIONS
2131     // =============================================================
2132 
2133     /**
2134      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
2135      *
2136      * Requirements:
2137      *
2138      * - The caller must own the token or be an approved operator.
2139      */
2140     function approve(address to, uint256 tokenId) public payable virtual override {
2141         _approve(to, tokenId, true);
2142     }
2143 
2144     /**
2145      * @dev Returns the account approved for `tokenId` token.
2146      *
2147      * Requirements:
2148      *
2149      * - `tokenId` must exist.
2150      */
2151     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2152         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
2153 
2154         return _tokenApprovals[tokenId].value;
2155     }
2156 
2157     /**
2158      * @dev Approve or remove `operator` as an operator for the caller.
2159      * Operators can call {transferFrom} or {safeTransferFrom}
2160      * for any token owned by the caller.
2161      *
2162      * Requirements:
2163      *
2164      * - The `operator` cannot be the caller.
2165      *
2166      * Emits an {ApprovalForAll} event.
2167      */
2168     function setApprovalForAll(address operator, bool approved) public virtual override {
2169         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2170         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2171     }
2172 
2173     /**
2174      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2175      *
2176      * See {setApprovalForAll}.
2177      */
2178     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2179         return _operatorApprovals[owner][operator];
2180     }
2181 
2182     /**
2183      * @dev Returns whether `tokenId` exists.
2184      *
2185      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2186      *
2187      * Tokens start existing when they are minted. See {_mint}.
2188      */
2189     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
2190         if (_startTokenId() <= tokenId) {
2191             if (tokenId < _currentIndex) {
2192                 uint256 packed;
2193                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
2194                 result = packed & _BITMASK_BURNED == 0;
2195             }
2196         }
2197     }
2198 
2199     /**
2200      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2201      */
2202     function _isSenderApprovedOrOwner(
2203         address approvedAddress,
2204         address owner,
2205         address msgSender
2206     ) private pure returns (bool result) {
2207         assembly {
2208             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2209             owner := and(owner, _BITMASK_ADDRESS)
2210             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2211             msgSender := and(msgSender, _BITMASK_ADDRESS)
2212             // `msgSender == owner || msgSender == approvedAddress`.
2213             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2214         }
2215     }
2216 
2217     /**
2218      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2219      */
2220     function _getApprovedSlotAndAddress(uint256 tokenId)
2221         private
2222         view
2223         returns (uint256 approvedAddressSlot, address approvedAddress)
2224     {
2225         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2226         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2227         assembly {
2228             approvedAddressSlot := tokenApproval.slot
2229             approvedAddress := sload(approvedAddressSlot)
2230         }
2231     }
2232 
2233     // =============================================================
2234     //                      TRANSFER OPERATIONS
2235     // =============================================================
2236 
2237     /**
2238      * @dev Transfers `tokenId` from `from` to `to`.
2239      *
2240      * Requirements:
2241      *
2242      * - `from` cannot be the zero address.
2243      * - `to` cannot be the zero address.
2244      * - `tokenId` token must be owned by `from`.
2245      * - If the caller is not `from`, it must be approved to move this token
2246      * by either {approve} or {setApprovalForAll}.
2247      *
2248      * Emits a {Transfer} event.
2249      */
2250     function transferFrom(
2251         address from,
2252         address to,
2253         uint256 tokenId
2254     ) public payable virtual override {
2255         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2256 
2257         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
2258         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
2259 
2260         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
2261 
2262         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2263 
2264         // The nested ifs save around 20+ gas over a compound boolean condition.
2265         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2266             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2267 
2268         _beforeTokenTransfers(from, to, tokenId, 1);
2269 
2270         // Clear approvals from the previous owner.
2271         assembly {
2272             if approvedAddress {
2273                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2274                 sstore(approvedAddressSlot, 0)
2275             }
2276         }
2277 
2278         // Underflow of the sender's balance is impossible because we check for
2279         // ownership above and the recipient's balance can't realistically overflow.
2280         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2281         unchecked {
2282             // We can directly increment and decrement the balances.
2283             --_packedAddressData[from]; // Updates: `balance -= 1`.
2284             ++_packedAddressData[to]; // Updates: `balance += 1`.
2285 
2286             // Updates:
2287             // - `address` to the next owner.
2288             // - `startTimestamp` to the timestamp of transfering.
2289             // - `burned` to `false`.
2290             // - `nextInitialized` to `true`.
2291             _packedOwnerships[tokenId] = _packOwnershipData(
2292                 to,
2293                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2294             );
2295 
2296             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2297             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2298                 uint256 nextTokenId = tokenId + 1;
2299                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2300                 if (_packedOwnerships[nextTokenId] == 0) {
2301                     // If the next slot is within bounds.
2302                     if (nextTokenId != _currentIndex) {
2303                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2304                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2305                     }
2306                 }
2307             }
2308         }
2309 
2310         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2311         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2312         assembly {
2313             // Emit the `Transfer` event.
2314             log4(
2315                 0, // Start of data (0, since no data).
2316                 0, // End of data (0, since no data).
2317                 _TRANSFER_EVENT_SIGNATURE, // Signature.
2318                 from, // `from`.
2319                 toMasked, // `to`.
2320                 tokenId // `tokenId`.
2321             )
2322         }
2323         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
2324 
2325         _afterTokenTransfers(from, to, tokenId, 1);
2326     }
2327 
2328     /**
2329      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2330      */
2331     function safeTransferFrom(
2332         address from,
2333         address to,
2334         uint256 tokenId
2335     ) public payable virtual override {
2336         safeTransferFrom(from, to, tokenId, '');
2337     }
2338 
2339     /**
2340      * @dev Safely transfers `tokenId` token from `from` to `to`.
2341      *
2342      * Requirements:
2343      *
2344      * - `from` cannot be the zero address.
2345      * - `to` cannot be the zero address.
2346      * - `tokenId` token must exist and be owned by `from`.
2347      * - If the caller is not `from`, it must be approved to move this token
2348      * by either {approve} or {setApprovalForAll}.
2349      * - If `to` refers to a smart contract, it must implement
2350      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2351      *
2352      * Emits a {Transfer} event.
2353      */
2354     function safeTransferFrom(
2355         address from,
2356         address to,
2357         uint256 tokenId,
2358         bytes memory _data
2359     ) public payable virtual override {
2360         transferFrom(from, to, tokenId);
2361         if (to.code.length != 0)
2362             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2363                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2364             }
2365     }
2366 
2367     /**
2368      * @dev Hook that is called before a set of serially-ordered token IDs
2369      * are about to be transferred. This includes minting.
2370      * And also called before burning one token.
2371      *
2372      * `startTokenId` - the first token ID to be transferred.
2373      * `quantity` - the amount to be transferred.
2374      *
2375      * Calling conditions:
2376      *
2377      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2378      * transferred to `to`.
2379      * - When `from` is zero, `tokenId` will be minted for `to`.
2380      * - When `to` is zero, `tokenId` will be burned by `from`.
2381      * - `from` and `to` are never both zero.
2382      */
2383     function _beforeTokenTransfers(
2384         address from,
2385         address to,
2386         uint256 startTokenId,
2387         uint256 quantity
2388     ) internal virtual {}
2389 
2390     /**
2391      * @dev Hook that is called after a set of serially-ordered token IDs
2392      * have been transferred. This includes minting.
2393      * And also called after one token has been burned.
2394      *
2395      * `startTokenId` - the first token ID to be transferred.
2396      * `quantity` - the amount to be transferred.
2397      *
2398      * Calling conditions:
2399      *
2400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2401      * transferred to `to`.
2402      * - When `from` is zero, `tokenId` has been minted for `to`.
2403      * - When `to` is zero, `tokenId` has been burned by `from`.
2404      * - `from` and `to` are never both zero.
2405      */
2406     function _afterTokenTransfers(
2407         address from,
2408         address to,
2409         uint256 startTokenId,
2410         uint256 quantity
2411     ) internal virtual {}
2412 
2413     /**
2414      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2415      *
2416      * `from` - Previous owner of the given token ID.
2417      * `to` - Target address that will receive the token.
2418      * `tokenId` - Token ID to be transferred.
2419      * `_data` - Optional data to send along with the call.
2420      *
2421      * Returns whether the call correctly returned the expected magic value.
2422      */
2423     function _checkContractOnERC721Received(
2424         address from,
2425         address to,
2426         uint256 tokenId,
2427         bytes memory _data
2428     ) private returns (bool) {
2429         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2430             bytes4 retval
2431         ) {
2432             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2433         } catch (bytes memory reason) {
2434             if (reason.length == 0) {
2435                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2436             }
2437             assembly {
2438                 revert(add(32, reason), mload(reason))
2439             }
2440         }
2441     }
2442 
2443     // =============================================================
2444     //                        MINT OPERATIONS
2445     // =============================================================
2446 
2447     /**
2448      * @dev Mints `quantity` tokens and transfers them to `to`.
2449      *
2450      * Requirements:
2451      *
2452      * - `to` cannot be the zero address.
2453      * - `quantity` must be greater than 0.
2454      *
2455      * Emits a {Transfer} event for each mint.
2456      */
2457     function _mint(address to, uint256 quantity) internal virtual {
2458         uint256 startTokenId = _currentIndex;
2459         if (quantity == 0) _revert(MintZeroQuantity.selector);
2460 
2461         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2462 
2463         // Overflows are incredibly unrealistic.
2464         // `balance` and `numberMinted` have a maximum limit of 2**64.
2465         // `tokenId` has a maximum limit of 2**256.
2466         unchecked {
2467             // Updates:
2468             // - `address` to the owner.
2469             // - `startTimestamp` to the timestamp of minting.
2470             // - `burned` to `false`.
2471             // - `nextInitialized` to `quantity == 1`.
2472             _packedOwnerships[startTokenId] = _packOwnershipData(
2473                 to,
2474                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2475             );
2476 
2477             // Updates:
2478             // - `balance += quantity`.
2479             // - `numberMinted += quantity`.
2480             //
2481             // We can directly add to the `balance` and `numberMinted`.
2482             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2483 
2484             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2485             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2486 
2487             if (toMasked == 0) _revert(MintToZeroAddress.selector);
2488 
2489             uint256 end = startTokenId + quantity;
2490             uint256 tokenId = startTokenId;
2491 
2492             do {
2493                 assembly {
2494                     // Emit the `Transfer` event.
2495                     log4(
2496                         0, // Start of data (0, since no data).
2497                         0, // End of data (0, since no data).
2498                         _TRANSFER_EVENT_SIGNATURE, // Signature.
2499                         0, // `address(0)`.
2500                         toMasked, // `to`.
2501                         tokenId // `tokenId`.
2502                     )
2503                 }
2504                 // The `!=` check ensures that large values of `quantity`
2505                 // that overflows uint256 will make the loop run out of gas.
2506             } while (++tokenId != end);
2507 
2508             _currentIndex = end;
2509         }
2510         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2511     }
2512 
2513     /**
2514      * @dev Mints `quantity` tokens and transfers them to `to`.
2515      *
2516      * This function is intended for efficient minting only during contract creation.
2517      *
2518      * It emits only one {ConsecutiveTransfer} as defined in
2519      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2520      * instead of a sequence of {Transfer} event(s).
2521      *
2522      * Calling this function outside of contract creation WILL make your contract
2523      * non-compliant with the ERC721 standard.
2524      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2525      * {ConsecutiveTransfer} event is only permissible during contract creation.
2526      *
2527      * Requirements:
2528      *
2529      * - `to` cannot be the zero address.
2530      * - `quantity` must be greater than 0.
2531      *
2532      * Emits a {ConsecutiveTransfer} event.
2533      */
2534     function _mintERC2309(address to, uint256 quantity) internal virtual {
2535         uint256 startTokenId = _currentIndex;
2536         if (to == address(0)) _revert(MintToZeroAddress.selector);
2537         if (quantity == 0) _revert(MintZeroQuantity.selector);
2538         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
2539 
2540         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2541 
2542         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2543         unchecked {
2544             // Updates:
2545             // - `balance += quantity`.
2546             // - `numberMinted += quantity`.
2547             //
2548             // We can directly add to the `balance` and `numberMinted`.
2549             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2550 
2551             // Updates:
2552             // - `address` to the owner.
2553             // - `startTimestamp` to the timestamp of minting.
2554             // - `burned` to `false`.
2555             // - `nextInitialized` to `quantity == 1`.
2556             _packedOwnerships[startTokenId] = _packOwnershipData(
2557                 to,
2558                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2559             );
2560 
2561             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2562 
2563             _currentIndex = startTokenId + quantity;
2564         }
2565         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2566     }
2567 
2568     /**
2569      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2570      *
2571      * Requirements:
2572      *
2573      * - If `to` refers to a smart contract, it must implement
2574      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2575      * - `quantity` must be greater than 0.
2576      *
2577      * See {_mint}.
2578      *
2579      * Emits a {Transfer} event for each mint.
2580      */
2581     function _safeMint(
2582         address to,
2583         uint256 quantity,
2584         bytes memory _data
2585     ) internal virtual {
2586         _mint(to, quantity);
2587 
2588         unchecked {
2589             if (to.code.length != 0) {
2590                 uint256 end = _currentIndex;
2591                 uint256 index = end - quantity;
2592                 do {
2593                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2594                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2595                     }
2596                 } while (index < end);
2597                 // Reentrancy protection.
2598                 if (_currentIndex != end) _revert(bytes4(0));
2599             }
2600         }
2601     }
2602 
2603     /**
2604      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2605      */
2606     function _safeMint(address to, uint256 quantity) internal virtual {
2607         _safeMint(to, quantity, '');
2608     }
2609 
2610     // =============================================================
2611     //                       APPROVAL OPERATIONS
2612     // =============================================================
2613 
2614     /**
2615      * @dev Equivalent to `_approve(to, tokenId, false)`.
2616      */
2617     function _approve(address to, uint256 tokenId) internal virtual {
2618         _approve(to, tokenId, false);
2619     }
2620 
2621     /**
2622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2623      * The approval is cleared when the token is transferred.
2624      *
2625      * Only a single account can be approved at a time, so approving the
2626      * zero address clears previous approvals.
2627      *
2628      * Requirements:
2629      *
2630      * - `tokenId` must exist.
2631      *
2632      * Emits an {Approval} event.
2633      */
2634     function _approve(
2635         address to,
2636         uint256 tokenId,
2637         bool approvalCheck
2638     ) internal virtual {
2639         address owner = ownerOf(tokenId);
2640 
2641         if (approvalCheck && _msgSenderERC721A() != owner)
2642             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2643                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2644             }
2645 
2646         _tokenApprovals[tokenId].value = to;
2647         emit Approval(owner, to, tokenId);
2648     }
2649 
2650     // =============================================================
2651     //                        BURN OPERATIONS
2652     // =============================================================
2653 
2654     /**
2655      * @dev Equivalent to `_burn(tokenId, false)`.
2656      */
2657     function _burn(uint256 tokenId) internal virtual {
2658         _burn(tokenId, false);
2659     }
2660 
2661     /**
2662      * @dev Destroys `tokenId`.
2663      * The approval is cleared when the token is burned.
2664      *
2665      * Requirements:
2666      *
2667      * - `tokenId` must exist.
2668      *
2669      * Emits a {Transfer} event.
2670      */
2671     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2672         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2673 
2674         address from = address(uint160(prevOwnershipPacked));
2675 
2676         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2677 
2678         if (approvalCheck) {
2679             // The nested ifs save around 20+ gas over a compound boolean condition.
2680             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2681                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2682         }
2683 
2684         _beforeTokenTransfers(from, address(0), tokenId, 1);
2685 
2686         // Clear approvals from the previous owner.
2687         assembly {
2688             if approvedAddress {
2689                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2690                 sstore(approvedAddressSlot, 0)
2691             }
2692         }
2693 
2694         // Underflow of the sender's balance is impossible because we check for
2695         // ownership above and the recipient's balance can't realistically overflow.
2696         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2697         unchecked {
2698             // Updates:
2699             // - `balance -= 1`.
2700             // - `numberBurned += 1`.
2701             //
2702             // We can directly decrement the balance, and increment the number burned.
2703             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2704             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2705 
2706             // Updates:
2707             // - `address` to the last owner.
2708             // - `startTimestamp` to the timestamp of burning.
2709             // - `burned` to `true`.
2710             // - `nextInitialized` to `true`.
2711             _packedOwnerships[tokenId] = _packOwnershipData(
2712                 from,
2713                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2714             );
2715 
2716             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2717             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2718                 uint256 nextTokenId = tokenId + 1;
2719                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2720                 if (_packedOwnerships[nextTokenId] == 0) {
2721                     // If the next slot is within bounds.
2722                     if (nextTokenId != _currentIndex) {
2723                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2724                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2725                     }
2726                 }
2727             }
2728         }
2729 
2730         emit Transfer(from, address(0), tokenId);
2731         _afterTokenTransfers(from, address(0), tokenId, 1);
2732 
2733         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2734         unchecked {
2735             _burnCounter++;
2736         }
2737     }
2738 
2739     // =============================================================
2740     //                     EXTRA DATA OPERATIONS
2741     // =============================================================
2742 
2743     /**
2744      * @dev Directly sets the extra data for the ownership data `index`.
2745      */
2746     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2747         uint256 packed = _packedOwnerships[index];
2748         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2749         uint256 extraDataCasted;
2750         // Cast `extraData` with assembly to avoid redundant masking.
2751         assembly {
2752             extraDataCasted := extraData
2753         }
2754         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2755         _packedOwnerships[index] = packed;
2756     }
2757 
2758     /**
2759      * @dev Called during each token transfer to set the 24bit `extraData` field.
2760      * Intended to be overridden by the cosumer contract.
2761      *
2762      * `previousExtraData` - the value of `extraData` before transfer.
2763      *
2764      * Calling conditions:
2765      *
2766      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2767      * transferred to `to`.
2768      * - When `from` is zero, `tokenId` will be minted for `to`.
2769      * - When `to` is zero, `tokenId` will be burned by `from`.
2770      * - `from` and `to` are never both zero.
2771      */
2772     function _extraData(
2773         address from,
2774         address to,
2775         uint24 previousExtraData
2776     ) internal view virtual returns (uint24) {}
2777 
2778     /**
2779      * @dev Returns the next extra data for the packed ownership data.
2780      * The returned result is shifted into position.
2781      */
2782     function _nextExtraData(
2783         address from,
2784         address to,
2785         uint256 prevOwnershipPacked
2786     ) private view returns (uint256) {
2787         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2788         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2789     }
2790 
2791     // =============================================================
2792     //                       OTHER OPERATIONS
2793     // =============================================================
2794 
2795     /**
2796      * @dev Returns the message sender (defaults to `msg.sender`).
2797      *
2798      * If you are writing GSN compatible contracts, you need to override this function.
2799      */
2800     function _msgSenderERC721A() internal view virtual returns (address) {
2801         return msg.sender;
2802     }
2803 
2804     /**
2805      * @dev Converts a uint256 to its ASCII string decimal representation.
2806      */
2807     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2808         assembly {
2809             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2810             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2811             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2812             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2813             let m := add(mload(0x40), 0xa0)
2814             // Update the free memory pointer to allocate.
2815             mstore(0x40, m)
2816             // Assign the `str` to the end.
2817             str := sub(m, 0x20)
2818             // Zeroize the slot after the string.
2819             mstore(str, 0)
2820 
2821             // Cache the end of the memory to calculate the length later.
2822             let end := str
2823 
2824             // We write the string from rightmost digit to leftmost digit.
2825             // The following is essentially a do-while loop that also handles the zero case.
2826             // prettier-ignore
2827             for { let temp := value } 1 {} {
2828                 str := sub(str, 1)
2829                 // Write the character to the pointer.
2830                 // The ASCII index of the '0' character is 48.
2831                 mstore8(str, add(48, mod(temp, 10)))
2832                 // Keep dividing `temp` until zero.
2833                 temp := div(temp, 10)
2834                 // prettier-ignore
2835                 if iszero(temp) { break }
2836             }
2837 
2838             let length := sub(end, str)
2839             // Move the pointer 32 bytes leftwards to make room for the length.
2840             str := sub(str, 0x20)
2841             // Store the length.
2842             mstore(str, length)
2843         }
2844     }
2845 
2846     /**
2847      * @dev For more efficient reverts.
2848      */
2849     function _revert(bytes4 errorSelector) internal pure {
2850         assembly {
2851             mstore(0x00, errorSelector)
2852             revert(0x00, 0x04)
2853         }
2854     }
2855 }
2856 // File: contracts/SacredShard.sol
2857 
2858 
2859 pragma solidity ^0.8.11;
2860 
2861 
2862 
2863 
2864 
2865 
2866 
2867 
2868 contract SacredShard is ERC721A, ERC2981, Ownable, DefaultOperatorFilterer, PaymentSplitter, ReentrancyGuard {
2869 
2870     uint256 public maxSupply = 700;
2871     uint256 public limit = 2;
2872     uint256 public price = 0.069 ether;
2873     bool public mintEnabled;
2874     bool public claimEnabled;
2875     bool public revealed;
2876     string public hiddenURI;
2877     string public baseURI;
2878 
2879     mapping(address => uint256) mintedWallets;
2880     mapping(address => uint256) claimableWallets;
2881 
2882     address[] private addressList = [
2883         0x32bd5891c38FD60A28FDFd6b3198c4428F4f4c30,
2884         0x7a87e3585AEDFe7F48045eEf28E90F94e5F959dA,
2885         0xE2bA5BF933F1f7581a7B852ee40F30686A8737b8
2886     ];
2887     
2888     uint256[] private shareList = [
2889         8,
2890         8,
2891         84
2892     ];
2893 
2894     constructor(address payable _royaltyReceiver) ERC721A("Sacred Shard", "SS") PaymentSplitter(addressList, shareList) {
2895         setDefaultRoyalty(_royaltyReceiver, 1000); // 10% default royalty
2896     }
2897 
2898     function mint(uint256 numberOfTokens) external payable nonReentrant {
2899         uint256 amount = numberOfTokens * price;
2900         require(mintEnabled, "Mint disabled");
2901         require(totalSupply() + numberOfTokens <= maxSupply, "We're sold out!");
2902         require(mintedWallets[msg.sender] + numberOfTokens <= limit, "Too many per wallet");
2903         require(msg.value >= amount, "Not enough Ether");
2904 
2905         mintedWallets[msg.sender] += numberOfTokens;
2906         _mint(msg.sender, numberOfTokens);
2907     }
2908 
2909     function claim() external nonReentrant {
2910         uint256 numberOfTokens = claimableWallets[msg.sender];
2911         require(claimEnabled, "Claim disabled");
2912         require(numberOfTokens > 0, "You don't have anything to claim");
2913 
2914         claimableWallets[msg.sender] = 0;
2915         _mint(msg.sender, numberOfTokens);
2916     }
2917 
2918     function teamMint(address to, uint256 numberOfTokens) external onlyOwner nonReentrant {
2919         require(totalSupply() + numberOfTokens <= maxSupply, "We're sold out!");
2920 
2921         _mint(to, numberOfTokens);
2922     }
2923 
2924     function addClaimableWallets(address[] calldata owner, uint256[] calldata amount) external onlyOwner {
2925         for (uint256 i = 0; i < owner.length; i++) {
2926             claimableWallets[owner[i]] = amount[i];
2927         }
2928     }
2929 
2930     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
2931         maxSupply = _maxSupply;
2932     }
2933 
2934     function setLimit(uint256 _limit) external onlyOwner {
2935         limit = _limit;
2936     }
2937 
2938     function setPrice(uint256 _price) external onlyOwner {
2939         price = _price;
2940     }
2941 
2942     function toggleMinting() external onlyOwner {
2943         mintEnabled = !mintEnabled;
2944     }
2945 
2946     function toggleClaiming() external onlyOwner {
2947         claimEnabled = !claimEnabled;
2948     }
2949 
2950     function toggleRevealed() external onlyOwner {
2951         revealed = !revealed;
2952     }
2953 
2954     function setHiddenURI(string calldata hiddenURI_) external onlyOwner {
2955         hiddenURI = hiddenURI_;
2956     }
2957 
2958     function setBaseURI(string calldata baseURI_) external onlyOwner {
2959         baseURI = baseURI_;
2960     }
2961 
2962     function _baseURI() internal view virtual override returns (string memory) {
2963         return baseURI;
2964     }
2965 
2966     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2967         require(_exists(tokenId), "SS does not exist");
2968 
2969         if (revealed) {
2970             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
2971         }
2972 
2973         return hiddenURI;
2974     }
2975 
2976     function emergencyWithdraw() external onlyOwner nonReentrant {
2977         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2978         require(success, "Withdraw eth failed!");
2979     }
2980 
2981     function getMintedAmount(address _address) public view returns (uint256) {
2982         return mintedWallets[_address];
2983     }
2984 
2985     function getClaimableAmount(address _address) public view returns (uint256) {
2986         return claimableWallets[_address];
2987     }
2988 
2989     // =========================================================================
2990     //                           Operator filtering
2991     // =========================================================================
2992 
2993     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2994         super.setApprovalForAll(operator, approved);
2995     }
2996 
2997     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2998         super.approve(operator, tokenId);
2999     }
3000 
3001     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
3002         super.transferFrom(from, to, tokenId);
3003     }
3004 
3005     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
3006         super.safeTransferFrom(from, to, tokenId);
3007     }
3008 
3009     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3010         public
3011         payable
3012         override
3013         onlyAllowedOperator(from)
3014     {
3015         super.safeTransferFrom(from, to, tokenId, data);
3016     }
3017 
3018     // =========================================================================
3019     //                                 ERC2891
3020     // =========================================================================
3021 
3022     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
3023         _setDefaultRoyalty(receiver, feeNumerator);
3024     }
3025 
3026     function deleteDefaultRoyalty() public onlyOwner {
3027         _deleteDefaultRoyalty();
3028     }
3029 
3030     // =========================================================================
3031     //                                  ERC165
3032     // =========================================================================
3033 
3034     function supportsInterface(bytes4 interfaceId) public view virtual override (ERC2981, ERC721A) returns (bool) {
3035         return super.supportsInterface(interfaceId);
3036     }
3037 }