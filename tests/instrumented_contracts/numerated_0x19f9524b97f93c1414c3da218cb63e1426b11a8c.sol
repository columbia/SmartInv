1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _________  ___  _____ ______   _______  _________  ________  ________  ___       ___       ________      
5 // |\___   ___|\  \|\   _ \  _   \|\  ___ \|\___   ___|\   __  \|\   __  \|\  \     |\  \     |\   ____\     
6 // \|___ \  \_\ \  \ \  \\\__\ \  \ \   __/\|___ \  \_\ \  \|\  \ \  \|\  \ \  \    \ \  \    \ \  \___|_    
7 //      \ \  \ \ \  \ \  \\|__| \  \ \  \_|/__  \ \  \ \ \   _  _\ \  \\\  \ \  \    \ \  \    \ \_____  \   
8 //       \ \  \ \ \  \ \  \    \ \  \ \  \_|\ \  \ \  \ \ \  \\  \\ \  \\\  \ \  \____\ \  \____\|____|\  \  
9 //        \ \__\ \ \__\ \__\    \ \__\ \_______\  \ \__\ \ \__\\ _\\ \_______\ \_______\ \_______\____\_\  \ 
10 //         \|__|  \|__|\|__|     \|__|\|_______|   \|__|  \|__|\|__|\|_______|\|_______|\|_______|\_________\
11 //                                                                                               \|_________|
12 //                                                                                                           
13 //                                                                                                           
14 //                                                        
15 //
16 //*********************************************************************//
17 //*********************************************************************//
18   
19 //-------------DEPENDENCIES--------------------------//
20 
21 // File: @openzeppelin/contracts/utils/Address.sol
22 
23 
24 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
25 
26 pragma solidity ^0.8.1;
27 
28 /**
29  * @dev Collection of functions related to the address type
30  */
31 library Address {
32     /**
33      * @dev Returns true if account is a contract.
34      *
35      * [IMPORTANT]
36      * ====
37      * It is unsafe to assume that an address for which this function returns
38      * false is an externally-owned account (EOA) and not a contract.
39      *
40      * Among others, isContract will return false for the following
41      * types of addresses:
42      *
43      *  - an externally-owned account
44      *  - a contract in construction
45      *  - an address where a contract will be created
46      *  - an address where a contract lived, but was destroyed
47      * ====
48      *
49      * [IMPORTANT]
50      * ====
51      * You shouldn't rely on isContract to protect against flash loan attacks!
52      *
53      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
54      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
55      * constructor.
56      * ====
57      */
58     function isContract(address account) internal view returns (bool) {
59         // This method relies on extcodesize/address.code.length, which returns 0
60         // for contracts in construction, since the code is only stored at the end
61         // of the constructor execution.
62 
63         return account.code.length > 0;
64     }
65 
66     /**
67      * @dev Replacement for Solidity's transfer: sends amount wei to
68      * recipient, forwarding all available gas and reverting on errors.
69      *
70      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
71      * of certain opcodes, possibly making contracts go over the 2300 gas limit
72      * imposed by transfer, making them unable to receive funds via
73      * transfer. {sendValue} removes this limitation.
74      *
75      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
76      *
77      * IMPORTANT: because control is transferred to recipient, care must be
78      * taken to not create reentrancy vulnerabilities. Consider using
79      * {ReentrancyGuard} or the
80      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
81      */
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         (bool success, ) = recipient.call{value: amount}("");
86         require(success, "Address: unable to send value, recipient may have reverted");
87     }
88 
89     /**
90      * @dev Performs a Solidity function call using a low level call. A
91      * plain call is an unsafe replacement for a function call: use this
92      * function instead.
93      *
94      * If target reverts with a revert reason, it is bubbled up by this
95      * function (like regular Solidity function calls).
96      *
97      * Returns the raw returned data. To convert to the expected return value,
98      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
99      *
100      * Requirements:
101      *
102      * - target must be a contract.
103      * - calling target with data must not revert.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
113      * errorMessage as a fallback revert reason when target reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCall(
118         address target,
119         bytes memory data,
120         string memory errorMessage
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, 0, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
127      * but also transferring value wei to target.
128      *
129      * Requirements:
130      *
131      * - the calling contract must have an ETH balance of at least value.
132      * - the called Solidity function must be payable.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value
140     ) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
146      * with errorMessage as a fallback revert reason when target reverts.
147      *
148      * _Available since v3.1._
149      */
150     function functionCallWithValue(
151         address target,
152         bytes memory data,
153         uint256 value,
154         string memory errorMessage
155     ) internal returns (bytes memory) {
156         require(address(this).balance >= value, "Address: insufficient balance for call");
157         require(isContract(target), "Address: call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.call{value: value}(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
170         return functionStaticCall(target, data, "Address: low-level static call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
175      * but performing a static call.
176      *
177      * _Available since v3.3._
178      */
179     function functionStaticCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal view returns (bytes memory) {
184         require(isContract(target), "Address: static call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.staticcall(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
192      * but performing a delegate call.
193      *
194      * _Available since v3.4._
195      */
196     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
197         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
202      * but performing a delegate call.
203      *
204      * _Available since v3.4._
205      */
206     function functionDelegateCall(
207         address target,
208         bytes memory data,
209         string memory errorMessage
210     ) internal returns (bytes memory) {
211         require(isContract(target), "Address: delegate call to non-contract");
212 
213         (bool success, bytes memory returndata) = target.delegatecall(data);
214         return verifyCallResult(success, returndata, errorMessage);
215     }
216 
217     /**
218      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
219      * revert reason using the provided one.
220      *
221      * _Available since v4.3._
222      */
223     function verifyCallResult(
224         bool success,
225         bytes memory returndata,
226         string memory errorMessage
227     ) internal pure returns (bytes memory) {
228         if (success) {
229             return returndata;
230         } else {
231             // Look for revert reason and bubble it up if present
232             if (returndata.length > 0) {
233                 // The easiest way to bubble the revert reason is using memory via assembly
234 
235                 assembly {
236                     let returndata_size := mload(returndata)
237                     revert(add(32, returndata), returndata_size)
238                 }
239             } else {
240                 revert(errorMessage);
241             }
242         }
243     }
244 }
245 
246 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 /**
254  * @title ERC721 token receiver interface
255  * @dev Interface for any contract that wants to support safeTransfers
256  * from ERC721 asset contracts.
257  */
258 interface IERC721Receiver {
259     /**
260      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
261      * by operator from from, this function is called.
262      *
263      * It must return its Solidity selector to confirm the token transfer.
264      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
265      *
266      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
267      */
268     function onERC721Received(
269         address operator,
270         address from,
271         uint256 tokenId,
272         bytes calldata data
273     ) external returns (bytes4);
274 }
275 
276 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
277 
278 
279 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Interface of the ERC165 standard, as defined in the
285  * https://eips.ethereum.org/EIPS/eip-165[EIP].
286  *
287  * Implementers can declare support of contract interfaces, which can then be
288  * queried by others ({ERC165Checker}).
289  *
290  * For an implementation, see {ERC165}.
291  */
292 interface IERC165 {
293     /**
294      * @dev Returns true if this contract implements the interface defined by
295      * interfaceId. See the corresponding
296      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
297      * to learn more about how these ids are created.
298      *
299      * This function call must use less than 30 000 gas.
300      */
301     function supportsInterface(bytes4 interfaceId) external view returns (bool);
302 }
303 
304 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 
312 /**
313  * @dev Implementation of the {IERC165} interface.
314  *
315  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
316  * for the additional interface id that will be supported. For example:
317  *
318  * solidity
319  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
320  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
321  * }
322  * 
323  *
324  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
325  */
326 abstract contract ERC165 is IERC165 {
327     /**
328      * @dev See {IERC165-supportsInterface}.
329      */
330     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331         return interfaceId == type(IERC165).interfaceId;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 
343 /**
344  * @dev Required interface of an ERC721 compliant contract.
345  */
346 interface IERC721 is IERC165 {
347     /**
348      * @dev Emitted when tokenId token is transferred from from to to.
349      */
350     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
351 
352     /**
353      * @dev Emitted when owner enables approved to manage the tokenId token.
354      */
355     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
359      */
360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
361 
362     /**
363      * @dev Returns the number of tokens in owner's account.
364      */
365     function balanceOf(address owner) external view returns (uint256 balance);
366 
367     /**
368      * @dev Returns the owner of the tokenId token.
369      *
370      * Requirements:
371      *
372      * - tokenId must exist.
373      */
374     function ownerOf(uint256 tokenId) external view returns (address owner);
375 
376     /**
377      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - from cannot be the zero address.
383      * - to cannot be the zero address.
384      * - tokenId token must exist and be owned by from.
385      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers tokenId token from from to to.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - from cannot be the zero address.
404      * - to cannot be the zero address.
405      * - tokenId token must be owned by from.
406      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to to to transfer tokenId token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - tokenId must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Returns the account approved for tokenId token.
433      *
434      * Requirements:
435      *
436      * - tokenId must exist.
437      */
438     function getApproved(uint256 tokenId) external view returns (address operator);
439 
440     /**
441      * @dev Approve or remove operator as an operator for the caller.
442      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
443      *
444      * Requirements:
445      *
446      * - The operator cannot be the caller.
447      *
448      * Emits an {ApprovalForAll} event.
449      */
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     /**
453      * @dev Returns if the operator is allowed to manage all of the assets of owner.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     /**
460      * @dev Safely transfers tokenId token from from to to.
461      *
462      * Requirements:
463      *
464      * - from cannot be the zero address.
465      * - to cannot be the zero address.
466      * - tokenId token must exist and be owned by from.
467      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
468      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
469      *
470      * Emits a {Transfer} event.
471      */
472     function safeTransferFrom(
473         address from,
474         address to,
475         uint256 tokenId,
476         bytes calldata data
477     ) external;
478 }
479 
480 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
481 
482 
483 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
490  * @dev See https://eips.ethereum.org/EIPS/eip-721
491  */
492 interface IERC721Enumerable is IERC721 {
493     /**
494      * @dev Returns the total amount of tokens stored by the contract.
495      */
496     function totalSupply() external view returns (uint256);
497 
498     /**
499      * @dev Returns a token ID owned by owner at a given index of its token list.
500      * Use along with {balanceOf} to enumerate all of owner's tokens.
501      */
502     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
503 
504     /**
505      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
506      * Use along with {totalSupply} to enumerate all tokens.
507      */
508     function tokenByIndex(uint256 index) external view returns (uint256);
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
521  * @dev See https://eips.ethereum.org/EIPS/eip-721
522  */
523 interface IERC721Metadata is IERC721 {
524     /**
525      * @dev Returns the token collection name.
526      */
527     function name() external view returns (string memory);
528 
529     /**
530      * @dev Returns the token collection symbol.
531      */
532     function symbol() external view returns (string memory);
533 
534     /**
535      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
536      */
537     function tokenURI(uint256 tokenId) external view returns (string memory);
538 }
539 
540 // File: @openzeppelin/contracts/utils/Strings.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev String operations.
549  */
550 library Strings {
551     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
552 
553     /**
554      * @dev Converts a uint256 to its ASCII string decimal representation.
555      */
556     function toString(uint256 value) internal pure returns (string memory) {
557         // Inspired by OraclizeAPI's implementation - MIT licence
558         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
559 
560         if (value == 0) {
561             return "0";
562         }
563         uint256 temp = value;
564         uint256 digits;
565         while (temp != 0) {
566             digits++;
567             temp /= 10;
568         }
569         bytes memory buffer = new bytes(digits);
570         while (value != 0) {
571             digits -= 1;
572             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
573             value /= 10;
574         }
575         return string(buffer);
576     }
577 
578     /**
579      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
580      */
581     function toHexString(uint256 value) internal pure returns (string memory) {
582         if (value == 0) {
583             return "0x00";
584         }
585         uint256 temp = value;
586         uint256 length = 0;
587         while (temp != 0) {
588             length++;
589             temp >>= 8;
590         }
591         return toHexString(value, length);
592     }
593 
594     /**
595      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
596      */
597     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
598         bytes memory buffer = new bytes(2 * length + 2);
599         buffer[0] = "0";
600         buffer[1] = "x";
601         for (uint256 i = 2 * length + 1; i > 1; --i) {
602             buffer[i] = _HEX_SYMBOLS[value & 0xf];
603             value >>= 4;
604         }
605         require(value == 0, "Strings: hex length insufficient");
606         return string(buffer);
607     }
608 }
609 
610 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev Contract module that helps prevent reentrant calls to a function.
619  *
620  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
621  * available, which can be applied to functions to make sure there are no nested
622  * (reentrant) calls to them.
623  *
624  * Note that because there is a single nonReentrant guard, functions marked as
625  * nonReentrant may not call one another. This can be worked around by making
626  * those functions private, and then adding external nonReentrant entry
627  * points to them.
628  *
629  * TIP: If you would like to learn more about reentrancy and alternative ways
630  * to protect against it, check out our blog post
631  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
632  */
633 abstract contract ReentrancyGuard {
634     // Booleans are more expensive than uint256 or any type that takes up a full
635     // word because each write operation emits an extra SLOAD to first read the
636     // slot's contents, replace the bits taken up by the boolean, and then write
637     // back. This is the compiler's defense against contract upgrades and
638     // pointer aliasing, and it cannot be disabled.
639 
640     // The values being non-zero value makes deployment a bit more expensive,
641     // but in exchange the refund on every call to nonReentrant will be lower in
642     // amount. Since refunds are capped to a percentage of the total
643     // transaction's gas, it is best to keep them low in cases like this one, to
644     // increase the likelihood of the full refund coming into effect.
645     uint256 private constant _NOT_ENTERED = 1;
646     uint256 private constant _ENTERED = 2;
647 
648     uint256 private _status;
649 
650     constructor() {
651         _status = _NOT_ENTERED;
652     }
653 
654     /**
655      * @dev Prevents a contract from calling itself, directly or indirectly.
656      * Calling a nonReentrant function from another nonReentrant
657      * function is not supported. It is possible to prevent this from happening
658      * by making the nonReentrant function external, and making it call a
659      * private function that does the actual work.
660      */
661     modifier nonReentrant() {
662         // On the first call to nonReentrant, _notEntered will be true
663         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
664 
665         // Any calls to nonReentrant after this point will fail
666         _status = _ENTERED;
667 
668         _;
669 
670         // By storing the original value once again, a refund is triggered (see
671         // https://eips.ethereum.org/EIPS/eip-2200)
672         _status = _NOT_ENTERED;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/utils/Context.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Provides information about the current execution context, including the
685  * sender of the transaction and its data. While these are generally available
686  * via msg.sender and msg.data, they should not be accessed in such a direct
687  * manner, since when dealing with meta-transactions the account sending and
688  * paying for execution may not be the actual sender (as far as an application
689  * is concerned).
690  *
691  * This contract is only required for intermediate, library-like contracts.
692  */
693 abstract contract Context {
694     function _msgSender() internal view virtual returns (address) {
695         return msg.sender;
696     }
697 
698     function _msgData() internal view virtual returns (bytes calldata) {
699         return msg.data;
700     }
701 }
702 
703 // File: @openzeppelin/contracts/access/Ownable.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 /**
712  * @dev Contract module which provides a basic access control mechanism, where
713  * there is an account (an owner) that can be granted exclusive access to
714  * specific functions.
715  *
716  * By default, the owner account will be the one that deploys the contract. This
717  * can later be changed with {transferOwnership}.
718  *
719  * This module is used through inheritance. It will make available the modifier
720  * onlyOwner, which can be applied to your functions to restrict their use to
721  * the owner.
722  */
723 abstract contract Ownable is Context {
724     address private _owner;
725 
726     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
727 
728     /**
729      * @dev Initializes the contract setting the deployer as the initial owner.
730      */
731     constructor() {
732         _transferOwnership(_msgSender());
733     }
734 
735     /**
736      * @dev Returns the address of the current owner.
737      */
738     function owner() public view virtual returns (address) {
739         return _owner;
740     }
741 
742     /**
743      * @dev Throws if called by any account other than the owner.
744      */
745     function _onlyOwner() private view {
746        require(owner() == _msgSender(), "Ownable: caller is not the owner");
747     }
748 
749     modifier onlyOwner() {
750         _onlyOwner();
751         _;
752     }
753 
754     /**
755      * @dev Leaves the contract without owner. It will not be possible to call
756      * onlyOwner functions anymore. Can only be called by the current owner.
757      *
758      * NOTE: Renouncing ownership will leave the contract without an owner,
759      * thereby removing any functionality that is only available to the owner.
760      */
761     function renounceOwnership() public virtual onlyOwner {
762         _transferOwnership(address(0));
763     }
764 
765     /**
766      * @dev Transfers ownership of the contract to a new account (newOwner).
767      * Can only be called by the current owner.
768      */
769     function transferOwnership(address newOwner) public virtual onlyOwner {
770         require(newOwner != address(0), "Ownable: new owner is the zero address");
771         _transferOwnership(newOwner);
772     }
773 
774     /**
775      * @dev Transfers ownership of the contract to a new account (newOwner).
776      * Internal function without access restriction.
777      */
778     function _transferOwnership(address newOwner) internal virtual {
779         address oldOwner = _owner;
780         _owner = newOwner;
781         emit OwnershipTransferred(oldOwner, newOwner);
782     }
783 }
784 
785 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
786 pragma solidity ^0.8.9;
787 
788 interface IOperatorFilterRegistry {
789     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
790     function register(address registrant) external;
791     function registerAndSubscribe(address registrant, address subscription) external;
792     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
793     function updateOperator(address registrant, address operator, bool filtered) external;
794     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
795     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
796     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
797     function subscribe(address registrant, address registrantToSubscribe) external;
798     function unsubscribe(address registrant, bool copyExistingEntries) external;
799     function subscriptionOf(address addr) external returns (address registrant);
800     function subscribers(address registrant) external returns (address[] memory);
801     function subscriberAt(address registrant, uint256 index) external returns (address);
802     function copyEntriesOf(address registrant, address registrantToCopy) external;
803     function isOperatorFiltered(address registrant, address operator) external returns (bool);
804     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
805     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
806     function filteredOperators(address addr) external returns (address[] memory);
807     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
808     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
809     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
810     function isRegistered(address addr) external returns (bool);
811     function codeHashOf(address addr) external returns (bytes32);
812 }
813 
814 // File contracts/OperatorFilter/OperatorFilterer.sol
815 pragma solidity ^0.8.9;
816 
817 abstract contract OperatorFilterer {
818     error OperatorNotAllowed(address operator);
819 
820     IOperatorFilterRegistry constant operatorFilterRegistry =
821         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
822 
823     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
824         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
825         // will not revert, but the contract will need to be registered with the registry once it is deployed in
826         // order for the modifier to filter addresses.
827         if (address(operatorFilterRegistry).code.length > 0) {
828             if (subscribe) {
829                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
830             } else {
831                 if (subscriptionOrRegistrantToCopy != address(0)) {
832                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
833                 } else {
834                     operatorFilterRegistry.register(address(this));
835                 }
836             }
837         }
838     }
839 
840     function _onlyAllowedOperator(address from) private view {
841       if (
842           !(
843               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
844               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
845           )
846       ) {
847           revert OperatorNotAllowed(msg.sender);
848       }
849     }
850 
851     modifier onlyAllowedOperator(address from) virtual {
852         // Check registry code length to facilitate testing in environments without a deployed registry.
853         if (address(operatorFilterRegistry).code.length > 0) {
854             // Allow spending tokens from addresses with balance
855             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
856             // from an EOA.
857             if (from == msg.sender) {
858                 _;
859                 return;
860             }
861             _onlyAllowedOperator(from);
862         }
863         _;
864     }
865 
866     modifier onlyAllowedOperatorApproval(address operator) virtual {
867         _checkFilterOperator(operator);
868         _;
869     }
870 
871     function _checkFilterOperator(address operator) internal view virtual {
872         // Check registry code length to facilitate testing in environments without a deployed registry.
873         if (address(operatorFilterRegistry).code.length > 0) {
874             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
875                 revert OperatorNotAllowed(operator);
876             }
877         }
878     }
879 }
880 
881 //-------------END DEPENDENCIES------------------------//
882 
883 
884   
885 error TransactionCapExceeded();
886 error PublicMintingClosed();
887 error ExcessiveOwnedMints();
888 error MintZeroQuantity();
889 error InvalidPayment();
890 error CapExceeded();
891 error IsAlreadyUnveiled();
892 error ValueCannotBeZero();
893 error CannotBeNullAddress();
894 error NoStateChange();
895 
896 error PublicMintClosed();
897 error AllowlistMintClosed();
898 
899 error AddressNotAllowlisted();
900 error AllowlistDropTimeHasNotPassed();
901 error PublicDropTimeHasNotPassed();
902 error DropTimeNotInFuture();
903 
904 error OnlyERC20MintingEnabled();
905 error ERC20TokenNotApproved();
906 error ERC20InsufficientBalance();
907 error ERC20InsufficientAllowance();
908 error ERC20TransferFailed();
909 
910 error ClaimModeDisabled();
911 error IneligibleRedemptionContract();
912 error TokenAlreadyRedeemed();
913 error InvalidOwnerForRedemption();
914 error InvalidApprovalForRedemption();
915 
916 error ERC721RestrictedApprovalAddressRestricted();
917 error NotMaintainer();
918   
919   
920 // Rampp Contracts v2.1 (Teams.sol)
921 
922 error InvalidTeamAddress();
923 error DuplicateTeamAddress();
924 pragma solidity ^0.8.0;
925 
926 /**
927 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
928 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
929 * This will easily allow cross-collaboration via Mintplex.xyz.
930 **/
931 abstract contract Teams is Ownable{
932   mapping (address => bool) internal team;
933 
934   /**
935   * @dev Adds an address to the team. Allows them to execute protected functions
936   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
937   **/
938   function addToTeam(address _address) public onlyOwner {
939     if(_address == address(0)) revert InvalidTeamAddress();
940     if(inTeam(_address)) revert DuplicateTeamAddress();
941   
942     team[_address] = true;
943   }
944 
945   /**
946   * @dev Removes an address to the team.
947   * @param _address the ETH address to remove, cannot be 0x and must be in team
948   **/
949   function removeFromTeam(address _address) public onlyOwner {
950     if(_address == address(0)) revert InvalidTeamAddress();
951     if(!inTeam(_address)) revert InvalidTeamAddress();
952   
953     team[_address] = false;
954   }
955 
956   /**
957   * @dev Check if an address is valid and active in the team
958   * @param _address ETH address to check for truthiness
959   **/
960   function inTeam(address _address)
961     public
962     view
963     returns (bool)
964   {
965     if(_address == address(0)) revert InvalidTeamAddress();
966     return team[_address] == true;
967   }
968 
969   /**
970   * @dev Throws if called by any account other than the owner or team member.
971   */
972   function _onlyTeamOrOwner() private view {
973     bool _isOwner = owner() == _msgSender();
974     bool _isTeam = inTeam(_msgSender());
975     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
976   }
977 
978   modifier onlyTeamOrOwner() {
979     _onlyTeamOrOwner();
980     _;
981   }
982 }
983 
984 
985   
986   pragma solidity ^0.8.0;
987 
988   /**
989   * @dev These functions deal with verification of Merkle Trees proofs.
990   *
991   * The proofs can be generated using the JavaScript library
992   * https://github.com/miguelmota/merkletreejs[merkletreejs].
993   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
994   *
995   *
996   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
997   * hashing, or use a hash function other than keccak256 for hashing leaves.
998   * This is because the concatenation of a sorted pair of internal nodes in
999   * the merkle tree could be reinterpreted as a leaf value.
1000   */
1001   library MerkleProof {
1002       /**
1003       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1004       * defined by 'root'. For this, a 'proof' must be provided, containing
1005       * sibling hashes on the branch from the leaf to the root of the tree. Each
1006       * pair of leaves and each pair of pre-images are assumed to be sorted.
1007       */
1008       function verify(
1009           bytes32[] memory proof,
1010           bytes32 root,
1011           bytes32 leaf
1012       ) internal pure returns (bool) {
1013           return processProof(proof, leaf) == root;
1014       }
1015 
1016       /**
1017       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1018       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1019       * hash matches the root of the tree. When processing the proof, the pairs
1020       * of leafs & pre-images are assumed to be sorted.
1021       *
1022       * _Available since v4.4._
1023       */
1024       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1025           bytes32 computedHash = leaf;
1026           for (uint256 i = 0; i < proof.length; i++) {
1027               bytes32 proofElement = proof[i];
1028               if (computedHash <= proofElement) {
1029                   // Hash(current computed hash + current element of the proof)
1030                   computedHash = _efficientHash(computedHash, proofElement);
1031               } else {
1032                   // Hash(current element of the proof + current computed hash)
1033                   computedHash = _efficientHash(proofElement, computedHash);
1034               }
1035           }
1036           return computedHash;
1037       }
1038 
1039       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1040           assembly {
1041               mstore(0x00, a)
1042               mstore(0x20, b)
1043               value := keccak256(0x00, 0x40)
1044           }
1045       }
1046   }
1047 
1048 
1049   // File: Allowlist.sol
1050 
1051   pragma solidity ^0.8.0;
1052 
1053   abstract contract Allowlist is Teams {
1054     bytes32 public merkleRoot;
1055     bool public onlyAllowlistMode = false;
1056 
1057     /**
1058      * @dev Update merkle root to reflect changes in Allowlist
1059      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1060      */
1061     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1062       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1063       merkleRoot = _newMerkleRoot;
1064     }
1065 
1066     /**
1067      * @dev Check the proof of an address if valid for merkle root
1068      * @param _to address to check for proof
1069      * @param _merkleProof Proof of the address to validate against root and leaf
1070      */
1071     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1072       if(merkleRoot == 0) revert ValueCannotBeZero();
1073       bytes32 leaf = keccak256(abi.encodePacked(_to));
1074 
1075       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1076     }
1077 
1078     
1079     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1080       onlyAllowlistMode = true;
1081     }
1082 
1083     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1084         onlyAllowlistMode = false;
1085     }
1086   }
1087   
1088   
1089 /**
1090  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1091  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1092  *
1093  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1094  * 
1095  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1096  *
1097  * Does not support burning tokens to address(0).
1098  */
1099 contract ERC721A is
1100   Context,
1101   ERC165,
1102   IERC721,
1103   IERC721Metadata,
1104   IERC721Enumerable,
1105   Teams
1106   , OperatorFilterer
1107 {
1108   using Address for address;
1109   using Strings for uint256;
1110 
1111   struct TokenOwnership {
1112     address addr;
1113     uint64 startTimestamp;
1114   }
1115 
1116   struct AddressData {
1117     uint128 balance;
1118     uint128 numberMinted;
1119   }
1120 
1121   uint256 private currentIndex;
1122 
1123   uint256 public immutable collectionSize;
1124   uint256 public maxBatchSize;
1125 
1126   // Token name
1127   string private _name;
1128 
1129   // Token symbol
1130   string private _symbol;
1131 
1132   // Mapping from token ID to ownership details
1133   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1134   mapping(uint256 => TokenOwnership) private _ownerships;
1135 
1136   // Mapping owner address to address data
1137   mapping(address => AddressData) private _addressData;
1138 
1139   // Mapping from token ID to approved address
1140   mapping(uint256 => address) private _tokenApprovals;
1141 
1142   // Mapping from owner to operator approvals
1143   mapping(address => mapping(address => bool)) private _operatorApprovals;
1144 
1145   /* @dev Mapping of restricted operator approvals set by contract Owner
1146   * This serves as an optional addition to ERC-721 so
1147   * that the contract owner can elect to prevent specific addresses/contracts
1148   * from being marked as the approver for a token. The reason for this
1149   * is that some projects may want to retain control of where their tokens can/can not be listed
1150   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1151   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1152   */
1153   mapping(address => bool) public restrictedApprovalAddresses;
1154 
1155   /**
1156    * @dev
1157    * maxBatchSize refers to how much a minter can mint at a time.
1158    * collectionSize_ refers to how many tokens are in the collection.
1159    */
1160   constructor(
1161     string memory name_,
1162     string memory symbol_,
1163     uint256 maxBatchSize_,
1164     uint256 collectionSize_
1165   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1166     require(
1167       collectionSize_ > 0,
1168       "ERC721A: collection must have a nonzero supply"
1169     );
1170     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1171     _name = name_;
1172     _symbol = symbol_;
1173     maxBatchSize = maxBatchSize_;
1174     collectionSize = collectionSize_;
1175     currentIndex = _startTokenId();
1176   }
1177 
1178   /**
1179   * To change the starting tokenId, please override this function.
1180   */
1181   function _startTokenId() internal view virtual returns (uint256) {
1182     return 1;
1183   }
1184 
1185   /**
1186    * @dev See {IERC721Enumerable-totalSupply}.
1187    */
1188   function totalSupply() public view override returns (uint256) {
1189     return _totalMinted();
1190   }
1191 
1192   function currentTokenId() public view returns (uint256) {
1193     return _totalMinted();
1194   }
1195 
1196   function getNextTokenId() public view returns (uint256) {
1197       return _totalMinted() + 1;
1198   }
1199 
1200   /**
1201   * Returns the total amount of tokens minted in the contract.
1202   */
1203   function _totalMinted() internal view returns (uint256) {
1204     unchecked {
1205       return currentIndex - _startTokenId();
1206     }
1207   }
1208 
1209   /**
1210    * @dev See {IERC721Enumerable-tokenByIndex}.
1211    */
1212   function tokenByIndex(uint256 index) public view override returns (uint256) {
1213     require(index < totalSupply(), "ERC721A: global index out of bounds");
1214     return index;
1215   }
1216 
1217   /**
1218    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1219    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1220    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1221    */
1222   function tokenOfOwnerByIndex(address owner, uint256 index)
1223     public
1224     view
1225     override
1226     returns (uint256)
1227   {
1228     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1229     uint256 numMintedSoFar = totalSupply();
1230     uint256 tokenIdsIdx = 0;
1231     address currOwnershipAddr = address(0);
1232     for (uint256 i = 0; i < numMintedSoFar; i++) {
1233       TokenOwnership memory ownership = _ownerships[i];
1234       if (ownership.addr != address(0)) {
1235         currOwnershipAddr = ownership.addr;
1236       }
1237       if (currOwnershipAddr == owner) {
1238         if (tokenIdsIdx == index) {
1239           return i;
1240         }
1241         tokenIdsIdx++;
1242       }
1243     }
1244     revert("ERC721A: unable to get token of owner by index");
1245   }
1246 
1247   /**
1248    * @dev See {IERC165-supportsInterface}.
1249    */
1250   function supportsInterface(bytes4 interfaceId)
1251     public
1252     view
1253     virtual
1254     override(ERC165, IERC165)
1255     returns (bool)
1256   {
1257     return
1258       interfaceId == type(IERC721).interfaceId ||
1259       interfaceId == type(IERC721Metadata).interfaceId ||
1260       interfaceId == type(IERC721Enumerable).interfaceId ||
1261       super.supportsInterface(interfaceId);
1262   }
1263 
1264   /**
1265    * @dev See {IERC721-balanceOf}.
1266    */
1267   function balanceOf(address owner) public view override returns (uint256) {
1268     require(owner != address(0), "ERC721A: balance query for the zero address");
1269     return uint256(_addressData[owner].balance);
1270   }
1271 
1272   function _numberMinted(address owner) internal view returns (uint256) {
1273     require(
1274       owner != address(0),
1275       "ERC721A: number minted query for the zero address"
1276     );
1277     return uint256(_addressData[owner].numberMinted);
1278   }
1279 
1280   function ownershipOf(uint256 tokenId)
1281     internal
1282     view
1283     returns (TokenOwnership memory)
1284   {
1285     uint256 curr = tokenId;
1286 
1287     unchecked {
1288         if (_startTokenId() <= curr && curr < currentIndex) {
1289             TokenOwnership memory ownership = _ownerships[curr];
1290             if (ownership.addr != address(0)) {
1291                 return ownership;
1292             }
1293 
1294             // Invariant:
1295             // There will always be an ownership that has an address and is not burned
1296             // before an ownership that does not have an address and is not burned.
1297             // Hence, curr will not underflow.
1298             while (true) {
1299                 curr--;
1300                 ownership = _ownerships[curr];
1301                 if (ownership.addr != address(0)) {
1302                     return ownership;
1303                 }
1304             }
1305         }
1306     }
1307 
1308     revert("ERC721A: unable to determine the owner of token");
1309   }
1310 
1311   /**
1312    * @dev See {IERC721-ownerOf}.
1313    */
1314   function ownerOf(uint256 tokenId) public view override returns (address) {
1315     return ownershipOf(tokenId).addr;
1316   }
1317 
1318   /**
1319    * @dev See {IERC721Metadata-name}.
1320    */
1321   function name() public view virtual override returns (string memory) {
1322     return _name;
1323   }
1324 
1325   /**
1326    * @dev See {IERC721Metadata-symbol}.
1327    */
1328   function symbol() public view virtual override returns (string memory) {
1329     return _symbol;
1330   }
1331 
1332   /**
1333    * @dev See {IERC721Metadata-tokenURI}.
1334    */
1335   function tokenURI(uint256 tokenId)
1336     public
1337     view
1338     virtual
1339     override
1340     returns (string memory)
1341   {
1342     string memory baseURI = _baseURI();
1343     string memory extension = _baseURIExtension();
1344     return
1345       bytes(baseURI).length > 0
1346         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1347         : "";
1348   }
1349 
1350   /**
1351    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1352    * token will be the concatenation of the baseURI and the tokenId. Empty
1353    * by default, can be overriden in child contracts.
1354    */
1355   function _baseURI() internal view virtual returns (string memory) {
1356     return "";
1357   }
1358 
1359   /**
1360    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1361    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1362    * by default, can be overriden in child contracts.
1363    */
1364   function _baseURIExtension() internal view virtual returns (string memory) {
1365     return "";
1366   }
1367 
1368   /**
1369    * @dev Sets the value for an address to be in the restricted approval address pool.
1370    * Setting an address to true will disable token owners from being able to mark the address
1371    * for approval for trading. This would be used in theory to prevent token owners from listing
1372    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1373    * @param _address the marketplace/user to modify restriction status of
1374    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1375    */
1376   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1377     restrictedApprovalAddresses[_address] = _isRestricted;
1378   }
1379 
1380   /**
1381    * @dev See {IERC721-approve}.
1382    */
1383   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1384     address owner = ERC721A.ownerOf(tokenId);
1385     require(to != owner, "ERC721A: approval to current owner");
1386     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1387 
1388     require(
1389       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1390       "ERC721A: approve caller is not owner nor approved for all"
1391     );
1392 
1393     _approve(to, tokenId, owner);
1394   }
1395 
1396   /**
1397    * @dev See {IERC721-getApproved}.
1398    */
1399   function getApproved(uint256 tokenId) public view override returns (address) {
1400     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1401 
1402     return _tokenApprovals[tokenId];
1403   }
1404 
1405   /**
1406    * @dev See {IERC721-setApprovalForAll}.
1407    */
1408   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1409     require(operator != _msgSender(), "ERC721A: approve to caller");
1410     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1411 
1412     _operatorApprovals[_msgSender()][operator] = approved;
1413     emit ApprovalForAll(_msgSender(), operator, approved);
1414   }
1415 
1416   /**
1417    * @dev See {IERC721-isApprovedForAll}.
1418    */
1419   function isApprovedForAll(address owner, address operator)
1420     public
1421     view
1422     virtual
1423     override
1424     returns (bool)
1425   {
1426     return _operatorApprovals[owner][operator];
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-transferFrom}.
1431    */
1432   function transferFrom(
1433     address from,
1434     address to,
1435     uint256 tokenId
1436   ) public override onlyAllowedOperator(from) {
1437     _transfer(from, to, tokenId);
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-safeTransferFrom}.
1442    */
1443   function safeTransferFrom(
1444     address from,
1445     address to,
1446     uint256 tokenId
1447   ) public override onlyAllowedOperator(from) {
1448     safeTransferFrom(from, to, tokenId, "");
1449   }
1450 
1451   /**
1452    * @dev See {IERC721-safeTransferFrom}.
1453    */
1454   function safeTransferFrom(
1455     address from,
1456     address to,
1457     uint256 tokenId,
1458     bytes memory _data
1459   ) public override onlyAllowedOperator(from) {
1460     _transfer(from, to, tokenId);
1461     require(
1462       _checkOnERC721Received(from, to, tokenId, _data),
1463       "ERC721A: transfer to non ERC721Receiver implementer"
1464     );
1465   }
1466 
1467   /**
1468    * @dev Returns whether tokenId exists.
1469    *
1470    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1471    *
1472    * Tokens start existing when they are minted (_mint),
1473    */
1474   function _exists(uint256 tokenId) internal view returns (bool) {
1475     return _startTokenId() <= tokenId && tokenId < currentIndex;
1476   }
1477 
1478   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1479     _safeMint(to, quantity, isAdminMint, "");
1480   }
1481 
1482   /**
1483    * @dev Mints quantity tokens and transfers them to to.
1484    *
1485    * Requirements:
1486    *
1487    * - there must be quantity tokens remaining unminted in the total collection.
1488    * - to cannot be the zero address.
1489    * - quantity cannot be larger than the max batch size.
1490    *
1491    * Emits a {Transfer} event.
1492    */
1493   function _safeMint(
1494     address to,
1495     uint256 quantity,
1496     bool isAdminMint,
1497     bytes memory _data
1498   ) internal {
1499     uint256 startTokenId = currentIndex;
1500     require(to != address(0), "ERC721A: mint to the zero address");
1501     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1502     require(!_exists(startTokenId), "ERC721A: token already minted");
1503 
1504     // For admin mints we do not want to enforce the maxBatchSize limit
1505     if (isAdminMint == false) {
1506         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1507     }
1508 
1509     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1510 
1511     AddressData memory addressData = _addressData[to];
1512     _addressData[to] = AddressData(
1513       addressData.balance + uint128(quantity),
1514       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1515     );
1516     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1517 
1518     uint256 updatedIndex = startTokenId;
1519 
1520     for (uint256 i = 0; i < quantity; i++) {
1521       emit Transfer(address(0), to, updatedIndex);
1522       require(
1523         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1524         "ERC721A: transfer to non ERC721Receiver implementer"
1525       );
1526       updatedIndex++;
1527     }
1528 
1529     currentIndex = updatedIndex;
1530     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1531   }
1532 
1533   /**
1534    * @dev Transfers tokenId from from to to.
1535    *
1536    * Requirements:
1537    *
1538    * - to cannot be the zero address.
1539    * - tokenId token must be owned by from.
1540    *
1541    * Emits a {Transfer} event.
1542    */
1543   function _transfer(
1544     address from,
1545     address to,
1546     uint256 tokenId
1547   ) private {
1548     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1549 
1550     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1551       getApproved(tokenId) == _msgSender() ||
1552       isApprovedForAll(prevOwnership.addr, _msgSender()));
1553 
1554     require(
1555       isApprovedOrOwner,
1556       "ERC721A: transfer caller is not owner nor approved"
1557     );
1558 
1559     require(
1560       prevOwnership.addr == from,
1561       "ERC721A: transfer from incorrect owner"
1562     );
1563     require(to != address(0), "ERC721A: transfer to the zero address");
1564 
1565     _beforeTokenTransfers(from, to, tokenId, 1);
1566 
1567     // Clear approvals from the previous owner
1568     _approve(address(0), tokenId, prevOwnership.addr);
1569 
1570     _addressData[from].balance -= 1;
1571     _addressData[to].balance += 1;
1572     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1573 
1574     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1575     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1576     uint256 nextTokenId = tokenId + 1;
1577     if (_ownerships[nextTokenId].addr == address(0)) {
1578       if (_exists(nextTokenId)) {
1579         _ownerships[nextTokenId] = TokenOwnership(
1580           prevOwnership.addr,
1581           prevOwnership.startTimestamp
1582         );
1583       }
1584     }
1585 
1586     emit Transfer(from, to, tokenId);
1587     _afterTokenTransfers(from, to, tokenId, 1);
1588   }
1589 
1590   /**
1591    * @dev Approve to to operate on tokenId
1592    *
1593    * Emits a {Approval} event.
1594    */
1595   function _approve(
1596     address to,
1597     uint256 tokenId,
1598     address owner
1599   ) private {
1600     _tokenApprovals[tokenId] = to;
1601     emit Approval(owner, to, tokenId);
1602   }
1603 
1604   uint256 public nextOwnerToExplicitlySet = 0;
1605 
1606   /**
1607    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1608    */
1609   function _setOwnersExplicit(uint256 quantity) internal {
1610     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1611     require(quantity > 0, "quantity must be nonzero");
1612     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1613 
1614     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1615     if (endIndex > collectionSize - 1) {
1616       endIndex = collectionSize - 1;
1617     }
1618     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1619     require(_exists(endIndex), "not enough minted yet for this cleanup");
1620     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1621       if (_ownerships[i].addr == address(0)) {
1622         TokenOwnership memory ownership = ownershipOf(i);
1623         _ownerships[i] = TokenOwnership(
1624           ownership.addr,
1625           ownership.startTimestamp
1626         );
1627       }
1628     }
1629     nextOwnerToExplicitlySet = endIndex + 1;
1630   }
1631 
1632   /**
1633    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1634    * The call is not executed if the target address is not a contract.
1635    *
1636    * @param from address representing the previous owner of the given token ID
1637    * @param to target address that will receive the tokens
1638    * @param tokenId uint256 ID of the token to be transferred
1639    * @param _data bytes optional data to send along with the call
1640    * @return bool whether the call correctly returned the expected magic value
1641    */
1642   function _checkOnERC721Received(
1643     address from,
1644     address to,
1645     uint256 tokenId,
1646     bytes memory _data
1647   ) private returns (bool) {
1648     if (to.isContract()) {
1649       try
1650         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1651       returns (bytes4 retval) {
1652         return retval == IERC721Receiver(to).onERC721Received.selector;
1653       } catch (bytes memory reason) {
1654         if (reason.length == 0) {
1655           revert("ERC721A: transfer to non ERC721Receiver implementer");
1656         } else {
1657           assembly {
1658             revert(add(32, reason), mload(reason))
1659           }
1660         }
1661       }
1662     } else {
1663       return true;
1664     }
1665   }
1666 
1667   /**
1668    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1669    *
1670    * startTokenId - the first token id to be transferred
1671    * quantity - the amount to be transferred
1672    *
1673    * Calling conditions:
1674    *
1675    * - When from and to are both non-zero, from's tokenId will be
1676    * transferred to to.
1677    * - When from is zero, tokenId will be minted for to.
1678    */
1679   function _beforeTokenTransfers(
1680     address from,
1681     address to,
1682     uint256 startTokenId,
1683     uint256 quantity
1684   ) internal virtual {}
1685 
1686   /**
1687    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1688    * minting.
1689    *
1690    * startTokenId - the first token id to be transferred
1691    * quantity - the amount to be transferred
1692    *
1693    * Calling conditions:
1694    *
1695    * - when from and to are both non-zero.
1696    * - from and to are never both zero.
1697    */
1698   function _afterTokenTransfers(
1699     address from,
1700     address to,
1701     uint256 startTokenId,
1702     uint256 quantity
1703   ) internal virtual {}
1704 }
1705 
1706 abstract contract ProviderFees is Context {
1707   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1708   uint256 public PROVIDER_FEE = 0.000777 ether;  
1709 
1710   function sendProviderFee() internal {
1711     payable(PROVIDER).transfer(PROVIDER_FEE);
1712   }
1713 
1714   function setProviderFee(uint256 _fee) public {
1715     if(_msgSender() != PROVIDER) revert NotMaintainer();
1716     PROVIDER_FEE = _fee;
1717   }
1718 }
1719 
1720 
1721 
1722   
1723   
1724 interface IERC20 {
1725   function allowance(address owner, address spender) external view returns (uint256);
1726   function transfer(address _to, uint256 _amount) external returns (bool);
1727   function balanceOf(address account) external view returns (uint256);
1728   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1729 }
1730 
1731 // File: WithdrawableV2
1732 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1733 // ERC-20 Payouts are limited to a single payout address. This feature 
1734 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1735 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1736 abstract contract WithdrawableV2 is Teams {
1737   struct acceptedERC20 {
1738     bool isActive;
1739     uint256 chargeAmount;
1740   }
1741 
1742   
1743   mapping(address => acceptedERC20) private allowedTokenContracts;
1744   address[] public payableAddresses = [0xbeCd35f4d30FA0e083A44497211efd9E3C0b0b1E];
1745   address public erc20Payable = 0xbeCd35f4d30FA0e083A44497211efd9E3C0b0b1E;
1746   uint256[] public payableFees = [100];
1747   uint256 public payableAddressCount = 1;
1748   bool public onlyERC20MintingMode;
1749   
1750 
1751   function withdrawAll() public onlyTeamOrOwner {
1752       if(address(this).balance == 0) revert ValueCannotBeZero();
1753       _withdrawAll(address(this).balance);
1754   }
1755 
1756   function _withdrawAll(uint256 balance) private {
1757       for(uint i=0; i < payableAddressCount; i++ ) {
1758           _widthdraw(
1759               payableAddresses[i],
1760               (balance * payableFees[i]) / 100
1761           );
1762       }
1763   }
1764   
1765   function _widthdraw(address _address, uint256 _amount) private {
1766       (bool success, ) = _address.call{value: _amount}("");
1767       require(success, "Transfer failed.");
1768   }
1769 
1770   /**
1771   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1772   * in the event ERC-20 tokens are paid to the contract for mints.
1773   * @param _tokenContract contract of ERC-20 token to withdraw
1774   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1775   */
1776   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1777     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1778     IERC20 tokenContract = IERC20(_tokenContract);
1779     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1780     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1781   }
1782 
1783   /**
1784   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1785   * @param _erc20TokenContract address of ERC-20 contract in question
1786   */
1787   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1788     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1789   }
1790 
1791   /**
1792   * @dev get the value of tokens to transfer for user of an ERC-20
1793   * @param _erc20TokenContract address of ERC-20 contract in question
1794   */
1795   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1796     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1797     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1798   }
1799 
1800   /**
1801   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1802   * @param _erc20TokenContract address of ERC-20 contract in question
1803   * @param _isActive default status of if contract should be allowed to accept payments
1804   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1805   */
1806   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1807     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1808     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1809   }
1810 
1811   /**
1812   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1813   * it will assume the default value of zero. This should not be used to create new payment tokens.
1814   * @param _erc20TokenContract address of ERC-20 contract in question
1815   */
1816   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1817     allowedTokenContracts[_erc20TokenContract].isActive = true;
1818   }
1819 
1820   /**
1821   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1822   * it will assume the default value of zero. This should not be used to create new payment tokens.
1823   * @param _erc20TokenContract address of ERC-20 contract in question
1824   */
1825   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1826     allowedTokenContracts[_erc20TokenContract].isActive = false;
1827   }
1828 
1829   /**
1830   * @dev Enable only ERC-20 payments for minting on this contract
1831   */
1832   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1833     onlyERC20MintingMode = true;
1834   }
1835 
1836   /**
1837   * @dev Disable only ERC-20 payments for minting on this contract
1838   */
1839   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1840     onlyERC20MintingMode = false;
1841   }
1842 
1843   /**
1844   * @dev Set the payout of the ERC-20 token payout to a specific address
1845   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1846   */
1847   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1848     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1849     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1850     erc20Payable = _newErc20Payable;
1851   }
1852 }
1853 
1854 
1855   
1856   
1857 /* File: Tippable.sol
1858 /* @dev Allows owner to set strict enforcement of payment to mint price.
1859 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1860 /* when doing a free mint with opt-in pricing.
1861 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1862 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1863 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1864 /* Pros - can take in gratituity payments during a mint. 
1865 /* Cons - However if you decrease pricing during mint txn settlement 
1866 /* it can result in mints landing who technically now have overpaid.
1867 */
1868 abstract contract Tippable is Teams {
1869   bool public strictPricing = true;
1870 
1871   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1872     strictPricing = _newStatus;
1873   }
1874 
1875   // @dev check if msg.value is correct according to pricing enforcement
1876   // @param _msgValue -> passed in msg.value of tx
1877   // @param _expectedPrice -> result of getPrice(...args)
1878   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1879     return strictPricing ? 
1880       _msgValue == _expectedPrice : 
1881       _msgValue >= _expectedPrice;
1882   }
1883 }
1884 
1885   
1886   
1887 // File: EarlyMintIncentive.sol
1888 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1889 // zero fee that can be calculated on the fly.
1890 abstract contract EarlyMintIncentive is Teams, ERC721A, ProviderFees {
1891   uint256 public PRICE = 0.0069 ether;
1892   uint256 public EARLY_MINT_PRICE = 0 ether;
1893   uint256 public earlyMintOwnershipCap = 1;
1894   bool public usingEarlyMintIncentive = true;
1895 
1896   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1897     usingEarlyMintIncentive = true;
1898   }
1899 
1900   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1901     usingEarlyMintIncentive = false;
1902   }
1903 
1904   /**
1905   * @dev Set the max token ID in which the cost incentive will be applied.
1906   * @param _newCap max number of tokens wallet may mint for incentive price
1907   */
1908   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1909     if(_newCap == 0) revert ValueCannotBeZero();
1910     earlyMintOwnershipCap = _newCap;
1911   }
1912 
1913   /**
1914   * @dev Set the incentive mint price
1915   * @param _feeInWei new price per token when in incentive range
1916   */
1917   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1918     EARLY_MINT_PRICE = _feeInWei;
1919   }
1920 
1921   /**
1922   * @dev Set the primary mint price - the base price when not under incentive
1923   * @param _feeInWei new price per token
1924   */
1925   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1926     PRICE = _feeInWei;
1927   }
1928 
1929   /**
1930   * @dev Get the correct price for the mint for qty and person minting
1931   * @param _count amount of tokens to calc for mint
1932   * @param _to the address which will be minting these tokens, passed explicitly
1933   */
1934   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1935     if(_count == 0) revert ValueCannotBeZero();
1936 
1937     // short circuit function if we dont need to even calc incentive pricing
1938     // short circuit if the current wallet mint qty is also already over cap
1939     if(
1940       usingEarlyMintIncentive == false ||
1941       _numberMinted(_to) > earlyMintOwnershipCap
1942     ) {
1943       return (PRICE * _count) + PROVIDER_FEE;
1944     }
1945 
1946     uint256 endingTokenQty = _numberMinted(_to) + _count;
1947     // If qty to mint results in a final qty less than or equal to the cap then
1948     // the entire qty is within incentive mint.
1949     if(endingTokenQty  <= earlyMintOwnershipCap) {
1950       return (EARLY_MINT_PRICE * _count) + PROVIDER_FEE;
1951     }
1952 
1953     // If the current token qty is less than the incentive cap
1954     // and the ending token qty is greater than the incentive cap
1955     // we will be straddling the cap so there will be some amount
1956     // that are incentive and some that are regular fee.
1957     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1958     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1959 
1960     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount) + PROVIDER_FEE;
1961   }
1962 }
1963 
1964   
1965 abstract contract ERC721APlus is 
1966     Ownable,
1967     Teams,
1968     ERC721A,
1969     WithdrawableV2,
1970     ReentrancyGuard 
1971     , EarlyMintIncentive, Tippable 
1972     , Allowlist 
1973     
1974 {
1975   constructor(
1976     string memory tokenName,
1977     string memory tokenSymbol
1978   ) ERC721A(tokenName, tokenSymbol, 20, 10000) { }
1979     uint8 constant public CONTRACT_VERSION = 2;
1980     string public _baseTokenURI = "ipfs://bafybeidmtq7zhbtn57lsyqzqgwylklnfad3uwdqly65tatypmji6hnmjom/";
1981     string public _baseTokenExtension = ".json";
1982 
1983     bool public mintingOpen = false;
1984     bool public isRevealed;
1985     
1986     uint256 public MAX_WALLET_MINTS = 100;
1987 
1988   
1989     /////////////// Admin Mint Functions
1990     /**
1991      * @dev Mints a token to an address with a tokenURI.
1992      * This is owner only and allows a fee-free drop
1993      * @param _to address of the future owner of the token
1994      * @param _qty amount of tokens to drop the owner
1995      */
1996      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1997          if(_qty == 0) revert MintZeroQuantity();
1998          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1999          _safeMint(_to, _qty, true);
2000      }
2001 
2002   
2003     /////////////// PUBLIC MINT FUNCTIONS
2004     /**
2005     * @dev Mints tokens to an address in batch.
2006     * fee may or may not be required*
2007     * @param _to address of the future owner of the token
2008     * @param _amount number of tokens to mint
2009     */
2010     function mintToMultiple(address _to, uint256 _amount) public payable {
2011         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2012         if(_amount == 0) revert MintZeroQuantity();
2013         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2014         if(!mintingOpen) revert PublicMintClosed();
2015         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2016         
2017         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2018         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2019         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
2020         sendProviderFee();
2021         _safeMint(_to, _amount, false);
2022     }
2023 
2024     /**
2025      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2026      * fee may or may not be required*
2027      * @param _to address of the future owner of the token
2028      * @param _amount number of tokens to mint
2029      * @param _erc20TokenContract erc-20 token contract to mint with
2030      */
2031     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2032       if(_amount == 0) revert MintZeroQuantity();
2033       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2034       if(!mintingOpen) revert PublicMintClosed();
2035       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2036       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2037       
2038       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2039       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2040 
2041       // ERC-20 Specific pre-flight checks
2042       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2043       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2044       IERC20 payableToken = IERC20(_erc20TokenContract);
2045 
2046       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2047       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2048 
2049       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2050       if(!transferComplete) revert ERC20TransferFailed();
2051 
2052       sendProviderFee();
2053       _safeMint(_to, _amount, false);
2054     }
2055 
2056     function openMinting() public onlyTeamOrOwner {
2057         mintingOpen = true;
2058     }
2059 
2060     function stopMinting() public onlyTeamOrOwner {
2061         mintingOpen = false;
2062     }
2063 
2064   
2065     ///////////// ALLOWLIST MINTING FUNCTIONS
2066     /**
2067     * @dev Mints tokens to an address using an allowlist.
2068     * fee may or may not be required*
2069     * @param _to address of the future owner of the token
2070     * @param _amount number of tokens to mint
2071     * @param _merkleProof merkle proof array
2072     */
2073     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2074         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2075         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2076         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2077         if(_amount == 0) revert MintZeroQuantity();
2078         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2079         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2080         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2081         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
2082         
2083 
2084         sendProviderFee();
2085         _safeMint(_to, _amount, false);
2086     }
2087 
2088     /**
2089     * @dev Mints tokens to an address using an allowlist.
2090     * fee may or may not be required*
2091     * @param _to address of the future owner of the token
2092     * @param _amount number of tokens to mint
2093     * @param _merkleProof merkle proof array
2094     * @param _erc20TokenContract erc-20 token contract to mint with
2095     */
2096     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2097       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2098       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2099       if(_amount == 0) revert MintZeroQuantity();
2100       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2101       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2102       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2103       
2104       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2105 
2106       // ERC-20 Specific pre-flight checks
2107       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2108       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2109       IERC20 payableToken = IERC20(_erc20TokenContract);
2110 
2111       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2112       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2113 
2114       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2115       if(!transferComplete) revert ERC20TransferFailed();
2116       
2117       sendProviderFee();
2118       _safeMint(_to, _amount, false);
2119     }
2120 
2121     /**
2122      * @dev Enable allowlist minting fully by enabling both flags
2123      * This is a convenience function for the Rampp user
2124      */
2125     function openAllowlistMint() public onlyTeamOrOwner {
2126         enableAllowlistOnlyMode();
2127         mintingOpen = true;
2128     }
2129 
2130     /**
2131      * @dev Close allowlist minting fully by disabling both flags
2132      * This is a convenience function for the Rampp user
2133      */
2134     function closeAllowlistMint() public onlyTeamOrOwner {
2135         disableAllowlistOnlyMode();
2136         mintingOpen = false;
2137     }
2138 
2139 
2140   
2141     /**
2142     * @dev Check if wallet over MAX_WALLET_MINTS
2143     * @param _address address in question to check if minted count exceeds max
2144     */
2145     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2146         if(_amount == 0) revert ValueCannotBeZero();
2147         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2148     }
2149 
2150     /**
2151     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2152     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2153     */
2154     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2155         if(_newWalletMax == 0) revert ValueCannotBeZero();
2156         MAX_WALLET_MINTS = _newWalletMax;
2157     }
2158     
2159 
2160   
2161     /**
2162      * @dev Allows owner to set Max mints per tx
2163      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2164      */
2165      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2166          if(_newMaxMint == 0) revert ValueCannotBeZero();
2167          maxBatchSize = _newMaxMint;
2168      }
2169     
2170 
2171   
2172     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2173         if(isRevealed) revert IsAlreadyUnveiled();
2174         _baseTokenURI = _updatedTokenURI;
2175         isRevealed = true;
2176     }
2177     
2178   
2179   
2180   function contractURI() public pure returns (string memory) {
2181     return "https://metadata.mintplex.xyz/AAnW6Huj6ZU75zahuDXG/contract-metadata";
2182   }
2183   
2184 
2185   function _baseURI() internal view virtual override returns(string memory) {
2186     return _baseTokenURI;
2187   }
2188 
2189   function _baseURIExtension() internal view virtual override returns(string memory) {
2190     return _baseTokenExtension;
2191   }
2192 
2193   function baseTokenURI() public view returns(string memory) {
2194     return _baseTokenURI;
2195   }
2196 
2197   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2198     _baseTokenURI = baseURI;
2199   }
2200 
2201   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2202     _baseTokenExtension = baseExtension;
2203   }
2204 }
2205 
2206 
2207   
2208 // File: contracts/TimeTrollsNftContract.sol
2209 //SPDX-License-Identifier: MIT
2210 
2211 pragma solidity ^0.8.0;
2212 
2213 contract TimeTrollsNftContract is ERC721APlus {
2214     constructor() ERC721APlus("TimeTrollsNFT", "TIME"){}
2215 }
2216   