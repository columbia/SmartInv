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
768 // Rampp Contracts v2.1 (Teams.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 /**
773 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
774 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
775 * This will easily allow cross-collaboration via Mintplex.xyz.
776 **/
777 abstract contract Teams is Ownable{
778   mapping (address => bool) internal team;
779 
780   /**
781   * @dev Adds an address to the team. Allows them to execute protected functions
782   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
783   **/
784   function addToTeam(address _address) public onlyOwner {
785     require(_address != address(0), "Invalid address");
786     require(!inTeam(_address), "This address is already in your team.");
787   
788     team[_address] = true;
789   }
790 
791   /**
792   * @dev Removes an address to the team.
793   * @param _address the ETH address to remove, cannot be 0x and must be in team
794   **/
795   function removeFromTeam(address _address) public onlyOwner {
796     require(_address != address(0), "Invalid address");
797     require(inTeam(_address), "This address is not in your team currently.");
798   
799     team[_address] = false;
800   }
801 
802   /**
803   * @dev Check if an address is valid and active in the team
804   * @param _address ETH address to check for truthiness
805   **/
806   function inTeam(address _address)
807     public
808     view
809     returns (bool)
810   {
811     require(_address != address(0), "Invalid address to check.");
812     return team[_address] == true;
813   }
814 
815   /**
816   * @dev Throws if called by any account other than the owner or team member.
817   */
818   modifier onlyTeamOrOwner() {
819     bool _isOwner = owner() == _msgSender();
820     bool _isTeam = inTeam(_msgSender());
821     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
822     _;
823   }
824 }
825 
826 
827   
828   
829 /**
830  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
831  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
832  *
833  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
834  * 
835  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
836  *
837  * Does not support burning tokens to address(0).
838  */
839 contract ERC721A is
840   Context,
841   ERC165,
842   IERC721,
843   IERC721Metadata,
844   IERC721Enumerable,
845   Teams
846 {
847   using Address for address;
848   using Strings for uint256;
849 
850   struct TokenOwnership {
851     address addr;
852     uint64 startTimestamp;
853   }
854 
855   struct AddressData {
856     uint128 balance;
857     uint128 numberMinted;
858   }
859 
860   uint256 private currentIndex;
861 
862   uint256 public immutable collectionSize;
863   uint256 public maxBatchSize;
864 
865   // Token name
866   string private _name;
867 
868   // Token symbol
869   string private _symbol;
870 
871   // Mapping from token ID to ownership details
872   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
873   mapping(uint256 => TokenOwnership) private _ownerships;
874 
875   // Mapping owner address to address data
876   mapping(address => AddressData) private _addressData;
877 
878   // Mapping from token ID to approved address
879   mapping(uint256 => address) private _tokenApprovals;
880 
881   // Mapping from owner to operator approvals
882   mapping(address => mapping(address => bool)) private _operatorApprovals;
883 
884   /* @dev Mapping of restricted operator approvals set by contract Owner
885   * This serves as an optional addition to ERC-721 so
886   * that the contract owner can elect to prevent specific addresses/contracts
887   * from being marked as the approver for a token. The reason for this
888   * is that some projects may want to retain control of where their tokens can/can not be listed
889   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
890   * By default, there are no restrictions. The contract owner must deliberatly block an address 
891   */
892   mapping(address => bool) public restrictedApprovalAddresses;
893 
894   /**
895    * @dev
896    * maxBatchSize refers to how much a minter can mint at a time.
897    * collectionSize_ refers to how many tokens are in the collection.
898    */
899   constructor(
900     string memory name_,
901     string memory symbol_,
902     uint256 maxBatchSize_,
903     uint256 collectionSize_
904   ) {
905     require(
906       collectionSize_ > 0,
907       "ERC721A: collection must have a nonzero supply"
908     );
909     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
910     _name = name_;
911     _symbol = symbol_;
912     maxBatchSize = maxBatchSize_;
913     collectionSize = collectionSize_;
914     currentIndex = _startTokenId();
915   }
916 
917   /**
918   * To change the starting tokenId, please override this function.
919   */
920   function _startTokenId() internal view virtual returns (uint256) {
921     return 1;
922   }
923 
924   /**
925    * @dev See {IERC721Enumerable-totalSupply}.
926    */
927   function totalSupply() public view override returns (uint256) {
928     return _totalMinted();
929   }
930 
931   function currentTokenId() public view returns (uint256) {
932     return _totalMinted();
933   }
934 
935   function getNextTokenId() public view returns (uint256) {
936       return _totalMinted() + 1;
937   }
938 
939   /**
940   * Returns the total amount of tokens minted in the contract.
941   */
942   function _totalMinted() internal view returns (uint256) {
943     unchecked {
944       return currentIndex - _startTokenId();
945     }
946   }
947 
948   /**
949    * @dev See {IERC721Enumerable-tokenByIndex}.
950    */
951   function tokenByIndex(uint256 index) public view override returns (uint256) {
952     require(index < totalSupply(), "ERC721A: global index out of bounds");
953     return index;
954   }
955 
956   /**
957    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
958    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
959    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
960    */
961   function tokenOfOwnerByIndex(address owner, uint256 index)
962     public
963     view
964     override
965     returns (uint256)
966   {
967     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
968     uint256 numMintedSoFar = totalSupply();
969     uint256 tokenIdsIdx = 0;
970     address currOwnershipAddr = address(0);
971     for (uint256 i = 0; i < numMintedSoFar; i++) {
972       TokenOwnership memory ownership = _ownerships[i];
973       if (ownership.addr != address(0)) {
974         currOwnershipAddr = ownership.addr;
975       }
976       if (currOwnershipAddr == owner) {
977         if (tokenIdsIdx == index) {
978           return i;
979         }
980         tokenIdsIdx++;
981       }
982     }
983     revert("ERC721A: unable to get token of owner by index");
984   }
985 
986   /**
987    * @dev See {IERC165-supportsInterface}.
988    */
989   function supportsInterface(bytes4 interfaceId)
990     public
991     view
992     virtual
993     override(ERC165, IERC165)
994     returns (bool)
995   {
996     return
997       interfaceId == type(IERC721).interfaceId ||
998       interfaceId == type(IERC721Metadata).interfaceId ||
999       interfaceId == type(IERC721Enumerable).interfaceId ||
1000       super.supportsInterface(interfaceId);
1001   }
1002 
1003   /**
1004    * @dev See {IERC721-balanceOf}.
1005    */
1006   function balanceOf(address owner) public view override returns (uint256) {
1007     require(owner != address(0), "ERC721A: balance query for the zero address");
1008     return uint256(_addressData[owner].balance);
1009   }
1010 
1011   function _numberMinted(address owner) internal view returns (uint256) {
1012     require(
1013       owner != address(0),
1014       "ERC721A: number minted query for the zero address"
1015     );
1016     return uint256(_addressData[owner].numberMinted);
1017   }
1018 
1019   function ownershipOf(uint256 tokenId)
1020     internal
1021     view
1022     returns (TokenOwnership memory)
1023   {
1024     uint256 curr = tokenId;
1025 
1026     unchecked {
1027         if (_startTokenId() <= curr && curr < currentIndex) {
1028             TokenOwnership memory ownership = _ownerships[curr];
1029             if (ownership.addr != address(0)) {
1030                 return ownership;
1031             }
1032 
1033             // Invariant:
1034             // There will always be an ownership that has an address and is not burned
1035             // before an ownership that does not have an address and is not burned.
1036             // Hence, curr will not underflow.
1037             while (true) {
1038                 curr--;
1039                 ownership = _ownerships[curr];
1040                 if (ownership.addr != address(0)) {
1041                     return ownership;
1042                 }
1043             }
1044         }
1045     }
1046 
1047     revert("ERC721A: unable to determine the owner of token");
1048   }
1049 
1050   /**
1051    * @dev See {IERC721-ownerOf}.
1052    */
1053   function ownerOf(uint256 tokenId) public view override returns (address) {
1054     return ownershipOf(tokenId).addr;
1055   }
1056 
1057   /**
1058    * @dev See {IERC721Metadata-name}.
1059    */
1060   function name() public view virtual override returns (string memory) {
1061     return _name;
1062   }
1063 
1064   /**
1065    * @dev See {IERC721Metadata-symbol}.
1066    */
1067   function symbol() public view virtual override returns (string memory) {
1068     return _symbol;
1069   }
1070 
1071   /**
1072    * @dev See {IERC721Metadata-tokenURI}.
1073    */
1074   function tokenURI(uint256 tokenId)
1075     public
1076     view
1077     virtual
1078     override
1079     returns (string memory)
1080   {
1081     string memory baseURI = _baseURI();
1082     return
1083       bytes(baseURI).length > 0
1084         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1085         : "";
1086   }
1087 
1088   /**
1089    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1090    * token will be the concatenation of the baseURI and the tokenId. Empty
1091    * by default, can be overriden in child contracts.
1092    */
1093   function _baseURI() internal view virtual returns (string memory) {
1094     return "";
1095   }
1096 
1097   /**
1098    * @dev Sets the value for an address to be in the restricted approval address pool.
1099    * Setting an address to true will disable token owners from being able to mark the address
1100    * for approval for trading. This would be used in theory to prevent token owners from listing
1101    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1102    * @param _address the marketplace/user to modify restriction status of
1103    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1104    */
1105   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1106     restrictedApprovalAddresses[_address] = _isRestricted;
1107   }
1108 
1109   /**
1110    * @dev See {IERC721-approve}.
1111    */
1112   function approve(address to, uint256 tokenId) public override {
1113     address owner = ERC721A.ownerOf(tokenId);
1114     require(to != owner, "ERC721A: approval to current owner");
1115     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1116 
1117     require(
1118       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1119       "ERC721A: approve caller is not owner nor approved for all"
1120     );
1121 
1122     _approve(to, tokenId, owner);
1123   }
1124 
1125   /**
1126    * @dev See {IERC721-getApproved}.
1127    */
1128   function getApproved(uint256 tokenId) public view override returns (address) {
1129     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1130 
1131     return _tokenApprovals[tokenId];
1132   }
1133 
1134   /**
1135    * @dev See {IERC721-setApprovalForAll}.
1136    */
1137   function setApprovalForAll(address operator, bool approved) public override {
1138     require(operator != _msgSender(), "ERC721A: approve to caller");
1139     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1140 
1141     _operatorApprovals[_msgSender()][operator] = approved;
1142     emit ApprovalForAll(_msgSender(), operator, approved);
1143   }
1144 
1145   /**
1146    * @dev See {IERC721-isApprovedForAll}.
1147    */
1148   function isApprovedForAll(address owner, address operator)
1149     public
1150     view
1151     virtual
1152     override
1153     returns (bool)
1154   {
1155     return _operatorApprovals[owner][operator];
1156   }
1157 
1158   /**
1159    * @dev See {IERC721-transferFrom}.
1160    */
1161   function transferFrom(
1162     address from,
1163     address to,
1164     uint256 tokenId
1165   ) public override {
1166     _transfer(from, to, tokenId);
1167   }
1168 
1169   /**
1170    * @dev See {IERC721-safeTransferFrom}.
1171    */
1172   function safeTransferFrom(
1173     address from,
1174     address to,
1175     uint256 tokenId
1176   ) public override {
1177     safeTransferFrom(from, to, tokenId, "");
1178   }
1179 
1180   /**
1181    * @dev See {IERC721-safeTransferFrom}.
1182    */
1183   function safeTransferFrom(
1184     address from,
1185     address to,
1186     uint256 tokenId,
1187     bytes memory _data
1188   ) public override {
1189     _transfer(from, to, tokenId);
1190     require(
1191       _checkOnERC721Received(from, to, tokenId, _data),
1192       "ERC721A: transfer to non ERC721Receiver implementer"
1193     );
1194   }
1195 
1196   /**
1197    * @dev Returns whether tokenId exists.
1198    *
1199    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1200    *
1201    * Tokens start existing when they are minted (_mint),
1202    */
1203   function _exists(uint256 tokenId) internal view returns (bool) {
1204     return _startTokenId() <= tokenId && tokenId < currentIndex;
1205   }
1206 
1207   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1208     _safeMint(to, quantity, isAdminMint, "");
1209   }
1210 
1211   /**
1212    * @dev Mints quantity tokens and transfers them to to.
1213    *
1214    * Requirements:
1215    *
1216    * - there must be quantity tokens remaining unminted in the total collection.
1217    * - to cannot be the zero address.
1218    * - quantity cannot be larger than the max batch size.
1219    *
1220    * Emits a {Transfer} event.
1221    */
1222   function _safeMint(
1223     address to,
1224     uint256 quantity,
1225     bool isAdminMint,
1226     bytes memory _data
1227   ) internal {
1228     uint256 startTokenId = currentIndex;
1229     require(to != address(0), "ERC721A: mint to the zero address");
1230     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1231     require(!_exists(startTokenId), "ERC721A: token already minted");
1232 
1233     // For admin mints we do not want to enforce the maxBatchSize limit
1234     if (isAdminMint == false) {
1235         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1236     }
1237 
1238     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1239 
1240     AddressData memory addressData = _addressData[to];
1241     _addressData[to] = AddressData(
1242       addressData.balance + uint128(quantity),
1243       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1244     );
1245     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1246 
1247     uint256 updatedIndex = startTokenId;
1248 
1249     for (uint256 i = 0; i < quantity; i++) {
1250       emit Transfer(address(0), to, updatedIndex);
1251       require(
1252         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1253         "ERC721A: transfer to non ERC721Receiver implementer"
1254       );
1255       updatedIndex++;
1256     }
1257 
1258     currentIndex = updatedIndex;
1259     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1260   }
1261 
1262   /**
1263    * @dev Transfers tokenId from from to to.
1264    *
1265    * Requirements:
1266    *
1267    * - to cannot be the zero address.
1268    * - tokenId token must be owned by from.
1269    *
1270    * Emits a {Transfer} event.
1271    */
1272   function _transfer(
1273     address from,
1274     address to,
1275     uint256 tokenId
1276   ) private {
1277     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1278 
1279     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1280       getApproved(tokenId) == _msgSender() ||
1281       isApprovedForAll(prevOwnership.addr, _msgSender()));
1282 
1283     require(
1284       isApprovedOrOwner,
1285       "ERC721A: transfer caller is not owner nor approved"
1286     );
1287 
1288     require(
1289       prevOwnership.addr == from,
1290       "ERC721A: transfer from incorrect owner"
1291     );
1292     require(to != address(0), "ERC721A: transfer to the zero address");
1293 
1294     _beforeTokenTransfers(from, to, tokenId, 1);
1295 
1296     // Clear approvals from the previous owner
1297     _approve(address(0), tokenId, prevOwnership.addr);
1298 
1299     _addressData[from].balance -= 1;
1300     _addressData[to].balance += 1;
1301     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1302 
1303     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1304     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1305     uint256 nextTokenId = tokenId + 1;
1306     if (_ownerships[nextTokenId].addr == address(0)) {
1307       if (_exists(nextTokenId)) {
1308         _ownerships[nextTokenId] = TokenOwnership(
1309           prevOwnership.addr,
1310           prevOwnership.startTimestamp
1311         );
1312       }
1313     }
1314 
1315     emit Transfer(from, to, tokenId);
1316     _afterTokenTransfers(from, to, tokenId, 1);
1317   }
1318 
1319   /**
1320    * @dev Approve to to operate on tokenId
1321    *
1322    * Emits a {Approval} event.
1323    */
1324   function _approve(
1325     address to,
1326     uint256 tokenId,
1327     address owner
1328   ) private {
1329     _tokenApprovals[tokenId] = to;
1330     emit Approval(owner, to, tokenId);
1331   }
1332 
1333   uint256 public nextOwnerToExplicitlySet = 0;
1334 
1335   /**
1336    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1337    */
1338   function _setOwnersExplicit(uint256 quantity) internal {
1339     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1340     require(quantity > 0, "quantity must be nonzero");
1341     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1342 
1343     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1344     if (endIndex > collectionSize - 1) {
1345       endIndex = collectionSize - 1;
1346     }
1347     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1348     require(_exists(endIndex), "not enough minted yet for this cleanup");
1349     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1350       if (_ownerships[i].addr == address(0)) {
1351         TokenOwnership memory ownership = ownershipOf(i);
1352         _ownerships[i] = TokenOwnership(
1353           ownership.addr,
1354           ownership.startTimestamp
1355         );
1356       }
1357     }
1358     nextOwnerToExplicitlySet = endIndex + 1;
1359   }
1360 
1361   /**
1362    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1363    * The call is not executed if the target address is not a contract.
1364    *
1365    * @param from address representing the previous owner of the given token ID
1366    * @param to target address that will receive the tokens
1367    * @param tokenId uint256 ID of the token to be transferred
1368    * @param _data bytes optional data to send along with the call
1369    * @return bool whether the call correctly returned the expected magic value
1370    */
1371   function _checkOnERC721Received(
1372     address from,
1373     address to,
1374     uint256 tokenId,
1375     bytes memory _data
1376   ) private returns (bool) {
1377     if (to.isContract()) {
1378       try
1379         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1380       returns (bytes4 retval) {
1381         return retval == IERC721Receiver(to).onERC721Received.selector;
1382       } catch (bytes memory reason) {
1383         if (reason.length == 0) {
1384           revert("ERC721A: transfer to non ERC721Receiver implementer");
1385         } else {
1386           assembly {
1387             revert(add(32, reason), mload(reason))
1388           }
1389         }
1390       }
1391     } else {
1392       return true;
1393     }
1394   }
1395 
1396   /**
1397    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1398    *
1399    * startTokenId - the first token id to be transferred
1400    * quantity - the amount to be transferred
1401    *
1402    * Calling conditions:
1403    *
1404    * - When from and to are both non-zero, from's tokenId will be
1405    * transferred to to.
1406    * - When from is zero, tokenId will be minted for to.
1407    */
1408   function _beforeTokenTransfers(
1409     address from,
1410     address to,
1411     uint256 startTokenId,
1412     uint256 quantity
1413   ) internal virtual {}
1414 
1415   /**
1416    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1417    * minting.
1418    *
1419    * startTokenId - the first token id to be transferred
1420    * quantity - the amount to be transferred
1421    *
1422    * Calling conditions:
1423    *
1424    * - when from and to are both non-zero.
1425    * - from and to are never both zero.
1426    */
1427   function _afterTokenTransfers(
1428     address from,
1429     address to,
1430     uint256 startTokenId,
1431     uint256 quantity
1432   ) internal virtual {}
1433 }
1434 
1435 
1436 
1437   
1438 abstract contract Ramppable {
1439   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1440 
1441   modifier isRampp() {
1442       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1443       _;
1444   }
1445 }
1446 
1447 
1448   
1449   
1450 interface IERC20 {
1451   function allowance(address owner, address spender) external view returns (uint256);
1452   function transfer(address _to, uint256 _amount) external returns (bool);
1453   function balanceOf(address account) external view returns (uint256);
1454   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1455 }
1456 
1457 // File: WithdrawableV2
1458 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1459 // ERC-20 Payouts are limited to a single payout address. This feature 
1460 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1461 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1462 abstract contract WithdrawableV2 is Teams, Ramppable {
1463   struct acceptedERC20 {
1464     bool isActive;
1465     uint256 chargeAmount;
1466   }
1467 
1468   
1469   mapping(address => acceptedERC20) private allowedTokenContracts;
1470   address[] public payableAddresses = [RAMPPADDRESS,0xe60C31BCA36A59825814588eEAa9412743F1bfA3];
1471   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1472   address public erc20Payable = 0xe60C31BCA36A59825814588eEAa9412743F1bfA3;
1473   uint256[] public payableFees = [5,95];
1474   uint256[] public surchargePayableFees = [100];
1475   uint256 public payableAddressCount = 2;
1476   uint256 public surchargePayableAddressCount = 1;
1477   uint256 public ramppSurchargeBalance = 0 ether;
1478   uint256 public ramppSurchargeFee = 0.001 ether;
1479   bool public onlyERC20MintingMode = false;
1480   
1481 
1482   /**
1483   * @dev Calculates the true payable balance of the contract as the
1484   * value on contract may be from ERC-20 mint surcharges and not 
1485   * public mint charges - which are not eligable for rev share & user withdrawl
1486   */
1487   function calcAvailableBalance() public view returns(uint256) {
1488     return address(this).balance - ramppSurchargeBalance;
1489   }
1490 
1491   function withdrawAll() public onlyTeamOrOwner {
1492       require(calcAvailableBalance() > 0);
1493       _withdrawAll();
1494   }
1495   
1496   function withdrawAllRampp() public isRampp {
1497       require(calcAvailableBalance() > 0);
1498       _withdrawAll();
1499   }
1500 
1501   function _withdrawAll() private {
1502       uint256 balance = calcAvailableBalance();
1503       
1504       for(uint i=0; i < payableAddressCount; i++ ) {
1505           _widthdraw(
1506               payableAddresses[i],
1507               (balance * payableFees[i]) / 100
1508           );
1509       }
1510   }
1511   
1512   function _widthdraw(address _address, uint256 _amount) private {
1513       (bool success, ) = _address.call{value: _amount}("");
1514       require(success, "Transfer failed.");
1515   }
1516 
1517   /**
1518   * @dev This function is similiar to the regular withdraw but operates only on the
1519   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1520   **/
1521   function _withdrawAllSurcharges() private {
1522     uint256 balance = ramppSurchargeBalance;
1523     if(balance == 0) { return; }
1524     
1525     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1526         _widthdraw(
1527             surchargePayableAddresses[i],
1528             (balance * surchargePayableFees[i]) / 100
1529         );
1530     }
1531     ramppSurchargeBalance = 0 ether;
1532   }
1533 
1534   /**
1535   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1536   * in the event ERC-20 tokens are paid to the contract for mints. This will
1537   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1538   * @param _tokenContract contract of ERC-20 token to withdraw
1539   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1540   */
1541   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1542     require(_amountToWithdraw > 0);
1543     IERC20 tokenContract = IERC20(_tokenContract);
1544     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1545     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1546     _withdrawAllSurcharges();
1547   }
1548 
1549   /**
1550   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1551   */
1552   function withdrawRamppSurcharges() public isRampp {
1553     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1554     _withdrawAllSurcharges();
1555   }
1556 
1557    /**
1558   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1559   */
1560   function addSurcharge() internal {
1561     ramppSurchargeBalance += ramppSurchargeFee;
1562   }
1563   
1564   /**
1565   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1566   */
1567   function hasSurcharge() internal returns(bool) {
1568     return msg.value == ramppSurchargeFee;
1569   }
1570 
1571   /**
1572   * @dev Set surcharge fee for using ERC-20 payments on contract
1573   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1574   */
1575   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1576     ramppSurchargeFee = _newSurcharge;
1577   }
1578 
1579   /**
1580   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1581   * @param _erc20TokenContract address of ERC-20 contract in question
1582   */
1583   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1584     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1585   }
1586 
1587   /**
1588   * @dev get the value of tokens to transfer for user of an ERC-20
1589   * @param _erc20TokenContract address of ERC-20 contract in question
1590   */
1591   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1592     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1593     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1594   }
1595 
1596   /**
1597   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1598   * @param _erc20TokenContract address of ERC-20 contract in question
1599   * @param _isActive default status of if contract should be allowed to accept payments
1600   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1601   */
1602   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1603     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1604     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1605   }
1606 
1607   /**
1608   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1609   * it will assume the default value of zero. This should not be used to create new payment tokens.
1610   * @param _erc20TokenContract address of ERC-20 contract in question
1611   */
1612   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1613     allowedTokenContracts[_erc20TokenContract].isActive = true;
1614   }
1615 
1616   /**
1617   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1618   * it will assume the default value of zero. This should not be used to create new payment tokens.
1619   * @param _erc20TokenContract address of ERC-20 contract in question
1620   */
1621   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1622     allowedTokenContracts[_erc20TokenContract].isActive = false;
1623   }
1624 
1625   /**
1626   * @dev Enable only ERC-20 payments for minting on this contract
1627   */
1628   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1629     onlyERC20MintingMode = true;
1630   }
1631 
1632   /**
1633   * @dev Disable only ERC-20 payments for minting on this contract
1634   */
1635   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1636     onlyERC20MintingMode = false;
1637   }
1638 
1639   /**
1640   * @dev Set the payout of the ERC-20 token payout to a specific address
1641   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1642   */
1643   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1644     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1645     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1646     erc20Payable = _newErc20Payable;
1647   }
1648 
1649   /**
1650   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1651   */
1652   function resetRamppSurchargeBalance() public isRampp {
1653     ramppSurchargeBalance = 0 ether;
1654   }
1655 
1656   /**
1657   * @dev Allows Rampp wallet to update its own reference as well as update
1658   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1659   * and since Rampp is always the first address this function is limited to the rampp payout only.
1660   * @param _newAddress updated Rampp Address
1661   */
1662   function setRamppAddress(address _newAddress) public isRampp {
1663     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1664     RAMPPADDRESS = _newAddress;
1665     payableAddresses[0] = _newAddress;
1666   }
1667 }
1668 
1669 
1670   
1671   
1672   
1673   
1674 abstract contract RamppERC721A is 
1675     Ownable,
1676     Teams,
1677     ERC721A,
1678     WithdrawableV2,
1679     ReentrancyGuard 
1680      
1681      
1682     
1683 {
1684   constructor(
1685     string memory tokenName,
1686     string memory tokenSymbol
1687   ) ERC721A(tokenName, tokenSymbol, 3, 5000) { }
1688     uint8 public CONTRACT_VERSION = 2;
1689     string public _baseTokenURI = "ipfs://QmYsDiUSKkkQbQE6QMGtmcnYuNiddNgftqtnC3ynUj4V6b/";
1690 
1691     bool public mintingOpen = true;
1692     
1693     
1694     uint256 public MAX_WALLET_MINTS = 3;
1695 
1696   
1697     /////////////// Admin Mint Functions
1698     /**
1699      * @dev Mints a token to an address with a tokenURI.
1700      * This is owner only and allows a fee-free drop
1701      * @param _to address of the future owner of the token
1702      * @param _qty amount of tokens to drop the owner
1703      */
1704      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1705          require(_qty > 0, "Must mint at least 1 token.");
1706          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5000");
1707          _safeMint(_to, _qty, true);
1708      }
1709 
1710   
1711     /////////////// GENERIC MINT FUNCTIONS
1712     /**
1713     * @dev Mints a single token to an address.
1714     * fee may or may not be required*
1715     * @param _to address of the future owner of the token
1716     */
1717     function mintTo(address _to) public payable {
1718         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1719         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1720         require(mintingOpen == true, "Minting is not open right now!");
1721         
1722         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1723         
1724         
1725         _safeMint(_to, 1, false);
1726     }
1727 
1728     /**
1729     * @dev Mints tokens to an address in batch.
1730     * fee may or may not be required*
1731     * @param _to address of the future owner of the token
1732     * @param _amount number of tokens to mint
1733     */
1734     function mintToMultiple(address _to, uint256 _amount) public payable {
1735         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1736         require(_amount >= 1, "Must mint at least 1 token");
1737         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1738         require(mintingOpen == true, "Minting is not open right now!");
1739         
1740         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1741         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1742         
1743 
1744         _safeMint(_to, _amount, false);
1745     }
1746 
1747     /**
1748      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1749      * fee may or may not be required*
1750      * @param _to address of the future owner of the token
1751      * @param _amount number of tokens to mint
1752      * @param _erc20TokenContract erc-20 token contract to mint with
1753      */
1754     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1755       require(_amount >= 1, "Must mint at least 1 token");
1756       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1757       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1758       require(mintingOpen == true, "Minting is not open right now!");
1759       
1760       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1761 
1762       // ERC-20 Specific pre-flight checks
1763       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1764       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1765       IERC20 payableToken = IERC20(_erc20TokenContract);
1766 
1767       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1768       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1769       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1770       
1771       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1772       require(transferComplete, "ERC-20 token was unable to be transferred");
1773       
1774       _safeMint(_to, _amount, false);
1775       addSurcharge();
1776     }
1777 
1778     function openMinting() public onlyTeamOrOwner {
1779         mintingOpen = true;
1780     }
1781 
1782     function stopMinting() public onlyTeamOrOwner {
1783         mintingOpen = false;
1784     }
1785 
1786   
1787 
1788   
1789     /**
1790     * @dev Check if wallet over MAX_WALLET_MINTS
1791     * @param _address address in question to check if minted count exceeds max
1792     */
1793     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1794         require(_amount >= 1, "Amount must be greater than or equal to 1");
1795         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1796     }
1797 
1798     /**
1799     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1800     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1801     */
1802     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1803         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1804         MAX_WALLET_MINTS = _newWalletMax;
1805     }
1806     
1807 
1808   
1809     /**
1810      * @dev Allows owner to set Max mints per tx
1811      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1812      */
1813      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1814          require(_newMaxMint >= 1, "Max mint must be at least 1");
1815          maxBatchSize = _newMaxMint;
1816      }
1817     
1818 
1819   
1820 
1821   function _baseURI() internal view virtual override returns(string memory) {
1822     return _baseTokenURI;
1823   }
1824 
1825   function baseTokenURI() public view returns(string memory) {
1826     return _baseTokenURI;
1827   }
1828 
1829   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1830     _baseTokenURI = baseURI;
1831   }
1832 
1833   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1834     return ownershipOf(tokenId);
1835   }
1836 }
1837 
1838 
1839   
1840 // File: contracts/DegenzContract.sol
1841 //SPDX-License-Identifier: MIT
1842 
1843 pragma solidity ^0.8.0;
1844 
1845 contract DegenzContract is RamppERC721A {
1846     constructor() RamppERC721A("DEGENZ", "DEGENZ"){}
1847 }
1848   
1849 //*********************************************************************//
1850 //*********************************************************************//  
1851 //                       Mintplex v2.1.0
1852 //
1853 //         This smart contract was generated by mintplex.xyz.
1854 //            Mintplex allows creators like you to launch 
1855 //             large scale NFT communities without code!
1856 //
1857 //    Mintplex is not responsible for the content of this contract and
1858 //        hopes it is being used in a responsible and kind way.  
1859 //       Mintplex is not associated or affiliated with this project.                                                    
1860 //             Twitter: @MintplexNFT ---- mintplex.xyz
1861 //*********************************************************************//                                                     
1862 //*********************************************************************// 
