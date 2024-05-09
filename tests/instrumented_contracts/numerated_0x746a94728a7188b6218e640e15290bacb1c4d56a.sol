1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ______  __ __    ___       _____ ____  ____    ____  __    __  _       
5 // |      ||  |  |  /  _]     / ___/|    \|    \  /    ||  |__|  || |      
6 // |      ||  |  | /  [_     (   \_ |  o  )  D  )|  o  ||  |  |  || |      
7 // |_|  |_||  _  ||    _]     \__  ||   _/|    / |     ||  |  |  || |___   
8 //   |  |  |  |  ||   [_      /  \ ||  |  |    \ |  _  ||  `  '  ||     |  
9 //   |  |  |  |  ||     |     \    ||  |  |  .  \|  |  | \      / |     |  
10 //   |__|  |__|__||_____|      \___||__|  |__|\_||__|__|  \_/\_/  |_____|  
11 //                                                                         
12 //         __  ____  ______  __ __      ____   ____  _____ _____           
13 //        /  ]|    ||      ||  |  |    |    \ /    |/ ___// ___/           
14 //       /  /  |  | |      ||  |  |    |  o  )  o  (   \_(   \_            
15 //      /  /   |  | |_|  |_||  ~  |    |   _/|     |\__  |\__  |           
16 //     /   \_  |  |   |  |  |___, |    |  |  |  _  |/  \ |/  \ |           
17 //     \     | |  |   |  |  |     |    |  |  |  |  |\    |\    |           
18 //      \____||____|  |__|  |____/     |__|  |__|__| \___| \___|           
19 //                                                                         
20 //                          ____   __ __                                   
21 //                         |    \ |  |  |                                  
22 //                         |  o  )|  |  |                                  
23 //                         |     ||  ~  |                                  
24 //                         |  O  ||___, |                                  
25 //                         |     ||     |                                  
26 //                         |_____||____/                                   
27 //                                                                         
28 //  ____   _       ____    __  __  _      ____   _       ___     __  __  _ 
29 // |    \ | |     /    |  /  ]|  |/ ]    |    \ | |     /   \   /  ]|  |/ ]
30 // |  o  )| |    |  o  | /  / |  ' /     |  o  )| |    |     | /  / |  ' / 
31 // |     || |___ |     |/  /  |    \     |     || |___ |  O  |/  /  |    \ 
32 // |  O  ||     ||  _  /   \_ |     \    |  O  ||     ||     /   \_ |     \
33 // |     ||     ||  |  \     ||  .  |    |     ||     ||     \     ||  .  |
34 // |_____||_____||__|__|\____||__|\_|    |_____||_____| \___/ \____||__|\_|
35 //                                                                         
36 //
37 //*********************************************************************//
38 //*********************************************************************//
39   
40 //-------------DEPENDENCIES--------------------------//
41 
42 // File: @openzeppelin/contracts/utils/Address.sol
43 
44 
45 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
46 
47 pragma solidity ^0.8.1;
48 
49 /**
50  * @dev Collection of functions related to the address type
51  */
52 library Address {
53     /**
54      * @dev Returns true if account is a contract.
55      *
56      * [IMPORTANT]
57      * ====
58      * It is unsafe to assume that an address for which this function returns
59      * false is an externally-owned account (EOA) and not a contract.
60      *
61      * Among others, isContract will return false for the following
62      * types of addresses:
63      *
64      *  - an externally-owned account
65      *  - a contract in construction
66      *  - an address where a contract will be created
67      *  - an address where a contract lived, but was destroyed
68      * ====
69      *
70      * [IMPORTANT]
71      * ====
72      * You shouldn't rely on isContract to protect against flash loan attacks!
73      *
74      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
75      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
76      * constructor.
77      * ====
78      */
79     function isContract(address account) internal view returns (bool) {
80         // This method relies on extcodesize/address.code.length, which returns 0
81         // for contracts in construction, since the code is only stored at the end
82         // of the constructor execution.
83 
84         return account.code.length > 0;
85     }
86 
87     /**
88      * @dev Replacement for Solidity's transfer: sends amount wei to
89      * recipient, forwarding all available gas and reverting on errors.
90      *
91      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
92      * of certain opcodes, possibly making contracts go over the 2300 gas limit
93      * imposed by transfer, making them unable to receive funds via
94      * transfer. {sendValue} removes this limitation.
95      *
96      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
97      *
98      * IMPORTANT: because control is transferred to recipient, care must be
99      * taken to not create reentrancy vulnerabilities. Consider using
100      * {ReentrancyGuard} or the
101      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
102      */
103     function sendValue(address payable recipient, uint256 amount) internal {
104         require(address(this).balance >= amount, "Address: insufficient balance");
105 
106         (bool success, ) = recipient.call{value: amount}("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110     /**
111      * @dev Performs a Solidity function call using a low level call. A
112      * plain call is an unsafe replacement for a function call: use this
113      * function instead.
114      *
115      * If target reverts with a revert reason, it is bubbled up by this
116      * function (like regular Solidity function calls).
117      *
118      * Returns the raw returned data. To convert to the expected return value,
119      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
120      *
121      * Requirements:
122      *
123      * - target must be a contract.
124      * - calling target with data must not revert.
125      *
126      * _Available since v3.1._
127      */
128     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
129         return functionCall(target, data, "Address: low-level call failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
134      * errorMessage as a fallback revert reason when target reverts.
135      *
136      * _Available since v3.1._
137      */
138     function functionCall(
139         address target,
140         bytes memory data,
141         string memory errorMessage
142     ) internal returns (bytes memory) {
143         return functionCallWithValue(target, data, 0, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
148      * but also transferring value wei to target.
149      *
150      * Requirements:
151      *
152      * - the calling contract must have an ETH balance of at least value.
153      * - the called Solidity function must be payable.
154      *
155      * _Available since v3.1._
156      */
157     function functionCallWithValue(
158         address target,
159         bytes memory data,
160         uint256 value
161     ) internal returns (bytes memory) {
162         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
167      * with errorMessage as a fallback revert reason when target reverts.
168      *
169      * _Available since v3.1._
170      */
171     function functionCallWithValue(
172         address target,
173         bytes memory data,
174         uint256 value,
175         string memory errorMessage
176     ) internal returns (bytes memory) {
177         require(address(this).balance >= value, "Address: insufficient balance for call");
178         require(isContract(target), "Address: call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.call{value: value}(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
186      * but performing a static call.
187      *
188      * _Available since v3.3._
189      */
190     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
191         return functionStaticCall(target, data, "Address: low-level static call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
196      * but performing a static call.
197      *
198      * _Available since v3.3._
199      */
200     function functionStaticCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal view returns (bytes memory) {
205         require(isContract(target), "Address: static call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.staticcall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
213      * but performing a delegate call.
214      *
215      * _Available since v3.4._
216      */
217     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
223      * but performing a delegate call.
224      *
225      * _Available since v3.4._
226      */
227     function functionDelegateCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         require(isContract(target), "Address: delegate call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.delegatecall(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
240      * revert reason using the provided one.
241      *
242      * _Available since v4.3._
243      */
244     function verifyCallResult(
245         bool success,
246         bytes memory returndata,
247         string memory errorMessage
248     ) internal pure returns (bytes memory) {
249         if (success) {
250             return returndata;
251         } else {
252             // Look for revert reason and bubble it up if present
253             if (returndata.length > 0) {
254                 // The easiest way to bubble the revert reason is using memory via assembly
255 
256                 assembly {
257                     let returndata_size := mload(returndata)
258                     revert(add(32, returndata), returndata_size)
259                 }
260             } else {
261                 revert(errorMessage);
262             }
263         }
264     }
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @title ERC721 token receiver interface
276  * @dev Interface for any contract that wants to support safeTransfers
277  * from ERC721 asset contracts.
278  */
279 interface IERC721Receiver {
280     /**
281      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
282      * by operator from from, this function is called.
283      *
284      * It must return its Solidity selector to confirm the token transfer.
285      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
286      *
287      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
288      */
289     function onERC721Received(
290         address operator,
291         address from,
292         uint256 tokenId,
293         bytes calldata data
294     ) external returns (bytes4);
295 }
296 
297 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Interface of the ERC165 standard, as defined in the
306  * https://eips.ethereum.org/EIPS/eip-165[EIP].
307  *
308  * Implementers can declare support of contract interfaces, which can then be
309  * queried by others ({ERC165Checker}).
310  *
311  * For an implementation, see {ERC165}.
312  */
313 interface IERC165 {
314     /**
315      * @dev Returns true if this contract implements the interface defined by
316      * interfaceId. See the corresponding
317      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
318      * to learn more about how these ids are created.
319      *
320      * This function call must use less than 30 000 gas.
321      */
322     function supportsInterface(bytes4 interfaceId) external view returns (bool);
323 }
324 
325 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 
333 /**
334  * @dev Implementation of the {IERC165} interface.
335  *
336  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
337  * for the additional interface id that will be supported. For example:
338  *
339  * solidity
340  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
341  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
342  * }
343  * 
344  *
345  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
346  */
347 abstract contract ERC165 is IERC165 {
348     /**
349      * @dev See {IERC165-supportsInterface}.
350      */
351     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352         return interfaceId == type(IERC165).interfaceId;
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 
364 /**
365  * @dev Required interface of an ERC721 compliant contract.
366  */
367 interface IERC721 is IERC165 {
368     /**
369      * @dev Emitted when tokenId token is transferred from from to to.
370      */
371     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
372 
373     /**
374      * @dev Emitted when owner enables approved to manage the tokenId token.
375      */
376     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
377 
378     /**
379      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
380      */
381     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
382 
383     /**
384      * @dev Returns the number of tokens in owner's account.
385      */
386     function balanceOf(address owner) external view returns (uint256 balance);
387 
388     /**
389      * @dev Returns the owner of the tokenId token.
390      *
391      * Requirements:
392      *
393      * - tokenId must exist.
394      */
395     function ownerOf(uint256 tokenId) external view returns (address owner);
396 
397     /**
398      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
399      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
400      *
401      * Requirements:
402      *
403      * - from cannot be the zero address.
404      * - to cannot be the zero address.
405      * - tokenId token must exist and be owned by from.
406      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
407      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
408      *
409      * Emits a {Transfer} event.
410      */
411     function safeTransferFrom(
412         address from,
413         address to,
414         uint256 tokenId
415     ) external;
416 
417     /**
418      * @dev Transfers tokenId token from from to to.
419      *
420      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
421      *
422      * Requirements:
423      *
424      * - from cannot be the zero address.
425      * - to cannot be the zero address.
426      * - tokenId token must be owned by from.
427      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transferFrom(
432         address from,
433         address to,
434         uint256 tokenId
435     ) external;
436 
437     /**
438      * @dev Gives permission to to to transfer tokenId token to another account.
439      * The approval is cleared when the token is transferred.
440      *
441      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
442      *
443      * Requirements:
444      *
445      * - The caller must own the token or be an approved operator.
446      * - tokenId must exist.
447      *
448      * Emits an {Approval} event.
449      */
450     function approve(address to, uint256 tokenId) external;
451 
452     /**
453      * @dev Returns the account approved for tokenId token.
454      *
455      * Requirements:
456      *
457      * - tokenId must exist.
458      */
459     function getApproved(uint256 tokenId) external view returns (address operator);
460 
461     /**
462      * @dev Approve or remove operator as an operator for the caller.
463      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
464      *
465      * Requirements:
466      *
467      * - The operator cannot be the caller.
468      *
469      * Emits an {ApprovalForAll} event.
470      */
471     function setApprovalForAll(address operator, bool _approved) external;
472 
473     /**
474      * @dev Returns if the operator is allowed to manage all of the assets of owner.
475      *
476      * See {setApprovalForAll}
477      */
478     function isApprovedForAll(address owner, address operator) external view returns (bool);
479 
480     /**
481      * @dev Safely transfers tokenId token from from to to.
482      *
483      * Requirements:
484      *
485      * - from cannot be the zero address.
486      * - to cannot be the zero address.
487      * - tokenId token must exist and be owned by from.
488      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
489      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
490      *
491      * Emits a {Transfer} event.
492      */
493     function safeTransferFrom(
494         address from,
495         address to,
496         uint256 tokenId,
497         bytes calldata data
498     ) external;
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
511  * @dev See https://eips.ethereum.org/EIPS/eip-721
512  */
513 interface IERC721Enumerable is IERC721 {
514     /**
515      * @dev Returns the total amount of tokens stored by the contract.
516      */
517     function totalSupply() external view returns (uint256);
518 
519     /**
520      * @dev Returns a token ID owned by owner at a given index of its token list.
521      * Use along with {balanceOf} to enumerate all of owner's tokens.
522      */
523     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
524 
525     /**
526      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
527      * Use along with {totalSupply} to enumerate all tokens.
528      */
529     function tokenByIndex(uint256 index) external view returns (uint256);
530 }
531 
532 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
542  * @dev See https://eips.ethereum.org/EIPS/eip-721
543  */
544 interface IERC721Metadata is IERC721 {
545     /**
546      * @dev Returns the token collection name.
547      */
548     function name() external view returns (string memory);
549 
550     /**
551      * @dev Returns the token collection symbol.
552      */
553     function symbol() external view returns (string memory);
554 
555     /**
556      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
557      */
558     function tokenURI(uint256 tokenId) external view returns (string memory);
559 }
560 
561 // File: @openzeppelin/contracts/utils/Strings.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev String operations.
570  */
571 library Strings {
572     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
573 
574     /**
575      * @dev Converts a uint256 to its ASCII string decimal representation.
576      */
577     function toString(uint256 value) internal pure returns (string memory) {
578         // Inspired by OraclizeAPI's implementation - MIT licence
579         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
580 
581         if (value == 0) {
582             return "0";
583         }
584         uint256 temp = value;
585         uint256 digits;
586         while (temp != 0) {
587             digits++;
588             temp /= 10;
589         }
590         bytes memory buffer = new bytes(digits);
591         while (value != 0) {
592             digits -= 1;
593             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
594             value /= 10;
595         }
596         return string(buffer);
597     }
598 
599     /**
600      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
601      */
602     function toHexString(uint256 value) internal pure returns (string memory) {
603         if (value == 0) {
604             return "0x00";
605         }
606         uint256 temp = value;
607         uint256 length = 0;
608         while (temp != 0) {
609             length++;
610             temp >>= 8;
611         }
612         return toHexString(value, length);
613     }
614 
615     /**
616      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
617      */
618     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
619         bytes memory buffer = new bytes(2 * length + 2);
620         buffer[0] = "0";
621         buffer[1] = "x";
622         for (uint256 i = 2 * length + 1; i > 1; --i) {
623             buffer[i] = _HEX_SYMBOLS[value & 0xf];
624             value >>= 4;
625         }
626         require(value == 0, "Strings: hex length insufficient");
627         return string(buffer);
628     }
629 }
630 
631 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
632 
633 
634 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Contract module that helps prevent reentrant calls to a function.
640  *
641  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
642  * available, which can be applied to functions to make sure there are no nested
643  * (reentrant) calls to them.
644  *
645  * Note that because there is a single nonReentrant guard, functions marked as
646  * nonReentrant may not call one another. This can be worked around by making
647  * those functions private, and then adding external nonReentrant entry
648  * points to them.
649  *
650  * TIP: If you would like to learn more about reentrancy and alternative ways
651  * to protect against it, check out our blog post
652  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
653  */
654 abstract contract ReentrancyGuard {
655     // Booleans are more expensive than uint256 or any type that takes up a full
656     // word because each write operation emits an extra SLOAD to first read the
657     // slot's contents, replace the bits taken up by the boolean, and then write
658     // back. This is the compiler's defense against contract upgrades and
659     // pointer aliasing, and it cannot be disabled.
660 
661     // The values being non-zero value makes deployment a bit more expensive,
662     // but in exchange the refund on every call to nonReentrant will be lower in
663     // amount. Since refunds are capped to a percentage of the total
664     // transaction's gas, it is best to keep them low in cases like this one, to
665     // increase the likelihood of the full refund coming into effect.
666     uint256 private constant _NOT_ENTERED = 1;
667     uint256 private constant _ENTERED = 2;
668 
669     uint256 private _status;
670 
671     constructor() {
672         _status = _NOT_ENTERED;
673     }
674 
675     /**
676      * @dev Prevents a contract from calling itself, directly or indirectly.
677      * Calling a nonReentrant function from another nonReentrant
678      * function is not supported. It is possible to prevent this from happening
679      * by making the nonReentrant function external, and making it call a
680      * private function that does the actual work.
681      */
682     modifier nonReentrant() {
683         // On the first call to nonReentrant, _notEntered will be true
684         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
685 
686         // Any calls to nonReentrant after this point will fail
687         _status = _ENTERED;
688 
689         _;
690 
691         // By storing the original value once again, a refund is triggered (see
692         // https://eips.ethereum.org/EIPS/eip-2200)
693         _status = _NOT_ENTERED;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/utils/Context.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 /**
705  * @dev Provides information about the current execution context, including the
706  * sender of the transaction and its data. While these are generally available
707  * via msg.sender and msg.data, they should not be accessed in such a direct
708  * manner, since when dealing with meta-transactions the account sending and
709  * paying for execution may not be the actual sender (as far as an application
710  * is concerned).
711  *
712  * This contract is only required for intermediate, library-like contracts.
713  */
714 abstract contract Context {
715     function _msgSender() internal view virtual returns (address) {
716         return msg.sender;
717     }
718 
719     function _msgData() internal view virtual returns (bytes calldata) {
720         return msg.data;
721     }
722 }
723 
724 // File: @openzeppelin/contracts/access/Ownable.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Contract module which provides a basic access control mechanism, where
734  * there is an account (an owner) that can be granted exclusive access to
735  * specific functions.
736  *
737  * By default, the owner account will be the one that deploys the contract. This
738  * can later be changed with {transferOwnership}.
739  *
740  * This module is used through inheritance. It will make available the modifier
741  * onlyOwner, which can be applied to your functions to restrict their use to
742  * the owner.
743  */
744 abstract contract Ownable is Context {
745     address private _owner;
746 
747     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
748 
749     /**
750      * @dev Initializes the contract setting the deployer as the initial owner.
751      */
752     constructor() {
753         _transferOwnership(_msgSender());
754     }
755 
756     /**
757      * @dev Returns the address of the current owner.
758      */
759     function owner() public view virtual returns (address) {
760         return _owner;
761     }
762 
763     /**
764      * @dev Throws if called by any account other than the owner.
765      */
766     function _onlyOwner() private view {
767        require(owner() == _msgSender(), "Ownable: caller is not the owner");
768     }
769 
770     modifier onlyOwner() {
771         _onlyOwner();
772         _;
773     }
774 
775     /**
776      * @dev Leaves the contract without owner. It will not be possible to call
777      * onlyOwner functions anymore. Can only be called by the current owner.
778      *
779      * NOTE: Renouncing ownership will leave the contract without an owner,
780      * thereby removing any functionality that is only available to the owner.
781      */
782     function renounceOwnership() public virtual onlyOwner {
783         _transferOwnership(address(0));
784     }
785 
786     /**
787      * @dev Transfers ownership of the contract to a new account (newOwner).
788      * Can only be called by the current owner.
789      */
790     function transferOwnership(address newOwner) public virtual onlyOwner {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         _transferOwnership(newOwner);
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (newOwner).
797      * Internal function without access restriction.
798      */
799     function _transferOwnership(address newOwner) internal virtual {
800         address oldOwner = _owner;
801         _owner = newOwner;
802         emit OwnershipTransferred(oldOwner, newOwner);
803     }
804 }
805 
806 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
807 pragma solidity ^0.8.9;
808 
809 interface IOperatorFilterRegistry {
810     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
811     function register(address registrant) external;
812     function registerAndSubscribe(address registrant, address subscription) external;
813     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
814     function updateOperator(address registrant, address operator, bool filtered) external;
815     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
816     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
817     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
818     function subscribe(address registrant, address registrantToSubscribe) external;
819     function unsubscribe(address registrant, bool copyExistingEntries) external;
820     function subscriptionOf(address addr) external returns (address registrant);
821     function subscribers(address registrant) external returns (address[] memory);
822     function subscriberAt(address registrant, uint256 index) external returns (address);
823     function copyEntriesOf(address registrant, address registrantToCopy) external;
824     function isOperatorFiltered(address registrant, address operator) external returns (bool);
825     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
826     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
827     function filteredOperators(address addr) external returns (address[] memory);
828     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
829     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
830     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
831     function isRegistered(address addr) external returns (bool);
832     function codeHashOf(address addr) external returns (bytes32);
833 }
834 
835 // File contracts/OperatorFilter/OperatorFilterer.sol
836 pragma solidity ^0.8.9;
837 
838 abstract contract OperatorFilterer {
839     error OperatorNotAllowed(address operator);
840 
841     IOperatorFilterRegistry constant operatorFilterRegistry =
842         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
843 
844     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
845         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
846         // will not revert, but the contract will need to be registered with the registry once it is deployed in
847         // order for the modifier to filter addresses.
848         if (address(operatorFilterRegistry).code.length > 0) {
849             if (subscribe) {
850                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
851             } else {
852                 if (subscriptionOrRegistrantToCopy != address(0)) {
853                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
854                 } else {
855                     operatorFilterRegistry.register(address(this));
856                 }
857             }
858         }
859     }
860 
861     function _onlyAllowedOperator(address from) private view {
862       if (
863           !(
864               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
865               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
866           )
867       ) {
868           revert OperatorNotAllowed(msg.sender);
869       }
870     }
871 
872     modifier onlyAllowedOperator(address from) virtual {
873         // Check registry code length to facilitate testing in environments without a deployed registry.
874         if (address(operatorFilterRegistry).code.length > 0) {
875             // Allow spending tokens from addresses with balance
876             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
877             // from an EOA.
878             if (from == msg.sender) {
879                 _;
880                 return;
881             }
882             _onlyAllowedOperator(from);
883         }
884         _;
885     }
886 
887     modifier onlyAllowedOperatorApproval(address operator) virtual {
888         _checkFilterOperator(operator);
889         _;
890     }
891 
892     function _checkFilterOperator(address operator) internal view virtual {
893         // Check registry code length to facilitate testing in environments without a deployed registry.
894         if (address(operatorFilterRegistry).code.length > 0) {
895             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
896                 revert OperatorNotAllowed(operator);
897             }
898         }
899     }
900 }
901 
902 //-------------END DEPENDENCIES------------------------//
903 
904 
905   
906 error TransactionCapExceeded();
907 error PublicMintingClosed();
908 error ExcessiveOwnedMints();
909 error MintZeroQuantity();
910 error InvalidPayment();
911 error CapExceeded();
912 error IsAlreadyUnveiled();
913 error ValueCannotBeZero();
914 error CannotBeNullAddress();
915 error NoStateChange();
916 
917 error PublicMintClosed();
918 error AllowlistMintClosed();
919 
920 error AddressNotAllowlisted();
921 error AllowlistDropTimeHasNotPassed();
922 error PublicDropTimeHasNotPassed();
923 error DropTimeNotInFuture();
924 
925 error OnlyERC20MintingEnabled();
926 error ERC20TokenNotApproved();
927 error ERC20InsufficientBalance();
928 error ERC20InsufficientAllowance();
929 error ERC20TransferFailed();
930 
931 error ClaimModeDisabled();
932 error IneligibleRedemptionContract();
933 error TokenAlreadyRedeemed();
934 error InvalidOwnerForRedemption();
935 error InvalidApprovalForRedemption();
936 
937 error ERC721RestrictedApprovalAddressRestricted();
938   
939   
940 // Rampp Contracts v2.1 (Teams.sol)
941 
942 error InvalidTeamAddress();
943 error DuplicateTeamAddress();
944 pragma solidity ^0.8.0;
945 
946 /**
947 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
948 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
949 * This will easily allow cross-collaboration via Mintplex.xyz.
950 **/
951 abstract contract Teams is Ownable{
952   mapping (address => bool) internal team;
953 
954   /**
955   * @dev Adds an address to the team. Allows them to execute protected functions
956   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
957   **/
958   function addToTeam(address _address) public onlyOwner {
959     if(_address == address(0)) revert InvalidTeamAddress();
960     if(inTeam(_address)) revert DuplicateTeamAddress();
961   
962     team[_address] = true;
963   }
964 
965   /**
966   * @dev Removes an address to the team.
967   * @param _address the ETH address to remove, cannot be 0x and must be in team
968   **/
969   function removeFromTeam(address _address) public onlyOwner {
970     if(_address == address(0)) revert InvalidTeamAddress();
971     if(!inTeam(_address)) revert InvalidTeamAddress();
972   
973     team[_address] = false;
974   }
975 
976   /**
977   * @dev Check if an address is valid and active in the team
978   * @param _address ETH address to check for truthiness
979   **/
980   function inTeam(address _address)
981     public
982     view
983     returns (bool)
984   {
985     if(_address == address(0)) revert InvalidTeamAddress();
986     return team[_address] == true;
987   }
988 
989   /**
990   * @dev Throws if called by any account other than the owner or team member.
991   */
992   function _onlyTeamOrOwner() private view {
993     bool _isOwner = owner() == _msgSender();
994     bool _isTeam = inTeam(_msgSender());
995     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
996   }
997 
998   modifier onlyTeamOrOwner() {
999     _onlyTeamOrOwner();
1000     _;
1001   }
1002 }
1003 
1004 
1005   
1006   pragma solidity ^0.8.0;
1007 
1008   /**
1009   * @dev These functions deal with verification of Merkle Trees proofs.
1010   *
1011   * The proofs can be generated using the JavaScript library
1012   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1013   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1014   *
1015   *
1016   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1017   * hashing, or use a hash function other than keccak256 for hashing leaves.
1018   * This is because the concatenation of a sorted pair of internal nodes in
1019   * the merkle tree could be reinterpreted as a leaf value.
1020   */
1021   library MerkleProof {
1022       /**
1023       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1024       * defined by 'root'. For this, a 'proof' must be provided, containing
1025       * sibling hashes on the branch from the leaf to the root of the tree. Each
1026       * pair of leaves and each pair of pre-images are assumed to be sorted.
1027       */
1028       function verify(
1029           bytes32[] memory proof,
1030           bytes32 root,
1031           bytes32 leaf
1032       ) internal pure returns (bool) {
1033           return processProof(proof, leaf) == root;
1034       }
1035 
1036       /**
1037       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1038       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1039       * hash matches the root of the tree. When processing the proof, the pairs
1040       * of leafs & pre-images are assumed to be sorted.
1041       *
1042       * _Available since v4.4._
1043       */
1044       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1045           bytes32 computedHash = leaf;
1046           for (uint256 i = 0; i < proof.length; i++) {
1047               bytes32 proofElement = proof[i];
1048               if (computedHash <= proofElement) {
1049                   // Hash(current computed hash + current element of the proof)
1050                   computedHash = _efficientHash(computedHash, proofElement);
1051               } else {
1052                   // Hash(current element of the proof + current computed hash)
1053                   computedHash = _efficientHash(proofElement, computedHash);
1054               }
1055           }
1056           return computedHash;
1057       }
1058 
1059       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1060           assembly {
1061               mstore(0x00, a)
1062               mstore(0x20, b)
1063               value := keccak256(0x00, 0x40)
1064           }
1065       }
1066   }
1067 
1068 
1069   // File: Allowlist.sol
1070 
1071   pragma solidity ^0.8.0;
1072 
1073   abstract contract Allowlist is Teams {
1074     bytes32 public merkleRoot;
1075     bool public onlyAllowlistMode = false;
1076 
1077     /**
1078      * @dev Update merkle root to reflect changes in Allowlist
1079      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1080      */
1081     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1082       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1083       merkleRoot = _newMerkleRoot;
1084     }
1085 
1086     /**
1087      * @dev Check the proof of an address if valid for merkle root
1088      * @param _to address to check for proof
1089      * @param _merkleProof Proof of the address to validate against root and leaf
1090      */
1091     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1092       if(merkleRoot == 0) revert ValueCannotBeZero();
1093       bytes32 leaf = keccak256(abi.encodePacked(_to));
1094 
1095       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1096     }
1097 
1098     
1099     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1100       onlyAllowlistMode = true;
1101     }
1102 
1103     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1104         onlyAllowlistMode = false;
1105     }
1106   }
1107   
1108   
1109 /**
1110  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1111  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1112  *
1113  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1114  * 
1115  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1116  *
1117  * Does not support burning tokens to address(0).
1118  */
1119 contract ERC721A is
1120   Context,
1121   ERC165,
1122   IERC721,
1123   IERC721Metadata,
1124   IERC721Enumerable,
1125   Teams
1126   , OperatorFilterer
1127 {
1128   using Address for address;
1129   using Strings for uint256;
1130 
1131   struct TokenOwnership {
1132     address addr;
1133     uint64 startTimestamp;
1134   }
1135 
1136   struct AddressData {
1137     uint128 balance;
1138     uint128 numberMinted;
1139   }
1140 
1141   uint256 private currentIndex;
1142 
1143   uint256 public immutable collectionSize;
1144   uint256 public maxBatchSize;
1145 
1146   // Token name
1147   string private _name;
1148 
1149   // Token symbol
1150   string private _symbol;
1151 
1152   // Mapping from token ID to ownership details
1153   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1154   mapping(uint256 => TokenOwnership) private _ownerships;
1155 
1156   // Mapping owner address to address data
1157   mapping(address => AddressData) private _addressData;
1158 
1159   // Mapping from token ID to approved address
1160   mapping(uint256 => address) private _tokenApprovals;
1161 
1162   // Mapping from owner to operator approvals
1163   mapping(address => mapping(address => bool)) private _operatorApprovals;
1164 
1165   /* @dev Mapping of restricted operator approvals set by contract Owner
1166   * This serves as an optional addition to ERC-721 so
1167   * that the contract owner can elect to prevent specific addresses/contracts
1168   * from being marked as the approver for a token. The reason for this
1169   * is that some projects may want to retain control of where their tokens can/can not be listed
1170   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1171   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1172   */
1173   mapping(address => bool) public restrictedApprovalAddresses;
1174 
1175   /**
1176    * @dev
1177    * maxBatchSize refers to how much a minter can mint at a time.
1178    * collectionSize_ refers to how many tokens are in the collection.
1179    */
1180   constructor(
1181     string memory name_,
1182     string memory symbol_,
1183     uint256 maxBatchSize_,
1184     uint256 collectionSize_
1185   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1186     require(
1187       collectionSize_ > 0,
1188       "ERC721A: collection must have a nonzero supply"
1189     );
1190     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1191     _name = name_;
1192     _symbol = symbol_;
1193     maxBatchSize = maxBatchSize_;
1194     collectionSize = collectionSize_;
1195     currentIndex = _startTokenId();
1196   }
1197 
1198   /**
1199   * To change the starting tokenId, please override this function.
1200   */
1201   function _startTokenId() internal view virtual returns (uint256) {
1202     return 1;
1203   }
1204 
1205   /**
1206    * @dev See {IERC721Enumerable-totalSupply}.
1207    */
1208   function totalSupply() public view override returns (uint256) {
1209     return _totalMinted();
1210   }
1211 
1212   function currentTokenId() public view returns (uint256) {
1213     return _totalMinted();
1214   }
1215 
1216   function getNextTokenId() public view returns (uint256) {
1217       return _totalMinted() + 1;
1218   }
1219 
1220   /**
1221   * Returns the total amount of tokens minted in the contract.
1222   */
1223   function _totalMinted() internal view returns (uint256) {
1224     unchecked {
1225       return currentIndex - _startTokenId();
1226     }
1227   }
1228 
1229   /**
1230    * @dev See {IERC721Enumerable-tokenByIndex}.
1231    */
1232   function tokenByIndex(uint256 index) public view override returns (uint256) {
1233     require(index < totalSupply(), "ERC721A: global index out of bounds");
1234     return index;
1235   }
1236 
1237   /**
1238    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1239    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1240    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1241    */
1242   function tokenOfOwnerByIndex(address owner, uint256 index)
1243     public
1244     view
1245     override
1246     returns (uint256)
1247   {
1248     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1249     uint256 numMintedSoFar = totalSupply();
1250     uint256 tokenIdsIdx = 0;
1251     address currOwnershipAddr = address(0);
1252     for (uint256 i = 0; i < numMintedSoFar; i++) {
1253       TokenOwnership memory ownership = _ownerships[i];
1254       if (ownership.addr != address(0)) {
1255         currOwnershipAddr = ownership.addr;
1256       }
1257       if (currOwnershipAddr == owner) {
1258         if (tokenIdsIdx == index) {
1259           return i;
1260         }
1261         tokenIdsIdx++;
1262       }
1263     }
1264     revert("ERC721A: unable to get token of owner by index");
1265   }
1266 
1267   /**
1268    * @dev See {IERC165-supportsInterface}.
1269    */
1270   function supportsInterface(bytes4 interfaceId)
1271     public
1272     view
1273     virtual
1274     override(ERC165, IERC165)
1275     returns (bool)
1276   {
1277     return
1278       interfaceId == type(IERC721).interfaceId ||
1279       interfaceId == type(IERC721Metadata).interfaceId ||
1280       interfaceId == type(IERC721Enumerable).interfaceId ||
1281       super.supportsInterface(interfaceId);
1282   }
1283 
1284   /**
1285    * @dev See {IERC721-balanceOf}.
1286    */
1287   function balanceOf(address owner) public view override returns (uint256) {
1288     require(owner != address(0), "ERC721A: balance query for the zero address");
1289     return uint256(_addressData[owner].balance);
1290   }
1291 
1292   function _numberMinted(address owner) internal view returns (uint256) {
1293     require(
1294       owner != address(0),
1295       "ERC721A: number minted query for the zero address"
1296     );
1297     return uint256(_addressData[owner].numberMinted);
1298   }
1299 
1300   function ownershipOf(uint256 tokenId)
1301     internal
1302     view
1303     returns (TokenOwnership memory)
1304   {
1305     uint256 curr = tokenId;
1306 
1307     unchecked {
1308         if (_startTokenId() <= curr && curr < currentIndex) {
1309             TokenOwnership memory ownership = _ownerships[curr];
1310             if (ownership.addr != address(0)) {
1311                 return ownership;
1312             }
1313 
1314             // Invariant:
1315             // There will always be an ownership that has an address and is not burned
1316             // before an ownership that does not have an address and is not burned.
1317             // Hence, curr will not underflow.
1318             while (true) {
1319                 curr--;
1320                 ownership = _ownerships[curr];
1321                 if (ownership.addr != address(0)) {
1322                     return ownership;
1323                 }
1324             }
1325         }
1326     }
1327 
1328     revert("ERC721A: unable to determine the owner of token");
1329   }
1330 
1331   /**
1332    * @dev See {IERC721-ownerOf}.
1333    */
1334   function ownerOf(uint256 tokenId) public view override returns (address) {
1335     return ownershipOf(tokenId).addr;
1336   }
1337 
1338   /**
1339    * @dev See {IERC721Metadata-name}.
1340    */
1341   function name() public view virtual override returns (string memory) {
1342     return _name;
1343   }
1344 
1345   /**
1346    * @dev See {IERC721Metadata-symbol}.
1347    */
1348   function symbol() public view virtual override returns (string memory) {
1349     return _symbol;
1350   }
1351 
1352   /**
1353    * @dev See {IERC721Metadata-tokenURI}.
1354    */
1355   function tokenURI(uint256 tokenId)
1356     public
1357     view
1358     virtual
1359     override
1360     returns (string memory)
1361   {
1362     string memory baseURI = _baseURI();
1363     string memory extension = _baseURIExtension();
1364     return
1365       bytes(baseURI).length > 0
1366         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1367         : "";
1368   }
1369 
1370   /**
1371    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1372    * token will be the concatenation of the baseURI and the tokenId. Empty
1373    * by default, can be overriden in child contracts.
1374    */
1375   function _baseURI() internal view virtual returns (string memory) {
1376     return "";
1377   }
1378 
1379   /**
1380    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1381    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1382    * by default, can be overriden in child contracts.
1383    */
1384   function _baseURIExtension() internal view virtual returns (string memory) {
1385     return "";
1386   }
1387 
1388   /**
1389    * @dev Sets the value for an address to be in the restricted approval address pool.
1390    * Setting an address to true will disable token owners from being able to mark the address
1391    * for approval for trading. This would be used in theory to prevent token owners from listing
1392    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1393    * @param _address the marketplace/user to modify restriction status of
1394    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1395    */
1396   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1397     restrictedApprovalAddresses[_address] = _isRestricted;
1398   }
1399 
1400   /**
1401    * @dev See {IERC721-approve}.
1402    */
1403   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1404     address owner = ERC721A.ownerOf(tokenId);
1405     require(to != owner, "ERC721A: approval to current owner");
1406     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1407 
1408     require(
1409       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1410       "ERC721A: approve caller is not owner nor approved for all"
1411     );
1412 
1413     _approve(to, tokenId, owner);
1414   }
1415 
1416   /**
1417    * @dev See {IERC721-getApproved}.
1418    */
1419   function getApproved(uint256 tokenId) public view override returns (address) {
1420     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1421 
1422     return _tokenApprovals[tokenId];
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-setApprovalForAll}.
1427    */
1428   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1429     require(operator != _msgSender(), "ERC721A: approve to caller");
1430     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1431 
1432     _operatorApprovals[_msgSender()][operator] = approved;
1433     emit ApprovalForAll(_msgSender(), operator, approved);
1434   }
1435 
1436   /**
1437    * @dev See {IERC721-isApprovedForAll}.
1438    */
1439   function isApprovedForAll(address owner, address operator)
1440     public
1441     view
1442     virtual
1443     override
1444     returns (bool)
1445   {
1446     return _operatorApprovals[owner][operator];
1447   }
1448 
1449   /**
1450    * @dev See {IERC721-transferFrom}.
1451    */
1452   function transferFrom(
1453     address from,
1454     address to,
1455     uint256 tokenId
1456   ) public override onlyAllowedOperator(from) {
1457     _transfer(from, to, tokenId);
1458   }
1459 
1460   /**
1461    * @dev See {IERC721-safeTransferFrom}.
1462    */
1463   function safeTransferFrom(
1464     address from,
1465     address to,
1466     uint256 tokenId
1467   ) public override onlyAllowedOperator(from) {
1468     safeTransferFrom(from, to, tokenId, "");
1469   }
1470 
1471   /**
1472    * @dev See {IERC721-safeTransferFrom}.
1473    */
1474   function safeTransferFrom(
1475     address from,
1476     address to,
1477     uint256 tokenId,
1478     bytes memory _data
1479   ) public override onlyAllowedOperator(from) {
1480     _transfer(from, to, tokenId);
1481     require(
1482       _checkOnERC721Received(from, to, tokenId, _data),
1483       "ERC721A: transfer to non ERC721Receiver implementer"
1484     );
1485   }
1486 
1487   /**
1488    * @dev Returns whether tokenId exists.
1489    *
1490    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1491    *
1492    * Tokens start existing when they are minted (_mint),
1493    */
1494   function _exists(uint256 tokenId) internal view returns (bool) {
1495     return _startTokenId() <= tokenId && tokenId < currentIndex;
1496   }
1497 
1498   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1499     _safeMint(to, quantity, isAdminMint, "");
1500   }
1501 
1502   /**
1503    * @dev Mints quantity tokens and transfers them to to.
1504    *
1505    * Requirements:
1506    *
1507    * - there must be quantity tokens remaining unminted in the total collection.
1508    * - to cannot be the zero address.
1509    * - quantity cannot be larger than the max batch size.
1510    *
1511    * Emits a {Transfer} event.
1512    */
1513   function _safeMint(
1514     address to,
1515     uint256 quantity,
1516     bool isAdminMint,
1517     bytes memory _data
1518   ) internal {
1519     uint256 startTokenId = currentIndex;
1520     require(to != address(0), "ERC721A: mint to the zero address");
1521     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1522     require(!_exists(startTokenId), "ERC721A: token already minted");
1523 
1524     // For admin mints we do not want to enforce the maxBatchSize limit
1525     if (isAdminMint == false) {
1526         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1527     }
1528 
1529     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1530 
1531     AddressData memory addressData = _addressData[to];
1532     _addressData[to] = AddressData(
1533       addressData.balance + uint128(quantity),
1534       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1535     );
1536     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1537 
1538     uint256 updatedIndex = startTokenId;
1539 
1540     for (uint256 i = 0; i < quantity; i++) {
1541       emit Transfer(address(0), to, updatedIndex);
1542       require(
1543         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1544         "ERC721A: transfer to non ERC721Receiver implementer"
1545       );
1546       updatedIndex++;
1547     }
1548 
1549     currentIndex = updatedIndex;
1550     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1551   }
1552 
1553   /**
1554    * @dev Transfers tokenId from from to to.
1555    *
1556    * Requirements:
1557    *
1558    * - to cannot be the zero address.
1559    * - tokenId token must be owned by from.
1560    *
1561    * Emits a {Transfer} event.
1562    */
1563   function _transfer(
1564     address from,
1565     address to,
1566     uint256 tokenId
1567   ) private {
1568     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1569 
1570     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1571       getApproved(tokenId) == _msgSender() ||
1572       isApprovedForAll(prevOwnership.addr, _msgSender()));
1573 
1574     require(
1575       isApprovedOrOwner,
1576       "ERC721A: transfer caller is not owner nor approved"
1577     );
1578 
1579     require(
1580       prevOwnership.addr == from,
1581       "ERC721A: transfer from incorrect owner"
1582     );
1583     require(to != address(0), "ERC721A: transfer to the zero address");
1584 
1585     _beforeTokenTransfers(from, to, tokenId, 1);
1586 
1587     // Clear approvals from the previous owner
1588     _approve(address(0), tokenId, prevOwnership.addr);
1589 
1590     _addressData[from].balance -= 1;
1591     _addressData[to].balance += 1;
1592     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1593 
1594     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1595     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1596     uint256 nextTokenId = tokenId + 1;
1597     if (_ownerships[nextTokenId].addr == address(0)) {
1598       if (_exists(nextTokenId)) {
1599         _ownerships[nextTokenId] = TokenOwnership(
1600           prevOwnership.addr,
1601           prevOwnership.startTimestamp
1602         );
1603       }
1604     }
1605 
1606     emit Transfer(from, to, tokenId);
1607     _afterTokenTransfers(from, to, tokenId, 1);
1608   }
1609 
1610   /**
1611    * @dev Approve to to operate on tokenId
1612    *
1613    * Emits a {Approval} event.
1614    */
1615   function _approve(
1616     address to,
1617     uint256 tokenId,
1618     address owner
1619   ) private {
1620     _tokenApprovals[tokenId] = to;
1621     emit Approval(owner, to, tokenId);
1622   }
1623 
1624   uint256 public nextOwnerToExplicitlySet = 0;
1625 
1626   /**
1627    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1628    */
1629   function _setOwnersExplicit(uint256 quantity) internal {
1630     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1631     require(quantity > 0, "quantity must be nonzero");
1632     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1633 
1634     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1635     if (endIndex > collectionSize - 1) {
1636       endIndex = collectionSize - 1;
1637     }
1638     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1639     require(_exists(endIndex), "not enough minted yet for this cleanup");
1640     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1641       if (_ownerships[i].addr == address(0)) {
1642         TokenOwnership memory ownership = ownershipOf(i);
1643         _ownerships[i] = TokenOwnership(
1644           ownership.addr,
1645           ownership.startTimestamp
1646         );
1647       }
1648     }
1649     nextOwnerToExplicitlySet = endIndex + 1;
1650   }
1651 
1652   /**
1653    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1654    * The call is not executed if the target address is not a contract.
1655    *
1656    * @param from address representing the previous owner of the given token ID
1657    * @param to target address that will receive the tokens
1658    * @param tokenId uint256 ID of the token to be transferred
1659    * @param _data bytes optional data to send along with the call
1660    * @return bool whether the call correctly returned the expected magic value
1661    */
1662   function _checkOnERC721Received(
1663     address from,
1664     address to,
1665     uint256 tokenId,
1666     bytes memory _data
1667   ) private returns (bool) {
1668     if (to.isContract()) {
1669       try
1670         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1671       returns (bytes4 retval) {
1672         return retval == IERC721Receiver(to).onERC721Received.selector;
1673       } catch (bytes memory reason) {
1674         if (reason.length == 0) {
1675           revert("ERC721A: transfer to non ERC721Receiver implementer");
1676         } else {
1677           assembly {
1678             revert(add(32, reason), mload(reason))
1679           }
1680         }
1681       }
1682     } else {
1683       return true;
1684     }
1685   }
1686 
1687   /**
1688    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1689    *
1690    * startTokenId - the first token id to be transferred
1691    * quantity - the amount to be transferred
1692    *
1693    * Calling conditions:
1694    *
1695    * - When from and to are both non-zero, from's tokenId will be
1696    * transferred to to.
1697    * - When from is zero, tokenId will be minted for to.
1698    */
1699   function _beforeTokenTransfers(
1700     address from,
1701     address to,
1702     uint256 startTokenId,
1703     uint256 quantity
1704   ) internal virtual {}
1705 
1706   /**
1707    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1708    * minting.
1709    *
1710    * startTokenId - the first token id to be transferred
1711    * quantity - the amount to be transferred
1712    *
1713    * Calling conditions:
1714    *
1715    * - when from and to are both non-zero.
1716    * - from and to are never both zero.
1717    */
1718   function _afterTokenTransfers(
1719     address from,
1720     address to,
1721     uint256 startTokenId,
1722     uint256 quantity
1723   ) internal virtual {}
1724 }
1725 
1726 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1727 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1728 // @notice -- See Medium article --
1729 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1730 abstract contract ERC721ARedemption is ERC721A {
1731   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1732   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1733 
1734   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1735   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1736   
1737   uint256 public redemptionSurcharge = 0 ether;
1738   bool public redemptionModeEnabled;
1739   bool public verifiedClaimModeEnabled;
1740   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1741   mapping(address => bool) public redemptionContracts;
1742   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1743 
1744   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1745   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1746     redemptionContracts[_contractAddress] = _status;
1747   }
1748 
1749   // @dev Allow owner/team to determine if contract is accepting redemption mints
1750   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1751     redemptionModeEnabled = _newStatus;
1752   }
1753 
1754   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1755   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1756     verifiedClaimModeEnabled = _newStatus;
1757   }
1758 
1759   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1760   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1761     redemptionSurcharge = _newSurchargeInWei;
1762   }
1763 
1764   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1765   // @notice Must be a wallet address or implement IERC721Receiver.
1766   // Cannot be null address as this will break any ERC-721A implementation without a proper
1767   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1768   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1769     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1770     redemptionAddress = _newRedemptionAddress;
1771   }
1772 
1773   /**
1774   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1775   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1776   * the contract owner or Team => redemptionAddress. 
1777   * @param tokenId the token to be redeemed.
1778   * Emits a {Redeemed} event.
1779   **/
1780   function redeem(address redemptionContract, uint256 tokenId) public payable {
1781     if(getNextTokenId() > collectionSize) revert CapExceeded();
1782     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1783     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1784     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1785     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1786     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1787     
1788     IERC721 _targetContract = IERC721(redemptionContract);
1789     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1790     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1791     
1792     // Warning: Since there is no standarized return value for transfers of ERC-721
1793     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1794     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1795     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1796     // but the NFT may not have been sent to the redemptionAddress.
1797     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1798     tokenRedemptions[redemptionContract][tokenId] = true;
1799 
1800     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1801     _safeMint(_msgSender(), 1, false);
1802   }
1803 
1804   /**
1805   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1806   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1807   * @param tokenId the token to be redeemed.
1808   * Emits a {VerifiedClaim} event.
1809   **/
1810   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1811     if(getNextTokenId() > collectionSize) revert CapExceeded();
1812     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1813     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1814     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1815     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1816     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1817     
1818     tokenRedemptions[redemptionContract][tokenId] = true;
1819     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1820     _safeMint(_msgSender(), 1, false);
1821   }
1822 }
1823 
1824 
1825   
1826   
1827 interface IERC20 {
1828   function allowance(address owner, address spender) external view returns (uint256);
1829   function transfer(address _to, uint256 _amount) external returns (bool);
1830   function balanceOf(address account) external view returns (uint256);
1831   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1832 }
1833 
1834 // File: WithdrawableV2
1835 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1836 // ERC-20 Payouts are limited to a single payout address. This feature 
1837 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1838 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1839 abstract contract WithdrawableV2 is Teams {
1840   struct acceptedERC20 {
1841     bool isActive;
1842     uint256 chargeAmount;
1843   }
1844 
1845   
1846   mapping(address => acceptedERC20) private allowedTokenContracts;
1847   address[] public payableAddresses = [0xAc08B4379bECbab5356A8180B59A9f28E2f474E6];
1848   address public erc20Payable = 0xAc08B4379bECbab5356A8180B59A9f28E2f474E6;
1849   uint256[] public payableFees = [100];
1850   uint256 public payableAddressCount = 1;
1851   bool public onlyERC20MintingMode;
1852   
1853 
1854   function withdrawAll() public onlyTeamOrOwner {
1855       if(address(this).balance == 0) revert ValueCannotBeZero();
1856       _withdrawAll(address(this).balance);
1857   }
1858 
1859   function _withdrawAll(uint256 balance) private {
1860       for(uint i=0; i < payableAddressCount; i++ ) {
1861           _widthdraw(
1862               payableAddresses[i],
1863               (balance * payableFees[i]) / 100
1864           );
1865       }
1866   }
1867   
1868   function _widthdraw(address _address, uint256 _amount) private {
1869       (bool success, ) = _address.call{value: _amount}("");
1870       require(success, "Transfer failed.");
1871   }
1872 
1873   /**
1874   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1875   * in the event ERC-20 tokens are paid to the contract for mints.
1876   * @param _tokenContract contract of ERC-20 token to withdraw
1877   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1878   */
1879   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1880     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1881     IERC20 tokenContract = IERC20(_tokenContract);
1882     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1883     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1884   }
1885 
1886   /**
1887   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1888   * @param _erc20TokenContract address of ERC-20 contract in question
1889   */
1890   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1891     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1892   }
1893 
1894   /**
1895   * @dev get the value of tokens to transfer for user of an ERC-20
1896   * @param _erc20TokenContract address of ERC-20 contract in question
1897   */
1898   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1899     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1900     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1901   }
1902 
1903   /**
1904   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1905   * @param _erc20TokenContract address of ERC-20 contract in question
1906   * @param _isActive default status of if contract should be allowed to accept payments
1907   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1908   */
1909   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1910     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1911     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1912   }
1913 
1914   /**
1915   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1916   * it will assume the default value of zero. This should not be used to create new payment tokens.
1917   * @param _erc20TokenContract address of ERC-20 contract in question
1918   */
1919   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1920     allowedTokenContracts[_erc20TokenContract].isActive = true;
1921   }
1922 
1923   /**
1924   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1925   * it will assume the default value of zero. This should not be used to create new payment tokens.
1926   * @param _erc20TokenContract address of ERC-20 contract in question
1927   */
1928   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1929     allowedTokenContracts[_erc20TokenContract].isActive = false;
1930   }
1931 
1932   /**
1933   * @dev Enable only ERC-20 payments for minting on this contract
1934   */
1935   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1936     onlyERC20MintingMode = true;
1937   }
1938 
1939   /**
1940   * @dev Disable only ERC-20 payments for minting on this contract
1941   */
1942   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1943     onlyERC20MintingMode = false;
1944   }
1945 
1946   /**
1947   * @dev Set the payout of the ERC-20 token payout to a specific address
1948   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1949   */
1950   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1951     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1952     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1953     erc20Payable = _newErc20Payable;
1954   }
1955 }
1956 
1957 
1958   
1959 // File: isFeeable.sol
1960 abstract contract Feeable is Teams {
1961   uint256 public PRICE = 0 ether;
1962 
1963   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1964     PRICE = _feeInWei;
1965   }
1966 
1967   function getPrice(uint256 _count) public view returns (uint256) {
1968     return PRICE * _count;
1969   }
1970 }
1971 
1972   
1973   
1974   
1975 abstract contract RamppERC721A is 
1976     Ownable,
1977     Teams,
1978     ERC721ARedemption,
1979     WithdrawableV2,
1980     ReentrancyGuard 
1981     , Feeable 
1982     , Allowlist 
1983     
1984 {
1985   constructor(
1986     string memory tokenName,
1987     string memory tokenSymbol
1988   ) ERC721A(tokenName, tokenSymbol, 1, 2200) { }
1989     uint8 constant public CONTRACT_VERSION = 2;
1990     string public _baseTokenURI = "https://ipfs.sprawlgame.net/ipfs/QmS2uit4Wa6TRGJLKUD1fd5pa85BAdBqWAekeqt7Lmy3Dr/";
1991     string public _baseTokenExtension = ".json";
1992 
1993     bool public mintingOpen = false;
1994     
1995     
1996     uint256 public MAX_WALLET_MINTS = 1;
1997 
1998   
1999     /////////////// Admin Mint Functions
2000     /**
2001      * @dev Mints a token to an address with a tokenURI.
2002      * This is owner only and allows a fee-free drop
2003      * @param _to address of the future owner of the token
2004      * @param _qty amount of tokens to drop the owner
2005      */
2006      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2007          if(_qty == 0) revert MintZeroQuantity();
2008          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2009          _safeMint(_to, _qty, true);
2010      }
2011 
2012   
2013     /////////////// PUBLIC MINT FUNCTIONS
2014     /**
2015     * @dev Mints tokens to an address in batch.
2016     * fee may or may not be required*
2017     * @param _to address of the future owner of the token
2018     * @param _amount number of tokens to mint
2019     */
2020     function mintToMultiple(address _to, uint256 _amount) public payable {
2021         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2022         if(_amount == 0) revert MintZeroQuantity();
2023         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2024         if(!mintingOpen) revert PublicMintClosed();
2025         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2026         
2027         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2028         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2029         if(msg.value != getPrice(_amount)) revert InvalidPayment();
2030 
2031         _safeMint(_to, _amount, false);
2032     }
2033 
2034     /**
2035      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2036      * fee may or may not be required*
2037      * @param _to address of the future owner of the token
2038      * @param _amount number of tokens to mint
2039      * @param _erc20TokenContract erc-20 token contract to mint with
2040      */
2041     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2042       if(_amount == 0) revert MintZeroQuantity();
2043       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2044       if(!mintingOpen) revert PublicMintClosed();
2045       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2046       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2047       
2048       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2049 
2050       // ERC-20 Specific pre-flight checks
2051       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2052       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2053       IERC20 payableToken = IERC20(_erc20TokenContract);
2054 
2055       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2056       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2057 
2058       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2059       if(!transferComplete) revert ERC20TransferFailed();
2060       
2061       _safeMint(_to, _amount, false);
2062     }
2063 
2064     function openMinting() public onlyTeamOrOwner {
2065         mintingOpen = true;
2066     }
2067 
2068     function stopMinting() public onlyTeamOrOwner {
2069         mintingOpen = false;
2070     }
2071 
2072   
2073     ///////////// ALLOWLIST MINTING FUNCTIONS
2074     /**
2075     * @dev Mints tokens to an address using an allowlist.
2076     * fee may or may not be required*
2077     * @param _to address of the future owner of the token
2078     * @param _amount number of tokens to mint
2079     * @param _merkleProof merkle proof array
2080     */
2081     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2082         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2083         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2084         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2085         if(_amount == 0) revert MintZeroQuantity();
2086         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2087         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2088         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2089         if(msg.value != getPrice(_amount)) revert InvalidPayment();
2090         
2091 
2092         _safeMint(_to, _amount, false);
2093     }
2094 
2095     /**
2096     * @dev Mints tokens to an address using an allowlist.
2097     * fee may or may not be required*
2098     * @param _to address of the future owner of the token
2099     * @param _amount number of tokens to mint
2100     * @param _merkleProof merkle proof array
2101     * @param _erc20TokenContract erc-20 token contract to mint with
2102     */
2103     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2104       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2105       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2106       if(_amount == 0) revert MintZeroQuantity();
2107       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2108       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2109       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2110       
2111     
2112       // ERC-20 Specific pre-flight checks
2113       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2114       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2115       IERC20 payableToken = IERC20(_erc20TokenContract);
2116 
2117       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2118       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2119 
2120       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2121       if(!transferComplete) revert ERC20TransferFailed();
2122       
2123       _safeMint(_to, _amount, false);
2124     }
2125 
2126     /**
2127      * @dev Enable allowlist minting fully by enabling both flags
2128      * This is a convenience function for the Rampp user
2129      */
2130     function openAllowlistMint() public onlyTeamOrOwner {
2131         enableAllowlistOnlyMode();
2132         mintingOpen = true;
2133     }
2134 
2135     /**
2136      * @dev Close allowlist minting fully by disabling both flags
2137      * This is a convenience function for the Rampp user
2138      */
2139     function closeAllowlistMint() public onlyTeamOrOwner {
2140         disableAllowlistOnlyMode();
2141         mintingOpen = false;
2142     }
2143 
2144 
2145   
2146     /**
2147     * @dev Check if wallet over MAX_WALLET_MINTS
2148     * @param _address address in question to check if minted count exceeds max
2149     */
2150     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2151         if(_amount == 0) revert ValueCannotBeZero();
2152         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2153     }
2154 
2155     /**
2156     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2157     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2158     */
2159     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2160         if(_newWalletMax == 0) revert ValueCannotBeZero();
2161         MAX_WALLET_MINTS = _newWalletMax;
2162     }
2163     
2164 
2165   
2166     /**
2167      * @dev Allows owner to set Max mints per tx
2168      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2169      */
2170      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2171          if(_newMaxMint == 0) revert ValueCannotBeZero();
2172          maxBatchSize = _newMaxMint;
2173      }
2174     
2175 
2176   
2177   
2178   
2179   function contractURI() public pure returns (string memory) {
2180     return "https://metadata.mintplex.xyz/S0bUKY7dTQ0E8meqWVcd/contract-metadata";
2181   }
2182   
2183 
2184   function _baseURI() internal view virtual override returns(string memory) {
2185     return _baseTokenURI;
2186   }
2187 
2188   function _baseURIExtension() internal view virtual override returns(string memory) {
2189     return _baseTokenExtension;
2190   }
2191 
2192   function baseTokenURI() public view returns(string memory) {
2193     return _baseTokenURI;
2194   }
2195 
2196   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2197     _baseTokenURI = baseURI;
2198   }
2199 
2200   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2201     _baseTokenExtension = baseExtension;
2202   }
2203 }
2204 
2205 
2206   
2207 // File: contracts/TheSprawlCityPassContract.sol
2208 //SPDX-License-Identifier: MIT
2209 
2210 pragma solidity ^0.8.0;
2211 
2212 contract TheSprawlCityPassContract is RamppERC721A {
2213     constructor() RamppERC721A("The Sprawl City Pass", "SPRLCP"){}
2214 }
2215   
2216 //*********************************************************************//
2217 //*********************************************************************//  
2218 //                       Mintplex v3.0.0
2219 //
2220 //         This smart contract was generated by mintplex.xyz.
2221 //            Mintplex allows creators like you to launch 
2222 //             large scale NFT communities without code!
2223 //
2224 //    Mintplex is not responsible for the content of this contract and
2225 //        hopes it is being used in a responsible and kind way.  
2226 //       Mintplex is not associated or affiliated with this project.                                                    
2227 //             Twitter: @MintplexNFT ---- mintplex.xyz
2228 //*********************************************************************//                                                     
2229 //*********************************************************************// 
