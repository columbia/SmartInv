1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  /$$$$$$$                      /$$             /$$$$$$$                                            /$$    
5 // | $$__  $$                    | $$            | $$__  $$                                          | $$    
6 // | $$  \ $$  /$$$$$$   /$$$$$$ | $$   /$$      | $$  \ $$ /$$   /$$  /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$  
7 // | $$  | $$ |____  $$ /$$__  $$| $$  /$$/      | $$$$$$$/| $$  | $$ /$$__  $$ /$$__  $$ /$$__  $$|_  $$_/  
8 // | $$  | $$  /$$$$$$$| $$  \__/| $$$$$$/       | $$____/ | $$  | $$| $$  \ $$| $$  \ $$| $$$$$$$$  | $$    
9 // | $$  | $$ /$$__  $$| $$      | $$_  $$       | $$      | $$  | $$| $$  | $$| $$  | $$| $$_____/  | $$ /$$
10 // | $$$$$$$/|  $$$$$$$| $$      | $$ \  $$      | $$      |  $$$$$$/| $$$$$$$/| $$$$$$$/|  $$$$$$$  |  $$$$/
11 // |_______/  \_______/|__/      |__/  \__/      |__/       \______/ | $$____/ | $$____/  \_______/   \___/  
12 //                                                                   | $$      | $$                          
13 //                                                                   | $$      | $$                          
14 //                                                                   |__/      |__/                          
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
860   IERC721Enumerable,
861   Teams
862 {
863   using Address for address;
864   using Strings for uint256;
865 
866   struct TokenOwnership {
867     address addr;
868     uint64 startTimestamp;
869   }
870 
871   struct AddressData {
872     uint128 balance;
873     uint128 numberMinted;
874   }
875 
876   uint256 private currentIndex;
877 
878   uint256 public immutable collectionSize;
879   uint256 public maxBatchSize;
880 
881   // Token name
882   string private _name;
883 
884   // Token symbol
885   string private _symbol;
886 
887   // Mapping from token ID to ownership details
888   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
889   mapping(uint256 => TokenOwnership) private _ownerships;
890 
891   // Mapping owner address to address data
892   mapping(address => AddressData) private _addressData;
893 
894   // Mapping from token ID to approved address
895   mapping(uint256 => address) private _tokenApprovals;
896 
897   // Mapping from owner to operator approvals
898   mapping(address => mapping(address => bool)) private _operatorApprovals;
899 
900   /* @dev Mapping of restricted operator approvals set by contract Owner
901   * This serves as an optional addition to ERC-721 so
902   * that the contract owner can elect to prevent specific addresses/contracts
903   * from being marked as the approver for a token. The reason for this
904   * is that some projects may want to retain control of where their tokens can/can not be listed
905   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
906   * By default, there are no restrictions. The contract owner must deliberatly block an address 
907   */
908   mapping(address => bool) public restrictedApprovalAddresses;
909 
910   /**
911    * @dev
912    * maxBatchSize refers to how much a minter can mint at a time.
913    * collectionSize_ refers to how many tokens are in the collection.
914    */
915   constructor(
916     string memory name_,
917     string memory symbol_,
918     uint256 maxBatchSize_,
919     uint256 collectionSize_
920   ) {
921     require(
922       collectionSize_ > 0,
923       "ERC721A: collection must have a nonzero supply"
924     );
925     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
926     _name = name_;
927     _symbol = symbol_;
928     maxBatchSize = maxBatchSize_;
929     collectionSize = collectionSize_;
930     currentIndex = _startTokenId();
931   }
932 
933   /**
934   * To change the starting tokenId, please override this function.
935   */
936   function _startTokenId() internal view virtual returns (uint256) {
937     return 1;
938   }
939 
940   /**
941    * @dev See {IERC721Enumerable-totalSupply}.
942    */
943   function totalSupply() public view override returns (uint256) {
944     return _totalMinted();
945   }
946 
947   function currentTokenId() public view returns (uint256) {
948     return _totalMinted();
949   }
950 
951   function getNextTokenId() public view returns (uint256) {
952       return _totalMinted() + 1;
953   }
954 
955   /**
956   * Returns the total amount of tokens minted in the contract.
957   */
958   function _totalMinted() internal view returns (uint256) {
959     unchecked {
960       return currentIndex - _startTokenId();
961     }
962   }
963 
964   /**
965    * @dev See {IERC721Enumerable-tokenByIndex}.
966    */
967   function tokenByIndex(uint256 index) public view override returns (uint256) {
968     require(index < totalSupply(), "ERC721A: global index out of bounds");
969     return index;
970   }
971 
972   /**
973    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
974    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
975    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
976    */
977   function tokenOfOwnerByIndex(address owner, uint256 index)
978     public
979     view
980     override
981     returns (uint256)
982   {
983     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
984     uint256 numMintedSoFar = totalSupply();
985     uint256 tokenIdsIdx = 0;
986     address currOwnershipAddr = address(0);
987     for (uint256 i = 0; i < numMintedSoFar; i++) {
988       TokenOwnership memory ownership = _ownerships[i];
989       if (ownership.addr != address(0)) {
990         currOwnershipAddr = ownership.addr;
991       }
992       if (currOwnershipAddr == owner) {
993         if (tokenIdsIdx == index) {
994           return i;
995         }
996         tokenIdsIdx++;
997       }
998     }
999     revert("ERC721A: unable to get token of owner by index");
1000   }
1001 
1002   /**
1003    * @dev See {IERC165-supportsInterface}.
1004    */
1005   function supportsInterface(bytes4 interfaceId)
1006     public
1007     view
1008     virtual
1009     override(ERC165, IERC165)
1010     returns (bool)
1011   {
1012     return
1013       interfaceId == type(IERC721).interfaceId ||
1014       interfaceId == type(IERC721Metadata).interfaceId ||
1015       interfaceId == type(IERC721Enumerable).interfaceId ||
1016       super.supportsInterface(interfaceId);
1017   }
1018 
1019   /**
1020    * @dev See {IERC721-balanceOf}.
1021    */
1022   function balanceOf(address owner) public view override returns (uint256) {
1023     require(owner != address(0), "ERC721A: balance query for the zero address");
1024     return uint256(_addressData[owner].balance);
1025   }
1026 
1027   function _numberMinted(address owner) internal view returns (uint256) {
1028     require(
1029       owner != address(0),
1030       "ERC721A: number minted query for the zero address"
1031     );
1032     return uint256(_addressData[owner].numberMinted);
1033   }
1034 
1035   function ownershipOf(uint256 tokenId)
1036     internal
1037     view
1038     returns (TokenOwnership memory)
1039   {
1040     uint256 curr = tokenId;
1041 
1042     unchecked {
1043         if (_startTokenId() <= curr && curr < currentIndex) {
1044             TokenOwnership memory ownership = _ownerships[curr];
1045             if (ownership.addr != address(0)) {
1046                 return ownership;
1047             }
1048 
1049             // Invariant:
1050             // There will always be an ownership that has an address and is not burned
1051             // before an ownership that does not have an address and is not burned.
1052             // Hence, curr will not underflow.
1053             while (true) {
1054                 curr--;
1055                 ownership = _ownerships[curr];
1056                 if (ownership.addr != address(0)) {
1057                     return ownership;
1058                 }
1059             }
1060         }
1061     }
1062 
1063     revert("ERC721A: unable to determine the owner of token");
1064   }
1065 
1066   /**
1067    * @dev See {IERC721-ownerOf}.
1068    */
1069   function ownerOf(uint256 tokenId) public view override returns (address) {
1070     return ownershipOf(tokenId).addr;
1071   }
1072 
1073   /**
1074    * @dev See {IERC721Metadata-name}.
1075    */
1076   function name() public view virtual override returns (string memory) {
1077     return _name;
1078   }
1079 
1080   /**
1081    * @dev See {IERC721Metadata-symbol}.
1082    */
1083   function symbol() public view virtual override returns (string memory) {
1084     return _symbol;
1085   }
1086 
1087   /**
1088    * @dev See {IERC721Metadata-tokenURI}.
1089    */
1090   function tokenURI(uint256 tokenId)
1091     public
1092     view
1093     virtual
1094     override
1095     returns (string memory)
1096   {
1097     string memory baseURI = _baseURI();
1098     return
1099       bytes(baseURI).length > 0
1100         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1101         : "";
1102   }
1103 
1104   /**
1105    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1106    * token will be the concatenation of the baseURI and the tokenId. Empty
1107    * by default, can be overriden in child contracts.
1108    */
1109   function _baseURI() internal view virtual returns (string memory) {
1110     return "";
1111   }
1112 
1113   /**
1114    * @dev Sets the value for an address to be in the restricted approval address pool.
1115    * Setting an address to true will disable token owners from being able to mark the address
1116    * for approval for trading. This would be used in theory to prevent token owners from listing
1117    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1118    * @param _address the marketplace/user to modify restriction status of
1119    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1120    */
1121   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1122     restrictedApprovalAddresses[_address] = _isRestricted;
1123   }
1124 
1125   /**
1126    * @dev See {IERC721-approve}.
1127    */
1128   function approve(address to, uint256 tokenId) public override {
1129     address owner = ERC721A.ownerOf(tokenId);
1130     require(to != owner, "ERC721A: approval to current owner");
1131     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1132 
1133     require(
1134       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1135       "ERC721A: approve caller is not owner nor approved for all"
1136     );
1137 
1138     _approve(to, tokenId, owner);
1139   }
1140 
1141   /**
1142    * @dev See {IERC721-getApproved}.
1143    */
1144   function getApproved(uint256 tokenId) public view override returns (address) {
1145     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1146 
1147     return _tokenApprovals[tokenId];
1148   }
1149 
1150   /**
1151    * @dev See {IERC721-setApprovalForAll}.
1152    */
1153   function setApprovalForAll(address operator, bool approved) public override {
1154     require(operator != _msgSender(), "ERC721A: approve to caller");
1155     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1156 
1157     _operatorApprovals[_msgSender()][operator] = approved;
1158     emit ApprovalForAll(_msgSender(), operator, approved);
1159   }
1160 
1161   /**
1162    * @dev See {IERC721-isApprovedForAll}.
1163    */
1164   function isApprovedForAll(address owner, address operator)
1165     public
1166     view
1167     virtual
1168     override
1169     returns (bool)
1170   {
1171     return _operatorApprovals[owner][operator];
1172   }
1173 
1174   /**
1175    * @dev See {IERC721-transferFrom}.
1176    */
1177   function transferFrom(
1178     address from,
1179     address to,
1180     uint256 tokenId
1181   ) public override {
1182     _transfer(from, to, tokenId);
1183   }
1184 
1185   /**
1186    * @dev See {IERC721-safeTransferFrom}.
1187    */
1188   function safeTransferFrom(
1189     address from,
1190     address to,
1191     uint256 tokenId
1192   ) public override {
1193     safeTransferFrom(from, to, tokenId, "");
1194   }
1195 
1196   /**
1197    * @dev See {IERC721-safeTransferFrom}.
1198    */
1199   function safeTransferFrom(
1200     address from,
1201     address to,
1202     uint256 tokenId,
1203     bytes memory _data
1204   ) public override {
1205     _transfer(from, to, tokenId);
1206     require(
1207       _checkOnERC721Received(from, to, tokenId, _data),
1208       "ERC721A: transfer to non ERC721Receiver implementer"
1209     );
1210   }
1211 
1212   /**
1213    * @dev Returns whether tokenId exists.
1214    *
1215    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1216    *
1217    * Tokens start existing when they are minted (_mint),
1218    */
1219   function _exists(uint256 tokenId) internal view returns (bool) {
1220     return _startTokenId() <= tokenId && tokenId < currentIndex;
1221   }
1222 
1223   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1224     _safeMint(to, quantity, isAdminMint, "");
1225   }
1226 
1227   /**
1228    * @dev Mints quantity tokens and transfers them to to.
1229    *
1230    * Requirements:
1231    *
1232    * - there must be quantity tokens remaining unminted in the total collection.
1233    * - to cannot be the zero address.
1234    * - quantity cannot be larger than the max batch size.
1235    *
1236    * Emits a {Transfer} event.
1237    */
1238   function _safeMint(
1239     address to,
1240     uint256 quantity,
1241     bool isAdminMint,
1242     bytes memory _data
1243   ) internal {
1244     uint256 startTokenId = currentIndex;
1245     require(to != address(0), "ERC721A: mint to the zero address");
1246     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1247     require(!_exists(startTokenId), "ERC721A: token already minted");
1248 
1249     // For admin mints we do not want to enforce the maxBatchSize limit
1250     if (isAdminMint == false) {
1251         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1252     }
1253 
1254     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1255 
1256     AddressData memory addressData = _addressData[to];
1257     _addressData[to] = AddressData(
1258       addressData.balance + uint128(quantity),
1259       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1260     );
1261     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1262 
1263     uint256 updatedIndex = startTokenId;
1264 
1265     for (uint256 i = 0; i < quantity; i++) {
1266       emit Transfer(address(0), to, updatedIndex);
1267       require(
1268         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1269         "ERC721A: transfer to non ERC721Receiver implementer"
1270       );
1271       updatedIndex++;
1272     }
1273 
1274     currentIndex = updatedIndex;
1275     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1276   }
1277 
1278   /**
1279    * @dev Transfers tokenId from from to to.
1280    *
1281    * Requirements:
1282    *
1283    * - to cannot be the zero address.
1284    * - tokenId token must be owned by from.
1285    *
1286    * Emits a {Transfer} event.
1287    */
1288   function _transfer(
1289     address from,
1290     address to,
1291     uint256 tokenId
1292   ) private {
1293     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1294 
1295     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1296       getApproved(tokenId) == _msgSender() ||
1297       isApprovedForAll(prevOwnership.addr, _msgSender()));
1298 
1299     require(
1300       isApprovedOrOwner,
1301       "ERC721A: transfer caller is not owner nor approved"
1302     );
1303 
1304     require(
1305       prevOwnership.addr == from,
1306       "ERC721A: transfer from incorrect owner"
1307     );
1308     require(to != address(0), "ERC721A: transfer to the zero address");
1309 
1310     _beforeTokenTransfers(from, to, tokenId, 1);
1311 
1312     // Clear approvals from the previous owner
1313     _approve(address(0), tokenId, prevOwnership.addr);
1314 
1315     _addressData[from].balance -= 1;
1316     _addressData[to].balance += 1;
1317     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1318 
1319     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1320     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1321     uint256 nextTokenId = tokenId + 1;
1322     if (_ownerships[nextTokenId].addr == address(0)) {
1323       if (_exists(nextTokenId)) {
1324         _ownerships[nextTokenId] = TokenOwnership(
1325           prevOwnership.addr,
1326           prevOwnership.startTimestamp
1327         );
1328       }
1329     }
1330 
1331     emit Transfer(from, to, tokenId);
1332     _afterTokenTransfers(from, to, tokenId, 1);
1333   }
1334 
1335   /**
1336    * @dev Approve to to operate on tokenId
1337    *
1338    * Emits a {Approval} event.
1339    */
1340   function _approve(
1341     address to,
1342     uint256 tokenId,
1343     address owner
1344   ) private {
1345     _tokenApprovals[tokenId] = to;
1346     emit Approval(owner, to, tokenId);
1347   }
1348 
1349   uint256 public nextOwnerToExplicitlySet = 0;
1350 
1351   /**
1352    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1353    */
1354   function _setOwnersExplicit(uint256 quantity) internal {
1355     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1356     require(quantity > 0, "quantity must be nonzero");
1357     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1358 
1359     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1360     if (endIndex > collectionSize - 1) {
1361       endIndex = collectionSize - 1;
1362     }
1363     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1364     require(_exists(endIndex), "not enough minted yet for this cleanup");
1365     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1366       if (_ownerships[i].addr == address(0)) {
1367         TokenOwnership memory ownership = ownershipOf(i);
1368         _ownerships[i] = TokenOwnership(
1369           ownership.addr,
1370           ownership.startTimestamp
1371         );
1372       }
1373     }
1374     nextOwnerToExplicitlySet = endIndex + 1;
1375   }
1376 
1377   /**
1378    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1379    * The call is not executed if the target address is not a contract.
1380    *
1381    * @param from address representing the previous owner of the given token ID
1382    * @param to target address that will receive the tokens
1383    * @param tokenId uint256 ID of the token to be transferred
1384    * @param _data bytes optional data to send along with the call
1385    * @return bool whether the call correctly returned the expected magic value
1386    */
1387   function _checkOnERC721Received(
1388     address from,
1389     address to,
1390     uint256 tokenId,
1391     bytes memory _data
1392   ) private returns (bool) {
1393     if (to.isContract()) {
1394       try
1395         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1396       returns (bytes4 retval) {
1397         return retval == IERC721Receiver(to).onERC721Received.selector;
1398       } catch (bytes memory reason) {
1399         if (reason.length == 0) {
1400           revert("ERC721A: transfer to non ERC721Receiver implementer");
1401         } else {
1402           assembly {
1403             revert(add(32, reason), mload(reason))
1404           }
1405         }
1406       }
1407     } else {
1408       return true;
1409     }
1410   }
1411 
1412   /**
1413    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1414    *
1415    * startTokenId - the first token id to be transferred
1416    * quantity - the amount to be transferred
1417    *
1418    * Calling conditions:
1419    *
1420    * - When from and to are both non-zero, from's tokenId will be
1421    * transferred to to.
1422    * - When from is zero, tokenId will be minted for to.
1423    */
1424   function _beforeTokenTransfers(
1425     address from,
1426     address to,
1427     uint256 startTokenId,
1428     uint256 quantity
1429   ) internal virtual {}
1430 
1431   /**
1432    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1433    * minting.
1434    *
1435    * startTokenId - the first token id to be transferred
1436    * quantity - the amount to be transferred
1437    *
1438    * Calling conditions:
1439    *
1440    * - when from and to are both non-zero.
1441    * - from and to are never both zero.
1442    */
1443   function _afterTokenTransfers(
1444     address from,
1445     address to,
1446     uint256 startTokenId,
1447     uint256 quantity
1448   ) internal virtual {}
1449 }
1450 
1451 
1452 
1453   
1454 abstract contract Ramppable {
1455   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1456 
1457   modifier isRampp() {
1458       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1459       _;
1460   }
1461 }
1462 
1463 
1464   
1465   
1466 interface IERC20 {
1467   function allowance(address owner, address spender) external view returns (uint256);
1468   function transfer(address _to, uint256 _amount) external returns (bool);
1469   function balanceOf(address account) external view returns (uint256);
1470   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1471 }
1472 
1473 // File: WithdrawableV2
1474 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1475 // ERC-20 Payouts are limited to a single payout address. This feature 
1476 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1477 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1478 abstract contract WithdrawableV2 is Teams, Ramppable {
1479   struct acceptedERC20 {
1480     bool isActive;
1481     uint256 chargeAmount;
1482   }
1483 
1484   
1485   mapping(address => acceptedERC20) private allowedTokenContracts;
1486   address[] public payableAddresses = [RAMPPADDRESS,0xAdCB77fe4cc7154734edB3A1c3baFD584CB917Ea];
1487   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1488   address public erc20Payable = 0xAdCB77fe4cc7154734edB3A1c3baFD584CB917Ea;
1489   uint256[] public payableFees = [5,95];
1490   uint256[] public surchargePayableFees = [100];
1491   uint256 public payableAddressCount = 2;
1492   uint256 public surchargePayableAddressCount = 1;
1493   uint256 public ramppSurchargeBalance = 0 ether;
1494   uint256 public ramppSurchargeFee = 0.001 ether;
1495   bool public onlyERC20MintingMode = false;
1496   
1497 
1498   /**
1499   * @dev Calculates the true payable balance of the contract as the
1500   * value on contract may be from ERC-20 mint surcharges and not 
1501   * public mint charges - which are not eligable for rev share & user withdrawl
1502   */
1503   function calcAvailableBalance() public view returns(uint256) {
1504     return address(this).balance - ramppSurchargeBalance;
1505   }
1506 
1507   function withdrawAll() public onlyTeamOrOwner {
1508       require(calcAvailableBalance() > 0);
1509       _withdrawAll();
1510   }
1511   
1512   function withdrawAllRampp() public isRampp {
1513       require(calcAvailableBalance() > 0);
1514       _withdrawAll();
1515   }
1516 
1517   function _withdrawAll() private {
1518       uint256 balance = calcAvailableBalance();
1519       
1520       for(uint i=0; i < payableAddressCount; i++ ) {
1521           _widthdraw(
1522               payableAddresses[i],
1523               (balance * payableFees[i]) / 100
1524           );
1525       }
1526   }
1527   
1528   function _widthdraw(address _address, uint256 _amount) private {
1529       (bool success, ) = _address.call{value: _amount}("");
1530       require(success, "Transfer failed.");
1531   }
1532 
1533   /**
1534   * @dev This function is similiar to the regular withdraw but operates only on the
1535   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1536   **/
1537   function _withdrawAllSurcharges() private {
1538     uint256 balance = ramppSurchargeBalance;
1539     if(balance == 0) { return; }
1540     
1541     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1542         _widthdraw(
1543             surchargePayableAddresses[i],
1544             (balance * surchargePayableFees[i]) / 100
1545         );
1546     }
1547     ramppSurchargeBalance = 0 ether;
1548   }
1549 
1550   /**
1551   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1552   * in the event ERC-20 tokens are paid to the contract for mints. This will
1553   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1554   * @param _tokenContract contract of ERC-20 token to withdraw
1555   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1556   */
1557   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1558     require(_amountToWithdraw > 0);
1559     IERC20 tokenContract = IERC20(_tokenContract);
1560     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1561     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1562     _withdrawAllSurcharges();
1563   }
1564 
1565   /**
1566   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1567   */
1568   function withdrawRamppSurcharges() public isRampp {
1569     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1570     _withdrawAllSurcharges();
1571   }
1572 
1573    /**
1574   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1575   */
1576   function addSurcharge() internal {
1577     ramppSurchargeBalance += ramppSurchargeFee;
1578   }
1579   
1580   /**
1581   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1582   */
1583   function hasSurcharge() internal returns(bool) {
1584     return msg.value == ramppSurchargeFee;
1585   }
1586 
1587   /**
1588   * @dev Set surcharge fee for using ERC-20 payments on contract
1589   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1590   */
1591   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1592     ramppSurchargeFee = _newSurcharge;
1593   }
1594 
1595   /**
1596   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1597   * @param _erc20TokenContract address of ERC-20 contract in question
1598   */
1599   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1600     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1601   }
1602 
1603   /**
1604   * @dev get the value of tokens to transfer for user of an ERC-20
1605   * @param _erc20TokenContract address of ERC-20 contract in question
1606   */
1607   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1608     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1609     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1610   }
1611 
1612   /**
1613   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1614   * @param _erc20TokenContract address of ERC-20 contract in question
1615   * @param _isActive default status of if contract should be allowed to accept payments
1616   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1617   */
1618   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1619     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1620     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1621   }
1622 
1623   /**
1624   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1625   * it will assume the default value of zero. This should not be used to create new payment tokens.
1626   * @param _erc20TokenContract address of ERC-20 contract in question
1627   */
1628   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1629     allowedTokenContracts[_erc20TokenContract].isActive = true;
1630   }
1631 
1632   /**
1633   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1634   * it will assume the default value of zero. This should not be used to create new payment tokens.
1635   * @param _erc20TokenContract address of ERC-20 contract in question
1636   */
1637   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1638     allowedTokenContracts[_erc20TokenContract].isActive = false;
1639   }
1640 
1641   /**
1642   * @dev Enable only ERC-20 payments for minting on this contract
1643   */
1644   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1645     onlyERC20MintingMode = true;
1646   }
1647 
1648   /**
1649   * @dev Disable only ERC-20 payments for minting on this contract
1650   */
1651   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1652     onlyERC20MintingMode = false;
1653   }
1654 
1655   /**
1656   * @dev Set the payout of the ERC-20 token payout to a specific address
1657   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1658   */
1659   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1660     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1661     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1662     erc20Payable = _newErc20Payable;
1663   }
1664 
1665   /**
1666   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1667   */
1668   function resetRamppSurchargeBalance() public isRampp {
1669     ramppSurchargeBalance = 0 ether;
1670   }
1671 
1672   /**
1673   * @dev Allows Rampp wallet to update its own reference as well as update
1674   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1675   * and since Rampp is always the first address this function is limited to the rampp payout only.
1676   * @param _newAddress updated Rampp Address
1677   */
1678   function setRamppAddress(address _newAddress) public isRampp {
1679     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1680     RAMPPADDRESS = _newAddress;
1681     payableAddresses[0] = _newAddress;
1682   }
1683 }
1684 
1685 
1686   
1687 // File: isFeeable.sol
1688 abstract contract Feeable is Teams {
1689   uint256 public PRICE = 0.012 ether;
1690 
1691   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1692     PRICE = _feeInWei;
1693   }
1694 
1695   function getPrice(uint256 _count) public view returns (uint256) {
1696     return PRICE * _count;
1697   }
1698 }
1699 
1700   
1701   
1702   
1703 abstract contract RamppERC721A is 
1704     Ownable,
1705     Teams,
1706     ERC721A,
1707     WithdrawableV2,
1708     ReentrancyGuard 
1709     , Feeable 
1710      
1711     
1712 {
1713   constructor(
1714     string memory tokenName,
1715     string memory tokenSymbol
1716   ) ERC721A(tokenName, tokenSymbol, 10, 444) { }
1717     uint8 public CONTRACT_VERSION = 2;
1718     string public _baseTokenURI = "ipfs://bafybeiberatdx5o25sd5sjn6irkss2xmol3b4ymmchxrale44fssxrb2ya/";
1719 
1720     bool public mintingOpen = true;
1721     
1722     
1723 
1724   
1725     /////////////// Admin Mint Functions
1726     /**
1727      * @dev Mints a token to an address with a tokenURI.
1728      * This is owner only and allows a fee-free drop
1729      * @param _to address of the future owner of the token
1730      * @param _qty amount of tokens to drop the owner
1731      */
1732      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1733          require(_qty > 0, "Must mint at least 1 token.");
1734          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 444");
1735          _safeMint(_to, _qty, true);
1736      }
1737 
1738   
1739     /////////////// GENERIC MINT FUNCTIONS
1740     /**
1741     * @dev Mints a single token to an address.
1742     * fee may or may not be required*
1743     * @param _to address of the future owner of the token
1744     */
1745     function mintTo(address _to) public payable {
1746         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1747         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 444");
1748         require(mintingOpen == true, "Minting is not open right now!");
1749         
1750         
1751         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1752         
1753         _safeMint(_to, 1, false);
1754     }
1755 
1756     /**
1757     * @dev Mints tokens to an address in batch.
1758     * fee may or may not be required*
1759     * @param _to address of the future owner of the token
1760     * @param _amount number of tokens to mint
1761     */
1762     function mintToMultiple(address _to, uint256 _amount) public payable {
1763         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1764         require(_amount >= 1, "Must mint at least 1 token");
1765         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1766         require(mintingOpen == true, "Minting is not open right now!");
1767         
1768         
1769         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 444");
1770         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1771 
1772         _safeMint(_to, _amount, false);
1773     }
1774 
1775     /**
1776      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1777      * fee may or may not be required*
1778      * @param _to address of the future owner of the token
1779      * @param _amount number of tokens to mint
1780      * @param _erc20TokenContract erc-20 token contract to mint with
1781      */
1782     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1783       require(_amount >= 1, "Must mint at least 1 token");
1784       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1785       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 444");
1786       require(mintingOpen == true, "Minting is not open right now!");
1787       
1788       
1789 
1790       // ERC-20 Specific pre-flight checks
1791       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1792       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1793       IERC20 payableToken = IERC20(_erc20TokenContract);
1794 
1795       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1796       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1797       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1798       
1799       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1800       require(transferComplete, "ERC-20 token was unable to be transferred");
1801       
1802       _safeMint(_to, _amount, false);
1803       addSurcharge();
1804     }
1805 
1806     function openMinting() public onlyTeamOrOwner {
1807         mintingOpen = true;
1808     }
1809 
1810     function stopMinting() public onlyTeamOrOwner {
1811         mintingOpen = false;
1812     }
1813 
1814   
1815 
1816   
1817 
1818   
1819     /**
1820      * @dev Allows owner to set Max mints per tx
1821      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1822      */
1823      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1824          require(_newMaxMint >= 1, "Max mint must be at least 1");
1825          maxBatchSize = _newMaxMint;
1826      }
1827     
1828 
1829   
1830 
1831   function _baseURI() internal view virtual override returns(string memory) {
1832     return _baseTokenURI;
1833   }
1834 
1835   function baseTokenURI() public view returns(string memory) {
1836     return _baseTokenURI;
1837   }
1838 
1839   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1840     _baseTokenURI = baseURI;
1841   }
1842 
1843   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1844     return ownershipOf(tokenId);
1845   }
1846 }
1847 
1848 
1849   
1850 // File: contracts/DarkPuppetContract.sol
1851 //SPDX-License-Identifier: MIT
1852 
1853 pragma solidity ^0.8.0;
1854 
1855 contract DarkPuppetContract is RamppERC721A {
1856     constructor() RamppERC721A("Dark Puppet ", "Darkpuppet"){}
1857 }
1858   
1859 //*********************************************************************//
1860 //*********************************************************************//  
1861 //                       Mintplex v2.1.0
1862 //
1863 //         This smart contract was generated by mintplex.xyz.
1864 //            Mintplex allows creators like you to launch 
1865 //             large scale NFT communities without code!
1866 //
1867 //    Mintplex is not responsible for the content of this contract and
1868 //        hopes it is being used in a responsible and kind way.  
1869 //       Mintplex is not associated or affiliated with this project.                                                    
1870 //             Twitter: @MintplexNFT ---- mintplex.xyz
1871 //*********************************************************************//                                                     
1872 //*********************************************************************// 
