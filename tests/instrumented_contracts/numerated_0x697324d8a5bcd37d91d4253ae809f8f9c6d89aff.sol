1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 //   _                       _ _           
5 //  | |                     | (_)          
6 //  | |__  _ __ _ __ _ __ __| |_  ___  ___ 
7 //  | '_ \| '__| '__| '__/ _` | |/ _ \/ __|
8 //  | |_) | |  | |  | | | (_| | |  __/\__ \
9 //  |_.__/|_|  |_|  |_|  \__,_|_|\___||___/
10 //                                         
11 //  FOR THE CULTURE -- NOV 2022                                      
12 
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev String operations.
37  */
38 library Strings {
39     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
43      */
44     function toString(uint256 value) internal pure returns (string memory) {
45         // Inspired by OraclizeAPI's implementation - MIT licence
46         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
47 
48         if (value == 0) {
49             return "0";
50         }
51         uint256 temp = value;
52         uint256 digits;
53         while (temp != 0) {
54             digits++;
55             temp /= 10;
56         }
57         bytes memory buffer = new bytes(digits);
58         while (value != 0) {
59             digits -= 1;
60             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
61             value /= 10;
62         }
63         return string(buffer);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
68      */
69     function toHexString(uint256 value) internal pure returns (string memory) {
70         if (value == 0) {
71             return "0x00";
72         }
73         uint256 temp = value;
74         uint256 length = 0;
75         while (temp != 0) {
76             length++;
77             temp >>= 8;
78         }
79         return toHexString(value, length);
80     }
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
84      */
85     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
86         bytes memory buffer = new bytes(2 * length + 2);
87         buffer[0] = "0";
88         buffer[1] = "x";
89         for (uint256 i = 2 * length + 1; i > 1; --i) {
90             buffer[i] = _HEX_SYMBOLS[value & 0xf];
91             value >>= 4;
92         }
93         require(value == 0, "Strings: hex length insufficient");
94         return string(buffer);
95     }
96 }
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies on extcodesize, which returns 0 for contracts in
122         // construction, since the code is only stored at the end of the
123         // constructor execution.
124 
125         uint256 size;
126         assembly {
127             size := extcodesize(account)
128         }
129         return size > 0;
130     }
131 
132     /**
133      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
134      * `recipient`, forwarding all available gas and reverting on errors.
135      *
136      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
137      * of certain opcodes, possibly making contracts go over the 2300 gas limit
138      * imposed by `transfer`, making them unable to receive funds via
139      * `transfer`. {sendValue} removes this limitation.
140      *
141      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
142      *
143      * IMPORTANT: because control is transferred to `recipient`, care must be
144      * taken to not create reentrancy vulnerabilities. Consider using
145      * {ReentrancyGuard} or the
146      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
147      */
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         (bool success, ) = recipient.call{value: amount}("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain `call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, 0, errorMessage);
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
193      * but also transferring `value` wei to `target`.
194      *
195      * Requirements:
196      *
197      * - the calling contract must have an ETH balance of at least `value`.
198      * - the called Solidity function must be `payable`.
199      *
200      * _Available since v3.1._
201      */
202     function functionCallWithValue(
203         address target,
204         bytes memory data,
205         uint256 value
206     ) internal returns (bytes memory) {
207         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
212      * with `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(address(this).balance >= value, "Address: insufficient balance for call");
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(data);
226         return verifyCallResult(success, returndata, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
236         return functionStaticCall(target, data, "Address: low-level static call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
241      * but performing a static call.
242      *
243      * _Available since v3.3._
244      */
245     function functionStaticCall(
246         address target,
247         bytes memory data,
248         string memory errorMessage
249     ) internal view returns (bytes memory) {
250         require(isContract(target), "Address: static call to non-contract");
251 
252         (bool success, bytes memory returndata) = target.staticcall(data);
253         return verifyCallResult(success, returndata, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
268      * but performing a delegate call.
269      *
270      * _Available since v3.4._
271      */
272     function functionDelegateCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         require(isContract(target), "Address: delegate call to non-contract");
278 
279         (bool success, bytes memory returndata) = target.delegatecall(data);
280         return verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
285      * revert reason using the provided one.
286      *
287      * _Available since v4.3._
288      */
289     function verifyCallResult(
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal pure returns (bytes memory) {
294         if (success) {
295             return returndata;
296         } else {
297             // Look for revert reason and bubble it up if present
298             if (returndata.length > 0) {
299                 // The easiest way to bubble the revert reason is using memory via assembly
300 
301                 assembly {
302                     let returndata_size := mload(returndata)
303                     revert(add(32, returndata), returndata_size)
304                 }
305             } else {
306                 revert(errorMessage);
307             }
308         }
309     }
310 }
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Interface of the ERC165 standard, as defined in the
315  * https://eips.ethereum.org/EIPS/eip-165[EIP].
316  *
317  * Implementers can declare support of contract interfaces, which can then be
318  * queried by others ({ERC165Checker}).
319  *
320  * For an implementation, see {ERC165}.
321  */
322 interface IERC165 {
323     /**
324      * @dev Returns true if this contract implements the interface defined by
325      * `interfaceId`. See the corresponding
326      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
327      * to learn more about how these ids are created.
328      *
329      * This function call must use less than 30 000 gas.
330      */
331     function supportsInterface(bytes4 interfaceId) external view returns (bool);
332 }
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @title ERC721 token receiver interface
337  * @dev Interface for any contract that wants to support safeTransfers
338  * from ERC721 asset contracts.
339  */
340 interface IERC721Receiver {
341     /**
342      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
343      * by `operator` from `from`, this function is called.
344      *
345      * It must return its Solidity selector to confirm the token transfer.
346      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
347      *
348      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
349      */
350     function onERC721Received(
351         address operator,
352         address from,
353         uint256 tokenId,
354         bytes calldata data
355     ) external returns (bytes4);
356 }
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Contract module which provides a basic access control mechanism, where
362  * there is an account (an owner) that can be granted exclusive access to
363  * specific functions.
364  *
365  * By default, the owner account will be the one that deploys the contract. This
366  * can later be changed with {transferOwnership}.
367  *
368  * This module is used through inheritance. It will make available the modifier
369  * `onlyOwner`, which can be applied to your functions to restrict their use to
370  * the owner.
371  */
372 abstract contract Ownable is Context {
373     address private _owner;
374 
375     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377     /**
378      * @dev Initializes the contract setting the deployer as the initial owner.
379      */
380     constructor() {
381         _setOwner(_msgSender());
382     }
383 
384     /**
385      * @dev Returns the address of the current owner.
386      */
387     function owner() public view virtual returns (address) {
388         return _owner;
389     }
390 
391     /**
392      * @dev Throws if called by any account other than the owner.
393      */
394     modifier onlyOwner() {
395         require(owner() == _msgSender(), "Ownable: caller is not the owner");
396         _;
397     }
398 
399     /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         _setOwner(address(0));
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Can only be called by the current owner.
413      */
414     function transferOwnership(address newOwner) public virtual onlyOwner {
415         require(newOwner != address(0), "Ownable: new owner is the zero address");
416         _setOwner(newOwner);
417     }
418 
419     function _setOwner(address newOwner) private {
420         address oldOwner = _owner;
421         _owner = newOwner;
422         emit OwnershipTransferred(oldOwner, newOwner);
423     }
424 }
425 pragma solidity ^0.8.0;
426 
427 
428 /**
429  * @dev Implementation of the {IERC165} interface.
430  *
431  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
432  * for the additional interface id that will be supported. For example:
433  *
434  * ```solidity
435  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
436  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
437  * }
438  * ```
439  *
440  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
441  */
442 abstract contract ERC165 is IERC165 {
443     /**
444      * @dev See {IERC165-supportsInterface}.
445      */
446     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447         return interfaceId == type(IERC165).interfaceId;
448     }
449 }
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @dev Required interface of an ERC721 compliant contract.
455  */
456 interface IERC721 is IERC165 {
457     /**
458      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
459      */
460     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
464      */
465     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
466 
467     /**
468      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
469      */
470     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
471 
472     /**
473      * @dev Returns the number of tokens in ``owner``'s account.
474      */
475     function balanceOf(address owner) external view returns (uint256 balance);
476 
477     /**
478      * @dev Returns the owner of the `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function ownerOf(uint256 tokenId) external view returns (address owner);
485 
486     /**
487      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
488      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
497      *
498      * Emits a {Transfer} event.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Transfers `tokenId` token from `from` to `to`.
508      *
509      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      *
518      * Emits a {Transfer} event.
519      */
520     function transferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external;
525 
526     /**
527      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
528      * The approval is cleared when the token is transferred.
529      *
530      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
531      *
532      * Requirements:
533      *
534      * - The caller must own the token or be an approved operator.
535      * - `tokenId` must exist.
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address to, uint256 tokenId) external;
540 
541     /**
542      * @dev Returns the account approved for `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function getApproved(uint256 tokenId) external view returns (address operator);
549 
550     /**
551      * @dev Approve or remove `operator` as an operator for the caller.
552      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
553      *
554      * Requirements:
555      *
556      * - The `operator` cannot be the caller.
557      *
558      * Emits an {ApprovalForAll} event.
559      */
560     function setApprovalForAll(address operator, bool _approved) external;
561 
562     /**
563      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
564      *
565      * See {setApprovalForAll}
566      */
567     function isApprovedForAll(address owner, address operator) external view returns (bool);
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must exist and be owned by `from`.
577      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId,
586         bytes calldata data
587     ) external;
588 }
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
594  * @dev See https://eips.ethereum.org/EIPS/eip-721
595  */
596 interface IERC721Metadata is IERC721 {
597     /**
598      * @dev Returns the token collection name.
599      */
600     function name() external view returns (string memory);
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() external view returns (string memory);
606 
607     /**
608      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory);
611 }
612 interface IERC721Enumerable is IERC721 {
613     /**
614      * @dev Returns the total amount of tokens stored by the contract.
615      */
616     function totalSupply() external view returns (uint256);
617 
618     /**
619      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
620      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
621      */
622     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
623 
624     /**
625      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
626      * Use along with {totalSupply} to enumerate all tokens.
627      */
628     function tokenByIndex(uint256 index) external view returns (uint256);
629 }
630 error ApprovalCallerNotOwnerNorApproved();
631 error ApprovalQueryForNonexistentToken();
632 error ApproveToCaller();
633 error ApprovalToCurrentOwner();
634 error BalanceQueryForZeroAddress();
635 error MintedQueryForZeroAddress();
636 error BurnedQueryForZeroAddress();
637 error AuxQueryForZeroAddress();
638 error MintToZeroAddress();
639 error MintZeroQuantity();
640 error OwnerIndexOutOfBounds();
641 error OwnerQueryForNonexistentToken();
642 error TokenIndexOutOfBounds();
643 error TransferCallerNotOwnerNorApproved();
644 error TransferFromIncorrectOwner();
645 error TransferToNonERC721ReceiverImplementer();
646 error TransferToZeroAddress();
647 error URIQueryForNonexistentToken();
648 
649 /**
650  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
651  * the Metadata extension. Built to optimize for lower gas during batch mints.
652  *
653  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
654  *
655  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
656  *
657  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
658  */
659 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
660     using Address for address;
661     using Strings for uint256;
662 
663     // Compiler will pack this into a single 256bit word.
664     struct TokenOwnership {
665         // The address of the owner.
666         address addr;
667         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
668         uint64 startTimestamp;
669         // Whether the token has been burned.
670         bool burned;
671     }
672 
673     // Compiler will pack this into a single 256bit word.
674     struct AddressData {
675         // Realistically, 2**64-1 is more than enough.
676         uint64 balance;
677         // Keeps track of mint count with minimal overhead for tokenomics.
678         uint64 numberMinted;
679         // Keeps track of burn count with minimal overhead for tokenomics.
680         uint64 numberBurned;
681         // For miscellaneous variable(s) pertaining to the address
682         // (e.g. number of whitelist mint slots used). 
683         // If there are multiple variables, please pack them into a uint64.
684         uint64 aux;
685     }
686 
687     // The tokenId of the next token to be minted.
688     uint256 internal _currentIndex = 1;
689 
690     // The number of tokens burned.
691     uint256 internal _burnCounter;
692 
693     // Token name
694     string private _name;
695 
696     // Token symbol
697     string private _symbol;
698 
699     // Mapping from token ID to ownership details
700     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
701     mapping(uint256 => TokenOwnership) internal _ownerships;
702 
703     // Mapping owner address to address data
704     mapping(address => AddressData) private _addressData;
705 
706     // Mapping from token ID to approved address
707     mapping(uint256 => address) private _tokenApprovals;
708 
709     // Mapping from owner to operator approvals
710     mapping(address => mapping(address => bool)) private _operatorApprovals;
711 
712     constructor(string memory name_, string memory symbol_) {
713         _name = name_;
714         _symbol = symbol_;
715     }
716 
717     /**
718      * @dev See {IERC721Enumerable-totalSupply}.
719      */
720     function totalSupply() public view returns (uint256) {
721         // Counter underflow is impossible as _burnCounter cannot be incremented
722         // more than _currentIndex times
723         unchecked {
724             return (_currentIndex - _burnCounter) - 1;    
725         }
726     }
727 
728     /**
729      * @dev See {IERC165-supportsInterface}.
730      */
731     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
732         return
733             interfaceId == type(IERC721).interfaceId ||
734             interfaceId == type(IERC721Metadata).interfaceId ||
735             super.supportsInterface(interfaceId);
736     }
737 
738     /**
739      * @dev See {IERC721-balanceOf}.
740      */
741     function balanceOf(address owner) public view override returns (uint256) {
742         if (owner == address(0)) revert BalanceQueryForZeroAddress();
743         return uint256(_addressData[owner].balance);
744     }
745 
746     /**
747      * Returns the number of tokens minted by `owner`.
748      */
749     function _numberMinted(address owner) internal view returns (uint256) {
750         if (owner == address(0)) revert MintedQueryForZeroAddress();
751         return uint256(_addressData[owner].numberMinted);
752     }
753 
754     /**
755      * Returns the number of tokens burned by or on behalf of `owner`.
756      */
757     function _numberBurned(address owner) internal view returns (uint256) {
758         if (owner == address(0)) revert BurnedQueryForZeroAddress();
759         return uint256(_addressData[owner].numberBurned);
760     }
761 
762     /**
763      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
764      */
765     function _getAux(address owner) internal view returns (uint64) {
766         if (owner == address(0)) revert AuxQueryForZeroAddress();
767         return _addressData[owner].aux;
768     }
769 
770     /**
771      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
772      * If there are multiple variables, please pack them into a uint64.
773      */
774     function _setAux(address owner, uint64 aux) internal {
775         if (owner == address(0)) revert AuxQueryForZeroAddress();
776         _addressData[owner].aux = aux;
777     }
778 
779     /**
780      * Gas spent here starts off proportional to the maximum mint batch size.
781      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
782      */
783     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
784         uint256 curr = tokenId;
785 
786         unchecked {
787             if (curr < _currentIndex) {
788                 TokenOwnership memory ownership = _ownerships[curr];
789                 if (!ownership.burned) {
790                     if (ownership.addr != address(0)) {
791                         return ownership;
792                     }
793                     // Invariant: 
794                     // There will always be an ownership that has an address and is not burned 
795                     // before an ownership that does not have an address and is not burned.
796                     // Hence, curr will not underflow.
797                     while (true) {
798                         curr--;
799                         ownership = _ownerships[curr];
800                         if (ownership.addr != address(0)) {
801                             return ownership;
802                         }
803                     }
804                 }
805             }
806         }
807         revert OwnerQueryForNonexistentToken();
808     }
809 
810     /**
811      * @dev See {IERC721-ownerOf}.
812      */
813     function ownerOf(uint256 tokenId) public view override returns (address) {
814         return ownershipOf(tokenId).addr;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-name}.
819      */
820     function name() public view virtual override returns (string memory) {
821         return _name;
822     }
823 
824     /**
825      * @dev See {IERC721Metadata-symbol}.
826      */
827     function symbol() public view virtual override returns (string memory) {
828         return _symbol;
829     }
830 
831     /**
832      * @dev See {IERC721Metadata-tokenURI}.
833      */
834     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
835         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
836 
837         string memory baseURI = _baseURI();
838         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
839     }
840 
841     /**
842      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
843      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
844      * by default, can be overriden in child contracts.
845      */
846     function _baseURI() internal view virtual returns (string memory) {
847         return '';
848     }
849 
850     /**
851      * @dev See {IERC721-approve}.
852      */
853     function approve(address to, uint256 tokenId) public override {
854         address owner = ERC721A.ownerOf(tokenId);
855         if (to == owner) revert ApprovalToCurrentOwner();
856 
857         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
858             revert ApprovalCallerNotOwnerNorApproved();
859         }
860 
861         _approve(to, tokenId, owner);
862     }
863 
864     /**
865      * @dev See {IERC721-getApproved}.
866      */
867     function getApproved(uint256 tokenId) public view override returns (address) {
868         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
869 
870         return _tokenApprovals[tokenId];
871     }
872 
873     /**
874      * @dev See {IERC721-setApprovalForAll}.
875      */
876     function setApprovalForAll(address operator, bool approved) public override {
877         if (operator == _msgSender()) revert ApproveToCaller();
878 
879         _operatorApprovals[_msgSender()][operator] = approved;
880         emit ApprovalForAll(_msgSender(), operator, approved);
881     }
882 
883     /**
884      * @dev See {IERC721-isApprovedForAll}.
885      */
886     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
887         return _operatorApprovals[owner][operator];
888     }
889 
890     /**
891      * @dev See {IERC721-transferFrom}.
892      */
893     function transferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public virtual override {
898         _transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev See {IERC721-safeTransferFrom}.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public virtual override {
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912     /**
913      * @dev See {IERC721-safeTransferFrom}.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public virtual override {
921         _transfer(from, to, tokenId);
922         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
923             revert TransferToNonERC721ReceiverImplementer();
924         }
925     }
926 
927     /**
928      * @dev Returns whether `tokenId` exists.
929      *
930      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
931      *
932      * Tokens start existing when they are minted (`_mint`),
933      */
934     function _exists(uint256 tokenId) internal view returns (bool) {
935         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
936     }
937 
938     function _safeMint(address to, uint256 quantity) internal {
939         _safeMint(to, quantity, '');
940     }
941 
942     /**
943      * @dev Safely mints `quantity` tokens and transfers them to `to`.
944      *
945      * Requirements:
946      *
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
948      * - `quantity` must be greater than 0.
949      *
950      * Emits a {Transfer} event.
951      */
952     function _safeMint(
953         address to,
954         uint256 quantity,
955         bytes memory _data
956     ) internal {
957         _mint(to, quantity, _data, true);
958     }
959 
960     /**
961      * @dev Mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - `to` cannot be the zero address.
966      * - `quantity` must be greater than 0.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _mint(
971         address to,
972         uint256 quantity,
973         bytes memory _data,
974         bool safe
975     ) internal {
976         uint256 startTokenId = _currentIndex;
977         if (to == address(0)) revert MintToZeroAddress();
978         if (quantity == 0) revert MintZeroQuantity();
979 
980         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
981 
982         // Overflows are incredibly unrealistic.
983         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
984         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
985         unchecked {
986             _addressData[to].balance += uint64(quantity);
987             _addressData[to].numberMinted += uint64(quantity);
988 
989             _ownerships[startTokenId].addr = to;
990             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
991 
992             uint256 updatedIndex = startTokenId;
993 
994             for (uint256 i; i < quantity; i++) {
995                 emit Transfer(address(0), to, updatedIndex);
996                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
997                     revert TransferToNonERC721ReceiverImplementer();
998                 }
999                 updatedIndex++;
1000             }
1001 
1002             _currentIndex = updatedIndex;
1003         }
1004         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1005     }
1006 
1007     /**
1008      * @dev Transfers `tokenId` from `from` to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) private {
1022         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1023 
1024         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1025             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1026             getApproved(tokenId) == _msgSender());
1027 
1028         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1029         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1030         if (to == address(0)) revert TransferToZeroAddress();
1031 
1032         _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId, prevOwnership.addr);
1036 
1037         // Underflow of the sender's balance is impossible because we check for
1038         // ownership above and the recipient's balance can't realistically overflow.
1039         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1040         unchecked {
1041             _addressData[from].balance -= 1;
1042             _addressData[to].balance += 1;
1043 
1044             _ownerships[tokenId].addr = to;
1045             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1046 
1047             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1048             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1049             uint256 nextTokenId = tokenId + 1;
1050             if (_ownerships[nextTokenId].addr == address(0)) {
1051                 // This will suffice for checking _exists(nextTokenId),
1052                 // as a burned slot cannot contain the zero address.
1053                 if (nextTokenId < _currentIndex) {
1054                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1055                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1056                 }
1057             }
1058         }
1059 
1060         emit Transfer(from, to, tokenId);
1061         _afterTokenTransfers(from, to, tokenId, 1);
1062     }
1063 
1064     /**
1065      * @dev Destroys `tokenId`.
1066      * The approval is cleared when the token is burned.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _burn(uint256 tokenId) internal virtual {
1075         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1076 
1077         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1078 
1079         // Clear approvals from the previous owner
1080         _approve(address(0), tokenId, prevOwnership.addr);
1081 
1082         // Underflow of the sender's balance is impossible because we check for
1083         // ownership above and the recipient's balance can't realistically overflow.
1084         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1085         unchecked {
1086             _addressData[prevOwnership.addr].balance -= 1;
1087             _addressData[prevOwnership.addr].numberBurned += 1;
1088 
1089             // Keep track of who burned the token, and the timestamp of burning.
1090             _ownerships[tokenId].addr = prevOwnership.addr;
1091             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1092             _ownerships[tokenId].burned = true;
1093 
1094             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1095             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1096             uint256 nextTokenId = tokenId + 1;
1097             if (_ownerships[nextTokenId].addr == address(0)) {
1098                 // This will suffice for checking _exists(nextTokenId),
1099                 // as a burned slot cannot contain the zero address.
1100                 if (nextTokenId < _currentIndex) {
1101                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1102                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1103                 }
1104             }
1105         }
1106 
1107         emit Transfer(prevOwnership.addr, address(0), tokenId);
1108         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1109 
1110         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1111         unchecked { 
1112             _burnCounter++;
1113         }
1114     }
1115 
1116     /**
1117      * @dev Approve `to` to operate on `tokenId`
1118      *
1119      * Emits a {Approval} event.
1120      */
1121     function _approve(
1122         address to,
1123         uint256 tokenId,
1124         address owner
1125     ) private {
1126         _tokenApprovals[tokenId] = to;
1127         emit Approval(owner, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1132      * The call is not executed if the target address is not a contract.
1133      *
1134      * @param from address representing the previous owner of the given token ID
1135      * @param to target address that will receive the tokens
1136      * @param tokenId uint256 ID of the token to be transferred
1137      * @param _data bytes optional data to send along with the call
1138      * @return bool whether the call correctly returned the expected magic value
1139      */
1140     function _checkOnERC721Received(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes memory _data
1145     ) private returns (bool) {
1146         if (to.isContract()) {
1147             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1148                 return retval == IERC721Receiver(to).onERC721Received.selector;
1149             } catch (bytes memory reason) {
1150                 if (reason.length == 0) {
1151                     revert TransferToNonERC721ReceiverImplementer();
1152                 } else {
1153                     assembly {
1154                         revert(add(32, reason), mload(reason))
1155                     }
1156                 }
1157             }
1158         } else {
1159             return true;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1165      * And also called before burning one token.
1166      *
1167      * startTokenId - the first token id to be transferred
1168      * quantity - the amount to be transferred
1169      *
1170      * Calling conditions:
1171      *
1172      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1173      * transferred to `to`.
1174      * - When `from` is zero, `tokenId` will be minted for `to`.
1175      * - When `to` is zero, `tokenId` will be burned by `from`.
1176      * - `from` and `to` are never both zero.
1177      */
1178     function _beforeTokenTransfers(
1179         address from,
1180         address to,
1181         uint256 startTokenId,
1182         uint256 quantity
1183     ) internal virtual {}
1184 
1185     /**
1186      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1187      * minting.
1188      * And also called after one token has been burned.
1189      *
1190      * startTokenId - the first token id to be transferred
1191      * quantity - the amount to be transferred
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` has been minted for `to`.
1198      * - When `to` is zero, `tokenId` has been burned by `from`.
1199      * - `from` and `to` are never both zero.
1200      */
1201     function _afterTokenTransfers(
1202         address from,
1203         address to,
1204         uint256 startTokenId,
1205         uint256 quantity
1206     ) internal virtual {}
1207 }
1208 
1209 library ECDSA {
1210     enum RecoverError {
1211         NoError,
1212         InvalidSignature,
1213         InvalidSignatureLength,
1214         InvalidSignatureS,
1215         InvalidSignatureV
1216     }
1217 
1218     function _throwError(RecoverError error) private pure {
1219         if (error == RecoverError.NoError) {
1220             return; // no error: do nothing
1221         } else if (error == RecoverError.InvalidSignature) {
1222             revert("ECDSA: invalid signature");
1223         } else if (error == RecoverError.InvalidSignatureLength) {
1224             revert("ECDSA: invalid signature length");
1225         } else if (error == RecoverError.InvalidSignatureS) {
1226             revert("ECDSA: invalid signature 's' value");
1227         } else if (error == RecoverError.InvalidSignatureV) {
1228             revert("ECDSA: invalid signature 'v' value");
1229         }
1230     }
1231 
1232     /**
1233      * @dev Returns the address that signed a hashed message (`hash`) with
1234      * `signature` or error string. This address can then be used for verification purposes.
1235      *
1236      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1237      * this function rejects them by requiring the `s` value to be in the lower
1238      * half order, and the `v` value to be either 27 or 28.
1239      *
1240      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1241      * verification to be secure: it is possible to craft signatures that
1242      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1243      * this is by receiving a hash of the original message (which may otherwise
1244      * be too long), and then calling {toEthSignedMessageHash} on it.
1245      *
1246      * Documentation for signature generation:
1247      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1248      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1249      *
1250      * _Available since v4.3._
1251      */
1252     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1253         // Check the signature length
1254         // - case 65: r,s,v signature (standard)
1255         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1256         if (signature.length == 65) {
1257             bytes32 r;
1258             bytes32 s;
1259             uint8 v;
1260             // ecrecover takes the signature parameters, and the only way to get them
1261             // currently is to use assembly.
1262             assembly {
1263                 r := mload(add(signature, 0x20))
1264                 s := mload(add(signature, 0x40))
1265                 v := byte(0, mload(add(signature, 0x60)))
1266             }
1267             return tryRecover(hash, v, r, s);
1268         } else if (signature.length == 64) {
1269             bytes32 r;
1270             bytes32 vs;
1271             // ecrecover takes the signature parameters, and the only way to get them
1272             // currently is to use assembly.
1273             assembly {
1274                 r := mload(add(signature, 0x20))
1275                 vs := mload(add(signature, 0x40))
1276             }
1277             return tryRecover(hash, r, vs);
1278         } else {
1279             return (address(0), RecoverError.InvalidSignatureLength);
1280         }
1281     }
1282 
1283     /**
1284      * @dev Returns the address that signed a hashed message (`hash`) with
1285      * `signature`. This address can then be used for verification purposes.
1286      *
1287      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1288      * this function rejects them by requiring the `s` value to be in the lower
1289      * half order, and the `v` value to be either 27 or 28.
1290      *
1291      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1292      * verification to be secure: it is possible to craft signatures that
1293      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1294      * this is by receiving a hash of the original message (which may otherwise
1295      * be too long), and then calling {toEthSignedMessageHash} on it.
1296      */
1297     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1298         (address recovered, RecoverError error) = tryRecover(hash, signature);
1299         _throwError(error);
1300         return recovered;
1301     }
1302 
1303     /**
1304      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1305      *
1306      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1307      *
1308      * _Available since v4.3._
1309      */
1310     function tryRecover(
1311         bytes32 hash,
1312         bytes32 r,
1313         bytes32 vs
1314     ) internal pure returns (address, RecoverError) {
1315         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1316         uint8 v = uint8((uint256(vs) >> 255) + 27);
1317         return tryRecover(hash, v, r, s);
1318     }
1319 
1320     /**
1321      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1322      *
1323      * _Available since v4.2._
1324      */
1325     function recover(
1326         bytes32 hash,
1327         bytes32 r,
1328         bytes32 vs
1329     ) internal pure returns (address) {
1330         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1331         _throwError(error);
1332         return recovered;
1333     }
1334 
1335     /**
1336      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1337      * `r` and `s` signature fields separately.
1338      *
1339      * _Available since v4.3._
1340      */
1341     function tryRecover(
1342         bytes32 hash,
1343         uint8 v,
1344         bytes32 r,
1345         bytes32 s
1346     ) internal pure returns (address, RecoverError) {
1347         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1348         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1349         // the valid range for s in (301): 0 < s < secp256k1n � 2 + 1, and for v in (302): v ? {27, 28}. Most
1350         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1351         //
1352         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1353         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1354         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1355         // these malleable signatures as well.
1356         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1357             return (address(0), RecoverError.InvalidSignatureS);
1358         }
1359         if (v != 27 && v != 28) {
1360             return (address(0), RecoverError.InvalidSignatureV);
1361         }
1362 
1363         // If the signature is valid (and not malleable), return the signer address
1364         address signer = ecrecover(hash, v, r, s);
1365         if (signer == address(0)) {
1366             return (address(0), RecoverError.InvalidSignature);
1367         }
1368 
1369         return (signer, RecoverError.NoError);
1370     }
1371 
1372     /**
1373      * @dev Overload of {ECDSA-recover} that receives the `v`,
1374      * `r` and `s` signature fields separately.
1375      */
1376     function recover(
1377         bytes32 hash,
1378         uint8 v,
1379         bytes32 r,
1380         bytes32 s
1381     ) internal pure returns (address) {
1382         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1383         _throwError(error);
1384         return recovered;
1385     }
1386 
1387     /**
1388      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1389      * produces hash corresponding to the one signed with the
1390      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1391      * JSON-RPC method as part of EIP-191.
1392      *
1393      * See {recover}.
1394      */
1395     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1396         // 32 is the length in bytes of hash,
1397         // enforced by the type signature above
1398         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1399     }
1400 
1401     /**
1402      * @dev Returns an Ethereum Signed Message, created from `s`. This
1403      * produces hash corresponding to the one signed with the
1404      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1405      * JSON-RPC method as part of EIP-191.
1406      *
1407      * See {recover}.
1408      */
1409     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1410         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1411     }
1412 
1413     /**
1414      * @dev Returns an Ethereum Signed Typed Data, created from a
1415      * `domainSeparator` and a `structHash`. This produces hash corresponding
1416      * to the one signed with the
1417      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1418      * JSON-RPC method as part of EIP-712.
1419      *
1420      * See {recover}.
1421      */
1422     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1423         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1424     }
1425 }
1426 abstract contract EIP712 {
1427     /* solhint-disable var-name-mixedcase */
1428     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1429     // invalidate the cached domain separator if the chain id changes.
1430     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1431     uint256 private immutable _CACHED_CHAIN_ID;
1432     address private immutable _CACHED_THIS;
1433 
1434     bytes32 private immutable _HASHED_NAME;
1435     bytes32 private immutable _HASHED_VERSION;
1436     bytes32 private immutable _TYPE_HASH;
1437 
1438     /* solhint-enable var-name-mixedcase */
1439 
1440     /**
1441      * @dev Initializes the domain separator and parameter caches.
1442      *
1443      * The meaning of `name` and `version` is specified in
1444      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1445      *
1446      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1447      * - `version`: the current major version of the signing domain.
1448      *
1449      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1450      * contract upgrade].
1451      */
1452     constructor(string memory name, string memory version) {
1453         bytes32 hashedName = keccak256(bytes(name));
1454         bytes32 hashedVersion = keccak256(bytes(version));
1455         bytes32 typeHash = keccak256(
1456             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1457         );
1458         _HASHED_NAME = hashedName;
1459         _HASHED_VERSION = hashedVersion;
1460         _CACHED_CHAIN_ID = block.chainid;
1461         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1462         _CACHED_THIS = address(this);
1463         _TYPE_HASH = typeHash;
1464     }
1465 
1466     /**
1467      * @dev Returns the domain separator for the current chain.
1468      */
1469     function _domainSeparatorV4() internal view returns (bytes32) {
1470         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1471             return _CACHED_DOMAIN_SEPARATOR;
1472         } else {
1473             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1474         }
1475     }
1476 
1477     function _buildDomainSeparator(
1478         bytes32 typeHash,
1479         bytes32 nameHash,
1480         bytes32 versionHash
1481     ) private view returns (bytes32) {
1482         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1483     }
1484 
1485     /**
1486      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1487      * function returns the hash of the fully encoded EIP712 message for this domain.
1488      *
1489      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1490      *
1491      * ```solidity
1492      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1493      *     keccak256("Mail(address to,string contents)"),
1494      *     mailTo,
1495      *     keccak256(bytes(mailContents))
1496      * )));
1497      * address signer = ECDSA.recover(digest, signature);
1498      * ```
1499      */
1500     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1501         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1502     }
1503 }
1504 
1505 contract Brrrdies is Ownable, ERC721A {
1506 
1507     uint256 public walletMax = 5;
1508     using Strings for uint256;
1509 
1510     mapping(uint256 => string) private _tokenURIs;
1511     bool public publicSaleOpen = false;
1512     string public baseURI = "ipfs://bafybeigzwwmzujz4ektttyaqrzs2rb3pxjhcyarlqbpsxwb7pksv2w6rdi/";
1513     string public _extension = ".json";
1514     uint256 public price = 0 ether;
1515     uint256 public maxSupply = 5858;
1516 
1517     constructor() ERC721A("Brrrdies", "BRRRD"){}
1518     
1519     function mintNFT(uint256 _quantity) public payable {
1520         require(_quantity > 0 && _quantity <= walletMax, "Wallet full, check max per wallet!");
1521         require(totalSupply() + _quantity <= maxSupply, "Reached max supply!");
1522         require(msg.value == price * _quantity, "Needs to send more ETH!");
1523         require(getMintedCount(msg.sender) + _quantity <= walletMax, "Exceeded max minting amount!");
1524         require(publicSaleOpen, "Public sale not yet started!");
1525 
1526         _safeMint(msg.sender, _quantity);
1527 
1528     }
1529 
1530 
1531     function sendGifts(address[] memory _wallets) external onlyOwner{
1532         require(totalSupply() + _wallets.length <= maxSupply, "Max Supply Reached.");
1533         for(uint i = 0; i < _wallets.length; i++)
1534             _safeMint(_wallets[i], 1);
1535 
1536     }
1537    function sendGiftsToWallet(address _wallet, uint256 _num) external onlyOwner{
1538                require(totalSupply() + _num <= maxSupply, "Max Supply Reached.");
1539             _safeMint(_wallet, _num);
1540     }
1541 
1542 
1543     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1544         require(
1545             _exists(_tokenId),
1546             "ERC721Metadata: URI set of nonexistent token"
1547         );
1548 
1549         return string(abi.encodePacked(baseURI, _tokenId.toString(), _extension));
1550     }
1551 
1552     function updateBaseURI(string memory _newBaseURI) onlyOwner public {
1553         baseURI = _newBaseURI;
1554     }
1555     function updateExtension(string memory _temp) onlyOwner public {
1556         _extension = _temp;
1557     }
1558 
1559     function getBaseURI() external view returns(string memory) {
1560         return baseURI;
1561     }
1562 
1563     function setPrice(uint256 _price) public onlyOwner() {
1564         price = _price;
1565     }
1566     function setWalletMaxs(uint256 _walletMax) public onlyOwner() {
1567         walletMax = _walletMax;
1568     }
1569 
1570     function setmaxSupply(uint256 _supply) public onlyOwner() {
1571         require(_supply <= 5858, "Error: New max supply cant be higher than original max.");
1572         maxSupply = _supply;
1573     }
1574 
1575     function toggleSale() public onlyOwner() {
1576         publicSaleOpen = !publicSaleOpen;
1577     }
1578 
1579 
1580     function getBalance() public view returns(uint) {
1581         return address(this).balance;
1582     }
1583 
1584     function getMintedCount(address owner) public view returns (uint256) {
1585     return _numberMinted(owner);
1586   }
1587 
1588     function withdraw() external onlyOwner {
1589         uint _balance = address(this).balance;
1590         payable(owner()).transfer(_balance); //Owner
1591     }
1592 
1593     function getOwnershipData(uint256 tokenId)
1594     external
1595     view
1596     returns (TokenOwnership memory)
1597   {
1598     return ownershipOf(tokenId);
1599   }
1600     receive() external payable {}
1601 }