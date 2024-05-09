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
901   
902   
903 // Rampp Contracts v2.1 (Teams.sol)
904 
905 error InvalidTeamAddress();
906 error DuplicateTeamAddress();
907 pragma solidity ^0.8.0;
908 
909 /**
910 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
911 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
912 * This will easily allow cross-collaboration via Mintplex.xyz.
913 **/
914 abstract contract Teams is Ownable{
915   mapping (address => bool) internal team;
916 
917   /**
918   * @dev Adds an address to the team. Allows them to execute protected functions
919   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
920   **/
921   function addToTeam(address _address) public onlyOwner {
922     if(_address == address(0)) revert InvalidTeamAddress();
923     if(inTeam(_address)) revert DuplicateTeamAddress();
924   
925     team[_address] = true;
926   }
927 
928   /**
929   * @dev Removes an address to the team.
930   * @param _address the ETH address to remove, cannot be 0x and must be in team
931   **/
932   function removeFromTeam(address _address) public onlyOwner {
933     if(_address == address(0)) revert InvalidTeamAddress();
934     if(!inTeam(_address)) revert InvalidTeamAddress();
935   
936     team[_address] = false;
937   }
938 
939   /**
940   * @dev Check if an address is valid and active in the team
941   * @param _address ETH address to check for truthiness
942   **/
943   function inTeam(address _address)
944     public
945     view
946     returns (bool)
947   {
948     if(_address == address(0)) revert InvalidTeamAddress();
949     return team[_address] == true;
950   }
951 
952   /**
953   * @dev Throws if called by any account other than the owner or team member.
954   */
955   function _onlyTeamOrOwner() private view {
956     bool _isOwner = owner() == _msgSender();
957     bool _isTeam = inTeam(_msgSender());
958     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
959   }
960 
961   modifier onlyTeamOrOwner() {
962     _onlyTeamOrOwner();
963     _;
964   }
965 }
966 
967 
968   
969   
970 /**
971  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
972  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
973  *
974  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
975  * 
976  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
977  *
978  * Does not support burning tokens to address(0).
979  */
980 contract ERC721A is
981   Context,
982   ERC165,
983   IERC721,
984   IERC721Metadata,
985   IERC721Enumerable,
986   Teams
987   , OperatorFilterer
988 {
989   using Address for address;
990   using Strings for uint256;
991 
992   struct TokenOwnership {
993     address addr;
994     uint64 startTimestamp;
995   }
996 
997   struct AddressData {
998     uint128 balance;
999     uint128 numberMinted;
1000   }
1001 
1002   uint256 private currentIndex;
1003 
1004   uint256 public immutable collectionSize;
1005   uint256 public maxBatchSize;
1006 
1007   // Token name
1008   string private _name;
1009 
1010   // Token symbol
1011   string private _symbol;
1012 
1013   // Mapping from token ID to ownership details
1014   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1015   mapping(uint256 => TokenOwnership) private _ownerships;
1016 
1017   // Mapping owner address to address data
1018   mapping(address => AddressData) private _addressData;
1019 
1020   // Mapping from token ID to approved address
1021   mapping(uint256 => address) private _tokenApprovals;
1022 
1023   // Mapping from owner to operator approvals
1024   mapping(address => mapping(address => bool)) private _operatorApprovals;
1025 
1026   /* @dev Mapping of restricted operator approvals set by contract Owner
1027   * This serves as an optional addition to ERC-721 so
1028   * that the contract owner can elect to prevent specific addresses/contracts
1029   * from being marked as the approver for a token. The reason for this
1030   * is that some projects may want to retain control of where their tokens can/can not be listed
1031   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1032   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1033   */
1034   mapping(address => bool) public restrictedApprovalAddresses;
1035 
1036   /**
1037    * @dev
1038    * maxBatchSize refers to how much a minter can mint at a time.
1039    * collectionSize_ refers to how many tokens are in the collection.
1040    */
1041   constructor(
1042     string memory name_,
1043     string memory symbol_,
1044     uint256 maxBatchSize_,
1045     uint256 collectionSize_
1046   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1047     require(
1048       collectionSize_ > 0,
1049       "ERC721A: collection must have a nonzero supply"
1050     );
1051     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1052     _name = name_;
1053     _symbol = symbol_;
1054     maxBatchSize = maxBatchSize_;
1055     collectionSize = collectionSize_;
1056     currentIndex = _startTokenId();
1057   }
1058 
1059   /**
1060   * To change the starting tokenId, please override this function.
1061   */
1062   function _startTokenId() internal view virtual returns (uint256) {
1063     return 1;
1064   }
1065 
1066   /**
1067    * @dev See {IERC721Enumerable-totalSupply}.
1068    */
1069   function totalSupply() public view override returns (uint256) {
1070     return _totalMinted();
1071   }
1072 
1073   function currentTokenId() public view returns (uint256) {
1074     return _totalMinted();
1075   }
1076 
1077   function getNextTokenId() public view returns (uint256) {
1078       return _totalMinted() + 1;
1079   }
1080 
1081   /**
1082   * Returns the total amount of tokens minted in the contract.
1083   */
1084   function _totalMinted() internal view returns (uint256) {
1085     unchecked {
1086       return currentIndex - _startTokenId();
1087     }
1088   }
1089 
1090   /**
1091    * @dev See {IERC721Enumerable-tokenByIndex}.
1092    */
1093   function tokenByIndex(uint256 index) public view override returns (uint256) {
1094     require(index < totalSupply(), "ERC721A: global index out of bounds");
1095     return index;
1096   }
1097 
1098   /**
1099    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1100    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1101    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1102    */
1103   function tokenOfOwnerByIndex(address owner, uint256 index)
1104     public
1105     view
1106     override
1107     returns (uint256)
1108   {
1109     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1110     uint256 numMintedSoFar = totalSupply();
1111     uint256 tokenIdsIdx = 0;
1112     address currOwnershipAddr = address(0);
1113     for (uint256 i = 0; i < numMintedSoFar; i++) {
1114       TokenOwnership memory ownership = _ownerships[i];
1115       if (ownership.addr != address(0)) {
1116         currOwnershipAddr = ownership.addr;
1117       }
1118       if (currOwnershipAddr == owner) {
1119         if (tokenIdsIdx == index) {
1120           return i;
1121         }
1122         tokenIdsIdx++;
1123       }
1124     }
1125     revert("ERC721A: unable to get token of owner by index");
1126   }
1127 
1128   /**
1129    * @dev See {IERC165-supportsInterface}.
1130    */
1131   function supportsInterface(bytes4 interfaceId)
1132     public
1133     view
1134     virtual
1135     override(ERC165, IERC165)
1136     returns (bool)
1137   {
1138     return
1139       interfaceId == type(IERC721).interfaceId ||
1140       interfaceId == type(IERC721Metadata).interfaceId ||
1141       interfaceId == type(IERC721Enumerable).interfaceId ||
1142       super.supportsInterface(interfaceId);
1143   }
1144 
1145   /**
1146    * @dev See {IERC721-balanceOf}.
1147    */
1148   function balanceOf(address owner) public view override returns (uint256) {
1149     require(owner != address(0), "ERC721A: balance query for the zero address");
1150     return uint256(_addressData[owner].balance);
1151   }
1152 
1153   function _numberMinted(address owner) internal view returns (uint256) {
1154     require(
1155       owner != address(0),
1156       "ERC721A: number minted query for the zero address"
1157     );
1158     return uint256(_addressData[owner].numberMinted);
1159   }
1160 
1161   function ownershipOf(uint256 tokenId)
1162     internal
1163     view
1164     returns (TokenOwnership memory)
1165   {
1166     uint256 curr = tokenId;
1167 
1168     unchecked {
1169         if (_startTokenId() <= curr && curr < currentIndex) {
1170             TokenOwnership memory ownership = _ownerships[curr];
1171             if (ownership.addr != address(0)) {
1172                 return ownership;
1173             }
1174 
1175             // Invariant:
1176             // There will always be an ownership that has an address and is not burned
1177             // before an ownership that does not have an address and is not burned.
1178             // Hence, curr will not underflow.
1179             while (true) {
1180                 curr--;
1181                 ownership = _ownerships[curr];
1182                 if (ownership.addr != address(0)) {
1183                     return ownership;
1184                 }
1185             }
1186         }
1187     }
1188 
1189     revert("ERC721A: unable to determine the owner of token");
1190   }
1191 
1192   /**
1193    * @dev See {IERC721-ownerOf}.
1194    */
1195   function ownerOf(uint256 tokenId) public view override returns (address) {
1196     return ownershipOf(tokenId).addr;
1197   }
1198 
1199   /**
1200    * @dev See {IERC721Metadata-name}.
1201    */
1202   function name() public view virtual override returns (string memory) {
1203     return _name;
1204   }
1205 
1206   /**
1207    * @dev See {IERC721Metadata-symbol}.
1208    */
1209   function symbol() public view virtual override returns (string memory) {
1210     return _symbol;
1211   }
1212 
1213   /**
1214    * @dev See {IERC721Metadata-tokenURI}.
1215    */
1216   function tokenURI(uint256 tokenId)
1217     public
1218     view
1219     virtual
1220     override
1221     returns (string memory)
1222   {
1223     string memory baseURI = _baseURI();
1224     string memory extension = _baseURIExtension();
1225     return
1226       bytes(baseURI).length > 0
1227         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1228         : "";
1229   }
1230 
1231   /**
1232    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1233    * token will be the concatenation of the baseURI and the tokenId. Empty
1234    * by default, can be overriden in child contracts.
1235    */
1236   function _baseURI() internal view virtual returns (string memory) {
1237     return "";
1238   }
1239 
1240   /**
1241    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1242    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1243    * by default, can be overriden in child contracts.
1244    */
1245   function _baseURIExtension() internal view virtual returns (string memory) {
1246     return "";
1247   }
1248 
1249   /**
1250    * @dev Sets the value for an address to be in the restricted approval address pool.
1251    * Setting an address to true will disable token owners from being able to mark the address
1252    * for approval for trading. This would be used in theory to prevent token owners from listing
1253    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1254    * @param _address the marketplace/user to modify restriction status of
1255    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1256    */
1257   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1258     restrictedApprovalAddresses[_address] = _isRestricted;
1259   }
1260 
1261   /**
1262    * @dev See {IERC721-approve}.
1263    */
1264   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1265     address owner = ERC721A.ownerOf(tokenId);
1266     require(to != owner, "ERC721A: approval to current owner");
1267     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1268 
1269     require(
1270       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1271       "ERC721A: approve caller is not owner nor approved for all"
1272     );
1273 
1274     _approve(to, tokenId, owner);
1275   }
1276 
1277   /**
1278    * @dev See {IERC721-getApproved}.
1279    */
1280   function getApproved(uint256 tokenId) public view override returns (address) {
1281     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1282 
1283     return _tokenApprovals[tokenId];
1284   }
1285 
1286   /**
1287    * @dev See {IERC721-setApprovalForAll}.
1288    */
1289   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1290     require(operator != _msgSender(), "ERC721A: approve to caller");
1291     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1292 
1293     _operatorApprovals[_msgSender()][operator] = approved;
1294     emit ApprovalForAll(_msgSender(), operator, approved);
1295   }
1296 
1297   /**
1298    * @dev See {IERC721-isApprovedForAll}.
1299    */
1300   function isApprovedForAll(address owner, address operator)
1301     public
1302     view
1303     virtual
1304     override
1305     returns (bool)
1306   {
1307     return _operatorApprovals[owner][operator];
1308   }
1309 
1310   /**
1311    * @dev See {IERC721-transferFrom}.
1312    */
1313   function transferFrom(
1314     address from,
1315     address to,
1316     uint256 tokenId
1317   ) public override onlyAllowedOperator(from) {
1318     _transfer(from, to, tokenId);
1319   }
1320 
1321   /**
1322    * @dev See {IERC721-safeTransferFrom}.
1323    */
1324   function safeTransferFrom(
1325     address from,
1326     address to,
1327     uint256 tokenId
1328   ) public override onlyAllowedOperator(from) {
1329     safeTransferFrom(from, to, tokenId, "");
1330   }
1331 
1332   /**
1333    * @dev See {IERC721-safeTransferFrom}.
1334    */
1335   function safeTransferFrom(
1336     address from,
1337     address to,
1338     uint256 tokenId,
1339     bytes memory _data
1340   ) public override onlyAllowedOperator(from) {
1341     _transfer(from, to, tokenId);
1342     require(
1343       _checkOnERC721Received(from, to, tokenId, _data),
1344       "ERC721A: transfer to non ERC721Receiver implementer"
1345     );
1346   }
1347 
1348   /**
1349    * @dev Returns whether tokenId exists.
1350    *
1351    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1352    *
1353    * Tokens start existing when they are minted (_mint),
1354    */
1355   function _exists(uint256 tokenId) internal view returns (bool) {
1356     return _startTokenId() <= tokenId && tokenId < currentIndex;
1357   }
1358 
1359   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1360     _safeMint(to, quantity, isAdminMint, "");
1361   }
1362 
1363   /**
1364    * @dev Mints quantity tokens and transfers them to to.
1365    *
1366    * Requirements:
1367    *
1368    * - there must be quantity tokens remaining unminted in the total collection.
1369    * - to cannot be the zero address.
1370    * - quantity cannot be larger than the max batch size.
1371    *
1372    * Emits a {Transfer} event.
1373    */
1374   function _safeMint(
1375     address to,
1376     uint256 quantity,
1377     bool isAdminMint,
1378     bytes memory _data
1379   ) internal {
1380     uint256 startTokenId = currentIndex;
1381     require(to != address(0), "ERC721A: mint to the zero address");
1382     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1383     require(!_exists(startTokenId), "ERC721A: token already minted");
1384 
1385     // For admin mints we do not want to enforce the maxBatchSize limit
1386     if (isAdminMint == false) {
1387         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1388     }
1389 
1390     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1391 
1392     AddressData memory addressData = _addressData[to];
1393     _addressData[to] = AddressData(
1394       addressData.balance + uint128(quantity),
1395       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1396     );
1397     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1398 
1399     uint256 updatedIndex = startTokenId;
1400 
1401     for (uint256 i = 0; i < quantity; i++) {
1402       emit Transfer(address(0), to, updatedIndex);
1403       require(
1404         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1405         "ERC721A: transfer to non ERC721Receiver implementer"
1406       );
1407       updatedIndex++;
1408     }
1409 
1410     currentIndex = updatedIndex;
1411     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1412   }
1413 
1414   /**
1415    * @dev Transfers tokenId from from to to.
1416    *
1417    * Requirements:
1418    *
1419    * - to cannot be the zero address.
1420    * - tokenId token must be owned by from.
1421    *
1422    * Emits a {Transfer} event.
1423    */
1424   function _transfer(
1425     address from,
1426     address to,
1427     uint256 tokenId
1428   ) private {
1429     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1430 
1431     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1432       getApproved(tokenId) == _msgSender() ||
1433       isApprovedForAll(prevOwnership.addr, _msgSender()));
1434 
1435     require(
1436       isApprovedOrOwner,
1437       "ERC721A: transfer caller is not owner nor approved"
1438     );
1439 
1440     require(
1441       prevOwnership.addr == from,
1442       "ERC721A: transfer from incorrect owner"
1443     );
1444     require(to != address(0), "ERC721A: transfer to the zero address");
1445 
1446     _beforeTokenTransfers(from, to, tokenId, 1);
1447 
1448     // Clear approvals from the previous owner
1449     _approve(address(0), tokenId, prevOwnership.addr);
1450 
1451     _addressData[from].balance -= 1;
1452     _addressData[to].balance += 1;
1453     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1454 
1455     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1456     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1457     uint256 nextTokenId = tokenId + 1;
1458     if (_ownerships[nextTokenId].addr == address(0)) {
1459       if (_exists(nextTokenId)) {
1460         _ownerships[nextTokenId] = TokenOwnership(
1461           prevOwnership.addr,
1462           prevOwnership.startTimestamp
1463         );
1464       }
1465     }
1466 
1467     emit Transfer(from, to, tokenId);
1468     _afterTokenTransfers(from, to, tokenId, 1);
1469   }
1470 
1471   /**
1472    * @dev Approve to to operate on tokenId
1473    *
1474    * Emits a {Approval} event.
1475    */
1476   function _approve(
1477     address to,
1478     uint256 tokenId,
1479     address owner
1480   ) private {
1481     _tokenApprovals[tokenId] = to;
1482     emit Approval(owner, to, tokenId);
1483   }
1484 
1485   uint256 public nextOwnerToExplicitlySet = 0;
1486 
1487   /**
1488    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1489    */
1490   function _setOwnersExplicit(uint256 quantity) internal {
1491     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1492     require(quantity > 0, "quantity must be nonzero");
1493     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1494 
1495     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1496     if (endIndex > collectionSize - 1) {
1497       endIndex = collectionSize - 1;
1498     }
1499     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1500     require(_exists(endIndex), "not enough minted yet for this cleanup");
1501     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1502       if (_ownerships[i].addr == address(0)) {
1503         TokenOwnership memory ownership = ownershipOf(i);
1504         _ownerships[i] = TokenOwnership(
1505           ownership.addr,
1506           ownership.startTimestamp
1507         );
1508       }
1509     }
1510     nextOwnerToExplicitlySet = endIndex + 1;
1511   }
1512 
1513   /**
1514    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1515    * The call is not executed if the target address is not a contract.
1516    *
1517    * @param from address representing the previous owner of the given token ID
1518    * @param to target address that will receive the tokens
1519    * @param tokenId uint256 ID of the token to be transferred
1520    * @param _data bytes optional data to send along with the call
1521    * @return bool whether the call correctly returned the expected magic value
1522    */
1523   function _checkOnERC721Received(
1524     address from,
1525     address to,
1526     uint256 tokenId,
1527     bytes memory _data
1528   ) private returns (bool) {
1529     if (to.isContract()) {
1530       try
1531         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1532       returns (bytes4 retval) {
1533         return retval == IERC721Receiver(to).onERC721Received.selector;
1534       } catch (bytes memory reason) {
1535         if (reason.length == 0) {
1536           revert("ERC721A: transfer to non ERC721Receiver implementer");
1537         } else {
1538           assembly {
1539             revert(add(32, reason), mload(reason))
1540           }
1541         }
1542       }
1543     } else {
1544       return true;
1545     }
1546   }
1547 
1548   /**
1549    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1550    *
1551    * startTokenId - the first token id to be transferred
1552    * quantity - the amount to be transferred
1553    *
1554    * Calling conditions:
1555    *
1556    * - When from and to are both non-zero, from's tokenId will be
1557    * transferred to to.
1558    * - When from is zero, tokenId will be minted for to.
1559    */
1560   function _beforeTokenTransfers(
1561     address from,
1562     address to,
1563     uint256 startTokenId,
1564     uint256 quantity
1565   ) internal virtual {}
1566 
1567   /**
1568    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1569    * minting.
1570    *
1571    * startTokenId - the first token id to be transferred
1572    * quantity - the amount to be transferred
1573    *
1574    * Calling conditions:
1575    *
1576    * - when from and to are both non-zero.
1577    * - from and to are never both zero.
1578    */
1579   function _afterTokenTransfers(
1580     address from,
1581     address to,
1582     uint256 startTokenId,
1583     uint256 quantity
1584   ) internal virtual {}
1585 }
1586 
1587 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1588 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1589 // @notice -- See Medium article --
1590 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1591 abstract contract ERC721ARedemption is ERC721A {
1592   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1593   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1594 
1595   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1596   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1597   
1598   uint256 public redemptionSurcharge = 0 ether;
1599   bool public redemptionModeEnabled;
1600   bool public verifiedClaimModeEnabled;
1601   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1602   mapping(address => bool) public redemptionContracts;
1603   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1604 
1605   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1606   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1607     redemptionContracts[_contractAddress] = _status;
1608   }
1609 
1610   // @dev Allow owner/team to determine if contract is accepting redemption mints
1611   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1612     redemptionModeEnabled = _newStatus;
1613   }
1614 
1615   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1616   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1617     verifiedClaimModeEnabled = _newStatus;
1618   }
1619 
1620   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1621   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1622     redemptionSurcharge = _newSurchargeInWei;
1623   }
1624 
1625   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1626   // @notice Must be a wallet address or implement IERC721Receiver.
1627   // Cannot be null address as this will break any ERC-721A implementation without a proper
1628   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1629   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1630     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1631     redemptionAddress = _newRedemptionAddress;
1632   }
1633 
1634   /**
1635   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1636   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1637   * the contract owner or Team => redemptionAddress. 
1638   * @param tokenId the token to be redeemed.
1639   * Emits a {Redeemed} event.
1640   **/
1641   function redeem(address redemptionContract, uint256 tokenId) public payable {
1642     if(getNextTokenId() > collectionSize) revert CapExceeded();
1643     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1644     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1645     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1646     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1647     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1648     
1649     IERC721 _targetContract = IERC721(redemptionContract);
1650     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1651     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1652     
1653     // Warning: Since there is no standarized return value for transfers of ERC-721
1654     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1655     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1656     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1657     // but the NFT may not have been sent to the redemptionAddress.
1658     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1659     tokenRedemptions[redemptionContract][tokenId] = true;
1660 
1661     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1662     _safeMint(_msgSender(), 1, false);
1663   }
1664 
1665   /**
1666   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1667   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1668   * @param tokenId the token to be redeemed.
1669   * Emits a {VerifiedClaim} event.
1670   **/
1671   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1672     if(getNextTokenId() > collectionSize) revert CapExceeded();
1673     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1674     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1675     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1676     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1677     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1678     
1679     tokenRedemptions[redemptionContract][tokenId] = true;
1680     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1681     _safeMint(_msgSender(), 1, false);
1682   }
1683 }
1684 
1685 
1686   
1687   
1688 interface IERC20 {
1689   function allowance(address owner, address spender) external view returns (uint256);
1690   function transfer(address _to, uint256 _amount) external returns (bool);
1691   function balanceOf(address account) external view returns (uint256);
1692   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1693 }
1694 
1695 // File: WithdrawableV2
1696 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1697 // ERC-20 Payouts are limited to a single payout address. This feature 
1698 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1699 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1700 abstract contract WithdrawableV2 is Teams {
1701   struct acceptedERC20 {
1702     bool isActive;
1703     uint256 chargeAmount;
1704   }
1705 
1706   
1707   mapping(address => acceptedERC20) private allowedTokenContracts;
1708   address[] public payableAddresses = [0xF17b39994313522C11D523e4fE674B4352D2A641];
1709   address public erc20Payable = 0xF17b39994313522C11D523e4fE674B4352D2A641;
1710   uint256[] public payableFees = [100];
1711   uint256 public payableAddressCount = 1;
1712   bool public onlyERC20MintingMode;
1713   
1714 
1715   function withdrawAll() public onlyTeamOrOwner {
1716       if(address(this).balance == 0) revert ValueCannotBeZero();
1717       _withdrawAll(address(this).balance);
1718   }
1719 
1720   function _withdrawAll(uint256 balance) private {
1721       for(uint i=0; i < payableAddressCount; i++ ) {
1722           _widthdraw(
1723               payableAddresses[i],
1724               (balance * payableFees[i]) / 100
1725           );
1726       }
1727   }
1728   
1729   function _widthdraw(address _address, uint256 _amount) private {
1730       (bool success, ) = _address.call{value: _amount}("");
1731       require(success, "Transfer failed.");
1732   }
1733 
1734   /**
1735   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1736   * in the event ERC-20 tokens are paid to the contract for mints.
1737   * @param _tokenContract contract of ERC-20 token to withdraw
1738   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1739   */
1740   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1741     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1742     IERC20 tokenContract = IERC20(_tokenContract);
1743     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1744     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1745   }
1746 
1747   /**
1748   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1749   * @param _erc20TokenContract address of ERC-20 contract in question
1750   */
1751   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1752     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1753   }
1754 
1755   /**
1756   * @dev get the value of tokens to transfer for user of an ERC-20
1757   * @param _erc20TokenContract address of ERC-20 contract in question
1758   */
1759   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1760     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1761     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1762   }
1763 
1764   /**
1765   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1766   * @param _erc20TokenContract address of ERC-20 contract in question
1767   * @param _isActive default status of if contract should be allowed to accept payments
1768   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1769   */
1770   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1771     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1772     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1773   }
1774 
1775   /**
1776   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1777   * it will assume the default value of zero. This should not be used to create new payment tokens.
1778   * @param _erc20TokenContract address of ERC-20 contract in question
1779   */
1780   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1781     allowedTokenContracts[_erc20TokenContract].isActive = true;
1782   }
1783 
1784   /**
1785   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1786   * it will assume the default value of zero. This should not be used to create new payment tokens.
1787   * @param _erc20TokenContract address of ERC-20 contract in question
1788   */
1789   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1790     allowedTokenContracts[_erc20TokenContract].isActive = false;
1791   }
1792 
1793   /**
1794   * @dev Enable only ERC-20 payments for minting on this contract
1795   */
1796   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1797     onlyERC20MintingMode = true;
1798   }
1799 
1800   /**
1801   * @dev Disable only ERC-20 payments for minting on this contract
1802   */
1803   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1804     onlyERC20MintingMode = false;
1805   }
1806 
1807   /**
1808   * @dev Set the payout of the ERC-20 token payout to a specific address
1809   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1810   */
1811   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1812     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1813     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1814     erc20Payable = _newErc20Payable;
1815   }
1816 }
1817 
1818 
1819   
1820   
1821   
1822 // File: EarlyMintIncentive.sol
1823 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1824 // zero fee that can be calculated on the fly.
1825 abstract contract EarlyMintIncentive is Teams, ERC721A {
1826   uint256 public PRICE = 0.001 ether;
1827   uint256 public EARLY_MINT_PRICE = 0 ether;
1828   uint256 public earlyMintOwnershipCap = 2;
1829   bool public usingEarlyMintIncentive = true;
1830 
1831   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1832     usingEarlyMintIncentive = true;
1833   }
1834 
1835   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1836     usingEarlyMintIncentive = false;
1837   }
1838 
1839   /**
1840   * @dev Set the max token ID in which the cost incentive will be applied.
1841   * @param _newCap max number of tokens wallet may mint for incentive price
1842   */
1843   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1844     if(_newCap == 0) revert ValueCannotBeZero();
1845     earlyMintOwnershipCap = _newCap;
1846   }
1847 
1848   /**
1849   * @dev Set the incentive mint price
1850   * @param _feeInWei new price per token when in incentive range
1851   */
1852   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1853     EARLY_MINT_PRICE = _feeInWei;
1854   }
1855 
1856   /**
1857   * @dev Set the primary mint price - the base price when not under incentive
1858   * @param _feeInWei new price per token
1859   */
1860   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1861     PRICE = _feeInWei;
1862   }
1863 
1864   /**
1865   * @dev Get the correct price for the mint for qty and person minting
1866   * @param _count amount of tokens to calc for mint
1867   * @param _to the address which will be minting these tokens, passed explicitly
1868   */
1869   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1870     if(_count == 0) revert ValueCannotBeZero();
1871 
1872     // short circuit function if we dont need to even calc incentive pricing
1873     // short circuit if the current wallet mint qty is also already over cap
1874     if(
1875       usingEarlyMintIncentive == false ||
1876       _numberMinted(_to) > earlyMintOwnershipCap
1877     ) {
1878       return PRICE * _count;
1879     }
1880 
1881     uint256 endingTokenQty = _numberMinted(_to) + _count;
1882     // If qty to mint results in a final qty less than or equal to the cap then
1883     // the entire qty is within incentive mint.
1884     if(endingTokenQty  <= earlyMintOwnershipCap) {
1885       return EARLY_MINT_PRICE * _count;
1886     }
1887 
1888     // If the current token qty is less than the incentive cap
1889     // and the ending token qty is greater than the incentive cap
1890     // we will be straddling the cap so there will be some amount
1891     // that are incentive and some that are regular fee.
1892     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1893     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1894 
1895     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1896   }
1897 }
1898 
1899   
1900 abstract contract RamppERC721A is 
1901     Ownable,
1902     Teams,
1903     ERC721ARedemption,
1904     WithdrawableV2,
1905     ReentrancyGuard 
1906     , EarlyMintIncentive 
1907      
1908     
1909 {
1910   constructor(
1911     string memory tokenName,
1912     string memory tokenSymbol
1913   ) ERC721A(tokenName, tokenSymbol, 10, 4500) { }
1914     uint8 constant public CONTRACT_VERSION = 2;
1915     string public _baseTokenURI = "ipfs://bafybeigm4gg6efsjwdl4chqb4eajc5qyusjibumeuem3allfap57bd4cym/";
1916     string public _baseTokenExtension = ".json";
1917 
1918     bool public mintingOpen = true;
1919     
1920     
1921 
1922   
1923     /////////////// Admin Mint Functions
1924     /**
1925      * @dev Mints a token to an address with a tokenURI.
1926      * This is owner only and allows a fee-free drop
1927      * @param _to address of the future owner of the token
1928      * @param _qty amount of tokens to drop the owner
1929      */
1930      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1931          if(_qty == 0) revert MintZeroQuantity();
1932          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1933          _safeMint(_to, _qty, true);
1934      }
1935 
1936   
1937     /////////////// PUBLIC MINT FUNCTIONS
1938     /**
1939     * @dev Mints tokens to an address in batch.
1940     * fee may or may not be required*
1941     * @param _to address of the future owner of the token
1942     * @param _amount number of tokens to mint
1943     */
1944     function mintToMultiple(address _to, uint256 _amount) public payable {
1945         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1946         if(_amount == 0) revert MintZeroQuantity();
1947         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1948         if(!mintingOpen) revert PublicMintClosed();
1949         
1950         
1951         
1952         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1953         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
1954 
1955         _safeMint(_to, _amount, false);
1956     }
1957 
1958     /**
1959      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1960      * fee may or may not be required*
1961      * @param _to address of the future owner of the token
1962      * @param _amount number of tokens to mint
1963      * @param _erc20TokenContract erc-20 token contract to mint with
1964      */
1965     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1966       if(_amount == 0) revert MintZeroQuantity();
1967       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1968       if(!mintingOpen) revert PublicMintClosed();
1969       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1970       
1971       
1972       
1973 
1974       // ERC-20 Specific pre-flight checks
1975       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1976       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1977       IERC20 payableToken = IERC20(_erc20TokenContract);
1978 
1979       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1980       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1981 
1982       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1983       if(!transferComplete) revert ERC20TransferFailed();
1984       
1985       _safeMint(_to, _amount, false);
1986     }
1987 
1988     function openMinting() public onlyTeamOrOwner {
1989         mintingOpen = true;
1990     }
1991 
1992     function stopMinting() public onlyTeamOrOwner {
1993         mintingOpen = false;
1994     }
1995 
1996   
1997 
1998   
1999 
2000   
2001     /**
2002      * @dev Allows owner to set Max mints per tx
2003      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2004      */
2005      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2006          if(_newMaxMint == 0) revert ValueCannotBeZero();
2007          maxBatchSize = _newMaxMint;
2008      }
2009     
2010 
2011   
2012   
2013   
2014   function contractURI() public pure returns (string memory) {
2015     return "https://metadata.mintplex.xyz/yz8bEYRH80rQlvyIkVJT/contract-metadata";
2016   }
2017   
2018 
2019   function _baseURI() internal view virtual override returns(string memory) {
2020     return _baseTokenURI;
2021   }
2022 
2023   function _baseURIExtension() internal view virtual override returns(string memory) {
2024     return _baseTokenExtension;
2025   }
2026 
2027   function baseTokenURI() public view returns(string memory) {
2028     return _baseTokenURI;
2029   }
2030 
2031   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2032     _baseTokenURI = baseURI;
2033   }
2034 
2035   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2036     _baseTokenExtension = baseExtension;
2037   }
2038 }
2039 
2040 
2041   
2042 // File: contracts/XiKimDigitalTradingCardsContract.sol
2043 //SPDX-License-Identifier: MIT
2044 
2045 pragma solidity ^0.8.0;
2046 
2047 contract XiKimDigitalTradingCardsContract is RamppERC721A {
2048     constructor() RamppERC721A("Xi Kim Digital Trading Cards", "XKD"){}
2049 }
2050   
2051 //*********************************************************************//
2052 //*********************************************************************//  
2053 //                       Mintplex v3.0.0
2054 //
2055 //         This smart contract was generated by mintplex.xyz.
2056 //            Mintplex allows creators like you to launch 
2057 //             large scale NFT communities without code!
2058 //
2059 //    Mintplex is not responsible for the content of this contract and
2060 //        hopes it is being used in a responsible and kind way.  
2061 //       Mintplex is not associated or affiliated with this project.                                                    
2062 //             Twitter: @MintplexNFT ---- mintplex.xyz
2063 //*********************************************************************//                                                     
2064 //*********************************************************************// 
