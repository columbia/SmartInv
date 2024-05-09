1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 //  _           _                                           
6 // | |__   __ _| |__  _   _   _ __   ___  ___  ___ _ __ ___ 
7 // | '_ \ / _` | '_ \| | | | | '_ \ / _ \/ __|/ _ \ '__/ __|
8 // | |_) | (_| | |_) | |_| | | |_) | (_) \__ \  __/ |  \__ \
9 // |_.__/ \__,_|_.__/ \__, | | .__/ \___/|___/\___|_|  |___/
10 //                    |___/  |_|                            
11 //                                                
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/utils/Address.sol
108 
109 
110 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
111 
112 pragma solidity ^0.8.1;
113 
114 /**
115  * @dev Collection of functions related to the address type
116  */
117 library Address {
118     /**
119      * @dev Returns true if `account` is a contract.
120      *
121      * [IMPORTANT]
122      * ====
123      * It is unsafe to assume that an address for which this function returns
124      * false is an externally-owned account (EOA) and not a contract.
125      *
126      * Among others, `isContract` will return false for the following
127      * types of addresses:
128      *
129      *  - an externally-owned account
130      *  - a contract in construction
131      *  - an address where a contract will be created
132      *  - an address where a contract lived, but was destroyed
133      * ====
134      *
135      * [IMPORTANT]
136      * ====
137      * You shouldn't rely on `isContract` to protect against flash loan attacks!
138      *
139      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
140      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
141      * constructor.
142      * ====
143      */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies on extcodesize/address.code.length, which returns 0
146         // for contracts in construction, since the code is only stored at the end
147         // of the constructor execution.
148 
149         return account.code.length > 0;
150     }
151 
152     /**
153      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
154      * `recipient`, forwarding all available gas and reverting on errors.
155      *
156      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
157      * of certain opcodes, possibly making contracts go over the 2300 gas limit
158      * imposed by `transfer`, making them unable to receive funds via
159      * `transfer`. {sendValue} removes this limitation.
160      *
161      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
162      *
163      * IMPORTANT: because control is transferred to `recipient`, care must be
164      * taken to not create reentrancy vulnerabilities. Consider using
165      * {ReentrancyGuard} or the
166      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
167      */
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(address(this).balance >= amount, "Address: insufficient balance");
170 
171         (bool success, ) = recipient.call{value: amount}("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 
175     /**
176      * @dev Performs a Solidity function call using a low level `call`. A
177      * plain `call` is an unsafe replacement for a function call: use this
178      * function instead.
179      *
180      * If `target` reverts with a revert reason, it is bubbled up by this
181      * function (like regular Solidity function calls).
182      *
183      * Returns the raw returned data. To convert to the expected return value,
184      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
185      *
186      * Requirements:
187      *
188      * - `target` must be a contract.
189      * - calling `target` with `data` must not revert.
190      *
191      * _Available since v3.1._
192      */
193     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionCall(target, data, "Address: low-level call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
199      * `errorMessage` as a fallback revert reason when `target` reverts.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, 0, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but also transferring `value` wei to `target`.
214      *
215      * Requirements:
216      *
217      * - the calling contract must have an ETH balance of at least `value`.
218      * - the called Solidity function must be `payable`.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value
226     ) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
232      * with `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCallWithValue(
237         address target,
238         bytes memory data,
239         uint256 value,
240         string memory errorMessage
241     ) internal returns (bytes memory) {
242         require(address(this).balance >= value, "Address: insufficient balance for call");
243         require(isContract(target), "Address: call to non-contract");
244 
245         (bool success, bytes memory returndata) = target.call{value: value}(data);
246         return verifyCallResult(success, returndata, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but performing a static call.
252      *
253      * _Available since v3.3._
254      */
255     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
256         return functionStaticCall(target, data, "Address: low-level static call failed");
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(
266         address target,
267         bytes memory data,
268         string memory errorMessage
269     ) internal view returns (bytes memory) {
270         require(isContract(target), "Address: static call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.staticcall(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a delegate call.
279      *
280      * _Available since v3.4._
281      */
282     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
283         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(isContract(target), "Address: delegate call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.delegatecall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
305      * revert reason using the provided one.
306      *
307      * _Available since v4.3._
308      */
309     function verifyCallResult(
310         bool success,
311         bytes memory returndata,
312         string memory errorMessage
313     ) internal pure returns (bytes memory) {
314         if (success) {
315             return returndata;
316         } else {
317             // Look for revert reason and bubble it up if present
318             if (returndata.length > 0) {
319                 // The easiest way to bubble the revert reason is using memory via assembly
320 
321                 assembly {
322                     let returndata_size := mload(returndata)
323                     revert(add(32, returndata), returndata_size)
324                 }
325             } else {
326                 revert(errorMessage);
327             }
328         }
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
333 
334 
335 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @title ERC721 token receiver interface
341  * @dev Interface for any contract that wants to support safeTransfers
342  * from ERC721 asset contracts.
343  */
344 interface IERC721Receiver {
345     /**
346      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
347      * by `operator` from `from`, this function is called.
348      *
349      * It must return its Solidity selector to confirm the token transfer.
350      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
351      *
352      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
353      */
354     function onERC721Received(
355         address operator,
356         address from,
357         uint256 tokenId,
358         bytes calldata data
359     ) external returns (bytes4);
360 }
361 
362 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Interface of the ERC165 standard, as defined in the
371  * https://eips.ethereum.org/EIPS/eip-165[EIP].
372  *
373  * Implementers can declare support of contract interfaces, which can then be
374  * queried by others ({ERC165Checker}).
375  *
376  * For an implementation, see {ERC165}.
377  */
378 interface IERC165 {
379     /**
380      * @dev Returns true if this contract implements the interface defined by
381      * `interfaceId`. See the corresponding
382      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
383      * to learn more about how these ids are created.
384      *
385      * This function call must use less than 30 000 gas.
386      */
387     function supportsInterface(bytes4 interfaceId) external view returns (bool);
388 }
389 
390 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 
398 /**
399  * @dev Implementation of the {IERC165} interface.
400  *
401  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
402  * for the additional interface id that will be supported. For example:
403  *
404  * ```solidity
405  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
406  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
407  * }
408  * ```
409  *
410  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
411  */
412 abstract contract ERC165 is IERC165 {
413     /**
414      * @dev See {IERC165-supportsInterface}.
415      */
416     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
417         return interfaceId == type(IERC165).interfaceId;
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Required interface of an ERC721 compliant contract.
431  */
432 interface IERC721 is IERC165 {
433     /**
434      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
440      */
441     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
442 
443     /**
444      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
447 
448     /**
449      * @dev Returns the number of tokens in ``owner``'s account.
450      */
451     function balanceOf(address owner) external view returns (uint256 balance);
452 
453     /**
454      * @dev Returns the owner of the `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`.
464      *
465      * Requirements:
466      *
467      * - `from` cannot be the zero address.
468      * - `to` cannot be the zero address.
469      * - `tokenId` token must exist and be owned by `from`.
470      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
471      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
472      *
473      * Emits a {Transfer} event.
474      */
475     function safeTransferFrom(
476         address from,
477         address to,
478         uint256 tokenId,
479         bytes calldata data
480     ) external;
481 
482     /**
483      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
484      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Transfers `tokenId` token from `from` to `to`.
504      *
505      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      *
514      * Emits a {Transfer} event.
515      */
516     function transferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
524      * The approval is cleared when the token is transferred.
525      *
526      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
527      *
528      * Requirements:
529      *
530      * - The caller must own the token or be an approved operator.
531      * - `tokenId` must exist.
532      *
533      * Emits an {Approval} event.
534      */
535     function approve(address to, uint256 tokenId) external;
536 
537     /**
538      * @dev Approve or remove `operator` as an operator for the caller.
539      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
540      *
541      * Requirements:
542      *
543      * - The `operator` cannot be the caller.
544      *
545      * Emits an {ApprovalForAll} event.
546      */
547     function setApprovalForAll(address operator, bool _approved) external;
548 
549     /**
550      * @dev Returns the account approved for `tokenId` token.
551      *
552      * Requirements:
553      *
554      * - `tokenId` must exist.
555      */
556     function getApproved(uint256 tokenId) external view returns (address operator);
557 
558     /**
559      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
560      *
561      * See {setApprovalForAll}
562      */
563     function isApprovedForAll(address owner, address operator) external view returns (bool);
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Enumerable is IERC721 {
579     /**
580      * @dev Returns the total amount of tokens stored by the contract.
581      */
582     function totalSupply() external view returns (uint256);
583 
584     /**
585      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
586      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
587      */
588     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
589 
590     /**
591      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
592      * Use along with {totalSupply} to enumerate all tokens.
593      */
594     function tokenByIndex(uint256 index) external view returns (uint256);
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 // File: ERC721A.sol
627 
628 
629 // Creator: Chiru Labs
630 
631 pragma solidity ^0.8.0;
632 
633 
634 
635 
636 
637 
638 
639 
640 
641 /**
642  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
643  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
644  *
645  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
646  *
647  * Does not support burning tokens to address(0).
648  *
649  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
650  */
651 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
652     using Address for address;
653     using Strings for uint256;
654 
655     struct TokenOwnership {
656         address addr;
657         uint64 startTimestamp;
658     }
659 
660     struct AddressData {
661         uint128 balance;
662         uint128 numberMinted;
663     }
664 
665     uint256 internal currentIndex;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to ownership details
674     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
675     mapping(uint256 => TokenOwnership) internal _ownerships;
676 
677     // Mapping owner address to address data
678     mapping(address => AddressData) private _addressData;
679 
680     // Mapping from token ID to approved address
681     mapping(uint256 => address) private _tokenApprovals;
682 
683     // Mapping from owner to operator approvals
684     mapping(address => mapping(address => bool)) private _operatorApprovals;
685 
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689     }
690 
691     /**
692      * @dev See {IERC721Enumerable-totalSupply}.
693      */
694     function totalSupply() public view override returns (uint256) {
695         return currentIndex;
696     }
697 
698     /**
699      * @dev See {IERC721Enumerable-tokenByIndex}.
700      */
701     function tokenByIndex(uint256 index) public view override returns (uint256) {
702         require(index < totalSupply(), 'ERC721A: global index out of bounds');
703         return index;
704     }
705 
706     /**
707      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
708      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
709      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
710      */
711     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
712         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
713         uint256 numMintedSoFar = totalSupply();
714         uint256 tokenIdsIdx;
715         address currOwnershipAddr;
716 
717         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
718         unchecked {
719             for (uint256 i; i < numMintedSoFar; i++) {
720                 TokenOwnership memory ownership = _ownerships[i];
721                 if (ownership.addr != address(0)) {
722                     currOwnershipAddr = ownership.addr;
723                 }
724                 if (currOwnershipAddr == owner) {
725                     if (tokenIdsIdx == index) {
726                         return i;
727                     }
728                     tokenIdsIdx++;
729                 }
730             }
731         }
732 
733         revert('ERC721A: unable to get token of owner by index');
734     }
735 
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
740         return
741             interfaceId == type(IERC721).interfaceId ||
742             interfaceId == type(IERC721Metadata).interfaceId ||
743             interfaceId == type(IERC721Enumerable).interfaceId ||
744             super.supportsInterface(interfaceId);
745     }
746 
747     /**
748      * @dev See {IERC721-balanceOf}.
749      */
750     function balanceOf(address owner) public view override returns (uint256) {
751         require(owner != address(0), 'ERC721A: balance query for the zero address');
752         return uint256(_addressData[owner].balance);
753     }
754 
755     function _numberMinted(address owner) internal view returns (uint256) {
756         require(owner != address(0), 'ERC721A: number minted query for the zero address');
757         return uint256(_addressData[owner].numberMinted);
758     }
759 
760     /**
761      * Gas spent here starts off proportional to the maximum mint batch size.
762      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
763      */
764     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
765         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
766 
767         unchecked {
768             for (uint256 curr = tokenId; curr >= 0; curr--) {
769                 TokenOwnership memory ownership = _ownerships[curr];
770                 if (ownership.addr != address(0)) {
771                     return ownership;
772                 }
773             }
774         }
775 
776         revert('ERC721A: unable to determine the owner of token');
777     }
778 
779     /**
780      * @dev See {IERC721-ownerOf}.
781      */
782     function ownerOf(uint256 tokenId) public view override returns (address) {
783         return ownershipOf(tokenId).addr;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-name}.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-symbol}.
795      */
796     function symbol() public view virtual override returns (string memory) {
797         return _symbol;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-tokenURI}.
802      */
803     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
804         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
805 
806         string memory baseURI = _baseURI();
807         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
808     }
809 
810     /**
811      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
812      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
813      * by default, can be overriden in child contracts.
814      */
815     function _baseURI() internal view virtual returns (string memory) {
816         return '';
817     }
818 
819     /**
820      * @dev See {IERC721-approve}.
821      */
822     function approve(address to, uint256 tokenId) public override {
823         address owner = ERC721A.ownerOf(tokenId);
824         require(to != owner, 'ERC721A: approval to current owner');
825 
826         require(
827             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
828             'ERC721A: approve caller is not owner nor approved for all'
829         );
830 
831         _approve(to, tokenId, owner);
832     }
833 
834     /**
835      * @dev See {IERC721-getApproved}.
836      */
837     function getApproved(uint256 tokenId) public view override returns (address) {
838         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
839 
840         return _tokenApprovals[tokenId];
841     }
842 
843     /**
844      * @dev See {IERC721-setApprovalForAll}.
845      */
846     function setApprovalForAll(address operator, bool approved) public override {
847         require(operator != _msgSender(), 'ERC721A: approve to caller');
848 
849         _operatorApprovals[_msgSender()][operator] = approved;
850         emit ApprovalForAll(_msgSender(), operator, approved);
851     }
852 
853     /**
854      * @dev See {IERC721-isApprovedForAll}.
855      */
856     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
857         return _operatorApprovals[owner][operator];
858     }
859 
860     /**
861      * @dev See {IERC721-transferFrom}.
862      */
863     function transferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public override {
868         _transfer(from, to, tokenId);
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public override {
879         safeTransferFrom(from, to, tokenId, '');
880     }
881 
882     /**
883      * @dev See {IERC721-safeTransferFrom}.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) public override {
891         _transfer(from, to, tokenId);
892         require(
893             _checkOnERC721Received(from, to, tokenId, _data),
894             'ERC721A: transfer to non ERC721Receiver implementer'
895         );
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted (`_mint`),
904      */
905     function _exists(uint256 tokenId) internal view returns (bool) {
906         return tokenId < currentIndex;
907     }
908 
909     function _safeMint(address to, uint256 quantity) internal {
910         _safeMint(to, quantity, '');
911     }
912 
913     /**
914      * @dev Safely mints `quantity` tokens and transfers them to `to`.
915      *
916      * Requirements:
917      *
918      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
919      * - `quantity` must be greater than 0.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeMint(
924         address to,
925         uint256 quantity,
926         bytes memory _data
927     ) internal {
928         _mint(to, quantity, _data, true);
929     }
930 
931     /**
932      * @dev Mints `quantity` tokens and transfers them to `to`.
933      *
934      * Requirements:
935      *
936      * - `to` cannot be the zero address.
937      * - `quantity` must be greater than 0.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _mint(
942         address to,
943         uint256 quantity,
944         bytes memory _data,
945         bool safe
946     ) internal {
947         uint256 startTokenId = currentIndex;
948         require(to != address(0), 'ERC721A: mint to the zero address');
949         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
950 
951         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
952 
953         // Overflows are incredibly unrealistic.
954         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
955         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
956         unchecked {
957             _addressData[to].balance += uint128(quantity);
958             _addressData[to].numberMinted += uint128(quantity);
959 
960             _ownerships[startTokenId].addr = to;
961             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
962 
963             uint256 updatedIndex = startTokenId;
964 
965             for (uint256 i; i < quantity; i++) {
966                 emit Transfer(address(0), to, updatedIndex);
967                 if (safe) {
968                     require(
969                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
970                         'ERC721A: transfer to non ERC721Receiver implementer'
971                     );
972                 }
973 
974                 updatedIndex++;
975             }
976 
977             currentIndex = updatedIndex;
978         }
979 
980         _afterTokenTransfers(address(0), to, startTokenId, quantity);
981     }
982 
983     /**
984      * @dev Transfers `tokenId` from `from` to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) private {
998         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
999 
1000         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1001             getApproved(tokenId) == _msgSender() ||
1002             isApprovedForAll(prevOwnership.addr, _msgSender()));
1003 
1004         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1005 
1006         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1007         require(to != address(0), 'ERC721A: transfer to the zero address');
1008 
1009         _beforeTokenTransfers(from, to, tokenId, 1);
1010 
1011         // Clear approvals from the previous owner
1012         _approve(address(0), tokenId, prevOwnership.addr);
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017         unchecked {
1018             _addressData[from].balance -= 1;
1019             _addressData[to].balance += 1;
1020 
1021             _ownerships[tokenId].addr = to;
1022             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1023 
1024             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1025             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1026             uint256 nextTokenId = tokenId + 1;
1027             if (_ownerships[nextTokenId].addr == address(0)) {
1028                 if (_exists(nextTokenId)) {
1029                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1030                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1031                 }
1032             }
1033         }
1034 
1035         emit Transfer(from, to, tokenId);
1036         _afterTokenTransfers(from, to, tokenId, 1);
1037     }
1038 
1039     /**
1040      * @dev Approve `to` to operate on `tokenId`
1041      *
1042      * Emits a {Approval} event.
1043      */
1044     function _approve(
1045         address to,
1046         uint256 tokenId,
1047         address owner
1048     ) private {
1049         _tokenApprovals[tokenId] = to;
1050         emit Approval(owner, to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1055      * The call is not executed if the target address is not a contract.
1056      *
1057      * @param from address representing the previous owner of the given token ID
1058      * @param to target address that will receive the tokens
1059      * @param tokenId uint256 ID of the token to be transferred
1060      * @param _data bytes optional data to send along with the call
1061      * @return bool whether the call correctly returned the expected magic value
1062      */
1063     function _checkOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         if (to.isContract()) {
1070             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1071                 return retval == IERC721Receiver(to).onERC721Received.selector;
1072             } catch (bytes memory reason) {
1073                 if (reason.length == 0) {
1074                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1075                 } else {
1076                     assembly {
1077                         revert(add(32, reason), mload(reason))
1078                     }
1079                 }
1080             }
1081         } else {
1082             return true;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1088      *
1089      * startTokenId - the first token id to be transferred
1090      * quantity - the amount to be transferred
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      */
1098     function _beforeTokenTransfers(
1099         address from,
1100         address to,
1101         uint256 startTokenId,
1102         uint256 quantity
1103     ) internal virtual {}
1104 
1105     /**
1106      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1107      * minting.
1108      *
1109      * startTokenId - the first token id to be transferred
1110      * quantity - the amount to be transferred
1111      *
1112      * Calling conditions:
1113      *
1114      * - when `from` and `to` are both non-zero.
1115      * - `from` and `to` are never both zero.
1116      */
1117     function _afterTokenTransfers(
1118         address from,
1119         address to,
1120         uint256 startTokenId,
1121         uint256 quantity
1122     ) internal virtual {}
1123 }
1124 // File: goblintownai-contract.sol
1125 
1126 
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 /**
1131  * @dev Contract module which allows children to implement an emergency stop
1132  * mechanism that can be triggered by an authorized account.
1133  *
1134  * This module is used through inheritance. It will make available the
1135  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1136  * the functions of your contract. Note that they will not be pausable by
1137  * simply including this module, only once the modifiers are put in place.
1138  */
1139 abstract contract Pausable is Context {
1140     /**
1141      * @dev Emitted when the pause is triggered by `account`.
1142      */
1143     event Paused(address account);
1144 
1145     /**
1146      * @dev Emitted when the pause is lifted by `account`.
1147      */
1148     event Unpaused(address account);
1149 
1150     bool private _paused;
1151 
1152     /**
1153      * @dev Initializes the contract in unpaused state.
1154      */
1155     constructor() {
1156         _paused = false;
1157     }
1158 
1159     /**
1160      * @dev Returns true if the contract is paused, and false otherwise.
1161      */
1162     function paused() public view virtual returns (bool) {
1163         return _paused;
1164     }
1165 
1166     /**
1167      * @dev Modifier to make a function callable only when the contract is not paused.
1168      *
1169      * Requirements:
1170      *
1171      * - The contract must not be paused.
1172      */
1173     modifier whenNotPaused() {
1174         require(!paused(), "Pausable: paused");
1175         _;
1176     }
1177 
1178     /**
1179      * @dev Modifier to make a function callable only when the contract is paused.
1180      *
1181      * Requirements:
1182      *
1183      * - The contract must be paused.
1184      */
1185     modifier whenPaused() {
1186         require(paused(), "Pausable: not paused");
1187         _;
1188     }
1189 
1190     /**
1191      * @dev Triggers stopped state.
1192      *
1193      * Requirements:
1194      *
1195      * - The contract must not be paused.
1196      */
1197     function _pause() internal virtual whenNotPaused {
1198         _paused = true;
1199         emit Paused(_msgSender());
1200     }
1201 
1202     /**
1203      * @dev Returns to normal state.
1204      *
1205      * Requirements:
1206      *
1207      * - The contract must be paused.
1208      */
1209     function _unpause() internal virtual whenPaused {
1210         _paused = false;
1211         emit Unpaused(_msgSender());
1212     }
1213 }
1214 
1215 // Ownable.sol
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 /**
1220  * @dev Contract module which provides a basic access control mechanism, where
1221  * there is an account (an owner) that can be granted exclusive access to
1222  * specific functions.
1223  *
1224  * By default, the owner account will be the one that deploys the contract. This
1225  * can later be changed with {transferOwnership}.
1226  *
1227  * This module is used through inheritance. It will make available the modifier
1228  * `onlyOwner`, which can be applied to your functions to restrict their use to
1229  * the owner.
1230  */
1231 abstract contract Ownable is Context {
1232     address private _owner;
1233 
1234     event OwnershipTransferred(
1235         address indexed previousOwner,
1236         address indexed newOwner
1237     );
1238 
1239     /**
1240      * @dev Initializes the contract setting the deployer as the initial owner.
1241      */
1242     constructor() {
1243         _setOwner(_msgSender());
1244     }
1245 
1246     /**
1247      * @dev Returns the address of the current owner.
1248      */
1249     function owner() public view virtual returns (address) {
1250         return _owner;
1251     }
1252 
1253     /**
1254      * @dev Throws if called by any account other than the owner.
1255      */
1256     modifier onlyOwner() {
1257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1258         _;
1259     }
1260 
1261     /**
1262      * @dev Leaves the contract without owner. It will not be possible to call
1263      * `onlyOwner` functions anymore. Can only be called by the current owner.
1264      *
1265      * NOTE: Renouncing ownership will leave the contract without an owner,
1266      * thereby removing any functionality that is only available to the owner.
1267      */
1268     function renounceOwnership() public virtual onlyOwner {
1269         _setOwner(address(0));
1270     }
1271 
1272     /**
1273      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1274      * Can only be called by the current owner.
1275      */
1276     function transferOwnership(address newOwner) public virtual onlyOwner {
1277         require(
1278             newOwner != address(0),
1279             "Ownable: new owner is the zero address"
1280         );
1281         _setOwner(newOwner);
1282     }
1283 
1284     function _setOwner(address newOwner) private {
1285         address oldOwner = _owner;
1286         _owner = newOwner;
1287         emit OwnershipTransferred(oldOwner, newOwner);
1288     }
1289 }
1290 
1291 pragma solidity ^0.8.0;
1292 
1293 /**
1294  * @dev Contract module that helps prevent reentrant calls to a function.
1295  *
1296  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1297  * available, which can be applied to functions to make sure there are no nested
1298  * (reentrant) calls to them.
1299  *
1300  * Note that because there is a single `nonReentrant` guard, functions marked as
1301  * `nonReentrant` may not call one another. This can be worked around by making
1302  * those functions `private`, and then adding `external` `nonReentrant` entry
1303  * points to them.
1304  *
1305  * TIP: If you would like to learn more about reentrancy and alternative ways
1306  * to protect against it, check out our blog post
1307  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1308  */
1309 abstract contract ReentrancyGuard {
1310     // Booleans are more expensive than uint256 or any type that takes up a full
1311     // word because each write operation emits an extra SLOAD to first read the
1312     // slot's contents, replace the bits taken up by the boolean, and then write
1313     // back. This is the compiler's defense against contract upgrades and
1314     // pointer aliasing, and it cannot be disabled.
1315 
1316     // The values being non-zero value makes deployment a bit more expensive,
1317     // but in exchange the refund on every call to nonReentrant will be lower in
1318     // amount. Since refunds are capped to a percentage of the total
1319     // transaction's gas, it is best to keep them low in cases like this one, to
1320     // increase the likelihood of the full refund coming into effect.
1321     uint256 private constant _NOT_ENTERED = 1;
1322     uint256 private constant _ENTERED = 2;
1323 
1324     uint256 private _status;
1325 
1326     constructor() {
1327         _status = _NOT_ENTERED;
1328     }
1329 
1330     /**
1331      * @dev Prevents a contract from calling itself, directly or indirectly.
1332      * Calling a `nonReentrant` function from another `nonReentrant`
1333      * function is not supported. It is possible to prevent this from happening
1334      * by making the `nonReentrant` function external, and make it call a
1335      * `private` function that does the actual work.
1336      */
1337     modifier nonReentrant() {
1338         // On the first call to nonReentrant, _notEntered will be true
1339         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1340 
1341         // Any calls to nonReentrant after this point will fail
1342         _status = _ENTERED;
1343 
1344         _;
1345 
1346         // By storing the original value once again, a refund is triggered (see
1347         // https://eips.ethereum.org/EIPS/eip-2200)
1348         _status = _NOT_ENTERED;
1349     }
1350 }
1351 
1352 //newerc.sol
1353 pragma solidity ^0.8.0;
1354 
1355 
1356 contract BabyPosers is ERC721A, Ownable, Pausable, ReentrancyGuard {
1357     using Strings for uint256;
1358     string public baseURI;
1359     uint256 public cost = 0.002 ether;
1360     uint256 public maxSupply = 5000;
1361     uint256 public maxFree = 5000;
1362     uint256 public maxperAddressFreeLimit = 1;
1363     uint256 public maxperAddressPublicMint = 10;
1364     uint256 public maxperWallet = 20;
1365     bool public revealed = false;
1366     string public hiddenMetadataUri;
1367 
1368     mapping(address => uint256) public addressFreeMintedBalance;
1369 
1370     constructor() ERC721A("Baby Posers", "bp") {
1371         setBaseURI("");
1372 
1373     }
1374 
1375     function _baseURI() internal view virtual override returns (string memory) {
1376         return baseURI;
1377     }
1378 
1379     function mintFree(uint256 _mintAmount) public payable nonReentrant{
1380 		uint256 s = totalSupply();
1381         uint256 addressFreeMintedCount = addressFreeMintedBalance[msg.sender];
1382         require(addressFreeMintedCount + _mintAmount <= maxperAddressFreeLimit, "max NFT per address exceeded!");
1383         require(balanceOf(msg.sender) <= 20, "Max per wallet reached!");
1384         require(balanceOf(msg.sender) + _mintAmount <= 20, "Max per wallet reached!");
1385 		require(_mintAmount > 0, "Cant mint 0" );
1386 		require(s + _mintAmount <= maxFree, "Cant go over supply!" );
1387 		for (uint256 i = 0; i < _mintAmount; ++i) {
1388             addressFreeMintedBalance[msg.sender]++;
1389 
1390 		}
1391         _safeMint(msg.sender, _mintAmount);
1392 		delete s;
1393         delete addressFreeMintedCount;
1394 	}
1395 
1396 
1397     function mint(uint256 _mintAmount) public payable nonReentrant {
1398         uint256 s = totalSupply();
1399         require(_mintAmount > 0, "Cant mint 0");
1400         require(_mintAmount <= maxperAddressPublicMint, "Cant mint more then maxmint" );
1401         require(balanceOf(msg.sender) <= 20, "Max per wallet reached!");
1402         require(balanceOf(msg.sender) + _mintAmount <= 20, "Max per wallet reached!");
1403         require(s + _mintAmount <= maxSupply, "Cant go over supply");
1404         require(msg.value >= cost * _mintAmount);
1405         _safeMint(msg.sender, _mintAmount);
1406         delete s;
1407     }
1408 
1409     function mintTeam(uint256[] calldata quantity, address[] calldata recipient)
1410         external
1411         onlyOwner
1412     {
1413         require(
1414             quantity.length == recipient.length,
1415             "Provide quantities and recipients"
1416         );
1417         uint256 totalQuantity = 0;
1418         uint256 s = totalSupply();
1419         for (uint256 i = 0; i < quantity.length; ++i) {
1420             totalQuantity += quantity[i];
1421         }
1422         require(s + totalQuantity <= maxSupply, "Too many");
1423         delete totalQuantity;
1424         for (uint256 i = 0; i < recipient.length; ++i) {
1425             _safeMint(recipient[i], quantity[i]);
1426         }
1427         delete s;
1428     }
1429 
1430     function tokenURI(uint256 tokenId)
1431         public
1432         view
1433         virtual
1434         override
1435         returns (string memory)
1436     {
1437         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1438 
1439         if (revealed == false) {
1440             return hiddenMetadataUri;
1441         }
1442 
1443         
1444         string memory currentBaseURI = _baseURI();
1445         return
1446             bytes(currentBaseURI).length > 0
1447                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
1448                 : "";
1449     }
1450 
1451     function setCost(uint256 _newCost) public onlyOwner {
1452         cost = _newCost;
1453     }
1454 
1455     function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1456         require(_newMaxSupply <= maxSupply, "Cannot increase max supply");
1457         maxSupply = _newMaxSupply;
1458     }
1459      function setmaxFreeSupply(uint256 _newMaxFreeSupply) public onlyOwner {
1460                maxFree = _newMaxFreeSupply;
1461     }
1462 
1463     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1464         baseURI = _newBaseURI;
1465     }
1466 
1467     function setRevealed(bool _state) public onlyOwner {
1468         revealed = _state;
1469     }
1470 
1471     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1472         hiddenMetadataUri = _hiddenMetadataUri;
1473     }
1474 
1475     function setMaxperAddressPublicMint(uint256 _amount) public onlyOwner {
1476         maxperAddressPublicMint = _amount;
1477     }
1478 
1479     function setMaxperAddressFreeMint(uint256 _amount) public onlyOwner{
1480         maxperAddressFreeLimit = _amount;
1481     }
1482 
1483     function withdraw() public payable onlyOwner {
1484 
1485         (bool os, ) = payable(msg.sender).call{value: address(this).balance}('');
1486         require(os);
1487  
1488     }
1489 }