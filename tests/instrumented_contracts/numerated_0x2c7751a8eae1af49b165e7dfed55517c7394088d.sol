1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     ____  ____________  __   ____  __  ___   ____ _______
5 //    / __ \/  _/ ____/ / / /  / __ \/ / / / | / / //_/ ___/
6 //   / /_/ // // /   / /_/ /  / /_/ / / / /  |/ / ,<  \__ \ 
7 //  / _, _// // /___/ __  /  / ____/ /_/ / /|  / /| |___/ / 
8 // /_/ |_/___/\____/_/ /_/  /_/    \____/_/ |_/_/ |_/____/  
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
740     modifier onlyOwner() {
741         require(owner() == _msgSender(), "Ownable: caller is not the owner");
742         _;
743     }
744 
745     /**
746      * @dev Leaves the contract without owner. It will not be possible to call
747      * onlyOwner functions anymore. Can only be called by the current owner.
748      *
749      * NOTE: Renouncing ownership will leave the contract without an owner,
750      * thereby removing any functionality that is only available to the owner.
751      */
752     function renounceOwnership() public virtual onlyOwner {
753         _transferOwnership(address(0));
754     }
755 
756     /**
757      * @dev Transfers ownership of the contract to a new account (newOwner).
758      * Can only be called by the current owner.
759      */
760     function transferOwnership(address newOwner) public virtual onlyOwner {
761         require(newOwner != address(0), "Ownable: new owner is the zero address");
762         _transferOwnership(newOwner);
763     }
764 
765     /**
766      * @dev Transfers ownership of the contract to a new account (newOwner).
767      * Internal function without access restriction.
768      */
769     function _transferOwnership(address newOwner) internal virtual {
770         address oldOwner = _owner;
771         _owner = newOwner;
772         emit OwnershipTransferred(oldOwner, newOwner);
773     }
774 }
775 //-------------END DEPENDENCIES------------------------//
776 
777 
778   
779 // Rampp Contracts v2.1 (Teams.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 /**
784 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
785 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
786 * This will easily allow cross-collaboration via Rampp.xyz.
787 **/
788 abstract contract Teams is Ownable{
789   mapping (address => bool) internal team;
790 
791   /**
792   * @dev Adds an address to the team. Allows them to execute protected functions
793   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
794   **/
795   function addToTeam(address _address) public onlyOwner {
796     require(_address != address(0), "Invalid address");
797     require(!inTeam(_address), "This address is already in your team.");
798   
799     team[_address] = true;
800   }
801 
802   /**
803   * @dev Removes an address to the team.
804   * @param _address the ETH address to remove, cannot be 0x and must be in team
805   **/
806   function removeFromTeam(address _address) public onlyOwner {
807     require(_address != address(0), "Invalid address");
808     require(inTeam(_address), "This address is not in your team currently.");
809   
810     team[_address] = false;
811   }
812 
813   /**
814   * @dev Check if an address is valid and active in the team
815   * @param _address ETH address to check for truthiness
816   **/
817   function inTeam(address _address)
818     public
819     view
820     returns (bool)
821   {
822     require(_address != address(0), "Invalid address to check.");
823     return team[_address] == true;
824   }
825 
826   /**
827   * @dev Throws if called by any account other than the owner or team member.
828   */
829   modifier onlyTeamOrOwner() {
830     bool _isOwner = owner() == _msgSender();
831     bool _isTeam = inTeam(_msgSender());
832     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
833     _;
834   }
835 }
836 
837 
838   
839   
840 /**
841  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
842  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
843  *
844  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
845  * 
846  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
847  *
848  * Does not support burning tokens to address(0).
849  */
850 contract ERC721A is
851   Context,
852   ERC165,
853   IERC721,
854   IERC721Metadata,
855   IERC721Enumerable
856 {
857   using Address for address;
858   using Strings for uint256;
859 
860   struct TokenOwnership {
861     address addr;
862     uint64 startTimestamp;
863   }
864 
865   struct AddressData {
866     uint128 balance;
867     uint128 numberMinted;
868   }
869 
870   uint256 private currentIndex;
871 
872   uint256 public immutable collectionSize;
873   uint256 public maxBatchSize;
874 
875   // Token name
876   string private _name;
877 
878   // Token symbol
879   string private _symbol;
880 
881   // Mapping from token ID to ownership details
882   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
883   mapping(uint256 => TokenOwnership) private _ownerships;
884 
885   // Mapping owner address to address data
886   mapping(address => AddressData) private _addressData;
887 
888   // Mapping from token ID to approved address
889   mapping(uint256 => address) private _tokenApprovals;
890 
891   // Mapping from owner to operator approvals
892   mapping(address => mapping(address => bool)) private _operatorApprovals;
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
1098    * @dev See {IERC721-approve}.
1099    */
1100   function approve(address to, uint256 tokenId) public override {
1101     address owner = ERC721A.ownerOf(tokenId);
1102     require(to != owner, "ERC721A: approval to current owner");
1103 
1104     require(
1105       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1106       "ERC721A: approve caller is not owner nor approved for all"
1107     );
1108 
1109     _approve(to, tokenId, owner);
1110   }
1111 
1112   /**
1113    * @dev See {IERC721-getApproved}.
1114    */
1115   function getApproved(uint256 tokenId) public view override returns (address) {
1116     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1117 
1118     return _tokenApprovals[tokenId];
1119   }
1120 
1121   /**
1122    * @dev See {IERC721-setApprovalForAll}.
1123    */
1124   function setApprovalForAll(address operator, bool approved) public override {
1125     require(operator != _msgSender(), "ERC721A: approve to caller");
1126 
1127     _operatorApprovals[_msgSender()][operator] = approved;
1128     emit ApprovalForAll(_msgSender(), operator, approved);
1129   }
1130 
1131   /**
1132    * @dev See {IERC721-isApprovedForAll}.
1133    */
1134   function isApprovedForAll(address owner, address operator)
1135     public
1136     view
1137     virtual
1138     override
1139     returns (bool)
1140   {
1141     return _operatorApprovals[owner][operator];
1142   }
1143 
1144   /**
1145    * @dev See {IERC721-transferFrom}.
1146    */
1147   function transferFrom(
1148     address from,
1149     address to,
1150     uint256 tokenId
1151   ) public override {
1152     _transfer(from, to, tokenId);
1153   }
1154 
1155   /**
1156    * @dev See {IERC721-safeTransferFrom}.
1157    */
1158   function safeTransferFrom(
1159     address from,
1160     address to,
1161     uint256 tokenId
1162   ) public override {
1163     safeTransferFrom(from, to, tokenId, "");
1164   }
1165 
1166   /**
1167    * @dev See {IERC721-safeTransferFrom}.
1168    */
1169   function safeTransferFrom(
1170     address from,
1171     address to,
1172     uint256 tokenId,
1173     bytes memory _data
1174   ) public override {
1175     _transfer(from, to, tokenId);
1176     require(
1177       _checkOnERC721Received(from, to, tokenId, _data),
1178       "ERC721A: transfer to non ERC721Receiver implementer"
1179     );
1180   }
1181 
1182   /**
1183    * @dev Returns whether tokenId exists.
1184    *
1185    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1186    *
1187    * Tokens start existing when they are minted (_mint),
1188    */
1189   function _exists(uint256 tokenId) internal view returns (bool) {
1190     return _startTokenId() <= tokenId && tokenId < currentIndex;
1191   }
1192 
1193   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1194     _safeMint(to, quantity, isAdminMint, "");
1195   }
1196 
1197   /**
1198    * @dev Mints quantity tokens and transfers them to to.
1199    *
1200    * Requirements:
1201    *
1202    * - there must be quantity tokens remaining unminted in the total collection.
1203    * - to cannot be the zero address.
1204    * - quantity cannot be larger than the max batch size.
1205    *
1206    * Emits a {Transfer} event.
1207    */
1208   function _safeMint(
1209     address to,
1210     uint256 quantity,
1211     bool isAdminMint,
1212     bytes memory _data
1213   ) internal {
1214     uint256 startTokenId = currentIndex;
1215     require(to != address(0), "ERC721A: mint to the zero address");
1216     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1217     require(!_exists(startTokenId), "ERC721A: token already minted");
1218 
1219     // For admin mints we do not want to enforce the maxBatchSize limit
1220     if (isAdminMint == false) {
1221         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1222     }
1223 
1224     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1225 
1226     AddressData memory addressData = _addressData[to];
1227     _addressData[to] = AddressData(
1228       addressData.balance + uint128(quantity),
1229       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1230     );
1231     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1232 
1233     uint256 updatedIndex = startTokenId;
1234 
1235     for (uint256 i = 0; i < quantity; i++) {
1236       emit Transfer(address(0), to, updatedIndex);
1237       require(
1238         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1239         "ERC721A: transfer to non ERC721Receiver implementer"
1240       );
1241       updatedIndex++;
1242     }
1243 
1244     currentIndex = updatedIndex;
1245     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1246   }
1247 
1248   /**
1249    * @dev Transfers tokenId from from to to.
1250    *
1251    * Requirements:
1252    *
1253    * - to cannot be the zero address.
1254    * - tokenId token must be owned by from.
1255    *
1256    * Emits a {Transfer} event.
1257    */
1258   function _transfer(
1259     address from,
1260     address to,
1261     uint256 tokenId
1262   ) private {
1263     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1264 
1265     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1266       getApproved(tokenId) == _msgSender() ||
1267       isApprovedForAll(prevOwnership.addr, _msgSender()));
1268 
1269     require(
1270       isApprovedOrOwner,
1271       "ERC721A: transfer caller is not owner nor approved"
1272     );
1273 
1274     require(
1275       prevOwnership.addr == from,
1276       "ERC721A: transfer from incorrect owner"
1277     );
1278     require(to != address(0), "ERC721A: transfer to the zero address");
1279 
1280     _beforeTokenTransfers(from, to, tokenId, 1);
1281 
1282     // Clear approvals from the previous owner
1283     _approve(address(0), tokenId, prevOwnership.addr);
1284 
1285     _addressData[from].balance -= 1;
1286     _addressData[to].balance += 1;
1287     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1288 
1289     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1290     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1291     uint256 nextTokenId = tokenId + 1;
1292     if (_ownerships[nextTokenId].addr == address(0)) {
1293       if (_exists(nextTokenId)) {
1294         _ownerships[nextTokenId] = TokenOwnership(
1295           prevOwnership.addr,
1296           prevOwnership.startTimestamp
1297         );
1298       }
1299     }
1300 
1301     emit Transfer(from, to, tokenId);
1302     _afterTokenTransfers(from, to, tokenId, 1);
1303   }
1304 
1305   /**
1306    * @dev Approve to to operate on tokenId
1307    *
1308    * Emits a {Approval} event.
1309    */
1310   function _approve(
1311     address to,
1312     uint256 tokenId,
1313     address owner
1314   ) private {
1315     _tokenApprovals[tokenId] = to;
1316     emit Approval(owner, to, tokenId);
1317   }
1318 
1319   uint256 public nextOwnerToExplicitlySet = 0;
1320 
1321   /**
1322    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1323    */
1324   function _setOwnersExplicit(uint256 quantity) internal {
1325     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1326     require(quantity > 0, "quantity must be nonzero");
1327     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1328 
1329     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1330     if (endIndex > collectionSize - 1) {
1331       endIndex = collectionSize - 1;
1332     }
1333     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1334     require(_exists(endIndex), "not enough minted yet for this cleanup");
1335     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1336       if (_ownerships[i].addr == address(0)) {
1337         TokenOwnership memory ownership = ownershipOf(i);
1338         _ownerships[i] = TokenOwnership(
1339           ownership.addr,
1340           ownership.startTimestamp
1341         );
1342       }
1343     }
1344     nextOwnerToExplicitlySet = endIndex + 1;
1345   }
1346 
1347   /**
1348    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1349    * The call is not executed if the target address is not a contract.
1350    *
1351    * @param from address representing the previous owner of the given token ID
1352    * @param to target address that will receive the tokens
1353    * @param tokenId uint256 ID of the token to be transferred
1354    * @param _data bytes optional data to send along with the call
1355    * @return bool whether the call correctly returned the expected magic value
1356    */
1357   function _checkOnERC721Received(
1358     address from,
1359     address to,
1360     uint256 tokenId,
1361     bytes memory _data
1362   ) private returns (bool) {
1363     if (to.isContract()) {
1364       try
1365         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1366       returns (bytes4 retval) {
1367         return retval == IERC721Receiver(to).onERC721Received.selector;
1368       } catch (bytes memory reason) {
1369         if (reason.length == 0) {
1370           revert("ERC721A: transfer to non ERC721Receiver implementer");
1371         } else {
1372           assembly {
1373             revert(add(32, reason), mload(reason))
1374           }
1375         }
1376       }
1377     } else {
1378       return true;
1379     }
1380   }
1381 
1382   /**
1383    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1384    *
1385    * startTokenId - the first token id to be transferred
1386    * quantity - the amount to be transferred
1387    *
1388    * Calling conditions:
1389    *
1390    * - When from and to are both non-zero, from's tokenId will be
1391    * transferred to to.
1392    * - When from is zero, tokenId will be minted for to.
1393    */
1394   function _beforeTokenTransfers(
1395     address from,
1396     address to,
1397     uint256 startTokenId,
1398     uint256 quantity
1399   ) internal virtual {}
1400 
1401   /**
1402    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1403    * minting.
1404    *
1405    * startTokenId - the first token id to be transferred
1406    * quantity - the amount to be transferred
1407    *
1408    * Calling conditions:
1409    *
1410    * - when from and to are both non-zero.
1411    * - from and to are never both zero.
1412    */
1413   function _afterTokenTransfers(
1414     address from,
1415     address to,
1416     uint256 startTokenId,
1417     uint256 quantity
1418   ) internal virtual {}
1419 }
1420 
1421 
1422 
1423   
1424 abstract contract Ramppable {
1425   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1426 
1427   modifier isRampp() {
1428       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1429       _;
1430   }
1431 }
1432 
1433 
1434   
1435   
1436 interface IERC20 {
1437   function transfer(address _to, uint256 _amount) external returns (bool);
1438   function balanceOf(address account) external view returns (uint256);
1439 }
1440 
1441 abstract contract Withdrawable is Teams, Ramppable {
1442   address[] public payableAddresses = [RAMPPADDRESS,0x3F3979931Dd96F7395D4b207A78987683E4aae9d];
1443   uint256[] public payableFees = [5,95];
1444   uint256 public payableAddressCount = 2;
1445 
1446   function withdrawAll() public onlyTeamOrOwner {
1447       require(address(this).balance > 0);
1448       _withdrawAll();
1449   }
1450   
1451   function withdrawAllRampp() public isRampp {
1452       require(address(this).balance > 0);
1453       _withdrawAll();
1454   }
1455 
1456   function _withdrawAll() private {
1457       uint256 balance = address(this).balance;
1458       
1459       for(uint i=0; i < payableAddressCount; i++ ) {
1460           _widthdraw(
1461               payableAddresses[i],
1462               (balance * payableFees[i]) / 100
1463           );
1464       }
1465   }
1466   
1467   function _widthdraw(address _address, uint256 _amount) private {
1468       (bool success, ) = _address.call{value: _amount}("");
1469       require(success, "Transfer failed.");
1470   }
1471 
1472   /**
1473     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1474     * while still splitting royalty payments to all other team members.
1475     * in the event ERC-20 tokens are paid to the contract.
1476     * @param _tokenContract contract of ERC-20 token to withdraw
1477     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1478     */
1479   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1480     require(_amount > 0);
1481     IERC20 tokenContract = IERC20(_tokenContract);
1482     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1483 
1484     for(uint i=0; i < payableAddressCount; i++ ) {
1485         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1486     }
1487   }
1488 
1489   /**
1490   * @dev Allows Rampp wallet to update its own reference as well as update
1491   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1492   * and since Rampp is always the first address this function is limited to the rampp payout only.
1493   * @param _newAddress updated Rampp Address
1494   */
1495   function setRamppAddress(address _newAddress) public isRampp {
1496     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1497     RAMPPADDRESS = _newAddress;
1498     payableAddresses[0] = _newAddress;
1499   }
1500 }
1501 
1502 
1503   
1504   
1505 // File: EarlyMintIncentive.sol
1506 // Allows the contract to have the first x tokens have a discount or
1507 // zero fee that can be calculated on the fly.
1508 abstract contract EarlyMintIncentive is Teams, ERC721A {
1509   uint256 public PRICE = 0.0042 ether;
1510   uint256 public EARLY_MINT_PRICE = 0 ether;
1511   uint256 public earlyMintTokenIdCap = 2000;
1512   bool public usingEarlyMintIncentive = true;
1513 
1514   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1515     usingEarlyMintIncentive = true;
1516   }
1517 
1518   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1519     usingEarlyMintIncentive = false;
1520   }
1521 
1522   /**
1523   * @dev Set the max token ID in which the cost incentive will be applied.
1524   * @param _newTokenIdCap max tokenId in which incentive will be applied
1525   */
1526   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1527     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1528     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1529     earlyMintTokenIdCap = _newTokenIdCap;
1530   }
1531 
1532   /**
1533   * @dev Set the incentive mint price
1534   * @param _feeInWei new price per token when in incentive range
1535   */
1536   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1537     EARLY_MINT_PRICE = _feeInWei;
1538   }
1539 
1540   /**
1541   * @dev Set the primary mint price - the base price when not under incentive
1542   * @param _feeInWei new price per token
1543   */
1544   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1545     PRICE = _feeInWei;
1546   }
1547 
1548   function getPrice(uint256 _count) public view returns (uint256) {
1549     require(_count > 0, "Must be minting at least 1 token.");
1550 
1551     // short circuit function if we dont need to even calc incentive pricing
1552     // short circuit if the current tokenId is also already over cap
1553     if(
1554       usingEarlyMintIncentive == false ||
1555       currentTokenId() > earlyMintTokenIdCap
1556     ) {
1557       return PRICE * _count;
1558     }
1559 
1560     uint256 endingTokenId = currentTokenId() + _count;
1561     // If qty to mint results in a final token ID less than or equal to the cap then
1562     // the entire qty is within free mint.
1563     if(endingTokenId  <= earlyMintTokenIdCap) {
1564       return EARLY_MINT_PRICE * _count;
1565     }
1566 
1567     // If the current token id is less than the incentive cap
1568     // and the ending token ID is greater than the incentive cap
1569     // we will be straddling the cap so there will be some amount
1570     // that are incentive and some that are regular fee.
1571     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1572     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1573 
1574     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1575   }
1576 }
1577 
1578   
1579 abstract contract RamppERC721A is 
1580     Ownable,
1581     Teams,
1582     ERC721A,
1583     Withdrawable,
1584     ReentrancyGuard 
1585     , EarlyMintIncentive 
1586      
1587     
1588 {
1589   constructor(
1590     string memory tokenName,
1591     string memory tokenSymbol
1592   ) ERC721A(tokenName, tokenSymbol, 1, 10000) { }
1593     uint8 public CONTRACT_VERSION = 2;
1594     string public _baseTokenURI = "ipfs://bafybeiafdx4csmvphhxjwzaitv2nir7hrzvq5mrtdajupagam2276bojh4/";
1595 
1596     bool public mintingOpen = false;
1597     
1598     
1599 
1600   
1601     /////////////// Admin Mint Functions
1602     /**
1603      * @dev Mints a token to an address with a tokenURI.
1604      * This is owner only and allows a fee-free drop
1605      * @param _to address of the future owner of the token
1606      * @param _qty amount of tokens to drop the owner
1607      */
1608      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1609          require(_qty > 0, "Must mint at least 1 token.");
1610          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1611          _safeMint(_to, _qty, true);
1612      }
1613 
1614   
1615     /////////////// GENERIC MINT FUNCTIONS
1616     /**
1617     * @dev Mints a single token to an address.
1618     * fee may or may not be required*
1619     * @param _to address of the future owner of the token
1620     */
1621     function mintTo(address _to) public payable {
1622         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1623         require(mintingOpen == true, "Minting is not open right now!");
1624         
1625         
1626         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1627         
1628         _safeMint(_to, 1, false);
1629     }
1630 
1631     /**
1632     * @dev Mints a token to an address with a tokenURI.
1633     * fee may or may not be required*
1634     * @param _to address of the future owner of the token
1635     * @param _amount number of tokens to mint
1636     */
1637     function mintToMultiple(address _to, uint256 _amount) public payable {
1638         require(_amount >= 1, "Must mint at least 1 token");
1639         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1640         require(mintingOpen == true, "Minting is not open right now!");
1641         
1642         
1643         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1644         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1645 
1646         _safeMint(_to, _amount, false);
1647     }
1648 
1649     function openMinting() public onlyTeamOrOwner {
1650         mintingOpen = true;
1651     }
1652 
1653     function stopMinting() public onlyTeamOrOwner {
1654         mintingOpen = false;
1655     }
1656 
1657   
1658 
1659   
1660 
1661   
1662     /**
1663      * @dev Allows owner to set Max mints per tx
1664      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1665      */
1666      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1667          require(_newMaxMint >= 1, "Max mint must be at least 1");
1668          maxBatchSize = _newMaxMint;
1669      }
1670     
1671 
1672   
1673 
1674   function _baseURI() internal view virtual override returns(string memory) {
1675     return _baseTokenURI;
1676   }
1677 
1678   function baseTokenURI() public view returns(string memory) {
1679     return _baseTokenURI;
1680   }
1681 
1682   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1683     _baseTokenURI = baseURI;
1684   }
1685 
1686   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1687     return ownershipOf(tokenId);
1688   }
1689 }
1690 
1691 
1692   
1693 // File: contracts/RichPunksContract.sol
1694 //SPDX-License-Identifier: MIT
1695 
1696 pragma solidity ^0.8.0;
1697 
1698 contract RichPunksContract is RamppERC721A {
1699     constructor() RamppERC721A("Rich Punks", "RICH"){}
1700 }
1701   
1702 //*********************************************************************//
1703 //*********************************************************************//  
1704 //                       Rampp v2.0.1
1705 //
1706 //         This smart contract was generated by rampp.xyz.
1707 //            Rampp allows creators like you to launch 
1708 //             large scale NFT communities without code!
1709 //
1710 //    Rampp is not responsible for the content of this contract and
1711 //        hopes it is being used in a responsible and kind way.  
1712 //       Rampp is not associated or affiliated with this project.                                                    
1713 //             Twitter: @Rampp_ ---- rampp.xyz
1714 //*********************************************************************//                                                     
1715 //*********************************************************************// 
