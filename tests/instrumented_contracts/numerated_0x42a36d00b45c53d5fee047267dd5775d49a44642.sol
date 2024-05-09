1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-13
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
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(
52         address indexed previousOwner,
53         address indexed newOwner
54     );
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(
95             newOwner != address(0),
96             "Ownable: new owner is the zero address"
97         );
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
115 
116 /**
117  * @dev String operations.
118  */
119 library Strings {
120     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
124      */
125     function toString(uint256 value) internal pure returns (string memory) {
126         // Inspired by OraclizeAPI's implementation - MIT licence
127         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
128 
129         if (value == 0) {
130             return "0";
131         }
132         uint256 temp = value;
133         uint256 digits;
134         while (temp != 0) {
135             digits++;
136             temp /= 10;
137         }
138         bytes memory buffer = new bytes(digits);
139         while (value != 0) {
140             digits -= 1;
141             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
142             value /= 10;
143         }
144         return string(buffer);
145     }
146 
147     /**
148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
149      */
150     function toHexString(uint256 value) internal pure returns (string memory) {
151         if (value == 0) {
152             return "0x00";
153         }
154         uint256 temp = value;
155         uint256 length = 0;
156         while (temp != 0) {
157             length++;
158             temp >>= 8;
159         }
160         return toHexString(value, length);
161     }
162 
163     /**
164      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
165      */
166     function toHexString(uint256 value, uint256 length)
167         internal
168         pure
169         returns (string memory)
170     {
171         bytes memory buffer = new bytes(2 * length + 2);
172         buffer[0] = "0";
173         buffer[1] = "x";
174         for (uint256 i = 2 * length + 1; i > 1; --i) {
175             buffer[i] = _HEX_SYMBOLS[value & 0xf];
176             value >>= 4;
177         }
178         require(value == 0, "Strings: hex length insufficient");
179         return string(buffer);
180     }
181 }
182 
183 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
186 
187 /**
188  * @dev Interface of the ERC165 standard, as defined in the
189  * https://eips.ethereum.org/EIPS/eip-165[EIP].
190  *
191  * Implementers can declare support of contract interfaces, which can then be
192  * queried by others ({ERC165Checker}).
193  *
194  * For an implementation, see {ERC165}.
195  */
196 interface IERC165 {
197     /**
198      * @dev Returns true if this contract implements the interface defined by
199      * `interfaceId`. See the corresponding
200      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
201      * to learn more about how these ids are created.
202      *
203      * This function call must use less than 30 000 gas.
204      */
205     function supportsInterface(bytes4 interfaceId) external view returns (bool);
206 }
207 
208 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
211 
212 /**
213  * @dev Required interface of an ERC721 compliant contract.
214  */
215 interface IERC721 is IERC165 {
216     /**
217      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
218      */
219     event Transfer(
220         address indexed from,
221         address indexed to,
222         uint256 indexed tokenId
223     );
224 
225     /**
226      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
227      */
228     event Approval(
229         address indexed owner,
230         address indexed approved,
231         uint256 indexed tokenId
232     );
233 
234     /**
235      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
236      */
237     event ApprovalForAll(
238         address indexed owner,
239         address indexed operator,
240         bool approved
241     );
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
319     function getApproved(uint256 tokenId)
320         external
321         view
322         returns (address operator);
323 
324     /**
325      * @dev Approve or remove `operator` as an operator for the caller.
326      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
327      *
328      * Requirements:
329      *
330      * - The `operator` cannot be the caller.
331      *
332      * Emits an {ApprovalForAll} event.
333      */
334     function setApprovalForAll(address operator, bool _approved) external;
335 
336     /**
337      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
338      *
339      * See {setApprovalForAll}
340      */
341     function isApprovedForAll(address owner, address operator)
342         external
343         view
344         returns (bool);
345 
346     /**
347      * @dev Safely transfers `tokenId` token from `from` to `to`.
348      *
349      * Requirements:
350      *
351      * - `from` cannot be the zero address.
352      * - `to` cannot be the zero address.
353      * - `tokenId` token must exist and be owned by `from`.
354      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
355      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
356      *
357      * Emits a {Transfer} event.
358      */
359     function safeTransferFrom(
360         address from,
361         address to,
362         uint256 tokenId,
363         bytes calldata data
364     ) external;
365 }
366 
367 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
368 
369 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
370 
371 /**
372  * @title ERC721 token receiver interface
373  * @dev Interface for any contract that wants to support safeTransfers
374  * from ERC721 asset contracts.
375  */
376 interface IERC721Receiver {
377     /**
378      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
379      * by `operator` from `from`, this function is called.
380      *
381      * It must return its Solidity selector to confirm the token transfer.
382      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
383      *
384      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
385      */
386     function onERC721Received(
387         address operator,
388         address from,
389         uint256 tokenId,
390         bytes calldata data
391     ) external returns (bytes4);
392 }
393 
394 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
395 
396 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
397 
398 /**
399  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
400  * @dev See https://eips.ethereum.org/EIPS/eip-721
401  */
402 interface IERC721Metadata is IERC721 {
403     /**
404      * @dev Returns the token collection name.
405      */
406     function name() external view returns (string memory);
407 
408     /**
409      * @dev Returns the token collection symbol.
410      */
411     function symbol() external view returns (string memory);
412 
413     /**
414      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
415      */
416     function tokenURI(uint256 tokenId) external view returns (string memory);
417 }
418 
419 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
420 
421 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
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
437     function tokenOfOwnerByIndex(address owner, uint256 index)
438         external
439         view
440         returns (uint256 tokenId);
441 
442     /**
443      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
444      * Use along with {totalSupply} to enumerate all tokens.
445      */
446     function tokenByIndex(uint256 index) external view returns (uint256);
447 }
448 
449 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
450 
451 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
452 
453 /**
454  * @dev Collection of functions related to the address type
455  */
456 library Address {
457     /**
458      * @dev Returns true if `account` is a contract.
459      *
460      * [IMPORTANT]
461      * ====
462      * It is unsafe to assume that an address for which this function returns
463      * false is an externally-owned account (EOA) and not a contract.
464      *
465      * Among others, `isContract` will return false for the following
466      * types of addresses:
467      *
468      *  - an externally-owned account
469      *  - a contract in construction
470      *  - an address where a contract will be created
471      *  - an address where a contract lived, but was destroyed
472      * ====
473      */
474     function isContract(address account) internal view returns (bool) {
475         // This method relies on extcodesize, which returns 0 for contracts in
476         // construction, since the code is only stored at the end of the
477         // constructor execution.
478 
479         uint256 size;
480         assembly {
481             size := extcodesize(account)
482         }
483         return size > 0;
484     }
485 
486     /**
487      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
488      * `recipient`, forwarding all available gas and reverting on errors.
489      *
490      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
491      * of certain opcodes, possibly making contracts go over the 2300 gas limit
492      * imposed by `transfer`, making them unable to receive funds via
493      * `transfer`. {sendValue} removes this limitation.
494      *
495      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
496      *
497      * IMPORTANT: because control is transferred to `recipient`, care must be
498      * taken to not create reentrancy vulnerabilities. Consider using
499      * {ReentrancyGuard} or the
500      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
501      */
502     function sendValue(address payable recipient, uint256 amount) internal {
503         require(
504             address(this).balance >= amount,
505             "Address: insufficient balance"
506         );
507 
508         (bool success, ) = recipient.call{value: amount}("");
509         require(
510             success,
511             "Address: unable to send value, recipient may have reverted"
512         );
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
533     function functionCall(address target, bytes memory data)
534         internal
535         returns (bytes memory)
536     {
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
570         return
571             functionCallWithValue(
572                 target,
573                 data,
574                 value,
575                 "Address: low-level call with value failed"
576             );
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
581      * with `errorMessage` as a fallback revert reason when `target` reverts.
582      *
583      * _Available since v3.1._
584      */
585     function functionCallWithValue(
586         address target,
587         bytes memory data,
588         uint256 value,
589         string memory errorMessage
590     ) internal returns (bytes memory) {
591         require(
592             address(this).balance >= value,
593             "Address: insufficient balance for call"
594         );
595         require(isContract(target), "Address: call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.call{value: value}(
598             data
599         );
600         return verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a static call.
606      *
607      * _Available since v3.3._
608      */
609     function functionStaticCall(address target, bytes memory data)
610         internal
611         view
612         returns (bytes memory)
613     {
614         return
615             functionStaticCall(
616                 target,
617                 data,
618                 "Address: low-level static call failed"
619             );
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
624      * but performing a static call.
625      *
626      * _Available since v3.3._
627      */
628     function functionStaticCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal view returns (bytes memory) {
633         require(isContract(target), "Address: static call to non-contract");
634 
635         (bool success, bytes memory returndata) = target.staticcall(data);
636         return verifyCallResult(success, returndata, errorMessage);
637     }
638 
639     /**
640      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
641      * but performing a delegate call.
642      *
643      * _Available since v3.4._
644      */
645     function functionDelegateCall(address target, bytes memory data)
646         internal
647         returns (bytes memory)
648     {
649         return
650             functionDelegateCall(
651                 target,
652                 data,
653                 "Address: low-level delegate call failed"
654             );
655     }
656 
657     /**
658      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
659      * but performing a delegate call.
660      *
661      * _Available since v3.4._
662      */
663     function functionDelegateCall(
664         address target,
665         bytes memory data,
666         string memory errorMessage
667     ) internal returns (bytes memory) {
668         require(isContract(target), "Address: delegate call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.delegatecall(data);
671         return verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
676      * revert reason using the provided one.
677      *
678      * _Available since v4.3._
679      */
680     function verifyCallResult(
681         bool success,
682         bytes memory returndata,
683         string memory errorMessage
684     ) internal pure returns (bytes memory) {
685         if (success) {
686             return returndata;
687         } else {
688             // Look for revert reason and bubble it up if present
689             if (returndata.length > 0) {
690                 // The easiest way to bubble the revert reason is using memory via assembly
691 
692                 assembly {
693                     let returndata_size := mload(returndata)
694                     revert(add(32, returndata), returndata_size)
695                 }
696             } else {
697                 revert(errorMessage);
698             }
699         }
700     }
701 }
702 
703 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
704 
705 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
706 
707 /**
708  * @dev Implementation of the {IERC165} interface.
709  *
710  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
711  * for the additional interface id that will be supported. For example:
712  *
713  * ```solidity
714  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
715  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
716  * }
717  * ```
718  *
719  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
720  */
721 abstract contract ERC165 is IERC165 {
722     /**
723      * @dev See {IERC165-supportsInterface}.
724      */
725     function supportsInterface(bytes4 interfaceId)
726         public
727         view
728         virtual
729         override
730         returns (bool)
731     {
732         return interfaceId == type(IERC165).interfaceId;
733     }
734 }
735 
736 // File contracts/ERC721A.sol
737 
738 // Creator: Chiru Labs
739 
740 /**
741  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
742  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
743  *
744  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
745  *
746  * Does not support burning tokens to address(0).
747  *
748  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
749  */
750 contract ERC721A is
751     Context,
752     ERC165,
753     IERC721,
754     IERC721Metadata,
755     IERC721Enumerable
756 {
757     using Address for address;
758     using Strings for uint256;
759 
760     struct TokenOwnership {
761         address addr;
762         uint64 startTimestamp;
763     }
764 
765     struct AddressData {
766         uint128 balance;
767         uint128 numberMinted;
768     }
769 
770     uint256 internal currentIndex = 0;
771 
772     // Token name
773     string private _name;
774 
775     // Token symbol
776     string private _symbol;
777 
778     // Mapping from token ID to ownership details
779     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
780     mapping(uint256 => TokenOwnership) internal _ownerships;
781 
782     // Mapping owner address to address data
783     mapping(address => AddressData) private _addressData;
784 
785     // Mapping from token ID to approved address
786     mapping(uint256 => address) private _tokenApprovals;
787 
788     // Mapping from owner to operator approvals
789     mapping(address => mapping(address => bool)) private _operatorApprovals;
790 
791     constructor(string memory name_, string memory symbol_) {
792         _name = name_;
793         _symbol = symbol_;
794     }
795 
796     /**
797      * @dev See {IERC721Enumerable-totalSupply}.
798      */
799     function totalSupply() public view override returns (uint256) {
800         return currentIndex;
801     }
802 
803     /**
804      * @dev See {IERC721Enumerable-tokenByIndex}.
805      */
806     function tokenByIndex(uint256 index)
807         public
808         view
809         override
810         returns (uint256)
811     {
812         require(index < totalSupply(), "ERC721A: global index out of bounds");
813         return index;
814     }
815 
816     /**
817      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
818      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
819      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
820      */
821     function tokenOfOwnerByIndex(address owner, uint256 index)
822         public
823         view
824         override
825         returns (uint256)
826     {
827         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
828         uint256 numMintedSoFar = totalSupply();
829         uint256 tokenIdsIdx = 0;
830         address currOwnershipAddr = address(0);
831         for (uint256 i = 0; i < numMintedSoFar; i++) {
832             TokenOwnership memory ownership = _ownerships[i];
833             if (ownership.addr != address(0)) {
834                 currOwnershipAddr = ownership.addr;
835             }
836             if (currOwnershipAddr == owner) {
837                 if (tokenIdsIdx == index) {
838                     return i;
839                 }
840                 tokenIdsIdx++;
841             }
842         }
843         revert("ERC721A: unable to get token of owner by index");
844     }
845 
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId)
850         public
851         view
852         virtual
853         override(ERC165, IERC165)
854         returns (bool)
855     {
856         return
857             interfaceId == type(IERC721).interfaceId ||
858             interfaceId == type(IERC721Metadata).interfaceId ||
859             interfaceId == type(IERC721Enumerable).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view override returns (uint256) {
867         require(
868             owner != address(0),
869             "ERC721A: balance query for the zero address"
870         );
871         return uint256(_addressData[owner].balance);
872     }
873 
874     function _numberMinted(address owner) internal view returns (uint256) {
875         require(
876             owner != address(0),
877             "ERC721A: number minted query for the zero address"
878         );
879         return uint256(_addressData[owner].numberMinted);
880     }
881 
882     function ownershipOf(uint256 tokenId)
883         internal
884         view
885         returns (TokenOwnership memory)
886     {
887         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
888 
889         for (uint256 curr = tokenId; ; curr--) {
890             TokenOwnership memory ownership = _ownerships[curr];
891             if (ownership.addr != address(0)) {
892                 return ownership;
893             }
894         }
895 
896         revert("ERC721A: unable to determine the owner of token");
897     }
898 
899     /**
900      * @dev See {IERC721-ownerOf}.
901      */
902     function ownerOf(uint256 tokenId) public view override returns (address) {
903         return ownershipOf(tokenId).addr;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-name}.
908      */
909     function name() public view virtual override returns (string memory) {
910         return _name;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-symbol}.
915      */
916     function symbol() public view virtual override returns (string memory) {
917         return _symbol;
918     }
919 
920     /**
921      * @dev See {IERC721Metadata-tokenURI}.
922      */
923     function tokenURI(uint256 tokenId)
924         public
925         view
926         virtual
927         override
928         returns (string memory)
929     {
930         require(
931             _exists(tokenId),
932             "ERC721Metadata: URI query for nonexistent token"
933         );
934 
935         string memory baseURI = _baseURI();
936         return
937             bytes(baseURI).length > 0
938                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
939                 : "";
940     }
941 
942     /**
943      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
944      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
945      * by default, can be overriden in child contracts.
946      */
947     function _baseURI() internal view virtual returns (string memory) {
948         return "";
949     }
950 
951     /**
952      * @dev See {IERC721-approve}.
953      */
954     function approve(address to, uint256 tokenId) public override {
955         address owner = ERC721A.ownerOf(tokenId);
956         require(to != owner, "ERC721A: approval to current owner");
957 
958         require(
959             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
960             "ERC721A: approve caller is not owner nor approved for all"
961         );
962 
963         _approve(to, tokenId, owner);
964     }
965 
966     /**
967      * @dev See {IERC721-getApproved}.
968      */
969     function getApproved(uint256 tokenId)
970         public
971         view
972         override
973         returns (address)
974     {
975         require(
976             _exists(tokenId),
977             "ERC721A: approved query for nonexistent token"
978         );
979 
980         return _tokenApprovals[tokenId];
981     }
982 
983     /**
984      * @dev See {IERC721-setApprovalForAll}.
985      */
986     function setApprovalForAll(address operator, bool approved)
987         public
988         override
989     {
990         require(operator != _msgSender(), "ERC721A: approve to caller");
991 
992         _operatorApprovals[_msgSender()][operator] = approved;
993         emit ApprovalForAll(_msgSender(), operator, approved);
994     }
995 
996     /**
997      * @dev See {IERC721-isApprovedForAll}.
998      */
999     function isApprovedForAll(address owner, address operator)
1000         public
1001         view
1002         virtual
1003         override
1004         returns (bool)
1005     {
1006         return _operatorApprovals[owner][operator];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-transferFrom}.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public override {
1017         _transfer(from, to, tokenId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-safeTransferFrom}.
1022      */
1023     function safeTransferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public override {
1028         safeTransferFrom(from, to, tokenId, "");
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-safeTransferFrom}.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public override {
1040         _transfer(from, to, tokenId);
1041         require(
1042             _checkOnERC721Received(from, to, tokenId, _data),
1043             "ERC721A: transfer to non ERC721Receiver implementer"
1044         );
1045     }
1046 
1047     /**
1048      * @dev Returns whether `tokenId` exists.
1049      *
1050      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1051      *
1052      * Tokens start existing when they are minted (`_mint`),
1053      */
1054     function _exists(uint256 tokenId) internal view returns (bool) {
1055         return tokenId < currentIndex;
1056     }
1057 
1058     function _safeMint(address to, uint256 quantity) internal {
1059         _safeMint(to, quantity, "");
1060     }
1061 
1062     /**
1063      * @dev Mints `quantity` tokens and transfers them to `to`.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `quantity` cannot be larger than the max batch size.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 quantity,
1075         bytes memory _data
1076     ) internal {
1077         uint256 startTokenId = currentIndex;
1078         require(to != address(0), "ERC721A: mint to the zero address");
1079         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1080         require(!_exists(startTokenId), "ERC721A: token already minted");
1081         require(quantity > 0, "ERC721A: quantity must be greater 0");
1082 
1083         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1084 
1085         AddressData memory addressData = _addressData[to];
1086         _addressData[to] = AddressData(
1087             addressData.balance + uint128(quantity),
1088             addressData.numberMinted + uint128(quantity)
1089         );
1090         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1091 
1092         uint256 updatedIndex = startTokenId;
1093 
1094         for (uint256 i = 0; i < quantity; i++) {
1095             emit Transfer(address(0), to, updatedIndex);
1096             require(
1097                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1098                 "ERC721A: transfer to non ERC721Receiver implementer"
1099             );
1100             updatedIndex++;
1101         }
1102 
1103         currentIndex = updatedIndex;
1104         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1105     }
1106 
1107     /**
1108      * @dev Transfers `tokenId` from `from` to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _transfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) private {
1122         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1123 
1124         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1125             getApproved(tokenId) == _msgSender() ||
1126             isApprovedForAll(prevOwnership.addr, _msgSender()));
1127 
1128         require(
1129             isApprovedOrOwner,
1130             "ERC721A: transfer caller is not owner nor approved"
1131         );
1132 
1133         require(
1134             prevOwnership.addr == from,
1135             "ERC721A: transfer from incorrect owner"
1136         );
1137         require(to != address(0), "ERC721A: transfer to the zero address");
1138 
1139         _beforeTokenTransfers(from, to, tokenId, 1);
1140 
1141         // Clear approvals from the previous owner
1142         _approve(address(0), tokenId, prevOwnership.addr);
1143 
1144         // Underflow of the sender's balance is impossible because we check for
1145         // ownership above and the recipient's balance can't realistically overflow.
1146         unchecked {
1147             _addressData[from].balance -= 1;
1148             _addressData[to].balance += 1;
1149         }
1150 
1151         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1152 
1153         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1154         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1155         uint256 nextTokenId = tokenId + 1;
1156         if (_ownerships[nextTokenId].addr == address(0)) {
1157             if (_exists(nextTokenId)) {
1158                 _ownerships[nextTokenId] = TokenOwnership(
1159                     prevOwnership.addr,
1160                     prevOwnership.startTimestamp
1161                 );
1162             }
1163         }
1164 
1165         emit Transfer(from, to, tokenId);
1166         _afterTokenTransfers(from, to, tokenId, 1);
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits a {Approval} event.
1173      */
1174     function _approve(
1175         address to,
1176         uint256 tokenId,
1177         address owner
1178     ) private {
1179         _tokenApprovals[tokenId] = to;
1180         emit Approval(owner, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1185      * The call is not executed if the target address is not a contract.
1186      *
1187      * @param from address representing the previous owner of the given token ID
1188      * @param to target address that will receive the tokens
1189      * @param tokenId uint256 ID of the token to be transferred
1190      * @param _data bytes optional data to send along with the call
1191      * @return bool whether the call correctly returned the expected magic value
1192      */
1193     function _checkOnERC721Received(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) private returns (bool) {
1199         if (to.isContract()) {
1200             try
1201                 IERC721Receiver(to).onERC721Received(
1202                     _msgSender(),
1203                     from,
1204                     tokenId,
1205                     _data
1206                 )
1207             returns (bytes4 retval) {
1208                 return retval == IERC721Receiver(to).onERC721Received.selector;
1209             } catch (bytes memory reason) {
1210                 if (reason.length == 0) {
1211                     revert(
1212                         "ERC721A: transfer to non ERC721Receiver implementer"
1213                     );
1214                 } else {
1215                     assembly {
1216                         revert(add(32, reason), mload(reason))
1217                     }
1218                 }
1219             }
1220         } else {
1221             return true;
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1227      *
1228      * startTokenId - the first token id to be transferred
1229      * quantity - the amount to be transferred
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      */
1237     function _beforeTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1246      * minting.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - when `from` and `to` are both non-zero.
1254      * - `from` and `to` are never both zero.
1255      */
1256     function _afterTokenTransfers(
1257         address from,
1258         address to,
1259         uint256 startTokenId,
1260         uint256 quantity
1261     ) internal virtual {}
1262 }
1263 
1264 contract ThreeLandBirds is ERC721A, Ownable {
1265     string public constant baseExtension = ".json";
1266     address public constant proxyRegistryAddress =
1267         0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1268 
1269     string baseURI;
1270     uint256 public price = 0.005 ether;
1271     uint256 public MAX_SUPPLY = 2222;
1272     uint256 public MAX_PER_TX = 5;
1273 
1274     constructor(
1275         string memory _initBaseURI
1276     ) ERC721A("3LandBirds", "3LB") {
1277         setBaseURI(_initBaseURI);
1278     }
1279 
1280     function mint(uint256 _amount) public payable {
1281         require(MAX_SUPPLY >= totalSupply() + _amount, "SOLD OUT");
1282         require(_amount > 0, "No 0 mints");
1283         require(MAX_PER_TX >= _amount, "Exceeds max per transaction");
1284         require(msg.value >= _amount * price, "Invalid funds provided");
1285 
1286         _safeMint(msg.sender, _amount);
1287     }
1288 
1289     function isApprovedForAll(address owner, address operator)
1290         public
1291         view
1292         override
1293         returns (bool)
1294     {
1295         // Whitelist OpenSea proxy contract for easy trading.
1296         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1297         if (address(proxyRegistry.proxies(owner)) == operator) {
1298             return true;
1299         }
1300 
1301         return super.isApprovedForAll(owner, operator);
1302     }
1303 
1304     function withdraw() public onlyOwner {
1305         (bool success, ) = payable(msg.sender).call{
1306             value: address(this).balance
1307         }("");
1308         require(success);
1309     }
1310 
1311     function setPrice(uint256 _newPrice) public onlyOwner {
1312         price = _newPrice;
1313     }
1314 
1315     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1316         MAX_SUPPLY = _newMaxSupply;
1317     }
1318 
1319     function setBaseURI(string memory baseURI_) public onlyOwner {
1320         baseURI = baseURI_;
1321     }
1322 
1323     function tokenURI(uint256 _tokenId)
1324         public
1325         view
1326         override
1327         returns (string memory)
1328     {
1329         require(_exists(_tokenId), "Token does not exist.");
1330 
1331         return
1332             bytes(baseURI).length > 0
1333                 ? string(
1334                     abi.encodePacked(
1335                         baseURI,
1336                         Strings.toString(_tokenId),
1337                         baseExtension
1338                     )
1339                 )
1340                 : "";
1341     }
1342 }
1343 
1344 contract OwnableDelegateProxy {}
1345 
1346 contract ProxyRegistry {
1347     mapping(address => OwnableDelegateProxy) public proxies;
1348 }