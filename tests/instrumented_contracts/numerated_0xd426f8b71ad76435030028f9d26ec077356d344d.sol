1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 
27 
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 
50 
51 
52 /**
53  * @dev String operations.
54  */
55 library Strings {
56     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
60      */
61     function toString(uint256 value) internal pure returns (string memory) {
62         // Inspired by OraclizeAPI's implementation - MIT licence
63         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
64 
65         if (value == 0) {
66             return "0";
67         }
68         uint256 temp = value;
69         uint256 digits;
70         while (temp != 0) {
71             digits++;
72             temp /= 10;
73         }
74         bytes memory buffer = new bytes(digits);
75         while (value != 0) {
76             digits -= 1;
77             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
78             value /= 10;
79         }
80         return string(buffer);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
85      */
86     function toHexString(uint256 value) internal pure returns (string memory) {
87         if (value == 0) {
88             return "0x00";
89         }
90         uint256 temp = value;
91         uint256 length = 0;
92         while (temp != 0) {
93             length++;
94             temp >>= 8;
95         }
96         return toHexString(value, length);
97     }
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
101      */
102     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
103         bytes memory buffer = new bytes(2 * length + 2);
104         buffer[0] = "0";
105         buffer[1] = "x";
106         for (uint256 i = 2 * length + 1; i > 1; --i) {
107             buffer[i] = _HEX_SYMBOLS[value & 0xf];
108             value >>= 4;
109         }
110         require(value == 0, "Strings: hex length insufficient");
111         return string(buffer);
112     }
113 }
114 
115 
116 
117 
118 // Creator: Chiru Labs
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 /**
129  * @dev Required interface of an ERC721 compliant contract.
130  */
131 interface IERC721 is IERC165 {
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Returns the account approved for `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function getApproved(uint256 tokenId) external view returns (address operator);
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 
244     /**
245      * @dev Safely transfers `tokenId` token from `from` to `to`.
246      *
247      * Requirements:
248      *
249      * - `from` cannot be the zero address.
250      * - `to` cannot be the zero address.
251      * - `tokenId` token must exist and be owned by `from`.
252      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
253      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
254      *
255      * Emits a {Transfer} event.
256      */
257     function safeTransferFrom(
258         address from,
259         address to,
260         uint256 tokenId,
261         bytes calldata data
262     ) external;
263 }
264 
265 
266 
267 
268 
269 /**
270  * @title ERC721 token receiver interface
271  * @dev Interface for any contract that wants to support safeTransfers
272  * from ERC721 asset contracts.
273  */
274 interface IERC721Receiver {
275     /**
276      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
277      * by `operator` from `from`, this function is called.
278      *
279      * It must return its Solidity selector to confirm the token transfer.
280      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
281      *
282      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
283      */
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 
293 
294 
295 
296 
297 
298 /**
299  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
300  * @dev See https://eips.ethereum.org/EIPS/eip-721
301  */
302 interface IERC721Metadata is IERC721 {
303     /**
304      * @dev Returns the token collection name.
305      */
306     function name() external view returns (string memory);
307 
308     /**
309      * @dev Returns the token collection symbol.
310      */
311     function symbol() external view returns (string memory);
312 
313     /**
314      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
315      */
316     function tokenURI(uint256 tokenId) external view returns (string memory);
317 }
318 
319 
320 
321 
322 
323 
324 
325 /**
326  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
327  * @dev See https://eips.ethereum.org/EIPS/eip-721
328  */
329 interface IERC721Enumerable is IERC721 {
330     /**
331      * @dev Returns the total amount of tokens stored by the contract.
332      */
333     function totalSupply() external view returns (uint256);
334 
335     /**
336      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
337      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
338      */
339     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
340 
341     /**
342      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
343      * Use along with {totalSupply} to enumerate all tokens.
344      */
345     function tokenByIndex(uint256 index) external view returns (uint256);
346 }
347 
348 
349 
350 
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // This method relies on extcodesize, which returns 0 for contracts in
375         // construction, since the code is only stored at the end of the
376         // constructor execution.
377 
378         uint256 size;
379         assembly {
380             size := extcodesize(account)
381         }
382         return size > 0;
383     }
384 
385     /**
386      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
387      * `recipient`, forwarding all available gas and reverting on errors.
388      *
389      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
390      * of certain opcodes, possibly making contracts go over the 2300 gas limit
391      * imposed by `transfer`, making them unable to receive funds via
392      * `transfer`. {sendValue} removes this limitation.
393      *
394      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
395      *
396      * IMPORTANT: because control is transferred to `recipient`, care must be
397      * taken to not create reentrancy vulnerabilities. Consider using
398      * {ReentrancyGuard} or the
399      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
400      */
401     function sendValue(address payable recipient, uint256 amount) internal {
402         require(address(this).balance >= amount, "Address: insufficient balance");
403 
404         (bool success, ) = recipient.call{value: amount}("");
405         require(success, "Address: unable to send value, recipient may have reverted");
406     }
407 
408     /**
409      * @dev Performs a Solidity function call using a low level `call`. A
410      * plain `call` is an unsafe replacement for a function call: use this
411      * function instead.
412      *
413      * If `target` reverts with a revert reason, it is bubbled up by this
414      * function (like regular Solidity function calls).
415      *
416      * Returns the raw returned data. To convert to the expected return value,
417      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418      *
419      * Requirements:
420      *
421      * - `target` must be a contract.
422      * - calling `target` with `data` must not revert.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
427         return functionCall(target, data, "Address: low-level call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
432      * `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(
437         address target,
438         bytes memory data,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, 0, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but also transferring `value` wei to `target`.
447      *
448      * Requirements:
449      *
450      * - the calling contract must have an ETH balance of at least `value`.
451      * - the called Solidity function must be `payable`.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value
459     ) internal returns (bytes memory) {
460         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
465      * with `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCallWithValue(
470         address target,
471         bytes memory data,
472         uint256 value,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(address(this).balance >= value, "Address: insufficient balance for call");
476         require(isContract(target), "Address: call to non-contract");
477 
478         (bool success, bytes memory returndata) = target.call{value: value}(data);
479         return _verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
489         return functionStaticCall(target, data, "Address: low-level static call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a static call.
495      *
496      * _Available since v3.3._
497      */
498     function functionStaticCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal view returns (bytes memory) {
503         require(isContract(target), "Address: static call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return _verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a delegate call.
522      *
523      * _Available since v3.4._
524      */
525     function functionDelegateCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         require(isContract(target), "Address: delegate call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.delegatecall(data);
533         return _verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     function _verifyCallResult(
537         bool success,
538         bytes memory returndata,
539         string memory errorMessage
540     ) private pure returns (bytes memory) {
541         if (success) {
542             return returndata;
543         } else {
544             // Look for revert reason and bubble it up if present
545             if (returndata.length > 0) {
546                 // The easiest way to bubble the revert reason is using memory via assembly
547 
548                 assembly {
549                     let returndata_size := mload(returndata)
550                     revert(add(32, returndata), returndata_size)
551                 }
552             } else {
553                 revert(errorMessage);
554             }
555         }
556     }
557 }
558 
559 
560 
561 
562 
563 
564 
565 
566 
567 /**
568  * @dev Implementation of the {IERC165} interface.
569  *
570  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
571  * for the additional interface id that will be supported. For example:
572  *
573  * ```solidity
574  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
576  * }
577  * ```
578  *
579  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
580  */
581 abstract contract ERC165 is IERC165 {
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
586         return interfaceId == type(IERC165).interfaceId;
587     }
588 }
589 
590 
591 /**
592  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
593  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
594  *
595  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
596  *
597  * Does not support burning tokens to address(0).
598  *
599  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
600  */
601 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
602     using Address for address;
603     using Strings for uint256;
604 
605     struct TokenOwnership {
606         address addr;
607         uint64 startTimestamp;
608     }
609 
610     struct AddressData {
611         uint128 balance;
612         uint128 numberMinted;
613     }
614 
615     uint256 internal currentIndex = 0;
616 
617     // Token name
618     string private _name;
619 
620     // Token symbol
621     string private _symbol;
622 
623     // Mapping from token ID to ownership details
624     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
625     mapping(uint256 => TokenOwnership) internal _ownerships;
626 
627     // Mapping owner address to address data
628     mapping(address => AddressData) private _addressData;
629 
630     // Mapping from token ID to approved address
631     mapping(uint256 => address) private _tokenApprovals;
632 
633     // Mapping from owner to operator approvals
634     mapping(address => mapping(address => bool)) private _operatorApprovals;
635 
636     constructor(string memory name_, string memory symbol_) {
637         _name = name_;
638         _symbol = symbol_;
639     }
640 
641     /**
642      * @dev See {IERC721Enumerable-totalSupply}.
643      */
644     function totalSupply() public view override returns (uint256) {
645         return currentIndex;
646     }
647 
648     /**
649      * @dev See {IERC721Enumerable-tokenByIndex}.
650      */
651     function tokenByIndex(uint256 index) public view override returns (uint256) {
652         require(index < totalSupply(), 'ERC721A: global index out of bounds');
653         return index;
654     }
655 
656     /**
657      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
658      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
659      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
660      */
661     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
662         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
663         uint256 numMintedSoFar = totalSupply();
664         uint256 tokenIdsIdx = 0;
665         address currOwnershipAddr = address(0);
666         for (uint256 i = 0; i < numMintedSoFar; i++) {
667             TokenOwnership memory ownership = _ownerships[i];
668             if (ownership.addr != address(0)) {
669                 currOwnershipAddr = ownership.addr;
670             }
671             if (currOwnershipAddr == owner) {
672                 if (tokenIdsIdx == index) {
673                     return i;
674                 }
675                 tokenIdsIdx++;
676             }
677         }
678         revert('ERC721A: unable to get token of owner by index');
679     }
680 
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
685         return
686             interfaceId == type(IERC721).interfaceId ||
687             interfaceId == type(IERC721Metadata).interfaceId ||
688             interfaceId == type(IERC721Enumerable).interfaceId ||
689             super.supportsInterface(interfaceId);
690     }
691 
692     /**
693      * @dev See {IERC721-balanceOf}.
694      */
695     function balanceOf(address owner) public view override returns (uint256) {
696         require(owner != address(0), 'ERC721A: balance query for the zero address');
697         return uint256(_addressData[owner].balance);
698     }
699 
700     function _numberMinted(address owner) internal view returns (uint256) {
701         require(owner != address(0), 'ERC721A: number minted query for the zero address');
702         return uint256(_addressData[owner].numberMinted);
703     }
704 
705     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
706         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
707 
708         for (uint256 curr = tokenId; ; curr--) {
709             TokenOwnership memory ownership = _ownerships[curr];
710             if (ownership.addr != address(0)) {
711                 return ownership;
712             }
713         }
714 
715         revert('ERC721A: unable to determine the owner of token');
716     }
717 
718     /**
719      * @dev See {IERC721-ownerOf}.
720      */
721     function ownerOf(uint256 tokenId) public view override returns (address) {
722         return ownershipOf(tokenId).addr;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-name}.
727      */
728     function name() public view virtual override returns (string memory) {
729         return _name;
730     }
731 
732     /**
733      * @dev See {IERC721Metadata-symbol}.
734      */
735     function symbol() public view virtual override returns (string memory) {
736         return _symbol;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-tokenURI}.
741      */
742     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
743         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
744 
745         string memory baseURI = _baseURI();
746         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
747     }
748 
749     /**
750      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
751      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
752      * by default, can be overriden in child contracts.
753      */
754     function _baseURI() internal view virtual returns (string memory) {
755         return '';
756     }
757 
758     /**
759      * @dev See {IERC721-approve}.
760      */
761     function approve(address to, uint256 tokenId) public override {
762         address owner = ERC721A.ownerOf(tokenId);
763         require(to != owner, 'ERC721A: approval to current owner');
764 
765         require(
766             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
767             'ERC721A: approve caller is not owner nor approved for all'
768         );
769 
770         _approve(to, tokenId, owner);
771     }
772 
773     /**
774      * @dev See {IERC721-getApproved}.
775      */
776     function getApproved(uint256 tokenId) public view override returns (address) {
777         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
778 
779         return _tokenApprovals[tokenId];
780     }
781 
782     /**
783      * @dev See {IERC721-setApprovalForAll}.
784      */
785     function setApprovalForAll(address operator, bool approved) public override {
786         require(operator != _msgSender(), 'ERC721A: approve to caller');
787 
788         _operatorApprovals[_msgSender()][operator] = approved;
789         emit ApprovalForAll(_msgSender(), operator, approved);
790     }
791 
792     /**
793      * @dev See {IERC721-isApprovedForAll}.
794      */
795     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
796         return _operatorApprovals[owner][operator];
797     }
798 
799     /**
800      * @dev See {IERC721-transferFrom}.
801      */
802     function transferFrom(
803         address from,
804         address to,
805         uint256 tokenId
806     ) public override {
807         _transfer(from, to, tokenId);
808     }
809 
810     /**
811      * @dev See {IERC721-safeTransferFrom}.
812      */
813     function safeTransferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) public override {
818         safeTransferFrom(from, to, tokenId, '');
819     }
820 
821     /**
822      * @dev See {IERC721-safeTransferFrom}.
823      */
824     function safeTransferFrom(
825         address from,
826         address to,
827         uint256 tokenId,
828         bytes memory _data
829     ) public override {
830         _transfer(from, to, tokenId);
831         require(
832             _checkOnERC721Received(from, to, tokenId, _data),
833             'ERC721A: transfer to non ERC721Receiver implementer'
834         );
835     }
836 
837     /**
838      * @dev Returns whether `tokenId` exists.
839      *
840      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
841      *
842      * Tokens start existing when they are minted (`_mint`),
843      */
844     function _exists(uint256 tokenId) internal view returns (bool) {
845         return tokenId < currentIndex;
846     }
847 
848     function _safeMint(address to, uint256 quantity) internal {
849         _safeMint(to, quantity, '');
850     }
851 
852     /**
853      * @dev Mints `quantity` tokens and transfers them to `to`.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `quantity` cannot be larger than the max batch size.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _safeMint(
863         address to,
864         uint256 quantity,
865         bytes memory _data
866     ) internal {
867         uint256 startTokenId = currentIndex;
868         require(to != address(0), 'ERC721A: mint to the zero address');
869         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
870         require(!_exists(startTokenId), 'ERC721A: token already minted');
871         require(quantity > 0, 'ERC721A: quantity must be greater 0');
872 
873         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
874 
875         AddressData memory addressData = _addressData[to];
876         _addressData[to] = AddressData(
877             addressData.balance + uint128(quantity),
878             addressData.numberMinted + uint128(quantity)
879         );
880         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
881 
882         uint256 updatedIndex = startTokenId;
883 
884         for (uint256 i = 0; i < quantity; i++) {
885             emit Transfer(address(0), to, updatedIndex);
886             require(
887                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
888                 'ERC721A: transfer to non ERC721Receiver implementer'
889             );
890             updatedIndex++;
891         }
892 
893         currentIndex = updatedIndex;
894         _afterTokenTransfers(address(0), to, startTokenId, quantity);
895     }
896 
897     /**
898      * @dev Transfers `tokenId` from `from` to `to`.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _transfer(
908         address from,
909         address to,
910         uint256 tokenId
911     ) private {
912         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
913 
914         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
915             getApproved(tokenId) == _msgSender() ||
916             isApprovedForAll(prevOwnership.addr, _msgSender()));
917 
918         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
919 
920         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
921         require(to != address(0), 'ERC721A: transfer to the zero address');
922 
923         _beforeTokenTransfers(from, to, tokenId, 1);
924 
925         // Clear approvals from the previous owner
926         _approve(address(0), tokenId, prevOwnership.addr);
927 
928         // Underflow of the sender's balance is impossible because we check for
929         // ownership above and the recipient's balance can't realistically overflow.
930         unchecked {
931             _addressData[from].balance -= 1;
932             _addressData[to].balance += 1;
933         }
934 
935         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
936 
937         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
938         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
939         uint256 nextTokenId = tokenId + 1;
940         if (_ownerships[nextTokenId].addr == address(0)) {
941             if (_exists(nextTokenId)) {
942                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
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
1036 
1037 
1038 
1039 /**
1040  * @title Counters
1041  * @author Matt Condon (@shrugs)
1042  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1043  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1044  *
1045  * Include with `using Counters for Counters.Counter;`
1046  */
1047 library Counters {
1048     struct Counter {
1049         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1050         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1051         // this feature: see https://github.com/ethereum/solidity/issues/4637
1052         uint256 _value; // default: 0
1053     }
1054 
1055     function current(Counter storage counter) internal view returns (uint256) {
1056         return counter._value;
1057     }
1058 
1059     function increment(Counter storage counter) internal {
1060         unchecked {
1061             counter._value += 1;
1062         }
1063     }
1064 
1065     function decrement(Counter storage counter) internal {
1066         uint256 value = counter._value;
1067         require(value > 0, "Counter: decrement overflow");
1068         unchecked {
1069             counter._value = value - 1;
1070         }
1071     }
1072 
1073     function reset(Counter storage counter) internal {
1074         counter._value = 0;
1075     }
1076 }
1077 
1078 
1079 
1080 
1081 
1082 
1083 
1084 /**
1085  * @dev Contract module which provides a basic access control mechanism, where
1086  * there is an account (an owner) that can be granted exclusive access to
1087  * specific functions.
1088  *
1089  * By default, the owner account will be the one that deploys the contract. This
1090  * can later be changed with {transferOwnership}.
1091  *
1092  * This module is used through inheritance. It will make available the modifier
1093  * `onlyOwner`, which can be applied to your functions to restrict their use to
1094  * the owner.
1095  */
1096 abstract contract Ownable is Context {
1097     address private _owner;
1098 
1099     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1100 
1101     /**
1102      * @dev Initializes the contract setting the deployer as the initial owner.
1103      */
1104     constructor() {
1105         _setOwner(_msgSender());
1106     }
1107 
1108     /**
1109      * @dev Returns the address of the current owner.
1110      */
1111     function owner() public view virtual returns (address) {
1112         return _owner;
1113     }
1114 
1115     /**
1116      * @dev Throws if called by any account other than the owner.
1117      */
1118     modifier onlyOwner() {
1119         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1120         _;
1121     }
1122 
1123     /**
1124      * @dev Leaves the contract without owner. It will not be possible to call
1125      * `onlyOwner` functions anymore. Can only be called by the current owner.
1126      *
1127      * NOTE: Renouncing ownership will leave the contract without an owner,
1128      * thereby removing any functionality that is only available to the owner.
1129      */
1130     function renounceOwnership() public virtual onlyOwner {
1131         _setOwner(address(0));
1132     }
1133 
1134     /**
1135      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1136      * Can only be called by the current owner.
1137      */
1138     function transferOwnership(address newOwner) public virtual onlyOwner {
1139         require(newOwner != address(0), "Ownable: new owner is the zero address");
1140         _setOwner(newOwner);
1141     }
1142 
1143     function _setOwner(address newOwner) private {
1144         address oldOwner = _owner;
1145         _owner = newOwner;
1146         emit OwnershipTransferred(oldOwner, newOwner);
1147     }
1148 }
1149 
1150 
1151 
1152 
1153 
1154 // CAUTION
1155 // This version of SafeMath should only be used with Solidity 0.8 or later,
1156 // because it relies on the compiler's built in overflow checks.
1157 
1158 /**
1159  * @dev Wrappers over Solidity's arithmetic operations.
1160  *
1161  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1162  * now has built in overflow checking.
1163  */
1164 library SafeMath {
1165     /**
1166      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1167      *
1168      * _Available since v3.4._
1169      */
1170     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1171         unchecked {
1172             uint256 c = a + b;
1173             if (c < a) return (false, 0);
1174             return (true, c);
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1180      *
1181      * _Available since v3.4._
1182      */
1183     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1184         unchecked {
1185             if (b > a) return (false, 0);
1186             return (true, a - b);
1187         }
1188     }
1189 
1190     /**
1191      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1192      *
1193      * _Available since v3.4._
1194      */
1195     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1196         unchecked {
1197             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1198             // benefit is lost if 'b' is also tested.
1199             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1200             if (a == 0) return (true, 0);
1201             uint256 c = a * b;
1202             if (c / a != b) return (false, 0);
1203             return (true, c);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1213         unchecked {
1214             if (b == 0) return (false, 0);
1215             return (true, a / b);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1221      *
1222      * _Available since v3.4._
1223      */
1224     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1225         unchecked {
1226             if (b == 0) return (false, 0);
1227             return (true, a % b);
1228         }
1229     }
1230 
1231     /**
1232      * @dev Returns the addition of two unsigned integers, reverting on
1233      * overflow.
1234      *
1235      * Counterpart to Solidity's `+` operator.
1236      *
1237      * Requirements:
1238      *
1239      * - Addition cannot overflow.
1240      */
1241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1242         return a + b;
1243     }
1244 
1245     /**
1246      * @dev Returns the subtraction of two unsigned integers, reverting on
1247      * overflow (when the result is negative).
1248      *
1249      * Counterpart to Solidity's `-` operator.
1250      *
1251      * Requirements:
1252      *
1253      * - Subtraction cannot overflow.
1254      */
1255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1256         return a - b;
1257     }
1258 
1259     /**
1260      * @dev Returns the multiplication of two unsigned integers, reverting on
1261      * overflow.
1262      *
1263      * Counterpart to Solidity's `*` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - Multiplication cannot overflow.
1268      */
1269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1270         return a * b;
1271     }
1272 
1273     /**
1274      * @dev Returns the integer division of two unsigned integers, reverting on
1275      * division by zero. The result is rounded towards zero.
1276      *
1277      * Counterpart to Solidity's `/` operator.
1278      *
1279      * Requirements:
1280      *
1281      * - The divisor cannot be zero.
1282      */
1283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1284         return a / b;
1285     }
1286 
1287     /**
1288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1289      * reverting when dividing by zero.
1290      *
1291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1292      * opcode (which leaves remaining gas untouched) while Solidity uses an
1293      * invalid opcode to revert (consuming all remaining gas).
1294      *
1295      * Requirements:
1296      *
1297      * - The divisor cannot be zero.
1298      */
1299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1300         return a % b;
1301     }
1302 
1303     /**
1304      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1305      * overflow (when the result is negative).
1306      *
1307      * CAUTION: This function is deprecated because it requires allocating memory for the error
1308      * message unnecessarily. For custom revert reasons use {trySub}.
1309      *
1310      * Counterpart to Solidity's `-` operator.
1311      *
1312      * Requirements:
1313      *
1314      * - Subtraction cannot overflow.
1315      */
1316     function sub(
1317         uint256 a,
1318         uint256 b,
1319         string memory errorMessage
1320     ) internal pure returns (uint256) {
1321         unchecked {
1322             require(b <= a, errorMessage);
1323             return a - b;
1324         }
1325     }
1326 
1327     /**
1328      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1329      * division by zero. The result is rounded towards zero.
1330      *
1331      * Counterpart to Solidity's `/` operator. Note: this function uses a
1332      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1333      * uses an invalid opcode to revert (consuming all remaining gas).
1334      *
1335      * Requirements:
1336      *
1337      * - The divisor cannot be zero.
1338      */
1339     function div(
1340         uint256 a,
1341         uint256 b,
1342         string memory errorMessage
1343     ) internal pure returns (uint256) {
1344         unchecked {
1345             require(b > 0, errorMessage);
1346             return a / b;
1347         }
1348     }
1349 
1350     /**
1351      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1352      * reverting with custom message when dividing by zero.
1353      *
1354      * CAUTION: This function is deprecated because it requires allocating memory for the error
1355      * message unnecessarily. For custom revert reasons use {tryMod}.
1356      *
1357      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1358      * opcode (which leaves remaining gas untouched) while Solidity uses an
1359      * invalid opcode to revert (consuming all remaining gas).
1360      *
1361      * Requirements:
1362      *
1363      * - The divisor cannot be zero.
1364      */
1365     function mod(
1366         uint256 a,
1367         uint256 b,
1368         string memory errorMessage
1369     ) internal pure returns (uint256) {
1370         unchecked {
1371             require(b > 0, errorMessage);
1372             return a % b;
1373         }
1374     }
1375 }
1376 
1377 
1378 
1379 
1380 
1381 /**
1382  * @dev Contract module that helps prevent reentrant calls to a function.
1383  *
1384  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1385  * available, which can be applied to functions to make sure there are no nested
1386  * (reentrant) calls to them.
1387  *
1388  * Note that because there is a single `nonReentrant` guard, functions marked as
1389  * `nonReentrant` may not call one another. This can be worked around by making
1390  * those functions `private`, and then adding `external` `nonReentrant` entry
1391  * points to them.
1392  *
1393  * TIP: If you would like to learn more about reentrancy and alternative ways
1394  * to protect against it, check out our blog post
1395  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1396  */
1397 abstract contract ReentrancyGuard {
1398     // Booleans are more expensive than uint256 or any type that takes up a full
1399     // word because each write operation emits an extra SLOAD to first read the
1400     // slot's contents, replace the bits taken up by the boolean, and then write
1401     // back. This is the compiler's defense against contract upgrades and
1402     // pointer aliasing, and it cannot be disabled.
1403 
1404     // The values being non-zero value makes deployment a bit more expensive,
1405     // but in exchange the refund on every call to nonReentrant will be lower in
1406     // amount. Since refunds are capped to a percentage of the total
1407     // transaction's gas, it is best to keep them low in cases like this one, to
1408     // increase the likelihood of the full refund coming into effect.
1409     uint256 private constant _NOT_ENTERED = 1;
1410     uint256 private constant _ENTERED = 2;
1411 
1412     uint256 private _status;
1413 
1414     constructor() {
1415         _status = _NOT_ENTERED;
1416     }
1417 
1418     /**
1419      * @dev Prevents a contract from calling itself, directly or indirectly.
1420      * Calling a `nonReentrant` function from another `nonReentrant`
1421      * function is not supported. It is possible to prevent this from happening
1422      * by making the `nonReentrant` function external, and make it call a
1423      * `private` function that does the actual work.
1424      */
1425     modifier nonReentrant() {
1426         // On the first call to nonReentrant, _notEntered will be true
1427         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1428 
1429         // Any calls to nonReentrant after this point will fail
1430         _status = _ENTERED;
1431 
1432         _;
1433 
1434         // By storing the original value once again, a refund is triggered (see
1435         // https://eips.ethereum.org/EIPS/eip-2200)
1436         _status = _NOT_ENTERED;
1437     }
1438 }
1439 
1440 
1441 contract NFT is ERC721A, Ownable, ReentrancyGuard {
1442   using Counters for Counters.Counter;
1443   using SafeMath for uint256;
1444   uint256 private _mintCost;
1445   uint256 private _maxSupply;
1446   bool private _isPublicMintEnabled;
1447   uint256 private _freeSupply;
1448   
1449   /**
1450   * @dev Initializes the contract setting the `tokenName` and `symbol` of the nft, `cost` of each mint call, and maximum `supply` of the nft.
1451   * Note: `cost` is in wei. 
1452   */
1453   constructor(string memory tokenName, string memory symbol, uint256 cost, uint256 supply) ERC721A(tokenName, symbol) Ownable() {
1454     _mintCost = cost;
1455     _maxSupply = supply;
1456     _isPublicMintEnabled = false;
1457     _freeSupply = 0;
1458   }
1459 
1460   /**
1461   * @dev Changes contract state to enable public access to `mintTokens` function
1462   * Can only be called by the current owner.
1463   */
1464   function allowPublicMint()
1465   public
1466   onlyOwner{
1467     _isPublicMintEnabled = true;
1468   }
1469 
1470   /**
1471   * @dev Changes contract state to disable public access to `mintTokens` function
1472   * Can only be called by the current owner.
1473   */
1474   function denyPublicMint()
1475   public
1476   onlyOwner{
1477     _isPublicMintEnabled = false;
1478   }
1479 
1480   /**
1481   * @dev Mint `count` tokens if requirements are satisfied.
1482   * 
1483   */
1484   function mintTokens(uint256 count)
1485   public
1486   payable
1487   nonReentrant{
1488     require(_isPublicMintEnabled, "Mint disabled");
1489     require(count > 0 && count <= 100, "You can drop minimum 1, maximum 100 NFTs");
1490     require(count.add(totalSupply()) < (_maxSupply+1), "Exceeds max supply");
1491     require(owner() == msg.sender || msg.value >= _mintCost.mul(count),
1492            "Ether value sent is below the price");
1493     
1494     _mint(msg.sender, count);
1495   }
1496 
1497   /**
1498   * @dev Mint a token to each Address of `recipients`.
1499   * Can only be called if requirements are satisfied.
1500   */
1501   function mintTokens(address[] calldata recipients)
1502   public
1503   payable
1504   nonReentrant{
1505     require(recipients.length>0,"Missing recipient addresses");
1506     require(owner() == msg.sender || _isPublicMintEnabled, "Mint disabled");
1507     require(recipients.length > 0 && recipients.length <= 100, "You can drop minimum 1, maximum 100 NFTs");
1508     require(recipients.length.add(totalSupply()) < (_maxSupply+1), "Exceeds max supply");
1509     require(owner() == msg.sender || msg.value >= _mintCost.mul(recipients.length),
1510            "Ether value sent is below the price");
1511     for(uint i=0; i<recipients.length; i++){
1512         _mint(recipients[i], 1);
1513      }
1514   }
1515 
1516   /**
1517   * @dev Mint `count` tokens if requirements are satisfied.
1518   */
1519   function freeMint(uint256 count) 
1520   public 
1521   payable 
1522   nonReentrant{
1523     require(owner() == msg.sender || _isPublicMintEnabled, "Mint disabled");
1524     require(totalSupply() + count <= _freeSupply, "Exceed max free supply");
1525     require(count == 1, "Cant mint more than 1");
1526     require(count > 0, "Must mint at least 1 token");
1527 
1528     _safeMint(msg.sender, count);
1529   }
1530 
1531   /**
1532   * @dev Update the cost to mint a token.
1533   * Can only be called by the current owner.
1534   */
1535   function setCost(uint256 cost) public onlyOwner{
1536     _mintCost = cost;
1537   }
1538 
1539   /**
1540   * @dev Update the max supply.
1541   * Can only be called by the current owner.
1542   */
1543   function setMaxSupply(uint256 max) public onlyOwner{
1544     _maxSupply = max;
1545   }
1546 
1547   /**
1548   * @dev Update the max free supply.
1549   * Can only be called by the current owner.
1550   */
1551   function setFreeSupply(uint256 max) public onlyOwner{
1552     _freeSupply = max;
1553   }
1554 
1555   /**
1556   * @dev Transfers contract balance to contract owner.
1557   * Can only be called by the current owner.
1558   */
1559   function withdraw() public onlyOwner{
1560     payable(owner()).transfer(address(this).balance);
1561   }
1562 
1563   /**
1564   * @dev Used by public mint functions and by owner functions.
1565   * Can only be called internally by other functions.
1566   */
1567   function _mint(address to, uint256 count) internal virtual returns (uint256){
1568     _safeMint(to, count);
1569 
1570     return count;
1571   }
1572 
1573   function getCost() public view returns (uint256){
1574     return _mintCost;
1575   }
1576   function getMaxSupply() public view returns (uint256){
1577     return _maxSupply;
1578   }
1579   function getCurrentSupply() public view returns (uint256){
1580     return totalSupply();
1581   }
1582   function getMintStatus() public view returns (bool) {
1583     return _isPublicMintEnabled;
1584   }
1585   function getFreeSupply() public view returns (uint256) {
1586     return _freeSupply;
1587   }
1588   function _baseURI() override internal pure returns (string memory) {
1589     return "https://mw9spidhbc.execute-api.us-east-1.amazonaws.com/dev/token/sekushi-girls/";
1590   }
1591   function contractURI() public pure returns (string memory) {
1592     return "https://mw9spidhbc.execute-api.us-east-1.amazonaws.com/dev/contract/sekushi-girls";
1593   }
1594 }