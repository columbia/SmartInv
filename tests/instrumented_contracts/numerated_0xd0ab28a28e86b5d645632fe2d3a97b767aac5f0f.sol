1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //    ____             __   _          
5 //    / __ )_________  / /__(_)__  _____
6 //   / __  / ___/ __ \/ //_/ / _ \/ ___/
7 //  / /_/ / /  / /_/ / ,< / /  __(__  ) 
8 // /_____/_/   \____/_/|_/_/\___/____/  
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
980   
981 /**
982  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
983  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
984  *
985  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
986  * 
987  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
988  *
989  * Does not support burning tokens to address(0).
990  */
991 contract ERC721A is
992   Context,
993   ERC165,
994   IERC721,
995   IERC721Metadata,
996   IERC721Enumerable,
997   Teams
998   , OperatorFilterer
999 {
1000   using Address for address;
1001   using Strings for uint256;
1002 
1003   struct TokenOwnership {
1004     address addr;
1005     uint64 startTimestamp;
1006   }
1007 
1008   struct AddressData {
1009     uint128 balance;
1010     uint128 numberMinted;
1011   }
1012 
1013   uint256 private currentIndex;
1014 
1015   uint256 public immutable collectionSize;
1016   uint256 public maxBatchSize;
1017 
1018   // Token name
1019   string private _name;
1020 
1021   // Token symbol
1022   string private _symbol;
1023 
1024   // Mapping from token ID to ownership details
1025   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1026   mapping(uint256 => TokenOwnership) private _ownerships;
1027 
1028   // Mapping owner address to address data
1029   mapping(address => AddressData) private _addressData;
1030 
1031   // Mapping from token ID to approved address
1032   mapping(uint256 => address) private _tokenApprovals;
1033 
1034   // Mapping from owner to operator approvals
1035   mapping(address => mapping(address => bool)) private _operatorApprovals;
1036 
1037   /* @dev Mapping of restricted operator approvals set by contract Owner
1038   * This serves as an optional addition to ERC-721 so
1039   * that the contract owner can elect to prevent specific addresses/contracts
1040   * from being marked as the approver for a token. The reason for this
1041   * is that some projects may want to retain control of where their tokens can/can not be listed
1042   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1043   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1044   */
1045   mapping(address => bool) public restrictedApprovalAddresses;
1046 
1047   /**
1048    * @dev
1049    * maxBatchSize refers to how much a minter can mint at a time.
1050    * collectionSize_ refers to how many tokens are in the collection.
1051    */
1052   constructor(
1053     string memory name_,
1054     string memory symbol_,
1055     uint256 maxBatchSize_,
1056     uint256 collectionSize_
1057   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1058     require(
1059       collectionSize_ > 0,
1060       "ERC721A: collection must have a nonzero supply"
1061     );
1062     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1063     _name = name_;
1064     _symbol = symbol_;
1065     maxBatchSize = maxBatchSize_;
1066     collectionSize = collectionSize_;
1067     currentIndex = _startTokenId();
1068   }
1069 
1070   /**
1071   * To change the starting tokenId, please override this function.
1072   */
1073   function _startTokenId() internal view virtual returns (uint256) {
1074     return 1;
1075   }
1076 
1077   /**
1078    * @dev See {IERC721Enumerable-totalSupply}.
1079    */
1080   function totalSupply() public view override returns (uint256) {
1081     return _totalMinted();
1082   }
1083 
1084   function currentTokenId() public view returns (uint256) {
1085     return _totalMinted();
1086   }
1087 
1088   function getNextTokenId() public view returns (uint256) {
1089       return _totalMinted() + 1;
1090   }
1091 
1092   /**
1093   * Returns the total amount of tokens minted in the contract.
1094   */
1095   function _totalMinted() internal view returns (uint256) {
1096     unchecked {
1097       return currentIndex - _startTokenId();
1098     }
1099   }
1100 
1101   /**
1102    * @dev See {IERC721Enumerable-tokenByIndex}.
1103    */
1104   function tokenByIndex(uint256 index) public view override returns (uint256) {
1105     require(index < totalSupply(), "ERC721A: global index out of bounds");
1106     return index;
1107   }
1108 
1109   /**
1110    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1111    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1112    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1113    */
1114   function tokenOfOwnerByIndex(address owner, uint256 index)
1115     public
1116     view
1117     override
1118     returns (uint256)
1119   {
1120     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1121     uint256 numMintedSoFar = totalSupply();
1122     uint256 tokenIdsIdx = 0;
1123     address currOwnershipAddr = address(0);
1124     for (uint256 i = 0; i < numMintedSoFar; i++) {
1125       TokenOwnership memory ownership = _ownerships[i];
1126       if (ownership.addr != address(0)) {
1127         currOwnershipAddr = ownership.addr;
1128       }
1129       if (currOwnershipAddr == owner) {
1130         if (tokenIdsIdx == index) {
1131           return i;
1132         }
1133         tokenIdsIdx++;
1134       }
1135     }
1136     revert("ERC721A: unable to get token of owner by index");
1137   }
1138 
1139   /**
1140    * @dev See {IERC165-supportsInterface}.
1141    */
1142   function supportsInterface(bytes4 interfaceId)
1143     public
1144     view
1145     virtual
1146     override(ERC165, IERC165)
1147     returns (bool)
1148   {
1149     return
1150       interfaceId == type(IERC721).interfaceId ||
1151       interfaceId == type(IERC721Metadata).interfaceId ||
1152       interfaceId == type(IERC721Enumerable).interfaceId ||
1153       super.supportsInterface(interfaceId);
1154   }
1155 
1156   /**
1157    * @dev See {IERC721-balanceOf}.
1158    */
1159   function balanceOf(address owner) public view override returns (uint256) {
1160     require(owner != address(0), "ERC721A: balance query for the zero address");
1161     return uint256(_addressData[owner].balance);
1162   }
1163 
1164   function _numberMinted(address owner) internal view returns (uint256) {
1165     require(
1166       owner != address(0),
1167       "ERC721A: number minted query for the zero address"
1168     );
1169     return uint256(_addressData[owner].numberMinted);
1170   }
1171 
1172   function ownershipOf(uint256 tokenId)
1173     internal
1174     view
1175     returns (TokenOwnership memory)
1176   {
1177     uint256 curr = tokenId;
1178 
1179     unchecked {
1180         if (_startTokenId() <= curr && curr < currentIndex) {
1181             TokenOwnership memory ownership = _ownerships[curr];
1182             if (ownership.addr != address(0)) {
1183                 return ownership;
1184             }
1185 
1186             // Invariant:
1187             // There will always be an ownership that has an address and is not burned
1188             // before an ownership that does not have an address and is not burned.
1189             // Hence, curr will not underflow.
1190             while (true) {
1191                 curr--;
1192                 ownership = _ownerships[curr];
1193                 if (ownership.addr != address(0)) {
1194                     return ownership;
1195                 }
1196             }
1197         }
1198     }
1199 
1200     revert("ERC721A: unable to determine the owner of token");
1201   }
1202 
1203   /**
1204    * @dev See {IERC721-ownerOf}.
1205    */
1206   function ownerOf(uint256 tokenId) public view override returns (address) {
1207     return ownershipOf(tokenId).addr;
1208   }
1209 
1210   /**
1211    * @dev See {IERC721Metadata-name}.
1212    */
1213   function name() public view virtual override returns (string memory) {
1214     return _name;
1215   }
1216 
1217   /**
1218    * @dev See {IERC721Metadata-symbol}.
1219    */
1220   function symbol() public view virtual override returns (string memory) {
1221     return _symbol;
1222   }
1223 
1224   /**
1225    * @dev See {IERC721Metadata-tokenURI}.
1226    */
1227   function tokenURI(uint256 tokenId)
1228     public
1229     view
1230     virtual
1231     override
1232     returns (string memory)
1233   {
1234     string memory baseURI = _baseURI();
1235     string memory extension = _baseURIExtension();
1236     return
1237       bytes(baseURI).length > 0
1238         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1239         : "";
1240   }
1241 
1242   /**
1243    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1244    * token will be the concatenation of the baseURI and the tokenId. Empty
1245    * by default, can be overriden in child contracts.
1246    */
1247   function _baseURI() internal view virtual returns (string memory) {
1248     return "";
1249   }
1250 
1251   /**
1252    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1253    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1254    * by default, can be overriden in child contracts.
1255    */
1256   function _baseURIExtension() internal view virtual returns (string memory) {
1257     return "";
1258   }
1259 
1260   /**
1261    * @dev Sets the value for an address to be in the restricted approval address pool.
1262    * Setting an address to true will disable token owners from being able to mark the address
1263    * for approval for trading. This would be used in theory to prevent token owners from listing
1264    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1265    * @param _address the marketplace/user to modify restriction status of
1266    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1267    */
1268   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1269     restrictedApprovalAddresses[_address] = _isRestricted;
1270   }
1271 
1272   /**
1273    * @dev See {IERC721-approve}.
1274    */
1275   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1276     address owner = ERC721A.ownerOf(tokenId);
1277     require(to != owner, "ERC721A: approval to current owner");
1278     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1279 
1280     require(
1281       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1282       "ERC721A: approve caller is not owner nor approved for all"
1283     );
1284 
1285     _approve(to, tokenId, owner);
1286   }
1287 
1288   /**
1289    * @dev See {IERC721-getApproved}.
1290    */
1291   function getApproved(uint256 tokenId) public view override returns (address) {
1292     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1293 
1294     return _tokenApprovals[tokenId];
1295   }
1296 
1297   /**
1298    * @dev See {IERC721-setApprovalForAll}.
1299    */
1300   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1301     require(operator != _msgSender(), "ERC721A: approve to caller");
1302     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1303 
1304     _operatorApprovals[_msgSender()][operator] = approved;
1305     emit ApprovalForAll(_msgSender(), operator, approved);
1306   }
1307 
1308   /**
1309    * @dev See {IERC721-isApprovedForAll}.
1310    */
1311   function isApprovedForAll(address owner, address operator)
1312     public
1313     view
1314     virtual
1315     override
1316     returns (bool)
1317   {
1318     return _operatorApprovals[owner][operator];
1319   }
1320 
1321   /**
1322    * @dev See {IERC721-transferFrom}.
1323    */
1324   function transferFrom(
1325     address from,
1326     address to,
1327     uint256 tokenId
1328   ) public override onlyAllowedOperator(from) {
1329     _transfer(from, to, tokenId);
1330   }
1331 
1332   /**
1333    * @dev See {IERC721-safeTransferFrom}.
1334    */
1335   function safeTransferFrom(
1336     address from,
1337     address to,
1338     uint256 tokenId
1339   ) public override onlyAllowedOperator(from) {
1340     safeTransferFrom(from, to, tokenId, "");
1341   }
1342 
1343   /**
1344    * @dev See {IERC721-safeTransferFrom}.
1345    */
1346   function safeTransferFrom(
1347     address from,
1348     address to,
1349     uint256 tokenId,
1350     bytes memory _data
1351   ) public override onlyAllowedOperator(from) {
1352     _transfer(from, to, tokenId);
1353     require(
1354       _checkOnERC721Received(from, to, tokenId, _data),
1355       "ERC721A: transfer to non ERC721Receiver implementer"
1356     );
1357   }
1358 
1359   /**
1360    * @dev Returns whether tokenId exists.
1361    *
1362    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1363    *
1364    * Tokens start existing when they are minted (_mint),
1365    */
1366   function _exists(uint256 tokenId) internal view returns (bool) {
1367     return _startTokenId() <= tokenId && tokenId < currentIndex;
1368   }
1369 
1370   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1371     _safeMint(to, quantity, isAdminMint, "");
1372   }
1373 
1374   /**
1375    * @dev Mints quantity tokens and transfers them to to.
1376    *
1377    * Requirements:
1378    *
1379    * - there must be quantity tokens remaining unminted in the total collection.
1380    * - to cannot be the zero address.
1381    * - quantity cannot be larger than the max batch size.
1382    *
1383    * Emits a {Transfer} event.
1384    */
1385   function _safeMint(
1386     address to,
1387     uint256 quantity,
1388     bool isAdminMint,
1389     bytes memory _data
1390   ) internal {
1391     uint256 startTokenId = currentIndex;
1392     require(to != address(0), "ERC721A: mint to the zero address");
1393     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1394     require(!_exists(startTokenId), "ERC721A: token already minted");
1395 
1396     // For admin mints we do not want to enforce the maxBatchSize limit
1397     if (isAdminMint == false) {
1398         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1399     }
1400 
1401     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1402 
1403     AddressData memory addressData = _addressData[to];
1404     _addressData[to] = AddressData(
1405       addressData.balance + uint128(quantity),
1406       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1407     );
1408     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1409 
1410     uint256 updatedIndex = startTokenId;
1411 
1412     for (uint256 i = 0; i < quantity; i++) {
1413       emit Transfer(address(0), to, updatedIndex);
1414       require(
1415         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1416         "ERC721A: transfer to non ERC721Receiver implementer"
1417       );
1418       updatedIndex++;
1419     }
1420 
1421     currentIndex = updatedIndex;
1422     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1423   }
1424 
1425   /**
1426    * @dev Transfers tokenId from from to to.
1427    *
1428    * Requirements:
1429    *
1430    * - to cannot be the zero address.
1431    * - tokenId token must be owned by from.
1432    *
1433    * Emits a {Transfer} event.
1434    */
1435   function _transfer(
1436     address from,
1437     address to,
1438     uint256 tokenId
1439   ) private {
1440     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1441 
1442     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1443       getApproved(tokenId) == _msgSender() ||
1444       isApprovedForAll(prevOwnership.addr, _msgSender()));
1445 
1446     require(
1447       isApprovedOrOwner,
1448       "ERC721A: transfer caller is not owner nor approved"
1449     );
1450 
1451     require(
1452       prevOwnership.addr == from,
1453       "ERC721A: transfer from incorrect owner"
1454     );
1455     require(to != address(0), "ERC721A: transfer to the zero address");
1456 
1457     _beforeTokenTransfers(from, to, tokenId, 1);
1458 
1459     // Clear approvals from the previous owner
1460     _approve(address(0), tokenId, prevOwnership.addr);
1461 
1462     _addressData[from].balance -= 1;
1463     _addressData[to].balance += 1;
1464     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1465 
1466     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1467     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1468     uint256 nextTokenId = tokenId + 1;
1469     if (_ownerships[nextTokenId].addr == address(0)) {
1470       if (_exists(nextTokenId)) {
1471         _ownerships[nextTokenId] = TokenOwnership(
1472           prevOwnership.addr,
1473           prevOwnership.startTimestamp
1474         );
1475       }
1476     }
1477 
1478     emit Transfer(from, to, tokenId);
1479     _afterTokenTransfers(from, to, tokenId, 1);
1480   }
1481 
1482   /**
1483    * @dev Approve to to operate on tokenId
1484    *
1485    * Emits a {Approval} event.
1486    */
1487   function _approve(
1488     address to,
1489     uint256 tokenId,
1490     address owner
1491   ) private {
1492     _tokenApprovals[tokenId] = to;
1493     emit Approval(owner, to, tokenId);
1494   }
1495 
1496   uint256 public nextOwnerToExplicitlySet = 0;
1497 
1498   /**
1499    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1500    */
1501   function _setOwnersExplicit(uint256 quantity) internal {
1502     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1503     require(quantity > 0, "quantity must be nonzero");
1504     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1505 
1506     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1507     if (endIndex > collectionSize - 1) {
1508       endIndex = collectionSize - 1;
1509     }
1510     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1511     require(_exists(endIndex), "not enough minted yet for this cleanup");
1512     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1513       if (_ownerships[i].addr == address(0)) {
1514         TokenOwnership memory ownership = ownershipOf(i);
1515         _ownerships[i] = TokenOwnership(
1516           ownership.addr,
1517           ownership.startTimestamp
1518         );
1519       }
1520     }
1521     nextOwnerToExplicitlySet = endIndex + 1;
1522   }
1523 
1524   /**
1525    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1526    * The call is not executed if the target address is not a contract.
1527    *
1528    * @param from address representing the previous owner of the given token ID
1529    * @param to target address that will receive the tokens
1530    * @param tokenId uint256 ID of the token to be transferred
1531    * @param _data bytes optional data to send along with the call
1532    * @return bool whether the call correctly returned the expected magic value
1533    */
1534   function _checkOnERC721Received(
1535     address from,
1536     address to,
1537     uint256 tokenId,
1538     bytes memory _data
1539   ) private returns (bool) {
1540     if (to.isContract()) {
1541       try
1542         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1543       returns (bytes4 retval) {
1544         return retval == IERC721Receiver(to).onERC721Received.selector;
1545       } catch (bytes memory reason) {
1546         if (reason.length == 0) {
1547           revert("ERC721A: transfer to non ERC721Receiver implementer");
1548         } else {
1549           assembly {
1550             revert(add(32, reason), mload(reason))
1551           }
1552         }
1553       }
1554     } else {
1555       return true;
1556     }
1557   }
1558 
1559   /**
1560    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1561    *
1562    * startTokenId - the first token id to be transferred
1563    * quantity - the amount to be transferred
1564    *
1565    * Calling conditions:
1566    *
1567    * - When from and to are both non-zero, from's tokenId will be
1568    * transferred to to.
1569    * - When from is zero, tokenId will be minted for to.
1570    */
1571   function _beforeTokenTransfers(
1572     address from,
1573     address to,
1574     uint256 startTokenId,
1575     uint256 quantity
1576   ) internal virtual {}
1577 
1578   /**
1579    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1580    * minting.
1581    *
1582    * startTokenId - the first token id to be transferred
1583    * quantity - the amount to be transferred
1584    *
1585    * Calling conditions:
1586    *
1587    * - when from and to are both non-zero.
1588    * - from and to are never both zero.
1589    */
1590   function _afterTokenTransfers(
1591     address from,
1592     address to,
1593     uint256 startTokenId,
1594     uint256 quantity
1595   ) internal virtual {}
1596 }
1597 
1598 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1599 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1600 // @notice -- See Medium article --
1601 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1602 abstract contract ERC721ARedemption is ERC721A {
1603   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1604   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1605 
1606   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1607   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1608   
1609   uint256 public redemptionSurcharge = 0 ether;
1610   bool public redemptionModeEnabled;
1611   bool public verifiedClaimModeEnabled;
1612   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1613   mapping(address => bool) public redemptionContracts;
1614   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1615 
1616   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1617   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1618     redemptionContracts[_contractAddress] = _status;
1619   }
1620 
1621   // @dev Allow owner/team to determine if contract is accepting redemption mints
1622   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1623     redemptionModeEnabled = _newStatus;
1624   }
1625 
1626   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1627   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1628     verifiedClaimModeEnabled = _newStatus;
1629   }
1630 
1631   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1632   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1633     redemptionSurcharge = _newSurchargeInWei;
1634   }
1635 
1636   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1637   // @notice Must be a wallet address or implement IERC721Receiver.
1638   // Cannot be null address as this will break any ERC-721A implementation without a proper
1639   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1640   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1641     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1642     redemptionAddress = _newRedemptionAddress;
1643   }
1644 
1645   /**
1646   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1647   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1648   * the contract owner or Team => redemptionAddress. 
1649   * @param tokenId the token to be redeemed.
1650   * Emits a {Redeemed} event.
1651   **/
1652   function redeem(address redemptionContract, uint256 tokenId) public payable {
1653     if(getNextTokenId() > collectionSize) revert CapExceeded();
1654     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1655     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1656     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1657     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1658     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1659     
1660     IERC721 _targetContract = IERC721(redemptionContract);
1661     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1662     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1663     
1664     // Warning: Since there is no standarized return value for transfers of ERC-721
1665     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1666     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1667     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1668     // but the NFT may not have been sent to the redemptionAddress.
1669     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1670     tokenRedemptions[redemptionContract][tokenId] = true;
1671 
1672     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1673     _safeMint(_msgSender(), 1, false);
1674   }
1675 
1676   /**
1677   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1678   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1679   * @param tokenId the token to be redeemed.
1680   * Emits a {VerifiedClaim} event.
1681   **/
1682   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1683     if(getNextTokenId() > collectionSize) revert CapExceeded();
1684     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1685     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1686     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1687     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1688     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1689     
1690     tokenRedemptions[redemptionContract][tokenId] = true;
1691     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1692     _safeMint(_msgSender(), 1, false);
1693   }
1694 }
1695 
1696 
1697   
1698   
1699 interface IERC20 {
1700   function allowance(address owner, address spender) external view returns (uint256);
1701   function transfer(address _to, uint256 _amount) external returns (bool);
1702   function balanceOf(address account) external view returns (uint256);
1703   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1704 }
1705 
1706 // File: WithdrawableV2
1707 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1708 // ERC-20 Payouts are limited to a single payout address. This feature 
1709 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1710 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1711 abstract contract WithdrawableV2 is Teams {
1712   struct acceptedERC20 {
1713     bool isActive;
1714     uint256 chargeAmount;
1715   }
1716 
1717   
1718   mapping(address => acceptedERC20) private allowedTokenContracts;
1719   address[] public payableAddresses = [0x3d404bfaf8FF3f77df2e0026172D3dA86C22D826];
1720   address public erc20Payable = 0x3d404bfaf8FF3f77df2e0026172D3dA86C22D826;
1721   uint256[] public payableFees = [100];
1722   uint256 public payableAddressCount = 1;
1723   bool public onlyERC20MintingMode;
1724   
1725 
1726   function withdrawAll() public onlyTeamOrOwner {
1727       if(address(this).balance == 0) revert ValueCannotBeZero();
1728       _withdrawAll(address(this).balance);
1729   }
1730 
1731   function _withdrawAll(uint256 balance) private {
1732       for(uint i=0; i < payableAddressCount; i++ ) {
1733           _widthdraw(
1734               payableAddresses[i],
1735               (balance * payableFees[i]) / 100
1736           );
1737       }
1738   }
1739   
1740   function _widthdraw(address _address, uint256 _amount) private {
1741       (bool success, ) = _address.call{value: _amount}("");
1742       require(success, "Transfer failed.");
1743   }
1744 
1745   /**
1746   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1747   * in the event ERC-20 tokens are paid to the contract for mints.
1748   * @param _tokenContract contract of ERC-20 token to withdraw
1749   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1750   */
1751   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1752     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1753     IERC20 tokenContract = IERC20(_tokenContract);
1754     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1755     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1756   }
1757 
1758   /**
1759   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1760   * @param _erc20TokenContract address of ERC-20 contract in question
1761   */
1762   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1763     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1764   }
1765 
1766   /**
1767   * @dev get the value of tokens to transfer for user of an ERC-20
1768   * @param _erc20TokenContract address of ERC-20 contract in question
1769   */
1770   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1771     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1772     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1773   }
1774 
1775   /**
1776   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1777   * @param _erc20TokenContract address of ERC-20 contract in question
1778   * @param _isActive default status of if contract should be allowed to accept payments
1779   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1780   */
1781   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1782     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1783     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1784   }
1785 
1786   /**
1787   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1788   * it will assume the default value of zero. This should not be used to create new payment tokens.
1789   * @param _erc20TokenContract address of ERC-20 contract in question
1790   */
1791   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1792     allowedTokenContracts[_erc20TokenContract].isActive = true;
1793   }
1794 
1795   /**
1796   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1797   * it will assume the default value of zero. This should not be used to create new payment tokens.
1798   * @param _erc20TokenContract address of ERC-20 contract in question
1799   */
1800   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1801     allowedTokenContracts[_erc20TokenContract].isActive = false;
1802   }
1803 
1804   /**
1805   * @dev Enable only ERC-20 payments for minting on this contract
1806   */
1807   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1808     onlyERC20MintingMode = true;
1809   }
1810 
1811   /**
1812   * @dev Disable only ERC-20 payments for minting on this contract
1813   */
1814   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1815     onlyERC20MintingMode = false;
1816   }
1817 
1818   /**
1819   * @dev Set the payout of the ERC-20 token payout to a specific address
1820   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1821   */
1822   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1823     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1824     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1825     erc20Payable = _newErc20Payable;
1826   }
1827 }
1828 
1829 
1830   
1831   
1832 // File: EarlyMintIncentive.sol
1833 // Allows the contract to have the first x tokens have a discount or
1834 // zero fee that can be calculated on the fly.
1835 abstract contract EarlyMintIncentive is Teams, ERC721A {
1836   uint256 public PRICE = 0.0055 ether;
1837   uint256 public EARLY_MINT_PRICE = 0 ether;
1838   uint256 public earlyMintTokenIdCap = 505;
1839   bool public usingEarlyMintIncentive = true;
1840 
1841   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1842     usingEarlyMintIncentive = true;
1843   }
1844 
1845   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1846     usingEarlyMintIncentive = false;
1847   }
1848 
1849   /**
1850   * @dev Set the max token ID in which the cost incentive will be applied.
1851   * @param _newTokenIdCap max tokenId in which incentive will be applied
1852   */
1853   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1854     if(_newTokenIdCap > collectionSize) revert CapExceeded();
1855     if(_newTokenIdCap == 0) revert ValueCannotBeZero();
1856     earlyMintTokenIdCap = _newTokenIdCap;
1857   }
1858 
1859   /**
1860   * @dev Set the incentive mint price
1861   * @param _feeInWei new price per token when in incentive range
1862   */
1863   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1864     EARLY_MINT_PRICE = _feeInWei;
1865   }
1866 
1867   /**
1868   * @dev Set the primary mint price - the base price when not under incentive
1869   * @param _feeInWei new price per token
1870   */
1871   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1872     PRICE = _feeInWei;
1873   }
1874 
1875   function getPrice(uint256 _count) public view returns (uint256) {
1876     if(_count == 0) revert ValueCannotBeZero();
1877 
1878     // short circuit function if we dont need to even calc incentive pricing
1879     // short circuit if the current tokenId is also already over cap
1880     if(
1881       usingEarlyMintIncentive == false ||
1882       currentTokenId() > earlyMintTokenIdCap
1883     ) {
1884       return PRICE * _count;
1885     }
1886 
1887     uint256 endingTokenId = currentTokenId() + _count;
1888     // If qty to mint results in a final token ID less than or equal to the cap then
1889     // the entire qty is within free mint.
1890     if(endingTokenId  <= earlyMintTokenIdCap) {
1891       return EARLY_MINT_PRICE * _count;
1892     }
1893 
1894     // If the current token id is less than the incentive cap
1895     // and the ending token ID is greater than the incentive cap
1896     // we will be straddling the cap so there will be some amount
1897     // that are incentive and some that are regular fee.
1898     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1899     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1900 
1901     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1902   }
1903 }
1904 
1905   
1906   
1907 abstract contract RamppERC721A is 
1908     Ownable,
1909     Teams,
1910     ERC721ARedemption,
1911     WithdrawableV2,
1912     ReentrancyGuard 
1913     , EarlyMintIncentive 
1914      
1915     
1916 {
1917   constructor(
1918     string memory tokenName,
1919     string memory tokenSymbol
1920   ) ERC721A(tokenName, tokenSymbol, 10, 5005) { }
1921     uint8 constant public CONTRACT_VERSION = 2;
1922     string public _baseTokenURI = "ipfs://bafybeicu3xqerbso3yuq2t6jbbjjjnfa6q4vpucjrm2iagbmwg57nwsczi/";
1923     string public _baseTokenExtension = ".json";
1924 
1925     bool public mintingOpen = false;
1926     
1927     
1928 
1929   
1930     /////////////// Admin Mint Functions
1931     /**
1932      * @dev Mints a token to an address with a tokenURI.
1933      * This is owner only and allows a fee-free drop
1934      * @param _to address of the future owner of the token
1935      * @param _qty amount of tokens to drop the owner
1936      */
1937      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1938          if(_qty == 0) revert MintZeroQuantity();
1939          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1940          _safeMint(_to, _qty, true);
1941      }
1942 
1943   
1944     /////////////// PUBLIC MINT FUNCTIONS
1945     /**
1946     * @dev Mints tokens to an address in batch.
1947     * fee may or may not be required*
1948     * @param _to address of the future owner of the token
1949     * @param _amount number of tokens to mint
1950     */
1951     function mintToMultiple(address _to, uint256 _amount) public payable {
1952         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1953         if(_amount == 0) revert MintZeroQuantity();
1954         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1955         if(!mintingOpen) revert PublicMintClosed();
1956         
1957         
1958         
1959         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1960         if(msg.value != getPrice(_amount)) revert InvalidPayment();
1961 
1962         _safeMint(_to, _amount, false);
1963     }
1964 
1965     /**
1966      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1967      * fee may or may not be required*
1968      * @param _to address of the future owner of the token
1969      * @param _amount number of tokens to mint
1970      * @param _erc20TokenContract erc-20 token contract to mint with
1971      */
1972     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1973       if(_amount == 0) revert MintZeroQuantity();
1974       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1975       if(!mintingOpen) revert PublicMintClosed();
1976       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1977       
1978       
1979       
1980 
1981       // ERC-20 Specific pre-flight checks
1982       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1983       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1984       IERC20 payableToken = IERC20(_erc20TokenContract);
1985 
1986       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1987       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1988 
1989       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1990       if(!transferComplete) revert ERC20TransferFailed();
1991       
1992       _safeMint(_to, _amount, false);
1993     }
1994 
1995     function openMinting() public onlyTeamOrOwner {
1996         mintingOpen = true;
1997     }
1998 
1999     function stopMinting() public onlyTeamOrOwner {
2000         mintingOpen = false;
2001     }
2002 
2003   
2004 
2005   
2006 
2007   
2008     /**
2009      * @dev Allows owner to set Max mints per tx
2010      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2011      */
2012      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2013          if(_newMaxMint == 0) revert ValueCannotBeZero();
2014          maxBatchSize = _newMaxMint;
2015      }
2016     
2017 
2018   
2019   
2020   
2021   function contractURI() public pure returns (string memory) {
2022     return "https://metadata.mintplex.xyz/EfU9iaX4hgF5OjhjjsgV/contract-metadata";
2023   }
2024   
2025 
2026   function _baseURI() internal view virtual override returns(string memory) {
2027     return _baseTokenURI;
2028   }
2029 
2030   function _baseURIExtension() internal view virtual override returns(string memory) {
2031     return _baseTokenExtension;
2032   }
2033 
2034   function baseTokenURI() public view returns(string memory) {
2035     return _baseTokenURI;
2036   }
2037 
2038   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2039     _baseTokenURI = baseURI;
2040   }
2041 
2042   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2043     _baseTokenExtension = baseExtension;
2044   }
2045 }
2046 
2047 
2048   
2049 // File: contracts/BrokiesContract.sol
2050 //SPDX-License-Identifier: MIT
2051 
2052 pragma solidity ^0.8.0;
2053 
2054 contract BrokiesContract is RamppERC721A {
2055     constructor() RamppERC721A("Brokies", "Brokie"){}
2056 }
2057   
2058 //*********************************************************************//
2059 //*********************************************************************//  
2060 //                       Mintplex v3.0.0
2061 //
2062 //         This smart contract was generated by mintplex.xyz.
2063 //            Mintplex allows creators like you to launch 
2064 //             large scale NFT communities without code!
2065 //
2066 //    Mintplex is not responsible for the content of this contract and
2067 //        hopes it is being used in a responsible and kind way.  
2068 //       Mintplex is not associated or affiliated with this project.                                                    
2069 //             Twitter: @MintplexNFT ---- mintplex.xyz
2070 //*********************************************************************//                                                     
2071 //*********************************************************************// 
