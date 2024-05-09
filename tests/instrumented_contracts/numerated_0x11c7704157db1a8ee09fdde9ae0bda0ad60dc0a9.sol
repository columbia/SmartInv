1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 /**
68  * @dev Provides information about the current execution context, including the
69  * sender of the transaction and its data. While these are generally available
70  * via msg.sender and msg.data, they should not be accessed in such a direct
71  * manner, since when dealing with meta-transactions the account sending and
72  * paying for execution may not be the actual sender (as far as an application
73  * is concerned).
74  *
75  * This contract is only required for intermediate, library-like contracts.
76  */
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         return msg.data;
84     }
85 }
86 
87 /**
88  * @dev Collection of functions related to the address type
89  */
90 library Address {
91     /**
92      * @dev Returns true if `account` is a contract.
93      *
94      * [IMPORTANT]
95      * ====
96      * It is unsafe to assume that an address for which this function returns
97      * false is an externally-owned account (EOA) and not a contract.
98      *
99      * Among others, `isContract` will return false for the following
100      * types of addresses:
101      *
102      *  - an externally-owned account
103      *  - a contract in construction
104      *  - an address where a contract will be created
105      *  - an address where a contract lived, but was destroyed
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize, which returns 0 for contracts in
110         // construction, since the code is only stored at the end of the
111         // constructor execution.
112 
113         uint256 size;
114         assembly {
115             size := extcodesize(account)
116         }
117         return size > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         (bool success, ) = recipient.call{value: amount}("");
140         require(success, "Address: unable to send value, recipient may have reverted");
141     }
142 
143     /**
144      * @dev Performs a Solidity function call using a low level `call`. A
145      * plain `call` is an unsafe replacement for a function call: use this
146      * function instead.
147      *
148      * If `target` reverts with a revert reason, it is bubbled up by this
149      * function (like regular Solidity function calls).
150      *
151      * Returns the raw returned data. To convert to the expected return value,
152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
153      *
154      * Requirements:
155      *
156      * - `target` must be a contract.
157      * - calling `target` with `data` must not revert.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionCall(target, data, "Address: low-level call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
167      * `errorMessage` as a fallback revert reason when `target` reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal returns (bytes memory) {
176         return functionCallWithValue(target, data, 0, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but also transferring `value` wei to `target`.
182      *
183      * Requirements:
184      *
185      * - the calling contract must have an ETH balance of at least `value`.
186      * - the called Solidity function must be `payable`.
187      *
188      * _Available since v3.1._
189      */
190     function functionCallWithValue(
191         address target,
192         bytes memory data,
193         uint256 value
194     ) internal returns (bytes memory) {
195         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
200      * with `errorMessage` as a fallback revert reason when `target` reverts.
201      *
202      * _Available since v3.1._
203      */
204     function functionCallWithValue(
205         address target,
206         bytes memory data,
207         uint256 value,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(address(this).balance >= value, "Address: insufficient balance for call");
211         require(isContract(target), "Address: call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.call{value: value}(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
224         return functionStaticCall(target, data, "Address: low-level static call failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
229      * but performing a static call.
230      *
231      * _Available since v3.3._
232      */
233     function functionStaticCall(
234         address target,
235         bytes memory data,
236         string memory errorMessage
237     ) internal view returns (bytes memory) {
238         require(isContract(target), "Address: static call to non-contract");
239 
240         (bool success, bytes memory returndata) = target.staticcall(data);
241         return verifyCallResult(success, returndata, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
251         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
256      * but performing a delegate call.
257      *
258      * _Available since v3.4._
259      */
260     function functionDelegateCall(
261         address target,
262         bytes memory data,
263         string memory errorMessage
264     ) internal returns (bytes memory) {
265         require(isContract(target), "Address: delegate call to non-contract");
266 
267         (bool success, bytes memory returndata) = target.delegatecall(data);
268         return verifyCallResult(success, returndata, errorMessage);
269     }
270 
271     /**
272      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
273      * revert reason using the provided one.
274      *
275      * _Available since v4.3._
276      */
277     function verifyCallResult(
278         bool success,
279         bytes memory returndata,
280         string memory errorMessage
281     ) internal pure returns (bytes memory) {
282         if (success) {
283             return returndata;
284         } else {
285             // Look for revert reason and bubble it up if present
286             if (returndata.length > 0) {
287                 // The easiest way to bubble the revert reason is using memory via assembly
288 
289                 assembly {
290                     let returndata_size := mload(returndata)
291                     revert(add(32, returndata), returndata_size)
292                 }
293             } else {
294                 revert(errorMessage);
295             }
296         }
297     }
298 }
299 
300 /**
301  * @title ERC721 token receiver interface
302  * @dev Interface for any contract that wants to support safeTransfers
303  * from ERC721 asset contracts.
304  */
305 interface IERC721Receiver {
306     /**
307      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
308      * by `operator` from `from`, this function is called.
309      *
310      * It must return its Solidity selector to confirm the token transfer.
311      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
312      *
313      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
314      */
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 /**
324  * @dev Interface of the ERC165 standard, as defined in the
325  * https://eips.ethereum.org/EIPS/eip-165[EIP].
326  *
327  * Implementers can declare support of contract interfaces, which can then be
328  * queried by others ({ERC165Checker}).
329  *
330  * For an implementation, see {ERC165}.
331  */
332 interface IERC165 {
333     /**
334      * @dev Returns true if this contract implements the interface defined by
335      * `interfaceId`. See the corresponding
336      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
337      * to learn more about how these ids are created.
338      *
339      * This function call must use less than 30 000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
342 }
343 
344 /**
345  * @dev Implementation of the {IERC165} interface.
346  *
347  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
348  * for the additional interface id that will be supported. For example:
349  *
350  * ```solidity
351  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
353  * }
354  * ```
355  *
356  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
357  */
358 abstract contract ERC165 is IERC165 {
359     /**
360      * @dev See {IERC165-supportsInterface}.
361      */
362     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
363         return interfaceId == type(IERC165).interfaceId;
364     }
365 }
366 
367 /**
368  * @dev Required interface of an ERC721 compliant contract.
369  */
370 interface IERC721 is IERC165 {
371     /**
372      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
373      */
374     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
375 
376     /**
377      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
378      */
379     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
380 
381     /**
382      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
383      */
384     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
385 
386     /**
387      * @dev Returns the number of tokens in ``owner``'s account.
388      */
389     function balanceOf(address owner) external view returns (uint256 balance);
390 
391     /**
392      * @dev Returns the owner of the `tokenId` token.
393      *
394      * Requirements:
395      *
396      * - `tokenId` must exist.
397      */
398     function ownerOf(uint256 tokenId) external view returns (address owner);
399 
400     /**
401      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
402      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
403      *
404      * Requirements:
405      *
406      * - `from` cannot be the zero address.
407      * - `to` cannot be the zero address.
408      * - `tokenId` token must exist and be owned by `from`.
409      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
410      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
411      *
412      * Emits a {Transfer} event.
413      */
414     function safeTransferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Transfers `tokenId` token from `from` to `to`.
422      *
423      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
424      *
425      * Requirements:
426      *
427      * - `from` cannot be the zero address.
428      * - `to` cannot be the zero address.
429      * - `tokenId` token must be owned by `from`.
430      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 tokenId
438     ) external;
439 
440     /**
441      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
442      * The approval is cleared when the token is transferred.
443      *
444      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
445      *
446      * Requirements:
447      *
448      * - The caller must own the token or be an approved operator.
449      * - `tokenId` must exist.
450      *
451      * Emits an {Approval} event.
452      */
453     function approve(address to, uint256 tokenId) external;
454 
455     /**
456      * @dev Returns the account approved for `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function getApproved(uint256 tokenId) external view returns (address operator);
463 
464     /**
465      * @dev Approve or remove `operator` as an operator for the caller.
466      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
467      *
468      * Requirements:
469      *
470      * - The `operator` cannot be the caller.
471      *
472      * Emits an {ApprovalForAll} event.
473      */
474     function setApprovalForAll(address operator, bool _approved) external;
475 
476     /**
477      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
478      *
479      * See {setApprovalForAll}
480      */
481     function isApprovedForAll(address owner, address operator) external view returns (bool);
482 
483     /**
484      * @dev Safely transfers `tokenId` token from `from` to `to`.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId,
500         bytes calldata data
501     ) external;
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
514  * @dev See https://eips.ethereum.org/EIPS/eip-721
515  */
516 interface IERC721Enumerable is IERC721 {
517     /**
518      * @dev Returns the total amount of tokens stored by the contract.
519      */
520     function totalSupply() external view returns (uint256);
521 
522     /**
523      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
524      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
525      */
526     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
527 
528     /**
529      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
530      * Use along with {totalSupply} to enumerate all tokens.
531      */
532     function tokenByIndex(uint256 index) external view returns (uint256);
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 
543 /**
544  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
545  * @dev See https://eips.ethereum.org/EIPS/eip-721
546  */
547 interface IERC721Metadata is IERC721 {
548     /**
549      * @dev Returns the token collection name.
550      */
551     function name() external view returns (string memory);
552 
553     /**
554      * @dev Returns the token collection symbol.
555      */
556     function symbol() external view returns (string memory);
557 
558     /**
559      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
560      */
561     function tokenURI(uint256 tokenId) external view returns (string memory);
562 }
563 
564 /**
565  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
566  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
567  *
568  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
569  *
570  * Does not support burning tokens to address(0).
571  *
572  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
573  */
574 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
575     using Address for address;
576     using Strings for uint256;
577 
578     struct TokenOwnership {
579         address addr;
580         uint64 startTimestamp;
581     }
582 
583     struct AddressData {
584         uint128 balance;
585         uint128 numberMinted;
586     }
587 
588     uint256 internal currentIndex = 1;
589 
590     // Token name
591     string private _name;
592 
593     // Token symbol
594     string private _symbol;
595 
596     // Mapping from token ID to ownership details
597     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
598     mapping(uint256 => TokenOwnership) internal _ownerships;
599 
600     // Mapping owner address to address data
601     mapping(address => AddressData) private _addressData;
602 
603     // Mapping from token ID to approved address
604     mapping(uint256 => address) private _tokenApprovals;
605 
606     // Mapping from owner to operator approvals
607     mapping(address => mapping(address => bool)) private _operatorApprovals;
608 
609     constructor(string memory name_, string memory symbol_) {
610         _name = name_;
611         _symbol = symbol_;
612     }
613 
614     /**
615      * @dev See {IERC721Enumerable-totalSupply}.
616      */
617     function totalSupply() public view override returns (uint256) {
618         return currentIndex;
619     }
620 
621     /**
622      * @dev See {IERC721Enumerable-tokenByIndex}.
623      */
624     function tokenByIndex(uint256 index) public view override returns (uint256) {
625         require(index < totalSupply(), 'ERC721A: global index out of bounds');
626         return index;
627     }
628 
629     /**
630      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
631      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
632      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
633      */
634     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
635         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
636         uint256 numMintedSoFar = totalSupply();
637         uint256 tokenIdsIdx = 0;
638         address currOwnershipAddr = address(0);
639         for (uint256 i = 0; i < numMintedSoFar; i++) {
640             TokenOwnership memory ownership = _ownerships[i];
641             if (ownership.addr != address(0)) {
642                 currOwnershipAddr = ownership.addr;
643             }
644             if (currOwnershipAddr == owner) {
645                 if (tokenIdsIdx == index) {
646                     return i;
647                 }
648                 tokenIdsIdx++;
649             }
650         }
651         revert('ERC721A: unable to get token of owner by index');
652     }
653 
654     /**
655      * @dev See {IERC165-supportsInterface}.
656      */
657     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
658         return
659             interfaceId == type(IERC721).interfaceId ||
660             interfaceId == type(IERC721Metadata).interfaceId ||
661             interfaceId == type(IERC721Enumerable).interfaceId ||
662             super.supportsInterface(interfaceId);
663     }
664 
665     /**
666      * @dev See {IERC721-balanceOf}.
667      */
668     function balanceOf(address owner) public view override returns (uint256) {
669         require(owner != address(0), 'ERC721A: balance query for the zero address');
670         return uint256(_addressData[owner].balance);
671     }
672 
673     function _numberMinted(address owner) internal view returns (uint256) {
674         require(owner != address(0), 'ERC721A: number minted query for the zero address');
675         return uint256(_addressData[owner].numberMinted);
676     }
677 
678     /**
679      * Gas spent here starts off proportional to the maximum mint batch size.
680      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
681      */
682     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
683         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
684 
685         for (uint256 curr = tokenId; ; curr--) {
686             TokenOwnership memory ownership = _ownerships[curr];
687             if (ownership.addr != address(0)) {
688                 return ownership;
689             }
690         }
691 
692         revert('ERC721A: unable to determine the owner of token');
693     }
694 
695     /**
696      * @dev See {IERC721-ownerOf}.
697      */
698     function ownerOf(uint256 tokenId) public view override returns (address) {
699         return ownershipOf(tokenId).addr;
700     }
701 
702     /**
703      * @dev See {IERC721Metadata-name}.
704      */
705     function name() public view virtual override returns (string memory) {
706         return _name;
707     }
708 
709     /**
710      * @dev See {IERC721Metadata-symbol}.
711      */
712     function symbol() public view virtual override returns (string memory) {
713         return _symbol;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-tokenURI}.
718      */
719     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
720         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
721 
722         string memory baseURI = _baseURI();
723         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
724     }
725 
726     /**
727      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
728      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
729      * by default, can be overriden in child contracts.
730      */
731     function _baseURI() internal view virtual returns (string memory) {
732         return '';
733     }
734 
735     /**
736      * @dev See {IERC721-approve}.
737      */
738     function approve(address to, uint256 tokenId) public override {
739         address owner = ERC721A.ownerOf(tokenId);
740         require(to != owner, 'ERC721A: approval to current owner');
741 
742         require(
743             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
744             'ERC721A: approve caller is not owner nor approved for all'
745         );
746 
747         _approve(to, tokenId, owner);
748     }
749 
750     /**
751      * @dev See {IERC721-getApproved}.
752      */
753     function getApproved(uint256 tokenId) public view override returns (address) {
754         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
755 
756         return _tokenApprovals[tokenId];
757     }
758 
759     /**
760      * @dev See {IERC721-setApprovalForAll}.
761      */
762     function setApprovalForAll(address operator, bool approved) public override {
763         require(operator != _msgSender(), 'ERC721A: approve to caller');
764 
765         _operatorApprovals[_msgSender()][operator] = approved;
766         emit ApprovalForAll(_msgSender(), operator, approved);
767     }
768 
769     /**
770      * @dev See {IERC721-isApprovedForAll}.
771      */
772     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
773         return _operatorApprovals[owner][operator];
774     }
775 
776     /**
777      * @dev See {IERC721-transferFrom}.
778      */
779     function transferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) public override {
784         _transfer(from, to, tokenId);
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) public override {
795         safeTransferFrom(from, to, tokenId, '');
796     }
797 
798     /**
799      * @dev See {IERC721-safeTransferFrom}.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) public override {
807         _transfer(from, to, tokenId);
808         require(
809             _checkOnERC721Received(from, to, tokenId, _data),
810             'ERC721A: transfer to non ERC721Receiver implementer'
811         );
812     }
813 
814     /**
815      * @dev Returns whether `tokenId` exists.
816      *
817      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
818      *
819      * Tokens start existing when they are minted (`_mint`),
820      */
821     function _exists(uint256 tokenId) internal view returns (bool) {
822         return tokenId < currentIndex;
823     }
824 
825     function _safeMint(address to, uint256 quantity) internal {
826         _safeMint(to, quantity, '');
827     }
828 
829     /**
830      * @dev Safely mints `quantity` tokens and transfers them to `to`.
831      *
832      * Requirements:
833      *
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
835      * - `quantity` must be greater than 0.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _safeMint(
840         address to,
841         uint256 quantity,
842         bytes memory _data
843     ) internal {
844         _mint(to, quantity, _data, true);
845     }
846 
847     /**
848      * @dev Mints `quantity` tokens and transfers them to `to`.
849      *
850      * Requirements:
851      *
852      * - `to` cannot be the zero address.
853      * - `quantity` must be greater than 0.
854      *
855      * Emits a {Transfer} event.
856      */
857     function _mint(
858         address to,
859         uint256 quantity,
860         bytes memory _data,
861         bool safe
862     ) internal {
863         uint256 startTokenId = currentIndex;
864         require(to != address(0), 'ERC721A: mint to the zero address');
865         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
866         require(!_exists(startTokenId), 'ERC721A: token already minted');
867         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
868 
869         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
870 
871         _addressData[to].balance += uint128(quantity);
872         _addressData[to].numberMinted += uint128(quantity);
873 
874         _ownerships[startTokenId].addr = to;
875         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
876 
877         uint256 updatedIndex = startTokenId;
878 
879         for (uint256 i = 0; i < quantity; i++) {
880             emit Transfer(address(0), to, updatedIndex);
881             if (safe) {
882                 require(
883                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
884                     'ERC721A: transfer to non ERC721Receiver implementer'
885                 );
886             }
887             updatedIndex++;
888         }
889 
890         currentIndex = updatedIndex;
891         _afterTokenTransfers(address(0), to, startTokenId, quantity);
892     }
893 
894     /**
895      * @dev Transfers `tokenId` from `from` to `to`.
896      *
897      * Requirements:
898      *
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must be owned by `from`.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _transfer(
905         address from,
906         address to,
907         uint256 tokenId
908     ) private {
909         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
910 
911         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
912             getApproved(tokenId) == _msgSender() ||
913             isApprovedForAll(prevOwnership.addr, _msgSender()));
914 
915         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
916 
917         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
918         require(to != address(0), 'ERC721A: transfer to the zero address');
919 
920         _beforeTokenTransfers(from, to, tokenId, 1);
921 
922         // Clear approvals from the previous owner
923         _approve(address(0), tokenId, prevOwnership.addr);
924 
925         // Underflow of the sender's balance is impossible because we check for
926         // ownership above and the recipient's balance can't realistically overflow.
927         unchecked {
928             _addressData[from].balance -= 1;
929             _addressData[to].balance += 1;
930         }
931 
932         _ownerships[tokenId].addr = to;
933         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
934 
935         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
936         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
937         uint256 nextTokenId = tokenId + 1;
938         if (_ownerships[nextTokenId].addr == address(0)) {
939             if (_exists(nextTokenId)) {
940                 _ownerships[nextTokenId].addr = prevOwnership.addr;
941                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
942             }
943         }
944 
945         emit Transfer(from, to, tokenId);
946         _afterTokenTransfers(from, to, tokenId, 1);
947     }
948 
949     /**
950      * @dev Approve `to` to operate on `tokenId`
951      *
952      * Emits a {Approval} event.
953      */
954     function _approve(
955         address to,
956         uint256 tokenId,
957         address owner
958     ) private {
959         _tokenApprovals[tokenId] = to;
960         emit Approval(owner, to, tokenId);
961     }
962 
963     /**
964      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
965      * The call is not executed if the target address is not a contract.
966      *
967      * @param from address representing the previous owner of the given token ID
968      * @param to target address that will receive the tokens
969      * @param tokenId uint256 ID of the token to be transferred
970      * @param _data bytes optional data to send along with the call
971      * @return bool whether the call correctly returned the expected magic value
972      */
973     function _checkOnERC721Received(
974         address from,
975         address to,
976         uint256 tokenId,
977         bytes memory _data
978     ) private returns (bool) {
979         if (to.isContract()) {
980             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
981                 return retval == IERC721Receiver(to).onERC721Received.selector;
982             } catch (bytes memory reason) {
983                 if (reason.length == 0) {
984                     revert('ERC721A: transfer to non ERC721Receiver implementer');
985                 } else {
986                     assembly {
987                         revert(add(32, reason), mload(reason))
988                     }
989                 }
990             }
991         } else {
992             return true;
993         }
994     }
995 
996     /**
997      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
998      *
999      * startTokenId - the first token id to be transferred
1000      * quantity - the amount to be transferred
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` will be minted for `to`.
1007      */
1008     function _beforeTokenTransfers(
1009         address from,
1010         address to,
1011         uint256 startTokenId,
1012         uint256 quantity
1013     ) internal virtual {}
1014 
1015     /**
1016      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1017      * minting.
1018      *
1019      * startTokenId - the first token id to be transferred
1020      * quantity - the amount to be transferred
1021      *
1022      * Calling conditions:
1023      *
1024      * - when `from` and `to` are both non-zero.
1025      * - `from` and `to` are never both zero.
1026      */
1027     function _afterTokenTransfers(
1028         address from,
1029         address to,
1030         uint256 startTokenId,
1031         uint256 quantity
1032     ) internal virtual {}
1033 }
1034 
1035 contract ScrubbyApeArtwork is ERC721A {
1036 
1037     mapping (address => uint8) public _minted;
1038 
1039     uint public salePrice;
1040     uint public reachedCapPrice;
1041     uint16 public maxSupply;
1042     uint8 public maxPerTx;
1043     uint8 public maxPerWallet;
1044 
1045     bool public publicMintStatus;
1046 
1047     string public baseURI;
1048 
1049     address private owner;
1050 
1051     function _baseURI() internal view override returns (string memory) {
1052         return baseURI;
1053     }
1054     
1055     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1056         baseURI = _newBaseURI;
1057     }
1058 
1059     function setSalePrice(uint price) external onlyOwner {
1060         salePrice = price;
1061     }
1062 
1063     function setReachedCapPrice(uint price) external onlyOwner {
1064         reachedCapPrice = price;
1065     }
1066 
1067     function setMaxSupply(uint16 supply) external onlyOwner {
1068         maxSupply = supply;
1069     }
1070 
1071     function setMaxPerTx(uint8 max) external onlyOwner {
1072         maxPerTx = max;
1073     }
1074 
1075     function setMaxPerWallet(uint8 max) external onlyOwner {
1076         maxPerWallet = max;
1077     }
1078 
1079     function setPublicMintStatus() external onlyOwner {
1080         publicMintStatus = !publicMintStatus;
1081     }
1082 
1083     function withdraw() external onlyOwner {
1084         payable(msg.sender).transfer(address(this).balance);
1085     }
1086 
1087     modifier onlyOwner {
1088         require(owner == msg.sender, "Not the owner!");
1089         _;
1090     }
1091 
1092     function transferOwnership(address newOwner) external onlyOwner {
1093         owner = newOwner;
1094     }
1095 
1096     constructor() ERC721A("Scrubby Ape Artwork", "SAA") {
1097         owner = msg.sender;
1098     }
1099 
1100     function I_AM_A_GENIUS_SO_I_AM_BUYING_MORE(uint8 amount) external payable {
1101         require(publicMintStatus, "Sale not active!");
1102         require(currentIndex + amount <= maxSupply + 1, "Not enough tokens to sell!");
1103         require(amount <= maxPerTx, "Incorrect amount!");
1104         require(_minted[msg.sender] + amount <= maxPerWallet, "Incorrect amount!");
1105         if(currentIndex + amount > 3000){
1106             require(msg.value == reachedCapPrice * amount, "Incorrect amount!");
1107             _safeMint(msg.sender, amount);
1108             _minted[msg.sender] += amount;
1109         }else{
1110             require(msg.value == salePrice * amount, "Incorrect amount!");
1111             _safeMint(msg.sender, amount);
1112             _minted[msg.sender] += amount;
1113         }
1114     }
1115 
1116     function LOL_YOU_CAN_BUY_MORE_FOR_THE_SAME_PRICE() external payable {
1117         require(publicMintStatus, "Sale not active!");
1118         require(currentIndex <= maxSupply, "Not enough tokens to sell!");
1119         require(_minted[msg.sender] + 1 <= maxPerWallet, "Not allowed!");
1120         if(currentIndex > 5000){
1121             require(msg.value == reachedCapPrice, "Incorrect amount!");
1122             _safeMint(msg.sender, 1);
1123             _minted[msg.sender] += 1;
1124         }else{
1125             require(msg.value == 0, "Incorrect amount!");
1126             _safeMint(msg.sender, 1);
1127             _minted[msg.sender] += 1;
1128         }
1129     }
1130 }