1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //      ...     ..                                                 ..                              ..       
5 //   .=*8888x <"?88h.                                        x .d88"                             dF         
6 //  X>  '8888H> '8888          u.      u.    u.               5888R                  u.    u.   '88bu.      
7 // '88h. `8888   8888    ...ue888b   x@88k u@88c.      .u     '888R         u      x@88k u@88c. '*88888bu   
8 // '8888 '8888    "88>   888R Y888r ^"8888""8888"   ud8888.    888R      us888u.  ^"8888""8888"   ^"*8888N  
9 //  `888 '8888.xH888x.   888R I888>   8888  888R  :888'8888.   888R   .@88 "8888"   8888  888R   beWE "888L 
10 //    X" :88*~  `*8888>  888R I888>   8888  888R  d888 '88%"   888R   9888  9888    8888  888R   888E  888E 
11 //  ~"   !"`      "888>  888R I888>   8888  888R  8888.+"      888R   9888  9888    8888  888R   888E  888E 
12 //   .H8888h.      ?88  u8888cJ888    8888  888R  8888L        888R   9888  9888    8888  888R   888E  888F 
13 //  :"^"88888h.    '!    "*888*P"    "*88*" 8888" '8888c. .+  .888B . 9888  9888   "*88*" 8888" .888N..888  
14 //  ^    "88888hx.+"       'Y"         ""   'Y"    "88888%    ^*888%  "888*""888"    ""   'Y"    `"888*""   
15 //         ^"**""                                    "YP'       "%     ^Y"   ^Y'                    ""      
16 //                                                                                                          
17 //                                                                                                          
18 //                                                                                                          
19 //
20 //*********************************************************************//
21 //*********************************************************************//
22   
23 //-------------DEPENDENCIES--------------------------//
24 
25 // File: @openzeppelin/contracts/utils/Address.sol
26 
27 
28 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
29 
30 pragma solidity ^0.8.1;
31 
32 /**
33  * @dev Collection of functions related to the address type
34  */
35 library Address {
36     /**
37      * @dev Returns true if account is a contract.
38      *
39      * [IMPORTANT]
40      * ====
41      * It is unsafe to assume that an address for which this function returns
42      * false is an externally-owned account (EOA) and not a contract.
43      *
44      * Among others, isContract will return false for the following
45      * types of addresses:
46      *
47      *  - an externally-owned account
48      *  - a contract in construction
49      *  - an address where a contract will be created
50      *  - an address where a contract lived, but was destroyed
51      * ====
52      *
53      * [IMPORTANT]
54      * ====
55      * You shouldn't rely on isContract to protect against flash loan attacks!
56      *
57      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
58      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
59      * constructor.
60      * ====
61      */
62     function isContract(address account) internal view returns (bool) {
63         // This method relies on extcodesize/address.code.length, which returns 0
64         // for contracts in construction, since the code is only stored at the end
65         // of the constructor execution.
66 
67         return account.code.length > 0;
68     }
69 
70     /**
71      * @dev Replacement for Solidity's transfer: sends amount wei to
72      * recipient, forwarding all available gas and reverting on errors.
73      *
74      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
75      * of certain opcodes, possibly making contracts go over the 2300 gas limit
76      * imposed by transfer, making them unable to receive funds via
77      * transfer. {sendValue} removes this limitation.
78      *
79      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
80      *
81      * IMPORTANT: because control is transferred to recipient, care must be
82      * taken to not create reentrancy vulnerabilities. Consider using
83      * {ReentrancyGuard} or the
84      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
85      */
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88 
89         (bool success, ) = recipient.call{value: amount}("");
90         require(success, "Address: unable to send value, recipient may have reverted");
91     }
92 
93     /**
94      * @dev Performs a Solidity function call using a low level call. A
95      * plain call is an unsafe replacement for a function call: use this
96      * function instead.
97      *
98      * If target reverts with a revert reason, it is bubbled up by this
99      * function (like regular Solidity function calls).
100      *
101      * Returns the raw returned data. To convert to the expected return value,
102      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
103      *
104      * Requirements:
105      *
106      * - target must be a contract.
107      * - calling target with data must not revert.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionCall(target, data, "Address: low-level call failed");
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
117      * errorMessage as a fallback revert reason when target reverts.
118      *
119      * _Available since v3.1._
120      */
121     function functionCall(
122         address target,
123         bytes memory data,
124         string memory errorMessage
125     ) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, 0, errorMessage);
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
131      * but also transferring value wei to target.
132      *
133      * Requirements:
134      *
135      * - the calling contract must have an ETH balance of at least value.
136      * - the called Solidity function must be payable.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value
144     ) internal returns (bytes memory) {
145         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
150      * with errorMessage as a fallback revert reason when target reverts.
151      *
152      * _Available since v3.1._
153      */
154     function functionCallWithValue(
155         address target,
156         bytes memory data,
157         uint256 value,
158         string memory errorMessage
159     ) internal returns (bytes memory) {
160         require(address(this).balance >= value, "Address: insufficient balance for call");
161         require(isContract(target), "Address: call to non-contract");
162 
163         (bool success, bytes memory returndata) = target.call{value: value}(data);
164         return verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
174         return functionStaticCall(target, data, "Address: low-level static call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
179      * but performing a static call.
180      *
181      * _Available since v3.3._
182      */
183     function functionStaticCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal view returns (bytes memory) {
188         require(isContract(target), "Address: static call to non-contract");
189 
190         (bool success, bytes memory returndata) = target.staticcall(data);
191         return verifyCallResult(success, returndata, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
201         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
206      * but performing a delegate call.
207      *
208      * _Available since v3.4._
209      */
210     function functionDelegateCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         require(isContract(target), "Address: delegate call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.delegatecall(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
223      * revert reason using the provided one.
224      *
225      * _Available since v4.3._
226      */
227     function verifyCallResult(
228         bool success,
229         bytes memory returndata,
230         string memory errorMessage
231     ) internal pure returns (bytes memory) {
232         if (success) {
233             return returndata;
234         } else {
235             // Look for revert reason and bubble it up if present
236             if (returndata.length > 0) {
237                 // The easiest way to bubble the revert reason is using memory via assembly
238 
239                 assembly {
240                     let returndata_size := mload(returndata)
241                     revert(add(32, returndata), returndata_size)
242                 }
243             } else {
244                 revert(errorMessage);
245             }
246         }
247     }
248 }
249 
250 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @title ERC721 token receiver interface
259  * @dev Interface for any contract that wants to support safeTransfers
260  * from ERC721 asset contracts.
261  */
262 interface IERC721Receiver {
263     /**
264      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
265      * by operator from from, this function is called.
266      *
267      * It must return its Solidity selector to confirm the token transfer.
268      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
269      *
270      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
271      */
272     function onERC721Received(
273         address operator,
274         address from,
275         uint256 tokenId,
276         bytes calldata data
277     ) external returns (bytes4);
278 }
279 
280 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 /**
288  * @dev Interface of the ERC165 standard, as defined in the
289  * https://eips.ethereum.org/EIPS/eip-165[EIP].
290  *
291  * Implementers can declare support of contract interfaces, which can then be
292  * queried by others ({ERC165Checker}).
293  *
294  * For an implementation, see {ERC165}.
295  */
296 interface IERC165 {
297     /**
298      * @dev Returns true if this contract implements the interface defined by
299      * interfaceId. See the corresponding
300      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
301      * to learn more about how these ids are created.
302      *
303      * This function call must use less than 30 000 gas.
304      */
305     function supportsInterface(bytes4 interfaceId) external view returns (bool);
306 }
307 
308 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
309 
310 
311 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
312 
313 pragma solidity ^0.8.0;
314 
315 
316 /**
317  * @dev Implementation of the {IERC165} interface.
318  *
319  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
320  * for the additional interface id that will be supported. For example:
321  *
322  * solidity
323  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
324  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
325  * }
326  * 
327  *
328  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
329  */
330 abstract contract ERC165 is IERC165 {
331     /**
332      * @dev See {IERC165-supportsInterface}.
333      */
334     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335         return interfaceId == type(IERC165).interfaceId;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
340 
341 
342 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 
347 /**
348  * @dev Required interface of an ERC721 compliant contract.
349  */
350 interface IERC721 is IERC165 {
351     /**
352      * @dev Emitted when tokenId token is transferred from from to to.
353      */
354     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when owner enables approved to manage the tokenId token.
358      */
359     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
363      */
364     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
365 
366     /**
367      * @dev Returns the number of tokens in owner's account.
368      */
369     function balanceOf(address owner) external view returns (uint256 balance);
370 
371     /**
372      * @dev Returns the owner of the tokenId token.
373      *
374      * Requirements:
375      *
376      * - tokenId must exist.
377      */
378     function ownerOf(uint256 tokenId) external view returns (address owner);
379 
380     /**
381      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
382      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
383      *
384      * Requirements:
385      *
386      * - from cannot be the zero address.
387      * - to cannot be the zero address.
388      * - tokenId token must exist and be owned by from.
389      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
390      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId
398     ) external;
399 
400     /**
401      * @dev Transfers tokenId token from from to to.
402      *
403      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
404      *
405      * Requirements:
406      *
407      * - from cannot be the zero address.
408      * - to cannot be the zero address.
409      * - tokenId token must be owned by from.
410      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
411      *
412      * Emits a {Transfer} event.
413      */
414     function transferFrom(
415         address from,
416         address to,
417         uint256 tokenId
418     ) external;
419 
420     /**
421      * @dev Gives permission to to to transfer tokenId token to another account.
422      * The approval is cleared when the token is transferred.
423      *
424      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
425      *
426      * Requirements:
427      *
428      * - The caller must own the token or be an approved operator.
429      * - tokenId must exist.
430      *
431      * Emits an {Approval} event.
432      */
433     function approve(address to, uint256 tokenId) external;
434 
435     /**
436      * @dev Returns the account approved for tokenId token.
437      *
438      * Requirements:
439      *
440      * - tokenId must exist.
441      */
442     function getApproved(uint256 tokenId) external view returns (address operator);
443 
444     /**
445      * @dev Approve or remove operator as an operator for the caller.
446      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
447      *
448      * Requirements:
449      *
450      * - The operator cannot be the caller.
451      *
452      * Emits an {ApprovalForAll} event.
453      */
454     function setApprovalForAll(address operator, bool _approved) external;
455 
456     /**
457      * @dev Returns if the operator is allowed to manage all of the assets of owner.
458      *
459      * See {setApprovalForAll}
460      */
461     function isApprovedForAll(address owner, address operator) external view returns (bool);
462 
463     /**
464      * @dev Safely transfers tokenId token from from to to.
465      *
466      * Requirements:
467      *
468      * - from cannot be the zero address.
469      * - to cannot be the zero address.
470      * - tokenId token must exist and be owned by from.
471      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
472      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId,
480         bytes calldata data
481     ) external;
482 }
483 
484 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
485 
486 
487 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
494  * @dev See https://eips.ethereum.org/EIPS/eip-721
495  */
496 interface IERC721Enumerable is IERC721 {
497     /**
498      * @dev Returns the total amount of tokens stored by the contract.
499      */
500     function totalSupply() external view returns (uint256);
501 
502     /**
503      * @dev Returns a token ID owned by owner at a given index of its token list.
504      * Use along with {balanceOf} to enumerate all of owner's tokens.
505      */
506     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
507 
508     /**
509      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
510      * Use along with {totalSupply} to enumerate all tokens.
511      */
512     function tokenByIndex(uint256 index) external view returns (uint256);
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
516 
517 
518 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 
523 /**
524  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
525  * @dev See https://eips.ethereum.org/EIPS/eip-721
526  */
527 interface IERC721Metadata is IERC721 {
528     /**
529      * @dev Returns the token collection name.
530      */
531     function name() external view returns (string memory);
532 
533     /**
534      * @dev Returns the token collection symbol.
535      */
536     function symbol() external view returns (string memory);
537 
538     /**
539      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
540      */
541     function tokenURI(uint256 tokenId) external view returns (string memory);
542 }
543 
544 // File: @openzeppelin/contracts/utils/Strings.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev String operations.
553  */
554 library Strings {
555     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
556 
557     /**
558      * @dev Converts a uint256 to its ASCII string decimal representation.
559      */
560     function toString(uint256 value) internal pure returns (string memory) {
561         // Inspired by OraclizeAPI's implementation - MIT licence
562         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
563 
564         if (value == 0) {
565             return "0";
566         }
567         uint256 temp = value;
568         uint256 digits;
569         while (temp != 0) {
570             digits++;
571             temp /= 10;
572         }
573         bytes memory buffer = new bytes(digits);
574         while (value != 0) {
575             digits -= 1;
576             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
577             value /= 10;
578         }
579         return string(buffer);
580     }
581 
582     /**
583      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
584      */
585     function toHexString(uint256 value) internal pure returns (string memory) {
586         if (value == 0) {
587             return "0x00";
588         }
589         uint256 temp = value;
590         uint256 length = 0;
591         while (temp != 0) {
592             length++;
593             temp >>= 8;
594         }
595         return toHexString(value, length);
596     }
597 
598     /**
599      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
600      */
601     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
602         bytes memory buffer = new bytes(2 * length + 2);
603         buffer[0] = "0";
604         buffer[1] = "x";
605         for (uint256 i = 2 * length + 1; i > 1; --i) {
606             buffer[i] = _HEX_SYMBOLS[value & 0xf];
607             value >>= 4;
608         }
609         require(value == 0, "Strings: hex length insufficient");
610         return string(buffer);
611     }
612 }
613 
614 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
615 
616 
617 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 /**
622  * @dev Contract module that helps prevent reentrant calls to a function.
623  *
624  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
625  * available, which can be applied to functions to make sure there are no nested
626  * (reentrant) calls to them.
627  *
628  * Note that because there is a single nonReentrant guard, functions marked as
629  * nonReentrant may not call one another. This can be worked around by making
630  * those functions private, and then adding external nonReentrant entry
631  * points to them.
632  *
633  * TIP: If you would like to learn more about reentrancy and alternative ways
634  * to protect against it, check out our blog post
635  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
636  */
637 abstract contract ReentrancyGuard {
638     // Booleans are more expensive than uint256 or any type that takes up a full
639     // word because each write operation emits an extra SLOAD to first read the
640     // slot's contents, replace the bits taken up by the boolean, and then write
641     // back. This is the compiler's defense against contract upgrades and
642     // pointer aliasing, and it cannot be disabled.
643 
644     // The values being non-zero value makes deployment a bit more expensive,
645     // but in exchange the refund on every call to nonReentrant will be lower in
646     // amount. Since refunds are capped to a percentage of the total
647     // transaction's gas, it is best to keep them low in cases like this one, to
648     // increase the likelihood of the full refund coming into effect.
649     uint256 private constant _NOT_ENTERED = 1;
650     uint256 private constant _ENTERED = 2;
651 
652     uint256 private _status;
653 
654     constructor() {
655         _status = _NOT_ENTERED;
656     }
657 
658     /**
659      * @dev Prevents a contract from calling itself, directly or indirectly.
660      * Calling a nonReentrant function from another nonReentrant
661      * function is not supported. It is possible to prevent this from happening
662      * by making the nonReentrant function external, and making it call a
663      * private function that does the actual work.
664      */
665     modifier nonReentrant() {
666         // On the first call to nonReentrant, _notEntered will be true
667         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
668 
669         // Any calls to nonReentrant after this point will fail
670         _status = _ENTERED;
671 
672         _;
673 
674         // By storing the original value once again, a refund is triggered (see
675         // https://eips.ethereum.org/EIPS/eip-2200)
676         _status = _NOT_ENTERED;
677     }
678 }
679 
680 // File: @openzeppelin/contracts/utils/Context.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev Provides information about the current execution context, including the
689  * sender of the transaction and its data. While these are generally available
690  * via msg.sender and msg.data, they should not be accessed in such a direct
691  * manner, since when dealing with meta-transactions the account sending and
692  * paying for execution may not be the actual sender (as far as an application
693  * is concerned).
694  *
695  * This contract is only required for intermediate, library-like contracts.
696  */
697 abstract contract Context {
698     function _msgSender() internal view virtual returns (address) {
699         return msg.sender;
700     }
701 
702     function _msgData() internal view virtual returns (bytes calldata) {
703         return msg.data;
704     }
705 }
706 
707 // File: @openzeppelin/contracts/access/Ownable.sol
708 
709 
710 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @dev Contract module which provides a basic access control mechanism, where
717  * there is an account (an owner) that can be granted exclusive access to
718  * specific functions.
719  *
720  * By default, the owner account will be the one that deploys the contract. This
721  * can later be changed with {transferOwnership}.
722  *
723  * This module is used through inheritance. It will make available the modifier
724  * onlyOwner, which can be applied to your functions to restrict their use to
725  * the owner.
726  */
727 abstract contract Ownable is Context {
728     address private _owner;
729 
730     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
731 
732     /**
733      * @dev Initializes the contract setting the deployer as the initial owner.
734      */
735     constructor() {
736         _transferOwnership(_msgSender());
737     }
738 
739     /**
740      * @dev Returns the address of the current owner.
741      */
742     function owner() public view virtual returns (address) {
743         return _owner;
744     }
745 
746     /**
747      * @dev Throws if called by any account other than the owner.
748      */
749     modifier onlyOwner() {
750         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
784 //-------------END DEPENDENCIES------------------------//
785 
786 
787   
788 // Rampp Contracts v2.1 (Teams.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 /**
793 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
794 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
795 * This will easily allow cross-collaboration via Mintplex.xyz.
796 **/
797 abstract contract Teams is Ownable{
798   mapping (address => bool) internal team;
799 
800   /**
801   * @dev Adds an address to the team. Allows them to execute protected functions
802   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
803   **/
804   function addToTeam(address _address) public onlyOwner {
805     require(_address != address(0), "Invalid address");
806     require(!inTeam(_address), "This address is already in your team.");
807   
808     team[_address] = true;
809   }
810 
811   /**
812   * @dev Removes an address to the team.
813   * @param _address the ETH address to remove, cannot be 0x and must be in team
814   **/
815   function removeFromTeam(address _address) public onlyOwner {
816     require(_address != address(0), "Invalid address");
817     require(inTeam(_address), "This address is not in your team currently.");
818   
819     team[_address] = false;
820   }
821 
822   /**
823   * @dev Check if an address is valid and active in the team
824   * @param _address ETH address to check for truthiness
825   **/
826   function inTeam(address _address)
827     public
828     view
829     returns (bool)
830   {
831     require(_address != address(0), "Invalid address to check.");
832     return team[_address] == true;
833   }
834 
835   /**
836   * @dev Throws if called by any account other than the owner or team member.
837   */
838   modifier onlyTeamOrOwner() {
839     bool _isOwner = owner() == _msgSender();
840     bool _isTeam = inTeam(_msgSender());
841     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
842     _;
843   }
844 }
845 
846 
847   
848   pragma solidity ^0.8.0;
849 
850   /**
851   * @dev These functions deal with verification of Merkle Trees proofs.
852   *
853   * The proofs can be generated using the JavaScript library
854   * https://github.com/miguelmota/merkletreejs[merkletreejs].
855   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
856   *
857   *
858   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
859   * hashing, or use a hash function other than keccak256 for hashing leaves.
860   * This is because the concatenation of a sorted pair of internal nodes in
861   * the merkle tree could be reinterpreted as a leaf value.
862   */
863   library MerkleProof {
864       /**
865       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
866       * defined by 'root'. For this, a 'proof' must be provided, containing
867       * sibling hashes on the branch from the leaf to the root of the tree. Each
868       * pair of leaves and each pair of pre-images are assumed to be sorted.
869       */
870       function verify(
871           bytes32[] memory proof,
872           bytes32 root,
873           bytes32 leaf
874       ) internal pure returns (bool) {
875           return processProof(proof, leaf) == root;
876       }
877 
878       /**
879       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
880       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
881       * hash matches the root of the tree. When processing the proof, the pairs
882       * of leafs & pre-images are assumed to be sorted.
883       *
884       * _Available since v4.4._
885       */
886       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
887           bytes32 computedHash = leaf;
888           for (uint256 i = 0; i < proof.length; i++) {
889               bytes32 proofElement = proof[i];
890               if (computedHash <= proofElement) {
891                   // Hash(current computed hash + current element of the proof)
892                   computedHash = _efficientHash(computedHash, proofElement);
893               } else {
894                   // Hash(current element of the proof + current computed hash)
895                   computedHash = _efficientHash(proofElement, computedHash);
896               }
897           }
898           return computedHash;
899       }
900 
901       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
902           assembly {
903               mstore(0x00, a)
904               mstore(0x20, b)
905               value := keccak256(0x00, 0x40)
906           }
907       }
908   }
909 
910 
911   // File: Allowlist.sol
912 
913   pragma solidity ^0.8.0;
914 
915   abstract contract Allowlist is Teams {
916     bytes32 public merkleRoot;
917     bool public onlyAllowlistMode = false;
918 
919     /**
920      * @dev Update merkle root to reflect changes in Allowlist
921      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
922      */
923     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
924       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
925       merkleRoot = _newMerkleRoot;
926     }
927 
928     /**
929      * @dev Check the proof of an address if valid for merkle root
930      * @param _to address to check for proof
931      * @param _merkleProof Proof of the address to validate against root and leaf
932      */
933     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
934       require(merkleRoot != 0, "Merkle root is not set!");
935       bytes32 leaf = keccak256(abi.encodePacked(_to));
936 
937       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
938     }
939 
940     
941     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
942       onlyAllowlistMode = true;
943     }
944 
945     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
946         onlyAllowlistMode = false;
947     }
948   }
949   
950   
951 /**
952  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
953  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
954  *
955  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
956  * 
957  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
958  *
959  * Does not support burning tokens to address(0).
960  */
961 contract ERC721A is
962   Context,
963   ERC165,
964   IERC721,
965   IERC721Metadata,
966   IERC721Enumerable,
967   Teams
968 {
969   using Address for address;
970   using Strings for uint256;
971 
972   struct TokenOwnership {
973     address addr;
974     uint64 startTimestamp;
975   }
976 
977   struct AddressData {
978     uint128 balance;
979     uint128 numberMinted;
980   }
981 
982   uint256 private currentIndex;
983 
984   uint256 public immutable collectionSize;
985   uint256 public maxBatchSize;
986 
987   // Token name
988   string private _name;
989 
990   // Token symbol
991   string private _symbol;
992 
993   // Mapping from token ID to ownership details
994   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
995   mapping(uint256 => TokenOwnership) private _ownerships;
996 
997   // Mapping owner address to address data
998   mapping(address => AddressData) private _addressData;
999 
1000   // Mapping from token ID to approved address
1001   mapping(uint256 => address) private _tokenApprovals;
1002 
1003   // Mapping from owner to operator approvals
1004   mapping(address => mapping(address => bool)) private _operatorApprovals;
1005 
1006   /* @dev Mapping of restricted operator approvals set by contract Owner
1007   * This serves as an optional addition to ERC-721 so
1008   * that the contract owner can elect to prevent specific addresses/contracts
1009   * from being marked as the approver for a token. The reason for this
1010   * is that some projects may want to retain control of where their tokens can/can not be listed
1011   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1012   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1013   */
1014   mapping(address => bool) public restrictedApprovalAddresses;
1015 
1016   /**
1017    * @dev
1018    * maxBatchSize refers to how much a minter can mint at a time.
1019    * collectionSize_ refers to how many tokens are in the collection.
1020    */
1021   constructor(
1022     string memory name_,
1023     string memory symbol_,
1024     uint256 maxBatchSize_,
1025     uint256 collectionSize_
1026   ) {
1027     require(
1028       collectionSize_ > 0,
1029       "ERC721A: collection must have a nonzero supply"
1030     );
1031     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1032     _name = name_;
1033     _symbol = symbol_;
1034     maxBatchSize = maxBatchSize_;
1035     collectionSize = collectionSize_;
1036     currentIndex = _startTokenId();
1037   }
1038 
1039   /**
1040   * To change the starting tokenId, please override this function.
1041   */
1042   function _startTokenId() internal view virtual returns (uint256) {
1043     return 1;
1044   }
1045 
1046   /**
1047    * @dev See {IERC721Enumerable-totalSupply}.
1048    */
1049   function totalSupply() public view override returns (uint256) {
1050     return _totalMinted();
1051   }
1052 
1053   function currentTokenId() public view returns (uint256) {
1054     return _totalMinted();
1055   }
1056 
1057   function getNextTokenId() public view returns (uint256) {
1058       return _totalMinted() + 1;
1059   }
1060 
1061   /**
1062   * Returns the total amount of tokens minted in the contract.
1063   */
1064   function _totalMinted() internal view returns (uint256) {
1065     unchecked {
1066       return currentIndex - _startTokenId();
1067     }
1068   }
1069 
1070   /**
1071    * @dev See {IERC721Enumerable-tokenByIndex}.
1072    */
1073   function tokenByIndex(uint256 index) public view override returns (uint256) {
1074     require(index < totalSupply(), "ERC721A: global index out of bounds");
1075     return index;
1076   }
1077 
1078   /**
1079    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1080    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1081    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1082    */
1083   function tokenOfOwnerByIndex(address owner, uint256 index)
1084     public
1085     view
1086     override
1087     returns (uint256)
1088   {
1089     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1090     uint256 numMintedSoFar = totalSupply();
1091     uint256 tokenIdsIdx = 0;
1092     address currOwnershipAddr = address(0);
1093     for (uint256 i = 0; i < numMintedSoFar; i++) {
1094       TokenOwnership memory ownership = _ownerships[i];
1095       if (ownership.addr != address(0)) {
1096         currOwnershipAddr = ownership.addr;
1097       }
1098       if (currOwnershipAddr == owner) {
1099         if (tokenIdsIdx == index) {
1100           return i;
1101         }
1102         tokenIdsIdx++;
1103       }
1104     }
1105     revert("ERC721A: unable to get token of owner by index");
1106   }
1107 
1108   /**
1109    * @dev See {IERC165-supportsInterface}.
1110    */
1111   function supportsInterface(bytes4 interfaceId)
1112     public
1113     view
1114     virtual
1115     override(ERC165, IERC165)
1116     returns (bool)
1117   {
1118     return
1119       interfaceId == type(IERC721).interfaceId ||
1120       interfaceId == type(IERC721Metadata).interfaceId ||
1121       interfaceId == type(IERC721Enumerable).interfaceId ||
1122       super.supportsInterface(interfaceId);
1123   }
1124 
1125   /**
1126    * @dev See {IERC721-balanceOf}.
1127    */
1128   function balanceOf(address owner) public view override returns (uint256) {
1129     require(owner != address(0), "ERC721A: balance query for the zero address");
1130     return uint256(_addressData[owner].balance);
1131   }
1132 
1133   function _numberMinted(address owner) internal view returns (uint256) {
1134     require(
1135       owner != address(0),
1136       "ERC721A: number minted query for the zero address"
1137     );
1138     return uint256(_addressData[owner].numberMinted);
1139   }
1140 
1141   function ownershipOf(uint256 tokenId)
1142     internal
1143     view
1144     returns (TokenOwnership memory)
1145   {
1146     uint256 curr = tokenId;
1147 
1148     unchecked {
1149         if (_startTokenId() <= curr && curr < currentIndex) {
1150             TokenOwnership memory ownership = _ownerships[curr];
1151             if (ownership.addr != address(0)) {
1152                 return ownership;
1153             }
1154 
1155             // Invariant:
1156             // There will always be an ownership that has an address and is not burned
1157             // before an ownership that does not have an address and is not burned.
1158             // Hence, curr will not underflow.
1159             while (true) {
1160                 curr--;
1161                 ownership = _ownerships[curr];
1162                 if (ownership.addr != address(0)) {
1163                     return ownership;
1164                 }
1165             }
1166         }
1167     }
1168 
1169     revert("ERC721A: unable to determine the owner of token");
1170   }
1171 
1172   /**
1173    * @dev See {IERC721-ownerOf}.
1174    */
1175   function ownerOf(uint256 tokenId) public view override returns (address) {
1176     return ownershipOf(tokenId).addr;
1177   }
1178 
1179   /**
1180    * @dev See {IERC721Metadata-name}.
1181    */
1182   function name() public view virtual override returns (string memory) {
1183     return _name;
1184   }
1185 
1186   /**
1187    * @dev See {IERC721Metadata-symbol}.
1188    */
1189   function symbol() public view virtual override returns (string memory) {
1190     return _symbol;
1191   }
1192 
1193   /**
1194    * @dev See {IERC721Metadata-tokenURI}.
1195    */
1196   function tokenURI(uint256 tokenId)
1197     public
1198     view
1199     virtual
1200     override
1201     returns (string memory)
1202   {
1203     string memory baseURI = _baseURI();
1204     return
1205       bytes(baseURI).length > 0
1206         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1207         : "";
1208   }
1209 
1210   /**
1211    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1212    * token will be the concatenation of the baseURI and the tokenId. Empty
1213    * by default, can be overriden in child contracts.
1214    */
1215   function _baseURI() internal view virtual returns (string memory) {
1216     return "";
1217   }
1218 
1219   /**
1220    * @dev Sets the value for an address to be in the restricted approval address pool.
1221    * Setting an address to true will disable token owners from being able to mark the address
1222    * for approval for trading. This would be used in theory to prevent token owners from listing
1223    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1224    * @param _address the marketplace/user to modify restriction status of
1225    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1226    */
1227   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1228     restrictedApprovalAddresses[_address] = _isRestricted;
1229   }
1230 
1231   /**
1232    * @dev See {IERC721-approve}.
1233    */
1234   function approve(address to, uint256 tokenId) public override {
1235     address owner = ERC721A.ownerOf(tokenId);
1236     require(to != owner, "ERC721A: approval to current owner");
1237     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1238 
1239     require(
1240       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1241       "ERC721A: approve caller is not owner nor approved for all"
1242     );
1243 
1244     _approve(to, tokenId, owner);
1245   }
1246 
1247   /**
1248    * @dev See {IERC721-getApproved}.
1249    */
1250   function getApproved(uint256 tokenId) public view override returns (address) {
1251     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1252 
1253     return _tokenApprovals[tokenId];
1254   }
1255 
1256   /**
1257    * @dev See {IERC721-setApprovalForAll}.
1258    */
1259   function setApprovalForAll(address operator, bool approved) public override {
1260     require(operator != _msgSender(), "ERC721A: approve to caller");
1261     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1262 
1263     _operatorApprovals[_msgSender()][operator] = approved;
1264     emit ApprovalForAll(_msgSender(), operator, approved);
1265   }
1266 
1267   /**
1268    * @dev See {IERC721-isApprovedForAll}.
1269    */
1270   function isApprovedForAll(address owner, address operator)
1271     public
1272     view
1273     virtual
1274     override
1275     returns (bool)
1276   {
1277     return _operatorApprovals[owner][operator];
1278   }
1279 
1280   /**
1281    * @dev See {IERC721-transferFrom}.
1282    */
1283   function transferFrom(
1284     address from,
1285     address to,
1286     uint256 tokenId
1287   ) public override {
1288     _transfer(from, to, tokenId);
1289   }
1290 
1291   /**
1292    * @dev See {IERC721-safeTransferFrom}.
1293    */
1294   function safeTransferFrom(
1295     address from,
1296     address to,
1297     uint256 tokenId
1298   ) public override {
1299     safeTransferFrom(from, to, tokenId, "");
1300   }
1301 
1302   /**
1303    * @dev See {IERC721-safeTransferFrom}.
1304    */
1305   function safeTransferFrom(
1306     address from,
1307     address to,
1308     uint256 tokenId,
1309     bytes memory _data
1310   ) public override {
1311     _transfer(from, to, tokenId);
1312     require(
1313       _checkOnERC721Received(from, to, tokenId, _data),
1314       "ERC721A: transfer to non ERC721Receiver implementer"
1315     );
1316   }
1317 
1318   /**
1319    * @dev Returns whether tokenId exists.
1320    *
1321    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1322    *
1323    * Tokens start existing when they are minted (_mint),
1324    */
1325   function _exists(uint256 tokenId) internal view returns (bool) {
1326     return _startTokenId() <= tokenId && tokenId < currentIndex;
1327   }
1328 
1329   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1330     _safeMint(to, quantity, isAdminMint, "");
1331   }
1332 
1333   /**
1334    * @dev Mints quantity tokens and transfers them to to.
1335    *
1336    * Requirements:
1337    *
1338    * - there must be quantity tokens remaining unminted in the total collection.
1339    * - to cannot be the zero address.
1340    * - quantity cannot be larger than the max batch size.
1341    *
1342    * Emits a {Transfer} event.
1343    */
1344   function _safeMint(
1345     address to,
1346     uint256 quantity,
1347     bool isAdminMint,
1348     bytes memory _data
1349   ) internal {
1350     uint256 startTokenId = currentIndex;
1351     require(to != address(0), "ERC721A: mint to the zero address");
1352     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1353     require(!_exists(startTokenId), "ERC721A: token already minted");
1354 
1355     // For admin mints we do not want to enforce the maxBatchSize limit
1356     if (isAdminMint == false) {
1357         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1358     }
1359 
1360     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1361 
1362     AddressData memory addressData = _addressData[to];
1363     _addressData[to] = AddressData(
1364       addressData.balance + uint128(quantity),
1365       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1366     );
1367     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1368 
1369     uint256 updatedIndex = startTokenId;
1370 
1371     for (uint256 i = 0; i < quantity; i++) {
1372       emit Transfer(address(0), to, updatedIndex);
1373       require(
1374         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1375         "ERC721A: transfer to non ERC721Receiver implementer"
1376       );
1377       updatedIndex++;
1378     }
1379 
1380     currentIndex = updatedIndex;
1381     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1382   }
1383 
1384   /**
1385    * @dev Transfers tokenId from from to to.
1386    *
1387    * Requirements:
1388    *
1389    * - to cannot be the zero address.
1390    * - tokenId token must be owned by from.
1391    *
1392    * Emits a {Transfer} event.
1393    */
1394   function _transfer(
1395     address from,
1396     address to,
1397     uint256 tokenId
1398   ) private {
1399     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1400 
1401     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1402       getApproved(tokenId) == _msgSender() ||
1403       isApprovedForAll(prevOwnership.addr, _msgSender()));
1404 
1405     require(
1406       isApprovedOrOwner,
1407       "ERC721A: transfer caller is not owner nor approved"
1408     );
1409 
1410     require(
1411       prevOwnership.addr == from,
1412       "ERC721A: transfer from incorrect owner"
1413     );
1414     require(to != address(0), "ERC721A: transfer to the zero address");
1415 
1416     _beforeTokenTransfers(from, to, tokenId, 1);
1417 
1418     // Clear approvals from the previous owner
1419     _approve(address(0), tokenId, prevOwnership.addr);
1420 
1421     _addressData[from].balance -= 1;
1422     _addressData[to].balance += 1;
1423     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1424 
1425     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1426     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1427     uint256 nextTokenId = tokenId + 1;
1428     if (_ownerships[nextTokenId].addr == address(0)) {
1429       if (_exists(nextTokenId)) {
1430         _ownerships[nextTokenId] = TokenOwnership(
1431           prevOwnership.addr,
1432           prevOwnership.startTimestamp
1433         );
1434       }
1435     }
1436 
1437     emit Transfer(from, to, tokenId);
1438     _afterTokenTransfers(from, to, tokenId, 1);
1439   }
1440 
1441   /**
1442    * @dev Approve to to operate on tokenId
1443    *
1444    * Emits a {Approval} event.
1445    */
1446   function _approve(
1447     address to,
1448     uint256 tokenId,
1449     address owner
1450   ) private {
1451     _tokenApprovals[tokenId] = to;
1452     emit Approval(owner, to, tokenId);
1453   }
1454 
1455   uint256 public nextOwnerToExplicitlySet = 0;
1456 
1457   /**
1458    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1459    */
1460   function _setOwnersExplicit(uint256 quantity) internal {
1461     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1462     require(quantity > 0, "quantity must be nonzero");
1463     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1464 
1465     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1466     if (endIndex > collectionSize - 1) {
1467       endIndex = collectionSize - 1;
1468     }
1469     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1470     require(_exists(endIndex), "not enough minted yet for this cleanup");
1471     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1472       if (_ownerships[i].addr == address(0)) {
1473         TokenOwnership memory ownership = ownershipOf(i);
1474         _ownerships[i] = TokenOwnership(
1475           ownership.addr,
1476           ownership.startTimestamp
1477         );
1478       }
1479     }
1480     nextOwnerToExplicitlySet = endIndex + 1;
1481   }
1482 
1483   /**
1484    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1485    * The call is not executed if the target address is not a contract.
1486    *
1487    * @param from address representing the previous owner of the given token ID
1488    * @param to target address that will receive the tokens
1489    * @param tokenId uint256 ID of the token to be transferred
1490    * @param _data bytes optional data to send along with the call
1491    * @return bool whether the call correctly returned the expected magic value
1492    */
1493   function _checkOnERC721Received(
1494     address from,
1495     address to,
1496     uint256 tokenId,
1497     bytes memory _data
1498   ) private returns (bool) {
1499     if (to.isContract()) {
1500       try
1501         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1502       returns (bytes4 retval) {
1503         return retval == IERC721Receiver(to).onERC721Received.selector;
1504       } catch (bytes memory reason) {
1505         if (reason.length == 0) {
1506           revert("ERC721A: transfer to non ERC721Receiver implementer");
1507         } else {
1508           assembly {
1509             revert(add(32, reason), mload(reason))
1510           }
1511         }
1512       }
1513     } else {
1514       return true;
1515     }
1516   }
1517 
1518   /**
1519    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1520    *
1521    * startTokenId - the first token id to be transferred
1522    * quantity - the amount to be transferred
1523    *
1524    * Calling conditions:
1525    *
1526    * - When from and to are both non-zero, from's tokenId will be
1527    * transferred to to.
1528    * - When from is zero, tokenId will be minted for to.
1529    */
1530   function _beforeTokenTransfers(
1531     address from,
1532     address to,
1533     uint256 startTokenId,
1534     uint256 quantity
1535   ) internal virtual {}
1536 
1537   /**
1538    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1539    * minting.
1540    *
1541    * startTokenId - the first token id to be transferred
1542    * quantity - the amount to be transferred
1543    *
1544    * Calling conditions:
1545    *
1546    * - when from and to are both non-zero.
1547    * - from and to are never both zero.
1548    */
1549   function _afterTokenTransfers(
1550     address from,
1551     address to,
1552     uint256 startTokenId,
1553     uint256 quantity
1554   ) internal virtual {}
1555 }
1556 
1557 
1558 
1559   
1560 abstract contract Ramppable {
1561   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1562 
1563   modifier isRampp() {
1564       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1565       _;
1566   }
1567 }
1568 
1569 
1570   
1571   
1572 interface IERC20 {
1573   function allowance(address owner, address spender) external view returns (uint256);
1574   function transfer(address _to, uint256 _amount) external returns (bool);
1575   function balanceOf(address account) external view returns (uint256);
1576   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1577 }
1578 
1579 // File: WithdrawableV2
1580 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1581 // ERC-20 Payouts are limited to a single payout address. This feature 
1582 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1583 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1584 abstract contract WithdrawableV2 is Teams, Ramppable {
1585   struct acceptedERC20 {
1586     bool isActive;
1587     uint256 chargeAmount;
1588   }
1589 
1590   
1591   mapping(address => acceptedERC20) private allowedTokenContracts;
1592   address[] public payableAddresses = [RAMPPADDRESS,0xd0343cF182A90565d5D11d58B759fa04261b34A2];
1593   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1594   address public erc20Payable = 0xd0343cF182A90565d5D11d58B759fa04261b34A2;
1595   uint256[] public payableFees = [5,95];
1596   uint256[] public surchargePayableFees = [100];
1597   uint256 public payableAddressCount = 2;
1598   uint256 public surchargePayableAddressCount = 1;
1599   uint256 public ramppSurchargeBalance = 0 ether;
1600   uint256 public ramppSurchargeFee = 0.001 ether;
1601   bool public onlyERC20MintingMode = false;
1602   
1603 
1604   /**
1605   * @dev Calculates the true payable balance of the contract as the
1606   * value on contract may be from ERC-20 mint surcharges and not 
1607   * public mint charges - which are not eligable for rev share & user withdrawl
1608   */
1609   function calcAvailableBalance() public view returns(uint256) {
1610     return address(this).balance - ramppSurchargeBalance;
1611   }
1612 
1613   function withdrawAll() public onlyTeamOrOwner {
1614       require(calcAvailableBalance() > 0);
1615       _withdrawAll();
1616   }
1617   
1618   function withdrawAllRampp() public isRampp {
1619       require(calcAvailableBalance() > 0);
1620       _withdrawAll();
1621   }
1622 
1623   function _withdrawAll() private {
1624       uint256 balance = calcAvailableBalance();
1625       
1626       for(uint i=0; i < payableAddressCount; i++ ) {
1627           _widthdraw(
1628               payableAddresses[i],
1629               (balance * payableFees[i]) / 100
1630           );
1631       }
1632   }
1633   
1634   function _widthdraw(address _address, uint256 _amount) private {
1635       (bool success, ) = _address.call{value: _amount}("");
1636       require(success, "Transfer failed.");
1637   }
1638 
1639   /**
1640   * @dev This function is similiar to the regular withdraw but operates only on the
1641   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1642   **/
1643   function _withdrawAllSurcharges() private {
1644     uint256 balance = ramppSurchargeBalance;
1645     if(balance == 0) { return; }
1646     
1647     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1648         _widthdraw(
1649             surchargePayableAddresses[i],
1650             (balance * surchargePayableFees[i]) / 100
1651         );
1652     }
1653     ramppSurchargeBalance = 0 ether;
1654   }
1655 
1656   /**
1657   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1658   * in the event ERC-20 tokens are paid to the contract for mints. This will
1659   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1660   * @param _tokenContract contract of ERC-20 token to withdraw
1661   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1662   */
1663   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1664     require(_amountToWithdraw > 0);
1665     IERC20 tokenContract = IERC20(_tokenContract);
1666     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1667     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1668     _withdrawAllSurcharges();
1669   }
1670 
1671   /**
1672   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1673   */
1674   function withdrawRamppSurcharges() public isRampp {
1675     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1676     _withdrawAllSurcharges();
1677   }
1678 
1679    /**
1680   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1681   */
1682   function addSurcharge() internal {
1683     ramppSurchargeBalance += ramppSurchargeFee;
1684   }
1685   
1686   /**
1687   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1688   */
1689   function hasSurcharge() internal returns(bool) {
1690     return msg.value == ramppSurchargeFee;
1691   }
1692 
1693   /**
1694   * @dev Set surcharge fee for using ERC-20 payments on contract
1695   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1696   */
1697   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1698     ramppSurchargeFee = _newSurcharge;
1699   }
1700 
1701   /**
1702   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1703   * @param _erc20TokenContract address of ERC-20 contract in question
1704   */
1705   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1706     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1707   }
1708 
1709   /**
1710   * @dev get the value of tokens to transfer for user of an ERC-20
1711   * @param _erc20TokenContract address of ERC-20 contract in question
1712   */
1713   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1714     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1715     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1716   }
1717 
1718   /**
1719   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1720   * @param _erc20TokenContract address of ERC-20 contract in question
1721   * @param _isActive default status of if contract should be allowed to accept payments
1722   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1723   */
1724   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1725     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1726     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1727   }
1728 
1729   /**
1730   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1731   * it will assume the default value of zero. This should not be used to create new payment tokens.
1732   * @param _erc20TokenContract address of ERC-20 contract in question
1733   */
1734   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1735     allowedTokenContracts[_erc20TokenContract].isActive = true;
1736   }
1737 
1738   /**
1739   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1740   * it will assume the default value of zero. This should not be used to create new payment tokens.
1741   * @param _erc20TokenContract address of ERC-20 contract in question
1742   */
1743   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1744     allowedTokenContracts[_erc20TokenContract].isActive = false;
1745   }
1746 
1747   /**
1748   * @dev Enable only ERC-20 payments for minting on this contract
1749   */
1750   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1751     onlyERC20MintingMode = true;
1752   }
1753 
1754   /**
1755   * @dev Disable only ERC-20 payments for minting on this contract
1756   */
1757   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1758     onlyERC20MintingMode = false;
1759   }
1760 
1761   /**
1762   * @dev Set the payout of the ERC-20 token payout to a specific address
1763   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1764   */
1765   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1766     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1767     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1768     erc20Payable = _newErc20Payable;
1769   }
1770 
1771   /**
1772   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1773   */
1774   function resetRamppSurchargeBalance() public isRampp {
1775     ramppSurchargeBalance = 0 ether;
1776   }
1777 
1778   /**
1779   * @dev Allows Rampp wallet to update its own reference as well as update
1780   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1781   * and since Rampp is always the first address this function is limited to the rampp payout only.
1782   * @param _newAddress updated Rampp Address
1783   */
1784   function setRamppAddress(address _newAddress) public isRampp {
1785     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1786     RAMPPADDRESS = _newAddress;
1787     payableAddresses[0] = _newAddress;
1788   }
1789 }
1790 
1791 
1792   
1793   
1794 // File: EarlyMintIncentive.sol
1795 // Allows the contract to have the first x tokens have a discount or
1796 // zero fee that can be calculated on the fly.
1797 abstract contract EarlyMintIncentive is Teams, ERC721A {
1798   uint256 public PRICE = 0.25 ether;
1799   uint256 public EARLY_MINT_PRICE = 0.1 ether;
1800   uint256 public earlyMintTokenIdCap = 100;
1801   bool public usingEarlyMintIncentive = true;
1802 
1803   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1804     usingEarlyMintIncentive = true;
1805   }
1806 
1807   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1808     usingEarlyMintIncentive = false;
1809   }
1810 
1811   /**
1812   * @dev Set the max token ID in which the cost incentive will be applied.
1813   * @param _newTokenIdCap max tokenId in which incentive will be applied
1814   */
1815   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1816     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1817     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1818     earlyMintTokenIdCap = _newTokenIdCap;
1819   }
1820 
1821   /**
1822   * @dev Set the incentive mint price
1823   * @param _feeInWei new price per token when in incentive range
1824   */
1825   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1826     EARLY_MINT_PRICE = _feeInWei;
1827   }
1828 
1829   /**
1830   * @dev Set the primary mint price - the base price when not under incentive
1831   * @param _feeInWei new price per token
1832   */
1833   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1834     PRICE = _feeInWei;
1835   }
1836 
1837   function getPrice(uint256 _count) public view returns (uint256) {
1838     require(_count > 0, "Must be minting at least 1 token.");
1839 
1840     // short circuit function if we dont need to even calc incentive pricing
1841     // short circuit if the current tokenId is also already over cap
1842     if(
1843       usingEarlyMintIncentive == false ||
1844       currentTokenId() > earlyMintTokenIdCap
1845     ) {
1846       return PRICE * _count;
1847     }
1848 
1849     uint256 endingTokenId = currentTokenId() + _count;
1850     // If qty to mint results in a final token ID less than or equal to the cap then
1851     // the entire qty is within free mint.
1852     if(endingTokenId  <= earlyMintTokenIdCap) {
1853       return EARLY_MINT_PRICE * _count;
1854     }
1855 
1856     // If the current token id is less than the incentive cap
1857     // and the ending token ID is greater than the incentive cap
1858     // we will be straddling the cap so there will be some amount
1859     // that are incentive and some that are regular fee.
1860     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1861     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1862 
1863     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1864   }
1865 }
1866 
1867   
1868   
1869 abstract contract RamppERC721A is 
1870     Ownable,
1871     Teams,
1872     ERC721A,
1873     WithdrawableV2,
1874     ReentrancyGuard 
1875     , EarlyMintIncentive 
1876     , Allowlist 
1877     
1878 {
1879   constructor(
1880     string memory tokenName,
1881     string memory tokenSymbol
1882   ) ERC721A(tokenName, tokenSymbol, 3, 1000) { }
1883     uint8 public CONTRACT_VERSION = 2;
1884     string public _baseTokenURI = "ipfs://bafybeigb54tzr7do27lqqk4c2pjfnubmls5sgqgduwcvryqirdkk54hk6i/";
1885 
1886     bool public mintingOpen = true;
1887     
1888     
1889     uint256 public MAX_WALLET_MINTS = 3;
1890 
1891   
1892     /////////////// Admin Mint Functions
1893     /**
1894      * @dev Mints a token to an address with a tokenURI.
1895      * This is owner only and allows a fee-free drop
1896      * @param _to address of the future owner of the token
1897      * @param _qty amount of tokens to drop the owner
1898      */
1899      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1900          require(_qty > 0, "Must mint at least 1 token.");
1901          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1000");
1902          _safeMint(_to, _qty, true);
1903      }
1904 
1905   
1906     /////////////// GENERIC MINT FUNCTIONS
1907     /**
1908     * @dev Mints a single token to an address.
1909     * fee may or may not be required*
1910     * @param _to address of the future owner of the token
1911     */
1912     function mintTo(address _to) public payable {
1913         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1914         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1915         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1916         
1917         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1918         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1919         
1920         _safeMint(_to, 1, false);
1921     }
1922 
1923     /**
1924     * @dev Mints tokens to an address in batch.
1925     * fee may or may not be required*
1926     * @param _to address of the future owner of the token
1927     * @param _amount number of tokens to mint
1928     */
1929     function mintToMultiple(address _to, uint256 _amount) public payable {
1930         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1931         require(_amount >= 1, "Must mint at least 1 token");
1932         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1933         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1934         
1935         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1936         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
1937         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1938 
1939         _safeMint(_to, _amount, false);
1940     }
1941 
1942     /**
1943      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1944      * fee may or may not be required*
1945      * @param _to address of the future owner of the token
1946      * @param _amount number of tokens to mint
1947      * @param _erc20TokenContract erc-20 token contract to mint with
1948      */
1949     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1950       require(_amount >= 1, "Must mint at least 1 token");
1951       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1952       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1953       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1954       
1955       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1956 
1957       // ERC-20 Specific pre-flight checks
1958       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1959       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1960       IERC20 payableToken = IERC20(_erc20TokenContract);
1961 
1962       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1963       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1964       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1965       
1966       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1967       require(transferComplete, "ERC-20 token was unable to be transferred");
1968       
1969       _safeMint(_to, _amount, false);
1970       addSurcharge();
1971     }
1972 
1973     function openMinting() public onlyTeamOrOwner {
1974         mintingOpen = true;
1975     }
1976 
1977     function stopMinting() public onlyTeamOrOwner {
1978         mintingOpen = false;
1979     }
1980 
1981   
1982     ///////////// ALLOWLIST MINTING FUNCTIONS
1983 
1984     /**
1985     * @dev Mints tokens to an address using an allowlist.
1986     * fee may or may not be required*
1987     * @param _to address of the future owner of the token
1988     * @param _merkleProof merkle proof array
1989     */
1990     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1991         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1992         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1993         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1994         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1000");
1995         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1996         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1997         
1998 
1999         _safeMint(_to, 1, false);
2000     }
2001 
2002     /**
2003     * @dev Mints tokens to an address using an allowlist.
2004     * fee may or may not be required*
2005     * @param _to address of the future owner of the token
2006     * @param _amount number of tokens to mint
2007     * @param _merkleProof merkle proof array
2008     */
2009     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2010         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2011         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2012         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2013         require(_amount >= 1, "Must mint at least 1 token");
2014         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2015 
2016         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2017         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2018         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2019         
2020 
2021         _safeMint(_to, _amount, false);
2022     }
2023 
2024     /**
2025     * @dev Mints tokens to an address using an allowlist.
2026     * fee may or may not be required*
2027     * @param _to address of the future owner of the token
2028     * @param _amount number of tokens to mint
2029     * @param _merkleProof merkle proof array
2030     * @param _erc20TokenContract erc-20 token contract to mint with
2031     */
2032     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2033       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2034       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2035       require(_amount >= 1, "Must mint at least 1 token");
2036       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2037       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2038       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2039       
2040     
2041       // ERC-20 Specific pre-flight checks
2042       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2043       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2044       IERC20 payableToken = IERC20(_erc20TokenContract);
2045     
2046       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2047       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2048       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2049       
2050       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2051       require(transferComplete, "ERC-20 token was unable to be transferred");
2052       
2053       _safeMint(_to, _amount, false);
2054       addSurcharge();
2055     }
2056 
2057     /**
2058      * @dev Enable allowlist minting fully by enabling both flags
2059      * This is a convenience function for the Rampp user
2060      */
2061     function openAllowlistMint() public onlyTeamOrOwner {
2062         enableAllowlistOnlyMode();
2063         mintingOpen = true;
2064     }
2065 
2066     /**
2067      * @dev Close allowlist minting fully by disabling both flags
2068      * This is a convenience function for the Rampp user
2069      */
2070     function closeAllowlistMint() public onlyTeamOrOwner {
2071         disableAllowlistOnlyMode();
2072         mintingOpen = false;
2073     }
2074 
2075 
2076   
2077     /**
2078     * @dev Check if wallet over MAX_WALLET_MINTS
2079     * @param _address address in question to check if minted count exceeds max
2080     */
2081     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2082         require(_amount >= 1, "Amount must be greater than or equal to 1");
2083         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2084     }
2085 
2086     /**
2087     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2088     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2089     */
2090     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2091         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2092         MAX_WALLET_MINTS = _newWalletMax;
2093     }
2094     
2095 
2096   
2097     /**
2098      * @dev Allows owner to set Max mints per tx
2099      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2100      */
2101      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2102          require(_newMaxMint >= 1, "Max mint must be at least 1");
2103          maxBatchSize = _newMaxMint;
2104      }
2105     
2106 
2107   
2108 
2109   function _baseURI() internal view virtual override returns(string memory) {
2110     return _baseTokenURI;
2111   }
2112 
2113   function baseTokenURI() public view returns(string memory) {
2114     return _baseTokenURI;
2115   }
2116 
2117   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2118     _baseTokenURI = baseURI;
2119   }
2120 
2121   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2122     return ownershipOf(tokenId);
2123   }
2124 }
2125 
2126 
2127   
2128 // File: contracts/BonelandContract.sol
2129 //SPDX-License-Identifier: MIT
2130 
2131 pragma solidity ^0.8.0;
2132 
2133 contract BonelandContract is RamppERC721A {
2134     constructor() RamppERC721A("Boneland", "BONE"){}
2135 }
2136   
2137 //*********************************************************************//
2138 //*********************************************************************//  
2139 //                       Mintplex v2.1.0
2140 //
2141 //         This smart contract was generated by mintplex.xyz.
2142 //            Mintplex allows creators like you to launch 
2143 //             large scale NFT communities without code!
2144 //
2145 //    Mintplex is not responsible for the content of this contract and
2146 //        hopes it is being used in a responsible and kind way.  
2147 //       Mintplex is not associated or affiliated with this project.                                                    
2148 //             Twitter: @MintplexNFT ---- mintplex.xyz
2149 //*********************************************************************//                                                     
2150 //*********************************************************************// 
