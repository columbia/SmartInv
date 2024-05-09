1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214 
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
227 
228 
229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @dev Interface of the ERC165 standard, as defined in the
265  * https://eips.ethereum.org/EIPS/eip-165[EIP].
266  *
267  * Implementers can declare support of contract interfaces, which can then be
268  * queried by others ({ERC165Checker}).
269  *
270  * For an implementation, see {ERC165}.
271  */
272 interface IERC165 {
273     /**
274      * @dev Returns true if this contract implements the interface defined by
275      * `interfaceId`. See the corresponding
276      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
277      * to learn more about how these ids are created.
278      *
279      * This function call must use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) external view returns (bool);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
296  * for the additional interface id that will be supported. For example:
297  *
298  * ```solidity
299  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
300  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
301  * }
302  * ```
303  *
304  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
305  */
306 abstract contract ERC165 is IERC165 {
307     /**
308      * @dev See {IERC165-supportsInterface}.
309      */
310     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
311         return interfaceId == type(IERC165).interfaceId;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 // File: https://github.com/chiru-labs/ERC721A/contracts/IERC721A.sol
490 
491 
492 // ERC721A Contracts v3.3.0
493 // Creator: Chiru Labs
494 
495 pragma solidity ^0.8.4;
496 
497 
498 
499 /**
500  * @dev Interface of an ERC721A compliant contract.
501  */
502 interface IERC721A is IERC721, IERC721Metadata {
503     /**
504      * The caller must own the token or be an approved operator.
505      */
506     error ApprovalCallerNotOwnerNorApproved();
507 
508     /**
509      * The token does not exist.
510      */
511     error ApprovalQueryForNonexistentToken();
512 
513     /**
514      * The caller cannot approve to their own address.
515      */
516     error ApproveToCaller();
517 
518     /**
519      * The caller cannot approve to the current owner.
520      */
521     error ApprovalToCurrentOwner();
522 
523     /**
524      * Cannot query the balance for the zero address.
525      */
526     error BalanceQueryForZeroAddress();
527 
528     /**
529      * Cannot mint to the zero address.
530      */
531     error MintToZeroAddress();
532 
533     /**
534      * The quantity of tokens minted must be more than zero.
535      */
536     error MintZeroQuantity();
537 
538     /**
539      * The token does not exist.
540      */
541     error OwnerQueryForNonexistentToken();
542 
543     /**
544      * The caller must own the token or be an approved operator.
545      */
546     error TransferCallerNotOwnerNorApproved();
547 
548     /**
549      * The token must be owned by `from`.
550      */
551     error TransferFromIncorrectOwner();
552 
553     /**
554      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
555      */
556     error TransferToNonERC721ReceiverImplementer();
557 
558     /**
559      * Cannot transfer to the zero address.
560      */
561     error TransferToZeroAddress();
562 
563     /**
564      * The token does not exist.
565      */
566     error URIQueryForNonexistentToken();
567 
568     // Compiler will pack this into a single 256bit word.
569     struct TokenOwnership {
570         // The address of the owner.
571         address addr;
572         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
573         uint64 startTimestamp;
574         // Whether the token has been burned.
575         bool burned;
576     }
577 
578     // Compiler will pack this into a single 256bit word.
579     struct AddressData {
580         // Realistically, 2**64-1 is more than enough.
581         uint64 balance;
582         // Keeps track of mint count with minimal overhead for tokenomics.
583         uint64 numberMinted;
584         // Keeps track of burn count with minimal overhead for tokenomics.
585         uint64 numberBurned;
586         // For miscellaneous variable(s) pertaining to the address
587         // (e.g. number of whitelist mint slots used).
588         // If there are multiple variables, please pack them into a uint64.
589         uint64 aux;
590     }
591 
592     /**
593      * @dev Returns the total amount of tokens stored by the contract.
594      * 
595      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
596      */
597     function totalSupply() external view returns (uint256);
598 }
599 
600 // File: @openzeppelin/contracts/utils/Strings.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev String operations.
609  */
610 library Strings {
611     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
612 
613     /**
614      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
615      */
616     function toString(uint256 value) internal pure returns (string memory) {
617         // Inspired by OraclizeAPI's implementation - MIT licence
618         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
619 
620         if (value == 0) {
621             return "0";
622         }
623         uint256 temp = value;
624         uint256 digits;
625         while (temp != 0) {
626             digits++;
627             temp /= 10;
628         }
629         bytes memory buffer = new bytes(digits);
630         while (value != 0) {
631             digits -= 1;
632             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
633             value /= 10;
634         }
635         return string(buffer);
636     }
637 
638     /**
639      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
640      */
641     function toHexString(uint256 value) internal pure returns (string memory) {
642         if (value == 0) {
643             return "0x00";
644         }
645         uint256 temp = value;
646         uint256 length = 0;
647         while (temp != 0) {
648             length++;
649             temp >>= 8;
650         }
651         return toHexString(value, length);
652     }
653 
654     /**
655      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
656      */
657     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
658         bytes memory buffer = new bytes(2 * length + 2);
659         buffer[0] = "0";
660         buffer[1] = "x";
661         for (uint256 i = 2 * length + 1; i > 1; --i) {
662             buffer[i] = _HEX_SYMBOLS[value & 0xf];
663             value >>= 4;
664         }
665         require(value == 0, "Strings: hex length insufficient");
666         return string(buffer);
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
671 
672 
673 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 // CAUTION
678 // This version of SafeMath should only be used with Solidity 0.8 or later,
679 // because it relies on the compiler's built in overflow checks.
680 
681 /**
682  * @dev Wrappers over Solidity's arithmetic operations.
683  *
684  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
685  * now has built in overflow checking.
686  */
687 library SafeMath {
688     /**
689      * @dev Returns the addition of two unsigned integers, with an overflow flag.
690      *
691      * _Available since v3.4._
692      */
693     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
694         unchecked {
695             uint256 c = a + b;
696             if (c < a) return (false, 0);
697             return (true, c);
698         }
699     }
700 
701     /**
702      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
703      *
704      * _Available since v3.4._
705      */
706     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
707         unchecked {
708             if (b > a) return (false, 0);
709             return (true, a - b);
710         }
711     }
712 
713     /**
714      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
715      *
716      * _Available since v3.4._
717      */
718     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
719         unchecked {
720             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
721             // benefit is lost if 'b' is also tested.
722             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
723             if (a == 0) return (true, 0);
724             uint256 c = a * b;
725             if (c / a != b) return (false, 0);
726             return (true, c);
727         }
728     }
729 
730     /**
731      * @dev Returns the division of two unsigned integers, with a division by zero flag.
732      *
733      * _Available since v3.4._
734      */
735     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
736         unchecked {
737             if (b == 0) return (false, 0);
738             return (true, a / b);
739         }
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
744      *
745      * _Available since v3.4._
746      */
747     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
748         unchecked {
749             if (b == 0) return (false, 0);
750             return (true, a % b);
751         }
752     }
753 
754     /**
755      * @dev Returns the addition of two unsigned integers, reverting on
756      * overflow.
757      *
758      * Counterpart to Solidity's `+` operator.
759      *
760      * Requirements:
761      *
762      * - Addition cannot overflow.
763      */
764     function add(uint256 a, uint256 b) internal pure returns (uint256) {
765         return a + b;
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting on
770      * overflow (when the result is negative).
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a - b;
780     }
781 
782     /**
783      * @dev Returns the multiplication of two unsigned integers, reverting on
784      * overflow.
785      *
786      * Counterpart to Solidity's `*` operator.
787      *
788      * Requirements:
789      *
790      * - Multiplication cannot overflow.
791      */
792     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a * b;
794     }
795 
796     /**
797      * @dev Returns the integer division of two unsigned integers, reverting on
798      * division by zero. The result is rounded towards zero.
799      *
800      * Counterpart to Solidity's `/` operator.
801      *
802      * Requirements:
803      *
804      * - The divisor cannot be zero.
805      */
806     function div(uint256 a, uint256 b) internal pure returns (uint256) {
807         return a / b;
808     }
809 
810     /**
811      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
812      * reverting when dividing by zero.
813      *
814      * Counterpart to Solidity's `%` operator. This function uses a `revert`
815      * opcode (which leaves remaining gas untouched) while Solidity uses an
816      * invalid opcode to revert (consuming all remaining gas).
817      *
818      * Requirements:
819      *
820      * - The divisor cannot be zero.
821      */
822     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
823         return a % b;
824     }
825 
826     /**
827      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
828      * overflow (when the result is negative).
829      *
830      * CAUTION: This function is deprecated because it requires allocating memory for the error
831      * message unnecessarily. For custom revert reasons use {trySub}.
832      *
833      * Counterpart to Solidity's `-` operator.
834      *
835      * Requirements:
836      *
837      * - Subtraction cannot overflow.
838      */
839     function sub(
840         uint256 a,
841         uint256 b,
842         string memory errorMessage
843     ) internal pure returns (uint256) {
844         unchecked {
845             require(b <= a, errorMessage);
846             return a - b;
847         }
848     }
849 
850     /**
851      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
852      * division by zero. The result is rounded towards zero.
853      *
854      * Counterpart to Solidity's `/` operator. Note: this function uses a
855      * `revert` opcode (which leaves remaining gas untouched) while Solidity
856      * uses an invalid opcode to revert (consuming all remaining gas).
857      *
858      * Requirements:
859      *
860      * - The divisor cannot be zero.
861      */
862     function div(
863         uint256 a,
864         uint256 b,
865         string memory errorMessage
866     ) internal pure returns (uint256) {
867         unchecked {
868             require(b > 0, errorMessage);
869             return a / b;
870         }
871     }
872 
873     /**
874      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
875      * reverting with custom message when dividing by zero.
876      *
877      * CAUTION: This function is deprecated because it requires allocating memory for the error
878      * message unnecessarily. For custom revert reasons use {tryMod}.
879      *
880      * Counterpart to Solidity's `%` operator. This function uses a `revert`
881      * opcode (which leaves remaining gas untouched) while Solidity uses an
882      * invalid opcode to revert (consuming all remaining gas).
883      *
884      * Requirements:
885      *
886      * - The divisor cannot be zero.
887      */
888     function mod(
889         uint256 a,
890         uint256 b,
891         string memory errorMessage
892     ) internal pure returns (uint256) {
893         unchecked {
894             require(b > 0, errorMessage);
895             return a % b;
896         }
897     }
898 }
899 
900 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev Contract module that helps prevent reentrant calls to a function.
909  *
910  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
911  * available, which can be applied to functions to make sure there are no nested
912  * (reentrant) calls to them.
913  *
914  * Note that because there is a single `nonReentrant` guard, functions marked as
915  * `nonReentrant` may not call one another. This can be worked around by making
916  * those functions `private`, and then adding `external` `nonReentrant` entry
917  * points to them.
918  *
919  * TIP: If you would like to learn more about reentrancy and alternative ways
920  * to protect against it, check out our blog post
921  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
922  */
923 abstract contract ReentrancyGuard {
924     // Booleans are more expensive than uint256 or any type that takes up a full
925     // word because each write operation emits an extra SLOAD to first read the
926     // slot's contents, replace the bits taken up by the boolean, and then write
927     // back. This is the compiler's defense against contract upgrades and
928     // pointer aliasing, and it cannot be disabled.
929 
930     // The values being non-zero value makes deployment a bit more expensive,
931     // but in exchange the refund on every call to nonReentrant will be lower in
932     // amount. Since refunds are capped to a percentage of the total
933     // transaction's gas, it is best to keep them low in cases like this one, to
934     // increase the likelihood of the full refund coming into effect.
935     uint256 private constant _NOT_ENTERED = 1;
936     uint256 private constant _ENTERED = 2;
937 
938     uint256 private _status;
939 
940     constructor() {
941         _status = _NOT_ENTERED;
942     }
943 
944     /**
945      * @dev Prevents a contract from calling itself, directly or indirectly.
946      * Calling a `nonReentrant` function from another `nonReentrant`
947      * function is not supported. It is possible to prevent this from happening
948      * by making the `nonReentrant` function external, and making it call a
949      * `private` function that does the actual work.
950      */
951     modifier nonReentrant() {
952         // On the first call to nonReentrant, _notEntered will be true
953         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
954 
955         // Any calls to nonReentrant after this point will fail
956         _status = _ENTERED;
957 
958         _;
959 
960         // By storing the original value once again, a refund is triggered (see
961         // https://eips.ethereum.org/EIPS/eip-2200)
962         _status = _NOT_ENTERED;
963     }
964 }
965 
966 // File: @openzeppelin/contracts/utils/Context.sol
967 
968 
969 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @dev Provides information about the current execution context, including the
975  * sender of the transaction and its data. While these are generally available
976  * via msg.sender and msg.data, they should not be accessed in such a direct
977  * manner, since when dealing with meta-transactions the account sending and
978  * paying for execution may not be the actual sender (as far as an application
979  * is concerned).
980  *
981  * This contract is only required for intermediate, library-like contracts.
982  */
983 abstract contract Context {
984     function _msgSender() internal view virtual returns (address) {
985         return msg.sender;
986     }
987 
988     function _msgData() internal view virtual returns (bytes calldata) {
989         return msg.data;
990     }
991 }
992 
993 // File: ERC721A.sol
994 
995 
996 // ERC721A Contracts v3.3.0
997 // Creator: Chiru Labs
998 
999 pragma solidity ^0.8.4;
1000 
1001 
1002 
1003 
1004 
1005 
1006 
1007 /**
1008  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1009  * the Metadata extension. Built to optimize for lower gas during batch mints.
1010  *
1011  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1012  *
1013  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1014  *
1015  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1016  */
1017 contract ERC721A is Context, ERC165, IERC721A{
1018 
1019     //Variables   
1020     using Address for address;
1021     using Strings for uint256;
1022 
1023    
1024     // The tokenId of the next token to be minted.
1025     uint256 internal _currentIndex;
1026 
1027     // The number of tokens burned.
1028     uint256 internal _burnCounter;
1029 
1030     // Token name
1031     string private _name;
1032 
1033     // Token symbol
1034     string private _symbol;
1035 
1036     // Mapping from token ID to ownership details
1037     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1038     mapping(uint256 => TokenOwnership) internal _ownerships;
1039 
1040     // Mapping owner address to address data
1041     mapping(address => AddressData) private _addressData;
1042 
1043     // Mapping from token ID to approved address
1044     mapping(uint256 => address) private _tokenApprovals;
1045 
1046     // Mapping from owner to operator approvals
1047     mapping(address => mapping(address => bool)) private _operatorApprovals;
1048 
1049 //------------------------------------------------------------------------------------------
1050 //Functions Begin
1051 //------------------------------------------------------------------------------------------
1052 
1053    constructor(string memory name_, string memory symbol_) {
1054         _name = name_;
1055         _symbol = symbol_;
1056         _currentIndex = _startTokenId();
1057     }
1058 
1059     /**
1060      * To change the starting tokenId, please override this function.
1061      */
1062     function _startTokenId() internal view virtual returns (uint256) {
1063         return 0;
1064     }
1065 
1066     /**
1067      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1068      */
1069     function totalSupply() public view override returns (uint256) {
1070         // Counter underflow is impossible as _burnCounter cannot be incremented
1071         // more than _currentIndex - _startTokenId() times
1072         unchecked {
1073             return _currentIndex - _burnCounter - _startTokenId();
1074         }
1075     }
1076 
1077     /**
1078      * Returns the total amount of tokens minted in the contract.
1079      */
1080     function _totalMinted() internal view returns (uint256) {
1081         // Counter underflow is impossible as _currentIndex does not decrement,
1082         // and it is initialized to _startTokenId()
1083         unchecked {
1084             return _currentIndex - _startTokenId();
1085         }
1086     }
1087 
1088     /**
1089      * @dev See {IERC165-supportsInterface}.
1090      */
1091     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1092         return
1093             interfaceId == type(IERC721).interfaceId ||
1094             interfaceId == type(IERC721Metadata).interfaceId ||
1095             super.supportsInterface(interfaceId);
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-balanceOf}.
1100      */
1101     function balanceOf(address owner) public view override returns (uint256) {
1102         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1103         return uint256(_addressData[owner].balance);
1104     }
1105 
1106     /**
1107      * Returns the number of tokens minted by `owner`.
1108      */
1109     function _numberMinted(address owner) internal view returns (uint256) {
1110         return uint256(_addressData[owner].numberMinted);
1111     }
1112 
1113     /**
1114      * Returns the number of tokens burned by or on behalf of `owner`.
1115      */
1116     function _numberBurned(address owner) internal view returns (uint256) {
1117         return uint256(_addressData[owner].numberBurned);
1118     }
1119 
1120     /**
1121      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1122      */
1123     function _getAux(address owner) internal view returns (uint64) {
1124         return _addressData[owner].aux;
1125     }
1126 
1127     /**
1128      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1129      * If there are multiple variables, please pack them into a uint64.
1130      */
1131     function _setAux(address owner, uint64 aux) internal {
1132         _addressData[owner].aux = aux;
1133     }
1134 
1135     /**
1136      * Gas spent here starts off proportional to the maximum mint batch size.
1137      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1138      */
1139     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1140         uint256 curr = tokenId;
1141 
1142         unchecked {
1143             if (_startTokenId() <= curr && curr < _currentIndex) {
1144                 TokenOwnership memory ownership = _ownerships[curr];
1145                 if (!ownership.burned) {
1146                     if (ownership.addr != address(0)) {
1147                         return ownership;
1148                     }
1149                     // Invariant:
1150                     // There will always be an ownership that has an address and is not burned
1151                     // before an ownership that does not have an address and is not burned.
1152                     // Hence, curr will not underflow.
1153                     while (true) {
1154                         curr--;
1155                         ownership = _ownerships[curr];
1156                         if (ownership.addr != address(0)) {
1157                             return ownership;
1158                         }
1159                     }
1160                 }
1161             }
1162         }
1163         revert OwnerQueryForNonexistentToken();
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-ownerOf}.
1168      */
1169     function ownerOf(uint256 tokenId) public view override returns (address) {
1170         return _ownershipOf(tokenId).addr;
1171     }
1172 
1173     /**
1174      * @dev See {IERC721Metadata-name}.
1175      */
1176     function name() public view virtual override returns (string memory) {
1177         return _name;
1178     }
1179 
1180     /**
1181      * @dev See {IERC721Metadata-symbol}.
1182      */
1183     function symbol() public view virtual override returns (string memory) {
1184         return _symbol;
1185     }
1186 
1187     /**
1188      * @dev See {IERC721Metadata-tokenURI}.
1189      */
1190       function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1191         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1192 
1193         string memory baseURI = _baseURI();
1194         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1195     }
1196 
1197     /**
1198      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1199      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1200      * by default, can be overriden in child contracts.
1201      */
1202     function _baseURI() internal view virtual returns (string memory) {
1203         return '';
1204     }
1205 
1206     /**
1207      * @dev See {IERC721-approve}.
1208      */
1209     function approve(address to, uint256 tokenId) public override {
1210         address owner = ERC721A.ownerOf(tokenId);
1211         if (to == owner) revert ApprovalToCurrentOwner();
1212 
1213         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1214             revert ApprovalCallerNotOwnerNorApproved();
1215         }
1216 
1217         _approve(to, tokenId, owner);
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-getApproved}.
1222      */
1223     function getApproved(uint256 tokenId) public view override returns (address) {
1224         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1225 
1226         return _tokenApprovals[tokenId];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-setApprovalForAll}.
1231      */
1232     function setApprovalForAll(address operator, bool approved) public virtual override {
1233         if (operator == _msgSender()) revert ApproveToCaller();
1234 
1235         _operatorApprovals[_msgSender()][operator] = approved;
1236         emit ApprovalForAll(_msgSender(), operator, approved);
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-isApprovedForAll}.
1241      */
1242     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1243         return _operatorApprovals[owner][operator];
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-transferFrom}.
1248      */
1249     function transferFrom(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) public virtual override {
1254         _transfer(from, to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-safeTransferFrom}.
1259      */
1260     function safeTransferFrom(
1261         address from,
1262         address to,
1263         uint256 tokenId
1264     ) public virtual override {
1265         safeTransferFrom(from, to, tokenId, '');
1266     }
1267 
1268     /**
1269      * @dev See {IERC721-safeTransferFrom}.
1270      */
1271     function safeTransferFrom(
1272         address from,
1273         address to,
1274         uint256 tokenId,
1275         bytes memory _data
1276     ) public virtual override {
1277         _transfer(from, to, tokenId);
1278         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1279             revert TransferToNonERC721ReceiverImplementer();
1280         }
1281     }
1282 
1283     /**
1284      * @dev Returns whether `tokenId` exists.
1285      *
1286      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1287      *
1288      * Tokens start existing when they are minted (`_mint`),
1289      */
1290     function _exists(uint256 tokenId) internal view returns (bool) {
1291         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1292     }
1293     
1294     /**
1295      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1296      */
1297     function _safeMint(address to, uint256 quantity) internal{
1298         _safeMint(to, quantity, '');
1299     }
1300 
1301     /**
1302      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1303      *
1304      * Requirements:
1305      *
1306      * - If `to` refers to a smart contract, it must implement
1307      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1308      * - `quantity` must be greater than 0.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _safeMint(
1313         address to,
1314         uint256 quantity,
1315         bytes memory _data
1316     ) internal {
1317         _mint(to, quantity, _data, true);
1318     }
1319 
1320     /**
1321      * @dev Mints `quantity` tokens and transfers them to `to`.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - `quantity` must be greater than 0.
1327      *
1328      * Emits a {Transfer} event.
1329      */
1330     function _mint(address to,  
1331                    uint256 quantity, 
1332                    bytes memory _data,
1333                    bool safe
1334         ) internal {
1335         uint256 startTokenId = _currentIndex;
1336         if (to == address(0)) revert MintToZeroAddress();
1337         if (quantity == 0) revert MintZeroQuantity();
1338 
1339         // Overflows are incredibly unrealistic.
1340         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1341         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1342         unchecked {
1343             _addressData[to].balance += uint64(quantity);
1344             _addressData[to].numberMinted += uint64(quantity);
1345 
1346             _ownerships[startTokenId].addr = to;
1347             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1348 
1349             uint256 updatedIndex = startTokenId;
1350             uint256 end = updatedIndex + quantity;
1351 
1352             if (safe && to.isContract()) {
1353                 do {
1354                     emit Transfer(address(0), to, updatedIndex);
1355                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1356                         revert TransferToNonERC721ReceiverImplementer();
1357                     }
1358                 } while (updatedIndex < end);
1359                 // Reentrancy protection
1360                 if (_currentIndex != startTokenId) revert();
1361             } else {
1362                 do {
1363                     emit Transfer(address(0), to, updatedIndex++);
1364                 } while (updatedIndex < end);
1365             }
1366             _currentIndex = updatedIndex;
1367         }
1368     }
1369 
1370 //------------------------------------------------------------------------------------------
1371     /**
1372      * @dev Transfers `tokenId` from `from` to `to`.
1373      *
1374      * Requirements:
1375      *
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must be owned by `from`.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _transfer(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) private {
1386         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1387 
1388         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1389 
1390         bool isApprovedOrOwner = (_msgSender() == from ||
1391             isApprovedForAll(from, _msgSender()) ||
1392             getApproved(tokenId) == _msgSender());
1393 
1394         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1395         if (to == address(0)) revert TransferToZeroAddress();
1396 
1397         // Clear approvals from the previous owner
1398         _approve(address(0), tokenId, from);
1399 
1400         // Underflow of the sender's balance is impossible because we check for
1401         // ownership above and the recipient's balance can't realistically overflow.
1402         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1403         unchecked {
1404             _addressData[from].balance -= 1;
1405             _addressData[to].balance += 1;
1406 
1407             TokenOwnership storage currSlot = _ownerships[tokenId];
1408             currSlot.addr = to;
1409             currSlot.startTimestamp = uint64(block.timestamp);
1410 
1411             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1412             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1413             uint256 nextTokenId = tokenId + 1;
1414             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1415             if (nextSlot.addr == address(0)) {
1416                 // This will suffice for checking _exists(nextTokenId),
1417                 // as a burned slot cannot contain the zero address.
1418                 if (nextTokenId != _currentIndex) {
1419                     nextSlot.addr = from;
1420                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1421                 }
1422             }
1423         }
1424 
1425         emit Transfer(from, to, tokenId);
1426     }
1427 
1428     /**
1429      * @dev Equivalent to `_burn(tokenId, false)`.
1430      */
1431     function _burn(uint256 tokenId) internal virtual {
1432         _burn(tokenId, false);
1433     }
1434 
1435     /**
1436      * @dev Destroys `tokenId`.
1437      * The approval is cleared when the token is burned.
1438      *
1439      * Requirements:
1440      *
1441      * - `tokenId` must exist.
1442      *
1443      * Emits a {Transfer} event.
1444      */
1445     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1446         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1447 
1448         address from = prevOwnership.addr;
1449 
1450         if (approvalCheck) {
1451             bool isApprovedOrOwner = (_msgSender() == from ||
1452                 isApprovedForAll(from, _msgSender()) ||
1453                 getApproved(tokenId) == _msgSender());
1454 
1455             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1456         }
1457 
1458         // Clear approvals from the previous owner
1459         _approve(address(0), tokenId, from);
1460 
1461         // Underflow of the sender's balance is impossible because we check for
1462         // ownership above and the recipient's balance can't realistically overflow.
1463         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1464         unchecked {
1465             AddressData storage addressData = _addressData[from];
1466             addressData.balance -= 1;
1467             addressData.numberBurned += 1;
1468 
1469             // Keep track of who burned the token, and the timestamp of burning.
1470             TokenOwnership storage currSlot = _ownerships[tokenId];
1471             currSlot.addr = from;
1472             currSlot.startTimestamp = uint64(block.timestamp);
1473             currSlot.burned = true;
1474 
1475             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1476             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1477             uint256 nextTokenId = tokenId + 1;
1478             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1479             if (nextSlot.addr == address(0)) {
1480                 // This will suffice for checking _exists(nextTokenId),
1481                 // as a burned slot cannot contain the zero address.
1482                 if (nextTokenId != _currentIndex) {
1483                     nextSlot.addr = from;
1484                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1485                 }
1486             }
1487         }
1488 
1489         emit Transfer(from, address(0), tokenId);
1490         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1491         unchecked {
1492             _burnCounter++;
1493         }
1494     }
1495 
1496     /**
1497      * @dev Approve `to` to operate on `tokenId`
1498      *
1499      * Emits a {Approval} event.
1500      */
1501     function _approve(
1502         address to,
1503         uint256 tokenId,
1504         address owner
1505     ) private {
1506         _tokenApprovals[tokenId] = to;
1507         emit Approval(owner, to, tokenId);
1508     }
1509 
1510     /**
1511      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1512      *
1513      * @param from address representing the previous owner of the given token ID
1514      * @param to target address that will receive the tokens
1515      * @param tokenId uint256 ID of the token to be transferred
1516      * @param _data bytes optional data to send along with the call
1517      * @return bool whether the call correctly returned the expected magic value
1518      */
1519     function _checkContractOnERC721Received(
1520         address from,
1521         address to,
1522         uint256 tokenId,
1523         bytes memory _data
1524     ) private returns (bool) {
1525         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1526             return retval == IERC721Receiver(to).onERC721Received.selector;
1527         } catch (bytes memory reason) {
1528             if (reason.length == 0) {
1529                 revert TransferToNonERC721ReceiverImplementer();
1530             } else {
1531                 assembly {
1532                     revert(add(32, reason), mload(reason))
1533                 }
1534             }
1535         }
1536     }
1537 
1538 }
1539 // File: @openzeppelin/contracts/access/Ownable.sol
1540 
1541 
1542 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 
1547 /**
1548  * @dev Contract module which provides a basic access control mechanism, where
1549  * there is an account (an owner) that can be granted exclusive access to
1550  * specific functions.
1551  *
1552  * By default, the owner account will be the one that deploys the contract. This
1553  * can later be changed with {transferOwnership}.
1554  *
1555  * This module is used through inheritance. It will make available the modifier
1556  * `onlyOwner`, which can be applied to your functions to restrict their use to
1557  * the owner.
1558  */
1559 abstract contract Ownable is Context {
1560     address private _owner;
1561 
1562     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1563 
1564     /**
1565      * @dev Initializes the contract setting the deployer as the initial owner.
1566      */
1567     constructor() {
1568         _transferOwnership(_msgSender());
1569     }
1570 
1571     /**
1572      * @dev Returns the address of the current owner.
1573      */
1574     function owner() public view virtual returns (address) {
1575         return _owner;
1576     }
1577 
1578     /**
1579      * @dev Throws if called by any account other than the owner.
1580      */
1581     modifier onlyOwner() {
1582         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1583         _;
1584     }
1585 
1586     /**
1587      * @dev Leaves the contract without owner. It will not be possible to call
1588      * `onlyOwner` functions anymore. Can only be called by the current owner.
1589      *
1590      * NOTE: Renouncing ownership will leave the contract without an owner,
1591      * thereby removing any functionality that is only available to the owner.
1592      */
1593     function renounceOwnership() public virtual onlyOwner {
1594         _transferOwnership(address(0));
1595     }
1596 
1597     /**
1598      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1599      * Can only be called by the current owner.
1600      */
1601     function transferOwnership(address newOwner) public virtual onlyOwner {
1602         require(newOwner != address(0), "Ownable: new owner is the zero address");
1603         _transferOwnership(newOwner);
1604     }
1605 
1606     /**
1607      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1608      * Internal function without access restriction.
1609      */
1610     function _transferOwnership(address newOwner) internal virtual {
1611         address oldOwner = _owner;
1612         _owner = newOwner;
1613         emit OwnershipTransferred(oldOwner, newOwner);
1614     }
1615 }
1616 
1617 // File: Thinkr.sol
1618 
1619 
1620 
1621 pragma solidity ^0.8.7;
1622 
1623 
1624 
1625 
1626 
1627 
1628 contract Thinkr is Ownable, ERC721A, ReentrancyGuard{
1629     using SafeMath for uint256;
1630     using Strings for uint256;
1631 
1632     uint256 public immutable MAX_TOKENS = 10000;
1633     uint256 public price = 0.08 ether;
1634     uint256 public allowlistPrice = 0.05 ether;
1635 
1636     bool public saleStarted = false;
1637     bool public presaleStarted = false;
1638     bool public revealed = false;
1639 
1640     uint256 public maxPerWallet = 10;
1641     uint256 public maxPerAllow = 1;
1642 
1643     string public baseURI;
1644     string public baseExtension = ".json";
1645     string public notRevealedURI;
1646 
1647   //Stores addresses for allow list
1648   mapping(address => uint256) public allowlist;
1649   //This stores number of mints per wallet address during publicSale
1650   mapping(address => uint256) public _walletMints;
1651 
1652   //------------------------------------------------------------
1653   constructor(
1654     string memory initBaseURI_,
1655     string memory initNotRevealedURI_
1656 
1657   ) ERC721A("Thinkrs", "THKRS") {
1658     baseURI = initBaseURI_;
1659     notRevealedURI = initNotRevealedURI_;
1660     presaleStarted = true;
1661     _safeMint(msg.sender, 100);
1662   }
1663 //------------------------------------------------------------
1664 
1665   function togglePresaleStarted() external onlyOwner {
1666         presaleStarted = !presaleStarted;
1667     }
1668 
1669   function toggleSaleStarted() external onlyOwner {
1670         saleStarted = !saleStarted;
1671         presaleStarted = !presaleStarted;
1672     }
1673 
1674  function setBaseURI(string calldata newBaseURI) external onlyOwner {
1675     baseURI = newBaseURI;
1676   }
1677 
1678   function reveal(bool _state) public onlyOwner {
1679       revealed = _state;
1680   }
1681 
1682   function setMaxPerWallet(uint256 _newMaxPerWallet) external onlyOwner {
1683       maxPerWallet = _newMaxPerWallet;
1684   }
1685   
1686   function setMaxPerAllow(uint256 _newMaxPerAllow) external onlyOwner {
1687       maxPerAllow = _newMaxPerAllow;
1688   }
1689  
1690  function setNotRevealedURI(string memory _notRevealedURI) external onlyOwner {
1691     notRevealedURI = _notRevealedURI;
1692   }
1693 
1694   function setBaseExtension(string memory _newBaseExtension) external onlyOwner {
1695     baseExtension = _newBaseExtension;
1696   }
1697   
1698   function setPrice(uint256 _newPrice) external onlyOwner {
1699     price = _newPrice * (1 ether);
1700   }
1701 
1702   function setAllowPrice(uint256 _newPrice) external onlyOwner {
1703     allowlistPrice = _newPrice * (1 ether);
1704   }
1705 
1706   function getMintSlots(address user)public view returns (uint256) {
1707     require(allowlist[user] >= 0, "Incorrect allowlist mint slots");
1708     if(allowlist[user] == 0){
1709       return 0;
1710     }
1711     uint256 mintSlots = allowlist[user];
1712     return mintSlots;
1713   }
1714 
1715   function seedAllowlist(address[] memory addresses) external onlyOwner
1716   {
1717     require(
1718       addresses.length > 0,
1719       "addresses cannot be empty"
1720     );
1721     for (uint256 i = 0; i < addresses.length; i++) {
1722       allowlist[addresses[i]] = maxPerAllow;
1723     }
1724   }
1725 
1726   function withdrawMoney() external onlyOwner nonReentrant {
1727     uint256 balance = address(this).balance;
1728     require(balance > 0, "Insufficent balance");
1729     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1730     require(success, "Transfer failed.");
1731   }
1732 
1733   
1734 //------------------------------------------------------------
1735  //Check to see what token# we want to start at! 
1736 function _startTokenId() internal pure override returns (uint256) {
1737         return 1;
1738 }
1739 
1740 function _baseURI() internal view virtual override returns (string memory) {
1741     return baseURI;
1742 
1743 }
1744 
1745 //------------------------------------------------------------
1746 function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1747         require(_exists(tokenId),"ERC721Metadata: Nonexistent token");
1748 
1749         //Added for NFT reveal
1750         if (revealed == false){
1751             return (notRevealedURI);
1752         }   
1753 
1754         string memory currentBaseURI = _baseURI();
1755         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : '';
1756 }
1757 
1758 function numberMinted(address owner) public view returns (uint256) {
1759     return _numberMinted(owner);
1760 }
1761 
1762 function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory){
1763     return _ownershipOf(tokenId);
1764 }
1765 
1766 modifier callerIsUser() {
1767     require(tx.origin == msg.sender, "The caller is another contract");
1768     _;
1769 }
1770 
1771 //AllowlistMint allows people to choose to mint 1 
1772 function allowlistMint(uint256 tokens) external payable callerIsUser {
1773     require(presaleStarted, "Presale has not started");
1774     require(tokens > 0 && tokens <= maxPerAllow, "Must mint at least one token and not more than 2");
1775     uint256 mintPrice = allowlistPrice;
1776     require(mintPrice != 0, "allowlist sale has not begun yet");
1777     require(allowlist[msg.sender] > 0, "not eligible for allowlist mint");
1778     uint256 mintSlots = allowlist[msg.sender];
1779     require(tokens <= mintSlots, "You cannot mint this amount");
1780     require(totalSupply() + tokens <= MAX_TOKENS, "reached max supply");
1781     require(msg.value == mintPrice * tokens,"ETH amount is incorrect");
1782     allowlist[msg.sender] = allowlist[msg.sender] - tokens;
1783     _safeMint(msg.sender, tokens);
1784 }
1785 
1786 /// Public Sale mint function
1787 /// @param tokens number of tokens to mint
1788 /// @dev reverts if any of the public sale preconditions aren't satisfied
1789 function mint(uint256 tokens) external payable callerIsUser {
1790     require(saleStarted, "Sale has not started");
1791     require(presaleStarted == false, "Public sale not started");
1792     require(tokens <= maxPerWallet, "Cannot purchase this many tokens in a transaction");
1793     require(_walletMints[_msgSender()] + tokens <= maxPerWallet, "Limit for this wallet reached");
1794     require(totalSupply() + tokens <= MAX_TOKENS, "Minting would exceed max supply");
1795     require(tokens > 0, "Must mint at least one token");
1796     require(price * tokens == msg.value, "ETH amount is incorrect");
1797 
1798     _walletMints[_msgSender()] += tokens;
1799     _safeMint(_msgSender(), tokens);
1800 }
1801 }