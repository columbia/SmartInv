1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //   ________            __               __     _____                                ____  _____  ________
5 //  /_  __/ /_  ___     / /   ____ ______/ /_   / ___/__  ______  ____  ___  _____   / __ )/   \ \/ / ____/
6 //   / / / __ \/ _ \   / /   / __ `/ ___/ __/   \__ \/ / / / __ \/ __ \/ _ \/ ___/  / __  / /| |\  / /     
7 //  / / / / / /  __/  / /___/ /_/ (__  ) /_    ___/ / /_/ / /_/ / /_/ /  __/ /     / /_/ / ___ |/ / /___   
8 // /_/ /_/ /_/\___/  /_____/\__,_/____/\__/   /____/\__,_/ .___/ .___/\___/_/     /_____/_/  |_/_/\____/   
9 //                                                      /_/   /_/                                          
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
855   IERC721Enumerable,
856   Teams
857 {
858   using Address for address;
859   using Strings for uint256;
860 
861   struct TokenOwnership {
862     address addr;
863     uint64 startTimestamp;
864   }
865 
866   struct AddressData {
867     uint128 balance;
868     uint128 numberMinted;
869   }
870 
871   uint256 private currentIndex;
872 
873   uint256 public immutable collectionSize;
874   uint256 public maxBatchSize;
875 
876   // Token name
877   string private _name;
878 
879   // Token symbol
880   string private _symbol;
881 
882   // Mapping from token ID to ownership details
883   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
884   mapping(uint256 => TokenOwnership) private _ownerships;
885 
886   // Mapping owner address to address data
887   mapping(address => AddressData) private _addressData;
888 
889   // Mapping from token ID to approved address
890   mapping(uint256 => address) private _tokenApprovals;
891 
892   // Mapping from owner to operator approvals
893   mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895   /* @dev Mapping of restricted operator approvals set by contract Owner
896   * This serves as an optional addition to ERC-721 so
897   * that the contract owner can elect to prevent specific addresses/contracts
898   * from being marked as the approver for a token. The reason for this
899   * is that some projects may want to retain control of where their tokens can/can not be listed
900   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
901   * By default, there are no restrictions. The contract owner must deliberatly block an address 
902   */
903   mapping(address => bool) public restrictedApprovalAddresses;
904 
905   /**
906    * @dev
907    * maxBatchSize refers to how much a minter can mint at a time.
908    * collectionSize_ refers to how many tokens are in the collection.
909    */
910   constructor(
911     string memory name_,
912     string memory symbol_,
913     uint256 maxBatchSize_,
914     uint256 collectionSize_
915   ) {
916     require(
917       collectionSize_ > 0,
918       "ERC721A: collection must have a nonzero supply"
919     );
920     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
921     _name = name_;
922     _symbol = symbol_;
923     maxBatchSize = maxBatchSize_;
924     collectionSize = collectionSize_;
925     currentIndex = _startTokenId();
926   }
927 
928   /**
929   * To change the starting tokenId, please override this function.
930   */
931   function _startTokenId() internal view virtual returns (uint256) {
932     return 1;
933   }
934 
935   /**
936    * @dev See {IERC721Enumerable-totalSupply}.
937    */
938   function totalSupply() public view override returns (uint256) {
939     return _totalMinted();
940   }
941 
942   function currentTokenId() public view returns (uint256) {
943     return _totalMinted();
944   }
945 
946   function getNextTokenId() public view returns (uint256) {
947       return _totalMinted() + 1;
948   }
949 
950   /**
951   * Returns the total amount of tokens minted in the contract.
952   */
953   function _totalMinted() internal view returns (uint256) {
954     unchecked {
955       return currentIndex - _startTokenId();
956     }
957   }
958 
959   /**
960    * @dev See {IERC721Enumerable-tokenByIndex}.
961    */
962   function tokenByIndex(uint256 index) public view override returns (uint256) {
963     require(index < totalSupply(), "ERC721A: global index out of bounds");
964     return index;
965   }
966 
967   /**
968    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
969    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
970    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
971    */
972   function tokenOfOwnerByIndex(address owner, uint256 index)
973     public
974     view
975     override
976     returns (uint256)
977   {
978     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
979     uint256 numMintedSoFar = totalSupply();
980     uint256 tokenIdsIdx = 0;
981     address currOwnershipAddr = address(0);
982     for (uint256 i = 0; i < numMintedSoFar; i++) {
983       TokenOwnership memory ownership = _ownerships[i];
984       if (ownership.addr != address(0)) {
985         currOwnershipAddr = ownership.addr;
986       }
987       if (currOwnershipAddr == owner) {
988         if (tokenIdsIdx == index) {
989           return i;
990         }
991         tokenIdsIdx++;
992       }
993     }
994     revert("ERC721A: unable to get token of owner by index");
995   }
996 
997   /**
998    * @dev See {IERC165-supportsInterface}.
999    */
1000   function supportsInterface(bytes4 interfaceId)
1001     public
1002     view
1003     virtual
1004     override(ERC165, IERC165)
1005     returns (bool)
1006   {
1007     return
1008       interfaceId == type(IERC721).interfaceId ||
1009       interfaceId == type(IERC721Metadata).interfaceId ||
1010       interfaceId == type(IERC721Enumerable).interfaceId ||
1011       super.supportsInterface(interfaceId);
1012   }
1013 
1014   /**
1015    * @dev See {IERC721-balanceOf}.
1016    */
1017   function balanceOf(address owner) public view override returns (uint256) {
1018     require(owner != address(0), "ERC721A: balance query for the zero address");
1019     return uint256(_addressData[owner].balance);
1020   }
1021 
1022   function _numberMinted(address owner) internal view returns (uint256) {
1023     require(
1024       owner != address(0),
1025       "ERC721A: number minted query for the zero address"
1026     );
1027     return uint256(_addressData[owner].numberMinted);
1028   }
1029 
1030   function ownershipOf(uint256 tokenId)
1031     internal
1032     view
1033     returns (TokenOwnership memory)
1034   {
1035     uint256 curr = tokenId;
1036 
1037     unchecked {
1038         if (_startTokenId() <= curr && curr < currentIndex) {
1039             TokenOwnership memory ownership = _ownerships[curr];
1040             if (ownership.addr != address(0)) {
1041                 return ownership;
1042             }
1043 
1044             // Invariant:
1045             // There will always be an ownership that has an address and is not burned
1046             // before an ownership that does not have an address and is not burned.
1047             // Hence, curr will not underflow.
1048             while (true) {
1049                 curr--;
1050                 ownership = _ownerships[curr];
1051                 if (ownership.addr != address(0)) {
1052                     return ownership;
1053                 }
1054             }
1055         }
1056     }
1057 
1058     revert("ERC721A: unable to determine the owner of token");
1059   }
1060 
1061   /**
1062    * @dev See {IERC721-ownerOf}.
1063    */
1064   function ownerOf(uint256 tokenId) public view override returns (address) {
1065     return ownershipOf(tokenId).addr;
1066   }
1067 
1068   /**
1069    * @dev See {IERC721Metadata-name}.
1070    */
1071   function name() public view virtual override returns (string memory) {
1072     return _name;
1073   }
1074 
1075   /**
1076    * @dev See {IERC721Metadata-symbol}.
1077    */
1078   function symbol() public view virtual override returns (string memory) {
1079     return _symbol;
1080   }
1081 
1082   /**
1083    * @dev See {IERC721Metadata-tokenURI}.
1084    */
1085   function tokenURI(uint256 tokenId)
1086     public
1087     view
1088     virtual
1089     override
1090     returns (string memory)
1091   {
1092     string memory baseURI = _baseURI();
1093     string memory extension = _baseURIExtension();
1094     return
1095       bytes(baseURI).length > 0
1096         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1097         : "";
1098   }
1099 
1100   /**
1101    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1102    * token will be the concatenation of the baseURI and the tokenId. Empty
1103    * by default, can be overriden in child contracts.
1104    */
1105   function _baseURI() internal view virtual returns (string memory) {
1106     return "";
1107   }
1108 
1109   /**
1110    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1111    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1112    * by default, can be overriden in child contracts.
1113    */
1114   function _baseURIExtension() internal view virtual returns (string memory) {
1115     return "";
1116   }
1117 
1118   /**
1119    * @dev Sets the value for an address to be in the restricted approval address pool.
1120    * Setting an address to true will disable token owners from being able to mark the address
1121    * for approval for trading. This would be used in theory to prevent token owners from listing
1122    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1123    * @param _address the marketplace/user to modify restriction status of
1124    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1125    */
1126   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1127     restrictedApprovalAddresses[_address] = _isRestricted;
1128   }
1129 
1130   /**
1131    * @dev See {IERC721-approve}.
1132    */
1133   function approve(address to, uint256 tokenId) public override {
1134     address owner = ERC721A.ownerOf(tokenId);
1135     require(to != owner, "ERC721A: approval to current owner");
1136     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1137 
1138     require(
1139       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1140       "ERC721A: approve caller is not owner nor approved for all"
1141     );
1142 
1143     _approve(to, tokenId, owner);
1144   }
1145 
1146   /**
1147    * @dev See {IERC721-getApproved}.
1148    */
1149   function getApproved(uint256 tokenId) public view override returns (address) {
1150     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1151 
1152     return _tokenApprovals[tokenId];
1153   }
1154 
1155   /**
1156    * @dev See {IERC721-setApprovalForAll}.
1157    */
1158   function setApprovalForAll(address operator, bool approved) public override {
1159     require(operator != _msgSender(), "ERC721A: approve to caller");
1160     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1161 
1162     _operatorApprovals[_msgSender()][operator] = approved;
1163     emit ApprovalForAll(_msgSender(), operator, approved);
1164   }
1165 
1166   /**
1167    * @dev See {IERC721-isApprovedForAll}.
1168    */
1169   function isApprovedForAll(address owner, address operator)
1170     public
1171     view
1172     virtual
1173     override
1174     returns (bool)
1175   {
1176     return _operatorApprovals[owner][operator];
1177   }
1178 
1179   /**
1180    * @dev See {IERC721-transferFrom}.
1181    */
1182   function transferFrom(
1183     address from,
1184     address to,
1185     uint256 tokenId
1186   ) public override {
1187     _transfer(from, to, tokenId);
1188   }
1189 
1190   /**
1191    * @dev See {IERC721-safeTransferFrom}.
1192    */
1193   function safeTransferFrom(
1194     address from,
1195     address to,
1196     uint256 tokenId
1197   ) public override {
1198     safeTransferFrom(from, to, tokenId, "");
1199   }
1200 
1201   /**
1202    * @dev See {IERC721-safeTransferFrom}.
1203    */
1204   function safeTransferFrom(
1205     address from,
1206     address to,
1207     uint256 tokenId,
1208     bytes memory _data
1209   ) public override {
1210     _transfer(from, to, tokenId);
1211     require(
1212       _checkOnERC721Received(from, to, tokenId, _data),
1213       "ERC721A: transfer to non ERC721Receiver implementer"
1214     );
1215   }
1216 
1217   /**
1218    * @dev Returns whether tokenId exists.
1219    *
1220    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1221    *
1222    * Tokens start existing when they are minted (_mint),
1223    */
1224   function _exists(uint256 tokenId) internal view returns (bool) {
1225     return _startTokenId() <= tokenId && tokenId < currentIndex;
1226   }
1227 
1228   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1229     _safeMint(to, quantity, isAdminMint, "");
1230   }
1231 
1232   /**
1233    * @dev Mints quantity tokens and transfers them to to.
1234    *
1235    * Requirements:
1236    *
1237    * - there must be quantity tokens remaining unminted in the total collection.
1238    * - to cannot be the zero address.
1239    * - quantity cannot be larger than the max batch size.
1240    *
1241    * Emits a {Transfer} event.
1242    */
1243   function _safeMint(
1244     address to,
1245     uint256 quantity,
1246     bool isAdminMint,
1247     bytes memory _data
1248   ) internal {
1249     uint256 startTokenId = currentIndex;
1250     require(to != address(0), "ERC721A: mint to the zero address");
1251     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1252     require(!_exists(startTokenId), "ERC721A: token already minted");
1253 
1254     // For admin mints we do not want to enforce the maxBatchSize limit
1255     if (isAdminMint == false) {
1256         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1257     }
1258 
1259     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1260 
1261     AddressData memory addressData = _addressData[to];
1262     _addressData[to] = AddressData(
1263       addressData.balance + uint128(quantity),
1264       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1265     );
1266     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1267 
1268     uint256 updatedIndex = startTokenId;
1269 
1270     for (uint256 i = 0; i < quantity; i++) {
1271       emit Transfer(address(0), to, updatedIndex);
1272       require(
1273         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1274         "ERC721A: transfer to non ERC721Receiver implementer"
1275       );
1276       updatedIndex++;
1277     }
1278 
1279     currentIndex = updatedIndex;
1280     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1281   }
1282 
1283   /**
1284    * @dev Transfers tokenId from from to to.
1285    *
1286    * Requirements:
1287    *
1288    * - to cannot be the zero address.
1289    * - tokenId token must be owned by from.
1290    *
1291    * Emits a {Transfer} event.
1292    */
1293   function _transfer(
1294     address from,
1295     address to,
1296     uint256 tokenId
1297   ) private {
1298     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1299 
1300     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1301       getApproved(tokenId) == _msgSender() ||
1302       isApprovedForAll(prevOwnership.addr, _msgSender()));
1303 
1304     require(
1305       isApprovedOrOwner,
1306       "ERC721A: transfer caller is not owner nor approved"
1307     );
1308 
1309     require(
1310       prevOwnership.addr == from,
1311       "ERC721A: transfer from incorrect owner"
1312     );
1313     require(to != address(0), "ERC721A: transfer to the zero address");
1314 
1315     _beforeTokenTransfers(from, to, tokenId, 1);
1316 
1317     // Clear approvals from the previous owner
1318     _approve(address(0), tokenId, prevOwnership.addr);
1319 
1320     _addressData[from].balance -= 1;
1321     _addressData[to].balance += 1;
1322     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1323 
1324     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1325     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1326     uint256 nextTokenId = tokenId + 1;
1327     if (_ownerships[nextTokenId].addr == address(0)) {
1328       if (_exists(nextTokenId)) {
1329         _ownerships[nextTokenId] = TokenOwnership(
1330           prevOwnership.addr,
1331           prevOwnership.startTimestamp
1332         );
1333       }
1334     }
1335 
1336     emit Transfer(from, to, tokenId);
1337     _afterTokenTransfers(from, to, tokenId, 1);
1338   }
1339 
1340   /**
1341    * @dev Approve to to operate on tokenId
1342    *
1343    * Emits a {Approval} event.
1344    */
1345   function _approve(
1346     address to,
1347     uint256 tokenId,
1348     address owner
1349   ) private {
1350     _tokenApprovals[tokenId] = to;
1351     emit Approval(owner, to, tokenId);
1352   }
1353 
1354   uint256 public nextOwnerToExplicitlySet = 0;
1355 
1356   /**
1357    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1358    */
1359   function _setOwnersExplicit(uint256 quantity) internal {
1360     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1361     require(quantity > 0, "quantity must be nonzero");
1362     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1363 
1364     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1365     if (endIndex > collectionSize - 1) {
1366       endIndex = collectionSize - 1;
1367     }
1368     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1369     require(_exists(endIndex), "not enough minted yet for this cleanup");
1370     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1371       if (_ownerships[i].addr == address(0)) {
1372         TokenOwnership memory ownership = ownershipOf(i);
1373         _ownerships[i] = TokenOwnership(
1374           ownership.addr,
1375           ownership.startTimestamp
1376         );
1377       }
1378     }
1379     nextOwnerToExplicitlySet = endIndex + 1;
1380   }
1381 
1382   /**
1383    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1384    * The call is not executed if the target address is not a contract.
1385    *
1386    * @param from address representing the previous owner of the given token ID
1387    * @param to target address that will receive the tokens
1388    * @param tokenId uint256 ID of the token to be transferred
1389    * @param _data bytes optional data to send along with the call
1390    * @return bool whether the call correctly returned the expected magic value
1391    */
1392   function _checkOnERC721Received(
1393     address from,
1394     address to,
1395     uint256 tokenId,
1396     bytes memory _data
1397   ) private returns (bool) {
1398     if (to.isContract()) {
1399       try
1400         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1401       returns (bytes4 retval) {
1402         return retval == IERC721Receiver(to).onERC721Received.selector;
1403       } catch (bytes memory reason) {
1404         if (reason.length == 0) {
1405           revert("ERC721A: transfer to non ERC721Receiver implementer");
1406         } else {
1407           assembly {
1408             revert(add(32, reason), mload(reason))
1409           }
1410         }
1411       }
1412     } else {
1413       return true;
1414     }
1415   }
1416 
1417   /**
1418    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1419    *
1420    * startTokenId - the first token id to be transferred
1421    * quantity - the amount to be transferred
1422    *
1423    * Calling conditions:
1424    *
1425    * - When from and to are both non-zero, from's tokenId will be
1426    * transferred to to.
1427    * - When from is zero, tokenId will be minted for to.
1428    */
1429   function _beforeTokenTransfers(
1430     address from,
1431     address to,
1432     uint256 startTokenId,
1433     uint256 quantity
1434   ) internal virtual {}
1435 
1436   /**
1437    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1438    * minting.
1439    *
1440    * startTokenId - the first token id to be transferred
1441    * quantity - the amount to be transferred
1442    *
1443    * Calling conditions:
1444    *
1445    * - when from and to are both non-zero.
1446    * - from and to are never both zero.
1447    */
1448   function _afterTokenTransfers(
1449     address from,
1450     address to,
1451     uint256 startTokenId,
1452     uint256 quantity
1453   ) internal virtual {}
1454 }
1455 
1456 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1457 // @author Mintplex.xyz (Rampp Labs Inc) (Twitter: @MintplexNFT)
1458 // @notice -- See Medium article --
1459 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1460 abstract contract ERC721ARedemption is ERC721A {
1461   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1462   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1463 
1464   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1465   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1466   
1467   uint256 public redemptionSurcharge = 0 ether;
1468   bool public redemptionModeEnabled;
1469   bool public verifiedClaimModeEnabled;
1470   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1471   mapping(address => bool) public redemptionContracts;
1472   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1473 
1474   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1475   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1476     redemptionContracts[_contractAddress] = _status;
1477   }
1478 
1479   // @dev Allow owner/team to determine if contract is accepting redemption mints
1480   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1481     redemptionModeEnabled = _newStatus;
1482   }
1483 
1484   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1485   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1486     verifiedClaimModeEnabled = _newStatus;
1487   }
1488 
1489   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1490   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1491     redemptionSurcharge = _newSurchargeInWei;
1492   }
1493 
1494   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1495   // @notice Must be a wallet address or implement IERC721Receiver.
1496   // Cannot be null address as this will break any ERC-721A implementation without a proper
1497   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1498   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1499     require(_newRedemptionAddress != address(0), "New redemption address cannot be null address.");
1500     redemptionAddress = _newRedemptionAddress;
1501   }
1502 
1503   /**
1504   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1505   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1506   * the contract owner or Team => redemptionAddress. 
1507   * @param tokenId the token to be redeemed.
1508   * Emits a {Redeemed} event.
1509   **/
1510   function redeem(address redemptionContract, uint256 tokenId) public payable {
1511     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1512     require(redemptionModeEnabled, "ERC721 Redeemable: Redemption mode is not enabled currently");
1513     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1514     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1515     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1516     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1517     
1518     IERC721 _targetContract = IERC721(redemptionContract);
1519     require(_targetContract.ownerOf(tokenId) == _msgSender(), "ERC721 Redeemable: Redeemer not owner of token to be claimed against.");
1520     require(_targetContract.getApproved(tokenId) == address(this), "ERC721 Redeemable: This contract is not approved for specific token on redempetion contract.");
1521     
1522     // Warning: Since there is no standarized return value for transfers of ERC-721
1523     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1524     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1525     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1526     // but the NFT may not have been sent to the redemptionAddress.
1527     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1528     tokenRedemptions[redemptionContract][tokenId] = true;
1529 
1530     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1531     _safeMint(_msgSender(), 1, false);
1532   }
1533 
1534   /**
1535   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1536   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1537   * @param tokenId the token to be redeemed.
1538   * Emits a {VerifiedClaim} event.
1539   **/
1540   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1541     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1542     require(verifiedClaimModeEnabled, "ERC721 Redeemable: Verified claim mode is not enabled currently");
1543     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1544     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1545     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1546     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1547     
1548     tokenRedemptions[redemptionContract][tokenId] = true;
1549     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1550     _safeMint(_msgSender(), 1, false);
1551   }
1552 }
1553 
1554 
1555   
1556   
1557 interface IERC20 {
1558   function allowance(address owner, address spender) external view returns (uint256);
1559   function transfer(address _to, uint256 _amount) external returns (bool);
1560   function balanceOf(address account) external view returns (uint256);
1561   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1562 }
1563 
1564 // File: WithdrawableV2
1565 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1566 // ERC-20 Payouts are limited to a single payout address. This feature 
1567 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1568 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1569 abstract contract WithdrawableV2 is Teams {
1570   struct acceptedERC20 {
1571     bool isActive;
1572     uint256 chargeAmount;
1573   }
1574 
1575   
1576   mapping(address => acceptedERC20) private allowedTokenContracts;
1577   address[] public payableAddresses = [0xc72eccc629232996aAAc95C5f1e450ba9B38EE87];
1578   address public erc20Payable = 0xc72eccc629232996aAAc95C5f1e450ba9B38EE87;
1579   uint256[] public payableFees = [100];
1580   uint256 public payableAddressCount = 1;
1581   bool public onlyERC20MintingMode = false;
1582   
1583 
1584   /**
1585   * @dev Calculates the true payable balance of the contract
1586   */
1587   function calcAvailableBalance() public view returns(uint256) {
1588     return address(this).balance;
1589   }
1590 
1591   function withdrawAll() public onlyTeamOrOwner {
1592       require(calcAvailableBalance() > 0);
1593       _withdrawAll();
1594   }
1595 
1596   function _withdrawAll() private {
1597       uint256 balance = calcAvailableBalance();
1598       
1599       for(uint i=0; i < payableAddressCount; i++ ) {
1600           _widthdraw(
1601               payableAddresses[i],
1602               (balance * payableFees[i]) / 100
1603           );
1604       }
1605   }
1606   
1607   function _widthdraw(address _address, uint256 _amount) private {
1608       (bool success, ) = _address.call{value: _amount}("");
1609       require(success, "Transfer failed.");
1610   }
1611 
1612   /**
1613   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1614   * in the event ERC-20 tokens are paid to the contract for mints.
1615   * @param _tokenContract contract of ERC-20 token to withdraw
1616   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1617   */
1618   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1619     require(_amountToWithdraw > 0);
1620     IERC20 tokenContract = IERC20(_tokenContract);
1621     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1622     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1623   }
1624 
1625   /**
1626   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1627   * @param _erc20TokenContract address of ERC-20 contract in question
1628   */
1629   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1630     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1631   }
1632 
1633   /**
1634   * @dev get the value of tokens to transfer for user of an ERC-20
1635   * @param _erc20TokenContract address of ERC-20 contract in question
1636   */
1637   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1638     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1639     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1640   }
1641 
1642   /**
1643   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1644   * @param _erc20TokenContract address of ERC-20 contract in question
1645   * @param _isActive default status of if contract should be allowed to accept payments
1646   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1647   */
1648   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1649     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1650     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1651   }
1652 
1653   /**
1654   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1655   * it will assume the default value of zero. This should not be used to create new payment tokens.
1656   * @param _erc20TokenContract address of ERC-20 contract in question
1657   */
1658   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1659     allowedTokenContracts[_erc20TokenContract].isActive = true;
1660   }
1661 
1662   /**
1663   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1664   * it will assume the default value of zero. This should not be used to create new payment tokens.
1665   * @param _erc20TokenContract address of ERC-20 contract in question
1666   */
1667   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1668     allowedTokenContracts[_erc20TokenContract].isActive = false;
1669   }
1670 
1671   /**
1672   * @dev Enable only ERC-20 payments for minting on this contract
1673   */
1674   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1675     onlyERC20MintingMode = true;
1676   }
1677 
1678   /**
1679   * @dev Disable only ERC-20 payments for minting on this contract
1680   */
1681   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1682     onlyERC20MintingMode = false;
1683   }
1684 
1685   /**
1686   * @dev Set the payout of the ERC-20 token payout to a specific address
1687   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1688   */
1689   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1690     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1691     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1692     erc20Payable = _newErc20Payable;
1693   }
1694 }
1695 
1696 
1697   
1698   
1699   
1700 // File: EarlyMintIncentive.sol
1701 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1702 // zero fee that can be calculated on the fly.
1703 abstract contract EarlyMintIncentive is Teams, ERC721A {
1704   uint256 public PRICE = 0.0069 ether;
1705   uint256 public EARLY_MINT_PRICE = 0 ether;
1706   uint256 public earlyMintOwnershipCap = 1;
1707   bool public usingEarlyMintIncentive = true;
1708 
1709   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1710     usingEarlyMintIncentive = true;
1711   }
1712 
1713   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1714     usingEarlyMintIncentive = false;
1715   }
1716 
1717   /**
1718   * @dev Set the max token ID in which the cost incentive will be applied.
1719   * @param _newCap max number of tokens wallet may mint for incentive price
1720   */
1721   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1722     require(_newCap >= 1, "Cannot set cap to less than 1");
1723     earlyMintOwnershipCap = _newCap;
1724   }
1725 
1726   /**
1727   * @dev Set the incentive mint price
1728   * @param _feeInWei new price per token when in incentive range
1729   */
1730   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1731     EARLY_MINT_PRICE = _feeInWei;
1732   }
1733 
1734   /**
1735   * @dev Set the primary mint price - the base price when not under incentive
1736   * @param _feeInWei new price per token
1737   */
1738   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1739     PRICE = _feeInWei;
1740   }
1741 
1742   /**
1743   * @dev Get the correct price for the mint for qty and person minting
1744   * @param _count amount of tokens to calc for mint
1745   * @param _to the address which will be minting these tokens, passed explicitly
1746   */
1747   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1748     require(_count > 0, "Must be minting at least 1 token.");
1749 
1750     // short circuit function if we dont need to even calc incentive pricing
1751     // short circuit if the current wallet mint qty is also already over cap
1752     if(
1753       usingEarlyMintIncentive == false ||
1754       _numberMinted(_to) > earlyMintOwnershipCap
1755     ) {
1756       return PRICE * _count;
1757     }
1758 
1759     uint256 endingTokenQty = _numberMinted(_to) + _count;
1760     // If qty to mint results in a final qty less than or equal to the cap then
1761     // the entire qty is within incentive mint.
1762     if(endingTokenQty  <= earlyMintOwnershipCap) {
1763       return EARLY_MINT_PRICE * _count;
1764     }
1765 
1766     // If the current token qty is less than the incentive cap
1767     // and the ending token qty is greater than the incentive cap
1768     // we will be straddling the cap so there will be some amount
1769     // that are incentive and some that are regular fee.
1770     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1771     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1772 
1773     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1774   }
1775 }
1776 
1777   
1778 abstract contract RamppERC721A is 
1779     Ownable,
1780     Teams,
1781     ERC721ARedemption,
1782     WithdrawableV2,
1783     ReentrancyGuard 
1784     , EarlyMintIncentive 
1785      
1786     
1787 {
1788   constructor(
1789     string memory tokenName,
1790     string memory tokenSymbol
1791   ) ERC721A(tokenName, tokenSymbol, 20, 10000) { }
1792     uint8 public CONTRACT_VERSION = 2;
1793     string public _baseTokenURI = "ipfs://bafybeiduide3jmegu2psh6v3p6wwap6tgkcmyp3eafg535ill3fbtjbsoa/";
1794     string public _baseTokenExtension = ".json";
1795 
1796     bool public mintingOpen = false;
1797     
1798     
1799 
1800   
1801     /////////////// Admin Mint Functions
1802     /**
1803      * @dev Mints a token to an address with a tokenURI.
1804      * This is owner only and allows a fee-free drop
1805      * @param _to address of the future owner of the token
1806      * @param _qty amount of tokens to drop the owner
1807      */
1808      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1809          require(_qty > 0, "Must mint at least 1 token.");
1810          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1811          _safeMint(_to, _qty, true);
1812      }
1813 
1814   
1815     /////////////// PUBLIC MINT FUNCTIONS
1816     /**
1817     * @dev Mints tokens to an address in batch.
1818     * fee may or may not be required*
1819     * @param _to address of the future owner of the token
1820     * @param _amount number of tokens to mint
1821     */
1822     function mintToMultiple(address _to, uint256 _amount) public payable {
1823         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1824         require(_amount >= 1, "Must mint at least 1 token");
1825         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1826         require(mintingOpen == true, "Minting is not open right now!");
1827         
1828         
1829         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1830         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1831 
1832         _safeMint(_to, _amount, false);
1833     }
1834 
1835     /**
1836      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1837      * fee may or may not be required*
1838      * @param _to address of the future owner of the token
1839      * @param _amount number of tokens to mint
1840      * @param _erc20TokenContract erc-20 token contract to mint with
1841      */
1842     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1843       require(_amount >= 1, "Must mint at least 1 token");
1844       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1845       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1846       require(mintingOpen == true, "Minting is not open right now!");
1847       
1848       
1849 
1850       // ERC-20 Specific pre-flight checks
1851       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1852       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1853       IERC20 payableToken = IERC20(_erc20TokenContract);
1854 
1855       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1856       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1857 
1858       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1859       require(transferComplete, "ERC-20 token was unable to be transferred");
1860       
1861       _safeMint(_to, _amount, false);
1862     }
1863 
1864     function openMinting() public onlyTeamOrOwner {
1865         mintingOpen = true;
1866     }
1867 
1868     function stopMinting() public onlyTeamOrOwner {
1869         mintingOpen = false;
1870     }
1871 
1872   
1873 
1874   
1875 
1876   
1877     /**
1878      * @dev Allows owner to set Max mints per tx
1879      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1880      */
1881      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1882          require(_newMaxMint >= 1, "Max mint must be at least 1");
1883          maxBatchSize = _newMaxMint;
1884      }
1885     
1886 
1887   
1888 
1889   function _baseURI() internal view virtual override returns(string memory) {
1890     return _baseTokenURI;
1891   }
1892 
1893   function _baseURIExtension() internal view virtual override returns(string memory) {
1894     return _baseTokenExtension;
1895   }
1896 
1897   function baseTokenURI() public view returns(string memory) {
1898     return _baseTokenURI;
1899   }
1900 
1901   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1902     _baseTokenURI = baseURI;
1903   }
1904 
1905   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
1906     _baseTokenExtension = baseExtension;
1907   }
1908 
1909   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1910     return ownershipOf(tokenId);
1911   }
1912 }
1913 
1914 
1915   
1916 // File: contracts/TheLastSupperBaycContract.sol
1917 //SPDX-License-Identifier: MIT
1918 
1919 pragma solidity ^0.8.0;
1920 
1921 contract TheLastSupperBaycContract is RamppERC721A {
1922     constructor() RamppERC721A("The Last Supper BAYC", "TLSB"){}
1923 }
1924   