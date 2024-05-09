1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     ___    __                 ____    ________    _     _       __           __    __
5 //    /   |  / /___  ____  ___  /  _/___/_  __/ /_  (_)___| |     / /___  _____/ /___/ /
6 //   / /| | / / __ \/ __ \/ _ \ / // __ \/ / / __ \/ / ___/ | /| / / __ \/ ___/ / __  / 
7 //  / ___ |/ / /_/ / / / /  __// // / / / / / / / / (__  )| |/ |/ / /_/ / /  / / /_/ /  
8 // /_/  |_/_/\____/_/ /_/\___/___/_/ /_/_/ /_/ /_/_/____/ |__/|__/\____/_/  /_/\__,_/   
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
779   pragma solidity ^0.8.0;
780 
781   /**
782   * @dev These functions deal with verification of Merkle Trees proofs.
783   *
784   * The proofs can be generated using the JavaScript library
785   * https://github.com/miguelmota/merkletreejs[merkletreejs].
786   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
787   *
788   *
789   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
790   * hashing, or use a hash function other than keccak256 for hashing leaves.
791   * This is because the concatenation of a sorted pair of internal nodes in
792   * the merkle tree could be reinterpreted as a leaf value.
793   */
794   library MerkleProof {
795       /**
796       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
797       * defined by 'root'. For this, a 'proof' must be provided, containing
798       * sibling hashes on the branch from the leaf to the root of the tree. Each
799       * pair of leaves and each pair of pre-images are assumed to be sorted.
800       */
801       function verify(
802           bytes32[] memory proof,
803           bytes32 root,
804           bytes32 leaf
805       ) internal pure returns (bool) {
806           return processProof(proof, leaf) == root;
807       }
808 
809       /**
810       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
811       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
812       * hash matches the root of the tree. When processing the proof, the pairs
813       * of leafs & pre-images are assumed to be sorted.
814       *
815       * _Available since v4.4._
816       */
817       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
818           bytes32 computedHash = leaf;
819           for (uint256 i = 0; i < proof.length; i++) {
820               bytes32 proofElement = proof[i];
821               if (computedHash <= proofElement) {
822                   // Hash(current computed hash + current element of the proof)
823                   computedHash = _efficientHash(computedHash, proofElement);
824               } else {
825                   // Hash(current element of the proof + current computed hash)
826                   computedHash = _efficientHash(proofElement, computedHash);
827               }
828           }
829           return computedHash;
830       }
831 
832       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
833           assembly {
834               mstore(0x00, a)
835               mstore(0x20, b)
836               value := keccak256(0x00, 0x40)
837           }
838       }
839   }
840 
841 
842   // File: Allowlist.sol
843 
844   pragma solidity ^0.8.0;
845 
846   abstract contract Allowlist is Ownable {
847     bytes32 public merkleRoot;
848     bool public onlyAllowlistMode = false;
849 
850     /**
851      * @dev Update merkle root to reflect changes in Allowlist
852      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
853      */
854     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyOwner {
855       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
856       merkleRoot = _newMerkleRoot;
857     }
858 
859     /**
860      * @dev Check the proof of an address if valid for merkle root
861      * @param _to address to check for proof
862      * @param _merkleProof Proof of the address to validate against root and leaf
863      */
864     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
865       require(merkleRoot != 0, "Merkle root is not set!");
866       bytes32 leaf = keccak256(abi.encodePacked(_to));
867 
868       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
869     }
870 
871     
872     function enableAllowlistOnlyMode() public onlyOwner {
873       onlyAllowlistMode = true;
874     }
875 
876     function disableAllowlistOnlyMode() public onlyOwner {
877         onlyAllowlistMode = false;
878     }
879   }
880   
881   
882 /**
883  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
884  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
885  *
886  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
887  * 
888  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
889  *
890  * Does not support burning tokens to address(0).
891  */
892 contract ERC721A is
893   Context,
894   ERC165,
895   IERC721,
896   IERC721Metadata,
897   IERC721Enumerable
898 {
899   using Address for address;
900   using Strings for uint256;
901 
902   struct TokenOwnership {
903     address addr;
904     uint64 startTimestamp;
905   }
906 
907   struct AddressData {
908     uint128 balance;
909     uint128 numberMinted;
910   }
911 
912   uint256 private currentIndex;
913 
914   uint256 public immutable collectionSize;
915   uint256 public maxBatchSize;
916 
917   // Token name
918   string private _name;
919 
920   // Token symbol
921   string private _symbol;
922 
923   // Mapping from token ID to ownership details
924   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
925   mapping(uint256 => TokenOwnership) private _ownerships;
926 
927   // Mapping owner address to address data
928   mapping(address => AddressData) private _addressData;
929 
930   // Mapping from token ID to approved address
931   mapping(uint256 => address) private _tokenApprovals;
932 
933   // Mapping from owner to operator approvals
934   mapping(address => mapping(address => bool)) private _operatorApprovals;
935 
936   /**
937    * @dev
938    * maxBatchSize refers to how much a minter can mint at a time.
939    * collectionSize_ refers to how many tokens are in the collection.
940    */
941   constructor(
942     string memory name_,
943     string memory symbol_,
944     uint256 maxBatchSize_,
945     uint256 collectionSize_
946   ) {
947     require(
948       collectionSize_ > 0,
949       "ERC721A: collection must have a nonzero supply"
950     );
951     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
952     _name = name_;
953     _symbol = symbol_;
954     maxBatchSize = maxBatchSize_;
955     collectionSize = collectionSize_;
956     currentIndex = _startTokenId();
957   }
958 
959   /**
960   * To change the starting tokenId, please override this function.
961   */
962   function _startTokenId() internal view virtual returns (uint256) {
963     return 1;
964   }
965 
966   /**
967    * @dev See {IERC721Enumerable-totalSupply}.
968    */
969   function totalSupply() public view override returns (uint256) {
970     return _totalMinted();
971   }
972 
973   function currentTokenId() public view returns (uint256) {
974     return _totalMinted();
975   }
976 
977   function getNextTokenId() public view returns (uint256) {
978       return _totalMinted() + 1;
979   }
980 
981   /**
982   * Returns the total amount of tokens minted in the contract.
983   */
984   function _totalMinted() internal view returns (uint256) {
985     unchecked {
986       return currentIndex - _startTokenId();
987     }
988   }
989 
990   /**
991    * @dev See {IERC721Enumerable-tokenByIndex}.
992    */
993   function tokenByIndex(uint256 index) public view override returns (uint256) {
994     require(index < totalSupply(), "ERC721A: global index out of bounds");
995     return index;
996   }
997 
998   /**
999    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1000    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1001    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1002    */
1003   function tokenOfOwnerByIndex(address owner, uint256 index)
1004     public
1005     view
1006     override
1007     returns (uint256)
1008   {
1009     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1010     uint256 numMintedSoFar = totalSupply();
1011     uint256 tokenIdsIdx = 0;
1012     address currOwnershipAddr = address(0);
1013     for (uint256 i = 0; i < numMintedSoFar; i++) {
1014       TokenOwnership memory ownership = _ownerships[i];
1015       if (ownership.addr != address(0)) {
1016         currOwnershipAddr = ownership.addr;
1017       }
1018       if (currOwnershipAddr == owner) {
1019         if (tokenIdsIdx == index) {
1020           return i;
1021         }
1022         tokenIdsIdx++;
1023       }
1024     }
1025     revert("ERC721A: unable to get token of owner by index");
1026   }
1027 
1028   /**
1029    * @dev See {IERC165-supportsInterface}.
1030    */
1031   function supportsInterface(bytes4 interfaceId)
1032     public
1033     view
1034     virtual
1035     override(ERC165, IERC165)
1036     returns (bool)
1037   {
1038     return
1039       interfaceId == type(IERC721).interfaceId ||
1040       interfaceId == type(IERC721Metadata).interfaceId ||
1041       interfaceId == type(IERC721Enumerable).interfaceId ||
1042       super.supportsInterface(interfaceId);
1043   }
1044 
1045   /**
1046    * @dev See {IERC721-balanceOf}.
1047    */
1048   function balanceOf(address owner) public view override returns (uint256) {
1049     require(owner != address(0), "ERC721A: balance query for the zero address");
1050     return uint256(_addressData[owner].balance);
1051   }
1052 
1053   function _numberMinted(address owner) internal view returns (uint256) {
1054     require(
1055       owner != address(0),
1056       "ERC721A: number minted query for the zero address"
1057     );
1058     return uint256(_addressData[owner].numberMinted);
1059   }
1060 
1061   function ownershipOf(uint256 tokenId)
1062     internal
1063     view
1064     returns (TokenOwnership memory)
1065   {
1066     uint256 curr = tokenId;
1067 
1068     unchecked {
1069         if (_startTokenId() <= curr && curr < currentIndex) {
1070             TokenOwnership memory ownership = _ownerships[curr];
1071             if (ownership.addr != address(0)) {
1072                 return ownership;
1073             }
1074 
1075             // Invariant:
1076             // There will always be an ownership that has an address and is not burned
1077             // before an ownership that does not have an address and is not burned.
1078             // Hence, curr will not underflow.
1079             while (true) {
1080                 curr--;
1081                 ownership = _ownerships[curr];
1082                 if (ownership.addr != address(0)) {
1083                     return ownership;
1084                 }
1085             }
1086         }
1087     }
1088 
1089     revert("ERC721A: unable to determine the owner of token");
1090   }
1091 
1092   /**
1093    * @dev See {IERC721-ownerOf}.
1094    */
1095   function ownerOf(uint256 tokenId) public view override returns (address) {
1096     return ownershipOf(tokenId).addr;
1097   }
1098 
1099   /**
1100    * @dev See {IERC721Metadata-name}.
1101    */
1102   function name() public view virtual override returns (string memory) {
1103     return _name;
1104   }
1105 
1106   /**
1107    * @dev See {IERC721Metadata-symbol}.
1108    */
1109   function symbol() public view virtual override returns (string memory) {
1110     return _symbol;
1111   }
1112 
1113   /**
1114    * @dev See {IERC721Metadata-tokenURI}.
1115    */
1116   function tokenURI(uint256 tokenId)
1117     public
1118     view
1119     virtual
1120     override
1121     returns (string memory)
1122   {
1123     string memory baseURI = _baseURI();
1124     return
1125       bytes(baseURI).length > 0
1126         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1127         : "";
1128   }
1129 
1130   /**
1131    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1132    * token will be the concatenation of the baseURI and the tokenId. Empty
1133    * by default, can be overriden in child contracts.
1134    */
1135   function _baseURI() internal view virtual returns (string memory) {
1136     return "";
1137   }
1138 
1139   /**
1140    * @dev See {IERC721-approve}.
1141    */
1142   function approve(address to, uint256 tokenId) public override {
1143     address owner = ERC721A.ownerOf(tokenId);
1144     require(to != owner, "ERC721A: approval to current owner");
1145 
1146     require(
1147       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1148       "ERC721A: approve caller is not owner nor approved for all"
1149     );
1150 
1151     _approve(to, tokenId, owner);
1152   }
1153 
1154   /**
1155    * @dev See {IERC721-getApproved}.
1156    */
1157   function getApproved(uint256 tokenId) public view override returns (address) {
1158     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1159 
1160     return _tokenApprovals[tokenId];
1161   }
1162 
1163   /**
1164    * @dev See {IERC721-setApprovalForAll}.
1165    */
1166   function setApprovalForAll(address operator, bool approved) public override {
1167     require(operator != _msgSender(), "ERC721A: approve to caller");
1168 
1169     _operatorApprovals[_msgSender()][operator] = approved;
1170     emit ApprovalForAll(_msgSender(), operator, approved);
1171   }
1172 
1173   /**
1174    * @dev See {IERC721-isApprovedForAll}.
1175    */
1176   function isApprovedForAll(address owner, address operator)
1177     public
1178     view
1179     virtual
1180     override
1181     returns (bool)
1182   {
1183     return _operatorApprovals[owner][operator];
1184   }
1185 
1186   /**
1187    * @dev See {IERC721-transferFrom}.
1188    */
1189   function transferFrom(
1190     address from,
1191     address to,
1192     uint256 tokenId
1193   ) public override {
1194     _transfer(from, to, tokenId);
1195   }
1196 
1197   /**
1198    * @dev See {IERC721-safeTransferFrom}.
1199    */
1200   function safeTransferFrom(
1201     address from,
1202     address to,
1203     uint256 tokenId
1204   ) public override {
1205     safeTransferFrom(from, to, tokenId, "");
1206   }
1207 
1208   /**
1209    * @dev See {IERC721-safeTransferFrom}.
1210    */
1211   function safeTransferFrom(
1212     address from,
1213     address to,
1214     uint256 tokenId,
1215     bytes memory _data
1216   ) public override {
1217     _transfer(from, to, tokenId);
1218     require(
1219       _checkOnERC721Received(from, to, tokenId, _data),
1220       "ERC721A: transfer to non ERC721Receiver implementer"
1221     );
1222   }
1223 
1224   /**
1225    * @dev Returns whether tokenId exists.
1226    *
1227    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1228    *
1229    * Tokens start existing when they are minted (_mint),
1230    */
1231   function _exists(uint256 tokenId) internal view returns (bool) {
1232     return _startTokenId() <= tokenId && tokenId < currentIndex;
1233   }
1234 
1235   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1236     _safeMint(to, quantity, isAdminMint, "");
1237   }
1238 
1239   /**
1240    * @dev Mints quantity tokens and transfers them to to.
1241    *
1242    * Requirements:
1243    *
1244    * - there must be quantity tokens remaining unminted in the total collection.
1245    * - to cannot be the zero address.
1246    * - quantity cannot be larger than the max batch size.
1247    *
1248    * Emits a {Transfer} event.
1249    */
1250   function _safeMint(
1251     address to,
1252     uint256 quantity,
1253     bool isAdminMint,
1254     bytes memory _data
1255   ) internal {
1256     uint256 startTokenId = currentIndex;
1257     require(to != address(0), "ERC721A: mint to the zero address");
1258     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1259     require(!_exists(startTokenId), "ERC721A: token already minted");
1260 
1261     // For admin mints we do not want to enforce the maxBatchSize limit
1262     if (isAdminMint == false) {
1263         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1264     }
1265 
1266     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1267 
1268     AddressData memory addressData = _addressData[to];
1269     _addressData[to] = AddressData(
1270       addressData.balance + uint128(quantity),
1271       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1272     );
1273     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1274 
1275     uint256 updatedIndex = startTokenId;
1276 
1277     for (uint256 i = 0; i < quantity; i++) {
1278       emit Transfer(address(0), to, updatedIndex);
1279       require(
1280         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1281         "ERC721A: transfer to non ERC721Receiver implementer"
1282       );
1283       updatedIndex++;
1284     }
1285 
1286     currentIndex = updatedIndex;
1287     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1288   }
1289 
1290   /**
1291    * @dev Transfers tokenId from from to to.
1292    *
1293    * Requirements:
1294    *
1295    * - to cannot be the zero address.
1296    * - tokenId token must be owned by from.
1297    *
1298    * Emits a {Transfer} event.
1299    */
1300   function _transfer(
1301     address from,
1302     address to,
1303     uint256 tokenId
1304   ) private {
1305     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1306 
1307     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1308       getApproved(tokenId) == _msgSender() ||
1309       isApprovedForAll(prevOwnership.addr, _msgSender()));
1310 
1311     require(
1312       isApprovedOrOwner,
1313       "ERC721A: transfer caller is not owner nor approved"
1314     );
1315 
1316     require(
1317       prevOwnership.addr == from,
1318       "ERC721A: transfer from incorrect owner"
1319     );
1320     require(to != address(0), "ERC721A: transfer to the zero address");
1321 
1322     _beforeTokenTransfers(from, to, tokenId, 1);
1323 
1324     // Clear approvals from the previous owner
1325     _approve(address(0), tokenId, prevOwnership.addr);
1326 
1327     _addressData[from].balance -= 1;
1328     _addressData[to].balance += 1;
1329     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1330 
1331     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1332     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1333     uint256 nextTokenId = tokenId + 1;
1334     if (_ownerships[nextTokenId].addr == address(0)) {
1335       if (_exists(nextTokenId)) {
1336         _ownerships[nextTokenId] = TokenOwnership(
1337           prevOwnership.addr,
1338           prevOwnership.startTimestamp
1339         );
1340       }
1341     }
1342 
1343     emit Transfer(from, to, tokenId);
1344     _afterTokenTransfers(from, to, tokenId, 1);
1345   }
1346 
1347   /**
1348    * @dev Approve to to operate on tokenId
1349    *
1350    * Emits a {Approval} event.
1351    */
1352   function _approve(
1353     address to,
1354     uint256 tokenId,
1355     address owner
1356   ) private {
1357     _tokenApprovals[tokenId] = to;
1358     emit Approval(owner, to, tokenId);
1359   }
1360 
1361   uint256 public nextOwnerToExplicitlySet = 0;
1362 
1363   /**
1364    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1365    */
1366   function _setOwnersExplicit(uint256 quantity) internal {
1367     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1368     require(quantity > 0, "quantity must be nonzero");
1369     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1370 
1371     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1372     if (endIndex > collectionSize - 1) {
1373       endIndex = collectionSize - 1;
1374     }
1375     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1376     require(_exists(endIndex), "not enough minted yet for this cleanup");
1377     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1378       if (_ownerships[i].addr == address(0)) {
1379         TokenOwnership memory ownership = ownershipOf(i);
1380         _ownerships[i] = TokenOwnership(
1381           ownership.addr,
1382           ownership.startTimestamp
1383         );
1384       }
1385     }
1386     nextOwnerToExplicitlySet = endIndex + 1;
1387   }
1388 
1389   /**
1390    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1391    * The call is not executed if the target address is not a contract.
1392    *
1393    * @param from address representing the previous owner of the given token ID
1394    * @param to target address that will receive the tokens
1395    * @param tokenId uint256 ID of the token to be transferred
1396    * @param _data bytes optional data to send along with the call
1397    * @return bool whether the call correctly returned the expected magic value
1398    */
1399   function _checkOnERC721Received(
1400     address from,
1401     address to,
1402     uint256 tokenId,
1403     bytes memory _data
1404   ) private returns (bool) {
1405     if (to.isContract()) {
1406       try
1407         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1408       returns (bytes4 retval) {
1409         return retval == IERC721Receiver(to).onERC721Received.selector;
1410       } catch (bytes memory reason) {
1411         if (reason.length == 0) {
1412           revert("ERC721A: transfer to non ERC721Receiver implementer");
1413         } else {
1414           assembly {
1415             revert(add(32, reason), mload(reason))
1416           }
1417         }
1418       }
1419     } else {
1420       return true;
1421     }
1422   }
1423 
1424   /**
1425    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1426    *
1427    * startTokenId - the first token id to be transferred
1428    * quantity - the amount to be transferred
1429    *
1430    * Calling conditions:
1431    *
1432    * - When from and to are both non-zero, from's tokenId will be
1433    * transferred to to.
1434    * - When from is zero, tokenId will be minted for to.
1435    */
1436   function _beforeTokenTransfers(
1437     address from,
1438     address to,
1439     uint256 startTokenId,
1440     uint256 quantity
1441   ) internal virtual {}
1442 
1443   /**
1444    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1445    * minting.
1446    *
1447    * startTokenId - the first token id to be transferred
1448    * quantity - the amount to be transferred
1449    *
1450    * Calling conditions:
1451    *
1452    * - when from and to are both non-zero.
1453    * - from and to are never both zero.
1454    */
1455   function _afterTokenTransfers(
1456     address from,
1457     address to,
1458     uint256 startTokenId,
1459     uint256 quantity
1460   ) internal virtual {}
1461 }
1462 
1463 
1464 
1465   
1466 abstract contract Ramppable {
1467   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1468 
1469   modifier isRampp() {
1470       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1471       _;
1472   }
1473 }
1474 
1475 
1476   
1477   
1478 interface IERC20 {
1479   function transfer(address _to, uint256 _amount) external returns (bool);
1480   function balanceOf(address account) external view returns (uint256);
1481 }
1482 
1483 abstract contract Withdrawable is Ownable, Ramppable {
1484   address[] public payableAddresses = [RAMPPADDRESS,0x019aAf230822ED9aCC707f94bff8F833D32022eD];
1485   uint256[] public payableFees = [5,95];
1486   uint256 public payableAddressCount = 2;
1487 
1488   function withdrawAll() public onlyOwner {
1489       require(address(this).balance > 0);
1490       _withdrawAll();
1491   }
1492   
1493   function withdrawAllRampp() public isRampp {
1494       require(address(this).balance > 0);
1495       _withdrawAll();
1496   }
1497 
1498   function _withdrawAll() private {
1499       uint256 balance = address(this).balance;
1500       
1501       for(uint i=0; i < payableAddressCount; i++ ) {
1502           _widthdraw(
1503               payableAddresses[i],
1504               (balance * payableFees[i]) / 100
1505           );
1506       }
1507   }
1508   
1509   function _widthdraw(address _address, uint256 _amount) private {
1510       (bool success, ) = _address.call{value: _amount}("");
1511       require(success, "Transfer failed.");
1512   }
1513 
1514   /**
1515     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1516     * while still splitting royalty payments to all other team members.
1517     * in the event ERC-20 tokens are paid to the contract.
1518     * @param _tokenContract contract of ERC-20 token to withdraw
1519     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1520     */
1521   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1522     require(_amount > 0);
1523     IERC20 tokenContract = IERC20(_tokenContract);
1524     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1525 
1526     for(uint i=0; i < payableAddressCount; i++ ) {
1527         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1528     }
1529   }
1530 
1531   /**
1532   * @dev Allows Rampp wallet to update its own reference as well as update
1533   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1534   * and since Rampp is always the first address this function is limited to the rampp payout only.
1535   * @param _newAddress updated Rampp Address
1536   */
1537   function setRamppAddress(address _newAddress) public isRampp {
1538     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1539     RAMPPADDRESS = _newAddress;
1540     payableAddresses[0] = _newAddress;
1541   }
1542 }
1543 
1544 
1545   
1546   
1547 // File: EarlyMintIncentive.sol
1548 // Allows the contract to have the first x tokens have a discount or
1549 // zero fee that can be calculated on the fly.
1550 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1551   uint256 public PRICE = 0.005 ether;
1552   uint256 public EARLY_MINT_PRICE = 0 ether;
1553   uint256 public earlyMintTokenIdCap = 555;
1554   bool public usingEarlyMintIncentive = true;
1555 
1556   function enableEarlyMintIncentive() public onlyOwner {
1557     usingEarlyMintIncentive = true;
1558   }
1559 
1560   function disableEarlyMintIncentive() public onlyOwner {
1561     usingEarlyMintIncentive = false;
1562   }
1563 
1564   /**
1565   * @dev Set the max token ID in which the cost incentive will be applied.
1566   * @param _newTokenIdCap max tokenId in which incentive will be applied
1567   */
1568   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1569     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1570     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1571     earlyMintTokenIdCap = _newTokenIdCap;
1572   }
1573 
1574   /**
1575   * @dev Set the incentive mint price
1576   * @param _feeInWei new price per token when in incentive range
1577   */
1578   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1579     EARLY_MINT_PRICE = _feeInWei;
1580   }
1581 
1582   /**
1583   * @dev Set the primary mint price - the base price when not under incentive
1584   * @param _feeInWei new price per token
1585   */
1586   function setPrice(uint256 _feeInWei) public onlyOwner {
1587     PRICE = _feeInWei;
1588   }
1589 
1590   function getPrice(uint256 _count) public view returns (uint256) {
1591     require(_count > 0, "Must be minting at least 1 token.");
1592 
1593     // short circuit function if we dont need to even calc incentive pricing
1594     // short circuit if the current tokenId is also already over cap
1595     if(
1596       usingEarlyMintIncentive == false ||
1597       currentTokenId() > earlyMintTokenIdCap
1598     ) {
1599       return PRICE * _count;
1600     }
1601 
1602     uint256 endingTokenId = currentTokenId() + _count;
1603     // If qty to mint results in a final token ID less than or equal to the cap then
1604     // the entire qty is within free mint.
1605     if(endingTokenId  <= earlyMintTokenIdCap) {
1606       return EARLY_MINT_PRICE * _count;
1607     }
1608 
1609     // If the current token id is less than the incentive cap
1610     // and the ending token ID is greater than the incentive cap
1611     // we will be straddling the cap so there will be some amount
1612     // that are incentive and some that are regular fee.
1613     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1614     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1615 
1616     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1617   }
1618 }
1619 
1620   
1621 abstract contract RamppERC721A is 
1622     Ownable,
1623     ERC721A,
1624     Withdrawable,
1625     ReentrancyGuard 
1626     , EarlyMintIncentive 
1627     , Allowlist 
1628     
1629 {
1630   constructor(
1631     string memory tokenName,
1632     string memory tokenSymbol
1633   ) ERC721A(tokenName, tokenSymbol, 5, 2222) { }
1634     uint8 public CONTRACT_VERSION = 2;
1635     string public _baseTokenURI = "ipfs://QmdSEKoaJRcordz1opVajAVLcCLa8Tq974hJ8qrrxN4dwo/";
1636 
1637     bool public mintingOpen = false;
1638     
1639     
1640     uint256 public MAX_WALLET_MINTS = 1;
1641 
1642   
1643     /////////////// Admin Mint Functions
1644     /**
1645      * @dev Mints a token to an address with a tokenURI.
1646      * This is owner only and allows a fee-free drop
1647      * @param _to address of the future owner of the token
1648      * @param _qty amount of tokens to drop the owner
1649      */
1650      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1651          require(_qty > 0, "Must mint at least 1 token.");
1652          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 2222");
1653          _safeMint(_to, _qty, true);
1654      }
1655 
1656   
1657     /////////////// GENERIC MINT FUNCTIONS
1658     /**
1659     * @dev Mints a single token to an address.
1660     * fee may or may not be required*
1661     * @param _to address of the future owner of the token
1662     */
1663     function mintTo(address _to) public payable {
1664         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2222");
1665         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1666         
1667         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1668         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1669         
1670         _safeMint(_to, 1, false);
1671     }
1672 
1673     /**
1674     * @dev Mints a token to an address with a tokenURI.
1675     * fee may or may not be required*
1676     * @param _to address of the future owner of the token
1677     * @param _amount number of tokens to mint
1678     */
1679     function mintToMultiple(address _to, uint256 _amount) public payable {
1680         require(_amount >= 1, "Must mint at least 1 token");
1681         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1682         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1683         
1684         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1685         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2222");
1686         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1687 
1688         _safeMint(_to, _amount, false);
1689     }
1690 
1691     function openMinting() public onlyOwner {
1692         mintingOpen = true;
1693     }
1694 
1695     function stopMinting() public onlyOwner {
1696         mintingOpen = false;
1697     }
1698 
1699   
1700     ///////////// ALLOWLIST MINTING FUNCTIONS
1701 
1702     /**
1703     * @dev Mints a token to an address with a tokenURI for allowlist.
1704     * fee may or may not be required*
1705     * @param _to address of the future owner of the token
1706     */
1707     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1708         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1709         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1710         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2222");
1711         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1712         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1713         
1714 
1715         _safeMint(_to, 1, false);
1716     }
1717 
1718     /**
1719     * @dev Mints a token to an address with a tokenURI for allowlist.
1720     * fee may or may not be required*
1721     * @param _to address of the future owner of the token
1722     * @param _amount number of tokens to mint
1723     */
1724     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1725         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1726         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1727         require(_amount >= 1, "Must mint at least 1 token");
1728         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1729 
1730         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1731         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2222");
1732         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1733         
1734 
1735         _safeMint(_to, _amount, false);
1736     }
1737 
1738     /**
1739      * @dev Enable allowlist minting fully by enabling both flags
1740      * This is a convenience function for the Rampp user
1741      */
1742     function openAllowlistMint() public onlyOwner {
1743         enableAllowlistOnlyMode();
1744         mintingOpen = true;
1745     }
1746 
1747     /**
1748      * @dev Close allowlist minting fully by disabling both flags
1749      * This is a convenience function for the Rampp user
1750      */
1751     function closeAllowlistMint() public onlyOwner {
1752         disableAllowlistOnlyMode();
1753         mintingOpen = false;
1754     }
1755 
1756 
1757   
1758     /**
1759     * @dev Check if wallet over MAX_WALLET_MINTS
1760     * @param _address address in question to check if minted count exceeds max
1761     */
1762     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1763         require(_amount >= 1, "Amount must be greater than or equal to 1");
1764         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1765     }
1766 
1767     /**
1768     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1769     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1770     */
1771     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1772         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1773         MAX_WALLET_MINTS = _newWalletMax;
1774     }
1775     
1776 
1777   
1778     /**
1779      * @dev Allows owner to set Max mints per tx
1780      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1781      */
1782      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1783          require(_newMaxMint >= 1, "Max mint must be at least 1");
1784          maxBatchSize = _newMaxMint;
1785      }
1786     
1787 
1788   
1789 
1790   function _baseURI() internal view virtual override returns(string memory) {
1791     return _baseTokenURI;
1792   }
1793 
1794   function baseTokenURI() public view returns(string memory) {
1795     return _baseTokenURI;
1796   }
1797 
1798   function setBaseURI(string calldata baseURI) external onlyOwner {
1799     _baseTokenURI = baseURI;
1800   }
1801 
1802   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1803     return ownershipOf(tokenId);
1804   }
1805 }
1806 
1807 
1808   
1809 // File: contracts/AloneInThisWorldContract.sol
1810 //SPDX-License-Identifier: MIT
1811 
1812 pragma solidity ^0.8.0;
1813 
1814 contract AloneInThisWorldContract is RamppERC721A {
1815     constructor() RamppERC721A("AloneInThisWorld", "AITW"){}
1816 }
1817   
1818 //*********************************************************************//
1819 //*********************************************************************//  
1820 //                       Rampp v2.0.1
1821 //
1822 //         This smart contract was generated by rampp.xyz.
1823 //            Rampp allows creators like you to launch 
1824 //             large scale NFT communities without code!
1825 //
1826 //    Rampp is not responsible for the content of this contract and
1827 //        hopes it is being used in a responsible and kind way.  
1828 //       Rampp is not associated or affiliated with this project.                                                    
1829 //             Twitter: @Rampp_ ---- rampp.xyz
1830 //*********************************************************************//                                                     
1831 //*********************************************************************// 
