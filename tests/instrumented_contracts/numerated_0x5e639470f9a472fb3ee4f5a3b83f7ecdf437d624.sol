1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //     __ __            __         ____               
6 //    / //_/___  ____ _/ /___ _   / __ \____ ___  __  
7 //   / ,< / __ \/ __ `/ / __ `/  / / / / __ `/ / / /  
8 //  / /| / /_/ / /_/ / / /_/ /  / /_/ / /_/ / /_/ /   
9 // /_/ |_\____/\__,_/_/\__,_/  /_____/\__,_/\__, /    
10 //    / __ )__  __                         /____/     
11 //   / __  / / / /                                    
12 //  / /_/ / /_/ /                                     
13 // /_____/\__, /                                      
14 //    ___/____/  __  __                               
15 //   / __ \_  __/ / / /___ __________ ___  ____  ____ 
16 //  / / / / |/_/ /_/ / __ `/ ___/ __ `__ \/ __ \/ __ \
17 // / /_/ />  </ __  / /_/ / /  / / / / / / /_/ / / / /
18 // \____/_/|_/_/ /_/\__,_/_/  /_/ /_/ /_/\____/_/ /_/ 
19 //                                                    
20 //
21 //
22 //*********************************************************************//
23 //*********************************************************************//
24   
25 //-------------DEPENDENCIES--------------------------//
26 
27 // File: @openzeppelin/contracts/utils/Address.sol
28 
29 
30 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
31 
32 pragma solidity ^0.8.1;
33 
34 /**
35  * @dev Collection of functions related to the address type
36  */
37 library Address {
38     /**
39      * @dev Returns true if account is a contract.
40      *
41      * [IMPORTANT]
42      * ====
43      * It is unsafe to assume that an address for which this function returns
44      * false is an externally-owned account (EOA) and not a contract.
45      *
46      * Among others, isContract will return false for the following
47      * types of addresses:
48      *
49      *  - an externally-owned account
50      *  - a contract in construction
51      *  - an address where a contract will be created
52      *  - an address where a contract lived, but was destroyed
53      * ====
54      *
55      * [IMPORTANT]
56      * ====
57      * You shouldn't rely on isContract to protect against flash loan attacks!
58      *
59      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
60      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
61      * constructor.
62      * ====
63      */
64     function isContract(address account) internal view returns (bool) {
65         // This method relies on extcodesize/address.code.length, which returns 0
66         // for contracts in construction, since the code is only stored at the end
67         // of the constructor execution.
68 
69         return account.code.length > 0;
70     }
71 
72     /**
73      * @dev Replacement for Solidity's transfer: sends amount wei to
74      * recipient, forwarding all available gas and reverting on errors.
75      *
76      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
77      * of certain opcodes, possibly making contracts go over the 2300 gas limit
78      * imposed by transfer, making them unable to receive funds via
79      * transfer. {sendValue} removes this limitation.
80      *
81      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
82      *
83      * IMPORTANT: because control is transferred to recipient, care must be
84      * taken to not create reentrancy vulnerabilities. Consider using
85      * {ReentrancyGuard} or the
86      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
87      */
88     function sendValue(address payable recipient, uint256 amount) internal {
89         require(address(this).balance >= amount, "Address: insufficient balance");
90 
91         (bool success, ) = recipient.call{value: amount}("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 
95     /**
96      * @dev Performs a Solidity function call using a low level call. A
97      * plain call is an unsafe replacement for a function call: use this
98      * function instead.
99      *
100      * If target reverts with a revert reason, it is bubbled up by this
101      * function (like regular Solidity function calls).
102      *
103      * Returns the raw returned data. To convert to the expected return value,
104      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
105      *
106      * Requirements:
107      *
108      * - target must be a contract.
109      * - calling target with data must not revert.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
114         return functionCall(target, data, "Address: low-level call failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
119      * errorMessage as a fallback revert reason when target reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCall(
124         address target,
125         bytes memory data,
126         string memory errorMessage
127     ) internal returns (bytes memory) {
128         return functionCallWithValue(target, data, 0, errorMessage);
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
133      * but also transferring value wei to target.
134      *
135      * Requirements:
136      *
137      * - the calling contract must have an ETH balance of at least value.
138      * - the called Solidity function must be payable.
139      *
140      * _Available since v3.1._
141      */
142     function functionCallWithValue(
143         address target,
144         bytes memory data,
145         uint256 value
146     ) internal returns (bytes memory) {
147         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
152      * with errorMessage as a fallback revert reason when target reverts.
153      *
154      * _Available since v3.1._
155      */
156     function functionCallWithValue(
157         address target,
158         bytes memory data,
159         uint256 value,
160         string memory errorMessage
161     ) internal returns (bytes memory) {
162         require(address(this).balance >= value, "Address: insufficient balance for call");
163         require(isContract(target), "Address: call to non-contract");
164 
165         (bool success, bytes memory returndata) = target.call{value: value}(data);
166         return verifyCallResult(success, returndata, errorMessage);
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
171      * but performing a static call.
172      *
173      * _Available since v3.3._
174      */
175     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
176         return functionStaticCall(target, data, "Address: low-level static call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
181      * but performing a static call.
182      *
183      * _Available since v3.3._
184      */
185     function functionStaticCall(
186         address target,
187         bytes memory data,
188         string memory errorMessage
189     ) internal view returns (bytes memory) {
190         require(isContract(target), "Address: static call to non-contract");
191 
192         (bool success, bytes memory returndata) = target.staticcall(data);
193         return verifyCallResult(success, returndata, errorMessage);
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
198      * but performing a delegate call.
199      *
200      * _Available since v3.4._
201      */
202     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
203         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
208      * but performing a delegate call.
209      *
210      * _Available since v3.4._
211      */
212     function functionDelegateCall(
213         address target,
214         bytes memory data,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(isContract(target), "Address: delegate call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.delegatecall(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
225      * revert reason using the provided one.
226      *
227      * _Available since v4.3._
228      */
229     function verifyCallResult(
230         bool success,
231         bytes memory returndata,
232         string memory errorMessage
233     ) internal pure returns (bytes memory) {
234         if (success) {
235             return returndata;
236         } else {
237             // Look for revert reason and bubble it up if present
238             if (returndata.length > 0) {
239                 // The easiest way to bubble the revert reason is using memory via assembly
240 
241                 assembly {
242                     let returndata_size := mload(returndata)
243                     revert(add(32, returndata), returndata_size)
244                 }
245             } else {
246                 revert(errorMessage);
247             }
248         }
249     }
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
253 
254 
255 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @title ERC721 token receiver interface
261  * @dev Interface for any contract that wants to support safeTransfers
262  * from ERC721 asset contracts.
263  */
264 interface IERC721Receiver {
265     /**
266      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
267      * by operator from from, this function is called.
268      *
269      * It must return its Solidity selector to confirm the token transfer.
270      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
271      *
272      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
273      */
274     function onERC721Received(
275         address operator,
276         address from,
277         uint256 tokenId,
278         bytes calldata data
279     ) external returns (bytes4);
280 }
281 
282 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Interface of the ERC165 standard, as defined in the
291  * https://eips.ethereum.org/EIPS/eip-165[EIP].
292  *
293  * Implementers can declare support of contract interfaces, which can then be
294  * queried by others ({ERC165Checker}).
295  *
296  * For an implementation, see {ERC165}.
297  */
298 interface IERC165 {
299     /**
300      * @dev Returns true if this contract implements the interface defined by
301      * interfaceId. See the corresponding
302      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
303      * to learn more about how these ids are created.
304      *
305      * This function call must use less than 30 000 gas.
306      */
307     function supportsInterface(bytes4 interfaceId) external view returns (bool);
308 }
309 
310 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
311 
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 /**
319  * @dev Implementation of the {IERC165} interface.
320  *
321  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
322  * for the additional interface id that will be supported. For example:
323  *
324  * solidity
325  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
326  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
327  * }
328  * 
329  *
330  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
331  */
332 abstract contract ERC165 is IERC165 {
333     /**
334      * @dev See {IERC165-supportsInterface}.
335      */
336     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
337         return interfaceId == type(IERC165).interfaceId;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 
349 /**
350  * @dev Required interface of an ERC721 compliant contract.
351  */
352 interface IERC721 is IERC165 {
353     /**
354      * @dev Emitted when tokenId token is transferred from from to to.
355      */
356     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
357 
358     /**
359      * @dev Emitted when owner enables approved to manage the tokenId token.
360      */
361     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
362 
363     /**
364      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
365      */
366     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
367 
368     /**
369      * @dev Returns the number of tokens in owner's account.
370      */
371     function balanceOf(address owner) external view returns (uint256 balance);
372 
373     /**
374      * @dev Returns the owner of the tokenId token.
375      *
376      * Requirements:
377      *
378      * - tokenId must exist.
379      */
380     function ownerOf(uint256 tokenId) external view returns (address owner);
381 
382     /**
383      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
384      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
385      *
386      * Requirements:
387      *
388      * - from cannot be the zero address.
389      * - to cannot be the zero address.
390      * - tokenId token must exist and be owned by from.
391      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
392      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
393      *
394      * Emits a {Transfer} event.
395      */
396     function safeTransferFrom(
397         address from,
398         address to,
399         uint256 tokenId
400     ) external;
401 
402     /**
403      * @dev Transfers tokenId token from from to to.
404      *
405      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
406      *
407      * Requirements:
408      *
409      * - from cannot be the zero address.
410      * - to cannot be the zero address.
411      * - tokenId token must be owned by from.
412      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) external;
421 
422     /**
423      * @dev Gives permission to to to transfer tokenId token to another account.
424      * The approval is cleared when the token is transferred.
425      *
426      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
427      *
428      * Requirements:
429      *
430      * - The caller must own the token or be an approved operator.
431      * - tokenId must exist.
432      *
433      * Emits an {Approval} event.
434      */
435     function approve(address to, uint256 tokenId) external;
436 
437     /**
438      * @dev Returns the account approved for tokenId token.
439      *
440      * Requirements:
441      *
442      * - tokenId must exist.
443      */
444     function getApproved(uint256 tokenId) external view returns (address operator);
445 
446     /**
447      * @dev Approve or remove operator as an operator for the caller.
448      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
449      *
450      * Requirements:
451      *
452      * - The operator cannot be the caller.
453      *
454      * Emits an {ApprovalForAll} event.
455      */
456     function setApprovalForAll(address operator, bool _approved) external;
457 
458     /**
459      * @dev Returns if the operator is allowed to manage all of the assets of owner.
460      *
461      * See {setApprovalForAll}
462      */
463     function isApprovedForAll(address owner, address operator) external view returns (bool);
464 
465     /**
466      * @dev Safely transfers tokenId token from from to to.
467      *
468      * Requirements:
469      *
470      * - from cannot be the zero address.
471      * - to cannot be the zero address.
472      * - tokenId token must exist and be owned by from.
473      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
474      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId,
482         bytes calldata data
483     ) external;
484 }
485 
486 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
487 
488 
489 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 
494 /**
495  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
496  * @dev See https://eips.ethereum.org/EIPS/eip-721
497  */
498 interface IERC721Enumerable is IERC721 {
499     /**
500      * @dev Returns the total amount of tokens stored by the contract.
501      */
502     function totalSupply() external view returns (uint256);
503 
504     /**
505      * @dev Returns a token ID owned by owner at a given index of its token list.
506      * Use along with {balanceOf} to enumerate all of owner's tokens.
507      */
508     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
509 
510     /**
511      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
512      * Use along with {totalSupply} to enumerate all tokens.
513      */
514     function tokenByIndex(uint256 index) external view returns (uint256);
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Metadata is IERC721 {
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 }
545 
546 // File: @openzeppelin/contracts/utils/Strings.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev String operations.
555  */
556 library Strings {
557     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
558 
559     /**
560      * @dev Converts a uint256 to its ASCII string decimal representation.
561      */
562     function toString(uint256 value) internal pure returns (string memory) {
563         // Inspired by OraclizeAPI's implementation - MIT licence
564         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
565 
566         if (value == 0) {
567             return "0";
568         }
569         uint256 temp = value;
570         uint256 digits;
571         while (temp != 0) {
572             digits++;
573             temp /= 10;
574         }
575         bytes memory buffer = new bytes(digits);
576         while (value != 0) {
577             digits -= 1;
578             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
579             value /= 10;
580         }
581         return string(buffer);
582     }
583 
584     /**
585      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
586      */
587     function toHexString(uint256 value) internal pure returns (string memory) {
588         if (value == 0) {
589             return "0x00";
590         }
591         uint256 temp = value;
592         uint256 length = 0;
593         while (temp != 0) {
594             length++;
595             temp >>= 8;
596         }
597         return toHexString(value, length);
598     }
599 
600     /**
601      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
602      */
603     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
604         bytes memory buffer = new bytes(2 * length + 2);
605         buffer[0] = "0";
606         buffer[1] = "x";
607         for (uint256 i = 2 * length + 1; i > 1; --i) {
608             buffer[i] = _HEX_SYMBOLS[value & 0xf];
609             value >>= 4;
610         }
611         require(value == 0, "Strings: hex length insufficient");
612         return string(buffer);
613     }
614 }
615 
616 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @dev Contract module that helps prevent reentrant calls to a function.
625  *
626  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
627  * available, which can be applied to functions to make sure there are no nested
628  * (reentrant) calls to them.
629  *
630  * Note that because there is a single nonReentrant guard, functions marked as
631  * nonReentrant may not call one another. This can be worked around by making
632  * those functions private, and then adding external nonReentrant entry
633  * points to them.
634  *
635  * TIP: If you would like to learn more about reentrancy and alternative ways
636  * to protect against it, check out our blog post
637  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
638  */
639 abstract contract ReentrancyGuard {
640     // Booleans are more expensive than uint256 or any type that takes up a full
641     // word because each write operation emits an extra SLOAD to first read the
642     // slot's contents, replace the bits taken up by the boolean, and then write
643     // back. This is the compiler's defense against contract upgrades and
644     // pointer aliasing, and it cannot be disabled.
645 
646     // The values being non-zero value makes deployment a bit more expensive,
647     // but in exchange the refund on every call to nonReentrant will be lower in
648     // amount. Since refunds are capped to a percentage of the total
649     // transaction's gas, it is best to keep them low in cases like this one, to
650     // increase the likelihood of the full refund coming into effect.
651     uint256 private constant _NOT_ENTERED = 1;
652     uint256 private constant _ENTERED = 2;
653 
654     uint256 private _status;
655 
656     constructor() {
657         _status = _NOT_ENTERED;
658     }
659 
660     /**
661      * @dev Prevents a contract from calling itself, directly or indirectly.
662      * Calling a nonReentrant function from another nonReentrant
663      * function is not supported. It is possible to prevent this from happening
664      * by making the nonReentrant function external, and making it call a
665      * private function that does the actual work.
666      */
667     modifier nonReentrant() {
668         // On the first call to nonReentrant, _notEntered will be true
669         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
670 
671         // Any calls to nonReentrant after this point will fail
672         _status = _ENTERED;
673 
674         _;
675 
676         // By storing the original value once again, a refund is triggered (see
677         // https://eips.ethereum.org/EIPS/eip-2200)
678         _status = _NOT_ENTERED;
679     }
680 }
681 
682 // File: @openzeppelin/contracts/utils/Context.sol
683 
684 
685 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev Provides information about the current execution context, including the
691  * sender of the transaction and its data. While these are generally available
692  * via msg.sender and msg.data, they should not be accessed in such a direct
693  * manner, since when dealing with meta-transactions the account sending and
694  * paying for execution may not be the actual sender (as far as an application
695  * is concerned).
696  *
697  * This contract is only required for intermediate, library-like contracts.
698  */
699 abstract contract Context {
700     function _msgSender() internal view virtual returns (address) {
701         return msg.sender;
702     }
703 
704     function _msgData() internal view virtual returns (bytes calldata) {
705         return msg.data;
706     }
707 }
708 
709 // File: @openzeppelin/contracts/access/Ownable.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @dev Contract module which provides a basic access control mechanism, where
719  * there is an account (an owner) that can be granted exclusive access to
720  * specific functions.
721  *
722  * By default, the owner account will be the one that deploys the contract. This
723  * can later be changed with {transferOwnership}.
724  *
725  * This module is used through inheritance. It will make available the modifier
726  * onlyOwner, which can be applied to your functions to restrict their use to
727  * the owner.
728  */
729 abstract contract Ownable is Context {
730     address private _owner;
731 
732     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734     /**
735      * @dev Initializes the contract setting the deployer as the initial owner.
736      */
737     constructor() {
738         _transferOwnership(_msgSender());
739     }
740 
741     /**
742      * @dev Returns the address of the current owner.
743      */
744     function owner() public view virtual returns (address) {
745         return _owner;
746     }
747 
748     /**
749      * @dev Throws if called by any account other than the owner.
750      */
751     function _onlyOwner() private view {
752        require(owner() == _msgSender(), "Ownable: caller is not the owner");
753     }
754 
755     modifier onlyOwner() {
756         _onlyOwner();
757         _;
758     }
759 
760     /**
761      * @dev Leaves the contract without owner. It will not be possible to call
762      * onlyOwner functions anymore. Can only be called by the current owner.
763      *
764      * NOTE: Renouncing ownership will leave the contract without an owner,
765      * thereby removing any functionality that is only available to the owner.
766      */
767     function renounceOwnership() public virtual onlyOwner {
768         _transferOwnership(address(0));
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (newOwner).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         _transferOwnership(newOwner);
778     }
779 
780     /**
781      * @dev Transfers ownership of the contract to a new account (newOwner).
782      * Internal function without access restriction.
783      */
784     function _transferOwnership(address newOwner) internal virtual {
785         address oldOwner = _owner;
786         _owner = newOwner;
787         emit OwnershipTransferred(oldOwner, newOwner);
788     }
789 }
790 
791 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
792 pragma solidity ^0.8.9;
793 
794 interface IOperatorFilterRegistry {
795     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
796     function register(address registrant) external;
797     function registerAndSubscribe(address registrant, address subscription) external;
798     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
799     function updateOperator(address registrant, address operator, bool filtered) external;
800     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
801     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
802     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
803     function subscribe(address registrant, address registrantToSubscribe) external;
804     function unsubscribe(address registrant, bool copyExistingEntries) external;
805     function subscriptionOf(address addr) external returns (address registrant);
806     function subscribers(address registrant) external returns (address[] memory);
807     function subscriberAt(address registrant, uint256 index) external returns (address);
808     function copyEntriesOf(address registrant, address registrantToCopy) external;
809     function isOperatorFiltered(address registrant, address operator) external returns (bool);
810     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
811     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
812     function filteredOperators(address addr) external returns (address[] memory);
813     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
814     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
815     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
816     function isRegistered(address addr) external returns (bool);
817     function codeHashOf(address addr) external returns (bytes32);
818 }
819 
820 // File contracts/OperatorFilter/OperatorFilterer.sol
821 pragma solidity ^0.8.9;
822 
823 abstract contract OperatorFilterer {
824     error OperatorNotAllowed(address operator);
825 
826     IOperatorFilterRegistry constant operatorFilterRegistry =
827         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
828 
829     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
830         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
831         // will not revert, but the contract will need to be registered with the registry once it is deployed in
832         // order for the modifier to filter addresses.
833         if (address(operatorFilterRegistry).code.length > 0) {
834             if (subscribe) {
835                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
836             } else {
837                 if (subscriptionOrRegistrantToCopy != address(0)) {
838                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
839                 } else {
840                     operatorFilterRegistry.register(address(this));
841                 }
842             }
843         }
844     }
845 
846     function _onlyAllowedOperator(address from) private view {
847       if (
848           !(
849               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
850               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
851           )
852       ) {
853           revert OperatorNotAllowed(msg.sender);
854       }
855     }
856 
857     modifier onlyAllowedOperator(address from) virtual {
858         // Check registry code length to facilitate testing in environments without a deployed registry.
859         if (address(operatorFilterRegistry).code.length > 0) {
860             // Allow spending tokens from addresses with balance
861             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
862             // from an EOA.
863             if (from == msg.sender) {
864                 _;
865                 return;
866             }
867             _onlyAllowedOperator(from);
868         }
869         _;
870     }
871 
872     modifier onlyAllowedOperatorApproval(address operator) virtual {
873         _checkFilterOperator(operator);
874         _;
875     }
876 
877     function _checkFilterOperator(address operator) internal view virtual {
878         // Check registry code length to facilitate testing in environments without a deployed registry.
879         if (address(operatorFilterRegistry).code.length > 0) {
880             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
881                 revert OperatorNotAllowed(operator);
882             }
883         }
884     }
885 }
886 
887 //-------------END DEPENDENCIES------------------------//
888 
889 
890   
891 error TransactionCapExceeded();
892 error PublicMintingClosed();
893 error ExcessiveOwnedMints();
894 error MintZeroQuantity();
895 error InvalidPayment();
896 error CapExceeded();
897 error IsAlreadyUnveiled();
898 error ValueCannotBeZero();
899 error CannotBeNullAddress();
900 error NoStateChange();
901 
902 error PublicMintClosed();
903 error AllowlistMintClosed();
904 
905 error AddressNotAllowlisted();
906 error AllowlistDropTimeHasNotPassed();
907 error PublicDropTimeHasNotPassed();
908 error DropTimeNotInFuture();
909 
910 error OnlyERC20MintingEnabled();
911 error ERC20TokenNotApproved();
912 error ERC20InsufficientBalance();
913 error ERC20InsufficientAllowance();
914 error ERC20TransferFailed();
915 
916 error ClaimModeDisabled();
917 error IneligibleRedemptionContract();
918 error TokenAlreadyRedeemed();
919 error InvalidOwnerForRedemption();
920 error InvalidApprovalForRedemption();
921 
922 error ERC721RestrictedApprovalAddressRestricted();
923 error NotMaintainer();
924   
925   
926 // Rampp Contracts v2.1 (Teams.sol)
927 
928 error InvalidTeamAddress();
929 error DuplicateTeamAddress();
930 pragma solidity ^0.8.0;
931 
932 /**
933 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
934 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
935 * This will easily allow cross-collaboration via Mintplex.xyz.
936 **/
937 abstract contract Teams is Ownable{
938   mapping (address => bool) internal team;
939 
940   /**
941   * @dev Adds an address to the team. Allows them to execute protected functions
942   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
943   **/
944   function addToTeam(address _address) public onlyOwner {
945     if(_address == address(0)) revert InvalidTeamAddress();
946     if(inTeam(_address)) revert DuplicateTeamAddress();
947   
948     team[_address] = true;
949   }
950 
951   /**
952   * @dev Removes an address to the team.
953   * @param _address the ETH address to remove, cannot be 0x and must be in team
954   **/
955   function removeFromTeam(address _address) public onlyOwner {
956     if(_address == address(0)) revert InvalidTeamAddress();
957     if(!inTeam(_address)) revert InvalidTeamAddress();
958   
959     team[_address] = false;
960   }
961 
962   /**
963   * @dev Check if an address is valid and active in the team
964   * @param _address ETH address to check for truthiness
965   **/
966   function inTeam(address _address)
967     public
968     view
969     returns (bool)
970   {
971     if(_address == address(0)) revert InvalidTeamAddress();
972     return team[_address] == true;
973   }
974 
975   /**
976   * @dev Throws if called by any account other than the owner or team member.
977   */
978   function _onlyTeamOrOwner() private view {
979     bool _isOwner = owner() == _msgSender();
980     bool _isTeam = inTeam(_msgSender());
981     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
982   }
983 
984   modifier onlyTeamOrOwner() {
985     _onlyTeamOrOwner();
986     _;
987   }
988 }
989 
990 
991   
992   pragma solidity ^0.8.0;
993 
994   /**
995   * @dev These functions deal with verification of Merkle Trees proofs.
996   *
997   * The proofs can be generated using the JavaScript library
998   * https://github.com/miguelmota/merkletreejs[merkletreejs].
999   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1000   *
1001   *
1002   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1003   * hashing, or use a hash function other than keccak256 for hashing leaves.
1004   * This is because the concatenation of a sorted pair of internal nodes in
1005   * the merkle tree could be reinterpreted as a leaf value.
1006   */
1007   library MerkleProof {
1008       /**
1009       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1010       * defined by 'root'. For this, a 'proof' must be provided, containing
1011       * sibling hashes on the branch from the leaf to the root of the tree. Each
1012       * pair of leaves and each pair of pre-images are assumed to be sorted.
1013       */
1014       function verify(
1015           bytes32[] memory proof,
1016           bytes32 root,
1017           bytes32 leaf
1018       ) internal pure returns (bool) {
1019           return processProof(proof, leaf) == root;
1020       }
1021 
1022       /**
1023       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1024       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1025       * hash matches the root of the tree. When processing the proof, the pairs
1026       * of leafs & pre-images are assumed to be sorted.
1027       *
1028       * _Available since v4.4._
1029       */
1030       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1031           bytes32 computedHash = leaf;
1032           for (uint256 i = 0; i < proof.length; i++) {
1033               bytes32 proofElement = proof[i];
1034               if (computedHash <= proofElement) {
1035                   // Hash(current computed hash + current element of the proof)
1036                   computedHash = _efficientHash(computedHash, proofElement);
1037               } else {
1038                   // Hash(current element of the proof + current computed hash)
1039                   computedHash = _efficientHash(proofElement, computedHash);
1040               }
1041           }
1042           return computedHash;
1043       }
1044 
1045       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1046           assembly {
1047               mstore(0x00, a)
1048               mstore(0x20, b)
1049               value := keccak256(0x00, 0x40)
1050           }
1051       }
1052   }
1053 
1054 
1055   // File: Allowlist.sol
1056 
1057   pragma solidity ^0.8.0;
1058 
1059   abstract contract Allowlist is Teams {
1060     bytes32 public merkleRoot;
1061     bool public onlyAllowlistMode = false;
1062 
1063     /**
1064      * @dev Update merkle root to reflect changes in Allowlist
1065      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1066      */
1067     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1068       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1069       merkleRoot = _newMerkleRoot;
1070     }
1071 
1072     /**
1073      * @dev Check the proof of an address if valid for merkle root
1074      * @param _to address to check for proof
1075      * @param _merkleProof Proof of the address to validate against root and leaf
1076      */
1077     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1078       if(merkleRoot == 0) revert ValueCannotBeZero();
1079       bytes32 leaf = keccak256(abi.encodePacked(_to));
1080 
1081       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1082     }
1083 
1084     
1085     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1086       onlyAllowlistMode = true;
1087     }
1088 
1089     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1090         onlyAllowlistMode = false;
1091     }
1092   }
1093   
1094   
1095 /**
1096  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1097  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1098  *
1099  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1100  * 
1101  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1102  *
1103  * Does not support burning tokens to address(0).
1104  */
1105 contract ERC721A is
1106   Context,
1107   ERC165,
1108   IERC721,
1109   IERC721Metadata,
1110   IERC721Enumerable,
1111   Teams
1112   , OperatorFilterer
1113 {
1114   using Address for address;
1115   using Strings for uint256;
1116 
1117   struct TokenOwnership {
1118     address addr;
1119     uint64 startTimestamp;
1120   }
1121 
1122   struct AddressData {
1123     uint128 balance;
1124     uint128 numberMinted;
1125   }
1126 
1127   uint256 private currentIndex;
1128 
1129   uint256 public immutable collectionSize;
1130   uint256 public maxBatchSize;
1131 
1132   // Token name
1133   string private _name;
1134 
1135   // Token symbol
1136   string private _symbol;
1137 
1138   // Mapping from token ID to ownership details
1139   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1140   mapping(uint256 => TokenOwnership) private _ownerships;
1141 
1142   // Mapping owner address to address data
1143   mapping(address => AddressData) private _addressData;
1144 
1145   // Mapping from token ID to approved address
1146   mapping(uint256 => address) private _tokenApprovals;
1147 
1148   // Mapping from owner to operator approvals
1149   mapping(address => mapping(address => bool)) private _operatorApprovals;
1150 
1151   /* @dev Mapping of restricted operator approvals set by contract Owner
1152   * This serves as an optional addition to ERC-721 so
1153   * that the contract owner can elect to prevent specific addresses/contracts
1154   * from being marked as the approver for a token. The reason for this
1155   * is that some projects may want to retain control of where their tokens can/can not be listed
1156   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1157   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1158   */
1159   mapping(address => bool) public restrictedApprovalAddresses;
1160 
1161   /**
1162    * @dev
1163    * maxBatchSize refers to how much a minter can mint at a time.
1164    * collectionSize_ refers to how many tokens are in the collection.
1165    */
1166   constructor(
1167     string memory name_,
1168     string memory symbol_,
1169     uint256 maxBatchSize_,
1170     uint256 collectionSize_
1171   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1172     require(
1173       collectionSize_ > 0,
1174       "ERC721A: collection must have a nonzero supply"
1175     );
1176     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1177     _name = name_;
1178     _symbol = symbol_;
1179     maxBatchSize = maxBatchSize_;
1180     collectionSize = collectionSize_;
1181     currentIndex = _startTokenId();
1182   }
1183 
1184   /**
1185   * To change the starting tokenId, please override this function.
1186   */
1187   function _startTokenId() internal view virtual returns (uint256) {
1188     return 1;
1189   }
1190 
1191   /**
1192    * @dev See {IERC721Enumerable-totalSupply}.
1193    */
1194   function totalSupply() public view override returns (uint256) {
1195     return _totalMinted();
1196   }
1197 
1198   function currentTokenId() public view returns (uint256) {
1199     return _totalMinted();
1200   }
1201 
1202   function getNextTokenId() public view returns (uint256) {
1203       return _totalMinted() + 1;
1204   }
1205 
1206   /**
1207   * Returns the total amount of tokens minted in the contract.
1208   */
1209   function _totalMinted() internal view returns (uint256) {
1210     unchecked {
1211       return currentIndex - _startTokenId();
1212     }
1213   }
1214 
1215   /**
1216    * @dev See {IERC721Enumerable-tokenByIndex}.
1217    */
1218   function tokenByIndex(uint256 index) public view override returns (uint256) {
1219     require(index < totalSupply(), "ERC721A: global index out of bounds");
1220     return index;
1221   }
1222 
1223   /**
1224    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1225    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1226    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1227    */
1228   function tokenOfOwnerByIndex(address owner, uint256 index)
1229     public
1230     view
1231     override
1232     returns (uint256)
1233   {
1234     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1235     uint256 numMintedSoFar = totalSupply();
1236     uint256 tokenIdsIdx = 0;
1237     address currOwnershipAddr = address(0);
1238     for (uint256 i = 0; i < numMintedSoFar; i++) {
1239       TokenOwnership memory ownership = _ownerships[i];
1240       if (ownership.addr != address(0)) {
1241         currOwnershipAddr = ownership.addr;
1242       }
1243       if (currOwnershipAddr == owner) {
1244         if (tokenIdsIdx == index) {
1245           return i;
1246         }
1247         tokenIdsIdx++;
1248       }
1249     }
1250     revert("ERC721A: unable to get token of owner by index");
1251   }
1252 
1253   /**
1254    * @dev See {IERC165-supportsInterface}.
1255    */
1256   function supportsInterface(bytes4 interfaceId)
1257     public
1258     view
1259     virtual
1260     override(ERC165, IERC165)
1261     returns (bool)
1262   {
1263     return
1264       interfaceId == type(IERC721).interfaceId ||
1265       interfaceId == type(IERC721Metadata).interfaceId ||
1266       interfaceId == type(IERC721Enumerable).interfaceId ||
1267       super.supportsInterface(interfaceId);
1268   }
1269 
1270   /**
1271    * @dev See {IERC721-balanceOf}.
1272    */
1273   function balanceOf(address owner) public view override returns (uint256) {
1274     require(owner != address(0), "ERC721A: balance query for the zero address");
1275     return uint256(_addressData[owner].balance);
1276   }
1277 
1278   function _numberMinted(address owner) internal view returns (uint256) {
1279     require(
1280       owner != address(0),
1281       "ERC721A: number minted query for the zero address"
1282     );
1283     return uint256(_addressData[owner].numberMinted);
1284   }
1285 
1286   function ownershipOf(uint256 tokenId)
1287     internal
1288     view
1289     returns (TokenOwnership memory)
1290   {
1291     uint256 curr = tokenId;
1292 
1293     unchecked {
1294         if (_startTokenId() <= curr && curr < currentIndex) {
1295             TokenOwnership memory ownership = _ownerships[curr];
1296             if (ownership.addr != address(0)) {
1297                 return ownership;
1298             }
1299 
1300             // Invariant:
1301             // There will always be an ownership that has an address and is not burned
1302             // before an ownership that does not have an address and is not burned.
1303             // Hence, curr will not underflow.
1304             while (true) {
1305                 curr--;
1306                 ownership = _ownerships[curr];
1307                 if (ownership.addr != address(0)) {
1308                     return ownership;
1309                 }
1310             }
1311         }
1312     }
1313 
1314     revert("ERC721A: unable to determine the owner of token");
1315   }
1316 
1317   /**
1318    * @dev See {IERC721-ownerOf}.
1319    */
1320   function ownerOf(uint256 tokenId) public view override returns (address) {
1321     return ownershipOf(tokenId).addr;
1322   }
1323 
1324   /**
1325    * @dev See {IERC721Metadata-name}.
1326    */
1327   function name() public view virtual override returns (string memory) {
1328     return _name;
1329   }
1330 
1331   /**
1332    * @dev See {IERC721Metadata-symbol}.
1333    */
1334   function symbol() public view virtual override returns (string memory) {
1335     return _symbol;
1336   }
1337 
1338   /**
1339    * @dev See {IERC721Metadata-tokenURI}.
1340    */
1341   function tokenURI(uint256 tokenId)
1342     public
1343     view
1344     virtual
1345     override
1346     returns (string memory)
1347   {
1348     string memory baseURI = _baseURI();
1349     string memory extension = _baseURIExtension();
1350     return
1351       bytes(baseURI).length > 0
1352         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1353         : "";
1354   }
1355 
1356   /**
1357    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1358    * token will be the concatenation of the baseURI and the tokenId. Empty
1359    * by default, can be overriden in child contracts.
1360    */
1361   function _baseURI() internal view virtual returns (string memory) {
1362     return "";
1363   }
1364 
1365   /**
1366    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1367    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1368    * by default, can be overriden in child contracts.
1369    */
1370   function _baseURIExtension() internal view virtual returns (string memory) {
1371     return "";
1372   }
1373 
1374   /**
1375    * @dev Sets the value for an address to be in the restricted approval address pool.
1376    * Setting an address to true will disable token owners from being able to mark the address
1377    * for approval for trading. This would be used in theory to prevent token owners from listing
1378    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1379    * @param _address the marketplace/user to modify restriction status of
1380    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1381    */
1382   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1383     restrictedApprovalAddresses[_address] = _isRestricted;
1384   }
1385 
1386   /**
1387    * @dev See {IERC721-approve}.
1388    */
1389   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1390     address owner = ERC721A.ownerOf(tokenId);
1391     require(to != owner, "ERC721A: approval to current owner");
1392     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1393 
1394     require(
1395       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1396       "ERC721A: approve caller is not owner nor approved for all"
1397     );
1398 
1399     _approve(to, tokenId, owner);
1400   }
1401 
1402   /**
1403    * @dev See {IERC721-getApproved}.
1404    */
1405   function getApproved(uint256 tokenId) public view override returns (address) {
1406     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1407 
1408     return _tokenApprovals[tokenId];
1409   }
1410 
1411   /**
1412    * @dev See {IERC721-setApprovalForAll}.
1413    */
1414   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1415     require(operator != _msgSender(), "ERC721A: approve to caller");
1416     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1417 
1418     _operatorApprovals[_msgSender()][operator] = approved;
1419     emit ApprovalForAll(_msgSender(), operator, approved);
1420   }
1421 
1422   /**
1423    * @dev See {IERC721-isApprovedForAll}.
1424    */
1425   function isApprovedForAll(address owner, address operator)
1426     public
1427     view
1428     virtual
1429     override
1430     returns (bool)
1431   {
1432     return _operatorApprovals[owner][operator];
1433   }
1434 
1435   /**
1436    * @dev See {IERC721-transferFrom}.
1437    */
1438   function transferFrom(
1439     address from,
1440     address to,
1441     uint256 tokenId
1442   ) public override onlyAllowedOperator(from) {
1443     _transfer(from, to, tokenId);
1444   }
1445 
1446   /**
1447    * @dev See {IERC721-safeTransferFrom}.
1448    */
1449   function safeTransferFrom(
1450     address from,
1451     address to,
1452     uint256 tokenId
1453   ) public override onlyAllowedOperator(from) {
1454     safeTransferFrom(from, to, tokenId, "");
1455   }
1456 
1457   /**
1458    * @dev See {IERC721-safeTransferFrom}.
1459    */
1460   function safeTransferFrom(
1461     address from,
1462     address to,
1463     uint256 tokenId,
1464     bytes memory _data
1465   ) public override onlyAllowedOperator(from) {
1466     _transfer(from, to, tokenId);
1467     require(
1468       _checkOnERC721Received(from, to, tokenId, _data),
1469       "ERC721A: transfer to non ERC721Receiver implementer"
1470     );
1471   }
1472 
1473   /**
1474    * @dev Returns whether tokenId exists.
1475    *
1476    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1477    *
1478    * Tokens start existing when they are minted (_mint),
1479    */
1480   function _exists(uint256 tokenId) internal view returns (bool) {
1481     return _startTokenId() <= tokenId && tokenId < currentIndex;
1482   }
1483 
1484   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1485     _safeMint(to, quantity, isAdminMint, "");
1486   }
1487 
1488   /**
1489    * @dev Mints quantity tokens and transfers them to to.
1490    *
1491    * Requirements:
1492    *
1493    * - there must be quantity tokens remaining unminted in the total collection.
1494    * - to cannot be the zero address.
1495    * - quantity cannot be larger than the max batch size.
1496    *
1497    * Emits a {Transfer} event.
1498    */
1499   function _safeMint(
1500     address to,
1501     uint256 quantity,
1502     bool isAdminMint,
1503     bytes memory _data
1504   ) internal {
1505     uint256 startTokenId = currentIndex;
1506     require(to != address(0), "ERC721A: mint to the zero address");
1507     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1508     require(!_exists(startTokenId), "ERC721A: token already minted");
1509 
1510     // For admin mints we do not want to enforce the maxBatchSize limit
1511     if (isAdminMint == false) {
1512         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1513     }
1514 
1515     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1516 
1517     AddressData memory addressData = _addressData[to];
1518     _addressData[to] = AddressData(
1519       addressData.balance + uint128(quantity),
1520       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1521     );
1522     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1523 
1524     uint256 updatedIndex = startTokenId;
1525 
1526     for (uint256 i = 0; i < quantity; i++) {
1527       emit Transfer(address(0), to, updatedIndex);
1528       require(
1529         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1530         "ERC721A: transfer to non ERC721Receiver implementer"
1531       );
1532       updatedIndex++;
1533     }
1534 
1535     currentIndex = updatedIndex;
1536     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1537   }
1538 
1539   /**
1540    * @dev Transfers tokenId from from to to.
1541    *
1542    * Requirements:
1543    *
1544    * - to cannot be the zero address.
1545    * - tokenId token must be owned by from.
1546    *
1547    * Emits a {Transfer} event.
1548    */
1549   function _transfer(
1550     address from,
1551     address to,
1552     uint256 tokenId
1553   ) private {
1554     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1555 
1556     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1557       getApproved(tokenId) == _msgSender() ||
1558       isApprovedForAll(prevOwnership.addr, _msgSender()));
1559 
1560     require(
1561       isApprovedOrOwner,
1562       "ERC721A: transfer caller is not owner nor approved"
1563     );
1564 
1565     require(
1566       prevOwnership.addr == from,
1567       "ERC721A: transfer from incorrect owner"
1568     );
1569     require(to != address(0), "ERC721A: transfer to the zero address");
1570 
1571     _beforeTokenTransfers(from, to, tokenId, 1);
1572 
1573     // Clear approvals from the previous owner
1574     _approve(address(0), tokenId, prevOwnership.addr);
1575 
1576     _addressData[from].balance -= 1;
1577     _addressData[to].balance += 1;
1578     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1579 
1580     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1581     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1582     uint256 nextTokenId = tokenId + 1;
1583     if (_ownerships[nextTokenId].addr == address(0)) {
1584       if (_exists(nextTokenId)) {
1585         _ownerships[nextTokenId] = TokenOwnership(
1586           prevOwnership.addr,
1587           prevOwnership.startTimestamp
1588         );
1589       }
1590     }
1591 
1592     emit Transfer(from, to, tokenId);
1593     _afterTokenTransfers(from, to, tokenId, 1);
1594   }
1595 
1596   /**
1597    * @dev Approve to to operate on tokenId
1598    *
1599    * Emits a {Approval} event.
1600    */
1601   function _approve(
1602     address to,
1603     uint256 tokenId,
1604     address owner
1605   ) private {
1606     _tokenApprovals[tokenId] = to;
1607     emit Approval(owner, to, tokenId);
1608   }
1609 
1610   uint256 public nextOwnerToExplicitlySet = 0;
1611 
1612   /**
1613    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1614    */
1615   function _setOwnersExplicit(uint256 quantity) internal {
1616     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1617     require(quantity > 0, "quantity must be nonzero");
1618     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1619 
1620     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1621     if (endIndex > collectionSize - 1) {
1622       endIndex = collectionSize - 1;
1623     }
1624     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1625     require(_exists(endIndex), "not enough minted yet for this cleanup");
1626     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1627       if (_ownerships[i].addr == address(0)) {
1628         TokenOwnership memory ownership = ownershipOf(i);
1629         _ownerships[i] = TokenOwnership(
1630           ownership.addr,
1631           ownership.startTimestamp
1632         );
1633       }
1634     }
1635     nextOwnerToExplicitlySet = endIndex + 1;
1636   }
1637 
1638   /**
1639    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1640    * The call is not executed if the target address is not a contract.
1641    *
1642    * @param from address representing the previous owner of the given token ID
1643    * @param to target address that will receive the tokens
1644    * @param tokenId uint256 ID of the token to be transferred
1645    * @param _data bytes optional data to send along with the call
1646    * @return bool whether the call correctly returned the expected magic value
1647    */
1648   function _checkOnERC721Received(
1649     address from,
1650     address to,
1651     uint256 tokenId,
1652     bytes memory _data
1653   ) private returns (bool) {
1654     if (to.isContract()) {
1655       try
1656         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1657       returns (bytes4 retval) {
1658         return retval == IERC721Receiver(to).onERC721Received.selector;
1659       } catch (bytes memory reason) {
1660         if (reason.length == 0) {
1661           revert("ERC721A: transfer to non ERC721Receiver implementer");
1662         } else {
1663           assembly {
1664             revert(add(32, reason), mload(reason))
1665           }
1666         }
1667       }
1668     } else {
1669       return true;
1670     }
1671   }
1672 
1673   /**
1674    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1675    *
1676    * startTokenId - the first token id to be transferred
1677    * quantity - the amount to be transferred
1678    *
1679    * Calling conditions:
1680    *
1681    * - When from and to are both non-zero, from's tokenId will be
1682    * transferred to to.
1683    * - When from is zero, tokenId will be minted for to.
1684    */
1685   function _beforeTokenTransfers(
1686     address from,
1687     address to,
1688     uint256 startTokenId,
1689     uint256 quantity
1690   ) internal virtual {}
1691 
1692   /**
1693    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1694    * minting.
1695    *
1696    * startTokenId - the first token id to be transferred
1697    * quantity - the amount to be transferred
1698    *
1699    * Calling conditions:
1700    *
1701    * - when from and to are both non-zero.
1702    * - from and to are never both zero.
1703    */
1704   function _afterTokenTransfers(
1705     address from,
1706     address to,
1707     uint256 startTokenId,
1708     uint256 quantity
1709   ) internal virtual {}
1710 }
1711 
1712 abstract contract ProviderFees is Context {
1713   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1714   uint256 public PROVIDER_FEE = 0.000777 ether;  
1715 
1716   function sendProviderFee() internal {
1717     payable(PROVIDER).transfer(PROVIDER_FEE);
1718   }
1719 
1720   function setProviderFee(uint256 _fee) public {
1721     if(_msgSender() != PROVIDER) revert NotMaintainer();
1722     PROVIDER_FEE = _fee;
1723   }
1724 }
1725 
1726 
1727 
1728   
1729 /** TimedDrop.sol
1730 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1731 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1732 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1733 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1734 */
1735 abstract contract TimedDrop is Teams {
1736   bool public enforcePublicDropTime = true;
1737   uint256 public publicDropTime = 1679677200;
1738   
1739   /**
1740   * @dev Allow the contract owner to set the public time to mint.
1741   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1742   */
1743   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1744     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1745     publicDropTime = _newDropTime;
1746   }
1747 
1748   function usePublicDropTime() public onlyTeamOrOwner {
1749     enforcePublicDropTime = true;
1750   }
1751 
1752   function disablePublicDropTime() public onlyTeamOrOwner {
1753     enforcePublicDropTime = false;
1754   }
1755 
1756   /**
1757   * @dev determine if the public droptime has passed.
1758   * if the feature is disabled then assume the time has passed.
1759   */
1760   function publicDropTimePassed() public view returns(bool) {
1761     if(enforcePublicDropTime == false) {
1762       return true;
1763     }
1764     return block.timestamp >= publicDropTime;
1765   }
1766   
1767   // Allowlist implementation of the Timed Drop feature
1768   bool public enforceAllowlistDropTime = true;
1769   uint256 public allowlistDropTime = 1679414400;
1770 
1771   /**
1772   * @dev Allow the contract owner to set the allowlist time to mint.
1773   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1774   */
1775   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1776     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1777     allowlistDropTime = _newDropTime;
1778   }
1779 
1780   function useAllowlistDropTime() public onlyTeamOrOwner {
1781     enforceAllowlistDropTime = true;
1782   }
1783 
1784   function disableAllowlistDropTime() public onlyTeamOrOwner {
1785     enforceAllowlistDropTime = false;
1786   }
1787 
1788   function allowlistDropTimePassed() public view returns(bool) {
1789     if(enforceAllowlistDropTime == false) {
1790       return true;
1791     }
1792 
1793     return block.timestamp >= allowlistDropTime;
1794   }
1795 }
1796 
1797   
1798 interface IERC20 {
1799   function allowance(address owner, address spender) external view returns (uint256);
1800   function transfer(address _to, uint256 _amount) external returns (bool);
1801   function balanceOf(address account) external view returns (uint256);
1802   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1803 }
1804 
1805 // File: WithdrawableV2
1806 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1807 // ERC-20 Payouts are limited to a single payout address. This feature 
1808 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1809 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1810 abstract contract WithdrawableV2 is Teams {
1811   struct acceptedERC20 {
1812     bool isActive;
1813     uint256 chargeAmount;
1814   }
1815 
1816   
1817   mapping(address => acceptedERC20) private allowedTokenContracts;
1818   address[] public payableAddresses = [0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0xCFb6bc33AF4F6f0a69F00d6DAB045dEE83f627f9];
1819   address public erc20Payable = 0xCFb6bc33AF4F6f0a69F00d6DAB045dEE83f627f9;
1820   uint256[] public payableFees = [2,98];
1821   uint256 public payableAddressCount = 2;
1822   bool public onlyERC20MintingMode;
1823   
1824 
1825   function withdrawAll() public onlyTeamOrOwner {
1826       if(address(this).balance == 0) revert ValueCannotBeZero();
1827       _withdrawAll(address(this).balance);
1828   }
1829 
1830   function _withdrawAll(uint256 balance) private {
1831       for(uint i=0; i < payableAddressCount; i++ ) {
1832           _widthdraw(
1833               payableAddresses[i],
1834               (balance * payableFees[i]) / 100
1835           );
1836       }
1837   }
1838   
1839   function _widthdraw(address _address, uint256 _amount) private {
1840       (bool success, ) = _address.call{value: _amount}("");
1841       require(success, "Transfer failed.");
1842   }
1843 
1844   /**
1845   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1846   * in the event ERC-20 tokens are paid to the contract for mints.
1847   * @param _tokenContract contract of ERC-20 token to withdraw
1848   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1849   */
1850   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1851     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1852     IERC20 tokenContract = IERC20(_tokenContract);
1853     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1854     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1855   }
1856 
1857   /**
1858   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1859   * @param _erc20TokenContract address of ERC-20 contract in question
1860   */
1861   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1862     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1863   }
1864 
1865   /**
1866   * @dev get the value of tokens to transfer for user of an ERC-20
1867   * @param _erc20TokenContract address of ERC-20 contract in question
1868   */
1869   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1870     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1871     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1872   }
1873 
1874   /**
1875   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1876   * @param _erc20TokenContract address of ERC-20 contract in question
1877   * @param _isActive default status of if contract should be allowed to accept payments
1878   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1879   */
1880   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1881     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1882     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1883   }
1884 
1885   /**
1886   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1887   * it will assume the default value of zero. This should not be used to create new payment tokens.
1888   * @param _erc20TokenContract address of ERC-20 contract in question
1889   */
1890   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1891     allowedTokenContracts[_erc20TokenContract].isActive = true;
1892   }
1893 
1894   /**
1895   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1896   * it will assume the default value of zero. This should not be used to create new payment tokens.
1897   * @param _erc20TokenContract address of ERC-20 contract in question
1898   */
1899   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1900     allowedTokenContracts[_erc20TokenContract].isActive = false;
1901   }
1902 
1903   /**
1904   * @dev Enable only ERC-20 payments for minting on this contract
1905   */
1906   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1907     onlyERC20MintingMode = true;
1908   }
1909 
1910   /**
1911   * @dev Disable only ERC-20 payments for minting on this contract
1912   */
1913   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1914     onlyERC20MintingMode = false;
1915   }
1916 
1917   /**
1918   * @dev Set the payout of the ERC-20 token payout to a specific address
1919   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1920   */
1921   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1922     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1923     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1924     erc20Payable = _newErc20Payable;
1925   }
1926 }
1927 
1928 
1929   
1930   
1931 /* File: Tippable.sol
1932 /* @dev Allows owner to set strict enforcement of payment to mint price.
1933 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1934 /* when doing a free mint with opt-in pricing.
1935 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1936 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1937 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1938 /* Pros - can take in gratituity payments during a mint. 
1939 /* Cons - However if you decrease pricing during mint txn settlement 
1940 /* it can result in mints landing who technically now have overpaid.
1941 */
1942 abstract contract Tippable is Teams {
1943   bool public strictPricing = true;
1944 
1945   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1946     strictPricing = _newStatus;
1947   }
1948 
1949   // @dev check if msg.value is correct according to pricing enforcement
1950   // @param _msgValue -> passed in msg.value of tx
1951   // @param _expectedPrice -> result of getPrice(...args)
1952   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1953     return strictPricing ? 
1954       _msgValue == _expectedPrice : 
1955       _msgValue >= _expectedPrice;
1956   }
1957 }
1958 
1959   
1960 // File: EarlyMintIncentive.sol
1961 // Allows the contract to have the first x tokens have a discount or
1962 // zero fee that can be calculated on the fly.
1963 abstract contract EarlyMintIncentive is Teams, ERC721A, ProviderFees {
1964   uint256 public PRICE = 0.025 ether;
1965   uint256 public EARLY_MINT_PRICE = 0 ether;
1966   uint256 public earlyMintTokenIdCap = 333;
1967   bool public usingEarlyMintIncentive = true;
1968 
1969   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1970     usingEarlyMintIncentive = true;
1971   }
1972 
1973   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1974     usingEarlyMintIncentive = false;
1975   }
1976 
1977   /**
1978   * @dev Set the max token ID in which the cost incentive will be applied.
1979   * @param _newTokenIdCap max tokenId in which incentive will be applied
1980   */
1981   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1982     if(_newTokenIdCap > collectionSize) revert CapExceeded();
1983     if(_newTokenIdCap == 0) revert ValueCannotBeZero();
1984     earlyMintTokenIdCap = _newTokenIdCap;
1985   }
1986 
1987   /**
1988   * @dev Set the incentive mint price
1989   * @param _feeInWei new price per token when in incentive range
1990   */
1991   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1992     EARLY_MINT_PRICE = _feeInWei;
1993   }
1994 
1995   /**
1996   * @dev Set the primary mint price - the base price when not under incentive
1997   * @param _feeInWei new price per token
1998   */
1999   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
2000     PRICE = _feeInWei;
2001   }
2002 
2003   function getPrice(uint256 _count) public view returns (uint256) {
2004     if(_count == 0) revert ValueCannotBeZero();
2005 
2006     // short circuit function if we dont need to even calc incentive pricing
2007     // short circuit if the current tokenId is also already over cap
2008     if(
2009       usingEarlyMintIncentive == false ||
2010       currentTokenId() > earlyMintTokenIdCap
2011     ) {
2012       return (PRICE * _count) + PROVIDER_FEE;
2013     }
2014 
2015     uint256 endingTokenId = currentTokenId() + _count;
2016     // If qty to mint results in a final token ID less than or equal to the cap then
2017     // the entire qty is within free mint.
2018     if(endingTokenId  <= earlyMintTokenIdCap) {
2019       return (EARLY_MINT_PRICE * _count) + PROVIDER_FEE;
2020     }
2021 
2022     // If the current token id is less than the incentive cap
2023     // and the ending token ID is greater than the incentive cap
2024     // we will be straddling the cap so there will be some amount
2025     // that are incentive and some that are regular fee.
2026     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
2027     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
2028 
2029     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount) + PROVIDER_FEE;
2030   }
2031 }
2032 
2033   
2034   
2035 abstract contract ERC721APlus is 
2036     Ownable,
2037     Teams,
2038     ERC721A,
2039     WithdrawableV2,
2040     ReentrancyGuard 
2041     , EarlyMintIncentive, Tippable 
2042     , Allowlist 
2043     , TimedDrop
2044 {
2045   constructor(
2046     string memory tokenName,
2047     string memory tokenSymbol
2048   ) ERC721A(tokenName, tokenSymbol, 1, 3333) { }
2049     uint8 constant public CONTRACT_VERSION = 2;
2050     string public _baseTokenURI = "ipfs://QmXqiQPVYtSnbK8nWRd8iGYDofb2khWys4SWushrLhTtN3/";
2051     string public _baseTokenExtension = ".json";
2052 
2053     bool public mintingOpen = false;
2054     
2055     
2056     uint256 public MAX_WALLET_MINTS = 1;
2057 
2058   
2059     /////////////// Admin Mint Functions
2060     /**
2061      * @dev Mints a token to an address with a tokenURI.
2062      * This is owner only and allows a fee-free drop
2063      * @param _to address of the future owner of the token
2064      * @param _qty amount of tokens to drop the owner
2065      */
2066      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2067          if(_qty == 0) revert MintZeroQuantity();
2068          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2069          _safeMint(_to, _qty, true);
2070      }
2071 
2072   
2073     /////////////// PUBLIC MINT FUNCTIONS
2074     /**
2075     * @dev Mints tokens to an address in batch.
2076     * fee may or may not be required*
2077     * @param _to address of the future owner of the token
2078     * @param _amount number of tokens to mint
2079     */
2080     function mintToMultiple(address _to, uint256 _amount) public payable {
2081         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2082         if(_amount == 0) revert MintZeroQuantity();
2083         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2084         if(!mintingOpen) revert PublicMintClosed();
2085         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2086         if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
2087         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2088         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2089         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2090         sendProviderFee();
2091         _safeMint(_to, _amount, false);
2092     }
2093 
2094     /**
2095      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2096      * fee may or may not be required*
2097      * @param _to address of the future owner of the token
2098      * @param _amount number of tokens to mint
2099      * @param _erc20TokenContract erc-20 token contract to mint with
2100      */
2101     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2102       if(_amount == 0) revert MintZeroQuantity();
2103       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2104       if(!mintingOpen) revert PublicMintClosed();
2105       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2106       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2107       if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
2108       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2109       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2110 
2111       // ERC-20 Specific pre-flight checks
2112       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2113       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2114       IERC20 payableToken = IERC20(_erc20TokenContract);
2115 
2116       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2117       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2118 
2119       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2120       if(!transferComplete) revert ERC20TransferFailed();
2121 
2122       sendProviderFee();
2123       _safeMint(_to, _amount, false);
2124     }
2125 
2126     function openMinting() public onlyTeamOrOwner {
2127         mintingOpen = true;
2128     }
2129 
2130     function stopMinting() public onlyTeamOrOwner {
2131         mintingOpen = false;
2132     }
2133 
2134   
2135     ///////////// ALLOWLIST MINTING FUNCTIONS
2136     /**
2137     * @dev Mints tokens to an address using an allowlist.
2138     * fee may or may not be required*
2139     * @param _to address of the future owner of the token
2140     * @param _amount number of tokens to mint
2141     * @param _merkleProof merkle proof array
2142     */
2143     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2144         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2145         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2146         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2147         if(_amount == 0) revert MintZeroQuantity();
2148         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2149         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2150         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2151         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2152         if(!allowlistDropTimePassed()) revert AllowlistDropTimeHasNotPassed();
2153 
2154         sendProviderFee();
2155         _safeMint(_to, _amount, false);
2156     }
2157 
2158     /**
2159     * @dev Mints tokens to an address using an allowlist.
2160     * fee may or may not be required*
2161     * @param _to address of the future owner of the token
2162     * @param _amount number of tokens to mint
2163     * @param _merkleProof merkle proof array
2164     * @param _erc20TokenContract erc-20 token contract to mint with
2165     */
2166     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2167       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2168       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2169       if(_amount == 0) revert MintZeroQuantity();
2170       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2171       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2172       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2173       if(!allowlistDropTimePassed()) revert AllowlistDropTimeHasNotPassed();
2174       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2175 
2176       // ERC-20 Specific pre-flight checks
2177       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2178       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2179       IERC20 payableToken = IERC20(_erc20TokenContract);
2180 
2181       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2182       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2183 
2184       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2185       if(!transferComplete) revert ERC20TransferFailed();
2186       
2187       sendProviderFee();
2188       _safeMint(_to, _amount, false);
2189     }
2190 
2191     /**
2192      * @dev Enable allowlist minting fully by enabling both flags
2193      * This is a convenience function for the Rampp user
2194      */
2195     function openAllowlistMint() public onlyTeamOrOwner {
2196         enableAllowlistOnlyMode();
2197         mintingOpen = true;
2198     }
2199 
2200     /**
2201      * @dev Close allowlist minting fully by disabling both flags
2202      * This is a convenience function for the Rampp user
2203      */
2204     function closeAllowlistMint() public onlyTeamOrOwner {
2205         disableAllowlistOnlyMode();
2206         mintingOpen = false;
2207     }
2208 
2209 
2210   
2211     /**
2212     * @dev Check if wallet over MAX_WALLET_MINTS
2213     * @param _address address in question to check if minted count exceeds max
2214     */
2215     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2216         if(_amount == 0) revert ValueCannotBeZero();
2217         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2218     }
2219 
2220     /**
2221     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2222     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2223     */
2224     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2225         if(_newWalletMax == 0) revert ValueCannotBeZero();
2226         MAX_WALLET_MINTS = _newWalletMax;
2227     }
2228     
2229 
2230   
2231     /**
2232      * @dev Allows owner to set Max mints per tx
2233      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2234      */
2235      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2236          if(_newMaxMint == 0) revert ValueCannotBeZero();
2237          maxBatchSize = _newMaxMint;
2238      }
2239     
2240 
2241   
2242   
2243   
2244   function contractURI() public pure returns (string memory) {
2245     return "https://metadata.mintplex.xyz/M14VU3m0US9N3Zq9ubbO/contract-metadata";
2246   }
2247   
2248 
2249   function _baseURI() internal view virtual override returns(string memory) {
2250     return _baseTokenURI;
2251   }
2252 
2253   function _baseURIExtension() internal view virtual override returns(string memory) {
2254     return _baseTokenExtension;
2255   }
2256 
2257   function baseTokenURI() public view returns(string memory) {
2258     return _baseTokenURI;
2259   }
2260 
2261   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2262     _baseTokenURI = baseURI;
2263   }
2264 
2265   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2266     _baseTokenExtension = baseExtension;
2267   }
2268 }
2269 
2270 
2271   
2272 // File: contracts/KoalaDayContract.sol
2273 //SPDX-License-Identifier: MIT
2274 
2275 pragma solidity ^0.8.0;
2276 
2277 contract KoalaDayContract is ERC721APlus {
2278     constructor() ERC721APlus("Koala Day", "KOALA"){}
2279 }
2280   /*******************************************************/
2281   /*                                                     */
2282   /*            ,ad8PPPP88b,     ,d88PPPP8ba,            */
2283   /*           d8P"      "Y8b, ,d8P"      "Y8b           */
2284   /*          dP'           "8a8"           `Yd          */
2285   /*          8(              "              )8          */
2286   /*          I8                             8I          */
2287   /*           Yb,                         ,dP           */
2288   /*            "8a,                     ,a8"            */
2289   /*              "8a,                 ,a8"              */
2290   /*                "Yba             adP"                */
2291   /*                  `Y8a         a8P'                  */
2292   /*                    `88,     ,88'                    */
2293   /*                      "8b   d8"  NFT-Inator &        */
2294   /*                       "8b d8"   Mintplex            */
2295   /*                        `888'                        */
2296   /*                          "                          */
2297   /*   _______________________________________________   */
2298   /*                                                     */
2299   /*   THIS FREE NO-CODE CONTRACT WAS DEPLOYED WITH      */
2300   /*   NFT-INATOR AND MINTPLEX. CREATE YOUR OWN NO-CODE  */
2301   /*   COLLECTION AT NFT-INATOR.COM                      */
2302   /*                                                     */
2303   /*   Neither NFT-inator or Mintplex are responsible    */
2304   /*   for the functionality & content associated with   */
2305   /*   this smart contract or the creator/collectors     */
2306   /*   NFT-Inator & Mintplex is not associated or        */
2307   /*   affiliated with this project.                     */
2308   /*******************************************************/