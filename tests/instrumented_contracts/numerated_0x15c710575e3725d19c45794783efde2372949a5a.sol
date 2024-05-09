1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/Context.sol
73 
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         return msg.data;
96     }
97 }
98 
99 // File: @openzeppelin/contracts/utils/Address.sol
100 
101 
102 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
103 
104 pragma solidity ^0.8.1;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      *
127      * [IMPORTANT]
128      * ====
129      * You shouldn't rely on `isContract` to protect against flash loan attacks!
130      *
131      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
132      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
133      * constructor.
134      * ====
135      */
136     function isContract(address account) internal view returns (bool) {
137         // This method relies on extcodesize/address.code.length, which returns 0
138         // for contracts in construction, since the code is only stored at the end
139         // of the constructor execution.
140 
141         return account.code.length > 0;
142     }
143 
144     /**
145      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
146      * `recipient`, forwarding all available gas and reverting on errors.
147      *
148      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
149      * of certain opcodes, possibly making contracts go over the 2300 gas limit
150      * imposed by `transfer`, making them unable to receive funds via
151      * `transfer`. {sendValue} removes this limitation.
152      *
153      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
154      *
155      * IMPORTANT: because control is transferred to `recipient`, care must be
156      * taken to not create reentrancy vulnerabilities. Consider using
157      * {ReentrancyGuard} or the
158      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
159      */
160     function sendValue(address payable recipient, uint256 amount) internal {
161         require(address(this).balance >= amount, "Address: insufficient balance");
162 
163         (bool success, ) = recipient.call{value: amount}("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167     /**
168      * @dev Performs a Solidity function call using a low level `call`. A
169      * plain `call` is an unsafe replacement for a function call: use this
170      * function instead.
171      *
172      * If `target` reverts with a revert reason, it is bubbled up by this
173      * function (like regular Solidity function calls).
174      *
175      * Returns the raw returned data. To convert to the expected return value,
176      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
177      *
178      * Requirements:
179      *
180      * - `target` must be a contract.
181      * - calling `target` with `data` must not revert.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
186         return functionCall(target, data, "Address: low-level call failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
191      * `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCall(
196         address target,
197         bytes memory data,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         return functionCallWithValue(target, data, 0, errorMessage);
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
205      * but also transferring `value` wei to `target`.
206      *
207      * Requirements:
208      *
209      * - the calling contract must have an ETH balance of at least `value`.
210      * - the called Solidity function must be `payable`.
211      *
212      * _Available since v3.1._
213      */
214     function functionCallWithValue(
215         address target,
216         bytes memory data,
217         uint256 value
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
224      * with `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(address(this).balance >= value, "Address: insufficient balance for call");
235         require(isContract(target), "Address: call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.call{value: value}(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a static call.
244      *
245      * _Available since v3.3._
246      */
247     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
248         return functionStaticCall(target, data, "Address: low-level static call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a static call.
254      *
255      * _Available since v3.3._
256      */
257     function functionStaticCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal view returns (bytes memory) {
262         require(isContract(target), "Address: static call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.staticcall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
270      * but performing a delegate call.
271      *
272      * _Available since v3.4._
273      */
274     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
275         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
280      * but performing a delegate call.
281      *
282      * _Available since v3.4._
283      */
284     function functionDelegateCall(
285         address target,
286         bytes memory data,
287         string memory errorMessage
288     ) internal returns (bytes memory) {
289         require(isContract(target), "Address: delegate call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.delegatecall(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
297      * revert reason using the provided one.
298      *
299      * _Available since v4.3._
300      */
301     function verifyCallResult(
302         bool success,
303         bytes memory returndata,
304         string memory errorMessage
305     ) internal pure returns (bytes memory) {
306         if (success) {
307             return returndata;
308         } else {
309             // Look for revert reason and bubble it up if present
310             if (returndata.length > 0) {
311                 // The easiest way to bubble the revert reason is using memory via assembly
312 
313                 assembly {
314                     let returndata_size := mload(returndata)
315                     revert(add(32, returndata), returndata_size)
316                 }
317             } else {
318                 revert(errorMessage);
319             }
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
325 
326 
327 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @title ERC721 token receiver interface
333  * @dev Interface for any contract that wants to support safeTransfers
334  * from ERC721 asset contracts.
335  */
336 interface IERC721Receiver {
337     /**
338      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
339      * by `operator` from `from`, this function is called.
340      *
341      * It must return its Solidity selector to confirm the token transfer.
342      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
343      *
344      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
345      */
346     function onERC721Received(
347         address operator,
348         address from,
349         uint256 tokenId,
350         bytes calldata data
351     ) external returns (bytes4);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Interface of the ERC165 standard, as defined in the
363  * https://eips.ethereum.org/EIPS/eip-165[EIP].
364  *
365  * Implementers can declare support of contract interfaces, which can then be
366  * queried by others ({ERC165Checker}).
367  *
368  * For an implementation, see {ERC165}.
369  */
370 interface IERC165 {
371     /**
372      * @dev Returns true if this contract implements the interface defined by
373      * `interfaceId`. See the corresponding
374      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
375      * to learn more about how these ids are created.
376      *
377      * This function call must use less than 30 000 gas.
378      */
379     function supportsInterface(bytes4 interfaceId) external view returns (bool);
380 }
381 
382 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Implementation of the {IERC165} interface.
392  *
393  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
394  * for the additional interface id that will be supported. For example:
395  *
396  * ```solidity
397  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
398  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
399  * }
400  * ```
401  *
402  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
403  */
404 abstract contract ERC165 is IERC165 {
405     /**
406      * @dev See {IERC165-supportsInterface}.
407      */
408     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409         return interfaceId == type(IERC165).interfaceId;
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
414 
415 
416 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Required interface of an ERC721 compliant contract.
423  */
424 interface IERC721 is IERC165 {
425     /**
426      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
427      */
428     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
429 
430     /**
431      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
432      */
433     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
434 
435     /**
436      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
437      */
438     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
439 
440     /**
441      * @dev Returns the number of tokens in ``owner``'s account.
442      */
443     function balanceOf(address owner) external view returns (uint256 balance);
444 
445     /**
446      * @dev Returns the owner of the `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function ownerOf(uint256 tokenId) external view returns (address owner);
453 
454     /**
455      * @dev Safely transfers `tokenId` token from `from` to `to`.
456      *
457      * Requirements:
458      *
459      * - `from` cannot be the zero address.
460      * - `to` cannot be the zero address.
461      * - `tokenId` token must exist and be owned by `from`.
462      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
473 
474     /**
475      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
476      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
477      *
478      * Requirements:
479      *
480      * - `from` cannot be the zero address.
481      * - `to` cannot be the zero address.
482      * - `tokenId` token must exist and be owned by `from`.
483      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
484      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
485      *
486      * Emits a {Transfer} event.
487      */
488     function safeTransferFrom(
489         address from,
490         address to,
491         uint256 tokenId
492     ) external;
493 
494     /**
495      * @dev Transfers `tokenId` token from `from` to `to`.
496      *
497      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transferFrom(
509         address from,
510         address to,
511         uint256 tokenId
512     ) external;
513 
514     /**
515      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
516      * The approval is cleared when the token is transferred.
517      *
518      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
519      *
520      * Requirements:
521      *
522      * - The caller must own the token or be an approved operator.
523      * - `tokenId` must exist.
524      *
525      * Emits an {Approval} event.
526      */
527     function approve(address to, uint256 tokenId) external;
528 
529     /**
530      * @dev Approve or remove `operator` as an operator for the caller.
531      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
532      *
533      * Requirements:
534      *
535      * - The `operator` cannot be the caller.
536      *
537      * Emits an {ApprovalForAll} event.
538      */
539     function setApprovalForAll(address operator, bool _approved) external;
540 
541     /**
542      * @dev Returns the account approved for `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function getApproved(uint256 tokenId) external view returns (address operator);
549 
550     /**
551      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
552      *
553      * See {setApprovalForAll}
554      */
555     function isApprovedForAll(address owner, address operator) external view returns (bool);
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
559 
560 
561 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
568  * @dev See https://eips.ethereum.org/EIPS/eip-721
569  */
570 interface IERC721Enumerable is IERC721 {
571     /**
572      * @dev Returns the total amount of tokens stored by the contract.
573      */
574     function totalSupply() external view returns (uint256);
575 
576     /**
577      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
578      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
579      */
580     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
581 
582     /**
583      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
584      * Use along with {totalSupply} to enumerate all tokens.
585      */
586     function tokenByIndex(uint256 index) external view returns (uint256);
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 /**
598  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
599  * @dev See https://eips.ethereum.org/EIPS/eip-721
600  */
601 interface IERC721Metadata is IERC721 {
602     /**
603      * @dev Returns the token collection name.
604      */
605     function name() external view returns (string memory);
606 
607     /**
608      * @dev Returns the token collection symbol.
609      */
610     function symbol() external view returns (string memory);
611 
612     /**
613      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
614      */
615     function tokenURI(uint256 tokenId) external view returns (string memory);
616 }
617 
618 // File: ERC721A.sol
619 
620 
621 // Creator: Chiru Labs
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 
628 
629 
630 
631 
632 
633 /**
634  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
635  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
636  *
637  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
638  *
639  * Does not support burning tokens to address(0).
640  *
641  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
642  */
643 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
644     using Address for address;
645     using Strings for uint256;
646 
647     struct TokenOwnership {
648         address addr;
649         uint64 startTimestamp;
650     }
651 
652     struct AddressData {
653         uint128 balance;
654         uint128 numberMinted;
655     }
656 
657     uint256 internal currentIndex;
658 
659     // Token name
660     string private _name;
661 
662     // Token symbol
663     string private _symbol;
664 
665     // Mapping from token ID to ownership details
666     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
667     mapping(uint256 => TokenOwnership) internal _ownerships;
668 
669     // Mapping owner address to address data
670     mapping(address => AddressData) private _addressData;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     constructor(string memory name_, string memory symbol_) {
679         _name = name_;
680         _symbol = symbol_;
681     }
682 
683     /**
684      * @dev See {IERC721Enumerable-totalSupply}.
685      */
686     function totalSupply() public view override returns (uint256) {
687         return currentIndex;
688     }
689 
690     /**
691      * @dev See {IERC721Enumerable-tokenByIndex}.
692      */
693     function tokenByIndex(uint256 index) public view override returns (uint256) {
694         require(index < totalSupply(), 'ERC721A: global index out of bounds');
695         return index;
696     }
697 
698     /**
699      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
700      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
701      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
702      */
703     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
704         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
705         uint256 numMintedSoFar = totalSupply();
706         uint256 tokenIdsIdx;
707         address currOwnershipAddr;
708 
709         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
710         unchecked {
711             for (uint256 i; i < numMintedSoFar; i++) {
712                 TokenOwnership memory ownership = _ownerships[i];
713                 if (ownership.addr != address(0)) {
714                     currOwnershipAddr = ownership.addr;
715                 }
716                 if (currOwnershipAddr == owner) {
717                     if (tokenIdsIdx == index) {
718                         return i;
719                     }
720                     tokenIdsIdx++;
721                 }
722             }
723         }
724 
725         revert('ERC721A: unable to get token of owner by index');
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             interfaceId == type(IERC721Enumerable).interfaceId ||
736             super.supportsInterface(interfaceId);
737     }
738 
739     /**
740      * @dev See {IERC721-balanceOf}.
741      */
742     function balanceOf(address owner) public view override returns (uint256) {
743         require(owner != address(0), 'ERC721A: balance query for the zero address');
744         return uint256(_addressData[owner].balance);
745     }
746 
747     function _numberMinted(address owner) internal view returns (uint256) {
748         require(owner != address(0), 'ERC721A: number minted query for the zero address');
749         return uint256(_addressData[owner].numberMinted);
750     }
751 
752     /**
753      * Gas spent here starts off proportional to the maximum mint batch size.
754      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
755      */
756     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
757         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
758 
759         unchecked {
760             for (uint256 curr = tokenId; curr >= 0; curr--) {
761                 TokenOwnership memory ownership = _ownerships[curr];
762                 if (ownership.addr != address(0)) {
763                     return ownership;
764                 }
765             }
766         }
767 
768         revert('ERC721A: unable to determine the owner of token');
769     }
770 
771     /**
772      * @dev See {IERC721-ownerOf}.
773      */
774     function ownerOf(uint256 tokenId) public view override returns (address) {
775         return ownershipOf(tokenId).addr;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-name}.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-symbol}.
787      */
788     function symbol() public view virtual override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-tokenURI}.
794      */
795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
796         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
797 
798         string memory baseURI = _baseURI();
799         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805      * by default, can be overriden in child contracts.
806      */
807     function _baseURI() internal view virtual returns (string memory) {
808         return '';
809     }
810 
811     /**
812      * @dev See {IERC721-approve}.
813      */
814     function approve(address to, uint256 tokenId) public override {
815         address owner = ERC721A.ownerOf(tokenId);
816         require(to != owner, 'ERC721A: approval to current owner');
817 
818         require(
819             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820             'ERC721A: approve caller is not owner nor approved for all'
821         );
822 
823         _approve(to, tokenId, owner);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view override returns (address) {
830         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public override {
839         require(operator != _msgSender(), 'ERC721A: approve to caller');
840 
841         _operatorApprovals[_msgSender()][operator] = approved;
842         emit ApprovalForAll(_msgSender(), operator, approved);
843     }
844 
845     /**
846      * @dev See {IERC721-isApprovedForAll}.
847      */
848     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
849         return _operatorApprovals[owner][operator];
850     }
851 
852     /**
853      * @dev See {IERC721-transferFrom}.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) public override {
860         _transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public override {
871         safeTransferFrom(from, to, tokenId, '');
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) public override {
883         _transfer(from, to, tokenId);
884         require(
885             _checkOnERC721Received(from, to, tokenId, _data),
886             'ERC721A: transfer to non ERC721Receiver implementer'
887         );
888     }
889 
890     /**
891      * @dev Returns whether `tokenId` exists.
892      *
893      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
894      *
895      * Tokens start existing when they are minted (`_mint`),
896      */
897     function _exists(uint256 tokenId) internal view returns (bool) {
898         return tokenId < currentIndex;
899     }
900 
901     function _safeMint(address to, uint256 quantity) internal {
902         _safeMint(to, quantity, '');
903     }
904 
905     /**
906      * @dev Safely mints `quantity` tokens and transfers them to `to`.
907      *
908      * Requirements:
909      *
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
911      * - `quantity` must be greater than 0.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _safeMint(
916         address to,
917         uint256 quantity,
918         bytes memory _data
919     ) internal {
920         _mint(to, quantity, _data, true);
921     }
922 
923     /**
924      * @dev Mints `quantity` tokens and transfers them to `to`.
925      *
926      * Requirements:
927      *
928      * - `to` cannot be the zero address.
929      * - `quantity` must be greater than 0.
930      *
931      * Emits a {Transfer} event.
932      */
933     function _mint(
934         address to,
935         uint256 quantity,
936         bytes memory _data,
937         bool safe
938     ) internal {
939         uint256 startTokenId = currentIndex;
940         require(to != address(0), 'ERC721A: mint to the zero address');
941         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
942 
943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945         // Overflows are incredibly unrealistic.
946         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
947         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
948         unchecked {
949             _addressData[to].balance += uint128(quantity);
950             _addressData[to].numberMinted += uint128(quantity);
951 
952             _ownerships[startTokenId].addr = to;
953             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
954 
955             uint256 updatedIndex = startTokenId;
956 
957             for (uint256 i; i < quantity; i++) {
958                 emit Transfer(address(0), to, updatedIndex);
959                 if (safe) {
960                     require(
961                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
962                         'ERC721A: transfer to non ERC721Receiver implementer'
963                     );
964                 }
965 
966                 updatedIndex++;
967             }
968 
969             currentIndex = updatedIndex;
970         }
971 
972         _afterTokenTransfers(address(0), to, startTokenId, quantity);
973     }
974 
975     /**
976      * @dev Transfers `tokenId` from `from` to `to`.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must be owned by `from`.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _transfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) private {
990         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
991 
992         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
993             getApproved(tokenId) == _msgSender() ||
994             isApprovedForAll(prevOwnership.addr, _msgSender()));
995 
996         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
997 
998         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
999         require(to != address(0), 'ERC721A: transfer to the zero address');
1000 
1001         _beforeTokenTransfers(from, to, tokenId, 1);
1002 
1003         // Clear approvals from the previous owner
1004         _approve(address(0), tokenId, prevOwnership.addr);
1005 
1006         // Underflow of the sender's balance is impossible because we check for
1007         // ownership above and the recipient's balance can't realistically overflow.
1008         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1009         unchecked {
1010             _addressData[from].balance -= 1;
1011             _addressData[to].balance += 1;
1012 
1013             _ownerships[tokenId].addr = to;
1014             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1015 
1016             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1017             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1018             uint256 nextTokenId = tokenId + 1;
1019             if (_ownerships[nextTokenId].addr == address(0)) {
1020                 if (_exists(nextTokenId)) {
1021                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1022                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1023                 }
1024             }
1025         }
1026 
1027         emit Transfer(from, to, tokenId);
1028         _afterTokenTransfers(from, to, tokenId, 1);
1029     }
1030 
1031     /**
1032      * @dev Approve `to` to operate on `tokenId`
1033      *
1034      * Emits a {Approval} event.
1035      */
1036     function _approve(
1037         address to,
1038         uint256 tokenId,
1039         address owner
1040     ) private {
1041         _tokenApprovals[tokenId] = to;
1042         emit Approval(owner, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1047      * The call is not executed if the target address is not a contract.
1048      *
1049      * @param from address representing the previous owner of the given token ID
1050      * @param to target address that will receive the tokens
1051      * @param tokenId uint256 ID of the token to be transferred
1052      * @param _data bytes optional data to send along with the call
1053      * @return bool whether the call correctly returned the expected magic value
1054      */
1055     function _checkOnERC721Received(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) private returns (bool) {
1061         if (to.isContract()) {
1062             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1063                 return retval == IERC721Receiver(to).onERC721Received.selector;
1064             } catch (bytes memory reason) {
1065                 if (reason.length == 0) {
1066                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1067                 } else {
1068                     assembly {
1069                         revert(add(32, reason), mload(reason))
1070                     }
1071                 }
1072             }
1073         } else {
1074             return true;
1075         }
1076     }
1077 
1078     /**
1079      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1080      *
1081      * startTokenId - the first token id to be transferred
1082      * quantity - the amount to be transferred
1083      *
1084      * Calling conditions:
1085      *
1086      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1087      * transferred to `to`.
1088      * - When `from` is zero, `tokenId` will be minted for `to`.
1089      */
1090     function _beforeTokenTransfers(
1091         address from,
1092         address to,
1093         uint256 startTokenId,
1094         uint256 quantity
1095     ) internal virtual {}
1096 
1097     /**
1098      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1099      * minting.
1100      *
1101      * startTokenId - the first token id to be transferred
1102      * quantity - the amount to be transferred
1103      *
1104      * Calling conditions:
1105      *
1106      * - when `from` and `to` are both non-zero.
1107      * - `from` and `to` are never both zero.
1108      */
1109     function _afterTokenTransfers(
1110         address from,
1111         address to,
1112         uint256 startTokenId,
1113         uint256 quantity
1114     ) internal virtual {}
1115 }
1116 // File: goblintownai-contract.sol
1117 
1118 
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 /**
1123  * @dev Contract module which allows children to implement an emergency stop
1124  * mechanism that can be triggered by an authorized account.
1125  *
1126  * This module is used through inheritance. It will make available the
1127  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1128  * the functions of your contract. Note that they will not be pausable by
1129  * simply including this module, only once the modifiers are put in place.
1130  */
1131 abstract contract Pausable is Context {
1132     /**
1133      * @dev Emitted when the pause is triggered by `account`.
1134      */
1135     event Paused(address account);
1136 
1137     /**
1138      * @dev Emitted when the pause is lifted by `account`.
1139      */
1140     event Unpaused(address account);
1141 
1142     bool private _paused;
1143 
1144     /**
1145      * @dev Initializes the contract in unpaused state.
1146      */
1147     constructor() {
1148         _paused = false;
1149     }
1150 
1151     /**
1152      * @dev Returns true if the contract is paused, and false otherwise.
1153      */
1154     function paused() public view virtual returns (bool) {
1155         return _paused;
1156     }
1157 
1158     /**
1159      * @dev Modifier to make a function callable only when the contract is not paused.
1160      *
1161      * Requirements:
1162      *
1163      * - The contract must not be paused.
1164      */
1165     modifier whenNotPaused() {
1166         require(!paused(), "Pausable: paused");
1167         _;
1168     }
1169 
1170     /**
1171      * @dev Modifier to make a function callable only when the contract is paused.
1172      *
1173      * Requirements:
1174      *
1175      * - The contract must be paused.
1176      */
1177     modifier whenPaused() {
1178         require(paused(), "Pausable: not paused");
1179         _;
1180     }
1181 
1182     /**
1183      * @dev Triggers stopped state.
1184      *
1185      * Requirements:
1186      *
1187      * - The contract must not be paused.
1188      */
1189     function _pause() internal virtual whenNotPaused {
1190         _paused = true;
1191         emit Paused(_msgSender());
1192     }
1193 
1194     /**
1195      * @dev Returns to normal state.
1196      *
1197      * Requirements:
1198      *
1199      * - The contract must be paused.
1200      */
1201     function _unpause() internal virtual whenPaused {
1202         _paused = false;
1203         emit Unpaused(_msgSender());
1204     }
1205 }
1206 
1207 // Ownable.sol
1208 
1209 pragma solidity ^0.8.0;
1210 
1211 /**
1212  * @dev Contract module which provides a basic access control mechanism, where
1213  * there is an account (an owner) that can be granted exclusive access to
1214  * specific functions.
1215  *
1216  * By default, the owner account will be the one that deploys the contract. This
1217  * can later be changed with {transferOwnership}.
1218  *
1219  * This module is used through inheritance. It will make available the modifier
1220  * `onlyOwner`, which can be applied to your functions to restrict their use to
1221  * the owner.
1222  */
1223 abstract contract Ownable is Context {
1224     address private _owner;
1225 
1226     event OwnershipTransferred(
1227         address indexed previousOwner,
1228         address indexed newOwner
1229     );
1230 
1231     /**
1232      * @dev Initializes the contract setting the deployer as the initial owner.
1233      */
1234     constructor() {
1235         _setOwner(_msgSender());
1236     }
1237 
1238     /**
1239      * @dev Returns the address of the current owner.
1240      */
1241     function owner() public view virtual returns (address) {
1242         return _owner;
1243     }
1244 
1245     /**
1246      * @dev Throws if called by any account other than the owner.
1247      */
1248     modifier onlyOwner() {
1249         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1250         _;
1251     }
1252 
1253     /**
1254      * @dev Leaves the contract without owner. It will not be possible to call
1255      * `onlyOwner` functions anymore. Can only be called by the current owner.
1256      *
1257      * NOTE: Renouncing ownership will leave the contract without an owner,
1258      * thereby removing any functionality that is only available to the owner.
1259      */
1260     function renounceOwnership() public virtual onlyOwner {
1261         _setOwner(address(0));
1262     }
1263 
1264     /**
1265      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1266      * Can only be called by the current owner.
1267      */
1268     function transferOwnership(address newOwner) public virtual onlyOwner {
1269         require(
1270             newOwner != address(0),
1271             "Ownable: new owner is the zero address"
1272         );
1273         _setOwner(newOwner);
1274     }
1275 
1276     function _setOwner(address newOwner) private {
1277         address oldOwner = _owner;
1278         _owner = newOwner;
1279         emit OwnershipTransferred(oldOwner, newOwner);
1280     }
1281 }
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 /**
1286  * @dev Contract module that helps prevent reentrant calls to a function.
1287  *
1288  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1289  * available, which can be applied to functions to make sure there are no nested
1290  * (reentrant) calls to them.
1291  *
1292  * Note that because there is a single `nonReentrant` guard, functions marked as
1293  * `nonReentrant` may not call one another. This can be worked around by making
1294  * those functions `private`, and then adding `external` `nonReentrant` entry
1295  * points to them.
1296  *
1297  * TIP: If you would like to learn more about reentrancy and alternative ways
1298  * to protect against it, check out our blog post
1299  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1300  */
1301 abstract contract ReentrancyGuard {
1302     // Booleans are more expensive than uint256 or any type that takes up a full
1303     // word because each write operation emits an extra SLOAD to first read the
1304     // slot's contents, replace the bits taken up by the boolean, and then write
1305     // back. This is the compiler's defense against contract upgrades and
1306     // pointer aliasing, and it cannot be disabled.
1307 
1308     // The values being non-zero value makes deployment a bit more expensive,
1309     // but in exchange the refund on every call to nonReentrant will be lower in
1310     // amount. Since refunds are capped to a percentage of the total
1311     // transaction's gas, it is best to keep them low in cases like this one, to
1312     // increase the likelihood of the full refund coming into effect.
1313     uint256 private constant _NOT_ENTERED = 1;
1314     uint256 private constant _ENTERED = 2;
1315 
1316     uint256 private _status;
1317 
1318     constructor() {
1319         _status = _NOT_ENTERED;
1320     }
1321 
1322     /**
1323      * @dev Prevents a contract from calling itself, directly or indirectly.
1324      * Calling a `nonReentrant` function from another `nonReentrant`
1325      * function is not supported. It is possible to prevent this from happening
1326      * by making the `nonReentrant` function external, and make it call a
1327      * `private` function that does the actual work.
1328      */
1329     modifier nonReentrant() {
1330         // On the first call to nonReentrant, _notEntered will be true
1331         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1332 
1333         // Any calls to nonReentrant after this point will fail
1334         _status = _ENTERED;
1335 
1336         _;
1337 
1338         // By storing the original value once again, a refund is triggered (see
1339         // https://eips.ethereum.org/EIPS/eip-2200)
1340         _status = _NOT_ENTERED;
1341     }
1342 }
1343 
1344 //newerc.sol
1345 pragma solidity ^0.8.0;
1346 
1347 
1348 contract BoredBonez is ERC721A, Ownable, Pausable, ReentrancyGuard {
1349     using Strings for uint256;
1350     string public baseURI;
1351     uint256 public cost = 0.002 ether;
1352     uint256 public maxSupply = 10000;
1353     uint256 public maxFree = 10000;
1354     uint256 public maxperAddressFreeLimit = 1;
1355     uint256 public maxperTxnPublicMint = 20;
1356     bool public saleIsActive = false;
1357 
1358     mapping(address => uint256) public addressFreeMintedBalance;
1359 
1360     constructor() ERC721A("Bored Bonez", "BBZ") {
1361         setBaseURI("ipfs://bafybeihtdlblb2vdzf4dgqbzecsgwncoj2wcvf22fepn6mnsaa5syby2gu/");
1362 
1363     }
1364 
1365     function _baseURI() internal view virtual override returns (string memory) {
1366         return baseURI;
1367     }
1368 
1369     function freeMint(uint256 _mintAmount) public payable nonReentrant{
1370 		uint256 s = totalSupply();
1371         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1372         require(saleIsActive, "Sale not active");
1373         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "max free NFT per wallet exceeded");
1374 		require(_mintAmount > 0, "Cant mint 0" );
1375 		require(s + _mintAmount <= maxFree, "Cant go over free supply" );
1376 		for (uint256 i = 0; i < _mintAmount; ++i) {
1377             addressFreeMintedBalance[msg.sender]++;
1378 
1379 		}
1380         _safeMint(msg.sender, _mintAmount);
1381 		delete s;
1382         delete addressFreeMintedCount;
1383 	}
1384 
1385 
1386     function mint(uint256 _mintAmount) public payable nonReentrant {
1387         uint256 s = totalSupply();
1388         require(saleIsActive, "Sale not active");
1389         require(_mintAmount > 0, "Cant mint 0");
1390         require(_mintAmount <= maxperTxnPublicMint, "Cant mint more than maxperTxnPublicMint" );
1391         require(s + _mintAmount <= maxSupply, "Sold out!");
1392         require(msg.value >= cost * _mintAmount);
1393         _safeMint(msg.sender, _mintAmount);
1394         delete s;
1395     }
1396 
1397     function devMint(uint256 _mintAmount) public payable nonReentrant onlyOwner {
1398         uint256 s = totalSupply();
1399         require(_mintAmount > 0, "Cant mint 0");
1400         require(s + _mintAmount <= maxSupply, "Cant go over supply");
1401         _safeMint(msg.sender, _mintAmount);
1402         delete s;
1403     }
1404 
1405     function tokenURI(uint256 tokenId)
1406         public
1407         view
1408         virtual
1409         override
1410         returns (string memory)
1411     {
1412         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1413         string memory currentBaseURI = _baseURI();
1414         return
1415             bytes(currentBaseURI).length > 0
1416                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1417                 : "";
1418     }
1419 
1420     function flipSaleState() public onlyOwner {
1421         saleIsActive = !saleIsActive;
1422     }
1423 
1424     function setCost(uint256 _newCost) public onlyOwner {
1425         cost = _newCost;
1426     }
1427 
1428      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1429                maxFree = _newMaxFreeSupply;
1430     }
1431 
1432     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1433         baseURI = _newBaseURI;
1434     }
1435 
1436     function setMaxperTxnPublicMint(uint256 _amount) public onlyOwner {
1437         maxperTxnPublicMint = _amount;
1438     }
1439 
1440     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1441         maxperAddressFreeLimit = _amount;
1442     }
1443     function withdraw() public payable onlyOwner {
1444         (bool success, ) = payable(msg.sender).call{
1445             value: address(this).balance
1446         }("");
1447         require(success);
1448     }
1449 }