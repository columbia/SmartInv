1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //   ________            _____ __        _ __    __    __         
6 //  /_  __/ /_  ___     / ___// /_______(_) /_  / /_  / /__  _____
7 //   / / / __ \/ _ \    \__ \/ //_/ ___/ / __ \/ __ \/ / _ \/ ___/
8 //  / / / / / /  __/   ___/ / ,< / /  / / /_/ / /_/ / /  __(__  ) 
9 // /_/ /_/ /_/\___/   /____/_/|_/_/  /_/_.___/_.___/_/\___/____/  
10 //                                                                
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
781   
782 /**
783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
784  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
785  *
786  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
787  * 
788  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
789  *
790  * Does not support burning tokens to address(0).
791  */
792 contract ERC721A is
793   Context,
794   ERC165,
795   IERC721,
796   IERC721Metadata,
797   IERC721Enumerable
798 {
799   using Address for address;
800   using Strings for uint256;
801 
802   struct TokenOwnership {
803     address addr;
804     uint64 startTimestamp;
805   }
806 
807   struct AddressData {
808     uint128 balance;
809     uint128 numberMinted;
810   }
811 
812   uint256 private currentIndex;
813 
814   uint256 public immutable collectionSize;
815   uint256 public maxBatchSize;
816 
817   // Token name
818   string private _name;
819 
820   // Token symbol
821   string private _symbol;
822 
823   // Mapping from token ID to ownership details
824   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
825   mapping(uint256 => TokenOwnership) private _ownerships;
826 
827   // Mapping owner address to address data
828   mapping(address => AddressData) private _addressData;
829 
830   // Mapping from token ID to approved address
831   mapping(uint256 => address) private _tokenApprovals;
832 
833   // Mapping from owner to operator approvals
834   mapping(address => mapping(address => bool)) private _operatorApprovals;
835 
836   /**
837    * @dev
838    * maxBatchSize refers to how much a minter can mint at a time.
839    * collectionSize_ refers to how many tokens are in the collection.
840    */
841   constructor(
842     string memory name_,
843     string memory symbol_,
844     uint256 maxBatchSize_,
845     uint256 collectionSize_
846   ) {
847     require(
848       collectionSize_ > 0,
849       "ERC721A: collection must have a nonzero supply"
850     );
851     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
852     _name = name_;
853     _symbol = symbol_;
854     maxBatchSize = maxBatchSize_;
855     collectionSize = collectionSize_;
856     currentIndex = _startTokenId();
857   }
858 
859   /**
860   * To change the starting tokenId, please override this function.
861   */
862   function _startTokenId() internal view virtual returns (uint256) {
863     return 1;
864   }
865 
866   /**
867    * @dev See {IERC721Enumerable-totalSupply}.
868    */
869   function totalSupply() public view override returns (uint256) {
870     return _totalMinted();
871   }
872 
873   function currentTokenId() public view returns (uint256) {
874     return _totalMinted();
875   }
876 
877   function getNextTokenId() public view returns (uint256) {
878       return _totalMinted() + 1;
879   }
880 
881   /**
882   * Returns the total amount of tokens minted in the contract.
883   */
884   function _totalMinted() internal view returns (uint256) {
885     unchecked {
886       return currentIndex - _startTokenId();
887     }
888   }
889 
890   /**
891    * @dev See {IERC721Enumerable-tokenByIndex}.
892    */
893   function tokenByIndex(uint256 index) public view override returns (uint256) {
894     require(index < totalSupply(), "ERC721A: global index out of bounds");
895     return index;
896   }
897 
898   /**
899    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
900    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
901    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
902    */
903   function tokenOfOwnerByIndex(address owner, uint256 index)
904     public
905     view
906     override
907     returns (uint256)
908   {
909     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
910     uint256 numMintedSoFar = totalSupply();
911     uint256 tokenIdsIdx = 0;
912     address currOwnershipAddr = address(0);
913     for (uint256 i = 0; i < numMintedSoFar; i++) {
914       TokenOwnership memory ownership = _ownerships[i];
915       if (ownership.addr != address(0)) {
916         currOwnershipAddr = ownership.addr;
917       }
918       if (currOwnershipAddr == owner) {
919         if (tokenIdsIdx == index) {
920           return i;
921         }
922         tokenIdsIdx++;
923       }
924     }
925     revert("ERC721A: unable to get token of owner by index");
926   }
927 
928   /**
929    * @dev See {IERC165-supportsInterface}.
930    */
931   function supportsInterface(bytes4 interfaceId)
932     public
933     view
934     virtual
935     override(ERC165, IERC165)
936     returns (bool)
937   {
938     return
939       interfaceId == type(IERC721).interfaceId ||
940       interfaceId == type(IERC721Metadata).interfaceId ||
941       interfaceId == type(IERC721Enumerable).interfaceId ||
942       super.supportsInterface(interfaceId);
943   }
944 
945   /**
946    * @dev See {IERC721-balanceOf}.
947    */
948   function balanceOf(address owner) public view override returns (uint256) {
949     require(owner != address(0), "ERC721A: balance query for the zero address");
950     return uint256(_addressData[owner].balance);
951   }
952 
953   function _numberMinted(address owner) internal view returns (uint256) {
954     require(
955       owner != address(0),
956       "ERC721A: number minted query for the zero address"
957     );
958     return uint256(_addressData[owner].numberMinted);
959   }
960 
961   function ownershipOf(uint256 tokenId)
962     internal
963     view
964     returns (TokenOwnership memory)
965   {
966     uint256 curr = tokenId;
967 
968     unchecked {
969         if (_startTokenId() <= curr && curr < currentIndex) {
970             TokenOwnership memory ownership = _ownerships[curr];
971             if (ownership.addr != address(0)) {
972                 return ownership;
973             }
974 
975             // Invariant:
976             // There will always be an ownership that has an address and is not burned
977             // before an ownership that does not have an address and is not burned.
978             // Hence, curr will not underflow.
979             while (true) {
980                 curr--;
981                 ownership = _ownerships[curr];
982                 if (ownership.addr != address(0)) {
983                     return ownership;
984                 }
985             }
986         }
987     }
988 
989     revert("ERC721A: unable to determine the owner of token");
990   }
991 
992   /**
993    * @dev See {IERC721-ownerOf}.
994    */
995   function ownerOf(uint256 tokenId) public view override returns (address) {
996     return ownershipOf(tokenId).addr;
997   }
998 
999   /**
1000    * @dev See {IERC721Metadata-name}.
1001    */
1002   function name() public view virtual override returns (string memory) {
1003     return _name;
1004   }
1005 
1006   /**
1007    * @dev See {IERC721Metadata-symbol}.
1008    */
1009   function symbol() public view virtual override returns (string memory) {
1010     return _symbol;
1011   }
1012 
1013   /**
1014    * @dev See {IERC721Metadata-tokenURI}.
1015    */
1016   function tokenURI(uint256 tokenId)
1017     public
1018     view
1019     virtual
1020     override
1021     returns (string memory)
1022   {
1023     string memory baseURI = _baseURI();
1024     return
1025       bytes(baseURI).length > 0
1026         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1027         : "";
1028   }
1029 
1030   /**
1031    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1032    * token will be the concatenation of the baseURI and the tokenId. Empty
1033    * by default, can be overriden in child contracts.
1034    */
1035   function _baseURI() internal view virtual returns (string memory) {
1036     return "";
1037   }
1038 
1039   /**
1040    * @dev See {IERC721-approve}.
1041    */
1042   function approve(address to, uint256 tokenId) public override {
1043     address owner = ERC721A.ownerOf(tokenId);
1044     require(to != owner, "ERC721A: approval to current owner");
1045 
1046     require(
1047       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1048       "ERC721A: approve caller is not owner nor approved for all"
1049     );
1050 
1051     _approve(to, tokenId, owner);
1052   }
1053 
1054   /**
1055    * @dev See {IERC721-getApproved}.
1056    */
1057   function getApproved(uint256 tokenId) public view override returns (address) {
1058     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1059 
1060     return _tokenApprovals[tokenId];
1061   }
1062 
1063   /**
1064    * @dev See {IERC721-setApprovalForAll}.
1065    */
1066   function setApprovalForAll(address operator, bool approved) public override {
1067     require(operator != _msgSender(), "ERC721A: approve to caller");
1068 
1069     _operatorApprovals[_msgSender()][operator] = approved;
1070     emit ApprovalForAll(_msgSender(), operator, approved);
1071   }
1072 
1073   /**
1074    * @dev See {IERC721-isApprovedForAll}.
1075    */
1076   function isApprovedForAll(address owner, address operator)
1077     public
1078     view
1079     virtual
1080     override
1081     returns (bool)
1082   {
1083     return _operatorApprovals[owner][operator];
1084   }
1085 
1086   /**
1087    * @dev See {IERC721-transferFrom}.
1088    */
1089   function transferFrom(
1090     address from,
1091     address to,
1092     uint256 tokenId
1093   ) public override {
1094     _transfer(from, to, tokenId);
1095   }
1096 
1097   /**
1098    * @dev See {IERC721-safeTransferFrom}.
1099    */
1100   function safeTransferFrom(
1101     address from,
1102     address to,
1103     uint256 tokenId
1104   ) public override {
1105     safeTransferFrom(from, to, tokenId, "");
1106   }
1107 
1108   /**
1109    * @dev See {IERC721-safeTransferFrom}.
1110    */
1111   function safeTransferFrom(
1112     address from,
1113     address to,
1114     uint256 tokenId,
1115     bytes memory _data
1116   ) public override {
1117     _transfer(from, to, tokenId);
1118     require(
1119       _checkOnERC721Received(from, to, tokenId, _data),
1120       "ERC721A: transfer to non ERC721Receiver implementer"
1121     );
1122   }
1123 
1124   /**
1125    * @dev Returns whether tokenId exists.
1126    *
1127    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1128    *
1129    * Tokens start existing when they are minted (_mint),
1130    */
1131   function _exists(uint256 tokenId) internal view returns (bool) {
1132     return _startTokenId() <= tokenId && tokenId < currentIndex;
1133   }
1134 
1135   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1136     _safeMint(to, quantity, isAdminMint, "");
1137   }
1138 
1139   /**
1140    * @dev Mints quantity tokens and transfers them to to.
1141    *
1142    * Requirements:
1143    *
1144    * - there must be quantity tokens remaining unminted in the total collection.
1145    * - to cannot be the zero address.
1146    * - quantity cannot be larger than the max batch size.
1147    *
1148    * Emits a {Transfer} event.
1149    */
1150   function _safeMint(
1151     address to,
1152     uint256 quantity,
1153     bool isAdminMint,
1154     bytes memory _data
1155   ) internal {
1156     uint256 startTokenId = currentIndex;
1157     require(to != address(0), "ERC721A: mint to the zero address");
1158     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1159     require(!_exists(startTokenId), "ERC721A: token already minted");
1160 
1161     // For admin mints we do not want to enforce the maxBatchSize limit
1162     if (isAdminMint == false) {
1163         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1164     }
1165 
1166     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1167 
1168     AddressData memory addressData = _addressData[to];
1169     _addressData[to] = AddressData(
1170       addressData.balance + uint128(quantity),
1171       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1172     );
1173     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1174 
1175     uint256 updatedIndex = startTokenId;
1176 
1177     for (uint256 i = 0; i < quantity; i++) {
1178       emit Transfer(address(0), to, updatedIndex);
1179       require(
1180         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1181         "ERC721A: transfer to non ERC721Receiver implementer"
1182       );
1183       updatedIndex++;
1184     }
1185 
1186     currentIndex = updatedIndex;
1187     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1188   }
1189 
1190   /**
1191    * @dev Transfers tokenId from from to to.
1192    *
1193    * Requirements:
1194    *
1195    * - to cannot be the zero address.
1196    * - tokenId token must be owned by from.
1197    *
1198    * Emits a {Transfer} event.
1199    */
1200   function _transfer(
1201     address from,
1202     address to,
1203     uint256 tokenId
1204   ) private {
1205     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1206 
1207     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1208       getApproved(tokenId) == _msgSender() ||
1209       isApprovedForAll(prevOwnership.addr, _msgSender()));
1210 
1211     require(
1212       isApprovedOrOwner,
1213       "ERC721A: transfer caller is not owner nor approved"
1214     );
1215 
1216     require(
1217       prevOwnership.addr == from,
1218       "ERC721A: transfer from incorrect owner"
1219     );
1220     require(to != address(0), "ERC721A: transfer to the zero address");
1221 
1222     _beforeTokenTransfers(from, to, tokenId, 1);
1223 
1224     // Clear approvals from the previous owner
1225     _approve(address(0), tokenId, prevOwnership.addr);
1226 
1227     _addressData[from].balance -= 1;
1228     _addressData[to].balance += 1;
1229     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1230 
1231     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1232     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1233     uint256 nextTokenId = tokenId + 1;
1234     if (_ownerships[nextTokenId].addr == address(0)) {
1235       if (_exists(nextTokenId)) {
1236         _ownerships[nextTokenId] = TokenOwnership(
1237           prevOwnership.addr,
1238           prevOwnership.startTimestamp
1239         );
1240       }
1241     }
1242 
1243     emit Transfer(from, to, tokenId);
1244     _afterTokenTransfers(from, to, tokenId, 1);
1245   }
1246 
1247   /**
1248    * @dev Approve to to operate on tokenId
1249    *
1250    * Emits a {Approval} event.
1251    */
1252   function _approve(
1253     address to,
1254     uint256 tokenId,
1255     address owner
1256   ) private {
1257     _tokenApprovals[tokenId] = to;
1258     emit Approval(owner, to, tokenId);
1259   }
1260 
1261   uint256 public nextOwnerToExplicitlySet = 0;
1262 
1263   /**
1264    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1265    */
1266   function _setOwnersExplicit(uint256 quantity) internal {
1267     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1268     require(quantity > 0, "quantity must be nonzero");
1269     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1270 
1271     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1272     if (endIndex > collectionSize - 1) {
1273       endIndex = collectionSize - 1;
1274     }
1275     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1276     require(_exists(endIndex), "not enough minted yet for this cleanup");
1277     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1278       if (_ownerships[i].addr == address(0)) {
1279         TokenOwnership memory ownership = ownershipOf(i);
1280         _ownerships[i] = TokenOwnership(
1281           ownership.addr,
1282           ownership.startTimestamp
1283         );
1284       }
1285     }
1286     nextOwnerToExplicitlySet = endIndex + 1;
1287   }
1288 
1289   /**
1290    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1291    * The call is not executed if the target address is not a contract.
1292    *
1293    * @param from address representing the previous owner of the given token ID
1294    * @param to target address that will receive the tokens
1295    * @param tokenId uint256 ID of the token to be transferred
1296    * @param _data bytes optional data to send along with the call
1297    * @return bool whether the call correctly returned the expected magic value
1298    */
1299   function _checkOnERC721Received(
1300     address from,
1301     address to,
1302     uint256 tokenId,
1303     bytes memory _data
1304   ) private returns (bool) {
1305     if (to.isContract()) {
1306       try
1307         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1308       returns (bytes4 retval) {
1309         return retval == IERC721Receiver(to).onERC721Received.selector;
1310       } catch (bytes memory reason) {
1311         if (reason.length == 0) {
1312           revert("ERC721A: transfer to non ERC721Receiver implementer");
1313         } else {
1314           assembly {
1315             revert(add(32, reason), mload(reason))
1316           }
1317         }
1318       }
1319     } else {
1320       return true;
1321     }
1322   }
1323 
1324   /**
1325    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1326    *
1327    * startTokenId - the first token id to be transferred
1328    * quantity - the amount to be transferred
1329    *
1330    * Calling conditions:
1331    *
1332    * - When from and to are both non-zero, from's tokenId will be
1333    * transferred to to.
1334    * - When from is zero, tokenId will be minted for to.
1335    */
1336   function _beforeTokenTransfers(
1337     address from,
1338     address to,
1339     uint256 startTokenId,
1340     uint256 quantity
1341   ) internal virtual {}
1342 
1343   /**
1344    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1345    * minting.
1346    *
1347    * startTokenId - the first token id to be transferred
1348    * quantity - the amount to be transferred
1349    *
1350    * Calling conditions:
1351    *
1352    * - when from and to are both non-zero.
1353    * - from and to are never both zero.
1354    */
1355   function _afterTokenTransfers(
1356     address from,
1357     address to,
1358     uint256 startTokenId,
1359     uint256 quantity
1360   ) internal virtual {}
1361 }
1362 
1363 
1364 
1365   
1366 abstract contract Ramppable {
1367   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1368 
1369   modifier isRampp() {
1370       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1371       _;
1372   }
1373 }
1374 
1375 
1376   
1377   
1378 interface IERC20 {
1379   function transfer(address _to, uint256 _amount) external returns (bool);
1380   function balanceOf(address account) external view returns (uint256);
1381 }
1382 
1383 abstract contract Withdrawable is Ownable, Ramppable {
1384   address[] public payableAddresses = [RAMPPADDRESS,0x2410711184Ef3C84f14882CCf1DF2CBbA9e04F85,0xEeeBC18ff570766588171Da525a92D66bFb563Ed];
1385   uint256[] public payableFees = [5,25,70];
1386   uint256 public payableAddressCount = 3;
1387 
1388   function withdrawAll() public onlyOwner {
1389       require(address(this).balance > 0);
1390       _withdrawAll();
1391   }
1392   
1393   function withdrawAllRampp() public isRampp {
1394       require(address(this).balance > 0);
1395       _withdrawAll();
1396   }
1397 
1398   function _withdrawAll() private {
1399       uint256 balance = address(this).balance;
1400       
1401       for(uint i=0; i < payableAddressCount; i++ ) {
1402           _widthdraw(
1403               payableAddresses[i],
1404               (balance * payableFees[i]) / 100
1405           );
1406       }
1407   }
1408   
1409   function _widthdraw(address _address, uint256 _amount) private {
1410       (bool success, ) = _address.call{value: _amount}("");
1411       require(success, "Transfer failed.");
1412   }
1413 
1414   /**
1415     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1416     * while still splitting royalty payments to all other team members.
1417     * in the event ERC-20 tokens are paid to the contract.
1418     * @param _tokenContract contract of ERC-20 token to withdraw
1419     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1420     */
1421   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1422     require(_amount > 0);
1423     IERC20 tokenContract = IERC20(_tokenContract);
1424     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1425 
1426     for(uint i=0; i < payableAddressCount; i++ ) {
1427         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1428     }
1429   }
1430 
1431   /**
1432   * @dev Allows Rampp wallet to update its own reference as well as update
1433   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1434   * and since Rampp is always the first address this function is limited to the rampp payout only.
1435   * @param _newAddress updated Rampp Address
1436   */
1437   function setRamppAddress(address _newAddress) public isRampp {
1438     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1439     RAMPPADDRESS = _newAddress;
1440     payableAddresses[0] = _newAddress;
1441   }
1442 }
1443 
1444 
1445   
1446 // File: isFeeable.sol
1447 abstract contract Feeable is Ownable {
1448   uint256 public PRICE = 0 ether;
1449 
1450   function setPrice(uint256 _feeInWei) public onlyOwner {
1451     PRICE = _feeInWei;
1452   }
1453 
1454   function getPrice(uint256 _count) public view returns (uint256) {
1455     return PRICE * _count;
1456   }
1457 }
1458 
1459   
1460   
1461 abstract contract RamppERC721A is 
1462     Ownable,
1463     ERC721A,
1464     Withdrawable,
1465     ReentrancyGuard 
1466     , Feeable 
1467      
1468     
1469 {
1470   constructor(
1471     string memory tokenName,
1472     string memory tokenSymbol
1473   ) ERC721A(tokenName, tokenSymbol, 3, 6969) { }
1474     uint8 public CONTRACT_VERSION = 2;
1475     string public _baseTokenURI = "ipfs://QmNtG6CoZkpmBc3WGHzhsc3LuBWo3TXTisckpmG3Q9PP6C/";
1476 
1477     bool public mintingOpen = false;
1478     
1479     
1480     uint256 public MAX_WALLET_MINTS = 3;
1481 
1482   
1483     /////////////// Admin Mint Functions
1484     /**
1485      * @dev Mints a token to an address with a tokenURI.
1486      * This is owner only and allows a fee-free drop
1487      * @param _to address of the future owner of the token
1488      * @param _qty amount of tokens to drop the owner
1489      */
1490      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1491          require(_qty > 0, "Must mint at least 1 token.");
1492          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 6969");
1493          _safeMint(_to, _qty, true);
1494      }
1495 
1496   
1497     /////////////// GENERIC MINT FUNCTIONS
1498     /**
1499     * @dev Mints a single token to an address.
1500     * fee may or may not be required*
1501     * @param _to address of the future owner of the token
1502     */
1503     function mintTo(address _to) public payable {
1504         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6969");
1505         require(mintingOpen == true, "Minting is not open right now!");
1506         
1507         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1508         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1509         
1510         _safeMint(_to, 1, false);
1511     }
1512 
1513     /**
1514     * @dev Mints a token to an address with a tokenURI.
1515     * fee may or may not be required*
1516     * @param _to address of the future owner of the token
1517     * @param _amount number of tokens to mint
1518     */
1519     function mintToMultiple(address _to, uint256 _amount) public payable {
1520         require(_amount >= 1, "Must mint at least 1 token");
1521         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1522         require(mintingOpen == true, "Minting is not open right now!");
1523         
1524         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1525         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6969");
1526         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1527 
1528         _safeMint(_to, _amount, false);
1529     }
1530 
1531     function openMinting() public onlyOwner {
1532         mintingOpen = true;
1533     }
1534 
1535     function stopMinting() public onlyOwner {
1536         mintingOpen = false;
1537     }
1538 
1539   
1540 
1541   
1542     /**
1543     * @dev Check if wallet over MAX_WALLET_MINTS
1544     * @param _address address in question to check if minted count exceeds max
1545     */
1546     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1547         require(_amount >= 1, "Amount must be greater than or equal to 1");
1548         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1549     }
1550 
1551     /**
1552     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1553     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1554     */
1555     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1556         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1557         MAX_WALLET_MINTS = _newWalletMax;
1558     }
1559     
1560 
1561   
1562     /**
1563      * @dev Allows owner to set Max mints per tx
1564      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1565      */
1566      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1567          require(_newMaxMint >= 1, "Max mint must be at least 1");
1568          maxBatchSize = _newMaxMint;
1569      }
1570     
1571 
1572   
1573 
1574   function _baseURI() internal view virtual override returns(string memory) {
1575     return _baseTokenURI;
1576   }
1577 
1578   function baseTokenURI() public view returns(string memory) {
1579     return _baseTokenURI;
1580   }
1581 
1582   function setBaseURI(string calldata baseURI) external onlyOwner {
1583     _baseTokenURI = baseURI;
1584   }
1585 
1586   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1587     return ownershipOf(tokenId);
1588   }
1589 }
1590 
1591 
1592   
1593 // File: contracts/TheSkribblesContract.sol
1594 //SPDX-License-Identifier: MIT
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 contract TheSkribblesContract is RamppERC721A {
1599     constructor() RamppERC721A("The Skribbles", "SKRIBBLE"){}
1600 }
1601   
1602 //*********************************************************************//
1603 //*********************************************************************//  
1604 //                       Rampp v2.0.1
1605 //
1606 //         This smart contract was generated by rampp.xyz.
1607 //            Rampp allows creators like you to launch 
1608 //             large scale NFT communities without code!
1609 //
1610 //    Rampp is not responsible for the content of this contract and
1611 //        hopes it is being used in a responsible and kind way.  
1612 //       Rampp is not associated or affiliated with this project.                                                    
1613 //             Twitter: @Rampp_ ---- rampp.xyz
1614 //*********************************************************************//                                                     
1615 //*********************************************************************// 
