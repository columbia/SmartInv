1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/utils/Address.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Collection of functions related to the address type
107  */
108 library Address {
109     /**
110      * @dev Returns true if `account` is a contract.
111      *
112      * [IMPORTANT]
113      * ====
114      * It is unsafe to assume that an address for which this function returns
115      * false is an externally-owned account (EOA) and not a contract.
116      *
117      * Among others, `isContract` will return false for the following
118      * types of addresses:
119      *
120      *  - an externally-owned account
121      *  - a contract in construction
122      *  - an address where a contract will be created
123      *  - an address where a contract lived, but was destroyed
124      * ====
125      */
126     function isContract(address account) internal view returns (bool) {
127         // This method relies on extcodesize, which returns 0 for contracts in
128         // construction, since the code is only stored at the end of the
129         // constructor execution.
130 
131         uint256 size;
132         assembly {
133             size := extcodesize(account)
134         }
135         return size > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         (bool success, ) = recipient.call{value: amount}("");
158         require(success, "Address: unable to send value, recipient may have reverted");
159     }
160 
161     /**
162      * @dev Performs a Solidity function call using a low level `call`. A
163      * plain `call` is an unsafe replacement for a function call: use this
164      * function instead.
165      *
166      * If `target` reverts with a revert reason, it is bubbled up by this
167      * function (like regular Solidity function calls).
168      *
169      * Returns the raw returned data. To convert to the expected return value,
170      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
171      *
172      * Requirements:
173      *
174      * - `target` must be a contract.
175      * - calling `target` with `data` must not revert.
176      *
177      * _Available since v3.1._
178      */
179     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionCall(target, data, "Address: low-level call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
185      * `errorMessage` as a fallback revert reason when `target` reverts.
186      *
187      * _Available since v3.1._
188      */
189     function functionCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         return functionCallWithValue(target, data, 0, errorMessage);
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
199      * but also transferring `value` wei to `target`.
200      *
201      * Requirements:
202      *
203      * - the calling contract must have an ETH balance of at least `value`.
204      * - the called Solidity function must be `payable`.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value
212     ) internal returns (bytes memory) {
213         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
218      * with `errorMessage` as a fallback revert reason when `target` reverts.
219      *
220      * _Available since v3.1._
221      */
222     function functionCallWithValue(
223         address target,
224         bytes memory data,
225         uint256 value,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         require(address(this).balance >= value, "Address: insufficient balance for call");
229         require(isContract(target), "Address: call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.call{value: value}(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a static call.
238      *
239      * _Available since v3.3._
240      */
241     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
242         return functionStaticCall(target, data, "Address: low-level static call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a delegate call.
275      *
276      * _Available since v3.4._
277      */
278     function functionDelegateCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         require(isContract(target), "Address: delegate call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.delegatecall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
291      * revert reason using the provided one.
292      *
293      * _Available since v4.3._
294      */
295     function verifyCallResult(
296         bool success,
297         bytes memory returndata,
298         string memory errorMessage
299     ) internal pure returns (bytes memory) {
300         if (success) {
301             return returndata;
302         } else {
303             // Look for revert reason and bubble it up if present
304             if (returndata.length > 0) {
305                 // The easiest way to bubble the revert reason is using memory via assembly
306 
307                 assembly {
308                     let returndata_size := mload(returndata)
309                     revert(add(32, returndata), returndata_size)
310                 }
311             } else {
312                 revert(errorMessage);
313             }
314         }
315     }
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @title ERC721 token receiver interface
327  * @dev Interface for any contract that wants to support safeTransfers
328  * from ERC721 asset contracts.
329  */
330 interface IERC721Receiver {
331     /**
332      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
333      * by `operator` from `from`, this function is called.
334      *
335      * It must return its Solidity selector to confirm the token transfer.
336      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
337      *
338      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
339      */
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
349 
350 
351 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Interface of the ERC165 standard, as defined in the
357  * https://eips.ethereum.org/EIPS/eip-165[EIP].
358  *
359  * Implementers can declare support of contract interfaces, which can then be
360  * queried by others ({ERC165Checker}).
361  *
362  * For an implementation, see {ERC165}.
363  */
364 interface IERC165 {
365     /**
366      * @dev Returns true if this contract implements the interface defined by
367      * `interfaceId`. See the corresponding
368      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
369      * to learn more about how these ids are created.
370      *
371      * This function call must use less than 30 000 gas.
372      */
373     function supportsInterface(bytes4 interfaceId) external view returns (bool);
374 }
375 
376 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 
384 /**
385  * @dev Implementation of the {IERC165} interface.
386  *
387  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
388  * for the additional interface id that will be supported. For example:
389  *
390  * ```solidity
391  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
393  * }
394  * ```
395  *
396  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
397  */
398 abstract contract ERC165 is IERC165 {
399     /**
400      * @dev See {IERC165-supportsInterface}.
401      */
402     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403         return interfaceId == type(IERC165).interfaceId;
404     }
405 }
406 
407 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Required interface of an ERC721 compliant contract.
417  */
418 interface IERC721 is IERC165 {
419     /**
420      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
423 
424     /**
425      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
426      */
427     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
428 
429     /**
430      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
431      */
432     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
433 
434     /**
435      * @dev Returns the number of tokens in ``owner``'s account.
436      */
437     function balanceOf(address owner) external view returns (uint256 balance);
438 
439     /**
440      * @dev Returns the owner of the `tokenId` token.
441      *
442      * Requirements:
443      *
444      * - `tokenId` must exist.
445      */
446     function ownerOf(uint256 tokenId) external view returns (address owner);
447 
448     /**
449      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
450      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
451      *
452      * Requirements:
453      *
454      * - `from` cannot be the zero address.
455      * - `to` cannot be the zero address.
456      * - `tokenId` token must exist and be owned by `from`.
457      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
458      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId
466     ) external;
467 
468     /**
469      * @dev Transfers `tokenId` token from `from` to `to`.
470      *
471      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
472      *
473      * Requirements:
474      *
475      * - `from` cannot be the zero address.
476      * - `to` cannot be the zero address.
477      * - `tokenId` token must be owned by `from`.
478      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      *
480      * Emits a {Transfer} event.
481      */
482     function transferFrom(
483         address from,
484         address to,
485         uint256 tokenId
486     ) external;
487 
488     /**
489      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
490      * The approval is cleared when the token is transferred.
491      *
492      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
493      *
494      * Requirements:
495      *
496      * - The caller must own the token or be an approved operator.
497      * - `tokenId` must exist.
498      *
499      * Emits an {Approval} event.
500      */
501     function approve(address to, uint256 tokenId) external;
502 
503     /**
504      * @dev Returns the account approved for `tokenId` token.
505      *
506      * Requirements:
507      *
508      * - `tokenId` must exist.
509      */
510     function getApproved(uint256 tokenId) external view returns (address operator);
511 
512     /**
513      * @dev Approve or remove `operator` as an operator for the caller.
514      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
515      *
516      * Requirements:
517      *
518      * - The `operator` cannot be the caller.
519      *
520      * Emits an {ApprovalForAll} event.
521      */
522     function setApprovalForAll(address operator, bool _approved) external;
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`.
533      *
534      * Requirements:
535      *
536      * - `from` cannot be the zero address.
537      * - `to` cannot be the zero address.
538      * - `tokenId` token must exist and be owned by `from`.
539      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
540      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
541      *
542      * Emits a {Transfer} event.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId,
548         bytes calldata data
549     ) external;
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
562  * @dev See https://eips.ethereum.org/EIPS/eip-721
563  */
564 interface IERC721Enumerable is IERC721 {
565     /**
566      * @dev Returns the total amount of tokens stored by the contract.
567      */
568     function totalSupply() external view returns (uint256);
569 
570     /**
571      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
572      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
573      */
574     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
575 
576     /**
577      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
578      * Use along with {totalSupply} to enumerate all tokens.
579      */
580     function tokenByIndex(uint256 index) external view returns (uint256);
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
593  * @dev See https://eips.ethereum.org/EIPS/eip-721
594  */
595 interface IERC721Metadata is IERC721 {
596     /**
597      * @dev Returns the token collection name.
598      */
599     function name() external view returns (string memory);
600 
601     /**
602      * @dev Returns the token collection symbol.
603      */
604     function symbol() external view returns (string memory);
605 
606     /**
607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
608      */
609     function tokenURI(uint256 tokenId) external view returns (string memory);
610 }
611 
612 // File: erc721a/contracts/ERC721A.sol
613 
614 
615 // Creator: Chiru Labs
616 
617 pragma solidity ^0.8.0;
618 
619 
620 
621 
622 
623 
624 
625 
626 
627 /**
628  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
629  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
630  *
631  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
632  *
633  * Does not support burning tokens to address(0).
634  *
635  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
636  */
637 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
638     using Address for address;
639     using Strings for uint256;
640 
641     struct TokenOwnership {
642         address addr;
643         uint64 startTimestamp;
644     }
645 
646     struct AddressData {
647         uint128 balance;
648         uint128 numberMinted;
649     }
650 
651     uint256 internal currentIndex;
652 
653     // Token name
654     string private _name;
655 
656     // Token symbol
657     string private _symbol;
658 
659     // Mapping from token ID to ownership details
660     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
661     mapping(uint256 => TokenOwnership) internal _ownerships;
662 
663     // Mapping owner address to address data
664     mapping(address => AddressData) private _addressData;
665 
666     // Mapping from token ID to approved address
667     mapping(uint256 => address) private _tokenApprovals;
668 
669     // Mapping from owner to operator approvals
670     mapping(address => mapping(address => bool)) private _operatorApprovals;
671 
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675     }
676 
677     /**
678      * @dev See {IERC721Enumerable-totalSupply}.
679      */
680     function totalSupply() public view override returns (uint256) {
681         return currentIndex;
682     }
683 
684     /**
685      * @dev See {IERC721Enumerable-tokenByIndex}.
686      */
687     function tokenByIndex(uint256 index) public view override returns (uint256) {
688         require(index < totalSupply(), 'ERC721A: global index out of bounds');
689         return index;
690     }
691 
692     /**
693      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
694      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
695      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
696      */
697     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
698         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
699         uint256 numMintedSoFar = totalSupply();
700         uint256 tokenIdsIdx;
701         address currOwnershipAddr;
702 
703         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
704         unchecked {
705             for (uint256 i; i < numMintedSoFar; i++) {
706                 TokenOwnership memory ownership = _ownerships[i];
707                 if (ownership.addr != address(0)) {
708                     currOwnershipAddr = ownership.addr;
709                 }
710                 if (currOwnershipAddr == owner) {
711                     if (tokenIdsIdx == index) {
712                         return i;
713                     }
714                     tokenIdsIdx++;
715                 }
716             }
717         }
718 
719         revert('ERC721A: unable to get token of owner by index');
720     }
721 
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
726         return
727             interfaceId == type(IERC721).interfaceId ||
728             interfaceId == type(IERC721Metadata).interfaceId ||
729             interfaceId == type(IERC721Enumerable).interfaceId ||
730             super.supportsInterface(interfaceId);
731     }
732 
733     /**
734      * @dev See {IERC721-balanceOf}.
735      */
736     function balanceOf(address owner) public view override returns (uint256) {
737         require(owner != address(0), 'ERC721A: balance query for the zero address');
738         return uint256(_addressData[owner].balance);
739     }
740 
741     function _numberMinted(address owner) internal view returns (uint256) {
742         require(owner != address(0), 'ERC721A: number minted query for the zero address');
743         return uint256(_addressData[owner].numberMinted);
744     }
745 
746     /**
747      * Gas spent here starts off proportional to the maximum mint batch size.
748      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
749      */
750     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
751         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
752 
753         unchecked {
754             for (uint256 curr = tokenId; curr >= 0; curr--) {
755                 TokenOwnership memory ownership = _ownerships[curr];
756                 if (ownership.addr != address(0)) {
757                     return ownership;
758                 }
759             }
760         }
761 
762         revert('ERC721A: unable to determine the owner of token');
763     }
764 
765     /**
766      * @dev See {IERC721-ownerOf}.
767      */
768     function ownerOf(uint256 tokenId) public view override returns (address) {
769         return ownershipOf(tokenId).addr;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-name}.
774      */
775     function name() public view virtual override returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-symbol}.
781      */
782     function symbol() public view virtual override returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-tokenURI}.
788      */
789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
790         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
791 
792         string memory baseURI = _baseURI();
793         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
794     }
795 
796     /**
797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
799      * by default, can be overriden in child contracts.
800      */
801     function _baseURI() internal view virtual returns (string memory) {
802         return '';
803     }
804 
805     /**
806      * @dev See {IERC721-approve}.
807      */
808     function approve(address to, uint256 tokenId) public override {
809         address owner = ERC721A.ownerOf(tokenId);
810         require(to != owner, 'ERC721A: approval to current owner');
811 
812         require(
813             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
814             'ERC721A: approve caller is not owner nor approved for all'
815         );
816 
817         _approve(to, tokenId, owner);
818     }
819 
820     /**
821      * @dev See {IERC721-getApproved}.
822      */
823     function getApproved(uint256 tokenId) public view override returns (address) {
824         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     /**
830      * @dev See {IERC721-setApprovalForAll}.
831      */
832     function setApprovalForAll(address operator, bool approved) public override {
833         require(operator != _msgSender(), 'ERC721A: approve to caller');
834 
835         _operatorApprovals[_msgSender()][operator] = approved;
836         emit ApprovalForAll(_msgSender(), operator, approved);
837     }
838 
839     /**
840      * @dev See {IERC721-isApprovedForAll}.
841      */
842     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
843         return _operatorApprovals[owner][operator];
844     }
845 
846     /**
847      * @dev See {IERC721-transferFrom}.
848      */
849     function transferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public override {
854         _transfer(from, to, tokenId);
855     }
856 
857     /**
858      * @dev See {IERC721-safeTransferFrom}.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) public override {
865         safeTransferFrom(from, to, tokenId, '');
866     }
867 
868     /**
869      * @dev See {IERC721-safeTransferFrom}.
870      */
871     function safeTransferFrom(
872         address from,
873         address to,
874         uint256 tokenId,
875         bytes memory _data
876     ) public override {
877         _transfer(from, to, tokenId);
878         require(
879             _checkOnERC721Received(from, to, tokenId, _data),
880             'ERC721A: transfer to non ERC721Receiver implementer'
881         );
882     }
883 
884     /**
885      * @dev Returns whether `tokenId` exists.
886      *
887      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
888      *
889      * Tokens start existing when they are minted (`_mint`),
890      */
891     function _exists(uint256 tokenId) internal view returns (bool) {
892         return tokenId < currentIndex;
893     }
894 
895     function _safeMint(address to, uint256 quantity) internal {
896         _safeMint(to, quantity, '');
897     }
898 
899     /**
900      * @dev Safely mints `quantity` tokens and transfers them to `to`.
901      *
902      * Requirements:
903      *
904      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
905      * - `quantity` must be greater than 0.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _safeMint(
910         address to,
911         uint256 quantity,
912         bytes memory _data
913     ) internal {
914         _mint(to, quantity, _data, true);
915     }
916 
917     /**
918      * @dev Mints `quantity` tokens and transfers them to `to`.
919      *
920      * Requirements:
921      *
922      * - `to` cannot be the zero address.
923      * - `quantity` must be greater than 0.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _mint(
928         address to,
929         uint256 quantity,
930         bytes memory _data,
931         bool safe
932     ) internal {
933         uint256 startTokenId = currentIndex;
934         require(to != address(0), 'ERC721A: mint to the zero address');
935         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
936 
937         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
938 
939         // Overflows are incredibly unrealistic.
940         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
941         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
942         unchecked {
943             _addressData[to].balance += uint128(quantity);
944             _addressData[to].numberMinted += uint128(quantity);
945 
946             _ownerships[startTokenId].addr = to;
947             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
948 
949             uint256 updatedIndex = startTokenId;
950 
951             for (uint256 i; i < quantity; i++) {
952                 emit Transfer(address(0), to, updatedIndex);
953                 if (safe) {
954                     require(
955                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
956                         'ERC721A: transfer to non ERC721Receiver implementer'
957                     );
958                 }
959 
960                 updatedIndex++;
961             }
962 
963             currentIndex = updatedIndex;
964         }
965 
966         _afterTokenTransfers(address(0), to, startTokenId, quantity);
967     }
968 
969     /**
970      * @dev Transfers `tokenId` from `from` to `to`.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _transfer(
980         address from,
981         address to,
982         uint256 tokenId
983     ) private {
984         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
985 
986         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
987             getApproved(tokenId) == _msgSender() ||
988             isApprovedForAll(prevOwnership.addr, _msgSender()));
989 
990         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
991 
992         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
993         require(to != address(0), 'ERC721A: transfer to the zero address');
994 
995         _beforeTokenTransfers(from, to, tokenId, 1);
996 
997         // Clear approvals from the previous owner
998         _approve(address(0), tokenId, prevOwnership.addr);
999 
1000         // Underflow of the sender's balance is impossible because we check for
1001         // ownership above and the recipient's balance can't realistically overflow.
1002         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1003         unchecked {
1004             _addressData[from].balance -= 1;
1005             _addressData[to].balance += 1;
1006 
1007             _ownerships[tokenId].addr = to;
1008             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1009 
1010             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1011             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1012             uint256 nextTokenId = tokenId + 1;
1013             if (_ownerships[nextTokenId].addr == address(0)) {
1014                 if (_exists(nextTokenId)) {
1015                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1016                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1017                 }
1018             }
1019         }
1020 
1021         emit Transfer(from, to, tokenId);
1022         _afterTokenTransfers(from, to, tokenId, 1);
1023     }
1024 
1025     /**
1026      * @dev Approve `to` to operate on `tokenId`
1027      *
1028      * Emits a {Approval} event.
1029      */
1030     function _approve(
1031         address to,
1032         uint256 tokenId,
1033         address owner
1034     ) private {
1035         _tokenApprovals[tokenId] = to;
1036         emit Approval(owner, to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1041      * The call is not executed if the target address is not a contract.
1042      *
1043      * @param from address representing the previous owner of the given token ID
1044      * @param to target address that will receive the tokens
1045      * @param tokenId uint256 ID of the token to be transferred
1046      * @param _data bytes optional data to send along with the call
1047      * @return bool whether the call correctly returned the expected magic value
1048      */
1049     function _checkOnERC721Received(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         if (to.isContract()) {
1056             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1057                 return retval == IERC721Receiver(to).onERC721Received.selector;
1058             } catch (bytes memory reason) {
1059                 if (reason.length == 0) {
1060                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1061                 } else {
1062                     assembly {
1063                         revert(add(32, reason), mload(reason))
1064                     }
1065                 }
1066             }
1067         } else {
1068             return true;
1069         }
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1074      *
1075      * startTokenId - the first token id to be transferred
1076      * quantity - the amount to be transferred
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` will be minted for `to`.
1083      */
1084     function _beforeTokenTransfers(
1085         address from,
1086         address to,
1087         uint256 startTokenId,
1088         uint256 quantity
1089     ) internal virtual {}
1090 
1091     /**
1092      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1093      * minting.
1094      *
1095      * startTokenId - the first token id to be transferred
1096      * quantity - the amount to be transferred
1097      *
1098      * Calling conditions:
1099      *
1100      * - when `from` and `to` are both non-zero.
1101      * - `from` and `to` are never both zero.
1102      */
1103     function _afterTokenTransfers(
1104         address from,
1105         address to,
1106         uint256 startTokenId,
1107         uint256 quantity
1108     ) internal virtual {}
1109 }
1110 
1111 // File: contracts/TheBoujeeLeopards.sol
1112 
1113 
1114 
1115 /*
1116 :::::::::::::::::::::::::......................................:::::::::::::::::::::::::::
1117 ::::::::::::::::::::::............................................::::::::::::::::::::::::
1118 :::::::::::::::::::..................................................:::::::::::::::::::::
1119 :::::::::::::::::.......::-=-::-............:::::::..........:.........:::::::::::::::::::
1120 :::::::::::::::........:*#%%%@%@%+-:::-=+#*##*#%%##%%##*+==+%%#%#**-:....:::::::::::::::::
1121 :::::::::::::.........:+#*#####%@@@@@%@%%@@@@@@@@%@@%@@@@@@%%@@@@@*#+.....::::::::::::::::
1122 ::::::::::::..........:+#**++*#%**%@@%@@@@%%@%@@@@@@@@@@@@@@@@@@@%**#:......::::::::::::::
1123 :::::::::::............-%*+++*###%@@@@@@%@@@@@@%@@@@@@@@@@@@@@@@@%*#-........:::::::::::::
1124 ::::::::::.............:+#+*++*@@%%@@@@%##**#%@@@@@@@%@@@@@@@@%%%@=...........::::::::::::
1125 ::::::::::...............+##*%@@@%@@@%**#@@%#**#%@@@@%@@@@@%##%%%%%:...........:::::::::::
1126 :::::::::................:#*@@@@@@@@@*+*****#%#**%@@@@@@@%*#%#****%%............::::::::::
1127 :::::::::................%*%@@@@@@@@%*+#+.AA..-***@@@@@@@**#=.A.-*#@+...........::::::::::
1128 :::::::::-====-.........*###%@@@%@@@@@#*#=::  .-*+%@%**%#*%-=:==*#@@%=...........:::::::::
1129 :::::::=####%@@@%#++:..:@%#%#%%@@%@@@@@%#**++****+#@*+**%**#####%@@@##...........:::::::::
1130 :::::=%@@%%@@@@@@@@##=.+%*#*#@@@@@@@@@@@@@@%%%%%##@#++++*#%%@@%@@@@@%#...........:::::::::
1131 :::+%@@@@@@@@@@#-+@%#*=:::@%*#%@%@@@@@%@@@@@@@@@@@@**+++++*#@@@@@@@##+...........:::::::::
1132 :-%@@@@@@@@@@@@++%%*#*+*-.@%%##**@@@@@@@@@@@@@@@@%*****#####**@@@@@**+...........:::::::::
1133 :%#*#%%%@@@@@@@@@%%*****#=+***##+*%#@@@@@@@@@@%%%**###*+++*%%%%@%#%***...........:::::::::
1134 :##***#@@@@%#*%@%**#***#%*..=#*###@*#@@@@@@%#*+*%%%@@@%*+*%%#*+@#+*+.............:::::::::
1135 ::+#***%@%#-.+%###***###%*...#%@@**##%*%@@@*++++++++**#%%#**+++**-..............::::::::::
1136 ::::=+***=:..-####**###@@@=..:**@@@%%%%%#@%**%@#::+-----.-++***=................::::::::::
1137 :::::::::::...:*#*#@@%@@@@*.-=*%@@@%@@@@@##*+*@*:=--+*****+-%+.................:::::::::::
1138 ::::::::::::....-%@@@@@@@@%*--*#@@@@#**%@@@%%##%#**++*****+#%..................:::::::::::
1139 :::::::::::::...-%@@@@@@@@%+.   .-*%#+++#@#****+++++++*++++#@::::.............::::::::::::
1140 ::::::::::::::..:+@@@@@@@@%*=.. .::.:-=**%@**++*+++++++++*%%%::.-=...........:::::::::::::
1141 :::::::::::::::...%@@@@@@%*+=-:::--.   .:=#@%%%**++++++*#%@@+ .:-=-..........:::::::::::::
1142 ::::::::::::::::.=@@@%*=:..---=--:.. .::.  .=*%%@%###@%%@#=..:::::=-.......:::::::::::::::
1143 ::::::::::::::::-*#+-:.   .......:::::--:-:.  .-+******+:: .:..::-::--:...::::::::::::::::
1144 ::::::::::::::::-:....::.      ..:       .==-.-. .-+**-:=-:-::=-..   .:-::::::::::::::::::
1145 :::::::::::::::=:...  :-:..    :--.      .::.:+....:==:::+..       ..  .--::::::::::::::::
1146 ::::::::::::::=:....      .:.        ...     =-..       .+.       .::..:..=:::::::::::::::
1147 ::::::::::::::=..--:.     .--.      .--.     :+--.     .-*:.      .::..  .:-::::::::::::::
1148 :::::::::::::+......      ....       ..     . =..  ..   .*    ..          .=::::::::::::::
1149 :::::::::::::::::::::::╔══╦╗───╔══╗─────────╔╗────────────╔╦═╗╔═╗───╔╗::::::::::::::::::::
1150 :::::::::::::::::::::::╚╗╔╣╚╦═╗║╔╗╠═╦╦╦╦═╦═╗║║╔═╦═╦═╦═╗╔╦╦╝║═╣║╔╬╗╔╦╣╚╗:::::::::::::::::::
1151 :::::::::::::::::::::::─║║║║║╩╣║╔╗║╬║║╠╣╩╣╩╣║╚╣╩╣╬║╬║╬╚╣╔╣╬╠═║║╚╣╚╣║║╬║:::::::::::::::::::
1152 :::::::::::::::::::::::─╚╝╚╩╩═╝╚══╩═╩╦╝╠═╩═╝╚═╩═╩═╣╔╩══╩╝╚═╩═╝╚═╩═╩═╩═╝:::::::::::::::::::
1153 :::::::::::::::::::::::──────────────╚═╝──────────╚╝────────────────────::::::::::::::::::
1154 */
1155 
1156 // Written by @0xmend
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 contract BoujeeLeopardsClub is ERC721A {
1162 
1163     using Strings for uint256;
1164     uint256 public maxSupply = 6590;
1165     uint256 public presaleCost = 0.07 ether;
1166     uint256 public cost = 0.11 ether;
1167     uint256 public maxMints = 5;
1168     address public constant teamWallet = 0x1a3b0f6eC01e1F943BfaB58E4a7efC5A064487Ca;
1169     address public owner;
1170     mapping(address => uint256) public whitelist;
1171     mapping(address => uint256) minted;
1172     bool public salePaused = true;
1173     bool public preSalePaused = true;
1174     string public contractMetadata;
1175     string public baseTokenURI;
1176     string erm = "Unauthorized";
1177 
1178     constructor(string memory _contractMetadata, string memory _baseTokenURI) ERC721A("BoujeeLeopardsClub", "BLC") {
1179         owner = msg.sender;
1180         contractMetadata = _contractMetadata;
1181         baseTokenURI = _baseTokenURI;
1182     }
1183 
1184     function _mint(address to, uint256 amount) internal {    
1185         _safeMint(to, amount);
1186         minted[to] = minted[to] + amount;
1187     }
1188 
1189     function presaleMint(uint256 quantity) external payable {
1190         uint256 mintCost = presaleCost;
1191         uint256 supply = totalSupply();
1192         require(!preSalePaused, "Presale paused");
1193         require(whitelist[msg.sender] > 0, "Not in whitelist");
1194         require(quantity <= maxMints - minted[msg.sender], "Exceeded max mints per wallet");
1195         require(quantity <= maxMints, "Exceeded max mints");
1196         require(quantity > 0, "Mint atleast 1");
1197         require(supply + quantity <= maxSupply, "Sold out!");
1198         require(msg.value >= mintCost * quantity, "Insufficient funds");
1199         _mint(msg.sender, quantity);
1200     }
1201 
1202     function mint(uint256 quantity) external payable {
1203         uint256 mintCost = cost;
1204         uint256 supply = totalSupply();
1205         if (msg.sender == owner) {
1206             mintCost = 0;
1207         } else {
1208             require(!salePaused, "Sale paused");
1209             require(quantity <= maxMints - minted[msg.sender], "Exceeded max mints per wallet");
1210             require(quantity <= maxMints, "Exceeded max mints");
1211         }
1212         require(quantity > 0, "Mint atleast 1");
1213         require(supply + quantity <= maxSupply, "Sold out!");
1214         require(msg.value >= mintCost * quantity, "Insufficient funds");
1215         _mint(msg.sender, quantity);
1216     }
1217 
1218     function airdrop(address to, uint256 quantity) external {
1219         require(msg.sender == owner, erm);
1220         uint256 supply = totalSupply();
1221         require(supply + quantity <= maxSupply, "Sold out!");
1222         _mint(to, quantity);
1223     }
1224 
1225     function _baseURI() internal view virtual override returns (string memory) {
1226         return baseTokenURI;
1227     }
1228 
1229     function contractURI() public view returns (string memory) {
1230         return contractMetadata;
1231     }
1232 
1233     function setWhitelist(address[] calldata addresses) external{
1234         require(msg.sender == owner);
1235         for (uint256 i = 0; i < addresses.length; i++) {
1236             whitelist[addresses[i]] = maxMints;
1237         }
1238     }
1239 
1240     function setCost(uint256 _newCost) external {
1241         require(msg.sender == owner, erm);
1242         cost = _newCost;
1243     }
1244 
1245     function setPresaleCost(uint256 _newCost) external {
1246         require(msg.sender == owner, erm);
1247         presaleCost = _newCost;
1248     }
1249     
1250     function setBaseTokenUri(string memory _base) external {
1251         require(msg.sender == owner, erm);
1252         baseTokenURI = _base;
1253     }
1254 
1255     function setcontractMeta(string memory _newMeta) external {
1256         require(msg.sender == owner, erm);
1257         contractMetadata = _newMeta;
1258     }
1259 
1260     function pauseSale(bool _state) external {
1261         require(msg.sender == owner, erm);
1262         salePaused = _state;
1263     }
1264 
1265     function pausepreSale(bool _state) external {
1266         require(msg.sender == owner, erm);
1267         preSalePaused = _state;
1268     }
1269 
1270     function withdraw() external {
1271         require(msg.sender == owner, erm);
1272         payable(teamWallet).transfer(address(this).balance);
1273     }
1274 }