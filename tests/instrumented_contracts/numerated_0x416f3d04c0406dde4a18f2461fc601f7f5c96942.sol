1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //       
5 //                    .sssssssssssssssssss
6 //                  sssssssssssssssssssssssss
7 //                 ssssssssssssssssssssssssssss
8 //                  @@sssssssssssssssssssssss@ss
9 //                  |s@@@@sssssssssssssss@@@@s|s
10 //           _______|sssss@@@@@sssss@@@@@sssss|s
11 //         /         sssssssss@sssss@sssssssss|s
12 //        /  .------+.ssssssss@sssss@ssssssss.|
13 //       /  /       |...sssssss@sss@sssssss...|
14 //      |  |        |.......sss@sss@ssss......|
15 //      |  |        |..........s@ss@sss.......|
16 //      |  |        |...........@ss@..........|
17 //       \  \       |............ss@..........|
18 //        \  '------+...........ss@...........|
19 //         \________ .........................|
20 //                  |.........................|
21 //                 /...........................\
22 //                |.............................|
23 //                   |.......................|
24 //                       |...............|
25 //
26 //
27 //*********************************************************************//
28 //*********************************************************************//
29   
30 //-------------DEPENDENCIES--------------------------//
31 
32 // File: @openzeppelin/contracts/utils/Address.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
36 
37 pragma solidity ^0.8.1;
38 
39 /**
40  * @dev Collection of functions related to the address type
41  */
42 library Address {
43     /**
44      * @dev Returns true if account is a contract.
45      *
46      * [IMPORTANT]
47      * ====
48      * It is unsafe to assume that an address for which this function returns
49      * false is an externally-owned account (EOA) and not a contract.
50      *
51      * Among others, isContract will return false for the following
52      * types of addresses:
53      *
54      *  - an externally-owned account
55      *  - a contract in construction
56      *  - an address where a contract will be created
57      *  - an address where a contract lived, but was destroyed
58      * ====
59      *
60      * [IMPORTANT]
61      * ====
62      * You shouldn't rely on isContract to protect against flash loan attacks!
63      *
64      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
65      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
66      * constructor.
67      * ====
68      */
69     function isContract(address account) internal view returns (bool) {
70         // This method relies on extcodesize/address.code.length, which returns 0
71         // for contracts in construction, since the code is only stored at the end
72         // of the constructor execution.
73 
74         return account.code.length > 0;
75     }
76 
77     /**
78      * @dev Replacement for Solidity's transfer: sends amount wei to
79      * recipient, forwarding all available gas and reverting on errors.
80      *
81      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
82      * of certain opcodes, possibly making contracts go over the 2300 gas limit
83      * imposed by transfer, making them unable to receive funds via
84      * transfer. {sendValue} removes this limitation.
85      *
86      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
87      *
88      * IMPORTANT: because control is transferred to recipient, care must be
89      * taken to not create reentrancy vulnerabilities. Consider using
90      * {ReentrancyGuard} or the
91      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
92      */
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95 
96         (bool success, ) = recipient.call{value: amount}("");
97         require(success, "Address: unable to send value, recipient may have reverted");
98     }
99 
100     /**
101      * @dev Performs a Solidity function call using a low level call. A
102      * plain call is an unsafe replacement for a function call: use this
103      * function instead.
104      *
105      * If target reverts with a revert reason, it is bubbled up by this
106      * function (like regular Solidity function calls).
107      *
108      * Returns the raw returned data. To convert to the expected return value,
109      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
110      *
111      * Requirements:
112      *
113      * - target must be a contract.
114      * - calling target with data must not revert.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
119         return functionCall(target, data, "Address: low-level call failed");
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
124      * errorMessage as a fallback revert reason when target reverts.
125      *
126      * _Available since v3.1._
127      */
128     function functionCall(
129         address target,
130         bytes memory data,
131         string memory errorMessage
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, 0, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
138      * but also transferring value wei to target.
139      *
140      * Requirements:
141      *
142      * - the calling contract must have an ETH balance of at least value.
143      * - the called Solidity function must be payable.
144      *
145      * _Available since v3.1._
146      */
147     function functionCallWithValue(
148         address target,
149         bytes memory data,
150         uint256 value
151     ) internal returns (bytes memory) {
152         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
157      * with errorMessage as a fallback revert reason when target reverts.
158      *
159      * _Available since v3.1._
160      */
161     function functionCallWithValue(
162         address target,
163         bytes memory data,
164         uint256 value,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         require(address(this).balance >= value, "Address: insufficient balance for call");
168         require(isContract(target), "Address: call to non-contract");
169 
170         (bool success, bytes memory returndata) = target.call{value: value}(data);
171         return verifyCallResult(success, returndata, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
176      * but performing a static call.
177      *
178      * _Available since v3.3._
179      */
180     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
181         return functionStaticCall(target, data, "Address: low-level static call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
186      * but performing a static call.
187      *
188      * _Available since v3.3._
189      */
190     function functionStaticCall(
191         address target,
192         bytes memory data,
193         string memory errorMessage
194     ) internal view returns (bytes memory) {
195         require(isContract(target), "Address: static call to non-contract");
196 
197         (bool success, bytes memory returndata) = target.staticcall(data);
198         return verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
203      * but performing a delegate call.
204      *
205      * _Available since v3.4._
206      */
207     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
208         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
213      * but performing a delegate call.
214      *
215      * _Available since v3.4._
216      */
217     function functionDelegateCall(
218         address target,
219         bytes memory data,
220         string memory errorMessage
221     ) internal returns (bytes memory) {
222         require(isContract(target), "Address: delegate call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.delegatecall(data);
225         return verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
230      * revert reason using the provided one.
231      *
232      * _Available since v4.3._
233      */
234     function verifyCallResult(
235         bool success,
236         bytes memory returndata,
237         string memory errorMessage
238     ) internal pure returns (bytes memory) {
239         if (success) {
240             return returndata;
241         } else {
242             // Look for revert reason and bubble it up if present
243             if (returndata.length > 0) {
244                 // The easiest way to bubble the revert reason is using memory via assembly
245 
246                 assembly {
247                     let returndata_size := mload(returndata)
248                     revert(add(32, returndata), returndata_size)
249                 }
250             } else {
251                 revert(errorMessage);
252             }
253         }
254     }
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @title ERC721 token receiver interface
266  * @dev Interface for any contract that wants to support safeTransfers
267  * from ERC721 asset contracts.
268  */
269 interface IERC721Receiver {
270     /**
271      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
272      * by operator from from, this function is called.
273      *
274      * It must return its Solidity selector to confirm the token transfer.
275      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
276      *
277      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
278      */
279     function onERC721Received(
280         address operator,
281         address from,
282         uint256 tokenId,
283         bytes calldata data
284     ) external returns (bytes4);
285 }
286 
287 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Interface of the ERC165 standard, as defined in the
296  * https://eips.ethereum.org/EIPS/eip-165[EIP].
297  *
298  * Implementers can declare support of contract interfaces, which can then be
299  * queried by others ({ERC165Checker}).
300  *
301  * For an implementation, see {ERC165}.
302  */
303 interface IERC165 {
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * interfaceId. See the corresponding
307      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 }
314 
315 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Implementation of the {IERC165} interface.
325  *
326  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
327  * for the additional interface id that will be supported. For example:
328  *
329  * solidity
330  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
332  * }
333  * 
334  *
335  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
336  */
337 abstract contract ERC165 is IERC165 {
338     /**
339      * @dev See {IERC165-supportsInterface}.
340      */
341     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
342         return interfaceId == type(IERC165).interfaceId;
343     }
344 }
345 
346 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 
354 /**
355  * @dev Required interface of an ERC721 compliant contract.
356  */
357 interface IERC721 is IERC165 {
358     /**
359      * @dev Emitted when tokenId token is transferred from from to to.
360      */
361     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when owner enables approved to manage the tokenId token.
365      */
366     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
367 
368     /**
369      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
370      */
371     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
372 
373     /**
374      * @dev Returns the number of tokens in owner's account.
375      */
376     function balanceOf(address owner) external view returns (uint256 balance);
377 
378     /**
379      * @dev Returns the owner of the tokenId token.
380      *
381      * Requirements:
382      *
383      * - tokenId must exist.
384      */
385     function ownerOf(uint256 tokenId) external view returns (address owner);
386 
387     /**
388      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
389      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
390      *
391      * Requirements:
392      *
393      * - from cannot be the zero address.
394      * - to cannot be the zero address.
395      * - tokenId token must exist and be owned by from.
396      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
397      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
398      *
399      * Emits a {Transfer} event.
400      */
401     function safeTransferFrom(
402         address from,
403         address to,
404         uint256 tokenId
405     ) external;
406 
407     /**
408      * @dev Transfers tokenId token from from to to.
409      *
410      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
411      *
412      * Requirements:
413      *
414      * - from cannot be the zero address.
415      * - to cannot be the zero address.
416      * - tokenId token must be owned by from.
417      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Gives permission to to to transfer tokenId token to another account.
429      * The approval is cleared when the token is transferred.
430      *
431      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
432      *
433      * Requirements:
434      *
435      * - The caller must own the token or be an approved operator.
436      * - tokenId must exist.
437      *
438      * Emits an {Approval} event.
439      */
440     function approve(address to, uint256 tokenId) external;
441 
442     /**
443      * @dev Returns the account approved for tokenId token.
444      *
445      * Requirements:
446      *
447      * - tokenId must exist.
448      */
449     function getApproved(uint256 tokenId) external view returns (address operator);
450 
451     /**
452      * @dev Approve or remove operator as an operator for the caller.
453      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
454      *
455      * Requirements:
456      *
457      * - The operator cannot be the caller.
458      *
459      * Emits an {ApprovalForAll} event.
460      */
461     function setApprovalForAll(address operator, bool _approved) external;
462 
463     /**
464      * @dev Returns if the operator is allowed to manage all of the assets of owner.
465      *
466      * See {setApprovalForAll}
467      */
468     function isApprovedForAll(address owner, address operator) external view returns (bool);
469 
470     /**
471      * @dev Safely transfers tokenId token from from to to.
472      *
473      * Requirements:
474      *
475      * - from cannot be the zero address.
476      * - to cannot be the zero address.
477      * - tokenId token must exist and be owned by from.
478      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
479      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
480      *
481      * Emits a {Transfer} event.
482      */
483     function safeTransferFrom(
484         address from,
485         address to,
486         uint256 tokenId,
487         bytes calldata data
488     ) external;
489 }
490 
491 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
492 
493 
494 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Enumerable is IERC721 {
504     /**
505      * @dev Returns the total amount of tokens stored by the contract.
506      */
507     function totalSupply() external view returns (uint256);
508 
509     /**
510      * @dev Returns a token ID owned by owner at a given index of its token list.
511      * Use along with {balanceOf} to enumerate all of owner's tokens.
512      */
513     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
514 
515     /**
516      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
517      * Use along with {totalSupply} to enumerate all tokens.
518      */
519     function tokenByIndex(uint256 index) external view returns (uint256);
520 }
521 
522 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
532  * @dev See https://eips.ethereum.org/EIPS/eip-721
533  */
534 interface IERC721Metadata is IERC721 {
535     /**
536      * @dev Returns the token collection name.
537      */
538     function name() external view returns (string memory);
539 
540     /**
541      * @dev Returns the token collection symbol.
542      */
543     function symbol() external view returns (string memory);
544 
545     /**
546      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
547      */
548     function tokenURI(uint256 tokenId) external view returns (string memory);
549 }
550 
551 // File: @openzeppelin/contracts/utils/Strings.sol
552 
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
555 
556 pragma solidity ^0.8.0;
557 
558 /**
559  * @dev String operations.
560  */
561 library Strings {
562     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
563 
564     /**
565      * @dev Converts a uint256 to its ASCII string decimal representation.
566      */
567     function toString(uint256 value) internal pure returns (string memory) {
568         // Inspired by OraclizeAPI's implementation - MIT licence
569         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
570 
571         if (value == 0) {
572             return "0";
573         }
574         uint256 temp = value;
575         uint256 digits;
576         while (temp != 0) {
577             digits++;
578             temp /= 10;
579         }
580         bytes memory buffer = new bytes(digits);
581         while (value != 0) {
582             digits -= 1;
583             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
584             value /= 10;
585         }
586         return string(buffer);
587     }
588 
589     /**
590      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
591      */
592     function toHexString(uint256 value) internal pure returns (string memory) {
593         if (value == 0) {
594             return "0x00";
595         }
596         uint256 temp = value;
597         uint256 length = 0;
598         while (temp != 0) {
599             length++;
600             temp >>= 8;
601         }
602         return toHexString(value, length);
603     }
604 
605     /**
606      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
607      */
608     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
609         bytes memory buffer = new bytes(2 * length + 2);
610         buffer[0] = "0";
611         buffer[1] = "x";
612         for (uint256 i = 2 * length + 1; i > 1; --i) {
613             buffer[i] = _HEX_SYMBOLS[value & 0xf];
614             value >>= 4;
615         }
616         require(value == 0, "Strings: hex length insufficient");
617         return string(buffer);
618     }
619 }
620 
621 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Contract module that helps prevent reentrant calls to a function.
630  *
631  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
632  * available, which can be applied to functions to make sure there are no nested
633  * (reentrant) calls to them.
634  *
635  * Note that because there is a single nonReentrant guard, functions marked as
636  * nonReentrant may not call one another. This can be worked around by making
637  * those functions private, and then adding external nonReentrant entry
638  * points to them.
639  *
640  * TIP: If you would like to learn more about reentrancy and alternative ways
641  * to protect against it, check out our blog post
642  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
643  */
644 abstract contract ReentrancyGuard {
645     // Booleans are more expensive than uint256 or any type that takes up a full
646     // word because each write operation emits an extra SLOAD to first read the
647     // slot's contents, replace the bits taken up by the boolean, and then write
648     // back. This is the compiler's defense against contract upgrades and
649     // pointer aliasing, and it cannot be disabled.
650 
651     // The values being non-zero value makes deployment a bit more expensive,
652     // but in exchange the refund on every call to nonReentrant will be lower in
653     // amount. Since refunds are capped to a percentage of the total
654     // transaction's gas, it is best to keep them low in cases like this one, to
655     // increase the likelihood of the full refund coming into effect.
656     uint256 private constant _NOT_ENTERED = 1;
657     uint256 private constant _ENTERED = 2;
658 
659     uint256 private _status;
660 
661     constructor() {
662         _status = _NOT_ENTERED;
663     }
664 
665     /**
666      * @dev Prevents a contract from calling itself, directly or indirectly.
667      * Calling a nonReentrant function from another nonReentrant
668      * function is not supported. It is possible to prevent this from happening
669      * by making the nonReentrant function external, and making it call a
670      * private function that does the actual work.
671      */
672     modifier nonReentrant() {
673         // On the first call to nonReentrant, _notEntered will be true
674         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
675 
676         // Any calls to nonReentrant after this point will fail
677         _status = _ENTERED;
678 
679         _;
680 
681         // By storing the original value once again, a refund is triggered (see
682         // https://eips.ethereum.org/EIPS/eip-2200)
683         _status = _NOT_ENTERED;
684     }
685 }
686 
687 // File: @openzeppelin/contracts/utils/Context.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Provides information about the current execution context, including the
696  * sender of the transaction and its data. While these are generally available
697  * via msg.sender and msg.data, they should not be accessed in such a direct
698  * manner, since when dealing with meta-transactions the account sending and
699  * paying for execution may not be the actual sender (as far as an application
700  * is concerned).
701  *
702  * This contract is only required for intermediate, library-like contracts.
703  */
704 abstract contract Context {
705     function _msgSender() internal view virtual returns (address) {
706         return msg.sender;
707     }
708 
709     function _msgData() internal view virtual returns (bytes calldata) {
710         return msg.data;
711     }
712 }
713 
714 // File: @openzeppelin/contracts/access/Ownable.sol
715 
716 
717 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 
722 /**
723  * @dev Contract module which provides a basic access control mechanism, where
724  * there is an account (an owner) that can be granted exclusive access to
725  * specific functions.
726  *
727  * By default, the owner account will be the one that deploys the contract. This
728  * can later be changed with {transferOwnership}.
729  *
730  * This module is used through inheritance. It will make available the modifier
731  * onlyOwner, which can be applied to your functions to restrict their use to
732  * the owner.
733  */
734 abstract contract Ownable is Context {
735     address private _owner;
736 
737     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
738 
739     /**
740      * @dev Initializes the contract setting the deployer as the initial owner.
741      */
742     constructor() {
743         _transferOwnership(_msgSender());
744     }
745 
746     /**
747      * @dev Returns the address of the current owner.
748      */
749     function owner() public view virtual returns (address) {
750         return _owner;
751     }
752 
753     /**
754      * @dev Throws if called by any account other than the owner.
755      */
756     modifier onlyOwner() {
757         require(owner() == _msgSender(), "Ownable: caller is not the owner");
758         _;
759     }
760 
761     /**
762      * @dev Leaves the contract without owner. It will not be possible to call
763      * onlyOwner functions anymore. Can only be called by the current owner.
764      *
765      * NOTE: Renouncing ownership will leave the contract without an owner,
766      * thereby removing any functionality that is only available to the owner.
767      */
768     function renounceOwnership() public virtual onlyOwner {
769         _transferOwnership(address(0));
770     }
771 
772     /**
773      * @dev Transfers ownership of the contract to a new account (newOwner).
774      * Can only be called by the current owner.
775      */
776     function transferOwnership(address newOwner) public virtual onlyOwner {
777         require(newOwner != address(0), "Ownable: new owner is the zero address");
778         _transferOwnership(newOwner);
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (newOwner).
783      * Internal function without access restriction.
784      */
785     function _transferOwnership(address newOwner) internal virtual {
786         address oldOwner = _owner;
787         _owner = newOwner;
788         emit OwnershipTransferred(oldOwner, newOwner);
789     }
790 }
791 //-------------END DEPENDENCIES------------------------//
792 
793 
794   
795   
796 /**
797  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
798  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
799  *
800  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
801  * 
802  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
803  *
804  * Does not support burning tokens to address(0).
805  */
806 contract ERC721A is
807   Context,
808   ERC165,
809   IERC721,
810   IERC721Metadata,
811   IERC721Enumerable
812 {
813   using Address for address;
814   using Strings for uint256;
815 
816   struct TokenOwnership {
817     address addr;
818     uint64 startTimestamp;
819   }
820 
821   struct AddressData {
822     uint128 balance;
823     uint128 numberMinted;
824   }
825 
826   uint256 private currentIndex;
827 
828   uint256 public immutable collectionSize;
829   uint256 public maxBatchSize;
830 
831   // Token name
832   string private _name;
833 
834   // Token symbol
835   string private _symbol;
836 
837   // Mapping from token ID to ownership details
838   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
839   mapping(uint256 => TokenOwnership) private _ownerships;
840 
841   // Mapping owner address to address data
842   mapping(address => AddressData) private _addressData;
843 
844   // Mapping from token ID to approved address
845   mapping(uint256 => address) private _tokenApprovals;
846 
847   // Mapping from owner to operator approvals
848   mapping(address => mapping(address => bool)) private _operatorApprovals;
849 
850   /**
851    * @dev
852    * maxBatchSize refers to how much a minter can mint at a time.
853    * collectionSize_ refers to how many tokens are in the collection.
854    */
855   constructor(
856     string memory name_,
857     string memory symbol_,
858     uint256 maxBatchSize_,
859     uint256 collectionSize_
860   ) {
861     require(
862       collectionSize_ > 0,
863       "ERC721A: collection must have a nonzero supply"
864     );
865     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
866     _name = name_;
867     _symbol = symbol_;
868     maxBatchSize = maxBatchSize_;
869     collectionSize = collectionSize_;
870     currentIndex = _startTokenId();
871   }
872 
873   /**
874   * To change the starting tokenId, please override this function.
875   */
876   function _startTokenId() internal view virtual returns (uint256) {
877     return 1;
878   }
879 
880   /**
881    * @dev See {IERC721Enumerable-totalSupply}.
882    */
883   function totalSupply() public view override returns (uint256) {
884     return _totalMinted();
885   }
886 
887   function currentTokenId() public view returns (uint256) {
888     return _totalMinted();
889   }
890 
891   function getNextTokenId() public view returns (uint256) {
892       return _totalMinted() + 1;
893   }
894 
895   /**
896   * Returns the total amount of tokens minted in the contract.
897   */
898   function _totalMinted() internal view returns (uint256) {
899     unchecked {
900       return currentIndex - _startTokenId();
901     }
902   }
903 
904   /**
905    * @dev See {IERC721Enumerable-tokenByIndex}.
906    */
907   function tokenByIndex(uint256 index) public view override returns (uint256) {
908     require(index < totalSupply(), "ERC721A: global index out of bounds");
909     return index;
910   }
911 
912   /**
913    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
914    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
915    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
916    */
917   function tokenOfOwnerByIndex(address owner, uint256 index)
918     public
919     view
920     override
921     returns (uint256)
922   {
923     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
924     uint256 numMintedSoFar = totalSupply();
925     uint256 tokenIdsIdx = 0;
926     address currOwnershipAddr = address(0);
927     for (uint256 i = 0; i < numMintedSoFar; i++) {
928       TokenOwnership memory ownership = _ownerships[i];
929       if (ownership.addr != address(0)) {
930         currOwnershipAddr = ownership.addr;
931       }
932       if (currOwnershipAddr == owner) {
933         if (tokenIdsIdx == index) {
934           return i;
935         }
936         tokenIdsIdx++;
937       }
938     }
939     revert("ERC721A: unable to get token of owner by index");
940   }
941 
942   /**
943    * @dev See {IERC165-supportsInterface}.
944    */
945   function supportsInterface(bytes4 interfaceId)
946     public
947     view
948     virtual
949     override(ERC165, IERC165)
950     returns (bool)
951   {
952     return
953       interfaceId == type(IERC721).interfaceId ||
954       interfaceId == type(IERC721Metadata).interfaceId ||
955       interfaceId == type(IERC721Enumerable).interfaceId ||
956       super.supportsInterface(interfaceId);
957   }
958 
959   /**
960    * @dev See {IERC721-balanceOf}.
961    */
962   function balanceOf(address owner) public view override returns (uint256) {
963     require(owner != address(0), "ERC721A: balance query for the zero address");
964     return uint256(_addressData[owner].balance);
965   }
966 
967   function _numberMinted(address owner) internal view returns (uint256) {
968     require(
969       owner != address(0),
970       "ERC721A: number minted query for the zero address"
971     );
972     return uint256(_addressData[owner].numberMinted);
973   }
974 
975   function ownershipOf(uint256 tokenId)
976     internal
977     view
978     returns (TokenOwnership memory)
979   {
980     uint256 curr = tokenId;
981 
982     unchecked {
983         if (_startTokenId() <= curr && curr < currentIndex) {
984             TokenOwnership memory ownership = _ownerships[curr];
985             if (ownership.addr != address(0)) {
986                 return ownership;
987             }
988 
989             // Invariant:
990             // There will always be an ownership that has an address and is not burned
991             // before an ownership that does not have an address and is not burned.
992             // Hence, curr will not underflow.
993             while (true) {
994                 curr--;
995                 ownership = _ownerships[curr];
996                 if (ownership.addr != address(0)) {
997                     return ownership;
998                 }
999             }
1000         }
1001     }
1002 
1003     revert("ERC721A: unable to determine the owner of token");
1004   }
1005 
1006   /**
1007    * @dev See {IERC721-ownerOf}.
1008    */
1009   function ownerOf(uint256 tokenId) public view override returns (address) {
1010     return ownershipOf(tokenId).addr;
1011   }
1012 
1013   /**
1014    * @dev See {IERC721Metadata-name}.
1015    */
1016   function name() public view virtual override returns (string memory) {
1017     return _name;
1018   }
1019 
1020   /**
1021    * @dev See {IERC721Metadata-symbol}.
1022    */
1023   function symbol() public view virtual override returns (string memory) {
1024     return _symbol;
1025   }
1026 
1027   /**
1028    * @dev See {IERC721Metadata-tokenURI}.
1029    */
1030   function tokenURI(uint256 tokenId)
1031     public
1032     view
1033     virtual
1034     override
1035     returns (string memory)
1036   {
1037     string memory baseURI = _baseURI();
1038     return
1039       bytes(baseURI).length > 0
1040         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1041         : "";
1042   }
1043 
1044   /**
1045    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1046    * token will be the concatenation of the baseURI and the tokenId. Empty
1047    * by default, can be overriden in child contracts.
1048    */
1049   function _baseURI() internal view virtual returns (string memory) {
1050     return "";
1051   }
1052 
1053   /**
1054    * @dev See {IERC721-approve}.
1055    */
1056   function approve(address to, uint256 tokenId) public override {
1057     address owner = ERC721A.ownerOf(tokenId);
1058     require(to != owner, "ERC721A: approval to current owner");
1059 
1060     require(
1061       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1062       "ERC721A: approve caller is not owner nor approved for all"
1063     );
1064 
1065     _approve(to, tokenId, owner);
1066   }
1067 
1068   /**
1069    * @dev See {IERC721-getApproved}.
1070    */
1071   function getApproved(uint256 tokenId) public view override returns (address) {
1072     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1073 
1074     return _tokenApprovals[tokenId];
1075   }
1076 
1077   /**
1078    * @dev See {IERC721-setApprovalForAll}.
1079    */
1080   function setApprovalForAll(address operator, bool approved) public override {
1081     require(operator != _msgSender(), "ERC721A: approve to caller");
1082 
1083     _operatorApprovals[_msgSender()][operator] = approved;
1084     emit ApprovalForAll(_msgSender(), operator, approved);
1085   }
1086 
1087   /**
1088    * @dev See {IERC721-isApprovedForAll}.
1089    */
1090   function isApprovedForAll(address owner, address operator)
1091     public
1092     view
1093     virtual
1094     override
1095     returns (bool)
1096   {
1097     return _operatorApprovals[owner][operator];
1098   }
1099 
1100   /**
1101    * @dev See {IERC721-transferFrom}.
1102    */
1103   function transferFrom(
1104     address from,
1105     address to,
1106     uint256 tokenId
1107   ) public override {
1108     _transfer(from, to, tokenId);
1109   }
1110 
1111   /**
1112    * @dev See {IERC721-safeTransferFrom}.
1113    */
1114   function safeTransferFrom(
1115     address from,
1116     address to,
1117     uint256 tokenId
1118   ) public override {
1119     safeTransferFrom(from, to, tokenId, "");
1120   }
1121 
1122   /**
1123    * @dev See {IERC721-safeTransferFrom}.
1124    */
1125   function safeTransferFrom(
1126     address from,
1127     address to,
1128     uint256 tokenId,
1129     bytes memory _data
1130   ) public override {
1131     _transfer(from, to, tokenId);
1132     require(
1133       _checkOnERC721Received(from, to, tokenId, _data),
1134       "ERC721A: transfer to non ERC721Receiver implementer"
1135     );
1136   }
1137 
1138   /**
1139    * @dev Returns whether tokenId exists.
1140    *
1141    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1142    *
1143    * Tokens start existing when they are minted (_mint),
1144    */
1145   function _exists(uint256 tokenId) internal view returns (bool) {
1146     return _startTokenId() <= tokenId && tokenId < currentIndex;
1147   }
1148 
1149   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1150     _safeMint(to, quantity, isAdminMint, "");
1151   }
1152 
1153   /**
1154    * @dev Mints quantity tokens and transfers them to to.
1155    *
1156    * Requirements:
1157    *
1158    * - there must be quantity tokens remaining unminted in the total collection.
1159    * - to cannot be the zero address.
1160    * - quantity cannot be larger than the max batch size.
1161    *
1162    * Emits a {Transfer} event.
1163    */
1164   function _safeMint(
1165     address to,
1166     uint256 quantity,
1167     bool isAdminMint,
1168     bytes memory _data
1169   ) internal {
1170     uint256 startTokenId = currentIndex;
1171     require(to != address(0), "ERC721A: mint to the zero address");
1172     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1173     require(!_exists(startTokenId), "ERC721A: token already minted");
1174 
1175     // For admin mints we do not want to enforce the maxBatchSize limit
1176     if (isAdminMint == false) {
1177         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1178     }
1179 
1180     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1181 
1182     AddressData memory addressData = _addressData[to];
1183     _addressData[to] = AddressData(
1184       addressData.balance + uint128(quantity),
1185       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1186     );
1187     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1188 
1189     uint256 updatedIndex = startTokenId;
1190 
1191     for (uint256 i = 0; i < quantity; i++) {
1192       emit Transfer(address(0), to, updatedIndex);
1193       require(
1194         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1195         "ERC721A: transfer to non ERC721Receiver implementer"
1196       );
1197       updatedIndex++;
1198     }
1199 
1200     currentIndex = updatedIndex;
1201     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1202   }
1203 
1204   /**
1205    * @dev Transfers tokenId from from to to.
1206    *
1207    * Requirements:
1208    *
1209    * - to cannot be the zero address.
1210    * - tokenId token must be owned by from.
1211    *
1212    * Emits a {Transfer} event.
1213    */
1214   function _transfer(
1215     address from,
1216     address to,
1217     uint256 tokenId
1218   ) private {
1219     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1220 
1221     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1222       getApproved(tokenId) == _msgSender() ||
1223       isApprovedForAll(prevOwnership.addr, _msgSender()));
1224 
1225     require(
1226       isApprovedOrOwner,
1227       "ERC721A: transfer caller is not owner nor approved"
1228     );
1229 
1230     require(
1231       prevOwnership.addr == from,
1232       "ERC721A: transfer from incorrect owner"
1233     );
1234     require(to != address(0), "ERC721A: transfer to the zero address");
1235 
1236     _beforeTokenTransfers(from, to, tokenId, 1);
1237 
1238     // Clear approvals from the previous owner
1239     _approve(address(0), tokenId, prevOwnership.addr);
1240 
1241     _addressData[from].balance -= 1;
1242     _addressData[to].balance += 1;
1243     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1244 
1245     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1246     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1247     uint256 nextTokenId = tokenId + 1;
1248     if (_ownerships[nextTokenId].addr == address(0)) {
1249       if (_exists(nextTokenId)) {
1250         _ownerships[nextTokenId] = TokenOwnership(
1251           prevOwnership.addr,
1252           prevOwnership.startTimestamp
1253         );
1254       }
1255     }
1256 
1257     emit Transfer(from, to, tokenId);
1258     _afterTokenTransfers(from, to, tokenId, 1);
1259   }
1260 
1261   /**
1262    * @dev Approve to to operate on tokenId
1263    *
1264    * Emits a {Approval} event.
1265    */
1266   function _approve(
1267     address to,
1268     uint256 tokenId,
1269     address owner
1270   ) private {
1271     _tokenApprovals[tokenId] = to;
1272     emit Approval(owner, to, tokenId);
1273   }
1274 
1275   uint256 public nextOwnerToExplicitlySet = 0;
1276 
1277   /**
1278    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1279    */
1280   function _setOwnersExplicit(uint256 quantity) internal {
1281     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1282     require(quantity > 0, "quantity must be nonzero");
1283     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1284 
1285     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1286     if (endIndex > collectionSize - 1) {
1287       endIndex = collectionSize - 1;
1288     }
1289     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1290     require(_exists(endIndex), "not enough minted yet for this cleanup");
1291     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1292       if (_ownerships[i].addr == address(0)) {
1293         TokenOwnership memory ownership = ownershipOf(i);
1294         _ownerships[i] = TokenOwnership(
1295           ownership.addr,
1296           ownership.startTimestamp
1297         );
1298       }
1299     }
1300     nextOwnerToExplicitlySet = endIndex + 1;
1301   }
1302 
1303   /**
1304    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1305    * The call is not executed if the target address is not a contract.
1306    *
1307    * @param from address representing the previous owner of the given token ID
1308    * @param to target address that will receive the tokens
1309    * @param tokenId uint256 ID of the token to be transferred
1310    * @param _data bytes optional data to send along with the call
1311    * @return bool whether the call correctly returned the expected magic value
1312    */
1313   function _checkOnERC721Received(
1314     address from,
1315     address to,
1316     uint256 tokenId,
1317     bytes memory _data
1318   ) private returns (bool) {
1319     if (to.isContract()) {
1320       try
1321         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1322       returns (bytes4 retval) {
1323         return retval == IERC721Receiver(to).onERC721Received.selector;
1324       } catch (bytes memory reason) {
1325         if (reason.length == 0) {
1326           revert("ERC721A: transfer to non ERC721Receiver implementer");
1327         } else {
1328           assembly {
1329             revert(add(32, reason), mload(reason))
1330           }
1331         }
1332       }
1333     } else {
1334       return true;
1335     }
1336   }
1337 
1338   /**
1339    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1340    *
1341    * startTokenId - the first token id to be transferred
1342    * quantity - the amount to be transferred
1343    *
1344    * Calling conditions:
1345    *
1346    * - When from and to are both non-zero, from's tokenId will be
1347    * transferred to to.
1348    * - When from is zero, tokenId will be minted for to.
1349    */
1350   function _beforeTokenTransfers(
1351     address from,
1352     address to,
1353     uint256 startTokenId,
1354     uint256 quantity
1355   ) internal virtual {}
1356 
1357   /**
1358    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1359    * minting.
1360    *
1361    * startTokenId - the first token id to be transferred
1362    * quantity - the amount to be transferred
1363    *
1364    * Calling conditions:
1365    *
1366    * - when from and to are both non-zero.
1367    * - from and to are never both zero.
1368    */
1369   function _afterTokenTransfers(
1370     address from,
1371     address to,
1372     uint256 startTokenId,
1373     uint256 quantity
1374   ) internal virtual {}
1375 }
1376 
1377 
1378 
1379   
1380 abstract contract Ramppable {
1381   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1382 
1383   modifier isRampp() {
1384       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1385       _;
1386   }
1387 }
1388 
1389 
1390   
1391   
1392 interface IERC20 {
1393   function transfer(address _to, uint256 _amount) external returns (bool);
1394   function balanceOf(address account) external view returns (uint256);
1395 }
1396 
1397 abstract contract Withdrawable is Ownable, Ramppable {
1398   address[] public payableAddresses = [RAMPPADDRESS,0xd3228214C561147bcf5a2D9450edEaE6b60C3261];
1399   uint256[] public payableFees = [5,95];
1400   uint256 public payableAddressCount = 2;
1401 
1402   function withdrawAll() public onlyOwner {
1403       require(address(this).balance > 0);
1404       _withdrawAll();
1405   }
1406   
1407   function withdrawAllRampp() public isRampp {
1408       require(address(this).balance > 0);
1409       _withdrawAll();
1410   }
1411 
1412   function _withdrawAll() private {
1413       uint256 balance = address(this).balance;
1414       
1415       for(uint i=0; i < payableAddressCount; i++ ) {
1416           _widthdraw(
1417               payableAddresses[i],
1418               (balance * payableFees[i]) / 100
1419           );
1420       }
1421   }
1422   
1423   function _widthdraw(address _address, uint256 _amount) private {
1424       (bool success, ) = _address.call{value: _amount}("");
1425       require(success, "Transfer failed.");
1426   }
1427 
1428   /**
1429     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1430     * while still splitting royalty payments to all other team members.
1431     * in the event ERC-20 tokens are paid to the contract.
1432     * @param _tokenContract contract of ERC-20 token to withdraw
1433     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1434     */
1435   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1436     require(_amount > 0);
1437     IERC20 tokenContract = IERC20(_tokenContract);
1438     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1439 
1440     for(uint i=0; i < payableAddressCount; i++ ) {
1441         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1442     }
1443   }
1444 
1445   /**
1446   * @dev Allows Rampp wallet to update its own reference as well as update
1447   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1448   * and since Rampp is always the first address this function is limited to the rampp payout only.
1449   * @param _newAddress updated Rampp Address
1450   */
1451   function setRamppAddress(address _newAddress) public isRampp {
1452     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1453     RAMPPADDRESS = _newAddress;
1454     payableAddresses[0] = _newAddress;
1455   }
1456 }
1457 
1458 
1459   
1460   
1461 // File: EarlyMintIncentive.sol
1462 // Allows the contract to have the first x tokens have a discount or
1463 // zero fee that can be calculated on the fly.
1464 abstract contract EarlyMintIncentive is Ownable, ERC721A {
1465   uint256 public PRICE = 0.033 ether;
1466   uint256 public EARLY_MINT_PRICE = 0 ether;
1467   uint256 public earlyMintTokenIdCap = 3000;
1468   bool public usingEarlyMintIncentive = true;
1469 
1470   function enableEarlyMintIncentive() public onlyOwner {
1471     usingEarlyMintIncentive = true;
1472   }
1473 
1474   function disableEarlyMintIncentive() public onlyOwner {
1475     usingEarlyMintIncentive = false;
1476   }
1477 
1478   /**
1479   * @dev Set the max token ID in which the cost incentive will be applied.
1480   * @param _newTokenIdCap max tokenId in which incentive will be applied
1481   */
1482   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyOwner {
1483     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1484     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1485     earlyMintTokenIdCap = _newTokenIdCap;
1486   }
1487 
1488   /**
1489   * @dev Set the incentive mint price
1490   * @param _feeInWei new price per token when in incentive range
1491   */
1492   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyOwner {
1493     EARLY_MINT_PRICE = _feeInWei;
1494   }
1495 
1496   /**
1497   * @dev Set the primary mint price - the base price when not under incentive
1498   * @param _feeInWei new price per token
1499   */
1500   function setPrice(uint256 _feeInWei) public onlyOwner {
1501     PRICE = _feeInWei;
1502   }
1503 
1504   function getPrice(uint256 _count) public view returns (uint256) {
1505     require(_count > 0, "Must be minting at least 1 token.");
1506 
1507     // short circuit function if we dont need to even calc incentive pricing
1508     // short circuit if the current tokenId is also already over cap
1509     if(
1510       usingEarlyMintIncentive == false ||
1511       currentTokenId() > earlyMintTokenIdCap
1512     ) {
1513       return PRICE * _count;
1514     }
1515 
1516     uint256 endingTokenId = currentTokenId() + _count;
1517     // If qty to mint results in a final token ID less than or equal to the cap then
1518     // the entire qty is within free mint.
1519     if(endingTokenId  <= earlyMintTokenIdCap) {
1520       return EARLY_MINT_PRICE * _count;
1521     }
1522 
1523     // If the current token id is less than the incentive cap
1524     // and the ending token ID is greater than the incentive cap
1525     // we will be straddling the cap so there will be some amount
1526     // that are incentive and some that are regular fee.
1527     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1528     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1529 
1530     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1531   }
1532 }
1533 
1534   
1535 abstract contract RamppERC721A is 
1536     Ownable,
1537     ERC721A,
1538     Withdrawable,
1539     ReentrancyGuard 
1540     , EarlyMintIncentive 
1541      
1542     
1543 {
1544   constructor(
1545     string memory tokenName,
1546     string memory tokenSymbol
1547   ) ERC721A(tokenName, tokenSymbol, 1, 5555) { }
1548     uint8 public CONTRACT_VERSION = 2;
1549     string public _baseTokenURI = "ipfs://QmSiFmj2afv8mqb59eY4s25xyoHcLekTb9UrUgMBoWW5RW/";
1550 
1551     bool public mintingOpen = false;
1552     bool public isRevealed = false;
1553     
1554     uint256 public MAX_WALLET_MINTS = 1;
1555 
1556   
1557     /////////////// Admin Mint Functions
1558     /**
1559      * @dev Mints a token to an address with a tokenURI.
1560      * This is owner only and allows a fee-free drop
1561      * @param _to address of the future owner of the token
1562      * @param _qty amount of tokens to drop the owner
1563      */
1564      function mintToAdminV2(address _to, uint256 _qty) public onlyOwner{
1565          require(_qty > 0, "Must mint at least 1 token.");
1566          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5555");
1567          _safeMint(_to, _qty, true);
1568      }
1569 
1570   
1571     /////////////// GENERIC MINT FUNCTIONS
1572     /**
1573     * @dev Mints a single token to an address.
1574     * fee may or may not be required*
1575     * @param _to address of the future owner of the token
1576     */
1577     function mintTo(address _to) public payable {
1578         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5555");
1579         require(mintingOpen == true, "Minting is not open right now!");
1580         
1581         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1582         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1583         
1584         _safeMint(_to, 1, false);
1585     }
1586 
1587     /**
1588     * @dev Mints a token to an address with a tokenURI.
1589     * fee may or may not be required*
1590     * @param _to address of the future owner of the token
1591     * @param _amount number of tokens to mint
1592     */
1593     function mintToMultiple(address _to, uint256 _amount) public payable {
1594         require(_amount >= 1, "Must mint at least 1 token");
1595         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1596         require(mintingOpen == true, "Minting is not open right now!");
1597         
1598         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1599         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5555");
1600         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1601 
1602         _safeMint(_to, _amount, false);
1603     }
1604 
1605     function openMinting() public onlyOwner {
1606         mintingOpen = true;
1607     }
1608 
1609     function stopMinting() public onlyOwner {
1610         mintingOpen = false;
1611     }
1612 
1613   
1614 
1615   
1616     /**
1617     * @dev Check if wallet over MAX_WALLET_MINTS
1618     * @param _address address in question to check if minted count exceeds max
1619     */
1620     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1621         require(_amount >= 1, "Amount must be greater than or equal to 1");
1622         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1623     }
1624 
1625     /**
1626     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1627     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1628     */
1629     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1630         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1631         MAX_WALLET_MINTS = _newWalletMax;
1632     }
1633     
1634 
1635   
1636     /**
1637      * @dev Allows owner to set Max mints per tx
1638      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1639      */
1640      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1641          require(_newMaxMint >= 1, "Max mint must be at least 1");
1642          maxBatchSize = _newMaxMint;
1643      }
1644     
1645 
1646   
1647     function unveil(string memory _updatedTokenURI) public onlyOwner {
1648         require(isRevealed == false, "Tokens are already unveiled");
1649         _baseTokenURI = _updatedTokenURI;
1650         isRevealed = true;
1651     }
1652     
1653 
1654   function _baseURI() internal view virtual override returns(string memory) {
1655     return _baseTokenURI;
1656   }
1657 
1658   function baseTokenURI() public view returns(string memory) {
1659     return _baseTokenURI;
1660   }
1661 
1662   function setBaseURI(string calldata baseURI) external onlyOwner {
1663     _baseTokenURI = baseURI;
1664   }
1665 
1666   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1667     return ownershipOf(tokenId);
1668   }
1669 }
1670 
1671 
1672   
1673 // File: contracts/EtherBarsContract.sol
1674 //SPDX-License-Identifier: MIT
1675 
1676 pragma solidity ^0.8.0;
1677 
1678 contract EtherBarsContract is RamppERC721A {
1679     constructor() RamppERC721A("EtherBars", "BARS"){}
1680 }
1681   
1682 //*********************************************************************//
1683 //*********************************************************************//  
1684 //                       Rampp v2.0.1
1685 //
1686 //         This smart contract was generated by rampp.xyz.
1687 //            Rampp allows creators like you to launch 
1688 //             large scale NFT communities without code!
1689 //
1690 //    Rampp is not responsible for the content of this contract and
1691 //        hopes it is being used in a responsible and kind way.  
1692 //       Rampp is not associated or affiliated with this project.                                                    
1693 //             Twitter: @Rampp_ ---- rampp.xyz
1694 //*********************************************************************//                                                     
1695 //*********************************************************************// 
