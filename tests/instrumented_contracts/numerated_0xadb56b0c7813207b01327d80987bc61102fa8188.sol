1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
8 pragma solidity ^0.8.0;
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
31 pragma solidity ^0.8.0;
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(
80         address from,
81         address to,
82         uint256 tokenId
83     ) external;
84 
85     /**
86      * @dev Transfers `tokenId` token from `from` to `to`.
87      *
88      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
89      *
90      * Requirements:
91      *
92      * - `from` cannot be the zero address.
93      * - `to` cannot be the zero address.
94      * - `tokenId` token must be owned by `from`.
95      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
107      * The approval is cleared when the token is transferred.
108      *
109      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
110      *
111      * Requirements:
112      *
113      * - The caller must own the token or be an approved operator.
114      * - `tokenId` must exist.
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address to, uint256 tokenId) external;
119 
120     /**
121      * @dev Returns the account approved for `tokenId` token.
122      *
123      * Requirements:
124      *
125      * - `tokenId` must exist.
126      */
127     function getApproved(uint256 tokenId) external view returns (address operator);
128 
129     /**
130      * @dev Approve or remove `operator` as an operator for the caller.
131      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
132      *
133      * Requirements:
134      *
135      * - The `operator` cannot be the caller.
136      *
137      * Emits an {ApprovalForAll} event.
138      */
139     function setApprovalForAll(address operator, bool _approved) external;
140 
141     /**
142      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
143      *
144      * See {setApprovalForAll}
145      */
146     function isApprovedForAll(address owner, address operator) external view returns (bool);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 }
168 
169 
170 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
171 pragma solidity ^0.8.0;
172 /**
173  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
174  * @dev See https://eips.ethereum.org/EIPS/eip-721
175  */
176 interface IERC721Enumerable is IERC721 {
177     /**
178      * @dev Returns the total amount of tokens stored by the contract.
179      */
180     function totalSupply() external view returns (uint256);
181 
182     /**
183      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
184      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
185      */
186     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
187 
188     /**
189      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
190      * Use along with {totalSupply} to enumerate all tokens.
191      */
192     function tokenByIndex(uint256 index) external view returns (uint256);
193 }
194 
195 
196 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
197 pragma solidity ^0.8.0;
198 /**
199  * @dev Implementation of the {IERC165} interface.
200  *
201  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
202  * for the additional interface id that will be supported. For example:
203  *
204  * ```solidity
205  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
206  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
207  * }
208  * ```
209  *
210  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
211  */
212 abstract contract ERC165 is IERC165 {
213     /**
214      * @dev See {IERC165-supportsInterface}.
215      */
216     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217         return interfaceId == type(IERC165).interfaceId;
218     }
219 }
220 
221 // File: @openzeppelin/contracts/utils/Strings.sol
222 
223 
224 
225 pragma solidity ^0.8.0;
226 
227 /**
228  * @dev String operations.
229  */
230 library Strings {
231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
232 
233     /**
234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
235      */
236     function toString(uint256 value) internal pure returns (string memory) {
237         // Inspired by OraclizeAPI's implementation - MIT licence
238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
239 
240         if (value == 0) {
241             return "0";
242         }
243         uint256 temp = value;
244         uint256 digits;
245         while (temp != 0) {
246             digits++;
247             temp /= 10;
248         }
249         bytes memory buffer = new bytes(digits);
250         while (value != 0) {
251             digits -= 1;
252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
253             value /= 10;
254         }
255         return string(buffer);
256     }
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
260      */
261     function toHexString(uint256 value) internal pure returns (string memory) {
262         if (value == 0) {
263             return "0x00";
264         }
265         uint256 temp = value;
266         uint256 length = 0;
267         while (temp != 0) {
268             length++;
269             temp >>= 8;
270         }
271         return toHexString(value, length);
272     }
273 
274     /**
275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
276      */
277     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
278         bytes memory buffer = new bytes(2 * length + 2);
279         buffer[0] = "0";
280         buffer[1] = "x";
281         for (uint256 i = 2 * length + 1; i > 1; --i) {
282             buffer[i] = _HEX_SYMBOLS[value & 0xf];
283             value >>= 4;
284         }
285         require(value == 0, "Strings: hex length insufficient");
286         return string(buffer);
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Address.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         assembly {
324             size := extcodesize(account)
325         }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{value: amount}("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain `call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.call{value: value}(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
510 
511 
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
518  * @dev See https://eips.ethereum.org/EIPS/eip-721
519  */
520 interface IERC721Metadata is IERC721 {
521     /**
522      * @dev Returns the token collection name.
523      */
524     function name() external view returns (string memory);
525 
526     /**
527      * @dev Returns the token collection symbol.
528      */
529     function symbol() external view returns (string memory);
530 
531     /**
532      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
533      */
534     function tokenURI(uint256 tokenId) external view returns (string memory);
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
538 
539 
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @title ERC721 token receiver interface
545  * @dev Interface for any contract that wants to support safeTransfers
546  * from ERC721 asset contracts.
547  */
548 interface IERC721Receiver {
549     /**
550      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
551      * by `operator` from `from`, this function is called.
552      *
553      * It must return its Solidity selector to confirm the token transfer.
554      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
555      *
556      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
557      */
558     function onERC721Received(
559         address operator,
560         address from,
561         uint256 tokenId,
562         bytes calldata data
563     ) external returns (bytes4);
564 }
565 
566 // File: @openzeppelin/contracts/utils/Context.sol
567 pragma solidity ^0.8.0;
568 /**
569  * @dev Provides information about the current execution context, including the
570  * sender of the transaction and its data. While these are generally available
571  * via msg.sender and msg.data, they should not be accessed in such a direct
572  * manner, since when dealing with meta-transactions the account sending and
573  * paying for execution may not be the actual sender (as far as an application
574  * is concerned).
575  *
576  * This contract is only required for intermediate, library-like contracts.
577  */
578 abstract contract Context {
579     function _msgSender() internal view virtual returns (address) {
580         return msg.sender;
581     }
582 
583     function _msgData() internal view virtual returns (bytes calldata) {
584         return msg.data;
585     }
586 }
587 
588 
589 // Creator: Chiru Labs
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
596  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
597  *
598  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
599  *
600  * Does not support burning tokens to address(0).
601  *
602  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
603  */
604 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
605     using Address for address;
606     using Strings for uint256;
607 
608     struct TokenOwnership {
609         address addr;
610         uint64 startTimestamp;
611     }
612 
613     struct AddressData {
614         uint128 balance;
615         uint128 numberMinted;
616     }
617 
618     uint256 internal currentIndex;
619 
620     // Token name
621     string private _name;
622 
623     // Token symbol
624     string private _symbol;
625 
626     // Mapping from token ID to ownership details
627     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
628     mapping(uint256 => TokenOwnership) internal _ownerships;
629 
630     // Mapping owner address to address data
631     mapping(address => AddressData) private _addressData;
632 
633     // Mapping from token ID to approved address
634     mapping(uint256 => address) private _tokenApprovals;
635 
636     // Mapping from owner to operator approvals
637     mapping(address => mapping(address => bool)) private _operatorApprovals;
638 
639     constructor(string memory name_, string memory symbol_) {
640         _name = name_;
641         _symbol = symbol_;
642     }
643 
644     /**
645      * @dev See {IERC721Enumerable-totalSupply}.
646      */
647     function totalSupply() public view override returns (uint256) {
648         return currentIndex;
649     }
650 
651     /**
652      * @dev See {IERC721Enumerable-tokenByIndex}.
653      */
654     function tokenByIndex(uint256 index) public view override returns (uint256) {
655         require(index < totalSupply(), 'ERC721A: global index out of bounds');
656         return index;
657     }
658 
659     /**
660      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
661      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
662      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
663      */
664     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
665         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
666         uint256 numMintedSoFar = totalSupply();
667         uint256 tokenIdsIdx;
668         address currOwnershipAddr;
669 
670         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
671         unchecked {
672             for (uint256 i; i < numMintedSoFar; i++) {
673                 TokenOwnership memory ownership = _ownerships[i];
674                 if (ownership.addr != address(0)) {
675                     currOwnershipAddr = ownership.addr;
676                 }
677                 if (currOwnershipAddr == owner) {
678                     if (tokenIdsIdx == index) {
679                         return i;
680                     }
681                     tokenIdsIdx++;
682                 }
683             }
684         }
685 
686         revert('ERC721A: unable to get token of owner by index');
687     }
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
693         return
694             interfaceId == type(IERC721).interfaceId ||
695             interfaceId == type(IERC721Metadata).interfaceId ||
696             interfaceId == type(IERC721Enumerable).interfaceId ||
697             super.supportsInterface(interfaceId);
698     }
699 
700     /**
701      * @dev See {IERC721-balanceOf}.
702      */
703     function balanceOf(address owner) public view override returns (uint256) {
704         require(owner != address(0), 'ERC721A: balance query for the zero address');
705         return uint256(_addressData[owner].balance);
706     }
707 
708     function _numberMinted(address owner) internal view returns (uint256) {
709         require(owner != address(0), 'ERC721A: number minted query for the zero address');
710         return uint256(_addressData[owner].numberMinted);
711     }
712 
713     /**
714      * Gas spent here starts off proportional to the maximum mint batch size.
715      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
716      */
717     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
718         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
719 
720         unchecked {
721             for (uint256 curr = tokenId; curr >= 0; curr--) {
722                 TokenOwnership memory ownership = _ownerships[curr];
723                 if (ownership.addr != address(0)) {
724                     return ownership;
725                 }
726             }
727         }
728 
729         revert('ERC721A: unable to determine the owner of token');
730     }
731 
732     /**
733      * @dev See {IERC721-ownerOf}.
734      */
735     function ownerOf(uint256 tokenId) public view override returns (address) {
736         return ownershipOf(tokenId).addr;
737     }
738 
739     /**
740      * @dev See {IERC721Metadata-name}.
741      */
742     function name() public view virtual override returns (string memory) {
743         return _name;
744     }
745 
746     /**
747      * @dev See {IERC721Metadata-symbol}.
748      */
749     function symbol() public view virtual override returns (string memory) {
750         return _symbol;
751     }
752 
753     /**
754      * @dev See {IERC721Metadata-tokenURI}.
755      */
756     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
757         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
758 
759         string memory baseURI = _baseURI();
760         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
761     }
762 
763     /**
764      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
765      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
766      * by default, can be overriden in child contracts.
767      */
768     function _baseURI() internal view virtual returns (string memory) {
769         return '';
770     }
771 
772     /**
773      * @dev See {IERC721-approve}.
774      */
775     function approve(address to, uint256 tokenId) public override {
776         address owner = ERC721A.ownerOf(tokenId);
777         require(to != owner, 'ERC721A: approval to current owner');
778 
779         require(
780             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
781             'ERC721A: approve caller is not owner nor approved for all'
782         );
783 
784         _approve(to, tokenId, owner);
785     }
786 
787     /**
788      * @dev See {IERC721-getApproved}.
789      */
790     function getApproved(uint256 tokenId) public view override returns (address) {
791         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
792 
793         return _tokenApprovals[tokenId];
794     }
795 
796     /**
797      * @dev See {IERC721-setApprovalForAll}.
798      */
799     function setApprovalForAll(address operator, bool approved) public override {
800         require(operator != _msgSender(), 'ERC721A: approve to caller');
801 
802         _operatorApprovals[_msgSender()][operator] = approved;
803         emit ApprovalForAll(_msgSender(), operator, approved);
804     }
805 
806     /**
807      * @dev See {IERC721-isApprovedForAll}.
808      */
809     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
810         return _operatorApprovals[owner][operator];
811     }
812 
813     /**
814      * @dev See {IERC721-transferFrom}.
815      */
816     function transferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public override {
821         _transfer(from, to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public override {
832         safeTransferFrom(from, to, tokenId, '');
833     }
834 
835     /**
836      * @dev See {IERC721-safeTransferFrom}.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) public override {
844         _transfer(from, to, tokenId);
845         require(
846             _checkOnERC721Received(from, to, tokenId, _data),
847             'ERC721A: transfer to non ERC721Receiver implementer'
848         );
849     }
850 
851     /**
852      * @dev Returns whether `tokenId` exists.
853      *
854      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
855      *
856      * Tokens start existing when they are minted (`_mint`),
857      */
858     function _exists(uint256 tokenId) internal view returns (bool) {
859         return tokenId < currentIndex;
860     }
861 
862     function _safeMint(address to, uint256 quantity) internal {
863         _safeMint(to, quantity, '');
864     }
865 
866     /**
867      * @dev Safely mints `quantity` tokens and transfers them to `to`.
868      *
869      * Requirements:
870      *
871      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
872      * - `quantity` must be greater than 0.
873      *
874      * Emits a {Transfer} event.
875      */
876     function _safeMint(
877         address to,
878         uint256 quantity,
879         bytes memory _data
880     ) internal {
881         _mint(to, quantity, _data, true);
882     }
883 
884     /**
885      * @dev Mints `quantity` tokens and transfers them to `to`.
886      *
887      * Requirements:
888      *
889      * - `to` cannot be the zero address.
890      * - `quantity` must be greater than 0.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _mint(
895         address to,
896         uint256 quantity,
897         bytes memory _data,
898         bool safe
899     ) internal {
900         uint256 startTokenId = currentIndex;
901         require(to != address(0), 'ERC721A: mint to the zero address');
902         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
903 
904         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
905 
906         // Overflows are incredibly unrealistic.
907         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
908         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
909         unchecked {
910             _addressData[to].balance += uint128(quantity);
911             _addressData[to].numberMinted += uint128(quantity);
912 
913             _ownerships[startTokenId].addr = to;
914             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
915 
916             uint256 updatedIndex = startTokenId;
917 
918             for (uint256 i; i < quantity; i++) {
919                 emit Transfer(address(0), to, updatedIndex);
920                 if (safe) {
921                     require(
922                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
923                         'ERC721A: transfer to non ERC721Receiver implementer'
924                     );
925                 }
926 
927                 updatedIndex++;
928             }
929 
930             currentIndex = updatedIndex;
931         }
932 
933         _afterTokenTransfers(address(0), to, startTokenId, quantity);
934     }
935 
936     /**
937      * @dev Transfers `tokenId` from `from` to `to`.
938      *
939      * Requirements:
940      *
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must be owned by `from`.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _transfer(
947         address from,
948         address to,
949         uint256 tokenId
950     ) private {
951         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
952 
953         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
954             getApproved(tokenId) == _msgSender() ||
955             isApprovedForAll(prevOwnership.addr, _msgSender()));
956 
957         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
958 
959         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
960         require(to != address(0), 'ERC721A: transfer to the zero address');
961 
962         _beforeTokenTransfers(from, to, tokenId, 1);
963 
964         // Clear approvals from the previous owner
965         _approve(address(0), tokenId, prevOwnership.addr);
966 
967         // Underflow of the sender's balance is impossible because we check for
968         // ownership above and the recipient's balance can't realistically overflow.
969         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
970         unchecked {
971             _addressData[from].balance -= 1;
972             _addressData[to].balance += 1;
973 
974             _ownerships[tokenId].addr = to;
975             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
976 
977             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
978             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
979             uint256 nextTokenId = tokenId + 1;
980             if (_ownerships[nextTokenId].addr == address(0)) {
981                 if (_exists(nextTokenId)) {
982                     _ownerships[nextTokenId].addr = prevOwnership.addr;
983                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
984                 }
985             }
986         }
987 
988         emit Transfer(from, to, tokenId);
989         _afterTokenTransfers(from, to, tokenId, 1);
990     }
991 
992     /**
993      * @dev Approve `to` to operate on `tokenId`
994      *
995      * Emits a {Approval} event.
996      */
997     function _approve(
998         address to,
999         uint256 tokenId,
1000         address owner
1001     ) private {
1002         _tokenApprovals[tokenId] = to;
1003         emit Approval(owner, to, tokenId);
1004     }
1005 
1006     /**
1007      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1008      * The call is not executed if the target address is not a contract.
1009      *
1010      * @param from address representing the previous owner of the given token ID
1011      * @param to target address that will receive the tokens
1012      * @param tokenId uint256 ID of the token to be transferred
1013      * @param _data bytes optional data to send along with the call
1014      * @return bool whether the call correctly returned the expected magic value
1015      */
1016     function _checkOnERC721Received(
1017         address from,
1018         address to,
1019         uint256 tokenId,
1020         bytes memory _data
1021     ) private returns (bool) {
1022         if (to.isContract()) {
1023             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1024                 return retval == IERC721Receiver(to).onERC721Received.selector;
1025             } catch (bytes memory reason) {
1026                 if (reason.length == 0) {
1027                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1028                 } else {
1029                     assembly {
1030                         revert(add(32, reason), mload(reason))
1031                     }
1032                 }
1033             }
1034         } else {
1035             return true;
1036         }
1037     }
1038 
1039     /**
1040      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1041      *
1042      * startTokenId - the first token id to be transferred
1043      * quantity - the amount to be transferred
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      */
1051     function _beforeTokenTransfers(
1052         address from,
1053         address to,
1054         uint256 startTokenId,
1055         uint256 quantity
1056     ) internal virtual {}
1057 
1058     /**
1059      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1060      * minting.
1061      *
1062      * startTokenId - the first token id to be transferred
1063      * quantity - the amount to be transferred
1064      *
1065      * Calling conditions:
1066      *
1067      * - when `from` and `to` are both non-zero.
1068      * - `from` and `to` are never both zero.
1069      */
1070     function _afterTokenTransfers(
1071         address from,
1072         address to,
1073         uint256 startTokenId,
1074         uint256 quantity
1075     ) internal virtual {}
1076 }
1077 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1078 
1079 
1080 
1081 
1082 
1083 // File: @openzeppelin/contracts/access/Ownable.sol
1084 pragma solidity ^0.8.0;
1085 /**
1086  * @dev Contract module which provides a basic access control mechanism, where
1087  * there is an account (an owner) that can be granted exclusive access to
1088  * specific functions.
1089  *
1090  * By default, the owner account will be the one that deploys the contract. This
1091  * can later be changed with {transferOwnership}.
1092  *
1093  * This module is used through inheritance. It will make available the modifier
1094  * `onlyOwner`, which can be applied to your functions to restrict their use to
1095  * the owner.
1096  */
1097 abstract contract Ownable is Context {
1098     address private _owner;
1099 
1100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1101 
1102     /**
1103      * @dev Initializes the contract setting the deployer as the initial owner.
1104      */
1105     constructor() {
1106         _setOwner(_msgSender());
1107     }
1108 
1109     /**
1110      * @dev Returns the address of the current owner.
1111      */
1112     function owner() public view virtual returns (address) {
1113         return _owner;
1114     }
1115 
1116     /**
1117      * @dev Throws if called by any account other than the owner.
1118      */
1119     modifier onlyOwner() {
1120         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1121         _;
1122     }
1123 
1124     /**
1125      * @dev Leaves the contract without owner. It will not be possible to call
1126      * `onlyOwner` functions anymore. Can only be called by the current owner.
1127      *
1128      * NOTE: Renouncing ownership will leave the contract without an owner,
1129      * thereby removing any functionality that is only available to the owner.
1130      */
1131     function renounceOwnership() public virtual onlyOwner {
1132         _setOwner(address(0));
1133     }
1134 
1135     /**
1136      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1137      * Can only be called by the current owner.
1138      */
1139     function transferOwnership(address newOwner) public virtual onlyOwner {
1140         require(newOwner != address(0), "Ownable: new owner is the zero address");
1141         _setOwner(newOwner);
1142     }
1143 
1144     function _setOwner(address newOwner) private {
1145         address oldOwner = _owner;
1146         _owner = newOwner;
1147         emit OwnershipTransferred(oldOwner, newOwner);
1148     }
1149 }
1150 
1151 pragma solidity >=0.7.0 <0.9.0;
1152 
1153 contract CreepyGF is ERC721A, Ownable {
1154   using Strings for uint256;
1155 
1156   string baseURI;
1157   string public baseExtension = ".json";
1158   uint256 public cost = 0.009 ether;
1159   uint256 public maxSupply = 2222;
1160   uint256 public maxMintAmount = 10;
1161   uint256 public maxFREEMintAmount = 3;
1162   uint256 public FREEnftPerAddressLimit = 3;
1163   uint256 public FREE_MAX_SUPPLY = 1000;
1164   bool public paused = true;
1165 
1166   constructor(
1167     string memory _name,
1168     string memory _symbol,
1169     string memory _initBaseURI
1170   ) ERC721A(_name, _symbol) {
1171     setBaseURI(_initBaseURI);
1172   }
1173 
1174   // internal
1175   function _baseURI() internal view virtual override returns (string memory) {
1176     return baseURI;
1177   }
1178 
1179   // public
1180   function mint(uint256 _mintAmount) public payable {
1181     require(!paused, "the contract is paused");
1182     uint256 supply = totalSupply();
1183     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1184 
1185     if (msg.sender != owner()) {
1186         if (FREE_MAX_SUPPLY >= supply + _mintAmount) {
1187             require(_mintAmount <= maxFREEMintAmount, "max mint amount per session exceeded");
1188             require(numberMinted(msg.sender) + _mintAmount <= FREEnftPerAddressLimit, "max NFT per address exceeded");
1189         } else {
1190             require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1191             require(msg.value >= _mintAmount * cost, "Invalid funds provided");
1192         }
1193     }
1194     _safeMint(msg.sender, _mintAmount);
1195     
1196   }
1197 
1198 
1199   function numberMinted(address owner) public view returns (uint256) {
1200     return _numberMinted(owner);
1201   }
1202 
1203   function tokenURI(uint256 tokenId)
1204     public
1205     view
1206     virtual
1207     override
1208     returns (string memory)
1209   {
1210     require(
1211       _exists(tokenId),
1212       "ERC721Metadata: URI query for nonexistent token"
1213     );
1214 
1215     string memory currentBaseURI = _baseURI();
1216     return bytes(currentBaseURI).length > 0
1217         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1218         : "";
1219   }
1220 
1221   //only owner
1222 
1223 
1224   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1225     FREEnftPerAddressLimit = _limit;
1226   }
1227 
1228   function setFreeMaxSupply(uint256 _FreeMaxAmount) public onlyOwner {
1229     FREE_MAX_SUPPLY = _FreeMaxAmount;
1230   }
1231   
1232   function setCost(uint256 _newCost) public onlyOwner {
1233     cost = _newCost;
1234   }
1235 
1236   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1237     maxMintAmount = _newmaxMintAmount;
1238   }
1239 
1240   function setFreeMaxMintAmount(uint256 _newFreeMaxMintAmount) public onlyOwner {
1241     maxFREEMintAmount = _newFreeMaxMintAmount;
1242     FREEnftPerAddressLimit = _newFreeMaxMintAmount;
1243   }
1244 
1245   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1246     baseURI = _newBaseURI;
1247   }
1248 
1249   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1250     baseExtension = _newBaseExtension;
1251   }
1252 
1253   function pause(bool _state) public onlyOwner {
1254     paused = _state;
1255   }
1256  
1257   function withdraw() public payable onlyOwner {
1258     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1259     require(os);
1260   }
1261 }