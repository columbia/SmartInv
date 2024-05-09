1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Address.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
117 
118 pragma solidity ^0.8.1;
119 
120 /**
121  * @dev Collection of functions related to the address type
122  */
123 library Address {
124     /**
125      * @dev Returns true if `account` is a contract.
126      *
127      * [IMPORTANT]
128      * ====
129      * It is unsafe to assume that an address for which this function returns
130      * false is an externally-owned account (EOA) and not a contract.
131      *
132      * Among others, `isContract` will return false for the following
133      * types of addresses:
134      *
135      *  - an externally-owned account
136      *  - a contract in construction
137      *  - an address where a contract will be created
138      *  - an address where a contract lived, but was destroyed
139      * ====
140      *
141      * [IMPORTANT]
142      * ====
143      * You shouldn't rely on `isContract` to protect against flash loan attacks!
144      *
145      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
146      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
147      * constructor.
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize/address.code.length, which returns 0
152         // for contracts in construction, since the code is only stored at the end
153         // of the constructor execution.
154 
155         return account.code.length > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
205      * `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but also transferring `value` wei to `target`.
220      *
221      * Requirements:
222      *
223      * - the calling contract must have an ETH balance of at least `value`.
224      * - the called Solidity function must be `payable`.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(address(this).balance >= value, "Address: insufficient balance for call");
249         (bool success, bytes memory returndata) = target.call{value: value}(data);
250         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
260         return functionStaticCall(target, data, "Address: low-level static call failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
265      * but performing a static call.
266      *
267      * _Available since v3.3._
268      */
269     function functionStaticCall(
270         address target,
271         bytes memory data,
272         string memory errorMessage
273     ) internal view returns (bytes memory) {
274         (bool success, bytes memory returndata) = target.staticcall(data);
275         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a delegate call.
291      *
292      * _Available since v3.4._
293      */
294     function functionDelegateCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         (bool success, bytes memory returndata) = target.delegatecall(data);
300         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
305      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
306      *
307      * _Available since v4.8._
308      */
309     function verifyCallResultFromTarget(
310         address target,
311         bool success,
312         bytes memory returndata,
313         string memory errorMessage
314     ) internal view returns (bytes memory) {
315         if (success) {
316             if (returndata.length == 0) {
317                 // only check isContract if the call was successful and the return data is empty
318                 // otherwise we already know that it was a contract
319                 require(isContract(target), "Address: call to non-contract");
320             }
321             return returndata;
322         } else {
323             _revert(returndata, errorMessage);
324         }
325     }
326 
327     /**
328      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
329      * revert reason or using the provided one.
330      *
331      * _Available since v4.3._
332      */
333     function verifyCallResult(
334         bool success,
335         bytes memory returndata,
336         string memory errorMessage
337     ) internal pure returns (bytes memory) {
338         if (success) {
339             return returndata;
340         } else {
341             _revert(returndata, errorMessage);
342         }
343     }
344 
345     function _revert(bytes memory returndata, string memory errorMessage) private pure {
346         // Look for revert reason and bubble it up if present
347         if (returndata.length > 0) {
348             // The easiest way to bubble the revert reason is using memory via assembly
349             /// @solidity memory-safe-assembly
350             assembly {
351                 let returndata_size := mload(returndata)
352                 revert(add(32, returndata), returndata_size)
353             }
354         } else {
355             revert(errorMessage);
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
369  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
370  *
371  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
372  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
373  * need to send a transaction, and thus is not required to hold Ether at all.
374  */
375 interface IERC20Permit {
376     /**
377      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
378      * given ``owner``'s signed approval.
379      *
380      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
381      * ordering also apply here.
382      *
383      * Emits an {Approval} event.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      * - `deadline` must be a timestamp in the future.
389      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
390      * over the EIP712-formatted function arguments.
391      * - the signature must use ``owner``'s current nonce (see {nonces}).
392      *
393      * For more information on the signature format, see the
394      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
395      * section].
396      */
397     function permit(
398         address owner,
399         address spender,
400         uint256 value,
401         uint256 deadline,
402         uint8 v,
403         bytes32 r,
404         bytes32 s
405     ) external;
406 
407     /**
408      * @dev Returns the current nonce for `owner`. This value must be
409      * included whenever a signature is generated for {permit}.
410      *
411      * Every successful call to {permit} increases ``owner``'s nonce by one. This
412      * prevents a signature from being used multiple times.
413      */
414     function nonces(address owner) external view returns (uint256);
415 
416     /**
417      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
418      */
419     // solhint-disable-next-line func-name-mixedcase
420     function DOMAIN_SEPARATOR() external view returns (bytes32);
421 }
422 
423 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Interface of the ERC20 standard as defined in the EIP.
432  */
433 interface IERC20 {
434     /**
435      * @dev Emitted when `value` tokens are moved from one account (`from`) to
436      * another (`to`).
437      *
438      * Note that `value` may be zero.
439      */
440     event Transfer(address indexed from, address indexed to, uint256 value);
441 
442     /**
443      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
444      * a call to {approve}. `value` is the new allowance.
445      */
446     event Approval(address indexed owner, address indexed spender, uint256 value);
447 
448     /**
449      * @dev Returns the amount of tokens in existence.
450      */
451     function totalSupply() external view returns (uint256);
452 
453     /**
454      * @dev Returns the amount of tokens owned by `account`.
455      */
456     function balanceOf(address account) external view returns (uint256);
457 
458     /**
459      * @dev Moves `amount` tokens from the caller's account to `to`.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * Emits a {Transfer} event.
464      */
465     function transfer(address to, uint256 amount) external returns (bool);
466 
467     /**
468      * @dev Returns the remaining number of tokens that `spender` will be
469      * allowed to spend on behalf of `owner` through {transferFrom}. This is
470      * zero by default.
471      *
472      * This value changes when {approve} or {transferFrom} are called.
473      */
474     function allowance(address owner, address spender) external view returns (uint256);
475 
476     /**
477      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
478      *
479      * Returns a boolean value indicating whether the operation succeeded.
480      *
481      * IMPORTANT: Beware that changing an allowance with this method brings the risk
482      * that someone may use both the old and the new allowance by unfortunate
483      * transaction ordering. One possible solution to mitigate this race
484      * condition is to first reduce the spender's allowance to 0 and set the
485      * desired value afterwards:
486      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
487      *
488      * Emits an {Approval} event.
489      */
490     function approve(address spender, uint256 amount) external returns (bool);
491 
492     /**
493      * @dev Moves `amount` tokens from `from` to `to` using the
494      * allowance mechanism. `amount` is then deducted from the caller's
495      * allowance.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transferFrom(
502         address from,
503         address to,
504         uint256 amount
505     ) external returns (bool);
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
509 
510 
511 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 
517 
518 /**
519  * @title SafeERC20
520  * @dev Wrappers around ERC20 operations that throw on failure (when the token
521  * contract returns false). Tokens that return no value (and instead revert or
522  * throw on failure) are also supported, non-reverting calls are assumed to be
523  * successful.
524  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
525  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
526  */
527 library SafeERC20 {
528     using Address for address;
529 
530     function safeTransfer(
531         IERC20 token,
532         address to,
533         uint256 value
534     ) internal {
535         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
536     }
537 
538     function safeTransferFrom(
539         IERC20 token,
540         address from,
541         address to,
542         uint256 value
543     ) internal {
544         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
545     }
546 
547     /**
548      * @dev Deprecated. This function has issues similar to the ones found in
549      * {IERC20-approve}, and its usage is discouraged.
550      *
551      * Whenever possible, use {safeIncreaseAllowance} and
552      * {safeDecreaseAllowance} instead.
553      */
554     function safeApprove(
555         IERC20 token,
556         address spender,
557         uint256 value
558     ) internal {
559         // safeApprove should only be called when setting an initial allowance,
560         // or when resetting it to zero. To increase and decrease it, use
561         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
562         require(
563             (value == 0) || (token.allowance(address(this), spender) == 0),
564             "SafeERC20: approve from non-zero to non-zero allowance"
565         );
566         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
567     }
568 
569     function safeIncreaseAllowance(
570         IERC20 token,
571         address spender,
572         uint256 value
573     ) internal {
574         uint256 newAllowance = token.allowance(address(this), spender) + value;
575         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
576     }
577 
578     function safeDecreaseAllowance(
579         IERC20 token,
580         address spender,
581         uint256 value
582     ) internal {
583         unchecked {
584             uint256 oldAllowance = token.allowance(address(this), spender);
585             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
586             uint256 newAllowance = oldAllowance - value;
587             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
588         }
589     }
590 
591     function safePermit(
592         IERC20Permit token,
593         address owner,
594         address spender,
595         uint256 value,
596         uint256 deadline,
597         uint8 v,
598         bytes32 r,
599         bytes32 s
600     ) internal {
601         uint256 nonceBefore = token.nonces(owner);
602         token.permit(owner, spender, value, deadline, v, r, s);
603         uint256 nonceAfter = token.nonces(owner);
604         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
605     }
606 
607     /**
608      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
609      * on the return value: the return value is optional (but if data is returned, it must not be false).
610      * @param token The token targeted by the call.
611      * @param data The call data (encoded using abi.encode or one of its variants).
612      */
613     function _callOptionalReturn(IERC20 token, bytes memory data) private {
614         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
615         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
616         // the target address contains contract code and also asserts for success in the low-level call.
617 
618         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
619         if (returndata.length > 0) {
620             // Return data is optional
621             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
622         }
623     }
624 }
625 
626 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Interface of the ERC165 standard, as defined in the
635  * https://eips.ethereum.org/EIPS/eip-165[EIP].
636  *
637  * Implementers can declare support of contract interfaces, which can then be
638  * queried by others ({ERC165Checker}).
639  *
640  * For an implementation, see {ERC165}.
641  */
642 interface IERC165 {
643     /**
644      * @dev Returns true if this contract implements the interface defined by
645      * `interfaceId`. See the corresponding
646      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
647      * to learn more about how these ids are created.
648      *
649      * This function call must use less than 30 000 gas.
650      */
651     function supportsInterface(bytes4 interfaceId) external view returns (bool);
652 }
653 
654 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
655 
656 
657 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @dev Required interface of an ERC1155 compliant contract, as defined in the
664  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
665  *
666  * _Available since v3.1._
667  */
668 interface IERC1155 is IERC165 {
669     /**
670      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
671      */
672     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
673 
674     /**
675      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
676      * transfers.
677      */
678     event TransferBatch(
679         address indexed operator,
680         address indexed from,
681         address indexed to,
682         uint256[] ids,
683         uint256[] values
684     );
685 
686     /**
687      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
688      * `approved`.
689      */
690     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
691 
692     /**
693      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
694      *
695      * If an {URI} event was emitted for `id`, the standard
696      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
697      * returned by {IERC1155MetadataURI-uri}.
698      */
699     event URI(string value, uint256 indexed id);
700 
701     /**
702      * @dev Returns the amount of tokens of token type `id` owned by `account`.
703      *
704      * Requirements:
705      *
706      * - `account` cannot be the zero address.
707      */
708     function balanceOf(address account, uint256 id) external view returns (uint256);
709 
710     /**
711      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
712      *
713      * Requirements:
714      *
715      * - `accounts` and `ids` must have the same length.
716      */
717     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
718         external
719         view
720         returns (uint256[] memory);
721 
722     /**
723      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
724      *
725      * Emits an {ApprovalForAll} event.
726      *
727      * Requirements:
728      *
729      * - `operator` cannot be the caller.
730      */
731     function setApprovalForAll(address operator, bool approved) external;
732 
733     /**
734      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
735      *
736      * See {setApprovalForAll}.
737      */
738     function isApprovedForAll(address account, address operator) external view returns (bool);
739 
740     /**
741      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
742      *
743      * Emits a {TransferSingle} event.
744      *
745      * Requirements:
746      *
747      * - `to` cannot be the zero address.
748      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
749      * - `from` must have a balance of tokens of type `id` of at least `amount`.
750      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
751      * acceptance magic value.
752      */
753     function safeTransferFrom(
754         address from,
755         address to,
756         uint256 id,
757         uint256 amount,
758         bytes calldata data
759     ) external;
760 
761     /**
762      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
763      *
764      * Emits a {TransferBatch} event.
765      *
766      * Requirements:
767      *
768      * - `ids` and `amounts` must have the same length.
769      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
770      * acceptance magic value.
771      */
772     function safeBatchTransferFrom(
773         address from,
774         address to,
775         uint256[] calldata ids,
776         uint256[] calldata amounts,
777         bytes calldata data
778     ) external;
779 }
780 
781 // File: nftstaking.sol
782 
783 pragma solidity ^0.8.9;
784 
785 
786 
787 
788 error InsufficientBalance(uint256 availableBRL, uint256 requiredBRL, uint256 availableNFTs, uint256 requiredNFTs);
789 error NotYetStarted();
790 error AlreadyStarted();
791 error AlreadyFinished();
792 
793 contract BullRunStaking is Ownable {
794     using SafeERC20 for IERC20;
795 
796     struct UserInfo {
797         uint256 amount;
798         uint256 nftBalance;
799         uint256 rewardDebt;
800         uint256 startTime;
801         uint256 totalRewards;
802     }
803 
804     //Pool Info
805     IERC20 public brl; //staking token
806     IERC1155 public nft; //nft to stake
807     uint256 public lastRewardTimestamp;
808     uint256 public accUSDCPerShare;
809     uint256 public usdcPerSecond;
810     uint256 public rewardSupply;
811 
812     mapping(address => UserInfo) public userInfo;
813 
814     address public constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
815 
816     uint256 public startTime;
817     bool public started;
818     bool public finished;
819 
820     event DepositBRL(address indexed user, uint256 amount);
821     event WithdrawBRL(address indexed user, uint256 amount);
822     event DepositNFT(address indexed user, uint256 amount);
823     event WithdrawNFT(address indexed user, uint256 amount);
824 
825     constructor(IERC20 _brl, IERC1155 _nft, uint256 _usdcPerSecond) {
826         brl = _brl;
827         nft = _nft;
828         usdcPerSecond = _usdcPerSecond;
829     }
830 
831     function pendingUSDC(address _user) external view returns (uint256)
832     {
833         UserInfo storage user = userInfo[_user];
834         uint256 _accUSDCPerShare = accUSDCPerShare;
835         uint256 balance = brl.balanceOf(address(this));
836         if (block.timestamp > lastRewardTimestamp && balance != 0) {
837             uint256 usdcReward = (block.timestamp - lastRewardTimestamp) * usdcPerSecond;
838             _accUSDCPerShare += (usdcReward * 1e36 / balance);
839         }
840         uint256 nftBalance = user.nftBalance;
841         uint256 multiplier = nftBalance < 5 ? 70 + (nftBalance * 6) : 100;
842         return ((user.amount * _accUSDCPerShare / 1e36) - user.rewardDebt) * multiplier / 100;
843     }
844 
845     function updatePool() public {
846         uint256 timestamp = block.timestamp;
847         if (!started) {
848             revert NotYetStarted();
849         }
850         if (timestamp <= lastRewardTimestamp) {
851             return;
852         }
853         uint256 balance = brl.balanceOf(address(this));
854         if (balance == 0) {
855             lastRewardTimestamp = timestamp;
856             return;
857         }
858         uint256 usdcReward = (timestamp - lastRewardTimestamp) * usdcPerSecond;
859         accUSDCPerShare += (usdcReward * 1e36 / balance);
860         lastRewardTimestamp = timestamp;
861         rewardSupply += usdcReward;
862     }
863 
864     function _claimRewards(uint256 nftBalance, uint256 amount, uint256 rewardDebt) internal returns (uint256 amountToSend) {
865         uint256 multiplier = nftBalance < 5 ? 70 + (nftBalance * 6) : 100;
866         uint256 totalRewards = (amount * accUSDCPerShare / 1e36) - rewardDebt;
867         uint256 pending = totalRewards * multiplier / 100;
868         uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
869         amountToSend = pending > usdcBalance ? usdcBalance : pending;
870         IERC20(usdc).transfer(msg.sender, amountToSend);
871         rewardSupply -= totalRewards;
872     }
873 
874     function deposit(uint256 _brlAmount, uint256 _nftAmount) external {
875         UserInfo storage user = userInfo[msg.sender];
876         updatePool();
877         if (user.amount > 0) {
878             uint256 amountTransferred = _claimRewards(user.nftBalance, user.amount, user.rewardDebt);
879             user.totalRewards += amountTransferred;
880         }
881         if (_brlAmount > 0) {
882             brl.safeTransferFrom(address(msg.sender), address(this), _brlAmount);
883             //for apy calculations
884             if (user.amount == 0) {
885                 user.startTime = block.timestamp;
886                 user.totalRewards = 0;
887             }
888             //update balances
889             user.amount += _brlAmount;
890             emit DepositBRL(msg.sender, _brlAmount);
891         }
892         if (_nftAmount > 0) {
893             user.nftBalance += _nftAmount;
894             nft.safeTransferFrom(msg.sender, address(this), 0, _nftAmount, "");
895             emit DepositNFT(msg.sender, _nftAmount);
896         }
897         user.rewardDebt = user.amount * accUSDCPerShare / 1e36;
898     }
899 
900     function withdraw(uint256 _brlAmount, uint256 _nftAmount) external {
901         UserInfo storage user = userInfo[msg.sender];
902         if (_brlAmount > user.amount || _nftAmount > user.nftBalance) {
903             revert InsufficientBalance(user.amount, _brlAmount, user.nftBalance, _nftAmount);
904         }
905         updatePool();
906         if (user.amount > 0) {
907             uint256 amountTransferred = _claimRewards(user.nftBalance, user.amount, user.rewardDebt);
908             user.totalRewards += amountTransferred;
909         }
910         if (_brlAmount > 0) {
911             user.amount -= _brlAmount;
912             brl.safeTransfer(address(msg.sender), _brlAmount);
913             emit WithdrawBRL(msg.sender, _brlAmount);
914         }
915         user.rewardDebt = user.amount * accUSDCPerShare / 1e36;
916         if (_nftAmount > 0) {
917             user.nftBalance -= _nftAmount;
918             nft.safeTransferFrom(address(this), msg.sender, 0, _nftAmount, "");
919             emit WithdrawNFT(msg.sender, _nftAmount);
920         }
921     }
922 
923     function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual returns (bytes4) {
924         return this.onERC1155Received.selector;
925     }
926 
927     function setRewardRate(uint256 _usdcPerSecond) external onlyOwner {
928         if (finished) {
929             revert AlreadyFinished();
930         }
931         usdcPerSecond = _usdcPerSecond;
932     }
933 
934     function startPool(uint256 _startTime) external onlyOwner {
935         if (started) {
936             revert AlreadyStarted();
937         }
938         started = true;
939         startTime = _startTime;
940         lastRewardTimestamp = _startTime;
941     }
942 
943     function finishPool() external onlyOwner {
944         if (finished) {
945             revert AlreadyFinished();
946         }
947         finished = true;
948         updatePool();
949         usdcPerSecond = 0;
950         uint256 usdcBalance = IERC20(usdc).balanceOf(address(this));
951         if (usdcBalance > rewardSupply) {
952             IERC20(usdc).transfer(owner(), usdcBalance - rewardSupply);
953         }
954     }
955 
956 }