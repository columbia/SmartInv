1 //-------------DEPENDENCIES--------------------------//
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library Address {
14     /**
15      * @dev Returns true if account is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, isContract will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on isContract to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's transfer: sends amount wei to
50      * recipient, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by transfer, making them unable to receive funds via
55      * transfer. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to recipient, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level call. A
73      * plain call is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If target reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
81      *
82      * Requirements:
83      *
84      * - target must be a contract.
85      * - calling target with data must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
95      * errorMessage as a fallback revert reason when target reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
109      * but also transferring value wei to target.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least value.
114      * - the called Solidity function must be payable.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
128      * with errorMessage as a fallback revert reason when target reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
174      * but performing a delegate call.
175      *
176      * _Available since v3.4._
177      */
178     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(isContract(target), "Address: delegate call to non-contract");
194 
195         (bool success, bytes memory returndata) = target.delegatecall(data);
196         return verifyCallResult(success, returndata, errorMessage);
197     }
198 
199     /**
200      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
201      * revert reason using the provided one.
202      *
203      * _Available since v4.3._
204      */
205     function verifyCallResult(
206         bool success,
207         bytes memory returndata,
208         string memory errorMessage
209     ) internal pure returns (bytes memory) {
210         if (success) {
211             return returndata;
212         } else {
213             // Look for revert reason and bubble it up if present
214             if (returndata.length > 0) {
215                 // The easiest way to bubble the revert reason is using memory via assembly
216 
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title ERC721 token receiver interface
237  * @dev Interface for any contract that wants to support safeTransfers
238  * from ERC721 asset contracts.
239  */
240 interface IERC721Receiver {
241     /**
242      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
243      * by operator from from, this function is called.
244      *
245      * It must return its Solidity selector to confirm the token transfer.
246      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
247      *
248      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
249      */
250     function onERC721Received(
251         address operator,
252         address from,
253         uint256 tokenId,
254         bytes calldata data
255     ) external returns (bytes4);
256 }
257 
258 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * interfaceId. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 
294 /**
295  * @dev Implementation of the {IERC165} interface.
296  *
297  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
298  * for the additional interface id that will be supported. For example:
299  *
300  * solidity
301  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
302  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
303  * }
304  * 
305  *
306  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
307  */
308 abstract contract ERC165 is IERC165 {
309     /**
310      * @dev See {IERC165-supportsInterface}.
311      */
312     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
313         return interfaceId == type(IERC165).interfaceId;
314     }
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Required interface of an ERC721 compliant contract.
327  */
328 interface IERC721 is IERC165 {
329     /**
330      * @dev Emitted when tokenId token is transferred from from to to.
331      */
332     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
333 
334     /**
335      * @dev Emitted when owner enables approved to manage the tokenId token.
336      */
337     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
338 
339     /**
340      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
341      */
342     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
343 
344     /**
345      * @dev Returns the number of tokens in owner's account.
346      */
347     function balanceOf(address owner) external view returns (uint256 balance);
348 
349     /**
350      * @dev Returns the owner of the tokenId token.
351      *
352      * Requirements:
353      *
354      * - tokenId must exist.
355      */
356     function ownerOf(uint256 tokenId) external view returns (address owner);
357 
358     /**
359      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
360      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
361      *
362      * Requirements:
363      *
364      * - from cannot be the zero address.
365      * - to cannot be the zero address.
366      * - tokenId token must exist and be owned by from.
367      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
368      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
369      *
370      * Emits a {Transfer} event.
371      */
372     function safeTransferFrom(
373         address from,
374         address to,
375         uint256 tokenId
376     ) external;
377 
378     /**
379      * @dev Transfers tokenId token from from to to.
380      *
381      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
382      *
383      * Requirements:
384      *
385      * - from cannot be the zero address.
386      * - to cannot be the zero address.
387      * - tokenId token must be owned by from.
388      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Gives permission to to to transfer tokenId token to another account.
400      * The approval is cleared when the token is transferred.
401      *
402      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
403      *
404      * Requirements:
405      *
406      * - The caller must own the token or be an approved operator.
407      * - tokenId must exist.
408      *
409      * Emits an {Approval} event.
410      */
411     function approve(address to, uint256 tokenId) external;
412 
413     /**
414      * @dev Returns the account approved for tokenId token.
415      *
416      * Requirements:
417      *
418      * - tokenId must exist.
419      */
420     function getApproved(uint256 tokenId) external view returns (address operator);
421 
422     /**
423      * @dev Approve or remove operator as an operator for the caller.
424      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
425      *
426      * Requirements:
427      *
428      * - The operator cannot be the caller.
429      *
430      * Emits an {ApprovalForAll} event.
431      */
432     function setApprovalForAll(address operator, bool _approved) external;
433 
434     /**
435      * @dev Returns if the operator is allowed to manage all of the assets of owner.
436      *
437      * See {setApprovalForAll}
438      */
439     function isApprovedForAll(address owner, address operator) external view returns (bool);
440 
441     /**
442      * @dev Safely transfers tokenId token from from to to.
443      *
444      * Requirements:
445      *
446      * - from cannot be the zero address.
447      * - to cannot be the zero address.
448      * - tokenId token must exist and be owned by from.
449      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
450      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
451      *
452      * Emits a {Transfer} event.
453      */
454     function safeTransferFrom(
455         address from,
456         address to,
457         uint256 tokenId,
458         bytes calldata data
459     ) external;
460 }
461 
462 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
463 
464 
465 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
472  * @dev See https://eips.ethereum.org/EIPS/eip-721
473  */
474 interface IERC721Enumerable is IERC721 {
475     /**
476      * @dev Returns the total amount of tokens stored by the contract.
477      */
478     function totalSupply() external view returns (uint256);
479 
480     /**
481      * @dev Returns a token ID owned by owner at a given index of its token list.
482      * Use along with {balanceOf} to enumerate all of owner's tokens.
483      */
484     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
485 
486     /**
487      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
488      * Use along with {totalSupply} to enumerate all tokens.
489      */
490     function tokenByIndex(uint256 index) external view returns (uint256);
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
503  * @dev See https://eips.ethereum.org/EIPS/eip-721
504  */
505 interface IERC721Metadata is IERC721 {
506     /**
507      * @dev Returns the token collection name.
508      */
509     function name() external view returns (string memory);
510 
511     /**
512      * @dev Returns the token collection symbol.
513      */
514     function symbol() external view returns (string memory);
515 
516     /**
517      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
518      */
519     function tokenURI(uint256 tokenId) external view returns (string memory);
520 }
521 
522 // File: @openzeppelin/contracts/utils/Strings.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev String operations.
531  */
532 library Strings {
533     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
534 
535     /**
536      * @dev Converts a uint256 to its ASCII string decimal representation.
537      */
538     function toString(uint256 value) internal pure returns (string memory) {
539         // Inspired by OraclizeAPI's implementation - MIT licence
540         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
541 
542         if (value == 0) {
543             return "0";
544         }
545         uint256 temp = value;
546         uint256 digits;
547         while (temp != 0) {
548             digits++;
549             temp /= 10;
550         }
551         bytes memory buffer = new bytes(digits);
552         while (value != 0) {
553             digits -= 1;
554             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
555             value /= 10;
556         }
557         return string(buffer);
558     }
559 
560     /**
561      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
562      */
563     function toHexString(uint256 value) internal pure returns (string memory) {
564         if (value == 0) {
565             return "0x00";
566         }
567         uint256 temp = value;
568         uint256 length = 0;
569         while (temp != 0) {
570             length++;
571             temp >>= 8;
572         }
573         return toHexString(value, length);
574     }
575 
576     /**
577      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
578      */
579     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
580         bytes memory buffer = new bytes(2 * length + 2);
581         buffer[0] = "0";
582         buffer[1] = "x";
583         for (uint256 i = 2 * length + 1; i > 1; --i) {
584             buffer[i] = _HEX_SYMBOLS[value & 0xf];
585             value >>= 4;
586         }
587         require(value == 0, "Strings: hex length insufficient");
588         return string(buffer);
589     }
590 }
591 
592 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @dev Contract module that helps prevent reentrant calls to a function.
601  *
602  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
603  * available, which can be applied to functions to make sure there are no nested
604  * (reentrant) calls to them.
605  *
606  * Note that because there is a single nonReentrant guard, functions marked as
607  * nonReentrant may not call one another. This can be worked around by making
608  * those functions private, and then adding external nonReentrant entry
609  * points to them.
610  *
611  * TIP: If you would like to learn more about reentrancy and alternative ways
612  * to protect against it, check out our blog post
613  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
614  */
615 abstract contract ReentrancyGuard {
616     // Booleans are more expensive than uint256 or any type that takes up a full
617     // word because each write operation emits an extra SLOAD to first read the
618     // slot's contents, replace the bits taken up by the boolean, and then write
619     // back. This is the compiler's defense against contract upgrades and
620     // pointer aliasing, and it cannot be disabled.
621 
622     // The values being non-zero value makes deployment a bit more expensive,
623     // but in exchange the refund on every call to nonReentrant will be lower in
624     // amount. Since refunds are capped to a percentage of the total
625     // transaction's gas, it is best to keep them low in cases like this one, to
626     // increase the likelihood of the full refund coming into effect.
627     uint256 private constant _NOT_ENTERED = 1;
628     uint256 private constant _ENTERED = 2;
629 
630     uint256 private _status;
631 
632     constructor() {
633         _status = _NOT_ENTERED;
634     }
635 
636     /**
637      * @dev Prevents a contract from calling itself, directly or indirectly.
638      * Calling a nonReentrant function from another nonReentrant
639      * function is not supported. It is possible to prevent this from happening
640      * by making the nonReentrant function external, and making it call a
641      * private function that does the actual work.
642      */
643     modifier nonReentrant() {
644         // On the first call to nonReentrant, _notEntered will be true
645         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
646 
647         // Any calls to nonReentrant after this point will fail
648         _status = _ENTERED;
649 
650         _;
651 
652         // By storing the original value once again, a refund is triggered (see
653         // https://eips.ethereum.org/EIPS/eip-2200)
654         _status = _NOT_ENTERED;
655     }
656 }
657 
658 // File: @openzeppelin/contracts/utils/Context.sol
659 
660 
661 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
662 
663 pragma solidity ^0.8.0;
664 
665 /**
666  * @dev Provides information about the current execution context, including the
667  * sender of the transaction and its data. While these are generally available
668  * via msg.sender and msg.data, they should not be accessed in such a direct
669  * manner, since when dealing with meta-transactions the account sending and
670  * paying for execution may not be the actual sender (as far as an application
671  * is concerned).
672  *
673  * This contract is only required for intermediate, library-like contracts.
674  */
675 abstract contract Context {
676     function _msgSender() internal view virtual returns (address) {
677         return msg.sender;
678     }
679 
680     function _msgData() internal view virtual returns (bytes calldata) {
681         return msg.data;
682     }
683 }
684 
685 // File: @openzeppelin/contracts/access/Ownable.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @dev Contract module which provides a basic access control mechanism, where
695  * there is an account (an owner) that can be granted exclusive access to
696  * specific functions.
697  *
698  * By default, the owner account will be the one that deploys the contract. This
699  * can later be changed with {transferOwnership}.
700  *
701  * This module is used through inheritance. It will make available the modifier
702  * onlyOwner, which can be applied to your functions to restrict their use to
703  * the owner.
704  */
705 abstract contract Ownable is Context {
706     address private _owner;
707 
708     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
709 
710     /**
711      * @dev Initializes the contract setting the deployer as the initial owner.
712      */
713     constructor() {
714         _transferOwnership(_msgSender());
715     }
716 
717     /**
718      * @dev Returns the address of the current owner.
719      */
720     function owner() public view virtual returns (address) {
721         return _owner;
722     }
723 
724     /**
725      * @dev Throws if called by any account other than the owner.
726      */
727     modifier onlyOwner() {
728         require(owner() == _msgSender(), "Ownable: caller is not the owner");
729         _;
730     }
731 
732     /**
733      * @dev Leaves the contract without owner. It will not be possible to call
734      * onlyOwner functions anymore. Can only be called by the current owner.
735      *
736      * NOTE: Renouncing ownership will leave the contract without an owner,
737      * thereby removing any functionality that is only available to the owner.
738      */
739     function renounceOwnership() public virtual onlyOwner {
740         _transferOwnership(address(0));
741     }
742 
743     /**
744      * @dev Transfers ownership of the contract to a new account (newOwner).
745      * Can only be called by the current owner.
746      */
747     function transferOwnership(address newOwner) public virtual onlyOwner {
748         require(newOwner != address(0), "Ownable: new owner is the zero address");
749         _transferOwnership(newOwner);
750     }
751 
752     /**
753      * @dev Transfers ownership of the contract to a new account (newOwner).
754      * Internal function without access restriction.
755      */
756     function _transferOwnership(address newOwner) internal virtual {
757         address oldOwner = _owner;
758         _owner = newOwner;
759         emit OwnershipTransferred(oldOwner, newOwner);
760     }
761 }
762 //-------------END DEPENDENCIES------------------------//
763 
764 
765   
766 // Rampp Contracts v2.1 (Teams.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 /**
771 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
772 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
773 * This will easily allow cross-collaboration via Mintplex.xyz.
774 **/
775 abstract contract Teams is Ownable{
776   mapping (address => bool) internal team;
777 
778   /**
779   * @dev Adds an address to the team. Allows them to execute protected functions
780   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
781   **/
782   function addToTeam(address _address) public onlyOwner {
783     require(_address != address(0), "Invalid address");
784     require(!inTeam(_address), "This address is already in your team.");
785   
786     team[_address] = true;
787   }
788 
789   /**
790   * @dev Removes an address to the team.
791   * @param _address the ETH address to remove, cannot be 0x and must be in team
792   **/
793   function removeFromTeam(address _address) public onlyOwner {
794     require(_address != address(0), "Invalid address");
795     require(inTeam(_address), "This address is not in your team currently.");
796   
797     team[_address] = false;
798   }
799 
800   /**
801   * @dev Check if an address is valid and active in the team
802   * @param _address ETH address to check for truthiness
803   **/
804   function inTeam(address _address)
805     public
806     view
807     returns (bool)
808   {
809     require(_address != address(0), "Invalid address to check.");
810     return team[_address] == true;
811   }
812 
813   /**
814   * @dev Throws if called by any account other than the owner or team member.
815   */
816   modifier onlyTeamOrOwner() {
817     bool _isOwner = owner() == _msgSender();
818     bool _isTeam = inTeam(_msgSender());
819     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
820     _;
821   }
822 }
823 
824 
825   
826   
827 /**
828  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
829  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
830  *
831  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
832  * 
833  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
834  *
835  * Does not support burning tokens to address(0).
836  */
837 contract ERC721A is
838   Context,
839   ERC165,
840   IERC721,
841   IERC721Metadata,
842   IERC721Enumerable,
843   Teams
844 {
845   using Address for address;
846   using Strings for uint256;
847 
848   struct TokenOwnership {
849     address addr;
850     uint64 startTimestamp;
851   }
852 
853   struct AddressData {
854     uint128 balance;
855     uint128 numberMinted;
856   }
857 
858   uint256 private currentIndex;
859 
860   uint256 public immutable collectionSize;
861   uint256 public maxBatchSize;
862 
863   // Token name
864   string private _name;
865 
866   // Token symbol
867   string private _symbol;
868 
869   // Mapping from token ID to ownership details
870   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
871   mapping(uint256 => TokenOwnership) private _ownerships;
872 
873   // Mapping owner address to address data
874   mapping(address => AddressData) private _addressData;
875 
876   // Mapping from token ID to approved address
877   mapping(uint256 => address) private _tokenApprovals;
878 
879   // Mapping from owner to operator approvals
880   mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882   /* @dev Mapping of restricted operator approvals set by contract Owner
883   * This serves as an optional addition to ERC-721 so
884   * that the contract owner can elect to prevent specific addresses/contracts
885   * from being marked as the approver for a token. The reason for this
886   * is that some projects may want to retain control of where their tokens can/can not be listed
887   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
888   * By default, there are no restrictions. The contract owner must deliberatly block an address 
889   */
890   mapping(address => bool) public restrictedApprovalAddresses;
891 
892   /**
893    * @dev
894    * maxBatchSize refers to how much a minter can mint at a time.
895    * collectionSize_ refers to how many tokens are in the collection.
896    */
897   constructor(
898     string memory name_,
899     string memory symbol_,
900     uint256 maxBatchSize_,
901     uint256 collectionSize_
902   ) {
903     require(
904       collectionSize_ > 0,
905       "ERC721A: collection must have a nonzero supply"
906     );
907     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
908     _name = name_;
909     _symbol = symbol_;
910     maxBatchSize = maxBatchSize_;
911     collectionSize = collectionSize_;
912     currentIndex = _startTokenId();
913   }
914 
915   /**
916   * To change the starting tokenId, please override this function.
917   */
918   function _startTokenId() internal view virtual returns (uint256) {
919     return 1;
920   }
921 
922   /**
923    * @dev See {IERC721Enumerable-totalSupply}.
924    */
925   function totalSupply() public view override returns (uint256) {
926     return _totalMinted();
927   }
928 
929   function currentTokenId() public view returns (uint256) {
930     return _totalMinted();
931   }
932 
933   function getNextTokenId() public view returns (uint256) {
934       return _totalMinted() + 1;
935   }
936 
937   /**
938   * Returns the total amount of tokens minted in the contract.
939   */
940   function _totalMinted() internal view returns (uint256) {
941     unchecked {
942       return currentIndex - _startTokenId();
943     }
944   }
945 
946   /**
947    * @dev See {IERC721Enumerable-tokenByIndex}.
948    */
949   function tokenByIndex(uint256 index) public view override returns (uint256) {
950     require(index < totalSupply(), "ERC721A: global index out of bounds");
951     return index;
952   }
953 
954   /**
955    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
956    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
957    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
958    */
959   function tokenOfOwnerByIndex(address owner, uint256 index)
960     public
961     view
962     override
963     returns (uint256)
964   {
965     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
966     uint256 numMintedSoFar = totalSupply();
967     uint256 tokenIdsIdx = 0;
968     address currOwnershipAddr = address(0);
969     for (uint256 i = 0; i < numMintedSoFar; i++) {
970       TokenOwnership memory ownership = _ownerships[i];
971       if (ownership.addr != address(0)) {
972         currOwnershipAddr = ownership.addr;
973       }
974       if (currOwnershipAddr == owner) {
975         if (tokenIdsIdx == index) {
976           return i;
977         }
978         tokenIdsIdx++;
979       }
980     }
981     revert("ERC721A: unable to get token of owner by index");
982   }
983 
984   /**
985    * @dev See {IERC165-supportsInterface}.
986    */
987   function supportsInterface(bytes4 interfaceId)
988     public
989     view
990     virtual
991     override(ERC165, IERC165)
992     returns (bool)
993   {
994     return
995       interfaceId == type(IERC721).interfaceId ||
996       interfaceId == type(IERC721Metadata).interfaceId ||
997       interfaceId == type(IERC721Enumerable).interfaceId ||
998       super.supportsInterface(interfaceId);
999   }
1000 
1001   /**
1002    * @dev See {IERC721-balanceOf}.
1003    */
1004   function balanceOf(address owner) public view override returns (uint256) {
1005     require(owner != address(0), "ERC721A: balance query for the zero address");
1006     return uint256(_addressData[owner].balance);
1007   }
1008 
1009   function _numberMinted(address owner) internal view returns (uint256) {
1010     require(
1011       owner != address(0),
1012       "ERC721A: number minted query for the zero address"
1013     );
1014     return uint256(_addressData[owner].numberMinted);
1015   }
1016 
1017   function ownershipOf(uint256 tokenId)
1018     internal
1019     view
1020     returns (TokenOwnership memory)
1021   {
1022     uint256 curr = tokenId;
1023 
1024     unchecked {
1025         if (_startTokenId() <= curr && curr < currentIndex) {
1026             TokenOwnership memory ownership = _ownerships[curr];
1027             if (ownership.addr != address(0)) {
1028                 return ownership;
1029             }
1030 
1031             // Invariant:
1032             // There will always be an ownership that has an address and is not burned
1033             // before an ownership that does not have an address and is not burned.
1034             // Hence, curr will not underflow.
1035             while (true) {
1036                 curr--;
1037                 ownership = _ownerships[curr];
1038                 if (ownership.addr != address(0)) {
1039                     return ownership;
1040                 }
1041             }
1042         }
1043     }
1044 
1045     revert("ERC721A: unable to determine the owner of token");
1046   }
1047 
1048   /**
1049    * @dev See {IERC721-ownerOf}.
1050    */
1051   function ownerOf(uint256 tokenId) public view override returns (address) {
1052     return ownershipOf(tokenId).addr;
1053   }
1054 
1055   /**
1056    * @dev See {IERC721Metadata-name}.
1057    */
1058   function name() public view virtual override returns (string memory) {
1059     return _name;
1060   }
1061 
1062   /**
1063    * @dev See {IERC721Metadata-symbol}.
1064    */
1065   function symbol() public view virtual override returns (string memory) {
1066     return _symbol;
1067   }
1068 
1069   /**
1070    * @dev See {IERC721Metadata-tokenURI}.
1071    */
1072   function tokenURI(uint256 tokenId)
1073     public
1074     view
1075     virtual
1076     override
1077     returns (string memory)
1078   {
1079     string memory baseURI = _baseURI();
1080     return
1081       bytes(baseURI).length > 0
1082         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1083         : "";
1084   }
1085 
1086   /**
1087    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1088    * token will be the concatenation of the baseURI and the tokenId. Empty
1089    * by default, can be overriden in child contracts.
1090    */
1091   function _baseURI() internal view virtual returns (string memory) {
1092     return "";
1093   }
1094 
1095   /**
1096    * @dev Sets the value for an address to be in the restricted approval address pool.
1097    * Setting an address to true will disable token owners from being able to mark the address
1098    * for approval for trading. This would be used in theory to prevent token owners from listing
1099    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1100    * @param _address the marketplace/user to modify restriction status of
1101    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1102    */
1103   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1104     restrictedApprovalAddresses[_address] = _isRestricted;
1105   }
1106 
1107   /**
1108    * @dev See {IERC721-approve}.
1109    */
1110   function approve(address to, uint256 tokenId) public override {
1111     address owner = ERC721A.ownerOf(tokenId);
1112     require(to != owner, "ERC721A: approval to current owner");
1113     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1114 
1115     require(
1116       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1117       "ERC721A: approve caller is not owner nor approved for all"
1118     );
1119 
1120     _approve(to, tokenId, owner);
1121   }
1122 
1123   /**
1124    * @dev See {IERC721-getApproved}.
1125    */
1126   function getApproved(uint256 tokenId) public view override returns (address) {
1127     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1128 
1129     return _tokenApprovals[tokenId];
1130   }
1131 
1132   /**
1133    * @dev See {IERC721-setApprovalForAll}.
1134    */
1135   function setApprovalForAll(address operator, bool approved) public override {
1136     require(operator != _msgSender(), "ERC721A: approve to caller");
1137     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1138 
1139     _operatorApprovals[_msgSender()][operator] = approved;
1140     emit ApprovalForAll(_msgSender(), operator, approved);
1141   }
1142 
1143   /**
1144    * @dev See {IERC721-isApprovedForAll}.
1145    */
1146   function isApprovedForAll(address owner, address operator)
1147     public
1148     view
1149     virtual
1150     override
1151     returns (bool)
1152   {
1153     return _operatorApprovals[owner][operator];
1154   }
1155 
1156   /**
1157    * @dev See {IERC721-transferFrom}.
1158    */
1159   function transferFrom(
1160     address from,
1161     address to,
1162     uint256 tokenId
1163   ) public override {
1164     _transfer(from, to, tokenId);
1165   }
1166 
1167   /**
1168    * @dev See {IERC721-safeTransferFrom}.
1169    */
1170   function safeTransferFrom(
1171     address from,
1172     address to,
1173     uint256 tokenId
1174   ) public override {
1175     safeTransferFrom(from, to, tokenId, "");
1176   }
1177 
1178   /**
1179    * @dev See {IERC721-safeTransferFrom}.
1180    */
1181   function safeTransferFrom(
1182     address from,
1183     address to,
1184     uint256 tokenId,
1185     bytes memory _data
1186   ) public override {
1187     _transfer(from, to, tokenId);
1188     require(
1189       _checkOnERC721Received(from, to, tokenId, _data),
1190       "ERC721A: transfer to non ERC721Receiver implementer"
1191     );
1192   }
1193 
1194   /**
1195    * @dev Returns whether tokenId exists.
1196    *
1197    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1198    *
1199    * Tokens start existing when they are minted (_mint),
1200    */
1201   function _exists(uint256 tokenId) internal view returns (bool) {
1202     return _startTokenId() <= tokenId && tokenId < currentIndex;
1203   }
1204 
1205   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1206     _safeMint(to, quantity, isAdminMint, "");
1207   }
1208 
1209   /**
1210    * @dev Mints quantity tokens and transfers them to to.
1211    *
1212    * Requirements:
1213    *
1214    * - there must be quantity tokens remaining unminted in the total collection.
1215    * - to cannot be the zero address.
1216    * - quantity cannot be larger than the max batch size.
1217    *
1218    * Emits a {Transfer} event.
1219    */
1220   function _safeMint(
1221     address to,
1222     uint256 quantity,
1223     bool isAdminMint,
1224     bytes memory _data
1225   ) internal {
1226     uint256 startTokenId = currentIndex;
1227     require(to != address(0), "ERC721A: mint to the zero address");
1228     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1229     require(!_exists(startTokenId), "ERC721A: token already minted");
1230 
1231     // For admin mints we do not want to enforce the maxBatchSize limit
1232     if (isAdminMint == false) {
1233         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1234     }
1235 
1236     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1237 
1238     AddressData memory addressData = _addressData[to];
1239     _addressData[to] = AddressData(
1240       addressData.balance + uint128(quantity),
1241       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1242     );
1243     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1244 
1245     uint256 updatedIndex = startTokenId;
1246 
1247     for (uint256 i = 0; i < quantity; i++) {
1248       emit Transfer(address(0), to, updatedIndex);
1249       require(
1250         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1251         "ERC721A: transfer to non ERC721Receiver implementer"
1252       );
1253       updatedIndex++;
1254     }
1255 
1256     currentIndex = updatedIndex;
1257     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1258   }
1259 
1260   /**
1261    * @dev Transfers tokenId from from to to.
1262    *
1263    * Requirements:
1264    *
1265    * - to cannot be the zero address.
1266    * - tokenId token must be owned by from.
1267    *
1268    * Emits a {Transfer} event.
1269    */
1270   function _transfer(
1271     address from,
1272     address to,
1273     uint256 tokenId
1274   ) private {
1275     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1276 
1277     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1278       getApproved(tokenId) == _msgSender() ||
1279       isApprovedForAll(prevOwnership.addr, _msgSender()));
1280 
1281     require(
1282       isApprovedOrOwner,
1283       "ERC721A: transfer caller is not owner nor approved"
1284     );
1285 
1286     require(
1287       prevOwnership.addr == from,
1288       "ERC721A: transfer from incorrect owner"
1289     );
1290     require(to != address(0), "ERC721A: transfer to the zero address");
1291 
1292     _beforeTokenTransfers(from, to, tokenId, 1);
1293 
1294     // Clear approvals from the previous owner
1295     _approve(address(0), tokenId, prevOwnership.addr);
1296 
1297     _addressData[from].balance -= 1;
1298     _addressData[to].balance += 1;
1299     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1300 
1301     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1302     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1303     uint256 nextTokenId = tokenId + 1;
1304     if (_ownerships[nextTokenId].addr == address(0)) {
1305       if (_exists(nextTokenId)) {
1306         _ownerships[nextTokenId] = TokenOwnership(
1307           prevOwnership.addr,
1308           prevOwnership.startTimestamp
1309         );
1310       }
1311     }
1312 
1313     emit Transfer(from, to, tokenId);
1314     _afterTokenTransfers(from, to, tokenId, 1);
1315   }
1316 
1317   /**
1318    * @dev Approve to to operate on tokenId
1319    *
1320    * Emits a {Approval} event.
1321    */
1322   function _approve(
1323     address to,
1324     uint256 tokenId,
1325     address owner
1326   ) private {
1327     _tokenApprovals[tokenId] = to;
1328     emit Approval(owner, to, tokenId);
1329   }
1330 
1331   uint256 public nextOwnerToExplicitlySet = 0;
1332 
1333   /**
1334    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1335    */
1336   function _setOwnersExplicit(uint256 quantity) internal {
1337     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1338     require(quantity > 0, "quantity must be nonzero");
1339     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1340 
1341     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1342     if (endIndex > collectionSize - 1) {
1343       endIndex = collectionSize - 1;
1344     }
1345     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1346     require(_exists(endIndex), "not enough minted yet for this cleanup");
1347     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1348       if (_ownerships[i].addr == address(0)) {
1349         TokenOwnership memory ownership = ownershipOf(i);
1350         _ownerships[i] = TokenOwnership(
1351           ownership.addr,
1352           ownership.startTimestamp
1353         );
1354       }
1355     }
1356     nextOwnerToExplicitlySet = endIndex + 1;
1357   }
1358 
1359   /**
1360    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1361    * The call is not executed if the target address is not a contract.
1362    *
1363    * @param from address representing the previous owner of the given token ID
1364    * @param to target address that will receive the tokens
1365    * @param tokenId uint256 ID of the token to be transferred
1366    * @param _data bytes optional data to send along with the call
1367    * @return bool whether the call correctly returned the expected magic value
1368    */
1369   function _checkOnERC721Received(
1370     address from,
1371     address to,
1372     uint256 tokenId,
1373     bytes memory _data
1374   ) private returns (bool) {
1375     if (to.isContract()) {
1376       try
1377         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1378       returns (bytes4 retval) {
1379         return retval == IERC721Receiver(to).onERC721Received.selector;
1380       } catch (bytes memory reason) {
1381         if (reason.length == 0) {
1382           revert("ERC721A: transfer to non ERC721Receiver implementer");
1383         } else {
1384           assembly {
1385             revert(add(32, reason), mload(reason))
1386           }
1387         }
1388       }
1389     } else {
1390       return true;
1391     }
1392   }
1393 
1394   /**
1395    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1396    *
1397    * startTokenId - the first token id to be transferred
1398    * quantity - the amount to be transferred
1399    *
1400    * Calling conditions:
1401    *
1402    * - When from and to are both non-zero, from's tokenId will be
1403    * transferred to to.
1404    * - When from is zero, tokenId will be minted for to.
1405    */
1406   function _beforeTokenTransfers(
1407     address from,
1408     address to,
1409     uint256 startTokenId,
1410     uint256 quantity
1411   ) internal virtual {}
1412 
1413   /**
1414    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1415    * minting.
1416    *
1417    * startTokenId - the first token id to be transferred
1418    * quantity - the amount to be transferred
1419    *
1420    * Calling conditions:
1421    *
1422    * - when from and to are both non-zero.
1423    * - from and to are never both zero.
1424    */
1425   function _afterTokenTransfers(
1426     address from,
1427     address to,
1428     uint256 startTokenId,
1429     uint256 quantity
1430   ) internal virtual {}
1431 }
1432 
1433 
1434 
1435   
1436 abstract contract Ramppable {
1437   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1438 
1439   modifier isRampp() {
1440       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1441       _;
1442   }
1443 }
1444 
1445 
1446   
1447   
1448 interface IERC20 {
1449   function allowance(address owner, address spender) external view returns (uint256);
1450   function transfer(address _to, uint256 _amount) external returns (bool);
1451   function balanceOf(address account) external view returns (uint256);
1452   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1453 }
1454 
1455 // File: WithdrawableV2
1456 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1457 // ERC-20 Payouts are limited to a single payout address. This feature 
1458 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1459 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1460 abstract contract WithdrawableV2 is Teams, Ramppable {
1461   struct acceptedERC20 {
1462     bool isActive;
1463     uint256 chargeAmount;
1464   }
1465 
1466   
1467   mapping(address => acceptedERC20) private allowedTokenContracts;
1468   address[] public payableAddresses = [RAMPPADDRESS,0xb66F69Ba02BB8047791B566988c5FcBAF354FBf7];
1469   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1470   address public erc20Payable = 0xb66F69Ba02BB8047791B566988c5FcBAF354FBf7;
1471   uint256[] public payableFees = [5,95];
1472   uint256[] public surchargePayableFees = [100];
1473   uint256 public payableAddressCount = 2;
1474   uint256 public surchargePayableAddressCount = 1;
1475   uint256 public ramppSurchargeBalance = 0 ether;
1476   uint256 public ramppSurchargeFee = 0.001 ether;
1477   bool public onlyERC20MintingMode = false;
1478   
1479 
1480   /**
1481   * @dev Calculates the true payable balance of the contract as the
1482   * value on contract may be from ERC-20 mint surcharges and not 
1483   * public mint charges - which are not eligable for rev share & user withdrawl
1484   */
1485   function calcAvailableBalance() public view returns(uint256) {
1486     return address(this).balance - ramppSurchargeBalance;
1487   }
1488 
1489   function withdrawAll() public onlyTeamOrOwner {
1490       require(calcAvailableBalance() > 0);
1491       _withdrawAll();
1492   }
1493   
1494   function withdrawAllRampp() public isRampp {
1495       require(calcAvailableBalance() > 0);
1496       _withdrawAll();
1497   }
1498 
1499   function _withdrawAll() private {
1500       uint256 balance = calcAvailableBalance();
1501       
1502       for(uint i=0; i < payableAddressCount; i++ ) {
1503           _widthdraw(
1504               payableAddresses[i],
1505               (balance * payableFees[i]) / 100
1506           );
1507       }
1508   }
1509   
1510   function _widthdraw(address _address, uint256 _amount) private {
1511       (bool success, ) = _address.call{value: _amount}("");
1512       require(success, "Transfer failed.");
1513   }
1514 
1515   /**
1516   * @dev This function is similiar to the regular withdraw but operates only on the
1517   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1518   **/
1519   function _withdrawAllSurcharges() private {
1520     uint256 balance = ramppSurchargeBalance;
1521     if(balance == 0) { return; }
1522     
1523     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1524         _widthdraw(
1525             surchargePayableAddresses[i],
1526             (balance * surchargePayableFees[i]) / 100
1527         );
1528     }
1529     ramppSurchargeBalance = 0 ether;
1530   }
1531 
1532   /**
1533   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1534   * in the event ERC-20 tokens are paid to the contract for mints. This will
1535   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1536   * @param _tokenContract contract of ERC-20 token to withdraw
1537   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1538   */
1539   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1540     require(_amountToWithdraw > 0);
1541     IERC20 tokenContract = IERC20(_tokenContract);
1542     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1543     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1544     _withdrawAllSurcharges();
1545   }
1546 
1547   /**
1548   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1549   */
1550   function withdrawRamppSurcharges() public isRampp {
1551     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1552     _withdrawAllSurcharges();
1553   }
1554 
1555    /**
1556   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1557   */
1558   function addSurcharge() internal {
1559     ramppSurchargeBalance += ramppSurchargeFee;
1560   }
1561   
1562   /**
1563   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1564   */
1565   function hasSurcharge() internal returns(bool) {
1566     return msg.value == ramppSurchargeFee;
1567   }
1568 
1569   /**
1570   * @dev Set surcharge fee for using ERC-20 payments on contract
1571   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1572   */
1573   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1574     ramppSurchargeFee = _newSurcharge;
1575   }
1576 
1577   /**
1578   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1579   * @param _erc20TokenContract address of ERC-20 contract in question
1580   */
1581   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1582     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1583   }
1584 
1585   /**
1586   * @dev get the value of tokens to transfer for user of an ERC-20
1587   * @param _erc20TokenContract address of ERC-20 contract in question
1588   */
1589   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1590     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1591     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1592   }
1593 
1594   /**
1595   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1596   * @param _erc20TokenContract address of ERC-20 contract in question
1597   * @param _isActive default status of if contract should be allowed to accept payments
1598   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1599   */
1600   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1601     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1602     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1603   }
1604 
1605   /**
1606   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1607   * it will assume the default value of zero. This should not be used to create new payment tokens.
1608   * @param _erc20TokenContract address of ERC-20 contract in question
1609   */
1610   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1611     allowedTokenContracts[_erc20TokenContract].isActive = true;
1612   }
1613 
1614   /**
1615   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1616   * it will assume the default value of zero. This should not be used to create new payment tokens.
1617   * @param _erc20TokenContract address of ERC-20 contract in question
1618   */
1619   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1620     allowedTokenContracts[_erc20TokenContract].isActive = false;
1621   }
1622 
1623   /**
1624   * @dev Enable only ERC-20 payments for minting on this contract
1625   */
1626   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1627     onlyERC20MintingMode = true;
1628   }
1629 
1630   /**
1631   * @dev Disable only ERC-20 payments for minting on this contract
1632   */
1633   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1634     onlyERC20MintingMode = false;
1635   }
1636 
1637   /**
1638   * @dev Set the payout of the ERC-20 token payout to a specific address
1639   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1640   */
1641   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1642     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1643     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1644     erc20Payable = _newErc20Payable;
1645   }
1646 
1647   /**
1648   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1649   */
1650   function resetRamppSurchargeBalance() public isRampp {
1651     ramppSurchargeBalance = 0 ether;
1652   }
1653 
1654   /**
1655   * @dev Allows Rampp wallet to update its own reference as well as update
1656   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1657   * and since Rampp is always the first address this function is limited to the rampp payout only.
1658   * @param _newAddress updated Rampp Address
1659   */
1660   function setRamppAddress(address _newAddress) public isRampp {
1661     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1662     RAMPPADDRESS = _newAddress;
1663     payableAddresses[0] = _newAddress;
1664   }
1665 }
1666 
1667 
1668   
1669 // File: isFeeable.sol
1670 abstract contract Feeable is Teams {
1671   uint256 public PRICE = 0 ether;
1672 
1673   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1674     PRICE = _feeInWei;
1675   }
1676 
1677   function getPrice(uint256 _count) public view returns (uint256) {
1678     return PRICE * _count;
1679   }
1680 }
1681 
1682   
1683   
1684   
1685 abstract contract RamppERC721A is 
1686     Ownable,
1687     Teams,
1688     ERC721A,
1689     WithdrawableV2,
1690     ReentrancyGuard 
1691     , Feeable 
1692      
1693     
1694 {
1695   constructor(
1696     string memory tokenName,
1697     string memory tokenSymbol
1698   ) ERC721A(tokenName, tokenSymbol, 2, 888) { }
1699     uint8 public CONTRACT_VERSION = 2;
1700     string public _baseTokenURI = "ipfs://bafybeif24d35uuqtfuup3qhtzjy5gcdvci5a44w6xgshzhfnsshhfrecby/";
1701 
1702     bool public mintingOpen = false;
1703     
1704     
1705     uint256 public MAX_WALLET_MINTS = 2;
1706 
1707   
1708     /////////////// Admin Mint Functions
1709     /**
1710      * @dev Mints a token to an address with a tokenURI.
1711      * This is owner only and allows a fee-free drop
1712      * @param _to address of the future owner of the token
1713      * @param _qty amount of tokens to drop the owner
1714      */
1715      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1716          require(_qty > 0, "Must mint at least 1 token.");
1717          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 888");
1718          _safeMint(_to, _qty, true);
1719      }
1720 
1721   
1722     /////////////// GENERIC MINT FUNCTIONS
1723     /**
1724     * @dev Mints a single token to an address.
1725     * fee may or may not be required*
1726     * @param _to address of the future owner of the token
1727     */
1728     function mintTo(address _to) public payable {
1729         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1730         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 888");
1731         require(mintingOpen == true, "Minting is not open right now!");
1732         
1733         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1734         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1735         
1736         _safeMint(_to, 1, false);
1737     }
1738 
1739     /**
1740     * @dev Mints tokens to an address in batch.
1741     * fee may or may not be required*
1742     * @param _to address of the future owner of the token
1743     * @param _amount number of tokens to mint
1744     */
1745     function mintToMultiple(address _to, uint256 _amount) public payable {
1746         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1747         require(_amount >= 1, "Must mint at least 1 token");
1748         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1749         require(mintingOpen == true, "Minting is not open right now!");
1750         
1751         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1752         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 888");
1753         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1754 
1755         _safeMint(_to, _amount, false);
1756     }
1757 
1758     /**
1759      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1760      * fee may or may not be required*
1761      * @param _to address of the future owner of the token
1762      * @param _amount number of tokens to mint
1763      * @param _erc20TokenContract erc-20 token contract to mint with
1764      */
1765     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1766       require(_amount >= 1, "Must mint at least 1 token");
1767       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1768       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 888");
1769       require(mintingOpen == true, "Minting is not open right now!");
1770       
1771       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1772 
1773       // ERC-20 Specific pre-flight checks
1774       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1775       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1776       IERC20 payableToken = IERC20(_erc20TokenContract);
1777 
1778       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1779       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1780       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1781       
1782       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1783       require(transferComplete, "ERC-20 token was unable to be transferred");
1784       
1785       _safeMint(_to, _amount, false);
1786       addSurcharge();
1787     }
1788 
1789     function openMinting() public onlyTeamOrOwner {
1790         mintingOpen = true;
1791     }
1792 
1793     function stopMinting() public onlyTeamOrOwner {
1794         mintingOpen = false;
1795     }
1796 
1797   
1798 
1799   
1800     /**
1801     * @dev Check if wallet over MAX_WALLET_MINTS
1802     * @param _address address in question to check if minted count exceeds max
1803     */
1804     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1805         require(_amount >= 1, "Amount must be greater than or equal to 1");
1806         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1807     }
1808 
1809     /**
1810     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1811     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1812     */
1813     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1814         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1815         MAX_WALLET_MINTS = _newWalletMax;
1816     }
1817     
1818 
1819   
1820     /**
1821      * @dev Allows owner to set Max mints per tx
1822      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1823      */
1824      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1825          require(_newMaxMint >= 1, "Max mint must be at least 1");
1826          maxBatchSize = _newMaxMint;
1827      }
1828     
1829 
1830   
1831 
1832   function _baseURI() internal view virtual override returns(string memory) {
1833     return _baseTokenURI;
1834   }
1835 
1836   function baseTokenURI() public view returns(string memory) {
1837     return _baseTokenURI;
1838   }
1839 
1840   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1841     _baseTokenURI = baseURI;
1842   }
1843 
1844   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1845     return ownershipOf(tokenId);
1846   }
1847 }
1848 
1849 
1850   
1851 // File: contracts/AncientEntitiesContract.sol
1852 //SPDX-License-Identifier: MIT
1853 
1854 pragma solidity ^0.8.0;
1855 
1856 contract AncientEntitiesContract is RamppERC721A {
1857     constructor() RamppERC721A("Ancient Entities", "AENT"){}
1858 }
1859   
1860 //*********************************************************************//
1861 //*********************************************************************//  
1862 //                       Mintplex v2.1.0
1863 //
1864 //         This smart contract was generated by mintplex.xyz.
1865 //            Mintplex allows creators like you to launch 
1866 //             large scale NFT communities without code!
1867 //
1868 //    Mintplex is not responsible for the content of this contract and
1869 //        hopes it is being used in a responsible and kind way.  
1870 //       Mintplex is not associated or affiliated with this project.                                                    
1871 //             Twitter: @MintplexNFT ---- mintplex.xyz
1872 //*********************************************************************//                                                     
1873 //*********************************************************************//