1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-16
7 */
8 
9 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
10 
11 // SPDX-License-Identifier: MIT
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 
39 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
40 
41 
42 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
43 
44 
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
121 
122 
123 
124 /**
125  * @dev String operations.
126  */
127 library Strings {
128     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
132      */
133     function toString(uint256 value) internal pure returns (string memory) {
134         // Inspired by OraclizeAPI's implementation - MIT licence
135         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
136 
137         if (value == 0) {
138             return "0";
139         }
140         uint256 temp = value;
141         uint256 digits;
142         while (temp != 0) {
143             digits++;
144             temp /= 10;
145         }
146         bytes memory buffer = new bytes(digits);
147         while (value != 0) {
148             digits -= 1;
149             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
150             value /= 10;
151         }
152         return string(buffer);
153     }
154 
155     /**
156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
157      */
158     function toHexString(uint256 value) internal pure returns (string memory) {
159         if (value == 0) {
160             return "0x00";
161         }
162         uint256 temp = value;
163         uint256 length = 0;
164         while (temp != 0) {
165             length++;
166             temp >>= 8;
167         }
168         return toHexString(value, length);
169     }
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
173      */
174     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
175         bytes memory buffer = new bytes(2 * length + 2);
176         buffer[0] = "0";
177         buffer[1] = "x";
178         for (uint256 i = 2 * length + 1; i > 1; --i) {
179             buffer[i] = _HEX_SYMBOLS[value & 0xf];
180             value >>= 4;
181         }
182         require(value == 0, "Strings: hex length insufficient");
183         return string(buffer);
184     }
185 }
186 
187 
188 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
189 
190 
191 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
192 
193 
194 
195 /**
196  * @dev Interface of the ERC165 standard, as defined in the
197  * https://eips.ethereum.org/EIPS/eip-165[EIP].
198  *
199  * Implementers can declare support of contract interfaces, which can then be
200  * queried by others ({ERC165Checker}).
201  *
202  * For an implementation, see {ERC165}.
203  */
204 interface IERC165 {
205     /**
206      * @dev Returns true if this contract implements the interface defined by
207      * `interfaceId`. See the corresponding
208      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
209      * to learn more about how these ids are created.
210      *
211      * This function call must use less than 30 000 gas.
212      */
213     function supportsInterface(bytes4 interfaceId) external view returns (bool);
214 }
215 
216 
217 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
218 
219 
220 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
221 
222 
223 
224 /**
225  * @dev Required interface of an ERC721 compliant contract.
226  */
227 interface IERC721 is IERC165 {
228     /**
229      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
232 
233     /**
234      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
235      */
236     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
240      */
241     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
242 
243     /**
244      * @dev Returns the number of tokens in ``owner``'s account.
245      */
246     function balanceOf(address owner) external view returns (uint256 balance);
247 
248     /**
249      * @dev Returns the owner of the `tokenId` token.
250      *
251      * Requirements:
252      *
253      * - `tokenId` must exist.
254      */
255     function ownerOf(uint256 tokenId) external view returns (address owner);
256 
257     /**
258      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
259      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
260      *
261      * Requirements:
262      *
263      * - `from` cannot be the zero address.
264      * - `to` cannot be the zero address.
265      * - `tokenId` token must exist and be owned by `from`.
266      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
267      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
268      *
269      * Emits a {Transfer} event.
270      */
271     function safeTransferFrom(
272         address from,
273         address to,
274         uint256 tokenId
275     ) external;
276 
277     /**
278      * @dev Transfers `tokenId` token from `from` to `to`.
279      *
280      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
281      *
282      * Requirements:
283      *
284      * - `from` cannot be the zero address.
285      * - `to` cannot be the zero address.
286      * - `tokenId` token must be owned by `from`.
287      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transferFrom(
292         address from,
293         address to,
294         uint256 tokenId
295     ) external;
296 
297     /**
298      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
299      * The approval is cleared when the token is transferred.
300      *
301      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
302      *
303      * Requirements:
304      *
305      * - The caller must own the token or be an approved operator.
306      * - `tokenId` must exist.
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address to, uint256 tokenId) external;
311 
312     /**
313      * @dev Returns the account approved for `tokenId` token.
314      *
315      * Requirements:
316      *
317      * - `tokenId` must exist.
318      */
319     function getApproved(uint256 tokenId) external view returns (address operator);
320 
321     /**
322      * @dev Approve or remove `operator` as an operator for the caller.
323      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
324      *
325      * Requirements:
326      *
327      * - The `operator` cannot be the caller.
328      *
329      * Emits an {ApprovalForAll} event.
330      */
331     function setApprovalForAll(address operator, bool _approved) external;
332 
333     /**
334      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
335      *
336      * See {setApprovalForAll}
337      */
338     function isApprovedForAll(address owner, address operator) external view returns (bool);
339 
340     /**
341      * @dev Safely transfers `tokenId` token from `from` to `to`.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `tokenId` token must exist and be owned by `from`.
348      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
349      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
350      *
351      * Emits a {Transfer} event.
352      */
353     function safeTransferFrom(
354         address from,
355         address to,
356         uint256 tokenId,
357         bytes calldata data
358     ) external;
359 }
360 
361 
362 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
366 
367 
368 
369 /**
370  * @title ERC721 token receiver interface
371  * @dev Interface for any contract that wants to support safeTransfers
372  * from ERC721 asset contracts.
373  */
374 interface IERC721Receiver {
375     /**
376      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
377      * by `operator` from `from`, this function is called.
378      *
379      * It must return its Solidity selector to confirm the token transfer.
380      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
381      *
382      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
383      */
384     function onERC721Received(
385         address operator,
386         address from,
387         uint256 tokenId,
388         bytes calldata data
389     ) external returns (bytes4);
390 }
391 
392 
393 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
394 
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
397 
398 
399 
400 /**
401  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
402  * @dev See https://eips.ethereum.org/EIPS/eip-721
403  */
404 interface IERC721Metadata is IERC721 {
405     /**
406      * @dev Returns the token collection name.
407      */
408     function name() external view returns (string memory);
409 
410     /**
411      * @dev Returns the token collection symbol.
412      */
413     function symbol() external view returns (string memory);
414 
415     /**
416      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
417      */
418     function tokenURI(uint256 tokenId) external view returns (string memory);
419 }
420 
421 
422 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
426 
427 
428 
429 /**
430  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
431  * @dev See https://eips.ethereum.org/EIPS/eip-721
432  */
433 interface IERC721Enumerable is IERC721 {
434     /**
435      * @dev Returns the total amount of tokens stored by the contract.
436      */
437     function totalSupply() external view returns (uint256);
438 
439     
440     
441     /**
442      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
443      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
444      */
445     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
446 
447     /**
448      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
449      * Use along with {totalSupply} to enumerate all tokens.
450      */
451     function tokenByIndex(uint256 index) external view returns (uint256);
452 }
453 
454 
455 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
456 
457 
458 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
459 
460 
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      */
483     function isContract(address account) internal view returns (bool) {
484         // This method relies on extcodesize, which returns 0 for contracts in
485         // construction, since the code is only stored at the end of the
486         // constructor execution.
487 
488         uint256 size;
489         assembly {
490             size := extcodesize(account)
491         }
492         return size > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         (bool success, ) = recipient.call{value: amount}("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain `call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537         return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal returns (bytes memory) {
551         return functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(
566         address target,
567         bytes memory data,
568         uint256 value
569     ) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(
580         address target,
581         bytes memory data,
582         uint256 value,
583         string memory errorMessage
584     ) internal returns (bytes memory) {
585         require(address(this).balance >= value, "Address: insufficient balance for call");
586         require(isContract(target), "Address: call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.call{value: value}(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
599         return functionStaticCall(target, data, "Address: low-level static call failed");
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
604      * but performing a static call.
605      *
606      * _Available since v3.3._
607      */
608     function functionStaticCall(
609         address target,
610         bytes memory data,
611         string memory errorMessage
612     ) internal view returns (bytes memory) {
613         require(isContract(target), "Address: static call to non-contract");
614 
615         (bool success, bytes memory returndata) = target.staticcall(data);
616         return verifyCallResult(success, returndata, errorMessage);
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
621      * but performing a delegate call.
622      *
623      * _Available since v3.4._
624      */
625     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
626         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
627     }
628 
629     /**
630      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
631      * but performing a delegate call.
632      *
633      * _Available since v3.4._
634      */
635     function functionDelegateCall(
636         address target,
637         bytes memory data,
638         string memory errorMessage
639     ) internal returns (bytes memory) {
640         require(isContract(target), "Address: delegate call to non-contract");
641 
642         (bool success, bytes memory returndata) = target.delegatecall(data);
643         return verifyCallResult(success, returndata, errorMessage);
644     }
645 
646     /**
647      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
648      * revert reason using the provided one.
649      *
650      * _Available since v4.3._
651      */
652     function verifyCallResult(
653         bool success,
654         bytes memory returndata,
655         string memory errorMessage
656     ) internal pure returns (bytes memory) {
657         if (success) {
658             return returndata;
659         } else {
660             // Look for revert reason and bubble it up if present
661             if (returndata.length > 0) {
662                 // The easiest way to bubble the revert reason is using memory via assembly
663 
664                 assembly {
665                     let returndata_size := mload(returndata)
666                     revert(add(32, returndata), returndata_size)
667                 }
668             } else {
669                 revert(errorMessage);
670             }
671         }
672     }
673 }
674 
675 
676 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
680 
681 
682 
683 /**
684  * @dev Implementation of the {IERC165} interface.
685  *
686  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
687  * for the additional interface id that will be supported. For example:
688  *
689  * ```solidity
690  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
692  * }
693  * ```
694  *
695  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
696  */
697 abstract contract ERC165 is IERC165 {
698     /**
699      * @dev See {IERC165-supportsInterface}.
700      */
701     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
702         return interfaceId == type(IERC165).interfaceId;
703     }
704 }
705 
706 
707 // File contracts/ERC721A.sol
708 
709 
710 // Creator: Chiru Labs
711 
712 
713 /**
714  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
715  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
716  *
717  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
718  *
719  * Does not support burning tokens to address(0).
720  *
721  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
722  */
723 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
724     using Address for address;
725     using Strings for uint256;
726 
727     struct TokenOwnership {
728         address addr;
729         uint64 startTimestamp;
730     }
731 
732     struct AddressData {
733         uint128 balance;
734         uint128 numberMinted;
735     }
736 
737     uint256 internal currentIndex = 0;
738 
739     // Token name
740     string private _name;
741 
742     // Token symbol
743     string private _symbol;
744 
745     
746 
747     // Mapping from token ID to ownership details
748     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
749     mapping(uint256 => TokenOwnership) internal _ownerships;
750 
751     // Mapping owner address to address data
752     mapping(address => AddressData) private _addressData;
753 
754     // Mapping from token ID to approved address
755     mapping(uint256 => address) private _tokenApprovals;
756 
757     // Mapping from owner to operator approvals
758     mapping(address => mapping(address => bool)) private _operatorApprovals;
759 
760     constructor(string memory name_, string memory symbol_) {
761         _name = name_;
762         _symbol = symbol_;
763     }
764 
765     /**
766      * @dev See {IERC721Enumerable-totalSupply}.
767      */
768     function totalSupply() public view override returns (uint256) {
769         return currentIndex;
770     }
771 
772           function _startTokenId() internal view virtual returns (uint256) {
773         return 0;
774     }
775 
776 
777       function _totalMinted() internal view returns (uint256) {
778         // Counter underflow is impossible as _currentIndex does not decrement,
779         // and it is initialized to _startTokenId()
780         unchecked {
781             return currentIndex - _startTokenId();
782         }
783     }
784 
785     /**
786      * @dev See {IERC721Enumerable-tokenByIndex}.
787      */
788     function tokenByIndex(uint256 index) public view override returns (uint256) {
789         require(index < totalSupply(), 'ERC721A: global index out of bounds');
790         return index;
791     }
792 
793     /**
794      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
795      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
796      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
797      */
798     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
799         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
800         uint256 numMintedSoFar = totalSupply();
801         uint256 tokenIdsIdx = 0;
802         address currOwnershipAddr = address(0);
803         for (uint256 i = 0; i < numMintedSoFar; i++) {
804             TokenOwnership memory ownership = _ownerships[i];
805             if (ownership.addr != address(0)) {
806                 currOwnershipAddr = ownership.addr;
807             }
808             if (currOwnershipAddr == owner) {
809                 if (tokenIdsIdx == index) {
810                     return i;
811                 }
812                 tokenIdsIdx++;
813             }
814         }
815         revert('ERC721A: unable to get token of owner by index');
816     }
817 
818     /**
819      * @dev See {IERC165-supportsInterface}.
820      */
821     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
822         return
823             interfaceId == type(IERC721).interfaceId ||
824             interfaceId == type(IERC721Metadata).interfaceId ||
825             interfaceId == type(IERC721Enumerable).interfaceId ||
826             super.supportsInterface(interfaceId);
827     }
828 
829     /**
830      * @dev See {IERC721-balanceOf}.
831      */
832     function balanceOf(address owner) public view override returns (uint256) {
833         require(owner != address(0), 'ERC721A: balance query for the zero address');
834         return uint256(_addressData[owner].balance);
835     }
836 
837     function _numberMinted(address owner) internal view returns (uint256) {
838         require(owner != address(0), 'ERC721A: number minted query for the zero address');
839         return uint256(_addressData[owner].numberMinted);
840     }
841 
842     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
843         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
844 
845         for (uint256 curr = tokenId; ; curr--) {
846             TokenOwnership memory ownership = _ownerships[curr];
847             if (ownership.addr != address(0)) {
848                 return ownership;
849             }
850         }
851 
852         revert('ERC721A: unable to determine the owner of token');
853     }
854 
855     /**
856      * @dev See {IERC721-ownerOf}.
857      */
858     function ownerOf(uint256 tokenId) public view override returns (address) {
859         return ownershipOf(tokenId).addr;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-name}.
864      */
865     function name() public view virtual override returns (string memory) {
866         return _name;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-symbol}.
871      */
872     function symbol() public view virtual override returns (string memory) {
873         return _symbol;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-tokenURI}.
878      */
879     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
880         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
881 
882         string memory baseURI = _baseURI();
883         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
884     }
885 
886     /**
887      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
888      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
889      * by default, can be overriden in child contracts.
890      */
891     function _baseURI() internal view virtual returns (string memory) {
892         return '';
893     }
894 
895     /**
896      * @dev See {IERC721-approve}.
897      */
898     function approve(address to, uint256 tokenId) public override {
899         address owner = ERC721A.ownerOf(tokenId);
900         require(to != owner, 'ERC721A: approval to current owner');
901 
902         require(
903             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
904             'ERC721A: approve caller is not owner nor approved for all'
905         );
906 
907         _approve(to, tokenId, owner);
908     }
909 
910     /**
911      * @dev See {IERC721-getApproved}.
912      */
913     function getApproved(uint256 tokenId) public view override returns (address) {
914         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
915 
916         return _tokenApprovals[tokenId];
917     }
918 
919     /**
920      * @dev See {IERC721-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public override {
923         require(operator != _msgSender(), 'ERC721A: approve to caller');
924 
925         _operatorApprovals[_msgSender()][operator] = approved;
926         emit ApprovalForAll(_msgSender(), operator, approved);
927     }
928 
929     /**
930      * @dev See {IERC721-isApprovedForAll}.
931      */
932     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
933         return _operatorApprovals[owner][operator];
934     }
935 
936     /**
937      * @dev See {IERC721-transferFrom}.
938      */
939     function transferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public override {
944         _transfer(from, to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-safeTransferFrom}.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public override {
955         safeTransferFrom(from, to, tokenId, '');
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) public override {
967         _transfer(from, to, tokenId);
968         require(
969             _checkOnERC721Received(from, to, tokenId, _data),
970             'ERC721A: transfer to non ERC721Receiver implementer'
971         );
972     }
973 
974     /**
975      * @dev Returns whether `tokenId` exists.
976      *
977      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
978      *
979      * Tokens start existing when they are minted (`_mint`),
980      */
981     function _exists(uint256 tokenId) internal view returns (bool) {
982         return tokenId < currentIndex;
983     }
984 
985     function _safeMint(address to, uint256 quantity) internal {
986         _safeMint(to, quantity, '');
987     }
988 
989     /**
990      * @dev Mints `quantity` tokens and transfers them to `to`.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `quantity` cannot be larger than the max batch size.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _safeMint(
1000         address to,
1001         uint256 quantity,
1002         bytes memory _data
1003     ) internal {
1004         uint256 startTokenId = currentIndex;
1005         require(to != address(0), 'ERC721A: mint to the zero address');
1006         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1007         require(!_exists(startTokenId), 'ERC721A: token already minted');
1008         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1009 
1010         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1011 
1012         AddressData memory addressData = _addressData[to];
1013         _addressData[to] = AddressData(
1014             addressData.balance + uint128(quantity),
1015             addressData.numberMinted + uint128(quantity)
1016         );
1017         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1018 
1019         uint256 updatedIndex = startTokenId;
1020 
1021         for (uint256 i = 0; i < quantity; i++) {
1022             emit Transfer(address(0), to, updatedIndex);
1023             require(
1024                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1025                 'ERC721A: transfer to non ERC721Receiver implementer'
1026             );
1027             updatedIndex++;
1028         }
1029 
1030         currentIndex = updatedIndex;
1031         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1032     }
1033 
1034     /**
1035      * @dev Transfers `tokenId` from `from` to `to`.
1036      *
1037      * Requirements:
1038      *
1039      * - `to` cannot be the zero address.
1040      * - `tokenId` token must be owned by `from`.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) private {
1049         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1050 
1051         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1052             getApproved(tokenId) == _msgSender() ||
1053             isApprovedForAll(prevOwnership.addr, _msgSender()));
1054 
1055         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1056 
1057         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1058         require(to != address(0), 'ERC721A: transfer to the zero address');
1059 
1060         _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner
1063         _approve(address(0), tokenId, prevOwnership.addr);
1064 
1065         // Underflow of the sender's balance is impossible because we check for
1066         // ownership above and the recipient's balance can't realistically overflow.
1067         unchecked {
1068             _addressData[from].balance -= 1;
1069             _addressData[to].balance += 1;
1070         }
1071 
1072         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1073 
1074         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1075         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1076         uint256 nextTokenId = tokenId + 1;
1077         if (_ownerships[nextTokenId].addr == address(0)) {
1078             if (_exists(nextTokenId)) {
1079                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1080             }
1081         }
1082 
1083         emit Transfer(from, to, tokenId);
1084         _afterTokenTransfers(from, to, tokenId, 1);
1085     }
1086 
1087     /**
1088      * @dev Approve `to` to operate on `tokenId`
1089      *
1090      * Emits a {Approval} event.
1091      */
1092     function _approve(
1093         address to,
1094         uint256 tokenId,
1095         address owner
1096     ) private {
1097         _tokenApprovals[tokenId] = to;
1098         emit Approval(owner, to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1103      * The call is not executed if the target address is not a contract.
1104      *
1105      * @param from address representing the previous owner of the given token ID
1106      * @param to target address that will receive the tokens
1107      * @param tokenId uint256 ID of the token to be transferred
1108      * @param _data bytes optional data to send along with the call
1109      * @return bool whether the call correctly returned the expected magic value
1110      */
1111     function _checkOnERC721Received(
1112         address from,
1113         address to,
1114         uint256 tokenId,
1115         bytes memory _data
1116     ) private returns (bool) {
1117         if (to.isContract()) {
1118             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1119                 return retval == IERC721Receiver(to).onERC721Received.selector;
1120             } catch (bytes memory reason) {
1121                 if (reason.length == 0) {
1122                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1123                 } else {
1124                     assembly {
1125                         revert(add(32, reason), mload(reason))
1126                     }
1127                 }
1128             }
1129         } else {
1130             return true;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1136      *
1137      * startTokenId - the first token id to be transferred
1138      * quantity - the amount to be transferred
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      */
1146     function _beforeTokenTransfers(
1147         address from,
1148         address to,
1149         uint256 startTokenId,
1150         uint256 quantity
1151     ) internal virtual {}
1152 
1153     /**
1154      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1155      * minting.
1156      *
1157      * startTokenId - the first token id to be transferred
1158      * quantity - the amount to be transferred
1159      *
1160      * Calling conditions:
1161      *
1162      * - when `from` and `to` are both non-zero.
1163      * - `from` and `to` are never both zero.
1164      */
1165     function _afterTokenTransfers(
1166         address from,
1167         address to,
1168         uint256 startTokenId,
1169         uint256 quantity
1170     ) internal virtual {}
1171 }
1172 
1173 
1174 
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 
1179 contract EtherTitanz is ERC721A, Ownable {
1180 	using Strings for uint;
1181 
1182 	uint public constant MINT_PRICE = 0.005 ether;
1183 	uint public constant MAX_NFT_PER_TITAN = 20;
1184 	uint public maxSupply = 6000;
1185 
1186 	bool public isPaused = false;
1187     bool public isMetadataFinal;
1188     string private _baseURL;
1189 	string public prerevealURL = '';
1190 	mapping(address => uint) private _walletMintedCount;
1191 
1192 	constructor()
1193 	ERC721A('EtherTitanz', 'ETZ') {
1194     }
1195 
1196 	function _baseURI() internal pure override returns (string memory) {
1197 		return "https://skyline.mypinata.cloud/ipfs/QmPVpLrWvEqeL1hL9xmEAEv4zLikyXrKXuEfdXBvAMj1k8/";
1198 	}
1199 
1200 
1201 
1202 	function _startTokenId() internal pure override returns (uint) {
1203 		return 1;
1204 	}
1205   
1206 
1207 
1208 	function contractURI() public pure returns (string memory) {
1209 		return "https://skyline.mypinata.cloud/ipfs/QmPVpLrWvEqeL1hL9xmEAEv4zLikyXrKXuEfdXBvAMj1k8/";
1210 	}
1211 
1212     function finalizeMetadata() external onlyOwner {
1213         isMetadataFinal = true;
1214     }
1215 
1216 	function reveal(string memory url) external onlyOwner {
1217         require(!isMetadataFinal, "Metadata is finalized");
1218 		_baseURL = url;
1219 	}
1220 
1221     function mintedCount(address owner) external view returns (uint) {
1222         return _walletMintedCount[owner];
1223     }
1224 
1225 	function setPause(bool value) external onlyOwner {
1226 		isPaused = value;
1227 	}
1228 
1229   function withdraw() external onlyOwner {
1230         uint256 balance = address(this).balance;
1231         (bool success, ) = _msgSender().call{value: balance}("");
1232         require(success, "Failed to send");
1233     }
1234 
1235 	function airdrop(address to, uint count) external onlyOwner {
1236 		require(
1237 			_totalMinted() + count <= maxSupply,
1238 			'Exceeds max supply'
1239 		);
1240 		_safeMint(to, count);
1241 	}
1242 
1243 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1244 		maxSupply = newMaxSupply;
1245 	}
1246 
1247 	function tokenURI(uint tokenId)
1248 		public
1249 		view
1250 		override
1251 		returns (string memory)
1252 	{
1253         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1254 
1255         return bytes(_baseURI()).length > 0 
1256             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1257             : prerevealURL;
1258 	}
1259 
1260 	function mint(uint count) external payable {
1261 		require(!isPaused, 'Sales are off');
1262 		require(count <= MAX_NFT_PER_TITAN,'Exceeds NFT per saction limit');
1263 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1264 
1265         //Free Mints
1266         uint payForCount = count;
1267         uint mintedSoFar = _walletMintedCount[msg.sender];
1268         if(mintedSoFar < 2) {
1269             uint remainingFreeMints = 2 - mintedSoFar;
1270             if(count > remainingFreeMints) {
1271                 payForCount = count - remainingFreeMints;
1272             }
1273             else {
1274                 payForCount = 0;
1275             }
1276         }
1277 
1278 		require(
1279 			msg.value >= payForCount * MINT_PRICE,
1280 			'Ether value sent is not sufficient'
1281 		);
1282 
1283 		_walletMintedCount[msg.sender] += count;
1284 		_safeMint(msg.sender, count);
1285 	}
1286 
1287 
1288     function mintZero(uint count) external  onlyOwner{ 
1289         _safeMint(msg.sender,count);
1290     }
1291 
1292 }