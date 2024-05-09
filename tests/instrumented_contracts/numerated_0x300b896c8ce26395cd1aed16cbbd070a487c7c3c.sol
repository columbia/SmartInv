1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Collection of functions related to the address type
79  */
80 library Address {
81     /**
82      * @dev Returns true if `account` is a contract.
83      *
84      * [IMPORTANT]
85      * ====
86      * It is unsafe to assume that an address for which this function returns
87      * false is an externally-owned account (EOA) and not a contract.
88      *
89      * Among others, `isContract` will return false for the following
90      * types of addresses:
91      *
92      *  - an externally-owned account
93      *  - a contract in construction
94      *  - an address where a contract will be created
95      *  - an address where a contract lived, but was destroyed
96      * ====
97      */
98     function isContract(address account) internal view returns (bool) {
99         // This method relies on extcodesize, which returns 0 for contracts in
100         // construction, since the code is only stored at the end of the
101         // constructor execution.
102 
103         uint256 size;
104         assembly {
105             size := extcodesize(account)
106         }
107         return size > 0;
108     }
109 
110     /**
111      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
112      * `recipient`, forwarding all available gas and reverting on errors.
113      *
114      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
115      * of certain opcodes, possibly making contracts go over the 2300 gas limit
116      * imposed by `transfer`, making them unable to receive funds via
117      * `transfer`. {sendValue} removes this limitation.
118      *
119      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
120      *
121      * IMPORTANT: because control is transferred to `recipient`, care must be
122      * taken to not create reentrancy vulnerabilities. Consider using
123      * {ReentrancyGuard} or the
124      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
125      */
126     function sendValue(address payable recipient, uint256 amount) internal {
127         require(address(this).balance >= amount, "Address: insufficient balance");
128 
129         (bool success, ) = recipient.call{value: amount}("");
130         require(success, "Address: unable to send value, recipient may have reverted");
131     }
132 
133     /**
134      * @dev Performs a Solidity function call using a low level `call`. A
135      * plain `call` is an unsafe replacement for a function call: use this
136      * function instead.
137      *
138      * If `target` reverts with a revert reason, it is bubbled up by this
139      * function (like regular Solidity function calls).
140      *
141      * Returns the raw returned data. To convert to the expected return value,
142      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
143      *
144      * Requirements:
145      *
146      * - `target` must be a contract.
147      * - calling `target` with `data` must not revert.
148      *
149      * _Available since v3.1._
150      */
151     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
152         return functionCall(target, data, "Address: low-level call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
157      * `errorMessage` as a fallback revert reason when `target` reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         return functionCallWithValue(target, data, 0, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
171      * but also transferring `value` wei to `target`.
172      *
173      * Requirements:
174      *
175      * - the calling contract must have an ETH balance of at least `value`.
176      * - the called Solidity function must be `payable`.
177      *
178      * _Available since v3.1._
179      */
180     function functionCallWithValue(
181         address target,
182         bytes memory data,
183         uint256 value
184     ) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
190      * with `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value,
198         string memory errorMessage
199     ) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         require(isContract(target), "Address: call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.call{value: value}(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
209      * but performing a static call.
210      *
211      * _Available since v3.3._
212      */
213     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
214         return functionStaticCall(target, data, "Address: low-level static call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
219      * but performing a static call.
220      *
221      * _Available since v3.3._
222      */
223     function functionStaticCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal view returns (bytes memory) {
228         require(isContract(target), "Address: static call to non-contract");
229 
230         (bool success, bytes memory returndata) = target.staticcall(data);
231         return verifyCallResult(success, returndata, errorMessage);
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
236      * but performing a delegate call.
237      *
238      * _Available since v3.4._
239      */
240     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
241         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
246      * but performing a delegate call.
247      *
248      * _Available since v3.4._
249      */
250     function functionDelegateCall(
251         address target,
252         bytes memory data,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(isContract(target), "Address: delegate call to non-contract");
256 
257         (bool success, bytes memory returndata) = target.delegatecall(data);
258         return verifyCallResult(success, returndata, errorMessage);
259     }
260 
261     /**
262      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
263      * revert reason using the provided one.
264      *
265      * _Available since v4.3._
266      */
267     function verifyCallResult(
268         bool success,
269         bytes memory returndata,
270         string memory errorMessage
271     ) internal pure returns (bytes memory) {
272         if (success) {
273             return returndata;
274         } else {
275             // Look for revert reason and bubble it up if present
276             if (returndata.length > 0) {
277                 // The easiest way to bubble the revert reason is using memory via assembly
278 
279                 assembly {
280                     let returndata_size := mload(returndata)
281                     revert(add(32, returndata), returndata_size)
282                 }
283             } else {
284                 revert(errorMessage);
285             }
286         }
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Context.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Provides information about the current execution context, including the
298  * sender of the transaction and its data. While these are generally available
299  * via msg.sender and msg.data, they should not be accessed in such a direct
300  * manner, since when dealing with meta-transactions the account sending and
301  * paying for execution may not be the actual sender (as far as an application
302  * is concerned).
303  *
304  * This contract is only required for intermediate, library-like contracts.
305  */
306 abstract contract Context {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes calldata) {
312         return msg.data;
313     }
314 }
315 
316 // File: @openzeppelin/contracts/access/Ownable.sol
317 
318 
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Contract module which provides a basic access control mechanism, where
325  * there is an account (an owner) that can be granted exclusive access to
326  * specific functions.
327  *
328  * By default, the owner account will be the one that deploys the contract. This
329  * can later be changed with {transferOwnership}.
330  *
331  * This module is used through inheritance. It will make available the modifier
332  * `onlyOwner`, which can be applied to your functions to restrict their use to
333  * the owner.
334  */
335 abstract contract Ownable is Context {
336     address private _owner;
337 
338     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
339 
340     /**
341      * @dev Initializes the contract setting the deployer as the initial owner.
342      */
343     constructor() {
344         _setOwner(_msgSender());
345     }
346 
347     /**
348      * @dev Returns the address of the current owner.
349      */
350     function owner() public view virtual returns (address) {
351         return _owner;
352     }
353 
354     /**
355      * @dev Throws if called by any account other than the owner.
356      */
357     modifier onlyOwner() {
358         require(owner() == _msgSender(), "Ownable: caller is not the owner");
359         _;
360     }
361 
362     /**
363      * @dev Leaves the contract without owner. It will not be possible to call
364      * `onlyOwner` functions anymore. Can only be called by the current owner.
365      *
366      * NOTE: Renouncing ownership will leave the contract without an owner,
367      * thereby removing any functionality that is only available to the owner.
368      */
369     function renounceOwnership() public virtual onlyOwner {
370         _setOwner(address(0));
371     }
372 
373     /**
374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
375      * Can only be called by the current owner.
376      */
377     function transferOwnership(address newOwner) public virtual onlyOwner {
378         require(newOwner != address(0), "Ownable: new owner is the zero address");
379         _setOwner(newOwner);
380     }
381 
382     function _setOwner(address newOwner) private {
383         address oldOwner = _owner;
384         _owner = newOwner;
385         emit OwnershipTransferred(oldOwner, newOwner);
386     }
387 }
388 
389 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
419 
420 
421 
422 pragma solidity ^0.8.0;
423 
424 /**
425  * @dev Interface of the ERC165 standard, as defined in the
426  * https://eips.ethereum.org/EIPS/eip-165[EIP].
427  *
428  * Implementers can declare support of contract interfaces, which can then be
429  * queried by others ({ERC165Checker}).
430  *
431  * For an implementation, see {ERC165}.
432  */
433 interface IERC165 {
434     /**
435      * @dev Returns true if this contract implements the interface defined by
436      * `interfaceId`. See the corresponding
437      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
438      * to learn more about how these ids are created.
439      *
440      * This function call must use less than 30 000 gas.
441      */
442     function supportsInterface(bytes4 interfaceId) external view returns (bool);
443 }
444 
445 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 
452 /**
453  * @dev Implementation of the {IERC165} interface.
454  *
455  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
456  * for the additional interface id that will be supported. For example:
457  *
458  * ```solidity
459  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
461  * }
462  * ```
463  *
464  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
465  */
466 abstract contract ERC165 is IERC165 {
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471         return interfaceId == type(IERC165).interfaceId;
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
476 
477 
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Required interface of an ERC721 compliant contract.
484  */
485 interface IERC721 is IERC165 {
486     /**
487      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
493      */
494     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
495 
496     /**
497      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
498      */
499     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
500 
501     /**
502      * @dev Returns the number of tokens in ``owner``'s account.
503      */
504     function balanceOf(address owner) external view returns (uint256 balance);
505 
506     /**
507      * @dev Returns the owner of the `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function ownerOf(uint256 tokenId) external view returns (address owner);
514 
515     /**
516      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
517      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Transfers `tokenId` token from `from` to `to`.
537      *
538      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(
550         address from,
551         address to,
552         uint256 tokenId
553     ) external;
554 
555     /**
556      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
557      * The approval is cleared when the token is transferred.
558      *
559      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
560      *
561      * Requirements:
562      *
563      * - The caller must own the token or be an approved operator.
564      * - `tokenId` must exist.
565      *
566      * Emits an {Approval} event.
567      */
568     function approve(address to, uint256 tokenId) external;
569 
570     /**
571      * @dev Returns the account approved for `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function getApproved(uint256 tokenId) external view returns (address operator);
578 
579     /**
580      * @dev Approve or remove `operator` as an operator for the caller.
581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
582      *
583      * Requirements:
584      *
585      * - The `operator` cannot be the caller.
586      *
587      * Emits an {ApprovalForAll} event.
588      */
589     function setApprovalForAll(address operator, bool _approved) external;
590 
591     /**
592      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
593      *
594      * See {setApprovalForAll}
595      */
596     function isApprovedForAll(address owner, address operator) external view returns (bool);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
620 
621 
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
628  * @dev See https://eips.ethereum.org/EIPS/eip-721
629  */
630 interface IERC721Enumerable is IERC721 {
631     /**
632      * @dev Returns the total amount of tokens stored by the contract.
633      */
634     function totalSupply() external view returns (uint256);
635 
636     /**
637      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
638      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
639      */
640     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
641 
642     /**
643      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
644      * Use along with {totalSupply} to enumerate all tokens.
645      */
646     function tokenByIndex(uint256 index) external view returns (uint256);
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
650 
651 
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
658  * @dev See https://eips.ethereum.org/EIPS/eip-721
659  */
660 interface IERC721Metadata is IERC721 {
661     /**
662      * @dev Returns the token collection name.
663      */
664     function name() external view returns (string memory);
665 
666     /**
667      * @dev Returns the token collection symbol.
668      */
669     function symbol() external view returns (string memory);
670 
671     /**
672      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
673      */
674     function tokenURI(uint256 tokenId) external view returns (string memory);
675 }
676 
677 // File: contracts/V2Punks.sol
678 
679 
680 // Creator: Shadowy Coder
681 
682 pragma solidity ^0.8.0;
683 
684 
685 
686 
687 
688 
689 
690 
691 
692 
693 /**
694 888     888  .d8888b.  
695 888     888 d88P  Y88b 
696 888     888        888 
697 Y88b   d88P      .d88P 
698  Y88b d88P   .od888P"  
699   Y88o88P   d88P"      
700    Y888P    888"       
701     Y8P     888888888                                       
702 **/
703 
704 contract V2Punks is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
705     using Address for address;
706     using Strings for uint256;
707 
708     struct TokenOwnership {
709         address addr;
710         uint64 startTimestamp;
711     }
712 
713     struct AddressData {
714         uint128 balance;
715         uint128 numberMinted;
716     }
717 
718     uint256 internal currentIndex = 0;
719 
720     // mint price
721     uint256 public _price = 10000000000000000;
722 
723     // Token name
724     string private _name;
725 
726     address private _owner = msg.sender;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Base URI
732     string private _baseURIextended;
733 
734     // Mapping from token ID to ownership details
735     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
736     mapping(uint256 => TokenOwnership) internal _ownerships;
737 
738     // Mapping owner address to address data
739     mapping(address => AddressData) private _addressData;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750         _baseURIextended = 'ipfs://QmUSivCzYphi5i2h7RGriY5bdrBVb9nLtG5y2t37BRPXL9/';
751     }
752 
753     /**
754      * @dev See {IERC721Enumerable-totalSupply}.
755      */
756     function totalSupply() public view override returns (uint256) {
757         return currentIndex;
758     }
759 
760     /**
761      * @dev See {IERC721Enumerable-tokenByIndex}.
762      */
763     function tokenByIndex(uint256 index) public view override returns (uint256) {
764         require(index < totalSupply(), 'ERC721A: global index out of bounds');
765         return index;
766     }
767 
768     /**
769      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
770      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
771      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
772      */
773     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
774         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
775         uint256 numMintedSoFar = totalSupply();
776         uint256 tokenIdsIdx = 0;
777         address currOwnershipAddr = address(0);
778         for (uint256 i = 0; i < numMintedSoFar; i++) {
779             TokenOwnership memory ownership = _ownerships[i];
780             if (ownership.addr != address(0)) {
781                 currOwnershipAddr = ownership.addr;
782             }
783             if (currOwnershipAddr == owner) {
784                 if (tokenIdsIdx == index) {
785                     return i;
786                 }
787                 tokenIdsIdx++;
788             }
789         }
790         revert('ERC721A: unable to get token of owner by index');
791     }
792 
793     /**
794      * @dev See {IERC165-supportsInterface}.
795      */
796     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
797         return
798             interfaceId == type(IERC721).interfaceId ||
799             interfaceId == type(IERC721Metadata).interfaceId ||
800             interfaceId == type(IERC721Enumerable).interfaceId ||
801             super.supportsInterface(interfaceId);
802     }
803 
804     /**
805      * @dev See {IERC721-balanceOf}.
806      */
807     function balanceOf(address owner) public view override returns (uint256) {
808         require(owner != address(0), 'ERC721A: balance query for the zero address');
809         return uint256(_addressData[owner].balance);
810     }
811 
812     function _numberMinted(address owner) internal view returns (uint256) {
813         require(owner != address(0), 'ERC721A: number minted query for the zero address');
814         return uint256(_addressData[owner].numberMinted);
815     }
816 
817     /**
818      * Gas spent here starts off proportional to the maximum mint batch size.
819      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
820      */
821     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
822         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
823 
824         for (uint256 curr = tokenId; ; curr--) {
825             TokenOwnership memory ownership = _ownerships[curr];
826             if (ownership.addr != address(0)) {
827                 return ownership;
828             }
829         }
830 
831         revert('ERC721A: unable to determine the owner of token');
832     }
833 
834     /**
835      * @dev See {IERC721-ownerOf}.
836      */
837     function ownerOf(uint256 tokenId) public view override returns (address) {
838         return ownershipOf(tokenId).addr;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-name}.
843      */
844     function name() public view virtual override returns (string memory) {
845         return _name;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-symbol}.
850      */
851     function symbol() public view virtual override returns (string memory) {
852         return _symbol;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-tokenURI}.
857      */
858     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
859         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
860 
861         string memory baseURI = _baseURI();
862         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), '.json')) : '';
863     }
864 
865     /**
866      * @dev Set the baseURI
867      */
868     function setBaseURI(string memory baseURI_) external onlyOwner() {
869         _baseURIextended = baseURI_;
870     }
871 
872     /**
873      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
874      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
875      * by default, can be overriden in child contracts.
876      */
877     function _baseURI() internal view virtual returns (string memory) {
878         return _baseURIextended;
879     }
880 
881     /**
882      * @dev See {IERC721-approve}.
883      */
884     function approve(address to, uint256 tokenId) public override {
885         address owner = V2Punks.ownerOf(tokenId);
886         require(to != owner, 'ERC721A: approval to current owner');
887 
888         require(
889             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
890             'ERC721A: approve caller is not owner nor approved for all'
891         );
892 
893         _approve(to, tokenId, owner);
894     }
895 
896     /**
897      * @dev See {IERC721-getApproved}.
898      */
899     function getApproved(uint256 tokenId) public view override returns (address) {
900         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
901 
902         return _tokenApprovals[tokenId];
903     }
904 
905     /**
906      * @dev See {IERC721-setApprovalForAll}.
907      */
908     function setApprovalForAll(address operator, bool approved) public override {
909         require(operator != _msgSender(), 'ERC721A: approve to caller');
910 
911         _operatorApprovals[_msgSender()][operator] = approved;
912         emit ApprovalForAll(_msgSender(), operator, approved);
913     }
914 
915     /**
916      * @dev See {IERC721-isApprovedForAll}.
917      */
918     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
919         return _operatorApprovals[owner][operator];
920     }
921 
922     /**
923      * @dev See {IERC721-transferFrom}.
924      */
925     function transferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public override {
930         _transfer(from, to, tokenId);
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public override {
941         safeTransferFrom(from, to, tokenId, '');
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) public override {
953         _transfer(from, to, tokenId);
954         require(
955             _checkOnERC721Received(from, to, tokenId, _data),
956             'ERC721A: transfer to non ERC721Receiver implementer'
957         );
958     }
959 
960     function setPrice(uint256 newPrice) external {
961         require(msg.sender == _owner);
962         _price = newPrice;
963     }
964 
965     /**
966      * @dev Returns whether `tokenId` exists.
967      *
968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
969      *
970      * Tokens start existing when they are minted (`_mint`),
971      */
972     function _exists(uint256 tokenId) internal view returns (bool) {
973         return tokenId < currentIndex;
974     }
975 
976     function reserveBulk(address[] memory to) external  {
977         require(msg.sender == _owner);
978         for (uint i = 0; i < to.length;i++) {
979             _safeMint(to[i], 1);
980         }
981     }
982 
983     function reserve(address to, uint256 quantity) external  {
984         require(msg.sender == _owner);
985         require(currentIndex + quantity <= 10000);
986         _safeMint(to, quantity);
987     }
988 
989     function mint(address to, uint256 quantity) external payable {
990         require(quantity <= 30 && quantity > 0);
991         require(_price * quantity == msg.value);
992         require(currentIndex + quantity <= 10000);
993         payable(_owner).transfer(msg.value);
994         _safeMint(to, quantity);
995     }
996 
997     function _safeMint(address to, uint256 quantity) internal {
998         _safeMint(to, quantity, '');
999     }
1000 
1001     /**
1002      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1007      * - `quantity` must be greater than 0.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _safeMint(
1012         address to,
1013         uint256 quantity,
1014         bytes memory _data
1015     ) internal {
1016         _mint(to, quantity, _data, true);
1017     }
1018 
1019     /**
1020      * @dev Mints `quantity` tokens and transfers them to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `quantity` must be greater than 0.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _mint(
1030         address to,
1031         uint256 quantity,
1032         bytes memory _data,
1033         bool safe
1034     ) internal {
1035         uint256 startTokenId = currentIndex;
1036         require(to != address(0), 'ERC721A: mint to the zero address');
1037         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1038         require(!_exists(startTokenId), 'ERC721A: token already minted');
1039         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         _addressData[to].balance += uint128(quantity);
1044         _addressData[to].numberMinted += uint128(quantity);
1045 
1046         _ownerships[startTokenId].addr = to;
1047         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1048 
1049         uint256 updatedIndex = startTokenId;
1050 
1051         for (uint256 i = 0; i < quantity; i++) {
1052             emit Transfer(address(0), to, updatedIndex);
1053             if (safe) {
1054                 require(
1055                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
1056                     'ERC721A: transfer to non ERC721Receiver implementer'
1057                 );
1058             }
1059             updatedIndex++;
1060         }
1061 
1062         currentIndex = updatedIndex;
1063         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1064     }
1065 
1066     /**
1067      * @dev Transfers `tokenId` from `from` to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must be owned by `from`.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _transfer(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) private {
1081         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1082 
1083         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1084             getApproved(tokenId) == _msgSender() ||
1085             isApprovedForAll(prevOwnership.addr, _msgSender()));
1086 
1087         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1088 
1089         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1090         require(to != address(0), 'ERC721A: transfer to the zero address');
1091 
1092         _beforeTokenTransfers(from, to, tokenId, 1);
1093 
1094         // Clear approvals from the previous owner
1095         _approve(address(0), tokenId, prevOwnership.addr);
1096 
1097         // Underflow of the sender's balance is impossible because we check for
1098         // ownership above and the recipient's balance can't realistically overflow.
1099         unchecked {
1100             _addressData[from].balance -= 1;
1101             _addressData[to].balance += 1;
1102         }
1103 
1104         _ownerships[tokenId].addr = to;
1105         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1106 
1107         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1108         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109         uint256 nextTokenId = tokenId + 1;
1110         if (_ownerships[nextTokenId].addr == address(0)) {
1111             if (_exists(nextTokenId)) {
1112                 _ownerships[nextTokenId].addr = prevOwnership.addr;
1113                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1114             }
1115         }
1116 
1117         emit Transfer(from, to, tokenId);
1118         _afterTokenTransfers(from, to, tokenId, 1);
1119     }
1120 
1121     /**
1122      * @dev Approve `to` to operate on `tokenId`
1123      *
1124      * Emits a {Approval} event.
1125      */
1126     function _approve(
1127         address to,
1128         uint256 tokenId,
1129         address owner
1130     ) private {
1131         _tokenApprovals[tokenId] = to;
1132         emit Approval(owner, to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1137      * The call is not executed if the target address is not a contract.
1138      *
1139      * @param from address representing the previous ownefr of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         if (to.isContract()) {
1152             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1153                 return retval == IERC721Receiver(to).onERC721Received.selector;
1154             } catch (bytes memory reason) {
1155                 if (reason.length == 0) {
1156                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1157                 } else {
1158                     assembly {
1159                         revert(add(32, reason), mload(reason))
1160                     }
1161                 }
1162             }
1163         } else {
1164             return true;
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` will be minted for `to`.
1179      */
1180     function _beforeTokenTransfers(
1181         address from,
1182         address to,
1183         uint256 startTokenId,
1184         uint256 quantity
1185     ) internal virtual {}
1186 
1187     /**
1188      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1189      * minting.
1190      *
1191      * startTokenId - the first token id to be transferred
1192      * quantity - the amount to be transferred
1193      *
1194      * Calling conditions:
1195      *
1196      * - when `from` and `to` are both non-zero.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _afterTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 }