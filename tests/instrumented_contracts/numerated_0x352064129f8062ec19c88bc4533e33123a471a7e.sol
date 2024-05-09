1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     __  _____________ _       ____    ___    _   ______ 
5 //    /  |/  / ____/ __ \ |     / / /   /   |  / | / / __ \
6 //   / /|_/ / __/ / / / / | /| / / /   / /| | /  |/ / / / /
7 //  / /  / / /___/ /_/ /| |/ |/ / /___/ ___ |/ /|  / /_/ / 
8 // /_/  /_/_____/\____/ |__/|__/_____/_/  |_/_/ |_/_____/  
9 //                                                         
10 //
11 //*********************************************************************//
12 //*********************************************************************//
13   
14 //-------------DEPENDENCIES--------------------------//
15 
16 // File: @openzeppelin/contracts/utils/Address.sol
17 
18 
19 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
20 
21 pragma solidity ^0.8.1;
22 
23 /**
24  * @dev Collection of functions related to the address type
25  */
26 library Address {
27     /**
28      * @dev Returns true if account is a contract.
29      *
30      * [IMPORTANT]
31      * ====
32      * It is unsafe to assume that an address for which this function returns
33      * false is an externally-owned account (EOA) and not a contract.
34      *
35      * Among others, isContract will return false for the following
36      * types of addresses:
37      *
38      *  - an externally-owned account
39      *  - a contract in construction
40      *  - an address where a contract will be created
41      *  - an address where a contract lived, but was destroyed
42      * ====
43      *
44      * [IMPORTANT]
45      * ====
46      * You shouldn't rely on isContract to protect against flash loan attacks!
47      *
48      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
49      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
50      * constructor.
51      * ====
52      */
53     function isContract(address account) internal view returns (bool) {
54         // This method relies on extcodesize/address.code.length, which returns 0
55         // for contracts in construction, since the code is only stored at the end
56         // of the constructor execution.
57 
58         return account.code.length > 0;
59     }
60 
61     /**
62      * @dev Replacement for Solidity's transfer: sends amount wei to
63      * recipient, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by transfer, making them unable to receive funds via
68      * transfer. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to recipient, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         (bool success, ) = recipient.call{value: amount}("");
81         require(success, "Address: unable to send value, recipient may have reverted");
82     }
83 
84     /**
85      * @dev Performs a Solidity function call using a low level call. A
86      * plain call is an unsafe replacement for a function call: use this
87      * function instead.
88      *
89      * If target reverts with a revert reason, it is bubbled up by this
90      * function (like regular Solidity function calls).
91      *
92      * Returns the raw returned data. To convert to the expected return value,
93      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
94      *
95      * Requirements:
96      *
97      * - target must be a contract.
98      * - calling target with data must not revert.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
103         return functionCall(target, data, "Address: low-level call failed");
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
108      * errorMessage as a fallback revert reason when target reverts.
109      *
110      * _Available since v3.1._
111      */
112     function functionCall(
113         address target,
114         bytes memory data,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, 0, errorMessage);
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
122      * but also transferring value wei to target.
123      *
124      * Requirements:
125      *
126      * - the calling contract must have an ETH balance of at least value.
127      * - the called Solidity function must be payable.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value
135     ) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
141      * with errorMessage as a fallback revert reason when target reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(
146         address target,
147         bytes memory data,
148         uint256 value,
149         string memory errorMessage
150     ) internal returns (bytes memory) {
151         require(address(this).balance >= value, "Address: insufficient balance for call");
152         require(isContract(target), "Address: call to non-contract");
153 
154         (bool success, bytes memory returndata) = target.call{value: value}(data);
155         return verifyCallResult(success, returndata, errorMessage);
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
160      * but performing a static call.
161      *
162      * _Available since v3.3._
163      */
164     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
165         return functionStaticCall(target, data, "Address: low-level static call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
170      * but performing a static call.
171      *
172      * _Available since v3.3._
173      */
174     function functionStaticCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal view returns (bytes memory) {
179         require(isContract(target), "Address: static call to non-contract");
180 
181         (bool success, bytes memory returndata) = target.staticcall(data);
182         return verifyCallResult(success, returndata, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
187      * but performing a delegate call.
188      *
189      * _Available since v3.4._
190      */
191     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
192         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
197      * but performing a delegate call.
198      *
199      * _Available since v3.4._
200      */
201     function functionDelegateCall(
202         address target,
203         bytes memory data,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(isContract(target), "Address: delegate call to non-contract");
207 
208         (bool success, bytes memory returndata) = target.delegatecall(data);
209         return verifyCallResult(success, returndata, errorMessage);
210     }
211 
212     /**
213      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
214      * revert reason using the provided one.
215      *
216      * _Available since v4.3._
217      */
218     function verifyCallResult(
219         bool success,
220         bytes memory returndata,
221         string memory errorMessage
222     ) internal pure returns (bytes memory) {
223         if (success) {
224             return returndata;
225         } else {
226             // Look for revert reason and bubble it up if present
227             if (returndata.length > 0) {
228                 // The easiest way to bubble the revert reason is using memory via assembly
229 
230                 assembly {
231                     let returndata_size := mload(returndata)
232                     revert(add(32, returndata), returndata_size)
233                 }
234             } else {
235                 revert(errorMessage);
236             }
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @title ERC721 token receiver interface
250  * @dev Interface for any contract that wants to support safeTransfers
251  * from ERC721 asset contracts.
252  */
253 interface IERC721Receiver {
254     /**
255      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
256      * by operator from from, this function is called.
257      *
258      * It must return its Solidity selector to confirm the token transfer.
259      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
260      *
261      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
262      */
263     function onERC721Received(
264         address operator,
265         address from,
266         uint256 tokenId,
267         bytes calldata data
268     ) external returns (bytes4);
269 }
270 
271 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Interface of the ERC165 standard, as defined in the
280  * https://eips.ethereum.org/EIPS/eip-165[EIP].
281  *
282  * Implementers can declare support of contract interfaces, which can then be
283  * queried by others ({ERC165Checker}).
284  *
285  * For an implementation, see {ERC165}.
286  */
287 interface IERC165 {
288     /**
289      * @dev Returns true if this contract implements the interface defined by
290      * interfaceId. See the corresponding
291      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
292      * to learn more about how these ids are created.
293      *
294      * This function call must use less than 30 000 gas.
295      */
296     function supportsInterface(bytes4 interfaceId) external view returns (bool);
297 }
298 
299 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 
307 /**
308  * @dev Implementation of the {IERC165} interface.
309  *
310  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
311  * for the additional interface id that will be supported. For example:
312  *
313  * solidity
314  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
316  * }
317  * 
318  *
319  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
320  */
321 abstract contract ERC165 is IERC165 {
322     /**
323      * @dev See {IERC165-supportsInterface}.
324      */
325     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
326         return interfaceId == type(IERC165).interfaceId;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Required interface of an ERC721 compliant contract.
340  */
341 interface IERC721 is IERC165 {
342     /**
343      * @dev Emitted when tokenId token is transferred from from to to.
344      */
345     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when owner enables approved to manage the tokenId token.
349      */
350     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
354      */
355     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
356 
357     /**
358      * @dev Returns the number of tokens in owner's account.
359      */
360     function balanceOf(address owner) external view returns (uint256 balance);
361 
362     /**
363      * @dev Returns the owner of the tokenId token.
364      *
365      * Requirements:
366      *
367      * - tokenId must exist.
368      */
369     function ownerOf(uint256 tokenId) external view returns (address owner);
370 
371     /**
372      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
373      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
374      *
375      * Requirements:
376      *
377      * - from cannot be the zero address.
378      * - to cannot be the zero address.
379      * - tokenId token must exist and be owned by from.
380      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
381      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
382      *
383      * Emits a {Transfer} event.
384      */
385     function safeTransferFrom(
386         address from,
387         address to,
388         uint256 tokenId
389     ) external;
390 
391     /**
392      * @dev Transfers tokenId token from from to to.
393      *
394      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
395      *
396      * Requirements:
397      *
398      * - from cannot be the zero address.
399      * - to cannot be the zero address.
400      * - tokenId token must be owned by from.
401      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(
406         address from,
407         address to,
408         uint256 tokenId
409     ) external;
410 
411     /**
412      * @dev Gives permission to to to transfer tokenId token to another account.
413      * The approval is cleared when the token is transferred.
414      *
415      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
416      *
417      * Requirements:
418      *
419      * - The caller must own the token or be an approved operator.
420      * - tokenId must exist.
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address to, uint256 tokenId) external;
425 
426     /**
427      * @dev Returns the account approved for tokenId token.
428      *
429      * Requirements:
430      *
431      * - tokenId must exist.
432      */
433     function getApproved(uint256 tokenId) external view returns (address operator);
434 
435     /**
436      * @dev Approve or remove operator as an operator for the caller.
437      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
438      *
439      * Requirements:
440      *
441      * - The operator cannot be the caller.
442      *
443      * Emits an {ApprovalForAll} event.
444      */
445     function setApprovalForAll(address operator, bool _approved) external;
446 
447     /**
448      * @dev Returns if the operator is allowed to manage all of the assets of owner.
449      *
450      * See {setApprovalForAll}
451      */
452     function isApprovedForAll(address owner, address operator) external view returns (bool);
453 
454     /**
455      * @dev Safely transfers tokenId token from from to to.
456      *
457      * Requirements:
458      *
459      * - from cannot be the zero address.
460      * - to cannot be the zero address.
461      * - tokenId token must exist and be owned by from.
462      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
463      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
464      *
465      * Emits a {Transfer} event.
466      */
467     function safeTransferFrom(
468         address from,
469         address to,
470         uint256 tokenId,
471         bytes calldata data
472     ) external;
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 
483 /**
484  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
485  * @dev See https://eips.ethereum.org/EIPS/eip-721
486  */
487 interface IERC721Enumerable is IERC721 {
488     /**
489      * @dev Returns the total amount of tokens stored by the contract.
490      */
491     function totalSupply() external view returns (uint256);
492 
493     /**
494      * @dev Returns a token ID owned by owner at a given index of its token list.
495      * Use along with {balanceOf} to enumerate all of owner's tokens.
496      */
497     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
498 
499     /**
500      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
501      * Use along with {totalSupply} to enumerate all tokens.
502      */
503     function tokenByIndex(uint256 index) external view returns (uint256);
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
516  * @dev See https://eips.ethereum.org/EIPS/eip-721
517  */
518 interface IERC721Metadata is IERC721 {
519     /**
520      * @dev Returns the token collection name.
521      */
522     function name() external view returns (string memory);
523 
524     /**
525      * @dev Returns the token collection symbol.
526      */
527     function symbol() external view returns (string memory);
528 
529     /**
530      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
531      */
532     function tokenURI(uint256 tokenId) external view returns (string memory);
533 }
534 
535 // File: @openzeppelin/contracts/utils/Strings.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev String operations.
544  */
545 library Strings {
546     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
547 
548     /**
549      * @dev Converts a uint256 to its ASCII string decimal representation.
550      */
551     function toString(uint256 value) internal pure returns (string memory) {
552         // Inspired by OraclizeAPI's implementation - MIT licence
553         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
554 
555         if (value == 0) {
556             return "0";
557         }
558         uint256 temp = value;
559         uint256 digits;
560         while (temp != 0) {
561             digits++;
562             temp /= 10;
563         }
564         bytes memory buffer = new bytes(digits);
565         while (value != 0) {
566             digits -= 1;
567             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
568             value /= 10;
569         }
570         return string(buffer);
571     }
572 
573     /**
574      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
575      */
576     function toHexString(uint256 value) internal pure returns (string memory) {
577         if (value == 0) {
578             return "0x00";
579         }
580         uint256 temp = value;
581         uint256 length = 0;
582         while (temp != 0) {
583             length++;
584             temp >>= 8;
585         }
586         return toHexString(value, length);
587     }
588 
589     /**
590      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
591      */
592     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
593         bytes memory buffer = new bytes(2 * length + 2);
594         buffer[0] = "0";
595         buffer[1] = "x";
596         for (uint256 i = 2 * length + 1; i > 1; --i) {
597             buffer[i] = _HEX_SYMBOLS[value & 0xf];
598             value >>= 4;
599         }
600         require(value == 0, "Strings: hex length insufficient");
601         return string(buffer);
602     }
603 }
604 
605 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Contract module that helps prevent reentrant calls to a function.
614  *
615  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
616  * available, which can be applied to functions to make sure there are no nested
617  * (reentrant) calls to them.
618  *
619  * Note that because there is a single nonReentrant guard, functions marked as
620  * nonReentrant may not call one another. This can be worked around by making
621  * those functions private, and then adding external nonReentrant entry
622  * points to them.
623  *
624  * TIP: If you would like to learn more about reentrancy and alternative ways
625  * to protect against it, check out our blog post
626  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
627  */
628 abstract contract ReentrancyGuard {
629     // Booleans are more expensive than uint256 or any type that takes up a full
630     // word because each write operation emits an extra SLOAD to first read the
631     // slot's contents, replace the bits taken up by the boolean, and then write
632     // back. This is the compiler's defense against contract upgrades and
633     // pointer aliasing, and it cannot be disabled.
634 
635     // The values being non-zero value makes deployment a bit more expensive,
636     // but in exchange the refund on every call to nonReentrant will be lower in
637     // amount. Since refunds are capped to a percentage of the total
638     // transaction's gas, it is best to keep them low in cases like this one, to
639     // increase the likelihood of the full refund coming into effect.
640     uint256 private constant _NOT_ENTERED = 1;
641     uint256 private constant _ENTERED = 2;
642 
643     uint256 private _status;
644 
645     constructor() {
646         _status = _NOT_ENTERED;
647     }
648 
649     /**
650      * @dev Prevents a contract from calling itself, directly or indirectly.
651      * Calling a nonReentrant function from another nonReentrant
652      * function is not supported. It is possible to prevent this from happening
653      * by making the nonReentrant function external, and making it call a
654      * private function that does the actual work.
655      */
656     modifier nonReentrant() {
657         // On the first call to nonReentrant, _notEntered will be true
658         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
659 
660         // Any calls to nonReentrant after this point will fail
661         _status = _ENTERED;
662 
663         _;
664 
665         // By storing the original value once again, a refund is triggered (see
666         // https://eips.ethereum.org/EIPS/eip-2200)
667         _status = _NOT_ENTERED;
668     }
669 }
670 
671 // File: @openzeppelin/contracts/utils/Context.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @dev Provides information about the current execution context, including the
680  * sender of the transaction and its data. While these are generally available
681  * via msg.sender and msg.data, they should not be accessed in such a direct
682  * manner, since when dealing with meta-transactions the account sending and
683  * paying for execution may not be the actual sender (as far as an application
684  * is concerned).
685  *
686  * This contract is only required for intermediate, library-like contracts.
687  */
688 abstract contract Context {
689     function _msgSender() internal view virtual returns (address) {
690         return msg.sender;
691     }
692 
693     function _msgData() internal view virtual returns (bytes calldata) {
694         return msg.data;
695     }
696 }
697 
698 // File: @openzeppelin/contracts/access/Ownable.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev Contract module which provides a basic access control mechanism, where
708  * there is an account (an owner) that can be granted exclusive access to
709  * specific functions.
710  *
711  * By default, the owner account will be the one that deploys the contract. This
712  * can later be changed with {transferOwnership}.
713  *
714  * This module is used through inheritance. It will make available the modifier
715  * onlyOwner, which can be applied to your functions to restrict their use to
716  * the owner.
717  */
718 abstract contract Ownable is Context {
719     address private _owner;
720 
721     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
722 
723     /**
724      * @dev Initializes the contract setting the deployer as the initial owner.
725      */
726     constructor() {
727         _transferOwnership(_msgSender());
728     }
729 
730     /**
731      * @dev Returns the address of the current owner.
732      */
733     function owner() public view virtual returns (address) {
734         return _owner;
735     }
736 
737     /**
738      * @dev Throws if called by any account other than the owner.
739      */
740     function _onlyOwner() private view {
741        require(owner() == _msgSender(), "Ownable: caller is not the owner");
742     }
743 
744     modifier onlyOwner() {
745         _onlyOwner();
746         _;
747     }
748 
749     /**
750      * @dev Leaves the contract without owner. It will not be possible to call
751      * onlyOwner functions anymore. Can only be called by the current owner.
752      *
753      * NOTE: Renouncing ownership will leave the contract without an owner,
754      * thereby removing any functionality that is only available to the owner.
755      */
756     function renounceOwnership() public virtual onlyOwner {
757         _transferOwnership(address(0));
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (newOwner).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         _transferOwnership(newOwner);
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (newOwner).
771      * Internal function without access restriction.
772      */
773     function _transferOwnership(address newOwner) internal virtual {
774         address oldOwner = _owner;
775         _owner = newOwner;
776         emit OwnershipTransferred(oldOwner, newOwner);
777     }
778 }
779 
780 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
781 pragma solidity ^0.8.9;
782 
783 interface IOperatorFilterRegistry {
784     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
785     function register(address registrant) external;
786     function registerAndSubscribe(address registrant, address subscription) external;
787     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
788     function updateOperator(address registrant, address operator, bool filtered) external;
789     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
790     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
791     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
792     function subscribe(address registrant, address registrantToSubscribe) external;
793     function unsubscribe(address registrant, bool copyExistingEntries) external;
794     function subscriptionOf(address addr) external returns (address registrant);
795     function subscribers(address registrant) external returns (address[] memory);
796     function subscriberAt(address registrant, uint256 index) external returns (address);
797     function copyEntriesOf(address registrant, address registrantToCopy) external;
798     function isOperatorFiltered(address registrant, address operator) external returns (bool);
799     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
800     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
801     function filteredOperators(address addr) external returns (address[] memory);
802     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
803     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
804     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
805     function isRegistered(address addr) external returns (bool);
806     function codeHashOf(address addr) external returns (bytes32);
807 }
808 
809 // File contracts/OperatorFilter/OperatorFilterer.sol
810 pragma solidity ^0.8.9;
811 
812 abstract contract OperatorFilterer {
813     error OperatorNotAllowed(address operator);
814 
815     IOperatorFilterRegistry constant operatorFilterRegistry =
816         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
817 
818     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
819         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
820         // will not revert, but the contract will need to be registered with the registry once it is deployed in
821         // order for the modifier to filter addresses.
822         if (address(operatorFilterRegistry).code.length > 0) {
823             if (subscribe) {
824                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
825             } else {
826                 if (subscriptionOrRegistrantToCopy != address(0)) {
827                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
828                 } else {
829                     operatorFilterRegistry.register(address(this));
830                 }
831             }
832         }
833     }
834 
835     function _onlyAllowedOperator(address from) private view {
836       if (
837           !(
838               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
839               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
840           )
841       ) {
842           revert OperatorNotAllowed(msg.sender);
843       }
844     }
845 
846     modifier onlyAllowedOperator(address from) virtual {
847         // Check registry code length to facilitate testing in environments without a deployed registry.
848         if (address(operatorFilterRegistry).code.length > 0) {
849             // Allow spending tokens from addresses with balance
850             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
851             // from an EOA.
852             if (from == msg.sender) {
853                 _;
854                 return;
855             }
856             _onlyAllowedOperator(from);
857         }
858         _;
859     }
860 
861     modifier onlyAllowedOperatorApproval(address operator) virtual {
862         _checkFilterOperator(operator);
863         _;
864     }
865 
866     function _checkFilterOperator(address operator) internal view virtual {
867         // Check registry code length to facilitate testing in environments without a deployed registry.
868         if (address(operatorFilterRegistry).code.length > 0) {
869             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
870                 revert OperatorNotAllowed(operator);
871             }
872         }
873     }
874 }
875 
876 //-------------END DEPENDENCIES------------------------//
877 
878 
879   
880 error TransactionCapExceeded();
881 error PublicMintingClosed();
882 error ExcessiveOwnedMints();
883 error MintZeroQuantity();
884 error InvalidPayment();
885 error CapExceeded();
886 error IsAlreadyUnveiled();
887 error ValueCannotBeZero();
888 error CannotBeNullAddress();
889 error NoStateChange();
890 
891 error PublicMintClosed();
892 error AllowlistMintClosed();
893 
894 error AddressNotAllowlisted();
895 error AllowlistDropTimeHasNotPassed();
896 error PublicDropTimeHasNotPassed();
897 error DropTimeNotInFuture();
898 
899 error OnlyERC20MintingEnabled();
900 error ERC20TokenNotApproved();
901 error ERC20InsufficientBalance();
902 error ERC20InsufficientAllowance();
903 error ERC20TransferFailed();
904 
905 error ClaimModeDisabled();
906 error IneligibleRedemptionContract();
907 error TokenAlreadyRedeemed();
908 error InvalidOwnerForRedemption();
909 error InvalidApprovalForRedemption();
910 
911 error ERC721RestrictedApprovalAddressRestricted();
912   
913   
914 // Rampp Contracts v2.1 (Teams.sol)
915 
916 error InvalidTeamAddress();
917 error DuplicateTeamAddress();
918 pragma solidity ^0.8.0;
919 
920 /**
921 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
922 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
923 * This will easily allow cross-collaboration via Mintplex.xyz.
924 **/
925 abstract contract Teams is Ownable{
926   mapping (address => bool) internal team;
927 
928   /**
929   * @dev Adds an address to the team. Allows them to execute protected functions
930   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
931   **/
932   function addToTeam(address _address) public onlyOwner {
933     if(_address == address(0)) revert InvalidTeamAddress();
934     if(inTeam(_address)) revert DuplicateTeamAddress();
935   
936     team[_address] = true;
937   }
938 
939   /**
940   * @dev Removes an address to the team.
941   * @param _address the ETH address to remove, cannot be 0x and must be in team
942   **/
943   function removeFromTeam(address _address) public onlyOwner {
944     if(_address == address(0)) revert InvalidTeamAddress();
945     if(!inTeam(_address)) revert InvalidTeamAddress();
946   
947     team[_address] = false;
948   }
949 
950   /**
951   * @dev Check if an address is valid and active in the team
952   * @param _address ETH address to check for truthiness
953   **/
954   function inTeam(address _address)
955     public
956     view
957     returns (bool)
958   {
959     if(_address == address(0)) revert InvalidTeamAddress();
960     return team[_address] == true;
961   }
962 
963   /**
964   * @dev Throws if called by any account other than the owner or team member.
965   */
966   function _onlyTeamOrOwner() private view {
967     bool _isOwner = owner() == _msgSender();
968     bool _isTeam = inTeam(_msgSender());
969     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
970   }
971 
972   modifier onlyTeamOrOwner() {
973     _onlyTeamOrOwner();
974     _;
975   }
976 }
977 
978 
979   
980   pragma solidity ^0.8.0;
981 
982   /**
983   * @dev These functions deal with verification of Merkle Trees proofs.
984   *
985   * The proofs can be generated using the JavaScript library
986   * https://github.com/miguelmota/merkletreejs[merkletreejs].
987   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
988   *
989   *
990   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
991   * hashing, or use a hash function other than keccak256 for hashing leaves.
992   * This is because the concatenation of a sorted pair of internal nodes in
993   * the merkle tree could be reinterpreted as a leaf value.
994   */
995   library MerkleProof {
996       /**
997       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
998       * defined by 'root'. For this, a 'proof' must be provided, containing
999       * sibling hashes on the branch from the leaf to the root of the tree. Each
1000       * pair of leaves and each pair of pre-images are assumed to be sorted.
1001       */
1002       function verify(
1003           bytes32[] memory proof,
1004           bytes32 root,
1005           bytes32 leaf
1006       ) internal pure returns (bool) {
1007           return processProof(proof, leaf) == root;
1008       }
1009 
1010       /**
1011       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1012       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1013       * hash matches the root of the tree. When processing the proof, the pairs
1014       * of leafs & pre-images are assumed to be sorted.
1015       *
1016       * _Available since v4.4._
1017       */
1018       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1019           bytes32 computedHash = leaf;
1020           for (uint256 i = 0; i < proof.length; i++) {
1021               bytes32 proofElement = proof[i];
1022               if (computedHash <= proofElement) {
1023                   // Hash(current computed hash + current element of the proof)
1024                   computedHash = _efficientHash(computedHash, proofElement);
1025               } else {
1026                   // Hash(current element of the proof + current computed hash)
1027                   computedHash = _efficientHash(proofElement, computedHash);
1028               }
1029           }
1030           return computedHash;
1031       }
1032 
1033       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1034           assembly {
1035               mstore(0x00, a)
1036               mstore(0x20, b)
1037               value := keccak256(0x00, 0x40)
1038           }
1039       }
1040   }
1041 
1042 
1043   // File: Allowlist.sol
1044 
1045   pragma solidity ^0.8.0;
1046 
1047   abstract contract Allowlist is Teams {
1048     bytes32 public merkleRoot;
1049     bool public onlyAllowlistMode = false;
1050 
1051     /**
1052      * @dev Update merkle root to reflect changes in Allowlist
1053      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1054      */
1055     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1056       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1057       merkleRoot = _newMerkleRoot;
1058     }
1059 
1060     /**
1061      * @dev Check the proof of an address if valid for merkle root
1062      * @param _to address to check for proof
1063      * @param _merkleProof Proof of the address to validate against root and leaf
1064      */
1065     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1066       if(merkleRoot == 0) revert ValueCannotBeZero();
1067       bytes32 leaf = keccak256(abi.encodePacked(_to));
1068 
1069       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1070     }
1071 
1072     
1073     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1074       onlyAllowlistMode = true;
1075     }
1076 
1077     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1078         onlyAllowlistMode = false;
1079     }
1080   }
1081   
1082   
1083 /**
1084  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1085  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1086  *
1087  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1088  * 
1089  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1090  *
1091  * Does not support burning tokens to address(0).
1092  */
1093 contract ERC721A is
1094   Context,
1095   ERC165,
1096   IERC721,
1097   IERC721Metadata,
1098   IERC721Enumerable,
1099   Teams
1100   , OperatorFilterer
1101 {
1102   using Address for address;
1103   using Strings for uint256;
1104 
1105   struct TokenOwnership {
1106     address addr;
1107     uint64 startTimestamp;
1108   }
1109 
1110   struct AddressData {
1111     uint128 balance;
1112     uint128 numberMinted;
1113   }
1114 
1115   uint256 private currentIndex;
1116 
1117   uint256 public immutable collectionSize;
1118   uint256 public maxBatchSize;
1119 
1120   // Token name
1121   string private _name;
1122 
1123   // Token symbol
1124   string private _symbol;
1125 
1126   // Mapping from token ID to ownership details
1127   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1128   mapping(uint256 => TokenOwnership) private _ownerships;
1129 
1130   // Mapping owner address to address data
1131   mapping(address => AddressData) private _addressData;
1132 
1133   // Mapping from token ID to approved address
1134   mapping(uint256 => address) private _tokenApprovals;
1135 
1136   // Mapping from owner to operator approvals
1137   mapping(address => mapping(address => bool)) private _operatorApprovals;
1138 
1139   /* @dev Mapping of restricted operator approvals set by contract Owner
1140   * This serves as an optional addition to ERC-721 so
1141   * that the contract owner can elect to prevent specific addresses/contracts
1142   * from being marked as the approver for a token. The reason for this
1143   * is that some projects may want to retain control of where their tokens can/can not be listed
1144   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1145   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1146   */
1147   mapping(address => bool) public restrictedApprovalAddresses;
1148 
1149   /**
1150    * @dev
1151    * maxBatchSize refers to how much a minter can mint at a time.
1152    * collectionSize_ refers to how many tokens are in the collection.
1153    */
1154   constructor(
1155     string memory name_,
1156     string memory symbol_,
1157     uint256 maxBatchSize_,
1158     uint256 collectionSize_
1159   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1160     require(
1161       collectionSize_ > 0,
1162       "ERC721A: collection must have a nonzero supply"
1163     );
1164     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1165     _name = name_;
1166     _symbol = symbol_;
1167     maxBatchSize = maxBatchSize_;
1168     collectionSize = collectionSize_;
1169     currentIndex = _startTokenId();
1170   }
1171 
1172   /**
1173   * To change the starting tokenId, please override this function.
1174   */
1175   function _startTokenId() internal view virtual returns (uint256) {
1176     return 1;
1177   }
1178 
1179   /**
1180    * @dev See {IERC721Enumerable-totalSupply}.
1181    */
1182   function totalSupply() public view override returns (uint256) {
1183     return _totalMinted();
1184   }
1185 
1186   function currentTokenId() public view returns (uint256) {
1187     return _totalMinted();
1188   }
1189 
1190   function getNextTokenId() public view returns (uint256) {
1191       return _totalMinted() + 1;
1192   }
1193 
1194   /**
1195   * Returns the total amount of tokens minted in the contract.
1196   */
1197   function _totalMinted() internal view returns (uint256) {
1198     unchecked {
1199       return currentIndex - _startTokenId();
1200     }
1201   }
1202 
1203   /**
1204    * @dev See {IERC721Enumerable-tokenByIndex}.
1205    */
1206   function tokenByIndex(uint256 index) public view override returns (uint256) {
1207     require(index < totalSupply(), "ERC721A: global index out of bounds");
1208     return index;
1209   }
1210 
1211   /**
1212    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1213    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1214    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1215    */
1216   function tokenOfOwnerByIndex(address owner, uint256 index)
1217     public
1218     view
1219     override
1220     returns (uint256)
1221   {
1222     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1223     uint256 numMintedSoFar = totalSupply();
1224     uint256 tokenIdsIdx = 0;
1225     address currOwnershipAddr = address(0);
1226     for (uint256 i = 0; i < numMintedSoFar; i++) {
1227       TokenOwnership memory ownership = _ownerships[i];
1228       if (ownership.addr != address(0)) {
1229         currOwnershipAddr = ownership.addr;
1230       }
1231       if (currOwnershipAddr == owner) {
1232         if (tokenIdsIdx == index) {
1233           return i;
1234         }
1235         tokenIdsIdx++;
1236       }
1237     }
1238     revert("ERC721A: unable to get token of owner by index");
1239   }
1240 
1241   /**
1242    * @dev See {IERC165-supportsInterface}.
1243    */
1244   function supportsInterface(bytes4 interfaceId)
1245     public
1246     view
1247     virtual
1248     override(ERC165, IERC165)
1249     returns (bool)
1250   {
1251     return
1252       interfaceId == type(IERC721).interfaceId ||
1253       interfaceId == type(IERC721Metadata).interfaceId ||
1254       interfaceId == type(IERC721Enumerable).interfaceId ||
1255       super.supportsInterface(interfaceId);
1256   }
1257 
1258   /**
1259    * @dev See {IERC721-balanceOf}.
1260    */
1261   function balanceOf(address owner) public view override returns (uint256) {
1262     require(owner != address(0), "ERC721A: balance query for the zero address");
1263     return uint256(_addressData[owner].balance);
1264   }
1265 
1266   function _numberMinted(address owner) internal view returns (uint256) {
1267     require(
1268       owner != address(0),
1269       "ERC721A: number minted query for the zero address"
1270     );
1271     return uint256(_addressData[owner].numberMinted);
1272   }
1273 
1274   function ownershipOf(uint256 tokenId)
1275     internal
1276     view
1277     returns (TokenOwnership memory)
1278   {
1279     uint256 curr = tokenId;
1280 
1281     unchecked {
1282         if (_startTokenId() <= curr && curr < currentIndex) {
1283             TokenOwnership memory ownership = _ownerships[curr];
1284             if (ownership.addr != address(0)) {
1285                 return ownership;
1286             }
1287 
1288             // Invariant:
1289             // There will always be an ownership that has an address and is not burned
1290             // before an ownership that does not have an address and is not burned.
1291             // Hence, curr will not underflow.
1292             while (true) {
1293                 curr--;
1294                 ownership = _ownerships[curr];
1295                 if (ownership.addr != address(0)) {
1296                     return ownership;
1297                 }
1298             }
1299         }
1300     }
1301 
1302     revert("ERC721A: unable to determine the owner of token");
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-ownerOf}.
1307    */
1308   function ownerOf(uint256 tokenId) public view override returns (address) {
1309     return ownershipOf(tokenId).addr;
1310   }
1311 
1312   /**
1313    * @dev See {IERC721Metadata-name}.
1314    */
1315   function name() public view virtual override returns (string memory) {
1316     return _name;
1317   }
1318 
1319   /**
1320    * @dev See {IERC721Metadata-symbol}.
1321    */
1322   function symbol() public view virtual override returns (string memory) {
1323     return _symbol;
1324   }
1325 
1326   /**
1327    * @dev See {IERC721Metadata-tokenURI}.
1328    */
1329   function tokenURI(uint256 tokenId)
1330     public
1331     view
1332     virtual
1333     override
1334     returns (string memory)
1335   {
1336     string memory baseURI = _baseURI();
1337     string memory extension = _baseURIExtension();
1338     return
1339       bytes(baseURI).length > 0
1340         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1341         : "";
1342   }
1343 
1344   /**
1345    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1346    * token will be the concatenation of the baseURI and the tokenId. Empty
1347    * by default, can be overriden in child contracts.
1348    */
1349   function _baseURI() internal view virtual returns (string memory) {
1350     return "";
1351   }
1352 
1353   /**
1354    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1355    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1356    * by default, can be overriden in child contracts.
1357    */
1358   function _baseURIExtension() internal view virtual returns (string memory) {
1359     return "";
1360   }
1361 
1362   /**
1363    * @dev Sets the value for an address to be in the restricted approval address pool.
1364    * Setting an address to true will disable token owners from being able to mark the address
1365    * for approval for trading. This would be used in theory to prevent token owners from listing
1366    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1367    * @param _address the marketplace/user to modify restriction status of
1368    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1369    */
1370   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1371     restrictedApprovalAddresses[_address] = _isRestricted;
1372   }
1373 
1374   /**
1375    * @dev See {IERC721-approve}.
1376    */
1377   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1378     address owner = ERC721A.ownerOf(tokenId);
1379     require(to != owner, "ERC721A: approval to current owner");
1380     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1381 
1382     require(
1383       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1384       "ERC721A: approve caller is not owner nor approved for all"
1385     );
1386 
1387     _approve(to, tokenId, owner);
1388   }
1389 
1390   /**
1391    * @dev See {IERC721-getApproved}.
1392    */
1393   function getApproved(uint256 tokenId) public view override returns (address) {
1394     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1395 
1396     return _tokenApprovals[tokenId];
1397   }
1398 
1399   /**
1400    * @dev See {IERC721-setApprovalForAll}.
1401    */
1402   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1403     require(operator != _msgSender(), "ERC721A: approve to caller");
1404     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1405 
1406     _operatorApprovals[_msgSender()][operator] = approved;
1407     emit ApprovalForAll(_msgSender(), operator, approved);
1408   }
1409 
1410   /**
1411    * @dev See {IERC721-isApprovedForAll}.
1412    */
1413   function isApprovedForAll(address owner, address operator)
1414     public
1415     view
1416     virtual
1417     override
1418     returns (bool)
1419   {
1420     return _operatorApprovals[owner][operator];
1421   }
1422 
1423   /**
1424    * @dev See {IERC721-transferFrom}.
1425    */
1426   function transferFrom(
1427     address from,
1428     address to,
1429     uint256 tokenId
1430   ) public override onlyAllowedOperator(from) {
1431     _transfer(from, to, tokenId);
1432   }
1433 
1434   /**
1435    * @dev See {IERC721-safeTransferFrom}.
1436    */
1437   function safeTransferFrom(
1438     address from,
1439     address to,
1440     uint256 tokenId
1441   ) public override onlyAllowedOperator(from) {
1442     safeTransferFrom(from, to, tokenId, "");
1443   }
1444 
1445   /**
1446    * @dev See {IERC721-safeTransferFrom}.
1447    */
1448   function safeTransferFrom(
1449     address from,
1450     address to,
1451     uint256 tokenId,
1452     bytes memory _data
1453   ) public override onlyAllowedOperator(from) {
1454     _transfer(from, to, tokenId);
1455     require(
1456       _checkOnERC721Received(from, to, tokenId, _data),
1457       "ERC721A: transfer to non ERC721Receiver implementer"
1458     );
1459   }
1460 
1461   /**
1462    * @dev Returns whether tokenId exists.
1463    *
1464    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1465    *
1466    * Tokens start existing when they are minted (_mint),
1467    */
1468   function _exists(uint256 tokenId) internal view returns (bool) {
1469     return _startTokenId() <= tokenId && tokenId < currentIndex;
1470   }
1471 
1472   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1473     _safeMint(to, quantity, isAdminMint, "");
1474   }
1475 
1476   /**
1477    * @dev Mints quantity tokens and transfers them to to.
1478    *
1479    * Requirements:
1480    *
1481    * - there must be quantity tokens remaining unminted in the total collection.
1482    * - to cannot be the zero address.
1483    * - quantity cannot be larger than the max batch size.
1484    *
1485    * Emits a {Transfer} event.
1486    */
1487   function _safeMint(
1488     address to,
1489     uint256 quantity,
1490     bool isAdminMint,
1491     bytes memory _data
1492   ) internal {
1493     uint256 startTokenId = currentIndex;
1494     require(to != address(0), "ERC721A: mint to the zero address");
1495     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1496     require(!_exists(startTokenId), "ERC721A: token already minted");
1497 
1498     // For admin mints we do not want to enforce the maxBatchSize limit
1499     if (isAdminMint == false) {
1500         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1501     }
1502 
1503     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1504 
1505     AddressData memory addressData = _addressData[to];
1506     _addressData[to] = AddressData(
1507       addressData.balance + uint128(quantity),
1508       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1509     );
1510     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1511 
1512     uint256 updatedIndex = startTokenId;
1513 
1514     for (uint256 i = 0; i < quantity; i++) {
1515       emit Transfer(address(0), to, updatedIndex);
1516       require(
1517         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1518         "ERC721A: transfer to non ERC721Receiver implementer"
1519       );
1520       updatedIndex++;
1521     }
1522 
1523     currentIndex = updatedIndex;
1524     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1525   }
1526 
1527   /**
1528    * @dev Transfers tokenId from from to to.
1529    *
1530    * Requirements:
1531    *
1532    * - to cannot be the zero address.
1533    * - tokenId token must be owned by from.
1534    *
1535    * Emits a {Transfer} event.
1536    */
1537   function _transfer(
1538     address from,
1539     address to,
1540     uint256 tokenId
1541   ) private {
1542     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1543 
1544     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1545       getApproved(tokenId) == _msgSender() ||
1546       isApprovedForAll(prevOwnership.addr, _msgSender()));
1547 
1548     require(
1549       isApprovedOrOwner,
1550       "ERC721A: transfer caller is not owner nor approved"
1551     );
1552 
1553     require(
1554       prevOwnership.addr == from,
1555       "ERC721A: transfer from incorrect owner"
1556     );
1557     require(to != address(0), "ERC721A: transfer to the zero address");
1558 
1559     _beforeTokenTransfers(from, to, tokenId, 1);
1560 
1561     // Clear approvals from the previous owner
1562     _approve(address(0), tokenId, prevOwnership.addr);
1563 
1564     _addressData[from].balance -= 1;
1565     _addressData[to].balance += 1;
1566     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1567 
1568     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1569     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1570     uint256 nextTokenId = tokenId + 1;
1571     if (_ownerships[nextTokenId].addr == address(0)) {
1572       if (_exists(nextTokenId)) {
1573         _ownerships[nextTokenId] = TokenOwnership(
1574           prevOwnership.addr,
1575           prevOwnership.startTimestamp
1576         );
1577       }
1578     }
1579 
1580     emit Transfer(from, to, tokenId);
1581     _afterTokenTransfers(from, to, tokenId, 1);
1582   }
1583 
1584   /**
1585    * @dev Approve to to operate on tokenId
1586    *
1587    * Emits a {Approval} event.
1588    */
1589   function _approve(
1590     address to,
1591     uint256 tokenId,
1592     address owner
1593   ) private {
1594     _tokenApprovals[tokenId] = to;
1595     emit Approval(owner, to, tokenId);
1596   }
1597 
1598   uint256 public nextOwnerToExplicitlySet = 0;
1599 
1600   /**
1601    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1602    */
1603   function _setOwnersExplicit(uint256 quantity) internal {
1604     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1605     require(quantity > 0, "quantity must be nonzero");
1606     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1607 
1608     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1609     if (endIndex > collectionSize - 1) {
1610       endIndex = collectionSize - 1;
1611     }
1612     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1613     require(_exists(endIndex), "not enough minted yet for this cleanup");
1614     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1615       if (_ownerships[i].addr == address(0)) {
1616         TokenOwnership memory ownership = ownershipOf(i);
1617         _ownerships[i] = TokenOwnership(
1618           ownership.addr,
1619           ownership.startTimestamp
1620         );
1621       }
1622     }
1623     nextOwnerToExplicitlySet = endIndex + 1;
1624   }
1625 
1626   /**
1627    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1628    * The call is not executed if the target address is not a contract.
1629    *
1630    * @param from address representing the previous owner of the given token ID
1631    * @param to target address that will receive the tokens
1632    * @param tokenId uint256 ID of the token to be transferred
1633    * @param _data bytes optional data to send along with the call
1634    * @return bool whether the call correctly returned the expected magic value
1635    */
1636   function _checkOnERC721Received(
1637     address from,
1638     address to,
1639     uint256 tokenId,
1640     bytes memory _data
1641   ) private returns (bool) {
1642     if (to.isContract()) {
1643       try
1644         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1645       returns (bytes4 retval) {
1646         return retval == IERC721Receiver(to).onERC721Received.selector;
1647       } catch (bytes memory reason) {
1648         if (reason.length == 0) {
1649           revert("ERC721A: transfer to non ERC721Receiver implementer");
1650         } else {
1651           assembly {
1652             revert(add(32, reason), mload(reason))
1653           }
1654         }
1655       }
1656     } else {
1657       return true;
1658     }
1659   }
1660 
1661   /**
1662    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1663    *
1664    * startTokenId - the first token id to be transferred
1665    * quantity - the amount to be transferred
1666    *
1667    * Calling conditions:
1668    *
1669    * - When from and to are both non-zero, from's tokenId will be
1670    * transferred to to.
1671    * - When from is zero, tokenId will be minted for to.
1672    */
1673   function _beforeTokenTransfers(
1674     address from,
1675     address to,
1676     uint256 startTokenId,
1677     uint256 quantity
1678   ) internal virtual {}
1679 
1680   /**
1681    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1682    * minting.
1683    *
1684    * startTokenId - the first token id to be transferred
1685    * quantity - the amount to be transferred
1686    *
1687    * Calling conditions:
1688    *
1689    * - when from and to are both non-zero.
1690    * - from and to are never both zero.
1691    */
1692   function _afterTokenTransfers(
1693     address from,
1694     address to,
1695     uint256 startTokenId,
1696     uint256 quantity
1697   ) internal virtual {}
1698 }
1699 
1700 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1701 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1702 // @notice -- See Medium article --
1703 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1704 abstract contract ERC721ARedemption is ERC721A {
1705   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1706   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1707 
1708   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1709   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1710   
1711   uint256 public redemptionSurcharge = 0 ether;
1712   bool public redemptionModeEnabled;
1713   bool public verifiedClaimModeEnabled;
1714   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1715   mapping(address => bool) public redemptionContracts;
1716   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1717 
1718   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1719   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1720     redemptionContracts[_contractAddress] = _status;
1721   }
1722 
1723   // @dev Allow owner/team to determine if contract is accepting redemption mints
1724   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1725     redemptionModeEnabled = _newStatus;
1726   }
1727 
1728   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1729   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1730     verifiedClaimModeEnabled = _newStatus;
1731   }
1732 
1733   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1734   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1735     redemptionSurcharge = _newSurchargeInWei;
1736   }
1737 
1738   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1739   // @notice Must be a wallet address or implement IERC721Receiver.
1740   // Cannot be null address as this will break any ERC-721A implementation without a proper
1741   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1742   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1743     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1744     redemptionAddress = _newRedemptionAddress;
1745   }
1746 
1747   /**
1748   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1749   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1750   * the contract owner or Team => redemptionAddress. 
1751   * @param tokenId the token to be redeemed.
1752   * Emits a {Redeemed} event.
1753   **/
1754   function redeem(address redemptionContract, uint256 tokenId) public payable {
1755     if(getNextTokenId() > collectionSize) revert CapExceeded();
1756     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1757     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1758     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1759     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1760     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1761     
1762     IERC721 _targetContract = IERC721(redemptionContract);
1763     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1764     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1765     
1766     // Warning: Since there is no standarized return value for transfers of ERC-721
1767     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1768     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1769     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1770     // but the NFT may not have been sent to the redemptionAddress.
1771     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1772     tokenRedemptions[redemptionContract][tokenId] = true;
1773 
1774     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1775     _safeMint(_msgSender(), 1, false);
1776   }
1777 
1778   /**
1779   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1780   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1781   * @param tokenId the token to be redeemed.
1782   * Emits a {VerifiedClaim} event.
1783   **/
1784   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1785     if(getNextTokenId() > collectionSize) revert CapExceeded();
1786     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1787     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1788     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1789     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1790     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1791     
1792     tokenRedemptions[redemptionContract][tokenId] = true;
1793     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1794     _safeMint(_msgSender(), 1, false);
1795   }
1796 }
1797 
1798 
1799   
1800   
1801 interface IERC20 {
1802   function allowance(address owner, address spender) external view returns (uint256);
1803   function transfer(address _to, uint256 _amount) external returns (bool);
1804   function balanceOf(address account) external view returns (uint256);
1805   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1806 }
1807 
1808 // File: WithdrawableV2
1809 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1810 // ERC-20 Payouts are limited to a single payout address. This feature 
1811 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1812 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1813 abstract contract WithdrawableV2 is Teams {
1814   struct acceptedERC20 {
1815     bool isActive;
1816     uint256 chargeAmount;
1817   }
1818 
1819   
1820   mapping(address => acceptedERC20) private allowedTokenContracts;
1821   address[] public payableAddresses = [0x8A6890494311FEd53462a63baD4d6d614f1CF950];
1822   address public erc20Payable = 0x8A6890494311FEd53462a63baD4d6d614f1CF950;
1823   uint256[] public payableFees = [100];
1824   uint256 public payableAddressCount = 1;
1825   bool public onlyERC20MintingMode;
1826   
1827 
1828   function withdrawAll() public onlyTeamOrOwner {
1829       if(address(this).balance == 0) revert ValueCannotBeZero();
1830       _withdrawAll(address(this).balance);
1831   }
1832 
1833   function _withdrawAll(uint256 balance) private {
1834       for(uint i=0; i < payableAddressCount; i++ ) {
1835           _widthdraw(
1836               payableAddresses[i],
1837               (balance * payableFees[i]) / 100
1838           );
1839       }
1840   }
1841   
1842   function _widthdraw(address _address, uint256 _amount) private {
1843       (bool success, ) = _address.call{value: _amount}("");
1844       require(success, "Transfer failed.");
1845   }
1846 
1847   /**
1848   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1849   * in the event ERC-20 tokens are paid to the contract for mints.
1850   * @param _tokenContract contract of ERC-20 token to withdraw
1851   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1852   */
1853   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1854     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1855     IERC20 tokenContract = IERC20(_tokenContract);
1856     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1857     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1858   }
1859 
1860   /**
1861   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1862   * @param _erc20TokenContract address of ERC-20 contract in question
1863   */
1864   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1865     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1866   }
1867 
1868   /**
1869   * @dev get the value of tokens to transfer for user of an ERC-20
1870   * @param _erc20TokenContract address of ERC-20 contract in question
1871   */
1872   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1873     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1874     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1875   }
1876 
1877   /**
1878   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1879   * @param _erc20TokenContract address of ERC-20 contract in question
1880   * @param _isActive default status of if contract should be allowed to accept payments
1881   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1882   */
1883   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1884     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1885     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1886   }
1887 
1888   /**
1889   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1890   * it will assume the default value of zero. This should not be used to create new payment tokens.
1891   * @param _erc20TokenContract address of ERC-20 contract in question
1892   */
1893   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1894     allowedTokenContracts[_erc20TokenContract].isActive = true;
1895   }
1896 
1897   /**
1898   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1899   * it will assume the default value of zero. This should not be used to create new payment tokens.
1900   * @param _erc20TokenContract address of ERC-20 contract in question
1901   */
1902   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1903     allowedTokenContracts[_erc20TokenContract].isActive = false;
1904   }
1905 
1906   /**
1907   * @dev Enable only ERC-20 payments for minting on this contract
1908   */
1909   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1910     onlyERC20MintingMode = true;
1911   }
1912 
1913   /**
1914   * @dev Disable only ERC-20 payments for minting on this contract
1915   */
1916   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1917     onlyERC20MintingMode = false;
1918   }
1919 
1920   /**
1921   * @dev Set the payout of the ERC-20 token payout to a specific address
1922   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1923   */
1924   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1925     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1926     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1927     erc20Payable = _newErc20Payable;
1928   }
1929 }
1930 
1931 
1932   
1933 // File: isFeeable.sol
1934 abstract contract Feeable is Teams {
1935   uint256 public PRICE = 0 ether;
1936 
1937   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1938     PRICE = _feeInWei;
1939   }
1940 
1941   function getPrice(uint256 _count) public view returns (uint256) {
1942     return PRICE * _count;
1943   }
1944 }
1945 
1946   
1947   
1948   
1949 abstract contract RamppERC721A is 
1950     Ownable,
1951     Teams,
1952     ERC721ARedemption,
1953     WithdrawableV2,
1954     ReentrancyGuard 
1955     , Feeable 
1956     , Allowlist 
1957     
1958 {
1959   constructor(
1960     string memory tokenName,
1961     string memory tokenSymbol
1962   ) ERC721A(tokenName, tokenSymbol, 1, 2222) { }
1963     uint8 constant public CONTRACT_VERSION = 2;
1964     string public _baseTokenURI = "ipfs://bafybeic2axvy6inwc2ofzctil5on4nlscbhzgtgo4wyc7v3xzoybbxwcyi/";
1965     string public _baseTokenExtension = ".json";
1966 
1967     bool public mintingOpen = false;
1968     
1969     
1970     uint256 public MAX_WALLET_MINTS = 1;
1971 
1972   
1973     /////////////// Admin Mint Functions
1974     /**
1975      * @dev Mints a token to an address with a tokenURI.
1976      * This is owner only and allows a fee-free drop
1977      * @param _to address of the future owner of the token
1978      * @param _qty amount of tokens to drop the owner
1979      */
1980      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1981          if(_qty == 0) revert MintZeroQuantity();
1982          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1983          _safeMint(_to, _qty, true);
1984      }
1985 
1986   
1987     /////////////// PUBLIC MINT FUNCTIONS
1988     /**
1989     * @dev Mints tokens to an address in batch.
1990     * fee may or may not be required*
1991     * @param _to address of the future owner of the token
1992     * @param _amount number of tokens to mint
1993     */
1994     function mintToMultiple(address _to, uint256 _amount) public payable {
1995         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1996         if(_amount == 0) revert MintZeroQuantity();
1997         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1998         if(!mintingOpen) revert PublicMintClosed();
1999         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2000         
2001         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2002         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2003         if(msg.value != getPrice(_amount)) revert InvalidPayment();
2004 
2005         _safeMint(_to, _amount, false);
2006     }
2007 
2008     /**
2009      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2010      * fee may or may not be required*
2011      * @param _to address of the future owner of the token
2012      * @param _amount number of tokens to mint
2013      * @param _erc20TokenContract erc-20 token contract to mint with
2014      */
2015     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2016       if(_amount == 0) revert MintZeroQuantity();
2017       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2018       if(!mintingOpen) revert PublicMintClosed();
2019       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2020       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2021       
2022       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2023 
2024       // ERC-20 Specific pre-flight checks
2025       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2026       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2027       IERC20 payableToken = IERC20(_erc20TokenContract);
2028 
2029       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2030       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2031 
2032       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2033       if(!transferComplete) revert ERC20TransferFailed();
2034       
2035       _safeMint(_to, _amount, false);
2036     }
2037 
2038     function openMinting() public onlyTeamOrOwner {
2039         mintingOpen = true;
2040     }
2041 
2042     function stopMinting() public onlyTeamOrOwner {
2043         mintingOpen = false;
2044     }
2045 
2046   
2047     ///////////// ALLOWLIST MINTING FUNCTIONS
2048     /**
2049     * @dev Mints tokens to an address using an allowlist.
2050     * fee may or may not be required*
2051     * @param _to address of the future owner of the token
2052     * @param _amount number of tokens to mint
2053     * @param _merkleProof merkle proof array
2054     */
2055     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2056         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2057         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2058         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2059         if(_amount == 0) revert MintZeroQuantity();
2060         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2061         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2062         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2063         if(msg.value != getPrice(_amount)) revert InvalidPayment();
2064         
2065 
2066         _safeMint(_to, _amount, false);
2067     }
2068 
2069     /**
2070     * @dev Mints tokens to an address using an allowlist.
2071     * fee may or may not be required*
2072     * @param _to address of the future owner of the token
2073     * @param _amount number of tokens to mint
2074     * @param _merkleProof merkle proof array
2075     * @param _erc20TokenContract erc-20 token contract to mint with
2076     */
2077     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2078       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2079       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2080       if(_amount == 0) revert MintZeroQuantity();
2081       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2082       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2083       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2084       
2085     
2086       // ERC-20 Specific pre-flight checks
2087       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2088       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2089       IERC20 payableToken = IERC20(_erc20TokenContract);
2090 
2091       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2092       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2093 
2094       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2095       if(!transferComplete) revert ERC20TransferFailed();
2096       
2097       _safeMint(_to, _amount, false);
2098     }
2099 
2100     /**
2101      * @dev Enable allowlist minting fully by enabling both flags
2102      * This is a convenience function for the Rampp user
2103      */
2104     function openAllowlistMint() public onlyTeamOrOwner {
2105         enableAllowlistOnlyMode();
2106         mintingOpen = true;
2107     }
2108 
2109     /**
2110      * @dev Close allowlist minting fully by disabling both flags
2111      * This is a convenience function for the Rampp user
2112      */
2113     function closeAllowlistMint() public onlyTeamOrOwner {
2114         disableAllowlistOnlyMode();
2115         mintingOpen = false;
2116     }
2117 
2118 
2119   
2120     /**
2121     * @dev Check if wallet over MAX_WALLET_MINTS
2122     * @param _address address in question to check if minted count exceeds max
2123     */
2124     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2125         if(_amount == 0) revert ValueCannotBeZero();
2126         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2127     }
2128 
2129     /**
2130     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2131     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2132     */
2133     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2134         if(_newWalletMax == 0) revert ValueCannotBeZero();
2135         MAX_WALLET_MINTS = _newWalletMax;
2136     }
2137     
2138 
2139   
2140     /**
2141      * @dev Allows owner to set Max mints per tx
2142      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2143      */
2144      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2145          if(_newMaxMint == 0) revert ValueCannotBeZero();
2146          maxBatchSize = _newMaxMint;
2147      }
2148     
2149 
2150   
2151   
2152   
2153   function contractURI() public pure returns (string memory) {
2154     return "https://metadata.mintplex.xyz/0o3UkTUwKx5h4Df4RdEq/contract-metadata";
2155   }
2156   
2157 
2158   function _baseURI() internal view virtual override returns(string memory) {
2159     return _baseTokenURI;
2160   }
2161 
2162   function _baseURIExtension() internal view virtual override returns(string memory) {
2163     return _baseTokenExtension;
2164   }
2165 
2166   function baseTokenURI() public view returns(string memory) {
2167     return _baseTokenURI;
2168   }
2169 
2170   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2171     _baseTokenURI = baseURI;
2172   }
2173 
2174   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2175     _baseTokenExtension = baseExtension;
2176   }
2177 }
2178 
2179 
2180   
2181 // File: contracts/MeowlandContract.sol
2182 //SPDX-License-Identifier: MIT
2183 
2184 pragma solidity ^0.8.0;
2185 
2186 contract MeowlandContract is RamppERC721A {
2187     constructor() RamppERC721A("MEOWLAND", "Meow"){}
2188 }
2189   
2190 //*********************************************************************//
2191 //*********************************************************************//  
2192 //                       Mintplex v3.0.0
2193 //
2194 //         This smart contract was generated by mintplex.xyz.
2195 //            Mintplex allows creators like you to launch 
2196 //             large scale NFT communities without code!
2197 //
2198 //    Mintplex is not responsible for the content of this contract and
2199 //        hopes it is being used in a responsible and kind way.  
2200 //       Mintplex is not associated or affiliated with this project.                                                    
2201 //             Twitter: @MintplexNFT ---- mintplex.xyz
2202 //*********************************************************************//                                                     
2203 //*********************************************************************// 
