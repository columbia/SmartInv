1 // SPDX-License-Identifier: MIT
2 //BabyNotBanksy
3 //Inspired by #notBanksyEchoes
4 //2023 NFTs
5 //Free Mint
6 //Max 2 per transaction
7 
8 
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
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev String operations.
41  */
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
90         bytes memory buffer = new bytes(2 * length + 2);
91         buffer[0] = "0";
92         buffer[1] = "x";
93         for (uint256 i = 2 * length + 1; i > 1; --i) {
94             buffer[i] = _HEX_SYMBOLS[value & 0xf];
95             value >>= 4;
96         }
97         require(value == 0, "Strings: hex length insufficient");
98         return string(buffer);
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Context.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
184 
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @title ERC721 token receiver interface
190  * @dev Interface for any contract that wants to support safeTransfers
191  * from ERC721 asset contracts.
192  */
193 interface IERC721Receiver {
194     /**
195      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
196      * by `operator` from `from`, this function is called.
197      *
198      * It must return its Solidity selector to confirm the token transfer.
199      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
200      *
201      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
202      */
203     function onERC721Received(
204         address operator,
205         address from,
206         uint256 tokenId,
207         bytes calldata data
208     ) external returns (bytes4);
209 }
210 
211 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
212 
213 
214 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev Interface of the ERC165 standard, as defined in the
220  * https://eips.ethereum.org/EIPS/eip-165[EIP].
221  *
222  * Implementers can declare support of contract interfaces, which can then be
223  * queried by others ({ERC165Checker}).
224  *
225  * For an implementation, see {ERC165}.
226  */
227 interface IERC165 {
228     /**
229      * @dev Returns true if this contract implements the interface defined by
230      * `interfaceId`. See the corresponding
231      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
232      * to learn more about how these ids are created.
233      *
234      * This function call must use less than 30 000 gas.
235      */
236     function supportsInterface(bytes4 interfaceId) external view returns (bool);
237 }
238 
239 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 
247 /**
248  * @dev Implementation of the {IERC165} interface.
249  *
250  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
251  * for the additional interface id that will be supported. For example:
252  *
253  * ```solidity
254  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
255  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
256  * }
257  * ```
258  *
259  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
260  */
261 abstract contract ERC165 is IERC165 {
262     /**
263      * @dev See {IERC165-supportsInterface}.
264      */
265     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
266         return interfaceId == type(IERC165).interfaceId;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         assembly {
305             size := extcodesize(account)
306         }
307         return size > 0;
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         (bool success, ) = recipient.call{value: amount}("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain `call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(
381         address target,
382         bytes memory data,
383         uint256 value
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         require(isContract(target), "Address: call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.call{value: value}(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
414         return functionStaticCall(target, data, "Address: low-level static call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal view returns (bytes memory) {
428         require(isContract(target), "Address: static call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.staticcall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.4._
449      */
450     function functionDelegateCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(isContract(target), "Address: delegate call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.delegatecall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
463      * revert reason using the provided one.
464      *
465      * _Available since v4.3._
466      */
467     function verifyCallResult(
468         bool success,
469         bytes memory returndata,
470         string memory errorMessage
471     ) internal pure returns (bytes memory) {
472         if (success) {
473             return returndata;
474         } else {
475             // Look for revert reason and bubble it up if present
476             if (returndata.length > 0) {
477                 // The easiest way to bubble the revert reason is using memory via assembly
478 
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Required interface of an ERC721 compliant contract.
500  */
501 interface IERC721 is IERC165 {
502     /**
503      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
504      */
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506 
507     /**
508      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
509      */
510     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
514      */
515     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
516 
517     /**
518      * @dev Returns the number of tokens in ``owner``'s account.
519      */
520     function balanceOf(address owner) external view returns (uint256 balance);
521 
522     /**
523      * @dev Returns the owner of the `tokenId` token.
524      *
525      * Requirements:
526      *
527      * - `tokenId` must exist.
528      */
529     function ownerOf(uint256 tokenId) external view returns (address owner);
530 
531     /**
532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
534      *
535      * Requirements:
536      *
537      * - `from` cannot be the zero address.
538      * - `to` cannot be the zero address.
539      * - `tokenId` token must exist and be owned by `from`.
540      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
541      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
542      *
543      * Emits a {Transfer} event.
544      */
545     function safeTransferFrom(
546         address from,
547         address to,
548         uint256 tokenId
549     ) external;
550 
551     /**
552      * @dev Transfers `tokenId` token from `from` to `to`.
553      *
554      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(
566         address from,
567         address to,
568         uint256 tokenId
569     ) external;
570 
571     /**
572      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
573      * The approval is cleared when the token is transferred.
574      *
575      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
576      *
577      * Requirements:
578      *
579      * - The caller must own the token or be an approved operator.
580      * - `tokenId` must exist.
581      *
582      * Emits an {Approval} event.
583      */
584     function approve(address to, uint256 tokenId) external;
585 
586     /**
587      * @dev Returns the account approved for `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function getApproved(uint256 tokenId) external view returns (address operator);
594 
595     /**
596      * @dev Approve or remove `operator` as an operator for the caller.
597      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
598      *
599      * Requirements:
600      *
601      * - The `operator` cannot be the caller.
602      *
603      * Emits an {ApprovalForAll} event.
604      */
605     function setApprovalForAll(address operator, bool _approved) external;
606 
607     /**
608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
609      *
610      * See {setApprovalForAll}
611      */
612     function isApprovedForAll(address owner, address operator) external view returns (bool);
613 
614     /**
615      * @dev Safely transfers `tokenId` token from `from` to `to`.
616      *
617      * Requirements:
618      *
619      * - `from` cannot be the zero address.
620      * - `to` cannot be the zero address.
621      * - `tokenId` token must exist and be owned by `from`.
622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
624      *
625      * Emits a {Transfer} event.
626      */
627     function safeTransferFrom(
628         address from,
629         address to,
630         uint256 tokenId,
631         bytes calldata data
632     ) external;
633 }
634 
635 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 
643 /**
644  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
645  * @dev See https://eips.ethereum.org/EIPS/eip-721
646  */
647 interface IERC721Enumerable is IERC721 {
648     /**
649      * @dev Returns the total amount of tokens stored by the contract.
650      */
651     function totalSupply() external view returns (uint256);
652 
653     /**
654      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
655      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
656      */
657     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
658 
659     /**
660      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
661      * Use along with {totalSupply} to enumerate all tokens.
662      */
663     function tokenByIndex(uint256 index) external view returns (uint256);
664 }
665 
666 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
676  * @dev See https://eips.ethereum.org/EIPS/eip-721
677  */
678 interface IERC721Metadata is IERC721 {
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() external view returns (string memory);
683 
684     /**
685      * @dev Returns the token collection symbol.
686      */
687     function symbol() external view returns (string memory);
688 
689     /**
690      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
691      */
692     function tokenURI(uint256 tokenId) external view returns (string memory);
693 }
694 
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
702  *
703  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
704  *
705  * Does not support burning tokens to address(0).
706  *
707  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
708  */
709 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
710     using Address for address;
711     using Strings for uint256;
712 
713     struct TokenOwnership {
714         address addr;
715         uint64 startTimestamp;
716     }
717 
718     struct AddressData {
719         uint128 balance;
720         uint128 numberMinted;
721     }
722 
723     uint256 internal currentIndex = 0;
724 
725     uint256 internal immutable maxBatchSize;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to ownership details
734     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
735     mapping(uint256 => TokenOwnership) internal _ownerships;
736 
737     // Mapping owner address to address data
738     mapping(address => AddressData) private _addressData;
739 
740     // Mapping from token ID to approved address
741     mapping(uint256 => address) private _tokenApprovals;
742 
743     // Mapping from owner to operator approvals
744     mapping(address => mapping(address => bool)) private _operatorApprovals;
745 
746     /**
747      * @dev
748      * `maxBatchSize` refers to how much a minter can mint at a time.
749      */
750     constructor(
751         string memory name_,
752         string memory symbol_,
753         uint256 maxBatchSize_
754     ) {
755         require(maxBatchSize_ > 0, 'ERC721A: max batch size must be nonzero');
756         _name = name_;
757         _symbol = symbol_;
758         maxBatchSize = maxBatchSize_;
759     }
760 
761     /**
762      * @dev See {IERC721Enumerable-totalSupply}.
763      */
764     function totalSupply() public view override returns (uint256) {
765         return currentIndex;
766     }
767 
768     /**
769      * @dev See {IERC721Enumerable-tokenByIndex}.
770      */
771     function tokenByIndex(uint256 index) public view override returns (uint256) {
772         require(index < totalSupply(), 'ERC721A: global index out of bounds');
773         return index;
774     }
775 
776     /**
777      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
778      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
779      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
780      */
781     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
782         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
783         uint256 numMintedSoFar = totalSupply();
784         uint256 tokenIdsIdx = 0;
785         address currOwnershipAddr = address(0);
786         for (uint256 i = 0; i < numMintedSoFar; i++) {
787             TokenOwnership memory ownership = _ownerships[i];
788             if (ownership.addr != address(0)) {
789                 currOwnershipAddr = ownership.addr;
790             }
791             if (currOwnershipAddr == owner) {
792                 if (tokenIdsIdx == index) {
793                     return i;
794                 }
795                 tokenIdsIdx++;
796             }
797         }
798         revert('ERC721A: unable to get token of owner by index');
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             interfaceId == type(IERC721Enumerable).interfaceId ||
809             super.supportsInterface(interfaceId);
810     }
811 
812     /**
813      * @dev See {IERC721-balanceOf}.
814      */
815     function balanceOf(address owner) public view override returns (uint256) {
816         require(owner != address(0), 'ERC721A: balance query for the zero address');
817         return uint256(_addressData[owner].balance);
818     }
819 
820     function _numberMinted(address owner) internal view returns (uint256) {
821         require(owner != address(0), 'ERC721A: number minted query for the zero address');
822         return uint256(_addressData[owner].numberMinted);
823     }
824 
825     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
826         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
827 
828         uint256 lowestTokenToCheck;
829         if (tokenId >= maxBatchSize) {
830             lowestTokenToCheck = tokenId - maxBatchSize + 1;
831         }
832 
833         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
834             TokenOwnership memory ownership = _ownerships[curr];
835             if (ownership.addr != address(0)) {
836                 return ownership;
837             }
838         }
839 
840         revert('ERC721A: unable to determine the owner of token');
841     }
842 
843     /**
844      * @dev See {IERC721-ownerOf}.
845      */
846     function ownerOf(uint256 tokenId) public view override returns (address) {
847         return ownershipOf(tokenId).addr;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-name}.
852      */
853     function name() public view virtual override returns (string memory) {
854         return _name;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-symbol}.
859      */
860     function symbol() public view virtual override returns (string memory) {
861         return _symbol;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-tokenURI}.
866      */
867     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
868         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
869 
870         string memory baseURI = _baseURI();
871         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
872     }
873 
874     /**
875      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
876      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
877      * by default, can be overriden in child contracts.
878      */
879     function _baseURI() internal view virtual returns (string memory) {
880         return '';
881     }
882 
883     /**
884      * @dev See {IERC721-approve}.
885      */
886     function approve(address to, uint256 tokenId) public override {
887         address owner = ERC721A.ownerOf(tokenId);
888         require(to != owner, 'ERC721A: approval to current owner');
889 
890         require(
891             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
892             'ERC721A: approve caller is not owner nor approved for all'
893         );
894 
895         _approve(to, tokenId, owner);
896     }
897 
898     /**
899      * @dev See {IERC721-getApproved}.
900      */
901     function getApproved(uint256 tokenId) public view override returns (address) {
902         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
903 
904         return _tokenApprovals[tokenId];
905     }
906 
907     /**
908      * @dev See {IERC721-setApprovalForAll}.
909      */
910     function setApprovalForAll(address operator, bool approved) public override {
911         require(operator != _msgSender(), 'ERC721A: approve to caller');
912 
913         _operatorApprovals[_msgSender()][operator] = approved;
914         emit ApprovalForAll(_msgSender(), operator, approved);
915     }
916 
917     /**
918      * @dev See {IERC721-isApprovedForAll}.
919      */
920     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
921         return _operatorApprovals[owner][operator];
922     }
923 
924     /**
925      * @dev See {IERC721-transferFrom}.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) public override {
932         _transfer(from, to, tokenId);
933     }
934 
935     /**
936      * @dev See {IERC721-safeTransferFrom}.
937      */
938     function safeTransferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public override {
943         safeTransferFrom(from, to, tokenId, '');
944     }
945 
946     /**
947      * @dev See {IERC721-safeTransferFrom}.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) public override {
955         _transfer(from, to, tokenId);
956         require(
957             _checkOnERC721Received(from, to, tokenId, _data),
958             'ERC721A: transfer to non ERC721Receiver implementer'
959         );
960     }
961 
962     /**
963      * @dev Returns whether `tokenId` exists.
964      *
965      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
966      *
967      * Tokens start existing when they are minted (`_mint`),
968      */
969     function _exists(uint256 tokenId) internal view returns (bool) {
970         return tokenId < currentIndex;
971     }
972 
973     function _safeMint(address to, uint256 quantity) internal {
974         _safeMint(to, quantity, '');
975     }
976 
977     /**
978      * @dev Mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - `to` cannot be the zero address.
983      * - `quantity` cannot be larger than the max batch size.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _safeMint(
988         address to,
989         uint256 quantity,
990         bytes memory _data
991     ) internal {
992         uint256 startTokenId = currentIndex;
993         require(to != address(0), 'ERC721A: mint to the zero address');
994         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
995         require(!_exists(startTokenId), 'ERC721A: token already minted');
996         require(quantity <= maxBatchSize, 'ERC721A: quantity to mint too high');
997         require(quantity > 0, 'ERC721A: quantity must be greater 0');
998 
999         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1000 
1001         AddressData memory addressData = _addressData[to];
1002         _addressData[to] = AddressData(
1003             addressData.balance + uint128(quantity),
1004             addressData.numberMinted + uint128(quantity)
1005         );
1006         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1007 
1008         uint256 updatedIndex = startTokenId;
1009 
1010         for (uint256 i = 0; i < quantity; i++) {
1011             emit Transfer(address(0), to, updatedIndex);
1012             require(
1013                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1014                 'ERC721A: transfer to non ERC721Receiver implementer'
1015             );
1016             updatedIndex++;
1017         }
1018 
1019         currentIndex = updatedIndex;
1020         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1021     }
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must be owned by `from`.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function _transfer(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) private {
1038         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1039 
1040         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1041             getApproved(tokenId) == _msgSender() ||
1042             isApprovedForAll(prevOwnership.addr, _msgSender()));
1043 
1044         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1045 
1046         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1047         require(to != address(0), 'ERC721A: transfer to the zero address');
1048 
1049         _beforeTokenTransfers(from, to, tokenId, 1);
1050 
1051         // Clear approvals from the previous owner
1052         _approve(address(0), tokenId, prevOwnership.addr);
1053 
1054         // Underflow of the sender's balance is impossible because we check for
1055         // ownership above and the recipient's balance can't realistically overflow.
1056         unchecked {
1057             _addressData[from].balance -= 1;
1058             _addressData[to].balance += 1;
1059         }
1060 
1061         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1062 
1063         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1064         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1065         uint256 nextTokenId = tokenId + 1;
1066         if (_ownerships[nextTokenId].addr == address(0)) {
1067             if (_exists(nextTokenId)) {
1068                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1069             }
1070         }
1071 
1072         emit Transfer(from, to, tokenId);
1073         _afterTokenTransfers(from, to, tokenId, 1);
1074     }
1075 
1076     /**
1077      * @dev Approve `to` to operate on `tokenId`
1078      *
1079      * Emits a {Approval} event.
1080      */
1081     function _approve(
1082         address to,
1083         uint256 tokenId,
1084         address owner
1085     ) private {
1086         _tokenApprovals[tokenId] = to;
1087         emit Approval(owner, to, tokenId);
1088     }
1089 
1090     /**
1091      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1092      * The call is not executed if the target address is not a contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         if (to.isContract()) {
1107             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1108                 return retval == IERC721Receiver(to).onERC721Received.selector;
1109             } catch (bytes memory reason) {
1110                 if (reason.length == 0) {
1111                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1112                 } else {
1113                     assembly {
1114                         revert(add(32, reason), mload(reason))
1115                     }
1116                 }
1117             }
1118         } else {
1119             return true;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1125      *
1126      * startTokenId - the first token id to be transferred
1127      * quantity - the amount to be transferred
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      */
1135     function _beforeTokenTransfers(
1136         address from,
1137         address to,
1138         uint256 startTokenId,
1139         uint256 quantity
1140     ) internal virtual {}
1141 
1142     /**
1143      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1144      * minting.
1145      *
1146      * startTokenId - the first token id to be transferred
1147      * quantity - the amount to be transferred
1148      *
1149      * Calling conditions:
1150      *
1151      * - when `from` and `to` are both non-zero.
1152      * - `from` and `to` are never both zero.
1153      */
1154     function _afterTokenTransfers(
1155         address from,
1156         address to,
1157         uint256 startTokenId,
1158         uint256 quantity
1159     ) internal virtual {}
1160 }
1161 
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 contract BabyNotBanksy is ERC721A, Ownable {
1166   using Strings for uint256;
1167 
1168   string private uriPrefix = "";
1169   string private uriSuffix = ".json";
1170   string public hiddenMetadataUri;
1171   
1172   uint256 public price = 0 ether; 
1173   uint256 public maxSupply = 2023; 
1174   uint256 public maxMintAmountPerTx = 2; 
1175   
1176   bool public paused = false;
1177   bool public revealed = false;
1178   mapping(address => uint256) public addressMintedBalance;
1179 
1180 
1181   constructor() ERC721A("BabyNotBanksy", "BNB", maxMintAmountPerTx) {
1182     setHiddenMetadataUri("ipfs://QmeVy1u2QtRMqcHbQS7zvj3X3JDKZaU6hYgyX7hpWjLzq5");
1183   }
1184 
1185   modifier mintCompliance(uint256 _mintAmount) {
1186     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1187     require(currentIndex + _mintAmount <= maxSupply, "Max supply exceeded!");
1188     _;
1189   }
1190 
1191   function mintBNB(uint256 _mintAmount) public payable mintCompliance(_mintAmount)
1192    {
1193     require(!paused, "The contract is paused!");
1194     require(msg.value >= price * _mintAmount, "Insufficient funds!");
1195     
1196     
1197     _safeMint(msg.sender, _mintAmount);
1198   }
1199 
1200    
1201   function BNBToAddress(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1202     _safeMint(_to, _mintAmount);
1203   }
1204 
1205  
1206   function walletOfOwner(address _owner)
1207     public
1208     view
1209     returns (uint256[] memory)
1210   {
1211     uint256 ownerTokenCount = balanceOf(_owner);
1212     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1213     uint256 currentTokenId = 0;
1214     uint256 ownedTokenIndex = 0;
1215 
1216     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1217       address currentTokenOwner = ownerOf(currentTokenId);
1218 
1219       if (currentTokenOwner == _owner) {
1220         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1221 
1222         ownedTokenIndex++;
1223       }
1224 
1225       currentTokenId++;
1226     }
1227 
1228     return ownedTokenIds;
1229   }
1230 
1231   function tokenURI(uint256 _tokenId)
1232     public
1233     view
1234     virtual
1235     override
1236     returns (string memory)
1237   {
1238     require(
1239       _exists(_tokenId),
1240       "ERC721Metadata: URI query for nonexistent token"
1241     );
1242 
1243     if (revealed == false) {
1244       return hiddenMetadataUri;
1245     }
1246 
1247     string memory currentBaseURI = _baseURI();
1248     return bytes(currentBaseURI).length > 0
1249         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1250         : "";
1251   }
1252 
1253   function setRevealed(bool _state) public onlyOwner {
1254     revealed = _state;
1255   
1256   }
1257 
1258   function setPrice(uint256 _price) public onlyOwner {
1259     price = _price;
1260 
1261   }
1262  
1263   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1264     hiddenMetadataUri = _hiddenMetadataUri;
1265   }
1266 
1267 
1268 
1269   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1270     uriPrefix = _uriPrefix;
1271   }
1272 
1273   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1274     uriSuffix = _uriSuffix;
1275   }
1276 
1277   function setPaused(bool _state) public onlyOwner {
1278     paused = _state;
1279   }
1280 
1281   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1282       _safeMint(_receiver, _mintAmount);
1283   }
1284 
1285   function _baseURI() internal view virtual override returns (string memory) {
1286     return uriPrefix;
1287     
1288   }
1289 
1290     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1291     maxMintAmountPerTx = _maxMintAmountPerTx;
1292 
1293   }
1294 
1295     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1296     maxSupply = _maxSupply;
1297 
1298   }
1299 
1300 
1301 
1302   function withdraw() public onlyOwner {
1303     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1304     require(os);
1305     
1306 
1307  
1308   }
1309   
1310 }