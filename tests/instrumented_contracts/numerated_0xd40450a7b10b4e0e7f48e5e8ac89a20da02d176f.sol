1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-01
3 */
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
34 
35 
36 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
37 
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 
111 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
112 
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
115 
116 
117 
118 /**
119  * @dev String operations.
120  */
121 library Strings {
122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
126      */
127     function toString(uint256 value) internal pure returns (string memory) {
128         // Inspired by OraclizeAPI's implementation - MIT licence
129         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
130 
131         if (value == 0) {
132             return "0";
133         }
134         uint256 temp = value;
135         uint256 digits;
136         while (temp != 0) {
137             digits++;
138             temp /= 10;
139         }
140         bytes memory buffer = new bytes(digits);
141         while (value != 0) {
142             digits -= 1;
143             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
144             value /= 10;
145         }
146         return string(buffer);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
151      */
152     function toHexString(uint256 value) internal pure returns (string memory) {
153         if (value == 0) {
154             return "0x00";
155         }
156         uint256 temp = value;
157         uint256 length = 0;
158         while (temp != 0) {
159             length++;
160             temp >>= 8;
161         }
162         return toHexString(value, length);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
167      */
168     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
169         bytes memory buffer = new bytes(2 * length + 2);
170         buffer[0] = "0";
171         buffer[1] = "x";
172         for (uint256 i = 2 * length + 1; i > 1; --i) {
173             buffer[i] = _HEX_SYMBOLS[value & 0xf];
174             value >>= 4;
175         }
176         require(value == 0, "Strings: hex length insufficient");
177         return string(buffer);
178     }
179 }
180 
181 
182 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
186 
187 
188 
189 /**
190  * @dev Interface of the ERC165 standard, as defined in the
191  * https://eips.ethereum.org/EIPS/eip-165[EIP].
192  *
193  * Implementers can declare support of contract interfaces, which can then be
194  * queried by others ({ERC165Checker}).
195  *
196  * For an implementation, see {ERC165}.
197  */
198 interface IERC165 {
199     /**
200      * @dev Returns true if this contract implements the interface defined by
201      * `interfaceId`. See the corresponding
202      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
203      * to learn more about how these ids are created.
204      *
205      * This function call must use less than 30 000 gas.
206      */
207     function supportsInterface(bytes4 interfaceId) external view returns (bool);
208 }
209 
210 
211 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
215 
216 
217 
218 /**
219  * @dev Required interface of an ERC721 compliant contract.
220  */
221 interface IERC721 is IERC165 {
222     /**
223      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
229      */
230     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
231 
232     /**
233      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
234      */
235     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
236 
237     /**
238      * @dev Returns the number of tokens in ``owner``'s account.
239      */
240     function balanceOf(address owner) external view returns (uint256 balance);
241 
242     /**
243      * @dev Returns the owner of the `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function ownerOf(uint256 tokenId) external view returns (address owner);
250 
251     /**
252      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
253      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
262      *
263      * Emits a {Transfer} event.
264      */
265     function safeTransferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Transfers `tokenId` token from `from` to `to`.
273      *
274      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
275      *
276      * Requirements:
277      *
278      * - `from` cannot be the zero address.
279      * - `to` cannot be the zero address.
280      * - `tokenId` token must be owned by `from`.
281      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     /**
292      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
293      * The approval is cleared when the token is transferred.
294      *
295      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
296      *
297      * Requirements:
298      *
299      * - The caller must own the token or be an approved operator.
300      * - `tokenId` must exist.
301      *
302      * Emits an {Approval} event.
303      */
304     function approve(address to, uint256 tokenId) external;
305 
306     /**
307      * @dev Returns the account approved for `tokenId` token.
308      *
309      * Requirements:
310      *
311      * - `tokenId` must exist.
312      */
313     function getApproved(uint256 tokenId) external view returns (address operator);
314 
315     /**
316      * @dev Approve or remove `operator` as an operator for the caller.
317      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
318      *
319      * Requirements:
320      *
321      * - The `operator` cannot be the caller.
322      *
323      * Emits an {ApprovalForAll} event.
324      */
325     function setApprovalForAll(address operator, bool _approved) external;
326 
327     /**
328      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
329      *
330      * See {setApprovalForAll}
331      */
332     function isApprovedForAll(address owner, address operator) external view returns (bool);
333 
334     /**
335      * @dev Safely transfers `tokenId` token from `from` to `to`.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must exist and be owned by `from`.
342      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
344      *
345      * Emits a {Transfer} event.
346      */
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId,
351         bytes calldata data
352     ) external;
353 }
354 
355 
356 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
360 
361 
362 
363 /**
364  * @title ERC721 token receiver interface
365  * @dev Interface for any contract that wants to support safeTransfers
366  * from ERC721 asset contracts.
367  */
368 interface IERC721Receiver {
369     /**
370      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
371      * by `operator` from `from`, this function is called.
372      *
373      * It must return its Solidity selector to confirm the token transfer.
374      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
375      *
376      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
377      */
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 
387 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
391 
392 
393 
394 /**
395  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
396  * @dev See https://eips.ethereum.org/EIPS/eip-721
397  */
398 interface IERC721Metadata is IERC721 {
399     /**
400      * @dev Returns the token collection name.
401      */
402     function name() external view returns (string memory);
403 
404     /**
405      * @dev Returns the token collection symbol.
406      */
407     function symbol() external view returns (string memory);
408 
409     /**
410      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
411      */
412     function tokenURI(uint256 tokenId) external view returns (string memory);
413 }
414 
415 
416 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
417 
418 
419 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
420 
421 
422 
423 /**
424  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
425  * @dev See https://eips.ethereum.org/EIPS/eip-721
426  */
427 interface IERC721Enumerable is IERC721 {
428     /**
429      * @dev Returns the total amount of tokens stored by the contract.
430      */
431     function totalSupply() external view returns (uint256);
432 
433     /**
434      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
435      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
436      */
437     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
438 
439     /**
440      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
441      * Use along with {totalSupply} to enumerate all tokens.
442      */
443     function tokenByIndex(uint256 index) external view returns (uint256);
444 }
445 
446 
447 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
448 
449 
450 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
451 
452 
453 
454 /**
455  * @dev Collection of functions related to the address type
456  */
457 library Address {
458     /**
459      * @dev Returns true if `account` is a contract.
460      *
461      * [IMPORTANT]
462      * ====
463      * It is unsafe to assume that an address for which this function returns
464      * false is an externally-owned account (EOA) and not a contract.
465      *
466      * Among others, `isContract` will return false for the following
467      * types of addresses:
468      *
469      *  - an externally-owned account
470      *  - a contract in construction
471      *  - an address where a contract will be created
472      *  - an address where a contract lived, but was destroyed
473      * ====
474      */
475     function isContract(address account) internal view returns (bool) {
476         // This method relies on extcodesize, which returns 0 for contracts in
477         // construction, since the code is only stored at the end of the
478         // constructor execution.
479 
480         uint256 size;
481         assembly {
482             size := extcodesize(account)
483         }
484         return size > 0;
485     }
486 
487     /**
488      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
489      * `recipient`, forwarding all available gas and reverting on errors.
490      *
491      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
492      * of certain opcodes, possibly making contracts go over the 2300 gas limit
493      * imposed by `transfer`, making them unable to receive funds via
494      * `transfer`. {sendValue} removes this limitation.
495      *
496      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
497      *
498      * IMPORTANT: because control is transferred to `recipient`, care must be
499      * taken to not create reentrancy vulnerabilities. Consider using
500      * {ReentrancyGuard} or the
501      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
502      */
503     function sendValue(address payable recipient, uint256 amount) internal {
504         require(address(this).balance >= amount, "Address: insufficient balance");
505 
506         (bool success, ) = recipient.call{value: amount}("");
507         require(success, "Address: unable to send value, recipient may have reverted");
508     }
509 
510     /**
511      * @dev Performs a Solidity function call using a low level `call`. A
512      * plain `call` is an unsafe replacement for a function call: use this
513      * function instead.
514      *
515      * If `target` reverts with a revert reason, it is bubbled up by this
516      * function (like regular Solidity function calls).
517      *
518      * Returns the raw returned data. To convert to the expected return value,
519      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
520      *
521      * Requirements:
522      *
523      * - `target` must be a contract.
524      * - calling `target` with `data` must not revert.
525      *
526      * _Available since v3.1._
527      */
528     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
529         return functionCall(target, data, "Address: low-level call failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
534      * `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(
539         address target,
540         bytes memory data,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         return functionCallWithValue(target, data, 0, errorMessage);
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
548      * but also transferring `value` wei to `target`.
549      *
550      * Requirements:
551      *
552      * - the calling contract must have an ETH balance of at least `value`.
553      * - the called Solidity function must be `payable`.
554      *
555      * _Available since v3.1._
556      */
557     function functionCallWithValue(
558         address target,
559         bytes memory data,
560         uint256 value
561     ) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
567      * with `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(
572         address target,
573         bytes memory data,
574         uint256 value,
575         string memory errorMessage
576     ) internal returns (bytes memory) {
577         require(address(this).balance >= value, "Address: insufficient balance for call");
578         require(isContract(target), "Address: call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.call{value: value}(data);
581         return verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
591         return functionStaticCall(target, data, "Address: low-level static call failed");
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(
601         address target,
602         bytes memory data,
603         string memory errorMessage
604     ) internal view returns (bytes memory) {
605         require(isContract(target), "Address: static call to non-contract");
606 
607         (bool success, bytes memory returndata) = target.staticcall(data);
608         return verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
618         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
623      * but performing a delegate call.
624      *
625      * _Available since v3.4._
626      */
627     function functionDelegateCall(
628         address target,
629         bytes memory data,
630         string memory errorMessage
631     ) internal returns (bytes memory) {
632         require(isContract(target), "Address: delegate call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.delegatecall(data);
635         return verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
640      * revert reason using the provided one.
641      *
642      * _Available since v4.3._
643      */
644     function verifyCallResult(
645         bool success,
646         bytes memory returndata,
647         string memory errorMessage
648     ) internal pure returns (bytes memory) {
649         if (success) {
650             return returndata;
651         } else {
652             // Look for revert reason and bubble it up if present
653             if (returndata.length > 0) {
654                 // The easiest way to bubble the revert reason is using memory via assembly
655 
656                 assembly {
657                     let returndata_size := mload(returndata)
658                     revert(add(32, returndata), returndata_size)
659                 }
660             } else {
661                 revert(errorMessage);
662             }
663         }
664     }
665 }
666 
667 
668 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
672 
673 
674 
675 /**
676  * @dev Implementation of the {IERC165} interface.
677  *
678  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
679  * for the additional interface id that will be supported. For example:
680  *
681  * ```solidity
682  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
683  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
684  * }
685  * ```
686  *
687  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
688  */
689 abstract contract ERC165 is IERC165 {
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694         return interfaceId == type(IERC165).interfaceId;
695     }
696 }
697 
698 
699 // File contracts/ERC721A.sol
700 
701 
702 // Creator: Chiru Labs
703 
704 
705 /**
706  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
707  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
708  *
709  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
710  *
711  * Does not support burning tokens to address(0).
712  *
713  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
714  */
715 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
716     using Address for address;
717     using Strings for uint256;
718 
719     struct TokenOwnership {
720         address addr;
721         uint64 startTimestamp;
722     }
723 
724     struct AddressData {
725         uint128 balance;
726         uint128 numberMinted;
727     }
728 
729     uint256 internal currentIndex = 1;
730 
731     // Token name
732     string private _name;
733 
734     // Token symbol
735     string private _symbol;
736 
737     // Mapping from token ID to ownership details
738     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
739     mapping(uint256 => TokenOwnership) internal _ownerships;
740 
741     // Mapping owner address to address data
742     mapping(address => AddressData) private _addressData;
743 
744     // Mapping from token ID to approved address
745     mapping(uint256 => address) private _tokenApprovals;
746 
747     // Mapping from owner to operator approvals
748     mapping(address => mapping(address => bool)) private _operatorApprovals;
749 
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     /**
756      * @dev See {IERC721Enumerable-totalSupply}.
757      */
758     function totalSupply() public view override returns (uint256) {
759         return currentIndex;
760     }
761 
762     /**
763      * @dev See {IERC721Enumerable-tokenByIndex}.
764      */
765     function tokenByIndex(uint256 index) public view override returns (uint256) {
766         require(index < totalSupply(), 'ERC721A: global index out of bounds');
767         return index;
768     }
769 
770     /**
771      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
772      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
773      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
774      */
775     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
776         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
777         uint256 numMintedSoFar = totalSupply();
778         uint256 tokenIdsIdx = 0;
779         address currOwnershipAddr = address(0);
780         for (uint256 i = 0; i < numMintedSoFar; i++) {
781             TokenOwnership memory ownership = _ownerships[i];
782             if (ownership.addr != address(0)) {
783                 currOwnershipAddr = ownership.addr;
784             }
785             if (currOwnershipAddr == owner) {
786                 if (tokenIdsIdx == index) {
787                     return i;
788                 }
789                 tokenIdsIdx++;
790             }
791         }
792         revert('ERC721A: unable to get token of owner by index');
793     }
794 
795     /**
796      * @dev See {IERC165-supportsInterface}.
797      */
798     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
799         return
800             interfaceId == type(IERC721).interfaceId ||
801             interfaceId == type(IERC721Metadata).interfaceId ||
802             interfaceId == type(IERC721Enumerable).interfaceId ||
803             super.supportsInterface(interfaceId);
804     }
805 
806     /**
807      * @dev See {IERC721-balanceOf}.
808      */
809     function balanceOf(address owner) public view override returns (uint256) {
810         require(owner != address(0), 'ERC721A: balance query for the zero address');
811         return uint256(_addressData[owner].balance);
812     }
813 
814     function _numberMinted(address owner) internal view returns (uint256) {
815         require(owner != address(0), 'ERC721A: number minted query for the zero address');
816         return uint256(_addressData[owner].numberMinted);
817     }
818 
819     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
820         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
821 
822         for (uint256 curr = tokenId; ; curr--) {
823             TokenOwnership memory ownership = _ownerships[curr];
824             if (ownership.addr != address(0)) {
825                 return ownership;
826             }
827         }
828 
829         revert('ERC721A: unable to determine the owner of token');
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId) public view override returns (address) {
836         return ownershipOf(tokenId).addr;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-name}.
841      */
842     function name() public view virtual override returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-symbol}.
848      */
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-tokenURI}.
855      */
856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
857         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
858 
859         string memory baseURI = _baseURI();
860         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return '';
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public override {
876         address owner = ERC721A.ownerOf(tokenId);
877         require(to != owner, 'ERC721A: approval to current owner');
878 
879         require(
880             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
881             'ERC721A: approve caller is not owner nor approved for all'
882         );
883 
884         _approve(to, tokenId, owner);
885     }
886 
887     /**
888      * @dev See {IERC721-getApproved}.
889      */
890     function getApproved(uint256 tokenId) public view override returns (address) {
891         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
892 
893         return _tokenApprovals[tokenId];
894     }
895 
896     /**
897      * @dev See {IERC721-setApprovalForAll}.
898      */
899     function setApprovalForAll(address operator, bool approved) public override {
900         require(operator != _msgSender(), 'ERC721A: approve to caller');
901 
902         _operatorApprovals[_msgSender()][operator] = approved;
903         emit ApprovalForAll(_msgSender(), operator, approved);
904     }
905 
906     /**
907      * @dev See {IERC721-isApprovedForAll}.
908      */
909     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
910         return _operatorApprovals[owner][operator];
911     }
912 
913     /**
914      * @dev See {IERC721-transferFrom}.
915      */
916     function transferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) public override {
921         _transfer(from, to, tokenId);
922     }
923 
924     /**
925      * @dev See {IERC721-safeTransferFrom}.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public override {
932         safeTransferFrom(from, to, tokenId, '');
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId,
942         bytes memory _data
943     ) public override {
944         _transfer(from, to, tokenId);
945         require(
946             _checkOnERC721Received(from, to, tokenId, _data),
947             'ERC721A: transfer to non ERC721Receiver implementer'
948         );
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted (`_mint`),
957      */
958     function _exists(uint256 tokenId) internal view returns (bool) {
959         return tokenId < currentIndex;
960     }
961 
962     function _safeMint(address to, uint256 quantity) internal {
963         _safeMint(to, quantity, '');
964     }
965 
966     /**
967      * @dev Mints `quantity` tokens and transfers them to `to`.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      * - `quantity` cannot be larger than the max batch size.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(
977         address to,
978         uint256 quantity,
979         bytes memory _data
980     ) internal {
981         uint256 startTokenId = currentIndex;
982         require(to != address(0), 'ERC721A: mint to the zero address');
983         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
984         require(!_exists(startTokenId), 'ERC721A: token already minted');
985         require(quantity > 0, 'ERC721A: quantity must be greater 0');
986 
987         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
988 
989         AddressData memory addressData = _addressData[to];
990         _addressData[to] = AddressData(
991             addressData.balance + uint128(quantity),
992             addressData.numberMinted + uint128(quantity)
993         );
994         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
995 
996         uint256 updatedIndex = startTokenId;
997 
998         for (uint256 i = 0; i < quantity; i++) {
999             emit Transfer(address(0), to, updatedIndex);
1000             require(
1001                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1002                 'ERC721A: transfer to non ERC721Receiver implementer'
1003             );
1004             updatedIndex++;
1005         }
1006 
1007         currentIndex = updatedIndex;
1008         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1009     }
1010 
1011     /**
1012      * @dev Transfers `tokenId` from `from` to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must be owned by `from`.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _transfer(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) private {
1026         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1027 
1028         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1029             getApproved(tokenId) == _msgSender() ||
1030             isApprovedForAll(prevOwnership.addr, _msgSender()));
1031 
1032         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1033 
1034         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1035         require(to != address(0), 'ERC721A: transfer to the zero address');
1036 
1037         _beforeTokenTransfers(from, to, tokenId, 1);
1038 
1039         // Clear approvals from the previous owner
1040         _approve(address(0), tokenId, prevOwnership.addr);
1041 
1042         // Underflow of the sender's balance is impossible because we check for
1043         // ownership above and the recipient's balance can't realistically overflow.
1044         unchecked {
1045             _addressData[from].balance -= 1;
1046             _addressData[to].balance += 1;
1047         }
1048 
1049         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1050 
1051         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1052         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1053         uint256 nextTokenId = tokenId + 1;
1054         if (_ownerships[nextTokenId].addr == address(0)) {
1055             if (_exists(nextTokenId)) {
1056                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1057             }
1058         }
1059 
1060         emit Transfer(from, to, tokenId);
1061         _afterTokenTransfers(from, to, tokenId, 1);
1062     }
1063 
1064     /**
1065      * @dev Approve `to` to operate on `tokenId`
1066      *
1067      * Emits a {Approval} event.
1068      */
1069     function _approve(
1070         address to,
1071         uint256 tokenId,
1072         address owner
1073     ) private {
1074         _tokenApprovals[tokenId] = to;
1075         emit Approval(owner, to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080      * The call is not executed if the target address is not a contract.
1081      *
1082      * @param from address representing the previous owner of the given token ID
1083      * @param to target address that will receive the tokens
1084      * @param tokenId uint256 ID of the token to be transferred
1085      * @param _data bytes optional data to send along with the call
1086      * @return bool whether the call correctly returned the expected magic value
1087      */
1088     function _checkOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         if (to.isContract()) {
1095             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1096                 return retval == IERC721Receiver(to).onERC721Received.selector;
1097             } catch (bytes memory reason) {
1098                 if (reason.length == 0) {
1099                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1100                 } else {
1101                     assembly {
1102                         revert(add(32, reason), mload(reason))
1103                     }
1104                 }
1105             }
1106         } else {
1107             return true;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1113      *
1114      * startTokenId - the first token id to be transferred
1115      * quantity - the amount to be transferred
1116      *
1117      * Calling conditions:
1118      *
1119      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1120      * transferred to `to`.
1121      * - When `from` is zero, `tokenId` will be minted for `to`.
1122      */
1123     function _beforeTokenTransfers(
1124         address from,
1125         address to,
1126         uint256 startTokenId,
1127         uint256 quantity
1128     ) internal virtual {}
1129 
1130     /**
1131      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1132      * minting.
1133      *
1134      * startTokenId - the first token id to be transferred
1135      * quantity - the amount to be transferred
1136      *
1137      * Calling conditions:
1138      *
1139      * - when `from` and `to` are both non-zero.
1140      * - `from` and `to` are never both zero.
1141      */
1142     function _afterTokenTransfers(
1143         address from,
1144         address to,
1145         uint256 startTokenId,
1146         uint256 quantity
1147     ) internal virtual {}
1148 }
1149 
1150 contract FemKevin is ERC721A, Ownable {
1151 
1152     string public baseURI = "ipfs://QmQJd5DVz9755P8oiTPK4qc2G1sJNGowQxRXvqm3HaQPpW/";
1153     string public contractURI = "ipfs://QmfK5t5v8B8KSQ8UTY8Tqx3EAzf3myo5cXmdSvySp4BB7x";
1154     string public constant baseExtension = ".json";
1155     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1156 
1157     uint256 public constant MAX_PER_TX = 2;
1158     uint256 public constant MAX_PER_WALLET = 4;
1159     uint256 public constant MAX_SUPPLY = 444;
1160     uint256 public constant price = 0.00 ether;
1161 
1162     bool public paused = true;
1163 
1164     mapping(address => uint256) public addressMinted;
1165 
1166     constructor() ERC721A("FemKevin", "FEMKEV") {}
1167 
1168     function mint(uint256 _amount) external payable {
1169         address _caller = _msgSender();
1170         require(!paused, "Paused");
1171         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1172         require(_amount > 0, "No 0 mints");
1173         require(tx.origin == _caller, "No contracts");
1174         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1175         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1176         require(_amount * price == msg.value, "Invalid funds provided");
1177          addressMinted[msg.sender] += _amount;
1178         _safeMint(_caller, _amount);
1179     }
1180 
1181     function isApprovedForAll(address owner, address operator)
1182         override
1183         public
1184         view
1185         returns (bool)
1186     {
1187         // Whitelist OpenSea proxy contract for easy trading.
1188         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1189         if (address(proxyRegistry.proxies(owner)) == operator) {
1190             return true;
1191         }
1192 
1193         return super.isApprovedForAll(owner, operator);
1194     }
1195 
1196     function withdraw() external onlyOwner {
1197         uint256 balance = address(this).balance;
1198         (bool success, ) = _msgSender().call{value: balance}("");
1199         require(success, "Failed to send");
1200     }
1201 
1202     function pause(bool _state) external onlyOwner {
1203         paused = _state;
1204     }
1205 
1206     function setBaseURI(string memory baseURI_) external onlyOwner {
1207         baseURI = baseURI_;
1208     }
1209 
1210     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1211         require(_exists(_tokenId), "Token does not exist.");
1212         return bytes(baseURI).length > 0 ? string(
1213             abi.encodePacked(
1214               baseURI,
1215               Strings.toString(_tokenId),
1216               baseExtension
1217             )
1218         ) : "";
1219     }
1220 }
1221 
1222 contract OwnableDelegateProxy { }
1223 contract ProxyRegistry {
1224     mapping(address => OwnableDelegateProxy) public proxies;
1225 }