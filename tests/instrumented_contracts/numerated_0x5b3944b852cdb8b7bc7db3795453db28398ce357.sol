1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-04
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
12 pragma solidity ^0.8.0;
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
35 pragma solidity ^0.8.0;
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
175 pragma solidity ^0.8.0;
176 /**
177  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
178  * @dev See https://eips.ethereum.org/EIPS/eip-721
179  */
180 interface IERC721Enumerable is IERC721 {
181     /**
182      * @dev Returns the total amount of tokens stored by the contract.
183      */
184     function totalSupply() external view returns (uint256);
185 
186     /**
187      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
188      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
189      */
190     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
191 
192     /**
193      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
194      * Use along with {totalSupply} to enumerate all tokens.
195      */
196     function tokenByIndex(uint256 index) external view returns (uint256);
197 }
198 
199 
200 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
201 pragma solidity ^0.8.0;
202 /**
203  * @dev Implementation of the {IERC165} interface.
204  *
205  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
206  * for the additional interface id that will be supported. For example:
207  *
208  * ```solidity
209  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
210  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
211  * }
212  * ```
213  *
214  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
215  */
216 abstract contract ERC165 is IERC165 {
217     /**
218      * @dev See {IERC165-supportsInterface}.
219      */
220     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
221         return interfaceId == type(IERC165).interfaceId;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/Strings.sol
226 
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev String operations.
233  */
234 library Strings {
235     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
236 
237     /**
238      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
239      */
240     function toString(uint256 value) internal pure returns (string memory) {
241         // Inspired by OraclizeAPI's implementation - MIT licence
242         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
243 
244         if (value == 0) {
245             return "0";
246         }
247         uint256 temp = value;
248         uint256 digits;
249         while (temp != 0) {
250             digits++;
251             temp /= 10;
252         }
253         bytes memory buffer = new bytes(digits);
254         while (value != 0) {
255             digits -= 1;
256             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
257             value /= 10;
258         }
259         return string(buffer);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
264      */
265     function toHexString(uint256 value) internal pure returns (string memory) {
266         if (value == 0) {
267             return "0x00";
268         }
269         uint256 temp = value;
270         uint256 length = 0;
271         while (temp != 0) {
272             length++;
273             temp >>= 8;
274         }
275         return toHexString(value, length);
276     }
277 
278     /**
279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
280      */
281     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
282         bytes memory buffer = new bytes(2 * length + 2);
283         buffer[0] = "0";
284         buffer[1] = "x";
285         for (uint256 i = 2 * length + 1; i > 1; --i) {
286             buffer[i] = _HEX_SYMBOLS[value & 0xf];
287             value >>= 4;
288         }
289         require(value == 0, "Strings: hex length insufficient");
290         return string(buffer);
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/Address.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Collection of functions related to the address type
302  */
303 library Address {
304     /**
305      * @dev Returns true if `account` is a contract.
306      *
307      * [IMPORTANT]
308      * ====
309      * It is unsafe to assume that an address for which this function returns
310      * false is an externally-owned account (EOA) and not a contract.
311      *
312      * Among others, `isContract` will return false for the following
313      * types of addresses:
314      *
315      *  - an externally-owned account
316      *  - a contract in construction
317      *  - an address where a contract will be created
318      *  - an address where a contract lived, but was destroyed
319      * ====
320      */
321     function isContract(address account) internal view returns (bool) {
322         // This method relies on extcodesize, which returns 0 for contracts in
323         // construction, since the code is only stored at the end of the
324         // constructor execution.
325 
326         uint256 size;
327         assembly {
328             size := extcodesize(account)
329         }
330         return size > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         (bool success, ) = recipient.call{value: amount}("");
353         require(success, "Address: unable to send value, recipient may have reverted");
354     }
355 
356     /**
357      * @dev Performs a Solidity function call using a low level `call`. A
358      * plain `call` is an unsafe replacement for a function call: use this
359      * function instead.
360      *
361      * If `target` reverts with a revert reason, it is bubbled up by this
362      * function (like regular Solidity function calls).
363      *
364      * Returns the raw returned data. To convert to the expected return value,
365      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
366      *
367      * Requirements:
368      *
369      * - `target` must be a contract.
370      * - calling `target` with `data` must not revert.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
375         return functionCall(target, data, "Address: low-level call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
380      * `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 value
407     ) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         require(address(this).balance >= value, "Address: insufficient balance for call");
424         require(isContract(target), "Address: call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.call{value: value}(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
437         return functionStaticCall(target, data, "Address: low-level static call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal view returns (bytes memory) {
451         require(isContract(target), "Address: static call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.staticcall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but performing a delegate call.
460      *
461      * _Available since v3.4._
462      */
463     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
464         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         require(isContract(target), "Address: delegate call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.delegatecall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
486      * revert reason using the provided one.
487      *
488      * _Available since v4.3._
489      */
490     function verifyCallResult(
491         bool success,
492         bytes memory returndata,
493         string memory errorMessage
494     ) internal pure returns (bytes memory) {
495         if (success) {
496             return returndata;
497         } else {
498             // Look for revert reason and bubble it up if present
499             if (returndata.length > 0) {
500                 // The easiest way to bubble the revert reason is using memory via assembly
501 
502                 assembly {
503                     let returndata_size := mload(returndata)
504                     revert(add(32, returndata), returndata_size)
505                 }
506             } else {
507                 revert(errorMessage);
508             }
509         }
510     }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
522  * @dev See https://eips.ethereum.org/EIPS/eip-721
523  */
524 interface IERC721Metadata is IERC721 {
525     /**
526      * @dev Returns the token collection name.
527      */
528     function name() external view returns (string memory);
529 
530     /**
531      * @dev Returns the token collection symbol.
532      */
533     function symbol() external view returns (string memory);
534 
535     /**
536      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
537      */
538     function tokenURI(uint256 tokenId) external view returns (string memory);
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @title ERC721 token receiver interface
549  * @dev Interface for any contract that wants to support safeTransfers
550  * from ERC721 asset contracts.
551  */
552 interface IERC721Receiver {
553     /**
554      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
555      * by `operator` from `from`, this function is called.
556      *
557      * It must return its Solidity selector to confirm the token transfer.
558      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
559      *
560      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
561      */
562     function onERC721Received(
563         address operator,
564         address from,
565         uint256 tokenId,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 // File: @openzeppelin/contracts/utils/Context.sol
571 pragma solidity ^0.8.0;
572 /**
573  * @dev Provides information about the current execution context, including the
574  * sender of the transaction and its data. While these are generally available
575  * via msg.sender and msg.data, they should not be accessed in such a direct
576  * manner, since when dealing with meta-transactions the account sending and
577  * paying for execution may not be the actual sender (as far as an application
578  * is concerned).
579  *
580  * This contract is only required for intermediate, library-like contracts.
581  */
582 abstract contract Context {
583     function _msgSender() internal view virtual returns (address) {
584         return msg.sender;
585     }
586 
587     function _msgData() internal view virtual returns (bytes calldata) {
588         return msg.data;
589     }
590 }
591 
592 
593 // Creator: Chiru Labs
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
600  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
601  *
602  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
603  *
604  * Does not support burning tokens to address(0).
605  *
606  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
607  */
608 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
609     using Address for address;
610     using Strings for uint256;
611 
612     struct TokenOwnership {
613         address addr;
614         uint64 startTimestamp;
615     }
616 
617     struct AddressData {
618         uint128 balance;
619         uint128 numberMinted;
620     }
621 
622     uint256 internal currentIndex;
623 
624     // Token name
625     string private _name;
626 
627     // Token symbol
628     string private _symbol;
629 
630     // Mapping from token ID to ownership details
631     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
632     mapping(uint256 => TokenOwnership) internal _ownerships;
633 
634     // Mapping owner address to address data
635     mapping(address => AddressData) private _addressData;
636 
637     // Mapping from token ID to approved address
638     mapping(uint256 => address) private _tokenApprovals;
639 
640     // Mapping from owner to operator approvals
641     mapping(address => mapping(address => bool)) private _operatorApprovals;
642 
643     constructor(string memory name_, string memory symbol_) {
644         _name = name_;
645         _symbol = symbol_;
646     }
647 
648     /**
649      * @dev See {IERC721Enumerable-totalSupply}.
650      */
651     function totalSupply() public view override returns (uint256) {
652         return currentIndex;
653     }
654 
655     /**
656      * @dev See {IERC721Enumerable-tokenByIndex}.
657      */
658     function tokenByIndex(uint256 index) public view override returns (uint256) {
659         require(index < totalSupply(), 'ERC721A: global index out of bounds');
660         return index;
661     }
662 
663     /**
664      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
665      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
666      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
667      */
668     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
669         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
670         uint256 numMintedSoFar = totalSupply();
671         uint256 tokenIdsIdx;
672         address currOwnershipAddr;
673 
674         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
675         unchecked {
676             for (uint256 i; i < numMintedSoFar; i++) {
677                 TokenOwnership memory ownership = _ownerships[i];
678                 if (ownership.addr != address(0)) {
679                     currOwnershipAddr = ownership.addr;
680                 }
681                 if (currOwnershipAddr == owner) {
682                     if (tokenIdsIdx == index) {
683                         return i;
684                     }
685                     tokenIdsIdx++;
686                 }
687             }
688         }
689 
690         revert('ERC721A: unable to get token of owner by index');
691     }
692 
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
697         return
698             interfaceId == type(IERC721).interfaceId ||
699             interfaceId == type(IERC721Metadata).interfaceId ||
700             interfaceId == type(IERC721Enumerable).interfaceId ||
701             super.supportsInterface(interfaceId);
702     }
703 
704     /**
705      * @dev See {IERC721-balanceOf}.
706      */
707     function balanceOf(address owner) public view override returns (uint256) {
708         require(owner != address(0), 'ERC721A: balance query for the zero address');
709         return uint256(_addressData[owner].balance);
710     }
711 
712     function _numberMinted(address owner) internal view returns (uint256) {
713         require(owner != address(0), 'ERC721A: number minted query for the zero address');
714         return uint256(_addressData[owner].numberMinted);
715     }
716 
717     /**
718      * Gas spent here starts off proportional to the maximum mint batch size.
719      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
720      */
721     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
722         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
723 
724         unchecked {
725             for (uint256 curr = tokenId; curr >= 0; curr--) {
726                 TokenOwnership memory ownership = _ownerships[curr];
727                 if (ownership.addr != address(0)) {
728                     return ownership;
729                 }
730             }
731         }
732 
733         revert('ERC721A: unable to determine the owner of token');
734     }
735 
736     /**
737      * @dev See {IERC721-ownerOf}.
738      */
739     function ownerOf(uint256 tokenId) public view override returns (address) {
740         return ownershipOf(tokenId).addr;
741     }
742 
743     /**
744      * @dev See {IERC721Metadata-name}.
745      */
746     function name() public view virtual override returns (string memory) {
747         return _name;
748     }
749 
750     /**
751      * @dev See {IERC721Metadata-symbol}.
752      */
753     function symbol() public view virtual override returns (string memory) {
754         return _symbol;
755     }
756 
757     /**
758      * @dev See {IERC721Metadata-tokenURI}.
759      */
760     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
761         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
762 
763         string memory baseURI = _baseURI();
764         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
765     }
766 
767     /**
768      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
769      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
770      * by default, can be overriden in child contracts.
771      */
772     function _baseURI() internal view virtual returns (string memory) {
773         return '';
774     }
775 
776     /**
777      * @dev See {IERC721-approve}.
778      */
779     function approve(address to, uint256 tokenId) public override {
780         address owner = ERC721A.ownerOf(tokenId);
781         require(to != owner, 'ERC721A: approval to current owner');
782 
783         require(
784             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
785             'ERC721A: approve caller is not owner nor approved for all'
786         );
787 
788         _approve(to, tokenId, owner);
789     }
790 
791     /**
792      * @dev See {IERC721-getApproved}.
793      */
794     function getApproved(uint256 tokenId) public view override returns (address) {
795         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
796 
797         return _tokenApprovals[tokenId];
798     }
799 
800     /**
801      * @dev See {IERC721-setApprovalForAll}.
802      */
803     function setApprovalForAll(address operator, bool approved) public override {
804         require(operator != _msgSender(), 'ERC721A: approve to caller');
805 
806         _operatorApprovals[_msgSender()][operator] = approved;
807         emit ApprovalForAll(_msgSender(), operator, approved);
808     }
809 
810     /**
811      * @dev See {IERC721-isApprovedForAll}.
812      */
813     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
814         return _operatorApprovals[owner][operator];
815     }
816 
817     /**
818      * @dev See {IERC721-transferFrom}.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public override {
825         _transfer(from, to, tokenId);
826     }
827 
828     /**
829      * @dev See {IERC721-safeTransferFrom}.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public override {
836         safeTransferFrom(from, to, tokenId, '');
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId,
846         bytes memory _data
847     ) public override {
848         _transfer(from, to, tokenId);
849         require(
850             _checkOnERC721Received(from, to, tokenId, _data),
851             'ERC721A: transfer to non ERC721Receiver implementer'
852         );
853     }
854 
855     /**
856      * @dev Returns whether `tokenId` exists.
857      *
858      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
859      *
860      * Tokens start existing when they are minted (`_mint`),
861      */
862     function _exists(uint256 tokenId) internal view returns (bool) {
863         return tokenId < currentIndex;
864     }
865 
866     function _safeMint(address to, uint256 quantity) internal {
867         _safeMint(to, quantity, '');
868     }
869 
870     /**
871      * @dev Safely mints `quantity` tokens and transfers them to `to`.
872      *
873      * Requirements:
874      *
875      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
876      * - `quantity` must be greater than 0.
877      *
878      * Emits a {Transfer} event.
879      */
880     function _safeMint(
881         address to,
882         uint256 quantity,
883         bytes memory _data
884     ) internal {
885         _mint(to, quantity, _data, true);
886     }
887 
888     /**
889      * @dev Mints `quantity` tokens and transfers them to `to`.
890      *
891      * Requirements:
892      *
893      * - `to` cannot be the zero address.
894      * - `quantity` must be greater than 0.
895      *
896      * Emits a {Transfer} event.
897      */
898     function _mint(
899         address to,
900         uint256 quantity,
901         bytes memory _data,
902         bool safe
903     ) internal {
904         uint256 startTokenId = currentIndex;
905         require(to != address(0), 'ERC721A: mint to the zero address');
906         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
907 
908         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
909 
910         // Overflows are incredibly unrealistic.
911         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
912         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
913         unchecked {
914             _addressData[to].balance += uint128(quantity);
915             _addressData[to].numberMinted += uint128(quantity);
916 
917             _ownerships[startTokenId].addr = to;
918             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
919 
920             uint256 updatedIndex = startTokenId;
921 
922             for (uint256 i; i < quantity; i++) {
923                 emit Transfer(address(0), to, updatedIndex);
924                 if (safe) {
925                     require(
926                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
927                         'ERC721A: transfer to non ERC721Receiver implementer'
928                     );
929                 }
930 
931                 updatedIndex++;
932             }
933 
934             currentIndex = updatedIndex;
935         }
936 
937         _afterTokenTransfers(address(0), to, startTokenId, quantity);
938     }
939 
940     /**
941      * @dev Transfers `tokenId` from `from` to `to`.
942      *
943      * Requirements:
944      *
945      * - `to` cannot be the zero address.
946      * - `tokenId` token must be owned by `from`.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _transfer(
951         address from,
952         address to,
953         uint256 tokenId
954     ) private {
955         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
956 
957         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
958             getApproved(tokenId) == _msgSender() ||
959             isApprovedForAll(prevOwnership.addr, _msgSender()));
960 
961         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
962 
963         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
964         require(to != address(0), 'ERC721A: transfer to the zero address');
965 
966         _beforeTokenTransfers(from, to, tokenId, 1);
967 
968         // Clear approvals from the previous owner
969         _approve(address(0), tokenId, prevOwnership.addr);
970 
971         // Underflow of the sender's balance is impossible because we check for
972         // ownership above and the recipient's balance can't realistically overflow.
973         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
974         unchecked {
975             _addressData[from].balance -= 1;
976             _addressData[to].balance += 1;
977 
978             _ownerships[tokenId].addr = to;
979             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
980 
981             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
982             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
983             uint256 nextTokenId = tokenId + 1;
984             if (_ownerships[nextTokenId].addr == address(0)) {
985                 if (_exists(nextTokenId)) {
986                     _ownerships[nextTokenId].addr = prevOwnership.addr;
987                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
988                 }
989             }
990         }
991 
992         emit Transfer(from, to, tokenId);
993         _afterTokenTransfers(from, to, tokenId, 1);
994     }
995 
996     /**
997      * @dev Approve `to` to operate on `tokenId`
998      *
999      * Emits a {Approval} event.
1000      */
1001     function _approve(
1002         address to,
1003         uint256 tokenId,
1004         address owner
1005     ) private {
1006         _tokenApprovals[tokenId] = to;
1007         emit Approval(owner, to, tokenId);
1008     }
1009 
1010     /**
1011      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1012      * The call is not executed if the target address is not a contract.
1013      *
1014      * @param from address representing the previous owner of the given token ID
1015      * @param to target address that will receive the tokens
1016      * @param tokenId uint256 ID of the token to be transferred
1017      * @param _data bytes optional data to send along with the call
1018      * @return bool whether the call correctly returned the expected magic value
1019      */
1020     function _checkOnERC721Received(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) private returns (bool) {
1026         if (to.isContract()) {
1027             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1028                 return retval == IERC721Receiver(to).onERC721Received.selector;
1029             } catch (bytes memory reason) {
1030                 if (reason.length == 0) {
1031                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1032                 } else {
1033                     assembly {
1034                         revert(add(32, reason), mload(reason))
1035                     }
1036                 }
1037             }
1038         } else {
1039             return true;
1040         }
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1045      *
1046      * startTokenId - the first token id to be transferred
1047      * quantity - the amount to be transferred
1048      *
1049      * Calling conditions:
1050      *
1051      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1052      * transferred to `to`.
1053      * - When `from` is zero, `tokenId` will be minted for `to`.
1054      */
1055     function _beforeTokenTransfers(
1056         address from,
1057         address to,
1058         uint256 startTokenId,
1059         uint256 quantity
1060     ) internal virtual {}
1061 
1062     /**
1063      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1064      * minting.
1065      *
1066      * startTokenId - the first token id to be transferred
1067      * quantity - the amount to be transferred
1068      *
1069      * Calling conditions:
1070      *
1071      * - when `from` and `to` are both non-zero.
1072      * - `from` and `to` are never both zero.
1073      */
1074     function _afterTokenTransfers(
1075         address from,
1076         address to,
1077         uint256 startTokenId,
1078         uint256 quantity
1079     ) internal virtual {}
1080 }
1081 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1082 
1083 
1084 
1085 
1086 
1087 // File: @openzeppelin/contracts/access/Ownable.sol
1088 pragma solidity ^0.8.0;
1089 /**
1090  * @dev Contract module which provides a basic access control mechanism, where
1091  * there is an account (an owner) that can be granted exclusive access to
1092  * specific functions.
1093  *
1094  * By default, the owner account will be the one that deploys the contract. This
1095  * can later be changed with {transferOwnership}.
1096  *
1097  * This module is used through inheritance. It will make available the modifier
1098  * `onlyOwner`, which can be applied to your functions to restrict their use to
1099  * the owner.
1100  */
1101 abstract contract Ownable is Context {
1102     address private _owner;
1103 
1104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1105 
1106     /**
1107      * @dev Initializes the contract setting the deployer as the initial owner.
1108      */
1109     constructor() {
1110         _setOwner(_msgSender());
1111     }
1112 
1113     /**
1114      * @dev Returns the address of the current owner.
1115      */
1116     function owner() public view virtual returns (address) {
1117         return _owner;
1118     }
1119 
1120     /**
1121      * @dev Throws if called by any account other than the owner.
1122      */
1123     modifier onlyOwner() {
1124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1125         _;
1126     }
1127 
1128     /**
1129      * @dev Leaves the contract without owner. It will not be possible to call
1130      * `onlyOwner` functions anymore. Can only be called by the current owner.
1131      *
1132      * NOTE: Renouncing ownership will leave the contract without an owner,
1133      * thereby removing any functionality that is only available to the owner.
1134      */
1135     function renounceOwnership() public virtual onlyOwner {
1136         _setOwner(address(0));
1137     }
1138 
1139     /**
1140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1141      * Can only be called by the current owner.
1142      */
1143     function transferOwnership(address newOwner) public virtual onlyOwner {
1144         require(newOwner != address(0), "Ownable: new owner is the zero address");
1145         _setOwner(newOwner);
1146     }
1147 
1148     function _setOwner(address newOwner) private {
1149         address oldOwner = _owner;
1150         _owner = newOwner;
1151         emit OwnershipTransferred(oldOwner, newOwner);
1152     }
1153 }
1154 
1155 pragma solidity >=0.7.0 <0.9.0;
1156 
1157 contract SusGuys is ERC721A, Ownable {
1158   using Strings for uint256;
1159 
1160   string baseURI;
1161   string public baseExtension = ".json";
1162   uint256 public cost = 0.009 ether;
1163   uint256 public maxSupply = 1500;
1164   uint256 public maxMintAmount = 10;
1165   uint256 public maxFREEMintAmount = 3;
1166   uint256 public FREEnftPerAddressLimit = 3;
1167   uint256 public FREE_MAX_SUPPLY = 1000;
1168   address[] public whitelistedAddresses;
1169   bool public paused = true;
1170 
1171   constructor(
1172     string memory _name,
1173     string memory _symbol,
1174     string memory _initBaseURI
1175   ) ERC721A(_name, _symbol) {
1176     setBaseURI(_initBaseURI);
1177   }
1178 
1179   // internal
1180   function _baseURI() internal view virtual override returns (string memory) {
1181     return baseURI;
1182   }
1183 
1184   // public
1185   function mint(uint256 _mintAmount) public payable {
1186     require(!paused, "the contract is paused");
1187     uint256 supply = totalSupply();
1188     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1189 
1190     if (msg.sender != owner()) {
1191         if (FREE_MAX_SUPPLY >= supply + _mintAmount) {
1192             require(_mintAmount <= maxFREEMintAmount, "max mint amount per session exceeded");
1193             require(numberMinted(msg.sender) + _mintAmount <= FREEnftPerAddressLimit, "max NFT per address exceeded");
1194         } else {
1195             require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1196             require(msg.value >= _mintAmount * cost, "Invalid funds provided");
1197         }
1198     }
1199     _safeMint(msg.sender, _mintAmount);
1200     
1201   }
1202 
1203   function WLmint(uint256 _mintAmount) public payable {
1204     require(!paused, "the contract is paused");
1205     uint256 supply = totalSupply();
1206     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1207     require(isWhitelisted(msg.sender), "user is not whitelisted");
1208     _safeMint(msg.sender, _mintAmount);
1209     
1210   }
1211 
1212   function isWhitelisted(address _user) public view returns (bool) {
1213     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1214       if (whitelistedAddresses[i] == _user) {
1215           return true;
1216       }
1217     }
1218     return false;
1219   }
1220 
1221 
1222   function numberMinted(address owner) public view returns (uint256) {
1223     return _numberMinted(owner);
1224   }
1225 
1226   function tokenURI(uint256 tokenId)
1227     public
1228     view
1229     virtual
1230     override
1231     returns (string memory)
1232   {
1233     require(
1234       _exists(tokenId),
1235       "ERC721Metadata: URI query for nonexistent token"
1236     );
1237 
1238     string memory currentBaseURI = _baseURI();
1239     return bytes(currentBaseURI).length > 0
1240         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1241         : "";
1242   }
1243 
1244   //only owner
1245 
1246   function whitelistUsers(address[] calldata _users) public onlyOwner {
1247     delete whitelistedAddresses;
1248     whitelistedAddresses = _users;
1249   }
1250 
1251 
1252   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1253     FREEnftPerAddressLimit = _limit;
1254   }
1255 
1256   function setFreeMaxSupply(uint256 _FreeMaxAmount) public onlyOwner {
1257     FREE_MAX_SUPPLY = _FreeMaxAmount;
1258   }
1259   
1260   function setCost(uint256 _newCost) public onlyOwner {
1261     cost = _newCost;
1262   }
1263 
1264   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1265     maxMintAmount = _newmaxMintAmount;
1266   }
1267 
1268   function setFreeMaxMintAmount(uint256 _newFreeMaxMintAmount) public onlyOwner {
1269     maxFREEMintAmount = _newFreeMaxMintAmount;
1270     FREEnftPerAddressLimit = _newFreeMaxMintAmount;
1271   }
1272 
1273   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1274     baseURI = _newBaseURI;
1275   }
1276 
1277   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1278     baseExtension = _newBaseExtension;
1279   }
1280 
1281   function pause(bool _state) public onlyOwner {
1282     paused = _state;
1283   }
1284  
1285   function withdraw() public payable onlyOwner {
1286     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1287     require(os);
1288   }
1289 }