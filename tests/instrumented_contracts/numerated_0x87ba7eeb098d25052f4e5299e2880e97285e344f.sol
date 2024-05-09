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
31 
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Required interface of an ERC721 compliant contract.
38  */
39 interface IERC721 is IERC165 {
40     /**
41      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
44 
45     /**
46      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
47      */
48     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
49 
50     /**
51      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
52      */
53     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
54 
55     /**
56      * @dev Returns the number of tokens in ``owner``'s account.
57      */
58     function balanceOf(address owner) external view returns (uint256 balance);
59 
60     /**
61      * @dev Returns the owner of the `tokenId` token.
62      *
63      * Requirements:
64      *
65      * - `tokenId` must exist.
66      */
67     function ownerOf(uint256 tokenId) external view returns (address owner);
68 
69     /**
70      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
71      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId
87     ) external;
88 
89     /**
90      * @dev Transfers `tokenId` token from `from` to `to`.
91      *
92      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must be owned by `from`.
99      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 tokenId
107     ) external;
108 
109     /**
110      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
111      * The approval is cleared when the token is transferred.
112      *
113      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
114      *
115      * Requirements:
116      *
117      * - The caller must own the token or be an approved operator.
118      * - `tokenId` must exist.
119      *
120      * Emits an {Approval} event.
121      */
122     function approve(address to, uint256 tokenId) external;
123 
124     /**
125      * @dev Returns the account approved for `tokenId` token.
126      *
127      * Requirements:
128      *
129      * - `tokenId` must exist.
130      */
131     function getApproved(uint256 tokenId) external view returns (address operator);
132 
133     /**
134      * @dev Approve or remove `operator` as an operator for the caller.
135      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
136      *
137      * Requirements:
138      *
139      * - The `operator` cannot be the caller.
140      *
141      * Emits an {ApprovalForAll} event.
142      */
143     function setApprovalForAll(address operator, bool _approved) external;
144 
145     /**
146      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
147      *
148      * See {setApprovalForAll}
149      */
150     function isApprovedForAll(address owner, address operator) external view returns (bool);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId,
169         bytes calldata data
170     ) external;
171 }
172 
173 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @title ERC721 token receiver interface
182  * @dev Interface for any contract that wants to support safeTransfers
183  * from ERC721 asset contracts.
184  */
185 interface IERC721Receiver {
186     /**
187      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
188      * by `operator` from `from`, this function is called.
189      *
190      * It must return its Solidity selector to confirm the token transfer.
191      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
192      *
193      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
194      */
195     function onERC721Received(
196         address operator,
197         address from,
198         uint256 tokenId,
199         bytes calldata data
200     ) external returns (bytes4);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
212  * @dev See https://eips.ethereum.org/EIPS/eip-721
213  */
214 interface IERC721Metadata is IERC721 {
215     /**
216      * @dev Returns the token collection name.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the token collection symbol.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
227      */
228     function tokenURI(uint256 tokenId) external view returns (string memory);
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
240  * @dev See https://eips.ethereum.org/EIPS/eip-721
241  */
242 interface IERC721Enumerable is IERC721 {
243     /**
244      * @dev Returns the total amount of tokens stored by the contract.
245      */
246     function totalSupply() external view returns (uint256);
247 
248     /**
249      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
250      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
251      */
252     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
253 
254     /**
255      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
256      * Use along with {totalSupply} to enumerate all tokens.
257      */
258     function tokenByIndex(uint256 index) external view returns (uint256);
259 }
260 
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 
264 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
265 
266 pragma solidity ^0.8.1;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      *
289      * [IMPORTANT]
290      * ====
291      * You shouldn't rely on `isContract` to protect against flash loan attacks!
292      *
293      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
294      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
295      * constructor.
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies on extcodesize/address.code.length, which returns 0
300         // for contracts in construction, since the code is only stored at the end
301         // of the constructor execution.
302 
303         return account.code.length > 0;
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         (bool success, ) = recipient.call{value: amount}("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain `call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(
358         address target,
359         bytes memory data,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(
377         address target,
378         bytes memory data,
379         uint256 value
380     ) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(
391         address target,
392         bytes memory data,
393         uint256 value,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.call{value: value}(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
410         return functionStaticCall(target, data, "Address: low-level static call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a static call.
416      *
417      * _Available since v3.3._
418      */
419     function functionStaticCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal view returns (bytes memory) {
424         require(isContract(target), "Address: static call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.staticcall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but performing a delegate call.
433      *
434      * _Available since v3.4._
435      */
436     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
437         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
442      * but performing a delegate call.
443      *
444      * _Available since v3.4._
445      */
446     function functionDelegateCall(
447         address target,
448         bytes memory data,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(isContract(target), "Address: delegate call to non-contract");
452 
453         (bool success, bytes memory returndata) = target.delegatecall(data);
454         return verifyCallResult(success, returndata, errorMessage);
455     }
456 
457     /**
458      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
459      * revert reason using the provided one.
460      *
461      * _Available since v4.3._
462      */
463     function verifyCallResult(
464         bool success,
465         bytes memory returndata,
466         string memory errorMessage
467     ) internal pure returns (bytes memory) {
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 assembly {
476                     let returndata_size := mload(returndata)
477                     revert(add(32, returndata), returndata_size)
478                 }
479             } else {
480                 revert(errorMessage);
481             }
482         }
483     }
484 }
485 
486 // File: @openzeppelin/contracts/utils/Context.sol
487 
488 
489 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Provides information about the current execution context, including the
495  * sender of the transaction and its data. While these are generally available
496  * via msg.sender and msg.data, they should not be accessed in such a direct
497  * manner, since when dealing with meta-transactions the account sending and
498  * paying for execution may not be the actual sender (as far as an application
499  * is concerned).
500  *
501  * This contract is only required for intermediate, library-like contracts.
502  */
503 abstract contract Context {
504     function _msgSender() internal view virtual returns (address) {
505         return msg.sender;
506     }
507 
508     function _msgData() internal view virtual returns (bytes calldata) {
509         return msg.data;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/utils/Strings.sol
514 
515 
516 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev String operations.
522  */
523 library Strings {
524     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
525 
526     /**
527      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
528      */
529     function toString(uint256 value) internal pure returns (string memory) {
530         // Inspired by OraclizeAPI's implementation - MIT licence
531         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
532 
533         if (value == 0) {
534             return "0";
535         }
536         uint256 temp = value;
537         uint256 digits;
538         while (temp != 0) {
539             digits++;
540             temp /= 10;
541         }
542         bytes memory buffer = new bytes(digits);
543         while (value != 0) {
544             digits -= 1;
545             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
546             value /= 10;
547         }
548         return string(buffer);
549     }
550 
551     /**
552      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
553      */
554     function toHexString(uint256 value) internal pure returns (string memory) {
555         if (value == 0) {
556             return "0x00";
557         }
558         uint256 temp = value;
559         uint256 length = 0;
560         while (temp != 0) {
561             length++;
562             temp >>= 8;
563         }
564         return toHexString(value, length);
565     }
566 
567     /**
568      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
569      */
570     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
571         bytes memory buffer = new bytes(2 * length + 2);
572         buffer[0] = "0";
573         buffer[1] = "x";
574         for (uint256 i = 2 * length + 1; i > 1; --i) {
575             buffer[i] = _HEX_SYMBOLS[value & 0xf];
576             value >>= 4;
577         }
578         require(value == 0, "Strings: hex length insufficient");
579         return string(buffer);
580     }
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 /**
591  * @dev Implementation of the {IERC165} interface.
592  *
593  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
594  * for the additional interface id that will be supported. For example:
595  *
596  * ```solidity
597  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
599  * }
600  * ```
601  *
602  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
603  */
604 abstract contract ERC165 is IERC165 {
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
609         return interfaceId == type(IERC165).interfaceId;
610     }
611 }
612 
613 // File: @openzeppelin/contracts/access/Ownable.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Contract module which provides a basic access control mechanism, where
622  * there is an account (an owner) that can be granted exclusive access to
623  * specific functions.
624  *
625  * By default, the owner account will be the one that deploys the contract. This
626  * can later be changed with {transferOwnership}.
627  *
628  * This module is used through inheritance. It will make available the modifier
629  * `onlyOwner`, which can be applied to your functions to restrict their use to
630  * the owner.
631  */
632 abstract contract Ownable is Context {
633     address private _owner;
634 
635     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
636 
637     /**
638      * @dev Initializes the contract setting the deployer as the initial owner.
639      */
640     constructor() {
641         _transferOwnership(_msgSender());
642     }
643 
644     /**
645      * @dev Returns the address of the current owner.
646      */
647     function owner() public view virtual returns (address) {
648         return _owner;
649     }
650 
651     /**
652      * @dev Throws if called by any account other than the owner.
653      */
654     modifier onlyOwner() {
655         require(owner() == _msgSender(), "Ownable: caller is not the owner");
656         _;
657     }
658 
659     /**
660      * @dev Leaves the contract without owner. It will not be possible to call
661      * `onlyOwner` functions anymore. Can only be called by the current owner.
662      *
663      * NOTE: Renouncing ownership will leave the contract without an owner,
664      * thereby removing any functionality that is only available to the owner.
665      */
666     function renounceOwnership() public virtual onlyOwner {
667         _transferOwnership(address(0));
668     }
669 
670     /**
671      * @dev Transfers ownership of the contract to a new account (`newOwner`).
672      * Can only be called by the current owner.
673      */
674     function transferOwnership(address newOwner) public virtual onlyOwner {
675         require(newOwner != address(0), "Ownable: new owner is the zero address");
676         _transferOwnership(newOwner);
677     }
678 
679     /**
680      * @dev Transfers ownership of the contract to a new account (`newOwner`).
681      * Internal function without access restriction.
682      */
683     function _transferOwnership(address newOwner) internal virtual {
684         address oldOwner = _owner;
685         _owner = newOwner;
686         emit OwnershipTransferred(oldOwner, newOwner);
687     }
688 }
689 
690 // File: contracts/ERC721A.sol
691 
692 
693 // Creator: Chiru Labs
694 
695 pragma solidity ^0.8.4;
696 
697 
698 
699 
700 
701 
702 
703 
704 
705 error ApprovalCallerNotOwnerNorApproved();
706 error ApprovalQueryForNonexistentToken();
707 error ApproveToCaller();
708 error ApprovalToCurrentOwner();
709 error BalanceQueryForZeroAddress();
710 error MintedQueryForZeroAddress();
711 error BurnedQueryForZeroAddress();
712 error AuxQueryForZeroAddress();
713 error MintToZeroAddress();
714 error MintZeroQuantity();
715 error OwnerIndexOutOfBounds();
716 error OwnerQueryForNonexistentToken();
717 error TokenIndexOutOfBounds();
718 error TransferCallerNotOwnerNorApproved();
719 error TransferFromIncorrectOwner();
720 error TransferToNonERC721ReceiverImplementer();
721 error TransferToZeroAddress();
722 error URIQueryForNonexistentToken();
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata extension. Built to optimize for lower gas during batch mints.
727  *
728  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
729  *
730  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
731  *
732  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
733  */
734 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, Ownable {
735     using Address for address;
736     using Strings for uint256;
737     string private baseURI;
738     string private baseExtension = ".json";
739     // Compiler will pack this into a single 256bit word.
740     struct TokenOwnership {
741         // The address of the owner.
742         address addr;
743         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
744         uint64 startTimestamp;
745         // Whether the token has been burned.
746         bool burned;
747     }
748 
749     // Compiler will pack this into a single 256bit word.
750     struct AddressData {
751         // Realistically, 2**64-1 is more than enough.
752         uint64 balance;
753         // Keeps track of mint count with minimal overhead for tokenomics.
754         uint64 numberMinted;
755         // Keeps track of burn count with minimal overhead for tokenomics.
756         uint64 numberBurned;
757         // For miscellaneous variable(s) pertaining to the address
758         // (e.g. number of whitelist mint slots used).
759         // If there are multiple variables, please pack them into a uint64.
760         uint64 aux;
761     }
762 
763     // The tokenId of the next token to be minted.
764     uint256 internal _currentIndex;
765 
766     // The number of tokens burned.
767     uint256 internal _burnCounter;
768 
769     // Token name
770     string private _name;
771 
772     // Token symbol
773     string private _symbol;
774 
775     // Mapping from token ID to ownership details
776     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
777     mapping(uint256 => TokenOwnership) internal _ownerships;
778 
779     // Mapping owner address to address data
780     mapping(address => AddressData) private _addressData;
781 
782     // Mapping from token ID to approved address
783     mapping(uint256 => address) private _tokenApprovals;
784 
785     // Mapping from owner to operator approvals
786     mapping(address => mapping(address => bool)) private _operatorApprovals;
787 
788     constructor(string memory name_, string memory symbol_, string memory baseUri_) {
789         _name = name_;
790         _symbol = symbol_;
791         _currentIndex = _startTokenId();
792         baseURI = baseUri_;
793     }
794 
795     /**
796      * To change the starting tokenId, please override this function.
797      */
798     function _startTokenId() internal view virtual returns (uint256) {
799         return 0;
800     }
801 
802     /**
803      * @dev See {IERC721Enumerable-totalSupply}.
804      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
805      */
806     function totalSupply() public view returns (uint256) {
807         // Counter underflow is impossible as _burnCounter cannot be incremented
808         // more than _currentIndex - _startTokenId() times
809         unchecked {
810             return _currentIndex - _burnCounter - _startTokenId();
811         }
812     }
813 
814     /**
815      * Returns the total amount of tokens minted in the contract.
816      */
817     function _totalMinted() internal view returns (uint256) {
818         // Counter underflow is impossible as _currentIndex does not decrement,
819         // and it is initialized to _startTokenId()
820         unchecked {
821             return _currentIndex - _startTokenId();
822         }
823     }
824 
825     /**
826      * @dev See {IERC165-supportsInterface}.
827      */
828     function supportsInterface(bytes4 interfaceId)
829         public
830         view
831         virtual
832         override(ERC165, IERC165)
833         returns (bool)
834     {
835         return
836             interfaceId == type(IERC721).interfaceId ||
837             interfaceId == type(IERC721Metadata).interfaceId ||
838             super.supportsInterface(interfaceId);
839     }
840 
841     /**
842      * @dev See {IERC721-balanceOf}.
843      */
844     function balanceOf(address owner) public view override returns (uint256) {
845         if (owner == address(0)) revert BalanceQueryForZeroAddress();
846         return uint256(_addressData[owner].balance);
847     }
848 
849     /**
850      * Returns the number of tokens minted by `owner`.
851      */
852     function _numberMinted(address owner) internal view returns (uint256) {
853         if (owner == address(0)) revert MintedQueryForZeroAddress();
854         return uint256(_addressData[owner].numberMinted);
855     }
856 
857     /**
858      * Returns the number of tokens burned by or on behalf of `owner`.
859      */
860     function _numberBurned(address owner) internal view returns (uint256) {
861         if (owner == address(0)) revert BurnedQueryForZeroAddress();
862         return uint256(_addressData[owner].numberBurned);
863     }
864 
865     /**
866      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
867      */
868     function _getAux(address owner) internal view returns (uint64) {
869         if (owner == address(0)) revert AuxQueryForZeroAddress();
870         return _addressData[owner].aux;
871     }
872 
873     /**
874      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
875      * If there are multiple variables, please pack them into a uint64.
876      */
877     function _setAux(address owner, uint64 aux) internal {
878         if (owner == address(0)) revert AuxQueryForZeroAddress();
879         _addressData[owner].aux = aux;
880     }
881 
882     /**
883      * Gas spent here starts off proportional to the maximum mint batch size.
884      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
885      */
886     function ownershipOf(uint256 tokenId)
887         internal
888         view
889         returns (TokenOwnership memory)
890     {
891         uint256 curr = tokenId;
892 
893         unchecked {
894             if (_startTokenId() <= curr && curr < _currentIndex) {
895                 TokenOwnership memory ownership = _ownerships[curr];
896                 if (!ownership.burned) {
897                     if (ownership.addr != address(0)) {
898                         return ownership;
899                     }
900                     // Invariant:
901                     // There will always be an ownership that has an address and is not burned
902                     // before an ownership that does not have an address and is not burned.
903                     // Hence, curr will not underflow.
904                     while (true) {
905                         curr--;
906                         ownership = _ownerships[curr];
907                         if (ownership.addr != address(0)) {
908                             return ownership;
909                         }
910                     }
911                 }
912             }
913         }
914         revert OwnerQueryForNonexistentToken();
915     }
916 
917     /**
918      * @dev See {IERC721-ownerOf}.
919      */
920     function ownerOf(uint256 tokenId) public view override returns (address) {
921         return ownershipOf(tokenId).addr;
922     }
923 
924 
925     /**
926      * @dev See {IERC721Metadata-name}.
927      */
928     function name() public view virtual override returns (string memory) {
929         return _name;
930     }
931 
932     /**
933      * @dev See {IERC721Metadata-symbol}.
934      */
935     function symbol() public view virtual override returns (string memory) {
936         return _symbol;
937     }
938 
939   
940     /**
941      * @dev See {IERC721Metadata-tokenURI}.
942      */
943   function tokenURI(uint256 tokenId)
944         public
945         view
946         virtual
947         override
948         returns (string memory)
949     {
950         require(
951             _exists(tokenId),
952             "Modern Poker Club: URI query for nonexistent token"
953         );
954 
955         string memory currentBaseURI = baseURI;
956         return
957             bytes(currentBaseURI).length > 0
958                 ? string(
959                     abi.encodePacked(
960                         currentBaseURI,
961                         tokenId.toString(),
962                         baseExtension
963                     )
964                 )
965                 : "";
966     }
967 
968     /**
969      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
970      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
971      * by default, can be overriden in child contracts.
972      */
973     function setBaseUri(string memory _baseUri) public onlyOwner {
974         baseURI = _baseUri;
975     }
976 
977     /**
978      * @dev See {IERC721-approve}.
979      */
980     function approve(address to, uint256 tokenId) public override {
981         address owner = ERC721A.ownerOf(tokenId);
982         if (to == owner) revert ApprovalToCurrentOwner();
983 
984         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
985             revert ApprovalCallerNotOwnerNorApproved();
986         }
987 
988         _approve(to, tokenId, owner);
989     }
990 
991     /**
992      * @dev See {IERC721-getApproved}.
993      */
994     function getApproved(uint256 tokenId)
995         public
996         view
997         override
998         returns (address)
999     {
1000         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1001 
1002         return _tokenApprovals[tokenId];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-setApprovalForAll}.
1007      */
1008     function setApprovalForAll(address operator, bool approved)
1009         public
1010         override
1011     {
1012         if (operator == _msgSender()) revert ApproveToCaller();
1013 
1014         _operatorApprovals[_msgSender()][operator] = approved;
1015         emit ApprovalForAll(_msgSender(), operator, approved);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-isApprovedForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator)
1022         public
1023         view
1024         virtual
1025         override
1026         returns (bool)
1027     {
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-transferFrom}.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         _transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         safeTransferFrom(from, to, tokenId, "");
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) public virtual override {
1062         _transfer(from, to, tokenId);
1063         if (
1064             to.isContract() &&
1065             !_checkContractOnERC721Received(from, to, tokenId, _data)
1066         ) {
1067             revert TransferToNonERC721ReceiverImplementer();
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns whether `tokenId` exists.
1073      *
1074      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1075      *
1076      * Tokens start existing when they are minted (`_mint`),
1077      */
1078     function _exists(uint256 tokenId) internal view returns (bool) {
1079         return
1080             _startTokenId() <= tokenId &&
1081             tokenId < _currentIndex &&
1082             !_ownerships[tokenId].burned;
1083     }
1084 
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, "");
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         _mint(to, quantity, _data, true);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _mint(
1118         address to,
1119         uint256 quantity,
1120         bytes memory _data,
1121         bool safe
1122     ) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1132         unchecked {
1133             _addressData[to].balance += uint64(quantity);
1134             _addressData[to].numberMinted += uint64(quantity);
1135 
1136             _ownerships[startTokenId].addr = to;
1137             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             uint256 updatedIndex = startTokenId;
1140             uint256 end = updatedIndex + quantity;
1141 
1142             if (safe && to.isContract()) {
1143                 do {
1144                     emit Transfer(address(0), to, updatedIndex);
1145                     if (
1146                         !_checkContractOnERC721Received(
1147                             address(0),
1148                             to,
1149                             updatedIndex++,
1150                             _data
1151                         )
1152                     ) {
1153                         revert TransferToNonERC721ReceiverImplementer();
1154                     }
1155                 } while (updatedIndex != end);
1156                 // Reentrancy protection
1157                 if (_currentIndex != startTokenId) revert();
1158             } else {
1159                 do {
1160                     emit Transfer(address(0), to, updatedIndex++);
1161                 } while (updatedIndex != end);
1162             }
1163             _currentIndex = updatedIndex;
1164         }
1165         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1166     }
1167 
1168     /**
1169      * @dev Transfers `tokenId` from `from` to `to`.
1170      *
1171      * Requirements:
1172      *
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must be owned by `from`.
1175      *
1176      * Emits a {Transfer} event.
1177      */
1178     function _transfer(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) private {
1183         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1184 
1185         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1186             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1187             getApproved(tokenId) == _msgSender());
1188 
1189         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1190         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1191         if (to == address(0)) revert TransferToZeroAddress();
1192 
1193         _beforeTokenTransfers(from, to, tokenId, 1);
1194 
1195         // Clear approvals from the previous owner
1196         _approve(address(0), tokenId, prevOwnership.addr);
1197 
1198         // Underflow of the sender's balance is impossible because we check for
1199         // ownership above and the recipient's balance can't realistically overflow.
1200         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1201         unchecked {
1202             _addressData[from].balance -= 1;
1203             _addressData[to].balance += 1;
1204 
1205             _ownerships[tokenId].addr = to;
1206             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1207 
1208             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1209             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1210             uint256 nextTokenId = tokenId + 1;
1211             if (_ownerships[nextTokenId].addr == address(0)) {
1212                 // This will suffice for checking _exists(nextTokenId),
1213                 // as a burned slot cannot contain the zero address.
1214                 if (nextTokenId < _currentIndex) {
1215                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1216                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1217                         .startTimestamp;
1218                 }
1219             }
1220         }
1221 
1222         emit Transfer(from, to, tokenId);
1223         _afterTokenTransfers(from, to, tokenId, 1);
1224     }
1225 
1226     /**
1227      * @dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId) internal virtual {
1237         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1238 
1239         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1240 
1241         // Clear approvals from the previous owner
1242         _approve(address(0), tokenId, prevOwnership.addr);
1243 
1244         // Underflow of the sender's balance is impossible because we check for
1245         // ownership above and the recipient's balance can't realistically overflow.
1246         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1247         unchecked {
1248             _addressData[prevOwnership.addr].balance -= 1;
1249             _addressData[prevOwnership.addr].numberBurned += 1;
1250 
1251             // Keep track of who burned the token, and the timestamp of burning.
1252             _ownerships[tokenId].addr = prevOwnership.addr;
1253             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1254             _ownerships[tokenId].burned = true;
1255 
1256             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1257             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1258             uint256 nextTokenId = tokenId + 1;
1259             if (_ownerships[nextTokenId].addr == address(0)) {
1260                 // This will suffice for checking _exists(nextTokenId),
1261                 // as a burned slot cannot contain the zero address.
1262                 if (nextTokenId < _currentIndex) {
1263                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1264                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1265                         .startTimestamp;
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(prevOwnership.addr, address(0), tokenId);
1271         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1272 
1273         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1274         unchecked {
1275             _burnCounter++;
1276         }
1277     }
1278 
1279     /**
1280      * @dev Approve `to` to operate on `tokenId`
1281      *
1282      * Emits a {Approval} event.
1283      */
1284     function _approve(
1285         address to,
1286         uint256 tokenId,
1287         address owner
1288     ) private {
1289         _tokenApprovals[tokenId] = to;
1290         emit Approval(owner, to, tokenId);
1291     }
1292 
1293     /**
1294      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1295      *
1296      * @param from address representing the previous owner of the given token ID
1297      * @param to target address that will receive the tokens
1298      * @param tokenId uint256 ID of the token to be transferred
1299      * @param _data bytes optional data to send along with the call
1300      * @return bool whether the call correctly returned the expected magic value
1301      */
1302     function _checkContractOnERC721Received(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) private returns (bool) {
1308         try
1309             IERC721Receiver(to).onERC721Received(
1310                 _msgSender(),
1311                 from,
1312                 tokenId,
1313                 _data
1314             )
1315         returns (bytes4 retval) {
1316             return retval == IERC721Receiver(to).onERC721Received.selector;
1317         } catch (bytes memory reason) {
1318             if (reason.length == 0) {
1319                 revert TransferToNonERC721ReceiverImplementer();
1320             } else {
1321                 assembly {
1322                     revert(add(32, reason), mload(reason))
1323                 }
1324             }
1325         }
1326     }
1327 
1328     /**
1329      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1330      * And also called before burning one token.
1331      *
1332      * startTokenId - the first token id to be transferred
1333      * quantity - the amount to be transferred
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, `tokenId` will be burned by `from`.
1341      * - `from` and `to` are never both zero.
1342      */
1343     function _beforeTokenTransfers(
1344         address from,
1345         address to,
1346         uint256 startTokenId,
1347         uint256 quantity
1348     ) internal virtual {}
1349 
1350     /**
1351      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1352      * minting.
1353      * And also called after one token has been burned.
1354      *
1355      * startTokenId - the first token id to be transferred
1356      * quantity - the amount to be transferred
1357      *
1358      * Calling conditions:
1359      *
1360      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1361      * transferred to `to`.
1362      * - When `from` is zero, `tokenId` has been minted for `to`.
1363      * - When `to` is zero, `tokenId` has been burned by `from`.
1364      * - `from` and `to` are never both zero.
1365      */
1366     function _afterTokenTransfers(
1367         address from,
1368         address to,
1369         uint256 startTokenId,
1370         uint256 quantity
1371     ) internal virtual {}
1372 }
1373 
1374 // File: contracts/roles/Roles.sol
1375 
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 /**
1380  * @title Roles
1381  * @dev Library for managing addresses assigned to a Role.
1382  */
1383 library Roles {
1384     struct Role {
1385         mapping (address => bool) bearer;
1386     }
1387 
1388     /**
1389      * @dev Give an account access to this role.
1390      */
1391     function add(Role storage role, address account) internal {
1392         require(!has(role, account), "Roles: account already has role");
1393         role.bearer[account] = true;
1394     }
1395 
1396     /**
1397      * @dev Remove an account's access to this role.
1398      */
1399     function remove(Role storage role, address account) internal {
1400         require(has(role, account), "Roles: account does not have role");
1401         role.bearer[account] = false;
1402     }
1403 
1404     /**
1405      * @dev Check if an account has this role.
1406      * @return bool
1407      */
1408     function has(Role storage role, address account) internal view returns (bool) {
1409         require(account != address(0), "Roles: account is the zero address");
1410         return role.bearer[account];
1411     }
1412 }
1413 
1414 // File: contracts/roles/MinterRole.sol
1415 
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 
1420 abstract contract MinterRole is Context {
1421     using Roles for Roles.Role;
1422 
1423     event MinterAdded(address indexed account);
1424     event MinterRemoved(address indexed account);
1425 
1426     Roles.Role private _minters;
1427 
1428     constructor () internal {
1429         _addMinter(_msgSender());
1430     }
1431 
1432     modifier onlyMinter() {
1433         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
1434         _;
1435     }
1436 
1437     function isMinter(address account) public view returns (bool) {
1438         return _minters.has(account);
1439     }
1440 
1441     function addMinter(address account) public onlyMinter {
1442         _addMinter(account);
1443     }
1444 
1445     function renounceMinter() public {
1446         _removeMinter(_msgSender());
1447     }
1448 
1449     function _addMinter(address account) internal {
1450         _minters.add(account);
1451         emit MinterAdded(account);
1452     }
1453 
1454     function _removeMinter(address account) internal {
1455         _minters.remove(account);
1456         emit MinterRemoved(account);
1457     }
1458 }
1459 
1460 // File: contracts/ModernPokerClubToken.sol
1461 
1462 
1463 pragma solidity ^0.8.4;
1464 
1465 
1466 contract ModernPokerClubToken is ERC721A, MinterRole {
1467     constructor(string memory _name, string memory _symbol, string memory _baseURI)
1468         ERC721A(_name, _symbol, _baseURI)
1469     {}
1470     event Mint(address indexed to, uint256 indexed tokenId);
1471 
1472     function mint(address beneficiary ,uint256 quantity) public onlyMinter returns (bool) {
1473         // _safeMint's second argument now takes in a quantity, not a tokenId.
1474         _safeMint(beneficiary, quantity);
1475         emit Mint(beneficiary, quantity);
1476 
1477         return true;
1478     }
1479 
1480 }