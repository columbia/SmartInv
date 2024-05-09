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
729     function _onlyOwner() private view {
730        require(owner() == _msgSender(), "Ownable: caller is not the owner");
731     }
732 
733     modifier onlyOwner() {
734         _onlyOwner();
735         _;
736     }
737 
738     /**
739      * @dev Leaves the contract without owner. It will not be possible to call
740      * onlyOwner functions anymore. Can only be called by the current owner.
741      *
742      * NOTE: Renouncing ownership will leave the contract without an owner,
743      * thereby removing any functionality that is only available to the owner.
744      */
745     function renounceOwnership() public virtual onlyOwner {
746         _transferOwnership(address(0));
747     }
748 
749     /**
750      * @dev Transfers ownership of the contract to a new account (newOwner).
751      * Can only be called by the current owner.
752      */
753     function transferOwnership(address newOwner) public virtual onlyOwner {
754         require(newOwner != address(0), "Ownable: new owner is the zero address");
755         _transferOwnership(newOwner);
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (newOwner).
760      * Internal function without access restriction.
761      */
762     function _transferOwnership(address newOwner) internal virtual {
763         address oldOwner = _owner;
764         _owner = newOwner;
765         emit OwnershipTransferred(oldOwner, newOwner);
766     }
767 }
768 
769 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
770 pragma solidity ^0.8.9;
771 
772 interface IOperatorFilterRegistry {
773     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
774     function register(address registrant) external;
775     function registerAndSubscribe(address registrant, address subscription) external;
776     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
777     function updateOperator(address registrant, address operator, bool filtered) external;
778     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
779     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
780     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
781     function subscribe(address registrant, address registrantToSubscribe) external;
782     function unsubscribe(address registrant, bool copyExistingEntries) external;
783     function subscriptionOf(address addr) external returns (address registrant);
784     function subscribers(address registrant) external returns (address[] memory);
785     function subscriberAt(address registrant, uint256 index) external returns (address);
786     function copyEntriesOf(address registrant, address registrantToCopy) external;
787     function isOperatorFiltered(address registrant, address operator) external returns (bool);
788     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
789     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
790     function filteredOperators(address addr) external returns (address[] memory);
791     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
792     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
793     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
794     function isRegistered(address addr) external returns (bool);
795     function codeHashOf(address addr) external returns (bytes32);
796 }
797 
798 // File contracts/OperatorFilter/OperatorFilterer.sol
799 pragma solidity ^0.8.9;
800 
801 abstract contract OperatorFilterer {
802     error OperatorNotAllowed(address operator);
803 
804     IOperatorFilterRegistry constant operatorFilterRegistry =
805         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
806 
807     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
808         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
809         // will not revert, but the contract will need to be registered with the registry once it is deployed in
810         // order for the modifier to filter addresses.
811         if (address(operatorFilterRegistry).code.length > 0) {
812             if (subscribe) {
813                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
814             } else {
815                 if (subscriptionOrRegistrantToCopy != address(0)) {
816                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
817                 } else {
818                     operatorFilterRegistry.register(address(this));
819                 }
820             }
821         }
822     }
823 
824     function _onlyAllowedOperator(address from) private view {
825       if (
826           !(
827               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
828               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
829           )
830       ) {
831           revert OperatorNotAllowed(msg.sender);
832       }
833     }
834 
835     modifier onlyAllowedOperator(address from) virtual {
836         // Check registry code length to facilitate testing in environments without a deployed registry.
837         if (address(operatorFilterRegistry).code.length > 0) {
838             // Allow spending tokens from addresses with balance
839             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
840             // from an EOA.
841             if (from == msg.sender) {
842                 _;
843                 return;
844             }
845             _onlyAllowedOperator(from);
846         }
847         _;
848     }
849 
850     modifier onlyAllowedOperatorApproval(address operator) virtual {
851         _checkFilterOperator(operator);
852         _;
853     }
854 
855     function _checkFilterOperator(address operator) internal view virtual {
856         // Check registry code length to facilitate testing in environments without a deployed registry.
857         if (address(operatorFilterRegistry).code.length > 0) {
858             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
859                 revert OperatorNotAllowed(operator);
860             }
861         }
862     }
863 }
864 
865 //-------------END DEPENDENCIES------------------------//
866 
867 
868   
869 error TransactionCapExceeded();
870 error PublicMintingClosed();
871 error ExcessiveOwnedMints();
872 error MintZeroQuantity();
873 error InvalidPayment();
874 error CapExceeded();
875 error IsAlreadyUnveiled();
876 error ValueCannotBeZero();
877 error CannotBeNullAddress();
878 error NoStateChange();
879 
880 error PublicMintClosed();
881 error AllowlistMintClosed();
882 
883 error AddressNotAllowlisted();
884 error AllowlistDropTimeHasNotPassed();
885 error PublicDropTimeHasNotPassed();
886 error DropTimeNotInFuture();
887 
888 error OnlyERC20MintingEnabled();
889 error ERC20TokenNotApproved();
890 error ERC20InsufficientBalance();
891 error ERC20InsufficientAllowance();
892 error ERC20TransferFailed();
893 
894 error ClaimModeDisabled();
895 error IneligibleRedemptionContract();
896 error TokenAlreadyRedeemed();
897 error InvalidOwnerForRedemption();
898 error InvalidApprovalForRedemption();
899 
900 error ERC721RestrictedApprovalAddressRestricted();
901 error NotMaintainer();
902   
903   
904 // Rampp Contracts v2.1 (Teams.sol)
905 
906 error InvalidTeamAddress();
907 error DuplicateTeamAddress();
908 pragma solidity ^0.8.0;
909 
910 /**
911 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
912 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
913 * This will easily allow cross-collaboration via Mintplex.xyz.
914 **/
915 abstract contract Teams is Ownable{
916   mapping (address => bool) internal team;
917 
918   /**
919   * @dev Adds an address to the team. Allows them to execute protected functions
920   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
921   **/
922   function addToTeam(address _address) public onlyOwner {
923     if(_address == address(0)) revert InvalidTeamAddress();
924     if(inTeam(_address)) revert DuplicateTeamAddress();
925   
926     team[_address] = true;
927   }
928 
929   /**
930   * @dev Removes an address to the team.
931   * @param _address the ETH address to remove, cannot be 0x and must be in team
932   **/
933   function removeFromTeam(address _address) public onlyOwner {
934     if(_address == address(0)) revert InvalidTeamAddress();
935     if(!inTeam(_address)) revert InvalidTeamAddress();
936   
937     team[_address] = false;
938   }
939 
940   /**
941   * @dev Check if an address is valid and active in the team
942   * @param _address ETH address to check for truthiness
943   **/
944   function inTeam(address _address)
945     public
946     view
947     returns (bool)
948   {
949     if(_address == address(0)) revert InvalidTeamAddress();
950     return team[_address] == true;
951   }
952 
953   /**
954   * @dev Throws if called by any account other than the owner or team member.
955   */
956   function _onlyTeamOrOwner() private view {
957     bool _isOwner = owner() == _msgSender();
958     bool _isTeam = inTeam(_msgSender());
959     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
960   }
961 
962   modifier onlyTeamOrOwner() {
963     _onlyTeamOrOwner();
964     _;
965   }
966 }
967 
968 
969   
970   
971 /**
972  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
973  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
974  *
975  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
976  * 
977  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
978  *
979  * Does not support burning tokens to address(0).
980  */
981 contract ERC721A is
982   Context,
983   ERC165,
984   IERC721,
985   IERC721Metadata,
986   IERC721Enumerable,
987   Teams
988   , OperatorFilterer
989 {
990   using Address for address;
991   using Strings for uint256;
992 
993   struct TokenOwnership {
994     address addr;
995     uint64 startTimestamp;
996   }
997 
998   struct AddressData {
999     uint128 balance;
1000     uint128 numberMinted;
1001   }
1002 
1003   uint256 private currentIndex;
1004 
1005   uint256 public immutable collectionSize;
1006   uint256 public maxBatchSize;
1007 
1008   // Token name
1009   string private _name;
1010 
1011   // Token symbol
1012   string private _symbol;
1013 
1014   // Mapping from token ID to ownership details
1015   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1016   mapping(uint256 => TokenOwnership) private _ownerships;
1017 
1018   // Mapping owner address to address data
1019   mapping(address => AddressData) private _addressData;
1020 
1021   // Mapping from token ID to approved address
1022   mapping(uint256 => address) private _tokenApprovals;
1023 
1024   // Mapping from owner to operator approvals
1025   mapping(address => mapping(address => bool)) private _operatorApprovals;
1026 
1027   /* @dev Mapping of restricted operator approvals set by contract Owner
1028   * This serves as an optional addition to ERC-721 so
1029   * that the contract owner can elect to prevent specific addresses/contracts
1030   * from being marked as the approver for a token. The reason for this
1031   * is that some projects may want to retain control of where their tokens can/can not be listed
1032   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1033   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1034   */
1035   mapping(address => bool) public restrictedApprovalAddresses;
1036 
1037   /**
1038    * @dev
1039    * maxBatchSize refers to how much a minter can mint at a time.
1040    * collectionSize_ refers to how many tokens are in the collection.
1041    */
1042   constructor(
1043     string memory name_,
1044     string memory symbol_,
1045     uint256 maxBatchSize_,
1046     uint256 collectionSize_
1047   ) OperatorFilterer(address(0), false) {
1048     require(
1049       collectionSize_ > 0,
1050       "ERC721A: collection must have a nonzero supply"
1051     );
1052     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1053     _name = name_;
1054     _symbol = symbol_;
1055     maxBatchSize = maxBatchSize_;
1056     collectionSize = collectionSize_;
1057     currentIndex = _startTokenId();
1058   }
1059 
1060   /**
1061   * To change the starting tokenId, please override this function.
1062   */
1063   function _startTokenId() internal view virtual returns (uint256) {
1064     return 1;
1065   }
1066 
1067   /**
1068    * @dev See {IERC721Enumerable-totalSupply}.
1069    */
1070   function totalSupply() public view override returns (uint256) {
1071     return _totalMinted();
1072   }
1073 
1074   function currentTokenId() public view returns (uint256) {
1075     return _totalMinted();
1076   }
1077 
1078   function getNextTokenId() public view returns (uint256) {
1079       return _totalMinted() + 1;
1080   }
1081 
1082   /**
1083   * Returns the total amount of tokens minted in the contract.
1084   */
1085   function _totalMinted() internal view returns (uint256) {
1086     unchecked {
1087       return currentIndex - _startTokenId();
1088     }
1089   }
1090 
1091   /**
1092    * @dev See {IERC721Enumerable-tokenByIndex}.
1093    */
1094   function tokenByIndex(uint256 index) public view override returns (uint256) {
1095     require(index < totalSupply(), "ERC721A: global index out of bounds");
1096     return index;
1097   }
1098 
1099   /**
1100    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1101    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1102    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1103    */
1104   function tokenOfOwnerByIndex(address owner, uint256 index)
1105     public
1106     view
1107     override
1108     returns (uint256)
1109   {
1110     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1111     uint256 numMintedSoFar = totalSupply();
1112     uint256 tokenIdsIdx = 0;
1113     address currOwnershipAddr = address(0);
1114     for (uint256 i = 0; i < numMintedSoFar; i++) {
1115       TokenOwnership memory ownership = _ownerships[i];
1116       if (ownership.addr != address(0)) {
1117         currOwnershipAddr = ownership.addr;
1118       }
1119       if (currOwnershipAddr == owner) {
1120         if (tokenIdsIdx == index) {
1121           return i;
1122         }
1123         tokenIdsIdx++;
1124       }
1125     }
1126     revert("ERC721A: unable to get token of owner by index");
1127   }
1128 
1129   /**
1130    * @dev See {IERC165-supportsInterface}.
1131    */
1132   function supportsInterface(bytes4 interfaceId)
1133     public
1134     view
1135     virtual
1136     override(ERC165, IERC165)
1137     returns (bool)
1138   {
1139     return
1140       interfaceId == type(IERC721).interfaceId ||
1141       interfaceId == type(IERC721Metadata).interfaceId ||
1142       interfaceId == type(IERC721Enumerable).interfaceId ||
1143       super.supportsInterface(interfaceId);
1144   }
1145 
1146   /**
1147    * @dev See {IERC721-balanceOf}.
1148    */
1149   function balanceOf(address owner) public view override returns (uint256) {
1150     require(owner != address(0), "ERC721A: balance query for the zero address");
1151     return uint256(_addressData[owner].balance);
1152   }
1153 
1154   function _numberMinted(address owner) internal view returns (uint256) {
1155     require(
1156       owner != address(0),
1157       "ERC721A: number minted query for the zero address"
1158     );
1159     return uint256(_addressData[owner].numberMinted);
1160   }
1161 
1162   function ownershipOf(uint256 tokenId)
1163     internal
1164     view
1165     returns (TokenOwnership memory)
1166   {
1167     uint256 curr = tokenId;
1168 
1169     unchecked {
1170         if (_startTokenId() <= curr && curr < currentIndex) {
1171             TokenOwnership memory ownership = _ownerships[curr];
1172             if (ownership.addr != address(0)) {
1173                 return ownership;
1174             }
1175 
1176             // Invariant:
1177             // There will always be an ownership that has an address and is not burned
1178             // before an ownership that does not have an address and is not burned.
1179             // Hence, curr will not underflow.
1180             while (true) {
1181                 curr--;
1182                 ownership = _ownerships[curr];
1183                 if (ownership.addr != address(0)) {
1184                     return ownership;
1185                 }
1186             }
1187         }
1188     }
1189 
1190     revert("ERC721A: unable to determine the owner of token");
1191   }
1192 
1193   /**
1194    * @dev See {IERC721-ownerOf}.
1195    */
1196   function ownerOf(uint256 tokenId) public view override returns (address) {
1197     return ownershipOf(tokenId).addr;
1198   }
1199 
1200   /**
1201    * @dev See {IERC721Metadata-name}.
1202    */
1203   function name() public view virtual override returns (string memory) {
1204     return _name;
1205   }
1206 
1207   /**
1208    * @dev See {IERC721Metadata-symbol}.
1209    */
1210   function symbol() public view virtual override returns (string memory) {
1211     return _symbol;
1212   }
1213 
1214   /**
1215    * @dev See {IERC721Metadata-tokenURI}.
1216    */
1217   function tokenURI(uint256 tokenId)
1218     public
1219     view
1220     virtual
1221     override
1222     returns (string memory)
1223   {
1224     string memory baseURI = _baseURI();
1225     string memory extension = _baseURIExtension();
1226     return
1227       bytes(baseURI).length > 0
1228         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1229         : "";
1230   }
1231 
1232   /**
1233    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1234    * token will be the concatenation of the baseURI and the tokenId. Empty
1235    * by default, can be overriden in child contracts.
1236    */
1237   function _baseURI() internal view virtual returns (string memory) {
1238     return "";
1239   }
1240 
1241   /**
1242    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1243    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1244    * by default, can be overriden in child contracts.
1245    */
1246   function _baseURIExtension() internal view virtual returns (string memory) {
1247     return "";
1248   }
1249 
1250   /**
1251    * @dev Sets the value for an address to be in the restricted approval address pool.
1252    * Setting an address to true will disable token owners from being able to mark the address
1253    * for approval for trading. This would be used in theory to prevent token owners from listing
1254    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1255    * @param _address the marketplace/user to modify restriction status of
1256    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1257    */
1258   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1259     restrictedApprovalAddresses[_address] = _isRestricted;
1260   }
1261 
1262   /**
1263    * @dev See {IERC721-approve}.
1264    */
1265   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1266     address owner = ERC721A.ownerOf(tokenId);
1267     require(to != owner, "ERC721A: approval to current owner");
1268     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1269 
1270     require(
1271       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1272       "ERC721A: approve caller is not owner nor approved for all"
1273     );
1274 
1275     _approve(to, tokenId, owner);
1276   }
1277 
1278   /**
1279    * @dev See {IERC721-getApproved}.
1280    */
1281   function getApproved(uint256 tokenId) public view override returns (address) {
1282     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1283 
1284     return _tokenApprovals[tokenId];
1285   }
1286 
1287   /**
1288    * @dev See {IERC721-setApprovalForAll}.
1289    */
1290   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1291     require(operator != _msgSender(), "ERC721A: approve to caller");
1292     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1293 
1294     _operatorApprovals[_msgSender()][operator] = approved;
1295     emit ApprovalForAll(_msgSender(), operator, approved);
1296   }
1297 
1298   /**
1299    * @dev See {IERC721-isApprovedForAll}.
1300    */
1301   function isApprovedForAll(address owner, address operator)
1302     public
1303     view
1304     virtual
1305     override
1306     returns (bool)
1307   {
1308     return _operatorApprovals[owner][operator];
1309   }
1310 
1311   /**
1312    * @dev See {IERC721-transferFrom}.
1313    */
1314   function transferFrom(
1315     address from,
1316     address to,
1317     uint256 tokenId
1318   ) public override onlyAllowedOperator(from) {
1319     _transfer(from, to, tokenId);
1320   }
1321 
1322   /**
1323    * @dev See {IERC721-safeTransferFrom}.
1324    */
1325   function safeTransferFrom(
1326     address from,
1327     address to,
1328     uint256 tokenId
1329   ) public override onlyAllowedOperator(from) {
1330     safeTransferFrom(from, to, tokenId, "");
1331   }
1332 
1333   /**
1334    * @dev See {IERC721-safeTransferFrom}.
1335    */
1336   function safeTransferFrom(
1337     address from,
1338     address to,
1339     uint256 tokenId,
1340     bytes memory _data
1341   ) public override onlyAllowedOperator(from) {
1342     _transfer(from, to, tokenId);
1343     require(
1344       _checkOnERC721Received(from, to, tokenId, _data),
1345       "ERC721A: transfer to non ERC721Receiver implementer"
1346     );
1347   }
1348 
1349   /**
1350    * @dev Returns whether tokenId exists.
1351    *
1352    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1353    *
1354    * Tokens start existing when they are minted (_mint),
1355    */
1356   function _exists(uint256 tokenId) internal view returns (bool) {
1357     return _startTokenId() <= tokenId && tokenId < currentIndex;
1358   }
1359 
1360   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1361     _safeMint(to, quantity, isAdminMint, "");
1362   }
1363 
1364   /**
1365    * @dev Mints quantity tokens and transfers them to to.
1366    *
1367    * Requirements:
1368    *
1369    * - there must be quantity tokens remaining unminted in the total collection.
1370    * - to cannot be the zero address.
1371    * - quantity cannot be larger than the max batch size.
1372    *
1373    * Emits a {Transfer} event.
1374    */
1375   function _safeMint(
1376     address to,
1377     uint256 quantity,
1378     bool isAdminMint,
1379     bytes memory _data
1380   ) internal {
1381     uint256 startTokenId = currentIndex;
1382     require(to != address(0), "ERC721A: mint to the zero address");
1383     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1384     require(!_exists(startTokenId), "ERC721A: token already minted");
1385 
1386     // For admin mints we do not want to enforce the maxBatchSize limit
1387     if (isAdminMint == false) {
1388         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1389     }
1390 
1391     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1392 
1393     AddressData memory addressData = _addressData[to];
1394     _addressData[to] = AddressData(
1395       addressData.balance + uint128(quantity),
1396       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1397     );
1398     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1399 
1400     uint256 updatedIndex = startTokenId;
1401 
1402     for (uint256 i = 0; i < quantity; i++) {
1403       emit Transfer(address(0), to, updatedIndex);
1404       require(
1405         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1406         "ERC721A: transfer to non ERC721Receiver implementer"
1407       );
1408       updatedIndex++;
1409     }
1410 
1411     currentIndex = updatedIndex;
1412     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1413   }
1414 
1415   /**
1416    * @dev Transfers tokenId from from to to.
1417    *
1418    * Requirements:
1419    *
1420    * - to cannot be the zero address.
1421    * - tokenId token must be owned by from.
1422    *
1423    * Emits a {Transfer} event.
1424    */
1425   function _transfer(
1426     address from,
1427     address to,
1428     uint256 tokenId
1429   ) private {
1430     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1431 
1432     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1433       getApproved(tokenId) == _msgSender() ||
1434       isApprovedForAll(prevOwnership.addr, _msgSender()));
1435 
1436     require(
1437       isApprovedOrOwner,
1438       "ERC721A: transfer caller is not owner nor approved"
1439     );
1440 
1441     require(
1442       prevOwnership.addr == from,
1443       "ERC721A: transfer from incorrect owner"
1444     );
1445     require(to != address(0), "ERC721A: transfer to the zero address");
1446 
1447     _beforeTokenTransfers(from, to, tokenId, 1);
1448 
1449     // Clear approvals from the previous owner
1450     _approve(address(0), tokenId, prevOwnership.addr);
1451 
1452     _addressData[from].balance -= 1;
1453     _addressData[to].balance += 1;
1454     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1455 
1456     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1457     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1458     uint256 nextTokenId = tokenId + 1;
1459     if (_ownerships[nextTokenId].addr == address(0)) {
1460       if (_exists(nextTokenId)) {
1461         _ownerships[nextTokenId] = TokenOwnership(
1462           prevOwnership.addr,
1463           prevOwnership.startTimestamp
1464         );
1465       }
1466     }
1467 
1468     emit Transfer(from, to, tokenId);
1469     _afterTokenTransfers(from, to, tokenId, 1);
1470   }
1471 
1472   /**
1473    * @dev Approve to to operate on tokenId
1474    *
1475    * Emits a {Approval} event.
1476    */
1477   function _approve(
1478     address to,
1479     uint256 tokenId,
1480     address owner
1481   ) private {
1482     _tokenApprovals[tokenId] = to;
1483     emit Approval(owner, to, tokenId);
1484   }
1485 
1486   uint256 public nextOwnerToExplicitlySet = 0;
1487 
1488   /**
1489    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1490    */
1491   function _setOwnersExplicit(uint256 quantity) internal {
1492     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1493     require(quantity > 0, "quantity must be nonzero");
1494     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1495 
1496     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1497     if (endIndex > collectionSize - 1) {
1498       endIndex = collectionSize - 1;
1499     }
1500     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1501     require(_exists(endIndex), "not enough minted yet for this cleanup");
1502     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1503       if (_ownerships[i].addr == address(0)) {
1504         TokenOwnership memory ownership = ownershipOf(i);
1505         _ownerships[i] = TokenOwnership(
1506           ownership.addr,
1507           ownership.startTimestamp
1508         );
1509       }
1510     }
1511     nextOwnerToExplicitlySet = endIndex + 1;
1512   }
1513 
1514   /**
1515    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1516    * The call is not executed if the target address is not a contract.
1517    *
1518    * @param from address representing the previous owner of the given token ID
1519    * @param to target address that will receive the tokens
1520    * @param tokenId uint256 ID of the token to be transferred
1521    * @param _data bytes optional data to send along with the call
1522    * @return bool whether the call correctly returned the expected magic value
1523    */
1524   function _checkOnERC721Received(
1525     address from,
1526     address to,
1527     uint256 tokenId,
1528     bytes memory _data
1529   ) private returns (bool) {
1530     if (to.isContract()) {
1531       try
1532         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1533       returns (bytes4 retval) {
1534         return retval == IERC721Receiver(to).onERC721Received.selector;
1535       } catch (bytes memory reason) {
1536         if (reason.length == 0) {
1537           revert("ERC721A: transfer to non ERC721Receiver implementer");
1538         } else {
1539           assembly {
1540             revert(add(32, reason), mload(reason))
1541           }
1542         }
1543       }
1544     } else {
1545       return true;
1546     }
1547   }
1548 
1549   /**
1550    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1551    *
1552    * startTokenId - the first token id to be transferred
1553    * quantity - the amount to be transferred
1554    *
1555    * Calling conditions:
1556    *
1557    * - When from and to are both non-zero, from's tokenId will be
1558    * transferred to to.
1559    * - When from is zero, tokenId will be minted for to.
1560    */
1561   function _beforeTokenTransfers(
1562     address from,
1563     address to,
1564     uint256 startTokenId,
1565     uint256 quantity
1566   ) internal virtual {}
1567 
1568   /**
1569    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1570    * minting.
1571    *
1572    * startTokenId - the first token id to be transferred
1573    * quantity - the amount to be transferred
1574    *
1575    * Calling conditions:
1576    *
1577    * - when from and to are both non-zero.
1578    * - from and to are never both zero.
1579    */
1580   function _afterTokenTransfers(
1581     address from,
1582     address to,
1583     uint256 startTokenId,
1584     uint256 quantity
1585   ) internal virtual {}
1586 }
1587 
1588 abstract contract ProviderFees is Context {
1589   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1590   uint256 public PROVIDER_FEE = 0.000777 ether;  
1591 
1592   function sendProviderFee() internal {
1593     payable(PROVIDER).transfer(PROVIDER_FEE);
1594   }
1595 
1596   function setProviderFee(uint256 _fee) public {
1597     if(_msgSender() != PROVIDER) revert NotMaintainer();
1598     PROVIDER_FEE = _fee;
1599   }
1600 }
1601 
1602 
1603 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1604 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1605 // @notice -- See Medium article --
1606 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1607 abstract contract ERC721ARedemption is ERC721A, ProviderFees {
1608   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1609   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1610 
1611   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1612   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1613   
1614   uint256 public redemptionSurcharge = 0 ether;
1615   bool public redemptionModeEnabled;
1616   bool public verifiedClaimModeEnabled;
1617   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1618   mapping(address => bool) public redemptionContracts;
1619   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1620 
1621   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1622   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1623     redemptionContracts[_contractAddress] = _status;
1624   }
1625 
1626   // @dev Allow owner/team to determine if contract is accepting redemption mints
1627   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1628     redemptionModeEnabled = _newStatus;
1629   }
1630 
1631   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1632   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1633     verifiedClaimModeEnabled = _newStatus;
1634   }
1635 
1636   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1637   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1638     redemptionSurcharge = _newSurchargeInWei;
1639   }
1640 
1641   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1642   // @notice Must be a wallet address or implement IERC721Receiver.
1643   // Cannot be null address as this will break any ERC-721A implementation without a proper
1644   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1645   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1646     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1647     redemptionAddress = _newRedemptionAddress;
1648   }
1649 
1650   /**
1651   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1652   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1653   * the contract owner or Team => redemptionAddress. 
1654   * @param tokenId the token to be redeemed.
1655   * Emits a {Redeemed} event.
1656   **/
1657   function redeem(address redemptionContract, uint256 tokenId) public payable {
1658     if(getNextTokenId() > collectionSize) revert CapExceeded();
1659     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1660     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1661     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1662     if(msg.value != (redemptionSurcharge + PROVIDER_FEE)) revert InvalidPayment();
1663     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1664     
1665     IERC721 _targetContract = IERC721(redemptionContract);
1666     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1667     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1668     
1669     // Warning: Since there is no standarized return value for transfers of ERC-721
1670     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1671     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1672     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1673     // but the NFT may not have been sent to the redemptionAddress.
1674     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1675     tokenRedemptions[redemptionContract][tokenId] = true;
1676 
1677     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1678     sendProviderFee();
1679     _safeMint(_msgSender(), 1, false);
1680   }
1681 
1682   /**
1683   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1684   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1685   * @param tokenId the token to be redeemed.
1686   * Emits a {VerifiedClaim} event.
1687   **/
1688   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1689     if(getNextTokenId() > collectionSize) revert CapExceeded();
1690     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1691     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1692     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1693     if(msg.value != (redemptionSurcharge + PROVIDER_FEE)) revert InvalidPayment();
1694     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1695     
1696     tokenRedemptions[redemptionContract][tokenId] = true;
1697     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1698     sendProviderFee();
1699     _safeMint(_msgSender(), 1, false);
1700   }
1701 }
1702 
1703 
1704 
1705   
1706 /** TimedDrop.sol
1707 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1708 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1709 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1710 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1711 */
1712 abstract contract TimedDrop is Teams {
1713   bool public enforcePublicDropTime = false;
1714   uint256 public publicDropTime = 0;
1715   
1716   /**
1717   * @dev Allow the contract owner to set the public time to mint.
1718   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1719   */
1720   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1721     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1722     publicDropTime = _newDropTime;
1723   }
1724 
1725   function usePublicDropTime() public onlyTeamOrOwner {
1726     enforcePublicDropTime = true;
1727   }
1728 
1729   function disablePublicDropTime() public onlyTeamOrOwner {
1730     enforcePublicDropTime = false;
1731   }
1732 
1733   /**
1734   * @dev determine if the public droptime has passed.
1735   * if the feature is disabled then assume the time has passed.
1736   */
1737   function publicDropTimePassed() public view returns(bool) {
1738     if(enforcePublicDropTime == false) {
1739       return true;
1740     }
1741     return block.timestamp >= publicDropTime;
1742   }
1743   
1744 }
1745 
1746   
1747 interface IERC20 {
1748   function allowance(address owner, address spender) external view returns (uint256);
1749   function transfer(address _to, uint256 _amount) external returns (bool);
1750   function balanceOf(address account) external view returns (uint256);
1751   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1752 }
1753 
1754 // File: WithdrawableV2
1755 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1756 // ERC-20 Payouts are limited to a single payout address. This feature 
1757 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1758 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1759 abstract contract WithdrawableV2 is Teams {
1760   struct acceptedERC20 {
1761     bool isActive;
1762     uint256 chargeAmount;
1763   }
1764 
1765   
1766   mapping(address => acceptedERC20) private allowedTokenContracts;
1767   address[] public payableAddresses = [0xe37bC92190da10470280a253449a189c86d5253B];
1768   address public erc20Payable = 0xe37bC92190da10470280a253449a189c86d5253B;
1769   uint256[] public payableFees = [100];
1770   uint256 public payableAddressCount = 1;
1771   bool public onlyERC20MintingMode;
1772   
1773 
1774   function withdrawAll() public onlyTeamOrOwner {
1775       if(address(this).balance == 0) revert ValueCannotBeZero();
1776       _withdrawAll(address(this).balance);
1777   }
1778 
1779   function _withdrawAll(uint256 balance) private {
1780       for(uint i=0; i < payableAddressCount; i++ ) {
1781           _widthdraw(
1782               payableAddresses[i],
1783               (balance * payableFees[i]) / 100
1784           );
1785       }
1786   }
1787   
1788   function _widthdraw(address _address, uint256 _amount) private {
1789       (bool success, ) = _address.call{value: _amount}("");
1790       require(success, "Transfer failed.");
1791   }
1792 
1793   /**
1794   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1795   * in the event ERC-20 tokens are paid to the contract for mints.
1796   * @param _tokenContract contract of ERC-20 token to withdraw
1797   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1798   */
1799   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1800     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1801     IERC20 tokenContract = IERC20(_tokenContract);
1802     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1803     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1804   }
1805 
1806   /**
1807   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1808   * @param _erc20TokenContract address of ERC-20 contract in question
1809   */
1810   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1811     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1812   }
1813 
1814   /**
1815   * @dev get the value of tokens to transfer for user of an ERC-20
1816   * @param _erc20TokenContract address of ERC-20 contract in question
1817   */
1818   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1819     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1820     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1821   }
1822 
1823   /**
1824   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1825   * @param _erc20TokenContract address of ERC-20 contract in question
1826   * @param _isActive default status of if contract should be allowed to accept payments
1827   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1828   */
1829   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1830     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1831     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1832   }
1833 
1834   /**
1835   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1836   * it will assume the default value of zero. This should not be used to create new payment tokens.
1837   * @param _erc20TokenContract address of ERC-20 contract in question
1838   */
1839   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1840     allowedTokenContracts[_erc20TokenContract].isActive = true;
1841   }
1842 
1843   /**
1844   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1845   * it will assume the default value of zero. This should not be used to create new payment tokens.
1846   * @param _erc20TokenContract address of ERC-20 contract in question
1847   */
1848   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1849     allowedTokenContracts[_erc20TokenContract].isActive = false;
1850   }
1851 
1852   /**
1853   * @dev Enable only ERC-20 payments for minting on this contract
1854   */
1855   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1856     onlyERC20MintingMode = true;
1857   }
1858 
1859   /**
1860   * @dev Disable only ERC-20 payments for minting on this contract
1861   */
1862   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1863     onlyERC20MintingMode = false;
1864   }
1865 
1866   /**
1867   * @dev Set the payout of the ERC-20 token payout to a specific address
1868   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1869   */
1870   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1871     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1872     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1873     erc20Payable = _newErc20Payable;
1874   }
1875 }
1876 
1877 
1878   
1879 // File: isFeeable.sol
1880 abstract contract Feeable is Teams, ProviderFees {
1881   uint256 public PRICE = 0.003 ether;
1882 
1883   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1884     PRICE = _feeInWei;
1885   }
1886 
1887   function getPrice(uint256 _count) public view returns (uint256) {
1888     return (PRICE * _count) + PROVIDER_FEE;
1889   }
1890 }
1891 
1892   
1893 /* File: Tippable.sol
1894 /* @dev Allows owner to set strict enforcement of payment to mint price.
1895 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1896 /* when doing a free mint with opt-in pricing.
1897 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1898 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1899 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1900 /* Pros - can take in gratituity payments during a mint. 
1901 /* Cons - However if you decrease pricing during mint txn settlement 
1902 /* it can result in mints landing who technically now have overpaid.
1903 */
1904 abstract contract Tippable is Teams {
1905   bool public strictPricing = true;
1906 
1907   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1908     strictPricing = _newStatus;
1909   }
1910 
1911   // @dev check if msg.value is correct according to pricing enforcement
1912   // @param _msgValue -> passed in msg.value of tx
1913   // @param _expectedPrice -> result of getPrice(...args)
1914   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1915     return strictPricing ? 
1916       _msgValue == _expectedPrice : 
1917       _msgValue >= _expectedPrice;
1918   }
1919 }
1920 
1921   
1922   
1923   
1924 abstract contract ERC721APlus is 
1925     Ownable,
1926     Teams,
1927     ERC721ARedemption,
1928     WithdrawableV2,
1929     ReentrancyGuard 
1930     , Feeable, Tippable 
1931      
1932     , TimedDrop
1933 {
1934   constructor(
1935     string memory tokenName,
1936     string memory tokenSymbol
1937   ) ERC721A(tokenName, tokenSymbol, 5, 3300) { }
1938     uint8 constant public CONTRACT_VERSION = 2;
1939     string public _baseTokenURI = "ipfs://bafybeidlt545x3f4nep2hyum22nbw2ij2443kf2cafs4xvrybth6cu5s4y/";
1940     string public _baseTokenExtension = ".json";
1941 
1942     bool public mintingOpen = false;
1943     bool public isRevealed;
1944     
1945     uint256 public MAX_WALLET_MINTS = 5;
1946 
1947   
1948     /////////////// Admin Mint Functions
1949     /**
1950      * @dev Mints a token to an address with a tokenURI.
1951      * This is owner only and allows a fee-free drop
1952      * @param _to address of the future owner of the token
1953      * @param _qty amount of tokens to drop the owner
1954      */
1955      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1956          if(_qty == 0) revert MintZeroQuantity();
1957          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1958          _safeMint(_to, _qty, true);
1959      }
1960 
1961   
1962     /////////////// PUBLIC MINT FUNCTIONS
1963     /**
1964     * @dev Mints tokens to an address in batch.
1965     * fee may or may not be required*
1966     * @param _to address of the future owner of the token
1967     * @param _amount number of tokens to mint
1968     */
1969     function mintToMultiple(address _to, uint256 _amount) public payable {
1970         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1971         if(_amount == 0) revert MintZeroQuantity();
1972         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1973         if(!mintingOpen) revert PublicMintClosed();
1974         
1975         if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
1976         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1977         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1978         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
1979         sendProviderFee();
1980         _safeMint(_to, _amount, false);
1981     }
1982 
1983     /**
1984      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1985      * fee may or may not be required*
1986      * @param _to address of the future owner of the token
1987      * @param _amount number of tokens to mint
1988      * @param _erc20TokenContract erc-20 token contract to mint with
1989      */
1990     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1991       if(_amount == 0) revert MintZeroQuantity();
1992       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1993       if(!mintingOpen) revert PublicMintClosed();
1994       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1995       
1996       if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
1997       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1998       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
1999 
2000       // ERC-20 Specific pre-flight checks
2001       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2002       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2003       IERC20 payableToken = IERC20(_erc20TokenContract);
2004 
2005       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2006       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2007 
2008       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2009       if(!transferComplete) revert ERC20TransferFailed();
2010 
2011       sendProviderFee();
2012       _safeMint(_to, _amount, false);
2013     }
2014 
2015     function openMinting() public onlyTeamOrOwner {
2016         mintingOpen = true;
2017     }
2018 
2019     function stopMinting() public onlyTeamOrOwner {
2020         mintingOpen = false;
2021     }
2022 
2023   
2024 
2025   
2026     /**
2027     * @dev Check if wallet over MAX_WALLET_MINTS
2028     * @param _address address in question to check if minted count exceeds max
2029     */
2030     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2031         if(_amount == 0) revert ValueCannotBeZero();
2032         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2033     }
2034 
2035     /**
2036     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2037     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2038     */
2039     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2040         if(_newWalletMax == 0) revert ValueCannotBeZero();
2041         MAX_WALLET_MINTS = _newWalletMax;
2042     }
2043     
2044 
2045   
2046     /**
2047      * @dev Allows owner to set Max mints per tx
2048      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2049      */
2050      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2051          if(_newMaxMint == 0) revert ValueCannotBeZero();
2052          maxBatchSize = _newMaxMint;
2053      }
2054     
2055 
2056   
2057     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2058         if(isRevealed) revert IsAlreadyUnveiled();
2059         _baseTokenURI = _updatedTokenURI;
2060         isRevealed = true;
2061     }
2062     
2063   
2064   
2065   function contractURI() public pure returns (string memory) {
2066     return "https://metadata.mintplex.xyz/IEzVdHhPbuOfk1zYwGu2/contract-metadata";
2067   }
2068   
2069 
2070   function _baseURI() internal view virtual override returns(string memory) {
2071     return _baseTokenURI;
2072   }
2073 
2074   function _baseURIExtension() internal view virtual override returns(string memory) {
2075     return _baseTokenExtension;
2076   }
2077 
2078   function baseTokenURI() public view returns(string memory) {
2079     return _baseTokenURI;
2080   }
2081 
2082   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2083     _baseTokenURI = baseURI;
2084   }
2085 
2086   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2087     _baseTokenExtension = baseExtension;
2088   }
2089 }
2090 
2091 
2092   
2093 // File: contracts/X4FourpuzzlesContract.sol
2094 //SPDX-License-Identifier: MIT
2095 
2096 pragma solidity ^0.8.0;
2097 
2098 contract X4FourpuzzlesContract is ERC721APlus {
2099     constructor() ERC721APlus("4FOUR PUZZLES", "4PZZLS"){}
2100 }
2101   