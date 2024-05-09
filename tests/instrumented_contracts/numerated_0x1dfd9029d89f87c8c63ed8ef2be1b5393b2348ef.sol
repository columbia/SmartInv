1 // File: IEIP2612.sol
2 
3 
4 
5 pragma solidity =0.8.12;
6 
7 interface IEIP2612 {
8 
9     function permit(
10         address owner_,
11         address spender_,
12         uint256 value_,
13         uint256 deadline_,
14         uint8 v_,
15         bytes32 r_,
16         bytes32 s_
17     ) external;
18 
19 }
20 
21 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
22 
23 
24 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: @openzeppelin/contracts/utils/Strings.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
121      */
122     function toString(uint256 value) internal pure returns (string memory) {
123         // Inspired by OraclizeAPI's implementation - MIT licence
124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
125 
126         if (value == 0) {
127             return "0";
128         }
129         uint256 temp = value;
130         uint256 digits;
131         while (temp != 0) {
132             digits++;
133             temp /= 10;
134         }
135         bytes memory buffer = new bytes(digits);
136         while (value != 0) {
137             digits -= 1;
138             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
139             value /= 10;
140         }
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
146      */
147     function toHexString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0x00";
150         }
151         uint256 temp = value;
152         uint256 length = 0;
153         while (temp != 0) {
154             length++;
155             temp >>= 8;
156         }
157         return toHexString(value, length);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
162      */
163     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
164         bytes memory buffer = new bytes(2 * length + 2);
165         buffer[0] = "0";
166         buffer[1] = "x";
167         for (uint256 i = 2 * length + 1; i > 1; --i) {
168             buffer[i] = _HEX_SYMBOLS[value & 0xf];
169             value >>= 4;
170         }
171         require(value == 0, "Strings: hex length insufficient");
172         return string(buffer);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Context.sol
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @dev Provides information about the current execution context, including the
185  * sender of the transaction and its data. While these are generally available
186  * via msg.sender and msg.data, they should not be accessed in such a direct
187  * manner, since when dealing with meta-transactions the account sending and
188  * paying for execution may not be the actual sender (as far as an application
189  * is concerned).
190  *
191  * This contract is only required for intermediate, library-like contracts.
192  */
193 abstract contract Context {
194     function _msgSender() internal view virtual returns (address) {
195         return msg.sender;
196     }
197 
198     function _msgData() internal view virtual returns (bytes calldata) {
199         return msg.data;
200     }
201 }
202 
203 // File: @openzeppelin/contracts/utils/Address.sol
204 
205 
206 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
207 
208 pragma solidity ^0.8.1;
209 
210 /**
211  * @dev Collection of functions related to the address type
212  */
213 library Address {
214     /**
215      * @dev Returns true if `account` is a contract.
216      *
217      * [IMPORTANT]
218      * ====
219      * It is unsafe to assume that an address for which this function returns
220      * false is an externally-owned account (EOA) and not a contract.
221      *
222      * Among others, `isContract` will return false for the following
223      * types of addresses:
224      *
225      *  - an externally-owned account
226      *  - a contract in construction
227      *  - an address where a contract will be created
228      *  - an address where a contract lived, but was destroyed
229      * ====
230      *
231      * [IMPORTANT]
232      * ====
233      * You shouldn't rely on `isContract` to protect against flash loan attacks!
234      *
235      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
236      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
237      * constructor.
238      * ====
239      */
240     function isContract(address account) internal view returns (bool) {
241         // This method relies on extcodesize/address.code.length, which returns 0
242         // for contracts in construction, since the code is only stored at the end
243         // of the constructor execution.
244 
245         return account.code.length > 0;
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         (bool success, ) = recipient.call{value: amount}("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain `call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290         return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(
300         address target,
301         bytes memory data,
302         string memory errorMessage
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, 0, errorMessage);
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
309      * but also transferring `value` wei to `target`.
310      *
311      * Requirements:
312      *
313      * - the calling contract must have an ETH balance of at least `value`.
314      * - the called Solidity function must be `payable`.
315      *
316      * _Available since v3.1._
317      */
318     function functionCallWithValue(
319         address target,
320         bytes memory data,
321         uint256 value
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
328      * with `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         require(address(this).balance >= value, "Address: insufficient balance for call");
339         require(isContract(target), "Address: call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.call{value: value}(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a static call.
348      *
349      * _Available since v3.3._
350      */
351     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
352         return functionStaticCall(target, data, "Address: low-level static call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a static call.
358      *
359      * _Available since v3.3._
360      */
361     function functionStaticCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal view returns (bytes memory) {
366         require(isContract(target), "Address: static call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.staticcall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a delegate call.
375      *
376      * _Available since v3.4._
377      */
378     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a delegate call.
385      *
386      * _Available since v3.4._
387      */
388     function functionDelegateCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         require(isContract(target), "Address: delegate call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.delegatecall(data);
396         return verifyCallResult(success, returndata, errorMessage);
397     }
398 
399     /**
400      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
401      * revert reason using the provided one.
402      *
403      * _Available since v4.3._
404      */
405     function verifyCallResult(
406         bool success,
407         bytes memory returndata,
408         string memory errorMessage
409     ) internal pure returns (bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
429 
430 
431 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
432 
433 pragma solidity ^0.8.0;
434 
435 /**
436  * @title ERC721 token receiver interface
437  * @dev Interface for any contract that wants to support safeTransfers
438  * from ERC721 asset contracts.
439  */
440 interface IERC721Receiver {
441     /**
442      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
443      * by `operator` from `from`, this function is called.
444      *
445      * It must return its Solidity selector to confirm the token transfer.
446      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
447      *
448      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
449      */
450     function onERC721Received(
451         address operator,
452         address from,
453         uint256 tokenId,
454         bytes calldata data
455     ) external returns (bytes4);
456 }
457 
458 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
459 
460 
461 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Interface of the ERC165 standard, as defined in the
467  * https://eips.ethereum.org/EIPS/eip-165[EIP].
468  *
469  * Implementers can declare support of contract interfaces, which can then be
470  * queried by others ({ERC165Checker}).
471  *
472  * For an implementation, see {ERC165}.
473  */
474 interface IERC165 {
475     /**
476      * @dev Returns true if this contract implements the interface defined by
477      * `interfaceId`. See the corresponding
478      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
479      * to learn more about how these ids are created.
480      *
481      * This function call must use less than 30 000 gas.
482      */
483     function supportsInterface(bytes4 interfaceId) external view returns (bool);
484 }
485 
486 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @dev Implementation of the {IERC165} interface.
496  *
497  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
498  * for the additional interface id that will be supported. For example:
499  *
500  * ```solidity
501  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
503  * }
504  * ```
505  *
506  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
507  */
508 abstract contract ERC165 is IERC165 {
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513         return interfaceId == type(IERC165).interfaceId;
514     }
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Required interface of an ERC721 compliant contract.
527  */
528 interface IERC721 is IERC165 {
529     /**
530      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
531      */
532     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
533 
534     /**
535      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
536      */
537     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
541      */
542     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
543 
544     /**
545      * @dev Returns the number of tokens in ``owner``'s account.
546      */
547     function balanceOf(address owner) external view returns (uint256 balance);
548 
549     /**
550      * @dev Returns the owner of the `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function ownerOf(uint256 tokenId) external view returns (address owner);
557 
558     /**
559      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
560      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId
576     ) external;
577 
578     /**
579      * @dev Transfers `tokenId` token from `from` to `to`.
580      *
581      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
582      *
583      * Requirements:
584      *
585      * - `from` cannot be the zero address.
586      * - `to` cannot be the zero address.
587      * - `tokenId` token must be owned by `from`.
588      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
589      *
590      * Emits a {Transfer} event.
591      */
592     function transferFrom(
593         address from,
594         address to,
595         uint256 tokenId
596     ) external;
597 
598     /**
599      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
600      * The approval is cleared when the token is transferred.
601      *
602      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
603      *
604      * Requirements:
605      *
606      * - The caller must own the token or be an approved operator.
607      * - `tokenId` must exist.
608      *
609      * Emits an {Approval} event.
610      */
611     function approve(address to, uint256 tokenId) external;
612 
613     /**
614      * @dev Returns the account approved for `tokenId` token.
615      *
616      * Requirements:
617      *
618      * - `tokenId` must exist.
619      */
620     function getApproved(uint256 tokenId) external view returns (address operator);
621 
622     /**
623      * @dev Approve or remove `operator` as an operator for the caller.
624      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
625      *
626      * Requirements:
627      *
628      * - The `operator` cannot be the caller.
629      *
630      * Emits an {ApprovalForAll} event.
631      */
632     function setApprovalForAll(address operator, bool _approved) external;
633 
634     /**
635      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
636      *
637      * See {setApprovalForAll}
638      */
639     function isApprovedForAll(address owner, address operator) external view returns (bool);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`.
643      *
644      * Requirements:
645      *
646      * - `from` cannot be the zero address.
647      * - `to` cannot be the zero address.
648      * - `tokenId` token must exist and be owned by `from`.
649      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
651      *
652      * Emits a {Transfer} event.
653      */
654     function safeTransferFrom(
655         address from,
656         address to,
657         uint256 tokenId,
658         bytes calldata data
659     ) external;
660 }
661 
662 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
663 
664 
665 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Enumerable is IERC721 {
675     /**
676      * @dev Returns the total amount of tokens stored by the contract.
677      */
678     function totalSupply() external view returns (uint256);
679 
680     /**
681      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
682      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
683      */
684     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
685 
686     /**
687      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
688      * Use along with {totalSupply} to enumerate all tokens.
689      */
690     function tokenByIndex(uint256 index) external view returns (uint256);
691 }
692 
693 // File: IXDEFIDistribution.sol
694 
695 
696 
697 pragma solidity =0.8.12;
698 
699 
700 interface IXDEFIDistribution is IERC721Enumerable {
701     /***********/
702     /* Structs */
703     /***********/
704 
705     struct Position {
706         uint96 units; // 240,000,000,000,000,000,000,000,000 XDEFI * 2.55x bonus (which fits in a `uint96`).
707         uint88 depositedXDEFI; // XDEFI cap is 240000000000000000000000000 (which fits in a `uint88`).
708         uint32 expiry; // block timestamps for the next 50 years (which fits in a `uint32`).
709         uint32 created;
710         uint256 pointsCorrection;
711     }
712 
713     /**********/
714     /* Errors */
715     /**********/
716 
717     error BeyondConsumeLimit();
718     error CannotUnlock();
719     error ConsumePermitExpired();
720     error EmptyArray();
721     error IncorrectBonusMultiplier();
722     error InsufficientAmountUnlocked();
723     error InsufficientCredits();
724     error InvalidConsumePermit();
725     error InvalidDuration();
726     error InvalidMultiplier();
727     error InvalidToken();
728     error LockingIsDisabled();
729     error LockResultsInTooFewUnits();
730     error MustMergeMultiple();
731     error NoReentering();
732     error NoUnitSupply();
733     error NotApprovedOrOwnerOfToken();
734     error NotInEmergencyMode();
735     error PositionAlreadyUnlocked();
736     error PositionStillLocked();
737     error TokenDoesNotExist();
738     error Unauthorized();
739 
740     /**********/
741     /* Events */
742     /**********/
743 
744     /// @notice Emitted when the base URI is set (or re-set).
745     event BaseURISet(string baseURI);
746 
747     /// @notice Emitted when some credits of a token are consumed.
748     event CreditsConsumed(uint256 indexed tokenId, address indexed consumer, uint256 amount);
749 
750     /// @notice Emitted when a new amount of XDEFI is distributed to all locked positions, by some caller.
751     event DistributionUpdated(address indexed caller, uint256 amount);
752 
753     /// @notice Emitted when the contract is no longer allowing locking XDEFI, and is allowing all locked positions to be unlocked effective immediately.
754     event EmergencyModeActivated();
755 
756     /// @notice Emitted when a new lock period duration, in seconds, has been enabled with some bonus multiplier (scaled by 100, 0 signaling it is disabled).
757     event LockPeriodSet(uint256 indexed duration, uint256 indexed bonusMultiplier);
758 
759     /// @notice Emitted when a new locked position is created for some amount of XDEFI, and the NFT is minted to an owner.
760     event LockPositionCreated(uint256 indexed tokenId, address indexed owner, uint256 amount, uint256 indexed duration);
761 
762     /// @notice Emitted when a locked position is unlocked, withdrawing some amount of XDEFI.
763     event LockPositionWithdrawn(uint256 indexed tokenId, address indexed owner, uint256 amount);
764 
765     /// @notice Emitted when an account has accepted ownership.
766     event OwnershipAccepted(address indexed previousOwner, address indexed owner);
767 
768     /// @notice Emitted when owner proposed an account that can accept ownership.
769     event OwnershipProposed(address indexed owner, address indexed pendingOwner);
770 
771     /// @notice Emitted when unlocked tokens are merged into one.
772     event TokensMerged(uint256[] mergedTokenIds, uint256 tokenId, uint256 credits);
773 
774     /*************/
775     /* Constants */
776     /*************/
777 
778     /// @notice The IERC721Permit domain separator.
779     function DOMAIN_SEPARATOR() external view returns (bytes32 domainSeparator_);
780 
781     /// @notice The minimum units that can result from a lock of XDEFI.
782     function MINIMUM_UNITS() external view returns (uint256 minimumUnits_);
783 
784     /*********/
785     /* State */
786     /*********/
787 
788     /// @notice The base URI for NFT metadata.
789     function baseURI() external view returns (string memory baseURI_);
790 
791     /// @notice The multiplier applied to the deposited XDEFI amount to determine the units of a position, and thus its share of future distributions.
792     function bonusMultiplierOf(uint256 duration_) external view returns (uint256 bonusMultiplier_);
793 
794     /// @notice Returns the consume permit nonce for a token.
795     function consumePermitNonce(uint256 tokenId_) external view returns (uint256 nonce_);
796 
797     /// @notice Returns the credits of a token.
798     function creditsOf(uint256 tokenId_) external view returns (uint256 credits_);
799 
800     /// @notice The amount of XDEFI that is distributable to all currently locked positions.
801     function distributableXDEFI() external view returns (uint256 distributableXDEFI_);
802 
803     /// @notice The contract is no longer allowing locking XDEFI, and is allowing all locked positions to be unlocked effective immediately.
804     function inEmergencyMode() external view returns (bool lockingDisabled_);
805 
806     /// @notice The account that can set and unset lock periods and transfer ownership of the contract.
807     function owner() external view returns (address owner_);
808 
809     /// @notice The account that can take ownership of the contract.
810     function pendingOwner() external view returns (address pendingOwner_);
811 
812     /// @notice Returns the position details (`pointsCorrection_` is a value used in the amortized work pattern for token distribution).
813     function positionOf(uint256 tokenId_) external view returns (Position memory position_);
814 
815     /// @notice The amount of XDEFI that was deposited by all currently locked positions.
816     function totalDepositedXDEFI() external view returns (uint256 totalDepositedXDEFI_);
817 
818     /// @notice The amount of locked position units (in some way, it is the denominator use to distribute new XDEFI to each unit).
819     function totalUnits() external view returns (uint256 totalUnits_);
820 
821     /// @notice The address of the XDEFI token.
822     function xdefi() external view returns (address XDEFI_);
823 
824     /*******************/
825     /* Admin Functions */
826     /*******************/
827 
828     /// @notice Allows the `pendingOwner` to take ownership of the contract.
829     function acceptOwnership() external;
830 
831     /// @notice Disallows locking XDEFI, and is allows all locked positions to be unlocked effective immediately.
832     function activateEmergencyMode() external;
833 
834     /// @notice Allows the owner to propose a new owner for the contract.
835     function proposeOwnership(address newOwner_) external;
836 
837     /// @notice Sets the base URI for NFT metadata.
838     function setBaseURI(string calldata baseURI_) external;
839 
840     /// @notice Allows the setting or un-setting (when the multiplier is 0) of multipliers for lock durations. Scaled such that 1x is 100.
841     function setLockPeriods(uint256[] calldata durations_, uint256[] calldata multipliers) external;
842 
843     /**********************/
844     /* Position Functions */
845     /**********************/
846 
847     /// @notice Unlock only the deposited amount from a non-fungible position, sending the XDEFI to some destination, when in emergency mode.
848     function emergencyUnlock(uint256 tokenId_, address destination_) external returns (uint256 amountUnlocked_);
849 
850     /// @notice Returns the bonus multiplier of a locked position.
851     function getBonusMultiplierOf(uint256 tokenId_) external view returns (uint256 bonusMultiplier_);
852 
853     /// @notice Locks some amount of XDEFI into a non-fungible (NFT) position, for a duration of time. The caller must first approve this contract to spend its XDEFI.
854     function lock(
855         uint256 amount_,
856         uint256 duration_,
857         uint256 bonusMultiplier_,
858         address destination_
859     ) external returns (uint256 tokenId_);
860 
861     /// @notice Locks some amount of XDEFI into a non-fungible (NFT) position, for a duration of time, with a signed permit to transfer XDEFI from the caller.
862     function lockWithPermit(
863         uint256 amount_,
864         uint256 duration_,
865         uint256 bonusMultiplier_,
866         address destination_,
867         uint256 deadline_,
868         uint8 v_,
869         bytes32 r_,
870         bytes32 s_
871     ) external returns (uint256 tokenId_);
872 
873     /// @notice Unlock an un-lockable non-fungible position and re-lock some amount, for a duration of time, sending the balance XDEFI to some destination.
874     function relock(
875         uint256 tokenId_,
876         uint256 lockAmount_,
877         uint256 duration_,
878         uint256 bonusMultiplier_,
879         address destination_
880     ) external returns (uint256 amountUnlocked_, uint256 newTokenId_);
881 
882     /// @notice Unlock an un-lockable non-fungible position, sending the XDEFI to some destination.
883     function unlock(uint256 tokenId_, address destination_) external returns (uint256 amountUnlocked_);
884 
885     /// @notice To be called as part of distributions to force the contract to recognize recently transferred XDEFI as distributable.
886     function updateDistribution() external;
887 
888     /// @notice Returns the amount of XDEFI that can be withdrawn when the position is unlocked. This will increase as distributions are made.
889     function withdrawableOf(uint256 tokenId_) external view returns (uint256 withdrawableXDEFI_);
890 
891     /****************************/
892     /* Batch Position Functions */
893     /****************************/
894 
895     /// @notice Unlocks several un-lockable non-fungible positions and re-lock some amount, for a duration of time, sending the balance XDEFI to some destination.
896     function relockBatch(
897         uint256[] calldata tokenIds_,
898         uint256 lockAmount_,
899         uint256 duration_,
900         uint256 bonusMultiplier_,
901         address destination_
902     ) external returns (uint256 amountUnlocked_, uint256 newTokenId_);
903 
904     /// @notice Unlocks several un-lockable non-fungible positions, sending the XDEFI to some destination.
905     function unlockBatch(uint256[] calldata tokenIds_, address destination_) external returns (uint256 amountUnlocked_);
906 
907     /*****************/
908     /* NFT Functions */
909     /*****************/
910 
911     /// @notice Returns the tier and credits of an NFT.
912     function attributesOf(uint256 tokenId_)
913         external
914         view
915         returns (
916             uint256 tier_,
917             uint256 credits_,
918             uint256 withdrawable_,
919             uint256 expiry_
920         );
921 
922     /// @notice Consumes some credits from an NFT, returning the number of credits left.
923     function consume(uint256 tokenId_, uint256 amount_) external returns (uint256 remainingCredits_);
924 
925     /// @notice Consumes some credits from an NFT, with a signed permit from the owner, returning the number of credits left.
926     function consumeWithPermit(
927         uint256 tokenId_,
928         uint256 amount_,
929         uint256 limit_,
930         uint256 deadline_,
931         uint8 v_,
932         bytes32 r_,
933         bytes32 s_
934     ) external returns (uint256 remainingCredits_);
935 
936     /// @notice Returns the URI for the contract metadata.
937     function contractURI() external view returns (string memory contractURI_);
938 
939     /// @notice Returns the credits an NFT will have, given some amount locked for some duration.
940     function getCredits(uint256 amount_, uint256 duration_) external pure returns (uint256 credits_);
941 
942     /// @notice Returns the tier an NFT will have, given some credits, which itself can be determined from `getCredits`.
943     function getTier(uint256 credits_) external pure returns (uint256 tier_);
944 
945     /// @notice Burns several unlocked NFTs to combine their credits into the first.
946     function merge(uint256[] calldata tokenIds_) external returns (uint256 tokenId_, uint256 credits_);
947 
948     /// @notice Returns the URI for the NFT metadata for a given token ID.
949     function tokenURI(uint256 tokenId_) external view returns (string memory tokenURI_);
950 }
951 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
952 
953 
954 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 /**
960  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
961  * @dev See https://eips.ethereum.org/EIPS/eip-721
962  */
963 interface IERC721Metadata is IERC721 {
964     /**
965      * @dev Returns the token collection name.
966      */
967     function name() external view returns (string memory);
968 
969     /**
970      * @dev Returns the token collection symbol.
971      */
972     function symbol() external view returns (string memory);
973 
974     /**
975      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
976      */
977     function tokenURI(uint256 tokenId) external view returns (string memory);
978 }
979 
980 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
981 
982 
983 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
984 
985 pragma solidity ^0.8.0;
986 
987 
988 
989 
990 
991 
992 
993 
994 /**
995  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
996  * the Metadata extension, but not including the Enumerable extension, which is available separately as
997  * {ERC721Enumerable}.
998  */
999 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1000     using Address for address;
1001     using Strings for uint256;
1002 
1003     // Token name
1004     string private _name;
1005 
1006     // Token symbol
1007     string private _symbol;
1008 
1009     // Mapping from token ID to owner address
1010     mapping(uint256 => address) private _owners;
1011 
1012     // Mapping owner address to token count
1013     mapping(address => uint256) private _balances;
1014 
1015     // Mapping from token ID to approved address
1016     mapping(uint256 => address) private _tokenApprovals;
1017 
1018     // Mapping from owner to operator approvals
1019     mapping(address => mapping(address => bool)) private _operatorApprovals;
1020 
1021     /**
1022      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1023      */
1024     constructor(string memory name_, string memory symbol_) {
1025         _name = name_;
1026         _symbol = symbol_;
1027     }
1028 
1029     /**
1030      * @dev See {IERC165-supportsInterface}.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1033         return
1034             interfaceId == type(IERC721).interfaceId ||
1035             interfaceId == type(IERC721Metadata).interfaceId ||
1036             super.supportsInterface(interfaceId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-balanceOf}.
1041      */
1042     function balanceOf(address owner) public view virtual override returns (uint256) {
1043         require(owner != address(0), "ERC721: balance query for the zero address");
1044         return _balances[owner];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-ownerOf}.
1049      */
1050     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1051         address owner = _owners[tokenId];
1052         require(owner != address(0), "ERC721: owner query for nonexistent token");
1053         return owner;
1054     }
1055 
1056     /**
1057      * @dev See {IERC721Metadata-name}.
1058      */
1059     function name() public view virtual override returns (string memory) {
1060         return _name;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Metadata-symbol}.
1065      */
1066     function symbol() public view virtual override returns (string memory) {
1067         return _symbol;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Metadata-tokenURI}.
1072      */
1073     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1074         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1075 
1076         string memory baseURI = _baseURI();
1077         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1078     }
1079 
1080     /**
1081      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1082      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1083      * by default, can be overriden in child contracts.
1084      */
1085     function _baseURI() internal view virtual returns (string memory) {
1086         return "";
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-approve}.
1091      */
1092     function approve(address to, uint256 tokenId) public virtual override {
1093         address owner = ERC721.ownerOf(tokenId);
1094         require(to != owner, "ERC721: approval to current owner");
1095 
1096         require(
1097             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1098             "ERC721: approve caller is not owner nor approved for all"
1099         );
1100 
1101         _approve(to, tokenId);
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-getApproved}.
1106      */
1107     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1108         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1109 
1110         return _tokenApprovals[tokenId];
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-setApprovalForAll}.
1115      */
1116     function setApprovalForAll(address operator, bool approved) public virtual override {
1117         _setApprovalForAll(_msgSender(), operator, approved);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-isApprovedForAll}.
1122      */
1123     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1124         return _operatorApprovals[owner][operator];
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-transferFrom}.
1129      */
1130     function transferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) public virtual override {
1135         //solhint-disable-next-line max-line-length
1136         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1137 
1138         _transfer(from, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-safeTransferFrom}.
1143      */
1144     function safeTransferFrom(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) public virtual override {
1149         safeTransferFrom(from, to, tokenId, "");
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-safeTransferFrom}.
1154      */
1155     function safeTransferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) public virtual override {
1161         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1162         _safeTransfer(from, to, tokenId, _data);
1163     }
1164 
1165     /**
1166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1168      *
1169      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1170      *
1171      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1172      * implement alternative mechanisms to perform token transfer, such as signature-based.
1173      *
1174      * Requirements:
1175      *
1176      * - `from` cannot be the zero address.
1177      * - `to` cannot be the zero address.
1178      * - `tokenId` token must exist and be owned by `from`.
1179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _safeTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory _data
1188     ) internal virtual {
1189         _transfer(from, to, tokenId);
1190         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1191     }
1192 
1193     /**
1194      * @dev Returns whether `tokenId` exists.
1195      *
1196      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1197      *
1198      * Tokens start existing when they are minted (`_mint`),
1199      * and stop existing when they are burned (`_burn`).
1200      */
1201     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1202         return _owners[tokenId] != address(0);
1203     }
1204 
1205     /**
1206      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      */
1212     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1213         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1214         address owner = ERC721.ownerOf(tokenId);
1215         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1216     }
1217 
1218     /**
1219      * @dev Safely mints `tokenId` and transfers it to `to`.
1220      *
1221      * Requirements:
1222      *
1223      * - `tokenId` must not exist.
1224      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function _safeMint(address to, uint256 tokenId) internal virtual {
1229         _safeMint(to, tokenId, "");
1230     }
1231 
1232     /**
1233      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1234      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1235      */
1236     function _safeMint(
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) internal virtual {
1241         _mint(to, tokenId);
1242         require(
1243             _checkOnERC721Received(address(0), to, tokenId, _data),
1244             "ERC721: transfer to non ERC721Receiver implementer"
1245         );
1246     }
1247 
1248     /**
1249      * @dev Mints `tokenId` and transfers it to `to`.
1250      *
1251      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1252      *
1253      * Requirements:
1254      *
1255      * - `tokenId` must not exist.
1256      * - `to` cannot be the zero address.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _mint(address to, uint256 tokenId) internal virtual {
1261         require(to != address(0), "ERC721: mint to the zero address");
1262         require(!_exists(tokenId), "ERC721: token already minted");
1263 
1264         _beforeTokenTransfer(address(0), to, tokenId);
1265 
1266         _balances[to] += 1;
1267         _owners[tokenId] = to;
1268 
1269         emit Transfer(address(0), to, tokenId);
1270 
1271         _afterTokenTransfer(address(0), to, tokenId);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId) internal virtual {
1285         address owner = ERC721.ownerOf(tokenId);
1286 
1287         _beforeTokenTransfer(owner, address(0), tokenId);
1288 
1289         // Clear approvals
1290         _approve(address(0), tokenId);
1291 
1292         _balances[owner] -= 1;
1293         delete _owners[tokenId];
1294 
1295         emit Transfer(owner, address(0), tokenId);
1296 
1297         _afterTokenTransfer(owner, address(0), tokenId);
1298     }
1299 
1300     /**
1301      * @dev Transfers `tokenId` from `from` to `to`.
1302      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - `tokenId` token must be owned by `from`.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _transfer(
1312         address from,
1313         address to,
1314         uint256 tokenId
1315     ) internal virtual {
1316         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1317         require(to != address(0), "ERC721: transfer to the zero address");
1318 
1319         _beforeTokenTransfer(from, to, tokenId);
1320 
1321         // Clear approvals from the previous owner
1322         _approve(address(0), tokenId);
1323 
1324         _balances[from] -= 1;
1325         _balances[to] += 1;
1326         _owners[tokenId] = to;
1327 
1328         emit Transfer(from, to, tokenId);
1329 
1330         _afterTokenTransfer(from, to, tokenId);
1331     }
1332 
1333     /**
1334      * @dev Approve `to` to operate on `tokenId`
1335      *
1336      * Emits a {Approval} event.
1337      */
1338     function _approve(address to, uint256 tokenId) internal virtual {
1339         _tokenApprovals[tokenId] = to;
1340         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Approve `operator` to operate on all of `owner` tokens
1345      *
1346      * Emits a {ApprovalForAll} event.
1347      */
1348     function _setApprovalForAll(
1349         address owner,
1350         address operator,
1351         bool approved
1352     ) internal virtual {
1353         require(owner != operator, "ERC721: approve to caller");
1354         _operatorApprovals[owner][operator] = approved;
1355         emit ApprovalForAll(owner, operator, approved);
1356     }
1357 
1358     /**
1359      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1360      * The call is not executed if the target address is not a contract.
1361      *
1362      * @param from address representing the previous owner of the given token ID
1363      * @param to target address that will receive the tokens
1364      * @param tokenId uint256 ID of the token to be transferred
1365      * @param _data bytes optional data to send along with the call
1366      * @return bool whether the call correctly returned the expected magic value
1367      */
1368     function _checkOnERC721Received(
1369         address from,
1370         address to,
1371         uint256 tokenId,
1372         bytes memory _data
1373     ) private returns (bool) {
1374         if (to.isContract()) {
1375             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1376                 return retval == IERC721Receiver.onERC721Received.selector;
1377             } catch (bytes memory reason) {
1378                 if (reason.length == 0) {
1379                     revert("ERC721: transfer to non ERC721Receiver implementer");
1380                 } else {
1381                     assembly {
1382                         revert(add(32, reason), mload(reason))
1383                     }
1384                 }
1385             }
1386         } else {
1387             return true;
1388         }
1389     }
1390 
1391     /**
1392      * @dev Hook that is called before any token transfer. This includes minting
1393      * and burning.
1394      *
1395      * Calling conditions:
1396      *
1397      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1398      * transferred to `to`.
1399      * - When `from` is zero, `tokenId` will be minted for `to`.
1400      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1401      * - `from` and `to` are never both zero.
1402      *
1403      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1404      */
1405     function _beforeTokenTransfer(
1406         address from,
1407         address to,
1408         uint256 tokenId
1409     ) internal virtual {}
1410 
1411     /**
1412      * @dev Hook that is called after any transfer of tokens. This includes
1413      * minting and burning.
1414      *
1415      * Calling conditions:
1416      *
1417      * - when `from` and `to` are both non-zero.
1418      * - `from` and `to` are never both zero.
1419      *
1420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1421      */
1422     function _afterTokenTransfer(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) internal virtual {}
1427 }
1428 
1429 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1430 
1431 
1432 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1433 
1434 pragma solidity ^0.8.0;
1435 
1436 
1437 
1438 /**
1439  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1440  * enumerability of all the token ids in the contract as well as all token ids owned by each
1441  * account.
1442  */
1443 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1444     // Mapping from owner to list of owned token IDs
1445     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1446 
1447     // Mapping from token ID to index of the owner tokens list
1448     mapping(uint256 => uint256) private _ownedTokensIndex;
1449 
1450     // Array with all token ids, used for enumeration
1451     uint256[] private _allTokens;
1452 
1453     // Mapping from token id to position in the allTokens array
1454     mapping(uint256 => uint256) private _allTokensIndex;
1455 
1456     /**
1457      * @dev See {IERC165-supportsInterface}.
1458      */
1459     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1460         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1461     }
1462 
1463     /**
1464      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1465      */
1466     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1467         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1468         return _ownedTokens[owner][index];
1469     }
1470 
1471     /**
1472      * @dev See {IERC721Enumerable-totalSupply}.
1473      */
1474     function totalSupply() public view virtual override returns (uint256) {
1475         return _allTokens.length;
1476     }
1477 
1478     /**
1479      * @dev See {IERC721Enumerable-tokenByIndex}.
1480      */
1481     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1482         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1483         return _allTokens[index];
1484     }
1485 
1486     /**
1487      * @dev Hook that is called before any token transfer. This includes minting
1488      * and burning.
1489      *
1490      * Calling conditions:
1491      *
1492      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1493      * transferred to `to`.
1494      * - When `from` is zero, `tokenId` will be minted for `to`.
1495      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1496      * - `from` cannot be the zero address.
1497      * - `to` cannot be the zero address.
1498      *
1499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1500      */
1501     function _beforeTokenTransfer(
1502         address from,
1503         address to,
1504         uint256 tokenId
1505     ) internal virtual override {
1506         super._beforeTokenTransfer(from, to, tokenId);
1507 
1508         if (from == address(0)) {
1509             _addTokenToAllTokensEnumeration(tokenId);
1510         } else if (from != to) {
1511             _removeTokenFromOwnerEnumeration(from, tokenId);
1512         }
1513         if (to == address(0)) {
1514             _removeTokenFromAllTokensEnumeration(tokenId);
1515         } else if (to != from) {
1516             _addTokenToOwnerEnumeration(to, tokenId);
1517         }
1518     }
1519 
1520     /**
1521      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1522      * @param to address representing the new owner of the given token ID
1523      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1524      */
1525     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1526         uint256 length = ERC721.balanceOf(to);
1527         _ownedTokens[to][length] = tokenId;
1528         _ownedTokensIndex[tokenId] = length;
1529     }
1530 
1531     /**
1532      * @dev Private function to add a token to this extension's token tracking data structures.
1533      * @param tokenId uint256 ID of the token to be added to the tokens list
1534      */
1535     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1536         _allTokensIndex[tokenId] = _allTokens.length;
1537         _allTokens.push(tokenId);
1538     }
1539 
1540     /**
1541      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1542      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1543      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1544      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1545      * @param from address representing the previous owner of the given token ID
1546      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1547      */
1548     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1549         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1550         // then delete the last slot (swap and pop).
1551 
1552         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1553         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1554 
1555         // When the token to delete is the last token, the swap operation is unnecessary
1556         if (tokenIndex != lastTokenIndex) {
1557             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1558 
1559             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1560             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1561         }
1562 
1563         // This also deletes the contents at the last position of the array
1564         delete _ownedTokensIndex[tokenId];
1565         delete _ownedTokens[from][lastTokenIndex];
1566     }
1567 
1568     /**
1569      * @dev Private function to remove a token from this extension's token tracking data structures.
1570      * This has O(1) time complexity, but alters the order of the _allTokens array.
1571      * @param tokenId uint256 ID of the token to be removed from the tokens list
1572      */
1573     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1574         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1575         // then delete the last slot (swap and pop).
1576 
1577         uint256 lastTokenIndex = _allTokens.length - 1;
1578         uint256 tokenIndex = _allTokensIndex[tokenId];
1579 
1580         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1581         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1582         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1583         uint256 lastTokenId = _allTokens[lastTokenIndex];
1584 
1585         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1586         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1587 
1588         // This also deletes the contents at the last position of the array
1589         delete _allTokensIndex[tokenId];
1590         _allTokens.pop();
1591     }
1592 }
1593 
1594 // File: XDEFIDistribution.sol
1595 
1596 
1597 
1598 pragma solidity =0.8.12;
1599 
1600 
1601 
1602 
1603 
1604 /// @dev Handles distributing XDEFI to NFTs that have locked up XDEFI for various durations of time.
1605 contract XDEFIDistribution is IXDEFIDistribution, ERC721Enumerable {
1606     address internal constant ZERO_ADDRESS = address(0);
1607 
1608     uint256 internal constant ZERO_UINT256 = uint256(0);
1609     uint256 internal constant ONE_UINT256 = uint256(1);
1610     uint256 internal constant ONE_HUNDRED_UINT256 = uint256(100);
1611 
1612     uint256 internal constant TIER_1 = uint256(1);
1613     uint256 internal constant TIER_2 = uint256(2);
1614     uint256 internal constant TIER_3 = uint256(3);
1615     uint256 internal constant TIER_4 = uint256(4);
1616     uint256 internal constant TIER_5 = uint256(5);
1617     uint256 internal constant TIER_6 = uint256(6);
1618     uint256 internal constant TIER_7 = uint256(7);
1619     uint256 internal constant TIER_8 = uint256(8);
1620     uint256 internal constant TIER_9 = uint256(9);
1621     uint256 internal constant TIER_10 = uint256(10);
1622     uint256 internal constant TIER_11 = uint256(11);
1623     uint256 internal constant TIER_12 = uint256(12);
1624     uint256 internal constant TIER_13 = uint256(13);
1625 
1626     uint256 internal constant TIER_2_THRESHOLD = uint256(150 * 1e18 * 30 days);
1627     uint256 internal constant TIER_3_THRESHOLD = uint256(300 * 1e18 * 30 days);
1628     uint256 internal constant TIER_4_THRESHOLD = uint256(750 * 1e18 * 30 days);
1629     uint256 internal constant TIER_5_THRESHOLD = uint256(1_500 * 1e18 * 30 days);
1630     uint256 internal constant TIER_6_THRESHOLD = uint256(3_000 * 1e18 * 30 days);
1631     uint256 internal constant TIER_7_THRESHOLD = uint256(7_000 * 1e18 * 30 days);
1632     uint256 internal constant TIER_8_THRESHOLD = uint256(15_000 * 1e18 * 30 days);
1633     uint256 internal constant TIER_9_THRESHOLD = uint256(30_000 * 1e18 * 30 days);
1634     uint256 internal constant TIER_10_THRESHOLD = uint256(60_000 * 1e18 * 30 days);
1635     uint256 internal constant TIER_11_THRESHOLD = uint256(120_000 * 1e18 * 30 days);
1636     uint256 internal constant TIER_12_THRESHOLD = uint256(250_000 * 1e18 * 30 days);
1637     uint256 internal constant TIER_13_THRESHOLD = uint256(500_000 * 1e18 * 30 days);
1638 
1639     // See https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1640     uint256 internal constant POINTS_MULTIPLIER_BITS = uint256(72);
1641     uint256 internal _pointsPerUnit;
1642 
1643     address public immutable xdefi;
1644 
1645     uint256 public distributableXDEFI;
1646     uint256 public totalDepositedXDEFI;
1647     uint256 public totalUnits;
1648 
1649     mapping(uint256 => Position) internal _positionOf;
1650 
1651     mapping(uint256 => uint256) public creditsOf;
1652 
1653     mapping(uint256 => uint256) public bonusMultiplierOf; // Scaled by 100, capped at 255 (i.e. 1.1x is 110, 2.55x is 255).
1654 
1655     uint256 internal _tokensMinted;
1656 
1657     string public baseURI;
1658 
1659     address public owner;
1660     address public pendingOwner;
1661 
1662     uint256 internal constant IS_NOT_LOCKED = uint256(1);
1663     uint256 internal constant IS_LOCKED = uint256(2);
1664 
1665     uint256 internal _lockedStatus = IS_NOT_LOCKED;
1666 
1667     bool public inEmergencyMode;
1668 
1669     uint256 internal constant MAX_DURATION = uint256(315360000 seconds); // 10 years.
1670     uint256 internal constant MAX_BONUS_MULTIPLIER = uint256(255); // 2.55x.
1671 
1672     uint256 public constant MINIMUM_UNITS = uint256(1e18);
1673 
1674     bytes32 public immutable DOMAIN_SEPARATOR;
1675 
1676     mapping(uint256 => uint256) public consumePermitNonce;
1677 
1678     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
1679 
1680     // keccak256('PermitConsume(uint256 tokenId,address consumer,uint256 limit,uint256 nonce,uint256 deadline)');
1681     bytes32 private constant CONSUME_PERMIT_SIGNATURE_HASH = bytes32(0xa0a7128942405265cd830695cb06df90c6bfdbbe22677cc592c3d36c3180b079);
1682 
1683     constructor(address xdefi_, string memory baseURI_) ERC721("XDEFI Badges", "bXDEFI") {
1684         // Set `xdefi` immutable and check that it's not empty.
1685         if ((xdefi = xdefi_) == ZERO_ADDRESS) revert InvalidToken();
1686 
1687         owner = msg.sender;
1688         baseURI = baseURI_;
1689 
1690         DOMAIN_SEPARATOR = keccak256(
1691             abi.encode(
1692                 // keccak256(bytes('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')),
1693                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
1694                 // keccak256(bytes('XDEFI Badges')),
1695                 0x4c62db20b6844e29b4686cc489ff0c3aac678cce88f9352a7a0ef17d53feb307,
1696                 // keccak256(bytes('1')),
1697                 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6,
1698                 block.chainid,
1699                 address(this)
1700             )
1701         );
1702     }
1703 
1704     /*************/
1705     /* Modifiers */
1706     /*************/
1707 
1708     modifier onlyOwner() {
1709         if (owner != msg.sender) revert Unauthorized();
1710 
1711         _;
1712     }
1713 
1714     modifier noReenter() {
1715         if (_lockedStatus == IS_LOCKED) revert NoReentering();
1716 
1717         _lockedStatus = IS_LOCKED;
1718         _;
1719         _lockedStatus = IS_NOT_LOCKED;
1720     }
1721 
1722     modifier updatePointsPerUnitAtStart() {
1723         updateDistribution();
1724         _;
1725     }
1726 
1727     modifier updateDistributableAtEnd() {
1728         _;
1729         // NOTE: This needs to be done after updating `totalDepositedXDEFI` (which happens in `_destroyLockedPosition`) and transferring out.
1730         _updateDistributableXDEFI();
1731     }
1732 
1733     /*******************/
1734     /* Admin Functions */
1735     /*******************/
1736 
1737     function acceptOwnership() external {
1738         if (pendingOwner != msg.sender) revert Unauthorized();
1739 
1740         emit OwnershipAccepted(owner, msg.sender);
1741         owner = msg.sender;
1742         pendingOwner = ZERO_ADDRESS;
1743     }
1744 
1745     function activateEmergencyMode() external onlyOwner {
1746         inEmergencyMode = true;
1747         emit EmergencyModeActivated();
1748     }
1749 
1750     function proposeOwnership(address newOwner_) external onlyOwner {
1751         emit OwnershipProposed(owner, pendingOwner = newOwner_);
1752     }
1753 
1754     function setBaseURI(string calldata baseURI_) external onlyOwner {
1755         emit BaseURISet(baseURI = baseURI_);
1756     }
1757 
1758     function setLockPeriods(uint256[] calldata durations_, uint256[] calldata multipliers_) external onlyOwner {
1759         // Revert if an empty duration array is passed in, which would result in a successful, yet wasted useless transaction.
1760         if (durations_.length == ZERO_UINT256) revert EmptyArray();
1761 
1762         for (uint256 i; i < durations_.length; ) {
1763             uint256 duration = durations_[i];
1764             uint256 multiplier = multipliers_[i];
1765 
1766             // Revert if duration is 0 or longer than max defined.
1767             if (duration == ZERO_UINT256 || duration > MAX_DURATION) revert InvalidDuration();
1768 
1769             // Revert if bonus multiplier is larger than max defined.
1770             if (multiplier > MAX_BONUS_MULTIPLIER) revert InvalidMultiplier();
1771 
1772             emit LockPeriodSet(duration, bonusMultiplierOf[duration] = multiplier);
1773 
1774             unchecked {
1775                 ++i;
1776             }
1777         }
1778     }
1779 
1780     /**********************/
1781     /* Position Functions */
1782     /**********************/
1783 
1784     function emergencyUnlock(uint256 tokenId_, address destination_) external noReenter updateDistributableAtEnd returns (uint256 amountUnlocked_) {
1785         // Revert if not in emergency mode.
1786         if (!inEmergencyMode) revert NotInEmergencyMode();
1787 
1788         // Revert if caller is not the token's owner, not approved for all the owner's token, and not approved for this specific token.
1789         if (!_isApprovedOrOwner(msg.sender, tokenId_)) revert NotApprovedOrOwnerOfToken();
1790 
1791         // Fetch position.
1792         Position storage position = _positionOf[tokenId_];
1793         uint256 units = uint256(position.units);
1794         amountUnlocked_ = uint256(position.depositedXDEFI);
1795 
1796         // Track deposits.
1797         // NOTE: Can be unchecked since `totalDepositedXDEFI` increase in `_createLockedPosition` is the only place where `totalDepositedXDEFI` is set.
1798         unchecked {
1799             totalDepositedXDEFI -= amountUnlocked_;
1800         }
1801 
1802         // Delete FDT Position.
1803         // NOTE: Can be unchecked since `totalUnits` increase in `_createLockedPosition` is the only place where `totalUnits` is set.
1804         unchecked {
1805             totalUnits -= units;
1806         }
1807 
1808         delete _positionOf[tokenId_];
1809 
1810         // Send the unlocked XDEFI to the destination. (Don't need SafeERC20 since XDEFI is standard ERC20).
1811         IERC20(xdefi).transfer(destination_, amountUnlocked_);
1812     }
1813 
1814     function getBonusMultiplierOf(uint256 tokenId_) external view returns (uint256 bonusMultiplier_) {
1815         // Fetch position.
1816         Position storage position = _positionOf[tokenId_];
1817         uint256 units = uint256(position.units);
1818         uint256 depositedXDEFI = uint256(position.depositedXDEFI);
1819 
1820         bonusMultiplier_ = (units * ONE_HUNDRED_UINT256) / depositedXDEFI;
1821     }
1822 
1823     function lock(
1824         uint256 amount_,
1825         uint256 duration_,
1826         uint256 bonusMultiplier_,
1827         address destination_
1828     ) external noReenter updatePointsPerUnitAtStart returns (uint256 tokenId_) {
1829         tokenId_ = _lock(amount_, duration_, bonusMultiplier_, destination_);
1830     }
1831 
1832     function lockWithPermit(
1833         uint256 amount_,
1834         uint256 duration_,
1835         uint256 bonusMultiplier_,
1836         address destination_,
1837         uint256 deadline_,
1838         uint8 v_,
1839         bytes32 r_,
1840         bytes32 s_
1841     ) external noReenter updatePointsPerUnitAtStart returns (uint256 tokenId_) {
1842         // Approve this contract for the amount, using the provided signature.
1843         IEIP2612(xdefi).permit(msg.sender, address(this), amount_, deadline_, v_, r_, s_);
1844 
1845         tokenId_ = _lock(amount_, duration_, bonusMultiplier_, destination_);
1846     }
1847 
1848     function positionOf(uint256 tokenId_) external view returns (Position memory position_) {
1849         position_ = _positionOf[tokenId_];
1850     }
1851 
1852     function relock(
1853         uint256 tokenId_,
1854         uint256 lockAmount_,
1855         uint256 duration_,
1856         uint256 bonusMultiplier_,
1857         address destination_
1858     ) external noReenter updatePointsPerUnitAtStart updateDistributableAtEnd returns (uint256 amountUnlocked_, uint256 newTokenId_) {
1859         // Handle the unlock and get the amount of XDEFI eligible to withdraw.
1860         amountUnlocked_ = _destroyLockedPosition(msg.sender, tokenId_);
1861 
1862         newTokenId_ = _relock(lockAmount_, amountUnlocked_, duration_, bonusMultiplier_, destination_);
1863     }
1864 
1865     function unlock(uint256 tokenId_, address destination_) external noReenter updatePointsPerUnitAtStart updateDistributableAtEnd returns (uint256 amountUnlocked_) {
1866         // Handle the unlock and get the amount of XDEFI eligible to withdraw.
1867         amountUnlocked_ = _destroyLockedPosition(msg.sender, tokenId_);
1868 
1869         // Send the unlocked XDEFI to the destination. (Don't need SafeERC20 since XDEFI is standard ERC20).
1870         IERC20(xdefi).transfer(destination_, amountUnlocked_);
1871     }
1872 
1873     function updateDistribution() public {
1874         // NOTE: Since `_updateDistributableXDEFI` is called anywhere after XDEFI is withdrawn from the contract, here `changeInDistributableXDEFI` should always be greater than 0.
1875         uint256 increaseInDistributableXDEFI = _updateDistributableXDEFI();
1876 
1877         // Return if no change in distributable XDEFI.
1878         if (increaseInDistributableXDEFI == ZERO_UINT256) return;
1879 
1880         uint256 totalUnitsCached = totalUnits;
1881 
1882         // Revert if `totalUnitsCached` is zero. (This would have reverted anyway in the line below.)
1883         if (totalUnitsCached == ZERO_UINT256) revert NoUnitSupply();
1884 
1885         // NOTE: Max numerator is 240_000_000 * 1e18 * (2 ** 72), which is less than `type(uint256).max`, and min denominator is 1.
1886         //       So, `_pointsPerUnit` can grow by 2**160 every distribution of XDEFI's max supply.
1887         unchecked {
1888             _pointsPerUnit += (increaseInDistributableXDEFI << POINTS_MULTIPLIER_BITS) / totalUnitsCached;
1889         }
1890 
1891         emit DistributionUpdated(msg.sender, increaseInDistributableXDEFI);
1892     }
1893 
1894     function withdrawableOf(uint256 tokenId_) public view returns (uint256 withdrawableXDEFI_) {
1895         Position storage position = _positionOf[tokenId_];
1896         withdrawableXDEFI_ = _withdrawableGiven(position.units, position.depositedXDEFI, position.pointsCorrection);
1897     }
1898 
1899     /****************************/
1900     /* Batch Position Functions */
1901     /****************************/
1902 
1903     function relockBatch(
1904         uint256[] calldata tokenIds_,
1905         uint256 lockAmount_,
1906         uint256 duration_,
1907         uint256 bonusMultiplier_,
1908         address destination_
1909     ) external noReenter updatePointsPerUnitAtStart updateDistributableAtEnd returns (uint256 amountUnlocked_, uint256 newTokenId_) {
1910         // Handle the unlocks and get the amount of XDEFI eligible to withdraw.
1911         amountUnlocked_ = _unlockBatch(msg.sender, tokenIds_);
1912 
1913         newTokenId_ = _relock(lockAmount_, amountUnlocked_, duration_, bonusMultiplier_, destination_);
1914     }
1915 
1916     function unlockBatch(uint256[] calldata tokenIds_, address destination_) external noReenter updatePointsPerUnitAtStart updateDistributableAtEnd returns (uint256 amountUnlocked_) {
1917         // Handle the unlocks and get the amount of XDEFI eligible to withdraw.
1918         amountUnlocked_ = _unlockBatch(msg.sender, tokenIds_);
1919 
1920         // Send the unlocked XDEFI to the destination. (Don't need SafeERC20 since XDEFI is standard ERC20).
1921         IERC20(xdefi).transfer(destination_, amountUnlocked_);
1922     }
1923 
1924     /*****************/
1925     /* NFT Functions */
1926     /*****************/
1927 
1928     function attributesOf(uint256 tokenId_)
1929         external
1930         view
1931         returns (
1932             uint256 tier_,
1933             uint256 credits_,
1934             uint256 withdrawable_,
1935             uint256 expiry_
1936         )
1937     {
1938         // Revert if the token does not exist.
1939         if (!_exists(tokenId_)) revert TokenDoesNotExist();
1940 
1941         credits_ = creditsOf[tokenId_];
1942         tier_ = getTier(credits_);
1943         withdrawable_ = withdrawableOf(tokenId_);
1944         expiry_ = _positionOf[tokenId_].expiry;
1945     }
1946 
1947     function consume(uint256 tokenId_, uint256 amount_) external returns (uint256 remainingCredits_) {
1948         // Revert if the caller is not the token's owner, not approved for all the owner's token, and not approved for this specific token.
1949         if (!_isApprovedOrOwner(msg.sender, tokenId_)) revert InvalidConsumePermit();
1950 
1951         // Consume some of the token's credits.
1952         remainingCredits_ = _consume(tokenId_, amount_, msg.sender);
1953     }
1954 
1955     function consumeWithPermit(
1956         uint256 tokenId_,
1957         uint256 amount_,
1958         uint256 limit_,
1959         uint256 deadline_,
1960         uint8 v_,
1961         bytes32 r_,
1962         bytes32 s_
1963     ) external returns (uint256 remainingCredits_) {
1964         // Revert if the permit's deadline has been elapsed.
1965         if (block.timestamp >= deadline_) revert ConsumePermitExpired();
1966 
1967         // Revert if the amount being consumed is greater than the permit's defined limit.
1968         if (amount_ > limit_) revert BeyondConsumeLimit();
1969 
1970         // Hash the data as per keccak256("PermitConsume(uint256 tokenId,address consumer,uint256 limit,uint256 nonce,uint256 deadline)");
1971         bytes32 digest = keccak256(abi.encode(CONSUME_PERMIT_SIGNATURE_HASH, tokenId_, msg.sender, limit_, consumePermitNonce[tokenId_]++, deadline_));
1972 
1973         // Get the digest that was to be signed signed.
1974         digest = keccak256(abi.encodePacked(EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA, DOMAIN_SEPARATOR, digest));
1975 
1976         address recoveredAddress = ecrecover(digest, v_, r_, s_);
1977 
1978         // Revert if the account that signed the permit is not the token's owner, not approved for all the owner's token, and not approved for this specific token.
1979         if (!_isApprovedOrOwner(recoveredAddress, tokenId_)) revert InvalidConsumePermit();
1980 
1981         // Consume some of the token's credits.
1982         remainingCredits_ = _consume(tokenId_, amount_, msg.sender);
1983     }
1984 
1985     function contractURI() external view returns (string memory contractURI_) {
1986         contractURI_ = string(abi.encodePacked(baseURI, "info"));
1987     }
1988 
1989     function getCredits(uint256 amount_, uint256 duration_) public pure returns (uint256 credits_) {
1990         // Credits is implicitly capped at max supply of XDEFI for 10 years locked (less than 2**116).
1991         unchecked {
1992             credits_ = amount_ * duration_;
1993         }
1994     }
1995 
1996     function getTier(uint256 credits_) public pure returns (uint256 tier_) {
1997         if (credits_ < TIER_2_THRESHOLD) return TIER_1;
1998 
1999         if (credits_ < TIER_3_THRESHOLD) return TIER_2;
2000 
2001         if (credits_ < TIER_4_THRESHOLD) return TIER_3;
2002 
2003         if (credits_ < TIER_5_THRESHOLD) return TIER_4;
2004 
2005         if (credits_ < TIER_6_THRESHOLD) return TIER_5;
2006 
2007         if (credits_ < TIER_7_THRESHOLD) return TIER_6;
2008 
2009         if (credits_ < TIER_8_THRESHOLD) return TIER_7;
2010 
2011         if (credits_ < TIER_9_THRESHOLD) return TIER_8;
2012 
2013         if (credits_ < TIER_10_THRESHOLD) return TIER_9;
2014 
2015         if (credits_ < TIER_11_THRESHOLD) return TIER_10;
2016 
2017         if (credits_ < TIER_12_THRESHOLD) return TIER_11;
2018 
2019         if (credits_ < TIER_13_THRESHOLD) return TIER_12;
2020 
2021         return TIER_13;
2022     }
2023 
2024     function merge(uint256[] calldata tokenIds_) external returns (uint256 tokenId_, uint256 credits_) {
2025         // Revert if trying to merge 0 or 1 tokens, which cannot be done.
2026         if (tokenIds_.length <= ONE_UINT256) revert MustMergeMultiple();
2027 
2028         uint256 iterator = tokenIds_.length - 1;
2029 
2030         // For each NFT from last to second, check that it belongs to the caller, burn it, and accumulate the credits.
2031         while (iterator > ZERO_UINT256) {
2032             tokenId_ = tokenIds_[iterator];
2033 
2034             // Revert if the caller is not the token's owner, not approved for all the owner's token, and not approved for this specific token.
2035             if (!_isApprovedOrOwner(msg.sender, tokenId_)) revert NotApprovedOrOwnerOfToken();
2036 
2037             // Revert if position has an expiry property, which means it still exists.
2038             if (_positionOf[tokenId_].expiry != ZERO_UINT256) revert PositionStillLocked();
2039 
2040             unchecked {
2041                 // Max credits of a previously locked position is `type(uint128).max`, so `credits_` is reasonably not going to overflow.
2042                 credits_ += creditsOf[tokenId_];
2043 
2044                 --iterator;
2045             }
2046 
2047             // Clear the credits for this token, and burn the token.
2048             delete creditsOf[tokenId_];
2049             _burn(tokenId_);
2050         }
2051 
2052         // The resulting token id is the first token.
2053         tokenId_ = tokenIds_[0];
2054 
2055         // The total credits merged into the first token is the sum of the first's plus the accumulation of the credits from burned tokens.
2056         credits_ = (creditsOf[tokenId_] += credits_);
2057 
2058         emit TokensMerged(tokenIds_, tokenId_, credits_);
2059     }
2060 
2061     function tokenURI(uint256 tokenId_) public view override(IXDEFIDistribution, ERC721) returns (string memory tokenURI_) {
2062         // Revert if the token does not exist.
2063         if (!_exists(tokenId_)) revert TokenDoesNotExist();
2064 
2065         tokenURI_ = string(abi.encodePacked(baseURI, Strings.toString(tokenId_)));
2066     }
2067 
2068     /**********************/
2069     /* Internal Functions */
2070     /**********************/
2071 
2072     function _consume(
2073         uint256 tokenId_,
2074         uint256 amount_,
2075         address consumer_
2076     ) internal returns (uint256 remainingCredits_) {
2077         remainingCredits_ = creditsOf[tokenId_];
2078 
2079         // Revert if credits to decrement is greater than credits of nft.
2080         if (amount_ > remainingCredits_) revert InsufficientCredits();
2081 
2082         unchecked {
2083             // Can be unchecked due to check done above.
2084             creditsOf[tokenId_] = (remainingCredits_ -= amount_);
2085         }
2086 
2087         emit CreditsConsumed(tokenId_, consumer_, amount_);
2088     }
2089 
2090     function _createLockedPosition(
2091         uint256 amount_,
2092         uint256 duration_,
2093         uint256 bonusMultiplier_,
2094         address destination_
2095     ) internal returns (uint256 tokenId_) {
2096         // Revert is locking has been disabled.
2097         if (inEmergencyMode) revert LockingIsDisabled();
2098 
2099         uint256 bonusMultiplier = bonusMultiplierOf[duration_];
2100 
2101         // Revert if the bonus multiplier is zero.
2102         if (bonusMultiplier == ZERO_UINT256) revert InvalidDuration();
2103 
2104         // Revert if the bonus multiplier is not at least what was expected.
2105         if (bonusMultiplier < bonusMultiplier_) revert IncorrectBonusMultiplier();
2106 
2107         unchecked {
2108             // Generate a token id.
2109             tokenId_ = ++_tokensMinted;
2110 
2111             // Store credits.
2112             creditsOf[tokenId_] = getCredits(amount_, duration_);
2113 
2114             // Track deposits.
2115             totalDepositedXDEFI += amount_;
2116 
2117             // The rest creates the locked position.
2118             uint256 units = (amount_ * bonusMultiplier) / ONE_HUNDRED_UINT256;
2119 
2120             // Revert if position will end up with less than define minimum lockable units.
2121             if (units < MINIMUM_UNITS) revert LockResultsInTooFewUnits();
2122 
2123             totalUnits += units;
2124 
2125             _positionOf[tokenId_] = Position({
2126                 units: uint96(units), // 240M * 1e18 * 255 can never be larger than a `uint96`.
2127                 depositedXDEFI: uint88(amount_), // There are only 240M (18 decimals) XDEFI tokens so can never be larger than a `uint88`.
2128                 expiry: uint32(block.timestamp + duration_), // For many years, block.timestamp + duration_ will never be larger than a `uint32`.
2129                 created: uint32(block.timestamp), // For many years, block.timestamp will never be larger than a `uint32`.
2130                 pointsCorrection: _pointsPerUnit * units // _pointsPerUnit * units cannot be greater than a `uint256`.
2131             });
2132         }
2133 
2134         emit LockPositionCreated(tokenId_, destination_, amount_, duration_);
2135 
2136         // Mint a locked staked position NFT to the destination.
2137         _safeMint(destination_, tokenId_);
2138     }
2139 
2140     function _destroyLockedPosition(address account_, uint256 tokenId_) internal returns (uint256 amountUnlocked_) {
2141         // Revert if account_ is not the token's owner, not approved for all the owner's token, and not approved for this specific token.
2142         if (!_isApprovedOrOwner(account_, tokenId_)) revert NotApprovedOrOwnerOfToken();
2143 
2144         // Fetch position.
2145         Position storage position = _positionOf[tokenId_];
2146         uint256 units = uint256(position.units);
2147         uint256 depositedXDEFI = uint256(position.depositedXDEFI);
2148         uint256 expiry = uint256(position.expiry);
2149 
2150         // Revert if the position does not have an expiry, which means the position does not exist.
2151         if (expiry == ZERO_UINT256) revert PositionAlreadyUnlocked();
2152 
2153         // Revert if not enough time has elapsed in order to unlock AND locking is not disabled (which would mean we are allowing emergency withdrawals).
2154         if (block.timestamp < expiry && !inEmergencyMode) revert CannotUnlock();
2155 
2156         // Get the withdrawable amount of XDEFI for the position.
2157         amountUnlocked_ = _withdrawableGiven(units, depositedXDEFI, position.pointsCorrection);
2158 
2159         // Track deposits.
2160         // NOTE: Can be unchecked since `totalDepositedXDEFI` increase in `_createLockedPosition` is the only place where `totalDepositedXDEFI` is set.
2161         unchecked {
2162             totalDepositedXDEFI -= depositedXDEFI;
2163         }
2164 
2165         // Delete FDT Position.
2166         // NOTE: Can be unchecked since `totalUnits` increase in `_createLockedPosition` is the only place where `totalUnits` is set.
2167         unchecked {
2168             totalUnits -= units;
2169         }
2170 
2171         delete _positionOf[tokenId_];
2172 
2173         emit LockPositionWithdrawn(tokenId_, account_, amountUnlocked_);
2174     }
2175 
2176     function _lock(
2177         uint256 amount_,
2178         uint256 duration_,
2179         uint256 bonusMultiplier_,
2180         address destination_
2181     ) internal returns (uint256 tokenId_) {
2182         // Lock the XDEFI in the contract. (Don't need SafeERC20 since XDEFI is standard ERC20).
2183         IERC20(xdefi).transferFrom(msg.sender, address(this), amount_);
2184 
2185         // Handle the lock position creation and get the tokenId of the locked position.
2186         tokenId_ = _createLockedPosition(amount_, duration_, bonusMultiplier_, destination_);
2187     }
2188 
2189     function _relock(
2190         uint256 lockAmount_,
2191         uint256 amountUnlocked_,
2192         uint256 duration_,
2193         uint256 bonusMultiplier_,
2194         address destination_
2195     ) internal returns (uint256 tokenId_) {
2196         // Throw convenient error if trying to re-lock more than was unlocked. `amountUnlocked_ - lockAmount_` cannot revert below now.
2197         if (lockAmount_ > amountUnlocked_) revert InsufficientAmountUnlocked();
2198 
2199         // Handle the lock position creation and get the tokenId of the locked position.
2200         tokenId_ = _createLockedPosition(lockAmount_, duration_, bonusMultiplier_, destination_);
2201 
2202         unchecked {
2203             if (amountUnlocked_ - lockAmount_ != ZERO_UINT256) {
2204                 // Send the excess XDEFI to the destination, if needed. (Don't need SafeERC20 since XDEFI is standard ERC20).
2205                 IERC20(xdefi).transfer(destination_, amountUnlocked_ - lockAmount_);
2206             }
2207         }
2208     }
2209 
2210     function _unlockBatch(address account_, uint256[] calldata tokenIds_) internal returns (uint256 amountUnlocked_) {
2211         // Revert if trying to unlock 0 positions, which would result in a successful, yet wasted useless transaction.
2212         if (tokenIds_.length == ZERO_UINT256) revert EmptyArray();
2213 
2214         // Handle the unlock for each position and accumulate the unlocked amount.
2215         for (uint256 i; i < tokenIds_.length; ) {
2216             unchecked {
2217                 amountUnlocked_ += _destroyLockedPosition(account_, tokenIds_[i]);
2218 
2219                 ++i;
2220             }
2221         }
2222     }
2223 
2224     function _updateDistributableXDEFI() internal returns (uint256 increaseInDistributableXDEFI_) {
2225         uint256 xdefiBalance = IERC20(xdefi).balanceOf(address(this));
2226         uint256 previousDistributableXDEFI = distributableXDEFI;
2227 
2228         unchecked {
2229             uint256 currentDistributableXDEFI = xdefiBalance > totalDepositedXDEFI ? xdefiBalance - totalDepositedXDEFI : ZERO_UINT256;
2230 
2231             // Return 0 early if distributable XDEFI did not change.
2232             if (currentDistributableXDEFI == previousDistributableXDEFI) return ZERO_UINT256;
2233 
2234             // Set distributableXDEFI.
2235             distributableXDEFI = currentDistributableXDEFI;
2236 
2237             // Return 0 early if distributable XDEFI decreased.
2238             if (currentDistributableXDEFI < previousDistributableXDEFI) return ZERO_UINT256;
2239 
2240             increaseInDistributableXDEFI_ = currentDistributableXDEFI - previousDistributableXDEFI;
2241         }
2242     }
2243 
2244     function _withdrawableGiven(
2245         uint256 units_,
2246         uint256 depositedXDEFI_,
2247         uint256 pointsCorrection_
2248     ) internal view returns (uint256 withdrawableXDEFI_) {
2249         // NOTE: In a worst case (120k XDEFI locked at 2.55x bonus, 120k XDEFI reward, cycled 1 million times) `_pointsPerUnit * units_` is smaller than 2**248.
2250         //       Since `pointsCorrection_` is always less than `_pointsPerUnit * units_`, (because `_pointsPerUnit` only grows) there is no underflow on the subtraction.
2251         //       Finally, `depositedXDEFI_` is at most 88 bits, so after the division by a very large `POINTS_MULTIPLIER`, this doesn't need to be checked.
2252         unchecked {
2253             withdrawableXDEFI_ = (((_pointsPerUnit * units_) - pointsCorrection_) >> POINTS_MULTIPLIER_BITS) + depositedXDEFI_;
2254         }
2255     }
2256 }