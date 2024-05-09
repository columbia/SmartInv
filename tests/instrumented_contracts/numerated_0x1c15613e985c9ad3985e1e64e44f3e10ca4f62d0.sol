1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // _________                        __            ____  __.                      _________ .__       ___.    
5 // \_   ___ \_______ ___.__._______/  |_  ____   |    |/ _|____   ____    ____   \_   ___ \|  |  __ _\_ |__  
6 // /    \  \/\_  __ <   |  |\____ \   __\/  _ \  |      < /  _ \ /    \  / ___\  /    \  \/|  | |  |  \ __ \ 
7 // \     \____|  | \/\___  ||  |_> >  | (  <_> ) |    |  (  <_> )   |  \/ /_/  > \     \___|  |_|  |  / \_\ \
8 //  \______  /|__|   / ____||   __/|__|  \____/  |____|__ \____/|___|  /\___  /   \______  /____/____/|___  /
9 //         \/        \/     |__|                         \/          \//_____/           \/               \/ 
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
786 * This will easily allow cross-collaboration via Mintplex.xyz.
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
839   pragma solidity ^0.8.0;
840 
841   /**
842   * @dev These functions deal with verification of Merkle Trees proofs.
843   *
844   * The proofs can be generated using the JavaScript library
845   * https://github.com/miguelmota/merkletreejs[merkletreejs].
846   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
847   *
848   *
849   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
850   * hashing, or use a hash function other than keccak256 for hashing leaves.
851   * This is because the concatenation of a sorted pair of internal nodes in
852   * the merkle tree could be reinterpreted as a leaf value.
853   */
854   library MerkleProof {
855       /**
856       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
857       * defined by 'root'. For this, a 'proof' must be provided, containing
858       * sibling hashes on the branch from the leaf to the root of the tree. Each
859       * pair of leaves and each pair of pre-images are assumed to be sorted.
860       */
861       function verify(
862           bytes32[] memory proof,
863           bytes32 root,
864           bytes32 leaf
865       ) internal pure returns (bool) {
866           return processProof(proof, leaf) == root;
867       }
868 
869       /**
870       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
871       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
872       * hash matches the root of the tree. When processing the proof, the pairs
873       * of leafs & pre-images are assumed to be sorted.
874       *
875       * _Available since v4.4._
876       */
877       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
878           bytes32 computedHash = leaf;
879           for (uint256 i = 0; i < proof.length; i++) {
880               bytes32 proofElement = proof[i];
881               if (computedHash <= proofElement) {
882                   // Hash(current computed hash + current element of the proof)
883                   computedHash = _efficientHash(computedHash, proofElement);
884               } else {
885                   // Hash(current element of the proof + current computed hash)
886                   computedHash = _efficientHash(proofElement, computedHash);
887               }
888           }
889           return computedHash;
890       }
891 
892       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
893           assembly {
894               mstore(0x00, a)
895               mstore(0x20, b)
896               value := keccak256(0x00, 0x40)
897           }
898       }
899   }
900 
901 
902   // File: Allowlist.sol
903 
904   pragma solidity ^0.8.0;
905 
906   abstract contract Allowlist is Teams {
907     bytes32 public merkleRoot;
908     bool public onlyAllowlistMode = false;
909 
910     /**
911      * @dev Update merkle root to reflect changes in Allowlist
912      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
913      */
914     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
915       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
916       merkleRoot = _newMerkleRoot;
917     }
918 
919     /**
920      * @dev Check the proof of an address if valid for merkle root
921      * @param _to address to check for proof
922      * @param _merkleProof Proof of the address to validate against root and leaf
923      */
924     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
925       require(merkleRoot != 0, "Merkle root is not set!");
926       bytes32 leaf = keccak256(abi.encodePacked(_to));
927 
928       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
929     }
930 
931     
932     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
933       onlyAllowlistMode = true;
934     }
935 
936     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
937         onlyAllowlistMode = false;
938     }
939   }
940   
941   
942 /**
943  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
944  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
945  *
946  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
947  * 
948  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
949  *
950  * Does not support burning tokens to address(0).
951  */
952 contract ERC721A is
953   Context,
954   ERC165,
955   IERC721,
956   IERC721Metadata,
957   IERC721Enumerable,
958   Teams
959 {
960   using Address for address;
961   using Strings for uint256;
962 
963   struct TokenOwnership {
964     address addr;
965     uint64 startTimestamp;
966   }
967 
968   struct AddressData {
969     uint128 balance;
970     uint128 numberMinted;
971   }
972 
973   uint256 private currentIndex;
974 
975   uint256 public immutable collectionSize;
976   uint256 public maxBatchSize;
977 
978   // Token name
979   string private _name;
980 
981   // Token symbol
982   string private _symbol;
983 
984   // Mapping from token ID to ownership details
985   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
986   mapping(uint256 => TokenOwnership) private _ownerships;
987 
988   // Mapping owner address to address data
989   mapping(address => AddressData) private _addressData;
990 
991   // Mapping from token ID to approved address
992   mapping(uint256 => address) private _tokenApprovals;
993 
994   // Mapping from owner to operator approvals
995   mapping(address => mapping(address => bool)) private _operatorApprovals;
996 
997   /* @dev Mapping of restricted operator approvals set by contract Owner
998   * This serves as an optional addition to ERC-721 so
999   * that the contract owner can elect to prevent specific addresses/contracts
1000   * from being marked as the approver for a token. The reason for this
1001   * is that some projects may want to retain control of where their tokens can/can not be listed
1002   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1003   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1004   */
1005   mapping(address => bool) public restrictedApprovalAddresses;
1006 
1007   /**
1008    * @dev
1009    * maxBatchSize refers to how much a minter can mint at a time.
1010    * collectionSize_ refers to how many tokens are in the collection.
1011    */
1012   constructor(
1013     string memory name_,
1014     string memory symbol_,
1015     uint256 maxBatchSize_,
1016     uint256 collectionSize_
1017   ) {
1018     require(
1019       collectionSize_ > 0,
1020       "ERC721A: collection must have a nonzero supply"
1021     );
1022     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1023     _name = name_;
1024     _symbol = symbol_;
1025     maxBatchSize = maxBatchSize_;
1026     collectionSize = collectionSize_;
1027     currentIndex = _startTokenId();
1028   }
1029 
1030   /**
1031   * To change the starting tokenId, please override this function.
1032   */
1033   function _startTokenId() internal view virtual returns (uint256) {
1034     return 1;
1035   }
1036 
1037   /**
1038    * @dev See {IERC721Enumerable-totalSupply}.
1039    */
1040   function totalSupply() public view override returns (uint256) {
1041     return _totalMinted();
1042   }
1043 
1044   function currentTokenId() public view returns (uint256) {
1045     return _totalMinted();
1046   }
1047 
1048   function getNextTokenId() public view returns (uint256) {
1049       return _totalMinted() + 1;
1050   }
1051 
1052   /**
1053   * Returns the total amount of tokens minted in the contract.
1054   */
1055   function _totalMinted() internal view returns (uint256) {
1056     unchecked {
1057       return currentIndex - _startTokenId();
1058     }
1059   }
1060 
1061   /**
1062    * @dev See {IERC721Enumerable-tokenByIndex}.
1063    */
1064   function tokenByIndex(uint256 index) public view override returns (uint256) {
1065     require(index < totalSupply(), "ERC721A: global index out of bounds");
1066     return index;
1067   }
1068 
1069   /**
1070    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1071    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1072    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1073    */
1074   function tokenOfOwnerByIndex(address owner, uint256 index)
1075     public
1076     view
1077     override
1078     returns (uint256)
1079   {
1080     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1081     uint256 numMintedSoFar = totalSupply();
1082     uint256 tokenIdsIdx = 0;
1083     address currOwnershipAddr = address(0);
1084     for (uint256 i = 0; i < numMintedSoFar; i++) {
1085       TokenOwnership memory ownership = _ownerships[i];
1086       if (ownership.addr != address(0)) {
1087         currOwnershipAddr = ownership.addr;
1088       }
1089       if (currOwnershipAddr == owner) {
1090         if (tokenIdsIdx == index) {
1091           return i;
1092         }
1093         tokenIdsIdx++;
1094       }
1095     }
1096     revert("ERC721A: unable to get token of owner by index");
1097   }
1098 
1099   /**
1100    * @dev See {IERC165-supportsInterface}.
1101    */
1102   function supportsInterface(bytes4 interfaceId)
1103     public
1104     view
1105     virtual
1106     override(ERC165, IERC165)
1107     returns (bool)
1108   {
1109     return
1110       interfaceId == type(IERC721).interfaceId ||
1111       interfaceId == type(IERC721Metadata).interfaceId ||
1112       interfaceId == type(IERC721Enumerable).interfaceId ||
1113       super.supportsInterface(interfaceId);
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-balanceOf}.
1118    */
1119   function balanceOf(address owner) public view override returns (uint256) {
1120     require(owner != address(0), "ERC721A: balance query for the zero address");
1121     return uint256(_addressData[owner].balance);
1122   }
1123 
1124   function _numberMinted(address owner) internal view returns (uint256) {
1125     require(
1126       owner != address(0),
1127       "ERC721A: number minted query for the zero address"
1128     );
1129     return uint256(_addressData[owner].numberMinted);
1130   }
1131 
1132   function ownershipOf(uint256 tokenId)
1133     internal
1134     view
1135     returns (TokenOwnership memory)
1136   {
1137     uint256 curr = tokenId;
1138 
1139     unchecked {
1140         if (_startTokenId() <= curr && curr < currentIndex) {
1141             TokenOwnership memory ownership = _ownerships[curr];
1142             if (ownership.addr != address(0)) {
1143                 return ownership;
1144             }
1145 
1146             // Invariant:
1147             // There will always be an ownership that has an address and is not burned
1148             // before an ownership that does not have an address and is not burned.
1149             // Hence, curr will not underflow.
1150             while (true) {
1151                 curr--;
1152                 ownership = _ownerships[curr];
1153                 if (ownership.addr != address(0)) {
1154                     return ownership;
1155                 }
1156             }
1157         }
1158     }
1159 
1160     revert("ERC721A: unable to determine the owner of token");
1161   }
1162 
1163   /**
1164    * @dev See {IERC721-ownerOf}.
1165    */
1166   function ownerOf(uint256 tokenId) public view override returns (address) {
1167     return ownershipOf(tokenId).addr;
1168   }
1169 
1170   /**
1171    * @dev See {IERC721Metadata-name}.
1172    */
1173   function name() public view virtual override returns (string memory) {
1174     return _name;
1175   }
1176 
1177   /**
1178    * @dev See {IERC721Metadata-symbol}.
1179    */
1180   function symbol() public view virtual override returns (string memory) {
1181     return _symbol;
1182   }
1183 
1184   /**
1185    * @dev See {IERC721Metadata-tokenURI}.
1186    */
1187   function tokenURI(uint256 tokenId)
1188     public
1189     view
1190     virtual
1191     override
1192     returns (string memory)
1193   {
1194     string memory baseURI = _baseURI();
1195     return
1196       bytes(baseURI).length > 0
1197         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1198         : "";
1199   }
1200 
1201   /**
1202    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203    * token will be the concatenation of the baseURI and the tokenId. Empty
1204    * by default, can be overriden in child contracts.
1205    */
1206   function _baseURI() internal view virtual returns (string memory) {
1207     return "";
1208   }
1209 
1210   /**
1211    * @dev Sets the value for an address to be in the restricted approval address pool.
1212    * Setting an address to true will disable token owners from being able to mark the address
1213    * for approval for trading. This would be used in theory to prevent token owners from listing
1214    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1215    * @param _address the marketplace/user to modify restriction status of
1216    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1217    */
1218   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1219     restrictedApprovalAddresses[_address] = _isRestricted;
1220   }
1221 
1222   /**
1223    * @dev See {IERC721-approve}.
1224    */
1225   function approve(address to, uint256 tokenId) public override {
1226     address owner = ERC721A.ownerOf(tokenId);
1227     require(to != owner, "ERC721A: approval to current owner");
1228     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1229 
1230     require(
1231       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1232       "ERC721A: approve caller is not owner nor approved for all"
1233     );
1234 
1235     _approve(to, tokenId, owner);
1236   }
1237 
1238   /**
1239    * @dev See {IERC721-getApproved}.
1240    */
1241   function getApproved(uint256 tokenId) public view override returns (address) {
1242     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1243 
1244     return _tokenApprovals[tokenId];
1245   }
1246 
1247   /**
1248    * @dev See {IERC721-setApprovalForAll}.
1249    */
1250   function setApprovalForAll(address operator, bool approved) public override {
1251     require(operator != _msgSender(), "ERC721A: approve to caller");
1252     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1253 
1254     _operatorApprovals[_msgSender()][operator] = approved;
1255     emit ApprovalForAll(_msgSender(), operator, approved);
1256   }
1257 
1258   /**
1259    * @dev See {IERC721-isApprovedForAll}.
1260    */
1261   function isApprovedForAll(address owner, address operator)
1262     public
1263     view
1264     virtual
1265     override
1266     returns (bool)
1267   {
1268     return _operatorApprovals[owner][operator];
1269   }
1270 
1271   /**
1272    * @dev See {IERC721-transferFrom}.
1273    */
1274   function transferFrom(
1275     address from,
1276     address to,
1277     uint256 tokenId
1278   ) public override {
1279     _transfer(from, to, tokenId);
1280   }
1281 
1282   /**
1283    * @dev See {IERC721-safeTransferFrom}.
1284    */
1285   function safeTransferFrom(
1286     address from,
1287     address to,
1288     uint256 tokenId
1289   ) public override {
1290     safeTransferFrom(from, to, tokenId, "");
1291   }
1292 
1293   /**
1294    * @dev See {IERC721-safeTransferFrom}.
1295    */
1296   function safeTransferFrom(
1297     address from,
1298     address to,
1299     uint256 tokenId,
1300     bytes memory _data
1301   ) public override {
1302     _transfer(from, to, tokenId);
1303     require(
1304       _checkOnERC721Received(from, to, tokenId, _data),
1305       "ERC721A: transfer to non ERC721Receiver implementer"
1306     );
1307   }
1308 
1309   /**
1310    * @dev Returns whether tokenId exists.
1311    *
1312    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1313    *
1314    * Tokens start existing when they are minted (_mint),
1315    */
1316   function _exists(uint256 tokenId) internal view returns (bool) {
1317     return _startTokenId() <= tokenId && tokenId < currentIndex;
1318   }
1319 
1320   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1321     _safeMint(to, quantity, isAdminMint, "");
1322   }
1323 
1324   /**
1325    * @dev Mints quantity tokens and transfers them to to.
1326    *
1327    * Requirements:
1328    *
1329    * - there must be quantity tokens remaining unminted in the total collection.
1330    * - to cannot be the zero address.
1331    * - quantity cannot be larger than the max batch size.
1332    *
1333    * Emits a {Transfer} event.
1334    */
1335   function _safeMint(
1336     address to,
1337     uint256 quantity,
1338     bool isAdminMint,
1339     bytes memory _data
1340   ) internal {
1341     uint256 startTokenId = currentIndex;
1342     require(to != address(0), "ERC721A: mint to the zero address");
1343     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1344     require(!_exists(startTokenId), "ERC721A: token already minted");
1345 
1346     // For admin mints we do not want to enforce the maxBatchSize limit
1347     if (isAdminMint == false) {
1348         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1349     }
1350 
1351     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1352 
1353     AddressData memory addressData = _addressData[to];
1354     _addressData[to] = AddressData(
1355       addressData.balance + uint128(quantity),
1356       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1357     );
1358     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1359 
1360     uint256 updatedIndex = startTokenId;
1361 
1362     for (uint256 i = 0; i < quantity; i++) {
1363       emit Transfer(address(0), to, updatedIndex);
1364       require(
1365         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1366         "ERC721A: transfer to non ERC721Receiver implementer"
1367       );
1368       updatedIndex++;
1369     }
1370 
1371     currentIndex = updatedIndex;
1372     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1373   }
1374 
1375   /**
1376    * @dev Transfers tokenId from from to to.
1377    *
1378    * Requirements:
1379    *
1380    * - to cannot be the zero address.
1381    * - tokenId token must be owned by from.
1382    *
1383    * Emits a {Transfer} event.
1384    */
1385   function _transfer(
1386     address from,
1387     address to,
1388     uint256 tokenId
1389   ) private {
1390     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1391 
1392     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1393       getApproved(tokenId) == _msgSender() ||
1394       isApprovedForAll(prevOwnership.addr, _msgSender()));
1395 
1396     require(
1397       isApprovedOrOwner,
1398       "ERC721A: transfer caller is not owner nor approved"
1399     );
1400 
1401     require(
1402       prevOwnership.addr == from,
1403       "ERC721A: transfer from incorrect owner"
1404     );
1405     require(to != address(0), "ERC721A: transfer to the zero address");
1406 
1407     _beforeTokenTransfers(from, to, tokenId, 1);
1408 
1409     // Clear approvals from the previous owner
1410     _approve(address(0), tokenId, prevOwnership.addr);
1411 
1412     _addressData[from].balance -= 1;
1413     _addressData[to].balance += 1;
1414     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1415 
1416     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1417     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1418     uint256 nextTokenId = tokenId + 1;
1419     if (_ownerships[nextTokenId].addr == address(0)) {
1420       if (_exists(nextTokenId)) {
1421         _ownerships[nextTokenId] = TokenOwnership(
1422           prevOwnership.addr,
1423           prevOwnership.startTimestamp
1424         );
1425       }
1426     }
1427 
1428     emit Transfer(from, to, tokenId);
1429     _afterTokenTransfers(from, to, tokenId, 1);
1430   }
1431 
1432   /**
1433    * @dev Approve to to operate on tokenId
1434    *
1435    * Emits a {Approval} event.
1436    */
1437   function _approve(
1438     address to,
1439     uint256 tokenId,
1440     address owner
1441   ) private {
1442     _tokenApprovals[tokenId] = to;
1443     emit Approval(owner, to, tokenId);
1444   }
1445 
1446   uint256 public nextOwnerToExplicitlySet = 0;
1447 
1448   /**
1449    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1450    */
1451   function _setOwnersExplicit(uint256 quantity) internal {
1452     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1453     require(quantity > 0, "quantity must be nonzero");
1454     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1455 
1456     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1457     if (endIndex > collectionSize - 1) {
1458       endIndex = collectionSize - 1;
1459     }
1460     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1461     require(_exists(endIndex), "not enough minted yet for this cleanup");
1462     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1463       if (_ownerships[i].addr == address(0)) {
1464         TokenOwnership memory ownership = ownershipOf(i);
1465         _ownerships[i] = TokenOwnership(
1466           ownership.addr,
1467           ownership.startTimestamp
1468         );
1469       }
1470     }
1471     nextOwnerToExplicitlySet = endIndex + 1;
1472   }
1473 
1474   /**
1475    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1476    * The call is not executed if the target address is not a contract.
1477    *
1478    * @param from address representing the previous owner of the given token ID
1479    * @param to target address that will receive the tokens
1480    * @param tokenId uint256 ID of the token to be transferred
1481    * @param _data bytes optional data to send along with the call
1482    * @return bool whether the call correctly returned the expected magic value
1483    */
1484   function _checkOnERC721Received(
1485     address from,
1486     address to,
1487     uint256 tokenId,
1488     bytes memory _data
1489   ) private returns (bool) {
1490     if (to.isContract()) {
1491       try
1492         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1493       returns (bytes4 retval) {
1494         return retval == IERC721Receiver(to).onERC721Received.selector;
1495       } catch (bytes memory reason) {
1496         if (reason.length == 0) {
1497           revert("ERC721A: transfer to non ERC721Receiver implementer");
1498         } else {
1499           assembly {
1500             revert(add(32, reason), mload(reason))
1501           }
1502         }
1503       }
1504     } else {
1505       return true;
1506     }
1507   }
1508 
1509   /**
1510    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1511    *
1512    * startTokenId - the first token id to be transferred
1513    * quantity - the amount to be transferred
1514    *
1515    * Calling conditions:
1516    *
1517    * - When from and to are both non-zero, from's tokenId will be
1518    * transferred to to.
1519    * - When from is zero, tokenId will be minted for to.
1520    */
1521   function _beforeTokenTransfers(
1522     address from,
1523     address to,
1524     uint256 startTokenId,
1525     uint256 quantity
1526   ) internal virtual {}
1527 
1528   /**
1529    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1530    * minting.
1531    *
1532    * startTokenId - the first token id to be transferred
1533    * quantity - the amount to be transferred
1534    *
1535    * Calling conditions:
1536    *
1537    * - when from and to are both non-zero.
1538    * - from and to are never both zero.
1539    */
1540   function _afterTokenTransfers(
1541     address from,
1542     address to,
1543     uint256 startTokenId,
1544     uint256 quantity
1545   ) internal virtual {}
1546 }
1547 
1548 
1549 
1550   
1551 abstract contract Ramppable {
1552   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1553 
1554   modifier isRampp() {
1555       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1556       _;
1557   }
1558 }
1559 
1560 
1561   
1562 /** TimedDrop.sol
1563 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1564 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1565 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1566 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1567 */
1568 abstract contract TimedDrop is Teams {
1569   bool public enforcePublicDropTime = true;
1570   uint256 public publicDropTime = 1664380800;
1571   
1572   /**
1573   * @dev Allow the contract owner to set the public time to mint.
1574   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1575   */
1576   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1577     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1578     publicDropTime = _newDropTime;
1579   }
1580 
1581   function usePublicDropTime() public onlyTeamOrOwner {
1582     enforcePublicDropTime = true;
1583   }
1584 
1585   function disablePublicDropTime() public onlyTeamOrOwner {
1586     enforcePublicDropTime = false;
1587   }
1588 
1589   /**
1590   * @dev determine if the public droptime has passed.
1591   * if the feature is disabled then assume the time has passed.
1592   */
1593   function publicDropTimePassed() public view returns(bool) {
1594     if(enforcePublicDropTime == false) {
1595       return true;
1596     }
1597     return block.timestamp >= publicDropTime;
1598   }
1599   
1600   // Allowlist implementation of the Timed Drop feature
1601   bool public enforceAllowlistDropTime = true;
1602   uint256 public allowlistDropTime = 1664208000;
1603 
1604   /**
1605   * @dev Allow the contract owner to set the allowlist time to mint.
1606   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1607   */
1608   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1609     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1610     allowlistDropTime = _newDropTime;
1611   }
1612 
1613   function useAllowlistDropTime() public onlyTeamOrOwner {
1614     enforceAllowlistDropTime = true;
1615   }
1616 
1617   function disableAllowlistDropTime() public onlyTeamOrOwner {
1618     enforceAllowlistDropTime = false;
1619   }
1620 
1621   function allowlistDropTimePassed() public view returns(bool) {
1622     if(enforceAllowlistDropTime == false) {
1623       return true;
1624     }
1625 
1626     return block.timestamp >= allowlistDropTime;
1627   }
1628 }
1629 
1630   
1631 interface IERC20 {
1632   function allowance(address owner, address spender) external view returns (uint256);
1633   function transfer(address _to, uint256 _amount) external returns (bool);
1634   function balanceOf(address account) external view returns (uint256);
1635   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1636 }
1637 
1638 // File: WithdrawableV2
1639 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1640 // ERC-20 Payouts are limited to a single payout address. This feature 
1641 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1642 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1643 abstract contract WithdrawableV2 is Teams, Ramppable {
1644   struct acceptedERC20 {
1645     bool isActive;
1646     uint256 chargeAmount;
1647   }
1648 
1649   
1650   mapping(address => acceptedERC20) private allowedTokenContracts;
1651   address[] public payableAddresses = [RAMPPADDRESS,0xd4c198DF54f6C1e14aE50F7bE6C877f3bAA8937F,0x4f7184A6e159D722840a9AB15DD3aa817D7d2034];
1652   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1653   address public erc20Payable = 0xd4c198DF54f6C1e14aE50F7bE6C877f3bAA8937F;
1654   uint256[] public payableFees = [5,48,47];
1655   uint256[] public surchargePayableFees = [100];
1656   uint256 public payableAddressCount = 3;
1657   uint256 public surchargePayableAddressCount = 1;
1658   uint256 public ramppSurchargeBalance = 0 ether;
1659   uint256 public ramppSurchargeFee = 0.001 ether;
1660   bool public onlyERC20MintingMode = false;
1661   
1662 
1663   /**
1664   * @dev Calculates the true payable balance of the contract as the
1665   * value on contract may be from ERC-20 mint surcharges and not 
1666   * public mint charges - which are not eligable for rev share & user withdrawl
1667   */
1668   function calcAvailableBalance() public view returns(uint256) {
1669     return address(this).balance - ramppSurchargeBalance;
1670   }
1671 
1672   function withdrawAll() public onlyTeamOrOwner {
1673       require(calcAvailableBalance() > 0);
1674       _withdrawAll();
1675   }
1676   
1677   function withdrawAllRampp() public isRampp {
1678       require(calcAvailableBalance() > 0);
1679       _withdrawAll();
1680   }
1681 
1682   function _withdrawAll() private {
1683       uint256 balance = calcAvailableBalance();
1684       
1685       for(uint i=0; i < payableAddressCount; i++ ) {
1686           _widthdraw(
1687               payableAddresses[i],
1688               (balance * payableFees[i]) / 100
1689           );
1690       }
1691   }
1692   
1693   function _widthdraw(address _address, uint256 _amount) private {
1694       (bool success, ) = _address.call{value: _amount}("");
1695       require(success, "Transfer failed.");
1696   }
1697 
1698   /**
1699   * @dev This function is similiar to the regular withdraw but operates only on the
1700   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1701   **/
1702   function _withdrawAllSurcharges() private {
1703     uint256 balance = ramppSurchargeBalance;
1704     if(balance == 0) { return; }
1705     
1706     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1707         _widthdraw(
1708             surchargePayableAddresses[i],
1709             (balance * surchargePayableFees[i]) / 100
1710         );
1711     }
1712     ramppSurchargeBalance = 0 ether;
1713   }
1714 
1715   /**
1716   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1717   * in the event ERC-20 tokens are paid to the contract for mints. This will
1718   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1719   * @param _tokenContract contract of ERC-20 token to withdraw
1720   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1721   */
1722   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1723     require(_amountToWithdraw > 0);
1724     IERC20 tokenContract = IERC20(_tokenContract);
1725     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1726     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1727     _withdrawAllSurcharges();
1728   }
1729 
1730   /**
1731   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1732   */
1733   function withdrawRamppSurcharges() public isRampp {
1734     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1735     _withdrawAllSurcharges();
1736   }
1737 
1738    /**
1739   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1740   */
1741   function addSurcharge() internal {
1742     ramppSurchargeBalance += ramppSurchargeFee;
1743   }
1744   
1745   /**
1746   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1747   */
1748   function hasSurcharge() internal returns(bool) {
1749     return msg.value == ramppSurchargeFee;
1750   }
1751 
1752   /**
1753   * @dev Set surcharge fee for using ERC-20 payments on contract
1754   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1755   */
1756   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1757     ramppSurchargeFee = _newSurcharge;
1758   }
1759 
1760   /**
1761   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1762   * @param _erc20TokenContract address of ERC-20 contract in question
1763   */
1764   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1765     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1766   }
1767 
1768   /**
1769   * @dev get the value of tokens to transfer for user of an ERC-20
1770   * @param _erc20TokenContract address of ERC-20 contract in question
1771   */
1772   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1773     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1774     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1775   }
1776 
1777   /**
1778   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1779   * @param _erc20TokenContract address of ERC-20 contract in question
1780   * @param _isActive default status of if contract should be allowed to accept payments
1781   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1782   */
1783   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1784     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1785     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1786   }
1787 
1788   /**
1789   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1790   * it will assume the default value of zero. This should not be used to create new payment tokens.
1791   * @param _erc20TokenContract address of ERC-20 contract in question
1792   */
1793   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1794     allowedTokenContracts[_erc20TokenContract].isActive = true;
1795   }
1796 
1797   /**
1798   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1799   * it will assume the default value of zero. This should not be used to create new payment tokens.
1800   * @param _erc20TokenContract address of ERC-20 contract in question
1801   */
1802   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1803     allowedTokenContracts[_erc20TokenContract].isActive = false;
1804   }
1805 
1806   /**
1807   * @dev Enable only ERC-20 payments for minting on this contract
1808   */
1809   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1810     onlyERC20MintingMode = true;
1811   }
1812 
1813   /**
1814   * @dev Disable only ERC-20 payments for minting on this contract
1815   */
1816   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1817     onlyERC20MintingMode = false;
1818   }
1819 
1820   /**
1821   * @dev Set the payout of the ERC-20 token payout to a specific address
1822   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1823   */
1824   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1825     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1826     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1827     erc20Payable = _newErc20Payable;
1828   }
1829 
1830   /**
1831   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1832   */
1833   function resetRamppSurchargeBalance() public isRampp {
1834     ramppSurchargeBalance = 0 ether;
1835   }
1836 
1837   /**
1838   * @dev Allows Rampp wallet to update its own reference as well as update
1839   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1840   * and since Rampp is always the first address this function is limited to the rampp payout only.
1841   * @param _newAddress updated Rampp Address
1842   */
1843   function setRamppAddress(address _newAddress) public isRampp {
1844     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1845     RAMPPADDRESS = _newAddress;
1846     payableAddresses[0] = _newAddress;
1847   }
1848 }
1849 
1850 
1851   
1852   
1853 // File: EarlyMintIncentive.sol
1854 // Allows the contract to have the first x tokens have a discount or
1855 // zero fee that can be calculated on the fly.
1856 abstract contract EarlyMintIncentive is Teams, ERC721A {
1857   uint256 public PRICE = 0.1 ether;
1858   uint256 public EARLY_MINT_PRICE = 0 ether;
1859   uint256 public earlyMintTokenIdCap = 6500;
1860   bool public usingEarlyMintIncentive = true;
1861 
1862   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1863     usingEarlyMintIncentive = true;
1864   }
1865 
1866   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1867     usingEarlyMintIncentive = false;
1868   }
1869 
1870   /**
1871   * @dev Set the max token ID in which the cost incentive will be applied.
1872   * @param _newTokenIdCap max tokenId in which incentive will be applied
1873   */
1874   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1875     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1876     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1877     earlyMintTokenIdCap = _newTokenIdCap;
1878   }
1879 
1880   /**
1881   * @dev Set the incentive mint price
1882   * @param _feeInWei new price per token when in incentive range
1883   */
1884   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1885     EARLY_MINT_PRICE = _feeInWei;
1886   }
1887 
1888   /**
1889   * @dev Set the primary mint price - the base price when not under incentive
1890   * @param _feeInWei new price per token
1891   */
1892   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1893     PRICE = _feeInWei;
1894   }
1895 
1896   function getPrice(uint256 _count) public view returns (uint256) {
1897     require(_count > 0, "Must be minting at least 1 token.");
1898 
1899     // short circuit function if we dont need to even calc incentive pricing
1900     // short circuit if the current tokenId is also already over cap
1901     if(
1902       usingEarlyMintIncentive == false ||
1903       currentTokenId() > earlyMintTokenIdCap
1904     ) {
1905       return PRICE * _count;
1906     }
1907 
1908     uint256 endingTokenId = currentTokenId() + _count;
1909     // If qty to mint results in a final token ID less than or equal to the cap then
1910     // the entire qty is within free mint.
1911     if(endingTokenId  <= earlyMintTokenIdCap) {
1912       return EARLY_MINT_PRICE * _count;
1913     }
1914 
1915     // If the current token id is less than the incentive cap
1916     // and the ending token ID is greater than the incentive cap
1917     // we will be straddling the cap so there will be some amount
1918     // that are incentive and some that are regular fee.
1919     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1920     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1921 
1922     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1923   }
1924 }
1925 
1926   
1927   
1928 abstract contract RamppERC721A is 
1929     Ownable,
1930     Teams,
1931     ERC721A,
1932     WithdrawableV2,
1933     ReentrancyGuard 
1934     , EarlyMintIncentive 
1935     , Allowlist 
1936     , TimedDrop
1937 {
1938   constructor(
1939     string memory tokenName,
1940     string memory tokenSymbol
1941   ) ERC721A(tokenName, tokenSymbol, 2, 6500) { }
1942     uint8 public CONTRACT_VERSION = 2;
1943     string public _baseTokenURI = "ipfs://QmTmAkSzqVnwPvqUcbUgwQkvro2k622HDtPmdGmsHMdQMa/";
1944 
1945     bool public mintingOpen = false;
1946     bool public isRevealed = false;
1947     
1948     uint256 public MAX_WALLET_MINTS = 1;
1949 
1950   
1951     /////////////// Admin Mint Functions
1952     /**
1953      * @dev Mints a token to an address with a tokenURI.
1954      * This is owner only and allows a fee-free drop
1955      * @param _to address of the future owner of the token
1956      * @param _qty amount of tokens to drop the owner
1957      */
1958      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1959          require(_qty > 0, "Must mint at least 1 token.");
1960          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 6500");
1961          _safeMint(_to, _qty, true);
1962      }
1963 
1964   
1965     /////////////// GENERIC MINT FUNCTIONS
1966     /**
1967     * @dev Mints a single token to an address.
1968     * fee may or may not be required*
1969     * @param _to address of the future owner of the token
1970     */
1971     function mintTo(address _to) public payable {
1972         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1973         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6500");
1974         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1975         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1976         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1977         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1978         
1979         _safeMint(_to, 1, false);
1980     }
1981 
1982     /**
1983     * @dev Mints tokens to an address in batch.
1984     * fee may or may not be required*
1985     * @param _to address of the future owner of the token
1986     * @param _amount number of tokens to mint
1987     */
1988     function mintToMultiple(address _to, uint256 _amount) public payable {
1989         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1990         require(_amount >= 1, "Must mint at least 1 token");
1991         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1992         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1993         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1994         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1995         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6500");
1996         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1997 
1998         _safeMint(_to, _amount, false);
1999     }
2000 
2001     /**
2002      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2003      * fee may or may not be required*
2004      * @param _to address of the future owner of the token
2005      * @param _amount number of tokens to mint
2006      * @param _erc20TokenContract erc-20 token contract to mint with
2007      */
2008     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2009       require(_amount >= 1, "Must mint at least 1 token");
2010       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2011       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6500");
2012       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2013       require(publicDropTimePassed() == true, "Public drop time has not passed!");
2014       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
2015 
2016       // ERC-20 Specific pre-flight checks
2017       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2018       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2019       IERC20 payableToken = IERC20(_erc20TokenContract);
2020 
2021       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2022       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2023       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2024       
2025       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2026       require(transferComplete, "ERC-20 token was unable to be transferred");
2027       
2028       _safeMint(_to, _amount, false);
2029       addSurcharge();
2030     }
2031 
2032     function openMinting() public onlyTeamOrOwner {
2033         mintingOpen = true;
2034     }
2035 
2036     function stopMinting() public onlyTeamOrOwner {
2037         mintingOpen = false;
2038     }
2039 
2040   
2041     ///////////// ALLOWLIST MINTING FUNCTIONS
2042 
2043     /**
2044     * @dev Mints tokens to an address using an allowlist.
2045     * fee may or may not be required*
2046     * @param _to address of the future owner of the token
2047     * @param _merkleProof merkle proof array
2048     */
2049     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
2050         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2051         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2052         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2053         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6500");
2054         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
2055         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
2056         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2057 
2058         _safeMint(_to, 1, false);
2059     }
2060 
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
2076         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6500");
2077         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2078         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
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
2097       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6500");
2098       require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2099     
2100       // ERC-20 Specific pre-flight checks
2101       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2102       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2103       IERC20 payableToken = IERC20(_erc20TokenContract);
2104     
2105       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2106       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2107       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2108       
2109       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2110       require(transferComplete, "ERC-20 token was unable to be transferred");
2111       
2112       _safeMint(_to, _amount, false);
2113       addSurcharge();
2114     }
2115 
2116     /**
2117      * @dev Enable allowlist minting fully by enabling both flags
2118      * This is a convenience function for the Rampp user
2119      */
2120     function openAllowlistMint() public onlyTeamOrOwner {
2121         enableAllowlistOnlyMode();
2122         mintingOpen = true;
2123     }
2124 
2125     /**
2126      * @dev Close allowlist minting fully by disabling both flags
2127      * This is a convenience function for the Rampp user
2128      */
2129     function closeAllowlistMint() public onlyTeamOrOwner {
2130         disableAllowlistOnlyMode();
2131         mintingOpen = false;
2132     }
2133 
2134 
2135   
2136     /**
2137     * @dev Check if wallet over MAX_WALLET_MINTS
2138     * @param _address address in question to check if minted count exceeds max
2139     */
2140     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2141         require(_amount >= 1, "Amount must be greater than or equal to 1");
2142         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2143     }
2144 
2145     /**
2146     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2147     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2148     */
2149     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2150         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2151         MAX_WALLET_MINTS = _newWalletMax;
2152     }
2153     
2154 
2155   
2156     /**
2157      * @dev Allows owner to set Max mints per tx
2158      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2159      */
2160      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2161          require(_newMaxMint >= 1, "Max mint must be at least 1");
2162          maxBatchSize = _newMaxMint;
2163      }
2164     
2165 
2166   
2167     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2168         require(isRevealed == false, "Tokens are already unveiled");
2169         _baseTokenURI = _updatedTokenURI;
2170         isRevealed = true;
2171     }
2172     
2173 
2174   function _baseURI() internal view virtual override returns(string memory) {
2175     return _baseTokenURI;
2176   }
2177 
2178   function baseTokenURI() public view returns(string memory) {
2179     return _baseTokenURI;
2180   }
2181 
2182   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2183     _baseTokenURI = baseURI;
2184   }
2185 
2186   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2187     return ownershipOf(tokenId);
2188   }
2189 }
2190 
2191 
2192   
2193 // File: contracts/CkcCryptoKongClubContract.sol
2194 //SPDX-License-Identifier: MIT
2195 
2196 pragma solidity ^0.8.0;
2197 
2198 contract CkcCryptoKongClubContract is RamppERC721A {
2199     constructor() RamppERC721A("CKCCryptoKongClub", "CKC"){}
2200 }
2201   
2202 //*********************************************************************//
2203 //*********************************************************************//  
2204 //                       Mintplex v2.1.0
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
