1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     ____        _       __                 _______ __   _ 
5 //    / __ \____ _(_)___  / /_  ____ _      _/_  __(_) /__(_)
6 //   / /_/ / __ `/ / __ \/ __ \/ __ \ | /| / // / / / //_/ / 
7 //  / _, _/ /_/ / / / / / /_/ / /_/ / |/ |/ // / / / ,< / /  
8 // /_/ |_|\__,_/_/_/ /_/_.___/\____/|__/|__//_/ /_/_/|_/_/   
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
1195     string memory extension = _baseURIExtension();
1196     return
1197       bytes(baseURI).length > 0
1198         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1199         : "";
1200   }
1201 
1202   /**
1203    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1204    * token will be the concatenation of the baseURI and the tokenId. Empty
1205    * by default, can be overriden in child contracts.
1206    */
1207   function _baseURI() internal view virtual returns (string memory) {
1208     return "";
1209   }
1210 
1211   /**
1212    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1213    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1214    * by default, can be overriden in child contracts.
1215    */
1216   function _baseURIExtension() internal view virtual returns (string memory) {
1217     return "";
1218   }
1219 
1220   /**
1221    * @dev Sets the value for an address to be in the restricted approval address pool.
1222    * Setting an address to true will disable token owners from being able to mark the address
1223    * for approval for trading. This would be used in theory to prevent token owners from listing
1224    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1225    * @param _address the marketplace/user to modify restriction status of
1226    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1227    */
1228   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1229     restrictedApprovalAddresses[_address] = _isRestricted;
1230   }
1231 
1232   /**
1233    * @dev See {IERC721-approve}.
1234    */
1235   function approve(address to, uint256 tokenId) public override {
1236     address owner = ERC721A.ownerOf(tokenId);
1237     require(to != owner, "ERC721A: approval to current owner");
1238     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1239 
1240     require(
1241       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1242       "ERC721A: approve caller is not owner nor approved for all"
1243     );
1244 
1245     _approve(to, tokenId, owner);
1246   }
1247 
1248   /**
1249    * @dev See {IERC721-getApproved}.
1250    */
1251   function getApproved(uint256 tokenId) public view override returns (address) {
1252     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1253 
1254     return _tokenApprovals[tokenId];
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-setApprovalForAll}.
1259    */
1260   function setApprovalForAll(address operator, bool approved) public override {
1261     require(operator != _msgSender(), "ERC721A: approve to caller");
1262     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1263 
1264     _operatorApprovals[_msgSender()][operator] = approved;
1265     emit ApprovalForAll(_msgSender(), operator, approved);
1266   }
1267 
1268   /**
1269    * @dev See {IERC721-isApprovedForAll}.
1270    */
1271   function isApprovedForAll(address owner, address operator)
1272     public
1273     view
1274     virtual
1275     override
1276     returns (bool)
1277   {
1278     return _operatorApprovals[owner][operator];
1279   }
1280 
1281   /**
1282    * @dev See {IERC721-transferFrom}.
1283    */
1284   function transferFrom(
1285     address from,
1286     address to,
1287     uint256 tokenId
1288   ) public override {
1289     _transfer(from, to, tokenId);
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-safeTransferFrom}.
1294    */
1295   function safeTransferFrom(
1296     address from,
1297     address to,
1298     uint256 tokenId
1299   ) public override {
1300     safeTransferFrom(from, to, tokenId, "");
1301   }
1302 
1303   /**
1304    * @dev See {IERC721-safeTransferFrom}.
1305    */
1306   function safeTransferFrom(
1307     address from,
1308     address to,
1309     uint256 tokenId,
1310     bytes memory _data
1311   ) public override {
1312     _transfer(from, to, tokenId);
1313     require(
1314       _checkOnERC721Received(from, to, tokenId, _data),
1315       "ERC721A: transfer to non ERC721Receiver implementer"
1316     );
1317   }
1318 
1319   /**
1320    * @dev Returns whether tokenId exists.
1321    *
1322    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1323    *
1324    * Tokens start existing when they are minted (_mint),
1325    */
1326   function _exists(uint256 tokenId) internal view returns (bool) {
1327     return _startTokenId() <= tokenId && tokenId < currentIndex;
1328   }
1329 
1330   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1331     _safeMint(to, quantity, isAdminMint, "");
1332   }
1333 
1334   /**
1335    * @dev Mints quantity tokens and transfers them to to.
1336    *
1337    * Requirements:
1338    *
1339    * - there must be quantity tokens remaining unminted in the total collection.
1340    * - to cannot be the zero address.
1341    * - quantity cannot be larger than the max batch size.
1342    *
1343    * Emits a {Transfer} event.
1344    */
1345   function _safeMint(
1346     address to,
1347     uint256 quantity,
1348     bool isAdminMint,
1349     bytes memory _data
1350   ) internal {
1351     uint256 startTokenId = currentIndex;
1352     require(to != address(0), "ERC721A: mint to the zero address");
1353     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1354     require(!_exists(startTokenId), "ERC721A: token already minted");
1355 
1356     // For admin mints we do not want to enforce the maxBatchSize limit
1357     if (isAdminMint == false) {
1358         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1359     }
1360 
1361     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1362 
1363     AddressData memory addressData = _addressData[to];
1364     _addressData[to] = AddressData(
1365       addressData.balance + uint128(quantity),
1366       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1367     );
1368     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1369 
1370     uint256 updatedIndex = startTokenId;
1371 
1372     for (uint256 i = 0; i < quantity; i++) {
1373       emit Transfer(address(0), to, updatedIndex);
1374       require(
1375         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1376         "ERC721A: transfer to non ERC721Receiver implementer"
1377       );
1378       updatedIndex++;
1379     }
1380 
1381     currentIndex = updatedIndex;
1382     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1383   }
1384 
1385   /**
1386    * @dev Transfers tokenId from from to to.
1387    *
1388    * Requirements:
1389    *
1390    * - to cannot be the zero address.
1391    * - tokenId token must be owned by from.
1392    *
1393    * Emits a {Transfer} event.
1394    */
1395   function _transfer(
1396     address from,
1397     address to,
1398     uint256 tokenId
1399   ) private {
1400     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1401 
1402     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1403       getApproved(tokenId) == _msgSender() ||
1404       isApprovedForAll(prevOwnership.addr, _msgSender()));
1405 
1406     require(
1407       isApprovedOrOwner,
1408       "ERC721A: transfer caller is not owner nor approved"
1409     );
1410 
1411     require(
1412       prevOwnership.addr == from,
1413       "ERC721A: transfer from incorrect owner"
1414     );
1415     require(to != address(0), "ERC721A: transfer to the zero address");
1416 
1417     _beforeTokenTransfers(from, to, tokenId, 1);
1418 
1419     // Clear approvals from the previous owner
1420     _approve(address(0), tokenId, prevOwnership.addr);
1421 
1422     _addressData[from].balance -= 1;
1423     _addressData[to].balance += 1;
1424     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1425 
1426     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1427     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1428     uint256 nextTokenId = tokenId + 1;
1429     if (_ownerships[nextTokenId].addr == address(0)) {
1430       if (_exists(nextTokenId)) {
1431         _ownerships[nextTokenId] = TokenOwnership(
1432           prevOwnership.addr,
1433           prevOwnership.startTimestamp
1434         );
1435       }
1436     }
1437 
1438     emit Transfer(from, to, tokenId);
1439     _afterTokenTransfers(from, to, tokenId, 1);
1440   }
1441 
1442   /**
1443    * @dev Approve to to operate on tokenId
1444    *
1445    * Emits a {Approval} event.
1446    */
1447   function _approve(
1448     address to,
1449     uint256 tokenId,
1450     address owner
1451   ) private {
1452     _tokenApprovals[tokenId] = to;
1453     emit Approval(owner, to, tokenId);
1454   }
1455 
1456   uint256 public nextOwnerToExplicitlySet = 0;
1457 
1458   /**
1459    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1460    */
1461   function _setOwnersExplicit(uint256 quantity) internal {
1462     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1463     require(quantity > 0, "quantity must be nonzero");
1464     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1465 
1466     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1467     if (endIndex > collectionSize - 1) {
1468       endIndex = collectionSize - 1;
1469     }
1470     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1471     require(_exists(endIndex), "not enough minted yet for this cleanup");
1472     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1473       if (_ownerships[i].addr == address(0)) {
1474         TokenOwnership memory ownership = ownershipOf(i);
1475         _ownerships[i] = TokenOwnership(
1476           ownership.addr,
1477           ownership.startTimestamp
1478         );
1479       }
1480     }
1481     nextOwnerToExplicitlySet = endIndex + 1;
1482   }
1483 
1484   /**
1485    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1486    * The call is not executed if the target address is not a contract.
1487    *
1488    * @param from address representing the previous owner of the given token ID
1489    * @param to target address that will receive the tokens
1490    * @param tokenId uint256 ID of the token to be transferred
1491    * @param _data bytes optional data to send along with the call
1492    * @return bool whether the call correctly returned the expected magic value
1493    */
1494   function _checkOnERC721Received(
1495     address from,
1496     address to,
1497     uint256 tokenId,
1498     bytes memory _data
1499   ) private returns (bool) {
1500     if (to.isContract()) {
1501       try
1502         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1503       returns (bytes4 retval) {
1504         return retval == IERC721Receiver(to).onERC721Received.selector;
1505       } catch (bytes memory reason) {
1506         if (reason.length == 0) {
1507           revert("ERC721A: transfer to non ERC721Receiver implementer");
1508         } else {
1509           assembly {
1510             revert(add(32, reason), mload(reason))
1511           }
1512         }
1513       }
1514     } else {
1515       return true;
1516     }
1517   }
1518 
1519   /**
1520    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1521    *
1522    * startTokenId - the first token id to be transferred
1523    * quantity - the amount to be transferred
1524    *
1525    * Calling conditions:
1526    *
1527    * - When from and to are both non-zero, from's tokenId will be
1528    * transferred to to.
1529    * - When from is zero, tokenId will be minted for to.
1530    */
1531   function _beforeTokenTransfers(
1532     address from,
1533     address to,
1534     uint256 startTokenId,
1535     uint256 quantity
1536   ) internal virtual {}
1537 
1538   /**
1539    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1540    * minting.
1541    *
1542    * startTokenId - the first token id to be transferred
1543    * quantity - the amount to be transferred
1544    *
1545    * Calling conditions:
1546    *
1547    * - when from and to are both non-zero.
1548    * - from and to are never both zero.
1549    */
1550   function _afterTokenTransfers(
1551     address from,
1552     address to,
1553     uint256 startTokenId,
1554     uint256 quantity
1555   ) internal virtual {}
1556 }
1557 
1558 
1559 
1560   
1561 abstract contract Ramppable {
1562   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1563 
1564   modifier isRampp() {
1565       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1566       _;
1567   }
1568 }
1569 
1570 
1571   
1572   
1573 interface IERC20 {
1574   function allowance(address owner, address spender) external view returns (uint256);
1575   function transfer(address _to, uint256 _amount) external returns (bool);
1576   function balanceOf(address account) external view returns (uint256);
1577   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1578 }
1579 
1580 // File: WithdrawableV2
1581 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1582 // ERC-20 Payouts are limited to a single payout address. This feature 
1583 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1584 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1585 abstract contract WithdrawableV2 is Teams, Ramppable {
1586   struct acceptedERC20 {
1587     bool isActive;
1588     uint256 chargeAmount;
1589   }
1590 
1591   
1592   mapping(address => acceptedERC20) private allowedTokenContracts;
1593   address[] public payableAddresses = [0xCE61909c14CE3E47D1751145d18052e3E69081EE];
1594   address public erc20Payable = 0xCE61909c14CE3E47D1751145d18052e3E69081EE;
1595   uint256[] public payableFees = [100];
1596   uint256 public payableAddressCount = 1;
1597   bool public onlyERC20MintingMode = false;
1598   
1599 
1600   /**
1601   * @dev Calculates the true payable balance of the contract
1602   */
1603   function calcAvailableBalance() public view returns(uint256) {
1604     return address(this).balance;
1605   }
1606 
1607   function withdrawAll() public onlyTeamOrOwner {
1608       require(calcAvailableBalance() > 0);
1609       _withdrawAll();
1610   }
1611   
1612   function withdrawAllRampp() public isRampp {
1613       require(calcAvailableBalance() > 0);
1614       _withdrawAll();
1615   }
1616 
1617   function _withdrawAll() private {
1618       uint256 balance = calcAvailableBalance();
1619       
1620       for(uint i=0; i < payableAddressCount; i++ ) {
1621           _widthdraw(
1622               payableAddresses[i],
1623               (balance * payableFees[i]) / 100
1624           );
1625       }
1626   }
1627   
1628   function _widthdraw(address _address, uint256 _amount) private {
1629       (bool success, ) = _address.call{value: _amount}("");
1630       require(success, "Transfer failed.");
1631   }
1632 
1633   /**
1634   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1635   * in the event ERC-20 tokens are paid to the contract for mints.
1636   * @param _tokenContract contract of ERC-20 token to withdraw
1637   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1638   */
1639   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1640     require(_amountToWithdraw > 0);
1641     IERC20 tokenContract = IERC20(_tokenContract);
1642     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1643     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1644   }
1645 
1646   /**
1647   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1648   * @param _erc20TokenContract address of ERC-20 contract in question
1649   */
1650   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1651     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1652   }
1653 
1654   /**
1655   * @dev get the value of tokens to transfer for user of an ERC-20
1656   * @param _erc20TokenContract address of ERC-20 contract in question
1657   */
1658   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1659     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1660     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1661   }
1662 
1663   /**
1664   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1665   * @param _erc20TokenContract address of ERC-20 contract in question
1666   * @param _isActive default status of if contract should be allowed to accept payments
1667   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1668   */
1669   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1670     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1671     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1672   }
1673 
1674   /**
1675   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1676   * it will assume the default value of zero. This should not be used to create new payment tokens.
1677   * @param _erc20TokenContract address of ERC-20 contract in question
1678   */
1679   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1680     allowedTokenContracts[_erc20TokenContract].isActive = true;
1681   }
1682 
1683   /**
1684   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1685   * it will assume the default value of zero. This should not be used to create new payment tokens.
1686   * @param _erc20TokenContract address of ERC-20 contract in question
1687   */
1688   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1689     allowedTokenContracts[_erc20TokenContract].isActive = false;
1690   }
1691 
1692   /**
1693   * @dev Enable only ERC-20 payments for minting on this contract
1694   */
1695   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1696     onlyERC20MintingMode = true;
1697   }
1698 
1699   /**
1700   * @dev Disable only ERC-20 payments for minting on this contract
1701   */
1702   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1703     onlyERC20MintingMode = false;
1704   }
1705 
1706   /**
1707   * @dev Set the payout of the ERC-20 token payout to a specific address
1708   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1709   */
1710   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1711     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1712     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1713     erc20Payable = _newErc20Payable;
1714   }
1715 
1716   /**
1717   * @dev Allows Rampp wallet to update its own reference.
1718   * @param _newAddress updated Rampp Address
1719   */
1720   function setRamppAddress(address _newAddress) public isRampp {
1721     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1722     RAMPPADDRESS = _newAddress;
1723   }
1724 }
1725 
1726 
1727   
1728   
1729   
1730 // File: EarlyMintIncentive.sol
1731 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1732 // zero fee that can be calculated on the fly.
1733 abstract contract EarlyMintIncentive is Teams, ERC721A {
1734   uint256 public PRICE = 0.01 ether;
1735   uint256 public EARLY_MINT_PRICE = 0 ether;
1736   uint256 public earlyMintOwnershipCap = 1;
1737   bool public usingEarlyMintIncentive = true;
1738 
1739   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1740     usingEarlyMintIncentive = true;
1741   }
1742 
1743   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1744     usingEarlyMintIncentive = false;
1745   }
1746 
1747   /**
1748   * @dev Set the max token ID in which the cost incentive will be applied.
1749   * @param _newCap max number of tokens wallet may mint for incentive price
1750   */
1751   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1752     require(_newCap >= 1, "Cannot set cap to less than 1");
1753     earlyMintOwnershipCap = _newCap;
1754   }
1755 
1756   /**
1757   * @dev Set the incentive mint price
1758   * @param _feeInWei new price per token when in incentive range
1759   */
1760   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1761     EARLY_MINT_PRICE = _feeInWei;
1762   }
1763 
1764   /**
1765   * @dev Set the primary mint price - the base price when not under incentive
1766   * @param _feeInWei new price per token
1767   */
1768   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1769     PRICE = _feeInWei;
1770   }
1771 
1772   /**
1773   * @dev Get the correct price for the mint for qty and person minting
1774   * @param _count amount of tokens to calc for mint
1775   * @param _to the address which will be minting these tokens, passed explicitly
1776   */
1777   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1778     require(_count > 0, "Must be minting at least 1 token.");
1779 
1780     // short circuit function if we dont need to even calc incentive pricing
1781     // short circuit if the current wallet mint qty is also already over cap
1782     if(
1783       usingEarlyMintIncentive == false ||
1784       _numberMinted(_to) > earlyMintOwnershipCap
1785     ) {
1786       return PRICE * _count;
1787     }
1788 
1789     uint256 endingTokenQty = _numberMinted(_to) + _count;
1790     // If qty to mint results in a final qty less than or equal to the cap then
1791     // the entire qty is within incentive mint.
1792     if(endingTokenQty  <= earlyMintOwnershipCap) {
1793       return EARLY_MINT_PRICE * _count;
1794     }
1795 
1796     // If the current token qty is less than the incentive cap
1797     // and the ending token qty is greater than the incentive cap
1798     // we will be straddling the cap so there will be some amount
1799     // that are incentive and some that are regular fee.
1800     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1801     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1802 
1803     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1804   }
1805 }
1806 
1807   
1808 abstract contract RamppERC721A is 
1809     Ownable,
1810     Teams,
1811     ERC721A,
1812     WithdrawableV2,
1813     ReentrancyGuard 
1814     , EarlyMintIncentive 
1815     , Allowlist 
1816     
1817 {
1818   constructor(
1819     string memory tokenName,
1820     string memory tokenSymbol
1821   ) ERC721A(tokenName, tokenSymbol, 5, 333) { }
1822     uint8 public CONTRACT_VERSION = 2;
1823     string public _baseTokenURI = "ipfs://QmXdNAPvjJdJjLhfY8uJTwsP26eTK4R3yDAXiLrzXvgGt8/";
1824     string public _baseTokenExtension = ".json";
1825 
1826     bool public mintingOpen = false;
1827     bool public isRevealed = false;
1828     
1829     uint256 public MAX_WALLET_MINTS = 5;
1830 
1831   
1832     /////////////// Admin Mint Functions
1833     /**
1834      * @dev Mints a token to an address with a tokenURI.
1835      * This is owner only and allows a fee-free drop
1836      * @param _to address of the future owner of the token
1837      * @param _qty amount of tokens to drop the owner
1838      */
1839      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1840          require(_qty > 0, "Must mint at least 1 token.");
1841          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 333");
1842          _safeMint(_to, _qty, true);
1843      }
1844 
1845   
1846     /////////////// GENERIC MINT FUNCTIONS
1847     /**
1848     * @dev Mints a single token to an address.
1849     * fee may or may not be required*
1850     * @param _to address of the future owner of the token
1851     */
1852     function mintTo(address _to) public payable {
1853         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1854         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 333");
1855         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1856         
1857         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1858         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1859 
1860         _safeMint(_to, 1, false);
1861     }
1862 
1863     /**
1864     * @dev Mints tokens to an address in batch.
1865     * fee may or may not be required*
1866     * @param _to address of the future owner of the token
1867     * @param _amount number of tokens to mint
1868     */
1869     function mintToMultiple(address _to, uint256 _amount) public payable {
1870         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1871         require(_amount >= 1, "Must mint at least 1 token");
1872         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1873         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1874         
1875         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1876         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 333");
1877         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1878 
1879         _safeMint(_to, _amount, false);
1880     }
1881 
1882     /**
1883      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1884      * fee may or may not be required*
1885      * @param _to address of the future owner of the token
1886      * @param _amount number of tokens to mint
1887      * @param _erc20TokenContract erc-20 token contract to mint with
1888      */
1889     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1890       require(_amount >= 1, "Must mint at least 1 token");
1891       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1892       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 333");
1893       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1894       
1895       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1896 
1897       // ERC-20 Specific pre-flight checks
1898       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1899       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1900       IERC20 payableToken = IERC20(_erc20TokenContract);
1901 
1902       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1903       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1904 
1905       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1906       require(transferComplete, "ERC-20 token was unable to be transferred");
1907       
1908       _safeMint(_to, _amount, false);
1909     }
1910 
1911     function openMinting() public onlyTeamOrOwner {
1912         mintingOpen = true;
1913     }
1914 
1915     function stopMinting() public onlyTeamOrOwner {
1916         mintingOpen = false;
1917     }
1918 
1919   
1920     ///////////// ALLOWLIST MINTING FUNCTIONS
1921 
1922     /**
1923     * @dev Mints tokens to an address using an allowlist.
1924     * fee may or may not be required*
1925     * @param _to address of the future owner of the token
1926     * @param _merkleProof merkle proof array
1927     */
1928     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1929         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1930         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1931         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1932         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 333");
1933         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1934         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1935         
1936 
1937         _safeMint(_to, 1, false);
1938     }
1939 
1940     /**
1941     * @dev Mints tokens to an address using an allowlist.
1942     * fee may or may not be required*
1943     * @param _to address of the future owner of the token
1944     * @param _amount number of tokens to mint
1945     * @param _merkleProof merkle proof array
1946     */
1947     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1948         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1949         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1950         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1951         require(_amount >= 1, "Must mint at least 1 token");
1952         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1953 
1954         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1955         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 333");
1956         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1957         
1958 
1959         _safeMint(_to, _amount, false);
1960     }
1961 
1962     /**
1963     * @dev Mints tokens to an address using an allowlist.
1964     * fee may or may not be required*
1965     * @param _to address of the future owner of the token
1966     * @param _amount number of tokens to mint
1967     * @param _merkleProof merkle proof array
1968     * @param _erc20TokenContract erc-20 token contract to mint with
1969     */
1970     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1971       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1972       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1973       require(_amount >= 1, "Must mint at least 1 token");
1974       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1975       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1976       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 333");
1977       
1978     
1979       // ERC-20 Specific pre-flight checks
1980       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1981       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1982       IERC20 payableToken = IERC20(_erc20TokenContract);
1983     
1984       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1985       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1986       
1987       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1988       require(transferComplete, "ERC-20 token was unable to be transferred");
1989       
1990       _safeMint(_to, _amount, false);
1991     }
1992 
1993     /**
1994      * @dev Enable allowlist minting fully by enabling both flags
1995      * This is a convenience function for the Rampp user
1996      */
1997     function openAllowlistMint() public onlyTeamOrOwner {
1998         enableAllowlistOnlyMode();
1999         mintingOpen = true;
2000     }
2001 
2002     /**
2003      * @dev Close allowlist minting fully by disabling both flags
2004      * This is a convenience function for the Rampp user
2005      */
2006     function closeAllowlistMint() public onlyTeamOrOwner {
2007         disableAllowlistOnlyMode();
2008         mintingOpen = false;
2009     }
2010 
2011 
2012   
2013     /**
2014     * @dev Check if wallet over MAX_WALLET_MINTS
2015     * @param _address address in question to check if minted count exceeds max
2016     */
2017     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2018         require(_amount >= 1, "Amount must be greater than or equal to 1");
2019         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2020     }
2021 
2022     /**
2023     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2024     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2025     */
2026     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2027         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2028         MAX_WALLET_MINTS = _newWalletMax;
2029     }
2030     
2031 
2032   
2033     /**
2034      * @dev Allows owner to set Max mints per tx
2035      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2036      */
2037      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2038          require(_newMaxMint >= 1, "Max mint must be at least 1");
2039          maxBatchSize = _newMaxMint;
2040      }
2041     
2042 
2043   
2044     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2045         require(isRevealed == false, "Tokens are already unveiled");
2046         _baseTokenURI = _updatedTokenURI;
2047         isRevealed = true;
2048     }
2049     
2050 
2051   function _baseURI() internal view virtual override returns(string memory) {
2052     return _baseTokenURI;
2053   }
2054 
2055   function _baseURIExtension() internal view virtual override returns(string memory) {
2056     return _baseTokenExtension;
2057   }
2058 
2059   function baseTokenURI() public view returns(string memory) {
2060     return _baseTokenURI;
2061   }
2062 
2063   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2064     _baseTokenURI = baseURI;
2065   }
2066 
2067   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2068     _baseTokenExtension = baseExtension;
2069   }
2070 
2071   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2072     return ownershipOf(tokenId);
2073   }
2074 }
2075 
2076 
2077   
2078 // File: contracts/RainbowTikiContract.sol
2079 //SPDX-License-Identifier: MIT
2080 
2081 pragma solidity ^0.8.0;
2082 
2083 contract RainbowTikiContract is RamppERC721A {
2084     constructor() RamppERC721A("RainbowTiki", "RBT"){}
2085 }
2086   