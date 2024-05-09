1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _   _           _       __           _           _ 
5 // | | | |         | |     / _|         | |         | |
6 // | | | |_ __   __| | ___| |_ ___  __ _| |_ ___  __| |
7 // | | | | '_ \ / _` |/ _ \  _/ _ \/ _` | __/ _ \/ _` |
8 // | |_| | | | | (_| |  __/ ||  __/ (_| | ||  __/ (_| |
9 //  \___/|_| |_|\__,_|\___|_| \___|\__,_|\__\___|\__,_|
10 //                                                     
11 //                                                     
12 //  _____                                 _            
13 // /  ___|                               (_)           
14 // \ `--.  __ _ _ __ ___  _   _ _ __ __ _ _            
15 //  `--. \/ _` | '_ ` _ \| | | | '__/ _` | |           
16 // /\__/ / (_| | | | | | | |_| | | | (_| | |           
17 // \____/ \__,_|_| |_| |_|\__,_|_|  \__,_|_|           
18 //                                                     
19 //                                                     
20 //
21 //*********************************************************************//
22 //*********************************************************************//
23   
24 //-------------DEPENDENCIES--------------------------//
25 
26 // File: @openzeppelin/contracts/utils/Address.sol
27 
28 
29 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
30 
31 pragma solidity ^0.8.1;
32 
33 /**
34  * @dev Collection of functions related to the address type
35  */
36 library Address {
37     /**
38      * @dev Returns true if account is a contract.
39      *
40      * [IMPORTANT]
41      * ====
42      * It is unsafe to assume that an address for which this function returns
43      * false is an externally-owned account (EOA) and not a contract.
44      *
45      * Among others, isContract will return false for the following
46      * types of addresses:
47      *
48      *  - an externally-owned account
49      *  - a contract in construction
50      *  - an address where a contract will be created
51      *  - an address where a contract lived, but was destroyed
52      * ====
53      *
54      * [IMPORTANT]
55      * ====
56      * You shouldn't rely on isContract to protect against flash loan attacks!
57      *
58      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
59      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
60      * constructor.
61      * ====
62      */
63     function isContract(address account) internal view returns (bool) {
64         // This method relies on extcodesize/address.code.length, which returns 0
65         // for contracts in construction, since the code is only stored at the end
66         // of the constructor execution.
67 
68         return account.code.length > 0;
69     }
70 
71     /**
72      * @dev Replacement for Solidity's transfer: sends amount wei to
73      * recipient, forwarding all available gas and reverting on errors.
74      *
75      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
76      * of certain opcodes, possibly making contracts go over the 2300 gas limit
77      * imposed by transfer, making them unable to receive funds via
78      * transfer. {sendValue} removes this limitation.
79      *
80      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
81      *
82      * IMPORTANT: because control is transferred to recipient, care must be
83      * taken to not create reentrancy vulnerabilities. Consider using
84      * {ReentrancyGuard} or the
85      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
86      */
87     function sendValue(address payable recipient, uint256 amount) internal {
88         require(address(this).balance >= amount, "Address: insufficient balance");
89 
90         (bool success, ) = recipient.call{value: amount}("");
91         require(success, "Address: unable to send value, recipient may have reverted");
92     }
93 
94     /**
95      * @dev Performs a Solidity function call using a low level call. A
96      * plain call is an unsafe replacement for a function call: use this
97      * function instead.
98      *
99      * If target reverts with a revert reason, it is bubbled up by this
100      * function (like regular Solidity function calls).
101      *
102      * Returns the raw returned data. To convert to the expected return value,
103      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
104      *
105      * Requirements:
106      *
107      * - target must be a contract.
108      * - calling target with data must not revert.
109      *
110      * _Available since v3.1._
111      */
112     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
113         return functionCall(target, data, "Address: low-level call failed");
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
118      * errorMessage as a fallback revert reason when target reverts.
119      *
120      * _Available since v3.1._
121      */
122     function functionCall(
123         address target,
124         bytes memory data,
125         string memory errorMessage
126     ) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, 0, errorMessage);
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
132      * but also transferring value wei to target.
133      *
134      * Requirements:
135      *
136      * - the calling contract must have an ETH balance of at least value.
137      * - the called Solidity function must be payable.
138      *
139      * _Available since v3.1._
140      */
141     function functionCallWithValue(
142         address target,
143         bytes memory data,
144         uint256 value
145     ) internal returns (bytes memory) {
146         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
151      * with errorMessage as a fallback revert reason when target reverts.
152      *
153      * _Available since v3.1._
154      */
155     function functionCallWithValue(
156         address target,
157         bytes memory data,
158         uint256 value,
159         string memory errorMessage
160     ) internal returns (bytes memory) {
161         require(address(this).balance >= value, "Address: insufficient balance for call");
162         require(isContract(target), "Address: call to non-contract");
163 
164         (bool success, bytes memory returndata) = target.call{value: value}(data);
165         return verifyCallResult(success, returndata, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
170      * but performing a static call.
171      *
172      * _Available since v3.3._
173      */
174     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
175         return functionStaticCall(target, data, "Address: low-level static call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
180      * but performing a static call.
181      *
182      * _Available since v3.3._
183      */
184     function functionStaticCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal view returns (bytes memory) {
189         require(isContract(target), "Address: static call to non-contract");
190 
191         (bool success, bytes memory returndata) = target.staticcall(data);
192         return verifyCallResult(success, returndata, errorMessage);
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
197      * but performing a delegate call.
198      *
199      * _Available since v3.4._
200      */
201     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
202         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
207      * but performing a delegate call.
208      *
209      * _Available since v3.4._
210      */
211     function functionDelegateCall(
212         address target,
213         bytes memory data,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(isContract(target), "Address: delegate call to non-contract");
217 
218         (bool success, bytes memory returndata) = target.delegatecall(data);
219         return verifyCallResult(success, returndata, errorMessage);
220     }
221 
222     /**
223      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
224      * revert reason using the provided one.
225      *
226      * _Available since v4.3._
227      */
228     function verifyCallResult(
229         bool success,
230         bytes memory returndata,
231         string memory errorMessage
232     ) internal pure returns (bytes memory) {
233         if (success) {
234             return returndata;
235         } else {
236             // Look for revert reason and bubble it up if present
237             if (returndata.length > 0) {
238                 // The easiest way to bubble the revert reason is using memory via assembly
239 
240                 assembly {
241                     let returndata_size := mload(returndata)
242                     revert(add(32, returndata), returndata_size)
243                 }
244             } else {
245                 revert(errorMessage);
246             }
247         }
248     }
249 }
250 
251 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
252 
253 
254 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @title ERC721 token receiver interface
260  * @dev Interface for any contract that wants to support safeTransfers
261  * from ERC721 asset contracts.
262  */
263 interface IERC721Receiver {
264     /**
265      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
266      * by operator from from, this function is called.
267      *
268      * It must return its Solidity selector to confirm the token transfer.
269      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
270      *
271      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
272      */
273     function onERC721Received(
274         address operator,
275         address from,
276         uint256 tokenId,
277         bytes calldata data
278     ) external returns (bytes4);
279 }
280 
281 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
282 
283 
284 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @dev Interface of the ERC165 standard, as defined in the
290  * https://eips.ethereum.org/EIPS/eip-165[EIP].
291  *
292  * Implementers can declare support of contract interfaces, which can then be
293  * queried by others ({ERC165Checker}).
294  *
295  * For an implementation, see {ERC165}.
296  */
297 interface IERC165 {
298     /**
299      * @dev Returns true if this contract implements the interface defined by
300      * interfaceId. See the corresponding
301      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
302      * to learn more about how these ids are created.
303      *
304      * This function call must use less than 30 000 gas.
305      */
306     function supportsInterface(bytes4 interfaceId) external view returns (bool);
307 }
308 
309 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
310 
311 
312 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
313 
314 pragma solidity ^0.8.0;
315 
316 
317 /**
318  * @dev Implementation of the {IERC165} interface.
319  *
320  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
321  * for the additional interface id that will be supported. For example:
322  *
323  * solidity
324  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
326  * }
327  * 
328  *
329  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
330  */
331 abstract contract ERC165 is IERC165 {
332     /**
333      * @dev See {IERC165-supportsInterface}.
334      */
335     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
336         return interfaceId == type(IERC165).interfaceId;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
341 
342 
343 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @dev Required interface of an ERC721 compliant contract.
350  */
351 interface IERC721 is IERC165 {
352     /**
353      * @dev Emitted when tokenId token is transferred from from to to.
354      */
355     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
356 
357     /**
358      * @dev Emitted when owner enables approved to manage the tokenId token.
359      */
360     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
361 
362     /**
363      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
364      */
365     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
366 
367     /**
368      * @dev Returns the number of tokens in owner's account.
369      */
370     function balanceOf(address owner) external view returns (uint256 balance);
371 
372     /**
373      * @dev Returns the owner of the tokenId token.
374      *
375      * Requirements:
376      *
377      * - tokenId must exist.
378      */
379     function ownerOf(uint256 tokenId) external view returns (address owner);
380 
381     /**
382      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
383      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
384      *
385      * Requirements:
386      *
387      * - from cannot be the zero address.
388      * - to cannot be the zero address.
389      * - tokenId token must exist and be owned by from.
390      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
391      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
392      *
393      * Emits a {Transfer} event.
394      */
395     function safeTransferFrom(
396         address from,
397         address to,
398         uint256 tokenId
399     ) external;
400 
401     /**
402      * @dev Transfers tokenId token from from to to.
403      *
404      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
405      *
406      * Requirements:
407      *
408      * - from cannot be the zero address.
409      * - to cannot be the zero address.
410      * - tokenId token must be owned by from.
411      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
412      *
413      * Emits a {Transfer} event.
414      */
415     function transferFrom(
416         address from,
417         address to,
418         uint256 tokenId
419     ) external;
420 
421     /**
422      * @dev Gives permission to to to transfer tokenId token to another account.
423      * The approval is cleared when the token is transferred.
424      *
425      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
426      *
427      * Requirements:
428      *
429      * - The caller must own the token or be an approved operator.
430      * - tokenId must exist.
431      *
432      * Emits an {Approval} event.
433      */
434     function approve(address to, uint256 tokenId) external;
435 
436     /**
437      * @dev Returns the account approved for tokenId token.
438      *
439      * Requirements:
440      *
441      * - tokenId must exist.
442      */
443     function getApproved(uint256 tokenId) external view returns (address operator);
444 
445     /**
446      * @dev Approve or remove operator as an operator for the caller.
447      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
448      *
449      * Requirements:
450      *
451      * - The operator cannot be the caller.
452      *
453      * Emits an {ApprovalForAll} event.
454      */
455     function setApprovalForAll(address operator, bool _approved) external;
456 
457     /**
458      * @dev Returns if the operator is allowed to manage all of the assets of owner.
459      *
460      * See {setApprovalForAll}
461      */
462     function isApprovedForAll(address owner, address operator) external view returns (bool);
463 
464     /**
465      * @dev Safely transfers tokenId token from from to to.
466      *
467      * Requirements:
468      *
469      * - from cannot be the zero address.
470      * - to cannot be the zero address.
471      * - tokenId token must exist and be owned by from.
472      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
473      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
474      *
475      * Emits a {Transfer} event.
476      */
477     function safeTransferFrom(
478         address from,
479         address to,
480         uint256 tokenId,
481         bytes calldata data
482     ) external;
483 }
484 
485 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
486 
487 
488 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 
493 /**
494  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
495  * @dev See https://eips.ethereum.org/EIPS/eip-721
496  */
497 interface IERC721Enumerable is IERC721 {
498     /**
499      * @dev Returns the total amount of tokens stored by the contract.
500      */
501     function totalSupply() external view returns (uint256);
502 
503     /**
504      * @dev Returns a token ID owned by owner at a given index of its token list.
505      * Use along with {balanceOf} to enumerate all of owner's tokens.
506      */
507     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
508 
509     /**
510      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
511      * Use along with {totalSupply} to enumerate all tokens.
512      */
513     function tokenByIndex(uint256 index) external view returns (uint256);
514 }
515 
516 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 
524 /**
525  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
526  * @dev See https://eips.ethereum.org/EIPS/eip-721
527  */
528 interface IERC721Metadata is IERC721 {
529     /**
530      * @dev Returns the token collection name.
531      */
532     function name() external view returns (string memory);
533 
534     /**
535      * @dev Returns the token collection symbol.
536      */
537     function symbol() external view returns (string memory);
538 
539     /**
540      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
541      */
542     function tokenURI(uint256 tokenId) external view returns (string memory);
543 }
544 
545 // File: @openzeppelin/contracts/utils/Strings.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev String operations.
554  */
555 library Strings {
556     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
557 
558     /**
559      * @dev Converts a uint256 to its ASCII string decimal representation.
560      */
561     function toString(uint256 value) internal pure returns (string memory) {
562         // Inspired by OraclizeAPI's implementation - MIT licence
563         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
564 
565         if (value == 0) {
566             return "0";
567         }
568         uint256 temp = value;
569         uint256 digits;
570         while (temp != 0) {
571             digits++;
572             temp /= 10;
573         }
574         bytes memory buffer = new bytes(digits);
575         while (value != 0) {
576             digits -= 1;
577             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
578             value /= 10;
579         }
580         return string(buffer);
581     }
582 
583     /**
584      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
585      */
586     function toHexString(uint256 value) internal pure returns (string memory) {
587         if (value == 0) {
588             return "0x00";
589         }
590         uint256 temp = value;
591         uint256 length = 0;
592         while (temp != 0) {
593             length++;
594             temp >>= 8;
595         }
596         return toHexString(value, length);
597     }
598 
599     /**
600      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
601      */
602     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
603         bytes memory buffer = new bytes(2 * length + 2);
604         buffer[0] = "0";
605         buffer[1] = "x";
606         for (uint256 i = 2 * length + 1; i > 1; --i) {
607             buffer[i] = _HEX_SYMBOLS[value & 0xf];
608             value >>= 4;
609         }
610         require(value == 0, "Strings: hex length insufficient");
611         return string(buffer);
612     }
613 }
614 
615 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Contract module that helps prevent reentrant calls to a function.
624  *
625  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
626  * available, which can be applied to functions to make sure there are no nested
627  * (reentrant) calls to them.
628  *
629  * Note that because there is a single nonReentrant guard, functions marked as
630  * nonReentrant may not call one another. This can be worked around by making
631  * those functions private, and then adding external nonReentrant entry
632  * points to them.
633  *
634  * TIP: If you would like to learn more about reentrancy and alternative ways
635  * to protect against it, check out our blog post
636  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
637  */
638 abstract contract ReentrancyGuard {
639     // Booleans are more expensive than uint256 or any type that takes up a full
640     // word because each write operation emits an extra SLOAD to first read the
641     // slot's contents, replace the bits taken up by the boolean, and then write
642     // back. This is the compiler's defense against contract upgrades and
643     // pointer aliasing, and it cannot be disabled.
644 
645     // The values being non-zero value makes deployment a bit more expensive,
646     // but in exchange the refund on every call to nonReentrant will be lower in
647     // amount. Since refunds are capped to a percentage of the total
648     // transaction's gas, it is best to keep them low in cases like this one, to
649     // increase the likelihood of the full refund coming into effect.
650     uint256 private constant _NOT_ENTERED = 1;
651     uint256 private constant _ENTERED = 2;
652 
653     uint256 private _status;
654 
655     constructor() {
656         _status = _NOT_ENTERED;
657     }
658 
659     /**
660      * @dev Prevents a contract from calling itself, directly or indirectly.
661      * Calling a nonReentrant function from another nonReentrant
662      * function is not supported. It is possible to prevent this from happening
663      * by making the nonReentrant function external, and making it call a
664      * private function that does the actual work.
665      */
666     modifier nonReentrant() {
667         // On the first call to nonReentrant, _notEntered will be true
668         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
669 
670         // Any calls to nonReentrant after this point will fail
671         _status = _ENTERED;
672 
673         _;
674 
675         // By storing the original value once again, a refund is triggered (see
676         // https://eips.ethereum.org/EIPS/eip-2200)
677         _status = _NOT_ENTERED;
678     }
679 }
680 
681 // File: @openzeppelin/contracts/utils/Context.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @dev Provides information about the current execution context, including the
690  * sender of the transaction and its data. While these are generally available
691  * via msg.sender and msg.data, they should not be accessed in such a direct
692  * manner, since when dealing with meta-transactions the account sending and
693  * paying for execution may not be the actual sender (as far as an application
694  * is concerned).
695  *
696  * This contract is only required for intermediate, library-like contracts.
697  */
698 abstract contract Context {
699     function _msgSender() internal view virtual returns (address) {
700         return msg.sender;
701     }
702 
703     function _msgData() internal view virtual returns (bytes calldata) {
704         return msg.data;
705     }
706 }
707 
708 // File: @openzeppelin/contracts/access/Ownable.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 
716 /**
717  * @dev Contract module which provides a basic access control mechanism, where
718  * there is an account (an owner) that can be granted exclusive access to
719  * specific functions.
720  *
721  * By default, the owner account will be the one that deploys the contract. This
722  * can later be changed with {transferOwnership}.
723  *
724  * This module is used through inheritance. It will make available the modifier
725  * onlyOwner, which can be applied to your functions to restrict their use to
726  * the owner.
727  */
728 abstract contract Ownable is Context {
729     address private _owner;
730 
731     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
732 
733     /**
734      * @dev Initializes the contract setting the deployer as the initial owner.
735      */
736     constructor() {
737         _transferOwnership(_msgSender());
738     }
739 
740     /**
741      * @dev Returns the address of the current owner.
742      */
743     function owner() public view virtual returns (address) {
744         return _owner;
745     }
746 
747     /**
748      * @dev Throws if called by any account other than the owner.
749      */
750     function _onlyOwner() private view {
751        require(owner() == _msgSender(), "Ownable: caller is not the owner");
752     }
753 
754     modifier onlyOwner() {
755         _onlyOwner();
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * onlyOwner functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         _transferOwnership(address(0));
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (newOwner).
772      * Can only be called by the current owner.
773      */
774     function transferOwnership(address newOwner) public virtual onlyOwner {
775         require(newOwner != address(0), "Ownable: new owner is the zero address");
776         _transferOwnership(newOwner);
777     }
778 
779     /**
780      * @dev Transfers ownership of the contract to a new account (newOwner).
781      * Internal function without access restriction.
782      */
783     function _transferOwnership(address newOwner) internal virtual {
784         address oldOwner = _owner;
785         _owner = newOwner;
786         emit OwnershipTransferred(oldOwner, newOwner);
787     }
788 }
789 
790 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
791 pragma solidity ^0.8.9;
792 
793 interface IOperatorFilterRegistry {
794     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
795     function register(address registrant) external;
796     function registerAndSubscribe(address registrant, address subscription) external;
797     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
798     function updateOperator(address registrant, address operator, bool filtered) external;
799     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
800     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
801     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
802     function subscribe(address registrant, address registrantToSubscribe) external;
803     function unsubscribe(address registrant, bool copyExistingEntries) external;
804     function subscriptionOf(address addr) external returns (address registrant);
805     function subscribers(address registrant) external returns (address[] memory);
806     function subscriberAt(address registrant, uint256 index) external returns (address);
807     function copyEntriesOf(address registrant, address registrantToCopy) external;
808     function isOperatorFiltered(address registrant, address operator) external returns (bool);
809     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
810     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
811     function filteredOperators(address addr) external returns (address[] memory);
812     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
813     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
814     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
815     function isRegistered(address addr) external returns (bool);
816     function codeHashOf(address addr) external returns (bytes32);
817 }
818 
819 // File contracts/OperatorFilter/OperatorFilterer.sol
820 pragma solidity ^0.8.9;
821 
822 abstract contract OperatorFilterer {
823     error OperatorNotAllowed(address operator);
824 
825     IOperatorFilterRegistry constant operatorFilterRegistry =
826         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
827 
828     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
829         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
830         // will not revert, but the contract will need to be registered with the registry once it is deployed in
831         // order for the modifier to filter addresses.
832         if (address(operatorFilterRegistry).code.length > 0) {
833             if (subscribe) {
834                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
835             } else {
836                 if (subscriptionOrRegistrantToCopy != address(0)) {
837                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
838                 } else {
839                     operatorFilterRegistry.register(address(this));
840                 }
841             }
842         }
843     }
844 
845     function _onlyAllowedOperator(address from) private view {
846       if (
847           !(
848               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
849               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
850           )
851       ) {
852           revert OperatorNotAllowed(msg.sender);
853       }
854     }
855 
856     modifier onlyAllowedOperator(address from) virtual {
857         // Check registry code length to facilitate testing in environments without a deployed registry.
858         if (address(operatorFilterRegistry).code.length > 0) {
859             // Allow spending tokens from addresses with balance
860             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
861             // from an EOA.
862             if (from == msg.sender) {
863                 _;
864                 return;
865             }
866             _onlyAllowedOperator(from);
867         }
868         _;
869     }
870 
871     modifier onlyAllowedOperatorApproval(address operator) virtual {
872         _checkFilterOperator(operator);
873         _;
874     }
875 
876     function _checkFilterOperator(address operator) internal view virtual {
877         // Check registry code length to facilitate testing in environments without a deployed registry.
878         if (address(operatorFilterRegistry).code.length > 0) {
879             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
880                 revert OperatorNotAllowed(operator);
881             }
882         }
883     }
884 }
885 
886 //-------------END DEPENDENCIES------------------------//
887 
888 
889   
890 error TransactionCapExceeded();
891 error PublicMintingClosed();
892 error ExcessiveOwnedMints();
893 error MintZeroQuantity();
894 error InvalidPayment();
895 error CapExceeded();
896 error IsAlreadyUnveiled();
897 error ValueCannotBeZero();
898 error CannotBeNullAddress();
899 error NoStateChange();
900 
901 error PublicMintClosed();
902 error AllowlistMintClosed();
903 
904 error AddressNotAllowlisted();
905 error AllowlistDropTimeHasNotPassed();
906 error PublicDropTimeHasNotPassed();
907 error DropTimeNotInFuture();
908 
909 error OnlyERC20MintingEnabled();
910 error ERC20TokenNotApproved();
911 error ERC20InsufficientBalance();
912 error ERC20InsufficientAllowance();
913 error ERC20TransferFailed();
914 
915 error ClaimModeDisabled();
916 error IneligibleRedemptionContract();
917 error TokenAlreadyRedeemed();
918 error InvalidOwnerForRedemption();
919 error InvalidApprovalForRedemption();
920 
921 error ERC721RestrictedApprovalAddressRestricted();
922   
923   
924 // Rampp Contracts v2.1 (Teams.sol)
925 
926 error InvalidTeamAddress();
927 error DuplicateTeamAddress();
928 pragma solidity ^0.8.0;
929 
930 /**
931 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
932 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
933 * This will easily allow cross-collaboration via Mintplex.xyz.
934 **/
935 abstract contract Teams is Ownable{
936   mapping (address => bool) internal team;
937 
938   /**
939   * @dev Adds an address to the team. Allows them to execute protected functions
940   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
941   **/
942   function addToTeam(address _address) public onlyOwner {
943     if(_address == address(0)) revert InvalidTeamAddress();
944     if(inTeam(_address)) revert DuplicateTeamAddress();
945   
946     team[_address] = true;
947   }
948 
949   /**
950   * @dev Removes an address to the team.
951   * @param _address the ETH address to remove, cannot be 0x and must be in team
952   **/
953   function removeFromTeam(address _address) public onlyOwner {
954     if(_address == address(0)) revert InvalidTeamAddress();
955     if(!inTeam(_address)) revert InvalidTeamAddress();
956   
957     team[_address] = false;
958   }
959 
960   /**
961   * @dev Check if an address is valid and active in the team
962   * @param _address ETH address to check for truthiness
963   **/
964   function inTeam(address _address)
965     public
966     view
967     returns (bool)
968   {
969     if(_address == address(0)) revert InvalidTeamAddress();
970     return team[_address] == true;
971   }
972 
973   /**
974   * @dev Throws if called by any account other than the owner or team member.
975   */
976   function _onlyTeamOrOwner() private view {
977     bool _isOwner = owner() == _msgSender();
978     bool _isTeam = inTeam(_msgSender());
979     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
980   }
981 
982   modifier onlyTeamOrOwner() {
983     _onlyTeamOrOwner();
984     _;
985   }
986 }
987 
988 
989   
990   
991 /**
992  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
993  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
994  *
995  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
996  * 
997  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
998  *
999  * Does not support burning tokens to address(0).
1000  */
1001 contract ERC721A is
1002   Context,
1003   ERC165,
1004   IERC721,
1005   IERC721Metadata,
1006   IERC721Enumerable,
1007   Teams
1008   , OperatorFilterer
1009 {
1010   using Address for address;
1011   using Strings for uint256;
1012 
1013   struct TokenOwnership {
1014     address addr;
1015     uint64 startTimestamp;
1016   }
1017 
1018   struct AddressData {
1019     uint128 balance;
1020     uint128 numberMinted;
1021   }
1022 
1023   uint256 private currentIndex;
1024 
1025   uint256 public immutable collectionSize;
1026   uint256 public maxBatchSize;
1027 
1028   // Token name
1029   string private _name;
1030 
1031   // Token symbol
1032   string private _symbol;
1033 
1034   // Mapping from token ID to ownership details
1035   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1036   mapping(uint256 => TokenOwnership) private _ownerships;
1037 
1038   // Mapping owner address to address data
1039   mapping(address => AddressData) private _addressData;
1040 
1041   // Mapping from token ID to approved address
1042   mapping(uint256 => address) private _tokenApprovals;
1043 
1044   // Mapping from owner to operator approvals
1045   mapping(address => mapping(address => bool)) private _operatorApprovals;
1046 
1047   /* @dev Mapping of restricted operator approvals set by contract Owner
1048   * This serves as an optional addition to ERC-721 so
1049   * that the contract owner can elect to prevent specific addresses/contracts
1050   * from being marked as the approver for a token. The reason for this
1051   * is that some projects may want to retain control of where their tokens can/can not be listed
1052   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1053   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1054   */
1055   mapping(address => bool) public restrictedApprovalAddresses;
1056 
1057   /**
1058    * @dev
1059    * maxBatchSize refers to how much a minter can mint at a time.
1060    * collectionSize_ refers to how many tokens are in the collection.
1061    */
1062   constructor(
1063     string memory name_,
1064     string memory symbol_,
1065     uint256 maxBatchSize_,
1066     uint256 collectionSize_
1067   ) OperatorFilterer(address(0), false) {
1068     require(
1069       collectionSize_ > 0,
1070       "ERC721A: collection must have a nonzero supply"
1071     );
1072     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1073     _name = name_;
1074     _symbol = symbol_;
1075     maxBatchSize = maxBatchSize_;
1076     collectionSize = collectionSize_;
1077     currentIndex = _startTokenId();
1078   }
1079 
1080   /**
1081   * To change the starting tokenId, please override this function.
1082   */
1083   function _startTokenId() internal view virtual returns (uint256) {
1084     return 1;
1085   }
1086 
1087   /**
1088    * @dev See {IERC721Enumerable-totalSupply}.
1089    */
1090   function totalSupply() public view override returns (uint256) {
1091     return _totalMinted();
1092   }
1093 
1094   function currentTokenId() public view returns (uint256) {
1095     return _totalMinted();
1096   }
1097 
1098   function getNextTokenId() public view returns (uint256) {
1099       return _totalMinted() + 1;
1100   }
1101 
1102   /**
1103   * Returns the total amount of tokens minted in the contract.
1104   */
1105   function _totalMinted() internal view returns (uint256) {
1106     unchecked {
1107       return currentIndex - _startTokenId();
1108     }
1109   }
1110 
1111   /**
1112    * @dev See {IERC721Enumerable-tokenByIndex}.
1113    */
1114   function tokenByIndex(uint256 index) public view override returns (uint256) {
1115     require(index < totalSupply(), "ERC721A: global index out of bounds");
1116     return index;
1117   }
1118 
1119   /**
1120    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1121    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1122    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1123    */
1124   function tokenOfOwnerByIndex(address owner, uint256 index)
1125     public
1126     view
1127     override
1128     returns (uint256)
1129   {
1130     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1131     uint256 numMintedSoFar = totalSupply();
1132     uint256 tokenIdsIdx = 0;
1133     address currOwnershipAddr = address(0);
1134     for (uint256 i = 0; i < numMintedSoFar; i++) {
1135       TokenOwnership memory ownership = _ownerships[i];
1136       if (ownership.addr != address(0)) {
1137         currOwnershipAddr = ownership.addr;
1138       }
1139       if (currOwnershipAddr == owner) {
1140         if (tokenIdsIdx == index) {
1141           return i;
1142         }
1143         tokenIdsIdx++;
1144       }
1145     }
1146     revert("ERC721A: unable to get token of owner by index");
1147   }
1148 
1149   /**
1150    * @dev See {IERC165-supportsInterface}.
1151    */
1152   function supportsInterface(bytes4 interfaceId)
1153     public
1154     view
1155     virtual
1156     override(ERC165, IERC165)
1157     returns (bool)
1158   {
1159     return
1160       interfaceId == type(IERC721).interfaceId ||
1161       interfaceId == type(IERC721Metadata).interfaceId ||
1162       interfaceId == type(IERC721Enumerable).interfaceId ||
1163       super.supportsInterface(interfaceId);
1164   }
1165 
1166   /**
1167    * @dev See {IERC721-balanceOf}.
1168    */
1169   function balanceOf(address owner) public view override returns (uint256) {
1170     require(owner != address(0), "ERC721A: balance query for the zero address");
1171     return uint256(_addressData[owner].balance);
1172   }
1173 
1174   function _numberMinted(address owner) internal view returns (uint256) {
1175     require(
1176       owner != address(0),
1177       "ERC721A: number minted query for the zero address"
1178     );
1179     return uint256(_addressData[owner].numberMinted);
1180   }
1181 
1182   function ownershipOf(uint256 tokenId)
1183     internal
1184     view
1185     returns (TokenOwnership memory)
1186   {
1187     uint256 curr = tokenId;
1188 
1189     unchecked {
1190         if (_startTokenId() <= curr && curr < currentIndex) {
1191             TokenOwnership memory ownership = _ownerships[curr];
1192             if (ownership.addr != address(0)) {
1193                 return ownership;
1194             }
1195 
1196             // Invariant:
1197             // There will always be an ownership that has an address and is not burned
1198             // before an ownership that does not have an address and is not burned.
1199             // Hence, curr will not underflow.
1200             while (true) {
1201                 curr--;
1202                 ownership = _ownerships[curr];
1203                 if (ownership.addr != address(0)) {
1204                     return ownership;
1205                 }
1206             }
1207         }
1208     }
1209 
1210     revert("ERC721A: unable to determine the owner of token");
1211   }
1212 
1213   /**
1214    * @dev See {IERC721-ownerOf}.
1215    */
1216   function ownerOf(uint256 tokenId) public view override returns (address) {
1217     return ownershipOf(tokenId).addr;
1218   }
1219 
1220   /**
1221    * @dev See {IERC721Metadata-name}.
1222    */
1223   function name() public view virtual override returns (string memory) {
1224     return _name;
1225   }
1226 
1227   /**
1228    * @dev See {IERC721Metadata-symbol}.
1229    */
1230   function symbol() public view virtual override returns (string memory) {
1231     return _symbol;
1232   }
1233 
1234   /**
1235    * @dev See {IERC721Metadata-tokenURI}.
1236    */
1237   function tokenURI(uint256 tokenId)
1238     public
1239     view
1240     virtual
1241     override
1242     returns (string memory)
1243   {
1244     string memory baseURI = _baseURI();
1245     string memory extension = _baseURIExtension();
1246     return
1247       bytes(baseURI).length > 0
1248         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1249         : "";
1250   }
1251 
1252   /**
1253    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1254    * token will be the concatenation of the baseURI and the tokenId. Empty
1255    * by default, can be overriden in child contracts.
1256    */
1257   function _baseURI() internal view virtual returns (string memory) {
1258     return "";
1259   }
1260 
1261   /**
1262    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1263    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1264    * by default, can be overriden in child contracts.
1265    */
1266   function _baseURIExtension() internal view virtual returns (string memory) {
1267     return "";
1268   }
1269 
1270   /**
1271    * @dev Sets the value for an address to be in the restricted approval address pool.
1272    * Setting an address to true will disable token owners from being able to mark the address
1273    * for approval for trading. This would be used in theory to prevent token owners from listing
1274    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1275    * @param _address the marketplace/user to modify restriction status of
1276    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1277    */
1278   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1279     restrictedApprovalAddresses[_address] = _isRestricted;
1280   }
1281 
1282   /**
1283    * @dev See {IERC721-approve}.
1284    */
1285   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1286     address owner = ERC721A.ownerOf(tokenId);
1287     require(to != owner, "ERC721A: approval to current owner");
1288     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1289 
1290     require(
1291       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1292       "ERC721A: approve caller is not owner nor approved for all"
1293     );
1294 
1295     _approve(to, tokenId, owner);
1296   }
1297 
1298   /**
1299    * @dev See {IERC721-getApproved}.
1300    */
1301   function getApproved(uint256 tokenId) public view override returns (address) {
1302     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1303 
1304     return _tokenApprovals[tokenId];
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-setApprovalForAll}.
1309    */
1310   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1311     require(operator != _msgSender(), "ERC721A: approve to caller");
1312     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1313 
1314     _operatorApprovals[_msgSender()][operator] = approved;
1315     emit ApprovalForAll(_msgSender(), operator, approved);
1316   }
1317 
1318   /**
1319    * @dev See {IERC721-isApprovedForAll}.
1320    */
1321   function isApprovedForAll(address owner, address operator)
1322     public
1323     view
1324     virtual
1325     override
1326     returns (bool)
1327   {
1328     return _operatorApprovals[owner][operator];
1329   }
1330 
1331   /**
1332    * @dev See {IERC721-transferFrom}.
1333    */
1334   function transferFrom(
1335     address from,
1336     address to,
1337     uint256 tokenId
1338   ) public override onlyAllowedOperator(from) {
1339     _transfer(from, to, tokenId);
1340   }
1341 
1342   /**
1343    * @dev See {IERC721-safeTransferFrom}.
1344    */
1345   function safeTransferFrom(
1346     address from,
1347     address to,
1348     uint256 tokenId
1349   ) public override onlyAllowedOperator(from) {
1350     safeTransferFrom(from, to, tokenId, "");
1351   }
1352 
1353   /**
1354    * @dev See {IERC721-safeTransferFrom}.
1355    */
1356   function safeTransferFrom(
1357     address from,
1358     address to,
1359     uint256 tokenId,
1360     bytes memory _data
1361   ) public override onlyAllowedOperator(from) {
1362     _transfer(from, to, tokenId);
1363     require(
1364       _checkOnERC721Received(from, to, tokenId, _data),
1365       "ERC721A: transfer to non ERC721Receiver implementer"
1366     );
1367   }
1368 
1369   /**
1370    * @dev Returns whether tokenId exists.
1371    *
1372    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1373    *
1374    * Tokens start existing when they are minted (_mint),
1375    */
1376   function _exists(uint256 tokenId) internal view returns (bool) {
1377     return _startTokenId() <= tokenId && tokenId < currentIndex;
1378   }
1379 
1380   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1381     _safeMint(to, quantity, isAdminMint, "");
1382   }
1383 
1384   /**
1385    * @dev Mints quantity tokens and transfers them to to.
1386    *
1387    * Requirements:
1388    *
1389    * - there must be quantity tokens remaining unminted in the total collection.
1390    * - to cannot be the zero address.
1391    * - quantity cannot be larger than the max batch size.
1392    *
1393    * Emits a {Transfer} event.
1394    */
1395   function _safeMint(
1396     address to,
1397     uint256 quantity,
1398     bool isAdminMint,
1399     bytes memory _data
1400   ) internal {
1401     uint256 startTokenId = currentIndex;
1402     require(to != address(0), "ERC721A: mint to the zero address");
1403     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1404     require(!_exists(startTokenId), "ERC721A: token already minted");
1405 
1406     // For admin mints we do not want to enforce the maxBatchSize limit
1407     if (isAdminMint == false) {
1408         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1409     }
1410 
1411     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1412 
1413     AddressData memory addressData = _addressData[to];
1414     _addressData[to] = AddressData(
1415       addressData.balance + uint128(quantity),
1416       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1417     );
1418     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1419 
1420     uint256 updatedIndex = startTokenId;
1421 
1422     for (uint256 i = 0; i < quantity; i++) {
1423       emit Transfer(address(0), to, updatedIndex);
1424       require(
1425         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1426         "ERC721A: transfer to non ERC721Receiver implementer"
1427       );
1428       updatedIndex++;
1429     }
1430 
1431     currentIndex = updatedIndex;
1432     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1433   }
1434 
1435   /**
1436    * @dev Transfers tokenId from from to to.
1437    *
1438    * Requirements:
1439    *
1440    * - to cannot be the zero address.
1441    * - tokenId token must be owned by from.
1442    *
1443    * Emits a {Transfer} event.
1444    */
1445   function _transfer(
1446     address from,
1447     address to,
1448     uint256 tokenId
1449   ) private {
1450     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1451 
1452     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1453       getApproved(tokenId) == _msgSender() ||
1454       isApprovedForAll(prevOwnership.addr, _msgSender()));
1455 
1456     require(
1457       isApprovedOrOwner,
1458       "ERC721A: transfer caller is not owner nor approved"
1459     );
1460 
1461     require(
1462       prevOwnership.addr == from,
1463       "ERC721A: transfer from incorrect owner"
1464     );
1465     require(to != address(0), "ERC721A: transfer to the zero address");
1466 
1467     _beforeTokenTransfers(from, to, tokenId, 1);
1468 
1469     // Clear approvals from the previous owner
1470     _approve(address(0), tokenId, prevOwnership.addr);
1471 
1472     _addressData[from].balance -= 1;
1473     _addressData[to].balance += 1;
1474     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1475 
1476     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1477     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1478     uint256 nextTokenId = tokenId + 1;
1479     if (_ownerships[nextTokenId].addr == address(0)) {
1480       if (_exists(nextTokenId)) {
1481         _ownerships[nextTokenId] = TokenOwnership(
1482           prevOwnership.addr,
1483           prevOwnership.startTimestamp
1484         );
1485       }
1486     }
1487 
1488     emit Transfer(from, to, tokenId);
1489     _afterTokenTransfers(from, to, tokenId, 1);
1490   }
1491 
1492   /**
1493    * @dev Approve to to operate on tokenId
1494    *
1495    * Emits a {Approval} event.
1496    */
1497   function _approve(
1498     address to,
1499     uint256 tokenId,
1500     address owner
1501   ) private {
1502     _tokenApprovals[tokenId] = to;
1503     emit Approval(owner, to, tokenId);
1504   }
1505 
1506   uint256 public nextOwnerToExplicitlySet = 0;
1507 
1508   /**
1509    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1510    */
1511   function _setOwnersExplicit(uint256 quantity) internal {
1512     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1513     require(quantity > 0, "quantity must be nonzero");
1514     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1515 
1516     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1517     if (endIndex > collectionSize - 1) {
1518       endIndex = collectionSize - 1;
1519     }
1520     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1521     require(_exists(endIndex), "not enough minted yet for this cleanup");
1522     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1523       if (_ownerships[i].addr == address(0)) {
1524         TokenOwnership memory ownership = ownershipOf(i);
1525         _ownerships[i] = TokenOwnership(
1526           ownership.addr,
1527           ownership.startTimestamp
1528         );
1529       }
1530     }
1531     nextOwnerToExplicitlySet = endIndex + 1;
1532   }
1533 
1534   /**
1535    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1536    * The call is not executed if the target address is not a contract.
1537    *
1538    * @param from address representing the previous owner of the given token ID
1539    * @param to target address that will receive the tokens
1540    * @param tokenId uint256 ID of the token to be transferred
1541    * @param _data bytes optional data to send along with the call
1542    * @return bool whether the call correctly returned the expected magic value
1543    */
1544   function _checkOnERC721Received(
1545     address from,
1546     address to,
1547     uint256 tokenId,
1548     bytes memory _data
1549   ) private returns (bool) {
1550     if (to.isContract()) {
1551       try
1552         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1553       returns (bytes4 retval) {
1554         return retval == IERC721Receiver(to).onERC721Received.selector;
1555       } catch (bytes memory reason) {
1556         if (reason.length == 0) {
1557           revert("ERC721A: transfer to non ERC721Receiver implementer");
1558         } else {
1559           assembly {
1560             revert(add(32, reason), mload(reason))
1561           }
1562         }
1563       }
1564     } else {
1565       return true;
1566     }
1567   }
1568 
1569   /**
1570    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1571    *
1572    * startTokenId - the first token id to be transferred
1573    * quantity - the amount to be transferred
1574    *
1575    * Calling conditions:
1576    *
1577    * - When from and to are both non-zero, from's tokenId will be
1578    * transferred to to.
1579    * - When from is zero, tokenId will be minted for to.
1580    */
1581   function _beforeTokenTransfers(
1582     address from,
1583     address to,
1584     uint256 startTokenId,
1585     uint256 quantity
1586   ) internal virtual {}
1587 
1588   /**
1589    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1590    * minting.
1591    *
1592    * startTokenId - the first token id to be transferred
1593    * quantity - the amount to be transferred
1594    *
1595    * Calling conditions:
1596    *
1597    * - when from and to are both non-zero.
1598    * - from and to are never both zero.
1599    */
1600   function _afterTokenTransfers(
1601     address from,
1602     address to,
1603     uint256 startTokenId,
1604     uint256 quantity
1605   ) internal virtual {}
1606 }
1607 
1608 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1609 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1610 // @notice -- See Medium article --
1611 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1612 abstract contract ERC721ARedemption is ERC721A {
1613   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1614   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1615 
1616   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1617   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1618   
1619   uint256 public redemptionSurcharge = 0 ether;
1620   bool public redemptionModeEnabled;
1621   bool public verifiedClaimModeEnabled;
1622   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1623   mapping(address => bool) public redemptionContracts;
1624   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1625 
1626   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1627   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1628     redemptionContracts[_contractAddress] = _status;
1629   }
1630 
1631   // @dev Allow owner/team to determine if contract is accepting redemption mints
1632   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1633     redemptionModeEnabled = _newStatus;
1634   }
1635 
1636   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1637   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1638     verifiedClaimModeEnabled = _newStatus;
1639   }
1640 
1641   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1642   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1643     redemptionSurcharge = _newSurchargeInWei;
1644   }
1645 
1646   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1647   // @notice Must be a wallet address or implement IERC721Receiver.
1648   // Cannot be null address as this will break any ERC-721A implementation without a proper
1649   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1650   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1651     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1652     redemptionAddress = _newRedemptionAddress;
1653   }
1654 
1655   /**
1656   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1657   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1658   * the contract owner or Team => redemptionAddress. 
1659   * @param tokenId the token to be redeemed.
1660   * Emits a {Redeemed} event.
1661   **/
1662   function redeem(address redemptionContract, uint256 tokenId) public payable {
1663     if(getNextTokenId() > collectionSize) revert CapExceeded();
1664     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1665     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1666     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1667     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1668     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1669     
1670     IERC721 _targetContract = IERC721(redemptionContract);
1671     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1672     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1673     
1674     // Warning: Since there is no standarized return value for transfers of ERC-721
1675     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1676     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1677     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1678     // but the NFT may not have been sent to the redemptionAddress.
1679     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1680     tokenRedemptions[redemptionContract][tokenId] = true;
1681 
1682     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1683     _safeMint(_msgSender(), 1, false);
1684   }
1685 
1686   /**
1687   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1688   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1689   * @param tokenId the token to be redeemed.
1690   * Emits a {VerifiedClaim} event.
1691   **/
1692   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1693     if(getNextTokenId() > collectionSize) revert CapExceeded();
1694     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1695     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1696     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1697     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1698     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1699     
1700     tokenRedemptions[redemptionContract][tokenId] = true;
1701     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1702     _safeMint(_msgSender(), 1, false);
1703   }
1704 }
1705 
1706 
1707   
1708   
1709 interface IERC20 {
1710   function allowance(address owner, address spender) external view returns (uint256);
1711   function transfer(address _to, uint256 _amount) external returns (bool);
1712   function balanceOf(address account) external view returns (uint256);
1713   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1714 }
1715 
1716 // File: WithdrawableV2
1717 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1718 // ERC-20 Payouts are limited to a single payout address. This feature 
1719 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1720 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1721 abstract contract WithdrawableV2 is Teams {
1722   struct acceptedERC20 {
1723     bool isActive;
1724     uint256 chargeAmount;
1725   }
1726 
1727   
1728   mapping(address => acceptedERC20) private allowedTokenContracts;
1729   address[] public payableAddresses = [0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0xBb06652BFff9651238Bb5fcF2dAC6be34920C788];
1730   address public erc20Payable = 0xBb06652BFff9651238Bb5fcF2dAC6be34920C788;
1731   uint256[] public payableFees = [2,98];
1732   uint256 public payableAddressCount = 2;
1733   bool public onlyERC20MintingMode;
1734   
1735 
1736   function withdrawAll() public onlyTeamOrOwner {
1737       if(address(this).balance == 0) revert ValueCannotBeZero();
1738       _withdrawAll(address(this).balance);
1739   }
1740 
1741   function _withdrawAll(uint256 balance) private {
1742       for(uint i=0; i < payableAddressCount; i++ ) {
1743           _widthdraw(
1744               payableAddresses[i],
1745               (balance * payableFees[i]) / 100
1746           );
1747       }
1748   }
1749   
1750   function _widthdraw(address _address, uint256 _amount) private {
1751       (bool success, ) = _address.call{value: _amount}("");
1752       require(success, "Transfer failed.");
1753   }
1754 
1755   /**
1756   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1757   * in the event ERC-20 tokens are paid to the contract for mints.
1758   * @param _tokenContract contract of ERC-20 token to withdraw
1759   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1760   */
1761   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1762     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1763     IERC20 tokenContract = IERC20(_tokenContract);
1764     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1765     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1766   }
1767 
1768   /**
1769   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1770   * @param _erc20TokenContract address of ERC-20 contract in question
1771   */
1772   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1773     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1774   }
1775 
1776   /**
1777   * @dev get the value of tokens to transfer for user of an ERC-20
1778   * @param _erc20TokenContract address of ERC-20 contract in question
1779   */
1780   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1781     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1782     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1783   }
1784 
1785   /**
1786   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1787   * @param _erc20TokenContract address of ERC-20 contract in question
1788   * @param _isActive default status of if contract should be allowed to accept payments
1789   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1790   */
1791   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1792     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1793     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1794   }
1795 
1796   /**
1797   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1798   * it will assume the default value of zero. This should not be used to create new payment tokens.
1799   * @param _erc20TokenContract address of ERC-20 contract in question
1800   */
1801   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1802     allowedTokenContracts[_erc20TokenContract].isActive = true;
1803   }
1804 
1805   /**
1806   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1807   * it will assume the default value of zero. This should not be used to create new payment tokens.
1808   * @param _erc20TokenContract address of ERC-20 contract in question
1809   */
1810   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1811     allowedTokenContracts[_erc20TokenContract].isActive = false;
1812   }
1813 
1814   /**
1815   * @dev Enable only ERC-20 payments for minting on this contract
1816   */
1817   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1818     onlyERC20MintingMode = true;
1819   }
1820 
1821   /**
1822   * @dev Disable only ERC-20 payments for minting on this contract
1823   */
1824   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1825     onlyERC20MintingMode = false;
1826   }
1827 
1828   /**
1829   * @dev Set the payout of the ERC-20 token payout to a specific address
1830   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1831   */
1832   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1833     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1834     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1835     erc20Payable = _newErc20Payable;
1836   }
1837 }
1838 
1839 
1840   
1841   
1842 // File: EarlyMintIncentive.sol
1843 // Allows the contract to have the first x tokens have a discount or
1844 // zero fee that can be calculated on the fly.
1845 abstract contract EarlyMintIncentive is Teams, ERC721A {
1846   uint256 public PRICE = 0.004 ether;
1847   uint256 public EARLY_MINT_PRICE = 0 ether;
1848   uint256 public earlyMintTokenIdCap = 1000;
1849   bool public usingEarlyMintIncentive = true;
1850 
1851   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1852     usingEarlyMintIncentive = true;
1853   }
1854 
1855   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1856     usingEarlyMintIncentive = false;
1857   }
1858 
1859   /**
1860   * @dev Set the max token ID in which the cost incentive will be applied.
1861   * @param _newTokenIdCap max tokenId in which incentive will be applied
1862   */
1863   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1864     if(_newTokenIdCap > collectionSize) revert CapExceeded();
1865     if(_newTokenIdCap == 0) revert ValueCannotBeZero();
1866     earlyMintTokenIdCap = _newTokenIdCap;
1867   }
1868 
1869   /**
1870   * @dev Set the incentive mint price
1871   * @param _feeInWei new price per token when in incentive range
1872   */
1873   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1874     EARLY_MINT_PRICE = _feeInWei;
1875   }
1876 
1877   /**
1878   * @dev Set the primary mint price - the base price when not under incentive
1879   * @param _feeInWei new price per token
1880   */
1881   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1882     PRICE = _feeInWei;
1883   }
1884 
1885   function getPrice(uint256 _count) public view returns (uint256) {
1886     if(_count == 0) revert ValueCannotBeZero();
1887 
1888     // short circuit function if we dont need to even calc incentive pricing
1889     // short circuit if the current tokenId is also already over cap
1890     if(
1891       usingEarlyMintIncentive == false ||
1892       currentTokenId() > earlyMintTokenIdCap
1893     ) {
1894       return PRICE * _count;
1895     }
1896 
1897     uint256 endingTokenId = currentTokenId() + _count;
1898     // If qty to mint results in a final token ID less than or equal to the cap then
1899     // the entire qty is within free mint.
1900     if(endingTokenId  <= earlyMintTokenIdCap) {
1901       return EARLY_MINT_PRICE * _count;
1902     }
1903 
1904     // If the current token id is less than the incentive cap
1905     // and the ending token ID is greater than the incentive cap
1906     // we will be straddling the cap so there will be some amount
1907     // that are incentive and some that are regular fee.
1908     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1909     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1910 
1911     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1912   }
1913 }
1914 
1915   
1916   
1917 abstract contract RamppERC721A is 
1918     Ownable,
1919     Teams,
1920     ERC721ARedemption,
1921     WithdrawableV2,
1922     ReentrancyGuard 
1923     , EarlyMintIncentive 
1924      
1925     
1926 {
1927   constructor(
1928     string memory tokenName,
1929     string memory tokenSymbol
1930   ) ERC721A(tokenName, tokenSymbol, 2, 3333) { }
1931     uint8 constant public CONTRACT_VERSION = 2;
1932     string public _baseTokenURI = "ipfs://bafybeie6fmn7y5c2ydpn36rghwcmddb5qd6vs3yfubyzojycizxrcpqjpq/";
1933     string public _baseTokenExtension = ".json";
1934 
1935     bool public mintingOpen = true;
1936     bool public isRevealed;
1937     
1938     uint256 public MAX_WALLET_MINTS = 2;
1939 
1940   
1941     /////////////// Admin Mint Functions
1942     /**
1943      * @dev Mints a token to an address with a tokenURI.
1944      * This is owner only and allows a fee-free drop
1945      * @param _to address of the future owner of the token
1946      * @param _qty amount of tokens to drop the owner
1947      */
1948      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1949          if(_qty == 0) revert MintZeroQuantity();
1950          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1951          _safeMint(_to, _qty, true);
1952      }
1953 
1954   
1955     /////////////// PUBLIC MINT FUNCTIONS
1956     /**
1957     * @dev Mints tokens to an address in batch.
1958     * fee may or may not be required*
1959     * @param _to address of the future owner of the token
1960     * @param _amount number of tokens to mint
1961     */
1962     function mintToMultiple(address _to, uint256 _amount) public payable {
1963         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1964         if(_amount == 0) revert MintZeroQuantity();
1965         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1966         if(!mintingOpen) revert PublicMintClosed();
1967         
1968         
1969         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1970         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1971         if(msg.value != getPrice(_amount)) revert InvalidPayment();
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
1984       if(_amount == 0) revert MintZeroQuantity();
1985       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1986       if(!mintingOpen) revert PublicMintClosed();
1987       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1988       
1989       
1990       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1991 
1992       // ERC-20 Specific pre-flight checks
1993       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1994       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1995       IERC20 payableToken = IERC20(_erc20TokenContract);
1996 
1997       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1998       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1999 
2000       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2001       if(!transferComplete) revert ERC20TransferFailed();
2002       
2003       _safeMint(_to, _amount, false);
2004     }
2005 
2006     function openMinting() public onlyTeamOrOwner {
2007         mintingOpen = true;
2008     }
2009 
2010     function stopMinting() public onlyTeamOrOwner {
2011         mintingOpen = false;
2012     }
2013 
2014   
2015 
2016   
2017     /**
2018     * @dev Check if wallet over MAX_WALLET_MINTS
2019     * @param _address address in question to check if minted count exceeds max
2020     */
2021     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2022         if(_amount == 0) revert ValueCannotBeZero();
2023         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2024     }
2025 
2026     /**
2027     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2028     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2029     */
2030     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2031         if(_newWalletMax == 0) revert ValueCannotBeZero();
2032         MAX_WALLET_MINTS = _newWalletMax;
2033     }
2034     
2035 
2036   
2037     /**
2038      * @dev Allows owner to set Max mints per tx
2039      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2040      */
2041      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2042          if(_newMaxMint == 0) revert ValueCannotBeZero();
2043          maxBatchSize = _newMaxMint;
2044      }
2045     
2046 
2047   
2048     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2049         if(isRevealed) revert IsAlreadyUnveiled();
2050         _baseTokenURI = _updatedTokenURI;
2051         isRevealed = true;
2052     }
2053     
2054   
2055   
2056   function contractURI() public pure returns (string memory) {
2057     return "https://metadata.mintplex.xyz/0nzaW90Fbe7trqhJZqXf/contract-metadata";
2058   }
2059   
2060 
2061   function _baseURI() internal view virtual override returns(string memory) {
2062     return _baseTokenURI;
2063   }
2064 
2065   function _baseURIExtension() internal view virtual override returns(string memory) {
2066     return _baseTokenExtension;
2067   }
2068 
2069   function baseTokenURI() public view returns(string memory) {
2070     return _baseTokenURI;
2071   }
2072 
2073   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2074     _baseTokenURI = baseURI;
2075   }
2076 
2077   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2078     _baseTokenExtension = baseExtension;
2079   }
2080 }
2081 
2082 
2083   
2084 // File: contracts/UndefeatedSamuraiContract.sol
2085 //SPDX-License-Identifier: MIT
2086 
2087 pragma solidity ^0.8.0;
2088 
2089 contract UndefeatedSamuraiContract is RamppERC721A {
2090     constructor() RamppERC721A("Undefeated Samurai", "USNFT"){}
2091 }
2092   
2093 //*********************************************************************//
2094 //*********************************************************************//  
2095 //                       Mintplex v3.0.0
2096 //
2097 //         This smart contract was generated by mintplex.xyz.
2098 //            Mintplex allows creators like you to launch 
2099 //             large scale NFT communities without code!
2100 //
2101 //    Mintplex is not responsible for the content of this contract and
2102 //        hopes it is being used in a responsible and kind way.  
2103 //       Mintplex is not associated or affiliated with this project.                                                    
2104 //             Twitter: @MintplexNFT ---- mintplex.xyz
2105 //*********************************************************************//                                                     
2106 //*********************************************************************// 
