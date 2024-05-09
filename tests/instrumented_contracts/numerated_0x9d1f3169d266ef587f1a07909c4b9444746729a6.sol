1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // $$$$$$$$\  $$$$$$\  $$\   $$\ $$$$$$$$\        $$$$$$\  $$$$$$$\  $$$$$$$$\  $$$$$$\  
5 // $$  _____|$$  __$$\ $$ | $$  |$$  _____|      $$  __$$\ $$  __$$\ $$  _____|$$  __$$\ 
6 // $$ |      $$ /  $$ |$$ |$$  / $$ |            $$ /  $$ |$$ |  $$ |$$ |      $$ /  \__|
7 // $$$$$\    $$$$$$$$ |$$$$$  /  $$$$$\          $$$$$$$$ |$$$$$$$  |$$$$$\    \$$$$$$\  
8 // $$  __|   $$  __$$ |$$  $$<   $$  __|         $$  __$$ |$$  ____/ $$  __|    \____$$\ 
9 // $$ |      $$ |  $$ |$$ |\$$\  $$ |            $$ |  $$ |$$ |      $$ |      $$\   $$ |
10 // $$ |      $$ |  $$ |$$ | \$$\ $$$$$$$$\       $$ |  $$ |$$ |      $$$$$$$$\ \$$$$$$  |
11 // \__|      \__|  \__|\__|  \__|\________|      \__|  \__|\__|      \________| \______/ 
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
745     modifier onlyOwner() {
746         require(owner() == _msgSender(), "Ownable: caller is not the owner");
747         _;
748     }
749 
750     /**
751      * @dev Leaves the contract without owner. It will not be possible to call
752      * onlyOwner functions anymore. Can only be called by the current owner.
753      *
754      * NOTE: Renouncing ownership will leave the contract without an owner,
755      * thereby removing any functionality that is only available to the owner.
756      */
757     function renounceOwnership() public virtual onlyOwner {
758         _transferOwnership(address(0));
759     }
760 
761     /**
762      * @dev Transfers ownership of the contract to a new account (newOwner).
763      * Can only be called by the current owner.
764      */
765     function transferOwnership(address newOwner) public virtual onlyOwner {
766         require(newOwner != address(0), "Ownable: new owner is the zero address");
767         _transferOwnership(newOwner);
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (newOwner).
772      * Internal function without access restriction.
773      */
774     function _transferOwnership(address newOwner) internal virtual {
775         address oldOwner = _owner;
776         _owner = newOwner;
777         emit OwnershipTransferred(oldOwner, newOwner);
778     }
779 }
780 //-------------END DEPENDENCIES------------------------//
781 
782 
783   
784 // Rampp Contracts v2.1 (Teams.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 /**
789 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
790 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
791 * This will easily allow cross-collaboration via Rampp.xyz.
792 **/
793 abstract contract Teams is Ownable{
794   mapping (address => bool) internal team;
795 
796   /**
797   * @dev Adds an address to the team. Allows them to execute protected functions
798   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
799   **/
800   function addToTeam(address _address) public onlyOwner {
801     require(_address != address(0), "Invalid address");
802     require(!inTeam(_address), "This address is already in your team.");
803   
804     team[_address] = true;
805   }
806 
807   /**
808   * @dev Removes an address to the team.
809   * @param _address the ETH address to remove, cannot be 0x and must be in team
810   **/
811   function removeFromTeam(address _address) public onlyOwner {
812     require(_address != address(0), "Invalid address");
813     require(inTeam(_address), "This address is not in your team currently.");
814   
815     team[_address] = false;
816   }
817 
818   /**
819   * @dev Check if an address is valid and active in the team
820   * @param _address ETH address to check for truthiness
821   **/
822   function inTeam(address _address)
823     public
824     view
825     returns (bool)
826   {
827     require(_address != address(0), "Invalid address to check.");
828     return team[_address] == true;
829   }
830 
831   /**
832   * @dev Throws if called by any account other than the owner or team member.
833   */
834   modifier onlyTeamOrOwner() {
835     bool _isOwner = owner() == _msgSender();
836     bool _isTeam = inTeam(_msgSender());
837     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
838     _;
839   }
840 }
841 
842 
843   
844   
845 /**
846  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
847  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
848  *
849  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
850  * 
851  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
852  *
853  * Does not support burning tokens to address(0).
854  */
855 contract ERC721A is
856   Context,
857   ERC165,
858   IERC721,
859   IERC721Metadata,
860   IERC721Enumerable
861 {
862   using Address for address;
863   using Strings for uint256;
864 
865   struct TokenOwnership {
866     address addr;
867     uint64 startTimestamp;
868   }
869 
870   struct AddressData {
871     uint128 balance;
872     uint128 numberMinted;
873   }
874 
875   uint256 private currentIndex;
876 
877   uint256 public immutable collectionSize;
878   uint256 public maxBatchSize;
879 
880   // Token name
881   string private _name;
882 
883   // Token symbol
884   string private _symbol;
885 
886   // Mapping from token ID to ownership details
887   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
888   mapping(uint256 => TokenOwnership) private _ownerships;
889 
890   // Mapping owner address to address data
891   mapping(address => AddressData) private _addressData;
892 
893   // Mapping from token ID to approved address
894   mapping(uint256 => address) private _tokenApprovals;
895 
896   // Mapping from owner to operator approvals
897   mapping(address => mapping(address => bool)) private _operatorApprovals;
898 
899   /**
900    * @dev
901    * maxBatchSize refers to how much a minter can mint at a time.
902    * collectionSize_ refers to how many tokens are in the collection.
903    */
904   constructor(
905     string memory name_,
906     string memory symbol_,
907     uint256 maxBatchSize_,
908     uint256 collectionSize_
909   ) {
910     require(
911       collectionSize_ > 0,
912       "ERC721A: collection must have a nonzero supply"
913     );
914     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
915     _name = name_;
916     _symbol = symbol_;
917     maxBatchSize = maxBatchSize_;
918     collectionSize = collectionSize_;
919     currentIndex = _startTokenId();
920   }
921 
922   /**
923   * To change the starting tokenId, please override this function.
924   */
925   function _startTokenId() internal view virtual returns (uint256) {
926     return 1;
927   }
928 
929   /**
930    * @dev See {IERC721Enumerable-totalSupply}.
931    */
932   function totalSupply() public view override returns (uint256) {
933     return _totalMinted();
934   }
935 
936   function currentTokenId() public view returns (uint256) {
937     return _totalMinted();
938   }
939 
940   function getNextTokenId() public view returns (uint256) {
941       return _totalMinted() + 1;
942   }
943 
944   /**
945   * Returns the total amount of tokens minted in the contract.
946   */
947   function _totalMinted() internal view returns (uint256) {
948     unchecked {
949       return currentIndex - _startTokenId();
950     }
951   }
952 
953   /**
954    * @dev See {IERC721Enumerable-tokenByIndex}.
955    */
956   function tokenByIndex(uint256 index) public view override returns (uint256) {
957     require(index < totalSupply(), "ERC721A: global index out of bounds");
958     return index;
959   }
960 
961   /**
962    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
963    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
964    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
965    */
966   function tokenOfOwnerByIndex(address owner, uint256 index)
967     public
968     view
969     override
970     returns (uint256)
971   {
972     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
973     uint256 numMintedSoFar = totalSupply();
974     uint256 tokenIdsIdx = 0;
975     address currOwnershipAddr = address(0);
976     for (uint256 i = 0; i < numMintedSoFar; i++) {
977       TokenOwnership memory ownership = _ownerships[i];
978       if (ownership.addr != address(0)) {
979         currOwnershipAddr = ownership.addr;
980       }
981       if (currOwnershipAddr == owner) {
982         if (tokenIdsIdx == index) {
983           return i;
984         }
985         tokenIdsIdx++;
986       }
987     }
988     revert("ERC721A: unable to get token of owner by index");
989   }
990 
991   /**
992    * @dev See {IERC165-supportsInterface}.
993    */
994   function supportsInterface(bytes4 interfaceId)
995     public
996     view
997     virtual
998     override(ERC165, IERC165)
999     returns (bool)
1000   {
1001     return
1002       interfaceId == type(IERC721).interfaceId ||
1003       interfaceId == type(IERC721Metadata).interfaceId ||
1004       interfaceId == type(IERC721Enumerable).interfaceId ||
1005       super.supportsInterface(interfaceId);
1006   }
1007 
1008   /**
1009    * @dev See {IERC721-balanceOf}.
1010    */
1011   function balanceOf(address owner) public view override returns (uint256) {
1012     require(owner != address(0), "ERC721A: balance query for the zero address");
1013     return uint256(_addressData[owner].balance);
1014   }
1015 
1016   function _numberMinted(address owner) internal view returns (uint256) {
1017     require(
1018       owner != address(0),
1019       "ERC721A: number minted query for the zero address"
1020     );
1021     return uint256(_addressData[owner].numberMinted);
1022   }
1023 
1024   function ownershipOf(uint256 tokenId)
1025     internal
1026     view
1027     returns (TokenOwnership memory)
1028   {
1029     uint256 curr = tokenId;
1030 
1031     unchecked {
1032         if (_startTokenId() <= curr && curr < currentIndex) {
1033             TokenOwnership memory ownership = _ownerships[curr];
1034             if (ownership.addr != address(0)) {
1035                 return ownership;
1036             }
1037 
1038             // Invariant:
1039             // There will always be an ownership that has an address and is not burned
1040             // before an ownership that does not have an address and is not burned.
1041             // Hence, curr will not underflow.
1042             while (true) {
1043                 curr--;
1044                 ownership = _ownerships[curr];
1045                 if (ownership.addr != address(0)) {
1046                     return ownership;
1047                 }
1048             }
1049         }
1050     }
1051 
1052     revert("ERC721A: unable to determine the owner of token");
1053   }
1054 
1055   /**
1056    * @dev See {IERC721-ownerOf}.
1057    */
1058   function ownerOf(uint256 tokenId) public view override returns (address) {
1059     return ownershipOf(tokenId).addr;
1060   }
1061 
1062   /**
1063    * @dev See {IERC721Metadata-name}.
1064    */
1065   function name() public view virtual override returns (string memory) {
1066     return _name;
1067   }
1068 
1069   /**
1070    * @dev See {IERC721Metadata-symbol}.
1071    */
1072   function symbol() public view virtual override returns (string memory) {
1073     return _symbol;
1074   }
1075 
1076   /**
1077    * @dev See {IERC721Metadata-tokenURI}.
1078    */
1079   function tokenURI(uint256 tokenId)
1080     public
1081     view
1082     virtual
1083     override
1084     returns (string memory)
1085   {
1086     string memory baseURI = _baseURI();
1087     return
1088       bytes(baseURI).length > 0
1089         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1090         : "";
1091   }
1092 
1093   /**
1094    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1095    * token will be the concatenation of the baseURI and the tokenId. Empty
1096    * by default, can be overriden in child contracts.
1097    */
1098   function _baseURI() internal view virtual returns (string memory) {
1099     return "";
1100   }
1101 
1102   /**
1103    * @dev See {IERC721-approve}.
1104    */
1105   function approve(address to, uint256 tokenId) public override {
1106     address owner = ERC721A.ownerOf(tokenId);
1107     require(to != owner, "ERC721A: approval to current owner");
1108 
1109     require(
1110       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1111       "ERC721A: approve caller is not owner nor approved for all"
1112     );
1113 
1114     _approve(to, tokenId, owner);
1115   }
1116 
1117   /**
1118    * @dev See {IERC721-getApproved}.
1119    */
1120   function getApproved(uint256 tokenId) public view override returns (address) {
1121     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1122 
1123     return _tokenApprovals[tokenId];
1124   }
1125 
1126   /**
1127    * @dev See {IERC721-setApprovalForAll}.
1128    */
1129   function setApprovalForAll(address operator, bool approved) public override {
1130     require(operator != _msgSender(), "ERC721A: approve to caller");
1131 
1132     _operatorApprovals[_msgSender()][operator] = approved;
1133     emit ApprovalForAll(_msgSender(), operator, approved);
1134   }
1135 
1136   /**
1137    * @dev See {IERC721-isApprovedForAll}.
1138    */
1139   function isApprovedForAll(address owner, address operator)
1140     public
1141     view
1142     virtual
1143     override
1144     returns (bool)
1145   {
1146     return _operatorApprovals[owner][operator];
1147   }
1148 
1149   /**
1150    * @dev See {IERC721-transferFrom}.
1151    */
1152   function transferFrom(
1153     address from,
1154     address to,
1155     uint256 tokenId
1156   ) public override {
1157     _transfer(from, to, tokenId);
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-safeTransferFrom}.
1162    */
1163   function safeTransferFrom(
1164     address from,
1165     address to,
1166     uint256 tokenId
1167   ) public override {
1168     safeTransferFrom(from, to, tokenId, "");
1169   }
1170 
1171   /**
1172    * @dev See {IERC721-safeTransferFrom}.
1173    */
1174   function safeTransferFrom(
1175     address from,
1176     address to,
1177     uint256 tokenId,
1178     bytes memory _data
1179   ) public override {
1180     _transfer(from, to, tokenId);
1181     require(
1182       _checkOnERC721Received(from, to, tokenId, _data),
1183       "ERC721A: transfer to non ERC721Receiver implementer"
1184     );
1185   }
1186 
1187   /**
1188    * @dev Returns whether tokenId exists.
1189    *
1190    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1191    *
1192    * Tokens start existing when they are minted (_mint),
1193    */
1194   function _exists(uint256 tokenId) internal view returns (bool) {
1195     return _startTokenId() <= tokenId && tokenId < currentIndex;
1196   }
1197 
1198   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1199     _safeMint(to, quantity, isAdminMint, "");
1200   }
1201 
1202   /**
1203    * @dev Mints quantity tokens and transfers them to to.
1204    *
1205    * Requirements:
1206    *
1207    * - there must be quantity tokens remaining unminted in the total collection.
1208    * - to cannot be the zero address.
1209    * - quantity cannot be larger than the max batch size.
1210    *
1211    * Emits a {Transfer} event.
1212    */
1213   function _safeMint(
1214     address to,
1215     uint256 quantity,
1216     bool isAdminMint,
1217     bytes memory _data
1218   ) internal {
1219     uint256 startTokenId = currentIndex;
1220     require(to != address(0), "ERC721A: mint to the zero address");
1221     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1222     require(!_exists(startTokenId), "ERC721A: token already minted");
1223 
1224     // For admin mints we do not want to enforce the maxBatchSize limit
1225     if (isAdminMint == false) {
1226         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1227     }
1228 
1229     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1230 
1231     AddressData memory addressData = _addressData[to];
1232     _addressData[to] = AddressData(
1233       addressData.balance + uint128(quantity),
1234       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1235     );
1236     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1237 
1238     uint256 updatedIndex = startTokenId;
1239 
1240     for (uint256 i = 0; i < quantity; i++) {
1241       emit Transfer(address(0), to, updatedIndex);
1242       require(
1243         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1244         "ERC721A: transfer to non ERC721Receiver implementer"
1245       );
1246       updatedIndex++;
1247     }
1248 
1249     currentIndex = updatedIndex;
1250     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1251   }
1252 
1253   /**
1254    * @dev Transfers tokenId from from to to.
1255    *
1256    * Requirements:
1257    *
1258    * - to cannot be the zero address.
1259    * - tokenId token must be owned by from.
1260    *
1261    * Emits a {Transfer} event.
1262    */
1263   function _transfer(
1264     address from,
1265     address to,
1266     uint256 tokenId
1267   ) private {
1268     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1269 
1270     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1271       getApproved(tokenId) == _msgSender() ||
1272       isApprovedForAll(prevOwnership.addr, _msgSender()));
1273 
1274     require(
1275       isApprovedOrOwner,
1276       "ERC721A: transfer caller is not owner nor approved"
1277     );
1278 
1279     require(
1280       prevOwnership.addr == from,
1281       "ERC721A: transfer from incorrect owner"
1282     );
1283     require(to != address(0), "ERC721A: transfer to the zero address");
1284 
1285     _beforeTokenTransfers(from, to, tokenId, 1);
1286 
1287     // Clear approvals from the previous owner
1288     _approve(address(0), tokenId, prevOwnership.addr);
1289 
1290     _addressData[from].balance -= 1;
1291     _addressData[to].balance += 1;
1292     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1293 
1294     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1295     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1296     uint256 nextTokenId = tokenId + 1;
1297     if (_ownerships[nextTokenId].addr == address(0)) {
1298       if (_exists(nextTokenId)) {
1299         _ownerships[nextTokenId] = TokenOwnership(
1300           prevOwnership.addr,
1301           prevOwnership.startTimestamp
1302         );
1303       }
1304     }
1305 
1306     emit Transfer(from, to, tokenId);
1307     _afterTokenTransfers(from, to, tokenId, 1);
1308   }
1309 
1310   /**
1311    * @dev Approve to to operate on tokenId
1312    *
1313    * Emits a {Approval} event.
1314    */
1315   function _approve(
1316     address to,
1317     uint256 tokenId,
1318     address owner
1319   ) private {
1320     _tokenApprovals[tokenId] = to;
1321     emit Approval(owner, to, tokenId);
1322   }
1323 
1324   uint256 public nextOwnerToExplicitlySet = 0;
1325 
1326   /**
1327    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1328    */
1329   function _setOwnersExplicit(uint256 quantity) internal {
1330     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1331     require(quantity > 0, "quantity must be nonzero");
1332     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1333 
1334     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1335     if (endIndex > collectionSize - 1) {
1336       endIndex = collectionSize - 1;
1337     }
1338     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1339     require(_exists(endIndex), "not enough minted yet for this cleanup");
1340     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1341       if (_ownerships[i].addr == address(0)) {
1342         TokenOwnership memory ownership = ownershipOf(i);
1343         _ownerships[i] = TokenOwnership(
1344           ownership.addr,
1345           ownership.startTimestamp
1346         );
1347       }
1348     }
1349     nextOwnerToExplicitlySet = endIndex + 1;
1350   }
1351 
1352   /**
1353    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1354    * The call is not executed if the target address is not a contract.
1355    *
1356    * @param from address representing the previous owner of the given token ID
1357    * @param to target address that will receive the tokens
1358    * @param tokenId uint256 ID of the token to be transferred
1359    * @param _data bytes optional data to send along with the call
1360    * @return bool whether the call correctly returned the expected magic value
1361    */
1362   function _checkOnERC721Received(
1363     address from,
1364     address to,
1365     uint256 tokenId,
1366     bytes memory _data
1367   ) private returns (bool) {
1368     if (to.isContract()) {
1369       try
1370         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1371       returns (bytes4 retval) {
1372         return retval == IERC721Receiver(to).onERC721Received.selector;
1373       } catch (bytes memory reason) {
1374         if (reason.length == 0) {
1375           revert("ERC721A: transfer to non ERC721Receiver implementer");
1376         } else {
1377           assembly {
1378             revert(add(32, reason), mload(reason))
1379           }
1380         }
1381       }
1382     } else {
1383       return true;
1384     }
1385   }
1386 
1387   /**
1388    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1389    *
1390    * startTokenId - the first token id to be transferred
1391    * quantity - the amount to be transferred
1392    *
1393    * Calling conditions:
1394    *
1395    * - When from and to are both non-zero, from's tokenId will be
1396    * transferred to to.
1397    * - When from is zero, tokenId will be minted for to.
1398    */
1399   function _beforeTokenTransfers(
1400     address from,
1401     address to,
1402     uint256 startTokenId,
1403     uint256 quantity
1404   ) internal virtual {}
1405 
1406   /**
1407    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1408    * minting.
1409    *
1410    * startTokenId - the first token id to be transferred
1411    * quantity - the amount to be transferred
1412    *
1413    * Calling conditions:
1414    *
1415    * - when from and to are both non-zero.
1416    * - from and to are never both zero.
1417    */
1418   function _afterTokenTransfers(
1419     address from,
1420     address to,
1421     uint256 startTokenId,
1422     uint256 quantity
1423   ) internal virtual {}
1424 }
1425 
1426 
1427 
1428   
1429 abstract contract Ramppable {
1430   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1431 
1432   modifier isRampp() {
1433       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1434       _;
1435   }
1436 }
1437 
1438 
1439   
1440   
1441 interface IERC20 {
1442   function transfer(address _to, uint256 _amount) external returns (bool);
1443   function balanceOf(address account) external view returns (uint256);
1444 }
1445 
1446 abstract contract Withdrawable is Teams, Ramppable {
1447   address[] public payableAddresses = [RAMPPADDRESS,0x0eAF7FEB562b7828c1C1B62B33BA902901bf6955];
1448   uint256[] public payableFees = [5,95];
1449   uint256 public payableAddressCount = 2;
1450 
1451   function withdrawAll() public onlyTeamOrOwner {
1452       require(address(this).balance > 0);
1453       _withdrawAll();
1454   }
1455   
1456   function withdrawAllRampp() public isRampp {
1457       require(address(this).balance > 0);
1458       _withdrawAll();
1459   }
1460 
1461   function _withdrawAll() private {
1462       uint256 balance = address(this).balance;
1463       
1464       for(uint i=0; i < payableAddressCount; i++ ) {
1465           _widthdraw(
1466               payableAddresses[i],
1467               (balance * payableFees[i]) / 100
1468           );
1469       }
1470   }
1471   
1472   function _widthdraw(address _address, uint256 _amount) private {
1473       (bool success, ) = _address.call{value: _amount}("");
1474       require(success, "Transfer failed.");
1475   }
1476 
1477   /**
1478     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1479     * while still splitting royalty payments to all other team members.
1480     * in the event ERC-20 tokens are paid to the contract.
1481     * @param _tokenContract contract of ERC-20 token to withdraw
1482     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1483     */
1484   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1485     require(_amount > 0);
1486     IERC20 tokenContract = IERC20(_tokenContract);
1487     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1488 
1489     for(uint i=0; i < payableAddressCount; i++ ) {
1490         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1491     }
1492   }
1493 
1494   /**
1495   * @dev Allows Rampp wallet to update its own reference as well as update
1496   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1497   * and since Rampp is always the first address this function is limited to the rampp payout only.
1498   * @param _newAddress updated Rampp Address
1499   */
1500   function setRamppAddress(address _newAddress) public isRampp {
1501     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1502     RAMPPADDRESS = _newAddress;
1503     payableAddresses[0] = _newAddress;
1504   }
1505 }
1506 
1507 
1508   
1509 // File: isFeeable.sol
1510 abstract contract Feeable is Teams {
1511   uint256 public PRICE = 0 ether;
1512 
1513   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1514     PRICE = _feeInWei;
1515   }
1516 
1517   function getPrice(uint256 _count) public view returns (uint256) {
1518     return PRICE * _count;
1519   }
1520 }
1521 
1522   
1523   
1524 abstract contract RamppERC721A is 
1525     Ownable,
1526     Teams,
1527     ERC721A,
1528     Withdrawable,
1529     ReentrancyGuard 
1530     , Feeable 
1531      
1532     
1533 {
1534   constructor(
1535     string memory tokenName,
1536     string memory tokenSymbol
1537   ) ERC721A(tokenName, tokenSymbol, 2, 10000) { }
1538     uint8 public CONTRACT_VERSION = 2;
1539     string public _baseTokenURI = "ipfs://bafybeiaxo3abtpkjldekuiu44pjtffjjtjfpvm4rvdwdn6perelfittu3a/";
1540 
1541     bool public mintingOpen = true;
1542     
1543     
1544     uint256 public MAX_WALLET_MINTS = 2;
1545 
1546   
1547     /////////////// Admin Mint Functions
1548     /**
1549      * @dev Mints a token to an address with a tokenURI.
1550      * This is owner only and allows a fee-free drop
1551      * @param _to address of the future owner of the token
1552      * @param _qty amount of tokens to drop the owner
1553      */
1554      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1555          require(_qty > 0, "Must mint at least 1 token.");
1556          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1557          _safeMint(_to, _qty, true);
1558      }
1559 
1560   
1561     /////////////// GENERIC MINT FUNCTIONS
1562     /**
1563     * @dev Mints a single token to an address.
1564     * fee may or may not be required*
1565     * @param _to address of the future owner of the token
1566     */
1567     function mintTo(address _to) public payable {
1568         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1569         require(mintingOpen == true, "Minting is not open right now!");
1570         
1571         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1572         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1573         
1574         _safeMint(_to, 1, false);
1575     }
1576 
1577     /**
1578     * @dev Mints a token to an address with a tokenURI.
1579     * fee may or may not be required*
1580     * @param _to address of the future owner of the token
1581     * @param _amount number of tokens to mint
1582     */
1583     function mintToMultiple(address _to, uint256 _amount) public payable {
1584         require(_amount >= 1, "Must mint at least 1 token");
1585         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1586         require(mintingOpen == true, "Minting is not open right now!");
1587         
1588         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1589         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1590         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1591 
1592         _safeMint(_to, _amount, false);
1593     }
1594 
1595     function openMinting() public onlyTeamOrOwner {
1596         mintingOpen = true;
1597     }
1598 
1599     function stopMinting() public onlyTeamOrOwner {
1600         mintingOpen = false;
1601     }
1602 
1603   
1604 
1605   
1606     /**
1607     * @dev Check if wallet over MAX_WALLET_MINTS
1608     * @param _address address in question to check if minted count exceeds max
1609     */
1610     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1611         require(_amount >= 1, "Amount must be greater than or equal to 1");
1612         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1613     }
1614 
1615     /**
1616     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1617     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1618     */
1619     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1620         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1621         MAX_WALLET_MINTS = _newWalletMax;
1622     }
1623     
1624 
1625   
1626     /**
1627      * @dev Allows owner to set Max mints per tx
1628      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1629      */
1630      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1631          require(_newMaxMint >= 1, "Max mint must be at least 1");
1632          maxBatchSize = _newMaxMint;
1633      }
1634     
1635 
1636   
1637 
1638   function _baseURI() internal view virtual override returns(string memory) {
1639     return _baseTokenURI;
1640   }
1641 
1642   function baseTokenURI() public view returns(string memory) {
1643     return _baseTokenURI;
1644   }
1645 
1646   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1647     _baseTokenURI = baseURI;
1648   }
1649 
1650   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1651     return ownershipOf(tokenId);
1652   }
1653 }
1654 
1655 
1656   
1657 // File: contracts/FakeApesContract.sol
1658 //SPDX-License-Identifier: MIT
1659 
1660 pragma solidity ^0.8.0;
1661 
1662 contract FakeApesContract is RamppERC721A {
1663     constructor() RamppERC721A("Fake Apes", "FAKE"){}
1664 }
1665   
1666 //*********************************************************************//
1667 //*********************************************************************//  
1668 //                       Rampp v2.0.1
1669 //
1670 //         This smart contract was generated by rampp.xyz.
1671 //            Rampp allows creators like you to launch 
1672 //             large scale NFT communities without code!
1673 //
1674 //    Rampp is not responsible for the content of this contract and
1675 //        hopes it is being used in a responsible and kind way.  
1676 //       Rampp is not associated or affiliated with this project.                                                    
1677 //             Twitter: @Rampp_ ---- rampp.xyz
1678 //*********************************************************************//                                                     
1679 //*********************************************************************// 
