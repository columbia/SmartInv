1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     _______      __    __   ______     _          _   ______________
5 //    / ____(_)__  / /___/ /  /_  __/____(_)___     / | / / ____/_  __/
6 //   / /_  / / _ \/ / __  /    / / / ___/ / __ \   /  |/ / /_    / /   
7 //  / __/ / /  __/ / /_/ /    / / / /  / / /_/ /  / /|  / __/   / /    
8 // /_/   /_/\___/_/\__,_/    /_/ /_/  /_/ .___/  /_/ |_/_/     /_/     
9 //                                     /_/                             
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
775 
776 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
777 pragma solidity ^0.8.9;
778 
779 interface IOperatorFilterRegistry {
780     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
781     function register(address registrant) external;
782     function registerAndSubscribe(address registrant, address subscription) external;
783     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
784     function updateOperator(address registrant, address operator, bool filtered) external;
785     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
786     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
787     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
788     function subscribe(address registrant, address registrantToSubscribe) external;
789     function unsubscribe(address registrant, bool copyExistingEntries) external;
790     function subscriptionOf(address addr) external returns (address registrant);
791     function subscribers(address registrant) external returns (address[] memory);
792     function subscriberAt(address registrant, uint256 index) external returns (address);
793     function copyEntriesOf(address registrant, address registrantToCopy) external;
794     function isOperatorFiltered(address registrant, address operator) external returns (bool);
795     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
796     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
797     function filteredOperators(address addr) external returns (address[] memory);
798     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
799     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
800     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
801     function isRegistered(address addr) external returns (bool);
802     function codeHashOf(address addr) external returns (bytes32);
803 }
804 
805 // File contracts/OperatorFilter/OperatorFilterer.sol
806 pragma solidity ^0.8.9;
807 
808 abstract contract OperatorFilterer {
809     error OperatorNotAllowed(address operator);
810 
811     IOperatorFilterRegistry constant operatorFilterRegistry =
812         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
813 
814     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
815         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
816         // will not revert, but the contract will need to be registered with the registry once it is deployed in
817         // order for the modifier to filter addresses.
818         if (address(operatorFilterRegistry).code.length > 0) {
819             if (subscribe) {
820                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
821             } else {
822                 if (subscriptionOrRegistrantToCopy != address(0)) {
823                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
824                 } else {
825                     operatorFilterRegistry.register(address(this));
826                 }
827             }
828         }
829     }
830 
831     function _onlyAllowedOperator(address from) private view {
832       if (
833           !(
834               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
835               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
836           )
837       ) {
838           revert OperatorNotAllowed(msg.sender);
839       }
840     }
841 
842     modifier onlyAllowedOperator(address from) virtual {
843         // Check registry code length to facilitate testing in environments without a deployed registry.
844         if (address(operatorFilterRegistry).code.length > 0) {
845             // Allow spending tokens from addresses with balance
846             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
847             // from an EOA.
848             if (from == msg.sender) {
849                 _;
850                 return;
851             }
852             _onlyAllowedOperator(from);
853         }
854         _;
855     }
856 }
857 
858 //-------------END DEPENDENCIES------------------------//
859 
860 
861   
862 // Rampp Contracts v2.1 (Teams.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 /**
867 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
868 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
869 * This will easily allow cross-collaboration via Mintplex.xyz.
870 **/
871 abstract contract Teams is Ownable{
872   mapping (address => bool) internal team;
873 
874   /**
875   * @dev Adds an address to the team. Allows them to execute protected functions
876   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
877   **/
878   function addToTeam(address _address) public onlyOwner {
879     require(_address != address(0), "Invalid address");
880     require(!inTeam(_address), "This address is already in your team.");
881   
882     team[_address] = true;
883   }
884 
885   /**
886   * @dev Removes an address to the team.
887   * @param _address the ETH address to remove, cannot be 0x and must be in team
888   **/
889   function removeFromTeam(address _address) public onlyOwner {
890     require(_address != address(0), "Invalid address");
891     require(inTeam(_address), "This address is not in your team currently.");
892   
893     team[_address] = false;
894   }
895 
896   /**
897   * @dev Check if an address is valid and active in the team
898   * @param _address ETH address to check for truthiness
899   **/
900   function inTeam(address _address)
901     public
902     view
903     returns (bool)
904   {
905     require(_address != address(0), "Invalid address to check.");
906     return team[_address] == true;
907   }
908 
909   /**
910   * @dev Throws if called by any account other than the owner or team member.
911   */
912   function _onlyTeamOrOwner() private view {
913     bool _isOwner = owner() == _msgSender();
914     bool _isTeam = inTeam(_msgSender());
915     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
916   }
917 
918   modifier onlyTeamOrOwner() {
919     _onlyTeamOrOwner();
920     _;
921   }
922 }
923 
924 
925   
926   pragma solidity ^0.8.0;
927 
928   /**
929   * @dev These functions deal with verification of Merkle Trees proofs.
930   *
931   * The proofs can be generated using the JavaScript library
932   * https://github.com/miguelmota/merkletreejs[merkletreejs].
933   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
934   *
935   *
936   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
937   * hashing, or use a hash function other than keccak256 for hashing leaves.
938   * This is because the concatenation of a sorted pair of internal nodes in
939   * the merkle tree could be reinterpreted as a leaf value.
940   */
941   library MerkleProof {
942       /**
943       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
944       * defined by 'root'. For this, a 'proof' must be provided, containing
945       * sibling hashes on the branch from the leaf to the root of the tree. Each
946       * pair of leaves and each pair of pre-images are assumed to be sorted.
947       */
948       function verify(
949           bytes32[] memory proof,
950           bytes32 root,
951           bytes32 leaf
952       ) internal pure returns (bool) {
953           return processProof(proof, leaf) == root;
954       }
955 
956       /**
957       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
958       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
959       * hash matches the root of the tree. When processing the proof, the pairs
960       * of leafs & pre-images are assumed to be sorted.
961       *
962       * _Available since v4.4._
963       */
964       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
965           bytes32 computedHash = leaf;
966           for (uint256 i = 0; i < proof.length; i++) {
967               bytes32 proofElement = proof[i];
968               if (computedHash <= proofElement) {
969                   // Hash(current computed hash + current element of the proof)
970                   computedHash = _efficientHash(computedHash, proofElement);
971               } else {
972                   // Hash(current element of the proof + current computed hash)
973                   computedHash = _efficientHash(proofElement, computedHash);
974               }
975           }
976           return computedHash;
977       }
978 
979       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
980           assembly {
981               mstore(0x00, a)
982               mstore(0x20, b)
983               value := keccak256(0x00, 0x40)
984           }
985       }
986   }
987 
988 
989   // File: Allowlist.sol
990 
991   pragma solidity ^0.8.0;
992 
993   abstract contract Allowlist is Teams {
994     bytes32 public merkleRoot;
995     bool public onlyAllowlistMode = false;
996 
997     /**
998      * @dev Update merkle root to reflect changes in Allowlist
999      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1000      */
1001     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1002       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1003       merkleRoot = _newMerkleRoot;
1004     }
1005 
1006     /**
1007      * @dev Check the proof of an address if valid for merkle root
1008      * @param _to address to check for proof
1009      * @param _merkleProof Proof of the address to validate against root and leaf
1010      */
1011     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1012       require(merkleRoot != 0, "Merkle root is not set!");
1013       bytes32 leaf = keccak256(abi.encodePacked(_to));
1014 
1015       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1016     }
1017 
1018     
1019     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1020       onlyAllowlistMode = true;
1021     }
1022 
1023     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1024         onlyAllowlistMode = false;
1025     }
1026   }
1027   
1028   
1029 /**
1030  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1031  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1032  *
1033  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1034  * 
1035  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1036  *
1037  * Does not support burning tokens to address(0).
1038  */
1039 contract ERC721A is
1040   Context,
1041   ERC165,
1042   IERC721,
1043   IERC721Metadata,
1044   IERC721Enumerable,
1045   Teams
1046   , OperatorFilterer
1047 {
1048   using Address for address;
1049   using Strings for uint256;
1050 
1051   struct TokenOwnership {
1052     address addr;
1053     uint64 startTimestamp;
1054   }
1055 
1056   struct AddressData {
1057     uint128 balance;
1058     uint128 numberMinted;
1059   }
1060 
1061   uint256 private currentIndex;
1062 
1063   uint256 public immutable collectionSize;
1064   uint256 public maxBatchSize;
1065 
1066   // Token name
1067   string private _name;
1068 
1069   // Token symbol
1070   string private _symbol;
1071 
1072   // Mapping from token ID to ownership details
1073   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1074   mapping(uint256 => TokenOwnership) private _ownerships;
1075 
1076   // Mapping owner address to address data
1077   mapping(address => AddressData) private _addressData;
1078 
1079   // Mapping from token ID to approved address
1080   mapping(uint256 => address) private _tokenApprovals;
1081 
1082   // Mapping from owner to operator approvals
1083   mapping(address => mapping(address => bool)) private _operatorApprovals;
1084 
1085   /* @dev Mapping of restricted operator approvals set by contract Owner
1086   * This serves as an optional addition to ERC-721 so
1087   * that the contract owner can elect to prevent specific addresses/contracts
1088   * from being marked as the approver for a token. The reason for this
1089   * is that some projects may want to retain control of where their tokens can/can not be listed
1090   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1091   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1092   */
1093   mapping(address => bool) public restrictedApprovalAddresses;
1094 
1095   /**
1096    * @dev
1097    * maxBatchSize refers to how much a minter can mint at a time.
1098    * collectionSize_ refers to how many tokens are in the collection.
1099    */
1100   constructor(
1101     string memory name_,
1102     string memory symbol_,
1103     uint256 maxBatchSize_,
1104     uint256 collectionSize_
1105   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1106     require(
1107       collectionSize_ > 0,
1108       "ERC721A: collection must have a nonzero supply"
1109     );
1110     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1111     _name = name_;
1112     _symbol = symbol_;
1113     maxBatchSize = maxBatchSize_;
1114     collectionSize = collectionSize_;
1115     currentIndex = _startTokenId();
1116   }
1117 
1118   /**
1119   * To change the starting tokenId, please override this function.
1120   */
1121   function _startTokenId() internal view virtual returns (uint256) {
1122     return 1;
1123   }
1124 
1125   /**
1126    * @dev See {IERC721Enumerable-totalSupply}.
1127    */
1128   function totalSupply() public view override returns (uint256) {
1129     return _totalMinted();
1130   }
1131 
1132   function currentTokenId() public view returns (uint256) {
1133     return _totalMinted();
1134   }
1135 
1136   function getNextTokenId() public view returns (uint256) {
1137       return _totalMinted() + 1;
1138   }
1139 
1140   /**
1141   * Returns the total amount of tokens minted in the contract.
1142   */
1143   function _totalMinted() internal view returns (uint256) {
1144     unchecked {
1145       return currentIndex - _startTokenId();
1146     }
1147   }
1148 
1149   /**
1150    * @dev See {IERC721Enumerable-tokenByIndex}.
1151    */
1152   function tokenByIndex(uint256 index) public view override returns (uint256) {
1153     require(index < totalSupply(), "ERC721A: global index out of bounds");
1154     return index;
1155   }
1156 
1157   /**
1158    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1159    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1160    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1161    */
1162   function tokenOfOwnerByIndex(address owner, uint256 index)
1163     public
1164     view
1165     override
1166     returns (uint256)
1167   {
1168     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1169     uint256 numMintedSoFar = totalSupply();
1170     uint256 tokenIdsIdx = 0;
1171     address currOwnershipAddr = address(0);
1172     for (uint256 i = 0; i < numMintedSoFar; i++) {
1173       TokenOwnership memory ownership = _ownerships[i];
1174       if (ownership.addr != address(0)) {
1175         currOwnershipAddr = ownership.addr;
1176       }
1177       if (currOwnershipAddr == owner) {
1178         if (tokenIdsIdx == index) {
1179           return i;
1180         }
1181         tokenIdsIdx++;
1182       }
1183     }
1184     revert("ERC721A: unable to get token of owner by index");
1185   }
1186 
1187   /**
1188    * @dev See {IERC165-supportsInterface}.
1189    */
1190   function supportsInterface(bytes4 interfaceId)
1191     public
1192     view
1193     virtual
1194     override(ERC165, IERC165)
1195     returns (bool)
1196   {
1197     return
1198       interfaceId == type(IERC721).interfaceId ||
1199       interfaceId == type(IERC721Metadata).interfaceId ||
1200       interfaceId == type(IERC721Enumerable).interfaceId ||
1201       super.supportsInterface(interfaceId);
1202   }
1203 
1204   /**
1205    * @dev See {IERC721-balanceOf}.
1206    */
1207   function balanceOf(address owner) public view override returns (uint256) {
1208     require(owner != address(0), "ERC721A: balance query for the zero address");
1209     return uint256(_addressData[owner].balance);
1210   }
1211 
1212   function _numberMinted(address owner) internal view returns (uint256) {
1213     require(
1214       owner != address(0),
1215       "ERC721A: number minted query for the zero address"
1216     );
1217     return uint256(_addressData[owner].numberMinted);
1218   }
1219 
1220   function ownershipOf(uint256 tokenId)
1221     internal
1222     view
1223     returns (TokenOwnership memory)
1224   {
1225     uint256 curr = tokenId;
1226 
1227     unchecked {
1228         if (_startTokenId() <= curr && curr < currentIndex) {
1229             TokenOwnership memory ownership = _ownerships[curr];
1230             if (ownership.addr != address(0)) {
1231                 return ownership;
1232             }
1233 
1234             // Invariant:
1235             // There will always be an ownership that has an address and is not burned
1236             // before an ownership that does not have an address and is not burned.
1237             // Hence, curr will not underflow.
1238             while (true) {
1239                 curr--;
1240                 ownership = _ownerships[curr];
1241                 if (ownership.addr != address(0)) {
1242                     return ownership;
1243                 }
1244             }
1245         }
1246     }
1247 
1248     revert("ERC721A: unable to determine the owner of token");
1249   }
1250 
1251   /**
1252    * @dev See {IERC721-ownerOf}.
1253    */
1254   function ownerOf(uint256 tokenId) public view override returns (address) {
1255     return ownershipOf(tokenId).addr;
1256   }
1257 
1258   /**
1259    * @dev See {IERC721Metadata-name}.
1260    */
1261   function name() public view virtual override returns (string memory) {
1262     return _name;
1263   }
1264 
1265   /**
1266    * @dev See {IERC721Metadata-symbol}.
1267    */
1268   function symbol() public view virtual override returns (string memory) {
1269     return _symbol;
1270   }
1271 
1272   /**
1273    * @dev See {IERC721Metadata-tokenURI}.
1274    */
1275   function tokenURI(uint256 tokenId)
1276     public
1277     view
1278     virtual
1279     override
1280     returns (string memory)
1281   {
1282     string memory baseURI = _baseURI();
1283     string memory extension = _baseURIExtension();
1284     return
1285       bytes(baseURI).length > 0
1286         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1287         : "";
1288   }
1289 
1290   /**
1291    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1292    * token will be the concatenation of the baseURI and the tokenId. Empty
1293    * by default, can be overriden in child contracts.
1294    */
1295   function _baseURI() internal view virtual returns (string memory) {
1296     return "";
1297   }
1298 
1299   /**
1300    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1301    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1302    * by default, can be overriden in child contracts.
1303    */
1304   function _baseURIExtension() internal view virtual returns (string memory) {
1305     return "";
1306   }
1307 
1308   /**
1309    * @dev Sets the value for an address to be in the restricted approval address pool.
1310    * Setting an address to true will disable token owners from being able to mark the address
1311    * for approval for trading. This would be used in theory to prevent token owners from listing
1312    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1313    * @param _address the marketplace/user to modify restriction status of
1314    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1315    */
1316   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1317     restrictedApprovalAddresses[_address] = _isRestricted;
1318   }
1319 
1320   /**
1321    * @dev See {IERC721-approve}.
1322    */
1323   function approve(address to, uint256 tokenId) public override {
1324     address owner = ERC721A.ownerOf(tokenId);
1325     require(to != owner, "ERC721A: approval to current owner");
1326     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1327 
1328     require(
1329       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1330       "ERC721A: approve caller is not owner nor approved for all"
1331     );
1332 
1333     _approve(to, tokenId, owner);
1334   }
1335 
1336   /**
1337    * @dev See {IERC721-getApproved}.
1338    */
1339   function getApproved(uint256 tokenId) public view override returns (address) {
1340     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1341 
1342     return _tokenApprovals[tokenId];
1343   }
1344 
1345   /**
1346    * @dev See {IERC721-setApprovalForAll}.
1347    */
1348   function setApprovalForAll(address operator, bool approved) public override {
1349     require(operator != _msgSender(), "ERC721A: approve to caller");
1350     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1351 
1352     _operatorApprovals[_msgSender()][operator] = approved;
1353     emit ApprovalForAll(_msgSender(), operator, approved);
1354   }
1355 
1356   /**
1357    * @dev See {IERC721-isApprovedForAll}.
1358    */
1359   function isApprovedForAll(address owner, address operator)
1360     public
1361     view
1362     virtual
1363     override
1364     returns (bool)
1365   {
1366     return _operatorApprovals[owner][operator];
1367   }
1368 
1369   /**
1370    * @dev See {IERC721-transferFrom}.
1371    */
1372   function transferFrom(
1373     address from,
1374     address to,
1375     uint256 tokenId
1376   ) public override onlyAllowedOperator(from) {
1377     _transfer(from, to, tokenId);
1378   }
1379 
1380   /**
1381    * @dev See {IERC721-safeTransferFrom}.
1382    */
1383   function safeTransferFrom(
1384     address from,
1385     address to,
1386     uint256 tokenId
1387   ) public override onlyAllowedOperator(from) {
1388     safeTransferFrom(from, to, tokenId, "");
1389   }
1390 
1391   /**
1392    * @dev See {IERC721-safeTransferFrom}.
1393    */
1394   function safeTransferFrom(
1395     address from,
1396     address to,
1397     uint256 tokenId,
1398     bytes memory _data
1399   ) public override onlyAllowedOperator(from) {
1400     _transfer(from, to, tokenId);
1401     require(
1402       _checkOnERC721Received(from, to, tokenId, _data),
1403       "ERC721A: transfer to non ERC721Receiver implementer"
1404     );
1405   }
1406 
1407   /**
1408    * @dev Returns whether tokenId exists.
1409    *
1410    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1411    *
1412    * Tokens start existing when they are minted (_mint),
1413    */
1414   function _exists(uint256 tokenId) internal view returns (bool) {
1415     return _startTokenId() <= tokenId && tokenId < currentIndex;
1416   }
1417 
1418   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1419     _safeMint(to, quantity, isAdminMint, "");
1420   }
1421 
1422   /**
1423    * @dev Mints quantity tokens and transfers them to to.
1424    *
1425    * Requirements:
1426    *
1427    * - there must be quantity tokens remaining unminted in the total collection.
1428    * - to cannot be the zero address.
1429    * - quantity cannot be larger than the max batch size.
1430    *
1431    * Emits a {Transfer} event.
1432    */
1433   function _safeMint(
1434     address to,
1435     uint256 quantity,
1436     bool isAdminMint,
1437     bytes memory _data
1438   ) internal {
1439     uint256 startTokenId = currentIndex;
1440     require(to != address(0), "ERC721A: mint to the zero address");
1441     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1442     require(!_exists(startTokenId), "ERC721A: token already minted");
1443 
1444     // For admin mints we do not want to enforce the maxBatchSize limit
1445     if (isAdminMint == false) {
1446         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1447     }
1448 
1449     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1450 
1451     AddressData memory addressData = _addressData[to];
1452     _addressData[to] = AddressData(
1453       addressData.balance + uint128(quantity),
1454       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1455     );
1456     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1457 
1458     uint256 updatedIndex = startTokenId;
1459 
1460     for (uint256 i = 0; i < quantity; i++) {
1461       emit Transfer(address(0), to, updatedIndex);
1462       require(
1463         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1464         "ERC721A: transfer to non ERC721Receiver implementer"
1465       );
1466       updatedIndex++;
1467     }
1468 
1469     currentIndex = updatedIndex;
1470     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1471   }
1472 
1473   /**
1474    * @dev Transfers tokenId from from to to.
1475    *
1476    * Requirements:
1477    *
1478    * - to cannot be the zero address.
1479    * - tokenId token must be owned by from.
1480    *
1481    * Emits a {Transfer} event.
1482    */
1483   function _transfer(
1484     address from,
1485     address to,
1486     uint256 tokenId
1487   ) private {
1488     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1489 
1490     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1491       getApproved(tokenId) == _msgSender() ||
1492       isApprovedForAll(prevOwnership.addr, _msgSender()));
1493 
1494     require(
1495       isApprovedOrOwner,
1496       "ERC721A: transfer caller is not owner nor approved"
1497     );
1498 
1499     require(
1500       prevOwnership.addr == from,
1501       "ERC721A: transfer from incorrect owner"
1502     );
1503     require(to != address(0), "ERC721A: transfer to the zero address");
1504 
1505     _beforeTokenTransfers(from, to, tokenId, 1);
1506 
1507     // Clear approvals from the previous owner
1508     _approve(address(0), tokenId, prevOwnership.addr);
1509 
1510     _addressData[from].balance -= 1;
1511     _addressData[to].balance += 1;
1512     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1513 
1514     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1515     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1516     uint256 nextTokenId = tokenId + 1;
1517     if (_ownerships[nextTokenId].addr == address(0)) {
1518       if (_exists(nextTokenId)) {
1519         _ownerships[nextTokenId] = TokenOwnership(
1520           prevOwnership.addr,
1521           prevOwnership.startTimestamp
1522         );
1523       }
1524     }
1525 
1526     emit Transfer(from, to, tokenId);
1527     _afterTokenTransfers(from, to, tokenId, 1);
1528   }
1529 
1530   /**
1531    * @dev Approve to to operate on tokenId
1532    *
1533    * Emits a {Approval} event.
1534    */
1535   function _approve(
1536     address to,
1537     uint256 tokenId,
1538     address owner
1539   ) private {
1540     _tokenApprovals[tokenId] = to;
1541     emit Approval(owner, to, tokenId);
1542   }
1543 
1544   uint256 public nextOwnerToExplicitlySet = 0;
1545 
1546   /**
1547    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1548    */
1549   function _setOwnersExplicit(uint256 quantity) internal {
1550     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1551     require(quantity > 0, "quantity must be nonzero");
1552     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1553 
1554     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1555     if (endIndex > collectionSize - 1) {
1556       endIndex = collectionSize - 1;
1557     }
1558     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1559     require(_exists(endIndex), "not enough minted yet for this cleanup");
1560     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1561       if (_ownerships[i].addr == address(0)) {
1562         TokenOwnership memory ownership = ownershipOf(i);
1563         _ownerships[i] = TokenOwnership(
1564           ownership.addr,
1565           ownership.startTimestamp
1566         );
1567       }
1568     }
1569     nextOwnerToExplicitlySet = endIndex + 1;
1570   }
1571 
1572   /**
1573    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1574    * The call is not executed if the target address is not a contract.
1575    *
1576    * @param from address representing the previous owner of the given token ID
1577    * @param to target address that will receive the tokens
1578    * @param tokenId uint256 ID of the token to be transferred
1579    * @param _data bytes optional data to send along with the call
1580    * @return bool whether the call correctly returned the expected magic value
1581    */
1582   function _checkOnERC721Received(
1583     address from,
1584     address to,
1585     uint256 tokenId,
1586     bytes memory _data
1587   ) private returns (bool) {
1588     if (to.isContract()) {
1589       try
1590         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1591       returns (bytes4 retval) {
1592         return retval == IERC721Receiver(to).onERC721Received.selector;
1593       } catch (bytes memory reason) {
1594         if (reason.length == 0) {
1595           revert("ERC721A: transfer to non ERC721Receiver implementer");
1596         } else {
1597           assembly {
1598             revert(add(32, reason), mload(reason))
1599           }
1600         }
1601       }
1602     } else {
1603       return true;
1604     }
1605   }
1606 
1607   /**
1608    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1609    *
1610    * startTokenId - the first token id to be transferred
1611    * quantity - the amount to be transferred
1612    *
1613    * Calling conditions:
1614    *
1615    * - When from and to are both non-zero, from's tokenId will be
1616    * transferred to to.
1617    * - When from is zero, tokenId will be minted for to.
1618    */
1619   function _beforeTokenTransfers(
1620     address from,
1621     address to,
1622     uint256 startTokenId,
1623     uint256 quantity
1624   ) internal virtual {}
1625 
1626   /**
1627    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1628    * minting.
1629    *
1630    * startTokenId - the first token id to be transferred
1631    * quantity - the amount to be transferred
1632    *
1633    * Calling conditions:
1634    *
1635    * - when from and to are both non-zero.
1636    * - from and to are never both zero.
1637    */
1638   function _afterTokenTransfers(
1639     address from,
1640     address to,
1641     uint256 startTokenId,
1642     uint256 quantity
1643   ) internal virtual {}
1644 }
1645 
1646 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1647 // @author Mintplex.xyz (Rampp Labs Inc) (Twitter: @MintplexNFT)
1648 // @notice -- See Medium article --
1649 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1650 abstract contract ERC721ARedemption is ERC721A {
1651   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1652   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1653 
1654   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1655   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1656   
1657   uint256 public redemptionSurcharge = 0 ether;
1658   bool public redemptionModeEnabled;
1659   bool public verifiedClaimModeEnabled;
1660   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1661   mapping(address => bool) public redemptionContracts;
1662   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1663 
1664   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1665   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1666     redemptionContracts[_contractAddress] = _status;
1667   }
1668 
1669   // @dev Allow owner/team to determine if contract is accepting redemption mints
1670   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1671     redemptionModeEnabled = _newStatus;
1672   }
1673 
1674   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1675   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1676     verifiedClaimModeEnabled = _newStatus;
1677   }
1678 
1679   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1680   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1681     redemptionSurcharge = _newSurchargeInWei;
1682   }
1683 
1684   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1685   // @notice Must be a wallet address or implement IERC721Receiver.
1686   // Cannot be null address as this will break any ERC-721A implementation without a proper
1687   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1688   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1689     require(_newRedemptionAddress != address(0), "New redemption address cannot be null address.");
1690     redemptionAddress = _newRedemptionAddress;
1691   }
1692 
1693   /**
1694   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1695   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1696   * the contract owner or Team => redemptionAddress. 
1697   * @param tokenId the token to be redeemed.
1698   * Emits a {Redeemed} event.
1699   **/
1700   function redeem(address redemptionContract, uint256 tokenId) public payable {
1701     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1702     require(redemptionModeEnabled, "ERC721 Redeemable: Redemption mode is not enabled currently");
1703     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1704     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1705     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1706     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1707     
1708     IERC721 _targetContract = IERC721(redemptionContract);
1709     require(_targetContract.ownerOf(tokenId) == _msgSender(), "ERC721 Redeemable: Redeemer not owner of token to be claimed against.");
1710     require(_targetContract.getApproved(tokenId) == address(this), "ERC721 Redeemable: This contract is not approved for specific token on redempetion contract.");
1711     
1712     // Warning: Since there is no standarized return value for transfers of ERC-721
1713     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1714     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1715     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1716     // but the NFT may not have been sent to the redemptionAddress.
1717     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1718     tokenRedemptions[redemptionContract][tokenId] = true;
1719 
1720     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1721     _safeMint(_msgSender(), 1, false);
1722   }
1723 
1724   /**
1725   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1726   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1727   * @param tokenId the token to be redeemed.
1728   * Emits a {VerifiedClaim} event.
1729   **/
1730   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1731     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1732     require(verifiedClaimModeEnabled, "ERC721 Redeemable: Verified claim mode is not enabled currently");
1733     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1734     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1735     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1736     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1737     
1738     tokenRedemptions[redemptionContract][tokenId] = true;
1739     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1740     _safeMint(_msgSender(), 1, false);
1741   }
1742 }
1743 
1744 
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
1767   address[] public payableAddresses = [0x051FD2b087aE4579dDc61432f31Cf685AC7F7779,0x4d8B6F8E6c5569B3003a94748b2A0cD3552962E5];
1768   address public erc20Payable = 0x051FD2b087aE4579dDc61432f31Cf685AC7F7779;
1769   uint256[] public payableFees = [95,5];
1770   uint256 public payableAddressCount = 2;
1771   bool public onlyERC20MintingMode = false;
1772   
1773 
1774   /**
1775   * @dev Calculates the true payable balance of the contract
1776   */
1777   function calcAvailableBalance() public view returns(uint256) {
1778     return address(this).balance;
1779   }
1780 
1781   function withdrawAll() public onlyTeamOrOwner {
1782       require(calcAvailableBalance() > 0);
1783       _withdrawAll();
1784   }
1785 
1786   function _withdrawAll() private {
1787       uint256 balance = calcAvailableBalance();
1788       
1789       for(uint i=0; i < payableAddressCount; i++ ) {
1790           _widthdraw(
1791               payableAddresses[i],
1792               (balance * payableFees[i]) / 100
1793           );
1794       }
1795   }
1796   
1797   function _widthdraw(address _address, uint256 _amount) private {
1798       (bool success, ) = _address.call{value: _amount}("");
1799       require(success, "Transfer failed.");
1800   }
1801 
1802   /**
1803   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1804   * in the event ERC-20 tokens are paid to the contract for mints.
1805   * @param _tokenContract contract of ERC-20 token to withdraw
1806   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1807   */
1808   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1809     require(_amountToWithdraw > 0);
1810     IERC20 tokenContract = IERC20(_tokenContract);
1811     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1812     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1813   }
1814 
1815   /**
1816   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1817   * @param _erc20TokenContract address of ERC-20 contract in question
1818   */
1819   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1820     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1821   }
1822 
1823   /**
1824   * @dev get the value of tokens to transfer for user of an ERC-20
1825   * @param _erc20TokenContract address of ERC-20 contract in question
1826   */
1827   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1828     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1829     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1830   }
1831 
1832   /**
1833   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1834   * @param _erc20TokenContract address of ERC-20 contract in question
1835   * @param _isActive default status of if contract should be allowed to accept payments
1836   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1837   */
1838   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1839     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1840     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1841   }
1842 
1843   /**
1844   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1845   * it will assume the default value of zero. This should not be used to create new payment tokens.
1846   * @param _erc20TokenContract address of ERC-20 contract in question
1847   */
1848   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1849     allowedTokenContracts[_erc20TokenContract].isActive = true;
1850   }
1851 
1852   /**
1853   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1854   * it will assume the default value of zero. This should not be used to create new payment tokens.
1855   * @param _erc20TokenContract address of ERC-20 contract in question
1856   */
1857   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1858     allowedTokenContracts[_erc20TokenContract].isActive = false;
1859   }
1860 
1861   /**
1862   * @dev Enable only ERC-20 payments for minting on this contract
1863   */
1864   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1865     onlyERC20MintingMode = true;
1866   }
1867 
1868   /**
1869   * @dev Disable only ERC-20 payments for minting on this contract
1870   */
1871   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1872     onlyERC20MintingMode = false;
1873   }
1874 
1875   /**
1876   * @dev Set the payout of the ERC-20 token payout to a specific address
1877   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1878   */
1879   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1880     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1881     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1882     erc20Payable = _newErc20Payable;
1883   }
1884 }
1885 
1886 
1887   
1888   
1889 // File: EarlyMintIncentive.sol
1890 // Allows the contract to have the first x tokens have a discount or
1891 // zero fee that can be calculated on the fly.
1892 abstract contract EarlyMintIncentive is Teams, ERC721A {
1893   uint256 public PRICE = 0.1 ether;
1894   uint256 public EARLY_MINT_PRICE = 0.08 ether;
1895   uint256 public earlyMintTokenIdCap = 600;
1896   bool public usingEarlyMintIncentive = true;
1897 
1898   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1899     usingEarlyMintIncentive = true;
1900   }
1901 
1902   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1903     usingEarlyMintIncentive = false;
1904   }
1905 
1906   /**
1907   * @dev Set the max token ID in which the cost incentive will be applied.
1908   * @param _newTokenIdCap max tokenId in which incentive will be applied
1909   */
1910   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1911     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1912     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1913     earlyMintTokenIdCap = _newTokenIdCap;
1914   }
1915 
1916   /**
1917   * @dev Set the incentive mint price
1918   * @param _feeInWei new price per token when in incentive range
1919   */
1920   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1921     EARLY_MINT_PRICE = _feeInWei;
1922   }
1923 
1924   /**
1925   * @dev Set the primary mint price - the base price when not under incentive
1926   * @param _feeInWei new price per token
1927   */
1928   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1929     PRICE = _feeInWei;
1930   }
1931 
1932   function getPrice(uint256 _count) public view returns (uint256) {
1933     require(_count > 0, "Must be minting at least 1 token.");
1934 
1935     // short circuit function if we dont need to even calc incentive pricing
1936     // short circuit if the current tokenId is also already over cap
1937     if(
1938       usingEarlyMintIncentive == false ||
1939       currentTokenId() > earlyMintTokenIdCap
1940     ) {
1941       return PRICE * _count;
1942     }
1943 
1944     uint256 endingTokenId = currentTokenId() + _count;
1945     // If qty to mint results in a final token ID less than or equal to the cap then
1946     // the entire qty is within free mint.
1947     if(endingTokenId  <= earlyMintTokenIdCap) {
1948       return EARLY_MINT_PRICE * _count;
1949     }
1950 
1951     // If the current token id is less than the incentive cap
1952     // and the ending token ID is greater than the incentive cap
1953     // we will be straddling the cap so there will be some amount
1954     // that are incentive and some that are regular fee.
1955     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1956     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1957 
1958     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1959   }
1960 }
1961 
1962   
1963   
1964 abstract contract RamppERC721A is 
1965     Ownable,
1966     Teams,
1967     ERC721ARedemption,
1968     WithdrawableV2,
1969     ReentrancyGuard 
1970     , EarlyMintIncentive 
1971     , Allowlist 
1972     
1973 {
1974   constructor(
1975     string memory tokenName,
1976     string memory tokenSymbol
1977   ) ERC721A(tokenName, tokenSymbol, 1, 600) { }
1978     uint8 public CONTRACT_VERSION = 2;
1979     string public _baseTokenURI = "ipfs://QmaY2WantBYJXRFgfDFT8o92rpqwdxerzR2WsNjfATt8At/";
1980     string public _baseTokenExtension = ".json";
1981 
1982     bool public mintingOpen = true;
1983     
1984     
1985     uint256 public MAX_WALLET_MINTS = 1;
1986 
1987   
1988     /////////////// Admin Mint Functions
1989     /**
1990      * @dev Mints a token to an address with a tokenURI.
1991      * This is owner only and allows a fee-free drop
1992      * @param _to address of the future owner of the token
1993      * @param _qty amount of tokens to drop the owner
1994      */
1995      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1996          require(_qty > 0, "Must mint at least 1 token.");
1997          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 600");
1998          _safeMint(_to, _qty, true);
1999      }
2000 
2001   
2002     /////////////// PUBLIC MINT FUNCTIONS
2003     /**
2004     * @dev Mints tokens to an address in batch.
2005     * fee may or may not be required*
2006     * @param _to address of the future owner of the token
2007     * @param _amount number of tokens to mint
2008     */
2009     function mintToMultiple(address _to, uint256 _amount) public payable {
2010         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2011         require(_amount >= 1, "Must mint at least 1 token");
2012         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2013         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2014         
2015         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2016         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 600");
2017         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2018 
2019         _safeMint(_to, _amount, false);
2020     }
2021 
2022     /**
2023      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2024      * fee may or may not be required*
2025      * @param _to address of the future owner of the token
2026      * @param _amount number of tokens to mint
2027      * @param _erc20TokenContract erc-20 token contract to mint with
2028      */
2029     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2030       require(_amount >= 1, "Must mint at least 1 token");
2031       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2032       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 600");
2033       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2034       
2035       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2036 
2037       // ERC-20 Specific pre-flight checks
2038       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2039       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2040       IERC20 payableToken = IERC20(_erc20TokenContract);
2041 
2042       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2043       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2044 
2045       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2046       require(transferComplete, "ERC-20 token was unable to be transferred");
2047       
2048       _safeMint(_to, _amount, false);
2049     }
2050 
2051     function openMinting() public onlyTeamOrOwner {
2052         mintingOpen = true;
2053     }
2054 
2055     function stopMinting() public onlyTeamOrOwner {
2056         mintingOpen = false;
2057     }
2058 
2059   
2060     ///////////// ALLOWLIST MINTING FUNCTIONS
2061     /**
2062     * @dev Mints tokens to an address using an allowlist.
2063     * fee may or may not be required*
2064     * @param _to address of the future owner of the token
2065     * @param _amount number of tokens to mint
2066     * @param _merkleProof merkle proof array
2067     */
2068     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2069         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2070         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2071         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2072         require(_amount >= 1, "Must mint at least 1 token");
2073         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2074 
2075         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2076         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 600");
2077         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2078         
2079 
2080         _safeMint(_to, _amount, false);
2081     }
2082 
2083     /**
2084     * @dev Mints tokens to an address using an allowlist.
2085     * fee may or may not be required*
2086     * @param _to address of the future owner of the token
2087     * @param _amount number of tokens to mint
2088     * @param _merkleProof merkle proof array
2089     * @param _erc20TokenContract erc-20 token contract to mint with
2090     */
2091     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2092       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2093       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2094       require(_amount >= 1, "Must mint at least 1 token");
2095       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2096       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2097       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 600");
2098       
2099     
2100       // ERC-20 Specific pre-flight checks
2101       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2102       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2103       IERC20 payableToken = IERC20(_erc20TokenContract);
2104     
2105       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2106       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2107       
2108       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2109       require(transferComplete, "ERC-20 token was unable to be transferred");
2110       
2111       _safeMint(_to, _amount, false);
2112     }
2113 
2114     /**
2115      * @dev Enable allowlist minting fully by enabling both flags
2116      * This is a convenience function for the Rampp user
2117      */
2118     function openAllowlistMint() public onlyTeamOrOwner {
2119         enableAllowlistOnlyMode();
2120         mintingOpen = true;
2121     }
2122 
2123     /**
2124      * @dev Close allowlist minting fully by disabling both flags
2125      * This is a convenience function for the Rampp user
2126      */
2127     function closeAllowlistMint() public onlyTeamOrOwner {
2128         disableAllowlistOnlyMode();
2129         mintingOpen = false;
2130     }
2131 
2132 
2133   
2134     /**
2135     * @dev Check if wallet over MAX_WALLET_MINTS
2136     * @param _address address in question to check if minted count exceeds max
2137     */
2138     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2139         require(_amount >= 1, "Amount must be greater than or equal to 1");
2140         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2141     }
2142 
2143     /**
2144     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2145     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2146     */
2147     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2148         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2149         MAX_WALLET_MINTS = _newWalletMax;
2150     }
2151     
2152 
2153   
2154     /**
2155      * @dev Allows owner to set Max mints per tx
2156      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2157      */
2158      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2159          require(_newMaxMint >= 1, "Max mint must be at least 1");
2160          maxBatchSize = _newMaxMint;
2161      }
2162     
2163 
2164   
2165 
2166   function _baseURI() internal view virtual override returns(string memory) {
2167     return _baseTokenURI;
2168   }
2169 
2170   function _baseURIExtension() internal view virtual override returns(string memory) {
2171     return _baseTokenExtension;
2172   }
2173 
2174   function baseTokenURI() public view returns(string memory) {
2175     return _baseTokenURI;
2176   }
2177 
2178   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2179     _baseTokenURI = baseURI;
2180   }
2181 
2182   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2183     _baseTokenExtension = baseExtension;
2184   }
2185 
2186   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2187     return ownershipOf(tokenId);
2188   }
2189 }
2190 
2191 
2192   
2193 // File: contracts/FieldTripContract.sol
2194 //SPDX-License-Identifier: MIT
2195 
2196 pragma solidity ^0.8.0;
2197 
2198 contract FieldTripContract is RamppERC721A {
2199     constructor() RamppERC721A("Field Trip", "FTRIP"){}
2200 }
2201   
2202 //*********************************************************************//
2203 //*********************************************************************//  
2204 //                       Mintplex v3.0.0
2205 //
2206 //         This smart contract was generated by mintplex.xyz.
2207 //            Mintplex allows creators like you to launch 
2208 //             large scale NFT communities without code!
2209 //
2210 //    Mintplex is not responsible for the content of this contract and
2211 //        hopes it is being used in a responsible and kind way.  
2212 //       Mintplex is not associated or affiliated with this project.                                                    
2213 //             Twitter: @MintplexNFT ---- mintplex.xyz
2214 //*********************************************************************//                                                     
2215 //*********************************************************************// 
