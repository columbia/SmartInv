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
768   pragma solidity ^0.8.0;
769 
770   /**
771   * @dev These functions deal with verification of Merkle Trees proofs.
772   *
773   * The proofs can be generated using the JavaScript library
774   * https://github.com/miguelmota/merkletreejs[merkletreejs].
775   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
776   *
777   *
778   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
779   * hashing, or use a hash function other than keccak256 for hashing leaves.
780   * This is because the concatenation of a sorted pair of internal nodes in
781   * the merkle tree could be reinterpreted as a leaf value.
782   */
783   library MerkleProof {
784       /**
785       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
786       * defined by 'root'. For this, a 'proof' must be provided, containing
787       * sibling hashes on the branch from the leaf to the root of the tree. Each
788       * pair of leaves and each pair of pre-images are assumed to be sorted.
789       */
790       function verify(
791           bytes32[] memory proof,
792           bytes32 root,
793           bytes32 leaf
794       ) internal pure returns (bool) {
795           return processProof(proof, leaf) == root;
796       }
797 
798       /**
799       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
800       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
801       * hash matches the root of the tree. When processing the proof, the pairs
802       * of leafs & pre-images are assumed to be sorted.
803       *
804       * _Available since v4.4._
805       */
806       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
807           bytes32 computedHash = leaf;
808           for (uint256 i = 0; i < proof.length; i++) {
809               bytes32 proofElement = proof[i];
810               if (computedHash <= proofElement) {
811                   // Hash(current computed hash + current element of the proof)
812                   computedHash = _efficientHash(computedHash, proofElement);
813               } else {
814                   // Hash(current element of the proof + current computed hash)
815                   computedHash = _efficientHash(proofElement, computedHash);
816               }
817           }
818           return computedHash;
819       }
820 
821       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
822           assembly {
823               mstore(0x00, a)
824               mstore(0x20, b)
825               value := keccak256(0x00, 0x40)
826           }
827       }
828   }
829 
830 
831   // File: Allowlist.sol
832 
833   pragma solidity ^0.8.0;
834 
835   abstract contract Allowlist is Ownable {
836     bytes32 public merkleRoot;
837     bool public onlyAllowlistMode = false;
838 
839     /**
840      * @dev Update merkle root to reflect changes in Allowlist
841      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
842      */
843     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
844       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
845       merkleRoot = _newMerkleRoot;
846     }
847 
848     /**
849      * @dev Check the proof of an address if valid for merkle root
850      * @param _to address to check for proof
851      * @param _merkleProof Proof of the address to validate against root and leaf
852      */
853     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
854       require(merkleRoot != 0, "Merkle root is not set!");
855       bytes32 leaf = keccak256(abi.encodePacked(_to));
856 
857       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
858     }
859 
860     
861     function enableAllowlistOnlyMode() public onlyOwner {
862       onlyAllowlistMode = true;
863     }
864 
865     function disableAllowlistOnlyMode() public onlyOwner {
866         onlyAllowlistMode = false;
867     }
868   }
869   
870   
871 /**
872  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
873  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
874  *
875  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
876  * 
877  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
878  *
879  * Does not support burning tokens to address(0).
880  */
881 contract ERC721A is
882   Context,
883   ERC165,
884   IERC721,
885   IERC721Metadata,
886   IERC721Enumerable
887 {
888   using Address for address;
889   using Strings for uint256;
890 
891   struct TokenOwnership {
892     address addr;
893     uint64 startTimestamp;
894   }
895 
896   struct AddressData {
897     uint128 balance;
898     uint128 numberMinted;
899   }
900 
901   uint256 private currentIndex;
902 
903   uint256 public immutable collectionSize;
904   uint256 public maxBatchSize;
905 
906   // Token name
907   string private _name;
908 
909   // Token symbol
910   string private _symbol;
911 
912   // Mapping from token ID to ownership details
913   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
914   mapping(uint256 => TokenOwnership) private _ownerships;
915 
916   // Mapping owner address to address data
917   mapping(address => AddressData) private _addressData;
918 
919   // Mapping from token ID to approved address
920   mapping(uint256 => address) private _tokenApprovals;
921 
922   // Mapping from owner to operator approvals
923   mapping(address => mapping(address => bool)) private _operatorApprovals;
924 
925   /**
926    * @dev
927    * maxBatchSize refers to how much a minter can mint at a time.
928    * collectionSize_ refers to how many tokens are in the collection.
929    */
930   constructor(
931     string memory name_,
932     string memory symbol_,
933     uint256 maxBatchSize_,
934     uint256 collectionSize_
935   ) {
936     require(
937       collectionSize_ > 0,
938       "ERC721A: collection must have a nonzero supply"
939     );
940     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
941     _name = name_;
942     _symbol = symbol_;
943     maxBatchSize = maxBatchSize_;
944     collectionSize = collectionSize_;
945     currentIndex = _startTokenId();
946   }
947 
948   /**
949   * To change the starting tokenId, please override this function.
950   */
951   function _startTokenId() internal view virtual returns (uint256) {
952     return 1;
953   }
954 
955   /**
956    * @dev See {IERC721Enumerable-totalSupply}.
957    */
958   function totalSupply() public view override returns (uint256) {
959     return _totalMinted();
960   }
961 
962   function currentTokenId() public view returns (uint256) {
963     return _totalMinted();
964   }
965 
966   function getNextTokenId() public view returns (uint256) {
967       return _totalMinted() + 1;
968   }
969 
970   /**
971   * Returns the total amount of tokens minted in the contract.
972   */
973   function _totalMinted() internal view returns (uint256) {
974     unchecked {
975       return currentIndex - _startTokenId();
976     }
977   }
978 
979   /**
980    * @dev See {IERC721Enumerable-tokenByIndex}.
981    */
982   function tokenByIndex(uint256 index) public view override returns (uint256) {
983     require(index < totalSupply(), "ERC721A: global index out of bounds");
984     return index;
985   }
986 
987   /**
988    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
989    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
990    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
991    */
992   function tokenOfOwnerByIndex(address owner, uint256 index)
993     public
994     view
995     override
996     returns (uint256)
997   {
998     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
999     uint256 numMintedSoFar = totalSupply();
1000     uint256 tokenIdsIdx = 0;
1001     address currOwnershipAddr = address(0);
1002     for (uint256 i = 0; i < numMintedSoFar; i++) {
1003       TokenOwnership memory ownership = _ownerships[i];
1004       if (ownership.addr != address(0)) {
1005         currOwnershipAddr = ownership.addr;
1006       }
1007       if (currOwnershipAddr == owner) {
1008         if (tokenIdsIdx == index) {
1009           return i;
1010         }
1011         tokenIdsIdx++;
1012       }
1013     }
1014     revert("ERC721A: unable to get token of owner by index");
1015   }
1016 
1017   /**
1018    * @dev See {IERC165-supportsInterface}.
1019    */
1020   function supportsInterface(bytes4 interfaceId)
1021     public
1022     view
1023     virtual
1024     override(ERC165, IERC165)
1025     returns (bool)
1026   {
1027     return
1028       interfaceId == type(IERC721).interfaceId ||
1029       interfaceId == type(IERC721Metadata).interfaceId ||
1030       interfaceId == type(IERC721Enumerable).interfaceId ||
1031       super.supportsInterface(interfaceId);
1032   }
1033 
1034   /**
1035    * @dev See {IERC721-balanceOf}.
1036    */
1037   function balanceOf(address owner) public view override returns (uint256) {
1038     require(owner != address(0), "ERC721A: balance query for the zero address");
1039     return uint256(_addressData[owner].balance);
1040   }
1041 
1042   function _numberMinted(address owner) internal view returns (uint256) {
1043     require(
1044       owner != address(0),
1045       "ERC721A: number minted query for the zero address"
1046     );
1047     return uint256(_addressData[owner].numberMinted);
1048   }
1049 
1050   function ownershipOf(uint256 tokenId)
1051     internal
1052     view
1053     returns (TokenOwnership memory)
1054   {
1055     uint256 curr = tokenId;
1056 
1057     unchecked {
1058         if (_startTokenId() <= curr && curr < currentIndex) {
1059             TokenOwnership memory ownership = _ownerships[curr];
1060             if (ownership.addr != address(0)) {
1061                 return ownership;
1062             }
1063 
1064             // Invariant:
1065             // There will always be an ownership that has an address and is not burned
1066             // before an ownership that does not have an address and is not burned.
1067             // Hence, curr will not underflow.
1068             while (true) {
1069                 curr--;
1070                 ownership = _ownerships[curr];
1071                 if (ownership.addr != address(0)) {
1072                     return ownership;
1073                 }
1074             }
1075         }
1076     }
1077 
1078     revert("ERC721A: unable to determine the owner of token");
1079   }
1080 
1081   /**
1082    * @dev See {IERC721-ownerOf}.
1083    */
1084   function ownerOf(uint256 tokenId) public view override returns (address) {
1085     return ownershipOf(tokenId).addr;
1086   }
1087 
1088   /**
1089    * @dev See {IERC721Metadata-name}.
1090    */
1091   function name() public view virtual override returns (string memory) {
1092     return _name;
1093   }
1094 
1095   /**
1096    * @dev See {IERC721Metadata-symbol}.
1097    */
1098   function symbol() public view virtual override returns (string memory) {
1099     return _symbol;
1100   }
1101 
1102   /**
1103    * @dev See {IERC721Metadata-tokenURI}.
1104    */
1105   function tokenURI(uint256 tokenId)
1106     public
1107     view
1108     virtual
1109     override
1110     returns (string memory)
1111   {
1112     string memory baseURI = _baseURI();
1113     return
1114       bytes(baseURI).length > 0
1115         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1116         : "";
1117   }
1118 
1119   /**
1120    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1121    * token will be the concatenation of the baseURI and the tokenId. Empty
1122    * by default, can be overriden in child contracts.
1123    */
1124   function _baseURI() internal view virtual returns (string memory) {
1125     return "";
1126   }
1127 
1128   /**
1129    * @dev See {IERC721-approve}.
1130    */
1131   function approve(address to, uint256 tokenId) public override {
1132     address owner = ERC721A.ownerOf(tokenId);
1133     require(to != owner, "ERC721A: approval to current owner");
1134 
1135     require(
1136       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1137       "ERC721A: approve caller is not owner nor approved for all"
1138     );
1139 
1140     _approve(to, tokenId, owner);
1141   }
1142 
1143   /**
1144    * @dev See {IERC721-getApproved}.
1145    */
1146   function getApproved(uint256 tokenId) public view override returns (address) {
1147     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1148 
1149     return _tokenApprovals[tokenId];
1150   }
1151 
1152   /**
1153    * @dev See {IERC721-setApprovalForAll}.
1154    */
1155   function setApprovalForAll(address operator, bool approved) public override {
1156     require(operator != _msgSender(), "ERC721A: approve to caller");
1157 
1158     _operatorApprovals[_msgSender()][operator] = approved;
1159     emit ApprovalForAll(_msgSender(), operator, approved);
1160   }
1161 
1162   /**
1163    * @dev See {IERC721-isApprovedForAll}.
1164    */
1165   function isApprovedForAll(address owner, address operator)
1166     public
1167     view
1168     virtual
1169     override
1170     returns (bool)
1171   {
1172     return _operatorApprovals[owner][operator];
1173   }
1174 
1175   /**
1176    * @dev See {IERC721-transferFrom}.
1177    */
1178   function transferFrom(
1179     address from,
1180     address to,
1181     uint256 tokenId
1182   ) public override {
1183     _transfer(from, to, tokenId);
1184   }
1185 
1186   /**
1187    * @dev See {IERC721-safeTransferFrom}.
1188    */
1189   function safeTransferFrom(
1190     address from,
1191     address to,
1192     uint256 tokenId
1193   ) public override {
1194     safeTransferFrom(from, to, tokenId, "");
1195   }
1196 
1197   /**
1198    * @dev See {IERC721-safeTransferFrom}.
1199    */
1200   function safeTransferFrom(
1201     address from,
1202     address to,
1203     uint256 tokenId,
1204     bytes memory _data
1205   ) public override {
1206     _transfer(from, to, tokenId);
1207     require(
1208       _checkOnERC721Received(from, to, tokenId, _data),
1209       "ERC721A: transfer to non ERC721Receiver implementer"
1210     );
1211   }
1212 
1213   /**
1214    * @dev Returns whether tokenId exists.
1215    *
1216    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1217    *
1218    * Tokens start existing when they are minted (_mint),
1219    */
1220   function _exists(uint256 tokenId) internal view returns (bool) {
1221     return _startTokenId() <= tokenId && tokenId < currentIndex;
1222   }
1223 
1224   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1225     _safeMint(to, quantity, isAdminMint, "");
1226   }
1227 
1228   /**
1229    * @dev Mints quantity tokens and transfers them to to.
1230    *
1231    * Requirements:
1232    *
1233    * - there must be quantity tokens remaining unminted in the total collection.
1234    * - to cannot be the zero address.
1235    * - quantity cannot be larger than the max batch size.
1236    *
1237    * Emits a {Transfer} event.
1238    */
1239   function _safeMint(
1240     address to,
1241     uint256 quantity,
1242     bool isAdminMint,
1243     bytes memory _data
1244   ) internal {
1245     uint256 startTokenId = currentIndex;
1246     require(to != address(0), "ERC721A: mint to the zero address");
1247     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1248     require(!_exists(startTokenId), "ERC721A: token already minted");
1249 
1250     // For admin mints we do not want to enforce the maxBatchSize limit
1251     if (isAdminMint == false) {
1252         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1253     }
1254 
1255     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1256 
1257     AddressData memory addressData = _addressData[to];
1258     _addressData[to] = AddressData(
1259       addressData.balance + uint128(quantity),
1260       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1261     );
1262     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1263 
1264     uint256 updatedIndex = startTokenId;
1265 
1266     for (uint256 i = 0; i < quantity; i++) {
1267       emit Transfer(address(0), to, updatedIndex);
1268       require(
1269         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1270         "ERC721A: transfer to non ERC721Receiver implementer"
1271       );
1272       updatedIndex++;
1273     }
1274 
1275     currentIndex = updatedIndex;
1276     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1277   }
1278 
1279   /**
1280    * @dev Transfers tokenId from from to to.
1281    *
1282    * Requirements:
1283    *
1284    * - to cannot be the zero address.
1285    * - tokenId token must be owned by from.
1286    *
1287    * Emits a {Transfer} event.
1288    */
1289   function _transfer(
1290     address from,
1291     address to,
1292     uint256 tokenId
1293   ) private {
1294     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1295 
1296     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1297       getApproved(tokenId) == _msgSender() ||
1298       isApprovedForAll(prevOwnership.addr, _msgSender()));
1299 
1300     require(
1301       isApprovedOrOwner,
1302       "ERC721A: transfer caller is not owner nor approved"
1303     );
1304 
1305     require(
1306       prevOwnership.addr == from,
1307       "ERC721A: transfer from incorrect owner"
1308     );
1309     require(to != address(0), "ERC721A: transfer to the zero address");
1310 
1311     _beforeTokenTransfers(from, to, tokenId, 1);
1312 
1313     // Clear approvals from the previous owner
1314     _approve(address(0), tokenId, prevOwnership.addr);
1315 
1316     _addressData[from].balance -= 1;
1317     _addressData[to].balance += 1;
1318     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1319 
1320     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1321     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1322     uint256 nextTokenId = tokenId + 1;
1323     if (_ownerships[nextTokenId].addr == address(0)) {
1324       if (_exists(nextTokenId)) {
1325         _ownerships[nextTokenId] = TokenOwnership(
1326           prevOwnership.addr,
1327           prevOwnership.startTimestamp
1328         );
1329       }
1330     }
1331 
1332     emit Transfer(from, to, tokenId);
1333     _afterTokenTransfers(from, to, tokenId, 1);
1334   }
1335 
1336   /**
1337    * @dev Approve to to operate on tokenId
1338    *
1339    * Emits a {Approval} event.
1340    */
1341   function _approve(
1342     address to,
1343     uint256 tokenId,
1344     address owner
1345   ) private {
1346     _tokenApprovals[tokenId] = to;
1347     emit Approval(owner, to, tokenId);
1348   }
1349 
1350   uint256 public nextOwnerToExplicitlySet = 0;
1351 
1352   /**
1353    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1354    */
1355   function _setOwnersExplicit(uint256 quantity) internal {
1356     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1357     require(quantity > 0, "quantity must be nonzero");
1358     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1359 
1360     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1361     if (endIndex > collectionSize - 1) {
1362       endIndex = collectionSize - 1;
1363     }
1364     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1365     require(_exists(endIndex), "not enough minted yet for this cleanup");
1366     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1367       if (_ownerships[i].addr == address(0)) {
1368         TokenOwnership memory ownership = ownershipOf(i);
1369         _ownerships[i] = TokenOwnership(
1370           ownership.addr,
1371           ownership.startTimestamp
1372         );
1373       }
1374     }
1375     nextOwnerToExplicitlySet = endIndex + 1;
1376   }
1377 
1378   /**
1379    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1380    * The call is not executed if the target address is not a contract.
1381    *
1382    * @param from address representing the previous owner of the given token ID
1383    * @param to target address that will receive the tokens
1384    * @param tokenId uint256 ID of the token to be transferred
1385    * @param _data bytes optional data to send along with the call
1386    * @return bool whether the call correctly returned the expected magic value
1387    */
1388   function _checkOnERC721Received(
1389     address from,
1390     address to,
1391     uint256 tokenId,
1392     bytes memory _data
1393   ) private returns (bool) {
1394     if (to.isContract()) {
1395       try
1396         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1397       returns (bytes4 retval) {
1398         return retval == IERC721Receiver(to).onERC721Received.selector;
1399       } catch (bytes memory reason) {
1400         if (reason.length == 0) {
1401           revert("ERC721A: transfer to non ERC721Receiver implementer");
1402         } else {
1403           assembly {
1404             revert(add(32, reason), mload(reason))
1405           }
1406         }
1407       }
1408     } else {
1409       return true;
1410     }
1411   }
1412 
1413   /**
1414    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1415    *
1416    * startTokenId - the first token id to be transferred
1417    * quantity - the amount to be transferred
1418    *
1419    * Calling conditions:
1420    *
1421    * - When from and to are both non-zero, from's tokenId will be
1422    * transferred to to.
1423    * - When from is zero, tokenId will be minted for to.
1424    */
1425   function _beforeTokenTransfers(
1426     address from,
1427     address to,
1428     uint256 startTokenId,
1429     uint256 quantity
1430   ) internal virtual {}
1431 
1432   /**
1433    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1434    * minting.
1435    *
1436    * startTokenId - the first token id to be transferred
1437    * quantity - the amount to be transferred
1438    *
1439    * Calling conditions:
1440    *
1441    * - when from and to are both non-zero.
1442    * - from and to are never both zero.
1443    */
1444   function _afterTokenTransfers(
1445     address from,
1446     address to,
1447     uint256 startTokenId,
1448     uint256 quantity
1449   ) internal virtual {}
1450 }
1451 
1452 
1453 
1454   
1455 abstract contract Ramppable {
1456   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1457 
1458   modifier isRampp() {
1459       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1460       _;
1461   }
1462 }
1463 
1464 
1465   
1466 /** TimedDrop.sol
1467 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1468 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1469 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1470 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1471 */
1472 abstract contract TimedDrop is Ownable {
1473   bool public enforcePublicDropTime = true;
1474   uint256 public publicDropTime = 1656208800;
1475   
1476   /**
1477   * @dev Allow the contract owner to set the public time to mint.
1478   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1479   */
1480   function setPublicDropTime(uint256 _newDropTime) public onlyOwner {
1481     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1482     publicDropTime = _newDropTime;
1483   }
1484 
1485   function usePublicDropTime() public onlyOwner {
1486     enforcePublicDropTime = true;
1487   }
1488 
1489   function disablePublicDropTime() public onlyOwner {
1490     enforcePublicDropTime = false;
1491   }
1492 
1493   /**
1494   * @dev determine if the public droptime has passed.
1495   * if the feature is disabled then assume the time has passed.
1496   */
1497   function publicDropTimePassed() public view returns(bool) {
1498     if(enforcePublicDropTime == false) {
1499       return true;
1500     }
1501     return block.timestamp >= publicDropTime;
1502   }
1503   
1504   // Allowlist implementation of the Timed Drop feature
1505   bool public enforceAllowlistDropTime = true;
1506   uint256 public allowlistDropTime = 1656208500;
1507 
1508   /**
1509   * @dev Allow the contract owner to set the allowlist time to mint.
1510   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1511   */
1512   function setAllowlistDropTime(uint256 _newDropTime) public onlyOwner {
1513     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1514     allowlistDropTime = _newDropTime;
1515   }
1516 
1517   function useAllowlistDropTime() public onlyOwner {
1518     enforceAllowlistDropTime = true;
1519   }
1520 
1521   function disableAllowlistDropTime() public onlyOwner {
1522     enforceAllowlistDropTime = false;
1523   }
1524 
1525   function allowlistDropTimePassed() public view returns(bool) {
1526     if(enforceAllowlistDropTime == false) {
1527       return true;
1528     }
1529 
1530     return block.timestamp >= allowlistDropTime;
1531   }
1532 }
1533 
1534   
1535 interface IERC20 {
1536   function transfer(address _to, uint256 _amount) external returns (bool);
1537   function balanceOf(address account) external view returns (uint256);
1538 }
1539 
1540 abstract contract Withdrawable is Ownable, Ramppable {
1541   address[] public payableAddresses = [RAMPPADDRESS,0xF4ed0716C55fbCa4DB1a772FF2f32902B120843a];
1542   uint256[] public payableFees = [5,95];
1543   uint256 public payableAddressCount = 2;
1544 
1545   function withdrawAll() public onlyOwner {
1546       require(address(this).balance > 0);
1547       _withdrawAll();
1548   }
1549   
1550   function withdrawAllRampp() public isRampp {
1551       require(address(this).balance > 0);
1552       _withdrawAll();
1553   }
1554 
1555   function _withdrawAll() private {
1556       uint256 balance = address(this).balance;
1557       
1558       for(uint i=0; i < payableAddressCount; i++ ) {
1559           _widthdraw(
1560               payableAddresses[i],
1561               (balance * payableFees[i]) / 100
1562           );
1563       }
1564   }
1565   
1566   function _widthdraw(address _address, uint256 _amount) private {
1567       (bool success, ) = _address.call{value: _amount}("");
1568       require(success, "Transfer failed.");
1569   }
1570 
1571   /**
1572     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1573     * while still splitting royalty payments to all other team members.
1574     * in the event ERC-20 tokens are paid to the contract.
1575     * @param _tokenContract contract of ERC-20 token to withdraw
1576     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1577     */
1578   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1579     require(_amount > 0);
1580     IERC20 tokenContract = IERC20(_tokenContract);
1581     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1582 
1583     for(uint i=0; i < payableAddressCount; i++ ) {
1584         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1585     }
1586   }
1587 
1588   /**
1589   * @dev Allows Rampp wallet to update its own reference as well as update
1590   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1591   * and since Rampp is always the first address this function is limited to the rampp payout only.
1592   * @param _newAddress updated Rampp Address
1593   */
1594   function setRamppAddress(address _newAddress) public isRampp {
1595     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1596     RAMPPADDRESS = _newAddress;
1597     payableAddresses[0] = _newAddress;
1598   }
1599 }
1600 
1601 
1602   
1603   
1604 // File: EarlyMintIncentive.sol
1605 // Allows the contract to have the first x tokens have a discount or
1606 // zero fee that can be calculated on the fly.
1607 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1608   uint256 public PRICE = 0.01 ether;
1609   uint256 public EARLY_MINT_PRICE = 0 ether;
1610   uint256 public earlyMintTokenIdCap = 1000;
1611   bool public usingEarlyMintIncentive = true;
1612 
1613   function enableEarlyMintIncentive() public onlyOwner {
1614     usingEarlyMintIncentive = true;
1615   }
1616 
1617   function disableEarlyMintIncentive() public onlyOwner {
1618     usingEarlyMintIncentive = false;
1619   }
1620 
1621   /**
1622   * @dev Set the max token ID in which the cost incentive will be applied.
1623   * @param _newTokenIdCap max tokenId in which incentive will be applied
1624   */
1625   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1626     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1627     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1628     earlyMintTokenIdCap = _newTokenIdCap;
1629   }
1630 
1631   /**
1632   * @dev Set the incentive mint price
1633   * @param _feeInWei new price per token when in incentive range
1634   */
1635   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1636     EARLY_MINT_PRICE = _feeInWei;
1637   }
1638 
1639   /**
1640   * @dev Set the primary mint price - the base price when not under incentive
1641   * @param _feeInWei new price per token
1642   */
1643   function setPrice(uint256 _feeInWei) public onlyOwner {
1644     PRICE = _feeInWei;
1645   }
1646 
1647   function getPrice(uint256 _count) public view returns (uint256) {
1648     require(_count > 0, "Must be minting at least 1 token.");
1649 
1650     // short circuit function if we dont need to even calc incentive pricing
1651     // short circuit if the current tokenId is also already over cap
1652     if(
1653       usingEarlyMintIncentive == false ||
1654       currentTokenId() > earlyMintTokenIdCap
1655     ) {
1656       return PRICE * _count;
1657     }
1658 
1659     uint256 endingTokenId = currentTokenId() + _count;
1660     // If qty to mint results in a final token ID less than or equal to the cap then
1661     // the entire qty is within free mint.
1662     if(endingTokenId  <= earlyMintTokenIdCap) {
1663       return EARLY_MINT_PRICE * _count;
1664     }
1665 
1666     // If the current token id is less than the incentive cap
1667     // and the ending token ID is greater than the incentive cap
1668     // we will be straddling the cap so there will be some amount
1669     // that are incentive and some that are regular fee.
1670     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1671     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1672 
1673     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1674   }
1675 }
1676 
1677   
1678 abstract contract RamppERC721A is 
1679     Ownable,
1680     ERC721A,
1681     Withdrawable,
1682     ReentrancyGuard 
1683     , EarlyMintIncentive 
1684     , Allowlist 
1685     , TimedDrop
1686 {
1687   constructor(
1688     string memory tokenName,
1689     string memory tokenSymbol
1690   ) ERC721A(tokenName, tokenSymbol, 1, 4444) { }
1691     uint8 public CONTRACT_VERSION = 2;
1692     string public _baseTokenURI = "ipfs://QmRA9CMboWYxcQYRe1JqPCZrydS9TfKombKbTKKRuR8U6D/";
1693 
1694     bool public mintingOpen = false;
1695     bool public isRevealed = false;
1696     
1697 
1698   
1699     /////////////// Admin Mint Functions
1700     /**
1701      * @dev Mints a token to an address with a tokenURI.
1702      * This is owner only and allows a fee-free drop
1703      * @param _to address of the future owner of the token
1704      * @param _qty amount of tokens to drop the owner
1705      */
1706      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1707          require(_qty > 0, "Must mint at least 1 token.");
1708          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 4444");
1709          _safeMint(_to, _qty, true);
1710      }
1711 
1712   
1713     /////////////// GENERIC MINT FUNCTIONS
1714     /**
1715     * @dev Mints a single token to an address.
1716     * fee may or may not be required*
1717     * @param _to address of the future owner of the token
1718     */
1719     function mintTo(address _to) public payable {
1720         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4444");
1721         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1722         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1723         
1724         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1725         
1726         _safeMint(_to, 1, false);
1727     }
1728 
1729     /**
1730     * @dev Mints a token to an address with a tokenURI.
1731     * fee may or may not be required*
1732     * @param _to address of the future owner of the token
1733     * @param _amount number of tokens to mint
1734     */
1735     function mintToMultiple(address _to, uint256 _amount) public payable {
1736         require(_amount >= 1, "Must mint at least 1 token");
1737         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1738         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1739         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1740         
1741         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4444");
1742         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1743 
1744         _safeMint(_to, _amount, false);
1745     }
1746 
1747     function openMinting() public onlyOwner {
1748         mintingOpen = true;
1749     }
1750 
1751     function stopMinting() public onlyOwner {
1752         mintingOpen = false;
1753     }
1754 
1755   
1756     ///////////// ALLOWLIST MINTING FUNCTIONS
1757 
1758     /**
1759     * @dev Mints a token to an address with a tokenURI for allowlist.
1760     * fee may or may not be required*
1761     * @param _to address of the future owner of the token
1762     */
1763     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1764         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1765         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1766         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 4444");
1767         
1768         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1769         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1770 
1771         _safeMint(_to, 1, false);
1772     }
1773 
1774     /**
1775     * @dev Mints a token to an address with a tokenURI for allowlist.
1776     * fee may or may not be required*
1777     * @param _to address of the future owner of the token
1778     * @param _amount number of tokens to mint
1779     */
1780     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1781         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1782         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1783         require(_amount >= 1, "Must mint at least 1 token");
1784         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1785 
1786         
1787         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 4444");
1788         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1789         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
1790 
1791         _safeMint(_to, _amount, false);
1792     }
1793 
1794     /**
1795      * @dev Enable allowlist minting fully by enabling both flags
1796      * This is a convenience function for the Rampp user
1797      */
1798     function openAllowlistMint() public onlyOwner {
1799         enableAllowlistOnlyMode();
1800         mintingOpen = true;
1801     }
1802 
1803     /**
1804      * @dev Close allowlist minting fully by disabling both flags
1805      * This is a convenience function for the Rampp user
1806      */
1807     function closeAllowlistMint() public onlyOwner {
1808         disableAllowlistOnlyMode();
1809         mintingOpen = false;
1810     }
1811 
1812 
1813   
1814 
1815   
1816     /**
1817      * @dev Allows owner to set Max mints per tx
1818      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1819      */
1820      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1821          require(_newMaxMint >= 1, "Max mint must be at least 1");
1822          maxBatchSize = _newMaxMint;
1823      }
1824     
1825 
1826   
1827     function unveil(string memory _updatedTokenURI) public onlyOwner {
1828         require(isRevealed == false, "Tokens are already unveiled");
1829         _baseTokenURI = _updatedTokenURI;
1830         isRevealed = true;
1831     }
1832     
1833 
1834   function _baseURI() internal view virtual override returns(string memory) {
1835     return _baseTokenURI;
1836   }
1837 
1838   function baseTokenURI() public view returns(string memory) {
1839     return _baseTokenURI;
1840   }
1841 
1842   function setBaseURI(string calldata baseURI) external onlyOwner {
1843     _baseTokenURI = baseURI;
1844   }
1845 
1846   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1847     return ownershipOf(tokenId);
1848   }
1849 }
1850 
1851 
1852   
1853 // File: contracts/BoolishbunniesContract.sol
1854 //SPDX-License-Identifier: MIT
1855 
1856 pragma solidity ^0.8.0;
1857 
1858 contract BoolishbunniesContract is RamppERC721A {
1859     constructor() RamppERC721A("boolish bunnies", "BOOLISH"){}
1860 }
1861   