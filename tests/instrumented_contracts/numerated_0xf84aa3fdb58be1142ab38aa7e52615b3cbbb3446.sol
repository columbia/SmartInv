1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     ____                                         ____               
5 //    / __ \ _____ ___   ____ _ ____ ___   _____   / __ ) __  __       
6 //   / / / // ___// _ \ / __ `// __ `__ \ / ___/  / __  |/ / / /       
7 //  / /_/ // /   /  __// /_/ // / / / / /(__  )  / /_/ // /_/ /        
8 // /_____//_/    \___/ \__,_//_/ /_/ /_//____/  /_____/ \__, /         
9 //    ______   ____                        ____        /____/   _      
10 //   / ____ \ /  _/      ____ ___         / __ \ ____   ____   (_)____ 
11 //  / / __ `/ / /       / __ `__ \       / /_/ // __ \ / __ \ / // __ \
12 // / / /_/ /_/ /       / / / / / /      / _, _// /_/ // / / // // / / /
13 // \ \__,_//___/______/_/ /_/ /_/______/_/ |_| \____//_/ /_//_//_/ /_/ 
14 //  \____/     /_____/          /_____/                                
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
917   
918   
919 // Rampp Contracts v2.1 (Teams.sol)
920 
921 error InvalidTeamAddress();
922 error DuplicateTeamAddress();
923 pragma solidity ^0.8.0;
924 
925 /**
926 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
927 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
928 * This will easily allow cross-collaboration via Mintplex.xyz.
929 **/
930 abstract contract Teams is Ownable{
931   mapping (address => bool) internal team;
932 
933   /**
934   * @dev Adds an address to the team. Allows them to execute protected functions
935   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
936   **/
937   function addToTeam(address _address) public onlyOwner {
938     if(_address == address(0)) revert InvalidTeamAddress();
939     if(inTeam(_address)) revert DuplicateTeamAddress();
940   
941     team[_address] = true;
942   }
943 
944   /**
945   * @dev Removes an address to the team.
946   * @param _address the ETH address to remove, cannot be 0x and must be in team
947   **/
948   function removeFromTeam(address _address) public onlyOwner {
949     if(_address == address(0)) revert InvalidTeamAddress();
950     if(!inTeam(_address)) revert InvalidTeamAddress();
951   
952     team[_address] = false;
953   }
954 
955   /**
956   * @dev Check if an address is valid and active in the team
957   * @param _address ETH address to check for truthiness
958   **/
959   function inTeam(address _address)
960     public
961     view
962     returns (bool)
963   {
964     if(_address == address(0)) revert InvalidTeamAddress();
965     return team[_address] == true;
966   }
967 
968   /**
969   * @dev Throws if called by any account other than the owner or team member.
970   */
971   function _onlyTeamOrOwner() private view {
972     bool _isOwner = owner() == _msgSender();
973     bool _isTeam = inTeam(_msgSender());
974     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
975   }
976 
977   modifier onlyTeamOrOwner() {
978     _onlyTeamOrOwner();
979     _;
980   }
981 }
982 
983 
984   
985   
986 /**
987  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
988  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
989  *
990  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
991  * 
992  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
993  *
994  * Does not support burning tokens to address(0).
995  */
996 contract ERC721A is
997   Context,
998   ERC165,
999   IERC721,
1000   IERC721Metadata,
1001   IERC721Enumerable,
1002   Teams
1003   , OperatorFilterer
1004 {
1005   using Address for address;
1006   using Strings for uint256;
1007 
1008   struct TokenOwnership {
1009     address addr;
1010     uint64 startTimestamp;
1011   }
1012 
1013   struct AddressData {
1014     uint128 balance;
1015     uint128 numberMinted;
1016   }
1017 
1018   uint256 private currentIndex;
1019 
1020   uint256 public immutable collectionSize;
1021   uint256 public maxBatchSize;
1022 
1023   // Token name
1024   string private _name;
1025 
1026   // Token symbol
1027   string private _symbol;
1028 
1029   // Mapping from token ID to ownership details
1030   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1031   mapping(uint256 => TokenOwnership) private _ownerships;
1032 
1033   // Mapping owner address to address data
1034   mapping(address => AddressData) private _addressData;
1035 
1036   // Mapping from token ID to approved address
1037   mapping(uint256 => address) private _tokenApprovals;
1038 
1039   // Mapping from owner to operator approvals
1040   mapping(address => mapping(address => bool)) private _operatorApprovals;
1041 
1042   /* @dev Mapping of restricted operator approvals set by contract Owner
1043   * This serves as an optional addition to ERC-721 so
1044   * that the contract owner can elect to prevent specific addresses/contracts
1045   * from being marked as the approver for a token. The reason for this
1046   * is that some projects may want to retain control of where their tokens can/can not be listed
1047   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1048   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1049   */
1050   mapping(address => bool) public restrictedApprovalAddresses;
1051 
1052   /**
1053    * @dev
1054    * maxBatchSize refers to how much a minter can mint at a time.
1055    * collectionSize_ refers to how many tokens are in the collection.
1056    */
1057   constructor(
1058     string memory name_,
1059     string memory symbol_,
1060     uint256 maxBatchSize_,
1061     uint256 collectionSize_
1062   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1063     require(
1064       collectionSize_ > 0,
1065       "ERC721A: collection must have a nonzero supply"
1066     );
1067     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1068     _name = name_;
1069     _symbol = symbol_;
1070     maxBatchSize = maxBatchSize_;
1071     collectionSize = collectionSize_;
1072     currentIndex = _startTokenId();
1073   }
1074 
1075   /**
1076   * To change the starting tokenId, please override this function.
1077   */
1078   function _startTokenId() internal view virtual returns (uint256) {
1079     return 1;
1080   }
1081 
1082   /**
1083    * @dev See {IERC721Enumerable-totalSupply}.
1084    */
1085   function totalSupply() public view override returns (uint256) {
1086     return _totalMinted();
1087   }
1088 
1089   function currentTokenId() public view returns (uint256) {
1090     return _totalMinted();
1091   }
1092 
1093   function getNextTokenId() public view returns (uint256) {
1094       return _totalMinted() + 1;
1095   }
1096 
1097   /**
1098   * Returns the total amount of tokens minted in the contract.
1099   */
1100   function _totalMinted() internal view returns (uint256) {
1101     unchecked {
1102       return currentIndex - _startTokenId();
1103     }
1104   }
1105 
1106   /**
1107    * @dev See {IERC721Enumerable-tokenByIndex}.
1108    */
1109   function tokenByIndex(uint256 index) public view override returns (uint256) {
1110     require(index < totalSupply(), "ERC721A: global index out of bounds");
1111     return index;
1112   }
1113 
1114   /**
1115    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1116    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1117    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1118    */
1119   function tokenOfOwnerByIndex(address owner, uint256 index)
1120     public
1121     view
1122     override
1123     returns (uint256)
1124   {
1125     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1126     uint256 numMintedSoFar = totalSupply();
1127     uint256 tokenIdsIdx = 0;
1128     address currOwnershipAddr = address(0);
1129     for (uint256 i = 0; i < numMintedSoFar; i++) {
1130       TokenOwnership memory ownership = _ownerships[i];
1131       if (ownership.addr != address(0)) {
1132         currOwnershipAddr = ownership.addr;
1133       }
1134       if (currOwnershipAddr == owner) {
1135         if (tokenIdsIdx == index) {
1136           return i;
1137         }
1138         tokenIdsIdx++;
1139       }
1140     }
1141     revert("ERC721A: unable to get token of owner by index");
1142   }
1143 
1144   /**
1145    * @dev See {IERC165-supportsInterface}.
1146    */
1147   function supportsInterface(bytes4 interfaceId)
1148     public
1149     view
1150     virtual
1151     override(ERC165, IERC165)
1152     returns (bool)
1153   {
1154     return
1155       interfaceId == type(IERC721).interfaceId ||
1156       interfaceId == type(IERC721Metadata).interfaceId ||
1157       interfaceId == type(IERC721Enumerable).interfaceId ||
1158       super.supportsInterface(interfaceId);
1159   }
1160 
1161   /**
1162    * @dev See {IERC721-balanceOf}.
1163    */
1164   function balanceOf(address owner) public view override returns (uint256) {
1165     require(owner != address(0), "ERC721A: balance query for the zero address");
1166     return uint256(_addressData[owner].balance);
1167   }
1168 
1169   function _numberMinted(address owner) internal view returns (uint256) {
1170     require(
1171       owner != address(0),
1172       "ERC721A: number minted query for the zero address"
1173     );
1174     return uint256(_addressData[owner].numberMinted);
1175   }
1176 
1177   function ownershipOf(uint256 tokenId)
1178     internal
1179     view
1180     returns (TokenOwnership memory)
1181   {
1182     uint256 curr = tokenId;
1183 
1184     unchecked {
1185         if (_startTokenId() <= curr && curr < currentIndex) {
1186             TokenOwnership memory ownership = _ownerships[curr];
1187             if (ownership.addr != address(0)) {
1188                 return ownership;
1189             }
1190 
1191             // Invariant:
1192             // There will always be an ownership that has an address and is not burned
1193             // before an ownership that does not have an address and is not burned.
1194             // Hence, curr will not underflow.
1195             while (true) {
1196                 curr--;
1197                 ownership = _ownerships[curr];
1198                 if (ownership.addr != address(0)) {
1199                     return ownership;
1200                 }
1201             }
1202         }
1203     }
1204 
1205     revert("ERC721A: unable to determine the owner of token");
1206   }
1207 
1208   /**
1209    * @dev See {IERC721-ownerOf}.
1210    */
1211   function ownerOf(uint256 tokenId) public view override returns (address) {
1212     return ownershipOf(tokenId).addr;
1213   }
1214 
1215   /**
1216    * @dev See {IERC721Metadata-name}.
1217    */
1218   function name() public view virtual override returns (string memory) {
1219     return _name;
1220   }
1221 
1222   /**
1223    * @dev See {IERC721Metadata-symbol}.
1224    */
1225   function symbol() public view virtual override returns (string memory) {
1226     return _symbol;
1227   }
1228 
1229   /**
1230    * @dev See {IERC721Metadata-tokenURI}.
1231    */
1232   function tokenURI(uint256 tokenId)
1233     public
1234     view
1235     virtual
1236     override
1237     returns (string memory)
1238   {
1239     string memory baseURI = _baseURI();
1240     string memory extension = _baseURIExtension();
1241     return
1242       bytes(baseURI).length > 0
1243         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1244         : "";
1245   }
1246 
1247   /**
1248    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1249    * token will be the concatenation of the baseURI and the tokenId. Empty
1250    * by default, can be overriden in child contracts.
1251    */
1252   function _baseURI() internal view virtual returns (string memory) {
1253     return "";
1254   }
1255 
1256   /**
1257    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1258    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1259    * by default, can be overriden in child contracts.
1260    */
1261   function _baseURIExtension() internal view virtual returns (string memory) {
1262     return "";
1263   }
1264 
1265   /**
1266    * @dev Sets the value for an address to be in the restricted approval address pool.
1267    * Setting an address to true will disable token owners from being able to mark the address
1268    * for approval for trading. This would be used in theory to prevent token owners from listing
1269    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1270    * @param _address the marketplace/user to modify restriction status of
1271    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1272    */
1273   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1274     restrictedApprovalAddresses[_address] = _isRestricted;
1275   }
1276 
1277   /**
1278    * @dev See {IERC721-approve}.
1279    */
1280   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1281     address owner = ERC721A.ownerOf(tokenId);
1282     require(to != owner, "ERC721A: approval to current owner");
1283     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1284 
1285     require(
1286       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1287       "ERC721A: approve caller is not owner nor approved for all"
1288     );
1289 
1290     _approve(to, tokenId, owner);
1291   }
1292 
1293   /**
1294    * @dev See {IERC721-getApproved}.
1295    */
1296   function getApproved(uint256 tokenId) public view override returns (address) {
1297     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1298 
1299     return _tokenApprovals[tokenId];
1300   }
1301 
1302   /**
1303    * @dev See {IERC721-setApprovalForAll}.
1304    */
1305   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1306     require(operator != _msgSender(), "ERC721A: approve to caller");
1307     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1308 
1309     _operatorApprovals[_msgSender()][operator] = approved;
1310     emit ApprovalForAll(_msgSender(), operator, approved);
1311   }
1312 
1313   /**
1314    * @dev See {IERC721-isApprovedForAll}.
1315    */
1316   function isApprovedForAll(address owner, address operator)
1317     public
1318     view
1319     virtual
1320     override
1321     returns (bool)
1322   {
1323     return _operatorApprovals[owner][operator];
1324   }
1325 
1326   /**
1327    * @dev See {IERC721-transferFrom}.
1328    */
1329   function transferFrom(
1330     address from,
1331     address to,
1332     uint256 tokenId
1333   ) public override onlyAllowedOperator(from) {
1334     _transfer(from, to, tokenId);
1335   }
1336 
1337   /**
1338    * @dev See {IERC721-safeTransferFrom}.
1339    */
1340   function safeTransferFrom(
1341     address from,
1342     address to,
1343     uint256 tokenId
1344   ) public override onlyAllowedOperator(from) {
1345     safeTransferFrom(from, to, tokenId, "");
1346   }
1347 
1348   /**
1349    * @dev See {IERC721-safeTransferFrom}.
1350    */
1351   function safeTransferFrom(
1352     address from,
1353     address to,
1354     uint256 tokenId,
1355     bytes memory _data
1356   ) public override onlyAllowedOperator(from) {
1357     _transfer(from, to, tokenId);
1358     require(
1359       _checkOnERC721Received(from, to, tokenId, _data),
1360       "ERC721A: transfer to non ERC721Receiver implementer"
1361     );
1362   }
1363 
1364   /**
1365    * @dev Returns whether tokenId exists.
1366    *
1367    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1368    *
1369    * Tokens start existing when they are minted (_mint),
1370    */
1371   function _exists(uint256 tokenId) internal view returns (bool) {
1372     return _startTokenId() <= tokenId && tokenId < currentIndex;
1373   }
1374 
1375   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1376     _safeMint(to, quantity, isAdminMint, "");
1377   }
1378 
1379   /**
1380    * @dev Mints quantity tokens and transfers them to to.
1381    *
1382    * Requirements:
1383    *
1384    * - there must be quantity tokens remaining unminted in the total collection.
1385    * - to cannot be the zero address.
1386    * - quantity cannot be larger than the max batch size.
1387    *
1388    * Emits a {Transfer} event.
1389    */
1390   function _safeMint(
1391     address to,
1392     uint256 quantity,
1393     bool isAdminMint,
1394     bytes memory _data
1395   ) internal {
1396     uint256 startTokenId = currentIndex;
1397     require(to != address(0), "ERC721A: mint to the zero address");
1398     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1399     require(!_exists(startTokenId), "ERC721A: token already minted");
1400 
1401     // For admin mints we do not want to enforce the maxBatchSize limit
1402     if (isAdminMint == false) {
1403         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1404     }
1405 
1406     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1407 
1408     AddressData memory addressData = _addressData[to];
1409     _addressData[to] = AddressData(
1410       addressData.balance + uint128(quantity),
1411       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1412     );
1413     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1414 
1415     uint256 updatedIndex = startTokenId;
1416 
1417     for (uint256 i = 0; i < quantity; i++) {
1418       emit Transfer(address(0), to, updatedIndex);
1419       require(
1420         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1421         "ERC721A: transfer to non ERC721Receiver implementer"
1422       );
1423       updatedIndex++;
1424     }
1425 
1426     currentIndex = updatedIndex;
1427     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1428   }
1429 
1430   /**
1431    * @dev Transfers tokenId from from to to.
1432    *
1433    * Requirements:
1434    *
1435    * - to cannot be the zero address.
1436    * - tokenId token must be owned by from.
1437    *
1438    * Emits a {Transfer} event.
1439    */
1440   function _transfer(
1441     address from,
1442     address to,
1443     uint256 tokenId
1444   ) private {
1445     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1446 
1447     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1448       getApproved(tokenId) == _msgSender() ||
1449       isApprovedForAll(prevOwnership.addr, _msgSender()));
1450 
1451     require(
1452       isApprovedOrOwner,
1453       "ERC721A: transfer caller is not owner nor approved"
1454     );
1455 
1456     require(
1457       prevOwnership.addr == from,
1458       "ERC721A: transfer from incorrect owner"
1459     );
1460     require(to != address(0), "ERC721A: transfer to the zero address");
1461 
1462     _beforeTokenTransfers(from, to, tokenId, 1);
1463 
1464     // Clear approvals from the previous owner
1465     _approve(address(0), tokenId, prevOwnership.addr);
1466 
1467     _addressData[from].balance -= 1;
1468     _addressData[to].balance += 1;
1469     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1470 
1471     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1472     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1473     uint256 nextTokenId = tokenId + 1;
1474     if (_ownerships[nextTokenId].addr == address(0)) {
1475       if (_exists(nextTokenId)) {
1476         _ownerships[nextTokenId] = TokenOwnership(
1477           prevOwnership.addr,
1478           prevOwnership.startTimestamp
1479         );
1480       }
1481     }
1482 
1483     emit Transfer(from, to, tokenId);
1484     _afterTokenTransfers(from, to, tokenId, 1);
1485   }
1486 
1487   /**
1488    * @dev Approve to to operate on tokenId
1489    *
1490    * Emits a {Approval} event.
1491    */
1492   function _approve(
1493     address to,
1494     uint256 tokenId,
1495     address owner
1496   ) private {
1497     _tokenApprovals[tokenId] = to;
1498     emit Approval(owner, to, tokenId);
1499   }
1500 
1501   uint256 public nextOwnerToExplicitlySet = 0;
1502 
1503   /**
1504    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1505    */
1506   function _setOwnersExplicit(uint256 quantity) internal {
1507     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1508     require(quantity > 0, "quantity must be nonzero");
1509     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1510 
1511     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1512     if (endIndex > collectionSize - 1) {
1513       endIndex = collectionSize - 1;
1514     }
1515     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1516     require(_exists(endIndex), "not enough minted yet for this cleanup");
1517     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1518       if (_ownerships[i].addr == address(0)) {
1519         TokenOwnership memory ownership = ownershipOf(i);
1520         _ownerships[i] = TokenOwnership(
1521           ownership.addr,
1522           ownership.startTimestamp
1523         );
1524       }
1525     }
1526     nextOwnerToExplicitlySet = endIndex + 1;
1527   }
1528 
1529   /**
1530    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1531    * The call is not executed if the target address is not a contract.
1532    *
1533    * @param from address representing the previous owner of the given token ID
1534    * @param to target address that will receive the tokens
1535    * @param tokenId uint256 ID of the token to be transferred
1536    * @param _data bytes optional data to send along with the call
1537    * @return bool whether the call correctly returned the expected magic value
1538    */
1539   function _checkOnERC721Received(
1540     address from,
1541     address to,
1542     uint256 tokenId,
1543     bytes memory _data
1544   ) private returns (bool) {
1545     if (to.isContract()) {
1546       try
1547         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1548       returns (bytes4 retval) {
1549         return retval == IERC721Receiver(to).onERC721Received.selector;
1550       } catch (bytes memory reason) {
1551         if (reason.length == 0) {
1552           revert("ERC721A: transfer to non ERC721Receiver implementer");
1553         } else {
1554           assembly {
1555             revert(add(32, reason), mload(reason))
1556           }
1557         }
1558       }
1559     } else {
1560       return true;
1561     }
1562   }
1563 
1564   /**
1565    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1566    *
1567    * startTokenId - the first token id to be transferred
1568    * quantity - the amount to be transferred
1569    *
1570    * Calling conditions:
1571    *
1572    * - When from and to are both non-zero, from's tokenId will be
1573    * transferred to to.
1574    * - When from is zero, tokenId will be minted for to.
1575    */
1576   function _beforeTokenTransfers(
1577     address from,
1578     address to,
1579     uint256 startTokenId,
1580     uint256 quantity
1581   ) internal virtual {}
1582 
1583   /**
1584    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1585    * minting.
1586    *
1587    * startTokenId - the first token id to be transferred
1588    * quantity - the amount to be transferred
1589    *
1590    * Calling conditions:
1591    *
1592    * - when from and to are both non-zero.
1593    * - from and to are never both zero.
1594    */
1595   function _afterTokenTransfers(
1596     address from,
1597     address to,
1598     uint256 startTokenId,
1599     uint256 quantity
1600   ) internal virtual {}
1601 }
1602 
1603 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1604 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1605 // @notice -- See Medium article --
1606 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1607 abstract contract ERC721ARedemption is ERC721A {
1608   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1609   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1610 
1611   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1612   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1613   
1614   uint256 public redemptionSurcharge = 0 ether;
1615   bool public redemptionModeEnabled;
1616   bool public verifiedClaimModeEnabled;
1617   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1618   mapping(address => bool) public redemptionContracts;
1619   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1620 
1621   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1622   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1623     redemptionContracts[_contractAddress] = _status;
1624   }
1625 
1626   // @dev Allow owner/team to determine if contract is accepting redemption mints
1627   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1628     redemptionModeEnabled = _newStatus;
1629   }
1630 
1631   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1632   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1633     verifiedClaimModeEnabled = _newStatus;
1634   }
1635 
1636   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1637   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1638     redemptionSurcharge = _newSurchargeInWei;
1639   }
1640 
1641   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1642   // @notice Must be a wallet address or implement IERC721Receiver.
1643   // Cannot be null address as this will break any ERC-721A implementation without a proper
1644   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1645   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1646     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1647     redemptionAddress = _newRedemptionAddress;
1648   }
1649 
1650   /**
1651   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1652   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1653   * the contract owner or Team => redemptionAddress. 
1654   * @param tokenId the token to be redeemed.
1655   * Emits a {Redeemed} event.
1656   **/
1657   function redeem(address redemptionContract, uint256 tokenId) public payable {
1658     if(getNextTokenId() > collectionSize) revert CapExceeded();
1659     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1660     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1661     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1662     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1663     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1664     
1665     IERC721 _targetContract = IERC721(redemptionContract);
1666     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1667     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1668     
1669     // Warning: Since there is no standarized return value for transfers of ERC-721
1670     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1671     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1672     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1673     // but the NFT may not have been sent to the redemptionAddress.
1674     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1675     tokenRedemptions[redemptionContract][tokenId] = true;
1676 
1677     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1678     _safeMint(_msgSender(), 1, false);
1679   }
1680 
1681   /**
1682   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1683   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1684   * @param tokenId the token to be redeemed.
1685   * Emits a {VerifiedClaim} event.
1686   **/
1687   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1688     if(getNextTokenId() > collectionSize) revert CapExceeded();
1689     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1690     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1691     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1692     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1693     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1694     
1695     tokenRedemptions[redemptionContract][tokenId] = true;
1696     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1697     _safeMint(_msgSender(), 1, false);
1698   }
1699 }
1700 
1701 
1702   
1703   
1704 interface IERC20 {
1705   function allowance(address owner, address spender) external view returns (uint256);
1706   function transfer(address _to, uint256 _amount) external returns (bool);
1707   function balanceOf(address account) external view returns (uint256);
1708   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1709 }
1710 
1711 // File: WithdrawableV2
1712 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1713 // ERC-20 Payouts are limited to a single payout address. This feature 
1714 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1715 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1716 abstract contract WithdrawableV2 is Teams {
1717   struct acceptedERC20 {
1718     bool isActive;
1719     uint256 chargeAmount;
1720   }
1721 
1722   
1723   mapping(address => acceptedERC20) private allowedTokenContracts;
1724   address[] public payableAddresses = [0x3bCf106f1A4ed6A33e64b323Ca824cdF04b40F70];
1725   address public erc20Payable = 0x3bCf106f1A4ed6A33e64b323Ca824cdF04b40F70;
1726   uint256[] public payableFees = [100];
1727   uint256 public payableAddressCount = 1;
1728   bool public onlyERC20MintingMode;
1729   
1730 
1731   function withdrawAll() public onlyTeamOrOwner {
1732       if(address(this).balance == 0) revert ValueCannotBeZero();
1733       _withdrawAll(address(this).balance);
1734   }
1735 
1736   function _withdrawAll(uint256 balance) private {
1737       for(uint i=0; i < payableAddressCount; i++ ) {
1738           _widthdraw(
1739               payableAddresses[i],
1740               (balance * payableFees[i]) / 100
1741           );
1742       }
1743   }
1744   
1745   function _widthdraw(address _address, uint256 _amount) private {
1746       (bool success, ) = _address.call{value: _amount}("");
1747       require(success, "Transfer failed.");
1748   }
1749 
1750   /**
1751   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1752   * in the event ERC-20 tokens are paid to the contract for mints.
1753   * @param _tokenContract contract of ERC-20 token to withdraw
1754   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1755   */
1756   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1757     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1758     IERC20 tokenContract = IERC20(_tokenContract);
1759     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1760     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1761   }
1762 
1763   /**
1764   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1765   * @param _erc20TokenContract address of ERC-20 contract in question
1766   */
1767   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1768     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1769   }
1770 
1771   /**
1772   * @dev get the value of tokens to transfer for user of an ERC-20
1773   * @param _erc20TokenContract address of ERC-20 contract in question
1774   */
1775   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1776     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1777     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1778   }
1779 
1780   /**
1781   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1782   * @param _erc20TokenContract address of ERC-20 contract in question
1783   * @param _isActive default status of if contract should be allowed to accept payments
1784   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1785   */
1786   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1787     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1788     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1789   }
1790 
1791   /**
1792   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1793   * it will assume the default value of zero. This should not be used to create new payment tokens.
1794   * @param _erc20TokenContract address of ERC-20 contract in question
1795   */
1796   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1797     allowedTokenContracts[_erc20TokenContract].isActive = true;
1798   }
1799 
1800   /**
1801   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1802   * it will assume the default value of zero. This should not be used to create new payment tokens.
1803   * @param _erc20TokenContract address of ERC-20 contract in question
1804   */
1805   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1806     allowedTokenContracts[_erc20TokenContract].isActive = false;
1807   }
1808 
1809   /**
1810   * @dev Enable only ERC-20 payments for minting on this contract
1811   */
1812   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1813     onlyERC20MintingMode = true;
1814   }
1815 
1816   /**
1817   * @dev Disable only ERC-20 payments for minting on this contract
1818   */
1819   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1820     onlyERC20MintingMode = false;
1821   }
1822 
1823   /**
1824   * @dev Set the payout of the ERC-20 token payout to a specific address
1825   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1826   */
1827   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1828     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1829     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1830     erc20Payable = _newErc20Payable;
1831   }
1832 }
1833 
1834 
1835   
1836   
1837 // File: EarlyMintIncentive.sol
1838 // Allows the contract to have the first x tokens have a discount or
1839 // zero fee that can be calculated on the fly.
1840 abstract contract EarlyMintIncentive is Teams, ERC721A {
1841   uint256 public PRICE = 0.001 ether;
1842   uint256 public EARLY_MINT_PRICE = 0 ether;
1843   uint256 public earlyMintTokenIdCap = 69;
1844   bool public usingEarlyMintIncentive = true;
1845 
1846   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1847     usingEarlyMintIncentive = true;
1848   }
1849 
1850   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1851     usingEarlyMintIncentive = false;
1852   }
1853 
1854   /**
1855   * @dev Set the max token ID in which the cost incentive will be applied.
1856   * @param _newTokenIdCap max tokenId in which incentive will be applied
1857   */
1858   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1859     if(_newTokenIdCap > collectionSize) revert CapExceeded();
1860     if(_newTokenIdCap == 0) revert ValueCannotBeZero();
1861     earlyMintTokenIdCap = _newTokenIdCap;
1862   }
1863 
1864   /**
1865   * @dev Set the incentive mint price
1866   * @param _feeInWei new price per token when in incentive range
1867   */
1868   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1869     EARLY_MINT_PRICE = _feeInWei;
1870   }
1871 
1872   /**
1873   * @dev Set the primary mint price - the base price when not under incentive
1874   * @param _feeInWei new price per token
1875   */
1876   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1877     PRICE = _feeInWei;
1878   }
1879 
1880   function getPrice(uint256 _count) public view returns (uint256) {
1881     if(_count == 0) revert ValueCannotBeZero();
1882 
1883     // short circuit function if we dont need to even calc incentive pricing
1884     // short circuit if the current tokenId is also already over cap
1885     if(
1886       usingEarlyMintIncentive == false ||
1887       currentTokenId() > earlyMintTokenIdCap
1888     ) {
1889       return PRICE * _count;
1890     }
1891 
1892     uint256 endingTokenId = currentTokenId() + _count;
1893     // If qty to mint results in a final token ID less than or equal to the cap then
1894     // the entire qty is within free mint.
1895     if(endingTokenId  <= earlyMintTokenIdCap) {
1896       return EARLY_MINT_PRICE * _count;
1897     }
1898 
1899     // If the current token id is less than the incentive cap
1900     // and the ending token ID is greater than the incentive cap
1901     // we will be straddling the cap so there will be some amount
1902     // that are incentive and some that are regular fee.
1903     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1904     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1905 
1906     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1907   }
1908 }
1909 
1910   
1911   
1912 abstract contract RamppERC721A is 
1913     Ownable,
1914     Teams,
1915     ERC721ARedemption,
1916     WithdrawableV2,
1917     ReentrancyGuard 
1918     , EarlyMintIncentive 
1919      
1920     
1921 {
1922   constructor(
1923     string memory tokenName,
1924     string memory tokenSymbol
1925   ) ERC721A(tokenName, tokenSymbol, 2, 369) { }
1926     uint8 constant public CONTRACT_VERSION = 2;
1927     string public _baseTokenURI = "ipfs://bafybeiegzhnevj4ctwiv4pfx67bqj7bwg5i75uhp2uzyjd7nkhutrwmjtm/";
1928     string public _baseTokenExtension = ".json";
1929 
1930     bool public mintingOpen = true;
1931     
1932     
1933     uint256 public MAX_WALLET_MINTS = 2;
1934 
1935   
1936     /////////////// Admin Mint Functions
1937     /**
1938      * @dev Mints a token to an address with a tokenURI.
1939      * This is owner only and allows a fee-free drop
1940      * @param _to address of the future owner of the token
1941      * @param _qty amount of tokens to drop the owner
1942      */
1943      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1944          if(_qty == 0) revert MintZeroQuantity();
1945          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1946          _safeMint(_to, _qty, true);
1947      }
1948 
1949   
1950     /////////////// PUBLIC MINT FUNCTIONS
1951     /**
1952     * @dev Mints tokens to an address in batch.
1953     * fee may or may not be required*
1954     * @param _to address of the future owner of the token
1955     * @param _amount number of tokens to mint
1956     */
1957     function mintToMultiple(address _to, uint256 _amount) public payable {
1958         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1959         if(_amount == 0) revert MintZeroQuantity();
1960         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1961         if(!mintingOpen) revert PublicMintClosed();
1962         
1963         
1964         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1965         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1966         if(msg.value != getPrice(_amount)) revert InvalidPayment();
1967 
1968         _safeMint(_to, _amount, false);
1969     }
1970 
1971     /**
1972      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1973      * fee may or may not be required*
1974      * @param _to address of the future owner of the token
1975      * @param _amount number of tokens to mint
1976      * @param _erc20TokenContract erc-20 token contract to mint with
1977      */
1978     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1979       if(_amount == 0) revert MintZeroQuantity();
1980       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1981       if(!mintingOpen) revert PublicMintClosed();
1982       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1983       
1984       
1985       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1986 
1987       // ERC-20 Specific pre-flight checks
1988       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1989       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1990       IERC20 payableToken = IERC20(_erc20TokenContract);
1991 
1992       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1993       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1994 
1995       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1996       if(!transferComplete) revert ERC20TransferFailed();
1997       
1998       _safeMint(_to, _amount, false);
1999     }
2000 
2001     function openMinting() public onlyTeamOrOwner {
2002         mintingOpen = true;
2003     }
2004 
2005     function stopMinting() public onlyTeamOrOwner {
2006         mintingOpen = false;
2007     }
2008 
2009   
2010 
2011   
2012     /**
2013     * @dev Check if wallet over MAX_WALLET_MINTS
2014     * @param _address address in question to check if minted count exceeds max
2015     */
2016     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2017         if(_amount == 0) revert ValueCannotBeZero();
2018         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2019     }
2020 
2021     /**
2022     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2023     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2024     */
2025     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2026         if(_newWalletMax == 0) revert ValueCannotBeZero();
2027         MAX_WALLET_MINTS = _newWalletMax;
2028     }
2029     
2030 
2031   
2032     /**
2033      * @dev Allows owner to set Max mints per tx
2034      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2035      */
2036      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2037          if(_newMaxMint == 0) revert ValueCannotBeZero();
2038          maxBatchSize = _newMaxMint;
2039      }
2040     
2041 
2042   
2043   
2044   
2045   function contractURI() public pure returns (string memory) {
2046     return "https://metadata.mintplex.xyz/INwRRv2IA14u9c51dfJP/contract-metadata";
2047   }
2048   
2049 
2050   function _baseURI() internal view virtual override returns(string memory) {
2051     return _baseTokenURI;
2052   }
2053 
2054   function _baseURIExtension() internal view virtual override returns(string memory) {
2055     return _baseTokenExtension;
2056   }
2057 
2058   function baseTokenURI() public view returns(string memory) {
2059     return _baseTokenURI;
2060   }
2061 
2062   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2063     _baseTokenURI = baseURI;
2064   }
2065 
2066   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2067     _baseTokenExtension = baseExtension;
2068   }
2069 }
2070 
2071 
2072   
2073 // File: contracts/DreamsByRoninContract.sol
2074 //SPDX-License-Identifier: MIT
2075 
2076 pragma solidity ^0.8.0;
2077 
2078 contract DreamsByRoninContract is RamppERC721A {
2079     constructor() RamppERC721A("Dreams By Ronin", "DBR"){}
2080 }
2081   
2082 //*********************************************************************//
2083 //*********************************************************************//  
2084 //                       Mintplex v3.0.0
2085 //
2086 //         This smart contract was generated by mintplex.xyz.
2087 //            Mintplex allows creators like you to launch 
2088 //             large scale NFT communities without code!
2089 //
2090 //    Mintplex is not responsible for the content of this contract and
2091 //        hopes it is being used in a responsible and kind way.  
2092 //       Mintplex is not associated or affiliated with this project.                                                    
2093 //             Twitter: @MintplexNFT ---- mintplex.xyz
2094 //*********************************************************************//                                                     
2095 //*********************************************************************// 
