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
775 * This will easily allow cross-collaboration via Rampp.xyz.
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
844   IERC721Enumerable
845 {
846   using Address for address;
847   using Strings for uint256;
848 
849   struct TokenOwnership {
850     address addr;
851     uint64 startTimestamp;
852   }
853 
854   struct AddressData {
855     uint128 balance;
856     uint128 numberMinted;
857   }
858 
859   uint256 private currentIndex;
860 
861   uint256 public immutable collectionSize;
862   uint256 public maxBatchSize;
863 
864   // Token name
865   string private _name;
866 
867   // Token symbol
868   string private _symbol;
869 
870   // Mapping from token ID to ownership details
871   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
872   mapping(uint256 => TokenOwnership) private _ownerships;
873 
874   // Mapping owner address to address data
875   mapping(address => AddressData) private _addressData;
876 
877   // Mapping from token ID to approved address
878   mapping(uint256 => address) private _tokenApprovals;
879 
880   // Mapping from owner to operator approvals
881   mapping(address => mapping(address => bool)) private _operatorApprovals;
882 
883   /**
884    * @dev
885    * maxBatchSize refers to how much a minter can mint at a time.
886    * collectionSize_ refers to how many tokens are in the collection.
887    */
888   constructor(
889     string memory name_,
890     string memory symbol_,
891     uint256 maxBatchSize_,
892     uint256 collectionSize_
893   ) {
894     require(
895       collectionSize_ > 0,
896       "ERC721A: collection must have a nonzero supply"
897     );
898     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
899     _name = name_;
900     _symbol = symbol_;
901     maxBatchSize = maxBatchSize_;
902     collectionSize = collectionSize_;
903     currentIndex = _startTokenId();
904   }
905 
906   /**
907   * To change the starting tokenId, please override this function.
908   */
909   function _startTokenId() internal view virtual returns (uint256) {
910     return 1;
911   }
912 
913   /**
914    * @dev See {IERC721Enumerable-totalSupply}.
915    */
916   function totalSupply() public view override returns (uint256) {
917     return _totalMinted();
918   }
919 
920   function currentTokenId() public view returns (uint256) {
921     return _totalMinted();
922   }
923 
924   function getNextTokenId() public view returns (uint256) {
925       return _totalMinted() + 1;
926   }
927 
928   /**
929   * Returns the total amount of tokens minted in the contract.
930   */
931   function _totalMinted() internal view returns (uint256) {
932     unchecked {
933       return currentIndex - _startTokenId();
934     }
935   }
936 
937   /**
938    * @dev See {IERC721Enumerable-tokenByIndex}.
939    */
940   function tokenByIndex(uint256 index) public view override returns (uint256) {
941     require(index < totalSupply(), "ERC721A: global index out of bounds");
942     return index;
943   }
944 
945   /**
946    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
947    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
948    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
949    */
950   function tokenOfOwnerByIndex(address owner, uint256 index)
951     public
952     view
953     override
954     returns (uint256)
955   {
956     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
957     uint256 numMintedSoFar = totalSupply();
958     uint256 tokenIdsIdx = 0;
959     address currOwnershipAddr = address(0);
960     for (uint256 i = 0; i < numMintedSoFar; i++) {
961       TokenOwnership memory ownership = _ownerships[i];
962       if (ownership.addr != address(0)) {
963         currOwnershipAddr = ownership.addr;
964       }
965       if (currOwnershipAddr == owner) {
966         if (tokenIdsIdx == index) {
967           return i;
968         }
969         tokenIdsIdx++;
970       }
971     }
972     revert("ERC721A: unable to get token of owner by index");
973   }
974 
975   /**
976    * @dev See {IERC165-supportsInterface}.
977    */
978   function supportsInterface(bytes4 interfaceId)
979     public
980     view
981     virtual
982     override(ERC165, IERC165)
983     returns (bool)
984   {
985     return
986       interfaceId == type(IERC721).interfaceId ||
987       interfaceId == type(IERC721Metadata).interfaceId ||
988       interfaceId == type(IERC721Enumerable).interfaceId ||
989       super.supportsInterface(interfaceId);
990   }
991 
992   /**
993    * @dev See {IERC721-balanceOf}.
994    */
995   function balanceOf(address owner) public view override returns (uint256) {
996     require(owner != address(0), "ERC721A: balance query for the zero address");
997     return uint256(_addressData[owner].balance);
998   }
999 
1000   function _numberMinted(address owner) internal view returns (uint256) {
1001     require(
1002       owner != address(0),
1003       "ERC721A: number minted query for the zero address"
1004     );
1005     return uint256(_addressData[owner].numberMinted);
1006   }
1007 
1008   function ownershipOf(uint256 tokenId)
1009     internal
1010     view
1011     returns (TokenOwnership memory)
1012   {
1013     uint256 curr = tokenId;
1014 
1015     unchecked {
1016         if (_startTokenId() <= curr && curr < currentIndex) {
1017             TokenOwnership memory ownership = _ownerships[curr];
1018             if (ownership.addr != address(0)) {
1019                 return ownership;
1020             }
1021 
1022             // Invariant:
1023             // There will always be an ownership that has an address and is not burned
1024             // before an ownership that does not have an address and is not burned.
1025             // Hence, curr will not underflow.
1026             while (true) {
1027                 curr--;
1028                 ownership = _ownerships[curr];
1029                 if (ownership.addr != address(0)) {
1030                     return ownership;
1031                 }
1032             }
1033         }
1034     }
1035 
1036     revert("ERC721A: unable to determine the owner of token");
1037   }
1038 
1039   /**
1040    * @dev See {IERC721-ownerOf}.
1041    */
1042   function ownerOf(uint256 tokenId) public view override returns (address) {
1043     return ownershipOf(tokenId).addr;
1044   }
1045 
1046   /**
1047    * @dev See {IERC721Metadata-name}.
1048    */
1049   function name() public view virtual override returns (string memory) {
1050     return _name;
1051   }
1052 
1053   /**
1054    * @dev See {IERC721Metadata-symbol}.
1055    */
1056   function symbol() public view virtual override returns (string memory) {
1057     return _symbol;
1058   }
1059 
1060   /**
1061    * @dev See {IERC721Metadata-tokenURI}.
1062    */
1063   function tokenURI(uint256 tokenId)
1064     public
1065     view
1066     virtual
1067     override
1068     returns (string memory)
1069   {
1070     string memory baseURI = _baseURI();
1071     return
1072       bytes(baseURI).length > 0
1073         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1074         : "";
1075   }
1076 
1077   /**
1078    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1079    * token will be the concatenation of the baseURI and the tokenId. Empty
1080    * by default, can be overriden in child contracts.
1081    */
1082   function _baseURI() internal view virtual returns (string memory) {
1083     return "";
1084   }
1085 
1086   /**
1087    * @dev See {IERC721-approve}.
1088    */
1089   function approve(address to, uint256 tokenId) public override {
1090     address owner = ERC721A.ownerOf(tokenId);
1091     require(to != owner, "ERC721A: approval to current owner");
1092 
1093     require(
1094       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1095       "ERC721A: approve caller is not owner nor approved for all"
1096     );
1097 
1098     _approve(to, tokenId, owner);
1099   }
1100 
1101   /**
1102    * @dev See {IERC721-getApproved}.
1103    */
1104   function getApproved(uint256 tokenId) public view override returns (address) {
1105     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1106 
1107     return _tokenApprovals[tokenId];
1108   }
1109 
1110   /**
1111    * @dev See {IERC721-setApprovalForAll}.
1112    */
1113   function setApprovalForAll(address operator, bool approved) public override {
1114     require(operator != _msgSender(), "ERC721A: approve to caller");
1115 
1116     _operatorApprovals[_msgSender()][operator] = approved;
1117     emit ApprovalForAll(_msgSender(), operator, approved);
1118   }
1119 
1120   /**
1121    * @dev See {IERC721-isApprovedForAll}.
1122    */
1123   function isApprovedForAll(address owner, address operator)
1124     public
1125     view
1126     virtual
1127     override
1128     returns (bool)
1129   {
1130     return _operatorApprovals[owner][operator];
1131   }
1132 
1133   /**
1134    * @dev See {IERC721-transferFrom}.
1135    */
1136   function transferFrom(
1137     address from,
1138     address to,
1139     uint256 tokenId
1140   ) public override {
1141     _transfer(from, to, tokenId);
1142   }
1143 
1144   /**
1145    * @dev See {IERC721-safeTransferFrom}.
1146    */
1147   function safeTransferFrom(
1148     address from,
1149     address to,
1150     uint256 tokenId
1151   ) public override {
1152     safeTransferFrom(from, to, tokenId, "");
1153   }
1154 
1155   /**
1156    * @dev See {IERC721-safeTransferFrom}.
1157    */
1158   function safeTransferFrom(
1159     address from,
1160     address to,
1161     uint256 tokenId,
1162     bytes memory _data
1163   ) public override {
1164     _transfer(from, to, tokenId);
1165     require(
1166       _checkOnERC721Received(from, to, tokenId, _data),
1167       "ERC721A: transfer to non ERC721Receiver implementer"
1168     );
1169   }
1170 
1171   /**
1172    * @dev Returns whether tokenId exists.
1173    *
1174    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1175    *
1176    * Tokens start existing when they are minted (_mint),
1177    */
1178   function _exists(uint256 tokenId) internal view returns (bool) {
1179     return _startTokenId() <= tokenId && tokenId < currentIndex;
1180   }
1181 
1182   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1183     _safeMint(to, quantity, isAdminMint, "");
1184   }
1185 
1186   /**
1187    * @dev Mints quantity tokens and transfers them to to.
1188    *
1189    * Requirements:
1190    *
1191    * - there must be quantity tokens remaining unminted in the total collection.
1192    * - to cannot be the zero address.
1193    * - quantity cannot be larger than the max batch size.
1194    *
1195    * Emits a {Transfer} event.
1196    */
1197   function _safeMint(
1198     address to,
1199     uint256 quantity,
1200     bool isAdminMint,
1201     bytes memory _data
1202   ) internal {
1203     uint256 startTokenId = currentIndex;
1204     require(to != address(0), "ERC721A: mint to the zero address");
1205     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1206     require(!_exists(startTokenId), "ERC721A: token already minted");
1207 
1208     // For admin mints we do not want to enforce the maxBatchSize limit
1209     if (isAdminMint == false) {
1210         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1211     }
1212 
1213     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1214 
1215     AddressData memory addressData = _addressData[to];
1216     _addressData[to] = AddressData(
1217       addressData.balance + uint128(quantity),
1218       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1219     );
1220     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1221 
1222     uint256 updatedIndex = startTokenId;
1223 
1224     for (uint256 i = 0; i < quantity; i++) {
1225       emit Transfer(address(0), to, updatedIndex);
1226       require(
1227         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1228         "ERC721A: transfer to non ERC721Receiver implementer"
1229       );
1230       updatedIndex++;
1231     }
1232 
1233     currentIndex = updatedIndex;
1234     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1235   }
1236 
1237   /**
1238    * @dev Transfers tokenId from from to to.
1239    *
1240    * Requirements:
1241    *
1242    * - to cannot be the zero address.
1243    * - tokenId token must be owned by from.
1244    *
1245    * Emits a {Transfer} event.
1246    */
1247   function _transfer(
1248     address from,
1249     address to,
1250     uint256 tokenId
1251   ) private {
1252     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1253 
1254     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1255       getApproved(tokenId) == _msgSender() ||
1256       isApprovedForAll(prevOwnership.addr, _msgSender()));
1257 
1258     require(
1259       isApprovedOrOwner,
1260       "ERC721A: transfer caller is not owner nor approved"
1261     );
1262 
1263     require(
1264       prevOwnership.addr == from,
1265       "ERC721A: transfer from incorrect owner"
1266     );
1267     require(to != address(0), "ERC721A: transfer to the zero address");
1268 
1269     _beforeTokenTransfers(from, to, tokenId, 1);
1270 
1271     // Clear approvals from the previous owner
1272     _approve(address(0), tokenId, prevOwnership.addr);
1273 
1274     _addressData[from].balance -= 1;
1275     _addressData[to].balance += 1;
1276     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1277 
1278     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1279     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1280     uint256 nextTokenId = tokenId + 1;
1281     if (_ownerships[nextTokenId].addr == address(0)) {
1282       if (_exists(nextTokenId)) {
1283         _ownerships[nextTokenId] = TokenOwnership(
1284           prevOwnership.addr,
1285           prevOwnership.startTimestamp
1286         );
1287       }
1288     }
1289 
1290     emit Transfer(from, to, tokenId);
1291     _afterTokenTransfers(from, to, tokenId, 1);
1292   }
1293 
1294   /**
1295    * @dev Approve to to operate on tokenId
1296    *
1297    * Emits a {Approval} event.
1298    */
1299   function _approve(
1300     address to,
1301     uint256 tokenId,
1302     address owner
1303   ) private {
1304     _tokenApprovals[tokenId] = to;
1305     emit Approval(owner, to, tokenId);
1306   }
1307 
1308   uint256 public nextOwnerToExplicitlySet = 0;
1309 
1310   /**
1311    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1312    */
1313   function _setOwnersExplicit(uint256 quantity) internal {
1314     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1315     require(quantity > 0, "quantity must be nonzero");
1316     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1317 
1318     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1319     if (endIndex > collectionSize - 1) {
1320       endIndex = collectionSize - 1;
1321     }
1322     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1323     require(_exists(endIndex), "not enough minted yet for this cleanup");
1324     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1325       if (_ownerships[i].addr == address(0)) {
1326         TokenOwnership memory ownership = ownershipOf(i);
1327         _ownerships[i] = TokenOwnership(
1328           ownership.addr,
1329           ownership.startTimestamp
1330         );
1331       }
1332     }
1333     nextOwnerToExplicitlySet = endIndex + 1;
1334   }
1335 
1336   /**
1337    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1338    * The call is not executed if the target address is not a contract.
1339    *
1340    * @param from address representing the previous owner of the given token ID
1341    * @param to target address that will receive the tokens
1342    * @param tokenId uint256 ID of the token to be transferred
1343    * @param _data bytes optional data to send along with the call
1344    * @return bool whether the call correctly returned the expected magic value
1345    */
1346   function _checkOnERC721Received(
1347     address from,
1348     address to,
1349     uint256 tokenId,
1350     bytes memory _data
1351   ) private returns (bool) {
1352     if (to.isContract()) {
1353       try
1354         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1355       returns (bytes4 retval) {
1356         return retval == IERC721Receiver(to).onERC721Received.selector;
1357       } catch (bytes memory reason) {
1358         if (reason.length == 0) {
1359           revert("ERC721A: transfer to non ERC721Receiver implementer");
1360         } else {
1361           assembly {
1362             revert(add(32, reason), mload(reason))
1363           }
1364         }
1365       }
1366     } else {
1367       return true;
1368     }
1369   }
1370 
1371   /**
1372    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1373    *
1374    * startTokenId - the first token id to be transferred
1375    * quantity - the amount to be transferred
1376    *
1377    * Calling conditions:
1378    *
1379    * - When from and to are both non-zero, from's tokenId will be
1380    * transferred to to.
1381    * - When from is zero, tokenId will be minted for to.
1382    */
1383   function _beforeTokenTransfers(
1384     address from,
1385     address to,
1386     uint256 startTokenId,
1387     uint256 quantity
1388   ) internal virtual {}
1389 
1390   /**
1391    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1392    * minting.
1393    *
1394    * startTokenId - the first token id to be transferred
1395    * quantity - the amount to be transferred
1396    *
1397    * Calling conditions:
1398    *
1399    * - when from and to are both non-zero.
1400    * - from and to are never both zero.
1401    */
1402   function _afterTokenTransfers(
1403     address from,
1404     address to,
1405     uint256 startTokenId,
1406     uint256 quantity
1407   ) internal virtual {}
1408 }
1409 
1410 
1411 
1412   
1413 abstract contract Ramppable {
1414   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1415 
1416   modifier isRampp() {
1417       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1418       _;
1419   }
1420 }
1421 
1422 
1423   
1424   
1425 interface IERC20 {
1426   function allowance(address owner, address spender) external view returns (uint256);
1427   function transfer(address _to, uint256 _amount) external returns (bool);
1428   function balanceOf(address account) external view returns (uint256);
1429   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1430 }
1431 
1432 // File: WithdrawableV2
1433 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1434 // ERC-20 Payouts are limited to a single payout address. This feature 
1435 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1436 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1437 abstract contract WithdrawableV2 is Teams, Ramppable {
1438   struct acceptedERC20 {
1439     bool isActive;
1440     uint256 chargeAmount;
1441   }
1442 
1443   mapping(address => acceptedERC20) private allowedTokenContracts;
1444   address[] public payableAddresses = [RAMPPADDRESS,0x0A0DEF4C9f03FEB725F4d936f9D7E705CEc03b43];
1445   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1446   address public erc20Payable = 0x0A0DEF4C9f03FEB725F4d936f9D7E705CEc03b43;
1447   uint256[] public payableFees = [5,95];
1448   uint256[] public surchargePayableFees = [100];
1449   uint256 public payableAddressCount = 2;
1450   uint256 public surchargePayableAddressCount = 1;
1451   uint256 public ramppSurchargeBalance = 0 ether;
1452   uint256 public ramppSurchargeFee = 0.001 ether;
1453   bool public onlyERC20MintingMode = false;
1454 
1455   /**
1456   * @dev Calculates the true payable balance of the contract as the
1457   * value on contract may be from ERC-20 mint surcharges and not 
1458   * public mint charges - which are not eligable for rev share & user withdrawl
1459   */
1460   function calcAvailableBalance() public view returns(uint256) {
1461     return address(this).balance - ramppSurchargeBalance;
1462   }
1463 
1464   function withdrawAll() public onlyTeamOrOwner {
1465       require(calcAvailableBalance() > 0);
1466       _withdrawAll();
1467   }
1468   
1469   function withdrawAllRampp() public isRampp {
1470       require(calcAvailableBalance() > 0);
1471       _withdrawAll();
1472   }
1473 
1474   function _withdrawAll() private {
1475       uint256 balance = calcAvailableBalance();
1476       
1477       for(uint i=0; i < payableAddressCount; i++ ) {
1478           _widthdraw(
1479               payableAddresses[i],
1480               (balance * payableFees[i]) / 100
1481           );
1482       }
1483   }
1484   
1485   function _widthdraw(address _address, uint256 _amount) private {
1486       (bool success, ) = _address.call{value: _amount}("");
1487       require(success, "Transfer failed.");
1488   }
1489 
1490   /**
1491   * @dev This function is similiar to the regular withdraw but operates only on the
1492   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1493   **/
1494   function _withdrawAllSurcharges() private {
1495     uint256 balance = ramppSurchargeBalance;
1496     if(balance == 0) { return; }
1497     
1498     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1499         _widthdraw(
1500             surchargePayableAddresses[i],
1501             (balance * surchargePayableFees[i]) / 100
1502         );
1503     }
1504     ramppSurchargeBalance = 0 ether;
1505   }
1506 
1507   /**
1508   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1509   * in the event ERC-20 tokens are paid to the contract for mints. This will
1510   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1511   * @param _tokenContract contract of ERC-20 token to withdraw
1512   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1513   */
1514   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1515     require(_amountToWithdraw > 0);
1516     IERC20 tokenContract = IERC20(_tokenContract);
1517     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1518     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1519     _withdrawAllSurcharges();
1520   }
1521 
1522   /**
1523   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1524   */
1525   function withdrawRamppSurcharges() public isRampp {
1526     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1527     _withdrawAllSurcharges();
1528   }
1529 
1530    /**
1531   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1532   */
1533   function addSurcharge() internal {
1534     ramppSurchargeBalance += ramppSurchargeFee;
1535   }
1536   
1537   /**
1538   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1539   */
1540   function hasSurcharge() internal returns(bool) {
1541     return msg.value == ramppSurchargeFee;
1542   }
1543 
1544   /**
1545   * @dev Set surcharge fee for using ERC-20 payments on contract
1546   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1547   */
1548   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1549     ramppSurchargeFee = _newSurcharge;
1550   }
1551 
1552   /**
1553   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1554   * @param _erc20TokenContract address of ERC-20 contract in question
1555   */
1556   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1557     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1558   }
1559 
1560   /**
1561   * @dev get the value of tokens to transfer for user of an ERC-20
1562   * @param _erc20TokenContract address of ERC-20 contract in question
1563   */
1564   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1565     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1566     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1567   }
1568 
1569   /**
1570   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1571   * @param _erc20TokenContract address of ERC-20 contract in question
1572   * @param _isActive default status of if contract should be allowed to accept payments
1573   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1574   */
1575   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1576     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1577     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1578   }
1579 
1580   /**
1581   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1582   * it will assume the default value of zero. This should not be used to create new payment tokens.
1583   * @param _erc20TokenContract address of ERC-20 contract in question
1584   */
1585   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1586     allowedTokenContracts[_erc20TokenContract].isActive = true;
1587   }
1588 
1589   /**
1590   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1591   * it will assume the default value of zero. This should not be used to create new payment tokens.
1592   * @param _erc20TokenContract address of ERC-20 contract in question
1593   */
1594   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1595     allowedTokenContracts[_erc20TokenContract].isActive = false;
1596   }
1597 
1598   /**
1599   * @dev Enable only ERC-20 payments for minting on this contract
1600   */
1601   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1602     onlyERC20MintingMode = true;
1603   }
1604 
1605   /**
1606   * @dev Disable only ERC-20 payments for minting on this contract
1607   */
1608   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1609     onlyERC20MintingMode = false;
1610   }
1611 
1612   /**
1613   * @dev Set the payout of the ERC-20 token payout to a specific address
1614   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1615   */
1616   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1617     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1618     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1619     erc20Payable = _newErc20Payable;
1620   }
1621 
1622   /**
1623   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1624   */
1625   function resetRamppSurchargeBalance() public isRampp {
1626     ramppSurchargeBalance = 0 ether;
1627   }
1628 
1629   /**
1630   * @dev Allows Rampp wallet to update its own reference as well as update
1631   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1632   * and since Rampp is always the first address this function is limited to the rampp payout only.
1633   * @param _newAddress updated Rampp Address
1634   */
1635   function setRamppAddress(address _newAddress) public isRampp {
1636     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1637     RAMPPADDRESS = _newAddress;
1638     payableAddresses[0] = _newAddress;
1639   }
1640 }
1641 
1642 
1643   
1644   
1645 // File: EarlyMintIncentive.sol
1646 // Allows the contract to have the first x tokens have a discount or
1647 // zero fee that can be calculated on the fly.
1648 abstract contract EarlyMintIncentive is Teams, ERC721A {
1649   uint256 public PRICE = 0.001 ether;
1650   uint256 public EARLY_MINT_PRICE = 0 ether;
1651   uint256 public earlyMintTokenIdCap = 1600;
1652   bool public usingEarlyMintIncentive = true;
1653 
1654   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1655     usingEarlyMintIncentive = true;
1656   }
1657 
1658   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1659     usingEarlyMintIncentive = false;
1660   }
1661 
1662   /**
1663   * @dev Set the max token ID in which the cost incentive will be applied.
1664   * @param _newTokenIdCap max tokenId in which incentive will be applied
1665   */
1666   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1667     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1668     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1669     earlyMintTokenIdCap = _newTokenIdCap;
1670   }
1671 
1672   /**
1673   * @dev Set the incentive mint price
1674   * @param _feeInWei new price per token when in incentive range
1675   */
1676   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1677     EARLY_MINT_PRICE = _feeInWei;
1678   }
1679 
1680   /**
1681   * @dev Set the primary mint price - the base price when not under incentive
1682   * @param _feeInWei new price per token
1683   */
1684   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1685     PRICE = _feeInWei;
1686   }
1687 
1688   function getPrice(uint256 _count) public view returns (uint256) {
1689     require(_count > 0, "Must be minting at least 1 token.");
1690 
1691     // short circuit function if we dont need to even calc incentive pricing
1692     // short circuit if the current tokenId is also already over cap
1693     if(
1694       usingEarlyMintIncentive == false ||
1695       currentTokenId() > earlyMintTokenIdCap
1696     ) {
1697       return PRICE * _count;
1698     }
1699 
1700     uint256 endingTokenId = currentTokenId() + _count;
1701     // If qty to mint results in a final token ID less than or equal to the cap then
1702     // the entire qty is within free mint.
1703     if(endingTokenId  <= earlyMintTokenIdCap) {
1704       return EARLY_MINT_PRICE * _count;
1705     }
1706 
1707     // If the current token id is less than the incentive cap
1708     // and the ending token ID is greater than the incentive cap
1709     // we will be straddling the cap so there will be some amount
1710     // that are incentive and some that are regular fee.
1711     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1712     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1713 
1714     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1715   }
1716 }
1717 
1718   
1719   
1720 abstract contract RamppERC721A is 
1721     Ownable,
1722     Teams,
1723     ERC721A,
1724     WithdrawableV2,
1725     ReentrancyGuard 
1726     , EarlyMintIncentive 
1727      
1728     
1729 {
1730   constructor(
1731     string memory tokenName,
1732     string memory tokenSymbol
1733   ) ERC721A(tokenName, tokenSymbol, 5, 2587) { }
1734     uint8 public CONTRACT_VERSION = 2;
1735     string public _baseTokenURI = "https://yepdderqweqw.mypinata.cloud/ipfs/QmY3Wizd4u4KviantdjVhvMQR1ndKVMca8qQPKjPkv65WB/";
1736 
1737     bool public mintingOpen = true;
1738     
1739     
1740     uint256 public MAX_WALLET_MINTS = 5;
1741 
1742   
1743     /////////////// Admin Mint Functions
1744     /**
1745      * @dev Mints a token to an address with a tokenURI.
1746      * This is owner only and allows a fee-free drop
1747      * @param _to address of the future owner of the token
1748      * @param _qty amount of tokens to drop the owner
1749      */
1750      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1751          require(_qty > 0, "Must mint at least 1 token.");
1752          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 2587");
1753          _safeMint(_to, _qty, true);
1754      }
1755 
1756   
1757     /////////////// GENERIC MINT FUNCTIONS
1758     /**
1759     * @dev Mints a single token to an address.
1760     * fee may or may not be required*
1761     * @param _to address of the future owner of the token
1762     */
1763     function mintTo(address _to) public payable {
1764         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1765         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2587");
1766         require(mintingOpen == true, "Minting is not open right now!");
1767         
1768         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1769         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1770         
1771         _safeMint(_to, 1, false);
1772     }
1773 
1774     /**
1775     * @dev Mints tokens to an address in batch.
1776     * fee may or may not be required*
1777     * @param _to address of the future owner of the token
1778     * @param _amount number of tokens to mint
1779     */
1780     function mintToMultiple(address _to, uint256 _amount) public payable {
1781         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1782         require(_amount >= 1, "Must mint at least 1 token");
1783         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1784         require(mintingOpen == true, "Minting is not open right now!");
1785         
1786         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1787         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2587");
1788         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1789 
1790         _safeMint(_to, _amount, false);
1791     }
1792 
1793     /**
1794      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1795      * fee may or may not be required*
1796      * @param _to address of the future owner of the token
1797      * @param _amount number of tokens to mint
1798      * @param _erc20TokenContract erc-20 token contract to mint with
1799      */
1800     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1801       require(_amount >= 1, "Must mint at least 1 token");
1802       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1803       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2587");
1804       require(mintingOpen == true, "Minting is not open right now!");
1805       
1806       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1807 
1808       // ERC-20 Specific pre-flight checks
1809       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1810       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1811       IERC20 payableToken = IERC20(_erc20TokenContract);
1812 
1813       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1814       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1815       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1816       
1817       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1818       require(transferComplete, "ERC-20 token was unable to be transferred");
1819       
1820       _safeMint(_to, _amount, false);
1821       addSurcharge();
1822     }
1823 
1824     function openMinting() public onlyTeamOrOwner {
1825         mintingOpen = true;
1826     }
1827 
1828     function stopMinting() public onlyTeamOrOwner {
1829         mintingOpen = false;
1830     }
1831 
1832   
1833 
1834   
1835     /**
1836     * @dev Check if wallet over MAX_WALLET_MINTS
1837     * @param _address address in question to check if minted count exceeds max
1838     */
1839     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1840         require(_amount >= 1, "Amount must be greater than or equal to 1");
1841         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1842     }
1843 
1844     /**
1845     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1846     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1847     */
1848     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1849         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1850         MAX_WALLET_MINTS = _newWalletMax;
1851     }
1852     
1853 
1854   
1855     /**
1856      * @dev Allows owner to set Max mints per tx
1857      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1858      */
1859      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1860          require(_newMaxMint >= 1, "Max mint must be at least 1");
1861          maxBatchSize = _newMaxMint;
1862      }
1863     
1864 
1865   
1866 
1867   function _baseURI() internal view virtual override returns(string memory) {
1868     return _baseTokenURI;
1869   }
1870 
1871   function baseTokenURI() public view returns(string memory) {
1872     return _baseTokenURI;
1873   }
1874 
1875   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1876     _baseTokenURI = baseURI;
1877   }
1878 
1879   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1880     return ownershipOf(tokenId);
1881   }
1882 }
1883 
1884 
1885   
1886 // File: contracts/AgeofSolariumContract.sol
1887 //SPDX-License-Identifier: MIT
1888 
1889 pragma solidity ^0.8.0;
1890 
1891 contract AgeofSolariumContract is RamppERC721A {
1892     constructor() RamppERC721A("Age of Solarium", "SOLARIUM"){}
1893 }
1894   
1895 //*********************************************************************//
1896 //*********************************************************************//  
1897 //                       Rampp v2.1.0
1898 //
1899 //         This smart contract was generated by rampp.xyz.
1900 //            Rampp allows creators like you to launch 
1901 //             large scale NFT communities without code!
1902 //
1903 //    Rampp is not responsible for the content of this contract and
1904 //        hopes it is being used in a responsible and kind way.  
1905 //       Rampp is not associated or affiliated with this project.                                                    
1906 //             Twitter: @Rampp_ ---- rampp.xyz
1907 //*********************************************************************//                                                     
1908 //*********************************************************************// 
