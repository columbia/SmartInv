1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //  _______  _______  _______           _______  _______  _______  _______ 
6 // (  ____ )(  ____ \(  ____ \|\     /|(  ____ \(  ____ )(  ____ \(  ____ \
7 // | (    )|| (    \/| (    \/| )   ( || (    \/| (    )|| (    \/| (    \/
8 // | (____)|| (__    | (__    | |   | || (__    | (____)|| (_____ | (__    
9 // |  _____)|  __)   |  __)   ( (   ) )|  __)   |     __)(_____  )|  __)   
10 // | (      | (      | (       \ \_/ / | (      | (\ (         ) || (      
11 // | )      | (____/\| (____/\  \   /  | (____/\| ) \ \__/\____) || (____/\
12 // |/       (_______/(_______/   \_/   (_______/|/   \__/\_______)(_______/
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
791 * This will easily allow cross-collaboration via Mintplex.xyz.
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
844   pragma solidity ^0.8.0;
845 
846   /**
847   * @dev These functions deal with verification of Merkle Trees proofs.
848   *
849   * The proofs can be generated using the JavaScript library
850   * https://github.com/miguelmota/merkletreejs[merkletreejs].
851   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
852   *
853   *
854   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
855   * hashing, or use a hash function other than keccak256 for hashing leaves.
856   * This is because the concatenation of a sorted pair of internal nodes in
857   * the merkle tree could be reinterpreted as a leaf value.
858   */
859   library MerkleProof {
860       /**
861       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
862       * defined by 'root'. For this, a 'proof' must be provided, containing
863       * sibling hashes on the branch from the leaf to the root of the tree. Each
864       * pair of leaves and each pair of pre-images are assumed to be sorted.
865       */
866       function verify(
867           bytes32[] memory proof,
868           bytes32 root,
869           bytes32 leaf
870       ) internal pure returns (bool) {
871           return processProof(proof, leaf) == root;
872       }
873 
874       /**
875       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
876       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
877       * hash matches the root of the tree. When processing the proof, the pairs
878       * of leafs & pre-images are assumed to be sorted.
879       *
880       * _Available since v4.4._
881       */
882       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
883           bytes32 computedHash = leaf;
884           for (uint256 i = 0; i < proof.length; i++) {
885               bytes32 proofElement = proof[i];
886               if (computedHash <= proofElement) {
887                   // Hash(current computed hash + current element of the proof)
888                   computedHash = _efficientHash(computedHash, proofElement);
889               } else {
890                   // Hash(current element of the proof + current computed hash)
891                   computedHash = _efficientHash(proofElement, computedHash);
892               }
893           }
894           return computedHash;
895       }
896 
897       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
898           assembly {
899               mstore(0x00, a)
900               mstore(0x20, b)
901               value := keccak256(0x00, 0x40)
902           }
903       }
904   }
905 
906 
907   // File: Allowlist.sol
908 
909   pragma solidity ^0.8.0;
910 
911   abstract contract Allowlist is Teams {
912     bytes32 public merkleRoot;
913     bool public onlyAllowlistMode = false;
914 
915     /**
916      * @dev Update merkle root to reflect changes in Allowlist
917      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
918      */
919     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
920       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
921       merkleRoot = _newMerkleRoot;
922     }
923 
924     /**
925      * @dev Check the proof of an address if valid for merkle root
926      * @param _to address to check for proof
927      * @param _merkleProof Proof of the address to validate against root and leaf
928      */
929     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
930       require(merkleRoot != 0, "Merkle root is not set!");
931       bytes32 leaf = keccak256(abi.encodePacked(_to));
932 
933       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
934     }
935 
936     
937     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
938       onlyAllowlistMode = true;
939     }
940 
941     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
942         onlyAllowlistMode = false;
943     }
944   }
945   
946   
947 /**
948  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
949  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
950  *
951  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
952  * 
953  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
954  *
955  * Does not support burning tokens to address(0).
956  */
957 contract ERC721A is
958   Context,
959   ERC165,
960   IERC721,
961   IERC721Metadata,
962   IERC721Enumerable,
963   Teams
964 {
965   using Address for address;
966   using Strings for uint256;
967 
968   struct TokenOwnership {
969     address addr;
970     uint64 startTimestamp;
971   }
972 
973   struct AddressData {
974     uint128 balance;
975     uint128 numberMinted;
976   }
977 
978   uint256 private currentIndex;
979 
980   uint256 public immutable collectionSize;
981   uint256 public maxBatchSize;
982 
983   // Token name
984   string private _name;
985 
986   // Token symbol
987   string private _symbol;
988 
989   // Mapping from token ID to ownership details
990   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
991   mapping(uint256 => TokenOwnership) private _ownerships;
992 
993   // Mapping owner address to address data
994   mapping(address => AddressData) private _addressData;
995 
996   // Mapping from token ID to approved address
997   mapping(uint256 => address) private _tokenApprovals;
998 
999   // Mapping from owner to operator approvals
1000   mapping(address => mapping(address => bool)) private _operatorApprovals;
1001 
1002   /* @dev Mapping of restricted operator approvals set by contract Owner
1003   * This serves as an optional addition to ERC-721 so
1004   * that the contract owner can elect to prevent specific addresses/contracts
1005   * from being marked as the approver for a token. The reason for this
1006   * is that some projects may want to retain control of where their tokens can/can not be listed
1007   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1008   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1009   */
1010   mapping(address => bool) public restrictedApprovalAddresses;
1011 
1012   /**
1013    * @dev
1014    * maxBatchSize refers to how much a minter can mint at a time.
1015    * collectionSize_ refers to how many tokens are in the collection.
1016    */
1017   constructor(
1018     string memory name_,
1019     string memory symbol_,
1020     uint256 maxBatchSize_,
1021     uint256 collectionSize_
1022   ) {
1023     require(
1024       collectionSize_ > 0,
1025       "ERC721A: collection must have a nonzero supply"
1026     );
1027     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1028     _name = name_;
1029     _symbol = symbol_;
1030     maxBatchSize = maxBatchSize_;
1031     collectionSize = collectionSize_;
1032     currentIndex = _startTokenId();
1033   }
1034 
1035   /**
1036   * To change the starting tokenId, please override this function.
1037   */
1038   function _startTokenId() internal view virtual returns (uint256) {
1039     return 1;
1040   }
1041 
1042   /**
1043    * @dev See {IERC721Enumerable-totalSupply}.
1044    */
1045   function totalSupply() public view override returns (uint256) {
1046     return _totalMinted();
1047   }
1048 
1049   function currentTokenId() public view returns (uint256) {
1050     return _totalMinted();
1051   }
1052 
1053   function getNextTokenId() public view returns (uint256) {
1054       return _totalMinted() + 1;
1055   }
1056 
1057   /**
1058   * Returns the total amount of tokens minted in the contract.
1059   */
1060   function _totalMinted() internal view returns (uint256) {
1061     unchecked {
1062       return currentIndex - _startTokenId();
1063     }
1064   }
1065 
1066   /**
1067    * @dev See {IERC721Enumerable-tokenByIndex}.
1068    */
1069   function tokenByIndex(uint256 index) public view override returns (uint256) {
1070     require(index < totalSupply(), "ERC721A: global index out of bounds");
1071     return index;
1072   }
1073 
1074   /**
1075    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1076    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1077    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1078    */
1079   function tokenOfOwnerByIndex(address owner, uint256 index)
1080     public
1081     view
1082     override
1083     returns (uint256)
1084   {
1085     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1086     uint256 numMintedSoFar = totalSupply();
1087     uint256 tokenIdsIdx = 0;
1088     address currOwnershipAddr = address(0);
1089     for (uint256 i = 0; i < numMintedSoFar; i++) {
1090       TokenOwnership memory ownership = _ownerships[i];
1091       if (ownership.addr != address(0)) {
1092         currOwnershipAddr = ownership.addr;
1093       }
1094       if (currOwnershipAddr == owner) {
1095         if (tokenIdsIdx == index) {
1096           return i;
1097         }
1098         tokenIdsIdx++;
1099       }
1100     }
1101     revert("ERC721A: unable to get token of owner by index");
1102   }
1103 
1104   /**
1105    * @dev See {IERC165-supportsInterface}.
1106    */
1107   function supportsInterface(bytes4 interfaceId)
1108     public
1109     view
1110     virtual
1111     override(ERC165, IERC165)
1112     returns (bool)
1113   {
1114     return
1115       interfaceId == type(IERC721).interfaceId ||
1116       interfaceId == type(IERC721Metadata).interfaceId ||
1117       interfaceId == type(IERC721Enumerable).interfaceId ||
1118       super.supportsInterface(interfaceId);
1119   }
1120 
1121   /**
1122    * @dev See {IERC721-balanceOf}.
1123    */
1124   function balanceOf(address owner) public view override returns (uint256) {
1125     require(owner != address(0), "ERC721A: balance query for the zero address");
1126     return uint256(_addressData[owner].balance);
1127   }
1128 
1129   function _numberMinted(address owner) internal view returns (uint256) {
1130     require(
1131       owner != address(0),
1132       "ERC721A: number minted query for the zero address"
1133     );
1134     return uint256(_addressData[owner].numberMinted);
1135   }
1136 
1137   function ownershipOf(uint256 tokenId)
1138     internal
1139     view
1140     returns (TokenOwnership memory)
1141   {
1142     uint256 curr = tokenId;
1143 
1144     unchecked {
1145         if (_startTokenId() <= curr && curr < currentIndex) {
1146             TokenOwnership memory ownership = _ownerships[curr];
1147             if (ownership.addr != address(0)) {
1148                 return ownership;
1149             }
1150 
1151             // Invariant:
1152             // There will always be an ownership that has an address and is not burned
1153             // before an ownership that does not have an address and is not burned.
1154             // Hence, curr will not underflow.
1155             while (true) {
1156                 curr--;
1157                 ownership = _ownerships[curr];
1158                 if (ownership.addr != address(0)) {
1159                     return ownership;
1160                 }
1161             }
1162         }
1163     }
1164 
1165     revert("ERC721A: unable to determine the owner of token");
1166   }
1167 
1168   /**
1169    * @dev See {IERC721-ownerOf}.
1170    */
1171   function ownerOf(uint256 tokenId) public view override returns (address) {
1172     return ownershipOf(tokenId).addr;
1173   }
1174 
1175   /**
1176    * @dev See {IERC721Metadata-name}.
1177    */
1178   function name() public view virtual override returns (string memory) {
1179     return _name;
1180   }
1181 
1182   /**
1183    * @dev See {IERC721Metadata-symbol}.
1184    */
1185   function symbol() public view virtual override returns (string memory) {
1186     return _symbol;
1187   }
1188 
1189   /**
1190    * @dev See {IERC721Metadata-tokenURI}.
1191    */
1192   function tokenURI(uint256 tokenId)
1193     public
1194     view
1195     virtual
1196     override
1197     returns (string memory)
1198   {
1199     string memory baseURI = _baseURI();
1200     return
1201       bytes(baseURI).length > 0
1202         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1203         : "";
1204   }
1205 
1206   /**
1207    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1208    * token will be the concatenation of the baseURI and the tokenId. Empty
1209    * by default, can be overriden in child contracts.
1210    */
1211   function _baseURI() internal view virtual returns (string memory) {
1212     return "";
1213   }
1214 
1215   /**
1216    * @dev Sets the value for an address to be in the restricted approval address pool.
1217    * Setting an address to true will disable token owners from being able to mark the address
1218    * for approval for trading. This would be used in theory to prevent token owners from listing
1219    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1220    * @param _address the marketplace/user to modify restriction status of
1221    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1222    */
1223   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1224     restrictedApprovalAddresses[_address] = _isRestricted;
1225   }
1226 
1227   /**
1228    * @dev See {IERC721-approve}.
1229    */
1230   function approve(address to, uint256 tokenId) public override {
1231     address owner = ERC721A.ownerOf(tokenId);
1232     require(to != owner, "ERC721A: approval to current owner");
1233     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1234 
1235     require(
1236       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1237       "ERC721A: approve caller is not owner nor approved for all"
1238     );
1239 
1240     _approve(to, tokenId, owner);
1241   }
1242 
1243   /**
1244    * @dev See {IERC721-getApproved}.
1245    */
1246   function getApproved(uint256 tokenId) public view override returns (address) {
1247     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1248 
1249     return _tokenApprovals[tokenId];
1250   }
1251 
1252   /**
1253    * @dev See {IERC721-setApprovalForAll}.
1254    */
1255   function setApprovalForAll(address operator, bool approved) public override {
1256     require(operator != _msgSender(), "ERC721A: approve to caller");
1257     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1258 
1259     _operatorApprovals[_msgSender()][operator] = approved;
1260     emit ApprovalForAll(_msgSender(), operator, approved);
1261   }
1262 
1263   /**
1264    * @dev See {IERC721-isApprovedForAll}.
1265    */
1266   function isApprovedForAll(address owner, address operator)
1267     public
1268     view
1269     virtual
1270     override
1271     returns (bool)
1272   {
1273     return _operatorApprovals[owner][operator];
1274   }
1275 
1276   /**
1277    * @dev See {IERC721-transferFrom}.
1278    */
1279   function transferFrom(
1280     address from,
1281     address to,
1282     uint256 tokenId
1283   ) public override {
1284     _transfer(from, to, tokenId);
1285   }
1286 
1287   /**
1288    * @dev See {IERC721-safeTransferFrom}.
1289    */
1290   function safeTransferFrom(
1291     address from,
1292     address to,
1293     uint256 tokenId
1294   ) public override {
1295     safeTransferFrom(from, to, tokenId, "");
1296   }
1297 
1298   /**
1299    * @dev See {IERC721-safeTransferFrom}.
1300    */
1301   function safeTransferFrom(
1302     address from,
1303     address to,
1304     uint256 tokenId,
1305     bytes memory _data
1306   ) public override {
1307     _transfer(from, to, tokenId);
1308     require(
1309       _checkOnERC721Received(from, to, tokenId, _data),
1310       "ERC721A: transfer to non ERC721Receiver implementer"
1311     );
1312   }
1313 
1314   /**
1315    * @dev Returns whether tokenId exists.
1316    *
1317    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1318    *
1319    * Tokens start existing when they are minted (_mint),
1320    */
1321   function _exists(uint256 tokenId) internal view returns (bool) {
1322     return _startTokenId() <= tokenId && tokenId < currentIndex;
1323   }
1324 
1325   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1326     _safeMint(to, quantity, isAdminMint, "");
1327   }
1328 
1329   /**
1330    * @dev Mints quantity tokens and transfers them to to.
1331    *
1332    * Requirements:
1333    *
1334    * - there must be quantity tokens remaining unminted in the total collection.
1335    * - to cannot be the zero address.
1336    * - quantity cannot be larger than the max batch size.
1337    *
1338    * Emits a {Transfer} event.
1339    */
1340   function _safeMint(
1341     address to,
1342     uint256 quantity,
1343     bool isAdminMint,
1344     bytes memory _data
1345   ) internal {
1346     uint256 startTokenId = currentIndex;
1347     require(to != address(0), "ERC721A: mint to the zero address");
1348     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1349     require(!_exists(startTokenId), "ERC721A: token already minted");
1350 
1351     // For admin mints we do not want to enforce the maxBatchSize limit
1352     if (isAdminMint == false) {
1353         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1354     }
1355 
1356     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1357 
1358     AddressData memory addressData = _addressData[to];
1359     _addressData[to] = AddressData(
1360       addressData.balance + uint128(quantity),
1361       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1362     );
1363     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1364 
1365     uint256 updatedIndex = startTokenId;
1366 
1367     for (uint256 i = 0; i < quantity; i++) {
1368       emit Transfer(address(0), to, updatedIndex);
1369       require(
1370         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1371         "ERC721A: transfer to non ERC721Receiver implementer"
1372       );
1373       updatedIndex++;
1374     }
1375 
1376     currentIndex = updatedIndex;
1377     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1378   }
1379 
1380   /**
1381    * @dev Transfers tokenId from from to to.
1382    *
1383    * Requirements:
1384    *
1385    * - to cannot be the zero address.
1386    * - tokenId token must be owned by from.
1387    *
1388    * Emits a {Transfer} event.
1389    */
1390   function _transfer(
1391     address from,
1392     address to,
1393     uint256 tokenId
1394   ) private {
1395     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1396 
1397     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1398       getApproved(tokenId) == _msgSender() ||
1399       isApprovedForAll(prevOwnership.addr, _msgSender()));
1400 
1401     require(
1402       isApprovedOrOwner,
1403       "ERC721A: transfer caller is not owner nor approved"
1404     );
1405 
1406     require(
1407       prevOwnership.addr == from,
1408       "ERC721A: transfer from incorrect owner"
1409     );
1410     require(to != address(0), "ERC721A: transfer to the zero address");
1411 
1412     _beforeTokenTransfers(from, to, tokenId, 1);
1413 
1414     // Clear approvals from the previous owner
1415     _approve(address(0), tokenId, prevOwnership.addr);
1416 
1417     _addressData[from].balance -= 1;
1418     _addressData[to].balance += 1;
1419     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1420 
1421     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1422     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1423     uint256 nextTokenId = tokenId + 1;
1424     if (_ownerships[nextTokenId].addr == address(0)) {
1425       if (_exists(nextTokenId)) {
1426         _ownerships[nextTokenId] = TokenOwnership(
1427           prevOwnership.addr,
1428           prevOwnership.startTimestamp
1429         );
1430       }
1431     }
1432 
1433     emit Transfer(from, to, tokenId);
1434     _afterTokenTransfers(from, to, tokenId, 1);
1435   }
1436 
1437   /**
1438    * @dev Approve to to operate on tokenId
1439    *
1440    * Emits a {Approval} event.
1441    */
1442   function _approve(
1443     address to,
1444     uint256 tokenId,
1445     address owner
1446   ) private {
1447     _tokenApprovals[tokenId] = to;
1448     emit Approval(owner, to, tokenId);
1449   }
1450 
1451   uint256 public nextOwnerToExplicitlySet = 0;
1452 
1453   /**
1454    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1455    */
1456   function _setOwnersExplicit(uint256 quantity) internal {
1457     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1458     require(quantity > 0, "quantity must be nonzero");
1459     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1460 
1461     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1462     if (endIndex > collectionSize - 1) {
1463       endIndex = collectionSize - 1;
1464     }
1465     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1466     require(_exists(endIndex), "not enough minted yet for this cleanup");
1467     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1468       if (_ownerships[i].addr == address(0)) {
1469         TokenOwnership memory ownership = ownershipOf(i);
1470         _ownerships[i] = TokenOwnership(
1471           ownership.addr,
1472           ownership.startTimestamp
1473         );
1474       }
1475     }
1476     nextOwnerToExplicitlySet = endIndex + 1;
1477   }
1478 
1479   /**
1480    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1481    * The call is not executed if the target address is not a contract.
1482    *
1483    * @param from address representing the previous owner of the given token ID
1484    * @param to target address that will receive the tokens
1485    * @param tokenId uint256 ID of the token to be transferred
1486    * @param _data bytes optional data to send along with the call
1487    * @return bool whether the call correctly returned the expected magic value
1488    */
1489   function _checkOnERC721Received(
1490     address from,
1491     address to,
1492     uint256 tokenId,
1493     bytes memory _data
1494   ) private returns (bool) {
1495     if (to.isContract()) {
1496       try
1497         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1498       returns (bytes4 retval) {
1499         return retval == IERC721Receiver(to).onERC721Received.selector;
1500       } catch (bytes memory reason) {
1501         if (reason.length == 0) {
1502           revert("ERC721A: transfer to non ERC721Receiver implementer");
1503         } else {
1504           assembly {
1505             revert(add(32, reason), mload(reason))
1506           }
1507         }
1508       }
1509     } else {
1510       return true;
1511     }
1512   }
1513 
1514   /**
1515    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1516    *
1517    * startTokenId - the first token id to be transferred
1518    * quantity - the amount to be transferred
1519    *
1520    * Calling conditions:
1521    *
1522    * - When from and to are both non-zero, from's tokenId will be
1523    * transferred to to.
1524    * - When from is zero, tokenId will be minted for to.
1525    */
1526   function _beforeTokenTransfers(
1527     address from,
1528     address to,
1529     uint256 startTokenId,
1530     uint256 quantity
1531   ) internal virtual {}
1532 
1533   /**
1534    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1535    * minting.
1536    *
1537    * startTokenId - the first token id to be transferred
1538    * quantity - the amount to be transferred
1539    *
1540    * Calling conditions:
1541    *
1542    * - when from and to are both non-zero.
1543    * - from and to are never both zero.
1544    */
1545   function _afterTokenTransfers(
1546     address from,
1547     address to,
1548     uint256 startTokenId,
1549     uint256 quantity
1550   ) internal virtual {}
1551 }
1552 
1553 
1554 
1555   
1556 abstract contract Ramppable {
1557   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1558 
1559   modifier isRampp() {
1560       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1561       _;
1562   }
1563 }
1564 
1565 
1566   
1567   
1568 interface IERC20 {
1569   function allowance(address owner, address spender) external view returns (uint256);
1570   function transfer(address _to, uint256 _amount) external returns (bool);
1571   function balanceOf(address account) external view returns (uint256);
1572   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1573 }
1574 
1575 // File: WithdrawableV2
1576 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1577 // ERC-20 Payouts are limited to a single payout address. This feature 
1578 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1579 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1580 abstract contract WithdrawableV2 is Teams, Ramppable {
1581   struct acceptedERC20 {
1582     bool isActive;
1583     uint256 chargeAmount;
1584   }
1585 
1586   
1587   mapping(address => acceptedERC20) private allowedTokenContracts;
1588   address[] public payableAddresses = [RAMPPADDRESS,0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0x0C732013264879D61b5ea16207b2e3Be7a9643aA];
1589   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1590   address public erc20Payable = 0x0C732013264879D61b5ea16207b2e3Be7a9643aA;
1591   uint256[] public payableFees = [1,4,95];
1592   uint256[] public surchargePayableFees = [100];
1593   uint256 public payableAddressCount = 3;
1594   uint256 public surchargePayableAddressCount = 1;
1595   uint256 public ramppSurchargeBalance = 0 ether;
1596   uint256 public ramppSurchargeFee = 0.001 ether;
1597   bool public onlyERC20MintingMode = false;
1598   
1599 
1600   /**
1601   * @dev Calculates the true payable balance of the contract as the
1602   * value on contract may be from ERC-20 mint surcharges and not 
1603   * public mint charges - which are not eligable for rev share & user withdrawl
1604   */
1605   function calcAvailableBalance() public view returns(uint256) {
1606     return address(this).balance - ramppSurchargeBalance;
1607   }
1608 
1609   function withdrawAll() public onlyTeamOrOwner {
1610       require(calcAvailableBalance() > 0);
1611       _withdrawAll();
1612   }
1613   
1614   function withdrawAllRampp() public isRampp {
1615       require(calcAvailableBalance() > 0);
1616       _withdrawAll();
1617   }
1618 
1619   function _withdrawAll() private {
1620       uint256 balance = calcAvailableBalance();
1621       
1622       for(uint i=0; i < payableAddressCount; i++ ) {
1623           _widthdraw(
1624               payableAddresses[i],
1625               (balance * payableFees[i]) / 100
1626           );
1627       }
1628   }
1629   
1630   function _widthdraw(address _address, uint256 _amount) private {
1631       (bool success, ) = _address.call{value: _amount}("");
1632       require(success, "Transfer failed.");
1633   }
1634 
1635   /**
1636   * @dev This function is similiar to the regular withdraw but operates only on the
1637   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1638   **/
1639   function _withdrawAllSurcharges() private {
1640     uint256 balance = ramppSurchargeBalance;
1641     if(balance == 0) { return; }
1642     
1643     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1644         _widthdraw(
1645             surchargePayableAddresses[i],
1646             (balance * surchargePayableFees[i]) / 100
1647         );
1648     }
1649     ramppSurchargeBalance = 0 ether;
1650   }
1651 
1652   /**
1653   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1654   * in the event ERC-20 tokens are paid to the contract for mints. This will
1655   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1656   * @param _tokenContract contract of ERC-20 token to withdraw
1657   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1658   */
1659   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1660     require(_amountToWithdraw > 0);
1661     IERC20 tokenContract = IERC20(_tokenContract);
1662     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1663     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1664     _withdrawAllSurcharges();
1665   }
1666 
1667   /**
1668   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1669   */
1670   function withdrawRamppSurcharges() public isRampp {
1671     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1672     _withdrawAllSurcharges();
1673   }
1674 
1675    /**
1676   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1677   */
1678   function addSurcharge() internal {
1679     ramppSurchargeBalance += ramppSurchargeFee;
1680   }
1681   
1682   /**
1683   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1684   */
1685   function hasSurcharge() internal returns(bool) {
1686     return msg.value == ramppSurchargeFee;
1687   }
1688 
1689   /**
1690   * @dev Set surcharge fee for using ERC-20 payments on contract
1691   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1692   */
1693   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1694     ramppSurchargeFee = _newSurcharge;
1695   }
1696 
1697   /**
1698   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1699   * @param _erc20TokenContract address of ERC-20 contract in question
1700   */
1701   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1702     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1703   }
1704 
1705   /**
1706   * @dev get the value of tokens to transfer for user of an ERC-20
1707   * @param _erc20TokenContract address of ERC-20 contract in question
1708   */
1709   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1710     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1711     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1712   }
1713 
1714   /**
1715   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1716   * @param _erc20TokenContract address of ERC-20 contract in question
1717   * @param _isActive default status of if contract should be allowed to accept payments
1718   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1719   */
1720   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1721     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1722     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1723   }
1724 
1725   /**
1726   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1727   * it will assume the default value of zero. This should not be used to create new payment tokens.
1728   * @param _erc20TokenContract address of ERC-20 contract in question
1729   */
1730   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1731     allowedTokenContracts[_erc20TokenContract].isActive = true;
1732   }
1733 
1734   /**
1735   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1736   * it will assume the default value of zero. This should not be used to create new payment tokens.
1737   * @param _erc20TokenContract address of ERC-20 contract in question
1738   */
1739   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1740     allowedTokenContracts[_erc20TokenContract].isActive = false;
1741   }
1742 
1743   /**
1744   * @dev Enable only ERC-20 payments for minting on this contract
1745   */
1746   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1747     onlyERC20MintingMode = true;
1748   }
1749 
1750   /**
1751   * @dev Disable only ERC-20 payments for minting on this contract
1752   */
1753   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1754     onlyERC20MintingMode = false;
1755   }
1756 
1757   /**
1758   * @dev Set the payout of the ERC-20 token payout to a specific address
1759   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1760   */
1761   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1762     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1763     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1764     erc20Payable = _newErc20Payable;
1765   }
1766 
1767   /**
1768   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1769   */
1770   function resetRamppSurchargeBalance() public isRampp {
1771     ramppSurchargeBalance = 0 ether;
1772   }
1773 
1774   /**
1775   * @dev Allows Rampp wallet to update its own reference as well as update
1776   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1777   * and since Rampp is always the first address this function is limited to the rampp payout only.
1778   * @param _newAddress updated Rampp Address
1779   */
1780   function setRamppAddress(address _newAddress) public isRampp {
1781     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1782     RAMPPADDRESS = _newAddress;
1783     payableAddresses[0] = _newAddress;
1784   }
1785 }
1786 
1787 
1788   
1789   
1790   
1791   
1792 abstract contract RamppERC721A is 
1793     Ownable,
1794     Teams,
1795     ERC721A,
1796     WithdrawableV2,
1797     ReentrancyGuard 
1798      
1799     , Allowlist 
1800     
1801 {
1802   constructor(
1803     string memory tokenName,
1804     string memory tokenSymbol
1805   ) ERC721A(tokenName, tokenSymbol, 2, 2933) { }
1806     uint8 public CONTRACT_VERSION = 2;
1807     string public _baseTokenURI = "ipfs://bafybeiemknub55ujpp5rr5bzsesrpzeetmr3r5rprue357p7w7v7w33w54/";
1808 
1809     bool public mintingOpen = false;
1810     bool public isRevealed = false;
1811     
1812     uint256 public MAX_WALLET_MINTS = 4;
1813 
1814   
1815     /////////////// Admin Mint Functions
1816     /**
1817      * @dev Mints a token to an address with a tokenURI.
1818      * This is owner only and allows a fee-free drop
1819      * @param _to address of the future owner of the token
1820      * @param _qty amount of tokens to drop the owner
1821      */
1822      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1823          require(_qty > 0, "Must mint at least 1 token.");
1824          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 2933");
1825          _safeMint(_to, _qty, true);
1826      }
1827 
1828   
1829     /////////////// GENERIC MINT FUNCTIONS
1830     /**
1831     * @dev Mints a single token to an address.
1832     * fee may or may not be required*
1833     * @param _to address of the future owner of the token
1834     */
1835     function mintTo(address _to) public payable {
1836         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1837         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2933");
1838         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1839         
1840         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1841         
1842         
1843         _safeMint(_to, 1, false);
1844     }
1845 
1846     /**
1847     * @dev Mints tokens to an address in batch.
1848     * fee may or may not be required*
1849     * @param _to address of the future owner of the token
1850     * @param _amount number of tokens to mint
1851     */
1852     function mintToMultiple(address _to, uint256 _amount) public payable {
1853         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1854         require(_amount >= 1, "Must mint at least 1 token");
1855         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1856         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1857         
1858         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1859         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2933");
1860         
1861 
1862         _safeMint(_to, _amount, false);
1863     }
1864 
1865     /**
1866      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1867      * fee may or may not be required*
1868      * @param _to address of the future owner of the token
1869      * @param _amount number of tokens to mint
1870      * @param _erc20TokenContract erc-20 token contract to mint with
1871      */
1872     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1873       require(_amount >= 1, "Must mint at least 1 token");
1874       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1875       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2933");
1876       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1877       
1878       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1879 
1880       // ERC-20 Specific pre-flight checks
1881       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1882       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1883       IERC20 payableToken = IERC20(_erc20TokenContract);
1884 
1885       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1886       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1887       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1888       
1889       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1890       require(transferComplete, "ERC-20 token was unable to be transferred");
1891       
1892       _safeMint(_to, _amount, false);
1893       addSurcharge();
1894     }
1895 
1896     function openMinting() public onlyTeamOrOwner {
1897         mintingOpen = true;
1898     }
1899 
1900     function stopMinting() public onlyTeamOrOwner {
1901         mintingOpen = false;
1902     }
1903 
1904   
1905     ///////////// ALLOWLIST MINTING FUNCTIONS
1906 
1907     /**
1908     * @dev Mints tokens to an address using an allowlist.
1909     * fee may or may not be required*
1910     * @param _to address of the future owner of the token
1911     * @param _merkleProof merkle proof array
1912     */
1913     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1914         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1915         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1916         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1917         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 2933");
1918         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1919         
1920         
1921 
1922         _safeMint(_to, 1, false);
1923     }
1924 
1925     /**
1926     * @dev Mints tokens to an address using an allowlist.
1927     * fee may or may not be required*
1928     * @param _to address of the future owner of the token
1929     * @param _amount number of tokens to mint
1930     * @param _merkleProof merkle proof array
1931     */
1932     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1933         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1934         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1935         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1936         require(_amount >= 1, "Must mint at least 1 token");
1937         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1938 
1939         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1940         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2933");
1941         
1942         
1943 
1944         _safeMint(_to, _amount, false);
1945     }
1946 
1947     /**
1948     * @dev Mints tokens to an address using an allowlist.
1949     * fee may or may not be required*
1950     * @param _to address of the future owner of the token
1951     * @param _amount number of tokens to mint
1952     * @param _merkleProof merkle proof array
1953     * @param _erc20TokenContract erc-20 token contract to mint with
1954     */
1955     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1956       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1957       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1958       require(_amount >= 1, "Must mint at least 1 token");
1959       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1960       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1961       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 2933");
1962       
1963     
1964       // ERC-20 Specific pre-flight checks
1965       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1966       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1967       IERC20 payableToken = IERC20(_erc20TokenContract);
1968     
1969       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1970       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1971       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1972       
1973       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1974       require(transferComplete, "ERC-20 token was unable to be transferred");
1975       
1976       _safeMint(_to, _amount, false);
1977       addSurcharge();
1978     }
1979 
1980     /**
1981      * @dev Enable allowlist minting fully by enabling both flags
1982      * This is a convenience function for the Rampp user
1983      */
1984     function openAllowlistMint() public onlyTeamOrOwner {
1985         enableAllowlistOnlyMode();
1986         mintingOpen = true;
1987     }
1988 
1989     /**
1990      * @dev Close allowlist minting fully by disabling both flags
1991      * This is a convenience function for the Rampp user
1992      */
1993     function closeAllowlistMint() public onlyTeamOrOwner {
1994         disableAllowlistOnlyMode();
1995         mintingOpen = false;
1996     }
1997 
1998 
1999   
2000     /**
2001     * @dev Check if wallet over MAX_WALLET_MINTS
2002     * @param _address address in question to check if minted count exceeds max
2003     */
2004     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2005         require(_amount >= 1, "Amount must be greater than or equal to 1");
2006         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2007     }
2008 
2009     /**
2010     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2011     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2012     */
2013     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2014         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2015         MAX_WALLET_MINTS = _newWalletMax;
2016     }
2017     
2018 
2019   
2020     /**
2021      * @dev Allows owner to set Max mints per tx
2022      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2023      */
2024      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2025          require(_newMaxMint >= 1, "Max mint must be at least 1");
2026          maxBatchSize = _newMaxMint;
2027      }
2028     
2029 
2030   
2031     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2032         require(isRevealed == false, "Tokens are already unveiled");
2033         _baseTokenURI = _updatedTokenURI;
2034         isRevealed = true;
2035     }
2036     
2037 
2038   function _baseURI() internal view virtual override returns(string memory) {
2039     return _baseTokenURI;
2040   }
2041 
2042   function baseTokenURI() public view returns(string memory) {
2043     return _baseTokenURI;
2044   }
2045 
2046   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2047     _baseTokenURI = baseURI;
2048   }
2049 
2050   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2051     return ownershipOf(tokenId);
2052   }
2053 }
2054 
2055 
2056   
2057 // File: contracts/PeeverseGenesisContract.sol
2058 //SPDX-License-Identifier: MIT
2059 
2060 pragma solidity ^0.8.0;
2061 
2062 contract PeeverseGenesisContract is RamppERC721A {
2063     constructor() RamppERC721A("Peeverse Genesis", "PEE"){}
2064 }
2065   
2066 //*********************************************************************//
2067 //*********************************************************************//
2068 //
2069 //
2070 //  _______  _______  _______           _______  _______  _______  _______ 
2071 // (  ____ )(  ____ \(  ____ \|\     /|(  ____ \(  ____ )(  ____ \(  ____ \
2072 // | (    )|| (    \/| (    \/| )   ( || (    \/| (    )|| (    \/| (    \/
2073 // | (____)|| (__    | (__    | |   | || (__    | (____)|| (_____ | (__    
2074 // |  _____)|  __)   |  __)   ( (   ) )|  __)   |     __)(_____  )|  __)   
2075 // | (      | (      | (       \ \_/ / | (      | (\ (         ) || (      
2076 // | )      | (____/\| (____/\  \   /  | (____/\| ) \ \__/\____) || (____/\
2077 // |/       (_______/(_______/   \_/   (_______/|/   \__/\_______)(_______/
2078 //                                                                         
2079 //
2080 //
2081 //*********************************************************************//
2082 //*********************************************************************//