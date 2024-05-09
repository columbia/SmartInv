1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //   _____  _     _          _  _  _ _______ _     _ _______ _     _  ______ 
5 //  (_____)| |   (_)  _     (_)(_)(_|_______|_)   | (_______) |   | |/ _____)
6 //   _____ | |__  _ _| |_    _  _  _ _     _ _____| |_____  | |___| ( (____  
7 //  / ___ \|  _ \| (_   _)  | || || | |   | |  _   _)  ___) |_____  |\____ \ 
8 // ( (___) ) |_) ) | | |_   | || || | |___| | |  \ \| |_____ _____| |_____) )
9 //  \_____/|____/|_|  \__)   \_____/ \_____/|_|   \_)_______|_______(______/
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
912 error NotMaintainer();
913   
914   
915 // Rampp Contracts v2.1 (Teams.sol)
916 
917 error InvalidTeamAddress();
918 error DuplicateTeamAddress();
919 pragma solidity ^0.8.0;
920 
921 /**
922 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
923 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
924 * This will easily allow cross-collaboration via Mintplex.xyz.
925 **/
926 abstract contract Teams is Ownable{
927   mapping (address => bool) internal team;
928 
929   /**
930   * @dev Adds an address to the team. Allows them to execute protected functions
931   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
932   **/
933   function addToTeam(address _address) public onlyOwner {
934     if(_address == address(0)) revert InvalidTeamAddress();
935     if(inTeam(_address)) revert DuplicateTeamAddress();
936   
937     team[_address] = true;
938   }
939 
940   /**
941   * @dev Removes an address to the team.
942   * @param _address the ETH address to remove, cannot be 0x and must be in team
943   **/
944   function removeFromTeam(address _address) public onlyOwner {
945     if(_address == address(0)) revert InvalidTeamAddress();
946     if(!inTeam(_address)) revert InvalidTeamAddress();
947   
948     team[_address] = false;
949   }
950 
951   /**
952   * @dev Check if an address is valid and active in the team
953   * @param _address ETH address to check for truthiness
954   **/
955   function inTeam(address _address)
956     public
957     view
958     returns (bool)
959   {
960     if(_address == address(0)) revert InvalidTeamAddress();
961     return team[_address] == true;
962   }
963 
964   /**
965   * @dev Throws if called by any account other than the owner or team member.
966   */
967   function _onlyTeamOrOwner() private view {
968     bool _isOwner = owner() == _msgSender();
969     bool _isTeam = inTeam(_msgSender());
970     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
971   }
972 
973   modifier onlyTeamOrOwner() {
974     _onlyTeamOrOwner();
975     _;
976   }
977 }
978 
979 
980   
981   pragma solidity ^0.8.0;
982 
983   /**
984   * @dev These functions deal with verification of Merkle Trees proofs.
985   *
986   * The proofs can be generated using the JavaScript library
987   * https://github.com/miguelmota/merkletreejs[merkletreejs].
988   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
989   *
990   *
991   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
992   * hashing, or use a hash function other than keccak256 for hashing leaves.
993   * This is because the concatenation of a sorted pair of internal nodes in
994   * the merkle tree could be reinterpreted as a leaf value.
995   */
996   library MerkleProof {
997       /**
998       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
999       * defined by 'root'. For this, a 'proof' must be provided, containing
1000       * sibling hashes on the branch from the leaf to the root of the tree. Each
1001       * pair of leaves and each pair of pre-images are assumed to be sorted.
1002       */
1003       function verify(
1004           bytes32[] memory proof,
1005           bytes32 root,
1006           bytes32 leaf
1007       ) internal pure returns (bool) {
1008           return processProof(proof, leaf) == root;
1009       }
1010 
1011       /**
1012       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1013       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1014       * hash matches the root of the tree. When processing the proof, the pairs
1015       * of leafs & pre-images are assumed to be sorted.
1016       *
1017       * _Available since v4.4._
1018       */
1019       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1020           bytes32 computedHash = leaf;
1021           for (uint256 i = 0; i < proof.length; i++) {
1022               bytes32 proofElement = proof[i];
1023               if (computedHash <= proofElement) {
1024                   // Hash(current computed hash + current element of the proof)
1025                   computedHash = _efficientHash(computedHash, proofElement);
1026               } else {
1027                   // Hash(current element of the proof + current computed hash)
1028                   computedHash = _efficientHash(proofElement, computedHash);
1029               }
1030           }
1031           return computedHash;
1032       }
1033 
1034       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1035           assembly {
1036               mstore(0x00, a)
1037               mstore(0x20, b)
1038               value := keccak256(0x00, 0x40)
1039           }
1040       }
1041   }
1042 
1043 
1044   // File: Allowlist.sol
1045 
1046   pragma solidity ^0.8.0;
1047 
1048   abstract contract Allowlist is Teams {
1049     bytes32 public merkleRoot;
1050     bool public onlyAllowlistMode = false;
1051 
1052     /**
1053      * @dev Update merkle root to reflect changes in Allowlist
1054      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1055      */
1056     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1057       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1058       merkleRoot = _newMerkleRoot;
1059     }
1060 
1061     /**
1062      * @dev Check the proof of an address if valid for merkle root
1063      * @param _to address to check for proof
1064      * @param _merkleProof Proof of the address to validate against root and leaf
1065      */
1066     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1067       if(merkleRoot == 0) revert ValueCannotBeZero();
1068       bytes32 leaf = keccak256(abi.encodePacked(_to));
1069 
1070       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1071     }
1072 
1073     
1074     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1075       onlyAllowlistMode = true;
1076     }
1077 
1078     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1079         onlyAllowlistMode = false;
1080     }
1081   }
1082   
1083   
1084 /**
1085  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1086  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1087  *
1088  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1089  * 
1090  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1091  *
1092  * Does not support burning tokens to address(0).
1093  */
1094 contract ERC721A is
1095   Context,
1096   ERC165,
1097   IERC721,
1098   IERC721Metadata,
1099   IERC721Enumerable,
1100   Teams
1101   , OperatorFilterer
1102 {
1103   using Address for address;
1104   using Strings for uint256;
1105 
1106   struct TokenOwnership {
1107     address addr;
1108     uint64 startTimestamp;
1109   }
1110 
1111   struct AddressData {
1112     uint128 balance;
1113     uint128 numberMinted;
1114   }
1115 
1116   uint256 private currentIndex;
1117 
1118   uint256 public immutable collectionSize;
1119   uint256 public maxBatchSize;
1120 
1121   // Token name
1122   string private _name;
1123 
1124   // Token symbol
1125   string private _symbol;
1126 
1127   // Mapping from token ID to ownership details
1128   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1129   mapping(uint256 => TokenOwnership) private _ownerships;
1130 
1131   // Mapping owner address to address data
1132   mapping(address => AddressData) private _addressData;
1133 
1134   // Mapping from token ID to approved address
1135   mapping(uint256 => address) private _tokenApprovals;
1136 
1137   // Mapping from owner to operator approvals
1138   mapping(address => mapping(address => bool)) private _operatorApprovals;
1139 
1140   /* @dev Mapping of restricted operator approvals set by contract Owner
1141   * This serves as an optional addition to ERC-721 so
1142   * that the contract owner can elect to prevent specific addresses/contracts
1143   * from being marked as the approver for a token. The reason for this
1144   * is that some projects may want to retain control of where their tokens can/can not be listed
1145   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1146   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1147   */
1148   mapping(address => bool) public restrictedApprovalAddresses;
1149 
1150   /**
1151    * @dev
1152    * maxBatchSize refers to how much a minter can mint at a time.
1153    * collectionSize_ refers to how many tokens are in the collection.
1154    */
1155   constructor(
1156     string memory name_,
1157     string memory symbol_,
1158     uint256 maxBatchSize_,
1159     uint256 collectionSize_
1160   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1161     require(
1162       collectionSize_ > 0,
1163       "ERC721A: collection must have a nonzero supply"
1164     );
1165     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1166     _name = name_;
1167     _symbol = symbol_;
1168     maxBatchSize = maxBatchSize_;
1169     collectionSize = collectionSize_;
1170     currentIndex = _startTokenId();
1171   }
1172 
1173   /**
1174   * To change the starting tokenId, please override this function.
1175   */
1176   function _startTokenId() internal view virtual returns (uint256) {
1177     return 1;
1178   }
1179 
1180   /**
1181    * @dev See {IERC721Enumerable-totalSupply}.
1182    */
1183   function totalSupply() public view override returns (uint256) {
1184     return _totalMinted();
1185   }
1186 
1187   function currentTokenId() public view returns (uint256) {
1188     return _totalMinted();
1189   }
1190 
1191   function getNextTokenId() public view returns (uint256) {
1192       return _totalMinted() + 1;
1193   }
1194 
1195   /**
1196   * Returns the total amount of tokens minted in the contract.
1197   */
1198   function _totalMinted() internal view returns (uint256) {
1199     unchecked {
1200       return currentIndex - _startTokenId();
1201     }
1202   }
1203 
1204   /**
1205    * @dev See {IERC721Enumerable-tokenByIndex}.
1206    */
1207   function tokenByIndex(uint256 index) public view override returns (uint256) {
1208     require(index < totalSupply(), "ERC721A: global index out of bounds");
1209     return index;
1210   }
1211 
1212   /**
1213    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1214    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1215    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1216    */
1217   function tokenOfOwnerByIndex(address owner, uint256 index)
1218     public
1219     view
1220     override
1221     returns (uint256)
1222   {
1223     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1224     uint256 numMintedSoFar = totalSupply();
1225     uint256 tokenIdsIdx = 0;
1226     address currOwnershipAddr = address(0);
1227     for (uint256 i = 0; i < numMintedSoFar; i++) {
1228       TokenOwnership memory ownership = _ownerships[i];
1229       if (ownership.addr != address(0)) {
1230         currOwnershipAddr = ownership.addr;
1231       }
1232       if (currOwnershipAddr == owner) {
1233         if (tokenIdsIdx == index) {
1234           return i;
1235         }
1236         tokenIdsIdx++;
1237       }
1238     }
1239     revert("ERC721A: unable to get token of owner by index");
1240   }
1241 
1242   /**
1243    * @dev See {IERC165-supportsInterface}.
1244    */
1245   function supportsInterface(bytes4 interfaceId)
1246     public
1247     view
1248     virtual
1249     override(ERC165, IERC165)
1250     returns (bool)
1251   {
1252     return
1253       interfaceId == type(IERC721).interfaceId ||
1254       interfaceId == type(IERC721Metadata).interfaceId ||
1255       interfaceId == type(IERC721Enumerable).interfaceId ||
1256       super.supportsInterface(interfaceId);
1257   }
1258 
1259   /**
1260    * @dev See {IERC721-balanceOf}.
1261    */
1262   function balanceOf(address owner) public view override returns (uint256) {
1263     require(owner != address(0), "ERC721A: balance query for the zero address");
1264     return uint256(_addressData[owner].balance);
1265   }
1266 
1267   function _numberMinted(address owner) internal view returns (uint256) {
1268     require(
1269       owner != address(0),
1270       "ERC721A: number minted query for the zero address"
1271     );
1272     return uint256(_addressData[owner].numberMinted);
1273   }
1274 
1275   function ownershipOf(uint256 tokenId)
1276     internal
1277     view
1278     returns (TokenOwnership memory)
1279   {
1280     uint256 curr = tokenId;
1281 
1282     unchecked {
1283         if (_startTokenId() <= curr && curr < currentIndex) {
1284             TokenOwnership memory ownership = _ownerships[curr];
1285             if (ownership.addr != address(0)) {
1286                 return ownership;
1287             }
1288 
1289             // Invariant:
1290             // There will always be an ownership that has an address and is not burned
1291             // before an ownership that does not have an address and is not burned.
1292             // Hence, curr will not underflow.
1293             while (true) {
1294                 curr--;
1295                 ownership = _ownerships[curr];
1296                 if (ownership.addr != address(0)) {
1297                     return ownership;
1298                 }
1299             }
1300         }
1301     }
1302 
1303     revert("ERC721A: unable to determine the owner of token");
1304   }
1305 
1306   /**
1307    * @dev See {IERC721-ownerOf}.
1308    */
1309   function ownerOf(uint256 tokenId) public view override returns (address) {
1310     return ownershipOf(tokenId).addr;
1311   }
1312 
1313   /**
1314    * @dev See {IERC721Metadata-name}.
1315    */
1316   function name() public view virtual override returns (string memory) {
1317     return _name;
1318   }
1319 
1320   /**
1321    * @dev See {IERC721Metadata-symbol}.
1322    */
1323   function symbol() public view virtual override returns (string memory) {
1324     return _symbol;
1325   }
1326 
1327   /**
1328    * @dev See {IERC721Metadata-tokenURI}.
1329    */
1330   function tokenURI(uint256 tokenId)
1331     public
1332     view
1333     virtual
1334     override
1335     returns (string memory)
1336   {
1337     string memory baseURI = _baseURI();
1338     string memory extension = _baseURIExtension();
1339     return
1340       bytes(baseURI).length > 0
1341         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1342         : "";
1343   }
1344 
1345   /**
1346    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1347    * token will be the concatenation of the baseURI and the tokenId. Empty
1348    * by default, can be overriden in child contracts.
1349    */
1350   function _baseURI() internal view virtual returns (string memory) {
1351     return "";
1352   }
1353 
1354   /**
1355    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1356    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1357    * by default, can be overriden in child contracts.
1358    */
1359   function _baseURIExtension() internal view virtual returns (string memory) {
1360     return "";
1361   }
1362 
1363   /**
1364    * @dev Sets the value for an address to be in the restricted approval address pool.
1365    * Setting an address to true will disable token owners from being able to mark the address
1366    * for approval for trading. This would be used in theory to prevent token owners from listing
1367    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1368    * @param _address the marketplace/user to modify restriction status of
1369    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1370    */
1371   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1372     restrictedApprovalAddresses[_address] = _isRestricted;
1373   }
1374 
1375   /**
1376    * @dev See {IERC721-approve}.
1377    */
1378   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1379     address owner = ERC721A.ownerOf(tokenId);
1380     require(to != owner, "ERC721A: approval to current owner");
1381     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1382 
1383     require(
1384       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1385       "ERC721A: approve caller is not owner nor approved for all"
1386     );
1387 
1388     _approve(to, tokenId, owner);
1389   }
1390 
1391   /**
1392    * @dev See {IERC721-getApproved}.
1393    */
1394   function getApproved(uint256 tokenId) public view override returns (address) {
1395     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1396 
1397     return _tokenApprovals[tokenId];
1398   }
1399 
1400   /**
1401    * @dev See {IERC721-setApprovalForAll}.
1402    */
1403   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1404     require(operator != _msgSender(), "ERC721A: approve to caller");
1405     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1406 
1407     _operatorApprovals[_msgSender()][operator] = approved;
1408     emit ApprovalForAll(_msgSender(), operator, approved);
1409   }
1410 
1411   /**
1412    * @dev See {IERC721-isApprovedForAll}.
1413    */
1414   function isApprovedForAll(address owner, address operator)
1415     public
1416     view
1417     virtual
1418     override
1419     returns (bool)
1420   {
1421     return _operatorApprovals[owner][operator];
1422   }
1423 
1424   /**
1425    * @dev See {IERC721-transferFrom}.
1426    */
1427   function transferFrom(
1428     address from,
1429     address to,
1430     uint256 tokenId
1431   ) public override onlyAllowedOperator(from) {
1432     _transfer(from, to, tokenId);
1433   }
1434 
1435   /**
1436    * @dev See {IERC721-safeTransferFrom}.
1437    */
1438   function safeTransferFrom(
1439     address from,
1440     address to,
1441     uint256 tokenId
1442   ) public override onlyAllowedOperator(from) {
1443     safeTransferFrom(from, to, tokenId, "");
1444   }
1445 
1446   /**
1447    * @dev See {IERC721-safeTransferFrom}.
1448    */
1449   function safeTransferFrom(
1450     address from,
1451     address to,
1452     uint256 tokenId,
1453     bytes memory _data
1454   ) public override onlyAllowedOperator(from) {
1455     _transfer(from, to, tokenId);
1456     require(
1457       _checkOnERC721Received(from, to, tokenId, _data),
1458       "ERC721A: transfer to non ERC721Receiver implementer"
1459     );
1460   }
1461 
1462   /**
1463    * @dev Returns whether tokenId exists.
1464    *
1465    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1466    *
1467    * Tokens start existing when they are minted (_mint),
1468    */
1469   function _exists(uint256 tokenId) internal view returns (bool) {
1470     return _startTokenId() <= tokenId && tokenId < currentIndex;
1471   }
1472 
1473   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1474     _safeMint(to, quantity, isAdminMint, "");
1475   }
1476 
1477   /**
1478    * @dev Mints quantity tokens and transfers them to to.
1479    *
1480    * Requirements:
1481    *
1482    * - there must be quantity tokens remaining unminted in the total collection.
1483    * - to cannot be the zero address.
1484    * - quantity cannot be larger than the max batch size.
1485    *
1486    * Emits a {Transfer} event.
1487    */
1488   function _safeMint(
1489     address to,
1490     uint256 quantity,
1491     bool isAdminMint,
1492     bytes memory _data
1493   ) internal {
1494     uint256 startTokenId = currentIndex;
1495     require(to != address(0), "ERC721A: mint to the zero address");
1496     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1497     require(!_exists(startTokenId), "ERC721A: token already minted");
1498 
1499     // For admin mints we do not want to enforce the maxBatchSize limit
1500     if (isAdminMint == false) {
1501         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1502     }
1503 
1504     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1505 
1506     AddressData memory addressData = _addressData[to];
1507     _addressData[to] = AddressData(
1508       addressData.balance + uint128(quantity),
1509       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1510     );
1511     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1512 
1513     uint256 updatedIndex = startTokenId;
1514 
1515     for (uint256 i = 0; i < quantity; i++) {
1516       emit Transfer(address(0), to, updatedIndex);
1517       require(
1518         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1519         "ERC721A: transfer to non ERC721Receiver implementer"
1520       );
1521       updatedIndex++;
1522     }
1523 
1524     currentIndex = updatedIndex;
1525     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1526   }
1527 
1528   /**
1529    * @dev Transfers tokenId from from to to.
1530    *
1531    * Requirements:
1532    *
1533    * - to cannot be the zero address.
1534    * - tokenId token must be owned by from.
1535    *
1536    * Emits a {Transfer} event.
1537    */
1538   function _transfer(
1539     address from,
1540     address to,
1541     uint256 tokenId
1542   ) private {
1543     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1544 
1545     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1546       getApproved(tokenId) == _msgSender() ||
1547       isApprovedForAll(prevOwnership.addr, _msgSender()));
1548 
1549     require(
1550       isApprovedOrOwner,
1551       "ERC721A: transfer caller is not owner nor approved"
1552     );
1553 
1554     require(
1555       prevOwnership.addr == from,
1556       "ERC721A: transfer from incorrect owner"
1557     );
1558     require(to != address(0), "ERC721A: transfer to the zero address");
1559 
1560     _beforeTokenTransfers(from, to, tokenId, 1);
1561 
1562     // Clear approvals from the previous owner
1563     _approve(address(0), tokenId, prevOwnership.addr);
1564 
1565     _addressData[from].balance -= 1;
1566     _addressData[to].balance += 1;
1567     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1568 
1569     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1570     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1571     uint256 nextTokenId = tokenId + 1;
1572     if (_ownerships[nextTokenId].addr == address(0)) {
1573       if (_exists(nextTokenId)) {
1574         _ownerships[nextTokenId] = TokenOwnership(
1575           prevOwnership.addr,
1576           prevOwnership.startTimestamp
1577         );
1578       }
1579     }
1580 
1581     emit Transfer(from, to, tokenId);
1582     _afterTokenTransfers(from, to, tokenId, 1);
1583   }
1584 
1585   /**
1586    * @dev Approve to to operate on tokenId
1587    *
1588    * Emits a {Approval} event.
1589    */
1590   function _approve(
1591     address to,
1592     uint256 tokenId,
1593     address owner
1594   ) private {
1595     _tokenApprovals[tokenId] = to;
1596     emit Approval(owner, to, tokenId);
1597   }
1598 
1599   uint256 public nextOwnerToExplicitlySet = 0;
1600 
1601   /**
1602    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1603    */
1604   function _setOwnersExplicit(uint256 quantity) internal {
1605     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1606     require(quantity > 0, "quantity must be nonzero");
1607     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1608 
1609     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1610     if (endIndex > collectionSize - 1) {
1611       endIndex = collectionSize - 1;
1612     }
1613     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1614     require(_exists(endIndex), "not enough minted yet for this cleanup");
1615     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1616       if (_ownerships[i].addr == address(0)) {
1617         TokenOwnership memory ownership = ownershipOf(i);
1618         _ownerships[i] = TokenOwnership(
1619           ownership.addr,
1620           ownership.startTimestamp
1621         );
1622       }
1623     }
1624     nextOwnerToExplicitlySet = endIndex + 1;
1625   }
1626 
1627   /**
1628    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1629    * The call is not executed if the target address is not a contract.
1630    *
1631    * @param from address representing the previous owner of the given token ID
1632    * @param to target address that will receive the tokens
1633    * @param tokenId uint256 ID of the token to be transferred
1634    * @param _data bytes optional data to send along with the call
1635    * @return bool whether the call correctly returned the expected magic value
1636    */
1637   function _checkOnERC721Received(
1638     address from,
1639     address to,
1640     uint256 tokenId,
1641     bytes memory _data
1642   ) private returns (bool) {
1643     if (to.isContract()) {
1644       try
1645         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1646       returns (bytes4 retval) {
1647         return retval == IERC721Receiver(to).onERC721Received.selector;
1648       } catch (bytes memory reason) {
1649         if (reason.length == 0) {
1650           revert("ERC721A: transfer to non ERC721Receiver implementer");
1651         } else {
1652           assembly {
1653             revert(add(32, reason), mload(reason))
1654           }
1655         }
1656       }
1657     } else {
1658       return true;
1659     }
1660   }
1661 
1662   /**
1663    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1664    *
1665    * startTokenId - the first token id to be transferred
1666    * quantity - the amount to be transferred
1667    *
1668    * Calling conditions:
1669    *
1670    * - When from and to are both non-zero, from's tokenId will be
1671    * transferred to to.
1672    * - When from is zero, tokenId will be minted for to.
1673    */
1674   function _beforeTokenTransfers(
1675     address from,
1676     address to,
1677     uint256 startTokenId,
1678     uint256 quantity
1679   ) internal virtual {}
1680 
1681   /**
1682    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1683    * minting.
1684    *
1685    * startTokenId - the first token id to be transferred
1686    * quantity - the amount to be transferred
1687    *
1688    * Calling conditions:
1689    *
1690    * - when from and to are both non-zero.
1691    * - from and to are never both zero.
1692    */
1693   function _afterTokenTransfers(
1694     address from,
1695     address to,
1696     uint256 startTokenId,
1697     uint256 quantity
1698   ) internal virtual {}
1699 }
1700 
1701 abstract contract ProviderFees is Context {
1702   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1703   uint256 public PROVIDER_FEE = 0.000777 ether;  
1704 
1705   function sendProviderFee() internal {
1706     payable(PROVIDER).transfer(PROVIDER_FEE);
1707   }
1708 
1709   function setProviderFee(uint256 _fee) public {
1710     if(_msgSender() != PROVIDER) revert NotMaintainer();
1711     PROVIDER_FEE = _fee;
1712   }
1713 }
1714 
1715 
1716 
1717   
1718 /** TimedDrop.sol
1719 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1720 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1721 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1722 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1723 */
1724 abstract contract TimedDrop is Teams {
1725   bool public enforcePublicDropTime = true;
1726   uint256 public publicDropTime = 1680462000;
1727   
1728   /**
1729   * @dev Allow the contract owner to set the public time to mint.
1730   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1731   */
1732   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1733     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1734     publicDropTime = _newDropTime;
1735   }
1736 
1737   function usePublicDropTime() public onlyTeamOrOwner {
1738     enforcePublicDropTime = true;
1739   }
1740 
1741   function disablePublicDropTime() public onlyTeamOrOwner {
1742     enforcePublicDropTime = false;
1743   }
1744 
1745   /**
1746   * @dev determine if the public droptime has passed.
1747   * if the feature is disabled then assume the time has passed.
1748   */
1749   function publicDropTimePassed() public view returns(bool) {
1750     if(enforcePublicDropTime == false) {
1751       return true;
1752     }
1753     return block.timestamp >= publicDropTime;
1754   }
1755   
1756   // Allowlist implementation of the Timed Drop feature
1757   bool public enforceAllowlistDropTime = false;
1758   uint256 public allowlistDropTime = 0;
1759 
1760   /**
1761   * @dev Allow the contract owner to set the allowlist time to mint.
1762   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1763   */
1764   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1765     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1766     allowlistDropTime = _newDropTime;
1767   }
1768 
1769   function useAllowlistDropTime() public onlyTeamOrOwner {
1770     enforceAllowlistDropTime = true;
1771   }
1772 
1773   function disableAllowlistDropTime() public onlyTeamOrOwner {
1774     enforceAllowlistDropTime = false;
1775   }
1776 
1777   function allowlistDropTimePassed() public view returns(bool) {
1778     if(enforceAllowlistDropTime == false) {
1779       return true;
1780     }
1781 
1782     return block.timestamp >= allowlistDropTime;
1783   }
1784 }
1785 
1786   
1787 interface IERC20 {
1788   function allowance(address owner, address spender) external view returns (uint256);
1789   function transfer(address _to, uint256 _amount) external returns (bool);
1790   function balanceOf(address account) external view returns (uint256);
1791   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1792 }
1793 
1794 // File: WithdrawableV2
1795 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1796 // ERC-20 Payouts are limited to a single payout address. This feature 
1797 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1798 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1799 abstract contract WithdrawableV2 is Teams {
1800   struct acceptedERC20 {
1801     bool isActive;
1802     uint256 chargeAmount;
1803   }
1804 
1805   
1806   mapping(address => acceptedERC20) private allowedTokenContracts;
1807   address[] public payableAddresses = [0x562090a33705f43eEc17e5CFF05106849d115C07];
1808   address public erc20Payable = 0x562090a33705f43eEc17e5CFF05106849d115C07;
1809   uint256[] public payableFees = [100];
1810   uint256 public payableAddressCount = 1;
1811   bool public onlyERC20MintingMode;
1812   
1813 
1814   function withdrawAll() public onlyTeamOrOwner {
1815       if(address(this).balance == 0) revert ValueCannotBeZero();
1816       _withdrawAll(address(this).balance);
1817   }
1818 
1819   function _withdrawAll(uint256 balance) private {
1820       for(uint i=0; i < payableAddressCount; i++ ) {
1821           _widthdraw(
1822               payableAddresses[i],
1823               (balance * payableFees[i]) / 100
1824           );
1825       }
1826   }
1827   
1828   function _widthdraw(address _address, uint256 _amount) private {
1829       (bool success, ) = _address.call{value: _amount}("");
1830       require(success, "Transfer failed.");
1831   }
1832 
1833   /**
1834   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1835   * in the event ERC-20 tokens are paid to the contract for mints.
1836   * @param _tokenContract contract of ERC-20 token to withdraw
1837   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1838   */
1839   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1840     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1841     IERC20 tokenContract = IERC20(_tokenContract);
1842     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1843     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1844   }
1845 
1846   /**
1847   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1848   * @param _erc20TokenContract address of ERC-20 contract in question
1849   */
1850   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1851     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1852   }
1853 
1854   /**
1855   * @dev get the value of tokens to transfer for user of an ERC-20
1856   * @param _erc20TokenContract address of ERC-20 contract in question
1857   */
1858   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1859     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1860     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1861   }
1862 
1863   /**
1864   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1865   * @param _erc20TokenContract address of ERC-20 contract in question
1866   * @param _isActive default status of if contract should be allowed to accept payments
1867   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1868   */
1869   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1870     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1871     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1872   }
1873 
1874   /**
1875   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1876   * it will assume the default value of zero. This should not be used to create new payment tokens.
1877   * @param _erc20TokenContract address of ERC-20 contract in question
1878   */
1879   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1880     allowedTokenContracts[_erc20TokenContract].isActive = true;
1881   }
1882 
1883   /**
1884   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1885   * it will assume the default value of zero. This should not be used to create new payment tokens.
1886   * @param _erc20TokenContract address of ERC-20 contract in question
1887   */
1888   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1889     allowedTokenContracts[_erc20TokenContract].isActive = false;
1890   }
1891 
1892   /**
1893   * @dev Enable only ERC-20 payments for minting on this contract
1894   */
1895   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1896     onlyERC20MintingMode = true;
1897   }
1898 
1899   /**
1900   * @dev Disable only ERC-20 payments for minting on this contract
1901   */
1902   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1903     onlyERC20MintingMode = false;
1904   }
1905 
1906   /**
1907   * @dev Set the payout of the ERC-20 token payout to a specific address
1908   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1909   */
1910   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1911     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1912     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1913     erc20Payable = _newErc20Payable;
1914   }
1915 }
1916 
1917 
1918   
1919 // File: isFeeable.sol
1920 abstract contract Feeable is Teams, ProviderFees {
1921   uint256 public PRICE = 0 ether;
1922 
1923   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1924     PRICE = _feeInWei;
1925   }
1926 
1927   function getPrice(uint256 _count) public view returns (uint256) {
1928     return (PRICE * _count) + PROVIDER_FEE;
1929   }
1930 }
1931 
1932   
1933 /* File: Tippable.sol
1934 /* @dev Allows owner to set strict enforcement of payment to mint price.
1935 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1936 /* when doing a free mint with opt-in pricing.
1937 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1938 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1939 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1940 /* Pros - can take in gratituity payments during a mint. 
1941 /* Cons - However if you decrease pricing during mint txn settlement 
1942 /* it can result in mints landing who technically now have overpaid.
1943 */
1944 abstract contract Tippable is Teams {
1945   bool public strictPricing = true;
1946 
1947   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1948     strictPricing = _newStatus;
1949   }
1950 
1951   // @dev check if msg.value is correct according to pricing enforcement
1952   // @param _msgValue -> passed in msg.value of tx
1953   // @param _expectedPrice -> result of getPrice(...args)
1954   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1955     return strictPricing ? 
1956       _msgValue == _expectedPrice : 
1957       _msgValue >= _expectedPrice;
1958   }
1959 }
1960 
1961   
1962   
1963   
1964 abstract contract ERC721APlus is 
1965     Ownable,
1966     Teams,
1967     ERC721A,
1968     WithdrawableV2,
1969     ReentrancyGuard 
1970     , Feeable, Tippable 
1971     , Allowlist 
1972     , TimedDrop
1973 {
1974   constructor(
1975     string memory tokenName,
1976     string memory tokenSymbol
1977   ) ERC721A(tokenName, tokenSymbol, 1, 1000) { }
1978     uint8 constant public CONTRACT_VERSION = 2;
1979     string public _baseTokenURI = "ipfs://bafybeibjrxxunsv2jluapp5sivv7dr5qcetwhq5bldvekeipzouh4lynjy/";
1980     string public _baseTokenExtension = ".json";
1981 
1982     bool public mintingOpen = true;
1983     bool public isRevealed;
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
1996          if(_qty == 0) revert MintZeroQuantity();
1997          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
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
2010         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2011         if(_amount == 0) revert MintZeroQuantity();
2012         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2013         if(!mintingOpen) revert PublicMintClosed();
2014         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2015         if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
2016         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2017         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2018         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2019         sendProviderFee();
2020         _safeMint(_to, _amount, false);
2021     }
2022 
2023     /**
2024      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2025      * fee may or may not be required*
2026      * @param _to address of the future owner of the token
2027      * @param _amount number of tokens to mint
2028      * @param _erc20TokenContract erc-20 token contract to mint with
2029      */
2030     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2031       if(_amount == 0) revert MintZeroQuantity();
2032       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2033       if(!mintingOpen) revert PublicMintClosed();
2034       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2035       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2036       if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
2037       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2038       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2039 
2040       // ERC-20 Specific pre-flight checks
2041       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2042       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2043       IERC20 payableToken = IERC20(_erc20TokenContract);
2044 
2045       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2046       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2047 
2048       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2049       if(!transferComplete) revert ERC20TransferFailed();
2050 
2051       sendProviderFee();
2052       _safeMint(_to, _amount, false);
2053     }
2054 
2055     function openMinting() public onlyTeamOrOwner {
2056         mintingOpen = true;
2057     }
2058 
2059     function stopMinting() public onlyTeamOrOwner {
2060         mintingOpen = false;
2061     }
2062 
2063   
2064     ///////////// ALLOWLIST MINTING FUNCTIONS
2065     /**
2066     * @dev Mints tokens to an address using an allowlist.
2067     * fee may or may not be required*
2068     * @param _to address of the future owner of the token
2069     * @param _amount number of tokens to mint
2070     * @param _merkleProof merkle proof array
2071     */
2072     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2073         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2074         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2075         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2076         if(_amount == 0) revert MintZeroQuantity();
2077         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2078         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2079         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2080         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2081         if(!allowlistDropTimePassed()) revert AllowlistDropTimeHasNotPassed();
2082 
2083         sendProviderFee();
2084         _safeMint(_to, _amount, false);
2085     }
2086 
2087     /**
2088     * @dev Mints tokens to an address using an allowlist.
2089     * fee may or may not be required*
2090     * @param _to address of the future owner of the token
2091     * @param _amount number of tokens to mint
2092     * @param _merkleProof merkle proof array
2093     * @param _erc20TokenContract erc-20 token contract to mint with
2094     */
2095     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2096       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2097       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2098       if(_amount == 0) revert MintZeroQuantity();
2099       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2100       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2101       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2102       if(!allowlistDropTimePassed()) revert AllowlistDropTimeHasNotPassed();
2103       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2104 
2105       // ERC-20 Specific pre-flight checks
2106       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2107       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2108       IERC20 payableToken = IERC20(_erc20TokenContract);
2109 
2110       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2111       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2112 
2113       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2114       if(!transferComplete) revert ERC20TransferFailed();
2115       
2116       sendProviderFee();
2117       _safeMint(_to, _amount, false);
2118     }
2119 
2120     /**
2121      * @dev Enable allowlist minting fully by enabling both flags
2122      * This is a convenience function for the Rampp user
2123      */
2124     function openAllowlistMint() public onlyTeamOrOwner {
2125         enableAllowlistOnlyMode();
2126         mintingOpen = true;
2127     }
2128 
2129     /**
2130      * @dev Close allowlist minting fully by disabling both flags
2131      * This is a convenience function for the Rampp user
2132      */
2133     function closeAllowlistMint() public onlyTeamOrOwner {
2134         disableAllowlistOnlyMode();
2135         mintingOpen = false;
2136     }
2137 
2138 
2139   
2140     /**
2141     * @dev Check if wallet over MAX_WALLET_MINTS
2142     * @param _address address in question to check if minted count exceeds max
2143     */
2144     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2145         if(_amount == 0) revert ValueCannotBeZero();
2146         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2147     }
2148 
2149     /**
2150     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2151     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2152     */
2153     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2154         if(_newWalletMax == 0) revert ValueCannotBeZero();
2155         MAX_WALLET_MINTS = _newWalletMax;
2156     }
2157     
2158 
2159   
2160     /**
2161      * @dev Allows owner to set Max mints per tx
2162      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2163      */
2164      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2165          if(_newMaxMint == 0) revert ValueCannotBeZero();
2166          maxBatchSize = _newMaxMint;
2167      }
2168     
2169 
2170   
2171     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2172         if(isRevealed) revert IsAlreadyUnveiled();
2173         _baseTokenURI = _updatedTokenURI;
2174         isRevealed = true;
2175     }
2176     
2177   
2178   
2179   function contractURI() public pure returns (string memory) {
2180     return "https://metadata.mintplex.xyz/ae1n5ndadiJhAnA6usUG/contract-metadata";
2181   }
2182   
2183 
2184   function _baseURI() internal view virtual override returns(string memory) {
2185     return _baseTokenURI;
2186   }
2187 
2188   function _baseURIExtension() internal view virtual override returns(string memory) {
2189     return _baseTokenExtension;
2190   }
2191 
2192   function baseTokenURI() public view returns(string memory) {
2193     return _baseTokenURI;
2194   }
2195 
2196   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2197     _baseTokenURI = baseURI;
2198   }
2199 
2200   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2201     _baseTokenExtension = baseExtension;
2202   }
2203 }
2204 
2205 
2206   
2207 // File: contracts/X8BitWokeysContract.sol
2208 //SPDX-License-Identifier: MIT
2209 
2210 pragma solidity ^0.8.0;
2211 
2212 contract X8BitWokeysContract is ERC721APlus {
2213     constructor() ERC721APlus("8bit WOKEYS", "MINTPLEX"){}
2214 }
2215   
2216 //*********************************************************************//
2217 //*********************************************************************//  
2218 //                       Mintplex v3.0.0
2219 //
2220 //         This smart contract was generated by mintplex.xyz.
2221 //            Mintplex allows creators like you to launch 
2222 //             large scale NFT communities without code!
2223 //
2224 //    Mintplex is not responsible for the content of this contract and
2225 //        hopes it is being used in a responsible and kind way.  
2226 //       Mintplex is not associated or affiliated with this project.                                                    
2227 //             Twitter: @MintplexNFT ---- mintplex.xyz
2228 //*********************************************************************//                                                     
2229 //*********************************************************************// 
