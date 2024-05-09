1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //      
6 //      
7 //      
8 //                                        ,▄▄▄ÆÆ▄▄,
9 //                                     ▄█▀  ,,╓,,  ╙▀▓,
10 //                                   ▄▀ ,▄▀▀      ▀█▄ ╙█,
11 //                                  █  ▓▀            ▀▌ ▀▌
12 //                                 █▌ █    ▄     ╓▄   ╙█ █
13 //                                 █  █    ▀     ╙▀    █ ▐▌
14 //                                 █  █    ╓▄▄▄▄▄▄     █ ╟▌
15 //                         ,▄▓▀▀▓▄,╙█ ╙▌    ╙▀▀▀▀╙    █▀ █ ╓▄▓Æ▓▄,
16 //                       ┌█╙       ███ ╙█▄          ▄█ ╓██▀       ▀▌
17 //                      ┌█          ╟▌▀▌  ▀▀▓▄▄▄▄▓▀▀ ▄█▀█          ╙█
18 //                      ▐▌          ┌█  ╙▀█▄▄   ╓▄▓▀▀   █           █
19 //                       █▄        ,█  ,▄▄▓▀▀▀  ▀▀▀▓▄▄  ▀▌         █▀
20 //                        ╙█▄,  ,▄▓██▀▀               └▀███▄,  ,╓▓▀
21 //                              ▄█▀                        ▀█
22 //                            ╓█`                            ▀▌
23 //                           █▀                                █▄
24 //                          █                                   ▀▌
25 //                         █                                     █▌
26 //                        ╟▌                                      █
27 //                        █                                       ╟▌
28 //                        █                                       ▐▌
29 //                        █                                       ╟▌
30 //                        ╟▌                                      █
31 //                         █                                     ▓▌
32 //                          █                                   ▄█
33 //                           █▄                                ▓▀
34 //                            ╙█                             ▄█
35 //                              ╙█▄                       ,▄▀
36 //                                 ▀█▄,                ▄▓▀╙
37 //                                     ╙▀▀▓▄▄▄▄▄▄▄▓▀▀▀└
38 //      
39 //
40 //
41 //
42 //*********************************************************************//
43 //*********************************************************************//
44   
45 //-------------DEPENDENCIES--------------------------//
46 
47 // File: @openzeppelin/contracts/utils/Address.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
51 
52 pragma solidity ^0.8.1;
53 
54 /**
55  * @dev Collection of functions related to the address type
56  */
57 library Address {
58     /**
59      * @dev Returns true if account is a contract.
60      *
61      * [IMPORTANT]
62      * ====
63      * It is unsafe to assume that an address for which this function returns
64      * false is an externally-owned account (EOA) and not a contract.
65      *
66      * Among others, isContract will return false for the following
67      * types of addresses:
68      *
69      *  - an externally-owned account
70      *  - a contract in construction
71      *  - an address where a contract will be created
72      *  - an address where a contract lived, but was destroyed
73      * ====
74      *
75      * [IMPORTANT]
76      * ====
77      * You shouldn't rely on isContract to protect against flash loan attacks!
78      *
79      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
80      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
81      * constructor.
82      * ====
83      */
84     function isContract(address account) internal view returns (bool) {
85         // This method relies on extcodesize/address.code.length, which returns 0
86         // for contracts in construction, since the code is only stored at the end
87         // of the constructor execution.
88 
89         return account.code.length > 0;
90     }
91 
92     /**
93      * @dev Replacement for Solidity's transfer: sends amount wei to
94      * recipient, forwarding all available gas and reverting on errors.
95      *
96      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
97      * of certain opcodes, possibly making contracts go over the 2300 gas limit
98      * imposed by transfer, making them unable to receive funds via
99      * transfer. {sendValue} removes this limitation.
100      *
101      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
102      *
103      * IMPORTANT: because control is transferred to recipient, care must be
104      * taken to not create reentrancy vulnerabilities. Consider using
105      * {ReentrancyGuard} or the
106      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
107      */
108     function sendValue(address payable recipient, uint256 amount) internal {
109         require(address(this).balance >= amount, "Address: insufficient balance");
110 
111         (bool success, ) = recipient.call{value: amount}("");
112         require(success, "Address: unable to send value, recipient may have reverted");
113     }
114 
115     /**
116      * @dev Performs a Solidity function call using a low level call. A
117      * plain call is an unsafe replacement for a function call: use this
118      * function instead.
119      *
120      * If target reverts with a revert reason, it is bubbled up by this
121      * function (like regular Solidity function calls).
122      *
123      * Returns the raw returned data. To convert to the expected return value,
124      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
125      *
126      * Requirements:
127      *
128      * - target must be a contract.
129      * - calling target with data must not revert.
130      *
131      * _Available since v3.1._
132      */
133     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
134         return functionCall(target, data, "Address: low-level call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
139      * errorMessage as a fallback revert reason when target reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCall(
144         address target,
145         bytes memory data,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         return functionCallWithValue(target, data, 0, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
153      * but also transferring value wei to target.
154      *
155      * Requirements:
156      *
157      * - the calling contract must have an ETH balance of at least value.
158      * - the called Solidity function must be payable.
159      *
160      * _Available since v3.1._
161      */
162     function functionCallWithValue(
163         address target,
164         bytes memory data,
165         uint256 value
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
172      * with errorMessage as a fallback revert reason when target reverts.
173      *
174      * _Available since v3.1._
175      */
176     function functionCallWithValue(
177         address target,
178         bytes memory data,
179         uint256 value,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         require(address(this).balance >= value, "Address: insufficient balance for call");
183         require(isContract(target), "Address: call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.call{value: value}(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
191      * but performing a static call.
192      *
193      * _Available since v3.3._
194      */
195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
196         return functionStaticCall(target, data, "Address: low-level static call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
201      * but performing a static call.
202      *
203      * _Available since v3.3._
204      */
205     function functionStaticCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal view returns (bytes memory) {
210         require(isContract(target), "Address: static call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.staticcall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
218      * but performing a delegate call.
219      *
220      * _Available since v3.4._
221      */
222     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
223         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
228      * but performing a delegate call.
229      *
230      * _Available since v3.4._
231      */
232     function functionDelegateCall(
233         address target,
234         bytes memory data,
235         string memory errorMessage
236     ) internal returns (bytes memory) {
237         require(isContract(target), "Address: delegate call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.delegatecall(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
245      * revert reason using the provided one.
246      *
247      * _Available since v4.3._
248      */
249     function verifyCallResult(
250         bool success,
251         bytes memory returndata,
252         string memory errorMessage
253     ) internal pure returns (bytes memory) {
254         if (success) {
255             return returndata;
256         } else {
257             // Look for revert reason and bubble it up if present
258             if (returndata.length > 0) {
259                 // The easiest way to bubble the revert reason is using memory via assembly
260 
261                 assembly {
262                     let returndata_size := mload(returndata)
263                     revert(add(32, returndata), returndata_size)
264                 }
265             } else {
266                 revert(errorMessage);
267             }
268         }
269     }
270 }
271 
272 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @title ERC721 token receiver interface
281  * @dev Interface for any contract that wants to support safeTransfers
282  * from ERC721 asset contracts.
283  */
284 interface IERC721Receiver {
285     /**
286      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
287      * by operator from from, this function is called.
288      *
289      * It must return its Solidity selector to confirm the token transfer.
290      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
291      *
292      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
293      */
294     function onERC721Received(
295         address operator,
296         address from,
297         uint256 tokenId,
298         bytes calldata data
299     ) external returns (bytes4);
300 }
301 
302 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Interface of the ERC165 standard, as defined in the
311  * https://eips.ethereum.org/EIPS/eip-165[EIP].
312  *
313  * Implementers can declare support of contract interfaces, which can then be
314  * queried by others ({ERC165Checker}).
315  *
316  * For an implementation, see {ERC165}.
317  */
318 interface IERC165 {
319     /**
320      * @dev Returns true if this contract implements the interface defined by
321      * interfaceId. See the corresponding
322      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
323      * to learn more about how these ids are created.
324      *
325      * This function call must use less than 30 000 gas.
326      */
327     function supportsInterface(bytes4 interfaceId) external view returns (bool);
328 }
329 
330 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Implementation of the {IERC165} interface.
340  *
341  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
342  * for the additional interface id that will be supported. For example:
343  *
344  * solidity
345  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
347  * }
348  * 
349  *
350  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
351  */
352 abstract contract ERC165 is IERC165 {
353     /**
354      * @dev See {IERC165-supportsInterface}.
355      */
356     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357         return interfaceId == type(IERC165).interfaceId;
358     }
359 }
360 
361 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Required interface of an ERC721 compliant contract.
371  */
372 interface IERC721 is IERC165 {
373     /**
374      * @dev Emitted when tokenId token is transferred from from to to.
375      */
376     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
377 
378     /**
379      * @dev Emitted when owner enables approved to manage the tokenId token.
380      */
381     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
385      */
386     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
387 
388     /**
389      * @dev Returns the number of tokens in owner's account.
390      */
391     function balanceOf(address owner) external view returns (uint256 balance);
392 
393     /**
394      * @dev Returns the owner of the tokenId token.
395      *
396      * Requirements:
397      *
398      * - tokenId must exist.
399      */
400     function ownerOf(uint256 tokenId) external view returns (address owner);
401 
402     /**
403      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
404      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
405      *
406      * Requirements:
407      *
408      * - from cannot be the zero address.
409      * - to cannot be the zero address.
410      * - tokenId token must exist and be owned by from.
411      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
412      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
413      *
414      * Emits a {Transfer} event.
415      */
416     function safeTransferFrom(
417         address from,
418         address to,
419         uint256 tokenId
420     ) external;
421 
422     /**
423      * @dev Transfers tokenId token from from to to.
424      *
425      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
426      *
427      * Requirements:
428      *
429      * - from cannot be the zero address.
430      * - to cannot be the zero address.
431      * - tokenId token must be owned by from.
432      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(
437         address from,
438         address to,
439         uint256 tokenId
440     ) external;
441 
442     /**
443      * @dev Gives permission to to to transfer tokenId token to another account.
444      * The approval is cleared when the token is transferred.
445      *
446      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
447      *
448      * Requirements:
449      *
450      * - The caller must own the token or be an approved operator.
451      * - tokenId must exist.
452      *
453      * Emits an {Approval} event.
454      */
455     function approve(address to, uint256 tokenId) external;
456 
457     /**
458      * @dev Returns the account approved for tokenId token.
459      *
460      * Requirements:
461      *
462      * - tokenId must exist.
463      */
464     function getApproved(uint256 tokenId) external view returns (address operator);
465 
466     /**
467      * @dev Approve or remove operator as an operator for the caller.
468      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
469      *
470      * Requirements:
471      *
472      * - The operator cannot be the caller.
473      *
474      * Emits an {ApprovalForAll} event.
475      */
476     function setApprovalForAll(address operator, bool _approved) external;
477 
478     /**
479      * @dev Returns if the operator is allowed to manage all of the assets of owner.
480      *
481      * See {setApprovalForAll}
482      */
483     function isApprovedForAll(address owner, address operator) external view returns (bool);
484 
485     /**
486      * @dev Safely transfers tokenId token from from to to.
487      *
488      * Requirements:
489      *
490      * - from cannot be the zero address.
491      * - to cannot be the zero address.
492      * - tokenId token must exist and be owned by from.
493      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
494      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
495      *
496      * Emits a {Transfer} event.
497      */
498     function safeTransferFrom(
499         address from,
500         address to,
501         uint256 tokenId,
502         bytes calldata data
503     ) external;
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
507 
508 
509 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 
514 /**
515  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
516  * @dev See https://eips.ethereum.org/EIPS/eip-721
517  */
518 interface IERC721Enumerable is IERC721 {
519     /**
520      * @dev Returns the total amount of tokens stored by the contract.
521      */
522     function totalSupply() external view returns (uint256);
523 
524     /**
525      * @dev Returns a token ID owned by owner at a given index of its token list.
526      * Use along with {balanceOf} to enumerate all of owner's tokens.
527      */
528     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
529 
530     /**
531      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
532      * Use along with {totalSupply} to enumerate all tokens.
533      */
534     function tokenByIndex(uint256 index) external view returns (uint256);
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
547  * @dev See https://eips.ethereum.org/EIPS/eip-721
548  */
549 interface IERC721Metadata is IERC721 {
550     /**
551      * @dev Returns the token collection name.
552      */
553     function name() external view returns (string memory);
554 
555     /**
556      * @dev Returns the token collection symbol.
557      */
558     function symbol() external view returns (string memory);
559 
560     /**
561      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
562      */
563     function tokenURI(uint256 tokenId) external view returns (string memory);
564 }
565 
566 // File: @openzeppelin/contracts/utils/Strings.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev String operations.
575  */
576 library Strings {
577     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
578 
579     /**
580      * @dev Converts a uint256 to its ASCII string decimal representation.
581      */
582     function toString(uint256 value) internal pure returns (string memory) {
583         // Inspired by OraclizeAPI's implementation - MIT licence
584         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
585 
586         if (value == 0) {
587             return "0";
588         }
589         uint256 temp = value;
590         uint256 digits;
591         while (temp != 0) {
592             digits++;
593             temp /= 10;
594         }
595         bytes memory buffer = new bytes(digits);
596         while (value != 0) {
597             digits -= 1;
598             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
599             value /= 10;
600         }
601         return string(buffer);
602     }
603 
604     /**
605      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
606      */
607     function toHexString(uint256 value) internal pure returns (string memory) {
608         if (value == 0) {
609             return "0x00";
610         }
611         uint256 temp = value;
612         uint256 length = 0;
613         while (temp != 0) {
614             length++;
615             temp >>= 8;
616         }
617         return toHexString(value, length);
618     }
619 
620     /**
621      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
622      */
623     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
624         bytes memory buffer = new bytes(2 * length + 2);
625         buffer[0] = "0";
626         buffer[1] = "x";
627         for (uint256 i = 2 * length + 1; i > 1; --i) {
628             buffer[i] = _HEX_SYMBOLS[value & 0xf];
629             value >>= 4;
630         }
631         require(value == 0, "Strings: hex length insufficient");
632         return string(buffer);
633     }
634 }
635 
636 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Contract module that helps prevent reentrant calls to a function.
645  *
646  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
647  * available, which can be applied to functions to make sure there are no nested
648  * (reentrant) calls to them.
649  *
650  * Note that because there is a single nonReentrant guard, functions marked as
651  * nonReentrant may not call one another. This can be worked around by making
652  * those functions private, and then adding external nonReentrant entry
653  * points to them.
654  *
655  * TIP: If you would like to learn more about reentrancy and alternative ways
656  * to protect against it, check out our blog post
657  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
658  */
659 abstract contract ReentrancyGuard {
660     // Booleans are more expensive than uint256 or any type that takes up a full
661     // word because each write operation emits an extra SLOAD to first read the
662     // slot's contents, replace the bits taken up by the boolean, and then write
663     // back. This is the compiler's defense against contract upgrades and
664     // pointer aliasing, and it cannot be disabled.
665 
666     // The values being non-zero value makes deployment a bit more expensive,
667     // but in exchange the refund on every call to nonReentrant will be lower in
668     // amount. Since refunds are capped to a percentage of the total
669     // transaction's gas, it is best to keep them low in cases like this one, to
670     // increase the likelihood of the full refund coming into effect.
671     uint256 private constant _NOT_ENTERED = 1;
672     uint256 private constant _ENTERED = 2;
673 
674     uint256 private _status;
675 
676     constructor() {
677         _status = _NOT_ENTERED;
678     }
679 
680     /**
681      * @dev Prevents a contract from calling itself, directly or indirectly.
682      * Calling a nonReentrant function from another nonReentrant
683      * function is not supported. It is possible to prevent this from happening
684      * by making the nonReentrant function external, and making it call a
685      * private function that does the actual work.
686      */
687     modifier nonReentrant() {
688         // On the first call to nonReentrant, _notEntered will be true
689         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
690 
691         // Any calls to nonReentrant after this point will fail
692         _status = _ENTERED;
693 
694         _;
695 
696         // By storing the original value once again, a refund is triggered (see
697         // https://eips.ethereum.org/EIPS/eip-2200)
698         _status = _NOT_ENTERED;
699     }
700 }
701 
702 // File: @openzeppelin/contracts/utils/Context.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @dev Provides information about the current execution context, including the
711  * sender of the transaction and its data. While these are generally available
712  * via msg.sender and msg.data, they should not be accessed in such a direct
713  * manner, since when dealing with meta-transactions the account sending and
714  * paying for execution may not be the actual sender (as far as an application
715  * is concerned).
716  *
717  * This contract is only required for intermediate, library-like contracts.
718  */
719 abstract contract Context {
720     function _msgSender() internal view virtual returns (address) {
721         return msg.sender;
722     }
723 
724     function _msgData() internal view virtual returns (bytes calldata) {
725         return msg.data;
726     }
727 }
728 
729 // File: @openzeppelin/contracts/access/Ownable.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @dev Contract module which provides a basic access control mechanism, where
739  * there is an account (an owner) that can be granted exclusive access to
740  * specific functions.
741  *
742  * By default, the owner account will be the one that deploys the contract. This
743  * can later be changed with {transferOwnership}.
744  *
745  * This module is used through inheritance. It will make available the modifier
746  * onlyOwner, which can be applied to your functions to restrict their use to
747  * the owner.
748  */
749 abstract contract Ownable is Context {
750     address private _owner;
751 
752     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
753 
754     /**
755      * @dev Initializes the contract setting the deployer as the initial owner.
756      */
757     constructor() {
758         _transferOwnership(_msgSender());
759     }
760 
761     /**
762      * @dev Returns the address of the current owner.
763      */
764     function owner() public view virtual returns (address) {
765         return _owner;
766     }
767 
768     /**
769      * @dev Throws if called by any account other than the owner.
770      */
771     function _onlyOwner() private view {
772        require(owner() == _msgSender(), "Ownable: caller is not the owner");
773     }
774 
775     modifier onlyOwner() {
776         _onlyOwner();
777         _;
778     }
779 
780     /**
781      * @dev Leaves the contract without owner. It will not be possible to call
782      * onlyOwner functions anymore. Can only be called by the current owner.
783      *
784      * NOTE: Renouncing ownership will leave the contract without an owner,
785      * thereby removing any functionality that is only available to the owner.
786      */
787     function renounceOwnership() public virtual onlyOwner {
788         _transferOwnership(address(0));
789     }
790 
791     /**
792      * @dev Transfers ownership of the contract to a new account (newOwner).
793      * Can only be called by the current owner.
794      */
795     function transferOwnership(address newOwner) public virtual onlyOwner {
796         require(newOwner != address(0), "Ownable: new owner is the zero address");
797         _transferOwnership(newOwner);
798     }
799 
800     /**
801      * @dev Transfers ownership of the contract to a new account (newOwner).
802      * Internal function without access restriction.
803      */
804     function _transferOwnership(address newOwner) internal virtual {
805         address oldOwner = _owner;
806         _owner = newOwner;
807         emit OwnershipTransferred(oldOwner, newOwner);
808     }
809 }
810 
811 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
812 pragma solidity ^0.8.9;
813 
814 interface IOperatorFilterRegistry {
815     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
816     function register(address registrant) external;
817     function registerAndSubscribe(address registrant, address subscription) external;
818     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
819     function updateOperator(address registrant, address operator, bool filtered) external;
820     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
821     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
822     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
823     function subscribe(address registrant, address registrantToSubscribe) external;
824     function unsubscribe(address registrant, bool copyExistingEntries) external;
825     function subscriptionOf(address addr) external returns (address registrant);
826     function subscribers(address registrant) external returns (address[] memory);
827     function subscriberAt(address registrant, uint256 index) external returns (address);
828     function copyEntriesOf(address registrant, address registrantToCopy) external;
829     function isOperatorFiltered(address registrant, address operator) external returns (bool);
830     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
831     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
832     function filteredOperators(address addr) external returns (address[] memory);
833     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
834     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
835     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
836     function isRegistered(address addr) external returns (bool);
837     function codeHashOf(address addr) external returns (bytes32);
838 }
839 
840 // File contracts/OperatorFilter/OperatorFilterer.sol
841 pragma solidity ^0.8.9;
842 
843 abstract contract OperatorFilterer {
844     error OperatorNotAllowed(address operator);
845 
846     IOperatorFilterRegistry constant operatorFilterRegistry =
847         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
848 
849     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
850         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
851         // will not revert, but the contract will need to be registered with the registry once it is deployed in
852         // order for the modifier to filter addresses.
853         if (address(operatorFilterRegistry).code.length > 0) {
854             if (subscribe) {
855                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
856             } else {
857                 if (subscriptionOrRegistrantToCopy != address(0)) {
858                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
859                 } else {
860                     operatorFilterRegistry.register(address(this));
861                 }
862             }
863         }
864     }
865 
866     function _onlyAllowedOperator(address from) private view {
867       if (
868           !(
869               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
870               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
871           )
872       ) {
873           revert OperatorNotAllowed(msg.sender);
874       }
875     }
876 
877     modifier onlyAllowedOperator(address from) virtual {
878         // Check registry code length to facilitate testing in environments without a deployed registry.
879         if (address(operatorFilterRegistry).code.length > 0) {
880             // Allow spending tokens from addresses with balance
881             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
882             // from an EOA.
883             if (from == msg.sender) {
884                 _;
885                 return;
886             }
887             _onlyAllowedOperator(from);
888         }
889         _;
890     }
891 
892     modifier onlyAllowedOperatorApproval(address operator) virtual {
893         _checkFilterOperator(operator);
894         _;
895     }
896 
897     function _checkFilterOperator(address operator) internal view virtual {
898         // Check registry code length to facilitate testing in environments without a deployed registry.
899         if (address(operatorFilterRegistry).code.length > 0) {
900             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
901                 revert OperatorNotAllowed(operator);
902             }
903         }
904     }
905 }
906 
907 //-------------END DEPENDENCIES------------------------//
908 
909 
910   
911 error TransactionCapExceeded();
912 error PublicMintingClosed();
913 error ExcessiveOwnedMints();
914 error MintZeroQuantity();
915 error InvalidPayment();
916 error CapExceeded();
917 error IsAlreadyUnveiled();
918 error ValueCannotBeZero();
919 error CannotBeNullAddress();
920 error NoStateChange();
921 
922 error PublicMintClosed();
923 error AllowlistMintClosed();
924 
925 error AddressNotAllowlisted();
926 error AllowlistDropTimeHasNotPassed();
927 error PublicDropTimeHasNotPassed();
928 error DropTimeNotInFuture();
929 
930 error OnlyERC20MintingEnabled();
931 error ERC20TokenNotApproved();
932 error ERC20InsufficientBalance();
933 error ERC20InsufficientAllowance();
934 error ERC20TransferFailed();
935 
936 error ClaimModeDisabled();
937 error IneligibleRedemptionContract();
938 error TokenAlreadyRedeemed();
939 error InvalidOwnerForRedemption();
940 error InvalidApprovalForRedemption();
941 
942 error ERC721RestrictedApprovalAddressRestricted();
943   
944   
945 // Rampp Contracts v2.1 (Teams.sol)
946 
947 error InvalidTeamAddress();
948 error DuplicateTeamAddress();
949 pragma solidity ^0.8.0;
950 
951 /**
952 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
953 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
954 * This will easily allow cross-collaboration via Mintplex.xyz.
955 **/
956 abstract contract Teams is Ownable{
957   mapping (address => bool) internal team;
958 
959   /**
960   * @dev Adds an address to the team. Allows them to execute protected functions
961   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
962   **/
963   function addToTeam(address _address) public onlyOwner {
964     if(_address == address(0)) revert InvalidTeamAddress();
965     if(inTeam(_address)) revert DuplicateTeamAddress();
966   
967     team[_address] = true;
968   }
969 
970   /**
971   * @dev Removes an address to the team.
972   * @param _address the ETH address to remove, cannot be 0x and must be in team
973   **/
974   function removeFromTeam(address _address) public onlyOwner {
975     if(_address == address(0)) revert InvalidTeamAddress();
976     if(!inTeam(_address)) revert InvalidTeamAddress();
977   
978     team[_address] = false;
979   }
980 
981   /**
982   * @dev Check if an address is valid and active in the team
983   * @param _address ETH address to check for truthiness
984   **/
985   function inTeam(address _address)
986     public
987     view
988     returns (bool)
989   {
990     if(_address == address(0)) revert InvalidTeamAddress();
991     return team[_address] == true;
992   }
993 
994   /**
995   * @dev Throws if called by any account other than the owner or team member.
996   */
997   function _onlyTeamOrOwner() private view {
998     bool _isOwner = owner() == _msgSender();
999     bool _isTeam = inTeam(_msgSender());
1000     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
1001   }
1002 
1003   modifier onlyTeamOrOwner() {
1004     _onlyTeamOrOwner();
1005     _;
1006   }
1007 }
1008 
1009 
1010   
1011   
1012 /**
1013  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1014  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1015  *
1016  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1017  * 
1018  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1019  *
1020  * Does not support burning tokens to address(0).
1021  */
1022 contract ERC721A is
1023   Context,
1024   ERC165,
1025   IERC721,
1026   IERC721Metadata,
1027   IERC721Enumerable,
1028   Teams
1029   , OperatorFilterer
1030 {
1031   using Address for address;
1032   using Strings for uint256;
1033 
1034   struct TokenOwnership {
1035     address addr;
1036     uint64 startTimestamp;
1037   }
1038 
1039   struct AddressData {
1040     uint128 balance;
1041     uint128 numberMinted;
1042   }
1043 
1044   uint256 private currentIndex;
1045 
1046   uint256 public immutable collectionSize;
1047   uint256 public maxBatchSize;
1048 
1049   // Token name
1050   string private _name;
1051 
1052   // Token symbol
1053   string private _symbol;
1054 
1055   // Mapping from token ID to ownership details
1056   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1057   mapping(uint256 => TokenOwnership) private _ownerships;
1058 
1059   // Mapping owner address to address data
1060   mapping(address => AddressData) private _addressData;
1061 
1062   // Mapping from token ID to approved address
1063   mapping(uint256 => address) private _tokenApprovals;
1064 
1065   // Mapping from owner to operator approvals
1066   mapping(address => mapping(address => bool)) private _operatorApprovals;
1067 
1068   /* @dev Mapping of restricted operator approvals set by contract Owner
1069   * This serves as an optional addition to ERC-721 so
1070   * that the contract owner can elect to prevent specific addresses/contracts
1071   * from being marked as the approver for a token. The reason for this
1072   * is that some projects may want to retain control of where their tokens can/can not be listed
1073   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1074   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1075   */
1076   mapping(address => bool) public restrictedApprovalAddresses;
1077 
1078   /**
1079    * @dev
1080    * maxBatchSize refers to how much a minter can mint at a time.
1081    * collectionSize_ refers to how many tokens are in the collection.
1082    */
1083   constructor(
1084     string memory name_,
1085     string memory symbol_,
1086     uint256 maxBatchSize_,
1087     uint256 collectionSize_
1088   ) OperatorFilterer(address(0), false) {
1089     require(
1090       collectionSize_ > 0,
1091       "ERC721A: collection must have a nonzero supply"
1092     );
1093     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1094     _name = name_;
1095     _symbol = symbol_;
1096     maxBatchSize = maxBatchSize_;
1097     collectionSize = collectionSize_;
1098     currentIndex = _startTokenId();
1099   }
1100 
1101   /**
1102   * To change the starting tokenId, please override this function.
1103   */
1104   function _startTokenId() internal view virtual returns (uint256) {
1105     return 1;
1106   }
1107 
1108   /**
1109    * @dev See {IERC721Enumerable-totalSupply}.
1110    */
1111   function totalSupply() public view override returns (uint256) {
1112     return _totalMinted();
1113   }
1114 
1115   function currentTokenId() public view returns (uint256) {
1116     return _totalMinted();
1117   }
1118 
1119   function getNextTokenId() public view returns (uint256) {
1120       return _totalMinted() + 1;
1121   }
1122 
1123   /**
1124   * Returns the total amount of tokens minted in the contract.
1125   */
1126   function _totalMinted() internal view returns (uint256) {
1127     unchecked {
1128       return currentIndex - _startTokenId();
1129     }
1130   }
1131 
1132   /**
1133    * @dev See {IERC721Enumerable-tokenByIndex}.
1134    */
1135   function tokenByIndex(uint256 index) public view override returns (uint256) {
1136     require(index < totalSupply(), "ERC721A: global index out of bounds");
1137     return index;
1138   }
1139 
1140   /**
1141    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1142    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1143    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1144    */
1145   function tokenOfOwnerByIndex(address owner, uint256 index)
1146     public
1147     view
1148     override
1149     returns (uint256)
1150   {
1151     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1152     uint256 numMintedSoFar = totalSupply();
1153     uint256 tokenIdsIdx = 0;
1154     address currOwnershipAddr = address(0);
1155     for (uint256 i = 0; i < numMintedSoFar; i++) {
1156       TokenOwnership memory ownership = _ownerships[i];
1157       if (ownership.addr != address(0)) {
1158         currOwnershipAddr = ownership.addr;
1159       }
1160       if (currOwnershipAddr == owner) {
1161         if (tokenIdsIdx == index) {
1162           return i;
1163         }
1164         tokenIdsIdx++;
1165       }
1166     }
1167     revert("ERC721A: unable to get token of owner by index");
1168   }
1169 
1170   /**
1171    * @dev See {IERC165-supportsInterface}.
1172    */
1173   function supportsInterface(bytes4 interfaceId)
1174     public
1175     view
1176     virtual
1177     override(ERC165, IERC165)
1178     returns (bool)
1179   {
1180     return
1181       interfaceId == type(IERC721).interfaceId ||
1182       interfaceId == type(IERC721Metadata).interfaceId ||
1183       interfaceId == type(IERC721Enumerable).interfaceId ||
1184       super.supportsInterface(interfaceId);
1185   }
1186 
1187   /**
1188    * @dev See {IERC721-balanceOf}.
1189    */
1190   function balanceOf(address owner) public view override returns (uint256) {
1191     require(owner != address(0), "ERC721A: balance query for the zero address");
1192     return uint256(_addressData[owner].balance);
1193   }
1194 
1195   function _numberMinted(address owner) internal view returns (uint256) {
1196     require(
1197       owner != address(0),
1198       "ERC721A: number minted query for the zero address"
1199     );
1200     return uint256(_addressData[owner].numberMinted);
1201   }
1202 
1203   function ownershipOf(uint256 tokenId)
1204     internal
1205     view
1206     returns (TokenOwnership memory)
1207   {
1208     uint256 curr = tokenId;
1209 
1210     unchecked {
1211         if (_startTokenId() <= curr && curr < currentIndex) {
1212             TokenOwnership memory ownership = _ownerships[curr];
1213             if (ownership.addr != address(0)) {
1214                 return ownership;
1215             }
1216 
1217             // Invariant:
1218             // There will always be an ownership that has an address and is not burned
1219             // before an ownership that does not have an address and is not burned.
1220             // Hence, curr will not underflow.
1221             while (true) {
1222                 curr--;
1223                 ownership = _ownerships[curr];
1224                 if (ownership.addr != address(0)) {
1225                     return ownership;
1226                 }
1227             }
1228         }
1229     }
1230 
1231     revert("ERC721A: unable to determine the owner of token");
1232   }
1233 
1234   /**
1235    * @dev See {IERC721-ownerOf}.
1236    */
1237   function ownerOf(uint256 tokenId) public view override returns (address) {
1238     return ownershipOf(tokenId).addr;
1239   }
1240 
1241   /**
1242    * @dev See {IERC721Metadata-name}.
1243    */
1244   function name() public view virtual override returns (string memory) {
1245     return _name;
1246   }
1247 
1248   /**
1249    * @dev See {IERC721Metadata-symbol}.
1250    */
1251   function symbol() public view virtual override returns (string memory) {
1252     return _symbol;
1253   }
1254 
1255   /**
1256    * @dev See {IERC721Metadata-tokenURI}.
1257    */
1258   function tokenURI(uint256 tokenId)
1259     public
1260     view
1261     virtual
1262     override
1263     returns (string memory)
1264   {
1265     string memory baseURI = _baseURI();
1266     string memory extension = _baseURIExtension();
1267     return
1268       bytes(baseURI).length > 0
1269         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1270         : "";
1271   }
1272 
1273   /**
1274    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1275    * token will be the concatenation of the baseURI and the tokenId. Empty
1276    * by default, can be overriden in child contracts.
1277    */
1278   function _baseURI() internal view virtual returns (string memory) {
1279     return "";
1280   }
1281 
1282   /**
1283    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1284    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1285    * by default, can be overriden in child contracts.
1286    */
1287   function _baseURIExtension() internal view virtual returns (string memory) {
1288     return "";
1289   }
1290 
1291   /**
1292    * @dev Sets the value for an address to be in the restricted approval address pool.
1293    * Setting an address to true will disable token owners from being able to mark the address
1294    * for approval for trading. This would be used in theory to prevent token owners from listing
1295    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1296    * @param _address the marketplace/user to modify restriction status of
1297    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1298    */
1299   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1300     restrictedApprovalAddresses[_address] = _isRestricted;
1301   }
1302 
1303   /**
1304    * @dev See {IERC721-approve}.
1305    */
1306   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1307     address owner = ERC721A.ownerOf(tokenId);
1308     require(to != owner, "ERC721A: approval to current owner");
1309     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1310 
1311     require(
1312       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1313       "ERC721A: approve caller is not owner nor approved for all"
1314     );
1315 
1316     _approve(to, tokenId, owner);
1317   }
1318 
1319   /**
1320    * @dev See {IERC721-getApproved}.
1321    */
1322   function getApproved(uint256 tokenId) public view override returns (address) {
1323     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1324 
1325     return _tokenApprovals[tokenId];
1326   }
1327 
1328   /**
1329    * @dev See {IERC721-setApprovalForAll}.
1330    */
1331   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1332     require(operator != _msgSender(), "ERC721A: approve to caller");
1333     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1334 
1335     _operatorApprovals[_msgSender()][operator] = approved;
1336     emit ApprovalForAll(_msgSender(), operator, approved);
1337   }
1338 
1339   /**
1340    * @dev See {IERC721-isApprovedForAll}.
1341    */
1342   function isApprovedForAll(address owner, address operator)
1343     public
1344     view
1345     virtual
1346     override
1347     returns (bool)
1348   {
1349     return _operatorApprovals[owner][operator];
1350   }
1351 
1352   /**
1353    * @dev See {IERC721-transferFrom}.
1354    */
1355   function transferFrom(
1356     address from,
1357     address to,
1358     uint256 tokenId
1359   ) public override onlyAllowedOperator(from) {
1360     _transfer(from, to, tokenId);
1361   }
1362 
1363   /**
1364    * @dev See {IERC721-safeTransferFrom}.
1365    */
1366   function safeTransferFrom(
1367     address from,
1368     address to,
1369     uint256 tokenId
1370   ) public override onlyAllowedOperator(from) {
1371     safeTransferFrom(from, to, tokenId, "");
1372   }
1373 
1374   /**
1375    * @dev See {IERC721-safeTransferFrom}.
1376    */
1377   function safeTransferFrom(
1378     address from,
1379     address to,
1380     uint256 tokenId,
1381     bytes memory _data
1382   ) public override onlyAllowedOperator(from) {
1383     _transfer(from, to, tokenId);
1384     require(
1385       _checkOnERC721Received(from, to, tokenId, _data),
1386       "ERC721A: transfer to non ERC721Receiver implementer"
1387     );
1388   }
1389 
1390   /**
1391    * @dev Returns whether tokenId exists.
1392    *
1393    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1394    *
1395    * Tokens start existing when they are minted (_mint),
1396    */
1397   function _exists(uint256 tokenId) internal view returns (bool) {
1398     return _startTokenId() <= tokenId && tokenId < currentIndex;
1399   }
1400 
1401   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1402     _safeMint(to, quantity, isAdminMint, "");
1403   }
1404 
1405   /**
1406    * @dev Mints quantity tokens and transfers them to to.
1407    *
1408    * Requirements:
1409    *
1410    * - there must be quantity tokens remaining unminted in the total collection.
1411    * - to cannot be the zero address.
1412    * - quantity cannot be larger than the max batch size.
1413    *
1414    * Emits a {Transfer} event.
1415    */
1416   function _safeMint(
1417     address to,
1418     uint256 quantity,
1419     bool isAdminMint,
1420     bytes memory _data
1421   ) internal {
1422     uint256 startTokenId = currentIndex;
1423     require(to != address(0), "ERC721A: mint to the zero address");
1424     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1425     require(!_exists(startTokenId), "ERC721A: token already minted");
1426 
1427     // For admin mints we do not want to enforce the maxBatchSize limit
1428     if (isAdminMint == false) {
1429         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1430     }
1431 
1432     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1433 
1434     AddressData memory addressData = _addressData[to];
1435     _addressData[to] = AddressData(
1436       addressData.balance + uint128(quantity),
1437       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1438     );
1439     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1440 
1441     uint256 updatedIndex = startTokenId;
1442 
1443     for (uint256 i = 0; i < quantity; i++) {
1444       emit Transfer(address(0), to, updatedIndex);
1445       require(
1446         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1447         "ERC721A: transfer to non ERC721Receiver implementer"
1448       );
1449       updatedIndex++;
1450     }
1451 
1452     currentIndex = updatedIndex;
1453     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1454   }
1455 
1456   /**
1457    * @dev Transfers tokenId from from to to.
1458    *
1459    * Requirements:
1460    *
1461    * - to cannot be the zero address.
1462    * - tokenId token must be owned by from.
1463    *
1464    * Emits a {Transfer} event.
1465    */
1466   function _transfer(
1467     address from,
1468     address to,
1469     uint256 tokenId
1470   ) private {
1471     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1472 
1473     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1474       getApproved(tokenId) == _msgSender() ||
1475       isApprovedForAll(prevOwnership.addr, _msgSender()));
1476 
1477     require(
1478       isApprovedOrOwner,
1479       "ERC721A: transfer caller is not owner nor approved"
1480     );
1481 
1482     require(
1483       prevOwnership.addr == from,
1484       "ERC721A: transfer from incorrect owner"
1485     );
1486     require(to != address(0), "ERC721A: transfer to the zero address");
1487 
1488     _beforeTokenTransfers(from, to, tokenId, 1);
1489 
1490     // Clear approvals from the previous owner
1491     _approve(address(0), tokenId, prevOwnership.addr);
1492 
1493     _addressData[from].balance -= 1;
1494     _addressData[to].balance += 1;
1495     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1496 
1497     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1498     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1499     uint256 nextTokenId = tokenId + 1;
1500     if (_ownerships[nextTokenId].addr == address(0)) {
1501       if (_exists(nextTokenId)) {
1502         _ownerships[nextTokenId] = TokenOwnership(
1503           prevOwnership.addr,
1504           prevOwnership.startTimestamp
1505         );
1506       }
1507     }
1508 
1509     emit Transfer(from, to, tokenId);
1510     _afterTokenTransfers(from, to, tokenId, 1);
1511   }
1512 
1513   /**
1514    * @dev Approve to to operate on tokenId
1515    *
1516    * Emits a {Approval} event.
1517    */
1518   function _approve(
1519     address to,
1520     uint256 tokenId,
1521     address owner
1522   ) private {
1523     _tokenApprovals[tokenId] = to;
1524     emit Approval(owner, to, tokenId);
1525   }
1526 
1527   uint256 public nextOwnerToExplicitlySet = 0;
1528 
1529   /**
1530    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1531    */
1532   function _setOwnersExplicit(uint256 quantity) internal {
1533     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1534     require(quantity > 0, "quantity must be nonzero");
1535     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1536 
1537     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1538     if (endIndex > collectionSize - 1) {
1539       endIndex = collectionSize - 1;
1540     }
1541     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1542     require(_exists(endIndex), "not enough minted yet for this cleanup");
1543     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1544       if (_ownerships[i].addr == address(0)) {
1545         TokenOwnership memory ownership = ownershipOf(i);
1546         _ownerships[i] = TokenOwnership(
1547           ownership.addr,
1548           ownership.startTimestamp
1549         );
1550       }
1551     }
1552     nextOwnerToExplicitlySet = endIndex + 1;
1553   }
1554 
1555   /**
1556    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1557    * The call is not executed if the target address is not a contract.
1558    *
1559    * @param from address representing the previous owner of the given token ID
1560    * @param to target address that will receive the tokens
1561    * @param tokenId uint256 ID of the token to be transferred
1562    * @param _data bytes optional data to send along with the call
1563    * @return bool whether the call correctly returned the expected magic value
1564    */
1565   function _checkOnERC721Received(
1566     address from,
1567     address to,
1568     uint256 tokenId,
1569     bytes memory _data
1570   ) private returns (bool) {
1571     if (to.isContract()) {
1572       try
1573         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1574       returns (bytes4 retval) {
1575         return retval == IERC721Receiver(to).onERC721Received.selector;
1576       } catch (bytes memory reason) {
1577         if (reason.length == 0) {
1578           revert("ERC721A: transfer to non ERC721Receiver implementer");
1579         } else {
1580           assembly {
1581             revert(add(32, reason), mload(reason))
1582           }
1583         }
1584       }
1585     } else {
1586       return true;
1587     }
1588   }
1589 
1590   /**
1591    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1592    *
1593    * startTokenId - the first token id to be transferred
1594    * quantity - the amount to be transferred
1595    *
1596    * Calling conditions:
1597    *
1598    * - When from and to are both non-zero, from's tokenId will be
1599    * transferred to to.
1600    * - When from is zero, tokenId will be minted for to.
1601    */
1602   function _beforeTokenTransfers(
1603     address from,
1604     address to,
1605     uint256 startTokenId,
1606     uint256 quantity
1607   ) internal virtual {}
1608 
1609   /**
1610    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1611    * minting.
1612    *
1613    * startTokenId - the first token id to be transferred
1614    * quantity - the amount to be transferred
1615    *
1616    * Calling conditions:
1617    *
1618    * - when from and to are both non-zero.
1619    * - from and to are never both zero.
1620    */
1621   function _afterTokenTransfers(
1622     address from,
1623     address to,
1624     uint256 startTokenId,
1625     uint256 quantity
1626   ) internal virtual {}
1627 }
1628 
1629 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1630 // @author Mintplex.xyz (Rampp Labs Inc) (Twitter: @MintplexNFT)
1631 // @notice -- See Medium article --
1632 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1633 abstract contract ERC721ARedemption is ERC721A {
1634   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1635   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1636 
1637   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1638   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1639   
1640   uint256 public redemptionSurcharge = 0 ether;
1641   bool public redemptionModeEnabled;
1642   bool public verifiedClaimModeEnabled;
1643   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1644   mapping(address => bool) public redemptionContracts;
1645   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1646 
1647   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1648   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1649     redemptionContracts[_contractAddress] = _status;
1650   }
1651 
1652   // @dev Allow owner/team to determine if contract is accepting redemption mints
1653   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1654     redemptionModeEnabled = _newStatus;
1655   }
1656 
1657   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1658   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1659     verifiedClaimModeEnabled = _newStatus;
1660   }
1661 
1662   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1663   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1664     redemptionSurcharge = _newSurchargeInWei;
1665   }
1666 
1667   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1668   // @notice Must be a wallet address or implement IERC721Receiver.
1669   // Cannot be null address as this will break any ERC-721A implementation without a proper
1670   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1671   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1672     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1673     redemptionAddress = _newRedemptionAddress;
1674   }
1675 
1676   /**
1677   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1678   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1679   * the contract owner or Team => redemptionAddress. 
1680   * @param tokenId the token to be redeemed.
1681   * Emits a {Redeemed} event.
1682   **/
1683   function redeem(address redemptionContract, uint256 tokenId) public payable {
1684     if(getNextTokenId() > collectionSize) revert CapExceeded();
1685     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1686     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1687     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1688     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1689     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1690     
1691     IERC721 _targetContract = IERC721(redemptionContract);
1692     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1693     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1694     
1695     // Warning: Since there is no standarized return value for transfers of ERC-721
1696     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1697     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1698     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1699     // but the NFT may not have been sent to the redemptionAddress.
1700     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1701     tokenRedemptions[redemptionContract][tokenId] = true;
1702 
1703     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1704     _safeMint(_msgSender(), 1, false);
1705   }
1706 
1707   /**
1708   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1709   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1710   * @param tokenId the token to be redeemed.
1711   * Emits a {VerifiedClaim} event.
1712   **/
1713   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1714     if(getNextTokenId() > collectionSize) revert CapExceeded();
1715     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1716     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1717     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1718     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1719     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1720     
1721     tokenRedemptions[redemptionContract][tokenId] = true;
1722     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1723     _safeMint(_msgSender(), 1, false);
1724   }
1725 }
1726 
1727 
1728   
1729   
1730 interface IERC20 {
1731   function allowance(address owner, address spender) external view returns (uint256);
1732   function transfer(address _to, uint256 _amount) external returns (bool);
1733   function balanceOf(address account) external view returns (uint256);
1734   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1735 }
1736 
1737 // File: WithdrawableV2
1738 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1739 // ERC-20 Payouts are limited to a single payout address. This feature 
1740 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1741 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1742 abstract contract WithdrawableV2 is Teams {
1743   struct acceptedERC20 {
1744     bool isActive;
1745     uint256 chargeAmount;
1746   }
1747 
1748   
1749   mapping(address => acceptedERC20) private allowedTokenContracts;
1750   address[] public payableAddresses = [0x5Dd38CB969Dea33A62ABD50934799Fd8257550E0];
1751   address public erc20Payable = 0x5Dd38CB969Dea33A62ABD50934799Fd8257550E0;
1752   uint256[] public payableFees = [100];
1753   uint256 public payableAddressCount = 1;
1754   bool public onlyERC20MintingMode;
1755   
1756 
1757   function withdrawAll() public onlyTeamOrOwner {
1758       if(address(this).balance == 0) revert ValueCannotBeZero();
1759       _withdrawAll(address(this).balance);
1760   }
1761 
1762   function _withdrawAll(uint256 balance) private {
1763       for(uint i=0; i < payableAddressCount; i++ ) {
1764           _widthdraw(
1765               payableAddresses[i],
1766               (balance * payableFees[i]) / 100
1767           );
1768       }
1769   }
1770   
1771   function _widthdraw(address _address, uint256 _amount) private {
1772       (bool success, ) = _address.call{value: _amount}("");
1773       require(success, "Transfer failed.");
1774   }
1775 
1776   /**
1777   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1778   * in the event ERC-20 tokens are paid to the contract for mints.
1779   * @param _tokenContract contract of ERC-20 token to withdraw
1780   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1781   */
1782   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1783     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1784     IERC20 tokenContract = IERC20(_tokenContract);
1785     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1786     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1787   }
1788 
1789   /**
1790   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1791   * @param _erc20TokenContract address of ERC-20 contract in question
1792   */
1793   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1794     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1795   }
1796 
1797   /**
1798   * @dev get the value of tokens to transfer for user of an ERC-20
1799   * @param _erc20TokenContract address of ERC-20 contract in question
1800   */
1801   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1802     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1803     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1804   }
1805 
1806   /**
1807   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1808   * @param _erc20TokenContract address of ERC-20 contract in question
1809   * @param _isActive default status of if contract should be allowed to accept payments
1810   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1811   */
1812   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1813     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1814     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1815   }
1816 
1817   /**
1818   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1819   * it will assume the default value of zero. This should not be used to create new payment tokens.
1820   * @param _erc20TokenContract address of ERC-20 contract in question
1821   */
1822   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1823     allowedTokenContracts[_erc20TokenContract].isActive = true;
1824   }
1825 
1826   /**
1827   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1828   * it will assume the default value of zero. This should not be used to create new payment tokens.
1829   * @param _erc20TokenContract address of ERC-20 contract in question
1830   */
1831   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1832     allowedTokenContracts[_erc20TokenContract].isActive = false;
1833   }
1834 
1835   /**
1836   * @dev Enable only ERC-20 payments for minting on this contract
1837   */
1838   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1839     onlyERC20MintingMode = true;
1840   }
1841 
1842   /**
1843   * @dev Disable only ERC-20 payments for minting on this contract
1844   */
1845   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1846     onlyERC20MintingMode = false;
1847   }
1848 
1849   /**
1850   * @dev Set the payout of the ERC-20 token payout to a specific address
1851   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1852   */
1853   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1854     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1855     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1856     erc20Payable = _newErc20Payable;
1857   }
1858 }
1859 
1860 
1861   
1862   
1863 // File: EarlyMintIncentive.sol
1864 // Allows the contract to have the first x tokens have a discount or
1865 // zero fee that can be calculated on the fly.
1866 abstract contract EarlyMintIncentive is Teams, ERC721A {
1867   uint256 public PRICE = 0.0036 ether;
1868   uint256 public EARLY_MINT_PRICE = 0 ether;
1869   uint256 public earlyMintTokenIdCap = 100;
1870   bool public usingEarlyMintIncentive = true;
1871 
1872   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1873     usingEarlyMintIncentive = true;
1874   }
1875 
1876   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1877     usingEarlyMintIncentive = false;
1878   }
1879 
1880   /**
1881   * @dev Set the max token ID in which the cost incentive will be applied.
1882   * @param _newTokenIdCap max tokenId in which incentive will be applied
1883   */
1884   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1885     if(_newTokenIdCap > collectionSize) revert CapExceeded();
1886     if(_newTokenIdCap == 0) revert ValueCannotBeZero();
1887     earlyMintTokenIdCap = _newTokenIdCap;
1888   }
1889 
1890   /**
1891   * @dev Set the incentive mint price
1892   * @param _feeInWei new price per token when in incentive range
1893   */
1894   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1895     EARLY_MINT_PRICE = _feeInWei;
1896   }
1897 
1898   /**
1899   * @dev Set the primary mint price - the base price when not under incentive
1900   * @param _feeInWei new price per token
1901   */
1902   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1903     PRICE = _feeInWei;
1904   }
1905 
1906   function getPrice(uint256 _count) public view returns (uint256) {
1907     if(_count == 0) revert ValueCannotBeZero();
1908 
1909     // short circuit function if we dont need to even calc incentive pricing
1910     // short circuit if the current tokenId is also already over cap
1911     if(
1912       usingEarlyMintIncentive == false ||
1913       currentTokenId() > earlyMintTokenIdCap
1914     ) {
1915       return PRICE * _count;
1916     }
1917 
1918     uint256 endingTokenId = currentTokenId() + _count;
1919     // If qty to mint results in a final token ID less than or equal to the cap then
1920     // the entire qty is within free mint.
1921     if(endingTokenId  <= earlyMintTokenIdCap) {
1922       return EARLY_MINT_PRICE * _count;
1923     }
1924 
1925     // If the current token id is less than the incentive cap
1926     // and the ending token ID is greater than the incentive cap
1927     // we will be straddling the cap so there will be some amount
1928     // that are incentive and some that are regular fee.
1929     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1930     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1931 
1932     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1933   }
1934 }
1935 
1936   
1937   
1938 abstract contract RamppERC721A is 
1939     Ownable,
1940     Teams,
1941     ERC721ARedemption,
1942     WithdrawableV2,
1943     ReentrancyGuard 
1944     , EarlyMintIncentive 
1945      
1946     
1947 {
1948   constructor(
1949     string memory tokenName,
1950     string memory tokenSymbol
1951   ) ERC721A(tokenName, tokenSymbol, 3, 3600) { }
1952     uint8 constant public CONTRACT_VERSION = 2;
1953     string public _baseTokenURI = "ipfs://QmePdrQNAYizvEZgQE7gogQF3newccyiD6XoofsV3xn7yD/";
1954     string public _baseTokenExtension = ".json";
1955 
1956     bool public mintingOpen = true;
1957     bool public isRevealed;
1958     
1959     uint256 public MAX_WALLET_MINTS = 3;
1960 
1961   
1962     /////////////// Admin Mint Functions
1963     /**
1964      * @dev Mints a token to an address with a tokenURI.
1965      * This is owner only and allows a fee-free drop
1966      * @param _to address of the future owner of the token
1967      * @param _qty amount of tokens to drop the owner
1968      */
1969      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1970          if(_qty == 0) revert MintZeroQuantity();
1971          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1972          _safeMint(_to, _qty, true);
1973      }
1974 
1975   
1976     /////////////// PUBLIC MINT FUNCTIONS
1977     /**
1978     * @dev Mints tokens to an address in batch.
1979     * fee may or may not be required*
1980     * @param _to address of the future owner of the token
1981     * @param _amount number of tokens to mint
1982     */
1983     function mintToMultiple(address _to, uint256 _amount) public payable {
1984         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1985         if(_amount == 0) revert MintZeroQuantity();
1986         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1987         if(!mintingOpen) revert PublicMintClosed();
1988         
1989         
1990         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1991         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1992         if(msg.value != getPrice(_amount)) revert InvalidPayment();
1993 
1994         _safeMint(_to, _amount, false);
1995     }
1996 
1997     /**
1998      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1999      * fee may or may not be required*
2000      * @param _to address of the future owner of the token
2001      * @param _amount number of tokens to mint
2002      * @param _erc20TokenContract erc-20 token contract to mint with
2003      */
2004     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2005       if(_amount == 0) revert MintZeroQuantity();
2006       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2007       if(!mintingOpen) revert PublicMintClosed();
2008       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2009       
2010       
2011       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2012 
2013       // ERC-20 Specific pre-flight checks
2014       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2015       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2016       IERC20 payableToken = IERC20(_erc20TokenContract);
2017 
2018       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2019       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2020 
2021       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2022       if(!transferComplete) revert ERC20TransferFailed();
2023       
2024       _safeMint(_to, _amount, false);
2025     }
2026 
2027     function openMinting() public onlyTeamOrOwner {
2028         mintingOpen = true;
2029     }
2030 
2031     function stopMinting() public onlyTeamOrOwner {
2032         mintingOpen = false;
2033     }
2034 
2035   
2036 
2037   
2038     /**
2039     * @dev Check if wallet over MAX_WALLET_MINTS
2040     * @param _address address in question to check if minted count exceeds max
2041     */
2042     function canMintAmount(address _address, uint256 _amount) private view returns(bool) {
2043         if(_amount == 0) revert ValueCannotBeZero();
2044         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2045     }
2046 
2047     /**
2048     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2049     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2050     */
2051     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2052         if(_newWalletMax == 0) revert ValueCannotBeZero();
2053         MAX_WALLET_MINTS = _newWalletMax;
2054     }
2055     
2056 
2057   
2058     /**
2059      * @dev Allows owner to set Max mints per tx
2060      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2061      */
2062      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2063          if(_newMaxMint == 0) revert ValueCannotBeZero();
2064          maxBatchSize = _newMaxMint;
2065      }
2066     
2067 
2068   
2069     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2070         if(isRevealed) revert IsAlreadyUnveiled();
2071         _baseTokenURI = _updatedTokenURI;
2072         isRevealed = true;
2073     }
2074     
2075 
2076   function _baseURI() internal view virtual override returns(string memory) {
2077     return _baseTokenURI;
2078   }
2079 
2080   function _baseURIExtension() internal view virtual override returns(string memory) {
2081     return _baseTokenExtension;
2082   }
2083 
2084   function baseTokenURI() public view returns(string memory) {
2085     return _baseTokenURI;
2086   }
2087 
2088   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2089     _baseTokenURI = baseURI;
2090   }
2091 
2092   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2093     _baseTokenExtension = baseExtension;
2094   }
2095 }
2096 
2097 
2098   
2099 // File: contracts/WeebleWowblesContract.sol
2100 //SPDX-License-Identifier: MIT
2101 
2102 pragma solidity ^0.8.0;
2103 
2104 contract WeebleWowblesContract is RamppERC721A {
2105     constructor() RamppERC721A("Weeble Wowbles", "WBWB"){}
2106 }
2107   