1 // File: ThePartnersNFT.sol
2 
3 
4 
5 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 pragma solidity ^0.8.0;
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 pragma solidity ^0.8.0;
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 
168 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
169 pragma solidity ^0.8.0;
170 /**
171  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
172  * @dev See https://eips.ethereum.org/EIPS/eip-721
173  */
174 interface IERC721Enumerable is IERC721 {
175     /**
176      * @dev Returns the total amount of tokens stored by the contract.
177      */
178     function totalSupply() external view returns (uint256);
179 
180     /**
181      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
182      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
183      */
184     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
185 
186     /**
187      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
188      * Use along with {totalSupply} to enumerate all tokens.
189      */
190     function tokenByIndex(uint256 index) external view returns (uint256);
191 }
192 
193 
194 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
195 pragma solidity ^0.8.0;
196 /**
197  * @dev Implementation of the {IERC165} interface.
198  *
199  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
200  * for the additional interface id that will be supported. For example:
201  *
202  * ```solidity
203  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
204  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
205  * }
206  * ```
207  *
208  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
209  */
210 abstract contract ERC165 is IERC165 {
211     /**
212      * @dev See {IERC165-supportsInterface}.
213      */
214     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
215         return interfaceId == type(IERC165).interfaceId;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Strings.sol
220 
221 
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev String operations.
227  */
228 library Strings {
229     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
233      */
234     function toString(uint256 value) internal pure returns (string memory) {
235         // Inspired by OraclizeAPI's implementation - MIT licence
236         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
237 
238         if (value == 0) {
239             return "0";
240         }
241         uint256 temp = value;
242         uint256 digits;
243         while (temp != 0) {
244             digits++;
245             temp /= 10;
246         }
247         bytes memory buffer = new bytes(digits);
248         while (value != 0) {
249             digits -= 1;
250             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
251             value /= 10;
252         }
253         return string(buffer);
254     }
255 
256     /**
257      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
258      */
259     function toHexString(uint256 value) internal pure returns (string memory) {
260         if (value == 0) {
261             return "0x00";
262         }
263         uint256 temp = value;
264         uint256 length = 0;
265         while (temp != 0) {
266             length++;
267             temp >>= 8;
268         }
269         return toHexString(value, length);
270     }
271 
272     /**
273      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
274      */
275     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
276         bytes memory buffer = new bytes(2 * length + 2);
277         buffer[0] = "0";
278         buffer[1] = "x";
279         for (uint256 i = 2 * length + 1; i > 1; --i) {
280             buffer[i] = _HEX_SYMBOLS[value & 0xf];
281             value >>= 4;
282         }
283         require(value == 0, "Strings: hex length insufficient");
284         return string(buffer);
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Address.sol
289 
290 
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      */
315     function isContract(address account) internal view returns (bool) {
316         // This method relies on extcodesize, which returns 0 for contracts in
317         // construction, since the code is only stored at the end of the
318         // constructor execution.
319 
320         uint256 size;
321         assembly {
322             size := extcodesize(account)
323         }
324         return size > 0;
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      */
343     function sendValue(address payable recipient, uint256 amount) internal {
344         require(address(this).balance >= amount, "Address: insufficient balance");
345 
346         (bool success, ) = recipient.call{value: amount}("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 
350     /**
351      * @dev Performs a Solidity function call using a low level `call`. A
352      * plain `call` is an unsafe replacement for a function call: use this
353      * function instead.
354      *
355      * If `target` reverts with a revert reason, it is bubbled up by this
356      * function (like regular Solidity function calls).
357      *
358      * Returns the raw returned data. To convert to the expected return value,
359      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
360      *
361      * Requirements:
362      *
363      * - `target` must be a contract.
364      * - calling `target` with `data` must not revert.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
369         return functionCall(target, data, "Address: low-level call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
374      * `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(
379         address target,
380         bytes memory data,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, 0, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but also transferring `value` wei to `target`.
389      *
390      * Requirements:
391      *
392      * - the calling contract must have an ETH balance of at least `value`.
393      * - the called Solidity function must be `payable`.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(address(this).balance >= value, "Address: insufficient balance for call");
418         require(isContract(target), "Address: call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.call{value: value}(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
431         return functionStaticCall(target, data, "Address: low-level static call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal view returns (bytes memory) {
445         require(isContract(target), "Address: static call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.staticcall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         require(isContract(target), "Address: delegate call to non-contract");
473 
474         (bool success, bytes memory returndata) = target.delegatecall(data);
475         return verifyCallResult(success, returndata, errorMessage);
476     }
477 
478     /**
479      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
480      * revert reason using the provided one.
481      *
482      * _Available since v4.3._
483      */
484     function verifyCallResult(
485         bool success,
486         bytes memory returndata,
487         string memory errorMessage
488     ) internal pure returns (bytes memory) {
489         if (success) {
490             return returndata;
491         } else {
492             // Look for revert reason and bubble it up if present
493             if (returndata.length > 0) {
494                 // The easiest way to bubble the revert reason is using memory via assembly
495 
496                 assembly {
497                     let returndata_size := mload(returndata)
498                     revert(add(32, returndata), returndata_size)
499                 }
500             } else {
501                 revert(errorMessage);
502             }
503         }
504     }
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
508 
509 
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
516  * @dev See https://eips.ethereum.org/EIPS/eip-721
517  */
518 interface IERC721Metadata is IERC721 {
519     /**
520      * @dev Returns the token collection name.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the token collection symbol.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
531      */
532     function tokenURI(uint256 tokenId) external view returns (string memory);
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @title ERC721 token receiver interface
543  * @dev Interface for any contract that wants to support safeTransfers
544  * from ERC721 asset contracts.
545  */
546 interface IERC721Receiver {
547     /**
548      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
549      * by `operator` from `from`, this function is called.
550      *
551      * It must return its Solidity selector to confirm the token transfer.
552      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
553      *
554      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
555      */
556     function onERC721Received(
557         address operator,
558         address from,
559         uint256 tokenId,
560         bytes calldata data
561     ) external returns (bytes4);
562 }
563 
564 // File: @openzeppelin/contracts/utils/Context.sol
565 pragma solidity ^0.8.0;
566 /**
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 abstract contract Context {
577     function _msgSender() internal view virtual returns (address) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view virtual returns (bytes calldata) {
582         return msg.data;
583     }
584 }
585 
586 
587 // Creator: Chiru Labs
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
594  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
595  *
596  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
597  *
598  * Does not support burning tokens to address(0).
599  *
600  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
601  */
602 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
603     using Address for address;
604     using Strings for uint256;
605 
606     struct TokenOwnership {
607         address addr;
608         uint64 startTimestamp;
609     }
610 
611     struct AddressData {
612         uint128 balance;
613         uint128 numberMinted;
614     }
615 
616     uint256 internal currentIndex;
617 
618     // Token name
619     string private _name;
620 
621     // Token symbol
622     string private _symbol;
623 
624     // Mapping from token ID to ownership details
625     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
626     mapping(uint256 => TokenOwnership) internal _ownerships;
627 
628     // Mapping owner address to address data
629     mapping(address => AddressData) private _addressData;
630 
631     // Mapping from token ID to approved address
632     mapping(uint256 => address) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     constructor(string memory name_, string memory symbol_) {
638         _name = name_;
639         _symbol = symbol_;
640     }
641 
642     /**
643      * @dev See {IERC721Enumerable-totalSupply}.
644      */
645     function totalSupply() public view override returns (uint256) {
646         return currentIndex;
647     }
648 
649     /**
650      * @dev See {IERC721Enumerable-tokenByIndex}.
651      */
652     function tokenByIndex(uint256 index) public view override returns (uint256) {
653         require(index < totalSupply(), 'ERC721A: global index out of bounds');
654         return index;
655     }
656 
657     /**
658      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
659      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
660      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
661      */
662     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
663         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
664         uint256 numMintedSoFar = totalSupply();
665         uint256 tokenIdsIdx;
666         address currOwnershipAddr;
667 
668         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
669         unchecked {
670             for (uint256 i; i < numMintedSoFar; i++) {
671                 TokenOwnership memory ownership = _ownerships[i];
672                 if (ownership.addr != address(0)) {
673                     currOwnershipAddr = ownership.addr;
674                 }
675                 if (currOwnershipAddr == owner) {
676                     if (tokenIdsIdx == index) {
677                         return i;
678                     }
679                     tokenIdsIdx++;
680                 }
681             }
682         }
683 
684         revert('ERC721A: unable to get token of owner by index');
685     }
686 
687     /**
688      * @dev See {IERC165-supportsInterface}.
689      */
690     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
691         return
692             interfaceId == type(IERC721).interfaceId ||
693             interfaceId == type(IERC721Metadata).interfaceId ||
694             interfaceId == type(IERC721Enumerable).interfaceId ||
695             super.supportsInterface(interfaceId);
696     }
697 
698     /**
699      * @dev See {IERC721-balanceOf}.
700      */
701     function balanceOf(address owner) public view override returns (uint256) {
702         require(owner != address(0), 'ERC721A: balance query for the zero address');
703         return uint256(_addressData[owner].balance);
704     }
705 
706     function _numberMinted(address owner) internal view returns (uint256) {
707         require(owner != address(0), 'ERC721A: number minted query for the zero address');
708         return uint256(_addressData[owner].numberMinted);
709     }
710 
711     /**
712      * Gas spent here starts off proportional to the maximum mint batch size.
713      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
714      */
715     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
716         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
717 
718         unchecked {
719             for (uint256 curr = tokenId; curr >= 0; curr--) {
720                 TokenOwnership memory ownership = _ownerships[curr];
721                 if (ownership.addr != address(0)) {
722                     return ownership;
723                 }
724             }
725         }
726 
727         revert('ERC721A: unable to determine the owner of token');
728     }
729 
730     /**
731      * @dev See {IERC721-ownerOf}.
732      */
733     function ownerOf(uint256 tokenId) public view override returns (address) {
734         return ownershipOf(tokenId).addr;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-name}.
739      */
740     function name() public view virtual override returns (string memory) {
741         return _name;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-symbol}.
746      */
747     function symbol() public view virtual override returns (string memory) {
748         return _symbol;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-tokenURI}.
753      */
754     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
755         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
756 
757         string memory baseURI = _baseURI();
758         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
759     }
760 
761     /**
762      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
763      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
764      * by default, can be overriden in child contracts.
765      */
766     function _baseURI() internal view virtual returns (string memory) {
767         return '';
768     }
769 
770     /**
771      * @dev See {IERC721-approve}.
772      */
773     function approve(address to, uint256 tokenId) public override {
774         address owner = ERC721A.ownerOf(tokenId);
775         require(to != owner, 'ERC721A: approval to current owner');
776 
777         require(
778             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
779             'ERC721A: approve caller is not owner nor approved for all'
780         );
781 
782         _approve(to, tokenId, owner);
783     }
784 
785     /**
786      * @dev See {IERC721-getApproved}.
787      */
788     function getApproved(uint256 tokenId) public view override returns (address) {
789         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
790 
791         return _tokenApprovals[tokenId];
792     }
793 
794     /**
795      * @dev See {IERC721-setApprovalForAll}.
796      */
797     function setApprovalForAll(address operator, bool approved) public override {
798         require(operator != _msgSender(), 'ERC721A: approve to caller');
799 
800         _operatorApprovals[_msgSender()][operator] = approved;
801         emit ApprovalForAll(_msgSender(), operator, approved);
802     }
803 
804     /**
805      * @dev See {IERC721-isApprovedForAll}.
806      */
807     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
808         return _operatorApprovals[owner][operator];
809     }
810 
811     /**
812      * @dev See {IERC721-transferFrom}.
813      */
814     function transferFrom(
815         address from,
816         address to,
817         uint256 tokenId
818     ) public override {
819         _transfer(from, to, tokenId);
820     }
821 
822     /**
823      * @dev See {IERC721-safeTransferFrom}.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public override {
830         safeTransferFrom(from, to, tokenId, '');
831     }
832 
833     /**
834      * @dev See {IERC721-safeTransferFrom}.
835      */
836     function safeTransferFrom(
837         address from,
838         address to,
839         uint256 tokenId,
840         bytes memory _data
841     ) public override {
842         _transfer(from, to, tokenId);
843         require(
844             _checkOnERC721Received(from, to, tokenId, _data),
845             'ERC721A: transfer to non ERC721Receiver implementer'
846         );
847     }
848 
849     /**
850      * @dev Returns whether `tokenId` exists.
851      *
852      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
853      *
854      * Tokens start existing when they are minted (`_mint`),
855      */
856     function _exists(uint256 tokenId) internal view returns (bool) {
857         return tokenId < currentIndex;
858     }
859 
860     function _safeMint(address to, uint256 quantity) internal {
861         _safeMint(to, quantity, '');
862     }
863 
864     /**
865      * @dev Safely mints `quantity` tokens and transfers them to `to`.
866      *
867      * Requirements:
868      *
869      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
870      * - `quantity` must be greater than 0.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _safeMint(
875         address to,
876         uint256 quantity,
877         bytes memory _data
878     ) internal {
879         _mint(to, quantity, _data, true);
880     }
881 
882     /**
883      * @dev Mints `quantity` tokens and transfers them to `to`.
884      *
885      * Requirements:
886      *
887      * - `to` cannot be the zero address.
888      * - `quantity` must be greater than 0.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _mint(
893         address to,
894         uint256 quantity,
895         bytes memory _data,
896         bool safe
897     ) internal {
898         uint256 startTokenId = currentIndex;
899         require(to != address(0), 'ERC721A: mint to the zero address');
900         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
901 
902         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
903 
904         // Overflows are incredibly unrealistic.
905         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
906         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
907         unchecked {
908             _addressData[to].balance += uint128(quantity);
909             _addressData[to].numberMinted += uint128(quantity);
910 
911             _ownerships[startTokenId].addr = to;
912             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
913 
914             uint256 updatedIndex = startTokenId;
915 
916             for (uint256 i; i < quantity; i++) {
917                 emit Transfer(address(0), to, updatedIndex);
918                 if (safe) {
919                     require(
920                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
921                         'ERC721A: transfer to non ERC721Receiver implementer'
922                     );
923                 }
924 
925                 updatedIndex++;
926             }
927 
928             currentIndex = updatedIndex;
929         }
930 
931         _afterTokenTransfers(address(0), to, startTokenId, quantity);
932     }
933 
934     /**
935      * @dev Transfers `tokenId` from `from` to `to`.
936      *
937      * Requirements:
938      *
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must be owned by `from`.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _transfer(
945         address from,
946         address to,
947         uint256 tokenId
948     ) private {
949         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
950 
951         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
952             getApproved(tokenId) == _msgSender() ||
953             isApprovedForAll(prevOwnership.addr, _msgSender()));
954 
955         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
956 
957         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
958         require(to != address(0), 'ERC721A: transfer to the zero address');
959 
960         _beforeTokenTransfers(from, to, tokenId, 1);
961 
962         // Clear approvals from the previous owner
963         _approve(address(0), tokenId, prevOwnership.addr);
964 
965         // Underflow of the sender's balance is impossible because we check for
966         // ownership above and the recipient's balance can't realistically overflow.
967         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
968         unchecked {
969             _addressData[from].balance -= 1;
970             _addressData[to].balance += 1;
971 
972             _ownerships[tokenId].addr = to;
973             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
974 
975             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
976             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
977             uint256 nextTokenId = tokenId + 1;
978             if (_ownerships[nextTokenId].addr == address(0)) {
979                 if (_exists(nextTokenId)) {
980                     _ownerships[nextTokenId].addr = prevOwnership.addr;
981                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
982                 }
983             }
984         }
985 
986         emit Transfer(from, to, tokenId);
987         _afterTokenTransfers(from, to, tokenId, 1);
988     }
989 
990     /**
991      * @dev Approve `to` to operate on `tokenId`
992      *
993      * Emits a {Approval} event.
994      */
995     function _approve(
996         address to,
997         uint256 tokenId,
998         address owner
999     ) private {
1000         _tokenApprovals[tokenId] = to;
1001         emit Approval(owner, to, tokenId);
1002     }
1003 
1004     /**
1005      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1006      * The call is not executed if the target address is not a contract.
1007      *
1008      * @param from address representing the previous owner of the given token ID
1009      * @param to target address that will receive the tokens
1010      * @param tokenId uint256 ID of the token to be transferred
1011      * @param _data bytes optional data to send along with the call
1012      * @return bool whether the call correctly returned the expected magic value
1013      */
1014     function _checkOnERC721Received(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes memory _data
1019     ) private returns (bool) {
1020         if (to.isContract()) {
1021             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1022                 return retval == IERC721Receiver(to).onERC721Received.selector;
1023             } catch (bytes memory reason) {
1024                 if (reason.length == 0) {
1025                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1026                 } else {
1027                     assembly {
1028                         revert(add(32, reason), mload(reason))
1029                     }
1030                 }
1031             }
1032         } else {
1033             return true;
1034         }
1035     }
1036 
1037     /**
1038      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1039      *
1040      * startTokenId - the first token id to be transferred
1041      * quantity - the amount to be transferred
1042      *
1043      * Calling conditions:
1044      *
1045      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1046      * transferred to `to`.
1047      * - When `from` is zero, `tokenId` will be minted for `to`.
1048      */
1049     function _beforeTokenTransfers(
1050         address from,
1051         address to,
1052         uint256 startTokenId,
1053         uint256 quantity
1054     ) internal virtual {}
1055 
1056     /**
1057      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1058      * minting.
1059      *
1060      * startTokenId - the first token id to be transferred
1061      * quantity - the amount to be transferred
1062      *
1063      * Calling conditions:
1064      *
1065      * - when `from` and `to` are both non-zero.
1066      * - `from` and `to` are never both zero.
1067      */
1068     function _afterTokenTransfers(
1069         address from,
1070         address to,
1071         uint256 startTokenId,
1072         uint256 quantity
1073     ) internal virtual {}
1074 }
1075 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1076 
1077 
1078 
1079 
1080 
1081 // File: @openzeppelin/contracts/access/Ownable.sol
1082 pragma solidity ^0.8.0;
1083 /**
1084  * @dev Contract module which provides a basic access control mechanism, where
1085  * there is an account (an owner) that can be granted exclusive access to
1086  * specific functions.
1087  *
1088  * By default, the owner account will be the one that deploys the contract. This
1089  * can later be changed with {transferOwnership}.
1090  *
1091  * This module is used through inheritance. It will make available the modifier
1092  * `onlyOwner`, which can be applied to your functions to restrict their use to
1093  * the owner.
1094  */
1095 abstract contract Ownable is Context {
1096     address private _owner;
1097 
1098     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1099 
1100     /**
1101      * @dev Initializes the contract setting the deployer as the initial owner.
1102      */
1103     constructor() {
1104         _setOwner(_msgSender());
1105     }
1106 
1107     /**
1108      * @dev Returns the address of the current owner.
1109      */
1110     function owner() public view virtual returns (address) {
1111         return _owner;
1112     }
1113 
1114     /**
1115      * @dev Throws if called by any account other than the owner.
1116      */
1117     modifier onlyOwner() {
1118         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1119         _;
1120     }
1121 
1122     /**
1123      * @dev Leaves the contract without owner. It will not be possible to call
1124      * `onlyOwner` functions anymore. Can only be called by the current owner.
1125      *
1126      * NOTE: Renouncing ownership will leave the contract without an owner,
1127      * thereby removing any functionality that is only available to the owner.
1128      */
1129     function renounceOwnership() public virtual onlyOwner {
1130         _setOwner(address(0));
1131     }
1132 
1133     /**
1134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1135      * Can only be called by the current owner.
1136      */
1137     function transferOwnership(address newOwner) public virtual onlyOwner {
1138         require(newOwner != address(0), "Ownable: new owner is the zero address");
1139         _setOwner(newOwner);
1140     }
1141 
1142     function _setOwner(address newOwner) private {
1143         address oldOwner = _owner;
1144         _owner = newOwner;
1145         emit OwnershipTransferred(oldOwner, newOwner);
1146     }
1147 }
1148 
1149 pragma solidity >=0.7.0 <0.9.0;
1150 
1151 contract ThePartners is ERC721A, Ownable {
1152   using Strings for uint256;
1153 
1154   string baseURI;
1155   string public baseExtension = ".json";
1156   uint256 public cost = 0.009 ether;
1157   uint256 public maxSupply = 2000;
1158   uint256 public maxMintAmount = 10;
1159   uint256 public maxFREEMintAmount = 3;
1160   uint256 public FREEnftPerAddressLimit = 3;
1161   uint256 public FREE_MAX_SUPPLY = 1000;
1162   address[] public whitelistedAddresses;
1163   bool public paused = true;
1164 
1165   constructor(
1166     string memory _name,
1167     string memory _symbol,
1168     string memory _initBaseURI
1169   ) ERC721A(_name, _symbol) {
1170     setBaseURI(_initBaseURI);
1171   }
1172 
1173   // internal
1174   function _baseURI() internal view virtual override returns (string memory) {
1175     return baseURI;
1176   }
1177 
1178   // public
1179   function mint(uint256 _mintAmount) public payable {
1180     require(!paused, "the contract is paused");
1181     uint256 supply = totalSupply();
1182     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1183 
1184     if (msg.sender != owner()) {
1185         if (FREE_MAX_SUPPLY >= supply + _mintAmount) {
1186             require(_mintAmount <= maxFREEMintAmount, "max mint amount per session exceeded");
1187             require(numberMinted(msg.sender) + _mintAmount <= FREEnftPerAddressLimit, "max NFT per address exceeded");
1188         } else {
1189             require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1190             require(msg.value >= _mintAmount * cost, "Invalid funds provided");
1191         }
1192     }
1193     _safeMint(msg.sender, _mintAmount);
1194     
1195   }
1196 
1197   function WLmint(uint256 _mintAmount) public payable {
1198     require(!paused, "the contract is paused");
1199     uint256 supply = totalSupply();
1200     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1201     require(isWhitelisted(msg.sender), "user is not whitelisted");
1202     _safeMint(msg.sender, _mintAmount);
1203     
1204   }
1205 
1206   function isWhitelisted(address _user) public view returns (bool) {
1207     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1208       if (whitelistedAddresses[i] == _user) {
1209           return true;
1210       }
1211     }
1212     return false;
1213   }
1214 
1215 
1216   function numberMinted(address owner) public view returns (uint256) {
1217     return _numberMinted(owner);
1218   }
1219 
1220   function tokenURI(uint256 tokenId)
1221     public
1222     view
1223     virtual
1224     override
1225     returns (string memory)
1226   {
1227     require(
1228       _exists(tokenId),
1229       "ERC721Metadata: URI query for nonexistent token"
1230     );
1231 
1232     string memory currentBaseURI = _baseURI();
1233     return bytes(currentBaseURI).length > 0
1234         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1235         : "";
1236   }
1237 
1238   //only owner
1239 
1240   function whitelistUsers(address[] calldata _users) public onlyOwner {
1241     delete whitelistedAddresses;
1242     whitelistedAddresses = _users;
1243   }
1244 
1245 
1246   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1247     FREEnftPerAddressLimit = _limit;
1248   }
1249 
1250   function setFreeMaxSupply(uint256 _FreeMaxAmount) public onlyOwner {
1251     FREE_MAX_SUPPLY = _FreeMaxAmount;
1252   }
1253   
1254   function setCost(uint256 _newCost) public onlyOwner {
1255     cost = _newCost;
1256   }
1257 
1258   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1259     maxMintAmount = _newmaxMintAmount;
1260   }
1261 
1262   function setFreeMaxMintAmount(uint256 _newFreeMaxMintAmount) public onlyOwner {
1263     maxFREEMintAmount = _newFreeMaxMintAmount;
1264     FREEnftPerAddressLimit = _newFreeMaxMintAmount;
1265   }
1266 
1267   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1268     baseURI = _newBaseURI;
1269   }
1270 
1271   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1272     baseExtension = _newBaseExtension;
1273   }
1274 
1275   function pause(bool _state) public onlyOwner {
1276     paused = _state;
1277   }
1278  
1279   function withdraw() public payable onlyOwner {
1280     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1281     require(os);
1282   }
1283 }