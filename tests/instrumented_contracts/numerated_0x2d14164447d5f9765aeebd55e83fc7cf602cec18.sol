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
12 
13 //  _____ _ _ _                
14 // | ____| | (_)_ __  ___  ___ 
15 // |  _| | | | | '_ \/ __|/ _ \
16 // | |___| | | | |_) \__ \  __/
17 // |_____|_|_|_| .__/|___/\___|
18 //             |_|             
19 
20                                  
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 
43 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
47 
48 
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby removing any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 
121 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
125 
126 
127 
128 /**
129  * @dev String operations.
130  */
131 library Strings {
132     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
133 
134     /**
135      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
136      */
137     function toString(uint256 value) internal pure returns (string memory) {
138         // Inspired by OraclizeAPI's implementation - MIT licence
139         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
140 
141         if (value == 0) {
142             return "0";
143         }
144         uint256 temp = value;
145         uint256 digits;
146         while (temp != 0) {
147             digits++;
148             temp /= 10;
149         }
150         bytes memory buffer = new bytes(digits);
151         while (value != 0) {
152             digits -= 1;
153             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
154             value /= 10;
155         }
156         return string(buffer);
157     }
158 
159     /**
160      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
161      */
162     function toHexString(uint256 value) internal pure returns (string memory) {
163         if (value == 0) {
164             return "0x00";
165         }
166         uint256 temp = value;
167         uint256 length = 0;
168         while (temp != 0) {
169             length++;
170             temp >>= 8;
171         }
172         return toHexString(value, length);
173     }
174 
175     /**
176      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
177      */
178     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
179         bytes memory buffer = new bytes(2 * length + 2);
180         buffer[0] = "0";
181         buffer[1] = "x";
182         for (uint256 i = 2 * length + 1; i > 1; --i) {
183             buffer[i] = _HEX_SYMBOLS[value & 0xf];
184             value >>= 4;
185         }
186         require(value == 0, "Strings: hex length insufficient");
187         return string(buffer);
188     }
189 }
190 
191 
192 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
196 
197 
198 
199 /**
200  * @dev Interface of the ERC165 standard, as defined in the
201  * https://eips.ethereum.org/EIPS/eip-165[EIP].
202  *
203  * Implementers can declare support of contract interfaces, which can then be
204  * queried by others ({ERC165Checker}).
205  *
206  * For an implementation, see {ERC165}.
207  */
208 interface IERC165 {
209     /**
210      * @dev Returns true if this contract implements the interface defined by
211      * `interfaceId`. See the corresponding
212      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
213      * to learn more about how these ids are created.
214      *
215      * This function call must use less than 30 000 gas.
216      */
217     function supportsInterface(bytes4 interfaceId) external view returns (bool);
218 }
219 
220 
221 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
225 
226 
227 
228 /**
229  * @dev Required interface of an ERC721 compliant contract.
230  */
231 interface IERC721 is IERC165 {
232     /**
233      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
236 
237     /**
238      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
239      */
240     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
241 
242     /**
243      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
244      */
245     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
246 
247     /**
248      * @dev Returns the number of tokens in ``owner``'s account.
249      */
250     function balanceOf(address owner) external view returns (uint256 balance);
251 
252     /**
253      * @dev Returns the owner of the `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function ownerOf(uint256 tokenId) external view returns (address owner);
260 
261     /**
262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId
279     ) external;
280 
281     /**
282      * @dev Transfers `tokenId` token from `from` to `to`.
283      *
284      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must be owned by `from`.
291      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300 
301     /**
302      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
303      * The approval is cleared when the token is transferred.
304      *
305      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
306      *
307      * Requirements:
308      *
309      * - The caller must own the token or be an approved operator.
310      * - `tokenId` must exist.
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address to, uint256 tokenId) external;
315 
316     /**
317      * @dev Returns the account approved for `tokenId` token.
318      *
319      * Requirements:
320      *
321      * - `tokenId` must exist.
322      */
323     function getApproved(uint256 tokenId) external view returns (address operator);
324 
325     /**
326      * @dev Approve or remove `operator` as an operator for the caller.
327      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
328      *
329      * Requirements:
330      *
331      * - The `operator` cannot be the caller.
332      *
333      * Emits an {ApprovalForAll} event.
334      */
335     function setApprovalForAll(address operator, bool _approved) external;
336 
337     /**
338      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
339      *
340      * See {setApprovalForAll}
341      */
342     function isApprovedForAll(address owner, address operator) external view returns (bool);
343 
344     /**
345      * @dev Safely transfers `tokenId` token from `from` to `to`.
346      *
347      * Requirements:
348      *
349      * - `from` cannot be the zero address.
350      * - `to` cannot be the zero address.
351      * - `tokenId` token must exist and be owned by `from`.
352      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
353      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
354      *
355      * Emits a {Transfer} event.
356      */
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId,
361         bytes calldata data
362     ) external;
363 }
364 
365 
366 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
367 
368 
369 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
370 
371 
372 
373 /**
374  * @title ERC721 token receiver interface
375  * @dev Interface for any contract that wants to support safeTransfers
376  * from ERC721 asset contracts.
377  */
378 interface IERC721Receiver {
379     /**
380      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
381      * by `operator` from `from`, this function is called.
382      *
383      * It must return its Solidity selector to confirm the token transfer.
384      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
385      *
386      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
387      */
388     function onERC721Received(
389         address operator,
390         address from,
391         uint256 tokenId,
392         bytes calldata data
393     ) external returns (bytes4);
394 }
395 
396 
397 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
398 
399 
400 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
401 
402 
403 
404 /**
405  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
406  * @dev See https://eips.ethereum.org/EIPS/eip-721
407  */
408 interface IERC721Metadata is IERC721 {
409     /**
410      * @dev Returns the token collection name.
411      */
412     function name() external view returns (string memory);
413 
414     /**
415      * @dev Returns the token collection symbol.
416      */
417     function symbol() external view returns (string memory);
418 
419     /**
420      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
421      */
422     function tokenURI(uint256 tokenId) external view returns (string memory);
423 }
424 
425 
426 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
430 
431 
432 
433 /**
434  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
435  * @dev See https://eips.ethereum.org/EIPS/eip-721
436  */
437 interface IERC721Enumerable is IERC721 {
438     /**
439      * @dev Returns the total amount of tokens stored by the contract.
440      */
441     function totalSupply() external view returns (uint256);
442 
443     /**
444      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
445      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
446      */
447     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
448 
449     /**
450      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
451      * Use along with {totalSupply} to enumerate all tokens.
452      */
453     function tokenByIndex(uint256 index) external view returns (uint256);
454 }
455 
456 
457 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
461 
462 
463 
464 /**
465  * @dev Collection of functions related to the address type
466  */
467 library Address {
468     /**
469      * @dev Returns true if `account` is a contract.
470      *
471      * [IMPORTANT]
472      * ====
473      * It is unsafe to assume that an address for which this function returns
474      * false is an externally-owned account (EOA) and not a contract.
475      *
476      * Among others, `isContract` will return false for the following
477      * types of addresses:
478      *
479      *  - an externally-owned account
480      *  - a contract in construction
481      *  - an address where a contract will be created
482      *  - an address where a contract lived, but was destroyed
483      * ====
484      */
485     function isContract(address account) internal view returns (bool) {
486         // This method relies on extcodesize, which returns 0 for contracts in
487         // construction, since the code is only stored at the end of the
488         // constructor execution.
489 
490         uint256 size;
491         assembly {
492             size := extcodesize(account)
493         }
494         return size > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         (bool success, ) = recipient.call{value: amount}("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain `call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionCall(target, data, "Address: low-level call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
544      * `errorMessage` as a fallback revert reason when `target` reverts.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, 0, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but also transferring `value` wei to `target`.
559      *
560      * Requirements:
561      *
562      * - the calling contract must have an ETH balance of at least `value`.
563      * - the called Solidity function must be `payable`.
564      *
565      * _Available since v3.1._
566      */
567     function functionCallWithValue(
568         address target,
569         bytes memory data,
570         uint256 value
571     ) internal returns (bytes memory) {
572         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(address(this).balance >= value, "Address: insufficient balance for call");
588         require(isContract(target), "Address: call to non-contract");
589 
590         (bool success, bytes memory returndata) = target.call{value: value}(data);
591         return verifyCallResult(success, returndata, errorMessage);
592     }
593 
594     /**
595      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
596      * but performing a static call.
597      *
598      * _Available since v3.3._
599      */
600     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
601         return functionStaticCall(target, data, "Address: low-level static call failed");
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
606      * but performing a static call.
607      *
608      * _Available since v3.3._
609      */
610     function functionStaticCall(
611         address target,
612         bytes memory data,
613         string memory errorMessage
614     ) internal view returns (bytes memory) {
615         require(isContract(target), "Address: static call to non-contract");
616 
617         (bool success, bytes memory returndata) = target.staticcall(data);
618         return verifyCallResult(success, returndata, errorMessage);
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
623      * but performing a delegate call.
624      *
625      * _Available since v3.4._
626      */
627     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
628         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
633      * but performing a delegate call.
634      *
635      * _Available since v3.4._
636      */
637     function functionDelegateCall(
638         address target,
639         bytes memory data,
640         string memory errorMessage
641     ) internal returns (bytes memory) {
642         require(isContract(target), "Address: delegate call to non-contract");
643 
644         (bool success, bytes memory returndata) = target.delegatecall(data);
645         return verifyCallResult(success, returndata, errorMessage);
646     }
647 
648     /**
649      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
650      * revert reason using the provided one.
651      *
652      * _Available since v4.3._
653      */
654     function verifyCallResult(
655         bool success,
656         bytes memory returndata,
657         string memory errorMessage
658     ) internal pure returns (bytes memory) {
659         if (success) {
660             return returndata;
661         } else {
662             // Look for revert reason and bubble it up if present
663             if (returndata.length > 0) {
664                 // The easiest way to bubble the revert reason is using memory via assembly
665 
666                 assembly {
667                     let returndata_size := mload(returndata)
668                     revert(add(32, returndata), returndata_size)
669                 }
670             } else {
671                 revert(errorMessage);
672             }
673         }
674     }
675 }
676 
677 
678 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
679 
680 
681 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
682 
683 
684 
685 /**
686  * @dev Implementation of the {IERC165} interface.
687  *
688  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
689  * for the additional interface id that will be supported. For example:
690  *
691  * ```solidity
692  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
694  * }
695  * ```
696  *
697  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
698  */
699 abstract contract ERC165 is IERC165 {
700     /**
701      * @dev See {IERC165-supportsInterface}.
702      */
703     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
704         return interfaceId == type(IERC165).interfaceId;
705     }
706 }
707 
708 
709 // File contracts/ERC721A.sol
710 
711 
712 // Creator: Chiru Labs
713 
714 
715 /**
716  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
717  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
718  *
719  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
720  *
721  * Does not support burning tokens to address(0).
722  *
723  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
724  */
725 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
726     using Address for address;
727     using Strings for uint256;
728 
729     struct TokenOwnership {
730         address addr;
731         uint64 startTimestamp;
732     }
733 
734     struct AddressData {
735         uint128 balance;
736         uint128 numberMinted;
737     }
738 
739     uint256 internal currentIndex = 0;
740 
741     // Token name
742     string private _name;
743 
744     // Token symbol
745     string private _symbol;
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
772     /**
773      * @dev See {IERC721Enumerable-tokenByIndex}.
774      */
775     function tokenByIndex(uint256 index) public view override returns (uint256) {
776         require(index < totalSupply(), 'ERC721A: global index out of bounds');
777         return index;
778     }
779 
780     /**
781      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
782      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
783      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
784      */
785     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
786         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
787         uint256 numMintedSoFar = totalSupply();
788         uint256 tokenIdsIdx = 0;
789         address currOwnershipAddr = address(0);
790         for (uint256 i = 0; i < numMintedSoFar; i++) {
791             TokenOwnership memory ownership = _ownerships[i];
792             if (ownership.addr != address(0)) {
793                 currOwnershipAddr = ownership.addr;
794             }
795             if (currOwnershipAddr == owner) {
796                 if (tokenIdsIdx == index) {
797                     return i;
798                 }
799                 tokenIdsIdx++;
800             }
801         }
802         revert('ERC721A: unable to get token of owner by index');
803     }
804 
805     /**
806      * @dev See {IERC165-supportsInterface}.
807      */
808     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
809         return
810             interfaceId == type(IERC721).interfaceId ||
811             interfaceId == type(IERC721Metadata).interfaceId ||
812             interfaceId == type(IERC721Enumerable).interfaceId ||
813             super.supportsInterface(interfaceId);
814     }
815 
816     /**
817      * @dev See {IERC721-balanceOf}.
818      */
819     function balanceOf(address owner) public view override returns (uint256) {
820         require(owner != address(0), 'ERC721A: balance query for the zero address');
821         return uint256(_addressData[owner].balance);
822     }
823 
824     function _numberMinted(address owner) internal view returns (uint256) {
825         require(owner != address(0), 'ERC721A: number minted query for the zero address');
826         return uint256(_addressData[owner].numberMinted);
827     }
828 
829     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
830         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
831 
832         for (uint256 curr = tokenId; ; curr--) {
833             TokenOwnership memory ownership = _ownerships[curr];
834             if (ownership.addr != address(0)) {
835                 return ownership;
836             }
837         }
838 
839         revert('ERC721A: unable to determine the owner of token');
840     }
841 
842     /**
843      * @dev See {IERC721-ownerOf}.
844      */
845     function ownerOf(uint256 tokenId) public view override returns (address) {
846         return ownershipOf(tokenId).addr;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overriden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return '';
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public override {
886         address owner = ERC721A.ownerOf(tokenId);
887         require(to != owner, 'ERC721A: approval to current owner');
888 
889         require(
890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891             'ERC721A: approve caller is not owner nor approved for all'
892         );
893 
894         _approve(to, tokenId, owner);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view override returns (address) {
901         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public override {
910         require(operator != _msgSender(), 'ERC721A: approve to caller');
911 
912         _operatorApprovals[_msgSender()][operator] = approved;
913         emit ApprovalForAll(_msgSender(), operator, approved);
914     }
915 
916     /**
917      * @dev See {IERC721-isApprovedForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
920         return _operatorApprovals[owner][operator];
921     }
922 
923     /**
924      * @dev See {IERC721-transferFrom}.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public override {
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public override {
942         safeTransferFrom(from, to, tokenId, '');
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public override {
954         _transfer(from, to, tokenId);
955         require(
956             _checkOnERC721Received(from, to, tokenId, _data),
957             'ERC721A: transfer to non ERC721Receiver implementer'
958         );
959     }
960 
961     /**
962      * @dev Returns whether `tokenId` exists.
963      *
964      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
965      *
966      * Tokens start existing when they are minted (`_mint`),
967      */
968     function _exists(uint256 tokenId) internal view returns (bool) {
969         return tokenId < currentIndex;
970     }
971 
972     function _safeMint(address to, uint256 quantity) internal {
973         _safeMint(to, quantity, '');
974     }
975 
976     /**
977      * @dev Mints `quantity` tokens and transfers them to `to`.
978      *
979      * Requirements:
980      *
981      * - `to` cannot be the zero address.
982      * - `quantity` cannot be larger than the max batch size.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(
987         address to,
988         uint256 quantity,
989         bytes memory _data
990     ) internal {
991         uint256 startTokenId = currentIndex;
992         require(to != address(0), 'ERC721A: mint to the zero address');
993         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
994         require(!_exists(startTokenId), 'ERC721A: token already minted');
995         require(quantity > 0, 'ERC721A: quantity must be greater 0');
996 
997         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
998 
999         AddressData memory addressData = _addressData[to];
1000         _addressData[to] = AddressData(
1001             addressData.balance + uint128(quantity),
1002             addressData.numberMinted + uint128(quantity)
1003         );
1004         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1005 
1006         uint256 updatedIndex = startTokenId;
1007 
1008         for (uint256 i = 0; i < quantity; i++) {
1009             emit Transfer(address(0), to, updatedIndex);
1010             require(
1011                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1012                 'ERC721A: transfer to non ERC721Receiver implementer'
1013             );
1014             updatedIndex++;
1015         }
1016 
1017         currentIndex = updatedIndex;
1018         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) private {
1036         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1037 
1038         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1039             getApproved(tokenId) == _msgSender() ||
1040             isApprovedForAll(prevOwnership.addr, _msgSender()));
1041 
1042         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1043 
1044         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1045         require(to != address(0), 'ERC721A: transfer to the zero address');
1046 
1047         _beforeTokenTransfers(from, to, tokenId, 1);
1048 
1049         // Clear approvals from the previous owner
1050         _approve(address(0), tokenId, prevOwnership.addr);
1051 
1052         // Underflow of the sender's balance is impossible because we check for
1053         // ownership above and the recipient's balance can't realistically overflow.
1054         unchecked {
1055             _addressData[from].balance -= 1;
1056             _addressData[to].balance += 1;
1057         }
1058 
1059         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1060 
1061         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1062         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1063         uint256 nextTokenId = tokenId + 1;
1064         if (_ownerships[nextTokenId].addr == address(0)) {
1065             if (_exists(nextTokenId)) {
1066                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1067             }
1068         }
1069 
1070         emit Transfer(from, to, tokenId);
1071         _afterTokenTransfers(from, to, tokenId, 1);
1072     }
1073 
1074     /**
1075      * @dev Approve `to` to operate on `tokenId`
1076      *
1077      * Emits a {Approval} event.
1078      */
1079     function _approve(
1080         address to,
1081         uint256 tokenId,
1082         address owner
1083     ) private {
1084         _tokenApprovals[tokenId] = to;
1085         emit Approval(owner, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1090      * The call is not executed if the target address is not a contract.
1091      *
1092      * @param from address representing the previous owner of the given token ID
1093      * @param to target address that will receive the tokens
1094      * @param tokenId uint256 ID of the token to be transferred
1095      * @param _data bytes optional data to send along with the call
1096      * @return bool whether the call correctly returned the expected magic value
1097      */
1098     function _checkOnERC721Received(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) private returns (bool) {
1104         if (to.isContract()) {
1105             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1106                 return retval == IERC721Receiver(to).onERC721Received.selector;
1107             } catch (bytes memory reason) {
1108                 if (reason.length == 0) {
1109                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1110                 } else {
1111                     assembly {
1112                         revert(add(32, reason), mload(reason))
1113                     }
1114                 }
1115             }
1116         } else {
1117             return true;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1123      *
1124      * startTokenId - the first token id to be transferred
1125      * quantity - the amount to be transferred
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      */
1133     function _beforeTokenTransfers(
1134         address from,
1135         address to,
1136         uint256 startTokenId,
1137         uint256 quantity
1138     ) internal virtual {}
1139 
1140     /**
1141      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1142      * minting.
1143      *
1144      * startTokenId - the first token id to be transferred
1145      * quantity - the amount to be transferred
1146      *
1147      * Calling conditions:
1148      *
1149      * - when `from` and `to` are both non-zero.
1150      * - `from` and `to` are never both zero.
1151      */
1152     function _afterTokenTransfers(
1153         address from,
1154         address to,
1155         uint256 startTokenId,
1156         uint256 quantity
1157     ) internal virtual {}
1158 }
1159 
1160 contract Bitzuki is ERC721A, Ownable {
1161 
1162     string public baseURI = "ipfs://QmPS6WWrgkExiZc7QWcgPPydJsWU1korxVHMbwQYG7dDsX/";
1163     string public contractURI = "ipfs://QmPS6WWrgkExiZc7QWcgPPydJsWU1korxVHMbwQYG7dDsX/";
1164     string public constant baseExtension = "";
1165     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1166 
1167     uint256 public constant MAX_PER_TX_Free = 5;
1168     uint256 public constant MAX_PER_TX = 5;
1169     uint256 public constant Free_MAX_SUPPLY = 888;
1170     uint256 public constant MAX_SUPPLY = 3333;
1171     uint256 public constant price = 0.01 ether;
1172 
1173     bool public paused = false;
1174 
1175     constructor() ERC721A("Bitzuki", "BZ") {}
1176 
1177     function mint(uint256 _amount) external payable {
1178         address _caller = _msgSender();
1179         require(!paused, "Paused");
1180         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1181         require(_amount > 0, "No 0 mints");
1182         require(tx.origin == _caller, "No contracts");
1183 
1184         if(Free_MAX_SUPPLY >= totalSupply()){
1185             require(MAX_PER_TX_Free >= _amount , "Excess max per free tx");
1186         }else{
1187             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1188             require(_amount * price == msg.value, "Invalid funds provided");
1189         }
1190 
1191         _safeMint(_caller, _amount);
1192     }
1193 
1194     function isApprovedForAll(address owner, address operator)
1195         override
1196         public
1197         view
1198         returns (bool)
1199     {
1200         // Whitelist OpenSea proxy contract for easy trading.
1201         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1202         if (address(proxyRegistry.proxies(owner)) == operator) {
1203             return true;
1204         }
1205 
1206         return super.isApprovedForAll(owner, operator);
1207     }
1208 
1209     function withdraw() external onlyOwner {
1210         uint256 balance = address(this).balance;
1211         (bool success, ) = _msgSender().call{value: balance}("");
1212         require(success, "Failed to send");
1213     }
1214 
1215     function pause(bool _state) external onlyOwner {
1216         paused = _state;
1217     }
1218 
1219     function setBaseURI(string memory baseURI_) external onlyOwner {
1220         baseURI = baseURI_;
1221     }
1222 
1223     function setContractURI(string memory _contractURI) external onlyOwner {
1224         contractURI = _contractURI;
1225     }
1226 
1227     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1228         require(_exists(_tokenId), "Token does not exist.");
1229         return bytes(baseURI).length > 0 ? string(
1230             abi.encodePacked(
1231               baseURI,
1232               Strings.toString(_tokenId),
1233               baseExtension
1234             )
1235         ) : "";
1236     }
1237 }
1238 
1239 contract OwnableDelegateProxy { }
1240 contract ProxyRegistry {
1241     mapping(address => OwnableDelegateProxy) public proxies;
1242 }