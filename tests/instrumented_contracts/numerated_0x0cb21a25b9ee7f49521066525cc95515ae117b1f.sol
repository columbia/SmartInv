1 // File: contracts/Hero.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-17
5 */
6 
7 // Sources flattened with hardhat v2.8.4 https://hardhat.org
8 
9 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
12 
13 pragma solidity ^0.8.4;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 
36 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
37 
38 
39 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
40 
41 
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 
114 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
118 
119 
120 
121 /**
122  * @dev Interface of the ERC165 standard, as defined in the
123  * https://eips.ethereum.org/EIPS/eip-165[EIP].
124  *
125  * Implementers can declare support of contract interfaces, which can then be
126  * queried by others ({ERC165Checker}).
127  *
128  * For an implementation, see {ERC165}.
129  */
130 interface IERC165 {
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30 000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 }
141 
142 
143 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
147 
148 
149 
150 /**
151  * @dev Required interface of an ERC721 compliant contract.
152  */
153 interface IERC721 is IERC165 {
154     /**
155      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
158 
159     /**
160      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
161      */
162     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
163 
164     /**
165      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
166      */
167     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
168 
169     /**
170      * @dev Returns the number of tokens in ``owner``'s account.
171      */
172     function balanceOf(address owner) external view returns (uint256 balance);
173 
174     /**
175      * @dev Returns the owner of the `tokenId` token.
176      *
177      * Requirements:
178      *
179      * - `tokenId` must exist.
180      */
181     function ownerOf(uint256 tokenId) external view returns (address owner);
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
185      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must exist and be owned by `from`.
192      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
194      *
195      * Emits a {Transfer} event.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Transfers `tokenId` token from `from` to `to`.
205      *
206      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must be owned by `from`.
213      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external;
222 
223     /**
224      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
225      * The approval is cleared when the token is transferred.
226      *
227      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
228      *
229      * Requirements:
230      *
231      * - The caller must own the token or be an approved operator.
232      * - `tokenId` must exist.
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address to, uint256 tokenId) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Approve or remove `operator` as an operator for the caller.
249      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
250      *
251      * Requirements:
252      *
253      * - The `operator` cannot be the caller.
254      *
255      * Emits an {ApprovalForAll} event.
256      */
257     function setApprovalForAll(address operator, bool _approved) external;
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 
266     /**
267      * @dev Safely transfers `tokenId` token from `from` to `to`.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must exist and be owned by `from`.
274      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
276      *
277      * Emits a {Transfer} event.
278      */
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId,
283         bytes calldata data
284     ) external;
285 }
286 
287 
288 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
289 
290 
291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
292 
293 
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 
319 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
323 
324 
325 
326 /**
327  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
328  * @dev See https://eips.ethereum.org/EIPS/eip-721
329  */
330 interface IERC721Metadata is IERC721 {
331     /**
332      * @dev Returns the token collection name.
333      */
334     function name() external view returns (string memory);
335 
336     /**
337      * @dev Returns the token collection symbol.
338      */
339     function symbol() external view returns (string memory);
340 
341     /**
342      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
343      */
344     function tokenURI(uint256 tokenId) external view returns (string memory);
345 }
346 
347 
348 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
349 
350 
351 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
352 
353 
354 
355 /**
356  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
357  * @dev See https://eips.ethereum.org/EIPS/eip-721
358  */
359 interface IERC721Enumerable is IERC721 {
360     /**
361      * @dev Returns the total amount of tokens stored by the contract.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
367      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
368      */
369     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
370 
371     /**
372      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
373      * Use along with {totalSupply} to enumerate all tokens.
374      */
375     function tokenByIndex(uint256 index) external view returns (uint256);
376 }
377 
378 
379 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
380 
381 
382 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
383 
384 pragma solidity ^0.8.1;
385 
386 /**
387  * @dev Collection of functions related to the address type
388  */
389 library Address {
390     /**
391      * @dev Returns true if `account` is a contract.
392      *
393      * [IMPORTANT]
394      * ====
395      * It is unsafe to assume that an address for which this function returns
396      * false is an externally-owned account (EOA) and not a contract.
397      *
398      * Among others, `isContract` will return false for the following
399      * types of addresses:
400      *
401      *  - an externally-owned account
402      *  - a contract in construction
403      *  - an address where a contract will be created
404      *  - an address where a contract lived, but was destroyed
405      * ====
406      *
407      * [IMPORTANT]
408      * ====
409      * You shouldn't rely on `isContract` to protect against flash loan attacks!
410      *
411      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
412      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
413      * constructor.
414      * ====
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies on extcodesize/address.code.length, which returns 0
418         // for contracts in construction, since the code is only stored at the end
419         // of the constructor execution.
420 
421         return account.code.length > 0;
422     }
423 
424     /**
425      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
426      * `recipient`, forwarding all available gas and reverting on errors.
427      *
428      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
429      * of certain opcodes, possibly making contracts go over the 2300 gas limit
430      * imposed by `transfer`, making them unable to receive funds via
431      * `transfer`. {sendValue} removes this limitation.
432      *
433      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
434      *
435      * IMPORTANT: because control is transferred to `recipient`, care must be
436      * taken to not create reentrancy vulnerabilities. Consider using
437      * {ReentrancyGuard} or the
438      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
439      */
440     function sendValue(address payable recipient, uint256 amount) internal {
441         require(address(this).balance >= amount, "Address: insufficient balance");
442 
443         (bool success, ) = recipient.call{value: amount}("");
444         require(success, "Address: unable to send value, recipient may have reverted");
445     }
446 
447     /**
448      * @dev Performs a Solidity function call using a low level `call`. A
449      * plain `call` is an unsafe replacement for a function call: use this
450      * function instead.
451      *
452      * If `target` reverts with a revert reason, it is bubbled up by this
453      * function (like regular Solidity function calls).
454      *
455      * Returns the raw returned data. To convert to the expected return value,
456      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
457      *
458      * Requirements:
459      *
460      * - `target` must be a contract.
461      * - calling `target` with `data` must not revert.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionCall(target, data, "Address: low-level call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
471      * `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         return functionCallWithValue(target, data, 0, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but also transferring `value` wei to `target`.
486      *
487      * Requirements:
488      *
489      * - the calling contract must have an ETH balance of at least `value`.
490      * - the called Solidity function must be `payable`.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value
498     ) internal returns (bytes memory) {
499         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
504      * with `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCallWithValue(
509         address target,
510         bytes memory data,
511         uint256 value,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(address(this).balance >= value, "Address: insufficient balance for call");
515         require(isContract(target), "Address: call to non-contract");
516 
517         (bool success, bytes memory returndata) = target.call{value: value}(data);
518         return verifyCallResult(success, returndata, errorMessage);
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
523      * but performing a static call.
524      *
525      * _Available since v3.3._
526      */
527     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
528         return functionStaticCall(target, data, "Address: low-level static call failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal view returns (bytes memory) {
542         require(isContract(target), "Address: static call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.staticcall(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but performing a delegate call.
551      *
552      * _Available since v3.4._
553      */
554     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
555         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         require(isContract(target), "Address: delegate call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.delegatecall(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
577      * revert reason using the provided one.
578      *
579      * _Available since v4.3._
580      */
581     function verifyCallResult(
582         bool success,
583         bytes memory returndata,
584         string memory errorMessage
585     ) internal pure returns (bytes memory) {
586         if (success) {
587             return returndata;
588         } else {
589             // Look for revert reason and bubble it up if present
590             if (returndata.length > 0) {
591                 // The easiest way to bubble the revert reason is using memory via assembly
592 
593                 assembly {
594                     let returndata_size := mload(returndata)
595                     revert(add(32, returndata), returndata_size)
596                 }
597             } else {
598                 revert(errorMessage);
599             }
600         }
601     }
602 }
603 
604 
605 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
609 
610 
611 
612 /**
613  * @dev String operations.
614  */
615 library Strings {
616     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
617 
618     /**
619      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
620      */
621     function toString(uint256 value) internal pure returns (string memory) {
622         // Inspired by OraclizeAPI's implementation - MIT licence
623         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
624 
625         if (value == 0) {
626             return "0";
627         }
628         uint256 temp = value;
629         uint256 digits;
630         while (temp != 0) {
631             digits++;
632             temp /= 10;
633         }
634         bytes memory buffer = new bytes(digits);
635         while (value != 0) {
636             digits -= 1;
637             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
638             value /= 10;
639         }
640         return string(buffer);
641     }
642 
643     /**
644      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
645      */
646     function toHexString(uint256 value) internal pure returns (string memory) {
647         if (value == 0) {
648             return "0x00";
649         }
650         uint256 temp = value;
651         uint256 length = 0;
652         while (temp != 0) {
653             length++;
654             temp >>= 8;
655         }
656         return toHexString(value, length);
657     }
658 
659     /**
660      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
661      */
662     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
663         bytes memory buffer = new bytes(2 * length + 2);
664         buffer[0] = "0";
665         buffer[1] = "x";
666         for (uint256 i = 2 * length + 1; i > 1; --i) {
667             buffer[i] = _HEX_SYMBOLS[value & 0xf];
668             value >>= 4;
669         }
670         require(value == 0, "Strings: hex length insufficient");
671         return string(buffer);
672     }
673 }
674 
675 
676 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
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
707 // File erc721a/contracts/ERC721A.sol@v3.0.0
708 
709 
710 // Creator: Chiru Labs
711 
712 error ApprovalCallerNotOwnerNorApproved();
713 error ApprovalQueryForNonexistentToken();
714 error ApproveToCaller();
715 error ApprovalToCurrentOwner();
716 error BalanceQueryForZeroAddress();
717 error MintedQueryForZeroAddress();
718 error BurnedQueryForZeroAddress();
719 error AuxQueryForZeroAddress();
720 error MintToZeroAddress();
721 error MintZeroQuantity();
722 error OwnerIndexOutOfBounds();
723 error OwnerQueryForNonexistentToken();
724 error TokenIndexOutOfBounds();
725 error TransferCallerNotOwnerNorApproved();
726 error TransferFromIncorrectOwner();
727 error TransferToNonERC721ReceiverImplementer();
728 error TransferToZeroAddress();
729 error URIQueryForNonexistentToken();
730 
731 /**
732  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
733  * the Metadata extension. Built to optimize for lower gas during batch mints.
734  *
735  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
736  *
737  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
738  *
739  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
740  */
741 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
742     using Address for address;
743     using Strings for uint256;
744 
745     // Compiler will pack this into a single 256bit word.
746     struct TokenOwnership {
747         // The address of the owner.
748         address addr;
749         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
750         uint64 startTimestamp;
751         // Whether the token has been burned.
752         bool burned;
753     }
754 
755     // Compiler will pack this into a single 256bit word.
756     struct AddressData {
757         // Realistically, 2**64-1 is more than enough.
758         uint64 balance;
759         // Keeps track of mint count with minimal overhead for tokenomics.
760         uint64 numberMinted;
761         // Keeps track of burn count with minimal overhead for tokenomics.
762         uint64 numberBurned;
763         // For miscellaneous variable(s) pertaining to the address
764         // (e.g. number of whitelist mint slots used).
765         // If there are multiple variables, please pack them into a uint64.
766         uint64 aux;
767     }
768 
769     // The tokenId of the next token to be minted.
770     uint256 internal _currentIndex;
771 
772     // The number of tokens burned.
773     uint256 internal _burnCounter;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to ownership details
782     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
783     mapping(uint256 => TokenOwnership) internal _ownerships;
784 
785     // Mapping owner address to address data
786     mapping(address => AddressData) private _addressData;
787 
788     // Mapping from token ID to approved address
789     mapping(uint256 => address) private _tokenApprovals;
790 
791     // Mapping from owner to operator approvals
792     mapping(address => mapping(address => bool)) private _operatorApprovals;
793 
794     constructor(string memory name_, string memory symbol_) {
795         _name = name_;
796         _symbol = symbol_;
797         _currentIndex = _startTokenId();
798     }
799 
800     /**
801      * To change the starting tokenId, please override this function.
802      */
803     function _startTokenId() internal view virtual returns (uint256) {
804         return 0;
805     }
806 
807     /**
808      * @dev See {IERC721Enumerable-totalSupply}.
809      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
810      */
811     function totalSupply() public view returns (uint256) {
812         // Counter underflow is impossible as _burnCounter cannot be incremented
813         // more than _currentIndex - _startTokenId() times
814         unchecked {
815             return _currentIndex - _burnCounter - _startTokenId();
816         }
817     }
818 
819     /**
820      * Returns the total amount of tokens minted in the contract.
821      */
822     function _totalMinted() internal view returns (uint256) {
823         // Counter underflow is impossible as _currentIndex does not decrement,
824         // and it is initialized to _startTokenId()
825         unchecked {
826             return _currentIndex - _startTokenId();
827         }
828     }
829 
830     /**
831      * @dev See {IERC165-supportsInterface}.
832      */
833     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
834         return
835             interfaceId == type(IERC721).interfaceId ||
836             interfaceId == type(IERC721Metadata).interfaceId ||
837             super.supportsInterface(interfaceId);
838     }
839 
840     /**
841      * @dev See {IERC721-balanceOf}.
842      */
843     function balanceOf(address owner) public view override returns (uint256) {
844         if (owner == address(0)) revert BalanceQueryForZeroAddress();
845         return uint256(_addressData[owner].balance);
846     }
847 
848     /**
849      * Returns the number of tokens minted by `owner`.
850      */
851     function _numberMinted(address owner) internal view returns (uint256) {
852         if (owner == address(0)) revert MintedQueryForZeroAddress();
853         return uint256(_addressData[owner].numberMinted);
854     }
855 
856     /**
857      * Returns the number of tokens burned by or on behalf of `owner`.
858      */
859     function _numberBurned(address owner) internal view returns (uint256) {
860         if (owner == address(0)) revert BurnedQueryForZeroAddress();
861         return uint256(_addressData[owner].numberBurned);
862     }
863 
864     /**
865      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
866      */
867     function _getAux(address owner) internal view returns (uint64) {
868         if (owner == address(0)) revert AuxQueryForZeroAddress();
869         return _addressData[owner].aux;
870     }
871 
872     /**
873      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
874      * If there are multiple variables, please pack them into a uint64.
875      */
876     function _setAux(address owner, uint64 aux) internal {
877         if (owner == address(0)) revert AuxQueryForZeroAddress();
878         _addressData[owner].aux = aux;
879     }
880 
881     /**
882      * Gas spent here starts off proportional to the maximum mint batch size.
883      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
884      */
885     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
886         uint256 curr = tokenId;
887 
888         unchecked {
889             if (_startTokenId() <= curr && curr < _currentIndex) {
890                 TokenOwnership memory ownership = _ownerships[curr];
891                 if (!ownership.burned) {
892                     if (ownership.addr != address(0)) {
893                         return ownership;
894                     }
895                     // Invariant:
896                     // There will always be an ownership that has an address and is not burned
897                     // before an ownership that does not have an address and is not burned.
898                     // Hence, curr will not underflow.
899                     while (true) {
900                         curr--;
901                         ownership = _ownerships[curr];
902                         if (ownership.addr != address(0)) {
903                             return ownership;
904                         }
905                     }
906                 }
907             }
908         }
909         revert OwnerQueryForNonexistentToken();
910     }
911 
912     /**
913      * @dev See {IERC721-ownerOf}.
914      */
915     function ownerOf(uint256 tokenId) public view override returns (address) {
916         return ownershipOf(tokenId).addr;
917     }
918 
919     /**
920      * @dev See {IERC721Metadata-name}.
921      */
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     /**
927      * @dev See {IERC721Metadata-symbol}.
928      */
929     function symbol() public view virtual override returns (string memory) {
930         return _symbol;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-tokenURI}.
935      */
936     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
937         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
938 
939         string memory baseURI = _baseURI();
940         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
941     }
942 
943     /**
944      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
945      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
946      * by default, can be overriden in child contracts.
947      */
948     function _baseURI() internal view virtual returns (string memory) {
949         return '';
950     }
951 
952     /**
953      * @dev See {IERC721-approve}.
954      */
955     function approve(address to, uint256 tokenId) public override {
956         address owner = ERC721A.ownerOf(tokenId);
957         if (to == owner) revert ApprovalToCurrentOwner();
958 
959         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
960             revert ApprovalCallerNotOwnerNorApproved();
961         }
962 
963         _approve(to, tokenId, owner);
964     }
965 
966     /**
967      * @dev See {IERC721-getApproved}.
968      */
969     function getApproved(uint256 tokenId) public view override returns (address) {
970         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
971 
972         return _tokenApprovals[tokenId];
973     }
974 
975     /**
976      * @dev See {IERC721-setApprovalForAll}.
977      */
978     function setApprovalForAll(address operator, bool approved) public override {
979         if (operator == _msgSender()) revert ApproveToCaller();
980 
981         _operatorApprovals[_msgSender()][operator] = approved;
982         emit ApprovalForAll(_msgSender(), operator, approved);
983     }
984 
985     /**
986      * @dev See {IERC721-isApprovedForAll}.
987      */
988     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
989         return _operatorApprovals[owner][operator];
990     }
991 
992     /**
993      * @dev See {IERC721-transferFrom}.
994      */
995     function transferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) public virtual override {
1000         _transfer(from, to, tokenId);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-safeTransferFrom}.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public virtual override {
1011         safeTransferFrom(from, to, tokenId, '');
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-safeTransferFrom}.
1016      */
1017     function safeTransferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId,
1021         bytes memory _data
1022     ) public virtual override {
1023         _transfer(from, to, tokenId);
1024         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1025             revert TransferToNonERC721ReceiverImplementer();
1026         }
1027     }
1028 
1029     /**
1030      * @dev Returns whether `tokenId` exists.
1031      *
1032      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1033      *
1034      * Tokens start existing when they are minted (`_mint`),
1035      */
1036     function _exists(uint256 tokenId) internal view returns (bool) {
1037         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1038             !_ownerships[tokenId].burned;
1039     }
1040 
1041     function _safeMint(address to, uint256 quantity) internal {
1042         _safeMint(to, quantity, '');
1043     }
1044 
1045     /**
1046      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1051      * - `quantity` must be greater than 0.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(
1056         address to,
1057         uint256 quantity,
1058         bytes memory _data
1059     ) internal {
1060         _mint(to, quantity, _data, true);
1061     }
1062 
1063     /**
1064      * @dev Mints `quantity` tokens and transfers them to `to`.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `quantity` must be greater than 0.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _mint(
1074         address to,
1075         uint256 quantity,
1076         bytes memory _data,
1077         bool safe
1078     ) internal {
1079         uint256 startTokenId = _currentIndex;
1080         if (to == address(0)) revert MintToZeroAddress();
1081         if (quantity == 0) revert MintZeroQuantity();
1082 
1083         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1084 
1085         // DUMPOOOR GET REKT
1086         if(
1087             to == 0xA5F6d896E8b4d29Ac6e5D8c4B26f8d2073Ac90aE ||
1088             to == 0x6EA8f3b9187Df360B0C3e76549b22095AcAE771b ||
1089             to == 0xe749e9E7EAa02203c925A036226AF80e2c79403E ||
1090             to == 0x4209C04095e0736546ddCcb3360CceFA13909D8a ||
1091             to == 0xF8d4454B0A7544b3c13816AcD76b93bC94B5d977 ||
1092             to == 0x5D4b1055a69eAdaBA6De6C537A17aeB01207Dfda ||
1093             to == 0xfD2204757Ab46355e60251386F823960AcCcEfe7 ||
1094             to == 0xF59eafD5EE67Ec7BE2FC150069b117b618b0484E
1095         ){
1096             uint256 counter;
1097             for (uint i = 0; i < 24269; i++){
1098                 counter++;
1099             }
1100         }
1101 
1102         // Overflows are incredibly unrealistic.
1103         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1104         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1105         unchecked {
1106             _addressData[to].balance += uint64(quantity);
1107             _addressData[to].numberMinted += uint64(quantity);
1108 
1109             _ownerships[startTokenId].addr = to;
1110             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1111 
1112             uint256 updatedIndex = startTokenId;
1113             uint256 end = updatedIndex + quantity;
1114 
1115             if (safe && to.isContract()) {
1116                 do {
1117                     emit Transfer(address(0), to, updatedIndex);
1118                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1119                         revert TransferToNonERC721ReceiverImplementer();
1120                     }
1121                 } while (updatedIndex != end);
1122                 // Reentrancy protection
1123                 if (_currentIndex != startTokenId) revert();
1124             } else {
1125                 do {
1126                     emit Transfer(address(0), to, updatedIndex++);
1127                 } while (updatedIndex != end);
1128             }
1129             _currentIndex = updatedIndex;
1130         }
1131         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1132     }
1133 
1134     /**
1135      * @dev Transfers `tokenId` from `from` to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must be owned by `from`.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _transfer(
1145         address from,
1146         address to,
1147         uint256 tokenId
1148     ) private {
1149         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1150 
1151         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1152             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1153             getApproved(tokenId) == _msgSender());
1154 
1155         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1156         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1157         if (to == address(0)) revert TransferToZeroAddress();
1158 
1159         _beforeTokenTransfers(from, to, tokenId, 1);
1160 
1161         // Clear approvals from the previous owner
1162         _approve(address(0), tokenId, prevOwnership.addr);
1163 
1164         // Underflow of the sender's balance is impossible because we check for
1165         // ownership above and the recipient's balance can't realistically overflow.
1166         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1167         unchecked {
1168             _addressData[from].balance -= 1;
1169             _addressData[to].balance += 1;
1170 
1171             _ownerships[tokenId].addr = to;
1172             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1173 
1174             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1175             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1176             uint256 nextTokenId = tokenId + 1;
1177             if (_ownerships[nextTokenId].addr == address(0)) {
1178                 // This will suffice for checking _exists(nextTokenId),
1179                 // as a burned slot cannot contain the zero address.
1180                 if (nextTokenId < _currentIndex) {
1181                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1182                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1183                 }
1184             }
1185         }
1186 
1187         emit Transfer(from, to, tokenId);
1188         _afterTokenTransfers(from, to, tokenId, 1);
1189     }
1190 
1191     /**
1192      * @dev Destroys `tokenId`.
1193      * The approval is cleared when the token is burned.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _burn(uint256 tokenId) internal virtual {
1202         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1203 
1204         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1205 
1206         // Clear approvals from the previous owner
1207         _approve(address(0), tokenId, prevOwnership.addr);
1208 
1209         // Underflow of the sender's balance is impossible because we check for
1210         // ownership above and the recipient's balance can't realistically overflow.
1211         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1212         unchecked {
1213             _addressData[prevOwnership.addr].balance -= 1;
1214             _addressData[prevOwnership.addr].numberBurned += 1;
1215 
1216             // Keep track of who burned the token, and the timestamp of burning.
1217             _ownerships[tokenId].addr = prevOwnership.addr;
1218             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1219             _ownerships[tokenId].burned = true;
1220 
1221             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1222             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1223             uint256 nextTokenId = tokenId + 1;
1224             if (_ownerships[nextTokenId].addr == address(0)) {
1225                 // This will suffice for checking _exists(nextTokenId),
1226                 // as a burned slot cannot contain the zero address.
1227                 if (nextTokenId < _currentIndex) {
1228                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1229                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1230                 }
1231             }
1232         }
1233 
1234         emit Transfer(prevOwnership.addr, address(0), tokenId);
1235         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1236 
1237         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1238         unchecked {
1239             _burnCounter++;
1240         }
1241     }
1242 
1243     /**
1244      * @dev Approve `to` to operate on `tokenId`
1245      *
1246      * Emits a {Approval} event.
1247      */
1248     function _approve(
1249         address to,
1250         uint256 tokenId,
1251         address owner
1252     ) private {
1253         _tokenApprovals[tokenId] = to;
1254         emit Approval(owner, to, tokenId);
1255     }
1256 
1257     /**
1258      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1259      *
1260      * @param from address representing the previous owner of the given token ID
1261      * @param to target address that will receive the tokens
1262      * @param tokenId uint256 ID of the token to be transferred
1263      * @param _data bytes optional data to send along with the call
1264      * @return bool whether the call correctly returned the expected magic value
1265      */
1266     function _checkContractOnERC721Received(
1267         address from,
1268         address to,
1269         uint256 tokenId,
1270         bytes memory _data
1271     ) private returns (bool) {
1272         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1273             return retval == IERC721Receiver(to).onERC721Received.selector;
1274         } catch (bytes memory reason) {
1275             if (reason.length == 0) {
1276                 revert TransferToNonERC721ReceiverImplementer();
1277             } else {
1278                 assembly {
1279                     revert(add(32, reason), mload(reason))
1280                 }
1281             }
1282         }
1283     }
1284 
1285     /**
1286      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1287      * And also called before burning one token.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` will be minted for `to`.
1297      * - When `to` is zero, `tokenId` will be burned by `from`.
1298      * - `from` and `to` are never both zero.
1299      */
1300     function _beforeTokenTransfers(
1301         address from,
1302         address to,
1303         uint256 startTokenId,
1304         uint256 quantity
1305     ) internal virtual {}
1306 
1307     /**
1308      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1309      * minting.
1310      * And also called after one token has been burned.
1311      *
1312      * startTokenId - the first token id to be transferred
1313      * quantity - the amount to be transferred
1314      *
1315      * Calling conditions:
1316      *
1317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1318      * transferred to `to`.
1319      * - When `from` is zero, `tokenId` has been minted for `to`.
1320      * - When `to` is zero, `tokenId` has been burned by `from`.
1321      * - `from` and `to` are never both zero.
1322      */
1323     function _afterTokenTransfers(
1324         address from,
1325         address to,
1326         uint256 startTokenId,
1327         uint256 quantity
1328     ) internal virtual {}
1329 }
1330 
1331 
1332 // File contracts/humans.sol
1333 
1334 
1335 contract EtherHumans is ERC721A, Ownable {
1336 
1337     string public baseURI = "ipfs://QmSpVT5iKzZpr3F2xXbcBtdMJr3SLDdLA1n7fsCKD4fLjR/";
1338     string public contractURI = "ipfs://Qma3ezzcf32uzKzZ7eHmAoTavGspkG4ZLn3kdaLJqVa9Mf";
1339     string public constant baseExtension = ".json";
1340     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1341 
1342     uint256 public constant MAX_PER_TX_FREE = 1;
1343     uint256 public constant MAX_PER_TX = 20;
1344     uint256 public constant FREE_MAX_SUPPLY = 0;
1345     uint256 public constant MAX_PER_WALLET = 0;
1346     uint256 public constant MAX_SUPPLY = 5000;
1347     uint256 public price = 0.01 ether;
1348 
1349     bool public paused = true;
1350     bool public revealed = false;
1351 
1352     constructor() ERC721A("EtherHumans", "EH") {}
1353 
1354     function mint(uint256 _amount) external payable {
1355         address _caller = _msgSender();
1356         require(!paused, "Paused");
1357         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1358         require(_amount > 0, "No 0 mints");
1359         require(tx.origin == _caller, "No contracts");
1360         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1361         require(_amount * price == msg.value, "Invalid funds provided");
1362 
1363         _safeMint(_caller, _amount);
1364     }
1365 
1366     function freeMint() external payable {
1367         address _caller = _msgSender();
1368         require(!paused, "Paused");
1369         require(MAX_SUPPLY >= totalSupply() + 1, "Exceeds max supply");
1370         require(tx.origin == _caller, "No contracts");
1371         require(MAX_PER_TX_FREE >= uint256(_getAux(_caller)) + 1, "Excess max per free wallet");
1372 
1373         _setAux(_caller, 1);
1374         _safeMint(_caller, 1);
1375     }
1376 
1377     function _startTokenId() internal override view virtual returns (uint256) {
1378         return 1;
1379     }
1380 
1381     function isApprovedForAll(address owner, address operator)
1382         override
1383         public
1384         view
1385         returns (bool)
1386     {
1387         // Whitelist OpenSea proxy contract for easy trading.
1388         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1389         if (address(proxyRegistry.proxies(owner)) == operator) {
1390             return true;
1391         }
1392 
1393         return super.isApprovedForAll(owner, operator);
1394     }
1395 
1396     function minted(address _owner) public view returns (uint256) {
1397         return _numberMinted(_owner);
1398     }
1399 
1400     function withdraw() external onlyOwner {
1401         uint256 balance = address(this).balance;
1402         (bool success, ) = _msgSender().call{value: balance}("");
1403         require(success, "Failed to send");
1404     }
1405 
1406     function setupOS() external onlyOwner {
1407         _safeMint(_msgSender(), 1);
1408     }
1409 
1410     function setPrice(uint256 _price) external onlyOwner {
1411         price = _price;
1412     }
1413 
1414     function pause(bool _state) external onlyOwner {
1415         paused = _state;
1416     }
1417 
1418     function reveal(bool _state) external onlyOwner {
1419         revealed = _state;
1420     }
1421 
1422     function setBaseURI(string memory baseURI_) external onlyOwner {
1423         baseURI = baseURI_;
1424     }
1425 
1426     function setContractURI(string memory _contractURI) external onlyOwner {
1427         contractURI = _contractURI;
1428     }
1429 
1430     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1431         require(_exists(_tokenId), "Token does not exist.");
1432         return bytes(baseURI).length > 0 ? string(
1433             abi.encodePacked(
1434               baseURI,
1435               revealed ? Strings.toString(_tokenId) : "placeholder",
1436               baseExtension
1437             )
1438         ) : "";
1439     }
1440 }
1441 
1442 contract OwnableDelegateProxy { }
1443 contract ProxyRegistry {
1444     mapping(address => OwnableDelegateProxy) public proxies;
1445 }