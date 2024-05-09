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
773 * This will easily allow cross-collaboration via Rampp.xyz.
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
826   pragma solidity ^0.8.0;
827 
828   /**
829   * @dev These functions deal with verification of Merkle Trees proofs.
830   *
831   * The proofs can be generated using the JavaScript library
832   * https://github.com/miguelmota/merkletreejs[merkletreejs].
833   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
834   *
835   *
836   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
837   * hashing, or use a hash function other than keccak256 for hashing leaves.
838   * This is because the concatenation of a sorted pair of internal nodes in
839   * the merkle tree could be reinterpreted as a leaf value.
840   */
841   library MerkleProof {
842       /**
843       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
844       * defined by 'root'. For this, a 'proof' must be provided, containing
845       * sibling hashes on the branch from the leaf to the root of the tree. Each
846       * pair of leaves and each pair of pre-images are assumed to be sorted.
847       */
848       function verify(
849           bytes32[] memory proof,
850           bytes32 root,
851           bytes32 leaf
852       ) internal pure returns (bool) {
853           return processProof(proof, leaf) == root;
854       }
855 
856       /**
857       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
858       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
859       * hash matches the root of the tree. When processing the proof, the pairs
860       * of leafs & pre-images are assumed to be sorted.
861       *
862       * _Available since v4.4._
863       */
864       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
865           bytes32 computedHash = leaf;
866           for (uint256 i = 0; i < proof.length; i++) {
867               bytes32 proofElement = proof[i];
868               if (computedHash <= proofElement) {
869                   // Hash(current computed hash + current element of the proof)
870                   computedHash = _efficientHash(computedHash, proofElement);
871               } else {
872                   // Hash(current element of the proof + current computed hash)
873                   computedHash = _efficientHash(proofElement, computedHash);
874               }
875           }
876           return computedHash;
877       }
878 
879       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
880           assembly {
881               mstore(0x00, a)
882               mstore(0x20, b)
883               value := keccak256(0x00, 0x40)
884           }
885       }
886   }
887 
888 
889   // File: Allowlist.sol
890 
891   pragma solidity ^0.8.0;
892 
893   abstract contract Allowlist is Teams {
894     bytes32 public merkleRoot;
895     bool public onlyAllowlistMode = false;
896 
897     /**
898      * @dev Update merkle root to reflect changes in Allowlist
899      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
900      */
901     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
902       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
903       merkleRoot = _newMerkleRoot;
904     }
905 
906     /**
907      * @dev Check the proof of an address if valid for merkle root
908      * @param _to address to check for proof
909      * @param _merkleProof Proof of the address to validate against root and leaf
910      */
911     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
912       require(merkleRoot != 0, "Merkle root is not set!");
913       bytes32 leaf = keccak256(abi.encodePacked(_to));
914 
915       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
916     }
917 
918     
919     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
920       onlyAllowlistMode = true;
921     }
922 
923     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
924         onlyAllowlistMode = false;
925     }
926   }
927   
928   
929 /**
930  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
931  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
932  *
933  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
934  * 
935  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
936  *
937  * Does not support burning tokens to address(0).
938  */
939 contract ERC721A is
940   Context,
941   ERC165,
942   IERC721,
943   IERC721Metadata,
944   IERC721Enumerable
945 {
946   using Address for address;
947   using Strings for uint256;
948 
949   struct TokenOwnership {
950     address addr;
951     uint64 startTimestamp;
952   }
953 
954   struct AddressData {
955     uint128 balance;
956     uint128 numberMinted;
957   }
958 
959   uint256 private currentIndex;
960 
961   uint256 public immutable collectionSize;
962   uint256 public maxBatchSize;
963 
964   // Token name
965   string private _name;
966 
967   // Token symbol
968   string private _symbol;
969 
970   // Mapping from token ID to ownership details
971   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
972   mapping(uint256 => TokenOwnership) private _ownerships;
973 
974   // Mapping owner address to address data
975   mapping(address => AddressData) private _addressData;
976 
977   // Mapping from token ID to approved address
978   mapping(uint256 => address) private _tokenApprovals;
979 
980   // Mapping from owner to operator approvals
981   mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983   /**
984    * @dev
985    * maxBatchSize refers to how much a minter can mint at a time.
986    * collectionSize_ refers to how many tokens are in the collection.
987    */
988   constructor(
989     string memory name_,
990     string memory symbol_,
991     uint256 maxBatchSize_,
992     uint256 collectionSize_
993   ) {
994     require(
995       collectionSize_ > 0,
996       "ERC721A: collection must have a nonzero supply"
997     );
998     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
999     _name = name_;
1000     _symbol = symbol_;
1001     maxBatchSize = maxBatchSize_;
1002     collectionSize = collectionSize_;
1003     currentIndex = _startTokenId();
1004   }
1005 
1006   /**
1007   * To change the starting tokenId, please override this function.
1008   */
1009   function _startTokenId() internal view virtual returns (uint256) {
1010     return 1;
1011   }
1012 
1013   /**
1014    * @dev See {IERC721Enumerable-totalSupply}.
1015    */
1016   function totalSupply() public view override returns (uint256) {
1017     return _totalMinted();
1018   }
1019 
1020   function currentTokenId() public view returns (uint256) {
1021     return _totalMinted();
1022   }
1023 
1024   function getNextTokenId() public view returns (uint256) {
1025       return _totalMinted() + 1;
1026   }
1027 
1028   /**
1029   * Returns the total amount of tokens minted in the contract.
1030   */
1031   function _totalMinted() internal view returns (uint256) {
1032     unchecked {
1033       return currentIndex - _startTokenId();
1034     }
1035   }
1036 
1037   /**
1038    * @dev See {IERC721Enumerable-tokenByIndex}.
1039    */
1040   function tokenByIndex(uint256 index) public view override returns (uint256) {
1041     require(index < totalSupply(), "ERC721A: global index out of bounds");
1042     return index;
1043   }
1044 
1045   /**
1046    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1047    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1048    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1049    */
1050   function tokenOfOwnerByIndex(address owner, uint256 index)
1051     public
1052     view
1053     override
1054     returns (uint256)
1055   {
1056     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1057     uint256 numMintedSoFar = totalSupply();
1058     uint256 tokenIdsIdx = 0;
1059     address currOwnershipAddr = address(0);
1060     for (uint256 i = 0; i < numMintedSoFar; i++) {
1061       TokenOwnership memory ownership = _ownerships[i];
1062       if (ownership.addr != address(0)) {
1063         currOwnershipAddr = ownership.addr;
1064       }
1065       if (currOwnershipAddr == owner) {
1066         if (tokenIdsIdx == index) {
1067           return i;
1068         }
1069         tokenIdsIdx++;
1070       }
1071     }
1072     revert("ERC721A: unable to get token of owner by index");
1073   }
1074 
1075   /**
1076    * @dev See {IERC165-supportsInterface}.
1077    */
1078   function supportsInterface(bytes4 interfaceId)
1079     public
1080     view
1081     virtual
1082     override(ERC165, IERC165)
1083     returns (bool)
1084   {
1085     return
1086       interfaceId == type(IERC721).interfaceId ||
1087       interfaceId == type(IERC721Metadata).interfaceId ||
1088       interfaceId == type(IERC721Enumerable).interfaceId ||
1089       super.supportsInterface(interfaceId);
1090   }
1091 
1092   /**
1093    * @dev See {IERC721-balanceOf}.
1094    */
1095   function balanceOf(address owner) public view override returns (uint256) {
1096     require(owner != address(0), "ERC721A: balance query for the zero address");
1097     return uint256(_addressData[owner].balance);
1098   }
1099 
1100   function _numberMinted(address owner) internal view returns (uint256) {
1101     require(
1102       owner != address(0),
1103       "ERC721A: number minted query for the zero address"
1104     );
1105     return uint256(_addressData[owner].numberMinted);
1106   }
1107 
1108   function ownershipOf(uint256 tokenId)
1109     internal
1110     view
1111     returns (TokenOwnership memory)
1112   {
1113     uint256 curr = tokenId;
1114 
1115     unchecked {
1116         if (_startTokenId() <= curr && curr < currentIndex) {
1117             TokenOwnership memory ownership = _ownerships[curr];
1118             if (ownership.addr != address(0)) {
1119                 return ownership;
1120             }
1121 
1122             // Invariant:
1123             // There will always be an ownership that has an address and is not burned
1124             // before an ownership that does not have an address and is not burned.
1125             // Hence, curr will not underflow.
1126             while (true) {
1127                 curr--;
1128                 ownership = _ownerships[curr];
1129                 if (ownership.addr != address(0)) {
1130                     return ownership;
1131                 }
1132             }
1133         }
1134     }
1135 
1136     revert("ERC721A: unable to determine the owner of token");
1137   }
1138 
1139   /**
1140    * @dev See {IERC721-ownerOf}.
1141    */
1142   function ownerOf(uint256 tokenId) public view override returns (address) {
1143     return ownershipOf(tokenId).addr;
1144   }
1145 
1146   /**
1147    * @dev See {IERC721Metadata-name}.
1148    */
1149   function name() public view virtual override returns (string memory) {
1150     return _name;
1151   }
1152 
1153   /**
1154    * @dev See {IERC721Metadata-symbol}.
1155    */
1156   function symbol() public view virtual override returns (string memory) {
1157     return _symbol;
1158   }
1159 
1160   /**
1161    * @dev See {IERC721Metadata-tokenURI}.
1162    */
1163   function tokenURI(uint256 tokenId)
1164     public
1165     view
1166     virtual
1167     override
1168     returns (string memory)
1169   {
1170     string memory baseURI = _baseURI();
1171     return
1172       bytes(baseURI).length > 0
1173         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1174         : "";
1175   }
1176 
1177   /**
1178    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1179    * token will be the concatenation of the baseURI and the tokenId. Empty
1180    * by default, can be overriden in child contracts.
1181    */
1182   function _baseURI() internal view virtual returns (string memory) {
1183     return "";
1184   }
1185 
1186   /**
1187    * @dev See {IERC721-approve}.
1188    */
1189   function approve(address to, uint256 tokenId) public override {
1190     address owner = ERC721A.ownerOf(tokenId);
1191     require(to != owner, "ERC721A: approval to current owner");
1192 
1193     require(
1194       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1195       "ERC721A: approve caller is not owner nor approved for all"
1196     );
1197 
1198     _approve(to, tokenId, owner);
1199   }
1200 
1201   /**
1202    * @dev See {IERC721-getApproved}.
1203    */
1204   function getApproved(uint256 tokenId) public view override returns (address) {
1205     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1206 
1207     return _tokenApprovals[tokenId];
1208   }
1209 
1210   /**
1211    * @dev See {IERC721-setApprovalForAll}.
1212    */
1213   function setApprovalForAll(address operator, bool approved) public override {
1214     require(operator != _msgSender(), "ERC721A: approve to caller");
1215 
1216     _operatorApprovals[_msgSender()][operator] = approved;
1217     emit ApprovalForAll(_msgSender(), operator, approved);
1218   }
1219 
1220   /**
1221    * @dev See {IERC721-isApprovedForAll}.
1222    */
1223   function isApprovedForAll(address owner, address operator)
1224     public
1225     view
1226     virtual
1227     override
1228     returns (bool)
1229   {
1230     return _operatorApprovals[owner][operator];
1231   }
1232 
1233   /**
1234    * @dev See {IERC721-transferFrom}.
1235    */
1236   function transferFrom(
1237     address from,
1238     address to,
1239     uint256 tokenId
1240   ) public override {
1241     _transfer(from, to, tokenId);
1242   }
1243 
1244   /**
1245    * @dev See {IERC721-safeTransferFrom}.
1246    */
1247   function safeTransferFrom(
1248     address from,
1249     address to,
1250     uint256 tokenId
1251   ) public override {
1252     safeTransferFrom(from, to, tokenId, "");
1253   }
1254 
1255   /**
1256    * @dev See {IERC721-safeTransferFrom}.
1257    */
1258   function safeTransferFrom(
1259     address from,
1260     address to,
1261     uint256 tokenId,
1262     bytes memory _data
1263   ) public override {
1264     _transfer(from, to, tokenId);
1265     require(
1266       _checkOnERC721Received(from, to, tokenId, _data),
1267       "ERC721A: transfer to non ERC721Receiver implementer"
1268     );
1269   }
1270 
1271   /**
1272    * @dev Returns whether tokenId exists.
1273    *
1274    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1275    *
1276    * Tokens start existing when they are minted (_mint),
1277    */
1278   function _exists(uint256 tokenId) internal view returns (bool) {
1279     return _startTokenId() <= tokenId && tokenId < currentIndex;
1280   }
1281 
1282   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1283     _safeMint(to, quantity, isAdminMint, "");
1284   }
1285 
1286   /**
1287    * @dev Mints quantity tokens and transfers them to to.
1288    *
1289    * Requirements:
1290    *
1291    * - there must be quantity tokens remaining unminted in the total collection.
1292    * - to cannot be the zero address.
1293    * - quantity cannot be larger than the max batch size.
1294    *
1295    * Emits a {Transfer} event.
1296    */
1297   function _safeMint(
1298     address to,
1299     uint256 quantity,
1300     bool isAdminMint,
1301     bytes memory _data
1302   ) internal {
1303     uint256 startTokenId = currentIndex;
1304     require(to != address(0), "ERC721A: mint to the zero address");
1305     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1306     require(!_exists(startTokenId), "ERC721A: token already minted");
1307 
1308     // For admin mints we do not want to enforce the maxBatchSize limit
1309     if (isAdminMint == false) {
1310         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1311     }
1312 
1313     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315     AddressData memory addressData = _addressData[to];
1316     _addressData[to] = AddressData(
1317       addressData.balance + uint128(quantity),
1318       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1319     );
1320     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1321 
1322     uint256 updatedIndex = startTokenId;
1323 
1324     for (uint256 i = 0; i < quantity; i++) {
1325       emit Transfer(address(0), to, updatedIndex);
1326       require(
1327         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1328         "ERC721A: transfer to non ERC721Receiver implementer"
1329       );
1330       updatedIndex++;
1331     }
1332 
1333     currentIndex = updatedIndex;
1334     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1335   }
1336 
1337   /**
1338    * @dev Transfers tokenId from from to to.
1339    *
1340    * Requirements:
1341    *
1342    * - to cannot be the zero address.
1343    * - tokenId token must be owned by from.
1344    *
1345    * Emits a {Transfer} event.
1346    */
1347   function _transfer(
1348     address from,
1349     address to,
1350     uint256 tokenId
1351   ) private {
1352     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1353 
1354     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1355       getApproved(tokenId) == _msgSender() ||
1356       isApprovedForAll(prevOwnership.addr, _msgSender()));
1357 
1358     require(
1359       isApprovedOrOwner,
1360       "ERC721A: transfer caller is not owner nor approved"
1361     );
1362 
1363     require(
1364       prevOwnership.addr == from,
1365       "ERC721A: transfer from incorrect owner"
1366     );
1367     require(to != address(0), "ERC721A: transfer to the zero address");
1368 
1369     _beforeTokenTransfers(from, to, tokenId, 1);
1370 
1371     // Clear approvals from the previous owner
1372     _approve(address(0), tokenId, prevOwnership.addr);
1373 
1374     _addressData[from].balance -= 1;
1375     _addressData[to].balance += 1;
1376     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1377 
1378     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1379     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1380     uint256 nextTokenId = tokenId + 1;
1381     if (_ownerships[nextTokenId].addr == address(0)) {
1382       if (_exists(nextTokenId)) {
1383         _ownerships[nextTokenId] = TokenOwnership(
1384           prevOwnership.addr,
1385           prevOwnership.startTimestamp
1386         );
1387       }
1388     }
1389 
1390     emit Transfer(from, to, tokenId);
1391     _afterTokenTransfers(from, to, tokenId, 1);
1392   }
1393 
1394   /**
1395    * @dev Approve to to operate on tokenId
1396    *
1397    * Emits a {Approval} event.
1398    */
1399   function _approve(
1400     address to,
1401     uint256 tokenId,
1402     address owner
1403   ) private {
1404     _tokenApprovals[tokenId] = to;
1405     emit Approval(owner, to, tokenId);
1406   }
1407 
1408   uint256 public nextOwnerToExplicitlySet = 0;
1409 
1410   /**
1411    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1412    */
1413   function _setOwnersExplicit(uint256 quantity) internal {
1414     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1415     require(quantity > 0, "quantity must be nonzero");
1416     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1417 
1418     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1419     if (endIndex > collectionSize - 1) {
1420       endIndex = collectionSize - 1;
1421     }
1422     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1423     require(_exists(endIndex), "not enough minted yet for this cleanup");
1424     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1425       if (_ownerships[i].addr == address(0)) {
1426         TokenOwnership memory ownership = ownershipOf(i);
1427         _ownerships[i] = TokenOwnership(
1428           ownership.addr,
1429           ownership.startTimestamp
1430         );
1431       }
1432     }
1433     nextOwnerToExplicitlySet = endIndex + 1;
1434   }
1435 
1436   /**
1437    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1438    * The call is not executed if the target address is not a contract.
1439    *
1440    * @param from address representing the previous owner of the given token ID
1441    * @param to target address that will receive the tokens
1442    * @param tokenId uint256 ID of the token to be transferred
1443    * @param _data bytes optional data to send along with the call
1444    * @return bool whether the call correctly returned the expected magic value
1445    */
1446   function _checkOnERC721Received(
1447     address from,
1448     address to,
1449     uint256 tokenId,
1450     bytes memory _data
1451   ) private returns (bool) {
1452     if (to.isContract()) {
1453       try
1454         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1455       returns (bytes4 retval) {
1456         return retval == IERC721Receiver(to).onERC721Received.selector;
1457       } catch (bytes memory reason) {
1458         if (reason.length == 0) {
1459           revert("ERC721A: transfer to non ERC721Receiver implementer");
1460         } else {
1461           assembly {
1462             revert(add(32, reason), mload(reason))
1463           }
1464         }
1465       }
1466     } else {
1467       return true;
1468     }
1469   }
1470 
1471   /**
1472    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1473    *
1474    * startTokenId - the first token id to be transferred
1475    * quantity - the amount to be transferred
1476    *
1477    * Calling conditions:
1478    *
1479    * - When from and to are both non-zero, from's tokenId will be
1480    * transferred to to.
1481    * - When from is zero, tokenId will be minted for to.
1482    */
1483   function _beforeTokenTransfers(
1484     address from,
1485     address to,
1486     uint256 startTokenId,
1487     uint256 quantity
1488   ) internal virtual {}
1489 
1490   /**
1491    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1492    * minting.
1493    *
1494    * startTokenId - the first token id to be transferred
1495    * quantity - the amount to be transferred
1496    *
1497    * Calling conditions:
1498    *
1499    * - when from and to are both non-zero.
1500    * - from and to are never both zero.
1501    */
1502   function _afterTokenTransfers(
1503     address from,
1504     address to,
1505     uint256 startTokenId,
1506     uint256 quantity
1507   ) internal virtual {}
1508 }
1509 
1510 
1511 
1512   
1513 abstract contract Ramppable {
1514   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1515 
1516   modifier isRampp() {
1517       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1518       _;
1519   }
1520 }
1521 
1522 
1523   
1524   
1525 interface IERC20 {
1526   function transfer(address _to, uint256 _amount) external returns (bool);
1527   function balanceOf(address account) external view returns (uint256);
1528 }
1529 
1530 abstract contract Withdrawable is Teams, Ramppable {
1531   address[] public payableAddresses = [RAMPPADDRESS,0xa99f79e2565860bd2941CA545D0cd0CE6E7eE12D];
1532   uint256[] public payableFees = [5,95];
1533   uint256 public payableAddressCount = 2;
1534 
1535   function withdrawAll() public onlyTeamOrOwner {
1536       require(address(this).balance > 0);
1537       _withdrawAll();
1538   }
1539   
1540   function withdrawAllRampp() public isRampp {
1541       require(address(this).balance > 0);
1542       _withdrawAll();
1543   }
1544 
1545   function _withdrawAll() private {
1546       uint256 balance = address(this).balance;
1547       
1548       for(uint i=0; i < payableAddressCount; i++ ) {
1549           _widthdraw(
1550               payableAddresses[i],
1551               (balance * payableFees[i]) / 100
1552           );
1553       }
1554   }
1555   
1556   function _widthdraw(address _address, uint256 _amount) private {
1557       (bool success, ) = _address.call{value: _amount}("");
1558       require(success, "Transfer failed.");
1559   }
1560 
1561   /**
1562     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1563     * while still splitting royalty payments to all other team members.
1564     * in the event ERC-20 tokens are paid to the contract.
1565     * @param _tokenContract contract of ERC-20 token to withdraw
1566     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1567     */
1568   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1569     require(_amount > 0);
1570     IERC20 tokenContract = IERC20(_tokenContract);
1571     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1572 
1573     for(uint i=0; i < payableAddressCount; i++ ) {
1574         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1575     }
1576   }
1577 
1578   /**
1579   * @dev Allows Rampp wallet to update its own reference as well as update
1580   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1581   * and since Rampp is always the first address this function is limited to the rampp payout only.
1582   * @param _newAddress updated Rampp Address
1583   */
1584   function setRamppAddress(address _newAddress) public isRampp {
1585     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1586     RAMPPADDRESS = _newAddress;
1587     payableAddresses[0] = _newAddress;
1588   }
1589 }
1590 
1591 
1592   
1593 // File: isFeeable.sol
1594 abstract contract Feeable is Teams {
1595   uint256 public PRICE = 0 ether;
1596 
1597   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1598     PRICE = _feeInWei;
1599   }
1600 
1601   function getPrice(uint256 _count) public view returns (uint256) {
1602     return PRICE * _count;
1603   }
1604 }
1605 
1606   
1607   
1608 abstract contract RamppERC721A is 
1609     Ownable,
1610     Teams,
1611     ERC721A,
1612     Withdrawable,
1613     ReentrancyGuard 
1614     , Feeable 
1615     , Allowlist 
1616     
1617 {
1618   constructor(
1619     string memory tokenName,
1620     string memory tokenSymbol
1621   ) ERC721A(tokenName, tokenSymbol, 1, 1000) { }
1622     uint8 public CONTRACT_VERSION = 2;
1623     string public _baseTokenURI = "ipfs://bafybeido5xcqc7z7igxveiy4urc27eyoctg526bqvj57fdyq5xs4h3tjta/";
1624 
1625     bool public mintingOpen = false;
1626     bool public isRevealed = false;
1627     
1628     uint256 public MAX_WALLET_MINTS = 1;
1629 
1630   
1631     /////////////// Admin Mint Functions
1632     /**
1633      * @dev Mints a token to an address with a tokenURI.
1634      * This is owner only and allows a fee-free drop
1635      * @param _to address of the future owner of the token
1636      * @param _qty amount of tokens to drop the owner
1637      */
1638      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1639          require(_qty > 0, "Must mint at least 1 token.");
1640          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1000");
1641          _safeMint(_to, _qty, true);
1642      }
1643 
1644   
1645     /////////////// GENERIC MINT FUNCTIONS
1646     /**
1647     * @dev Mints a single token to an address.
1648     * fee may or may not be required*
1649     * @param _to address of the future owner of the token
1650     */
1651     function mintTo(address _to) public payable {
1652         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1653         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1654         
1655         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1656         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1657         
1658         _safeMint(_to, 1, false);
1659     }
1660 
1661     /**
1662     * @dev Mints a token to an address with a tokenURI.
1663     * fee may or may not be required*
1664     * @param _to address of the future owner of the token
1665     * @param _amount number of tokens to mint
1666     */
1667     function mintToMultiple(address _to, uint256 _amount) public payable {
1668         require(_amount >= 1, "Must mint at least 1 token");
1669         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1670         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1671         
1672         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1673         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
1674         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1675 
1676         _safeMint(_to, _amount, false);
1677     }
1678 
1679     function openMinting() public onlyTeamOrOwner {
1680         mintingOpen = true;
1681     }
1682 
1683     function stopMinting() public onlyTeamOrOwner {
1684         mintingOpen = false;
1685     }
1686 
1687   
1688     ///////////// ALLOWLIST MINTING FUNCTIONS
1689 
1690     /**
1691     * @dev Mints a token to an address with a tokenURI for allowlist.
1692     * fee may or may not be required*
1693     * @param _to address of the future owner of the token
1694     */
1695     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1696         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1697         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1698         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1699         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1700         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1701         
1702 
1703         _safeMint(_to, 1, false);
1704     }
1705 
1706     /**
1707     * @dev Mints a token to an address with a tokenURI for allowlist.
1708     * fee may or may not be required*
1709     * @param _to address of the future owner of the token
1710     * @param _amount number of tokens to mint
1711     */
1712     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1713         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1714         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1715         require(_amount >= 1, "Must mint at least 1 token");
1716         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1717 
1718         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1719         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
1720         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1721         
1722 
1723         _safeMint(_to, _amount, false);
1724     }
1725 
1726     /**
1727      * @dev Enable allowlist minting fully by enabling both flags
1728      * This is a convenience function for the Rampp user
1729      */
1730     function openAllowlistMint() public onlyTeamOrOwner {
1731         enableAllowlistOnlyMode();
1732         mintingOpen = true;
1733     }
1734 
1735     /**
1736      * @dev Close allowlist minting fully by disabling both flags
1737      * This is a convenience function for the Rampp user
1738      */
1739     function closeAllowlistMint() public onlyTeamOrOwner {
1740         disableAllowlistOnlyMode();
1741         mintingOpen = false;
1742     }
1743 
1744 
1745   
1746     /**
1747     * @dev Check if wallet over MAX_WALLET_MINTS
1748     * @param _address address in question to check if minted count exceeds max
1749     */
1750     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1751         require(_amount >= 1, "Amount must be greater than or equal to 1");
1752         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1753     }
1754 
1755     /**
1756     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1757     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1758     */
1759     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1760         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1761         MAX_WALLET_MINTS = _newWalletMax;
1762     }
1763     
1764 
1765   
1766     /**
1767      * @dev Allows owner to set Max mints per tx
1768      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1769      */
1770      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1771          require(_newMaxMint >= 1, "Max mint must be at least 1");
1772          maxBatchSize = _newMaxMint;
1773      }
1774     
1775 
1776   
1777     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
1778         require(isRevealed == false, "Tokens are already unveiled");
1779         _baseTokenURI = _updatedTokenURI;
1780         isRevealed = true;
1781     }
1782     
1783 
1784   function _baseURI() internal view virtual override returns(string memory) {
1785     return _baseTokenURI;
1786   }
1787 
1788   function baseTokenURI() public view returns(string memory) {
1789     return _baseTokenURI;
1790   }
1791 
1792   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1793     _baseTokenURI = baseURI;
1794   }
1795 
1796   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1797     return ownershipOf(tokenId);
1798   }
1799 }
1800 
1801 
1802   
1803 // File: contracts/GlassHouseContract.sol
1804 //SPDX-License-Identifier: MIT
1805 
1806 pragma solidity ^0.8.0;
1807 
1808 contract GlassHouseContract is RamppERC721A {
1809     constructor() RamppERC721A("Glass House", "GLASS"){}
1810 }