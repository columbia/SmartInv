1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //   _______  _  _                               __    _____                                 _    _               
5 //  |__   __|(_)| |                             / _|  / ____|                               | |  (_)              
6 //     | |    _ | |_  __ _  _ __   ___    ___  | |_  | |      ___   _ __ ___   _ __   _   _ | |_  _  _ __    __ _ 
7 //     | |   | || __|/ _` || '_ \ / __|  / _ \ |  _| | |     / _ \ | '_ ` _ \ | '_ \ | | | || __|| || '_ \  / _` |
8 //     | |   | || |_| (_| || | | |\__ \ | (_) || |   | |____| (_) || | | | | || |_) || |_| || |_ | || | | || (_| |
9 //     |_|   |_| \__|\__,_||_| |_||___/  \___/ |_|    \_____|\___/ |_| |_| |_|| .__/  \__,_| \__||_||_| |_| \__, |
10 //                                                                            | |                            __/ |
11 //                                                                            |_|                           |___/ 
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
841   pragma solidity ^0.8.0;
842 
843   /**
844   * @dev These functions deal with verification of Merkle Trees proofs.
845   *
846   * The proofs can be generated using the JavaScript library
847   * https://github.com/miguelmota/merkletreejs[merkletreejs].
848   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
849   *
850   *
851   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
852   * hashing, or use a hash function other than keccak256 for hashing leaves.
853   * This is because the concatenation of a sorted pair of internal nodes in
854   * the merkle tree could be reinterpreted as a leaf value.
855   */
856   library MerkleProof {
857       /**
858       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
859       * defined by 'root'. For this, a 'proof' must be provided, containing
860       * sibling hashes on the branch from the leaf to the root of the tree. Each
861       * pair of leaves and each pair of pre-images are assumed to be sorted.
862       */
863       function verify(
864           bytes32[] memory proof,
865           bytes32 root,
866           bytes32 leaf
867       ) internal pure returns (bool) {
868           return processProof(proof, leaf) == root;
869       }
870 
871       /**
872       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
873       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
874       * hash matches the root of the tree. When processing the proof, the pairs
875       * of leafs & pre-images are assumed to be sorted.
876       *
877       * _Available since v4.4._
878       */
879       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
880           bytes32 computedHash = leaf;
881           for (uint256 i = 0; i < proof.length; i++) {
882               bytes32 proofElement = proof[i];
883               if (computedHash <= proofElement) {
884                   // Hash(current computed hash + current element of the proof)
885                   computedHash = _efficientHash(computedHash, proofElement);
886               } else {
887                   // Hash(current element of the proof + current computed hash)
888                   computedHash = _efficientHash(proofElement, computedHash);
889               }
890           }
891           return computedHash;
892       }
893 
894       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
895           assembly {
896               mstore(0x00, a)
897               mstore(0x20, b)
898               value := keccak256(0x00, 0x40)
899           }
900       }
901   }
902 
903 
904   // File: Allowlist.sol
905 
906   pragma solidity ^0.8.0;
907 
908   abstract contract Allowlist is Teams {
909     bytes32 public merkleRoot;
910     bool public onlyAllowlistMode = false;
911 
912     /**
913      * @dev Update merkle root to reflect changes in Allowlist
914      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
915      */
916     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
917       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
918       merkleRoot = _newMerkleRoot;
919     }
920 
921     /**
922      * @dev Check the proof of an address if valid for merkle root
923      * @param _to address to check for proof
924      * @param _merkleProof Proof of the address to validate against root and leaf
925      */
926     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
927       require(merkleRoot != 0, "Merkle root is not set!");
928       bytes32 leaf = keccak256(abi.encodePacked(_to));
929 
930       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
931     }
932 
933     
934     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
935       onlyAllowlistMode = true;
936     }
937 
938     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
939         onlyAllowlistMode = false;
940     }
941   }
942   
943   
944 /**
945  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
946  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
947  *
948  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
949  * 
950  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
951  *
952  * Does not support burning tokens to address(0).
953  */
954 contract ERC721A is
955   Context,
956   ERC165,
957   IERC721,
958   IERC721Metadata,
959   IERC721Enumerable
960 {
961   using Address for address;
962   using Strings for uint256;
963 
964   struct TokenOwnership {
965     address addr;
966     uint64 startTimestamp;
967   }
968 
969   struct AddressData {
970     uint128 balance;
971     uint128 numberMinted;
972   }
973 
974   uint256 private currentIndex;
975 
976   uint256 public immutable collectionSize;
977   uint256 public maxBatchSize;
978 
979   // Token name
980   string private _name;
981 
982   // Token symbol
983   string private _symbol;
984 
985   // Mapping from token ID to ownership details
986   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
987   mapping(uint256 => TokenOwnership) private _ownerships;
988 
989   // Mapping owner address to address data
990   mapping(address => AddressData) private _addressData;
991 
992   // Mapping from token ID to approved address
993   mapping(uint256 => address) private _tokenApprovals;
994 
995   // Mapping from owner to operator approvals
996   mapping(address => mapping(address => bool)) private _operatorApprovals;
997 
998   /**
999    * @dev
1000    * maxBatchSize refers to how much a minter can mint at a time.
1001    * collectionSize_ refers to how many tokens are in the collection.
1002    */
1003   constructor(
1004     string memory name_,
1005     string memory symbol_,
1006     uint256 maxBatchSize_,
1007     uint256 collectionSize_
1008   ) {
1009     require(
1010       collectionSize_ > 0,
1011       "ERC721A: collection must have a nonzero supply"
1012     );
1013     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1014     _name = name_;
1015     _symbol = symbol_;
1016     maxBatchSize = maxBatchSize_;
1017     collectionSize = collectionSize_;
1018     currentIndex = _startTokenId();
1019   }
1020 
1021   /**
1022   * To change the starting tokenId, please override this function.
1023   */
1024   function _startTokenId() internal view virtual returns (uint256) {
1025     return 1;
1026   }
1027 
1028   /**
1029    * @dev See {IERC721Enumerable-totalSupply}.
1030    */
1031   function totalSupply() public view override returns (uint256) {
1032     return _totalMinted();
1033   }
1034 
1035   function currentTokenId() public view returns (uint256) {
1036     return _totalMinted();
1037   }
1038 
1039   function getNextTokenId() public view returns (uint256) {
1040       return _totalMinted() + 1;
1041   }
1042 
1043   /**
1044   * Returns the total amount of tokens minted in the contract.
1045   */
1046   function _totalMinted() internal view returns (uint256) {
1047     unchecked {
1048       return currentIndex - _startTokenId();
1049     }
1050   }
1051 
1052   /**
1053    * @dev See {IERC721Enumerable-tokenByIndex}.
1054    */
1055   function tokenByIndex(uint256 index) public view override returns (uint256) {
1056     require(index < totalSupply(), "ERC721A: global index out of bounds");
1057     return index;
1058   }
1059 
1060   /**
1061    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1062    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1063    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1064    */
1065   function tokenOfOwnerByIndex(address owner, uint256 index)
1066     public
1067     view
1068     override
1069     returns (uint256)
1070   {
1071     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1072     uint256 numMintedSoFar = totalSupply();
1073     uint256 tokenIdsIdx = 0;
1074     address currOwnershipAddr = address(0);
1075     for (uint256 i = 0; i < numMintedSoFar; i++) {
1076       TokenOwnership memory ownership = _ownerships[i];
1077       if (ownership.addr != address(0)) {
1078         currOwnershipAddr = ownership.addr;
1079       }
1080       if (currOwnershipAddr == owner) {
1081         if (tokenIdsIdx == index) {
1082           return i;
1083         }
1084         tokenIdsIdx++;
1085       }
1086     }
1087     revert("ERC721A: unable to get token of owner by index");
1088   }
1089 
1090   /**
1091    * @dev See {IERC165-supportsInterface}.
1092    */
1093   function supportsInterface(bytes4 interfaceId)
1094     public
1095     view
1096     virtual
1097     override(ERC165, IERC165)
1098     returns (bool)
1099   {
1100     return
1101       interfaceId == type(IERC721).interfaceId ||
1102       interfaceId == type(IERC721Metadata).interfaceId ||
1103       interfaceId == type(IERC721Enumerable).interfaceId ||
1104       super.supportsInterface(interfaceId);
1105   }
1106 
1107   /**
1108    * @dev See {IERC721-balanceOf}.
1109    */
1110   function balanceOf(address owner) public view override returns (uint256) {
1111     require(owner != address(0), "ERC721A: balance query for the zero address");
1112     return uint256(_addressData[owner].balance);
1113   }
1114 
1115   function _numberMinted(address owner) internal view returns (uint256) {
1116     require(
1117       owner != address(0),
1118       "ERC721A: number minted query for the zero address"
1119     );
1120     return uint256(_addressData[owner].numberMinted);
1121   }
1122 
1123   function ownershipOf(uint256 tokenId)
1124     internal
1125     view
1126     returns (TokenOwnership memory)
1127   {
1128     uint256 curr = tokenId;
1129 
1130     unchecked {
1131         if (_startTokenId() <= curr && curr < currentIndex) {
1132             TokenOwnership memory ownership = _ownerships[curr];
1133             if (ownership.addr != address(0)) {
1134                 return ownership;
1135             }
1136 
1137             // Invariant:
1138             // There will always be an ownership that has an address and is not burned
1139             // before an ownership that does not have an address and is not burned.
1140             // Hence, curr will not underflow.
1141             while (true) {
1142                 curr--;
1143                 ownership = _ownerships[curr];
1144                 if (ownership.addr != address(0)) {
1145                     return ownership;
1146                 }
1147             }
1148         }
1149     }
1150 
1151     revert("ERC721A: unable to determine the owner of token");
1152   }
1153 
1154   /**
1155    * @dev See {IERC721-ownerOf}.
1156    */
1157   function ownerOf(uint256 tokenId) public view override returns (address) {
1158     return ownershipOf(tokenId).addr;
1159   }
1160 
1161   /**
1162    * @dev See {IERC721Metadata-name}.
1163    */
1164   function name() public view virtual override returns (string memory) {
1165     return _name;
1166   }
1167 
1168   /**
1169    * @dev See {IERC721Metadata-symbol}.
1170    */
1171   function symbol() public view virtual override returns (string memory) {
1172     return _symbol;
1173   }
1174 
1175   /**
1176    * @dev See {IERC721Metadata-tokenURI}.
1177    */
1178   function tokenURI(uint256 tokenId)
1179     public
1180     view
1181     virtual
1182     override
1183     returns (string memory)
1184   {
1185     string memory baseURI = _baseURI();
1186     return
1187       bytes(baseURI).length > 0
1188         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1189         : "";
1190   }
1191 
1192   /**
1193    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1194    * token will be the concatenation of the baseURI and the tokenId. Empty
1195    * by default, can be overriden in child contracts.
1196    */
1197   function _baseURI() internal view virtual returns (string memory) {
1198     return "";
1199   }
1200 
1201   /**
1202    * @dev See {IERC721-approve}.
1203    */
1204   function approve(address to, uint256 tokenId) public override {
1205     address owner = ERC721A.ownerOf(tokenId);
1206     require(to != owner, "ERC721A: approval to current owner");
1207 
1208     require(
1209       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1210       "ERC721A: approve caller is not owner nor approved for all"
1211     );
1212 
1213     _approve(to, tokenId, owner);
1214   }
1215 
1216   /**
1217    * @dev See {IERC721-getApproved}.
1218    */
1219   function getApproved(uint256 tokenId) public view override returns (address) {
1220     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1221 
1222     return _tokenApprovals[tokenId];
1223   }
1224 
1225   /**
1226    * @dev See {IERC721-setApprovalForAll}.
1227    */
1228   function setApprovalForAll(address operator, bool approved) public override {
1229     require(operator != _msgSender(), "ERC721A: approve to caller");
1230 
1231     _operatorApprovals[_msgSender()][operator] = approved;
1232     emit ApprovalForAll(_msgSender(), operator, approved);
1233   }
1234 
1235   /**
1236    * @dev See {IERC721-isApprovedForAll}.
1237    */
1238   function isApprovedForAll(address owner, address operator)
1239     public
1240     view
1241     virtual
1242     override
1243     returns (bool)
1244   {
1245     return _operatorApprovals[owner][operator];
1246   }
1247 
1248   /**
1249    * @dev See {IERC721-transferFrom}.
1250    */
1251   function transferFrom(
1252     address from,
1253     address to,
1254     uint256 tokenId
1255   ) public override {
1256     _transfer(from, to, tokenId);
1257   }
1258 
1259   /**
1260    * @dev See {IERC721-safeTransferFrom}.
1261    */
1262   function safeTransferFrom(
1263     address from,
1264     address to,
1265     uint256 tokenId
1266   ) public override {
1267     safeTransferFrom(from, to, tokenId, "");
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-safeTransferFrom}.
1272    */
1273   function safeTransferFrom(
1274     address from,
1275     address to,
1276     uint256 tokenId,
1277     bytes memory _data
1278   ) public override {
1279     _transfer(from, to, tokenId);
1280     require(
1281       _checkOnERC721Received(from, to, tokenId, _data),
1282       "ERC721A: transfer to non ERC721Receiver implementer"
1283     );
1284   }
1285 
1286   /**
1287    * @dev Returns whether tokenId exists.
1288    *
1289    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1290    *
1291    * Tokens start existing when they are minted (_mint),
1292    */
1293   function _exists(uint256 tokenId) internal view returns (bool) {
1294     return _startTokenId() <= tokenId && tokenId < currentIndex;
1295   }
1296 
1297   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1298     _safeMint(to, quantity, isAdminMint, "");
1299   }
1300 
1301   /**
1302    * @dev Mints quantity tokens and transfers them to to.
1303    *
1304    * Requirements:
1305    *
1306    * - there must be quantity tokens remaining unminted in the total collection.
1307    * - to cannot be the zero address.
1308    * - quantity cannot be larger than the max batch size.
1309    *
1310    * Emits a {Transfer} event.
1311    */
1312   function _safeMint(
1313     address to,
1314     uint256 quantity,
1315     bool isAdminMint,
1316     bytes memory _data
1317   ) internal {
1318     uint256 startTokenId = currentIndex;
1319     require(to != address(0), "ERC721A: mint to the zero address");
1320     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1321     require(!_exists(startTokenId), "ERC721A: token already minted");
1322 
1323     // For admin mints we do not want to enforce the maxBatchSize limit
1324     if (isAdminMint == false) {
1325         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1326     }
1327 
1328     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1329 
1330     AddressData memory addressData = _addressData[to];
1331     _addressData[to] = AddressData(
1332       addressData.balance + uint128(quantity),
1333       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1334     );
1335     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1336 
1337     uint256 updatedIndex = startTokenId;
1338 
1339     for (uint256 i = 0; i < quantity; i++) {
1340       emit Transfer(address(0), to, updatedIndex);
1341       require(
1342         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1343         "ERC721A: transfer to non ERC721Receiver implementer"
1344       );
1345       updatedIndex++;
1346     }
1347 
1348     currentIndex = updatedIndex;
1349     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1350   }
1351 
1352   /**
1353    * @dev Transfers tokenId from from to to.
1354    *
1355    * Requirements:
1356    *
1357    * - to cannot be the zero address.
1358    * - tokenId token must be owned by from.
1359    *
1360    * Emits a {Transfer} event.
1361    */
1362   function _transfer(
1363     address from,
1364     address to,
1365     uint256 tokenId
1366   ) private {
1367     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1368 
1369     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1370       getApproved(tokenId) == _msgSender() ||
1371       isApprovedForAll(prevOwnership.addr, _msgSender()));
1372 
1373     require(
1374       isApprovedOrOwner,
1375       "ERC721A: transfer caller is not owner nor approved"
1376     );
1377 
1378     require(
1379       prevOwnership.addr == from,
1380       "ERC721A: transfer from incorrect owner"
1381     );
1382     require(to != address(0), "ERC721A: transfer to the zero address");
1383 
1384     _beforeTokenTransfers(from, to, tokenId, 1);
1385 
1386     // Clear approvals from the previous owner
1387     _approve(address(0), tokenId, prevOwnership.addr);
1388 
1389     _addressData[from].balance -= 1;
1390     _addressData[to].balance += 1;
1391     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1392 
1393     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1394     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1395     uint256 nextTokenId = tokenId + 1;
1396     if (_ownerships[nextTokenId].addr == address(0)) {
1397       if (_exists(nextTokenId)) {
1398         _ownerships[nextTokenId] = TokenOwnership(
1399           prevOwnership.addr,
1400           prevOwnership.startTimestamp
1401         );
1402       }
1403     }
1404 
1405     emit Transfer(from, to, tokenId);
1406     _afterTokenTransfers(from, to, tokenId, 1);
1407   }
1408 
1409   /**
1410    * @dev Approve to to operate on tokenId
1411    *
1412    * Emits a {Approval} event.
1413    */
1414   function _approve(
1415     address to,
1416     uint256 tokenId,
1417     address owner
1418   ) private {
1419     _tokenApprovals[tokenId] = to;
1420     emit Approval(owner, to, tokenId);
1421   }
1422 
1423   uint256 public nextOwnerToExplicitlySet = 0;
1424 
1425   /**
1426    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1427    */
1428   function _setOwnersExplicit(uint256 quantity) internal {
1429     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1430     require(quantity > 0, "quantity must be nonzero");
1431     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1432 
1433     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1434     if (endIndex > collectionSize - 1) {
1435       endIndex = collectionSize - 1;
1436     }
1437     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1438     require(_exists(endIndex), "not enough minted yet for this cleanup");
1439     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1440       if (_ownerships[i].addr == address(0)) {
1441         TokenOwnership memory ownership = ownershipOf(i);
1442         _ownerships[i] = TokenOwnership(
1443           ownership.addr,
1444           ownership.startTimestamp
1445         );
1446       }
1447     }
1448     nextOwnerToExplicitlySet = endIndex + 1;
1449   }
1450 
1451   /**
1452    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1453    * The call is not executed if the target address is not a contract.
1454    *
1455    * @param from address representing the previous owner of the given token ID
1456    * @param to target address that will receive the tokens
1457    * @param tokenId uint256 ID of the token to be transferred
1458    * @param _data bytes optional data to send along with the call
1459    * @return bool whether the call correctly returned the expected magic value
1460    */
1461   function _checkOnERC721Received(
1462     address from,
1463     address to,
1464     uint256 tokenId,
1465     bytes memory _data
1466   ) private returns (bool) {
1467     if (to.isContract()) {
1468       try
1469         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1470       returns (bytes4 retval) {
1471         return retval == IERC721Receiver(to).onERC721Received.selector;
1472       } catch (bytes memory reason) {
1473         if (reason.length == 0) {
1474           revert("ERC721A: transfer to non ERC721Receiver implementer");
1475         } else {
1476           assembly {
1477             revert(add(32, reason), mload(reason))
1478           }
1479         }
1480       }
1481     } else {
1482       return true;
1483     }
1484   }
1485 
1486   /**
1487    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1488    *
1489    * startTokenId - the first token id to be transferred
1490    * quantity - the amount to be transferred
1491    *
1492    * Calling conditions:
1493    *
1494    * - When from and to are both non-zero, from's tokenId will be
1495    * transferred to to.
1496    * - When from is zero, tokenId will be minted for to.
1497    */
1498   function _beforeTokenTransfers(
1499     address from,
1500     address to,
1501     uint256 startTokenId,
1502     uint256 quantity
1503   ) internal virtual {}
1504 
1505   /**
1506    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1507    * minting.
1508    *
1509    * startTokenId - the first token id to be transferred
1510    * quantity - the amount to be transferred
1511    *
1512    * Calling conditions:
1513    *
1514    * - when from and to are both non-zero.
1515    * - from and to are never both zero.
1516    */
1517   function _afterTokenTransfers(
1518     address from,
1519     address to,
1520     uint256 startTokenId,
1521     uint256 quantity
1522   ) internal virtual {}
1523 }
1524 
1525 
1526 
1527   
1528 abstract contract Ramppable {
1529   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1530 
1531   modifier isRampp() {
1532       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1533       _;
1534   }
1535 }
1536 
1537 
1538   
1539 /** TimedDrop.sol
1540 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1541 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1542 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1543 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1544 */
1545 abstract contract TimedDrop is Teams {
1546   bool public enforcePublicDropTime = true;
1547   uint256 public publicDropTime = 1660953600;
1548   
1549   /**
1550   * @dev Allow the contract owner to set the public time to mint.
1551   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1552   */
1553   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1554     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1555     publicDropTime = _newDropTime;
1556   }
1557 
1558   function usePublicDropTime() public onlyTeamOrOwner {
1559     enforcePublicDropTime = true;
1560   }
1561 
1562   function disablePublicDropTime() public onlyTeamOrOwner {
1563     enforcePublicDropTime = false;
1564   }
1565 
1566   /**
1567   * @dev determine if the public droptime has passed.
1568   * if the feature is disabled then assume the time has passed.
1569   */
1570   function publicDropTimePassed() public view returns(bool) {
1571     if(enforcePublicDropTime == false) {
1572       return true;
1573     }
1574     return block.timestamp >= publicDropTime;
1575   }
1576   
1577   // Allowlist implementation of the Timed Drop feature
1578   bool public enforceAllowlistDropTime = true;
1579   uint256 public allowlistDropTime = 1661385600;
1580 
1581   /**
1582   * @dev Allow the contract owner to set the allowlist time to mint.
1583   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1584   */
1585   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1586     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1587     allowlistDropTime = _newDropTime;
1588   }
1589 
1590   function useAllowlistDropTime() public onlyTeamOrOwner {
1591     enforceAllowlistDropTime = true;
1592   }
1593 
1594   function disableAllowlistDropTime() public onlyTeamOrOwner {
1595     enforceAllowlistDropTime = false;
1596   }
1597 
1598   function allowlistDropTimePassed() public view returns(bool) {
1599     if(enforceAllowlistDropTime == false) {
1600       return true;
1601     }
1602 
1603     return block.timestamp >= allowlistDropTime;
1604   }
1605 }
1606 
1607   
1608 interface IERC20 {
1609   function allowance(address owner, address spender) external view returns (uint256);
1610   function transfer(address _to, uint256 _amount) external returns (bool);
1611   function balanceOf(address account) external view returns (uint256);
1612   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1613 }
1614 
1615 // File: WithdrawableV2
1616 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1617 // ERC-20 Payouts are limited to a single payout address. This feature 
1618 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1619 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1620 abstract contract WithdrawableV2 is Teams, Ramppable {
1621   struct acceptedERC20 {
1622     bool isActive;
1623     uint256 chargeAmount;
1624   }
1625 
1626   mapping(address => acceptedERC20) private allowedTokenContracts;
1627   address[] public payableAddresses = [RAMPPADDRESS,0xB566C82ba5eb0df25e759afB53384E8249dF6837,0x78f896DBcCa3384966f645ae52628CD2aF519745];
1628   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1629   address public erc20Payable = 0xB566C82ba5eb0df25e759afB53384E8249dF6837;
1630   uint256[] public payableFees = [5,50,45];
1631   uint256[] public surchargePayableFees = [100];
1632   uint256 public payableAddressCount = 3;
1633   uint256 public surchargePayableAddressCount = 1;
1634   uint256 public ramppSurchargeBalance = 0 ether;
1635   uint256 public ramppSurchargeFee = 0.001 ether;
1636   bool public onlyERC20MintingMode = false;
1637 
1638   /**
1639   * @dev Calculates the true payable balance of the contract as the
1640   * value on contract may be from ERC-20 mint surcharges and not 
1641   * public mint charges - which are not eligable for rev share & user withdrawl
1642   */
1643   function calcAvailableBalance() public view returns(uint256) {
1644     return address(this).balance - ramppSurchargeBalance;
1645   }
1646 
1647   function withdrawAll() public onlyTeamOrOwner {
1648       require(calcAvailableBalance() > 0);
1649       _withdrawAll();
1650   }
1651   
1652   function withdrawAllRampp() public isRampp {
1653       require(calcAvailableBalance() > 0);
1654       _withdrawAll();
1655   }
1656 
1657   function _withdrawAll() private {
1658       uint256 balance = calcAvailableBalance();
1659       
1660       for(uint i=0; i < payableAddressCount; i++ ) {
1661           _widthdraw(
1662               payableAddresses[i],
1663               (balance * payableFees[i]) / 100
1664           );
1665       }
1666   }
1667   
1668   function _widthdraw(address _address, uint256 _amount) private {
1669       (bool success, ) = _address.call{value: _amount}("");
1670       require(success, "Transfer failed.");
1671   }
1672 
1673   /**
1674   * @dev This function is similiar to the regular withdraw but operates only on the
1675   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1676   **/
1677   function _withdrawAllSurcharges() private {
1678     uint256 balance = ramppSurchargeBalance;
1679     if(balance == 0) { return; }
1680     
1681     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1682         _widthdraw(
1683             surchargePayableAddresses[i],
1684             (balance * surchargePayableFees[i]) / 100
1685         );
1686     }
1687     ramppSurchargeBalance = 0 ether;
1688   }
1689 
1690   /**
1691   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1692   * in the event ERC-20 tokens are paid to the contract for mints. This will
1693   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1694   * @param _tokenContract contract of ERC-20 token to withdraw
1695   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1696   */
1697   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1698     require(_amountToWithdraw > 0);
1699     IERC20 tokenContract = IERC20(_tokenContract);
1700     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1701     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1702     _withdrawAllSurcharges();
1703   }
1704 
1705   /**
1706   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1707   */
1708   function withdrawRamppSurcharges() public isRampp {
1709     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1710     _withdrawAllSurcharges();
1711   }
1712 
1713    /**
1714   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1715   */
1716   function addSurcharge() internal {
1717     ramppSurchargeBalance += ramppSurchargeFee;
1718   }
1719   
1720   /**
1721   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1722   */
1723   function hasSurcharge() internal returns(bool) {
1724     return msg.value == ramppSurchargeFee;
1725   }
1726 
1727   /**
1728   * @dev Set surcharge fee for using ERC-20 payments on contract
1729   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1730   */
1731   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1732     ramppSurchargeFee = _newSurcharge;
1733   }
1734 
1735   /**
1736   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1737   * @param _erc20TokenContract address of ERC-20 contract in question
1738   */
1739   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1740     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1741   }
1742 
1743   /**
1744   * @dev get the value of tokens to transfer for user of an ERC-20
1745   * @param _erc20TokenContract address of ERC-20 contract in question
1746   */
1747   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1748     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1749     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1750   }
1751 
1752   /**
1753   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1754   * @param _erc20TokenContract address of ERC-20 contract in question
1755   * @param _isActive default status of if contract should be allowed to accept payments
1756   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1757   */
1758   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1759     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1760     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1761   }
1762 
1763   /**
1764   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1765   * it will assume the default value of zero. This should not be used to create new payment tokens.
1766   * @param _erc20TokenContract address of ERC-20 contract in question
1767   */
1768   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1769     allowedTokenContracts[_erc20TokenContract].isActive = true;
1770   }
1771 
1772   /**
1773   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1774   * it will assume the default value of zero. This should not be used to create new payment tokens.
1775   * @param _erc20TokenContract address of ERC-20 contract in question
1776   */
1777   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1778     allowedTokenContracts[_erc20TokenContract].isActive = false;
1779   }
1780 
1781   /**
1782   * @dev Enable only ERC-20 payments for minting on this contract
1783   */
1784   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1785     onlyERC20MintingMode = true;
1786   }
1787 
1788   /**
1789   * @dev Disable only ERC-20 payments for minting on this contract
1790   */
1791   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1792     onlyERC20MintingMode = false;
1793   }
1794 
1795   /**
1796   * @dev Set the payout of the ERC-20 token payout to a specific address
1797   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1798   */
1799   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1800     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1801     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1802     erc20Payable = _newErc20Payable;
1803   }
1804 
1805   /**
1806   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1807   */
1808   function resetRamppSurchargeBalance() public isRampp {
1809     ramppSurchargeBalance = 0 ether;
1810   }
1811 
1812   /**
1813   * @dev Allows Rampp wallet to update its own reference as well as update
1814   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1815   * and since Rampp is always the first address this function is limited to the rampp payout only.
1816   * @param _newAddress updated Rampp Address
1817   */
1818   function setRamppAddress(address _newAddress) public isRampp {
1819     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1820     RAMPPADDRESS = _newAddress;
1821     payableAddresses[0] = _newAddress;
1822   }
1823 }
1824 
1825 
1826   
1827   
1828 // File: EarlyMintIncentive.sol
1829 // Allows the contract to have the first x tokens have a discount or
1830 // zero fee that can be calculated on the fly.
1831 abstract contract EarlyMintIncentive is Teams, ERC721A {
1832   uint256 public PRICE = 0 ether;
1833   uint256 public EARLY_MINT_PRICE = 0 ether;
1834   uint256 public earlyMintTokenIdCap = 300;
1835   bool public usingEarlyMintIncentive = true;
1836 
1837   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1838     usingEarlyMintIncentive = true;
1839   }
1840 
1841   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1842     usingEarlyMintIncentive = false;
1843   }
1844 
1845   /**
1846   * @dev Set the max token ID in which the cost incentive will be applied.
1847   * @param _newTokenIdCap max tokenId in which incentive will be applied
1848   */
1849   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1850     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1851     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1852     earlyMintTokenIdCap = _newTokenIdCap;
1853   }
1854 
1855   /**
1856   * @dev Set the incentive mint price
1857   * @param _feeInWei new price per token when in incentive range
1858   */
1859   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1860     EARLY_MINT_PRICE = _feeInWei;
1861   }
1862 
1863   /**
1864   * @dev Set the primary mint price - the base price when not under incentive
1865   * @param _feeInWei new price per token
1866   */
1867   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1868     PRICE = _feeInWei;
1869   }
1870 
1871   function getPrice(uint256 _count) public view returns (uint256) {
1872     require(_count > 0, "Must be minting at least 1 token.");
1873 
1874     // short circuit function if we dont need to even calc incentive pricing
1875     // short circuit if the current tokenId is also already over cap
1876     if(
1877       usingEarlyMintIncentive == false ||
1878       currentTokenId() > earlyMintTokenIdCap
1879     ) {
1880       return PRICE * _count;
1881     }
1882 
1883     uint256 endingTokenId = currentTokenId() + _count;
1884     // If qty to mint results in a final token ID less than or equal to the cap then
1885     // the entire qty is within free mint.
1886     if(endingTokenId  <= earlyMintTokenIdCap) {
1887       return EARLY_MINT_PRICE * _count;
1888     }
1889 
1890     // If the current token id is less than the incentive cap
1891     // and the ending token ID is greater than the incentive cap
1892     // we will be straddling the cap so there will be some amount
1893     // that are incentive and some that are regular fee.
1894     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1895     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1896 
1897     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1898   }
1899 }
1900 
1901   
1902   
1903 abstract contract RamppERC721A is 
1904     Ownable,
1905     Teams,
1906     ERC721A,
1907     WithdrawableV2,
1908     ReentrancyGuard 
1909     , EarlyMintIncentive 
1910     , Allowlist 
1911     , TimedDrop
1912 {
1913   constructor(
1914     string memory tokenName,
1915     string memory tokenSymbol
1916   ) ERC721A(tokenName, tokenSymbol, 2, 1000) { }
1917     uint8 public CONTRACT_VERSION = 2;
1918     string public _baseTokenURI = "ipfs://QmPnQKwovktAXXGrcckPS6XanpJPLrZ9seM7L5XYhdzx2p/";
1919 
1920     bool public mintingOpen = false;
1921     
1922     
1923     uint256 public MAX_WALLET_MINTS = 2;
1924 
1925   
1926     /////////////// Admin Mint Functions
1927     /**
1928      * @dev Mints a token to an address with a tokenURI.
1929      * This is owner only and allows a fee-free drop
1930      * @param _to address of the future owner of the token
1931      * @param _qty amount of tokens to drop the owner
1932      */
1933      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1934          require(_qty > 0, "Must mint at least 1 token.");
1935          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1000");
1936          _safeMint(_to, _qty, true);
1937      }
1938 
1939   
1940     /////////////// GENERIC MINT FUNCTIONS
1941     /**
1942     * @dev Mints a single token to an address.
1943     * fee may or may not be required*
1944     * @param _to address of the future owner of the token
1945     */
1946     function mintTo(address _to) public payable {
1947         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1948         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1949         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1950         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1951         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1952         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1953         
1954         _safeMint(_to, 1, false);
1955     }
1956 
1957     /**
1958     * @dev Mints tokens to an address in batch.
1959     * fee may or may not be required*
1960     * @param _to address of the future owner of the token
1961     * @param _amount number of tokens to mint
1962     */
1963     function mintToMultiple(address _to, uint256 _amount) public payable {
1964         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1965         require(_amount >= 1, "Must mint at least 1 token");
1966         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1967         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1968         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1969         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1970         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
1971         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1972 
1973         _safeMint(_to, _amount, false);
1974     }
1975 
1976     /**
1977      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1978      * fee may or may not be required*
1979      * @param _to address of the future owner of the token
1980      * @param _amount number of tokens to mint
1981      * @param _erc20TokenContract erc-20 token contract to mint with
1982      */
1983     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1984       require(_amount >= 1, "Must mint at least 1 token");
1985       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1986       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1987       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1988       require(publicDropTimePassed() == true, "Public drop time has not passed!");
1989       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1990 
1991       // ERC-20 Specific pre-flight checks
1992       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1993       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1994       IERC20 payableToken = IERC20(_erc20TokenContract);
1995 
1996       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1997       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1998       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1999       
2000       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2001       require(transferComplete, "ERC-20 token was unable to be transferred");
2002       
2003       _safeMint(_to, _amount, false);
2004       addSurcharge();
2005     }
2006 
2007     function openMinting() public onlyTeamOrOwner {
2008         mintingOpen = true;
2009     }
2010 
2011     function stopMinting() public onlyTeamOrOwner {
2012         mintingOpen = false;
2013     }
2014 
2015   
2016     ///////////// ALLOWLIST MINTING FUNCTIONS
2017 
2018     /**
2019     * @dev Mints tokens to an address using an allowlist.
2020     * fee may or may not be required*
2021     * @param _to address of the future owner of the token
2022     * @param _merkleProof merkle proof array
2023     */
2024     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
2025         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2026         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2027         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2028         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
2029         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
2030         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
2031         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2032 
2033         _safeMint(_to, 1, false);
2034     }
2035 
2036     /**
2037     * @dev Mints tokens to an address using an allowlist.
2038     * fee may or may not be required*
2039     * @param _to address of the future owner of the token
2040     * @param _amount number of tokens to mint
2041     * @param _merkleProof merkle proof array
2042     */
2043     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2044         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2045         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2046         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2047         require(_amount >= 1, "Must mint at least 1 token");
2048         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2049 
2050         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2051         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2052         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2053         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2054 
2055         _safeMint(_to, _amount, false);
2056     }
2057 
2058     /**
2059     * @dev Mints tokens to an address using an allowlist.
2060     * fee may or may not be required*
2061     * @param _to address of the future owner of the token
2062     * @param _amount number of tokens to mint
2063     * @param _merkleProof merkle proof array
2064     * @param _erc20TokenContract erc-20 token contract to mint with
2065     */
2066     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2067       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2068       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2069       require(_amount >= 1, "Must mint at least 1 token");
2070       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2071       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2072       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2073       require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2074     
2075       // ERC-20 Specific pre-flight checks
2076       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2077       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2078       IERC20 payableToken = IERC20(_erc20TokenContract);
2079     
2080       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2081       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2082       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2083       
2084       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2085       require(transferComplete, "ERC-20 token was unable to be transferred");
2086       
2087       _safeMint(_to, _amount, false);
2088       addSurcharge();
2089     }
2090 
2091     /**
2092      * @dev Enable allowlist minting fully by enabling both flags
2093      * This is a convenience function for the Rampp user
2094      */
2095     function openAllowlistMint() public onlyTeamOrOwner {
2096         enableAllowlistOnlyMode();
2097         mintingOpen = true;
2098     }
2099 
2100     /**
2101      * @dev Close allowlist minting fully by disabling both flags
2102      * This is a convenience function for the Rampp user
2103      */
2104     function closeAllowlistMint() public onlyTeamOrOwner {
2105         disableAllowlistOnlyMode();
2106         mintingOpen = false;
2107     }
2108 
2109 
2110   
2111     /**
2112     * @dev Check if wallet over MAX_WALLET_MINTS
2113     * @param _address address in question to check if minted count exceeds max
2114     */
2115     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2116         require(_amount >= 1, "Amount must be greater than or equal to 1");
2117         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2118     }
2119 
2120     /**
2121     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2122     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2123     */
2124     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2125         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2126         MAX_WALLET_MINTS = _newWalletMax;
2127     }
2128     
2129 
2130   
2131     /**
2132      * @dev Allows owner to set Max mints per tx
2133      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2134      */
2135      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2136          require(_newMaxMint >= 1, "Max mint must be at least 1");
2137          maxBatchSize = _newMaxMint;
2138      }
2139     
2140 
2141   
2142 
2143   function _baseURI() internal view virtual override returns(string memory) {
2144     return _baseTokenURI;
2145   }
2146 
2147   function baseTokenURI() public view returns(string memory) {
2148     return _baseTokenURI;
2149   }
2150 
2151   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2152     _baseTokenURI = baseURI;
2153   }
2154 
2155   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2156     return ownershipOf(tokenId);
2157   }
2158 }
2159 
2160 
2161   
2162 // File: contracts/TitansofComputingContract.sol
2163 //SPDX-License-Identifier: MIT
2164 
2165 pragma solidity ^0.8.0;
2166 
2167 contract TitansofComputingContract is RamppERC721A {
2168     constructor() RamppERC721A("Titans of Computing", "TCOMP"){}
2169 }
2170   
2171 //*********************************************************************//
2172 //*********************************************************************//  
2173 //                       Rampp v2.1.0
2174 //
2175 //         This smart contract was generated by rampp.xyz.
2176 //            Rampp allows creators like you to launch 
2177 //             large scale NFT communities without code!
2178 //
2179 //    Rampp is not responsible for the content of this contract and
2180 //        hopes it is being used in a responsible and kind way.  
2181 //       Rampp is not associated or affiliated with this project.                                                    
2182 //             Twitter: @Rampp_ ---- rampp.xyz
2183 //*********************************************************************//                                                     
2184 //*********************************************************************// 
