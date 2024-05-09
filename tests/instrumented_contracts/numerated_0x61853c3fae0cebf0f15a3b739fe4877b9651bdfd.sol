1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     ______     __   ___    __      _____  ___       ______    
5 //    /    " \   |/"| /  ")  |" \    (\"   \|"  \     /    " \   
6 //   // ____  \  (: |/   /   ||  |   |.\\   \    |   // ____  \  
7 //  /  /    ) :) |    __/    |:  |   |: \.   \\  |  /  /    ) :) 
8 // (: (____/ //  (// _  \    |.  |   |.  \    \. | (: (____/ //  
9 //  \        /   |: | \  \   /\  |\  |    \    \ |  \        /   
10 //   \"_____/    (__|  \__) (__\_|_)  \___|\____\)   \"_____/    
11 //                                                               
12 //
13 //*********************************************************************//
14 //*********************************************************************//
15   
16 //-------------DEPENDENCIES--------------------------//
17 
18 // File: @openzeppelin/contracts/utils/Address.sol
19 
20 
21 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
22 
23 pragma solidity ^0.8.1;
24 
25 /**
26  * @dev Collection of functions related to the address type
27  */
28 library Address {
29     /**
30      * @dev Returns true if account is a contract.
31      *
32      * [IMPORTANT]
33      * ====
34      * It is unsafe to assume that an address for which this function returns
35      * false is an externally-owned account (EOA) and not a contract.
36      *
37      * Among others, isContract will return false for the following
38      * types of addresses:
39      *
40      *  - an externally-owned account
41      *  - a contract in construction
42      *  - an address where a contract will be created
43      *  - an address where a contract lived, but was destroyed
44      * ====
45      *
46      * [IMPORTANT]
47      * ====
48      * You shouldn't rely on isContract to protect against flash loan attacks!
49      *
50      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
51      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
52      * constructor.
53      * ====
54      */
55     function isContract(address account) internal view returns (bool) {
56         // This method relies on extcodesize/address.code.length, which returns 0
57         // for contracts in construction, since the code is only stored at the end
58         // of the constructor execution.
59 
60         return account.code.length > 0;
61     }
62 
63     /**
64      * @dev Replacement for Solidity's transfer: sends amount wei to
65      * recipient, forwarding all available gas and reverting on errors.
66      *
67      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
68      * of certain opcodes, possibly making contracts go over the 2300 gas limit
69      * imposed by transfer, making them unable to receive funds via
70      * transfer. {sendValue} removes this limitation.
71      *
72      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
73      *
74      * IMPORTANT: because control is transferred to recipient, care must be
75      * taken to not create reentrancy vulnerabilities. Consider using
76      * {ReentrancyGuard} or the
77      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
78      */
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         (bool success, ) = recipient.call{value: amount}("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     /**
87      * @dev Performs a Solidity function call using a low level call. A
88      * plain call is an unsafe replacement for a function call: use this
89      * function instead.
90      *
91      * If target reverts with a revert reason, it is bubbled up by this
92      * function (like regular Solidity function calls).
93      *
94      * Returns the raw returned data. To convert to the expected return value,
95      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
96      *
97      * Requirements:
98      *
99      * - target must be a contract.
100      * - calling target with data must not revert.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
110      * errorMessage as a fallback revert reason when target reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(
115         address target,
116         bytes memory data,
117         string memory errorMessage
118     ) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
124      * but also transferring value wei to target.
125      *
126      * Requirements:
127      *
128      * - the calling contract must have an ETH balance of at least value.
129      * - the called Solidity function must be payable.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value
137     ) internal returns (bytes memory) {
138         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
143      * with errorMessage as a fallback revert reason when target reverts.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value,
151         string memory errorMessage
152     ) internal returns (bytes memory) {
153         require(address(this).balance >= value, "Address: insufficient balance for call");
154         require(isContract(target), "Address: call to non-contract");
155 
156         (bool success, bytes memory returndata) = target.call{value: value}(data);
157         return verifyCallResult(success, returndata, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
162      * but performing a static call.
163      *
164      * _Available since v3.3._
165      */
166     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
167         return functionStaticCall(target, data, "Address: low-level static call failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
172      * but performing a static call.
173      *
174      * _Available since v3.3._
175      */
176     function functionStaticCall(
177         address target,
178         bytes memory data,
179         string memory errorMessage
180     ) internal view returns (bytes memory) {
181         require(isContract(target), "Address: static call to non-contract");
182 
183         (bool success, bytes memory returndata) = target.staticcall(data);
184         return verifyCallResult(success, returndata, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
189      * but performing a delegate call.
190      *
191      * _Available since v3.4._
192      */
193     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
194         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(isContract(target), "Address: delegate call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.delegatecall(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
216      * revert reason using the provided one.
217      *
218      * _Available since v4.3._
219      */
220     function verifyCallResult(
221         bool success,
222         bytes memory returndata,
223         string memory errorMessage
224     ) internal pure returns (bytes memory) {
225         if (success) {
226             return returndata;
227         } else {
228             // Look for revert reason and bubble it up if present
229             if (returndata.length > 0) {
230                 // The easiest way to bubble the revert reason is using memory via assembly
231 
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @title ERC721 token receiver interface
252  * @dev Interface for any contract that wants to support safeTransfers
253  * from ERC721 asset contracts.
254  */
255 interface IERC721Receiver {
256     /**
257      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
258      * by operator from from, this function is called.
259      *
260      * It must return its Solidity selector to confirm the token transfer.
261      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
262      *
263      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
264      */
265     function onERC721Received(
266         address operator,
267         address from,
268         uint256 tokenId,
269         bytes calldata data
270     ) external returns (bytes4);
271 }
272 
273 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
274 
275 
276 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
277 
278 pragma solidity ^0.8.0;
279 
280 /**
281  * @dev Interface of the ERC165 standard, as defined in the
282  * https://eips.ethereum.org/EIPS/eip-165[EIP].
283  *
284  * Implementers can declare support of contract interfaces, which can then be
285  * queried by others ({ERC165Checker}).
286  *
287  * For an implementation, see {ERC165}.
288  */
289 interface IERC165 {
290     /**
291      * @dev Returns true if this contract implements the interface defined by
292      * interfaceId. See the corresponding
293      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
294      * to learn more about how these ids are created.
295      *
296      * This function call must use less than 30 000 gas.
297      */
298     function supportsInterface(bytes4 interfaceId) external view returns (bool);
299 }
300 
301 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
302 
303 
304 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 /**
310  * @dev Implementation of the {IERC165} interface.
311  *
312  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
313  * for the additional interface id that will be supported. For example:
314  *
315  * solidity
316  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
317  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
318  * }
319  * 
320  *
321  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
322  */
323 abstract contract ERC165 is IERC165 {
324     /**
325      * @dev See {IERC165-supportsInterface}.
326      */
327     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
328         return interfaceId == type(IERC165).interfaceId;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
333 
334 
335 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
336 
337 pragma solidity ^0.8.0;
338 
339 
340 /**
341  * @dev Required interface of an ERC721 compliant contract.
342  */
343 interface IERC721 is IERC165 {
344     /**
345      * @dev Emitted when tokenId token is transferred from from to to.
346      */
347     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
348 
349     /**
350      * @dev Emitted when owner enables approved to manage the tokenId token.
351      */
352     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
353 
354     /**
355      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
356      */
357     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
358 
359     /**
360      * @dev Returns the number of tokens in owner's account.
361      */
362     function balanceOf(address owner) external view returns (uint256 balance);
363 
364     /**
365      * @dev Returns the owner of the tokenId token.
366      *
367      * Requirements:
368      *
369      * - tokenId must exist.
370      */
371     function ownerOf(uint256 tokenId) external view returns (address owner);
372 
373     /**
374      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
375      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
376      *
377      * Requirements:
378      *
379      * - from cannot be the zero address.
380      * - to cannot be the zero address.
381      * - tokenId token must exist and be owned by from.
382      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
383      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
384      *
385      * Emits a {Transfer} event.
386      */
387     function safeTransferFrom(
388         address from,
389         address to,
390         uint256 tokenId
391     ) external;
392 
393     /**
394      * @dev Transfers tokenId token from from to to.
395      *
396      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
397      *
398      * Requirements:
399      *
400      * - from cannot be the zero address.
401      * - to cannot be the zero address.
402      * - tokenId token must be owned by from.
403      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
404      *
405      * Emits a {Transfer} event.
406      */
407     function transferFrom(
408         address from,
409         address to,
410         uint256 tokenId
411     ) external;
412 
413     /**
414      * @dev Gives permission to to to transfer tokenId token to another account.
415      * The approval is cleared when the token is transferred.
416      *
417      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
418      *
419      * Requirements:
420      *
421      * - The caller must own the token or be an approved operator.
422      * - tokenId must exist.
423      *
424      * Emits an {Approval} event.
425      */
426     function approve(address to, uint256 tokenId) external;
427 
428     /**
429      * @dev Returns the account approved for tokenId token.
430      *
431      * Requirements:
432      *
433      * - tokenId must exist.
434      */
435     function getApproved(uint256 tokenId) external view returns (address operator);
436 
437     /**
438      * @dev Approve or remove operator as an operator for the caller.
439      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
440      *
441      * Requirements:
442      *
443      * - The operator cannot be the caller.
444      *
445      * Emits an {ApprovalForAll} event.
446      */
447     function setApprovalForAll(address operator, bool _approved) external;
448 
449     /**
450      * @dev Returns if the operator is allowed to manage all of the assets of owner.
451      *
452      * See {setApprovalForAll}
453      */
454     function isApprovedForAll(address owner, address operator) external view returns (bool);
455 
456     /**
457      * @dev Safely transfers tokenId token from from to to.
458      *
459      * Requirements:
460      *
461      * - from cannot be the zero address.
462      * - to cannot be the zero address.
463      * - tokenId token must exist and be owned by from.
464      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
465      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
466      *
467      * Emits a {Transfer} event.
468      */
469     function safeTransferFrom(
470         address from,
471         address to,
472         uint256 tokenId,
473         bytes calldata data
474     ) external;
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
487  * @dev See https://eips.ethereum.org/EIPS/eip-721
488  */
489 interface IERC721Enumerable is IERC721 {
490     /**
491      * @dev Returns the total amount of tokens stored by the contract.
492      */
493     function totalSupply() external view returns (uint256);
494 
495     /**
496      * @dev Returns a token ID owned by owner at a given index of its token list.
497      * Use along with {balanceOf} to enumerate all of owner's tokens.
498      */
499     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
500 
501     /**
502      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
503      * Use along with {totalSupply} to enumerate all tokens.
504      */
505     function tokenByIndex(uint256 index) external view returns (uint256);
506 }
507 
508 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
518  * @dev See https://eips.ethereum.org/EIPS/eip-721
519  */
520 interface IERC721Metadata is IERC721 {
521     /**
522      * @dev Returns the token collection name.
523      */
524     function name() external view returns (string memory);
525 
526     /**
527      * @dev Returns the token collection symbol.
528      */
529     function symbol() external view returns (string memory);
530 
531     /**
532      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
533      */
534     function tokenURI(uint256 tokenId) external view returns (string memory);
535 }
536 
537 // File: @openzeppelin/contracts/utils/Strings.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @dev String operations.
546  */
547 library Strings {
548     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
549 
550     /**
551      * @dev Converts a uint256 to its ASCII string decimal representation.
552      */
553     function toString(uint256 value) internal pure returns (string memory) {
554         // Inspired by OraclizeAPI's implementation - MIT licence
555         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
556 
557         if (value == 0) {
558             return "0";
559         }
560         uint256 temp = value;
561         uint256 digits;
562         while (temp != 0) {
563             digits++;
564             temp /= 10;
565         }
566         bytes memory buffer = new bytes(digits);
567         while (value != 0) {
568             digits -= 1;
569             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
570             value /= 10;
571         }
572         return string(buffer);
573     }
574 
575     /**
576      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
577      */
578     function toHexString(uint256 value) internal pure returns (string memory) {
579         if (value == 0) {
580             return "0x00";
581         }
582         uint256 temp = value;
583         uint256 length = 0;
584         while (temp != 0) {
585             length++;
586             temp >>= 8;
587         }
588         return toHexString(value, length);
589     }
590 
591     /**
592      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
593      */
594     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
595         bytes memory buffer = new bytes(2 * length + 2);
596         buffer[0] = "0";
597         buffer[1] = "x";
598         for (uint256 i = 2 * length + 1; i > 1; --i) {
599             buffer[i] = _HEX_SYMBOLS[value & 0xf];
600             value >>= 4;
601         }
602         require(value == 0, "Strings: hex length insufficient");
603         return string(buffer);
604     }
605 }
606 
607 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Contract module that helps prevent reentrant calls to a function.
616  *
617  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
618  * available, which can be applied to functions to make sure there are no nested
619  * (reentrant) calls to them.
620  *
621  * Note that because there is a single nonReentrant guard, functions marked as
622  * nonReentrant may not call one another. This can be worked around by making
623  * those functions private, and then adding external nonReentrant entry
624  * points to them.
625  *
626  * TIP: If you would like to learn more about reentrancy and alternative ways
627  * to protect against it, check out our blog post
628  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
629  */
630 abstract contract ReentrancyGuard {
631     // Booleans are more expensive than uint256 or any type that takes up a full
632     // word because each write operation emits an extra SLOAD to first read the
633     // slot's contents, replace the bits taken up by the boolean, and then write
634     // back. This is the compiler's defense against contract upgrades and
635     // pointer aliasing, and it cannot be disabled.
636 
637     // The values being non-zero value makes deployment a bit more expensive,
638     // but in exchange the refund on every call to nonReentrant will be lower in
639     // amount. Since refunds are capped to a percentage of the total
640     // transaction's gas, it is best to keep them low in cases like this one, to
641     // increase the likelihood of the full refund coming into effect.
642     uint256 private constant _NOT_ENTERED = 1;
643     uint256 private constant _ENTERED = 2;
644 
645     uint256 private _status;
646 
647     constructor() {
648         _status = _NOT_ENTERED;
649     }
650 
651     /**
652      * @dev Prevents a contract from calling itself, directly or indirectly.
653      * Calling a nonReentrant function from another nonReentrant
654      * function is not supported. It is possible to prevent this from happening
655      * by making the nonReentrant function external, and making it call a
656      * private function that does the actual work.
657      */
658     modifier nonReentrant() {
659         // On the first call to nonReentrant, _notEntered will be true
660         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
661 
662         // Any calls to nonReentrant after this point will fail
663         _status = _ENTERED;
664 
665         _;
666 
667         // By storing the original value once again, a refund is triggered (see
668         // https://eips.ethereum.org/EIPS/eip-2200)
669         _status = _NOT_ENTERED;
670     }
671 }
672 
673 // File: @openzeppelin/contracts/utils/Context.sol
674 
675 
676 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
677 
678 pragma solidity ^0.8.0;
679 
680 /**
681  * @dev Provides information about the current execution context, including the
682  * sender of the transaction and its data. While these are generally available
683  * via msg.sender and msg.data, they should not be accessed in such a direct
684  * manner, since when dealing with meta-transactions the account sending and
685  * paying for execution may not be the actual sender (as far as an application
686  * is concerned).
687  *
688  * This contract is only required for intermediate, library-like contracts.
689  */
690 abstract contract Context {
691     function _msgSender() internal view virtual returns (address) {
692         return msg.sender;
693     }
694 
695     function _msgData() internal view virtual returns (bytes calldata) {
696         return msg.data;
697     }
698 }
699 
700 // File: @openzeppelin/contracts/access/Ownable.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @dev Contract module which provides a basic access control mechanism, where
710  * there is an account (an owner) that can be granted exclusive access to
711  * specific functions.
712  *
713  * By default, the owner account will be the one that deploys the contract. This
714  * can later be changed with {transferOwnership}.
715  *
716  * This module is used through inheritance. It will make available the modifier
717  * onlyOwner, which can be applied to your functions to restrict their use to
718  * the owner.
719  */
720 abstract contract Ownable is Context {
721     address private _owner;
722 
723     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
724 
725     /**
726      * @dev Initializes the contract setting the deployer as the initial owner.
727      */
728     constructor() {
729         _transferOwnership(_msgSender());
730     }
731 
732     /**
733      * @dev Returns the address of the current owner.
734      */
735     function owner() public view virtual returns (address) {
736         return _owner;
737     }
738 
739     /**
740      * @dev Throws if called by any account other than the owner.
741      */
742     modifier onlyOwner() {
743         require(owner() == _msgSender(), "Ownable: caller is not the owner");
744         _;
745     }
746 
747     /**
748      * @dev Leaves the contract without owner. It will not be possible to call
749      * onlyOwner functions anymore. Can only be called by the current owner.
750      *
751      * NOTE: Renouncing ownership will leave the contract without an owner,
752      * thereby removing any functionality that is only available to the owner.
753      */
754     function renounceOwnership() public virtual onlyOwner {
755         _transferOwnership(address(0));
756     }
757 
758     /**
759      * @dev Transfers ownership of the contract to a new account (newOwner).
760      * Can only be called by the current owner.
761      */
762     function transferOwnership(address newOwner) public virtual onlyOwner {
763         require(newOwner != address(0), "Ownable: new owner is the zero address");
764         _transferOwnership(newOwner);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (newOwner).
769      * Internal function without access restriction.
770      */
771     function _transferOwnership(address newOwner) internal virtual {
772         address oldOwner = _owner;
773         _owner = newOwner;
774         emit OwnershipTransferred(oldOwner, newOwner);
775     }
776 }
777 //-------------END DEPENDENCIES------------------------//
778 
779 
780   
781 // Rampp Contracts v2.1 (Teams.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 /**
786 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
787 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
788 * This will easily allow cross-collaboration via Rampp.xyz.
789 **/
790 abstract contract Teams is Ownable{
791   mapping (address => bool) internal team;
792 
793   /**
794   * @dev Adds an address to the team. Allows them to execute protected functions
795   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
796   **/
797   function addToTeam(address _address) public onlyOwner {
798     require(_address != address(0), "Invalid address");
799     require(!inTeam(_address), "This address is already in your team.");
800   
801     team[_address] = true;
802   }
803 
804   /**
805   * @dev Removes an address to the team.
806   * @param _address the ETH address to remove, cannot be 0x and must be in team
807   **/
808   function removeFromTeam(address _address) public onlyOwner {
809     require(_address != address(0), "Invalid address");
810     require(inTeam(_address), "This address is not in your team currently.");
811   
812     team[_address] = false;
813   }
814 
815   /**
816   * @dev Check if an address is valid and active in the team
817   * @param _address ETH address to check for truthiness
818   **/
819   function inTeam(address _address)
820     public
821     view
822     returns (bool)
823   {
824     require(_address != address(0), "Invalid address to check.");
825     return team[_address] == true;
826   }
827 
828   /**
829   * @dev Throws if called by any account other than the owner or team member.
830   */
831   modifier onlyTeamOrOwner() {
832     bool _isOwner = owner() == _msgSender();
833     bool _isTeam = inTeam(_msgSender());
834     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
835     _;
836   }
837 }
838 
839 
840   
841   
842 /**
843  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
844  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
845  *
846  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
847  * 
848  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
849  *
850  * Does not support burning tokens to address(0).
851  */
852 contract ERC721A is
853   Context,
854   ERC165,
855   IERC721,
856   IERC721Metadata,
857   IERC721Enumerable
858 {
859   using Address for address;
860   using Strings for uint256;
861 
862   struct TokenOwnership {
863     address addr;
864     uint64 startTimestamp;
865   }
866 
867   struct AddressData {
868     uint128 balance;
869     uint128 numberMinted;
870   }
871 
872   uint256 private currentIndex;
873 
874   uint256 public immutable collectionSize;
875   uint256 public maxBatchSize;
876 
877   // Token name
878   string private _name;
879 
880   // Token symbol
881   string private _symbol;
882 
883   // Mapping from token ID to ownership details
884   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
885   mapping(uint256 => TokenOwnership) private _ownerships;
886 
887   // Mapping owner address to address data
888   mapping(address => AddressData) private _addressData;
889 
890   // Mapping from token ID to approved address
891   mapping(uint256 => address) private _tokenApprovals;
892 
893   // Mapping from owner to operator approvals
894   mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896   /**
897    * @dev
898    * maxBatchSize refers to how much a minter can mint at a time.
899    * collectionSize_ refers to how many tokens are in the collection.
900    */
901   constructor(
902     string memory name_,
903     string memory symbol_,
904     uint256 maxBatchSize_,
905     uint256 collectionSize_
906   ) {
907     require(
908       collectionSize_ > 0,
909       "ERC721A: collection must have a nonzero supply"
910     );
911     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
912     _name = name_;
913     _symbol = symbol_;
914     maxBatchSize = maxBatchSize_;
915     collectionSize = collectionSize_;
916     currentIndex = _startTokenId();
917   }
918 
919   /**
920   * To change the starting tokenId, please override this function.
921   */
922   function _startTokenId() internal view virtual returns (uint256) {
923     return 1;
924   }
925 
926   /**
927    * @dev See {IERC721Enumerable-totalSupply}.
928    */
929   function totalSupply() public view override returns (uint256) {
930     return _totalMinted();
931   }
932 
933   function currentTokenId() public view returns (uint256) {
934     return _totalMinted();
935   }
936 
937   function getNextTokenId() public view returns (uint256) {
938       return _totalMinted() + 1;
939   }
940 
941   /**
942   * Returns the total amount of tokens minted in the contract.
943   */
944   function _totalMinted() internal view returns (uint256) {
945     unchecked {
946       return currentIndex - _startTokenId();
947     }
948   }
949 
950   /**
951    * @dev See {IERC721Enumerable-tokenByIndex}.
952    */
953   function tokenByIndex(uint256 index) public view override returns (uint256) {
954     require(index < totalSupply(), "ERC721A: global index out of bounds");
955     return index;
956   }
957 
958   /**
959    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
960    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
961    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
962    */
963   function tokenOfOwnerByIndex(address owner, uint256 index)
964     public
965     view
966     override
967     returns (uint256)
968   {
969     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
970     uint256 numMintedSoFar = totalSupply();
971     uint256 tokenIdsIdx = 0;
972     address currOwnershipAddr = address(0);
973     for (uint256 i = 0; i < numMintedSoFar; i++) {
974       TokenOwnership memory ownership = _ownerships[i];
975       if (ownership.addr != address(0)) {
976         currOwnershipAddr = ownership.addr;
977       }
978       if (currOwnershipAddr == owner) {
979         if (tokenIdsIdx == index) {
980           return i;
981         }
982         tokenIdsIdx++;
983       }
984     }
985     revert("ERC721A: unable to get token of owner by index");
986   }
987 
988   /**
989    * @dev See {IERC165-supportsInterface}.
990    */
991   function supportsInterface(bytes4 interfaceId)
992     public
993     view
994     virtual
995     override(ERC165, IERC165)
996     returns (bool)
997   {
998     return
999       interfaceId == type(IERC721).interfaceId ||
1000       interfaceId == type(IERC721Metadata).interfaceId ||
1001       interfaceId == type(IERC721Enumerable).interfaceId ||
1002       super.supportsInterface(interfaceId);
1003   }
1004 
1005   /**
1006    * @dev See {IERC721-balanceOf}.
1007    */
1008   function balanceOf(address owner) public view override returns (uint256) {
1009     require(owner != address(0), "ERC721A: balance query for the zero address");
1010     return uint256(_addressData[owner].balance);
1011   }
1012 
1013   function _numberMinted(address owner) internal view returns (uint256) {
1014     require(
1015       owner != address(0),
1016       "ERC721A: number minted query for the zero address"
1017     );
1018     return uint256(_addressData[owner].numberMinted);
1019   }
1020 
1021   function ownershipOf(uint256 tokenId)
1022     internal
1023     view
1024     returns (TokenOwnership memory)
1025   {
1026     uint256 curr = tokenId;
1027 
1028     unchecked {
1029         if (_startTokenId() <= curr && curr < currentIndex) {
1030             TokenOwnership memory ownership = _ownerships[curr];
1031             if (ownership.addr != address(0)) {
1032                 return ownership;
1033             }
1034 
1035             // Invariant:
1036             // There will always be an ownership that has an address and is not burned
1037             // before an ownership that does not have an address and is not burned.
1038             // Hence, curr will not underflow.
1039             while (true) {
1040                 curr--;
1041                 ownership = _ownerships[curr];
1042                 if (ownership.addr != address(0)) {
1043                     return ownership;
1044                 }
1045             }
1046         }
1047     }
1048 
1049     revert("ERC721A: unable to determine the owner of token");
1050   }
1051 
1052   /**
1053    * @dev See {IERC721-ownerOf}.
1054    */
1055   function ownerOf(uint256 tokenId) public view override returns (address) {
1056     return ownershipOf(tokenId).addr;
1057   }
1058 
1059   /**
1060    * @dev See {IERC721Metadata-name}.
1061    */
1062   function name() public view virtual override returns (string memory) {
1063     return _name;
1064   }
1065 
1066   /**
1067    * @dev See {IERC721Metadata-symbol}.
1068    */
1069   function symbol() public view virtual override returns (string memory) {
1070     return _symbol;
1071   }
1072 
1073   /**
1074    * @dev See {IERC721Metadata-tokenURI}.
1075    */
1076   function tokenURI(uint256 tokenId)
1077     public
1078     view
1079     virtual
1080     override
1081     returns (string memory)
1082   {
1083     string memory baseURI = _baseURI();
1084     return
1085       bytes(baseURI).length > 0
1086         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1087         : "";
1088   }
1089 
1090   /**
1091    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1092    * token will be the concatenation of the baseURI and the tokenId. Empty
1093    * by default, can be overriden in child contracts.
1094    */
1095   function _baseURI() internal view virtual returns (string memory) {
1096     return "";
1097   }
1098 
1099   /**
1100    * @dev See {IERC721-approve}.
1101    */
1102   function approve(address to, uint256 tokenId) public override {
1103     address owner = ERC721A.ownerOf(tokenId);
1104     require(to != owner, "ERC721A: approval to current owner");
1105 
1106     require(
1107       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1108       "ERC721A: approve caller is not owner nor approved for all"
1109     );
1110 
1111     _approve(to, tokenId, owner);
1112   }
1113 
1114   /**
1115    * @dev See {IERC721-getApproved}.
1116    */
1117   function getApproved(uint256 tokenId) public view override returns (address) {
1118     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1119 
1120     return _tokenApprovals[tokenId];
1121   }
1122 
1123   /**
1124    * @dev See {IERC721-setApprovalForAll}.
1125    */
1126   function setApprovalForAll(address operator, bool approved) public override {
1127     require(operator != _msgSender(), "ERC721A: approve to caller");
1128 
1129     _operatorApprovals[_msgSender()][operator] = approved;
1130     emit ApprovalForAll(_msgSender(), operator, approved);
1131   }
1132 
1133   /**
1134    * @dev See {IERC721-isApprovedForAll}.
1135    */
1136   function isApprovedForAll(address owner, address operator)
1137     public
1138     view
1139     virtual
1140     override
1141     returns (bool)
1142   {
1143     return _operatorApprovals[owner][operator];
1144   }
1145 
1146   /**
1147    * @dev See {IERC721-transferFrom}.
1148    */
1149   function transferFrom(
1150     address from,
1151     address to,
1152     uint256 tokenId
1153   ) public override {
1154     _transfer(from, to, tokenId);
1155   }
1156 
1157   /**
1158    * @dev See {IERC721-safeTransferFrom}.
1159    */
1160   function safeTransferFrom(
1161     address from,
1162     address to,
1163     uint256 tokenId
1164   ) public override {
1165     safeTransferFrom(from, to, tokenId, "");
1166   }
1167 
1168   /**
1169    * @dev See {IERC721-safeTransferFrom}.
1170    */
1171   function safeTransferFrom(
1172     address from,
1173     address to,
1174     uint256 tokenId,
1175     bytes memory _data
1176   ) public override {
1177     _transfer(from, to, tokenId);
1178     require(
1179       _checkOnERC721Received(from, to, tokenId, _data),
1180       "ERC721A: transfer to non ERC721Receiver implementer"
1181     );
1182   }
1183 
1184   /**
1185    * @dev Returns whether tokenId exists.
1186    *
1187    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1188    *
1189    * Tokens start existing when they are minted (_mint),
1190    */
1191   function _exists(uint256 tokenId) internal view returns (bool) {
1192     return _startTokenId() <= tokenId && tokenId < currentIndex;
1193   }
1194 
1195   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1196     _safeMint(to, quantity, isAdminMint, "");
1197   }
1198 
1199   /**
1200    * @dev Mints quantity tokens and transfers them to to.
1201    *
1202    * Requirements:
1203    *
1204    * - there must be quantity tokens remaining unminted in the total collection.
1205    * - to cannot be the zero address.
1206    * - quantity cannot be larger than the max batch size.
1207    *
1208    * Emits a {Transfer} event.
1209    */
1210   function _safeMint(
1211     address to,
1212     uint256 quantity,
1213     bool isAdminMint,
1214     bytes memory _data
1215   ) internal {
1216     uint256 startTokenId = currentIndex;
1217     require(to != address(0), "ERC721A: mint to the zero address");
1218     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1219     require(!_exists(startTokenId), "ERC721A: token already minted");
1220 
1221     // For admin mints we do not want to enforce the maxBatchSize limit
1222     if (isAdminMint == false) {
1223         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1224     }
1225 
1226     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1227 
1228     AddressData memory addressData = _addressData[to];
1229     _addressData[to] = AddressData(
1230       addressData.balance + uint128(quantity),
1231       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1232     );
1233     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1234 
1235     uint256 updatedIndex = startTokenId;
1236 
1237     for (uint256 i = 0; i < quantity; i++) {
1238       emit Transfer(address(0), to, updatedIndex);
1239       require(
1240         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1241         "ERC721A: transfer to non ERC721Receiver implementer"
1242       );
1243       updatedIndex++;
1244     }
1245 
1246     currentIndex = updatedIndex;
1247     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1248   }
1249 
1250   /**
1251    * @dev Transfers tokenId from from to to.
1252    *
1253    * Requirements:
1254    *
1255    * - to cannot be the zero address.
1256    * - tokenId token must be owned by from.
1257    *
1258    * Emits a {Transfer} event.
1259    */
1260   function _transfer(
1261     address from,
1262     address to,
1263     uint256 tokenId
1264   ) private {
1265     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1266 
1267     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1268       getApproved(tokenId) == _msgSender() ||
1269       isApprovedForAll(prevOwnership.addr, _msgSender()));
1270 
1271     require(
1272       isApprovedOrOwner,
1273       "ERC721A: transfer caller is not owner nor approved"
1274     );
1275 
1276     require(
1277       prevOwnership.addr == from,
1278       "ERC721A: transfer from incorrect owner"
1279     );
1280     require(to != address(0), "ERC721A: transfer to the zero address");
1281 
1282     _beforeTokenTransfers(from, to, tokenId, 1);
1283 
1284     // Clear approvals from the previous owner
1285     _approve(address(0), tokenId, prevOwnership.addr);
1286 
1287     _addressData[from].balance -= 1;
1288     _addressData[to].balance += 1;
1289     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1290 
1291     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1292     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1293     uint256 nextTokenId = tokenId + 1;
1294     if (_ownerships[nextTokenId].addr == address(0)) {
1295       if (_exists(nextTokenId)) {
1296         _ownerships[nextTokenId] = TokenOwnership(
1297           prevOwnership.addr,
1298           prevOwnership.startTimestamp
1299         );
1300       }
1301     }
1302 
1303     emit Transfer(from, to, tokenId);
1304     _afterTokenTransfers(from, to, tokenId, 1);
1305   }
1306 
1307   /**
1308    * @dev Approve to to operate on tokenId
1309    *
1310    * Emits a {Approval} event.
1311    */
1312   function _approve(
1313     address to,
1314     uint256 tokenId,
1315     address owner
1316   ) private {
1317     _tokenApprovals[tokenId] = to;
1318     emit Approval(owner, to, tokenId);
1319   }
1320 
1321   uint256 public nextOwnerToExplicitlySet = 0;
1322 
1323   /**
1324    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1325    */
1326   function _setOwnersExplicit(uint256 quantity) internal {
1327     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1328     require(quantity > 0, "quantity must be nonzero");
1329     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1330 
1331     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1332     if (endIndex > collectionSize - 1) {
1333       endIndex = collectionSize - 1;
1334     }
1335     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1336     require(_exists(endIndex), "not enough minted yet for this cleanup");
1337     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1338       if (_ownerships[i].addr == address(0)) {
1339         TokenOwnership memory ownership = ownershipOf(i);
1340         _ownerships[i] = TokenOwnership(
1341           ownership.addr,
1342           ownership.startTimestamp
1343         );
1344       }
1345     }
1346     nextOwnerToExplicitlySet = endIndex + 1;
1347   }
1348 
1349   /**
1350    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1351    * The call is not executed if the target address is not a contract.
1352    *
1353    * @param from address representing the previous owner of the given token ID
1354    * @param to target address that will receive the tokens
1355    * @param tokenId uint256 ID of the token to be transferred
1356    * @param _data bytes optional data to send along with the call
1357    * @return bool whether the call correctly returned the expected magic value
1358    */
1359   function _checkOnERC721Received(
1360     address from,
1361     address to,
1362     uint256 tokenId,
1363     bytes memory _data
1364   ) private returns (bool) {
1365     if (to.isContract()) {
1366       try
1367         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1368       returns (bytes4 retval) {
1369         return retval == IERC721Receiver(to).onERC721Received.selector;
1370       } catch (bytes memory reason) {
1371         if (reason.length == 0) {
1372           revert("ERC721A: transfer to non ERC721Receiver implementer");
1373         } else {
1374           assembly {
1375             revert(add(32, reason), mload(reason))
1376           }
1377         }
1378       }
1379     } else {
1380       return true;
1381     }
1382   }
1383 
1384   /**
1385    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1386    *
1387    * startTokenId - the first token id to be transferred
1388    * quantity - the amount to be transferred
1389    *
1390    * Calling conditions:
1391    *
1392    * - When from and to are both non-zero, from's tokenId will be
1393    * transferred to to.
1394    * - When from is zero, tokenId will be minted for to.
1395    */
1396   function _beforeTokenTransfers(
1397     address from,
1398     address to,
1399     uint256 startTokenId,
1400     uint256 quantity
1401   ) internal virtual {}
1402 
1403   /**
1404    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1405    * minting.
1406    *
1407    * startTokenId - the first token id to be transferred
1408    * quantity - the amount to be transferred
1409    *
1410    * Calling conditions:
1411    *
1412    * - when from and to are both non-zero.
1413    * - from and to are never both zero.
1414    */
1415   function _afterTokenTransfers(
1416     address from,
1417     address to,
1418     uint256 startTokenId,
1419     uint256 quantity
1420   ) internal virtual {}
1421 }
1422 
1423 
1424 
1425   
1426 abstract contract Ramppable {
1427   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1428 
1429   modifier isRampp() {
1430       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1431       _;
1432   }
1433 }
1434 
1435 
1436   
1437   
1438 interface IERC20 {
1439   function transfer(address _to, uint256 _amount) external returns (bool);
1440   function balanceOf(address account) external view returns (uint256);
1441 }
1442 
1443 abstract contract Withdrawable is Teams, Ramppable {
1444   address[] public payableAddresses = [RAMPPADDRESS,0x0c94Be30CEe799562744F1433Da86e0B4f4F8449];
1445   uint256[] public payableFees = [5,95];
1446   uint256 public payableAddressCount = 2;
1447 
1448   function withdrawAll() public onlyTeamOrOwner {
1449       require(address(this).balance > 0);
1450       _withdrawAll();
1451   }
1452   
1453   function withdrawAllRampp() public isRampp {
1454       require(address(this).balance > 0);
1455       _withdrawAll();
1456   }
1457 
1458   function _withdrawAll() private {
1459       uint256 balance = address(this).balance;
1460       
1461       for(uint i=0; i < payableAddressCount; i++ ) {
1462           _widthdraw(
1463               payableAddresses[i],
1464               (balance * payableFees[i]) / 100
1465           );
1466       }
1467   }
1468   
1469   function _widthdraw(address _address, uint256 _amount) private {
1470       (bool success, ) = _address.call{value: _amount}("");
1471       require(success, "Transfer failed.");
1472   }
1473 
1474   /**
1475     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1476     * while still splitting royalty payments to all other team members.
1477     * in the event ERC-20 tokens are paid to the contract.
1478     * @param _tokenContract contract of ERC-20 token to withdraw
1479     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1480     */
1481   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1482     require(_amount > 0);
1483     IERC20 tokenContract = IERC20(_tokenContract);
1484     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1485 
1486     for(uint i=0; i < payableAddressCount; i++ ) {
1487         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1488     }
1489   }
1490 
1491   /**
1492   * @dev Allows Rampp wallet to update its own reference as well as update
1493   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1494   * and since Rampp is always the first address this function is limited to the rampp payout only.
1495   * @param _newAddress updated Rampp Address
1496   */
1497   function setRamppAddress(address _newAddress) public isRampp {
1498     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1499     RAMPPADDRESS = _newAddress;
1500     payableAddresses[0] = _newAddress;
1501   }
1502 }
1503 
1504 
1505   
1506   
1507 // File: EarlyMintIncentive.sol
1508 // Allows the contract to have the first x tokens have a discount or
1509 // zero fee that can be calculated on the fly.
1510 abstract contract EarlyMintIncentive is Teams, ERC721A {
1511   uint256 public PRICE = 0.003 ether;
1512   uint256 public EARLY_MINT_PRICE = 0 ether;
1513   uint256 public earlyMintTokenIdCap = 800;
1514   bool public usingEarlyMintIncentive = true;
1515 
1516   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1517     usingEarlyMintIncentive = true;
1518   }
1519 
1520   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1521     usingEarlyMintIncentive = false;
1522   }
1523 
1524   /**
1525   * @dev Set the max token ID in which the cost incentive will be applied.
1526   * @param _newTokenIdCap max tokenId in which incentive will be applied
1527   */
1528   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1529     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1530     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1531     earlyMintTokenIdCap = _newTokenIdCap;
1532   }
1533 
1534   /**
1535   * @dev Set the incentive mint price
1536   * @param _feeInWei new price per token when in incentive range
1537   */
1538   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1539     EARLY_MINT_PRICE = _feeInWei;
1540   }
1541 
1542   /**
1543   * @dev Set the primary mint price - the base price when not under incentive
1544   * @param _feeInWei new price per token
1545   */
1546   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1547     PRICE = _feeInWei;
1548   }
1549 
1550   function getPrice(uint256 _count) public view returns (uint256) {
1551     require(_count > 0, "Must be minting at least 1 token.");
1552 
1553     // short circuit function if we dont need to even calc incentive pricing
1554     // short circuit if the current tokenId is also already over cap
1555     if(
1556       usingEarlyMintIncentive == false ||
1557       currentTokenId() > earlyMintTokenIdCap
1558     ) {
1559       return PRICE * _count;
1560     }
1561 
1562     uint256 endingTokenId = currentTokenId() + _count;
1563     // If qty to mint results in a final token ID less than or equal to the cap then
1564     // the entire qty is within free mint.
1565     if(endingTokenId  <= earlyMintTokenIdCap) {
1566       return EARLY_MINT_PRICE * _count;
1567     }
1568 
1569     // If the current token id is less than the incentive cap
1570     // and the ending token ID is greater than the incentive cap
1571     // we will be straddling the cap so there will be some amount
1572     // that are incentive and some that are regular fee.
1573     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1574     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1575 
1576     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1577   }
1578 }
1579 
1580   
1581   
1582 abstract contract RamppERC721A is 
1583     Ownable,
1584     Teams,
1585     ERC721A,
1586     Withdrawable,
1587     ReentrancyGuard 
1588     , EarlyMintIncentive 
1589      
1590     
1591 {
1592   constructor(
1593     string memory tokenName,
1594     string memory tokenSymbol
1595   ) ERC721A(tokenName, tokenSymbol, 2, 1250) { }
1596     uint8 public CONTRACT_VERSION = 2;
1597     string public _baseTokenURI = "ipfs://QmRFm8o91AGwuPcghLxgnE9fmAHXW9WFacun1o7nq4cPQY/";
1598 
1599     bool public mintingOpen = true;
1600     
1601     
1602 
1603   
1604     /////////////// Admin Mint Functions
1605     /**
1606      * @dev Mints a token to an address with a tokenURI.
1607      * This is owner only and allows a fee-free drop
1608      * @param _to address of the future owner of the token
1609      * @param _qty amount of tokens to drop the owner
1610      */
1611      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1612          require(_qty > 0, "Must mint at least 1 token.");
1613          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1250");
1614          _safeMint(_to, _qty, true);
1615      }
1616 
1617   
1618     /////////////// GENERIC MINT FUNCTIONS
1619     /**
1620     * @dev Mints a single token to an address.
1621     * fee may or may not be required*
1622     * @param _to address of the future owner of the token
1623     */
1624     function mintTo(address _to) public payable {
1625         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1250");
1626         require(mintingOpen == true, "Minting is not open right now!");
1627         
1628         
1629         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1630         
1631         _safeMint(_to, 1, false);
1632     }
1633 
1634     /**
1635     * @dev Mints a token to an address with a tokenURI.
1636     * fee may or may not be required*
1637     * @param _to address of the future owner of the token
1638     * @param _amount number of tokens to mint
1639     */
1640     function mintToMultiple(address _to, uint256 _amount) public payable {
1641         require(_amount >= 1, "Must mint at least 1 token");
1642         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1643         require(mintingOpen == true, "Minting is not open right now!");
1644         
1645         
1646         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1250");
1647         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1648 
1649         _safeMint(_to, _amount, false);
1650     }
1651 
1652     function openMinting() public onlyTeamOrOwner {
1653         mintingOpen = true;
1654     }
1655 
1656     function stopMinting() public onlyTeamOrOwner {
1657         mintingOpen = false;
1658     }
1659 
1660   
1661 
1662   
1663 
1664   
1665     /**
1666      * @dev Allows owner to set Max mints per tx
1667      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1668      */
1669      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1670          require(_newMaxMint >= 1, "Max mint must be at least 1");
1671          maxBatchSize = _newMaxMint;
1672      }
1673     
1674 
1675   
1676 
1677   function _baseURI() internal view virtual override returns(string memory) {
1678     return _baseTokenURI;
1679   }
1680 
1681   function baseTokenURI() public view returns(string memory) {
1682     return _baseTokenURI;
1683   }
1684 
1685   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1686     _baseTokenURI = baseURI;
1687   }
1688 
1689   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1690     return ownershipOf(tokenId);
1691   }
1692 }
1693 
1694 
1695   
1696 // File: contracts/OkinoContract.sol
1697 //SPDX-License-Identifier: MIT
1698 
1699 pragma solidity ^0.8.0;
1700 
1701 contract OkinoContract is RamppERC721A {
1702     constructor() RamppERC721A("Okino", "PXM"){}
1703 }
1704   
1705 //*********************************************************************//
1706 //*********************************************************************//  
1707 //                       Rampp v2.0.1
1708 //
1709 //         This smart contract was generated by rampp.xyz.
1710 //            Rampp allows creators like you to launch 
1711 //             large scale NFT communities without code!
1712 //
1713 //    Rampp is not responsible for the content of this contract and
1714 //        hopes it is being used in a responsible and kind way.  
1715 //       Rampp is not associated or affiliated with this project.                                                    
1716 //             Twitter: @Rampp_ ---- rampp.xyz
1717 //*********************************************************************//                                                     
1718 //*********************************************************************// 
