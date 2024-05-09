1 // _______ ______  _______ _______  ______ _______ _______ _______ _     _ _______
2 // |_____| |_____] |______    |    |_____/ |_____| |          |    |     | |______
3 // |     | |_____] ______|    |    |    \_ |     | |_____     |    |_____| ______|     
4 //                                                                                    
5 //         ______ _______        _______ _     _ _____ _______ _______              
6 //        |  ____ |_____| |      |_____|  \___/    |   |_____| |______              
7 //        |_____| |     | |_____ |     | _/   \_ __|__ |     | ______|              
8                                                                               
9 
10 // SPDX-License-Identifier: MIT
11 // File: contracts/AbstractusGalaxias.sol
12 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
13 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 
38 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
39 
40 
41 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
42 
43 
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
129      */
130     function toString(uint256 value) internal pure returns (string memory) {
131         // Inspired by OraclizeAPI's implementation - MIT licence
132         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
133 
134         if (value == 0) {
135             return "0";
136         }
137         uint256 temp = value;
138         uint256 digits;
139         while (temp != 0) {
140             digits++;
141             temp /= 10;
142         }
143         bytes memory buffer = new bytes(digits);
144         while (value != 0) {
145             digits -= 1;
146             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
147             value /= 10;
148         }
149         return string(buffer);
150     }
151 
152     /**
153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
154      */
155     function toHexString(uint256 value) internal pure returns (string memory) {
156         if (value == 0) {
157             return "0x00";
158         }
159         uint256 temp = value;
160         uint256 length = 0;
161         while (temp != 0) {
162             length++;
163             temp >>= 8;
164         }
165         return toHexString(value, length);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
170      */
171     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
172         bytes memory buffer = new bytes(2 * length + 2);
173         buffer[0] = "0";
174         buffer[1] = "x";
175         for (uint256 i = 2 * length + 1; i > 1; --i) {
176             buffer[i] = _HEX_SYMBOLS[value & 0xf];
177             value >>= 4;
178         }
179         require(value == 0, "Strings: hex length insufficient");
180         return string(buffer);
181     }
182 }
183 
184 
185 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
189 
190 
191 
192 /**
193  * @dev Interface of the ERC165 standard, as defined in the
194  * https://eips.ethereum.org/EIPS/eip-165[EIP].
195  *
196  * Implementers can declare support of contract interfaces, which can then be
197  * queried by others ({ERC165Checker}).
198  *
199  * For an implementation, see {ERC165}.
200  */
201 interface IERC165 {
202     /**
203      * @dev Returns true if this contract implements the interface defined by
204      * `interfaceId`. See the corresponding
205      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
206      * to learn more about how these ids are created.
207      *
208      * This function call must use less than 30 000 gas.
209      */
210     function supportsInterface(bytes4 interfaceId) external view returns (bool);
211 }
212 
213 
214 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
215 
216 
217 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
218 
219 
220 
221 /**
222  * @dev Required interface of an ERC721 compliant contract.
223  */
224 interface IERC721 is IERC165 {
225     /**
226      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
232      */
233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
234 
235     /**
236      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
237      */
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
239 
240     /**
241      * @dev Returns the number of tokens in ``owner``'s account.
242      */
243     function balanceOf(address owner) external view returns (uint256 balance);
244 
245     /**
246      * @dev Returns the owner of the `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function ownerOf(uint256 tokenId) external view returns (address owner);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
256      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
257      *
258      * Requirements:
259      *
260      * - `from` cannot be the zero address.
261      * - `to` cannot be the zero address.
262      * - `tokenId` token must exist and be owned by `from`.
263      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
264      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
265      *
266      * Emits a {Transfer} event.
267      */
268     function safeTransferFrom(
269         address from,
270         address to,
271         uint256 tokenId
272     ) external;
273 
274     /**
275      * @dev Transfers `tokenId` token from `from` to `to`.
276      *
277      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
278      *
279      * Requirements:
280      *
281      * - `from` cannot be the zero address.
282      * - `to` cannot be the zero address.
283      * - `tokenId` token must be owned by `from`.
284      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
285      *
286      * Emits a {Transfer} event.
287      */
288     function transferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     /**
295      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
296      * The approval is cleared when the token is transferred.
297      *
298      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
299      *
300      * Requirements:
301      *
302      * - The caller must own the token or be an approved operator.
303      * - `tokenId` must exist.
304      *
305      * Emits an {Approval} event.
306      */
307     function approve(address to, uint256 tokenId) external;
308 
309     /**
310      * @dev Returns the account approved for `tokenId` token.
311      *
312      * Requirements:
313      *
314      * - `tokenId` must exist.
315      */
316     function getApproved(uint256 tokenId) external view returns (address operator);
317 
318     /**
319      * @dev Approve or remove `operator` as an operator for the caller.
320      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
321      *
322      * Requirements:
323      *
324      * - The `operator` cannot be the caller.
325      *
326      * Emits an {ApprovalForAll} event.
327      */
328     function setApprovalForAll(address operator, bool _approved) external;
329 
330     /**
331      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
332      *
333      * See {setApprovalForAll}
334      */
335     function isApprovedForAll(address owner, address operator) external view returns (bool);
336 
337     /**
338      * @dev Safely transfers `tokenId` token from `from` to `to`.
339      *
340      * Requirements:
341      *
342      * - `from` cannot be the zero address.
343      * - `to` cannot be the zero address.
344      * - `tokenId` token must exist and be owned by `from`.
345      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
346      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
347      *
348      * Emits a {Transfer} event.
349      */
350     function safeTransferFrom(
351         address from,
352         address to,
353         uint256 tokenId,
354         bytes calldata data
355     ) external;
356 }
357 
358 
359 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 
364 
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 
390 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
394 
395 
396 
397 /**
398  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
399  * @dev See https://eips.ethereum.org/EIPS/eip-721
400  */
401 interface IERC721Metadata is IERC721 {
402     /**
403      * @dev Returns the token collection name.
404      */
405     function name() external view returns (string memory);
406 
407     /**
408      * @dev Returns the token collection symbol.
409      */
410     function symbol() external view returns (string memory);
411 
412     /**
413      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
414      */
415     function tokenURI(uint256 tokenId) external view returns (string memory);
416 }
417 
418 
419 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
420 
421 
422 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
423 
424 
425 
426 /**
427  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
428  * @dev See https://eips.ethereum.org/EIPS/eip-721
429  */
430 interface IERC721Enumerable is IERC721 {
431     /**
432      * @dev Returns the total amount of tokens stored by the contract.
433      */
434     function totalSupply() external view returns (uint256);
435 
436     /**
437      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
438      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
439      */
440     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
441 
442     /**
443      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
444      * Use along with {totalSupply} to enumerate all tokens.
445      */
446     function tokenByIndex(uint256 index) external view returns (uint256);
447 }
448 
449 
450 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
454 
455 
456 
457 /**
458  * @dev Collection of functions related to the address type
459  */
460 library Address {
461     /**
462      * @dev Returns true if `account` is a contract.
463      *
464      * [IMPORTANT]
465      * ====
466      * It is unsafe to assume that an address for which this function returns
467      * false is an externally-owned account (EOA) and not a contract.
468      *
469      * Among others, `isContract` will return false for the following
470      * types of addresses:
471      *
472      *  - an externally-owned account
473      *  - a contract in construction
474      *  - an address where a contract will be created
475      *  - an address where a contract lived, but was destroyed
476      * ====
477      */
478     function isContract(address account) internal view returns (bool) {
479         // This method relies on extcodesize, which returns 0 for contracts in
480         // construction, since the code is only stored at the end of the
481         // constructor execution.
482 
483         uint256 size;
484         assembly {
485             size := extcodesize(account)
486         }
487         return size > 0;
488     }
489 
490     /**
491      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
492      * `recipient`, forwarding all available gas and reverting on errors.
493      *
494      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
495      * of certain opcodes, possibly making contracts go over the 2300 gas limit
496      * imposed by `transfer`, making them unable to receive funds via
497      * `transfer`. {sendValue} removes this limitation.
498      *
499      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
500      *
501      * IMPORTANT: because control is transferred to `recipient`, care must be
502      * taken to not create reentrancy vulnerabilities. Consider using
503      * {ReentrancyGuard} or the
504      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
505      */
506     function sendValue(address payable recipient, uint256 amount) internal {
507         require(address(this).balance >= amount, "Address: insufficient balance");
508 
509         (bool success, ) = recipient.call{value: amount}("");
510         require(success, "Address: unable to send value, recipient may have reverted");
511     }
512 
513     /**
514      * @dev Performs a Solidity function call using a low level `call`. A
515      * plain `call` is an unsafe replacement for a function call: use this
516      * function instead.
517      *
518      * If `target` reverts with a revert reason, it is bubbled up by this
519      * function (like regular Solidity function calls).
520      *
521      * Returns the raw returned data. To convert to the expected return value,
522      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
523      *
524      * Requirements:
525      *
526      * - `target` must be a contract.
527      * - calling `target` with `data` must not revert.
528      *
529      * _Available since v3.1._
530      */
531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
532         return functionCall(target, data, "Address: low-level call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
537      * `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, 0, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but also transferring `value` wei to `target`.
552      *
553      * Requirements:
554      *
555      * - the calling contract must have an ETH balance of at least `value`.
556      * - the called Solidity function must be `payable`.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(
561         address target,
562         bytes memory data,
563         uint256 value
564     ) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(
575         address target,
576         bytes memory data,
577         uint256 value,
578         string memory errorMessage
579     ) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         require(isContract(target), "Address: call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.call{value: value}(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a static call.
590      *
591      * _Available since v3.3._
592      */
593     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
594         return functionStaticCall(target, data, "Address: low-level static call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a static call.
600      *
601      * _Available since v3.3._
602      */
603     function functionStaticCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal view returns (bytes memory) {
608         require(isContract(target), "Address: static call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.staticcall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
621         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
626      * but performing a delegate call.
627      *
628      * _Available since v3.4._
629      */
630     function functionDelegateCall(
631         address target,
632         bytes memory data,
633         string memory errorMessage
634     ) internal returns (bytes memory) {
635         require(isContract(target), "Address: delegate call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.delegatecall(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
643      * revert reason using the provided one.
644      *
645      * _Available since v4.3._
646      */
647     function verifyCallResult(
648         bool success,
649         bytes memory returndata,
650         string memory errorMessage
651     ) internal pure returns (bytes memory) {
652         if (success) {
653             return returndata;
654         } else {
655             // Look for revert reason and bubble it up if present
656             if (returndata.length > 0) {
657                 // The easiest way to bubble the revert reason is using memory via assembly
658 
659                 assembly {
660                     let returndata_size := mload(returndata)
661                     revert(add(32, returndata), returndata_size)
662                 }
663             } else {
664                 revert(errorMessage);
665             }
666         }
667     }
668 }
669 
670 
671 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
675 
676 
677 
678 /**
679  * @dev Implementation of the {IERC165} interface.
680  *
681  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
682  * for the additional interface id that will be supported. For example:
683  *
684  * ```solidity
685  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
686  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
687  * }
688  * ```
689  *
690  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
691  */
692 abstract contract ERC165 is IERC165 {
693     /**
694      * @dev See {IERC165-supportsInterface}.
695      */
696     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
697         return interfaceId == type(IERC165).interfaceId;
698     }
699 }
700 
701 
702 // File contracts/ERC721A.sol
703 
704 
705 // Creator: FROGGY
706 
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
711  *
712  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
713  *
714  * Does not support burning tokens to address(0).
715  *
716  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
717  */
718 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
719     using Address for address;
720     using Strings for uint256;
721 
722     struct TokenOwnership {
723         address addr;
724         uint64 startTimestamp;
725     }
726 
727     struct AddressData {
728         uint128 balance;
729         uint128 numberMinted;
730     }
731 
732     uint256 internal currentIndex = 1;
733 
734     // Token name
735     string private _name;
736 
737     // Token symbol
738     string private _symbol;
739 
740     // Mapping from token ID to ownership details
741     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
742     mapping(uint256 => TokenOwnership) internal _ownerships;
743 
744     // Mapping owner address to address data
745     mapping(address => AddressData) private _addressData;
746 
747     // Mapping from token ID to approved address
748     mapping(uint256 => address) private _tokenApprovals;
749 
750     // Mapping from owner to operator approvals
751     mapping(address => mapping(address => bool)) private _operatorApprovals;
752 
753     constructor(string memory name_, string memory symbol_) {
754         _name = name_;
755         _symbol = symbol_;
756     }
757 
758     /**
759      * @dev See {IERC721Enumerable-totalSupply}.
760      */
761     function totalSupply() public view override returns (uint256) {
762         return currentIndex;
763     }
764 
765     /**
766      * @dev See {IERC721Enumerable-tokenByIndex}.
767      */
768     function tokenByIndex(uint256 index) public view override returns (uint256) {
769         require(index < totalSupply(), 'ERC721A: global index out of bounds');
770         return index;
771     }
772 
773     /**
774      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
775      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
776      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
777      */
778     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
779         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
780         uint256 numMintedSoFar = totalSupply();
781         uint256 tokenIdsIdx = 0;
782         address currOwnershipAddr = address(0);
783         for (uint256 i = 0; i < numMintedSoFar; i++) {
784             TokenOwnership memory ownership = _ownerships[i];
785             if (ownership.addr != address(0)) {
786                 currOwnershipAddr = ownership.addr;
787             }
788             if (currOwnershipAddr == owner) {
789                 if (tokenIdsIdx == index) {
790                     return i;
791                 }
792                 tokenIdsIdx++;
793             }
794         }
795         revert('ERC721A: unable to get token of owner by index');
796     }
797 
798     /**
799      * @dev See {IERC165-supportsInterface}.
800      */
801     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
802         return
803             interfaceId == type(IERC721).interfaceId ||
804             interfaceId == type(IERC721Metadata).interfaceId ||
805             interfaceId == type(IERC721Enumerable).interfaceId ||
806             super.supportsInterface(interfaceId);
807     }
808 
809     /**
810      * @dev See {IERC721-balanceOf}.
811      */
812     function balanceOf(address owner) public view override returns (uint256) {
813         require(owner != address(0), 'ERC721A: balance query for the zero address');
814         return uint256(_addressData[owner].balance);
815     }
816 
817     function _numberMinted(address owner) internal view returns (uint256) {
818         require(owner != address(0), 'ERC721A: number minted query for the zero address');
819         return uint256(_addressData[owner].numberMinted);
820     }
821 
822     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
823         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
824 
825         for (uint256 curr = tokenId; ; curr--) {
826             TokenOwnership memory ownership = _ownerships[curr];
827             if (ownership.addr != address(0)) {
828                 return ownership;
829             }
830         }
831 
832         revert('ERC721A: unable to determine the owner of token');
833     }
834 
835     /**
836      * @dev See {IERC721-ownerOf}.
837      */
838     function ownerOf(uint256 tokenId) public view override returns (address) {
839         return ownershipOf(tokenId).addr;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-name}.
844      */
845     function name() public view virtual override returns (string memory) {
846         return _name;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-symbol}.
851      */
852     function symbol() public view virtual override returns (string memory) {
853         return _symbol;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-tokenURI}.
858      */
859     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
860         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
861 
862         string memory baseURI = _baseURI();
863         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
864     }
865 
866     /**
867      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
868      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
869      * by default, can be overriden in child contracts.
870      */
871     function _baseURI() internal view virtual returns (string memory) {
872         return '';
873     }
874 
875     /**
876      * @dev See {IERC721-approve}.
877      */
878     function approve(address to, uint256 tokenId) public override {
879         address owner = ERC721A.ownerOf(tokenId);
880         require(to != owner, 'ERC721A: approval to current owner');
881 
882         require(
883             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
884             'ERC721A: approve caller is not owner nor approved for all'
885         );
886 
887         _approve(to, tokenId, owner);
888     }
889 
890     /**
891      * @dev See {IERC721-getApproved}.
892      */
893     function getApproved(uint256 tokenId) public view override returns (address) {
894         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
895 
896         return _tokenApprovals[tokenId];
897     }
898 
899     /**
900      * @dev See {IERC721-setApprovalForAll}.
901      */
902     function setApprovalForAll(address operator, bool approved) public override {
903         require(operator != _msgSender(), 'ERC721A: approve to caller');
904 
905         _operatorApprovals[_msgSender()][operator] = approved;
906         emit ApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public override {
924         _transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public override {
935         safeTransferFrom(from, to, tokenId, '');
936     }
937 
938     /**
939      * @dev See {IERC721-safeTransferFrom}.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) public override {
947         _transfer(from, to, tokenId);
948         require(
949             _checkOnERC721Received(from, to, tokenId, _data),
950             'ERC721A: transfer to non ERC721Receiver implementer'
951         );
952     }
953 
954     /**
955      * @dev Returns whether `tokenId` exists.
956      *
957      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
958      *
959      * Tokens start existing when they are minted (`_mint`),
960      */
961     function _exists(uint256 tokenId) internal view returns (bool) {
962         return tokenId < currentIndex;
963     }
964 
965     function _safeMint(address to, uint256 quantity) internal {
966         _safeMint(to, quantity, '');
967     }
968 
969     /**
970      * @dev Mints `quantity` tokens and transfers them to `to`.
971      *
972      * Requirements:
973      *
974      * - `to` cannot be the zero address.
975      * - `quantity` cannot be larger than the max batch size.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _safeMint(
980         address to,
981         uint256 quantity,
982         bytes memory _data
983     ) internal {
984         uint256 startTokenId = currentIndex;
985         require(to != address(0), 'ERC721A: mint to the zero address');
986         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
987         require(!_exists(startTokenId), 'ERC721A: token already minted');
988         require(quantity > 0, 'ERC721A: quantity must be greater 0');
989 
990         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
991 
992         AddressData memory addressData = _addressData[to];
993         _addressData[to] = AddressData(
994             addressData.balance + uint128(quantity),
995             addressData.numberMinted + uint128(quantity)
996         );
997         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
998 
999         uint256 updatedIndex = startTokenId;
1000 
1001         for (uint256 i = 0; i < quantity; i++) {
1002             emit Transfer(address(0), to, updatedIndex);
1003             require(
1004                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1005                 'ERC721A: transfer to non ERC721Receiver implementer'
1006             );
1007             updatedIndex++;
1008         }
1009 
1010         currentIndex = updatedIndex;
1011         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1012     }
1013 
1014     /**
1015      * @dev Transfers `tokenId` from `from` to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must be owned by `from`.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _transfer(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) private {
1029         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1030 
1031         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1032             getApproved(tokenId) == _msgSender() ||
1033             isApprovedForAll(prevOwnership.addr, _msgSender()));
1034 
1035         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1036 
1037         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1038         require(to != address(0), 'ERC721A: transfer to the zero address');
1039 
1040         _beforeTokenTransfers(from, to, tokenId, 1);
1041 
1042         // Clear approvals from the previous owner
1043         _approve(address(0), tokenId, prevOwnership.addr);
1044 
1045         // Underflow of the sender's balance is impossible because we check for
1046         // ownership above and the recipient's balance can't realistically overflow.
1047         unchecked {
1048             _addressData[from].balance -= 1;
1049             _addressData[to].balance += 1;
1050         }
1051 
1052         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1053 
1054         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1055         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1056         uint256 nextTokenId = tokenId + 1;
1057         if (_ownerships[nextTokenId].addr == address(0)) {
1058             if (_exists(nextTokenId)) {
1059                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1060             }
1061         }
1062 
1063         emit Transfer(from, to, tokenId);
1064         _afterTokenTransfers(from, to, tokenId, 1);
1065     }
1066 
1067     /**
1068      * @dev Approve `to` to operate on `tokenId`
1069      *
1070      * Emits a {Approval} event.
1071      */
1072     function _approve(
1073         address to,
1074         uint256 tokenId,
1075         address owner
1076     ) private {
1077         _tokenApprovals[tokenId] = to;
1078         emit Approval(owner, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1099                 return retval == IERC721Receiver(to).onERC721Received.selector;
1100             } catch (bytes memory reason) {
1101                 if (reason.length == 0) {
1102                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1116      *
1117      * startTokenId - the first token id to be transferred
1118      * quantity - the amount to be transferred
1119      *
1120      * Calling conditions:
1121      *
1122      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1123      * transferred to `to`.
1124      * - When `from` is zero, `tokenId` will be minted for `to`.
1125      */
1126     function _beforeTokenTransfers(
1127         address from,
1128         address to,
1129         uint256 startTokenId,
1130         uint256 quantity
1131     ) internal virtual {}
1132 
1133     /**
1134      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1135      * minting.
1136      *
1137      * startTokenId - the first token id to be transferred
1138      * quantity - the amount to be transferred
1139      *
1140      * Calling conditions:
1141      *
1142      * - when `from` and `to` are both non-zero.
1143      * - `from` and `to` are never both zero.
1144      */
1145     function _afterTokenTransfers(
1146         address from,
1147         address to,
1148         uint256 startTokenId,
1149         uint256 quantity
1150     ) internal virtual {}
1151 }
1152 
1153 contract AbstractusGalaxias is ERC721A, Ownable {
1154 
1155     string public baseURI = "ipfs://QmboBkgcq5UfKkRoQ3pM2PWU6ksDaGVmDHgcdVNkbmmmvU/";
1156     string public constant baseExtension = ".json";
1157     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1158 
1159     uint256 public constant MAX_PER_TX = 1;
1160     uint256 public constant MAX_PER_WALLET = 2;
1161     uint256 public constant MAX_SUPPLY = 420;
1162     uint256 public constant price = 0 ether;
1163 
1164     bool public paused = false;
1165 
1166     mapping(address => uint256) public addressMinted;
1167 
1168     constructor() ERC721A("AbstractusGalaxias", "AG") {}
1169 
1170     function mint(uint256 _amount) external payable {
1171         address _caller = _msgSender();
1172         require(!paused, "Paused");
1173         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1174         require(_amount > 0, "No 0 mints");
1175         require(tx.origin == _caller, "No contracts");
1176         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1177         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1178         require(_amount * price == msg.value, "Invalid funds provided");
1179          addressMinted[msg.sender] += _amount;
1180         _safeMint(_caller, _amount);
1181     }
1182 
1183     function isApprovedForAll(address owner, address operator)
1184         override
1185         public
1186         view
1187         returns (bool)
1188     {
1189         // Whitelist OpenSea proxy contract for easy trading.
1190         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1191         if (address(proxyRegistry.proxies(owner)) == operator) {
1192             return true;
1193         }
1194 
1195         return super.isApprovedForAll(owner, operator);
1196     }
1197 
1198     function withdraw() external onlyOwner {
1199         uint256 balance = address(this).balance;
1200         (bool success, ) = _msgSender().call{value: balance}("");
1201         require(success, "Failed to send");
1202     }
1203 
1204     function pause(bool _state) external onlyOwner {
1205         paused = _state;
1206     }
1207 
1208     function setBaseURI(string memory baseURI_) external onlyOwner {
1209         baseURI = baseURI_;
1210     }
1211 
1212     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1213         require(_exists(_tokenId), "Token does not exist.");
1214         return bytes(baseURI).length > 0 ? string(
1215             abi.encodePacked(
1216               baseURI,
1217               Strings.toString(_tokenId),
1218               baseExtension
1219             )
1220         ) : "";
1221     }
1222 }
1223 
1224 contract OwnableDelegateProxy { }
1225 contract ProxyRegistry {
1226     mapping(address => OwnableDelegateProxy) public proxies;
1227 }