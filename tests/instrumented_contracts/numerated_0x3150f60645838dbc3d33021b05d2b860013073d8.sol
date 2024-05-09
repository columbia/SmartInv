1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 
93 
94 /**
95  * @dev Required interface of an ERC721 compliant contract.
96  */
97 interface IERC721 is IERC165 {
98     /**
99      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102 
103     /**
104      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
105      */
106     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
110      */
111     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
112 
113     /**
114      * @dev Returns the number of tokens in ``owner``'s account.
115      */
116     function balanceOf(address owner) external view returns (uint256 balance);
117 
118     /**
119      * @dev Returns the owner of the `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function ownerOf(uint256 tokenId) external view returns (address owner);
126 
127     /**
128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must exist and be owned by `from`.
136      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
138      *
139      * Emits a {Transfer} event.
140      */
141     function safeTransferFrom(
142         address from,
143         address to,
144         uint256 tokenId
145     ) external;
146 
147     /**
148      * @dev Transfers `tokenId` token from `from` to `to`.
149      *
150      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
169      * The approval is cleared when the token is transferred.
170      *
171      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
172      *
173      * Requirements:
174      *
175      * - The caller must own the token or be an approved operator.
176      * - `tokenId` must exist.
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address to, uint256 tokenId) external;
181 
182     /**
183      * @dev Returns the account approved for `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function getApproved(uint256 tokenId) external view returns (address operator);
190 
191     /**
192      * @dev Approve or remove `operator` as an operator for the caller.
193      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
194      *
195      * Requirements:
196      *
197      * - The `operator` cannot be the caller.
198      *
199      * Emits an {ApprovalForAll} event.
200      */
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     /**
204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
205      *
206      * See {setApprovalForAll}
207      */
208     function isApprovedForAll(address owner, address operator) external view returns (bool);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must exist and be owned by `from`.
218      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220      *
221      * Emits a {Transfer} event.
222      */
223     function safeTransferFrom(
224         address from,
225         address to,
226         uint256 tokenId,
227         bytes calldata data
228     ) external;
229 }
230 
231 
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 
257 
258 /**
259  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
260  * @dev See https://eips.ethereum.org/EIPS/eip-721
261  */
262 interface IERC721Metadata is IERC721 {
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 
280 
281 /**
282  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
283  * @dev See https://eips.ethereum.org/EIPS/eip-721
284  */
285 interface IERC721Enumerable is IERC721 {
286     /**
287      * @dev Returns the total amount of tokens stored by the contract.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     /**
292      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
293      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
294      */
295     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
296 
297     /**
298      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
299      * Use along with {totalSupply} to enumerate all tokens.
300      */
301     function tokenByIndex(uint256 index) external view returns (uint256);
302 }
303 
304 
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      *
327      * [IMPORTANT]
328      * ====
329      * You shouldn't rely on `isContract` to protect against flash loan attacks!
330      *
331      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
332      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
333      * constructor.
334      * ====
335      */
336     function isContract(address account) internal view returns (bool) {
337         // This method relies on extcodesize/address.code.length, which returns 0
338         // for contracts in construction, since the code is only stored at the end
339         // of the constructor execution.
340 
341         return account.code.length > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         (bool success, ) = recipient.call{value: amount}("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.call{value: value}(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 
525 
526 /**
527  * @dev Provides information about the current execution context, including the
528  * sender of the transaction and its data. While these are generally available
529  * via msg.sender and msg.data, they should not be accessed in such a direct
530  * manner, since when dealing with meta-transactions the account sending and
531  * paying for execution may not be the actual sender (as far as an application
532  * is concerned).
533  *
534  * This contract is only required for intermediate, library-like contracts.
535  */
536 abstract contract Context {
537     function _msgSender() internal view virtual returns (address) {
538         return msg.sender;
539     }
540 
541     function _msgData() internal view virtual returns (bytes calldata) {
542         return msg.data;
543     }
544 }
545 
546 
547 
548 /**
549  * @dev Contract module which provides a basic access control mechanism, where
550  * there is an account (an owner) that can be granted exclusive access to
551  * specific functions.
552  *
553  * By default, the owner account will be the one that deploys the contract. This
554  * can later be changed with {transferOwnership}.
555  *
556  * This module is used through inheritance. It will make available the modifier
557  * `onlyOwner`, which can be applied to your functions to restrict their use to
558  * the owner.
559  */
560 abstract contract Ownable is Context {
561     address private _owner;
562 
563     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
564 
565     /**
566      * @dev Initializes the contract setting the deployer as the initial owner.
567      */
568     constructor() {
569         _transferOwnership(_msgSender());
570     }
571 
572     /**
573      * @dev Returns the address of the current owner.
574      */
575     function owner() public view virtual returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(owner() == _msgSender(), "Ownable: caller is not the owner");
584         _;
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         _transferOwnership(address(0));
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 
619 
620 /**
621  * @dev Contract module that helps prevent reentrant calls to a function.
622  *
623  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
624  * available, which can be applied to functions to make sure there are no nested
625  * (reentrant) calls to them.
626  *
627  * Note that because there is a single `nonReentrant` guard, functions marked as
628  * `nonReentrant` may not call one another. This can be worked around by making
629  * those functions `private`, and then adding `external` `nonReentrant` entry
630  * points to them.
631  *
632  * TIP: If you would like to learn more about reentrancy and alternative ways
633  * to protect against it, check out our blog post
634  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
635  */
636 abstract contract ReentrancyGuard {
637     // Booleans are more expensive than uint256 or any type that takes up a full
638     // word because each write operation emits an extra SLOAD to first read the
639     // slot's contents, replace the bits taken up by the boolean, and then write
640     // back. This is the compiler's defense against contract upgrades and
641     // pointer aliasing, and it cannot be disabled.
642 
643     // The values being non-zero value makes deployment a bit more expensive,
644     // but in exchange the refund on every call to nonReentrant will be lower in
645     // amount. Since refunds are capped to a percentage of the total
646     // transaction's gas, it is best to keep them low in cases like this one, to
647     // increase the likelihood of the full refund coming into effect.
648     uint256 private constant _NOT_ENTERED = 1;
649     uint256 private constant _ENTERED = 2;
650 
651     uint256 private _status;
652 
653     constructor() {
654         _status = _NOT_ENTERED;
655     }
656 
657     /**
658      * @dev Prevents a contract from calling itself, directly or indirectly.
659      * Calling a `nonReentrant` function from another `nonReentrant`
660      * function is not supported. It is possible to prevent this from happening
661      * by making the `nonReentrant` function external, and making it call a
662      * `private` function that does the actual work.
663      */
664     modifier nonReentrant() {
665         // On the first call to nonReentrant, _notEntered will be true
666         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
667 
668         // Any calls to nonReentrant after this point will fail
669         _status = _ENTERED;
670 
671         _;
672 
673         // By storing the original value once again, a refund is triggered (see
674         // https://eips.ethereum.org/EIPS/eip-2200)
675         _status = _NOT_ENTERED;
676     }
677 }
678 
679 
680 
681 /**
682  * @dev Implementation of the {IERC165} interface.
683  *
684  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
685  * for the additional interface id that will be supported. For example:
686  *
687  * ```solidity
688  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
689  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
690  * }
691  * ```
692  *
693  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
694  */
695 abstract contract ERC165 is IERC165 {
696     /**
697      * @dev See {IERC165-supportsInterface}.
698      */
699     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
700         return interfaceId == type(IERC165).interfaceId;
701     }
702 }
703 
704 
705 
706 error ApprovalCallerNotOwnerNorApproved();
707 error ApprovalQueryForNonexistentToken();
708 error ApproveToCaller();
709 error ApprovalToCurrentOwner();
710 error BalanceQueryForZeroAddress();
711 error MintedQueryForZeroAddress();
712 error BurnedQueryForZeroAddress();
713 error AuxQueryForZeroAddress();
714 error MintToZeroAddress();
715 error MintZeroQuantity();
716 error OwnerIndexOutOfBounds();
717 error OwnerQueryForNonexistentToken();
718 error TokenIndexOutOfBounds();
719 error TransferCallerNotOwnerNorApproved();
720 error TransferFromIncorrectOwner();
721 error TransferToNonERC721ReceiverImplementer();
722 error TransferToZeroAddress();
723 error URIQueryForNonexistentToken();
724 
725 /**
726  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
727  * the Metadata extension. Built to optimize for lower gas during batch mints.
728  *
729  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
730  *
731  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
732  *
733  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
734  */
735 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
736     using Address for address;
737     using Strings for uint256;
738 
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
788     constructor(string memory name_, string memory symbol_) {
789         _name = name_;
790         _symbol = symbol_;
791     }
792 
793     /**
794      * @dev See {IERC721Enumerable-totalSupply}.
795      */
796     function totalSupply() public view returns (uint256) {
797         // Counter underflow is impossible as _burnCounter cannot be incremented
798         // more than _currentIndex times
799         unchecked {
800             return _currentIndex - _burnCounter;    
801         }
802     }
803 
804     /**
805      * @dev See {IERC165-supportsInterface}.
806      */
807     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
808         return
809             interfaceId == type(IERC721).interfaceId ||
810             interfaceId == type(IERC721Metadata).interfaceId ||
811             super.supportsInterface(interfaceId);
812     }
813 
814     /**
815      * @dev See {IERC721-balanceOf}.
816      */
817     function balanceOf(address owner) public view override returns (uint256) {
818         if (owner == address(0)) revert BalanceQueryForZeroAddress();
819         return uint256(_addressData[owner].balance);
820     }
821 
822     /**
823      * Returns the number of tokens minted by `owner`.
824      */
825     function _numberMinted(address owner) internal view returns (uint256) {
826         if (owner == address(0)) revert MintedQueryForZeroAddress();
827         return uint256(_addressData[owner].numberMinted);
828     }
829 
830     /**
831      * Returns the number of tokens burned by or on behalf of `owner`.
832      */
833     function _numberBurned(address owner) internal view returns (uint256) {
834         if (owner == address(0)) revert BurnedQueryForZeroAddress();
835         return uint256(_addressData[owner].numberBurned);
836     }
837 
838     /**
839      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
840      */
841     function _getAux(address owner) internal view returns (uint64) {
842         if (owner == address(0)) revert AuxQueryForZeroAddress();
843         return _addressData[owner].aux;
844     }
845 
846     /**
847      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
848      * If there are multiple variables, please pack them into a uint64.
849      */
850     function _setAux(address owner, uint64 aux) internal {
851         if (owner == address(0)) revert AuxQueryForZeroAddress();
852         _addressData[owner].aux = aux;
853     }
854 
855     /**
856      * Gas spent here starts off proportional to the maximum mint batch size.
857      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
858      */
859     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
860         uint256 curr = tokenId;
861 
862         unchecked {
863             if (curr < _currentIndex) {
864                 TokenOwnership memory ownership = _ownerships[curr];
865                 if (!ownership.burned) {
866                     if (ownership.addr != address(0)) {
867                         return ownership;
868                     }
869                     // Invariant: 
870                     // There will always be an ownership that has an address and is not burned 
871                     // before an ownership that does not have an address and is not burned.
872                     // Hence, curr will not underflow.
873                     while (true) {
874                         curr--;
875                         ownership = _ownerships[curr];
876                         if (ownership.addr != address(0)) {
877                             return ownership;
878                         }
879                     }
880                 }
881             }
882         }
883         revert OwnerQueryForNonexistentToken();
884     }
885 
886     /**
887      * @dev See {IERC721-ownerOf}.
888      */
889     function ownerOf(uint256 tokenId) public view override returns (address) {
890         return ownershipOf(tokenId).addr;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-name}.
895      */
896     function name() public view virtual override returns (string memory) {
897         return _name;
898     }
899 
900     /**
901      * @dev See {IERC721Metadata-symbol}.
902      */
903     function symbol() public view virtual override returns (string memory) {
904         return _symbol;
905     }
906 
907     /**
908      * @dev See {IERC721Metadata-tokenURI}.
909      */
910     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
911         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
912 
913         string memory baseURI = _baseURI();
914         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
915     }
916 
917     /**
918      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
919      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
920      * by default, can be overriden in child contracts.
921      */
922     function _baseURI() internal view virtual returns (string memory) {
923         return '';
924     }
925 
926     /**
927      * @dev See {IERC721-approve}.
928      */
929     function approve(address to, uint256 tokenId) public override {
930         address owner = ERC721A.ownerOf(tokenId);
931         if (to == owner) revert ApprovalToCurrentOwner();
932 
933         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
934             revert ApprovalCallerNotOwnerNorApproved();
935         }
936 
937         _approve(to, tokenId, owner);
938     }
939 
940     /**
941      * @dev See {IERC721-getApproved}.
942      */
943     function getApproved(uint256 tokenId) public view override returns (address) {
944         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
945 
946         return _tokenApprovals[tokenId];
947     }
948 
949     /**
950      * @dev See {IERC721-setApprovalForAll}.
951      */
952     function setApprovalForAll(address operator, bool approved) public override {
953         if (operator == _msgSender()) revert ApproveToCaller();
954 
955         _operatorApprovals[_msgSender()][operator] = approved;
956         emit ApprovalForAll(_msgSender(), operator, approved);
957     }
958 
959     /**
960      * @dev See {IERC721-isApprovedForAll}.
961      */
962     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
963         return _operatorApprovals[owner][operator];
964     }
965 
966     /**
967      * @dev See {IERC721-transferFrom}.
968      */
969     function transferFrom(
970         address from,
971         address to,
972         uint256 tokenId
973     ) public virtual override {
974         _transfer(from, to, tokenId);
975     }
976 
977     /**
978      * @dev See {IERC721-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId
984     ) public virtual override {
985         safeTransferFrom(from, to, tokenId, '');
986     }
987 
988     /**
989      * @dev See {IERC721-safeTransferFrom}.
990      */
991     function safeTransferFrom(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) public virtual override {
997         _transfer(from, to, tokenId);
998         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
999             revert TransferToNonERC721ReceiverImplementer();
1000         }
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      */
1010     function _exists(uint256 tokenId) internal view returns (bool) {
1011         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1012     }
1013 
1014     function _safeMint(address to, uint256 quantity) internal {
1015         _safeMint(to, quantity, '');
1016     }
1017 
1018     /**
1019      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1024      * - `quantity` must be greater than 0.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _safeMint(
1029         address to,
1030         uint256 quantity,
1031         bytes memory _data
1032     ) internal {
1033         _mint(to, quantity, _data, true);
1034     }
1035 
1036     /**
1037      * @dev Mints `quantity` tokens and transfers them to `to`.
1038      *
1039      * Requirements:
1040      *
1041      * - `to` cannot be the zero address.
1042      * - `quantity` must be greater than 0.
1043      *
1044      * Emits a {Transfer} event.
1045      */
1046     function _mint(
1047         address to,
1048         uint256 quantity,
1049         bytes memory _data,
1050         bool safe
1051     ) internal {
1052         uint256 startTokenId = _currentIndex;
1053         if (to == address(0)) revert MintToZeroAddress();
1054         if (quantity == 0) revert MintZeroQuantity();
1055 
1056         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1057 
1058         // Overflows are incredibly unrealistic.
1059         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1060         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1061         unchecked {
1062             _addressData[to].balance += uint64(quantity);
1063             _addressData[to].numberMinted += uint64(quantity);
1064 
1065             _ownerships[startTokenId].addr = to;
1066             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1067 
1068             uint256 updatedIndex = startTokenId;
1069 
1070             for (uint256 i; i < quantity; i++) {
1071                 emit Transfer(address(0), to, updatedIndex);
1072                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1073                     revert TransferToNonERC721ReceiverImplementer();
1074                 }
1075                 updatedIndex++;
1076             }
1077 
1078             _currentIndex = updatedIndex;
1079         }
1080         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1081     }
1082 
1083     /**
1084      * @dev Transfers `tokenId` from `from` to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must be owned by `from`.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 tokenId
1097     ) private {
1098         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1099 
1100         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1101             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1102             getApproved(tokenId) == _msgSender());
1103 
1104         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1105         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1106         if (to == address(0)) revert TransferToZeroAddress();
1107 
1108         _beforeTokenTransfers(from, to, tokenId, 1);
1109 
1110         // Clear approvals from the previous owner
1111         _approve(address(0), tokenId, prevOwnership.addr);
1112 
1113         // Underflow of the sender's balance is impossible because we check for
1114         // ownership above and the recipient's balance can't realistically overflow.
1115         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1116         unchecked {
1117             _addressData[from].balance -= 1;
1118             _addressData[to].balance += 1;
1119 
1120             _ownerships[tokenId].addr = to;
1121             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1122 
1123             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1124             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1125             uint256 nextTokenId = tokenId + 1;
1126             if (_ownerships[nextTokenId].addr == address(0)) {
1127                 // This will suffice for checking _exists(nextTokenId),
1128                 // as a burned slot cannot contain the zero address.
1129                 if (nextTokenId < _currentIndex) {
1130                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1131                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1132                 }
1133             }
1134         }
1135 
1136         emit Transfer(from, to, tokenId);
1137         _afterTokenTransfers(from, to, tokenId, 1);
1138     }
1139 
1140     /**
1141      * @dev Destroys `tokenId`.
1142      * The approval is cleared when the token is burned.
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must exist.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _burn(uint256 tokenId) internal virtual {
1151         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1152 
1153         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1154 
1155         // Clear approvals from the previous owner
1156         _approve(address(0), tokenId, prevOwnership.addr);
1157 
1158         // Underflow of the sender's balance is impossible because we check for
1159         // ownership above and the recipient's balance can't realistically overflow.
1160         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1161         unchecked {
1162             _addressData[prevOwnership.addr].balance -= 1;
1163             _addressData[prevOwnership.addr].numberBurned += 1;
1164 
1165             // Keep track of who burned the token, and the timestamp of burning.
1166             _ownerships[tokenId].addr = prevOwnership.addr;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168             _ownerships[tokenId].burned = true;
1169 
1170             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1171             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1172             uint256 nextTokenId = tokenId + 1;
1173             if (_ownerships[nextTokenId].addr == address(0)) {
1174                 // This will suffice for checking _exists(nextTokenId),
1175                 // as a burned slot cannot contain the zero address.
1176                 if (nextTokenId < _currentIndex) {
1177                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1178                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1179                 }
1180             }
1181         }
1182 
1183         emit Transfer(prevOwnership.addr, address(0), tokenId);
1184         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1185 
1186         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1187         unchecked { 
1188             _burnCounter++;
1189         }
1190     }
1191 
1192     /**
1193      * @dev Approve `to` to operate on `tokenId`
1194      *
1195      * Emits a {Approval} event.
1196      */
1197     function _approve(
1198         address to,
1199         uint256 tokenId,
1200         address owner
1201     ) private {
1202         _tokenApprovals[tokenId] = to;
1203         emit Approval(owner, to, tokenId);
1204     }
1205 
1206     /**
1207      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1208      * The call is not executed if the target address is not a contract.
1209      *
1210      * @param from address representing the previous owner of the given token ID
1211      * @param to target address that will receive the tokens
1212      * @param tokenId uint256 ID of the token to be transferred
1213      * @param _data bytes optional data to send along with the call
1214      * @return bool whether the call correctly returned the expected magic value
1215      */
1216     function _checkOnERC721Received(
1217         address from,
1218         address to,
1219         uint256 tokenId,
1220         bytes memory _data
1221     ) private returns (bool) {
1222         if (to.isContract()) {
1223             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1224                 return retval == IERC721Receiver(to).onERC721Received.selector;
1225             } catch (bytes memory reason) {
1226                 if (reason.length == 0) {
1227                     revert TransferToNonERC721ReceiverImplementer();
1228                 } else {
1229                     assembly {
1230                         revert(add(32, reason), mload(reason))
1231                     }
1232                 }
1233             }
1234         } else {
1235             return true;
1236         }
1237     }
1238 
1239     /**
1240      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1241      * And also called before burning one token.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, `tokenId` will be burned by `from`.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1263      * minting.
1264      * And also called after one token has been burned.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` has been minted for `to`.
1274      * - When `to` is zero, `tokenId` has been burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _afterTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 }
1284 
1285 interface IStaking {
1286     function getStakeOwner(uint256 _id) external view returns(address);
1287     function getStakeTime(uint256 _id) external view returns(uint256);
1288 }
1289       
1290 contract AtlanteanParcelPass is ERC721A, Ownable, ReentrancyGuard {
1291     using Strings for uint256;
1292 
1293     string  public baseURI;
1294     uint256 public maxSupply     = 5000;
1295     uint256 public minStakedTime = 1_641_600; 
1296     bool    public paused        = false;
1297 
1298     mapping(uint256 => bool) atlanteanAlreadyClaimed;
1299 
1300     IStaking public staking;
1301 
1302     constructor() ERC721A("Atlantean Parcel Pass", "APP") {
1303         staking = IStaking(0x45235D72a7786Db0320D8227BEDF95Eb273977E9);
1304     }
1305 
1306     function claim(uint256 _atlanteanId) public nonReentrant {
1307         address caller = msg.sender;
1308 
1309         require(!paused, "Contract is paused!");
1310         require(totalSupply() < maxSupply, "Max supply exceeded!");
1311         require(atlanteanAlreadyClaimed[_atlanteanId] == false, "Max land per Atlantean exceeded!");
1312         require(staking.getStakeOwner(_atlanteanId) == caller, "Caller not owner of NFT!");
1313         require(staking.getStakeTime(_atlanteanId) > minStakedTime, "NFT is staked less than 19 days!");
1314 
1315         atlanteanAlreadyClaimed[_atlanteanId] = true;
1316         _mint(caller, 1, "", false);
1317     }
1318 
1319     function claimMany(uint256[] memory _atlanteansIds) public nonReentrant {
1320         address caller = msg.sender;
1321         uint256 amount = _atlanteansIds.length;
1322 
1323         require(!paused, "Contract is paused!");
1324         require(totalSupply() + amount < maxSupply + 1, "Max supply exceeded!");
1325 
1326         for(uint256 i=0; i<_atlanteansIds.length; i++) {
1327             uint256 _atlanteanId = _atlanteansIds[i];
1328 
1329             require(atlanteanAlreadyClaimed[_atlanteanId] == false, "Max land per Atlantean exceeded!");
1330             require(staking.getStakeOwner(_atlanteanId) == caller, "Caller not owner or NFT not staked!");
1331             require(staking.getStakeTime(_atlanteanId) > minStakedTime, "NFT is staked less than 19 days!");
1332 
1333             atlanteanAlreadyClaimed[_atlanteanId] = true;
1334         }
1335         _mint(caller, amount, "", false);
1336 
1337     }
1338 
1339     function atlanteanAlreadyUsed(uint256 _id) public view returns(bool) {
1340         return atlanteanAlreadyClaimed[_id];
1341     }
1342 
1343     function tokenURI(uint256 _tokenId)
1344         public
1345         view
1346         virtual
1347         override
1348         returns (string memory)
1349     {
1350         require(
1351             _exists(_tokenId),
1352             "ERC721Metadata: URI query for nonexistent token"
1353         );
1354 
1355         string memory currentBaseURI = _baseURI();
1356         return bytes(currentBaseURI).length > 0
1357             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1358             : "";
1359     }
1360 
1361     function setMinStakedTime(uint256 _minTime) public onlyOwner {
1362         minStakedTime = _minTime;
1363     }
1364 
1365     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1366         baseURI = _newBaseURI;
1367     }
1368 
1369     function setPaused(bool _state) public onlyOwner {
1370         paused = _state;
1371     }
1372 
1373     function _baseURI() internal view virtual override returns (string memory) {
1374         return baseURI;
1375     }
1376 }