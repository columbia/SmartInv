1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Provides information about the current execution context, including the
78  * sender of the transaction and its data. While these are generally available
79  * via msg.sender and msg.data, they should not be accessed in such a direct
80  * manner, since when dealing with meta-transactions the account sending and
81  * paying for execution may not be the actual sender (as far as an application
82  * is concerned).
83  *
84  * This contract is only required for intermediate, library-like contracts.
85  */
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view virtual returns (bytes calldata) {
92         return msg.data;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/access/Ownable.sol
97 
98 
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _setOwner(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _setOwner(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _setOwner(newOwner);
160     }
161 
162     function _setOwner(address newOwner) private {
163         address oldOwner = _owner;
164         _owner = newOwner;
165         emit OwnershipTransferred(oldOwner, newOwner);
166     }
167 }
168 
169 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/contracts/Authorizable.sol
170 
171 
172 pragma solidity >=0.4.22 <0.9.0;
173 
174 
175 contract Authorizable is Ownable {
176     address public trustee;
177 
178     constructor() {
179         trustee = address(0x0);
180     }
181 
182     modifier onlyAuthorized() {
183         require(msg.sender == trustee || msg.sender == owner());
184         _;
185     }
186 
187     function setTrustee(address _newTrustee) public onlyOwner {
188         trustee = _newTrustee;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Address.sol
193 
194 
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      */
219     function isContract(address account) internal view returns (bool) {
220         // This method relies on extcodesize, which returns 0 for contracts in
221         // construction, since the code is only stored at the end of the
222         // constructor execution.
223 
224         uint256 size;
225         assembly {
226             size := extcodesize(account)
227         }
228         return size > 0;
229     }
230 
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     /**
255      * @dev Performs a Solidity function call using a low level `call`. A
256      * plain `call` is an unsafe replacement for a function call: use this
257      * function instead.
258      *
259      * If `target` reverts with a revert reason, it is bubbled up by this
260      * function (like regular Solidity function calls).
261      *
262      * Returns the raw returned data. To convert to the expected return value,
263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
264      *
265      * Requirements:
266      *
267      * - `target` must be a contract.
268      * - calling `target` with `data` must not revert.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
311      * with `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(address(this).balance >= value, "Address: insufficient balance for call");
322         require(isContract(target), "Address: call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.call{value: value}(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
384      * revert reason using the provided one.
385      *
386      * _Available since v4.3._
387      */
388     function verifyCallResult(
389         bool success,
390         bytes memory returndata,
391         string memory errorMessage
392     ) internal pure returns (bytes memory) {
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
412 
413 
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @title ERC721 token receiver interface
419  * @dev Interface for any contract that wants to support safeTransfers
420  * from ERC721 asset contracts.
421  */
422 interface IERC721Receiver {
423     /**
424      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
425      * by `operator` from `from`, this function is called.
426      *
427      * It must return its Solidity selector to confirm the token transfer.
428      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
429      *
430      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
431      */
432     function onERC721Received(
433         address operator,
434         address from,
435         uint256 tokenId,
436         bytes calldata data
437     ) external returns (bytes4);
438 }
439 
440 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
441 
442 
443 
444 pragma solidity ^0.8.0;
445 
446 /**
447  * @dev Interface of the ERC165 standard, as defined in the
448  * https://eips.ethereum.org/EIPS/eip-165[EIP].
449  *
450  * Implementers can declare support of contract interfaces, which can then be
451  * queried by others ({ERC165Checker}).
452  *
453  * For an implementation, see {ERC165}.
454  */
455 interface IERC165 {
456     /**
457      * @dev Returns true if this contract implements the interface defined by
458      * `interfaceId`. See the corresponding
459      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
460      * to learn more about how these ids are created.
461      *
462      * This function call must use less than 30 000 gas.
463      */
464     function supportsInterface(bytes4 interfaceId) external view returns (bool);
465 }
466 
467 // File: @openzeppelin/contracts/interfaces/IERC165.sol
468 
469 
470 
471 pragma solidity ^0.8.0;
472 
473 
474 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
475 
476 
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Interface for the NFT Royalty Standard
483  */
484 interface IERC2981 is IERC165 {
485     /**
486      * @dev Called with the sale price to determine how much royalty is owed and to whom.
487      * @param tokenId - the NFT asset queried for royalty information
488      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
489      * @return receiver - address of who should be sent the royalty payment
490      * @return royaltyAmount - the royalty payment amount for `salePrice`
491      */
492     function royaltyInfo(uint256 tokenId, uint256 salePrice)
493         external
494         view
495         returns (address receiver, uint256 royaltyAmount);
496 }
497 
498 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
499 
500 
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Implementation of the {IERC165} interface.
507  *
508  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
509  * for the additional interface id that will be supported. For example:
510  *
511  * ```solidity
512  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
514  * }
515  * ```
516  *
517  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
518  */
519 abstract contract ERC165 is IERC165 {
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524         return interfaceId == type(IERC165).interfaceId;
525     }
526 }
527 
528 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
529 
530 
531 
532 pragma solidity ^0.8.0;
533 
534 
535 /**
536  * @dev Required interface of an ERC721 compliant contract.
537  */
538 interface IERC721 is IERC165 {
539     /**
540      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
541      */
542     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
543 
544     /**
545      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
546      */
547     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
551      */
552     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
553 
554     /**
555      * @dev Returns the number of tokens in ``owner``'s account.
556      */
557     function balanceOf(address owner) external view returns (uint256 balance);
558 
559     /**
560      * @dev Returns the owner of the `tokenId` token.
561      *
562      * Requirements:
563      *
564      * - `tokenId` must exist.
565      */
566     function ownerOf(uint256 tokenId) external view returns (address owner);
567 
568     /**
569      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
570      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must exist and be owned by `from`.
577      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId
586     ) external;
587 
588     /**
589      * @dev Transfers `tokenId` token from `from` to `to`.
590      *
591      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must be owned by `from`.
598      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
599      *
600      * Emits a {Transfer} event.
601      */
602     function transferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external;
607 
608     /**
609      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
610      * The approval is cleared when the token is transferred.
611      *
612      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
613      *
614      * Requirements:
615      *
616      * - The caller must own the token or be an approved operator.
617      * - `tokenId` must exist.
618      *
619      * Emits an {Approval} event.
620      */
621     function approve(address to, uint256 tokenId) external;
622 
623     /**
624      * @dev Returns the account approved for `tokenId` token.
625      *
626      * Requirements:
627      *
628      * - `tokenId` must exist.
629      */
630     function getApproved(uint256 tokenId) external view returns (address operator);
631 
632     /**
633      * @dev Approve or remove `operator` as an operator for the caller.
634      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
635      *
636      * Requirements:
637      *
638      * - The `operator` cannot be the caller.
639      *
640      * Emits an {ApprovalForAll} event.
641      */
642     function setApprovalForAll(address operator, bool _approved) external;
643 
644     /**
645      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
646      *
647      * See {setApprovalForAll}
648      */
649     function isApprovedForAll(address owner, address operator) external view returns (bool);
650 
651     /**
652      * @dev Safely transfers `tokenId` token from `from` to `to`.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must exist and be owned by `from`.
659      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
660      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
661      *
662      * Emits a {Transfer} event.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId,
668         bytes calldata data
669     ) external;
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
673 
674 
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Enumerable is IERC721 {
684     /**
685      * @dev Returns the total amount of tokens stored by the contract.
686      */
687     function totalSupply() external view returns (uint256);
688 
689     /**
690      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
691      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
692      */
693     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
694 
695     /**
696      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
697      * Use along with {totalSupply} to enumerate all tokens.
698      */
699     function tokenByIndex(uint256 index) external view returns (uint256);
700 }
701 
702 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
703 
704 
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
711  * @dev See https://eips.ethereum.org/EIPS/eip-721
712  */
713 interface IERC721Metadata is IERC721 {
714     /**
715      * @dev Returns the token collection name.
716      */
717     function name() external view returns (string memory);
718 
719     /**
720      * @dev Returns the token collection symbol.
721      */
722     function symbol() external view returns (string memory);
723 
724     /**
725      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
726      */
727     function tokenURI(uint256 tokenId) external view returns (string memory);
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
731 
732 
733 
734 pragma solidity ^0.8.0;
735 
736 
737 
738 
739 
740 
741 
742 
743 /**
744  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
745  * the Metadata extension, but not including the Enumerable extension, which is available separately as
746  * {ERC721Enumerable}.
747  */
748 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
749     using Address for address;
750     using Strings for uint256;
751 
752     // Token name
753     string private _name;
754 
755     // Token symbol
756     string private _symbol;
757 
758     // Mapping from token ID to owner address
759     mapping(uint256 => address) private _owners;
760 
761     // Mapping owner address to token count
762     mapping(address => uint256) private _balances;
763 
764     // Mapping from token ID to approved address
765     mapping(uint256 => address) private _tokenApprovals;
766 
767     // Mapping from owner to operator approvals
768     mapping(address => mapping(address => bool)) private _operatorApprovals;
769 
770     /**
771      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
772      */
773     constructor(string memory name_, string memory symbol_) {
774         _name = name_;
775         _symbol = symbol_;
776     }
777 
778     /**
779      * @dev See {IERC165-supportsInterface}.
780      */
781     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
782         return
783             interfaceId == type(IERC721).interfaceId ||
784             interfaceId == type(IERC721Metadata).interfaceId ||
785             super.supportsInterface(interfaceId);
786     }
787 
788     /**
789      * @dev See {IERC721-balanceOf}.
790      */
791     function balanceOf(address owner) public view virtual override returns (uint256) {
792         require(owner != address(0), "ERC721: balance query for the zero address");
793         return _balances[owner];
794     }
795 
796     /**
797      * @dev See {IERC721-ownerOf}.
798      */
799     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
800         address owner = _owners[tokenId];
801         require(owner != address(0), "ERC721: owner query for nonexistent token");
802         return owner;
803     }
804 
805     /**
806      * @dev See {IERC721Metadata-name}.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev See {IERC721Metadata-symbol}.
814      */
815     function symbol() public view virtual override returns (string memory) {
816         return _symbol;
817     }
818 
819     /**
820      * @dev See {IERC721Metadata-tokenURI}.
821      */
822     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
823         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
824 
825         string memory baseURI = _baseURI();
826         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
827     }
828 
829     /**
830      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
831      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
832      * by default, can be overriden in child contracts.
833      */
834     function _baseURI() internal view virtual returns (string memory) {
835         return "";
836     }
837 
838     /**
839      * @dev See {IERC721-approve}.
840      */
841     function approve(address to, uint256 tokenId) public virtual override {
842         address owner = ERC721.ownerOf(tokenId);
843         require(to != owner, "ERC721: approval to current owner");
844 
845         require(
846             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
847             "ERC721: approve caller is not owner nor approved for all"
848         );
849 
850         _approve(to, tokenId);
851     }
852 
853     /**
854      * @dev See {IERC721-getApproved}.
855      */
856     function getApproved(uint256 tokenId) public view virtual override returns (address) {
857         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
858 
859         return _tokenApprovals[tokenId];
860     }
861 
862     /**
863      * @dev See {IERC721-setApprovalForAll}.
864      */
865     function setApprovalForAll(address operator, bool approved) public virtual override {
866         require(operator != _msgSender(), "ERC721: approve to caller");
867 
868         _operatorApprovals[_msgSender()][operator] = approved;
869         emit ApprovalForAll(_msgSender(), operator, approved);
870     }
871 
872     /**
873      * @dev See {IERC721-isApprovedForAll}.
874      */
875     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
876         return _operatorApprovals[owner][operator];
877     }
878 
879     /**
880      * @dev See {IERC721-transferFrom}.
881      */
882     function transferFrom(
883         address from,
884         address to,
885         uint256 tokenId
886     ) public virtual override {
887         //solhint-disable-next-line max-line-length
888         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
889 
890         _transfer(from, to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-safeTransferFrom}.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         safeTransferFrom(from, to, tokenId, "");
902     }
903 
904     /**
905      * @dev See {IERC721-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId,
911         bytes memory _data
912     ) public virtual override {
913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
914         _safeTransfer(from, to, tokenId, _data);
915     }
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
919      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
920      *
921      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
922      *
923      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
924      * implement alternative mechanisms to perform token transfer, such as signature-based.
925      *
926      * Requirements:
927      *
928      * - `from` cannot be the zero address.
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must exist and be owned by `from`.
931      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _safeTransfer(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) internal virtual {
941         _transfer(from, to, tokenId);
942         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
943     }
944 
945     /**
946      * @dev Returns whether `tokenId` exists.
947      *
948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
949      *
950      * Tokens start existing when they are minted (`_mint`),
951      * and stop existing when they are burned (`_burn`).
952      */
953     function _exists(uint256 tokenId) internal view virtual returns (bool) {
954         return _owners[tokenId] != address(0);
955     }
956 
957     /**
958      * @dev Returns whether `spender` is allowed to manage `tokenId`.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      */
964     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
965         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
966         address owner = ERC721.ownerOf(tokenId);
967         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
968     }
969 
970     /**
971      * @dev Safely mints `tokenId` and transfers it to `to`.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _safeMint(address to, uint256 tokenId) internal virtual {
981         _safeMint(to, tokenId, "");
982     }
983 
984     /**
985      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
986      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
987      */
988     function _safeMint(
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) internal virtual {
993         _mint(to, tokenId);
994         require(
995             _checkOnERC721Received(address(0), to, tokenId, _data),
996             "ERC721: transfer to non ERC721Receiver implementer"
997         );
998     }
999 
1000     /**
1001      * @dev Mints `tokenId` and transfers it to `to`.
1002      *
1003      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must not exist.
1008      * - `to` cannot be the zero address.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _mint(address to, uint256 tokenId) internal virtual {
1013         require(to != address(0), "ERC721: mint to the zero address");
1014         require(!_exists(tokenId), "ERC721: token already minted");
1015 
1016         _beforeTokenTransfer(address(0), to, tokenId);
1017 
1018         _balances[to] += 1;
1019         _owners[tokenId] = to;
1020 
1021         emit Transfer(address(0), to, tokenId);
1022     }
1023 
1024     /**
1025      * @dev Destroys `tokenId`.
1026      * The approval is cleared when the token is burned.
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must exist.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _burn(uint256 tokenId) internal virtual {
1035         address owner = ERC721.ownerOf(tokenId);
1036 
1037         _beforeTokenTransfer(owner, address(0), tokenId);
1038 
1039         // Clear approvals
1040         _approve(address(0), tokenId);
1041 
1042         _balances[owner] -= 1;
1043         delete _owners[tokenId];
1044 
1045         emit Transfer(owner, address(0), tokenId);
1046     }
1047 
1048     /**
1049      * @dev Transfers `tokenId` from `from` to `to`.
1050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {
1064         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1065         require(to != address(0), "ERC721: transfer to the zero address");
1066 
1067         _beforeTokenTransfer(from, to, tokenId);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId);
1071 
1072         _balances[from] -= 1;
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits a {Approval} event.
1083      */
1084     function _approve(address to, uint256 tokenId) internal virtual {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1091      * The call is not executed if the target address is not a contract.
1092      *
1093      * @param from address representing the previous owner of the given token ID
1094      * @param to target address that will receive the tokens
1095      * @param tokenId uint256 ID of the token to be transferred
1096      * @param _data bytes optional data to send along with the call
1097      * @return bool whether the call correctly returned the expected magic value
1098      */
1099     function _checkOnERC721Received(
1100         address from,
1101         address to,
1102         uint256 tokenId,
1103         bytes memory _data
1104     ) private returns (bool) {
1105         if (to.isContract()) {
1106             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1107                 return retval == IERC721Receiver.onERC721Received.selector;
1108             } catch (bytes memory reason) {
1109                 if (reason.length == 0) {
1110                     revert("ERC721: transfer to non ERC721Receiver implementer");
1111                 } else {
1112                     assembly {
1113                         revert(add(32, reason), mload(reason))
1114                     }
1115                 }
1116             }
1117         } else {
1118             return true;
1119         }
1120     }
1121 
1122     /**
1123      * @dev Hook that is called before any token transfer. This includes minting
1124      * and burning.
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` will be minted for `to`.
1131      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1132      * - `from` and `to` are never both zero.
1133      *
1134      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1135      */
1136     function _beforeTokenTransfer(
1137         address from,
1138         address to,
1139         uint256 tokenId
1140     ) internal virtual {}
1141 }
1142 
1143 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1144 
1145 
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 
1151 /**
1152  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1153  * enumerability of all the token ids in the contract as well as all token ids owned by each
1154  * account.
1155  */
1156 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1157     // Mapping from owner to list of owned token IDs
1158     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1159 
1160     // Mapping from token ID to index of the owner tokens list
1161     mapping(uint256 => uint256) private _ownedTokensIndex;
1162 
1163     // Array with all token ids, used for enumeration
1164     uint256[] private _allTokens;
1165 
1166     // Mapping from token id to position in the allTokens array
1167     mapping(uint256 => uint256) private _allTokensIndex;
1168 
1169     /**
1170      * @dev See {IERC165-supportsInterface}.
1171      */
1172     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1173         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1178      */
1179     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1180         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1181         return _ownedTokens[owner][index];
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Enumerable-totalSupply}.
1186      */
1187     function totalSupply() public view virtual override returns (uint256) {
1188         return _allTokens.length;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Enumerable-tokenByIndex}.
1193      */
1194     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1195         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1196         return _allTokens[index];
1197     }
1198 
1199     /**
1200      * @dev Hook that is called before any token transfer. This includes minting
1201      * and burning.
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` will be minted for `to`.
1208      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1209      * - `from` cannot be the zero address.
1210      * - `to` cannot be the zero address.
1211      *
1212      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1213      */
1214     function _beforeTokenTransfer(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) internal virtual override {
1219         super._beforeTokenTransfer(from, to, tokenId);
1220 
1221         if (from == address(0)) {
1222             _addTokenToAllTokensEnumeration(tokenId);
1223         } else if (from != to) {
1224             _removeTokenFromOwnerEnumeration(from, tokenId);
1225         }
1226         if (to == address(0)) {
1227             _removeTokenFromAllTokensEnumeration(tokenId);
1228         } else if (to != from) {
1229             _addTokenToOwnerEnumeration(to, tokenId);
1230         }
1231     }
1232 
1233     /**
1234      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1235      * @param to address representing the new owner of the given token ID
1236      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1237      */
1238     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1239         uint256 length = ERC721.balanceOf(to);
1240         _ownedTokens[to][length] = tokenId;
1241         _ownedTokensIndex[tokenId] = length;
1242     }
1243 
1244     /**
1245      * @dev Private function to add a token to this extension's token tracking data structures.
1246      * @param tokenId uint256 ID of the token to be added to the tokens list
1247      */
1248     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1249         _allTokensIndex[tokenId] = _allTokens.length;
1250         _allTokens.push(tokenId);
1251     }
1252 
1253     /**
1254      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1255      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1256      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1257      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1258      * @param from address representing the previous owner of the given token ID
1259      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1260      */
1261     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1262         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1263         // then delete the last slot (swap and pop).
1264 
1265         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1266         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1267 
1268         // When the token to delete is the last token, the swap operation is unnecessary
1269         if (tokenIndex != lastTokenIndex) {
1270             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1271 
1272             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1273             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1274         }
1275 
1276         // This also deletes the contents at the last position of the array
1277         delete _ownedTokensIndex[tokenId];
1278         delete _ownedTokens[from][lastTokenIndex];
1279     }
1280 
1281     /**
1282      * @dev Private function to remove a token from this extension's token tracking data structures.
1283      * This has O(1) time complexity, but alters the order of the _allTokens array.
1284      * @param tokenId uint256 ID of the token to be removed from the tokens list
1285      */
1286     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1287         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1288         // then delete the last slot (swap and pop).
1289 
1290         uint256 lastTokenIndex = _allTokens.length - 1;
1291         uint256 tokenIndex = _allTokensIndex[tokenId];
1292 
1293         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1294         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1295         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1296         uint256 lastTokenId = _allTokens[lastTokenIndex];
1297 
1298         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1299         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1300 
1301         // This also deletes the contents at the last position of the array
1302         delete _allTokensIndex[tokenId];
1303         _allTokens.pop();
1304     }
1305 }
1306 
1307 // File: github/bitmark-inc/feralfile-exhibition-smart-contract/contracts/FeralfileArtworkV2.sol
1308 
1309 
1310 pragma solidity ^0.8.0;
1311 
1312 
1313 
1314 
1315 
1316 contract FeralfileExhibitionV2 is ERC721Enumerable, Authorizable, IERC2981 {
1317     using Strings for uint256;
1318 
1319     // royalty payout address
1320     address public royaltyPayoutAddress;
1321 
1322     // The maximum limit of edition size for each exhibitions
1323     uint256 public immutable maxEditionPerArtwork;
1324 
1325     // the basis points of royalty payments for each secondary sales
1326     uint256 public immutable secondarySaleRoyaltyBPS;
1327 
1328     // the maximum basis points of royalty payments
1329     uint256 public constant MAX_ROYALITY_BPS = 100_00;
1330 
1331     // token base URI
1332     string private _tokenBaseURI;
1333 
1334     // contract URI
1335     string private _contractURI;
1336 
1337     /// @notice A structure for Feral File artwork
1338     struct Artwork {
1339         string title;
1340         string artistName;
1341         string fingerprint;
1342         uint256 editionSize;
1343     }
1344 
1345     struct ArtworkEdition {
1346         uint256 editionID;
1347         string ipfsCID;
1348     }
1349 
1350     uint256[] private _allArtworks;
1351     mapping(uint256 => Artwork) public artworks; // artworkID => Artwork
1352     mapping(uint256 => ArtworkEdition) public artworkEditions; // artworkEditionID => ArtworkEdition
1353     mapping(uint256 => uint256[]) internal allArtworkEditions; // artworkID => []ArtworkEditionID
1354     mapping(uint256 => bool) internal registeredBitmarks; // bitmarkID => bool
1355     mapping(string => bool) internal registeredIPFSCIDs; // ipfsCID => bool
1356 
1357     constructor(
1358         string memory name_,
1359         string memory symbol_,
1360         uint256 maxEditionPerArtwork_,
1361         uint256 secondarySaleRoyaltyBPS_,
1362         address royaltyPayoutAddress_,
1363         string memory contractURI_,
1364         string memory tokenBaseURI_
1365     ) ERC721(name_, symbol_) {
1366         require(
1367             maxEditionPerArtwork_ > 0,
1368             "maxEdition of each artwork in an exhibition needs to be greater than zero"
1369         );
1370         require(
1371             secondarySaleRoyaltyBPS_ <= MAX_ROYALITY_BPS,
1372             "royalty BPS for secondary sales can not be greater than the maximum royalty BPS"
1373         );
1374         require(
1375             royaltyPayoutAddress_ != address(0),
1376             "invalid royalty payout address"
1377         );
1378 
1379         maxEditionPerArtwork = maxEditionPerArtwork_;
1380         secondarySaleRoyaltyBPS = secondarySaleRoyaltyBPS_;
1381         royaltyPayoutAddress = royaltyPayoutAddress_;
1382         _contractURI = contractURI_;
1383         _tokenBaseURI = tokenBaseURI_;
1384     }
1385 
1386     function supportsInterface(bytes4 interfaceId)
1387         public
1388         view
1389         virtual
1390         override(ERC721Enumerable, IERC165)
1391         returns (bool)
1392     {
1393         return
1394             interfaceId == type(IERC721Enumerable).interfaceId ||
1395             super.supportsInterface(interfaceId);
1396     }
1397 
1398     /// @notice Call to create an artwork in the exhibition
1399     /// @param fingerprint - the fingerprint of an artwork
1400     /// @param title - the title of an artwork
1401     /// @param artistName - the artist of an artwork
1402     /// @param editionSize - the maximum edition size of an artwork
1403     function createArtwork(
1404         string memory fingerprint,
1405         string memory title,
1406         string memory artistName,
1407         uint256 editionSize
1408     ) external onlyAuthorized {
1409         require(bytes(title).length != 0, "title can not be empty");
1410         require(bytes(artistName).length != 0, "artist can not be empty");
1411         require(bytes(fingerprint).length != 0, "fingerprint can not be empty");
1412         require(editionSize > 0, "edition size needs to be at least 1");
1413         require(
1414             editionSize <= maxEditionPerArtwork,
1415             "artwork edition size exceeds the maximum edition size of the exhibition"
1416         );
1417 
1418         uint256 artworkID = uint256(keccak256(abi.encode(fingerprint)));
1419 
1420         /// @notice make sure the artwork have not been registered
1421         require(
1422             bytes(artworks[artworkID].fingerprint).length == 0,
1423             "an artwork with the same fingerprint has already registered"
1424         );
1425 
1426         Artwork memory artwork = Artwork(
1427             title = title,
1428             artistName = artistName,
1429             fingerprint = fingerprint,
1430             editionSize = editionSize
1431         );
1432 
1433         _allArtworks.push(artworkID);
1434         artworks[artworkID] = artwork;
1435 
1436         emit NewArtwork(artworkID);
1437     }
1438 
1439     /// @notice Return a count of artworks registered in this exhibition
1440     function totalArtworks() public view virtual returns (uint256) {
1441         return _allArtworks.length;
1442     }
1443 
1444     /// @notice Return the token identifier for the `index`th artwork
1445     function getArtworkByIndex(uint256 index)
1446         public
1447         view
1448         virtual
1449         returns (uint256)
1450     {
1451         require(
1452             index < totalArtworks(),
1453             "artworks: global index out of bounds"
1454         );
1455         return _allArtworks[index];
1456     }
1457 
1458     /// @notice Swap an existent artwork from bitmark to ERC721
1459     /// @param artworkID - the artwork id where the new edition is referenced to
1460     /// @param bitmarkID - the bitmark id of artwork edition before swapped
1461     /// @param editionNumber - the edition number of the artwork edition
1462     /// @param owner - the owner address of the new minted token
1463     /// @param ipfsCID - the IPFS cid for the new token
1464     function swapArtworkFromBitmark(
1465         uint256 artworkID,
1466         uint256 bitmarkID,
1467         uint256 editionNumber,
1468         address owner,
1469         string memory ipfsCID
1470     ) external onlyAuthorized {
1471         /// @notice the edition size is not set implies the artwork is not created
1472         require(artworks[artworkID].editionSize > 0, "artwork is not found");
1473         /// @notice The range of editionNumber should be between 0 (AP) ~ artwork.editionSize
1474         require(
1475             editionNumber <= artworks[artworkID].editionSize,
1476             "edition number exceed the edition size of the artwork"
1477         );
1478         require(owner != address(0), "invalid owner address");
1479         require(!registeredBitmarks[bitmarkID], "bitmark id has registered");
1480         require(!registeredIPFSCIDs[ipfsCID], "ipfs id has registered");
1481 
1482         uint256 editionID = artworkID + editionNumber;
1483         require(
1484             artworkEditions[editionID].editionID == 0,
1485             "the edition is existent"
1486         );
1487 
1488         ArtworkEdition memory edition = ArtworkEdition(
1489             editionID = editionID,
1490             ipfsCID = ipfsCID
1491         );
1492 
1493         artworkEditions[editionID] = edition;
1494         allArtworkEditions[artworkID].push(editionID);
1495 
1496         registeredBitmarks[bitmarkID] = true;
1497         registeredIPFSCIDs[ipfsCID] = true;
1498 
1499         _safeMint(owner, editionID);
1500         emit NewArtworkEdition(owner, artworkID, editionID);
1501     }
1502 
1503     /// @notice Update the IPFS cid of an edition to a new value
1504     function updateArtworkEditionIPFSCid(uint256 tokenId, string memory ipfsCID)
1505         external
1506         onlyAuthorized
1507     {
1508         require(_exists(tokenId), "artwork edition is not found");
1509         require(!registeredIPFSCIDs[ipfsCID], "ipfs id has registered");
1510 
1511         ArtworkEdition storage edition = artworkEditions[tokenId];
1512         delete registeredIPFSCIDs[edition.ipfsCID];
1513         registeredIPFSCIDs[ipfsCID] = true;
1514         edition.ipfsCID = ipfsCID;
1515     }
1516 
1517     /// @notice setRoyaltyPayoutAddress assigns a payout address so
1518     //          that we can split the royalty.
1519     /// @param royaltyPayoutAddress_ - the new royalty payout address
1520     function setRoyaltyPayoutAddress(address royaltyPayoutAddress_)
1521         external
1522         onlyAuthorized
1523     {
1524         require(
1525             royaltyPayoutAddress_ != address(0),
1526             "invalid royalty payout address"
1527         );
1528         royaltyPayoutAddress = royaltyPayoutAddress_;
1529     }
1530 
1531     /// @notice Return the edition counts for an artwork
1532     function totalEditionOfArtwork(uint256 artworkID)
1533         public
1534         view
1535         returns (uint256)
1536     {
1537         return allArtworkEditions[artworkID].length;
1538     }
1539 
1540     /// @notice Return the edition id of an artwork by index
1541     function getArtworkEditionByIndex(uint256 artworkID, uint256 index)
1542         public
1543         view
1544         returns (uint256)
1545     {
1546         require(index < totalEditionOfArtwork(artworkID));
1547         return allArtworkEditions[artworkID][index];
1548     }
1549 
1550     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
1551     function tokenURI(uint256 tokenId)
1552         public
1553         view
1554         virtual
1555         override
1556         returns (string memory)
1557     {
1558         require(
1559             _exists(tokenId),
1560             "ERC721Metadata: URI query for nonexistent token"
1561         );
1562 
1563         string memory baseURI = _tokenBaseURI;
1564         if (bytes(baseURI).length == 0) {
1565             baseURI = "ipfs://";
1566         }
1567 
1568         return
1569             string(
1570                 abi.encodePacked(
1571                     baseURI,
1572                     artworkEditions[tokenId].ipfsCID,
1573                     "/metadata.json"
1574                 )
1575             );
1576     }
1577 
1578     /// @notice Update the base URI for all tokens
1579     function setTokenBaseURI(string memory baseURI_) external onlyAuthorized {
1580         _tokenBaseURI = baseURI_;
1581     }
1582 
1583     /// @notice A URL for the opensea storefront-level metadata
1584     function contractURI() public view returns (string memory) {
1585         return _contractURI;
1586     }
1587 
1588     /// @notice Called with the sale price to determine how much royalty
1589     //          is owed and to whom.
1590     /// @param tokenId - the NFT asset queried for royalty information
1591     /// @param salePrice - the sale price of the NFT asset specified by tokenId
1592     /// @return receiver - address of who should be sent the royalty payment
1593     /// @return royaltyAmount - the royalty payment amount for salePrice
1594     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1595         external
1596         view
1597         override
1598         returns (address receiver, uint256 royaltyAmount)
1599     {
1600         require(
1601             _exists(tokenId),
1602             "ERC2981: query royalty info for nonexistent token"
1603         );
1604 
1605         receiver = royaltyPayoutAddress;
1606 
1607         royaltyAmount =
1608             (salePrice * secondarySaleRoyaltyBPS) /
1609             MAX_ROYALITY_BPS;
1610     }
1611 
1612     event NewArtwork(uint256 indexed artworkID);
1613     event NewArtworkEdition(
1614         address indexed owner,
1615         uint256 indexed artworkID,
1616         uint256 indexed editionID
1617     );
1618 }