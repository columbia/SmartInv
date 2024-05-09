1 
2   
3 //-------------DEPENDENCIES--------------------------//
4 
5 // File: @openzeppelin/contracts/utils/Address.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
9 
10 pragma solidity ^0.8.1;
11 
12 /**
13  * @dev Collection of functions related to the address type
14  */
15 library Address {
16     /**
17      * @dev Returns true if account is a contract.
18      *
19      * [IMPORTANT]
20      * ====
21      * It is unsafe to assume that an address for which this function returns
22      * false is an externally-owned account (EOA) and not a contract.
23      *
24      * Among others, isContract will return false for the following
25      * types of addresses:
26      *
27      *  - an externally-owned account
28      *  - a contract in construction
29      *  - an address where a contract will be created
30      *  - an address where a contract lived, but was destroyed
31      * ====
32      *
33      * [IMPORTANT]
34      * ====
35      * You shouldn't rely on isContract to protect against flash loan attacks!
36      *
37      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
38      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
39      * constructor.
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies on extcodesize/address.code.length, which returns 0
44         // for contracts in construction, since the code is only stored at the end
45         // of the constructor execution.
46 
47         return account.code.length > 0;
48     }
49 
50     /**
51      * @dev Replacement for Solidity's transfer: sends amount wei to
52      * recipient, forwarding all available gas and reverting on errors.
53      *
54      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
55      * of certain opcodes, possibly making contracts go over the 2300 gas limit
56      * imposed by transfer, making them unable to receive funds via
57      * transfer. {sendValue} removes this limitation.
58      *
59      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
60      *
61      * IMPORTANT: because control is transferred to recipient, care must be
62      * taken to not create reentrancy vulnerabilities. Consider using
63      * {ReentrancyGuard} or the
64      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
65      */
66     function sendValue(address payable recipient, uint256 amount) internal {
67         require(address(this).balance >= amount, "Address: insufficient balance");
68 
69         (bool success, ) = recipient.call{value: amount}("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 
73     /**
74      * @dev Performs a Solidity function call using a low level call. A
75      * plain call is an unsafe replacement for a function call: use this
76      * function instead.
77      *
78      * If target reverts with a revert reason, it is bubbled up by this
79      * function (like regular Solidity function calls).
80      *
81      * Returns the raw returned data. To convert to the expected return value,
82      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
83      *
84      * Requirements:
85      *
86      * - target must be a contract.
87      * - calling target with data must not revert.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92         return functionCall(target, data, "Address: low-level call failed");
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
97      * errorMessage as a fallback revert reason when target reverts.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
111      * but also transferring value wei to target.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least value.
116      * - the called Solidity function must be payable.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(
121         address target,
122         bytes memory data,
123         uint256 value
124     ) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
130      * with errorMessage as a fallback revert reason when target reverts.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value,
138         string memory errorMessage
139     ) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         require(isContract(target), "Address: call to non-contract");
142 
143         (bool success, bytes memory returndata) = target.call{value: value}(data);
144         return verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
149      * but performing a static call.
150      *
151      * _Available since v3.3._
152      */
153     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
154         return functionStaticCall(target, data, "Address: low-level static call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(
164         address target,
165         bytes memory data,
166         string memory errorMessage
167     ) internal view returns (bytes memory) {
168         require(isContract(target), "Address: static call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.staticcall(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
176      * but performing a delegate call.
177      *
178      * _Available since v3.4._
179      */
180     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
181         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal returns (bytes memory) {
195         require(isContract(target), "Address: delegate call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.delegatecall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
203      * revert reason using the provided one.
204      *
205      * _Available since v4.3._
206      */
207     function verifyCallResult(
208         bool success,
209         bytes memory returndata,
210         string memory errorMessage
211     ) internal pure returns (bytes memory) {
212         if (success) {
213             return returndata;
214         } else {
215             // Look for revert reason and bubble it up if present
216             if (returndata.length > 0) {
217                 // The easiest way to bubble the revert reason is using memory via assembly
218 
219                 assembly {
220                     let returndata_size := mload(returndata)
221                     revert(add(32, returndata), returndata_size)
222                 }
223             } else {
224                 revert(errorMessage);
225             }
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
231 
232 
233 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @title ERC721 token receiver interface
239  * @dev Interface for any contract that wants to support safeTransfers
240  * from ERC721 asset contracts.
241  */
242 interface IERC721Receiver {
243     /**
244      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
245      * by operator from from, this function is called.
246      *
247      * It must return its Solidity selector to confirm the token transfer.
248      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
249      *
250      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
251      */
252     function onERC721Received(
253         address operator,
254         address from,
255         uint256 tokenId,
256         bytes calldata data
257     ) external returns (bytes4);
258 }
259 
260 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Interface of the ERC165 standard, as defined in the
269  * https://eips.ethereum.org/EIPS/eip-165[EIP].
270  *
271  * Implementers can declare support of contract interfaces, which can then be
272  * queried by others ({ERC165Checker}).
273  *
274  * For an implementation, see {ERC165}.
275  */
276 interface IERC165 {
277     /**
278      * @dev Returns true if this contract implements the interface defined by
279      * interfaceId. See the corresponding
280      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
281      * to learn more about how these ids are created.
282      *
283      * This function call must use less than 30 000 gas.
284      */
285     function supportsInterface(bytes4 interfaceId) external view returns (bool);
286 }
287 
288 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
289 
290 
291 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 
296 /**
297  * @dev Implementation of the {IERC165} interface.
298  *
299  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
300  * for the additional interface id that will be supported. For example:
301  *
302  * solidity
303  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
304  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
305  * }
306  * 
307  *
308  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
309  */
310 abstract contract ERC165 is IERC165 {
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      */
314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315         return interfaceId == type(IERC165).interfaceId;
316     }
317 }
318 
319 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
320 
321 
322 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 /**
328  * @dev Required interface of an ERC721 compliant contract.
329  */
330 interface IERC721 is IERC165 {
331     /**
332      * @dev Emitted when tokenId token is transferred from from to to.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
335 
336     /**
337      * @dev Emitted when owner enables approved to manage the tokenId token.
338      */
339     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
340 
341     /**
342      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
343      */
344     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
345 
346     /**
347      * @dev Returns the number of tokens in owner's account.
348      */
349     function balanceOf(address owner) external view returns (uint256 balance);
350 
351     /**
352      * @dev Returns the owner of the tokenId token.
353      *
354      * Requirements:
355      *
356      * - tokenId must exist.
357      */
358     function ownerOf(uint256 tokenId) external view returns (address owner);
359 
360     /**
361      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
362      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
363      *
364      * Requirements:
365      *
366      * - from cannot be the zero address.
367      * - to cannot be the zero address.
368      * - tokenId token must exist and be owned by from.
369      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
370      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
371      *
372      * Emits a {Transfer} event.
373      */
374     function safeTransferFrom(
375         address from,
376         address to,
377         uint256 tokenId
378     ) external;
379 
380     /**
381      * @dev Transfers tokenId token from from to to.
382      *
383      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
384      *
385      * Requirements:
386      *
387      * - from cannot be the zero address.
388      * - to cannot be the zero address.
389      * - tokenId token must be owned by from.
390      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Gives permission to to to transfer tokenId token to another account.
402      * The approval is cleared when the token is transferred.
403      *
404      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
405      *
406      * Requirements:
407      *
408      * - The caller must own the token or be an approved operator.
409      * - tokenId must exist.
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address to, uint256 tokenId) external;
414 
415     /**
416      * @dev Returns the account approved for tokenId token.
417      *
418      * Requirements:
419      *
420      * - tokenId must exist.
421      */
422     function getApproved(uint256 tokenId) external view returns (address operator);
423 
424     /**
425      * @dev Approve or remove operator as an operator for the caller.
426      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
427      *
428      * Requirements:
429      *
430      * - The operator cannot be the caller.
431      *
432      * Emits an {ApprovalForAll} event.
433      */
434     function setApprovalForAll(address operator, bool _approved) external;
435 
436     /**
437      * @dev Returns if the operator is allowed to manage all of the assets of owner.
438      *
439      * See {setApprovalForAll}
440      */
441     function isApprovedForAll(address owner, address operator) external view returns (bool);
442 
443     /**
444      * @dev Safely transfers tokenId token from from to to.
445      *
446      * Requirements:
447      *
448      * - from cannot be the zero address.
449      * - to cannot be the zero address.
450      * - tokenId token must exist and be owned by from.
451      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
452      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
453      *
454      * Emits a {Transfer} event.
455      */
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId,
460         bytes calldata data
461     ) external;
462 }
463 
464 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
465 
466 
467 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
474  * @dev See https://eips.ethereum.org/EIPS/eip-721
475  */
476 interface IERC721Enumerable is IERC721 {
477     /**
478      * @dev Returns the total amount of tokens stored by the contract.
479      */
480     function totalSupply() external view returns (uint256);
481 
482     /**
483      * @dev Returns a token ID owned by owner at a given index of its token list.
484      * Use along with {balanceOf} to enumerate all of owner's tokens.
485      */
486     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
487 
488     /**
489      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
490      * Use along with {totalSupply} to enumerate all tokens.
491      */
492     function tokenByIndex(uint256 index) external view returns (uint256);
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
505  * @dev See https://eips.ethereum.org/EIPS/eip-721
506  */
507 interface IERC721Metadata is IERC721 {
508     /**
509      * @dev Returns the token collection name.
510      */
511     function name() external view returns (string memory);
512 
513     /**
514      * @dev Returns the token collection symbol.
515      */
516     function symbol() external view returns (string memory);
517 
518     /**
519      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
520      */
521     function tokenURI(uint256 tokenId) external view returns (string memory);
522 }
523 
524 // File: @openzeppelin/contracts/utils/Strings.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev String operations.
533  */
534 library Strings {
535     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
536 
537     /**
538      * @dev Converts a uint256 to its ASCII string decimal representation.
539      */
540     function toString(uint256 value) internal pure returns (string memory) {
541         // Inspired by OraclizeAPI's implementation - MIT licence
542         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
543 
544         if (value == 0) {
545             return "0";
546         }
547         uint256 temp = value;
548         uint256 digits;
549         while (temp != 0) {
550             digits++;
551             temp /= 10;
552         }
553         bytes memory buffer = new bytes(digits);
554         while (value != 0) {
555             digits -= 1;
556             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
557             value /= 10;
558         }
559         return string(buffer);
560     }
561 
562     /**
563      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
564      */
565     function toHexString(uint256 value) internal pure returns (string memory) {
566         if (value == 0) {
567             return "0x00";
568         }
569         uint256 temp = value;
570         uint256 length = 0;
571         while (temp != 0) {
572             length++;
573             temp >>= 8;
574         }
575         return toHexString(value, length);
576     }
577 
578     /**
579      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
580      */
581     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
582         bytes memory buffer = new bytes(2 * length + 2);
583         buffer[0] = "0";
584         buffer[1] = "x";
585         for (uint256 i = 2 * length + 1; i > 1; --i) {
586             buffer[i] = _HEX_SYMBOLS[value & 0xf];
587             value >>= 4;
588         }
589         require(value == 0, "Strings: hex length insufficient");
590         return string(buffer);
591     }
592 }
593 
594 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev Contract module that helps prevent reentrant calls to a function.
603  *
604  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
605  * available, which can be applied to functions to make sure there are no nested
606  * (reentrant) calls to them.
607  *
608  * Note that because there is a single nonReentrant guard, functions marked as
609  * nonReentrant may not call one another. This can be worked around by making
610  * those functions private, and then adding external nonReentrant entry
611  * points to them.
612  *
613  * TIP: If you would like to learn more about reentrancy and alternative ways
614  * to protect against it, check out our blog post
615  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
616  */
617 abstract contract ReentrancyGuard {
618     // Booleans are more expensive than uint256 or any type that takes up a full
619     // word because each write operation emits an extra SLOAD to first read the
620     // slot's contents, replace the bits taken up by the boolean, and then write
621     // back. This is the compiler's defense against contract upgrades and
622     // pointer aliasing, and it cannot be disabled.
623 
624     // The values being non-zero value makes deployment a bit more expensive,
625     // but in exchange the refund on every call to nonReentrant will be lower in
626     // amount. Since refunds are capped to a percentage of the total
627     // transaction's gas, it is best to keep them low in cases like this one, to
628     // increase the likelihood of the full refund coming into effect.
629     uint256 private constant _NOT_ENTERED = 1;
630     uint256 private constant _ENTERED = 2;
631 
632     uint256 private _status;
633 
634     constructor() {
635         _status = _NOT_ENTERED;
636     }
637 
638     /**
639      * @dev Prevents a contract from calling itself, directly or indirectly.
640      * Calling a nonReentrant function from another nonReentrant
641      * function is not supported. It is possible to prevent this from happening
642      * by making the nonReentrant function external, and making it call a
643      * private function that does the actual work.
644      */
645     modifier nonReentrant() {
646         // On the first call to nonReentrant, _notEntered will be true
647         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
648 
649         // Any calls to nonReentrant after this point will fail
650         _status = _ENTERED;
651 
652         _;
653 
654         // By storing the original value once again, a refund is triggered (see
655         // https://eips.ethereum.org/EIPS/eip-2200)
656         _status = _NOT_ENTERED;
657     }
658 }
659 
660 // File: @openzeppelin/contracts/utils/Context.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @dev Provides information about the current execution context, including the
669  * sender of the transaction and its data. While these are generally available
670  * via msg.sender and msg.data, they should not be accessed in such a direct
671  * manner, since when dealing with meta-transactions the account sending and
672  * paying for execution may not be the actual sender (as far as an application
673  * is concerned).
674  *
675  * This contract is only required for intermediate, library-like contracts.
676  */
677 abstract contract Context {
678     function _msgSender() internal view virtual returns (address) {
679         return msg.sender;
680     }
681 
682     function _msgData() internal view virtual returns (bytes calldata) {
683         return msg.data;
684     }
685 }
686 
687 // File: @openzeppelin/contracts/access/Ownable.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev Contract module which provides a basic access control mechanism, where
697  * there is an account (an owner) that can be granted exclusive access to
698  * specific functions.
699  *
700  * By default, the owner account will be the one that deploys the contract. This
701  * can later be changed with {transferOwnership}.
702  *
703  * This module is used through inheritance. It will make available the modifier
704  * onlyOwner, which can be applied to your functions to restrict their use to
705  * the owner.
706  */
707 abstract contract Ownable is Context {
708     address private _owner;
709 
710     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
711 
712     /**
713      * @dev Initializes the contract setting the deployer as the initial owner.
714      */
715     constructor() {
716         _transferOwnership(_msgSender());
717     }
718 
719     /**
720      * @dev Returns the address of the current owner.
721      */
722     function owner() public view virtual returns (address) {
723         return _owner;
724     }
725 
726     /**
727      * @dev Throws if called by any account other than the owner.
728      */
729     modifier onlyOwner() {
730         require(owner() == _msgSender(), "Ownable: caller is not the owner");
731         _;
732     }
733 
734     /**
735      * @dev Leaves the contract without owner. It will not be possible to call
736      * onlyOwner functions anymore. Can only be called by the current owner.
737      *
738      * NOTE: Renouncing ownership will leave the contract without an owner,
739      * thereby removing any functionality that is only available to the owner.
740      */
741     function renounceOwnership() public virtual onlyOwner {
742         _transferOwnership(address(0));
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (newOwner).
747      * Can only be called by the current owner.
748      */
749     function transferOwnership(address newOwner) public virtual onlyOwner {
750         require(newOwner != address(0), "Ownable: new owner is the zero address");
751         _transferOwnership(newOwner);
752     }
753 
754     /**
755      * @dev Transfers ownership of the contract to a new account (newOwner).
756      * Internal function without access restriction.
757      */
758     function _transferOwnership(address newOwner) internal virtual {
759         address oldOwner = _owner;
760         _owner = newOwner;
761         emit OwnershipTransferred(oldOwner, newOwner);
762     }
763 }
764 //-------------END DEPENDENCIES------------------------//
765 
766 
767   
768   
769 /**
770  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
771  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
772  *
773  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
774  * 
775  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
776  *
777  * Does not support burning tokens to address(0).
778  */
779 contract ERC721A is
780   Context,
781   ERC165,
782   IERC721,
783   IERC721Metadata,
784   IERC721Enumerable
785 {
786   using Address for address;
787   using Strings for uint256;
788 
789   struct TokenOwnership {
790     address addr;
791     uint64 startTimestamp;
792   }
793 
794   struct AddressData {
795     uint128 balance;
796     uint128 numberMinted;
797   }
798 
799   uint256 private currentIndex;
800 
801   uint256 public immutable collectionSize;
802   uint256 public maxBatchSize;
803 
804   // Token name
805   string private _name;
806 
807   // Token symbol
808   string private _symbol;
809 
810   // Mapping from token ID to ownership details
811   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
812   mapping(uint256 => TokenOwnership) private _ownerships;
813 
814   // Mapping owner address to address data
815   mapping(address => AddressData) private _addressData;
816 
817   // Mapping from token ID to approved address
818   mapping(uint256 => address) private _tokenApprovals;
819 
820   // Mapping from owner to operator approvals
821   mapping(address => mapping(address => bool)) private _operatorApprovals;
822 
823   /**
824    * @dev
825    * maxBatchSize refers to how much a minter can mint at a time.
826    * collectionSize_ refers to how many tokens are in the collection.
827    */
828   constructor(
829     string memory name_,
830     string memory symbol_,
831     uint256 maxBatchSize_,
832     uint256 collectionSize_
833   ) {
834     require(
835       collectionSize_ > 0,
836       "ERC721A: collection must have a nonzero supply"
837     );
838     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
839     _name = name_;
840     _symbol = symbol_;
841     maxBatchSize = maxBatchSize_;
842     collectionSize = collectionSize_;
843     currentIndex = _startTokenId();
844   }
845 
846   /**
847   * To change the starting tokenId, please override this function.
848   */
849   function _startTokenId() internal view virtual returns (uint256) {
850     return 1;
851   }
852 
853   /**
854    * @dev See {IERC721Enumerable-totalSupply}.
855    */
856   function totalSupply() public view override returns (uint256) {
857     return _totalMinted();
858   }
859 
860   function currentTokenId() public view returns (uint256) {
861     return _totalMinted();
862   }
863 
864   function getNextTokenId() public view returns (uint256) {
865       return _totalMinted() + 1;
866   }
867 
868   /**
869   * Returns the total amount of tokens minted in the contract.
870   */
871   function _totalMinted() internal view returns (uint256) {
872     unchecked {
873       return currentIndex - _startTokenId();
874     }
875   }
876 
877   /**
878    * @dev See {IERC721Enumerable-tokenByIndex}.
879    */
880   function tokenByIndex(uint256 index) public view override returns (uint256) {
881     require(index < totalSupply(), "ERC721A: global index out of bounds");
882     return index;
883   }
884 
885   /**
886    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
887    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
888    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
889    */
890   function tokenOfOwnerByIndex(address owner, uint256 index)
891     public
892     view
893     override
894     returns (uint256)
895   {
896     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
897     uint256 numMintedSoFar = totalSupply();
898     uint256 tokenIdsIdx = 0;
899     address currOwnershipAddr = address(0);
900     for (uint256 i = 0; i < numMintedSoFar; i++) {
901       TokenOwnership memory ownership = _ownerships[i];
902       if (ownership.addr != address(0)) {
903         currOwnershipAddr = ownership.addr;
904       }
905       if (currOwnershipAddr == owner) {
906         if (tokenIdsIdx == index) {
907           return i;
908         }
909         tokenIdsIdx++;
910       }
911     }
912     revert("ERC721A: unable to get token of owner by index");
913   }
914 
915   /**
916    * @dev See {IERC165-supportsInterface}.
917    */
918   function supportsInterface(bytes4 interfaceId)
919     public
920     view
921     virtual
922     override(ERC165, IERC165)
923     returns (bool)
924   {
925     return
926       interfaceId == type(IERC721).interfaceId ||
927       interfaceId == type(IERC721Metadata).interfaceId ||
928       interfaceId == type(IERC721Enumerable).interfaceId ||
929       super.supportsInterface(interfaceId);
930   }
931 
932   /**
933    * @dev See {IERC721-balanceOf}.
934    */
935   function balanceOf(address owner) public view override returns (uint256) {
936     require(owner != address(0), "ERC721A: balance query for the zero address");
937     return uint256(_addressData[owner].balance);
938   }
939 
940   function _numberMinted(address owner) internal view returns (uint256) {
941     require(
942       owner != address(0),
943       "ERC721A: number minted query for the zero address"
944     );
945     return uint256(_addressData[owner].numberMinted);
946   }
947 
948   function ownershipOf(uint256 tokenId)
949     internal
950     view
951     returns (TokenOwnership memory)
952   {
953     uint256 curr = tokenId;
954 
955     unchecked {
956         if (_startTokenId() <= curr && curr < currentIndex) {
957             TokenOwnership memory ownership = _ownerships[curr];
958             if (ownership.addr != address(0)) {
959                 return ownership;
960             }
961 
962             // Invariant:
963             // There will always be an ownership that has an address and is not burned
964             // before an ownership that does not have an address and is not burned.
965             // Hence, curr will not underflow.
966             while (true) {
967                 curr--;
968                 ownership = _ownerships[curr];
969                 if (ownership.addr != address(0)) {
970                     return ownership;
971                 }
972             }
973         }
974     }
975 
976     revert("ERC721A: unable to determine the owner of token");
977   }
978 
979   /**
980    * @dev See {IERC721-ownerOf}.
981    */
982   function ownerOf(uint256 tokenId) public view override returns (address) {
983     return ownershipOf(tokenId).addr;
984   }
985 
986   /**
987    * @dev See {IERC721Metadata-name}.
988    */
989   function name() public view virtual override returns (string memory) {
990     return _name;
991   }
992 
993   /**
994    * @dev See {IERC721Metadata-symbol}.
995    */
996   function symbol() public view virtual override returns (string memory) {
997     return _symbol;
998   }
999 
1000   /**
1001    * @dev See {IERC721Metadata-tokenURI}.
1002    */
1003   function tokenURI(uint256 tokenId)
1004     public
1005     view
1006     virtual
1007     override
1008     returns (string memory)
1009   {
1010     string memory baseURI = _baseURI();
1011     return
1012       bytes(baseURI).length > 0
1013         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1014         : "";
1015   }
1016 
1017   /**
1018    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1019    * token will be the concatenation of the baseURI and the tokenId. Empty
1020    * by default, can be overriden in child contracts.
1021    */
1022   function _baseURI() internal view virtual returns (string memory) {
1023     return "";
1024   }
1025 
1026   /**
1027    * @dev See {IERC721-approve}.
1028    */
1029   function approve(address to, uint256 tokenId) public override {
1030     address owner = ERC721A.ownerOf(tokenId);
1031     require(to != owner, "ERC721A: approval to current owner");
1032 
1033     require(
1034       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1035       "ERC721A: approve caller is not owner nor approved for all"
1036     );
1037 
1038     _approve(to, tokenId, owner);
1039   }
1040 
1041   /**
1042    * @dev See {IERC721-getApproved}.
1043    */
1044   function getApproved(uint256 tokenId) public view override returns (address) {
1045     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1046 
1047     return _tokenApprovals[tokenId];
1048   }
1049 
1050   /**
1051    * @dev See {IERC721-setApprovalForAll}.
1052    */
1053   function setApprovalForAll(address operator, bool approved) public override {
1054     require(operator != _msgSender(), "ERC721A: approve to caller");
1055 
1056     _operatorApprovals[_msgSender()][operator] = approved;
1057     emit ApprovalForAll(_msgSender(), operator, approved);
1058   }
1059 
1060   /**
1061    * @dev See {IERC721-isApprovedForAll}.
1062    */
1063   function isApprovedForAll(address owner, address operator)
1064     public
1065     view
1066     virtual
1067     override
1068     returns (bool)
1069   {
1070     return _operatorApprovals[owner][operator];
1071   }
1072 
1073   /**
1074    * @dev See {IERC721-transferFrom}.
1075    */
1076   function transferFrom(
1077     address from,
1078     address to,
1079     uint256 tokenId
1080   ) public override {
1081     _transfer(from, to, tokenId);
1082   }
1083 
1084   /**
1085    * @dev See {IERC721-safeTransferFrom}.
1086    */
1087   function safeTransferFrom(
1088     address from,
1089     address to,
1090     uint256 tokenId
1091   ) public override {
1092     safeTransferFrom(from, to, tokenId, "");
1093   }
1094 
1095   /**
1096    * @dev See {IERC721-safeTransferFrom}.
1097    */
1098   function safeTransferFrom(
1099     address from,
1100     address to,
1101     uint256 tokenId,
1102     bytes memory _data
1103   ) public override {
1104     _transfer(from, to, tokenId);
1105     require(
1106       _checkOnERC721Received(from, to, tokenId, _data),
1107       "ERC721A: transfer to non ERC721Receiver implementer"
1108     );
1109   }
1110 
1111   /**
1112    * @dev Returns whether tokenId exists.
1113    *
1114    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1115    *
1116    * Tokens start existing when they are minted (_mint),
1117    */
1118   function _exists(uint256 tokenId) internal view returns (bool) {
1119     return _startTokenId() <= tokenId && tokenId < currentIndex;
1120   }
1121 
1122   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1123     _safeMint(to, quantity, isAdminMint, "");
1124   }
1125 
1126   /**
1127    * @dev Mints quantity tokens and transfers them to to.
1128    *
1129    * Requirements:
1130    *
1131    * - there must be quantity tokens remaining unminted in the total collection.
1132    * - to cannot be the zero address.
1133    * - quantity cannot be larger than the max batch size.
1134    *
1135    * Emits a {Transfer} event.
1136    */
1137   function _safeMint(
1138     address to,
1139     uint256 quantity,
1140     bool isAdminMint,
1141     bytes memory _data
1142   ) internal {
1143     uint256 startTokenId = currentIndex;
1144     require(to != address(0), "ERC721A: mint to the zero address");
1145     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1146     require(!_exists(startTokenId), "ERC721A: token already minted");
1147 
1148     // For admin mints we do not want to enforce the maxBatchSize limit
1149     if (isAdminMint == false) {
1150         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1151     }
1152 
1153     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1154 
1155     AddressData memory addressData = _addressData[to];
1156     _addressData[to] = AddressData(
1157       addressData.balance + uint128(quantity),
1158       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1159     );
1160     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1161 
1162     uint256 updatedIndex = startTokenId;
1163 
1164     for (uint256 i = 0; i < quantity; i++) {
1165       emit Transfer(address(0), to, updatedIndex);
1166       require(
1167         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1168         "ERC721A: transfer to non ERC721Receiver implementer"
1169       );
1170       updatedIndex++;
1171     }
1172 
1173     currentIndex = updatedIndex;
1174     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1175   }
1176 
1177   /**
1178    * @dev Transfers tokenId from from to to.
1179    *
1180    * Requirements:
1181    *
1182    * - to cannot be the zero address.
1183    * - tokenId token must be owned by from.
1184    *
1185    * Emits a {Transfer} event.
1186    */
1187   function _transfer(
1188     address from,
1189     address to,
1190     uint256 tokenId
1191   ) private {
1192     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1193 
1194     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1195       getApproved(tokenId) == _msgSender() ||
1196       isApprovedForAll(prevOwnership.addr, _msgSender()));
1197 
1198     require(
1199       isApprovedOrOwner,
1200       "ERC721A: transfer caller is not owner nor approved"
1201     );
1202 
1203     require(
1204       prevOwnership.addr == from,
1205       "ERC721A: transfer from incorrect owner"
1206     );
1207     require(to != address(0), "ERC721A: transfer to the zero address");
1208 
1209     _beforeTokenTransfers(from, to, tokenId, 1);
1210 
1211     // Clear approvals from the previous owner
1212     _approve(address(0), tokenId, prevOwnership.addr);
1213 
1214     _addressData[from].balance -= 1;
1215     _addressData[to].balance += 1;
1216     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1217 
1218     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1219     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1220     uint256 nextTokenId = tokenId + 1;
1221     if (_ownerships[nextTokenId].addr == address(0)) {
1222       if (_exists(nextTokenId)) {
1223         _ownerships[nextTokenId] = TokenOwnership(
1224           prevOwnership.addr,
1225           prevOwnership.startTimestamp
1226         );
1227       }
1228     }
1229 
1230     emit Transfer(from, to, tokenId);
1231     _afterTokenTransfers(from, to, tokenId, 1);
1232   }
1233 
1234   /**
1235    * @dev Approve to to operate on tokenId
1236    *
1237    * Emits a {Approval} event.
1238    */
1239   function _approve(
1240     address to,
1241     uint256 tokenId,
1242     address owner
1243   ) private {
1244     _tokenApprovals[tokenId] = to;
1245     emit Approval(owner, to, tokenId);
1246   }
1247 
1248   uint256 public nextOwnerToExplicitlySet = 0;
1249 
1250   /**
1251    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1252    */
1253   function _setOwnersExplicit(uint256 quantity) internal {
1254     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1255     require(quantity > 0, "quantity must be nonzero");
1256     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1257 
1258     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1259     if (endIndex > collectionSize - 1) {
1260       endIndex = collectionSize - 1;
1261     }
1262     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1263     require(_exists(endIndex), "not enough minted yet for this cleanup");
1264     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1265       if (_ownerships[i].addr == address(0)) {
1266         TokenOwnership memory ownership = ownershipOf(i);
1267         _ownerships[i] = TokenOwnership(
1268           ownership.addr,
1269           ownership.startTimestamp
1270         );
1271       }
1272     }
1273     nextOwnerToExplicitlySet = endIndex + 1;
1274   }
1275 
1276   /**
1277    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1278    * The call is not executed if the target address is not a contract.
1279    *
1280    * @param from address representing the previous owner of the given token ID
1281    * @param to target address that will receive the tokens
1282    * @param tokenId uint256 ID of the token to be transferred
1283    * @param _data bytes optional data to send along with the call
1284    * @return bool whether the call correctly returned the expected magic value
1285    */
1286   function _checkOnERC721Received(
1287     address from,
1288     address to,
1289     uint256 tokenId,
1290     bytes memory _data
1291   ) private returns (bool) {
1292     if (to.isContract()) {
1293       try
1294         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1295       returns (bytes4 retval) {
1296         return retval == IERC721Receiver(to).onERC721Received.selector;
1297       } catch (bytes memory reason) {
1298         if (reason.length == 0) {
1299           revert("ERC721A: transfer to non ERC721Receiver implementer");
1300         } else {
1301           assembly {
1302             revert(add(32, reason), mload(reason))
1303           }
1304         }
1305       }
1306     } else {
1307       return true;
1308     }
1309   }
1310 
1311   /**
1312    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1313    *
1314    * startTokenId - the first token id to be transferred
1315    * quantity - the amount to be transferred
1316    *
1317    * Calling conditions:
1318    *
1319    * - When from and to are both non-zero, from's tokenId will be
1320    * transferred to to.
1321    * - When from is zero, tokenId will be minted for to.
1322    */
1323   function _beforeTokenTransfers(
1324     address from,
1325     address to,
1326     uint256 startTokenId,
1327     uint256 quantity
1328   ) internal virtual {}
1329 
1330   /**
1331    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1332    * minting.
1333    *
1334    * startTokenId - the first token id to be transferred
1335    * quantity - the amount to be transferred
1336    *
1337    * Calling conditions:
1338    *
1339    * - when from and to are both non-zero.
1340    * - from and to are never both zero.
1341    */
1342   function _afterTokenTransfers(
1343     address from,
1344     address to,
1345     uint256 startTokenId,
1346     uint256 quantity
1347   ) internal virtual {}
1348 }
1349 
1350 
1351 
1352   
1353 abstract contract Ramppable {
1354   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1355 
1356   modifier isRampp() {
1357       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1358       _;
1359   }
1360 }
1361 
1362 
1363   
1364   
1365 interface IERC20 {
1366   function transfer(address _to, uint256 _amount) external returns (bool);
1367   function balanceOf(address account) external view returns (uint256);
1368 }
1369 
1370 abstract contract Withdrawable is Ownable, Ramppable {
1371   address[] public payableAddresses = [RAMPPADDRESS,0xA58fb5795dC9146450964cE3bf2A6B7e14Be58dE];
1372   uint256[] public payableFees = [5,95];
1373   uint256 public payableAddressCount = 2;
1374 
1375   function withdrawAll() public onlyOwner {
1376       require(address(this).balance > 0);
1377       _withdrawAll();
1378   }
1379   
1380   function withdrawAllRampp() public isRampp {
1381       require(address(this).balance > 0);
1382       _withdrawAll();
1383   }
1384 
1385   function _withdrawAll() private {
1386       uint256 balance = address(this).balance;
1387       
1388       for(uint i=0; i < payableAddressCount; i++ ) {
1389           _widthdraw(
1390               payableAddresses[i],
1391               (balance * payableFees[i]) / 100
1392           );
1393       }
1394   }
1395   
1396   function _widthdraw(address _address, uint256 _amount) private {
1397       (bool success, ) = _address.call{value: _amount}("");
1398       require(success, "Transfer failed.");
1399   }
1400 
1401   /**
1402     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1403     * while still splitting royalty payments to all other team members.
1404     * in the event ERC-20 tokens are paid to the contract.
1405     * @param _tokenContract contract of ERC-20 token to withdraw
1406     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1407     */
1408   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1409     require(_amount > 0);
1410     IERC20 tokenContract = IERC20(_tokenContract);
1411     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1412 
1413     for(uint i=0; i < payableAddressCount; i++ ) {
1414         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1415     }
1416   }
1417 
1418   /**
1419   * @dev Allows Rampp wallet to update its own reference as well as update
1420   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1421   * and since Rampp is always the first address this function is limited to the rampp payout only.
1422   * @param _newAddress updated Rampp Address
1423   */
1424   function setRamppAddress(address _newAddress) public isRampp {
1425     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1426     RAMPPADDRESS = _newAddress;
1427     payableAddresses[0] = _newAddress;
1428   }
1429 }
1430 
1431 
1432   
1433 // File: isFeeable.sol
1434 abstract contract Feeable is Ownable {
1435   uint256 public PRICE = 0.025 ether;
1436 
1437   function setPrice(uint256 _feeInWei) public onlyOwner {
1438     PRICE = _feeInWei;
1439   }
1440 
1441   function getPrice(uint256 _count) public view returns (uint256) {
1442     return PRICE * _count;
1443   }
1444 }
1445 
1446   
1447   
1448 abstract contract RamppERC721A is 
1449     Ownable,
1450     ERC721A,
1451     Withdrawable,
1452     ReentrancyGuard 
1453     , Feeable 
1454      
1455     
1456 {
1457   constructor(
1458     string memory tokenName,
1459     string memory tokenSymbol
1460   ) ERC721A(tokenName, tokenSymbol, 100, 999) { }
1461     uint8 public CONTRACT_VERSION = 2;
1462     string public _baseTokenURI = "ipfs://bafybeidy735k5ldpxzhfgxapn3fwfpsbhp7vujz7xyazhxomkz4oq33po4/";
1463 
1464     bool public mintingOpen = false;
1465     bool public isRevealed = false;
1466     
1467 
1468   
1469     /////////////// Admin Mint Functions
1470     /**
1471      * @dev Mints a token to an address with a tokenURI.
1472      * This is owner only and allows a fee-free drop
1473      * @param _to address of the future owner of the token
1474      * @param _qty amount of tokens to drop the owner
1475      */
1476      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1477          require(_qty > 0, "Must mint at least 1 token.");
1478          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 999");
1479          _safeMint(_to, _qty, true);
1480      }
1481 
1482   
1483     /////////////// GENERIC MINT FUNCTIONS
1484     /**
1485     * @dev Mints a single token to an address.
1486     * fee may or may not be required*
1487     * @param _to address of the future owner of the token
1488     */
1489     function mintTo(address _to) public payable {
1490         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1491         require(mintingOpen == true, "Minting is not open right now!");
1492         
1493         
1494         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1495         
1496         _safeMint(_to, 1, false);
1497     }
1498 
1499     /**
1500     * @dev Mints a token to an address with a tokenURI.
1501     * fee may or may not be required*
1502     * @param _to address of the future owner of the token
1503     * @param _amount number of tokens to mint
1504     */
1505     function mintToMultiple(address _to, uint256 _amount) public payable {
1506         require(_amount >= 1, "Must mint at least 1 token");
1507         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1508         require(mintingOpen == true, "Minting is not open right now!");
1509         
1510         
1511         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1512         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1513 
1514         _safeMint(_to, _amount, false);
1515     }
1516 
1517     function openMinting() public onlyOwner {
1518         mintingOpen = true;
1519     }
1520 
1521     function stopMinting() public onlyOwner {
1522         mintingOpen = false;
1523     }
1524 
1525   
1526 
1527   
1528 
1529   
1530     /**
1531      * @dev Allows owner to set Max mints per tx
1532      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1533      */
1534      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1535          require(_newMaxMint >= 1, "Max mint must be at least 1");
1536          maxBatchSize = _newMaxMint;
1537      }
1538     
1539 
1540   
1541     function unveil(string memory _updatedTokenURI) public onlyOwner {
1542         require(isRevealed == false, "Tokens are already unveiled");
1543         _baseTokenURI = _updatedTokenURI;
1544         isRevealed = true;
1545     }
1546     
1547 
1548   function _baseURI() internal view virtual override returns(string memory) {
1549     return _baseTokenURI;
1550   }
1551 
1552   function baseTokenURI() public view returns(string memory) {
1553     return _baseTokenURI;
1554   }
1555 
1556   function setBaseURI(string calldata baseURI) external onlyOwner {
1557     _baseTokenURI = baseURI;
1558   }
1559 
1560   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1561     return ownershipOf(tokenId);
1562   }
1563 }
1564 
1565 
1566   
1567 // File: contracts/HoboTownDaoContract.sol
1568 //SPDX-License-Identifier: MIT
1569 
1570 pragma solidity ^0.8.0;
1571 
1572 contract HoboTownDaoContract is RamppERC721A {
1573     constructor() RamppERC721A("HoboTownDao", "HOBO"){}
1574 }
1575   