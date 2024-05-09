1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
2 
3 /*
4                    _    _                    _     
5   __ _ _   _  __ _| | _| |__   ___  __ _  __| |___ 
6  / _` | | | |/ _` | |/ / '_ \ / _ \/ _` |/ _` / __|
7 | (_| | |_| | (_| |   <| | | |  __/ (_| | (_| \__ \
8  \__, |\__,_|\__,_|_|\_\_| |_|\___|\__,_|\__,_|___/
9     |_|                                            
10 */
11 
12 // SPDX-License-Identifier: MIT
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
121 
122 
123 /**
124  * @dev String operations.
125  */
126 library Strings {
127     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
131      */
132     function toString(uint256 value) internal pure returns (string memory) {
133         // Inspired by OraclizeAPI's implementation - MIT licence
134         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
135 
136         if (value == 0) {
137             return "0";
138         }
139         uint256 temp = value;
140         uint256 digits;
141         while (temp != 0) {
142             digits++;
143             temp /= 10;
144         }
145         bytes memory buffer = new bytes(digits);
146         while (value != 0) {
147             digits -= 1;
148             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
149             value /= 10;
150         }
151         return string(buffer);
152     }
153 
154     /**
155      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
156      */
157     function toHexString(uint256 value) internal pure returns (string memory) {
158         if (value == 0) {
159             return "0x00";
160         }
161         uint256 temp = value;
162         uint256 length = 0;
163         while (temp != 0) {
164             length++;
165             temp >>= 8;
166         }
167         return toHexString(value, length);
168     }
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
172      */
173     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
174         bytes memory buffer = new bytes(2 * length + 2);
175         buffer[0] = "0";
176         buffer[1] = "x";
177         for (uint256 i = 2 * length + 1; i > 1; --i) {
178             buffer[i] = _HEX_SYMBOLS[value & 0xf];
179             value >>= 4;
180         }
181         require(value == 0, "Strings: hex length insufficient");
182         return string(buffer);
183     }
184 }
185 
186 
187 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
191 
192 
193 
194 /**
195  * @dev Interface of the ERC165 standard, as defined in the
196  * https://eips.ethereum.org/EIPS/eip-165[EIP].
197  *
198  * Implementers can declare support of contract interfaces, which can then be
199  * queried by others ({ERC165Checker}).
200  *
201  * For an implementation, see {ERC165}.
202  */
203 interface IERC165 {
204     /**
205      * @dev Returns true if this contract implements the interface defined by
206      * `interfaceId`. See the corresponding
207      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
208      * to learn more about how these ids are created.
209      *
210      * This function call must use less than 30 000 gas.
211      */
212     function supportsInterface(bytes4 interfaceId) external view returns (bool);
213 }
214 
215 
216 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
220 
221 
222 
223 /**
224  * @dev Required interface of an ERC721 compliant contract.
225  */
226 interface IERC721 is IERC165 {
227     /**
228      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
231 
232     /**
233      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
234      */
235     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
236 
237     /**
238      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
239      */
240     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
241 
242     /**
243      * @dev Returns the number of tokens in ``owner``'s account.
244      */
245     function balanceOf(address owner) external view returns (uint256 balance);
246 
247     /**
248      * @dev Returns the owner of the `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function ownerOf(uint256 tokenId) external view returns (address owner);
255 
256     /**
257      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
258      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
259      *
260      * Requirements:
261      *
262      * - `from` cannot be the zero address.
263      * - `to` cannot be the zero address.
264      * - `tokenId` token must exist and be owned by `from`.
265      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
267      *
268      * Emits a {Transfer} event.
269      */
270     function safeTransferFrom(
271         address from,
272         address to,
273         uint256 tokenId
274     ) external;
275 
276     /**
277      * @dev Transfers `tokenId` token from `from` to `to`.
278      *
279      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
280      *
281      * Requirements:
282      *
283      * - `from` cannot be the zero address.
284      * - `to` cannot be the zero address.
285      * - `tokenId` token must be owned by `from`.
286      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transferFrom(
291         address from,
292         address to,
293         uint256 tokenId
294     ) external;
295 
296     /**
297      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
298      * The approval is cleared when the token is transferred.
299      *
300      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
301      *
302      * Requirements:
303      *
304      * - The caller must own the token or be an approved operator.
305      * - `tokenId` must exist.
306      *
307      * Emits an {Approval} event.
308      */
309     function approve(address to, uint256 tokenId) external;
310 
311     /**
312      * @dev Returns the account approved for `tokenId` token.
313      *
314      * Requirements:
315      *
316      * - `tokenId` must exist.
317      */
318     function getApproved(uint256 tokenId) external view returns (address operator);
319 
320     /**
321      * @dev Approve or remove `operator` as an operator for the caller.
322      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
323      *
324      * Requirements:
325      *
326      * - The `operator` cannot be the caller.
327      *
328      * Emits an {ApprovalForAll} event.
329      */
330     function setApprovalForAll(address operator, bool _approved) external;
331 
332     /**
333      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
334      *
335      * See {setApprovalForAll}
336      */
337     function isApprovedForAll(address owner, address operator) external view returns (bool);
338 
339     /**
340      * @dev Safely transfers `tokenId` token from `from` to `to`.
341      *
342      * Requirements:
343      *
344      * - `from` cannot be the zero address.
345      * - `to` cannot be the zero address.
346      * - `tokenId` token must exist and be owned by `from`.
347      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
348      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
349      *
350      * Emits a {Transfer} event.
351      */
352     function safeTransferFrom(
353         address from,
354         address to,
355         uint256 tokenId,
356         bytes calldata data
357     ) external;
358 }
359 
360 
361 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
365 
366 
367 
368 /**
369  * @title ERC721 token receiver interface
370  * @dev Interface for any contract that wants to support safeTransfers
371  * from ERC721 asset contracts.
372  */
373 interface IERC721Receiver {
374     /**
375      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
376      * by `operator` from `from`, this function is called.
377      *
378      * It must return its Solidity selector to confirm the token transfer.
379      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
380      *
381      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
382      */
383     function onERC721Received(
384         address operator,
385         address from,
386         uint256 tokenId,
387         bytes calldata data
388     ) external returns (bytes4);
389 }
390 
391 
392 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
396 
397 
398 
399 /**
400  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
401  * @dev See https://eips.ethereum.org/EIPS/eip-721
402  */
403 interface IERC721Metadata is IERC721 {
404     /**
405      * @dev Returns the token collection name.
406      */
407     function name() external view returns (string memory);
408 
409     /**
410      * @dev Returns the token collection symbol.
411      */
412     function symbol() external view returns (string memory);
413 
414     /**
415      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
416      */
417     function tokenURI(uint256 tokenId) external view returns (string memory);
418 }
419 
420 
421 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
425 
426 
427 
428 /**
429  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
430  * @dev See https://eips.ethereum.org/EIPS/eip-721
431  */
432 interface IERC721Enumerable is IERC721 {
433     /**
434      * @dev Returns the total amount of tokens stored by the contract.
435      */
436     function totalSupply() external view returns (uint256);
437 
438     /**
439      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
440      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
441      */
442     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
443 
444     /**
445      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
446      * Use along with {totalSupply} to enumerate all tokens.
447      */
448     function tokenByIndex(uint256 index) external view returns (uint256);
449 }
450 
451 
452 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
456 
457 
458 
459 /**
460  * @dev Collection of functions related to the address type
461  */
462 library Address {
463     /**
464      * @dev Returns true if `account` is a contract.
465      *
466      * [IMPORTANT]
467      * ====
468      * It is unsafe to assume that an address for which this function returns
469      * false is an externally-owned account (EOA) and not a contract.
470      *
471      * Among others, `isContract` will return false for the following
472      * types of addresses:
473      *
474      *  - an externally-owned account
475      *  - a contract in construction
476      *  - an address where a contract will be created
477      *  - an address where a contract lived, but was destroyed
478      * ====
479      */
480     function isContract(address account) internal view returns (bool) {
481         // This method relies on extcodesize, which returns 0 for contracts in
482         // construction, since the code is only stored at the end of the
483         // constructor execution.
484 
485         uint256 size;
486         assembly {
487             size := extcodesize(account)
488         }
489         return size > 0;
490     }
491 
492     /**
493      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
494      * `recipient`, forwarding all available gas and reverting on errors.
495      *
496      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
497      * of certain opcodes, possibly making contracts go over the 2300 gas limit
498      * imposed by `transfer`, making them unable to receive funds via
499      * `transfer`. {sendValue} removes this limitation.
500      *
501      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
502      *
503      * IMPORTANT: because control is transferred to `recipient`, care must be
504      * taken to not create reentrancy vulnerabilities. Consider using
505      * {ReentrancyGuard} or the
506      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
507      */
508     function sendValue(address payable recipient, uint256 amount) internal {
509         require(address(this).balance >= amount, "Address: insufficient balance");
510 
511         (bool success, ) = recipient.call{value: amount}("");
512         require(success, "Address: unable to send value, recipient may have reverted");
513     }
514 
515     /**
516      * @dev Performs a Solidity function call using a low level `call`. A
517      * plain `call` is an unsafe replacement for a function call: use this
518      * function instead.
519      *
520      * If `target` reverts with a revert reason, it is bubbled up by this
521      * function (like regular Solidity function calls).
522      *
523      * Returns the raw returned data. To convert to the expected return value,
524      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
525      *
526      * Requirements:
527      *
528      * - `target` must be a contract.
529      * - calling `target` with `data` must not revert.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
534         return functionCall(target, data, "Address: low-level call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
539      * `errorMessage` as a fallback revert reason when `target` reverts.
540      *
541      * _Available since v3.1._
542      */
543     function functionCall(
544         address target,
545         bytes memory data,
546         string memory errorMessage
547     ) internal returns (bytes memory) {
548         return functionCallWithValue(target, data, 0, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but also transferring `value` wei to `target`.
554      *
555      * Requirements:
556      *
557      * - the calling contract must have an ETH balance of at least `value`.
558      * - the called Solidity function must be `payable`.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(
563         address target,
564         bytes memory data,
565         uint256 value
566     ) internal returns (bytes memory) {
567         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
572      * with `errorMessage` as a fallback revert reason when `target` reverts.
573      *
574      * _Available since v3.1._
575      */
576     function functionCallWithValue(
577         address target,
578         bytes memory data,
579         uint256 value,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         require(address(this).balance >= value, "Address: insufficient balance for call");
583         require(isContract(target), "Address: call to non-contract");
584 
585         (bool success, bytes memory returndata) = target.call{value: value}(data);
586         return verifyCallResult(success, returndata, errorMessage);
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
591      * but performing a static call.
592      *
593      * _Available since v3.3._
594      */
595     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
596         return functionStaticCall(target, data, "Address: low-level static call failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(
606         address target,
607         bytes memory data,
608         string memory errorMessage
609     ) internal view returns (bytes memory) {
610         require(isContract(target), "Address: static call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.staticcall(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
618      * but performing a delegate call.
619      *
620      * _Available since v3.4._
621      */
622     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
623         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
624     }
625 
626     /**
627      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
628      * but performing a delegate call.
629      *
630      * _Available since v3.4._
631      */
632     function functionDelegateCall(
633         address target,
634         bytes memory data,
635         string memory errorMessage
636     ) internal returns (bytes memory) {
637         require(isContract(target), "Address: delegate call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.delegatecall(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
645      * revert reason using the provided one.
646      *
647      * _Available since v4.3._
648      */
649     function verifyCallResult(
650         bool success,
651         bytes memory returndata,
652         string memory errorMessage
653     ) internal pure returns (bytes memory) {
654         if (success) {
655             return returndata;
656         } else {
657             // Look for revert reason and bubble it up if present
658             if (returndata.length > 0) {
659                 // The easiest way to bubble the revert reason is using memory via assembly
660 
661                 assembly {
662                     let returndata_size := mload(returndata)
663                     revert(add(32, returndata), returndata_size)
664                 }
665             } else {
666                 revert(errorMessage);
667             }
668         }
669     }
670 }
671 
672 
673 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
677 
678 
679 
680 /**
681  * @dev Implementation of the {IERC165} interface.
682  *
683  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
684  * for the additional interface id that will be supported. For example:
685  *
686  * ```solidity
687  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
689  * }
690  * ```
691  *
692  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
693  */
694 abstract contract ERC165 is IERC165 {
695     /**
696      * @dev See {IERC165-supportsInterface}.
697      */
698     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
699         return interfaceId == type(IERC165).interfaceId;
700     }
701 }
702 
703 
704 // File contracts/ERC721A.sol
705 
706 
707 // Creator: Chiru Labs
708 
709 
710 /**
711  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
712  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
713  *
714  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
715  *
716  * Does not support burning tokens to address(0).
717  *
718  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
719  */
720 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
721     using Address for address;
722     using Strings for uint256;
723 
724     struct TokenOwnership {
725         address addr;
726         uint64 startTimestamp;
727     }
728 
729     struct AddressData {
730         uint128 balance;
731         uint128 numberMinted;
732     }
733 
734     uint256 internal currentIndex = 0;
735 
736     // Token name
737     string private _name;
738 
739     // Token symbol
740     string private _symbol;
741 
742     // Mapping from token ID to ownership details
743     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
744     mapping(uint256 => TokenOwnership) internal _ownerships;
745 
746     // Mapping owner address to address data
747     mapping(address => AddressData) private _addressData;
748 
749     // Mapping from token ID to approved address
750     mapping(uint256 => address) private _tokenApprovals;
751 
752     // Mapping from owner to operator approvals
753     mapping(address => mapping(address => bool)) private _operatorApprovals;
754 
755     constructor(string memory name_, string memory symbol_) {
756         _name = name_;
757         _symbol = symbol_;
758     }
759 
760     /**
761      * @dev See {IERC721Enumerable-totalSupply}.
762      */
763     function totalSupply() public view override returns (uint256) {
764         return currentIndex;
765     }
766 
767     /**
768      * @dev See {IERC721Enumerable-tokenByIndex}.
769      */
770     function tokenByIndex(uint256 index) public view override returns (uint256) {
771         require(index < totalSupply(), 'ERC721A: global index out of bounds');
772         return index;
773     }
774 
775     /**
776      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
777      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
778      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
779      */
780     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
781         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
782         uint256 numMintedSoFar = totalSupply();
783         uint256 tokenIdsIdx = 0;
784         address currOwnershipAddr = address(0);
785         for (uint256 i = 0; i < numMintedSoFar; i++) {
786             TokenOwnership memory ownership = _ownerships[i];
787             if (ownership.addr != address(0)) {
788                 currOwnershipAddr = ownership.addr;
789             }
790             if (currOwnershipAddr == owner) {
791                 if (tokenIdsIdx == index) {
792                     return i;
793                 }
794                 tokenIdsIdx++;
795             }
796         }
797         revert('ERC721A: unable to get token of owner by index');
798     }
799 
800     /**
801      * @dev See {IERC165-supportsInterface}.
802      */
803     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
804         return
805             interfaceId == type(IERC721).interfaceId ||
806             interfaceId == type(IERC721Metadata).interfaceId ||
807             interfaceId == type(IERC721Enumerable).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view override returns (uint256) {
815         require(owner != address(0), 'ERC721A: balance query for the zero address');
816         return uint256(_addressData[owner].balance);
817     }
818 
819     function _numberMinted(address owner) internal view returns (uint256) {
820         require(owner != address(0), 'ERC721A: number minted query for the zero address');
821         return uint256(_addressData[owner].numberMinted);
822     }
823 
824     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
825         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
826 
827         for (uint256 curr = tokenId; ; curr--) {
828             TokenOwnership memory ownership = _ownerships[curr];
829             if (ownership.addr != address(0)) {
830                 return ownership;
831             }
832         }
833 
834         revert('ERC721A: unable to determine the owner of token');
835     }
836 
837     /**
838      * @dev See {IERC721-ownerOf}.
839      */
840     function ownerOf(uint256 tokenId) public view override returns (address) {
841         return ownershipOf(tokenId).addr;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-name}.
846      */
847     function name() public view virtual override returns (string memory) {
848         return _name;
849     }
850 
851     /**
852      * @dev See {IERC721Metadata-symbol}.
853      */
854     function symbol() public view virtual override returns (string memory) {
855         return _symbol;
856     }
857 
858     /**
859      * @dev See {IERC721Metadata-tokenURI}.
860      */
861     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
862         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
863 
864         string memory baseURI = _baseURI();
865         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
866     }
867 
868     /**
869      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
870      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
871      * by default, can be overriden in child contracts.
872      */
873     function _baseURI() internal view virtual returns (string memory) {
874         return '';
875     }
876 
877     /**
878      * @dev See {IERC721-approve}.
879      */
880     function approve(address to, uint256 tokenId) public override {
881         address owner = ERC721A.ownerOf(tokenId);
882         require(to != owner, 'ERC721A: approval to current owner');
883 
884         require(
885             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
886             'ERC721A: approve caller is not owner nor approved for all'
887         );
888 
889         _approve(to, tokenId, owner);
890     }
891 
892     /**
893      * @dev See {IERC721-getApproved}.
894      */
895     function getApproved(uint256 tokenId) public view override returns (address) {
896         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
897 
898         return _tokenApprovals[tokenId];
899     }
900 
901     /**
902      * @dev See {IERC721-setApprovalForAll}.
903      */
904     function setApprovalForAll(address operator, bool approved) public override {
905         require(operator != _msgSender(), 'ERC721A: approve to caller');
906 
907         _operatorApprovals[_msgSender()][operator] = approved;
908         emit ApprovalForAll(_msgSender(), operator, approved);
909     }
910 
911     /**
912      * @dev See {IERC721-isApprovedForAll}.
913      */
914     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
915         return _operatorApprovals[owner][operator];
916     }
917 
918     /**
919      * @dev See {IERC721-transferFrom}.
920      */
921     function transferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public override {
926         _transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public override {
937         safeTransferFrom(from, to, tokenId, '');
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) public override {
949         _transfer(from, to, tokenId);
950         require(
951             _checkOnERC721Received(from, to, tokenId, _data),
952             'ERC721A: transfer to non ERC721Receiver implementer'
953         );
954     }
955 
956     /**
957      * @dev Returns whether `tokenId` exists.
958      *
959      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
960      *
961      * Tokens start existing when they are minted (`_mint`),
962      */
963     function _exists(uint256 tokenId) internal view returns (bool) {
964         return tokenId < currentIndex;
965     }
966 
967     function _safeMint(address to, uint256 quantity) internal {
968         _safeMint(to, quantity, '');
969     }
970 
971     /**
972      * @dev Mints `quantity` tokens and transfers them to `to`.
973      *
974      * Requirements:
975      *
976      * - `to` cannot be the zero address.
977      * - `quantity` cannot be larger than the max batch size.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _safeMint(
982         address to,
983         uint256 quantity,
984         bytes memory _data
985     ) internal {
986         uint256 startTokenId = currentIndex;
987         require(to != address(0), 'ERC721A: mint to the zero address');
988         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
989         require(!_exists(startTokenId), 'ERC721A: token already minted');
990         require(quantity > 0, 'ERC721A: quantity must be greater 0');
991 
992         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
993 
994         AddressData memory addressData = _addressData[to];
995         _addressData[to] = AddressData(
996             addressData.balance + uint128(quantity),
997             addressData.numberMinted + uint128(quantity)
998         );
999         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1000 
1001         uint256 updatedIndex = startTokenId;
1002 
1003         for (uint256 i = 0; i < quantity; i++) {
1004             emit Transfer(address(0), to, updatedIndex);
1005             require(
1006                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1007                 'ERC721A: transfer to non ERC721Receiver implementer'
1008             );
1009             updatedIndex++;
1010         }
1011 
1012         currentIndex = updatedIndex;
1013         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1014     }
1015 
1016     /**
1017      * @dev Transfers `tokenId` from `from` to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) private {
1031         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1032 
1033         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1034             getApproved(tokenId) == _msgSender() ||
1035             isApprovedForAll(prevOwnership.addr, _msgSender()));
1036 
1037         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1038 
1039         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1040         require(to != address(0), 'ERC721A: transfer to the zero address');
1041 
1042         _beforeTokenTransfers(from, to, tokenId, 1);
1043 
1044         // Clear approvals from the previous owner
1045         _approve(address(0), tokenId, prevOwnership.addr);
1046 
1047         // Underflow of the sender's balance is impossible because we check for
1048         // ownership above and the recipient's balance can't realistically overflow.
1049         unchecked {
1050             _addressData[from].balance -= 1;
1051             _addressData[to].balance += 1;
1052         }
1053 
1054         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1055 
1056         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1057         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1058         uint256 nextTokenId = tokenId + 1;
1059         if (_ownerships[nextTokenId].addr == address(0)) {
1060             if (_exists(nextTokenId)) {
1061                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1062             }
1063         }
1064 
1065         emit Transfer(from, to, tokenId);
1066         _afterTokenTransfers(from, to, tokenId, 1);
1067     }
1068 
1069     /**
1070      * @dev Approve `to` to operate on `tokenId`
1071      *
1072      * Emits a {Approval} event.
1073      */
1074     function _approve(
1075         address to,
1076         uint256 tokenId,
1077         address owner
1078     ) private {
1079         _tokenApprovals[tokenId] = to;
1080         emit Approval(owner, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1085      * The call is not executed if the target address is not a contract.
1086      *
1087      * @param from address representing the previous owner of the given token ID
1088      * @param to target address that will receive the tokens
1089      * @param tokenId uint256 ID of the token to be transferred
1090      * @param _data bytes optional data to send along with the call
1091      * @return bool whether the call correctly returned the expected magic value
1092      */
1093     function _checkOnERC721Received(
1094         address from,
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) private returns (bool) {
1099         if (to.isContract()) {
1100             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1101                 return retval == IERC721Receiver(to).onERC721Received.selector;
1102             } catch (bytes memory reason) {
1103                 if (reason.length == 0) {
1104                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1105                 } else {
1106                     assembly {
1107                         revert(add(32, reason), mload(reason))
1108                     }
1109                 }
1110             }
1111         } else {
1112             return true;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1118      *
1119      * startTokenId - the first token id to be transferred
1120      * quantity - the amount to be transferred
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` will be minted for `to`.
1127      */
1128     function _beforeTokenTransfers(
1129         address from,
1130         address to,
1131         uint256 startTokenId,
1132         uint256 quantity
1133     ) internal virtual {}
1134 
1135     /**
1136      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1137      * minting.
1138      *
1139      * startTokenId - the first token id to be transferred
1140      * quantity - the amount to be transferred
1141      *
1142      * Calling conditions:
1143      *
1144      * - when `from` and `to` are both non-zero.
1145      * - `from` and `to` are never both zero.
1146      */
1147     function _afterTokenTransfers(
1148         address from,
1149         address to,
1150         uint256 startTokenId,
1151         uint256 quantity
1152     ) internal virtual {}
1153 }
1154 
1155 
1156 // File contracts/Quakheads.sol
1157 
1158 
1159 contract Quakheads is ERC721A, Ownable {
1160 
1161     string public baseURI = "";
1162     string public contractURI = "";
1163     string public constant baseExtension = ".json";
1164     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1165 
1166     uint256 public constant MAX_PER_TX = 1;
1167     uint256 public constant MAX_SUPPLY = 6666;
1168     uint256 public constant MAX_PER_WALLET = 1;
1169 
1170     bool public paused = true;
1171     bool hasClaimedReserved = false;
1172 
1173     constructor() ERC721A("Quakheads", "QUAK") {}
1174 
1175     function mint() external {
1176         address _caller = _msgSender();
1177         uint256 ownerTokenCount = balanceOf(_caller);
1178         require(!paused, "Paused");
1179         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1180         require(tx.origin == _caller, "No contracts");
1181         require(ownerTokenCount < MAX_PER_WALLET, "Exceeds max token count per wallet");
1182 
1183         _safeMint(_caller, 1);
1184     }
1185 
1186     function isApprovedForAll(address owner, address operator)
1187         override
1188         public
1189         view
1190         returns (bool)
1191     {
1192         // Whitelist OpenSea proxy contract for easy trading.
1193         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1194         if (address(proxyRegistry.proxies(owner)) == operator) {
1195             return true;
1196         }
1197 
1198         return super.isApprovedForAll(owner, operator);
1199     }
1200 
1201     function withdraw() external onlyOwner {
1202         uint256 balance = address(this).balance;
1203         (bool success, ) = _msgSender().call{value: balance}("");
1204         require(success, "Failed to send");
1205     }
1206 
1207     function setup() external onlyOwner {
1208          require(MAX_SUPPLY >= totalSupply() + 66, "Exceeds max supply");
1209          require(!hasClaimedReserved, "Team reserve already claimed");
1210          hasClaimedReserved = true;
1211         _safeMint(_msgSender(), 66);
1212     }
1213 
1214     function pause(bool _state) external onlyOwner {
1215         paused = _state;
1216     }
1217 
1218     function setBaseURI(string memory baseURI_) external onlyOwner {
1219         baseURI = baseURI_;
1220     }
1221 
1222     function setContractURI(string memory _contractURI) external onlyOwner {
1223         contractURI = _contractURI;
1224     }
1225 
1226     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1227         require(_exists(_tokenId), "Token does not exist.");
1228         return bytes(baseURI).length > 0 ? string(
1229             abi.encodePacked(
1230               baseURI,
1231               Strings.toString(_tokenId),
1232               baseExtension
1233             )
1234         ) : "";
1235     }
1236 }
1237 
1238 contract OwnableDelegateProxy { }
1239 contract ProxyRegistry {
1240     mapping(address => OwnableDelegateProxy) public proxies;
1241 }