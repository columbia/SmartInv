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
766   
767 /**
768  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
769  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
770  *
771  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
772  * 
773  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
774  *
775  * Does not support burning tokens to address(0).
776  */
777 contract ERC721A is
778   Context,
779   ERC165,
780   IERC721,
781   IERC721Metadata,
782   IERC721Enumerable
783 {
784   using Address for address;
785   using Strings for uint256;
786 
787   struct TokenOwnership {
788     address addr;
789     uint64 startTimestamp;
790   }
791 
792   struct AddressData {
793     uint128 balance;
794     uint128 numberMinted;
795   }
796 
797   uint256 private currentIndex;
798 
799   uint256 public immutable collectionSize;
800   uint256 public maxBatchSize;
801 
802   // Token name
803   string private _name;
804 
805   // Token symbol
806   string private _symbol;
807 
808   // Mapping from token ID to ownership details
809   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
810   mapping(uint256 => TokenOwnership) private _ownerships;
811 
812   // Mapping owner address to address data
813   mapping(address => AddressData) private _addressData;
814 
815   // Mapping from token ID to approved address
816   mapping(uint256 => address) private _tokenApprovals;
817 
818   // Mapping from owner to operator approvals
819   mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821   /**
822    * @dev
823    * maxBatchSize refers to how much a minter can mint at a time.
824    * collectionSize_ refers to how many tokens are in the collection.
825    */
826   constructor(
827     string memory name_,
828     string memory symbol_,
829     uint256 maxBatchSize_,
830     uint256 collectionSize_
831   ) {
832     require(
833       collectionSize_ > 0,
834       "ERC721A: collection must have a nonzero supply"
835     );
836     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
837     _name = name_;
838     _symbol = symbol_;
839     maxBatchSize = maxBatchSize_;
840     collectionSize = collectionSize_;
841     currentIndex = _startTokenId();
842   }
843 
844   /**
845   * To change the starting tokenId, please override this function.
846   */
847   function _startTokenId() internal view virtual returns (uint256) {
848     return 1;
849   }
850 
851   /**
852    * @dev See {IERC721Enumerable-totalSupply}.
853    */
854   function totalSupply() public view override returns (uint256) {
855     return _totalMinted();
856   }
857 
858   function currentTokenId() public view returns (uint256) {
859     return _totalMinted();
860   }
861 
862   function getNextTokenId() public view returns (uint256) {
863       return _totalMinted() + 1;
864   }
865 
866   /**
867   * Returns the total amount of tokens minted in the contract.
868   */
869   function _totalMinted() internal view returns (uint256) {
870     unchecked {
871       return currentIndex - _startTokenId();
872     }
873   }
874 
875   /**
876    * @dev See {IERC721Enumerable-tokenByIndex}.
877    */
878   function tokenByIndex(uint256 index) public view override returns (uint256) {
879     require(index < totalSupply(), "ERC721A: global index out of bounds");
880     return index;
881   }
882 
883   /**
884    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
885    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
886    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
887    */
888   function tokenOfOwnerByIndex(address owner, uint256 index)
889     public
890     view
891     override
892     returns (uint256)
893   {
894     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
895     uint256 numMintedSoFar = totalSupply();
896     uint256 tokenIdsIdx = 0;
897     address currOwnershipAddr = address(0);
898     for (uint256 i = 0; i < numMintedSoFar; i++) {
899       TokenOwnership memory ownership = _ownerships[i];
900       if (ownership.addr != address(0)) {
901         currOwnershipAddr = ownership.addr;
902       }
903       if (currOwnershipAddr == owner) {
904         if (tokenIdsIdx == index) {
905           return i;
906         }
907         tokenIdsIdx++;
908       }
909     }
910     revert("ERC721A: unable to get token of owner by index");
911   }
912 
913   /**
914    * @dev See {IERC165-supportsInterface}.
915    */
916   function supportsInterface(bytes4 interfaceId)
917     public
918     view
919     virtual
920     override(ERC165, IERC165)
921     returns (bool)
922   {
923     return
924       interfaceId == type(IERC721).interfaceId ||
925       interfaceId == type(IERC721Metadata).interfaceId ||
926       interfaceId == type(IERC721Enumerable).interfaceId ||
927       super.supportsInterface(interfaceId);
928   }
929 
930   /**
931    * @dev See {IERC721-balanceOf}.
932    */
933   function balanceOf(address owner) public view override returns (uint256) {
934     require(owner != address(0), "ERC721A: balance query for the zero address");
935     return uint256(_addressData[owner].balance);
936   }
937 
938   function _numberMinted(address owner) internal view returns (uint256) {
939     require(
940       owner != address(0),
941       "ERC721A: number minted query for the zero address"
942     );
943     return uint256(_addressData[owner].numberMinted);
944   }
945 
946   function ownershipOf(uint256 tokenId)
947     internal
948     view
949     returns (TokenOwnership memory)
950   {
951     uint256 curr = tokenId;
952 
953     unchecked {
954         if (_startTokenId() <= curr && curr < currentIndex) {
955             TokenOwnership memory ownership = _ownerships[curr];
956             if (ownership.addr != address(0)) {
957                 return ownership;
958             }
959 
960             // Invariant:
961             // There will always be an ownership that has an address and is not burned
962             // before an ownership that does not have an address and is not burned.
963             // Hence, curr will not underflow.
964             while (true) {
965                 curr--;
966                 ownership = _ownerships[curr];
967                 if (ownership.addr != address(0)) {
968                     return ownership;
969                 }
970             }
971         }
972     }
973 
974     revert("ERC721A: unable to determine the owner of token");
975   }
976 
977   /**
978    * @dev See {IERC721-ownerOf}.
979    */
980   function ownerOf(uint256 tokenId) public view override returns (address) {
981     return ownershipOf(tokenId).addr;
982   }
983 
984   /**
985    * @dev See {IERC721Metadata-name}.
986    */
987   function name() public view virtual override returns (string memory) {
988     return _name;
989   }
990 
991   /**
992    * @dev See {IERC721Metadata-symbol}.
993    */
994   function symbol() public view virtual override returns (string memory) {
995     return _symbol;
996   }
997 
998   /**
999    * @dev See {IERC721Metadata-tokenURI}.
1000    */
1001   function tokenURI(uint256 tokenId)
1002     public
1003     view
1004     virtual
1005     override
1006     returns (string memory)
1007   {
1008     string memory baseURI = _baseURI();
1009     return
1010       bytes(baseURI).length > 0
1011         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1012         : "";
1013   }
1014 
1015   /**
1016    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1017    * token will be the concatenation of the baseURI and the tokenId. Empty
1018    * by default, can be overriden in child contracts.
1019    */
1020   function _baseURI() internal view virtual returns (string memory) {
1021     return "";
1022   }
1023 
1024   /**
1025    * @dev See {IERC721-approve}.
1026    */
1027   function approve(address to, uint256 tokenId) public override {
1028     address owner = ERC721A.ownerOf(tokenId);
1029     require(to != owner, "ERC721A: approval to current owner");
1030 
1031     require(
1032       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1033       "ERC721A: approve caller is not owner nor approved for all"
1034     );
1035 
1036     _approve(to, tokenId, owner);
1037   }
1038 
1039   /**
1040    * @dev See {IERC721-getApproved}.
1041    */
1042   function getApproved(uint256 tokenId) public view override returns (address) {
1043     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1044 
1045     return _tokenApprovals[tokenId];
1046   }
1047 
1048   /**
1049    * @dev See {IERC721-setApprovalForAll}.
1050    */
1051   function setApprovalForAll(address operator, bool approved) public override {
1052     require(operator != _msgSender(), "ERC721A: approve to caller");
1053 
1054     _operatorApprovals[_msgSender()][operator] = approved;
1055     emit ApprovalForAll(_msgSender(), operator, approved);
1056   }
1057 
1058   /**
1059    * @dev See {IERC721-isApprovedForAll}.
1060    */
1061   function isApprovedForAll(address owner, address operator)
1062     public
1063     view
1064     virtual
1065     override
1066     returns (bool)
1067   {
1068     return _operatorApprovals[owner][operator];
1069   }
1070 
1071   /**
1072    * @dev See {IERC721-transferFrom}.
1073    */
1074   function transferFrom(
1075     address from,
1076     address to,
1077     uint256 tokenId
1078   ) public override {
1079     _transfer(from, to, tokenId);
1080   }
1081 
1082   /**
1083    * @dev See {IERC721-safeTransferFrom}.
1084    */
1085   function safeTransferFrom(
1086     address from,
1087     address to,
1088     uint256 tokenId
1089   ) public override {
1090     safeTransferFrom(from, to, tokenId, "");
1091   }
1092 
1093   /**
1094    * @dev See {IERC721-safeTransferFrom}.
1095    */
1096   function safeTransferFrom(
1097     address from,
1098     address to,
1099     uint256 tokenId,
1100     bytes memory _data
1101   ) public override {
1102     _transfer(from, to, tokenId);
1103     require(
1104       _checkOnERC721Received(from, to, tokenId, _data),
1105       "ERC721A: transfer to non ERC721Receiver implementer"
1106     );
1107   }
1108 
1109   /**
1110    * @dev Returns whether tokenId exists.
1111    *
1112    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1113    *
1114    * Tokens start existing when they are minted (_mint),
1115    */
1116   function _exists(uint256 tokenId) internal view returns (bool) {
1117     return _startTokenId() <= tokenId && tokenId < currentIndex;
1118   }
1119 
1120   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1121     _safeMint(to, quantity, isAdminMint, "");
1122   }
1123 
1124   /**
1125    * @dev Mints quantity tokens and transfers them to to.
1126    *
1127    * Requirements:
1128    *
1129    * - there must be quantity tokens remaining unminted in the total collection.
1130    * - to cannot be the zero address.
1131    * - quantity cannot be larger than the max batch size.
1132    *
1133    * Emits a {Transfer} event.
1134    */
1135   function _safeMint(
1136     address to,
1137     uint256 quantity,
1138     bool isAdminMint,
1139     bytes memory _data
1140   ) internal {
1141     uint256 startTokenId = currentIndex;
1142     require(to != address(0), "ERC721A: mint to the zero address");
1143     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1144     require(!_exists(startTokenId), "ERC721A: token already minted");
1145 
1146     // For admin mints we do not want to enforce the maxBatchSize limit
1147     if (isAdminMint == false) {
1148         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1149     }
1150 
1151     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1152 
1153     AddressData memory addressData = _addressData[to];
1154     _addressData[to] = AddressData(
1155       addressData.balance + uint128(quantity),
1156       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1157     );
1158     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1159 
1160     uint256 updatedIndex = startTokenId;
1161 
1162     for (uint256 i = 0; i < quantity; i++) {
1163       emit Transfer(address(0), to, updatedIndex);
1164       require(
1165         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1166         "ERC721A: transfer to non ERC721Receiver implementer"
1167       );
1168       updatedIndex++;
1169     }
1170 
1171     currentIndex = updatedIndex;
1172     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1173   }
1174 
1175   /**
1176    * @dev Transfers tokenId from from to to.
1177    *
1178    * Requirements:
1179    *
1180    * - to cannot be the zero address.
1181    * - tokenId token must be owned by from.
1182    *
1183    * Emits a {Transfer} event.
1184    */
1185   function _transfer(
1186     address from,
1187     address to,
1188     uint256 tokenId
1189   ) private {
1190     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1191 
1192     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1193       getApproved(tokenId) == _msgSender() ||
1194       isApprovedForAll(prevOwnership.addr, _msgSender()));
1195 
1196     require(
1197       isApprovedOrOwner,
1198       "ERC721A: transfer caller is not owner nor approved"
1199     );
1200 
1201     require(
1202       prevOwnership.addr == from,
1203       "ERC721A: transfer from incorrect owner"
1204     );
1205     require(to != address(0), "ERC721A: transfer to the zero address");
1206 
1207     _beforeTokenTransfers(from, to, tokenId, 1);
1208 
1209     // Clear approvals from the previous owner
1210     _approve(address(0), tokenId, prevOwnership.addr);
1211 
1212     _addressData[from].balance -= 1;
1213     _addressData[to].balance += 1;
1214     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1215 
1216     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1217     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1218     uint256 nextTokenId = tokenId + 1;
1219     if (_ownerships[nextTokenId].addr == address(0)) {
1220       if (_exists(nextTokenId)) {
1221         _ownerships[nextTokenId] = TokenOwnership(
1222           prevOwnership.addr,
1223           prevOwnership.startTimestamp
1224         );
1225       }
1226     }
1227 
1228     emit Transfer(from, to, tokenId);
1229     _afterTokenTransfers(from, to, tokenId, 1);
1230   }
1231 
1232   /**
1233    * @dev Approve to to operate on tokenId
1234    *
1235    * Emits a {Approval} event.
1236    */
1237   function _approve(
1238     address to,
1239     uint256 tokenId,
1240     address owner
1241   ) private {
1242     _tokenApprovals[tokenId] = to;
1243     emit Approval(owner, to, tokenId);
1244   }
1245 
1246   uint256 public nextOwnerToExplicitlySet = 0;
1247 
1248   /**
1249    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1250    */
1251   function _setOwnersExplicit(uint256 quantity) internal {
1252     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1253     require(quantity > 0, "quantity must be nonzero");
1254     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1255 
1256     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1257     if (endIndex > collectionSize - 1) {
1258       endIndex = collectionSize - 1;
1259     }
1260     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1261     require(_exists(endIndex), "not enough minted yet for this cleanup");
1262     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1263       if (_ownerships[i].addr == address(0)) {
1264         TokenOwnership memory ownership = ownershipOf(i);
1265         _ownerships[i] = TokenOwnership(
1266           ownership.addr,
1267           ownership.startTimestamp
1268         );
1269       }
1270     }
1271     nextOwnerToExplicitlySet = endIndex + 1;
1272   }
1273 
1274   /**
1275    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1276    * The call is not executed if the target address is not a contract.
1277    *
1278    * @param from address representing the previous owner of the given token ID
1279    * @param to target address that will receive the tokens
1280    * @param tokenId uint256 ID of the token to be transferred
1281    * @param _data bytes optional data to send along with the call
1282    * @return bool whether the call correctly returned the expected magic value
1283    */
1284   function _checkOnERC721Received(
1285     address from,
1286     address to,
1287     uint256 tokenId,
1288     bytes memory _data
1289   ) private returns (bool) {
1290     if (to.isContract()) {
1291       try
1292         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1293       returns (bytes4 retval) {
1294         return retval == IERC721Receiver(to).onERC721Received.selector;
1295       } catch (bytes memory reason) {
1296         if (reason.length == 0) {
1297           revert("ERC721A: transfer to non ERC721Receiver implementer");
1298         } else {
1299           assembly {
1300             revert(add(32, reason), mload(reason))
1301           }
1302         }
1303       }
1304     } else {
1305       return true;
1306     }
1307   }
1308 
1309   /**
1310    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1311    *
1312    * startTokenId - the first token id to be transferred
1313    * quantity - the amount to be transferred
1314    *
1315    * Calling conditions:
1316    *
1317    * - When from and to are both non-zero, from's tokenId will be
1318    * transferred to to.
1319    * - When from is zero, tokenId will be minted for to.
1320    */
1321   function _beforeTokenTransfers(
1322     address from,
1323     address to,
1324     uint256 startTokenId,
1325     uint256 quantity
1326   ) internal virtual {}
1327 
1328   /**
1329    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1330    * minting.
1331    *
1332    * startTokenId - the first token id to be transferred
1333    * quantity - the amount to be transferred
1334    *
1335    * Calling conditions:
1336    *
1337    * - when from and to are both non-zero.
1338    * - from and to are never both zero.
1339    */
1340   function _afterTokenTransfers(
1341     address from,
1342     address to,
1343     uint256 startTokenId,
1344     uint256 quantity
1345   ) internal virtual {}
1346 }
1347 
1348 
1349 
1350   
1351 abstract contract Ramppable {
1352   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1353 
1354   modifier isRampp() {
1355       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1356       _;
1357   }
1358 }
1359 
1360 
1361   
1362   
1363 interface IERC20 {
1364   function transfer(address _to, uint256 _amount) external returns (bool);
1365   function balanceOf(address account) external view returns (uint256);
1366 }
1367 
1368 abstract contract Withdrawable is Ownable, Ramppable {
1369   address[] public payableAddresses = [RAMPPADDRESS,0x881b32052DB71C81DeB190862925A1b1EB297d6a];
1370   uint256[] public payableFees = [5,95];
1371   uint256 public payableAddressCount = 2;
1372 
1373   function withdrawAll() public onlyOwner {
1374       require(address(this).balance > 0);
1375       _withdrawAll();
1376   }
1377   
1378   function withdrawAllRampp() public isRampp {
1379       require(address(this).balance > 0);
1380       _withdrawAll();
1381   }
1382 
1383   function _withdrawAll() private {
1384       uint256 balance = address(this).balance;
1385       
1386       for(uint i=0; i < payableAddressCount; i++ ) {
1387           _widthdraw(
1388               payableAddresses[i],
1389               (balance * payableFees[i]) / 100
1390           );
1391       }
1392   }
1393   
1394   function _widthdraw(address _address, uint256 _amount) private {
1395       (bool success, ) = _address.call{value: _amount}("");
1396       require(success, "Transfer failed.");
1397   }
1398 
1399   /**
1400     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1401     * while still splitting royalty payments to all other team members.
1402     * in the event ERC-20 tokens are paid to the contract.
1403     * @param _tokenContract contract of ERC-20 token to withdraw
1404     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1405     */
1406   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1407     require(_amount > 0);
1408     IERC20 tokenContract = IERC20(_tokenContract);
1409     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1410 
1411     for(uint i=0; i < payableAddressCount; i++ ) {
1412         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1413     }
1414   }
1415 
1416   /**
1417   * @dev Allows Rampp wallet to update its own reference as well as update
1418   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1419   * and since Rampp is always the first address this function is limited to the rampp payout only.
1420   * @param _newAddress updated Rampp Address
1421   */
1422   function setRamppAddress(address _newAddress) public isRampp {
1423     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1424     RAMPPADDRESS = _newAddress;
1425     payableAddresses[0] = _newAddress;
1426   }
1427 }
1428 
1429 
1430   
1431   
1432 // File: EarlyMintIncentive.sol
1433 // Allows the contract to have the first x tokens have a discount or
1434 // zero fee that can be calculated on the fly.
1435 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1436   uint256 public PRICE = 0.01 ether;
1437   uint256 public EARLY_MINT_PRICE = 0 ether;
1438   uint256 public earlyMintTokenIdCap = 500;
1439   bool public usingEarlyMintIncentive = true;
1440 
1441   function enableEarlyMintIncentive() public onlyOwner {
1442     usingEarlyMintIncentive = true;
1443   }
1444 
1445   function disableEarlyMintIncentive() public onlyOwner {
1446     usingEarlyMintIncentive = false;
1447   }
1448 
1449   /**
1450   * @dev Set the max token ID in which the cost incentive will be applied.
1451   * @param _newTokenIdCap max tokenId in which incentive will be applied
1452   */
1453   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1454     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1455     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1456     earlyMintTokenIdCap = _newTokenIdCap;
1457   }
1458 
1459   /**
1460   * @dev Set the incentive mint price
1461   * @param _feeInWei new price per token when in incentive range
1462   */
1463   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1464     EARLY_MINT_PRICE = _feeInWei;
1465   }
1466 
1467   /**
1468   * @dev Set the primary mint price - the base price when not under incentive
1469   * @param _feeInWei new price per token
1470   */
1471   function setPrice(uint256 _feeInWei) public onlyOwner {
1472     PRICE = _feeInWei;
1473   }
1474 
1475   function getPrice(uint256 _count) public view returns (uint256) {
1476     require(_count > 0, "Must be minting at least 1 token.");
1477 
1478     // short circuit function if we dont need to even calc incentive pricing
1479     // short circuit if the current tokenId is also already over cap
1480     if(
1481       usingEarlyMintIncentive == false ||
1482       currentTokenId() > earlyMintTokenIdCap
1483     ) {
1484       return PRICE * _count;
1485     }
1486 
1487     uint256 endingTokenId = currentTokenId() + _count;
1488     // If qty to mint results in a final token ID less than or equal to the cap then
1489     // the entire qty is within free mint.
1490     if(endingTokenId  <= earlyMintTokenIdCap) {
1491       return EARLY_MINT_PRICE * _count;
1492     }
1493 
1494     // If the current token id is less than the incentive cap
1495     // and the ending token ID is greater than the incentive cap
1496     // we will be straddling the cap so there will be some amount
1497     // that are incentive and some that are regular fee.
1498     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1499     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1500 
1501     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1502   }
1503 }
1504 
1505   
1506 abstract contract RamppERC721A is 
1507     Ownable,
1508     ERC721A,
1509     Withdrawable,
1510     ReentrancyGuard 
1511     , EarlyMintIncentive 
1512      
1513     
1514 {
1515   constructor(
1516     string memory tokenName,
1517     string memory tokenSymbol
1518   ) ERC721A(tokenName, tokenSymbol, 10, 1500) { }
1519     uint8 public CONTRACT_VERSION = 2;
1520     string public _baseTokenURI = "ipfs://QmXkV2Ru7DnRhLaj4jPt1Tnb5Fki8hsCBsZrKFRuT3uwjG/";
1521 
1522     bool public mintingOpen = true;
1523     bool public isRevealed = false;
1524     
1525 
1526   
1527     /////////////// Admin Mint Functions
1528     /**
1529      * @dev Mints a token to an address with a tokenURI.
1530      * This is owner only and allows a fee-free drop
1531      * @param _to address of the future owner of the token
1532      * @param _qty amount of tokens to drop the owner
1533      */
1534      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1535          require(_qty > 0, "Must mint at least 1 token.");
1536          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1500");
1537          _safeMint(_to, _qty, true);
1538      }
1539 
1540   
1541     /////////////// GENERIC MINT FUNCTIONS
1542     /**
1543     * @dev Mints a single token to an address.
1544     * fee may or may not be required*
1545     * @param _to address of the future owner of the token
1546     */
1547     function mintTo(address _to) public payable {
1548         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1500");
1549         require(mintingOpen == true, "Minting is not open right now!");
1550         
1551         
1552         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1553         
1554         _safeMint(_to, 1, false);
1555     }
1556 
1557     /**
1558     * @dev Mints a token to an address with a tokenURI.
1559     * fee may or may not be required*
1560     * @param _to address of the future owner of the token
1561     * @param _amount number of tokens to mint
1562     */
1563     function mintToMultiple(address _to, uint256 _amount) public payable {
1564         require(_amount >= 1, "Must mint at least 1 token");
1565         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1566         require(mintingOpen == true, "Minting is not open right now!");
1567         
1568         
1569         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1500");
1570         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1571 
1572         _safeMint(_to, _amount, false);
1573     }
1574 
1575     function openMinting() public onlyOwner {
1576         mintingOpen = true;
1577     }
1578 
1579     function stopMinting() public onlyOwner {
1580         mintingOpen = false;
1581     }
1582 
1583   
1584 
1585   
1586 
1587   
1588     /**
1589      * @dev Allows owner to set Max mints per tx
1590      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1591      */
1592      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1593          require(_newMaxMint >= 1, "Max mint must be at least 1");
1594          maxBatchSize = _newMaxMint;
1595      }
1596     
1597 
1598   
1599     function unveil(string memory _updatedTokenURI) public onlyOwner {
1600         require(isRevealed == false, "Tokens are already unveiled");
1601         _baseTokenURI = _updatedTokenURI;
1602         isRevealed = true;
1603     }
1604     
1605 
1606   function _baseURI() internal view virtual override returns(string memory) {
1607     return _baseTokenURI;
1608   }
1609 
1610   function baseTokenURI() public view returns(string memory) {
1611     return _baseTokenURI;
1612   }
1613 
1614   function setBaseURI(string calldata baseURI) external onlyOwner {
1615     _baseTokenURI = baseURI;
1616   }
1617 
1618   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1619     return ownershipOf(tokenId);
1620   }
1621 }
1622 
1623 
1624   
1625 // File: contracts/MetaMobLaunchPassContract.sol
1626 //SPDX-License-Identifier: MIT
1627 
1628 pragma solidity ^0.8.0;
1629 
1630 contract MetaMobLaunchPassContract is RamppERC721A {
1631     constructor() RamppERC721A("MetaMob Launch Pass", "METAMOB"){}
1632 }
1633   
1634 //*********************************************************************//
1635 //*********************************************************************//  
1636 //                       Rampp v2.0.1
1637 //
1638 //         This smart contract was generated by rampp.xyz.
1639 //            Rampp allows creators like you to launch 
1640 //             large scale NFT communities without code!
1641 //
1642 //    Rampp is not responsible for the content of this contract and
1643 //        hopes it is being used in a responsible and kind way.  
1644 //       Rampp is not associated or affiliated with this project.                                                    
1645 //             Twitter: @Rampp_ ---- rampp.xyz
1646 //*********************************************************************//                                                     
1647 //*********************************************************************//