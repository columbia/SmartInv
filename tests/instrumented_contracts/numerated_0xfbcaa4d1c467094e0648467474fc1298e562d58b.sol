1 /** 
2  *  
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [////IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * ////IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 
229 
230 
231 /** 
232  *  
233 */
234             
235 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
236 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Interface of the ERC20 standard as defined in the EIP.
242  */
243 interface IERC20 {
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 
258     /**
259      * @dev Returns the amount of tokens in existence.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     /**
264      * @dev Returns the amount of tokens owned by `account`.
265      */
266     function balanceOf(address account) external view returns (uint256);
267 
268     /**
269      * @dev Moves `amount` tokens from the caller's account to `to`.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transfer(address to, uint256 amount) external returns (bool);
276 
277     /**
278      * @dev Returns the remaining number of tokens that `spender` will be
279      * allowed to spend on behalf of `owner` through {transferFrom}. This is
280      * zero by default.
281      *
282      * This value changes when {approve} or {transferFrom} are called.
283      */
284     function allowance(address owner, address spender) external view returns (uint256);
285 
286     /**
287      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
292      * that someone may use both the old and the new allowance by unfortunate
293      * transaction ordering. One possible solution to mitigate this race
294      * condition is to first reduce the spender's allowance to 0 and set the
295      * desired value afterwards:
296      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address spender, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Moves `amount` tokens from `from` to `to` using the
304      * allowance mechanism. `amount` is then deducted from the caller's
305      * allowance.
306      *
307      * Returns a boolean value indicating whether the operation succeeded.
308      *
309      * Emits a {Transfer} event.
310      */
311     function transferFrom(
312         address from,
313         address to,
314         uint256 amount
315     ) external returns (bool);
316 }
317 
318 
319 
320 
321 /** 
322  *  
323 */
324             
325 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
326 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Provides information about the current execution context, including the
332  * sender of the transaction and its data. While these are generally available
333  * via msg.sender and msg.data, they should not be accessed in such a direct
334  * manner, since when dealing with meta-transactions the account sending and
335  * paying for execution may not be the actual sender (as far as an application
336  * is concerned).
337  *
338  * This contract is only required for intermediate, library-like contracts.
339  */
340 abstract contract Context {
341     function _msgSender() internal view virtual returns (address) {
342         return msg.sender;
343     }
344 
345     function _msgData() internal view virtual returns (bytes calldata) {
346         return msg.data;
347     }
348 }
349 
350 
351 
352 
353 /** 
354  *  
355 */
356             
357 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
358 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 ////import "../IERC20.sol";
363 ////import "../../../utils/Address.sol";
364 
365 /**
366  * @title SafeERC20
367  * @dev Wrappers around ERC20 operations that throw on failure (when the token
368  * contract returns false). Tokens that return no value (and instead revert or
369  * throw on failure) are also supported, non-reverting calls are assumed to be
370  * successful.
371  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
372  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
373  */
374 library SafeERC20 {
375     using Address for address;
376 
377     function safeTransfer(
378         IERC20 token,
379         address to,
380         uint256 value
381     ) internal {
382         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
383     }
384 
385     function safeTransferFrom(
386         IERC20 token,
387         address from,
388         address to,
389         uint256 value
390     ) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     /**
395      * @dev Deprecated. This function has issues similar to the ones found in
396      * {IERC20-approve}, and its usage is discouraged.
397      *
398      * Whenever possible, use {safeIncreaseAllowance} and
399      * {safeDecreaseAllowance} instead.
400      */
401     function safeApprove(
402         IERC20 token,
403         address spender,
404         uint256 value
405     ) internal {
406         // safeApprove should only be called when setting an initial allowance,
407         // or when resetting it to zero. To increase and decrease it, use
408         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
409         require(
410             (value == 0) || (token.allowance(address(this), spender) == 0),
411             "SafeERC20: approve from non-zero to non-zero allowance"
412         );
413         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
414     }
415 
416     function safeIncreaseAllowance(
417         IERC20 token,
418         address spender,
419         uint256 value
420     ) internal {
421         uint256 newAllowance = token.allowance(address(this), spender) + value;
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     function safeDecreaseAllowance(
426         IERC20 token,
427         address spender,
428         uint256 value
429     ) internal {
430         unchecked {
431             uint256 oldAllowance = token.allowance(address(this), spender);
432             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
433             uint256 newAllowance = oldAllowance - value;
434             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435         }
436     }
437 
438     /**
439      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
440      * on the return value: the return value is optional (but if data is returned, it must not be false).
441      * @param token The token targeted by the call.
442      * @param data The call data (encoded using abi.encode or one of its variants).
443      */
444     function _callOptionalReturn(IERC20 token, bytes memory data) private {
445         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
446         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
447         // the target address contains contract code and also asserts for success in the low-level call.
448 
449         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
450         if (returndata.length > 0) {
451             // Return data is optional
452             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
453         }
454     }
455 }
456 
457 
458 
459 
460 /** 
461  *  
462 */
463             
464 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
465 // ERC721A Contracts v4.2.2
466 // Creator: Chiru Labs
467 
468 pragma solidity ^0.8.4;
469 
470 /**
471  * @dev Interface of ERC721A.
472  */
473 interface IERC721A {
474     /**
475      * The caller must own the token or be an approved operator.
476      */
477     error ApprovalCallerNotOwnerNorApproved();
478 
479     /**
480      * The token does not exist.
481      */
482     error ApprovalQueryForNonexistentToken();
483 
484     /**
485      * The caller cannot approve to their own address.
486      */
487     error ApproveToCaller();
488 
489     /**
490      * Cannot query the balance for the zero address.
491      */
492     error BalanceQueryForZeroAddress();
493 
494     /**
495      * Cannot mint to the zero address.
496      */
497     error MintToZeroAddress();
498 
499     /**
500      * The quantity of tokens minted must be more than zero.
501      */
502     error MintZeroQuantity();
503 
504     /**
505      * The token does not exist.
506      */
507     error OwnerQueryForNonexistentToken();
508 
509     /**
510      * The caller must own the token or be an approved operator.
511      */
512     error TransferCallerNotOwnerNorApproved();
513 
514     /**
515      * The token must be owned by `from`.
516      */
517     error TransferFromIncorrectOwner();
518 
519     /**
520      * Cannot safely transfer to a contract that does not implement the
521      * ERC721Receiver interface.
522      */
523     error TransferToNonERC721ReceiverImplementer();
524 
525     /**
526      * Cannot transfer to the zero address.
527      */
528     error TransferToZeroAddress();
529 
530     /**
531      * The token does not exist.
532      */
533     error URIQueryForNonexistentToken();
534 
535     /**
536      * The `quantity` minted with ERC2309 exceeds the safety limit.
537      */
538     error MintERC2309QuantityExceedsLimit();
539 
540     /**
541      * The `extraData` cannot be set on an unintialized ownership slot.
542      */
543     error OwnershipNotInitializedForExtraData();
544 
545     // =============================================================
546     //                            STRUCTS
547     // =============================================================
548 
549     struct TokenOwnership {
550         // The address of the owner.
551         address addr;
552         // Stores the start time of ownership with minimal overhead for tokenomics.
553         uint64 startTimestamp;
554         // Whether the token has been burned.
555         bool burned;
556         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
557         uint24 extraData;
558     }
559 
560     // =============================================================
561     //                         TOKEN COUNTERS
562     // =============================================================
563 
564     /**
565      * @dev Returns the total number of tokens in existence.
566      * Burned tokens will reduce the count.
567      * To get the total number of tokens minted, please see {_totalMinted}.
568      */
569     function totalSupply() external view returns (uint256);
570 
571     // =============================================================
572     //                            IERC165
573     // =============================================================
574 
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) external view returns (bool);
584 
585     // =============================================================
586     //                            IERC721
587     // =============================================================
588 
589     /**
590      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
591      */
592     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
596      */
597     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
598 
599     /**
600      * @dev Emitted when `owner` enables or disables
601      * (`approved`) `operator` to manage all of its assets.
602      */
603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
604 
605     /**
606      * @dev Returns the number of tokens in `owner`'s account.
607      */
608     function balanceOf(address owner) external view returns (uint256 balance);
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) external view returns (address owner);
618 
619     /**
620      * @dev Safely transfers `tokenId` token from `from` to `to`,
621      * checking first that contract recipients are aware of the ERC721 protocol
622      * to prevent tokens from being forever locked.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be have been allowed to move
630      * this token by either {approve} or {setApprovalForAll}.
631      * - If `to` refers to a smart contract, it must implement
632      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
633      *
634      * Emits a {Transfer} event.
635      */
636     function safeTransferFrom(
637         address from,
638         address to,
639         uint256 tokenId,
640         bytes calldata data
641     ) external;
642 
643     /**
644      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
645      */
646     function safeTransferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) external;
651 
652     /**
653      * @dev Transfers `tokenId` from `from` to `to`.
654      *
655      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
656      * whenever possible.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token
664      * by either {approve} or {setApprovalForAll}.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
676      * The approval is cleared when the token is transferred.
677      *
678      * Only a single account can be approved at a time, so approving the
679      * zero address clears previous approvals.
680      *
681      * Requirements:
682      *
683      * - The caller must own the token or be an approved operator.
684      * - `tokenId` must exist.
685      *
686      * Emits an {Approval} event.
687      */
688     function approve(address to, uint256 tokenId) external;
689 
690     /**
691      * @dev Approve or remove `operator` as an operator for the caller.
692      * Operators can call {transferFrom} or {safeTransferFrom}
693      * for any token owned by the caller.
694      *
695      * Requirements:
696      *
697      * - The `operator` cannot be the caller.
698      *
699      * Emits an {ApprovalForAll} event.
700      */
701     function setApprovalForAll(address operator, bool _approved) external;
702 
703     /**
704      * @dev Returns the account approved for `tokenId` token.
705      *
706      * Requirements:
707      *
708      * - `tokenId` must exist.
709      */
710     function getApproved(uint256 tokenId) external view returns (address operator);
711 
712     /**
713      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
714      *
715      * See {setApprovalForAll}.
716      */
717     function isApprovedForAll(address owner, address operator) external view returns (bool);
718 
719     // =============================================================
720     //                        IERC721Metadata
721     // =============================================================
722 
723     /**
724      * @dev Returns the token collection name.
725      */
726     function name() external view returns (string memory);
727 
728     /**
729      * @dev Returns the token collection symbol.
730      */
731     function symbol() external view returns (string memory);
732 
733     /**
734      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
735      */
736     function tokenURI(uint256 tokenId) external view returns (string memory);
737 
738     // =============================================================
739     //                           IERC2309
740     // =============================================================
741 
742     /**
743      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
744      * (inclusive) is transferred from `from` to `to`, as defined in the
745      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
746      *
747      * See {_mintERC2309} for more details.
748      */
749     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
750 }
751 
752 
753 
754 
755 /** 
756  *  
757 */
758             
759 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
760 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 ////import "../token/ERC20/utils/SafeERC20.sol";
765 ////import "../utils/Address.sol";
766 ////import "../utils/Context.sol";
767 
768 /**
769  * @title PaymentSplitter
770  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
771  * that the Ether will be split in this way, since it is handled transparently by the contract.
772  *
773  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
774  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
775  * an amount proportional to the percentage of total shares they were assigned.
776  *
777  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
778  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
779  * function.
780  *
781  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
782  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
783  * to run tests before sending real value to this contract.
784  */
785 contract PaymentSplitter is Context {
786     event PayeeAdded(address account, uint256 shares);
787     event PaymentReleased(address to, uint256 amount);
788     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
789     event PaymentReceived(address from, uint256 amount);
790 
791     uint256 private _totalShares;
792     uint256 private _totalReleased;
793 
794     mapping(address => uint256) private _shares;
795     mapping(address => uint256) private _released;
796     address[] private _payees;
797 
798     mapping(IERC20 => uint256) private _erc20TotalReleased;
799     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
800 
801     /**
802      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
803      * the matching position in the `shares` array.
804      *
805      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
806      * duplicates in `payees`.
807      */
808     constructor(address[] memory payees, uint256[] memory shares_) payable {
809         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
810         require(payees.length > 0, "PaymentSplitter: no payees");
811 
812         for (uint256 i = 0; i < payees.length; i++) {
813             _addPayee(payees[i], shares_[i]);
814         }
815     }
816 
817     /**
818      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
819      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
820      * reliability of the events, and not the actual splitting of Ether.
821      *
822      * To learn more about this see the Solidity documentation for
823      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
824      * functions].
825      */
826     receive() external payable virtual {
827         emit PaymentReceived(_msgSender(), msg.value);
828     }
829 
830     /**
831      * @dev Getter for the total shares held by payees.
832      */
833     function totalShares() public view returns (uint256) {
834         return _totalShares;
835     }
836 
837     /**
838      * @dev Getter for the total amount of Ether already released.
839      */
840     function totalReleased() public view returns (uint256) {
841         return _totalReleased;
842     }
843 
844     /**
845      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
846      * contract.
847      */
848     function totalReleased(IERC20 token) public view returns (uint256) {
849         return _erc20TotalReleased[token];
850     }
851 
852     /**
853      * @dev Getter for the amount of shares held by an account.
854      */
855     function shares(address account) public view returns (uint256) {
856         return _shares[account];
857     }
858 
859     /**
860      * @dev Getter for the amount of Ether already released to a payee.
861      */
862     function released(address account) public view returns (uint256) {
863         return _released[account];
864     }
865 
866     /**
867      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
868      * IERC20 contract.
869      */
870     function released(IERC20 token, address account) public view returns (uint256) {
871         return _erc20Released[token][account];
872     }
873 
874     /**
875      * @dev Getter for the address of the payee number `index`.
876      */
877     function payee(uint256 index) public view returns (address) {
878         return _payees[index];
879     }
880 
881     /**
882      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
883      * total shares and their previous withdrawals.
884      */
885     function release(address payable account) public virtual {
886         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
887 
888         uint256 totalReceived = address(this).balance + totalReleased();
889         uint256 payment = _pendingPayment(account, totalReceived, released(account));
890 
891         require(payment != 0, "PaymentSplitter: account is not due payment");
892 
893         _released[account] += payment;
894         _totalReleased += payment;
895 
896         Address.sendValue(account, payment);
897         emit PaymentReleased(account, payment);
898     }
899 
900     /**
901      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
902      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
903      * contract.
904      */
905     function release(IERC20 token, address account) public virtual {
906         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
907 
908         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
909         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
910 
911         require(payment != 0, "PaymentSplitter: account is not due payment");
912 
913         _erc20Released[token][account] += payment;
914         _erc20TotalReleased[token] += payment;
915 
916         SafeERC20.safeTransfer(token, account, payment);
917         emit ERC20PaymentReleased(token, account, payment);
918     }
919 
920     /**
921      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
922      * already released amounts.
923      */
924     function _pendingPayment(
925         address account,
926         uint256 totalReceived,
927         uint256 alreadyReleased
928     ) private view returns (uint256) {
929         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
930     }
931 
932     /**
933      * @dev Add a new payee to the contract.
934      * @param account The address of the payee to add.
935      * @param shares_ The number of shares owned by the payee.
936      */
937     function _addPayee(address account, uint256 shares_) private {
938         require(account != address(0), "PaymentSplitter: account is the zero address");
939         require(shares_ > 0, "PaymentSplitter: shares are 0");
940         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
941 
942         _payees.push(account);
943         _shares[account] = shares_;
944         _totalShares = _totalShares + shares_;
945         emit PayeeAdded(account, shares_);
946     }
947 }
948 
949 
950 
951 
952 /** 
953  *  
954 */
955             
956 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
957 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
958 
959 pragma solidity ^0.8.0;
960 
961 /**
962  * @dev String operations.
963  */
964 library Strings {
965     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
966 
967     /**
968      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
969      */
970     function toString(uint256 value) internal pure returns (string memory) {
971         // Inspired by OraclizeAPI's implementation - MIT licence
972         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
973 
974         if (value == 0) {
975             return "0";
976         }
977         uint256 temp = value;
978         uint256 digits;
979         while (temp != 0) {
980             digits++;
981             temp /= 10;
982         }
983         bytes memory buffer = new bytes(digits);
984         while (value != 0) {
985             digits -= 1;
986             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
987             value /= 10;
988         }
989         return string(buffer);
990     }
991 
992     /**
993      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
994      */
995     function toHexString(uint256 value) internal pure returns (string memory) {
996         if (value == 0) {
997             return "0x00";
998         }
999         uint256 temp = value;
1000         uint256 length = 0;
1001         while (temp != 0) {
1002             length++;
1003             temp >>= 8;
1004         }
1005         return toHexString(value, length);
1006     }
1007 
1008     /**
1009      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1010      */
1011     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1012         bytes memory buffer = new bytes(2 * length + 2);
1013         buffer[0] = "0";
1014         buffer[1] = "x";
1015         for (uint256 i = 2 * length + 1; i > 1; --i) {
1016             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1017             value >>= 4;
1018         }
1019         require(value == 0, "Strings: hex length insufficient");
1020         return string(buffer);
1021     }
1022 }
1023 
1024 
1025 
1026 
1027 /** 
1028  *  
1029 */
1030             
1031 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1032 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 /**
1037  * @dev These functions deal with verification of Merkle Trees proofs.
1038  *
1039  * The proofs can be generated using the JavaScript library
1040  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1041  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1042  *
1043  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1044  *
1045  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1046  * hashing, or use a hash function other than keccak256 for hashing leaves.
1047  * This is because the concatenation of a sorted pair of internal nodes in
1048  * the merkle tree could be reinterpreted as a leaf value.
1049  */
1050 library MerkleProof {
1051     /**
1052      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1053      * defined by `root`. For this, a `proof` must be provided, containing
1054      * sibling hashes on the branch from the leaf to the root of the tree. Each
1055      * pair of leaves and each pair of pre-images are assumed to be sorted.
1056      */
1057     function verify(
1058         bytes32[] memory proof,
1059         bytes32 root,
1060         bytes32 leaf
1061     ) internal pure returns (bool) {
1062         return processProof(proof, leaf) == root;
1063     }
1064 
1065     /**
1066      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1067      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1068      * hash matches the root of the tree. When processing the proof, the pairs
1069      * of leafs & pre-images are assumed to be sorted.
1070      *
1071      * _Available since v4.4._
1072      */
1073     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1074         bytes32 computedHash = leaf;
1075         for (uint256 i = 0; i < proof.length; i++) {
1076             bytes32 proofElement = proof[i];
1077             if (computedHash <= proofElement) {
1078                 // Hash(current computed hash + current element of the proof)
1079                 computedHash = _efficientHash(computedHash, proofElement);
1080             } else {
1081                 // Hash(current element of the proof + current computed hash)
1082                 computedHash = _efficientHash(proofElement, computedHash);
1083             }
1084         }
1085         return computedHash;
1086     }
1087 
1088     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1089         assembly {
1090             mstore(0x00, a)
1091             mstore(0x20, b)
1092             value := keccak256(0x00, 0x40)
1093         }
1094     }
1095 }
1096 
1097 
1098 
1099 
1100 /** 
1101  *  
1102 */
1103             
1104 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 ////import "../utils/Context.sol";
1110 
1111 /**
1112  * @dev Contract module which provides a basic access control mechanism, where
1113  * there is an account (an owner) that can be granted exclusive access to
1114  * specific functions.
1115  *
1116  * By default, the owner account will be the one that deploys the contract. This
1117  * can later be changed with {transferOwnership}.
1118  *
1119  * This module is used through inheritance. It will make available the modifier
1120  * `onlyOwner`, which can be applied to your functions to restrict their use to
1121  * the owner.
1122  */
1123 abstract contract Ownable is Context {
1124     address private _owner;
1125 
1126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1127 
1128     /**
1129      * @dev Initializes the contract setting the deployer as the initial owner.
1130      */
1131     constructor() {
1132         _transferOwnership(_msgSender());
1133     }
1134 
1135     /**
1136      * @dev Returns the address of the current owner.
1137      */
1138     function owner() public view virtual returns (address) {
1139         return _owner;
1140     }
1141 
1142     /**
1143      * @dev Throws if called by any account other than the owner.
1144      */
1145     modifier onlyOwner() {
1146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1147         _;
1148     }
1149 
1150     /**
1151      * @dev Leaves the contract without owner. It will not be possible to call
1152      * `onlyOwner` functions anymore. Can only be called by the current owner.
1153      *
1154      * NOTE: Renouncing ownership will leave the contract without an owner,
1155      * thereby removing any functionality that is only available to the owner.
1156      */
1157     function renounceOwnership() public virtual onlyOwner {
1158         _transferOwnership(address(0));
1159     }
1160 
1161     /**
1162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1163      * Can only be called by the current owner.
1164      */
1165     function transferOwnership(address newOwner) public virtual onlyOwner {
1166         require(newOwner != address(0), "Ownable: new owner is the zero address");
1167         _transferOwnership(newOwner);
1168     }
1169 
1170     /**
1171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1172      * Internal function without access restriction.
1173      */
1174     function _transferOwnership(address newOwner) internal virtual {
1175         address oldOwner = _owner;
1176         _owner = newOwner;
1177         emit OwnershipTransferred(oldOwner, newOwner);
1178     }
1179 }
1180 
1181 
1182 
1183 
1184 /** 
1185  *  
1186 */
1187             
1188 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1189 // ERC721A Contracts v4.2.2
1190 // Creator: Chiru Labs
1191 
1192 pragma solidity ^0.8.4;
1193 
1194 ////import './IERC721A.sol';
1195 
1196 /**
1197  * @dev Interface of ERC721 token receiver.
1198  */
1199 interface ERC721A__IERC721Receiver {
1200     function onERC721Received(
1201         address operator,
1202         address from,
1203         uint256 tokenId,
1204         bytes calldata data
1205     ) external returns (bytes4);
1206 }
1207 
1208 /**
1209  * @title ERC721A
1210  *
1211  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1212  * Non-Fungible Token Standard, including the Metadata extension.
1213  * Optimized for lower gas during batch mints.
1214  *
1215  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1216  * starting from `_startTokenId()`.
1217  *
1218  * Assumptions:
1219  *
1220  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1221  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1222  */
1223 contract ERC721A is IERC721A {
1224     // Reference type for token approval.
1225     struct TokenApprovalRef {
1226         address value;
1227     }
1228 
1229     // =============================================================
1230     //                           CONSTANTS
1231     // =============================================================
1232 
1233     // Mask of an entry in packed address data.
1234     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1235 
1236     // The bit position of `numberMinted` in packed address data.
1237     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1238 
1239     // The bit position of `numberBurned` in packed address data.
1240     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1241 
1242     // The bit position of `aux` in packed address data.
1243     uint256 private constant _BITPOS_AUX = 192;
1244 
1245     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1246     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1247 
1248     // The bit position of `startTimestamp` in packed ownership.
1249     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1250 
1251     // The bit mask of the `burned` bit in packed ownership.
1252     uint256 private constant _BITMASK_BURNED = 1 << 224;
1253 
1254     // The bit position of the `nextInitialized` bit in packed ownership.
1255     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1256 
1257     // The bit mask of the `nextInitialized` bit in packed ownership.
1258     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1259 
1260     // The bit position of `extraData` in packed ownership.
1261     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1262 
1263     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1264     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1265 
1266     // The mask of the lower 160 bits for addresses.
1267     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1268 
1269     // The maximum `quantity` that can be minted with {_mintERC2309}.
1270     // This limit is to prevent overflows on the address data entries.
1271     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1272     // is required to cause an overflow, which is unrealistic.
1273     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1274 
1275     // The `Transfer` event signature is given by:
1276     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1277     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1278         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1279 
1280     // =============================================================
1281     //                            STORAGE
1282     // =============================================================
1283 
1284     // The next token ID to be minted.
1285     uint256 private _currentIndex;
1286 
1287     // The number of tokens burned.
1288     uint256 private _burnCounter;
1289 
1290     // Token name
1291     string private _name;
1292 
1293     // Token symbol
1294     string private _symbol;
1295 
1296     // Mapping from token ID to ownership details
1297     // An empty struct value does not necessarily mean the token is unowned.
1298     // See {_packedOwnershipOf} implementation for details.
1299     //
1300     // Bits Layout:
1301     // - [0..159]   `addr`
1302     // - [160..223] `startTimestamp`
1303     // - [224]      `burned`
1304     // - [225]      `nextInitialized`
1305     // - [232..255] `extraData`
1306     mapping(uint256 => uint256) private _packedOwnerships;
1307 
1308     // Mapping owner address to address data.
1309     //
1310     // Bits Layout:
1311     // - [0..63]    `balance`
1312     // - [64..127]  `numberMinted`
1313     // - [128..191] `numberBurned`
1314     // - [192..255] `aux`
1315     mapping(address => uint256) private _packedAddressData;
1316 
1317     // Mapping from token ID to approved address.
1318     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1319 
1320     // Mapping from owner to operator approvals
1321     mapping(address => mapping(address => bool)) private _operatorApprovals;
1322 
1323     // =============================================================
1324     //                          CONSTRUCTOR
1325     // =============================================================
1326 
1327     constructor(string memory name_, string memory symbol_) {
1328         _name = name_;
1329         _symbol = symbol_;
1330         _currentIndex = _startTokenId();
1331     }
1332 
1333     // =============================================================
1334     //                   TOKEN COUNTING OPERATIONS
1335     // =============================================================
1336 
1337     /**
1338      * @dev Returns the starting token ID.
1339      * To change the starting token ID, please override this function.
1340      */
1341     function _startTokenId() internal view virtual returns (uint256) {
1342         return 0;
1343     }
1344 
1345     /**
1346      * @dev Returns the next token ID to be minted.
1347      */
1348     function _nextTokenId() internal view virtual returns (uint256) {
1349         return _currentIndex;
1350     }
1351 
1352     /**
1353      * @dev Returns the total number of tokens in existence.
1354      * Burned tokens will reduce the count.
1355      * To get the total number of tokens minted, please see {_totalMinted}.
1356      */
1357     function totalSupply() public view virtual override returns (uint256) {
1358         // Counter underflow is impossible as _burnCounter cannot be incremented
1359         // more than `_currentIndex - _startTokenId()` times.
1360         unchecked {
1361             return _currentIndex - _burnCounter - _startTokenId();
1362         }
1363     }
1364 
1365     /**
1366      * @dev Returns the total amount of tokens minted in the contract.
1367      */
1368     function _totalMinted() internal view virtual returns (uint256) {
1369         // Counter underflow is impossible as `_currentIndex` does not decrement,
1370         // and it is initialized to `_startTokenId()`.
1371         unchecked {
1372             return _currentIndex - _startTokenId();
1373         }
1374     }
1375 
1376     /**
1377      * @dev Returns the total number of tokens burned.
1378      */
1379     function _totalBurned() internal view virtual returns (uint256) {
1380         return _burnCounter;
1381     }
1382 
1383     // =============================================================
1384     //                    ADDRESS DATA OPERATIONS
1385     // =============================================================
1386 
1387     /**
1388      * @dev Returns the number of tokens in `owner`'s account.
1389      */
1390     function balanceOf(address owner) public view virtual override returns (uint256) {
1391         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1392         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1393     }
1394 
1395     /**
1396      * Returns the number of tokens minted by `owner`.
1397      */
1398     function _numberMinted(address owner) internal view returns (uint256) {
1399         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1400     }
1401 
1402     /**
1403      * Returns the number of tokens burned by or on behalf of `owner`.
1404      */
1405     function _numberBurned(address owner) internal view returns (uint256) {
1406         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1407     }
1408 
1409     /**
1410      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1411      */
1412     function _getAux(address owner) internal view returns (uint64) {
1413         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1414     }
1415 
1416     /**
1417      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1418      * If there are multiple variables, please pack them into a uint64.
1419      */
1420     function _setAux(address owner, uint64 aux) internal virtual {
1421         uint256 packed = _packedAddressData[owner];
1422         uint256 auxCasted;
1423         // Cast `aux` with assembly to avoid redundant masking.
1424         assembly {
1425             auxCasted := aux
1426         }
1427         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1428         _packedAddressData[owner] = packed;
1429     }
1430 
1431     // =============================================================
1432     //                            IERC165
1433     // =============================================================
1434 
1435     /**
1436      * @dev Returns true if this contract implements the interface defined by
1437      * `interfaceId`. See the corresponding
1438      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1439      * to learn more about how these ids are created.
1440      *
1441      * This function call must use less than 30000 gas.
1442      */
1443     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1444         // The interface IDs are constants representing the first 4 bytes
1445         // of the XOR of all function selectors in the interface.
1446         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1447         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1448         return
1449             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1450             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1451             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1452     }
1453 
1454     // =============================================================
1455     //                        IERC721Metadata
1456     // =============================================================
1457 
1458     /**
1459      * @dev Returns the token collection name.
1460      */
1461     function name() public view virtual override returns (string memory) {
1462         return _name;
1463     }
1464 
1465     /**
1466      * @dev Returns the token collection symbol.
1467      */
1468     function symbol() public view virtual override returns (string memory) {
1469         return _symbol;
1470     }
1471 
1472     /**
1473      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1474      */
1475     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1476         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1477 
1478         string memory baseURI = _baseURI();
1479         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1480     }
1481 
1482     /**
1483      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1484      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1485      * by default, it can be overridden in child contracts.
1486      */
1487     function _baseURI() internal view virtual returns (string memory) {
1488         return '';
1489     }
1490 
1491     // =============================================================
1492     //                     OWNERSHIPS OPERATIONS
1493     // =============================================================
1494 
1495     /**
1496      * @dev Returns the owner of the `tokenId` token.
1497      *
1498      * Requirements:
1499      *
1500      * - `tokenId` must exist.
1501      */
1502     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1503         return address(uint160(_packedOwnershipOf(tokenId)));
1504     }
1505 
1506     /**
1507      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1508      * It gradually moves to O(1) as tokens get transferred around over time.
1509      */
1510     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1511         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1512     }
1513 
1514     /**
1515      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1516      */
1517     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1518         return _unpackedOwnership(_packedOwnerships[index]);
1519     }
1520 
1521     /**
1522      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1523      */
1524     function _initializeOwnershipAt(uint256 index) internal virtual {
1525         if (_packedOwnerships[index] == 0) {
1526             _packedOwnerships[index] = _packedOwnershipOf(index);
1527         }
1528     }
1529 
1530     /**
1531      * Returns the packed ownership data of `tokenId`.
1532      */
1533     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1534         uint256 curr = tokenId;
1535 
1536         unchecked {
1537             if (_startTokenId() <= curr)
1538                 if (curr < _currentIndex) {
1539                     uint256 packed = _packedOwnerships[curr];
1540                     // If not burned.
1541                     if (packed & _BITMASK_BURNED == 0) {
1542                         // Invariant:
1543                         // There will always be an initialized ownership slot
1544                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1545                         // before an unintialized ownership slot
1546                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1547                         // Hence, `curr` will not underflow.
1548                         //
1549                         // We can directly compare the packed value.
1550                         // If the address is zero, packed will be zero.
1551                         while (packed == 0) {
1552                             packed = _packedOwnerships[--curr];
1553                         }
1554                         return packed;
1555                     }
1556                 }
1557         }
1558         revert OwnerQueryForNonexistentToken();
1559     }
1560 
1561     /**
1562      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1563      */
1564     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1565         ownership.addr = address(uint160(packed));
1566         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1567         ownership.burned = packed & _BITMASK_BURNED != 0;
1568         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1569     }
1570 
1571     /**
1572      * @dev Packs ownership data into a single uint256.
1573      */
1574     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1575         assembly {
1576             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1577             owner := and(owner, _BITMASK_ADDRESS)
1578             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1579             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1580         }
1581     }
1582 
1583     /**
1584      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1585      */
1586     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1587         // For branchless setting of the `nextInitialized` flag.
1588         assembly {
1589             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1590             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1591         }
1592     }
1593 
1594     // =============================================================
1595     //                      APPROVAL OPERATIONS
1596     // =============================================================
1597 
1598     /**
1599      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1600      * The approval is cleared when the token is transferred.
1601      *
1602      * Only a single account can be approved at a time, so approving the
1603      * zero address clears previous approvals.
1604      *
1605      * Requirements:
1606      *
1607      * - The caller must own the token or be an approved operator.
1608      * - `tokenId` must exist.
1609      *
1610      * Emits an {Approval} event.
1611      */
1612     function approve(address to, uint256 tokenId) public virtual override {
1613         address owner = ownerOf(tokenId);
1614 
1615         if (_msgSenderERC721A() != owner)
1616             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1617                 revert ApprovalCallerNotOwnerNorApproved();
1618             }
1619 
1620         _tokenApprovals[tokenId].value = to;
1621         emit Approval(owner, to, tokenId);
1622     }
1623 
1624     /**
1625      * @dev Returns the account approved for `tokenId` token.
1626      *
1627      * Requirements:
1628      *
1629      * - `tokenId` must exist.
1630      */
1631     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1632         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1633 
1634         return _tokenApprovals[tokenId].value;
1635     }
1636 
1637     /**
1638      * @dev Approve or remove `operator` as an operator for the caller.
1639      * Operators can call {transferFrom} or {safeTransferFrom}
1640      * for any token owned by the caller.
1641      *
1642      * Requirements:
1643      *
1644      * - The `operator` cannot be the caller.
1645      *
1646      * Emits an {ApprovalForAll} event.
1647      */
1648     function setApprovalForAll(address operator, bool approved) public virtual override {
1649         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1650 
1651         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1652         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1653     }
1654 
1655     /**
1656      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1657      *
1658      * See {setApprovalForAll}.
1659      */
1660     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1661         return _operatorApprovals[owner][operator];
1662     }
1663 
1664     /**
1665      * @dev Returns whether `tokenId` exists.
1666      *
1667      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1668      *
1669      * Tokens start existing when they are minted. See {_mint}.
1670      */
1671     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1672         return
1673             _startTokenId() <= tokenId &&
1674             tokenId < _currentIndex && // If within bounds,
1675             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1676     }
1677 
1678     /**
1679      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1680      */
1681     function _isSenderApprovedOrOwner(
1682         address approvedAddress,
1683         address owner,
1684         address msgSender
1685     ) private pure returns (bool result) {
1686         assembly {
1687             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1688             owner := and(owner, _BITMASK_ADDRESS)
1689             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1690             msgSender := and(msgSender, _BITMASK_ADDRESS)
1691             // `msgSender == owner || msgSender == approvedAddress`.
1692             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1693         }
1694     }
1695 
1696     /**
1697      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1698      */
1699     function _getApprovedSlotAndAddress(uint256 tokenId)
1700         private
1701         view
1702         returns (uint256 approvedAddressSlot, address approvedAddress)
1703     {
1704         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1705         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1706         assembly {
1707             approvedAddressSlot := tokenApproval.slot
1708             approvedAddress := sload(approvedAddressSlot)
1709         }
1710     }
1711 
1712     // =============================================================
1713     //                      TRANSFER OPERATIONS
1714     // =============================================================
1715 
1716     /**
1717      * @dev Transfers `tokenId` from `from` to `to`.
1718      *
1719      * Requirements:
1720      *
1721      * - `from` cannot be the zero address.
1722      * - `to` cannot be the zero address.
1723      * - `tokenId` token must be owned by `from`.
1724      * - If the caller is not `from`, it must be approved to move this token
1725      * by either {approve} or {setApprovalForAll}.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function transferFrom(
1730         address from,
1731         address to,
1732         uint256 tokenId
1733     ) public virtual override {
1734         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1735 
1736         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1737 
1738         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1739 
1740         // The nested ifs save around 20+ gas over a compound boolean condition.
1741         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1742             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1743 
1744         if (to == address(0)) revert TransferToZeroAddress();
1745 
1746         _beforeTokenTransfers(from, to, tokenId, 1);
1747 
1748         // Clear approvals from the previous owner.
1749         assembly {
1750             if approvedAddress {
1751                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1752                 sstore(approvedAddressSlot, 0)
1753             }
1754         }
1755 
1756         // Underflow of the sender's balance is impossible because we check for
1757         // ownership above and the recipient's balance can't realistically overflow.
1758         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1759         unchecked {
1760             // We can directly increment and decrement the balances.
1761             --_packedAddressData[from]; // Updates: `balance -= 1`.
1762             ++_packedAddressData[to]; // Updates: `balance += 1`.
1763 
1764             // Updates:
1765             // - `address` to the next owner.
1766             // - `startTimestamp` to the timestamp of transfering.
1767             // - `burned` to `false`.
1768             // - `nextInitialized` to `true`.
1769             _packedOwnerships[tokenId] = _packOwnershipData(
1770                 to,
1771                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1772             );
1773 
1774             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1775             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1776                 uint256 nextTokenId = tokenId + 1;
1777                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1778                 if (_packedOwnerships[nextTokenId] == 0) {
1779                     // If the next slot is within bounds.
1780                     if (nextTokenId != _currentIndex) {
1781                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1782                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1783                     }
1784                 }
1785             }
1786         }
1787 
1788         emit Transfer(from, to, tokenId);
1789         _afterTokenTransfers(from, to, tokenId, 1);
1790     }
1791 
1792     /**
1793      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1794      */
1795     function safeTransferFrom(
1796         address from,
1797         address to,
1798         uint256 tokenId
1799     ) public virtual override {
1800         safeTransferFrom(from, to, tokenId, '');
1801     }
1802 
1803     /**
1804      * @dev Safely transfers `tokenId` token from `from` to `to`.
1805      *
1806      * Requirements:
1807      *
1808      * - `from` cannot be the zero address.
1809      * - `to` cannot be the zero address.
1810      * - `tokenId` token must exist and be owned by `from`.
1811      * - If the caller is not `from`, it must be approved to move this token
1812      * by either {approve} or {setApprovalForAll}.
1813      * - If `to` refers to a smart contract, it must implement
1814      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1815      *
1816      * Emits a {Transfer} event.
1817      */
1818     function safeTransferFrom(
1819         address from,
1820         address to,
1821         uint256 tokenId,
1822         bytes memory _data
1823     ) public virtual override {
1824         transferFrom(from, to, tokenId);
1825         if (to.code.length != 0)
1826             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1827                 revert TransferToNonERC721ReceiverImplementer();
1828             }
1829     }
1830 
1831     /**
1832      * @dev Hook that is called before a set of serially-ordered token IDs
1833      * are about to be transferred. This includes minting.
1834      * And also called before burning one token.
1835      *
1836      * `startTokenId` - the first token ID to be transferred.
1837      * `quantity` - the amount to be transferred.
1838      *
1839      * Calling conditions:
1840      *
1841      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1842      * transferred to `to`.
1843      * - When `from` is zero, `tokenId` will be minted for `to`.
1844      * - When `to` is zero, `tokenId` will be burned by `from`.
1845      * - `from` and `to` are never both zero.
1846      */
1847     function _beforeTokenTransfers(
1848         address from,
1849         address to,
1850         uint256 startTokenId,
1851         uint256 quantity
1852     ) internal virtual {}
1853 
1854     /**
1855      * @dev Hook that is called after a set of serially-ordered token IDs
1856      * have been transferred. This includes minting.
1857      * And also called after one token has been burned.
1858      *
1859      * `startTokenId` - the first token ID to be transferred.
1860      * `quantity` - the amount to be transferred.
1861      *
1862      * Calling conditions:
1863      *
1864      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1865      * transferred to `to`.
1866      * - When `from` is zero, `tokenId` has been minted for `to`.
1867      * - When `to` is zero, `tokenId` has been burned by `from`.
1868      * - `from` and `to` are never both zero.
1869      */
1870     function _afterTokenTransfers(
1871         address from,
1872         address to,
1873         uint256 startTokenId,
1874         uint256 quantity
1875     ) internal virtual {}
1876 
1877     /**
1878      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1879      *
1880      * `from` - Previous owner of the given token ID.
1881      * `to` - Target address that will receive the token.
1882      * `tokenId` - Token ID to be transferred.
1883      * `_data` - Optional data to send along with the call.
1884      *
1885      * Returns whether the call correctly returned the expected magic value.
1886      */
1887     function _checkContractOnERC721Received(
1888         address from,
1889         address to,
1890         uint256 tokenId,
1891         bytes memory _data
1892     ) private returns (bool) {
1893         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1894             bytes4 retval
1895         ) {
1896             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1897         } catch (bytes memory reason) {
1898             if (reason.length == 0) {
1899                 revert TransferToNonERC721ReceiverImplementer();
1900             } else {
1901                 assembly {
1902                     revert(add(32, reason), mload(reason))
1903                 }
1904             }
1905         }
1906     }
1907 
1908     // =============================================================
1909     //                        MINT OPERATIONS
1910     // =============================================================
1911 
1912     /**
1913      * @dev Mints `quantity` tokens and transfers them to `to`.
1914      *
1915      * Requirements:
1916      *
1917      * - `to` cannot be the zero address.
1918      * - `quantity` must be greater than 0.
1919      *
1920      * Emits a {Transfer} event for each mint.
1921      */
1922     function _mint(address to, uint256 quantity) internal virtual {
1923         uint256 startTokenId = _currentIndex;
1924         if (quantity == 0) revert MintZeroQuantity();
1925 
1926         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1927 
1928         // Overflows are incredibly unrealistic.
1929         // `balance` and `numberMinted` have a maximum limit of 2**64.
1930         // `tokenId` has a maximum limit of 2**256.
1931         unchecked {
1932             // Updates:
1933             // - `balance += quantity`.
1934             // - `numberMinted += quantity`.
1935             //
1936             // We can directly add to the `balance` and `numberMinted`.
1937             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1938 
1939             // Updates:
1940             // - `address` to the owner.
1941             // - `startTimestamp` to the timestamp of minting.
1942             // - `burned` to `false`.
1943             // - `nextInitialized` to `quantity == 1`.
1944             _packedOwnerships[startTokenId] = _packOwnershipData(
1945                 to,
1946                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1947             );
1948 
1949             uint256 toMasked;
1950             uint256 end = startTokenId + quantity;
1951 
1952             // Use assembly to loop and emit the `Transfer` event for gas savings.
1953             assembly {
1954                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1955                 toMasked := and(to, _BITMASK_ADDRESS)
1956                 // Emit the `Transfer` event.
1957                 log4(
1958                     0, // Start of data (0, since no data).
1959                     0, // End of data (0, since no data).
1960                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1961                     0, // `address(0)`.
1962                     toMasked, // `to`.
1963                     startTokenId // `tokenId`.
1964                 )
1965 
1966                 for {
1967                     let tokenId := add(startTokenId, 1)
1968                 } iszero(eq(tokenId, end)) {
1969                     tokenId := add(tokenId, 1)
1970                 } {
1971                     // Emit the `Transfer` event. Similar to above.
1972                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1973                 }
1974             }
1975             if (toMasked == 0) revert MintToZeroAddress();
1976 
1977             _currentIndex = end;
1978         }
1979         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1980     }
1981 
1982     /**
1983      * @dev Mints `quantity` tokens and transfers them to `to`.
1984      *
1985      * This function is intended for efficient minting only during contract creation.
1986      *
1987      * It emits only one {ConsecutiveTransfer} as defined in
1988      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1989      * instead of a sequence of {Transfer} event(s).
1990      *
1991      * Calling this function outside of contract creation WILL make your contract
1992      * non-compliant with the ERC721 standard.
1993      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1994      * {ConsecutiveTransfer} event is only permissible during contract creation.
1995      *
1996      * Requirements:
1997      *
1998      * - `to` cannot be the zero address.
1999      * - `quantity` must be greater than 0.
2000      *
2001      * Emits a {ConsecutiveTransfer} event.
2002      */
2003     function _mintERC2309(address to, uint256 quantity) internal virtual {
2004         uint256 startTokenId = _currentIndex;
2005         if (to == address(0)) revert MintToZeroAddress();
2006         if (quantity == 0) revert MintZeroQuantity();
2007         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2008 
2009         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2010 
2011         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2012         unchecked {
2013             // Updates:
2014             // - `balance += quantity`.
2015             // - `numberMinted += quantity`.
2016             //
2017             // We can directly add to the `balance` and `numberMinted`.
2018             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2019 
2020             // Updates:
2021             // - `address` to the owner.
2022             // - `startTimestamp` to the timestamp of minting.
2023             // - `burned` to `false`.
2024             // - `nextInitialized` to `quantity == 1`.
2025             _packedOwnerships[startTokenId] = _packOwnershipData(
2026                 to,
2027                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2028             );
2029 
2030             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2031 
2032             _currentIndex = startTokenId + quantity;
2033         }
2034         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2035     }
2036 
2037     /**
2038      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2039      *
2040      * Requirements:
2041      *
2042      * - If `to` refers to a smart contract, it must implement
2043      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2044      * - `quantity` must be greater than 0.
2045      *
2046      * See {_mint}.
2047      *
2048      * Emits a {Transfer} event for each mint.
2049      */
2050     function _safeMint(
2051         address to,
2052         uint256 quantity,
2053         bytes memory _data
2054     ) internal virtual {
2055         _mint(to, quantity);
2056 
2057         unchecked {
2058             if (to.code.length != 0) {
2059                 uint256 end = _currentIndex;
2060                 uint256 index = end - quantity;
2061                 do {
2062                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2063                         revert TransferToNonERC721ReceiverImplementer();
2064                     }
2065                 } while (index < end);
2066                 // Reentrancy protection.
2067                 if (_currentIndex != end) revert();
2068             }
2069         }
2070     }
2071 
2072     /**
2073      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2074      */
2075     function _safeMint(address to, uint256 quantity) internal virtual {
2076         _safeMint(to, quantity, '');
2077     }
2078 
2079     // =============================================================
2080     //                        BURN OPERATIONS
2081     // =============================================================
2082 
2083     /**
2084      * @dev Equivalent to `_burn(tokenId, false)`.
2085      */
2086     function _burn(uint256 tokenId) internal virtual {
2087         _burn(tokenId, false);
2088     }
2089 
2090     /**
2091      * @dev Destroys `tokenId`.
2092      * The approval is cleared when the token is burned.
2093      *
2094      * Requirements:
2095      *
2096      * - `tokenId` must exist.
2097      *
2098      * Emits a {Transfer} event.
2099      */
2100     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2101         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2102 
2103         address from = address(uint160(prevOwnershipPacked));
2104 
2105         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2106 
2107         if (approvalCheck) {
2108             // The nested ifs save around 20+ gas over a compound boolean condition.
2109             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2110                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2111         }
2112 
2113         _beforeTokenTransfers(from, address(0), tokenId, 1);
2114 
2115         // Clear approvals from the previous owner.
2116         assembly {
2117             if approvedAddress {
2118                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2119                 sstore(approvedAddressSlot, 0)
2120             }
2121         }
2122 
2123         // Underflow of the sender's balance is impossible because we check for
2124         // ownership above and the recipient's balance can't realistically overflow.
2125         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2126         unchecked {
2127             // Updates:
2128             // - `balance -= 1`.
2129             // - `numberBurned += 1`.
2130             //
2131             // We can directly decrement the balance, and increment the number burned.
2132             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2133             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2134 
2135             // Updates:
2136             // - `address` to the last owner.
2137             // - `startTimestamp` to the timestamp of burning.
2138             // - `burned` to `true`.
2139             // - `nextInitialized` to `true`.
2140             _packedOwnerships[tokenId] = _packOwnershipData(
2141                 from,
2142                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2143             );
2144 
2145             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2146             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2147                 uint256 nextTokenId = tokenId + 1;
2148                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2149                 if (_packedOwnerships[nextTokenId] == 0) {
2150                     // If the next slot is within bounds.
2151                     if (nextTokenId != _currentIndex) {
2152                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2153                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2154                     }
2155                 }
2156             }
2157         }
2158 
2159         emit Transfer(from, address(0), tokenId);
2160         _afterTokenTransfers(from, address(0), tokenId, 1);
2161 
2162         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2163         unchecked {
2164             _burnCounter++;
2165         }
2166     }
2167 
2168     // =============================================================
2169     //                     EXTRA DATA OPERATIONS
2170     // =============================================================
2171 
2172     /**
2173      * @dev Directly sets the extra data for the ownership data `index`.
2174      */
2175     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2176         uint256 packed = _packedOwnerships[index];
2177         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2178         uint256 extraDataCasted;
2179         // Cast `extraData` with assembly to avoid redundant masking.
2180         assembly {
2181             extraDataCasted := extraData
2182         }
2183         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2184         _packedOwnerships[index] = packed;
2185     }
2186 
2187     /**
2188      * @dev Called during each token transfer to set the 24bit `extraData` field.
2189      * Intended to be overridden by the cosumer contract.
2190      *
2191      * `previousExtraData` - the value of `extraData` before transfer.
2192      *
2193      * Calling conditions:
2194      *
2195      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2196      * transferred to `to`.
2197      * - When `from` is zero, `tokenId` will be minted for `to`.
2198      * - When `to` is zero, `tokenId` will be burned by `from`.
2199      * - `from` and `to` are never both zero.
2200      */
2201     function _extraData(
2202         address from,
2203         address to,
2204         uint24 previousExtraData
2205     ) internal view virtual returns (uint24) {}
2206 
2207     /**
2208      * @dev Returns the next extra data for the packed ownership data.
2209      * The returned result is shifted into position.
2210      */
2211     function _nextExtraData(
2212         address from,
2213         address to,
2214         uint256 prevOwnershipPacked
2215     ) private view returns (uint256) {
2216         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2217         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2218     }
2219 
2220     // =============================================================
2221     //                       OTHER OPERATIONS
2222     // =============================================================
2223 
2224     /**
2225      * @dev Returns the message sender (defaults to `msg.sender`).
2226      *
2227      * If you are writing GSN compatible contracts, you need to override this function.
2228      */
2229     function _msgSenderERC721A() internal view virtual returns (address) {
2230         return msg.sender;
2231     }
2232 
2233     /**
2234      * @dev Converts a uint256 to its ASCII string decimal representation.
2235      */
2236     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2237         assembly {
2238             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2239             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
2240             // We will need 1 32-byte word to store the length,
2241             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
2242             str := add(mload(0x40), 0x80)
2243             // Update the free memory pointer to allocate.
2244             mstore(0x40, str)
2245 
2246             // Cache the end of the memory to calculate the length later.
2247             let end := str
2248 
2249             // We write the string from rightmost digit to leftmost digit.
2250             // The following is essentially a do-while loop that also handles the zero case.
2251             // prettier-ignore
2252             for { let temp := value } 1 {} {
2253                 str := sub(str, 1)
2254                 // Write the character to the pointer.
2255                 // The ASCII index of the '0' character is 48.
2256                 mstore8(str, add(48, mod(temp, 10)))
2257                 // Keep dividing `temp` until zero.
2258                 temp := div(temp, 10)
2259                 // prettier-ignore
2260                 if iszero(temp) { break }
2261             }
2262 
2263             let length := sub(end, str)
2264             // Move the pointer 32 bytes leftwards to make room for the length.
2265             str := sub(str, 0x20)
2266             // Store the length.
2267             mstore(str, length)
2268         }
2269     }
2270 }
2271 
2272 
2273 /** 
2274  *  
2275 */
2276 
2277 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
2278 
2279 pragma solidity >=0.8.9 <0.9.0;
2280 
2281 ////import 'erc721a/contracts/ERC721A.sol';
2282 ////import '@openzeppelin/contracts/access/Ownable.sol';
2283 ////import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
2284 ////import '@openzeppelin/contracts/utils/Strings.sol';
2285 ////import '@openzeppelin/contracts/finance/PaymentSplitter.sol';
2286 
2287 contract Crackheths is ERC721A, Ownable, PaymentSplitter {
2288 	using Strings for uint256;
2289 
2290 	bytes32 public merkleRootOg = 0xacc30fb2c320b7ad921ece9d7ecdfb29ce8e4c8ae2cf1d2f746dbb9451cbd5d3;
2291 	bytes32 public merkleRootWl = 0x0012095bbcd28bc1ab6d4cedb8b30a9e58e01b9db27f79491c81d9a13315fe17;
2292 
2293 	mapping(address => bool) public whitelistClaimed;
2294 	mapping(address => bool) public freeTokensClaimed;
2295 
2296 	string public uriPrefix = '';
2297 	string public uriSuffix = '.json';
2298 	string public hiddenMetadataUri;
2299 	
2300 	uint256 public cost;
2301 	uint256 public maxSupply;
2302 	uint256 public maxMintAmountPerTx;
2303 
2304 	bool public paused = true;
2305 	bool public whitelistMintEnabled = false;
2306 	bool public revealed = false;
2307 
2308 	address[] private addressList = [
2309 		0x7aa4720178a05654D48182aCF853b4eC1fe5f7E5,
2310 		0xD932B57C2A2A019C5b5924b86134FaF51280F956,
2311 		0x60b91Dd29689B1be954929225200F2f6BD3011BB
2312 	];
2313 	uint[] private shareList = [
2314 		15,
2315 		5,
2316 		80
2317 	];
2318 
2319 	constructor() ERC721A("Crackheths", "HETH") PaymentSplitter(addressList, shareList) {
2320 		cost = 0.009 ether;
2321 		maxSupply = 8888;
2322 		maxMintAmountPerTx = 5;
2323 		hiddenMetadataUri = "ipfs://QmZVvv5mthd8tYhMYPbFGWT6BtpJa8ByfxbTRW85Caw5JY/hidden.json.json";
2324 	}
2325 
2326 	modifier mintCompliance(uint256 _mintAmount) {
2327 		require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2328 		_;
2329 	}
2330 
2331 	modifier mintPriceCompliance(uint256 _mintAmount) {
2332 		require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
2333 		_;
2334 	}
2335 
2336 	function whitelistMint(uint8 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2337 		// Verify whitelist requirements
2338 		require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
2339 		require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
2340 
2341 		bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2342 		bool isOg = MerkleProof.verify(_merkleProof, merkleRootOg, leaf);
2343 		bool isWl = MerkleProof.verify(_merkleProof, merkleRootWl, leaf);
2344 
2345 		require(isOg || isWl, 'Invalid proof!');
2346 
2347 		uint8 freeTokens = 0;
2348 		uint8 maxMint = 5;
2349 		if (!freeTokensClaimed[_msgSender()]) {
2350 			if (isWl) {
2351 				freeTokens = 1;
2352 			}
2353 
2354 			if (isOg) {
2355 				freeTokens = 2;
2356 			}
2357 		}
2358 
2359 		if (isOg) {
2360 			maxMint = 10;
2361 		}
2362 
2363 		uint8 realMintAmount = _mintAmount + freeTokens;
2364 		require(realMintAmount > 0 && _mintAmount <= maxMint, 'Invalid mint amount!');
2365 
2366 		whitelistClaimed[_msgSender()] = true;
2367 		freeTokensClaimed[_msgSender()] = true;
2368 
2369 		_safeMint(_msgSender(), realMintAmount + freeTokens);
2370 	}
2371 
2372 	function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2373 		require(!paused, 'The contract is paused!');
2374 		require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2375 
2376 		_safeMint(_msgSender(), _mintAmount);
2377 	}
2378 	
2379 	function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2380 		_safeMint(_receiver, _mintAmount);
2381 	}
2382 
2383 	/*function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2384 		uint256 ownerTokenCount = balanceOf(_owner);
2385 		uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2386 		uint256 currentTokenId = _startTokenId();
2387 		uint256 ownedTokenIndex = 0;
2388 		address latestOwnerAddress;
2389 
2390 		while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2391 			TokenOwnership memory ownership = _ownershipOf[currentTokenId];
2392 
2393 			if (!ownership.burned && ownership.addr != address(0)) {
2394 				latestOwnerAddress = ownership.addr;
2395 			}
2396 
2397 			if (latestOwnerAddress == _owner) {
2398 				ownedTokenIds[ownedTokenIndex] = currentTokenId;
2399 
2400 				ownedTokenIndex++;
2401 			}
2402 
2403 			currentTokenId++;
2404 		}
2405 
2406 		return ownedTokenIds;
2407 	}*/
2408 
2409 	function _startTokenId() internal view virtual override returns (uint256) {
2410 		return 1;
2411 	}
2412 
2413 	function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2414 		require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2415 
2416 		if (revealed == false) {
2417 			return hiddenMetadataUri;
2418 		}
2419 
2420 		string memory currentBaseURI = _baseURI();
2421 		return bytes(currentBaseURI).length > 0
2422 			? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2423 			: '';
2424 	}
2425 
2426 	function setRevealed(bool _state) public onlyOwner {
2427 		revealed = _state;
2428 	}
2429 
2430 	function setCost(uint256 _cost) public onlyOwner {
2431 		cost = _cost;
2432 	}
2433 
2434 	function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2435 		maxMintAmountPerTx = _maxMintAmountPerTx;
2436 	}
2437 
2438 	function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2439 		hiddenMetadataUri = _hiddenMetadataUri;
2440 	}
2441 
2442 	function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2443 		uriPrefix = _uriPrefix;
2444 	}
2445 
2446 	function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2447 		uriSuffix = _uriSuffix;
2448 	}
2449 
2450 	function setPaused(bool _state) public onlyOwner {
2451 		paused = _state;
2452 	}
2453 
2454 	function setMerkleRootWl(bytes32 _merkleRoot) public onlyOwner {
2455 		merkleRootWl = _merkleRoot;
2456 	}
2457 
2458 	function setMerkleRootOg(bytes32 _merkleRoot) public onlyOwner {
2459 		merkleRootOg = _merkleRoot;
2460 	}
2461 
2462 	function setWhitelistMintEnabled(bool _state) public onlyOwner {
2463 		whitelistMintEnabled = _state;
2464 	}
2465 
2466 	function _baseURI() internal view virtual override returns (string memory) {
2467 		return uriPrefix;
2468 	}
2469 }