1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 
68 /**
69  * @dev Provides information about the current execution context, including the
70  * sender of the transaction and its data. While these are generally available
71  * via msg.sender and msg.data, they should not be accessed in such a direct
72  * manner, since when dealing with meta-transactions the account sending and
73  * paying for execution may not be the actual sender (as far as an application
74  * is concerned).
75  *
76  * This contract is only required for intermediate, library-like contracts.
77  */
78 abstract contract Context {
79     function _msgSender() internal view virtual returns (address) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes calldata) {
84         return msg.data;
85     }
86 }
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         assembly {
116             size := extcodesize(account)
117         }
118         return size > 0;
119     }
120 
121     /**
122      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
123      * `recipient`, forwarding all available gas and reverting on errors.
124      *
125      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
126      * of certain opcodes, possibly making contracts go over the 2300 gas limit
127      * imposed by `transfer`, making them unable to receive funds via
128      * `transfer`. {sendValue} removes this limitation.
129      *
130      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
131      *
132      * IMPORTANT: because control is transferred to `recipient`, care must be
133      * taken to not create reentrancy vulnerabilities. Consider using
134      * {ReentrancyGuard} or the
135      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
136      */
137     function sendValue(address payable recipient, uint256 amount) internal {
138         require(address(this).balance >= amount, "Address: insufficient balance");
139 
140         (bool success, ) = recipient.call{value: amount}("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain `call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163         return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(
173         address target,
174         bytes memory data,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         return functionCallWithValue(target, data, 0, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
182      * but also transferring `value` wei to `target`.
183      *
184      * Requirements:
185      *
186      * - the calling contract must have an ETH balance of at least `value`.
187      * - the called Solidity function must be `payable`.
188      *
189      * _Available since v3.1._
190      */
191     function functionCallWithValue(
192         address target,
193         bytes memory data,
194         uint256 value
195     ) internal returns (bytes memory) {
196         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
201      * with `errorMessage` as a fallback revert reason when `target` reverts.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(
206         address target,
207         bytes memory data,
208         uint256 value,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213 
214         (bool success, bytes memory returndata) = target.call{value: value}(data);
215         return verifyCallResult(success, returndata, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
225         return functionStaticCall(target, data, "Address: low-level static call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal view returns (bytes memory) {
239         require(isContract(target), "Address: static call to non-contract");
240 
241         (bool success, bytes memory returndata) = target.staticcall(data);
242         return verifyCallResult(success, returndata, errorMessage);
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
252         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(
262         address target,
263         bytes memory data,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(isContract(target), "Address: delegate call to non-contract");
267 
268         (bool success, bytes memory returndata) = target.delegatecall(data);
269         return verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     /**
273      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
274      * revert reason using the provided one.
275      *
276      * _Available since v4.3._
277      */
278     function verifyCallResult(
279         bool success,
280         bytes memory returndata,
281         string memory errorMessage
282     ) internal pure returns (bytes memory) {
283         if (success) {
284             return returndata;
285         } else {
286             // Look for revert reason and bubble it up if present
287             if (returndata.length > 0) {
288                 // The easiest way to bubble the revert reason is using memory via assembly
289 
290                 assembly {
291                     let returndata_size := mload(returndata)
292                     revert(add(32, returndata), returndata_size)
293                 }
294             } else {
295                 revert(errorMessage);
296             }
297         }
298     }
299 }
300 
301 /**
302  * @title ERC721 token receiver interface
303  * @dev Interface for any contract that wants to support safeTransfers
304  * from ERC721 asset contracts.
305  */
306 interface IERC721Receiver {
307     /**
308      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
309      * by `operator` from `from`, this function is called.
310      *
311      * It must return its Solidity selector to confirm the token transfer.
312      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
313      *
314      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
315      */
316     function onERC721Received(
317         address operator,
318         address from,
319         uint256 tokenId,
320         bytes calldata data
321     ) external returns (bytes4);
322 }
323 
324 /**
325  * @dev Interface of the ERC165 standard, as defined in the
326  * https://eips.ethereum.org/EIPS/eip-165[EIP].
327  *
328  * Implementers can declare support of contract interfaces, which can then be
329  * queried by others ({ERC165Checker}).
330  *
331  * For an implementation, see {ERC165}.
332  */
333 interface IERC165 {
334     /**
335      * @dev Returns true if this contract implements the interface defined by
336      * `interfaceId`. See the corresponding
337      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
338      * to learn more about how these ids are created.
339      *
340      * This function call must use less than 30 000 gas.
341      */
342     function supportsInterface(bytes4 interfaceId) external view returns (bool);
343 }
344 
345 /**
346  * @dev Implementation of the {IERC165} interface.
347  *
348  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
349  * for the additional interface id that will be supported. For example:
350  *
351  * ```solidity
352  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
353  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
354  * }
355  * ```
356  *
357  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
358  */
359 abstract contract ERC165 is IERC165 {
360     /**
361      * @dev See {IERC165-supportsInterface}.
362      */
363     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
364         return interfaceId == type(IERC165).interfaceId;
365     }
366 }
367 
368 /**
369  * @dev Required interface of an ERC721 compliant contract.
370  */
371 interface IERC721 is IERC165 {
372     /**
373      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
376 
377     /**
378      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
379      */
380     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
381 
382     /**
383      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
384      */
385     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
386 
387     /**
388      * @dev Returns the number of tokens in ``owner``'s account.
389      */
390     function balanceOf(address owner) external view returns (uint256 balance);
391 
392     /**
393      * @dev Returns the owner of the `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function ownerOf(uint256 tokenId) external view returns (address owner);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
403      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must exist and be owned by `from`.
410      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
412      *
413      * Emits a {Transfer} event.
414      */
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId
419     ) external;
420 
421     /**
422      * @dev Transfers `tokenId` token from `from` to `to`.
423      *
424      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
443      * The approval is cleared when the token is transferred.
444      *
445      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
446      *
447      * Requirements:
448      *
449      * - The caller must own the token or be an approved operator.
450      * - `tokenId` must exist.
451      *
452      * Emits an {Approval} event.
453      */
454     function approve(address to, uint256 tokenId) external;
455 
456     /**
457      * @dev Returns the account approved for `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function getApproved(uint256 tokenId) external view returns (address operator);
464 
465     /**
466      * @dev Approve or remove `operator` as an operator for the caller.
467      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
468      *
469      * Requirements:
470      *
471      * - The `operator` cannot be the caller.
472      *
473      * Emits an {ApprovalForAll} event.
474      */
475     function setApprovalForAll(address operator, bool _approved) external;
476 
477     /**
478      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
479      *
480      * See {setApprovalForAll}
481      */
482     function isApprovedForAll(address owner, address operator) external view returns (bool);
483 
484     /**
485      * @dev Safely transfers `tokenId` token from `from` to `to`.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must exist and be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
494      *
495      * Emits a {Transfer} event.
496      */
497     function safeTransferFrom(
498         address from,
499         address to,
500         uint256 tokenId,
501         bytes calldata data
502     ) external;
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
515  * @dev See https://eips.ethereum.org/EIPS/eip-721
516  */
517 interface IERC721Enumerable is IERC721 {
518     /**
519      * @dev Returns the total amount of tokens stored by the contract.
520      */
521     function totalSupply() external view returns (uint256);
522 
523     /**
524      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
525      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
526      */
527     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
528 
529     /**
530      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
531      * Use along with {totalSupply} to enumerate all tokens.
532      */
533     function tokenByIndex(uint256 index) external view returns (uint256);
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 
544 /**
545  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
546  * @dev See https://eips.ethereum.org/EIPS/eip-721
547  */
548 interface IERC721Metadata is IERC721 {
549     /**
550      * @dev Returns the token collection name.
551      */
552     function name() external view returns (string memory);
553 
554     /**
555      * @dev Returns the token collection symbol.
556      */
557     function symbol() external view returns (string memory);
558 
559     /**
560      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
561      */
562     function tokenURI(uint256 tokenId) external view returns (string memory);
563 }
564 
565 /**
566  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
567  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
568  *
569  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
570  *
571  * Does not support burning tokens to address(0).
572  *
573  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
574  */
575 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
576     using Address for address;
577     using Strings for uint256;
578 
579     struct TokenOwnership {
580         address addr;
581         uint64 startTimestamp;
582     }
583 
584     struct AddressData {
585         uint128 balance;
586         uint128 numberMinted;
587     }
588 
589     uint256 internal currentIndex = 1;
590 
591     // Token name
592     string private _name;
593 
594     // Token symbol
595     string private _symbol;
596 
597     // Mapping from token ID to ownership details
598     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
599     mapping(uint256 => TokenOwnership) internal _ownerships;
600 
601     // Mapping owner address to address data
602     mapping(address => AddressData) private _addressData;
603 
604     // Mapping from token ID to approved address
605     mapping(uint256 => address) private _tokenApprovals;
606 
607     // Mapping from owner to operator approvals
608     mapping(address => mapping(address => bool)) private _operatorApprovals;
609 
610     constructor(string memory name_, string memory symbol_) {
611         _name = name_;
612         _symbol = symbol_;
613     }
614 
615     /**
616      * @dev See {IERC721Enumerable-totalSupply}.
617      */
618     function totalSupply() public view override returns (uint256) {
619         return currentIndex;
620     }
621 
622     /**
623      * @dev See {IERC721Enumerable-tokenByIndex}.
624      */
625     function tokenByIndex(uint256 index) public view override returns (uint256) {
626         require(index < totalSupply(), 'ERC721A: global index out of bounds');
627         return index;
628     }
629 
630     /**
631      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
632      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
633      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
634      */
635     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
636         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
637         uint256 numMintedSoFar = totalSupply();
638         uint256 tokenIdsIdx = 0;
639         address currOwnershipAddr = address(0);
640         for (uint256 i = 0; i < numMintedSoFar; i++) {
641             TokenOwnership memory ownership = _ownerships[i];
642             if (ownership.addr != address(0)) {
643                 currOwnershipAddr = ownership.addr;
644             }
645             if (currOwnershipAddr == owner) {
646                 if (tokenIdsIdx == index) {
647                     return i;
648                 }
649                 tokenIdsIdx++;
650             }
651         }
652         revert('ERC721A: unable to get token of owner by index');
653     }
654 
655     /**
656      * @dev See {IERC165-supportsInterface}.
657      */
658     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
659         return
660             interfaceId == type(IERC721).interfaceId ||
661             interfaceId == type(IERC721Metadata).interfaceId ||
662             interfaceId == type(IERC721Enumerable).interfaceId ||
663             super.supportsInterface(interfaceId);
664     }
665 
666     /**
667      * @dev See {IERC721-balanceOf}.
668      */
669     function balanceOf(address owner) public view override returns (uint256) {
670         require(owner != address(0), 'ERC721A: balance query for the zero address');
671         return uint256(_addressData[owner].balance);
672     }
673 
674     function _numberMinted(address owner) internal view returns (uint256) {
675         require(owner != address(0), 'ERC721A: number minted query for the zero address');
676         return uint256(_addressData[owner].numberMinted);
677     }
678 
679     /**
680      * Gas spent here starts off proportional to the maximum mint batch size.
681      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
682      */
683     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
684         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
685 
686         for (uint256 curr = tokenId; ; curr--) {
687             TokenOwnership memory ownership = _ownerships[curr];
688             if (ownership.addr != address(0)) {
689                 return ownership;
690             }
691         }
692 
693         revert('ERC721A: unable to determine the owner of token');
694     }
695 
696     /**
697      * @dev See {IERC721-ownerOf}.
698      */
699     function ownerOf(uint256 tokenId) public view override returns (address) {
700         return ownershipOf(tokenId).addr;
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
721         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
722 
723         string memory baseURI = _baseURI();
724         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
725     }
726 
727     /**
728      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
729      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
730      * by default, can be overriden in child contracts.
731      */
732     function _baseURI() internal view virtual returns (string memory) {
733         return '';
734     }
735 
736     /**
737      * @dev See {IERC721-approve}.
738      */
739     function approve(address to, uint256 tokenId) public override {
740         address owner = ERC721A.ownerOf(tokenId);
741         require(to != owner, 'ERC721A: approval to current owner');
742 
743         require(
744             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
745             'ERC721A: approve caller is not owner nor approved for all'
746         );
747 
748         _approve(to, tokenId, owner);
749     }
750 
751     /**
752      * @dev See {IERC721-getApproved}.
753      */
754     function getApproved(uint256 tokenId) public view override returns (address) {
755         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
756 
757         return _tokenApprovals[tokenId];
758     }
759 
760     /**
761      * @dev See {IERC721-setApprovalForAll}.
762      */
763     function setApprovalForAll(address operator, bool approved) public override {
764         require(operator != _msgSender(), 'ERC721A: approve to caller');
765 
766         _operatorApprovals[_msgSender()][operator] = approved;
767         emit ApprovalForAll(_msgSender(), operator, approved);
768     }
769 
770     /**
771      * @dev See {IERC721-isApprovedForAll}.
772      */
773     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
774         return _operatorApprovals[owner][operator];
775     }
776 
777     /**
778      * @dev See {IERC721-transferFrom}.
779      */
780     function transferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) public override {
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public override {
796         safeTransferFrom(from, to, tokenId, '');
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public override {
808         _transfer(from, to, tokenId);
809         require(
810             _checkOnERC721Received(from, to, tokenId, _data),
811             'ERC721A: transfer to non ERC721Receiver implementer'
812         );
813     }
814 
815     /**
816      * @dev Returns whether `tokenId` exists.
817      *
818      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
819      *
820      * Tokens start existing when they are minted (`_mint`),
821      */
822     function _exists(uint256 tokenId) internal view returns (bool) {
823         return tokenId < currentIndex;
824     }
825 
826     function _safeMint(address to, uint256 quantity) internal {
827         _safeMint(to, quantity, '');
828     }
829 
830     /**
831      * @dev Safely mints `quantity` tokens and transfers them to `to`.
832      *
833      * Requirements:
834      *
835      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
836      * - `quantity` must be greater than 0.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(
841         address to,
842         uint256 quantity,
843         bytes memory _data
844     ) internal {
845         _mint(to, quantity, _data, true);
846     }
847 
848     /**
849      * @dev Mints `quantity` tokens and transfers them to `to`.
850      *
851      * Requirements:
852      *
853      * - `to` cannot be the zero address.
854      * - `quantity` must be greater than 0.
855      *
856      * Emits a {Transfer} event.
857      */
858     function _mint(
859         address to,
860         uint256 quantity,
861         bytes memory _data,
862         bool safe
863     ) internal {
864         uint256 startTokenId = currentIndex;
865         require(to != address(0), 'ERC721A: mint to the zero address');
866         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
867         require(!_exists(startTokenId), 'ERC721A: token already minted');
868         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
869 
870         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
871 
872         _addressData[to].balance += uint128(quantity);
873         _addressData[to].numberMinted += uint128(quantity);
874 
875         _ownerships[startTokenId].addr = to;
876         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
877 
878         uint256 updatedIndex = startTokenId;
879 
880         for (uint256 i = 0; i < quantity; i++) {
881             emit Transfer(address(0), to, updatedIndex);
882             if (safe) {
883                 require(
884                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
885                     'ERC721A: transfer to non ERC721Receiver implementer'
886                 );
887             }
888             updatedIndex++;
889         }
890 
891         currentIndex = updatedIndex;
892         _afterTokenTransfers(address(0), to, startTokenId, quantity);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _transfer(
906         address from,
907         address to,
908         uint256 tokenId
909     ) private {
910         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
911 
912         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
913             getApproved(tokenId) == _msgSender() ||
914             isApprovedForAll(prevOwnership.addr, _msgSender()));
915 
916         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
917 
918         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
919         require(to != address(0), 'ERC721A: transfer to the zero address');
920 
921         _beforeTokenTransfers(from, to, tokenId, 1);
922 
923         // Clear approvals from the previous owner
924         _approve(address(0), tokenId, prevOwnership.addr);
925 
926         // Underflow of the sender's balance is impossible because we check for
927         // ownership above and the recipient's balance can't realistically overflow.
928         unchecked {
929             _addressData[from].balance -= 1;
930             _addressData[to].balance += 1;
931         }
932 
933         _ownerships[tokenId].addr = to;
934         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
935 
936         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
937         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
938         uint256 nextTokenId = tokenId + 1;
939         if (_ownerships[nextTokenId].addr == address(0)) {
940             if (_exists(nextTokenId)) {
941                 _ownerships[nextTokenId].addr = prevOwnership.addr;
942                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
943             }
944         }
945 
946         emit Transfer(from, to, tokenId);
947         _afterTokenTransfers(from, to, tokenId, 1);
948     }
949 
950     /**
951      * @dev Approve `to` to operate on `tokenId`
952      *
953      * Emits a {Approval} event.
954      */
955     function _approve(
956         address to,
957         uint256 tokenId,
958         address owner
959     ) private {
960         _tokenApprovals[tokenId] = to;
961         emit Approval(owner, to, tokenId);
962     }
963 
964     /**
965      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
966      * The call is not executed if the target address is not a contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         if (to.isContract()) {
981             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
982                 return retval == IERC721Receiver(to).onERC721Received.selector;
983             } catch (bytes memory reason) {
984                 if (reason.length == 0) {
985                     revert('ERC721A: transfer to non ERC721Receiver implementer');
986                 } else {
987                     assembly {
988                         revert(add(32, reason), mload(reason))
989                     }
990                 }
991             }
992         } else {
993             return true;
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
999      *
1000      * startTokenId - the first token id to be transferred
1001      * quantity - the amount to be transferred
1002      *
1003      * Calling conditions:
1004      *
1005      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1006      * transferred to `to`.
1007      * - When `from` is zero, `tokenId` will be minted for `to`.
1008      */
1009     function _beforeTokenTransfers(
1010         address from,
1011         address to,
1012         uint256 startTokenId,
1013         uint256 quantity
1014     ) internal virtual {}
1015 
1016     /**
1017      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1018      * minting.
1019      *
1020      * startTokenId - the first token id to be transferred
1021      * quantity - the amount to be transferred
1022      *
1023      * Calling conditions:
1024      *
1025      * - when `from` and `to` are both non-zero.
1026      * - `from` and `to` are never both zero.
1027      */
1028     function _afterTokenTransfers(
1029         address from,
1030         address to,
1031         uint256 startTokenId,
1032         uint256 quantity
1033     ) internal virtual {}
1034 }
1035 
1036 contract Doodle_Ape_Planet is ERC721A {
1037 
1038     mapping (address => uint8) public _minted;
1039 
1040     uint public salePrice;
1041     uint public reachedCapPrice;
1042     uint16 public maxSupply;
1043     uint8 public maxPerTx;
1044     uint8 public maxPerWallet;
1045 
1046     bool public publicMintStatus;
1047 
1048     string public baseURI;
1049 
1050     address private owner;
1051 
1052     function _baseURI() internal view override returns (string memory) {
1053         return baseURI;
1054     }
1055     
1056     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1057         baseURI = _newBaseURI;
1058     }
1059 
1060     function setSalePrice(uint price) external onlyOwner {
1061         salePrice = price;
1062     }
1063 
1064     function setReachedCapPrice(uint price) external onlyOwner {
1065         reachedCapPrice = price;
1066     }
1067 
1068     function setMaxSupply(uint16 supply) external onlyOwner {
1069         maxSupply = supply;
1070     }
1071 
1072 
1073     function setMaxPerTx(uint8 max) external onlyOwner {
1074         maxPerTx = max;
1075     }
1076 
1077     function setMaxPerWallet(uint8 max) external onlyOwner {
1078         maxPerWallet = max;
1079     }
1080 
1081     function setPublicMintStatus() external onlyOwner {
1082         publicMintStatus = !publicMintStatus;
1083     }
1084 
1085     function withdraw() external onlyOwner {
1086         payable(msg.sender).transfer(address(this).balance);
1087     }
1088 
1089     modifier onlyOwner {
1090         require(owner == msg.sender, "Not the owner!");
1091         _;
1092     }
1093 
1094     function transferOwnership(address newOwner) external onlyOwner {
1095         owner = newOwner;
1096     }
1097 
1098     constructor() ERC721A("Doodle Ape Palnet", "DAP") {
1099         owner = msg.sender;
1100     }
1101 
1102     function publicMint(uint8 amount) external payable {
1103         require(publicMintStatus, "Sale not active!");
1104         require(currentIndex + amount <= maxSupply + 1, "Not enough tokens to sell!");
1105         require(amount <= maxPerTx, "Incorrect amount!");
1106         require(_minted[msg.sender] + amount <= maxPerWallet, "Incorrect amount!");
1107         if(currentIndex + amount > 5000){
1108             require(msg.value == reachedCapPrice * amount, "Incorrect amount!");
1109             _safeMint(msg.sender, amount);
1110             _minted[msg.sender] += amount;
1111         }else{
1112             require(msg.value == salePrice * amount, "Incorrect amount!");
1113             _safeMint(msg.sender, amount);
1114             _minted[msg.sender] += amount;
1115         }
1116     }
1117 }