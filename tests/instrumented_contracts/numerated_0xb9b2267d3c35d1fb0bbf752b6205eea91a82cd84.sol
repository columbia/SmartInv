1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(
82         address from,
83         address to,
84         uint256 tokenId,
85         bytes calldata data
86     ) external;
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Approve or remove `operator` as an operator for the caller.
145      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
146      *
147      * Requirements:
148      *
149      * - The `operator` cannot be the caller.
150      *
151      * Emits an {ApprovalForAll} event.
152      */
153     function setApprovalForAll(address operator, bool _approved) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 }
171 
172 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
173 
174 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Implementation of the {IERC165} interface.
180  *
181  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
182  * for the additional interface id that will be supported. For example:
183  *
184  * ```solidity
185  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
186  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
187  * }
188  * ```
189  *
190  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
191  */
192 abstract contract ERC165 is IERC165 {
193     /**
194      * @dev See {IERC165-supportsInterface}.
195      */
196     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
197         return interfaceId == type(IERC165).interfaceId;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
202 
203 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @title ERC721 token receiver interface
209  * @dev Interface for any contract that wants to support safeTransfers
210  * from ERC721 asset contracts.
211  */
212 interface IERC721Receiver {
213     /**
214      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
215      * by `operator` from `from`, this function is called.
216      *
217      * It must return its Solidity selector to confirm the token transfer.
218      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
219      *
220      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
221      */
222     function onERC721Received(
223         address operator,
224         address from,
225         uint256 tokenId,
226         bytes calldata data
227     ) external returns (bytes4);
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
231 
232 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
238  * @dev See https://eips.ethereum.org/EIPS/eip-721
239  */
240 interface IERC721Enumerable is IERC721 {
241     /**
242      * @dev Returns the total amount of tokens stored by the contract.
243      */
244     function totalSupply() external view returns (uint256);
245 
246     /**
247      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
248      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
249      */
250     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
251 
252     /**
253      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
254      * Use along with {totalSupply} to enumerate all tokens.
255      */
256     function tokenByIndex(uint256 index) external view returns (uint256);
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
260 
261 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
267  * @dev See https://eips.ethereum.org/EIPS/eip-721
268  */
269 interface IERC721Metadata is IERC721 {
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 }
285 
286 // File: @openzeppelin/contracts/utils/Address.sol
287 
288 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
289 
290 pragma solidity ^0.8.1;
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      *
313      * [IMPORTANT]
314      * ====
315      * You shouldn't rely on `isContract` to protect against flash loan attacks!
316      *
317      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
318      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
319      * constructor.
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // This method relies on extcodesize/address.code.length, which returns 0
324         // for contracts in construction, since the code is only stored at the end
325         // of the constructor execution.
326 
327         return account.code.length > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         (bool success, ) = recipient.call{value: amount}("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 
353     /**
354      * @dev Performs a Solidity function call using a low level `call`. A
355      * plain `call` is an unsafe replacement for a function call: use this
356      * function instead.
357      *
358      * If `target` reverts with a revert reason, it is bubbled up by this
359      * function (like regular Solidity function calls).
360      *
361      * Returns the raw returned data. To convert to the expected return value,
362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
363      *
364      * Requirements:
365      *
366      * - `target` must be a contract.
367      * - calling `target` with `data` must not revert.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
372         return functionCall(target, data, "Address: low-level call failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
377      * `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(
382         address target,
383         bytes memory data,
384         string memory errorMessage
385     ) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(
401         address target,
402         bytes memory data,
403         uint256 value
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         require(address(this).balance >= value, "Address: insufficient balance for call");
421         require(isContract(target), "Address: call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.call{value: value}(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
434         return functionStaticCall(target, data, "Address: low-level static call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(
444         address target,
445         bytes memory data,
446         string memory errorMessage
447     ) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.staticcall(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.4._
459      */
460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal returns (bytes memory) {
475         require(isContract(target), "Address: delegate call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.delegatecall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
483      * revert reason using the provided one.
484      *
485      * _Available since v4.3._
486      */
487     function verifyCallResult(
488         bool success,
489         bytes memory returndata,
490         string memory errorMessage
491     ) internal pure returns (bytes memory) {
492         if (success) {
493             return returndata;
494         } else {
495             // Look for revert reason and bubble it up if present
496             if (returndata.length > 0) {
497                 // The easiest way to bubble the revert reason is using memory via assembly
498                 /// @solidity memory-safe-assembly
499                 assembly {
500                     let returndata_size := mload(returndata)
501                     revert(add(32, returndata), returndata_size)
502                 }
503             } else {
504                 revert(errorMessage);
505             }
506         }
507     }
508 }
509 
510 // File: @openzeppelin/contracts/utils/Context.sol
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Provides information about the current execution context, including the
518  * sender of the transaction and its data. While these are generally available
519  * via msg.sender and msg.data, they should not be accessed in such a direct
520  * manner, since when dealing with meta-transactions the account sending and
521  * paying for execution may not be the actual sender (as far as an application
522  * is concerned).
523  *
524  * This contract is only required for intermediate, library-like contracts.
525  */
526 abstract contract Context {
527     function _msgSender() internal view virtual returns (address) {
528         return msg.sender;
529     }
530 
531     function _msgData() internal view virtual returns (bytes calldata) {
532         return msg.data;
533     }
534 }
535 
536 // File: @openzeppelin/contracts/utils/Strings.sol
537 
538 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev String operations.
544  */
545 library Strings {
546     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
547     uint8 private constant _ADDRESS_LENGTH = 20;
548 
549     /**
550      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
551      */
552     function toString(uint256 value) internal pure returns (string memory) {
553         // Inspired by OraclizeAPI's implementation - MIT licence
554         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
555 
556         if (value == 0) {
557             return "0";
558         }
559         uint256 temp = value;
560         uint256 digits;
561         while (temp != 0) {
562             digits++;
563             temp /= 10;
564         }
565         bytes memory buffer = new bytes(digits);
566         while (value != 0) {
567             digits -= 1;
568             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
569             value /= 10;
570         }
571         return string(buffer);
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
576      */
577     function toHexString(uint256 value) internal pure returns (string memory) {
578         if (value == 0) {
579             return "0x00";
580         }
581         uint256 temp = value;
582         uint256 length = 0;
583         while (temp != 0) {
584             length++;
585             temp >>= 8;
586         }
587         return toHexString(value, length);
588     }
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
592      */
593     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
594         bytes memory buffer = new bytes(2 * length + 2);
595         buffer[0] = "0";
596         buffer[1] = "x";
597         for (uint256 i = 2 * length + 1; i > 1; --i) {
598             buffer[i] = _HEX_SYMBOLS[value & 0xf];
599             value >>= 4;
600         }
601         require(value == 0, "Strings: hex length insufficient");
602         return string(buffer);
603     }
604 
605     /**
606      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
607      */
608     function toHexString(address addr) internal pure returns (string memory) {
609         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
610     }
611 }
612 
613 // File: @openzeppelin/contracts/access/Ownable.sol
614 
615 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 /**
620  * @dev Contract module which provides a basic access control mechanism, where
621  * there is an account (an owner) that can be granted exclusive access to
622  * specific functions.
623  *
624  * By default, the owner account will be the one that deploys the contract. This
625  * can later be changed with {transferOwnership}.
626  *
627  * This module is used through inheritance. It will make available the modifier
628  * `onlyOwner`, which can be applied to your functions to restrict their use to
629  * the owner.
630  */
631 abstract contract Ownable is Context {
632     address private _owner;
633 
634     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
635 
636     /**
637      * @dev Initializes the contract setting the deployer as the initial owner.
638      */
639     constructor() {
640         _transferOwnership(_msgSender());
641     }
642 
643     /**
644      * @dev Throws if called by any account other than the owner.
645      */
646     modifier onlyOwner() {
647         _checkOwner();
648         _;
649     }
650 
651     /**
652      * @dev Returns the address of the current owner.
653      */
654     function owner() public view virtual returns (address) {
655         return _owner;
656     }
657 
658     /**
659      * @dev Throws if the sender is not the owner.
660      */
661     function _checkOwner() internal view virtual {
662         require(owner() == _msgSender(), "Ownable: caller is not the owner");
663     }
664 
665     /**
666      * @dev Leaves the contract without owner. It will not be possible to call
667      * `onlyOwner` functions anymore. Can only be called by the current owner.
668      *
669      * NOTE: Renouncing ownership will leave the contract without an owner,
670      * thereby removing any functionality that is only available to the owner.
671      */
672     function renounceOwnership() public virtual onlyOwner {
673         _transferOwnership(address(0));
674     }
675 
676     /**
677      * @dev Transfers ownership of the contract to a new account (`newOwner`).
678      * Can only be called by the current owner.
679      */
680     function transferOwnership(address newOwner) public virtual onlyOwner {
681         require(newOwner != address(0), "Ownable: new owner is the zero address");
682         _transferOwnership(newOwner);
683     }
684 
685     /**
686      * @dev Transfers ownership of the contract to a new account (`newOwner`).
687      * Internal function without access restriction.
688      */
689     function _transferOwnership(address newOwner) internal virtual {
690         address oldOwner = _owner;
691         _owner = newOwner;
692         emit OwnershipTransferred(oldOwner, newOwner);
693     }
694 }
695 
696 // File: contracts/ERC721R.sol
697 
698 // Github: https://github.com/erc721r/ERC721R
699 
700 pragma solidity ^0.8.0;
701 
702 
703 
704 
705 
706 
707 
708 /**
709  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
710  * the Metadata extension, but not including the Enumerable extension. This does random batch minting.
711  */
712 contract ERC721r is Context, ERC165, IERC721, IERC721Metadata {
713     using Address for address;
714     using Strings for uint256;
715 
716     // Token name
717     string private _name;
718 
719     // Token symbol
720     string private _symbol;
721 
722     mapping(uint => uint) private _availableTokens;
723     uint256 private _numAvailableTokens;
724     uint256 immutable _maxSupply;
725     // Mapping from token ID to owner address
726     mapping(uint256 => address) private _owners;
727 
728     // Mapping owner address to token count
729     mapping(address => uint256) private _balances;
730 
731     // Mapping from token ID to approved address
732     mapping(uint256 => address) private _tokenApprovals;
733 
734     // Mapping from owner to operator approvals
735     mapping(address => mapping(address => bool)) private _operatorApprovals;
736 
737     /**
738      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
739      */
740     constructor(string memory name_, string memory symbol_, uint maxSupply_) {
741         _name = name_;
742         _symbol = symbol_;
743         _maxSupply = maxSupply_;
744         _numAvailableTokens = maxSupply_;
745     }
746 
747     /**
748      * @dev See {IERC165-supportsInterface}.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
751         return
752         interfaceId == type(IERC721).interfaceId ||
753         interfaceId == type(IERC721Metadata).interfaceId ||
754         super.supportsInterface(interfaceId);
755     }
756 
757     function totalSupply() public view virtual returns (uint256) {
758         return _maxSupply - _numAvailableTokens;
759     }
760 
761     function maxSupply() public view virtual returns (uint256) {
762         return _maxSupply;
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view virtual override returns (uint256) {
769         require(owner != address(0), "ERC721: balance query for the zero address");
770         return _balances[owner];
771     }
772 
773     /**
774      * @dev See {IERC721-ownerOf}.
775      */
776     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
777         address owner = _owners[tokenId];
778         require(owner != address(0), "ERC721: owner query for nonexistent token");
779         return owner;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overridden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return "";
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public virtual override {
819         address owner = ERC721r.ownerOf(tokenId);
820         require(to != owner, "ERC721: approval to current owner");
821 
822         require(
823             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             "ERC721: approve caller is not owner nor approved for all"
825         );
826 
827         _approve(to, tokenId);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view virtual override returns (address) {
834         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public virtual override {
843         _setApprovalForAll(_msgSender(), operator, approved);
844     }
845 
846     /**
847      * @dev See {IERC721-isApprovedForAll}.
848      */
849     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
850         return _operatorApprovals[owner][operator];
851     }
852 
853     /**
854      * @dev See {IERC721-transferFrom}.
855      */
856     function transferFrom(
857         address from,
858         address to,
859         uint256 tokenId
860     ) public virtual override {
861         //solhint-disable-next-line max-line-length
862         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
863 
864         _transfer(from, to, tokenId);
865     }
866 
867     /**
868      * @dev See {IERC721-safeTransferFrom}.
869      */
870     function safeTransferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         safeTransferFrom(from, to, tokenId, "");
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) public virtual override {
887         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
888         _safeTransfer(from, to, tokenId, _data);
889     }
890 
891     /**
892      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
893      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
894      *
895      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
896      *
897      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
898      * implement alternative mechanisms to perform token transfer, such as signature-based.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must exist and be owned by `from`.
905      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _safeTransfer(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) internal virtual {
915         _transfer(from, to, tokenId);
916         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
917     }
918 
919     /**
920      * @dev Returns whether `tokenId` exists.
921      *
922      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
923      *
924      * Tokens start existing when they are minted (`_mint`),
925      * and stop existing when they are burned (`_burn`).
926      */
927     function _exists(uint256 tokenId) internal view virtual returns (bool) {
928         return _owners[tokenId] != address(0);
929     }
930 
931     /**
932      * @dev Returns whether `spender` is allowed to manage `tokenId`.
933      *
934      * Requirements:
935      *
936      * - `tokenId` must exist.
937      */
938     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
939         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
940         address owner = ERC721r.ownerOf(tokenId);
941         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
942     }
943 
944     function _mintIdWithoutBalanceUpdate(address to, uint256 tokenId) private {
945         _beforeTokenTransfer(address(0), to, tokenId);
946 
947         _owners[tokenId] = to;
948 
949         emit Transfer(address(0), to, tokenId);
950 
951         _afterTokenTransfer(address(0), to, tokenId);
952     }
953 
954     function _mintRandom(address to, uint _numToMint) internal virtual {
955         require(_msgSender() == tx.origin, "Contracts cannot mint");
956         require(to != address(0), "ERC721: mint to the zero address");
957         require(_numToMint > 0, "ERC721r: need to mint at least one token");
958 
959         // TODO: Probably don't need this as it will underflow and revert automatically in this case
960         require(_numAvailableTokens >= _numToMint, "ERC721r: minting more tokens than available");
961 
962         uint updatedNumAvailableTokens = _numAvailableTokens;
963         for (uint256 i; i < _numToMint; ++i) { // Do this ++ unchecked?
964             uint256 tokenId = getRandomAvailableTokenId(to, updatedNumAvailableTokens);
965 
966             _mintIdWithoutBalanceUpdate(to, tokenId);
967 
968             --updatedNumAvailableTokens;
969             _balances[to] += 1;
970         }
971 
972         _numAvailableTokens = updatedNumAvailableTokens;
973     }
974 
975     function getRandomAvailableTokenId(address to, uint updatedNumAvailableTokens)
976     internal
977     returns (uint256)
978     {
979         uint256 randomNum = uint256(
980             keccak256(
981                 abi.encode(
982                     to,
983                     tx.gasprice,
984                     block.number,
985                     block.timestamp,
986                     block.difficulty,
987                     blockhash(block.number - 1),
988                     address(this),
989                     updatedNumAvailableTokens
990                 )
991             )
992         );
993         uint256 randomIndex = randomNum % updatedNumAvailableTokens;
994         return getAvailableTokenAtIndex(randomIndex, updatedNumAvailableTokens);
995     }
996 
997     // Implements https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle. Code taken from CryptoPhunksV2
998     function getAvailableTokenAtIndex(uint256 indexToUse, uint updatedNumAvailableTokens)
999     internal
1000     returns (uint256)
1001     {
1002         uint256 valAtIndex = _availableTokens[indexToUse];
1003         uint256 result;
1004         if (valAtIndex == 0) {
1005             // This means the index itself is still an available token
1006             result = indexToUse;
1007         } else {
1008             // This means the index itself is not an available token, but the val at that index is.
1009             result = valAtIndex;
1010         }
1011 
1012         uint256 lastIndex = updatedNumAvailableTokens - 1;
1013         if (indexToUse != lastIndex) {
1014             // Replace the value at indexToUse, now that it's been used.
1015             // Replace it with the data from the last index in the array, since we are going to decrease the array size afterwards.
1016             uint256 lastValInArray = _availableTokens[lastIndex];
1017             if (lastValInArray == 0) {
1018                 // This means the index itself is still an available token
1019                 _availableTokens[indexToUse] = lastIndex;
1020             } else {
1021                 // This means the index itself is not an available token, but the val at that index is.
1022                 _availableTokens[indexToUse] = lastValInArray;
1023                 // Gas refund courtsey of @dievardump
1024                 delete _availableTokens[lastIndex];
1025             }
1026         }
1027 
1028         return result;
1029     }
1030 
1031     // Not as good as minting a specific tokenId, but will behave the same at the start
1032     // allowing you to explicitly mint some tokens at launch.
1033     function _mintAtIndex(address to, uint index) internal virtual {
1034         require(_msgSender() == tx.origin, "Contracts cannot mint");
1035         require(to != address(0), "ERC721: mint to the zero address");
1036         require(_numAvailableTokens >= 1, "ERC721r: minting more tokens than available");
1037 
1038         uint tokenId = getAvailableTokenAtIndex(index, _numAvailableTokens);
1039         --_numAvailableTokens;
1040 
1041         _mintIdWithoutBalanceUpdate(to, tokenId);
1042 
1043         _balances[to] += 1;
1044     }
1045 
1046     /**
1047      * @dev Transfers `tokenId` from `from` to `to`.
1048      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1049      *
1050      * Requirements:
1051      *
1052      * - `to` cannot be the zero address.
1053      * - `tokenId` token must be owned by `from`.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) internal virtual {
1062         require(ERC721r.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1063         require(to != address(0), "ERC721: transfer to the zero address");
1064 
1065         _beforeTokenTransfer(from, to, tokenId);
1066 
1067         // Clear approvals from the previous owner
1068         _approve(address(0), tokenId);
1069 
1070         _balances[from] -= 1;
1071         _balances[to] += 1;
1072         _owners[tokenId] = to;
1073 
1074         emit Transfer(from, to, tokenId);
1075 
1076         _afterTokenTransfer(from, to, tokenId);
1077     }
1078 
1079     /**
1080      * @dev Approve `to` to operate on `tokenId`
1081      *
1082      * Emits a {Approval} event.
1083      */
1084     function _approve(address to, uint256 tokenId) internal virtual {
1085         _tokenApprovals[tokenId] = to;
1086         emit Approval(ERC721r.ownerOf(tokenId), to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev Approve `operator` to operate on all of `owner` tokens
1091      *
1092      * Emits a {ApprovalForAll} event.
1093      */
1094     function _setApprovalForAll(
1095         address owner,
1096         address operator,
1097         bool approved
1098     ) internal virtual {
1099         require(owner != operator, "ERC721: approve to caller");
1100         _operatorApprovals[owner][operator] = approved;
1101         emit ApprovalForAll(owner, operator, approved);
1102     }
1103 
1104     /**
1105      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1106      * The call is not executed if the target address is not a contract.
1107      *
1108      * @param from address representing the previous owner of the given token ID
1109      * @param to target address that will receive the tokens
1110      * @param tokenId uint256 ID of the token to be transferred
1111      * @param _data bytes optional data to send along with the call
1112      * @return bool whether the call correctly returned the expected magic value
1113      */
1114     function _checkOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         if (to.isContract()) {
1121             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1122                 return retval == IERC721Receiver.onERC721Received.selector;
1123             } catch (bytes memory reason) {
1124                 if (reason.length == 0) {
1125                     revert("ERC721: transfer to non ERC721Receiver implementer");
1126                 } else {
1127                     assembly {
1128                         revert(add(32, reason), mload(reason))
1129                     }
1130                 }
1131             }
1132         } else {
1133             return true;
1134         }
1135     }
1136 
1137     /**
1138      * @dev Hook that is called before any token transfer. This includes minting
1139      * and burning.
1140      *
1141      * Calling conditions:
1142      *
1143      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1144      * transferred to `to`.
1145      * - When `from` is zero, `tokenId` will be minted for `to`.
1146      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1147      * - `from` and `to` are never both zero.
1148      *
1149      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1150      */
1151     function _beforeTokenTransfer(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) internal virtual {}
1156 
1157     /**
1158      * @dev Hook that is called after any transfer of tokens. This includes
1159      * minting and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - when `from` and `to` are both non-zero.
1164      * - `from` and `to` are never both zero.
1165      *
1166      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1167      */
1168     function _afterTokenTransfer(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) internal virtual {}
1173 }
1174 
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 /**
1179  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1180  * enumerability of all the token ids in the contract as well as all token ids owned by each
1181  * account.
1182  */
1183 abstract contract ERC721Enumerable is ERC721r, IERC721Enumerable {
1184     // Mapping from owner to list of owned token IDs
1185     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1186 
1187     // Mapping from token ID to index of the owner tokens list
1188     mapping(uint256 => uint256) private _ownedTokensIndex;
1189 
1190     // Array with all token ids, used for enumeration
1191     uint256[] private _allTokens;
1192 
1193     // Mapping from token id to position in the allTokens array
1194     mapping(uint256 => uint256) private _allTokensIndex;
1195 
1196     /**
1197      * @dev See {IERC165-supportsInterface}.
1198      */
1199     function supportsInterface(bytes4 interfaceId)
1200     public
1201     view
1202     virtual
1203     override(IERC165, ERC721r)
1204     returns (bool)
1205     {
1206         return
1207         interfaceId == type(IERC721Enumerable).interfaceId ||
1208         super.supportsInterface(interfaceId);
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1213      */
1214     function tokenOfOwnerByIndex(address owner, uint256 index)
1215     public
1216     view
1217     virtual
1218     override
1219     returns (uint256)
1220     {
1221         require(
1222             index < ERC721r.balanceOf(owner),
1223             "ERC721Enumerable: owner index out of bounds"
1224         );
1225         return _ownedTokens[owner][index];
1226     }
1227 
1228     /**
1229      * @dev See {IERC721Enumerable-totalSupply}.
1230      */
1231     function totalSupply()
1232     public
1233     view
1234     virtual
1235     override(ERC721r, IERC721Enumerable)
1236     returns (uint256)
1237     {
1238         return _allTokens.length;
1239     }
1240 
1241     /**
1242      * @dev See {IERC721Enumerable-tokenByIndex}.
1243      */
1244     function tokenByIndex(uint256 index)
1245     public
1246     view
1247     virtual
1248     override
1249     returns (uint256)
1250     {
1251         require(
1252             index < ERC721Enumerable.totalSupply(),
1253             "ERC721Enumerable: global index out of bounds"
1254         );
1255         return _allTokens[index];
1256     }
1257 
1258     /**
1259      * @dev Hook that is called before any token transfer. This includes minting
1260      * and burning.
1261      *
1262      * Calling conditions:
1263      *
1264      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1265      * transferred to `to`.
1266      * - When `from` is zero, `tokenId` will be minted for `to`.
1267      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1268      * - `from` cannot be the zero address.
1269      * - `to` cannot be the zero address.
1270      *
1271      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1272      */
1273     function _beforeTokenTransfer(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) internal virtual override {
1278         super._beforeTokenTransfer(from, to, tokenId);
1279 
1280         if (from == address(0)) {
1281             _addTokenToAllTokensEnumeration(tokenId);
1282         } else if (from != to) {
1283             _removeTokenFromOwnerEnumeration(from, tokenId);
1284         }
1285         if (to == address(0)) {
1286             _removeTokenFromAllTokensEnumeration(tokenId);
1287         } else if (to != from) {
1288             _addTokenToOwnerEnumeration(to, tokenId);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1294      * @param to address representing the new owner of the given token ID
1295      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1296      */
1297     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1298         uint256 length = ERC721r.balanceOf(to);
1299         _ownedTokens[to][length] = tokenId;
1300         _ownedTokensIndex[tokenId] = length;
1301     }
1302 
1303     /**
1304      * @dev Private function to add a token to this extension's token tracking data structures.
1305      * @param tokenId uint256 ID of the token to be added to the tokens list
1306      */
1307     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1308         _allTokensIndex[tokenId] = _allTokens.length;
1309         _allTokens.push(tokenId);
1310     }
1311 
1312     /**
1313      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1314      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1315      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1316      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1317      * @param from address representing the previous owner of the given token ID
1318      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1319      */
1320     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1321     private
1322     {
1323         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1324         // then delete the last slot (swap and pop).
1325 
1326         uint256 lastTokenIndex = ERC721r.balanceOf(from) - 1;
1327         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1328 
1329         // When the token to delete is the last token, the swap operation is unnecessary
1330         if (tokenIndex != lastTokenIndex) {
1331             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1332 
1333             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1334             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1335         }
1336 
1337         // This also deletes the contents at the last position of the array
1338         delete _ownedTokensIndex[tokenId];
1339         delete _ownedTokens[from][lastTokenIndex];
1340     }
1341 
1342     /**
1343      * @dev Private function to remove a token from this extension's token tracking data structures.
1344      * This has O(1) time complexity, but alters the order of the _allTokens array.
1345      * @param tokenId uint256 ID of the token to be removed from the tokens list
1346      */
1347     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1348         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1349         // then delete the last slot (swap and pop).
1350 
1351         uint256 lastTokenIndex = _allTokens.length - 1;
1352         uint256 tokenIndex = _allTokensIndex[tokenId];
1353 
1354         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1355         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1356         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1357         uint256 lastTokenId = _allTokens[lastTokenIndex];
1358 
1359         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1360         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1361 
1362         // This also deletes the contents at the last position of the array
1363         delete _allTokensIndex[tokenId];
1364         _allTokens.pop();
1365     }
1366 }
1367 
1368 pragma solidity >=0.7.0 <0.9.0;
1369 
1370 contract SuperFriedChickenNFT is ERC721Enumerable, Ownable {
1371     using Strings for uint256;
1372 
1373     string baseURI;
1374     string public baseExtension = ".json";
1375 
1376     bool public paused = true;
1377     bool public happyHour = true;
1378 
1379     uint256 public maxGuestMints = 3;
1380     uint256 public maxPublicMints = 1;
1381 
1382     // Guest list. A mapping to 1 indicates,
1383     // that an address is a happy hour guest.
1384     mapping(address => uint8) public guestList;
1385 
1386     // Number of mints per address
1387     mapping(address => uint256) public mintList;
1388 
1389     constructor(string memory _initBaseURI)
1390     ERC721r("Super Fried Chicken", "SFC", 5999)
1391     {
1392         setBaseURI(_initBaseURI);
1393     }
1394 
1395     // internal
1396     function _baseURI() internal view virtual override returns (string memory) {
1397         return baseURI;
1398     }
1399 
1400     // public
1401     function mint(uint256 _mintAmount) public payable {
1402         require(!paused, " Minting is paused");
1403 
1404         require(_mintAmount > 0, " Invalid mint quantity");
1405         require(totalSupply() + _mintAmount <= maxSupply(), " Not enough supply");
1406 
1407         // apply mint limits for guests and public
1408         if (msg.sender != owner()) {
1409             bool guest = guestList[msg.sender] == 1;
1410             if (happyHour) {
1411                 require(guest, " Minting is currently open only to happy hour guests");
1412             }
1413 
1414             uint256 maxMints = (guest ? maxGuestMints : maxPublicMints);
1415             require(mintList[msg.sender] + _mintAmount <= maxMints, " Insufficient mints remaining");
1416         }
1417 
1418         mintList[msg.sender] += _mintAmount;
1419         _mintRandom(msg.sender, _mintAmount);
1420     }
1421 
1422     // Returns number of SFC an address can still mint.
1423     // Max number of mints available per address is determined
1424     // by (1) whether a happy hour is going on and (3) whether the
1425     // address is a happy hour guest.
1426     // This method does not check if minting is paused.
1427     function mintsRemaining(address addr) public view returns (uint256){
1428         bool guest = guestList[addr] == 1;
1429         if (happyHour && !guest) {
1430             return 0;
1431         }
1432 
1433         uint256 maxMints = (guest ? maxGuestMints : maxPublicMints);
1434         if (mintList[addr] >= maxMints) {
1435             return 0;
1436         } else {
1437             return maxMints - mintList[addr];
1438         }
1439     }
1440 
1441     function tokenURI(uint256 tokenId)
1442     public
1443     view
1444     virtual
1445     override
1446     returns (string memory)
1447     {
1448         require(
1449             _exists(tokenId),
1450             "ERC721Metadata: URI query for nonexistent token"
1451         );
1452 
1453         string memory currentBaseURI = _baseURI();
1454         return
1455         bytes(currentBaseURI).length > 0
1456         ? string(
1457             abi.encodePacked(
1458                 currentBaseURI,
1459                 tokenId.toString(),
1460                 baseExtension
1461             )
1462         )
1463         : "";
1464     }
1465 
1466     function walletOfOwner(address _owner)
1467     public
1468     view
1469     returns (uint256[] memory)
1470     {
1471         uint256 ownerTokenCount = balanceOf(_owner);
1472         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1473         for (uint256 i; i < ownerTokenCount; i++) {
1474             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1475         }
1476         return tokenIds;
1477     }
1478 
1479     function seedGuestList(
1480         address[] calldata addresses
1481     ) external onlyOwner {
1482         for (uint256 i = 0; i < addresses.length; i++) {
1483             guestList[addresses[i]] = 1;
1484         }
1485     }
1486 
1487     function removeGuestList(address[] calldata addresses) external onlyOwner {
1488         for (uint256 i = 0; i < addresses.length; i++) {
1489             guestList[addresses[i]] = 0;
1490         }
1491     }
1492 
1493     function setMaxGuestMintAmount(uint256 _newMaxGuestMintAmount) public onlyOwner {
1494         maxGuestMints = _newMaxGuestMintAmount;
1495     }
1496 
1497     function setMaxPublicMintAmount(uint256 _newMaxPublicMintAmount) public onlyOwner {
1498         maxPublicMints = _newMaxPublicMintAmount;
1499     }
1500 
1501     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1502         baseURI = _newBaseURI;
1503     }
1504 
1505     function setBaseExtension(string memory _newBaseExtension)
1506     public
1507     onlyOwner
1508     {
1509         baseExtension = _newBaseExtension;
1510     }
1511 
1512     function pause(bool _state) public onlyOwner {
1513         paused = _state;
1514     }
1515 
1516     function setHappyHour(bool _state) public onlyOwner {
1517         happyHour = _state;
1518     }
1519 
1520     function withdraw() public payable onlyOwner {
1521         (bool os,) = payable(owner()).call{value : address(this).balance}("");
1522         require(os);
1523     }
1524 }