1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //            _      _ __   ____                 
6 //     ____  (_)  __(_) /  / __ )___  ____ ______
7 //    / __ \/ / |/_/ / /  / __  / _ \/ __ `/ ___/
8 //   / /_/ / />  </ / /  / /_/ /  __/ /_/ / /    
9 //  / .___/_/_/|_/_/_/  /_____/\___/\__,_/_/     
10 // /_/                                           
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
788 * This will easily allow cross-collaboration via Mintplex.xyz.
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
857   IERC721Enumerable,
858   Teams
859 {
860   using Address for address;
861   using Strings for uint256;
862 
863   struct TokenOwnership {
864     address addr;
865     uint64 startTimestamp;
866   }
867 
868   struct AddressData {
869     uint128 balance;
870     uint128 numberMinted;
871   }
872 
873   uint256 private currentIndex;
874 
875   uint256 public immutable collectionSize;
876   uint256 public maxBatchSize;
877 
878   // Token name
879   string private _name;
880 
881   // Token symbol
882   string private _symbol;
883 
884   // Mapping from token ID to ownership details
885   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
886   mapping(uint256 => TokenOwnership) private _ownerships;
887 
888   // Mapping owner address to address data
889   mapping(address => AddressData) private _addressData;
890 
891   // Mapping from token ID to approved address
892   mapping(uint256 => address) private _tokenApprovals;
893 
894   // Mapping from owner to operator approvals
895   mapping(address => mapping(address => bool)) private _operatorApprovals;
896 
897   /* @dev Mapping of restricted operator approvals set by contract Owner
898   * This serves as an optional addition to ERC-721 so
899   * that the contract owner can elect to prevent specific addresses/contracts
900   * from being marked as the approver for a token. The reason for this
901   * is that some projects may want to retain control of where their tokens can/can not be listed
902   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
903   * By default, there are no restrictions. The contract owner must deliberatly block an address 
904   */
905   mapping(address => bool) public restrictedApprovalAddresses;
906 
907   /**
908    * @dev
909    * maxBatchSize refers to how much a minter can mint at a time.
910    * collectionSize_ refers to how many tokens are in the collection.
911    */
912   constructor(
913     string memory name_,
914     string memory symbol_,
915     uint256 maxBatchSize_,
916     uint256 collectionSize_
917   ) {
918     require(
919       collectionSize_ > 0,
920       "ERC721A: collection must have a nonzero supply"
921     );
922     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
923     _name = name_;
924     _symbol = symbol_;
925     maxBatchSize = maxBatchSize_;
926     collectionSize = collectionSize_;
927     currentIndex = _startTokenId();
928   }
929 
930   /**
931   * To change the starting tokenId, please override this function.
932   */
933   function _startTokenId() internal view virtual returns (uint256) {
934     return 1;
935   }
936 
937   /**
938    * @dev See {IERC721Enumerable-totalSupply}.
939    */
940   function totalSupply() public view override returns (uint256) {
941     return _totalMinted();
942   }
943 
944   function currentTokenId() public view returns (uint256) {
945     return _totalMinted();
946   }
947 
948   function getNextTokenId() public view returns (uint256) {
949       return _totalMinted() + 1;
950   }
951 
952   /**
953   * Returns the total amount of tokens minted in the contract.
954   */
955   function _totalMinted() internal view returns (uint256) {
956     unchecked {
957       return currentIndex - _startTokenId();
958     }
959   }
960 
961   /**
962    * @dev See {IERC721Enumerable-tokenByIndex}.
963    */
964   function tokenByIndex(uint256 index) public view override returns (uint256) {
965     require(index < totalSupply(), "ERC721A: global index out of bounds");
966     return index;
967   }
968 
969   /**
970    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
971    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
972    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
973    */
974   function tokenOfOwnerByIndex(address owner, uint256 index)
975     public
976     view
977     override
978     returns (uint256)
979   {
980     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
981     uint256 numMintedSoFar = totalSupply();
982     uint256 tokenIdsIdx = 0;
983     address currOwnershipAddr = address(0);
984     for (uint256 i = 0; i < numMintedSoFar; i++) {
985       TokenOwnership memory ownership = _ownerships[i];
986       if (ownership.addr != address(0)) {
987         currOwnershipAddr = ownership.addr;
988       }
989       if (currOwnershipAddr == owner) {
990         if (tokenIdsIdx == index) {
991           return i;
992         }
993         tokenIdsIdx++;
994       }
995     }
996     revert("ERC721A: unable to get token of owner by index");
997   }
998 
999   /**
1000    * @dev See {IERC165-supportsInterface}.
1001    */
1002   function supportsInterface(bytes4 interfaceId)
1003     public
1004     view
1005     virtual
1006     override(ERC165, IERC165)
1007     returns (bool)
1008   {
1009     return
1010       interfaceId == type(IERC721).interfaceId ||
1011       interfaceId == type(IERC721Metadata).interfaceId ||
1012       interfaceId == type(IERC721Enumerable).interfaceId ||
1013       super.supportsInterface(interfaceId);
1014   }
1015 
1016   /**
1017    * @dev See {IERC721-balanceOf}.
1018    */
1019   function balanceOf(address owner) public view override returns (uint256) {
1020     require(owner != address(0), "ERC721A: balance query for the zero address");
1021     return uint256(_addressData[owner].balance);
1022   }
1023 
1024   function _numberMinted(address owner) internal view returns (uint256) {
1025     require(
1026       owner != address(0),
1027       "ERC721A: number minted query for the zero address"
1028     );
1029     return uint256(_addressData[owner].numberMinted);
1030   }
1031 
1032   function ownershipOf(uint256 tokenId)
1033     internal
1034     view
1035     returns (TokenOwnership memory)
1036   {
1037     uint256 curr = tokenId;
1038 
1039     unchecked {
1040         if (_startTokenId() <= curr && curr < currentIndex) {
1041             TokenOwnership memory ownership = _ownerships[curr];
1042             if (ownership.addr != address(0)) {
1043                 return ownership;
1044             }
1045 
1046             // Invariant:
1047             // There will always be an ownership that has an address and is not burned
1048             // before an ownership that does not have an address and is not burned.
1049             // Hence, curr will not underflow.
1050             while (true) {
1051                 curr--;
1052                 ownership = _ownerships[curr];
1053                 if (ownership.addr != address(0)) {
1054                     return ownership;
1055                 }
1056             }
1057         }
1058     }
1059 
1060     revert("ERC721A: unable to determine the owner of token");
1061   }
1062 
1063   /**
1064    * @dev See {IERC721-ownerOf}.
1065    */
1066   function ownerOf(uint256 tokenId) public view override returns (address) {
1067     return ownershipOf(tokenId).addr;
1068   }
1069 
1070   /**
1071    * @dev See {IERC721Metadata-name}.
1072    */
1073   function name() public view virtual override returns (string memory) {
1074     return _name;
1075   }
1076 
1077   /**
1078    * @dev See {IERC721Metadata-symbol}.
1079    */
1080   function symbol() public view virtual override returns (string memory) {
1081     return _symbol;
1082   }
1083 
1084   /**
1085    * @dev See {IERC721Metadata-tokenURI}.
1086    */
1087   function tokenURI(uint256 tokenId)
1088     public
1089     view
1090     virtual
1091     override
1092     returns (string memory)
1093   {
1094     string memory baseURI = _baseURI();
1095     return
1096       bytes(baseURI).length > 0
1097         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1098         : "";
1099   }
1100 
1101   /**
1102    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1103    * token will be the concatenation of the baseURI and the tokenId. Empty
1104    * by default, can be overriden in child contracts.
1105    */
1106   function _baseURI() internal view virtual returns (string memory) {
1107     return "";
1108   }
1109 
1110   /**
1111    * @dev Sets the value for an address to be in the restricted approval address pool.
1112    * Setting an address to true will disable token owners from being able to mark the address
1113    * for approval for trading. This would be used in theory to prevent token owners from listing
1114    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1115    * @param _address the marketplace/user to modify restriction status of
1116    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1117    */
1118   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1119     restrictedApprovalAddresses[_address] = _isRestricted;
1120   }
1121 
1122   /**
1123    * @dev See {IERC721-approve}.
1124    */
1125   function approve(address to, uint256 tokenId) public override {
1126     address owner = ERC721A.ownerOf(tokenId);
1127     require(to != owner, "ERC721A: approval to current owner");
1128     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1129 
1130     require(
1131       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1132       "ERC721A: approve caller is not owner nor approved for all"
1133     );
1134 
1135     _approve(to, tokenId, owner);
1136   }
1137 
1138   /**
1139    * @dev See {IERC721-getApproved}.
1140    */
1141   function getApproved(uint256 tokenId) public view override returns (address) {
1142     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1143 
1144     return _tokenApprovals[tokenId];
1145   }
1146 
1147   /**
1148    * @dev See {IERC721-setApprovalForAll}.
1149    */
1150   function setApprovalForAll(address operator, bool approved) public override {
1151     require(operator != _msgSender(), "ERC721A: approve to caller");
1152     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1153 
1154     _operatorApprovals[_msgSender()][operator] = approved;
1155     emit ApprovalForAll(_msgSender(), operator, approved);
1156   }
1157 
1158   /**
1159    * @dev See {IERC721-isApprovedForAll}.
1160    */
1161   function isApprovedForAll(address owner, address operator)
1162     public
1163     view
1164     virtual
1165     override
1166     returns (bool)
1167   {
1168     return _operatorApprovals[owner][operator];
1169   }
1170 
1171   /**
1172    * @dev See {IERC721-transferFrom}.
1173    */
1174   function transferFrom(
1175     address from,
1176     address to,
1177     uint256 tokenId
1178   ) public override {
1179     _transfer(from, to, tokenId);
1180   }
1181 
1182   /**
1183    * @dev See {IERC721-safeTransferFrom}.
1184    */
1185   function safeTransferFrom(
1186     address from,
1187     address to,
1188     uint256 tokenId
1189   ) public override {
1190     safeTransferFrom(from, to, tokenId, "");
1191   }
1192 
1193   /**
1194    * @dev See {IERC721-safeTransferFrom}.
1195    */
1196   function safeTransferFrom(
1197     address from,
1198     address to,
1199     uint256 tokenId,
1200     bytes memory _data
1201   ) public override {
1202     _transfer(from, to, tokenId);
1203     require(
1204       _checkOnERC721Received(from, to, tokenId, _data),
1205       "ERC721A: transfer to non ERC721Receiver implementer"
1206     );
1207   }
1208 
1209   /**
1210    * @dev Returns whether tokenId exists.
1211    *
1212    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1213    *
1214    * Tokens start existing when they are minted (_mint),
1215    */
1216   function _exists(uint256 tokenId) internal view returns (bool) {
1217     return _startTokenId() <= tokenId && tokenId < currentIndex;
1218   }
1219 
1220   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1221     _safeMint(to, quantity, isAdminMint, "");
1222   }
1223 
1224   /**
1225    * @dev Mints quantity tokens and transfers them to to.
1226    *
1227    * Requirements:
1228    *
1229    * - there must be quantity tokens remaining unminted in the total collection.
1230    * - to cannot be the zero address.
1231    * - quantity cannot be larger than the max batch size.
1232    *
1233    * Emits a {Transfer} event.
1234    */
1235   function _safeMint(
1236     address to,
1237     uint256 quantity,
1238     bool isAdminMint,
1239     bytes memory _data
1240   ) internal {
1241     uint256 startTokenId = currentIndex;
1242     require(to != address(0), "ERC721A: mint to the zero address");
1243     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1244     require(!_exists(startTokenId), "ERC721A: token already minted");
1245 
1246     // For admin mints we do not want to enforce the maxBatchSize limit
1247     if (isAdminMint == false) {
1248         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1249     }
1250 
1251     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1252 
1253     AddressData memory addressData = _addressData[to];
1254     _addressData[to] = AddressData(
1255       addressData.balance + uint128(quantity),
1256       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1257     );
1258     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1259 
1260     uint256 updatedIndex = startTokenId;
1261 
1262     for (uint256 i = 0; i < quantity; i++) {
1263       emit Transfer(address(0), to, updatedIndex);
1264       require(
1265         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1266         "ERC721A: transfer to non ERC721Receiver implementer"
1267       );
1268       updatedIndex++;
1269     }
1270 
1271     currentIndex = updatedIndex;
1272     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1273   }
1274 
1275   /**
1276    * @dev Transfers tokenId from from to to.
1277    *
1278    * Requirements:
1279    *
1280    * - to cannot be the zero address.
1281    * - tokenId token must be owned by from.
1282    *
1283    * Emits a {Transfer} event.
1284    */
1285   function _transfer(
1286     address from,
1287     address to,
1288     uint256 tokenId
1289   ) private {
1290     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1291 
1292     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1293       getApproved(tokenId) == _msgSender() ||
1294       isApprovedForAll(prevOwnership.addr, _msgSender()));
1295 
1296     require(
1297       isApprovedOrOwner,
1298       "ERC721A: transfer caller is not owner nor approved"
1299     );
1300 
1301     require(
1302       prevOwnership.addr == from,
1303       "ERC721A: transfer from incorrect owner"
1304     );
1305     require(to != address(0), "ERC721A: transfer to the zero address");
1306 
1307     _beforeTokenTransfers(from, to, tokenId, 1);
1308 
1309     // Clear approvals from the previous owner
1310     _approve(address(0), tokenId, prevOwnership.addr);
1311 
1312     _addressData[from].balance -= 1;
1313     _addressData[to].balance += 1;
1314     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1315 
1316     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1317     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1318     uint256 nextTokenId = tokenId + 1;
1319     if (_ownerships[nextTokenId].addr == address(0)) {
1320       if (_exists(nextTokenId)) {
1321         _ownerships[nextTokenId] = TokenOwnership(
1322           prevOwnership.addr,
1323           prevOwnership.startTimestamp
1324         );
1325       }
1326     }
1327 
1328     emit Transfer(from, to, tokenId);
1329     _afterTokenTransfers(from, to, tokenId, 1);
1330   }
1331 
1332   /**
1333    * @dev Approve to to operate on tokenId
1334    *
1335    * Emits a {Approval} event.
1336    */
1337   function _approve(
1338     address to,
1339     uint256 tokenId,
1340     address owner
1341   ) private {
1342     _tokenApprovals[tokenId] = to;
1343     emit Approval(owner, to, tokenId);
1344   }
1345 
1346   uint256 public nextOwnerToExplicitlySet = 0;
1347 
1348   /**
1349    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1350    */
1351   function _setOwnersExplicit(uint256 quantity) internal {
1352     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1353     require(quantity > 0, "quantity must be nonzero");
1354     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1355 
1356     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1357     if (endIndex > collectionSize - 1) {
1358       endIndex = collectionSize - 1;
1359     }
1360     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1361     require(_exists(endIndex), "not enough minted yet for this cleanup");
1362     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1363       if (_ownerships[i].addr == address(0)) {
1364         TokenOwnership memory ownership = ownershipOf(i);
1365         _ownerships[i] = TokenOwnership(
1366           ownership.addr,
1367           ownership.startTimestamp
1368         );
1369       }
1370     }
1371     nextOwnerToExplicitlySet = endIndex + 1;
1372   }
1373 
1374   /**
1375    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1376    * The call is not executed if the target address is not a contract.
1377    *
1378    * @param from address representing the previous owner of the given token ID
1379    * @param to target address that will receive the tokens
1380    * @param tokenId uint256 ID of the token to be transferred
1381    * @param _data bytes optional data to send along with the call
1382    * @return bool whether the call correctly returned the expected magic value
1383    */
1384   function _checkOnERC721Received(
1385     address from,
1386     address to,
1387     uint256 tokenId,
1388     bytes memory _data
1389   ) private returns (bool) {
1390     if (to.isContract()) {
1391       try
1392         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1393       returns (bytes4 retval) {
1394         return retval == IERC721Receiver(to).onERC721Received.selector;
1395       } catch (bytes memory reason) {
1396         if (reason.length == 0) {
1397           revert("ERC721A: transfer to non ERC721Receiver implementer");
1398         } else {
1399           assembly {
1400             revert(add(32, reason), mload(reason))
1401           }
1402         }
1403       }
1404     } else {
1405       return true;
1406     }
1407   }
1408 
1409   /**
1410    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1411    *
1412    * startTokenId - the first token id to be transferred
1413    * quantity - the amount to be transferred
1414    *
1415    * Calling conditions:
1416    *
1417    * - When from and to are both non-zero, from's tokenId will be
1418    * transferred to to.
1419    * - When from is zero, tokenId will be minted for to.
1420    */
1421   function _beforeTokenTransfers(
1422     address from,
1423     address to,
1424     uint256 startTokenId,
1425     uint256 quantity
1426   ) internal virtual {}
1427 
1428   /**
1429    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1430    * minting.
1431    *
1432    * startTokenId - the first token id to be transferred
1433    * quantity - the amount to be transferred
1434    *
1435    * Calling conditions:
1436    *
1437    * - when from and to are both non-zero.
1438    * - from and to are never both zero.
1439    */
1440   function _afterTokenTransfers(
1441     address from,
1442     address to,
1443     uint256 startTokenId,
1444     uint256 quantity
1445   ) internal virtual {}
1446 }
1447 
1448 
1449 
1450   
1451 abstract contract Ramppable {
1452   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1453 
1454   modifier isRampp() {
1455       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1456       _;
1457   }
1458 }
1459 
1460 
1461   
1462   
1463 interface IERC20 {
1464   function allowance(address owner, address spender) external view returns (uint256);
1465   function transfer(address _to, uint256 _amount) external returns (bool);
1466   function balanceOf(address account) external view returns (uint256);
1467   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1468 }
1469 
1470 // File: WithdrawableV2
1471 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1472 // ERC-20 Payouts are limited to a single payout address. This feature 
1473 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1474 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1475 abstract contract WithdrawableV2 is Teams, Ramppable {
1476   struct acceptedERC20 {
1477     bool isActive;
1478     uint256 chargeAmount;
1479   }
1480 
1481   
1482   mapping(address => acceptedERC20) private allowedTokenContracts;
1483   address[] public payableAddresses = [RAMPPADDRESS,0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0x92BdA736aD0c8be95e0a0930d840e8da198Be041];
1484   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1485   address public erc20Payable = 0x92BdA736aD0c8be95e0a0930d840e8da198Be041;
1486   uint256[] public payableFees = [1,4,95];
1487   uint256[] public surchargePayableFees = [100];
1488   uint256 public payableAddressCount = 3;
1489   uint256 public surchargePayableAddressCount = 1;
1490   uint256 public ramppSurchargeBalance = 0 ether;
1491   uint256 public ramppSurchargeFee = 0.001 ether;
1492   bool public onlyERC20MintingMode = false;
1493   
1494 
1495   /**
1496   * @dev Calculates the true payable balance of the contract as the
1497   * value on contract may be from ERC-20 mint surcharges and not 
1498   * public mint charges - which are not eligable for rev share & user withdrawl
1499   */
1500   function calcAvailableBalance() public view returns(uint256) {
1501     return address(this).balance - ramppSurchargeBalance;
1502   }
1503 
1504   function withdrawAll() public onlyTeamOrOwner {
1505       require(calcAvailableBalance() > 0);
1506       _withdrawAll();
1507   }
1508   
1509   function withdrawAllRampp() public isRampp {
1510       require(calcAvailableBalance() > 0);
1511       _withdrawAll();
1512   }
1513 
1514   function _withdrawAll() private {
1515       uint256 balance = calcAvailableBalance();
1516       
1517       for(uint i=0; i < payableAddressCount; i++ ) {
1518           _widthdraw(
1519               payableAddresses[i],
1520               (balance * payableFees[i]) / 100
1521           );
1522       }
1523   }
1524   
1525   function _widthdraw(address _address, uint256 _amount) private {
1526       (bool success, ) = _address.call{value: _amount}("");
1527       require(success, "Transfer failed.");
1528   }
1529 
1530   /**
1531   * @dev This function is similiar to the regular withdraw but operates only on the
1532   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1533   **/
1534   function _withdrawAllSurcharges() private {
1535     uint256 balance = ramppSurchargeBalance;
1536     if(balance == 0) { return; }
1537     
1538     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1539         _widthdraw(
1540             surchargePayableAddresses[i],
1541             (balance * surchargePayableFees[i]) / 100
1542         );
1543     }
1544     ramppSurchargeBalance = 0 ether;
1545   }
1546 
1547   /**
1548   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1549   * in the event ERC-20 tokens are paid to the contract for mints. This will
1550   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1551   * @param _tokenContract contract of ERC-20 token to withdraw
1552   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1553   */
1554   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1555     require(_amountToWithdraw > 0);
1556     IERC20 tokenContract = IERC20(_tokenContract);
1557     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1558     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1559     _withdrawAllSurcharges();
1560   }
1561 
1562   /**
1563   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1564   */
1565   function withdrawRamppSurcharges() public isRampp {
1566     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1567     _withdrawAllSurcharges();
1568   }
1569 
1570    /**
1571   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1572   */
1573   function addSurcharge() internal {
1574     ramppSurchargeBalance += ramppSurchargeFee;
1575   }
1576   
1577   /**
1578   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1579   */
1580   function hasSurcharge() internal returns(bool) {
1581     return msg.value == ramppSurchargeFee;
1582   }
1583 
1584   /**
1585   * @dev Set surcharge fee for using ERC-20 payments on contract
1586   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1587   */
1588   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1589     ramppSurchargeFee = _newSurcharge;
1590   }
1591 
1592   /**
1593   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1594   * @param _erc20TokenContract address of ERC-20 contract in question
1595   */
1596   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1597     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1598   }
1599 
1600   /**
1601   * @dev get the value of tokens to transfer for user of an ERC-20
1602   * @param _erc20TokenContract address of ERC-20 contract in question
1603   */
1604   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1605     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1606     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1607   }
1608 
1609   /**
1610   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1611   * @param _erc20TokenContract address of ERC-20 contract in question
1612   * @param _isActive default status of if contract should be allowed to accept payments
1613   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1614   */
1615   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1616     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1617     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1618   }
1619 
1620   /**
1621   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1622   * it will assume the default value of zero. This should not be used to create new payment tokens.
1623   * @param _erc20TokenContract address of ERC-20 contract in question
1624   */
1625   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1626     allowedTokenContracts[_erc20TokenContract].isActive = true;
1627   }
1628 
1629   /**
1630   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1631   * it will assume the default value of zero. This should not be used to create new payment tokens.
1632   * @param _erc20TokenContract address of ERC-20 contract in question
1633   */
1634   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1635     allowedTokenContracts[_erc20TokenContract].isActive = false;
1636   }
1637 
1638   /**
1639   * @dev Enable only ERC-20 payments for minting on this contract
1640   */
1641   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1642     onlyERC20MintingMode = true;
1643   }
1644 
1645   /**
1646   * @dev Disable only ERC-20 payments for minting on this contract
1647   */
1648   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1649     onlyERC20MintingMode = false;
1650   }
1651 
1652   /**
1653   * @dev Set the payout of the ERC-20 token payout to a specific address
1654   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1655   */
1656   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1657     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1658     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1659     erc20Payable = _newErc20Payable;
1660   }
1661 
1662   /**
1663   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1664   */
1665   function resetRamppSurchargeBalance() public isRampp {
1666     ramppSurchargeBalance = 0 ether;
1667   }
1668 
1669   /**
1670   * @dev Allows Rampp wallet to update its own reference as well as update
1671   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1672   * and since Rampp is always the first address this function is limited to the rampp payout only.
1673   * @param _newAddress updated Rampp Address
1674   */
1675   function setRamppAddress(address _newAddress) public isRampp {
1676     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1677     RAMPPADDRESS = _newAddress;
1678     payableAddresses[0] = _newAddress;
1679   }
1680 }
1681 
1682 
1683   
1684   
1685 // File: EarlyMintIncentive.sol
1686 // Allows the contract to have the first x tokens have a discount or
1687 // zero fee that can be calculated on the fly.
1688 abstract contract EarlyMintIncentive is Teams, ERC721A {
1689   uint256 public PRICE = 0.0009 ether;
1690   uint256 public EARLY_MINT_PRICE = 0 ether;
1691   uint256 public earlyMintTokenIdCap = 2500;
1692   bool public usingEarlyMintIncentive = true;
1693 
1694   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1695     usingEarlyMintIncentive = true;
1696   }
1697 
1698   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1699     usingEarlyMintIncentive = false;
1700   }
1701 
1702   /**
1703   * @dev Set the max token ID in which the cost incentive will be applied.
1704   * @param _newTokenIdCap max tokenId in which incentive will be applied
1705   */
1706   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1707     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1708     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1709     earlyMintTokenIdCap = _newTokenIdCap;
1710   }
1711 
1712   /**
1713   * @dev Set the incentive mint price
1714   * @param _feeInWei new price per token when in incentive range
1715   */
1716   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1717     EARLY_MINT_PRICE = _feeInWei;
1718   }
1719 
1720   /**
1721   * @dev Set the primary mint price - the base price when not under incentive
1722   * @param _feeInWei new price per token
1723   */
1724   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1725     PRICE = _feeInWei;
1726   }
1727 
1728   function getPrice(uint256 _count) public view returns (uint256) {
1729     require(_count > 0, "Must be minting at least 1 token.");
1730 
1731     // short circuit function if we dont need to even calc incentive pricing
1732     // short circuit if the current tokenId is also already over cap
1733     if(
1734       usingEarlyMintIncentive == false ||
1735       currentTokenId() > earlyMintTokenIdCap
1736     ) {
1737       return PRICE * _count;
1738     }
1739 
1740     uint256 endingTokenId = currentTokenId() + _count;
1741     // If qty to mint results in a final token ID less than or equal to the cap then
1742     // the entire qty is within free mint.
1743     if(endingTokenId  <= earlyMintTokenIdCap) {
1744       return EARLY_MINT_PRICE * _count;
1745     }
1746 
1747     // If the current token id is less than the incentive cap
1748     // and the ending token ID is greater than the incentive cap
1749     // we will be straddling the cap so there will be some amount
1750     // that are incentive and some that are regular fee.
1751     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1752     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1753 
1754     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1755   }
1756 }
1757 
1758   
1759   
1760 abstract contract RamppERC721A is 
1761     Ownable,
1762     Teams,
1763     ERC721A,
1764     WithdrawableV2,
1765     ReentrancyGuard 
1766     , EarlyMintIncentive 
1767      
1768     
1769 {
1770   constructor(
1771     string memory tokenName,
1772     string memory tokenSymbol
1773   ) ERC721A(tokenName, tokenSymbol, 10, 5555) { }
1774     uint8 public CONTRACT_VERSION = 2;
1775     string public _baseTokenURI = "ipfs://bafybeidmkwlcaiigthua5xwotvbidptwdqrjn3sutdnb3czeclhyef22im/";
1776 
1777     bool public mintingOpen = false;
1778     bool public isRevealed = false;
1779     
1780     uint256 public MAX_WALLET_MINTS = 20;
1781 
1782   
1783     /////////////// Admin Mint Functions
1784     /**
1785      * @dev Mints a token to an address with a tokenURI.
1786      * This is owner only and allows a fee-free drop
1787      * @param _to address of the future owner of the token
1788      * @param _qty amount of tokens to drop the owner
1789      */
1790      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1791          require(_qty > 0, "Must mint at least 1 token.");
1792          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5555");
1793          _safeMint(_to, _qty, true);
1794      }
1795 
1796   
1797     /////////////// GENERIC MINT FUNCTIONS
1798     /**
1799     * @dev Mints a single token to an address.
1800     * fee may or may not be required*
1801     * @param _to address of the future owner of the token
1802     */
1803     function mintTo(address _to) public payable {
1804         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1805         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1806         require(mintingOpen == true, "Minting is not open right now!");
1807         
1808         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1809         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1810         
1811         _safeMint(_to, 1, false);
1812     }
1813 
1814     /**
1815     * @dev Mints tokens to an address in batch.
1816     * fee may or may not be required*
1817     * @param _to address of the future owner of the token
1818     * @param _amount number of tokens to mint
1819     */
1820     function mintToMultiple(address _to, uint256 _amount) public payable {
1821         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1822         require(_amount >= 1, "Must mint at least 1 token");
1823         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1824         require(mintingOpen == true, "Minting is not open right now!");
1825         
1826         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1827         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5555");
1828         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1829 
1830         _safeMint(_to, _amount, false);
1831     }
1832 
1833     /**
1834      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1835      * fee may or may not be required*
1836      * @param _to address of the future owner of the token
1837      * @param _amount number of tokens to mint
1838      * @param _erc20TokenContract erc-20 token contract to mint with
1839      */
1840     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1841       require(_amount >= 1, "Must mint at least 1 token");
1842       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1843       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1844       require(mintingOpen == true, "Minting is not open right now!");
1845       
1846       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1847 
1848       // ERC-20 Specific pre-flight checks
1849       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1850       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1851       IERC20 payableToken = IERC20(_erc20TokenContract);
1852 
1853       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1854       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1855       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1856       
1857       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1858       require(transferComplete, "ERC-20 token was unable to be transferred");
1859       
1860       _safeMint(_to, _amount, false);
1861       addSurcharge();
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
1875     /**
1876     * @dev Check if wallet over MAX_WALLET_MINTS
1877     * @param _address address in question to check if minted count exceeds max
1878     */
1879     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1880         require(_amount >= 1, "Amount must be greater than or equal to 1");
1881         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1882     }
1883 
1884     /**
1885     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1886     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1887     */
1888     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1889         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1890         MAX_WALLET_MINTS = _newWalletMax;
1891     }
1892     
1893 
1894   
1895     /**
1896      * @dev Allows owner to set Max mints per tx
1897      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1898      */
1899      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1900          require(_newMaxMint >= 1, "Max mint must be at least 1");
1901          maxBatchSize = _newMaxMint;
1902      }
1903     
1904 
1905   
1906     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
1907         require(isRevealed == false, "Tokens are already unveiled");
1908         _baseTokenURI = _updatedTokenURI;
1909         isRevealed = true;
1910     }
1911     
1912 
1913   function _baseURI() internal view virtual override returns(string memory) {
1914     return _baseTokenURI;
1915   }
1916 
1917   function baseTokenURI() public view returns(string memory) {
1918     return _baseTokenURI;
1919   }
1920 
1921   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1922     _baseTokenURI = baseURI;
1923   }
1924 
1925   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1926     return ownershipOf(tokenId);
1927   }
1928 }
1929 
1930 
1931   
1932 // File: contracts/PixilbearsContract.sol
1933 //SPDX-License-Identifier: MIT
1934 
1935 pragma solidity ^0.8.0;
1936 
1937 contract PixilbearsContract is RamppERC721A {
1938     constructor() RamppERC721A("pixil bears", "plb"){}
1939 }
1940   
1941 //*********************************************************************//
1942 //*********************************************************************//  
1943 //                       Mintplex v2.1.0
1944 //
1945 //         This smart contract was generated by mintplex.xyz.
1946 //            Mintplex allows creators like you to launch 
1947 //             large scale NFT communities without code!
1948 //
1949 //    Mintplex is not responsible for the content of this contract and
1950 //        hopes it is being used in a responsible and kind way.  
1951 //       Mintplex is not associated or affiliated with this project.                                                    
1952 //             Twitter: @MintplexNFT ---- mintplex.xyz
1953 //*********************************************************************//                                                     
1954 //*********************************************************************//