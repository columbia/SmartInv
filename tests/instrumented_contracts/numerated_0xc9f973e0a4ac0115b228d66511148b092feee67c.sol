1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ███╗   ███╗ █████╗ ██████╗ ███╗   ██╗███████╗███████╗███████╗    ████████╗██████╗  █████╗ ██████╗ ███████╗██████╗ 
5 // ████╗ ████║██╔══██╗██╔══██╗████╗  ██║██╔════╝██╔════╝██╔════╝    ╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
6 // ██╔████╔██║███████║██║  ██║██╔██╗ ██║█████╗  ███████╗███████╗       ██║   ██████╔╝███████║██║  ██║█████╗  ██████╔╝
7 // ██║╚██╔╝██║██╔══██║██║  ██║██║╚██╗██║██╔══╝  ╚════██║╚════██║       ██║   ██╔══██╗██╔══██║██║  ██║██╔══╝  ██╔══██╗
8 // ██║ ╚═╝ ██║██║  ██║██████╔╝██║ ╚████║███████╗███████║███████║       ██║   ██║  ██║██║  ██║██████╔╝███████╗██║  ██║
9 // ╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝
10 //                                                                                                                   
11 //
12 //*********************************************************************//
13 //*********************************************************************//
14   
15 //-------------DEPENDENCIES--------------------------//
16 
17 // File: @openzeppelin/contracts/utils/Address.sol
18 
19 
20 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
21 
22 pragma solidity ^0.8.1;
23 
24 /**
25  * @dev Collection of functions related to the address type
26  */
27 library Address {
28     /**
29      * @dev Returns true if account is a contract.
30      *
31      * [IMPORTANT]
32      * ====
33      * It is unsafe to assume that an address for which this function returns
34      * false is an externally-owned account (EOA) and not a contract.
35      *
36      * Among others, isContract will return false for the following
37      * types of addresses:
38      *
39      *  - an externally-owned account
40      *  - a contract in construction
41      *  - an address where a contract will be created
42      *  - an address where a contract lived, but was destroyed
43      * ====
44      *
45      * [IMPORTANT]
46      * ====
47      * You shouldn't rely on isContract to protect against flash loan attacks!
48      *
49      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
50      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
51      * constructor.
52      * ====
53      */
54     function isContract(address account) internal view returns (bool) {
55         // This method relies on extcodesize/address.code.length, which returns 0
56         // for contracts in construction, since the code is only stored at the end
57         // of the constructor execution.
58 
59         return account.code.length > 0;
60     }
61 
62     /**
63      * @dev Replacement for Solidity's transfer: sends amount wei to
64      * recipient, forwarding all available gas and reverting on errors.
65      *
66      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
67      * of certain opcodes, possibly making contracts go over the 2300 gas limit
68      * imposed by transfer, making them unable to receive funds via
69      * transfer. {sendValue} removes this limitation.
70      *
71      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
72      *
73      * IMPORTANT: because control is transferred to recipient, care must be
74      * taken to not create reentrancy vulnerabilities. Consider using
75      * {ReentrancyGuard} or the
76      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
77      */
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         (bool success, ) = recipient.call{value: amount}("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level call. A
87      * plain call is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If target reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
95      *
96      * Requirements:
97      *
98      * - target must be a contract.
99      * - calling target with data must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104         return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
109      * errorMessage as a fallback revert reason when target reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(
114         address target,
115         bytes memory data,
116         string memory errorMessage
117     ) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, 0, errorMessage);
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
123      * but also transferring value wei to target.
124      *
125      * Requirements:
126      *
127      * - the calling contract must have an ETH balance of at least value.
128      * - the called Solidity function must be payable.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value
136     ) internal returns (bytes memory) {
137         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
138     }
139 
140     /**
141      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
142      * with errorMessage as a fallback revert reason when target reverts.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value,
150         string memory errorMessage
151     ) internal returns (bytes memory) {
152         require(address(this).balance >= value, "Address: insufficient balance for call");
153         require(isContract(target), "Address: call to non-contract");
154 
155         (bool success, bytes memory returndata) = target.call{value: value}(data);
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
166         return functionStaticCall(target, data, "Address: low-level static call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
171      * but performing a static call.
172      *
173      * _Available since v3.3._
174      */
175     function functionStaticCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal view returns (bytes memory) {
180         require(isContract(target), "Address: static call to non-contract");
181 
182         (bool success, bytes memory returndata) = target.staticcall(data);
183         return verifyCallResult(success, returndata, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
193         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
198      * but performing a delegate call.
199      *
200      * _Available since v3.4._
201      */
202     function functionDelegateCall(
203         address target,
204         bytes memory data,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(isContract(target), "Address: delegate call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.delegatecall(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
215      * revert reason using the provided one.
216      *
217      * _Available since v4.3._
218      */
219     function verifyCallResult(
220         bool success,
221         bytes memory returndata,
222         string memory errorMessage
223     ) internal pure returns (bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             // Look for revert reason and bubble it up if present
228             if (returndata.length > 0) {
229                 // The easiest way to bubble the revert reason is using memory via assembly
230 
231                 assembly {
232                     let returndata_size := mload(returndata)
233                     revert(add(32, returndata), returndata_size)
234                 }
235             } else {
236                 revert(errorMessage);
237             }
238         }
239     }
240 }
241 
242 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
243 
244 
245 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @title ERC721 token receiver interface
251  * @dev Interface for any contract that wants to support safeTransfers
252  * from ERC721 asset contracts.
253  */
254 interface IERC721Receiver {
255     /**
256      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
257      * by operator from from, this function is called.
258      *
259      * It must return its Solidity selector to confirm the token transfer.
260      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
261      *
262      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
263      */
264     function onERC721Received(
265         address operator,
266         address from,
267         uint256 tokenId,
268         bytes calldata data
269     ) external returns (bytes4);
270 }
271 
272 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Interface of the ERC165 standard, as defined in the
281  * https://eips.ethereum.org/EIPS/eip-165[EIP].
282  *
283  * Implementers can declare support of contract interfaces, which can then be
284  * queried by others ({ERC165Checker}).
285  *
286  * For an implementation, see {ERC165}.
287  */
288 interface IERC165 {
289     /**
290      * @dev Returns true if this contract implements the interface defined by
291      * interfaceId. See the corresponding
292      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
293      * to learn more about how these ids are created.
294      *
295      * This function call must use less than 30 000 gas.
296      */
297     function supportsInterface(bytes4 interfaceId) external view returns (bool);
298 }
299 
300 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 
308 /**
309  * @dev Implementation of the {IERC165} interface.
310  *
311  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
312  * for the additional interface id that will be supported. For example:
313  *
314  * solidity
315  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
316  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
317  * }
318  * 
319  *
320  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
321  */
322 abstract contract ERC165 is IERC165 {
323     /**
324      * @dev See {IERC165-supportsInterface}.
325      */
326     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
327         return interfaceId == type(IERC165).interfaceId;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Required interface of an ERC721 compliant contract.
341  */
342 interface IERC721 is IERC165 {
343     /**
344      * @dev Emitted when tokenId token is transferred from from to to.
345      */
346     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when owner enables approved to manage the tokenId token.
350      */
351     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
352 
353     /**
354      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
355      */
356     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
357 
358     /**
359      * @dev Returns the number of tokens in owner's account.
360      */
361     function balanceOf(address owner) external view returns (uint256 balance);
362 
363     /**
364      * @dev Returns the owner of the tokenId token.
365      *
366      * Requirements:
367      *
368      * - tokenId must exist.
369      */
370     function ownerOf(uint256 tokenId) external view returns (address owner);
371 
372     /**
373      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
374      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
375      *
376      * Requirements:
377      *
378      * - from cannot be the zero address.
379      * - to cannot be the zero address.
380      * - tokenId token must exist and be owned by from.
381      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
382      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
383      *
384      * Emits a {Transfer} event.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Transfers tokenId token from from to to.
394      *
395      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
396      *
397      * Requirements:
398      *
399      * - from cannot be the zero address.
400      * - to cannot be the zero address.
401      * - tokenId token must be owned by from.
402      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(
407         address from,
408         address to,
409         uint256 tokenId
410     ) external;
411 
412     /**
413      * @dev Gives permission to to to transfer tokenId token to another account.
414      * The approval is cleared when the token is transferred.
415      *
416      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
417      *
418      * Requirements:
419      *
420      * - The caller must own the token or be an approved operator.
421      * - tokenId must exist.
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address to, uint256 tokenId) external;
426 
427     /**
428      * @dev Returns the account approved for tokenId token.
429      *
430      * Requirements:
431      *
432      * - tokenId must exist.
433      */
434     function getApproved(uint256 tokenId) external view returns (address operator);
435 
436     /**
437      * @dev Approve or remove operator as an operator for the caller.
438      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
439      *
440      * Requirements:
441      *
442      * - The operator cannot be the caller.
443      *
444      * Emits an {ApprovalForAll} event.
445      */
446     function setApprovalForAll(address operator, bool _approved) external;
447 
448     /**
449      * @dev Returns if the operator is allowed to manage all of the assets of owner.
450      *
451      * See {setApprovalForAll}
452      */
453     function isApprovedForAll(address owner, address operator) external view returns (bool);
454 
455     /**
456      * @dev Safely transfers tokenId token from from to to.
457      *
458      * Requirements:
459      *
460      * - from cannot be the zero address.
461      * - to cannot be the zero address.
462      * - tokenId token must exist and be owned by from.
463      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
464      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
465      *
466      * Emits a {Transfer} event.
467      */
468     function safeTransferFrom(
469         address from,
470         address to,
471         uint256 tokenId,
472         bytes calldata data
473     ) external;
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
477 
478 
479 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
486  * @dev See https://eips.ethereum.org/EIPS/eip-721
487  */
488 interface IERC721Enumerable is IERC721 {
489     /**
490      * @dev Returns the total amount of tokens stored by the contract.
491      */
492     function totalSupply() external view returns (uint256);
493 
494     /**
495      * @dev Returns a token ID owned by owner at a given index of its token list.
496      * Use along with {balanceOf} to enumerate all of owner's tokens.
497      */
498     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
499 
500     /**
501      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
502      * Use along with {totalSupply} to enumerate all tokens.
503      */
504     function tokenByIndex(uint256 index) external view returns (uint256);
505 }
506 
507 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
508 
509 
510 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
517  * @dev See https://eips.ethereum.org/EIPS/eip-721
518  */
519 interface IERC721Metadata is IERC721 {
520     /**
521      * @dev Returns the token collection name.
522      */
523     function name() external view returns (string memory);
524 
525     /**
526      * @dev Returns the token collection symbol.
527      */
528     function symbol() external view returns (string memory);
529 
530     /**
531      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
532      */
533     function tokenURI(uint256 tokenId) external view returns (string memory);
534 }
535 
536 // File: @openzeppelin/contracts/utils/Strings.sol
537 
538 
539 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @dev String operations.
545  */
546 library Strings {
547     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
548 
549     /**
550      * @dev Converts a uint256 to its ASCII string decimal representation.
551      */
552     function toString(uint256 value) internal pure returns (string memory) {
553         // Inspired by OraclizeAPI's implementation - MIT licence
554         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
555 
556         if (value == 0) {
557             return "0";
558         }
559         uint256 temp = value;
560         uint256 digits;
561         while (temp != 0) {
562             digits++;
563             temp /= 10;
564         }
565         bytes memory buffer = new bytes(digits);
566         while (value != 0) {
567             digits -= 1;
568             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
569             value /= 10;
570         }
571         return string(buffer);
572     }
573 
574     /**
575      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
576      */
577     function toHexString(uint256 value) internal pure returns (string memory) {
578         if (value == 0) {
579             return "0x00";
580         }
581         uint256 temp = value;
582         uint256 length = 0;
583         while (temp != 0) {
584             length++;
585             temp >>= 8;
586         }
587         return toHexString(value, length);
588     }
589 
590     /**
591      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
592      */
593     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
594         bytes memory buffer = new bytes(2 * length + 2);
595         buffer[0] = "0";
596         buffer[1] = "x";
597         for (uint256 i = 2 * length + 1; i > 1; --i) {
598             buffer[i] = _HEX_SYMBOLS[value & 0xf];
599             value >>= 4;
600         }
601         require(value == 0, "Strings: hex length insufficient");
602         return string(buffer);
603     }
604 }
605 
606 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Contract module that helps prevent reentrant calls to a function.
615  *
616  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
617  * available, which can be applied to functions to make sure there are no nested
618  * (reentrant) calls to them.
619  *
620  * Note that because there is a single nonReentrant guard, functions marked as
621  * nonReentrant may not call one another. This can be worked around by making
622  * those functions private, and then adding external nonReentrant entry
623  * points to them.
624  *
625  * TIP: If you would like to learn more about reentrancy and alternative ways
626  * to protect against it, check out our blog post
627  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
628  */
629 abstract contract ReentrancyGuard {
630     // Booleans are more expensive than uint256 or any type that takes up a full
631     // word because each write operation emits an extra SLOAD to first read the
632     // slot's contents, replace the bits taken up by the boolean, and then write
633     // back. This is the compiler's defense against contract upgrades and
634     // pointer aliasing, and it cannot be disabled.
635 
636     // The values being non-zero value makes deployment a bit more expensive,
637     // but in exchange the refund on every call to nonReentrant will be lower in
638     // amount. Since refunds are capped to a percentage of the total
639     // transaction's gas, it is best to keep them low in cases like this one, to
640     // increase the likelihood of the full refund coming into effect.
641     uint256 private constant _NOT_ENTERED = 1;
642     uint256 private constant _ENTERED = 2;
643 
644     uint256 private _status;
645 
646     constructor() {
647         _status = _NOT_ENTERED;
648     }
649 
650     /**
651      * @dev Prevents a contract from calling itself, directly or indirectly.
652      * Calling a nonReentrant function from another nonReentrant
653      * function is not supported. It is possible to prevent this from happening
654      * by making the nonReentrant function external, and making it call a
655      * private function that does the actual work.
656      */
657     modifier nonReentrant() {
658         // On the first call to nonReentrant, _notEntered will be true
659         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
660 
661         // Any calls to nonReentrant after this point will fail
662         _status = _ENTERED;
663 
664         _;
665 
666         // By storing the original value once again, a refund is triggered (see
667         // https://eips.ethereum.org/EIPS/eip-2200)
668         _status = _NOT_ENTERED;
669     }
670 }
671 
672 // File: @openzeppelin/contracts/utils/Context.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 /**
680  * @dev Provides information about the current execution context, including the
681  * sender of the transaction and its data. While these are generally available
682  * via msg.sender and msg.data, they should not be accessed in such a direct
683  * manner, since when dealing with meta-transactions the account sending and
684  * paying for execution may not be the actual sender (as far as an application
685  * is concerned).
686  *
687  * This contract is only required for intermediate, library-like contracts.
688  */
689 abstract contract Context {
690     function _msgSender() internal view virtual returns (address) {
691         return msg.sender;
692     }
693 
694     function _msgData() internal view virtual returns (bytes calldata) {
695         return msg.data;
696     }
697 }
698 
699 // File: @openzeppelin/contracts/access/Ownable.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @dev Contract module which provides a basic access control mechanism, where
709  * there is an account (an owner) that can be granted exclusive access to
710  * specific functions.
711  *
712  * By default, the owner account will be the one that deploys the contract. This
713  * can later be changed with {transferOwnership}.
714  *
715  * This module is used through inheritance. It will make available the modifier
716  * onlyOwner, which can be applied to your functions to restrict their use to
717  * the owner.
718  */
719 abstract contract Ownable is Context {
720     address private _owner;
721 
722     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
723 
724     /**
725      * @dev Initializes the contract setting the deployer as the initial owner.
726      */
727     constructor() {
728         _transferOwnership(_msgSender());
729     }
730 
731     /**
732      * @dev Returns the address of the current owner.
733      */
734     function owner() public view virtual returns (address) {
735         return _owner;
736     }
737 
738     /**
739      * @dev Throws if called by any account other than the owner.
740      */
741     modifier onlyOwner() {
742         require(owner() == _msgSender(), "Ownable: caller is not the owner");
743         _;
744     }
745 
746     /**
747      * @dev Leaves the contract without owner. It will not be possible to call
748      * onlyOwner functions anymore. Can only be called by the current owner.
749      *
750      * NOTE: Renouncing ownership will leave the contract without an owner,
751      * thereby removing any functionality that is only available to the owner.
752      */
753     function renounceOwnership() public virtual onlyOwner {
754         _transferOwnership(address(0));
755     }
756 
757     /**
758      * @dev Transfers ownership of the contract to a new account (newOwner).
759      * Can only be called by the current owner.
760      */
761     function transferOwnership(address newOwner) public virtual onlyOwner {
762         require(newOwner != address(0), "Ownable: new owner is the zero address");
763         _transferOwnership(newOwner);
764     }
765 
766     /**
767      * @dev Transfers ownership of the contract to a new account (newOwner).
768      * Internal function without access restriction.
769      */
770     function _transferOwnership(address newOwner) internal virtual {
771         address oldOwner = _owner;
772         _owner = newOwner;
773         emit OwnershipTransferred(oldOwner, newOwner);
774     }
775 }
776 
777 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
778 pragma solidity ^0.8.9;
779 
780 interface IOperatorFilterRegistry {
781     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
782     function register(address registrant) external;
783     function registerAndSubscribe(address registrant, address subscription) external;
784     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
785     function updateOperator(address registrant, address operator, bool filtered) external;
786     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
787     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
788     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
789     function subscribe(address registrant, address registrantToSubscribe) external;
790     function unsubscribe(address registrant, bool copyExistingEntries) external;
791     function subscriptionOf(address addr) external returns (address registrant);
792     function subscribers(address registrant) external returns (address[] memory);
793     function subscriberAt(address registrant, uint256 index) external returns (address);
794     function copyEntriesOf(address registrant, address registrantToCopy) external;
795     function isOperatorFiltered(address registrant, address operator) external returns (bool);
796     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
797     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
798     function filteredOperators(address addr) external returns (address[] memory);
799     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
800     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
801     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
802     function isRegistered(address addr) external returns (bool);
803     function codeHashOf(address addr) external returns (bytes32);
804 }
805 
806 // File contracts/OperatorFilter/OperatorFilterer.sol
807 pragma solidity ^0.8.9;
808 
809 abstract contract OperatorFilterer {
810     error OperatorNotAllowed(address operator);
811 
812     IOperatorFilterRegistry constant operatorFilterRegistry =
813         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
814 
815     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
816         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
817         // will not revert, but the contract will need to be registered with the registry once it is deployed in
818         // order for the modifier to filter addresses.
819         if (address(operatorFilterRegistry).code.length > 0) {
820             if (subscribe) {
821                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
822             } else {
823                 if (subscriptionOrRegistrantToCopy != address(0)) {
824                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
825                 } else {
826                     operatorFilterRegistry.register(address(this));
827                 }
828             }
829         }
830     }
831 
832     function _onlyAllowedOperator(address from) private view {
833       if (
834           !(
835               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
836               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
837           )
838       ) {
839           revert OperatorNotAllowed(msg.sender);
840       }
841     }
842 
843     modifier onlyAllowedOperator(address from) virtual {
844         // Check registry code length to facilitate testing in environments without a deployed registry.
845         if (address(operatorFilterRegistry).code.length > 0) {
846             // Allow spending tokens from addresses with balance
847             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
848             // from an EOA.
849             if (from == msg.sender) {
850                 _;
851                 return;
852             }
853             _onlyAllowedOperator(from);
854         }
855         _;
856     }
857 }
858 
859 //-------------END DEPENDENCIES------------------------//
860 
861 
862   
863 // Rampp Contracts v2.1 (Teams.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 /**
868 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
869 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
870 * This will easily allow cross-collaboration via Mintplex.xyz.
871 **/
872 abstract contract Teams is Ownable{
873   mapping (address => bool) internal team;
874 
875   /**
876   * @dev Adds an address to the team. Allows them to execute protected functions
877   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
878   **/
879   function addToTeam(address _address) public onlyOwner {
880     require(_address != address(0), "Invalid address");
881     require(!inTeam(_address), "This address is already in your team.");
882   
883     team[_address] = true;
884   }
885 
886   /**
887   * @dev Removes an address to the team.
888   * @param _address the ETH address to remove, cannot be 0x and must be in team
889   **/
890   function removeFromTeam(address _address) public onlyOwner {
891     require(_address != address(0), "Invalid address");
892     require(inTeam(_address), "This address is not in your team currently.");
893   
894     team[_address] = false;
895   }
896 
897   /**
898   * @dev Check if an address is valid and active in the team
899   * @param _address ETH address to check for truthiness
900   **/
901   function inTeam(address _address)
902     public
903     view
904     returns (bool)
905   {
906     require(_address != address(0), "Invalid address to check.");
907     return team[_address] == true;
908   }
909 
910   /**
911   * @dev Throws if called by any account other than the owner or team member.
912   */
913   function _onlyTeamOrOwner() private view {
914     bool _isOwner = owner() == _msgSender();
915     bool _isTeam = inTeam(_msgSender());
916     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
917   }
918 
919   modifier onlyTeamOrOwner() {
920     _onlyTeamOrOwner();
921     _;
922   }
923 }
924 
925 
926   
927   pragma solidity ^0.8.0;
928 
929   /**
930   * @dev These functions deal with verification of Merkle Trees proofs.
931   *
932   * The proofs can be generated using the JavaScript library
933   * https://github.com/miguelmota/merkletreejs[merkletreejs].
934   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
935   *
936   *
937   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
938   * hashing, or use a hash function other than keccak256 for hashing leaves.
939   * This is because the concatenation of a sorted pair of internal nodes in
940   * the merkle tree could be reinterpreted as a leaf value.
941   */
942   library MerkleProof {
943       /**
944       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
945       * defined by 'root'. For this, a 'proof' must be provided, containing
946       * sibling hashes on the branch from the leaf to the root of the tree. Each
947       * pair of leaves and each pair of pre-images are assumed to be sorted.
948       */
949       function verify(
950           bytes32[] memory proof,
951           bytes32 root,
952           bytes32 leaf
953       ) internal pure returns (bool) {
954           return processProof(proof, leaf) == root;
955       }
956 
957       /**
958       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
959       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
960       * hash matches the root of the tree. When processing the proof, the pairs
961       * of leafs & pre-images are assumed to be sorted.
962       *
963       * _Available since v4.4._
964       */
965       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
966           bytes32 computedHash = leaf;
967           for (uint256 i = 0; i < proof.length; i++) {
968               bytes32 proofElement = proof[i];
969               if (computedHash <= proofElement) {
970                   // Hash(current computed hash + current element of the proof)
971                   computedHash = _efficientHash(computedHash, proofElement);
972               } else {
973                   // Hash(current element of the proof + current computed hash)
974                   computedHash = _efficientHash(proofElement, computedHash);
975               }
976           }
977           return computedHash;
978       }
979 
980       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
981           assembly {
982               mstore(0x00, a)
983               mstore(0x20, b)
984               value := keccak256(0x00, 0x40)
985           }
986       }
987   }
988 
989 
990   // File: Allowlist.sol
991 
992   pragma solidity ^0.8.0;
993 
994   abstract contract Allowlist is Teams {
995     bytes32 public merkleRoot;
996     bool public onlyAllowlistMode = false;
997 
998     /**
999      * @dev Update merkle root to reflect changes in Allowlist
1000      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1001      */
1002     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1003       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
1004       merkleRoot = _newMerkleRoot;
1005     }
1006 
1007     /**
1008      * @dev Check the proof of an address if valid for merkle root
1009      * @param _to address to check for proof
1010      * @param _merkleProof Proof of the address to validate against root and leaf
1011      */
1012     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1013       require(merkleRoot != 0, "Merkle root is not set!");
1014       bytes32 leaf = keccak256(abi.encodePacked(_to));
1015 
1016       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1017     }
1018 
1019     
1020     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1021       onlyAllowlistMode = true;
1022     }
1023 
1024     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1025         onlyAllowlistMode = false;
1026     }
1027   }
1028   
1029   
1030 /**
1031  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1032  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1033  *
1034  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1035  * 
1036  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1037  *
1038  * Does not support burning tokens to address(0).
1039  */
1040 contract ERC721A is
1041   Context,
1042   ERC165,
1043   IERC721,
1044   IERC721Metadata,
1045   IERC721Enumerable,
1046   Teams
1047   , OperatorFilterer
1048 {
1049   using Address for address;
1050   using Strings for uint256;
1051 
1052   struct TokenOwnership {
1053     address addr;
1054     uint64 startTimestamp;
1055   }
1056 
1057   struct AddressData {
1058     uint128 balance;
1059     uint128 numberMinted;
1060   }
1061 
1062   uint256 private currentIndex;
1063 
1064   uint256 public immutable collectionSize;
1065   uint256 public maxBatchSize;
1066 
1067   // Token name
1068   string private _name;
1069 
1070   // Token symbol
1071   string private _symbol;
1072 
1073   // Mapping from token ID to ownership details
1074   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1075   mapping(uint256 => TokenOwnership) private _ownerships;
1076 
1077   // Mapping owner address to address data
1078   mapping(address => AddressData) private _addressData;
1079 
1080   // Mapping from token ID to approved address
1081   mapping(uint256 => address) private _tokenApprovals;
1082 
1083   // Mapping from owner to operator approvals
1084   mapping(address => mapping(address => bool)) private _operatorApprovals;
1085 
1086   /* @dev Mapping of restricted operator approvals set by contract Owner
1087   * This serves as an optional addition to ERC-721 so
1088   * that the contract owner can elect to prevent specific addresses/contracts
1089   * from being marked as the approver for a token. The reason for this
1090   * is that some projects may want to retain control of where their tokens can/can not be listed
1091   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1092   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1093   */
1094   mapping(address => bool) public restrictedApprovalAddresses;
1095 
1096   /**
1097    * @dev
1098    * maxBatchSize refers to how much a minter can mint at a time.
1099    * collectionSize_ refers to how many tokens are in the collection.
1100    */
1101   constructor(
1102     string memory name_,
1103     string memory symbol_,
1104     uint256 maxBatchSize_,
1105     uint256 collectionSize_
1106   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1107     require(
1108       collectionSize_ > 0,
1109       "ERC721A: collection must have a nonzero supply"
1110     );
1111     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1112     _name = name_;
1113     _symbol = symbol_;
1114     maxBatchSize = maxBatchSize_;
1115     collectionSize = collectionSize_;
1116     currentIndex = _startTokenId();
1117   }
1118 
1119   /**
1120   * To change the starting tokenId, please override this function.
1121   */
1122   function _startTokenId() internal view virtual returns (uint256) {
1123     return 1;
1124   }
1125 
1126   /**
1127    * @dev See {IERC721Enumerable-totalSupply}.
1128    */
1129   function totalSupply() public view override returns (uint256) {
1130     return _totalMinted();
1131   }
1132 
1133   function currentTokenId() public view returns (uint256) {
1134     return _totalMinted();
1135   }
1136 
1137   function getNextTokenId() public view returns (uint256) {
1138       return _totalMinted() + 1;
1139   }
1140 
1141   /**
1142   * Returns the total amount of tokens minted in the contract.
1143   */
1144   function _totalMinted() internal view returns (uint256) {
1145     unchecked {
1146       return currentIndex - _startTokenId();
1147     }
1148   }
1149 
1150   /**
1151    * @dev See {IERC721Enumerable-tokenByIndex}.
1152    */
1153   function tokenByIndex(uint256 index) public view override returns (uint256) {
1154     require(index < totalSupply(), "ERC721A: global index out of bounds");
1155     return index;
1156   }
1157 
1158   /**
1159    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1160    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1161    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1162    */
1163   function tokenOfOwnerByIndex(address owner, uint256 index)
1164     public
1165     view
1166     override
1167     returns (uint256)
1168   {
1169     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1170     uint256 numMintedSoFar = totalSupply();
1171     uint256 tokenIdsIdx = 0;
1172     address currOwnershipAddr = address(0);
1173     for (uint256 i = 0; i < numMintedSoFar; i++) {
1174       TokenOwnership memory ownership = _ownerships[i];
1175       if (ownership.addr != address(0)) {
1176         currOwnershipAddr = ownership.addr;
1177       }
1178       if (currOwnershipAddr == owner) {
1179         if (tokenIdsIdx == index) {
1180           return i;
1181         }
1182         tokenIdsIdx++;
1183       }
1184     }
1185     revert("ERC721A: unable to get token of owner by index");
1186   }
1187 
1188   /**
1189    * @dev See {IERC165-supportsInterface}.
1190    */
1191   function supportsInterface(bytes4 interfaceId)
1192     public
1193     view
1194     virtual
1195     override(ERC165, IERC165)
1196     returns (bool)
1197   {
1198     return
1199       interfaceId == type(IERC721).interfaceId ||
1200       interfaceId == type(IERC721Metadata).interfaceId ||
1201       interfaceId == type(IERC721Enumerable).interfaceId ||
1202       super.supportsInterface(interfaceId);
1203   }
1204 
1205   /**
1206    * @dev See {IERC721-balanceOf}.
1207    */
1208   function balanceOf(address owner) public view override returns (uint256) {
1209     require(owner != address(0), "ERC721A: balance query for the zero address");
1210     return uint256(_addressData[owner].balance);
1211   }
1212 
1213   function _numberMinted(address owner) internal view returns (uint256) {
1214     require(
1215       owner != address(0),
1216       "ERC721A: number minted query for the zero address"
1217     );
1218     return uint256(_addressData[owner].numberMinted);
1219   }
1220 
1221   function ownershipOf(uint256 tokenId)
1222     internal
1223     view
1224     returns (TokenOwnership memory)
1225   {
1226     uint256 curr = tokenId;
1227 
1228     unchecked {
1229         if (_startTokenId() <= curr && curr < currentIndex) {
1230             TokenOwnership memory ownership = _ownerships[curr];
1231             if (ownership.addr != address(0)) {
1232                 return ownership;
1233             }
1234 
1235             // Invariant:
1236             // There will always be an ownership that has an address and is not burned
1237             // before an ownership that does not have an address and is not burned.
1238             // Hence, curr will not underflow.
1239             while (true) {
1240                 curr--;
1241                 ownership = _ownerships[curr];
1242                 if (ownership.addr != address(0)) {
1243                     return ownership;
1244                 }
1245             }
1246         }
1247     }
1248 
1249     revert("ERC721A: unable to determine the owner of token");
1250   }
1251 
1252   /**
1253    * @dev See {IERC721-ownerOf}.
1254    */
1255   function ownerOf(uint256 tokenId) public view override returns (address) {
1256     return ownershipOf(tokenId).addr;
1257   }
1258 
1259   /**
1260    * @dev See {IERC721Metadata-name}.
1261    */
1262   function name() public view virtual override returns (string memory) {
1263     return _name;
1264   }
1265 
1266   /**
1267    * @dev See {IERC721Metadata-symbol}.
1268    */
1269   function symbol() public view virtual override returns (string memory) {
1270     return _symbol;
1271   }
1272 
1273   /**
1274    * @dev See {IERC721Metadata-tokenURI}.
1275    */
1276   function tokenURI(uint256 tokenId)
1277     public
1278     view
1279     virtual
1280     override
1281     returns (string memory)
1282   {
1283     string memory baseURI = _baseURI();
1284     string memory extension = _baseURIExtension();
1285     return
1286       bytes(baseURI).length > 0
1287         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1288         : "";
1289   }
1290 
1291   /**
1292    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1293    * token will be the concatenation of the baseURI and the tokenId. Empty
1294    * by default, can be overriden in child contracts.
1295    */
1296   function _baseURI() internal view virtual returns (string memory) {
1297     return "";
1298   }
1299 
1300   /**
1301    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1302    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1303    * by default, can be overriden in child contracts.
1304    */
1305   function _baseURIExtension() internal view virtual returns (string memory) {
1306     return "";
1307   }
1308 
1309   /**
1310    * @dev Sets the value for an address to be in the restricted approval address pool.
1311    * Setting an address to true will disable token owners from being able to mark the address
1312    * for approval for trading. This would be used in theory to prevent token owners from listing
1313    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1314    * @param _address the marketplace/user to modify restriction status of
1315    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1316    */
1317   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1318     restrictedApprovalAddresses[_address] = _isRestricted;
1319   }
1320 
1321   /**
1322    * @dev See {IERC721-approve}.
1323    */
1324   function approve(address to, uint256 tokenId) public override {
1325     address owner = ERC721A.ownerOf(tokenId);
1326     require(to != owner, "ERC721A: approval to current owner");
1327     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1328 
1329     require(
1330       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1331       "ERC721A: approve caller is not owner nor approved for all"
1332     );
1333 
1334     _approve(to, tokenId, owner);
1335   }
1336 
1337   /**
1338    * @dev See {IERC721-getApproved}.
1339    */
1340   function getApproved(uint256 tokenId) public view override returns (address) {
1341     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1342 
1343     return _tokenApprovals[tokenId];
1344   }
1345 
1346   /**
1347    * @dev See {IERC721-setApprovalForAll}.
1348    */
1349   function setApprovalForAll(address operator, bool approved) public override {
1350     require(operator != _msgSender(), "ERC721A: approve to caller");
1351     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1352 
1353     _operatorApprovals[_msgSender()][operator] = approved;
1354     emit ApprovalForAll(_msgSender(), operator, approved);
1355   }
1356 
1357   /**
1358    * @dev See {IERC721-isApprovedForAll}.
1359    */
1360   function isApprovedForAll(address owner, address operator)
1361     public
1362     view
1363     virtual
1364     override
1365     returns (bool)
1366   {
1367     return _operatorApprovals[owner][operator];
1368   }
1369 
1370   /**
1371    * @dev See {IERC721-transferFrom}.
1372    */
1373   function transferFrom(
1374     address from,
1375     address to,
1376     uint256 tokenId
1377   ) public override onlyAllowedOperator(from) {
1378     _transfer(from, to, tokenId);
1379   }
1380 
1381   /**
1382    * @dev See {IERC721-safeTransferFrom}.
1383    */
1384   function safeTransferFrom(
1385     address from,
1386     address to,
1387     uint256 tokenId
1388   ) public override onlyAllowedOperator(from) {
1389     safeTransferFrom(from, to, tokenId, "");
1390   }
1391 
1392   /**
1393    * @dev See {IERC721-safeTransferFrom}.
1394    */
1395   function safeTransferFrom(
1396     address from,
1397     address to,
1398     uint256 tokenId,
1399     bytes memory _data
1400   ) public override onlyAllowedOperator(from) {
1401     _transfer(from, to, tokenId);
1402     require(
1403       _checkOnERC721Received(from, to, tokenId, _data),
1404       "ERC721A: transfer to non ERC721Receiver implementer"
1405     );
1406   }
1407 
1408   /**
1409    * @dev Returns whether tokenId exists.
1410    *
1411    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1412    *
1413    * Tokens start existing when they are minted (_mint),
1414    */
1415   function _exists(uint256 tokenId) internal view returns (bool) {
1416     return _startTokenId() <= tokenId && tokenId < currentIndex;
1417   }
1418 
1419   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1420     _safeMint(to, quantity, isAdminMint, "");
1421   }
1422 
1423   /**
1424    * @dev Mints quantity tokens and transfers them to to.
1425    *
1426    * Requirements:
1427    *
1428    * - there must be quantity tokens remaining unminted in the total collection.
1429    * - to cannot be the zero address.
1430    * - quantity cannot be larger than the max batch size.
1431    *
1432    * Emits a {Transfer} event.
1433    */
1434   function _safeMint(
1435     address to,
1436     uint256 quantity,
1437     bool isAdminMint,
1438     bytes memory _data
1439   ) internal {
1440     uint256 startTokenId = currentIndex;
1441     require(to != address(0), "ERC721A: mint to the zero address");
1442     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1443     require(!_exists(startTokenId), "ERC721A: token already minted");
1444 
1445     // For admin mints we do not want to enforce the maxBatchSize limit
1446     if (isAdminMint == false) {
1447         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1448     }
1449 
1450     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1451 
1452     AddressData memory addressData = _addressData[to];
1453     _addressData[to] = AddressData(
1454       addressData.balance + uint128(quantity),
1455       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1456     );
1457     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1458 
1459     uint256 updatedIndex = startTokenId;
1460 
1461     for (uint256 i = 0; i < quantity; i++) {
1462       emit Transfer(address(0), to, updatedIndex);
1463       require(
1464         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1465         "ERC721A: transfer to non ERC721Receiver implementer"
1466       );
1467       updatedIndex++;
1468     }
1469 
1470     currentIndex = updatedIndex;
1471     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1472   }
1473 
1474   /**
1475    * @dev Transfers tokenId from from to to.
1476    *
1477    * Requirements:
1478    *
1479    * - to cannot be the zero address.
1480    * - tokenId token must be owned by from.
1481    *
1482    * Emits a {Transfer} event.
1483    */
1484   function _transfer(
1485     address from,
1486     address to,
1487     uint256 tokenId
1488   ) private {
1489     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1490 
1491     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1492       getApproved(tokenId) == _msgSender() ||
1493       isApprovedForAll(prevOwnership.addr, _msgSender()));
1494 
1495     require(
1496       isApprovedOrOwner,
1497       "ERC721A: transfer caller is not owner nor approved"
1498     );
1499 
1500     require(
1501       prevOwnership.addr == from,
1502       "ERC721A: transfer from incorrect owner"
1503     );
1504     require(to != address(0), "ERC721A: transfer to the zero address");
1505 
1506     _beforeTokenTransfers(from, to, tokenId, 1);
1507 
1508     // Clear approvals from the previous owner
1509     _approve(address(0), tokenId, prevOwnership.addr);
1510 
1511     _addressData[from].balance -= 1;
1512     _addressData[to].balance += 1;
1513     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1514 
1515     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1516     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1517     uint256 nextTokenId = tokenId + 1;
1518     if (_ownerships[nextTokenId].addr == address(0)) {
1519       if (_exists(nextTokenId)) {
1520         _ownerships[nextTokenId] = TokenOwnership(
1521           prevOwnership.addr,
1522           prevOwnership.startTimestamp
1523         );
1524       }
1525     }
1526 
1527     emit Transfer(from, to, tokenId);
1528     _afterTokenTransfers(from, to, tokenId, 1);
1529   }
1530 
1531   /**
1532    * @dev Approve to to operate on tokenId
1533    *
1534    * Emits a {Approval} event.
1535    */
1536   function _approve(
1537     address to,
1538     uint256 tokenId,
1539     address owner
1540   ) private {
1541     _tokenApprovals[tokenId] = to;
1542     emit Approval(owner, to, tokenId);
1543   }
1544 
1545   uint256 public nextOwnerToExplicitlySet = 0;
1546 
1547   /**
1548    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1549    */
1550   function _setOwnersExplicit(uint256 quantity) internal {
1551     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1552     require(quantity > 0, "quantity must be nonzero");
1553     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1554 
1555     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1556     if (endIndex > collectionSize - 1) {
1557       endIndex = collectionSize - 1;
1558     }
1559     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1560     require(_exists(endIndex), "not enough minted yet for this cleanup");
1561     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1562       if (_ownerships[i].addr == address(0)) {
1563         TokenOwnership memory ownership = ownershipOf(i);
1564         _ownerships[i] = TokenOwnership(
1565           ownership.addr,
1566           ownership.startTimestamp
1567         );
1568       }
1569     }
1570     nextOwnerToExplicitlySet = endIndex + 1;
1571   }
1572 
1573   /**
1574    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1575    * The call is not executed if the target address is not a contract.
1576    *
1577    * @param from address representing the previous owner of the given token ID
1578    * @param to target address that will receive the tokens
1579    * @param tokenId uint256 ID of the token to be transferred
1580    * @param _data bytes optional data to send along with the call
1581    * @return bool whether the call correctly returned the expected magic value
1582    */
1583   function _checkOnERC721Received(
1584     address from,
1585     address to,
1586     uint256 tokenId,
1587     bytes memory _data
1588   ) private returns (bool) {
1589     if (to.isContract()) {
1590       try
1591         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1592       returns (bytes4 retval) {
1593         return retval == IERC721Receiver(to).onERC721Received.selector;
1594       } catch (bytes memory reason) {
1595         if (reason.length == 0) {
1596           revert("ERC721A: transfer to non ERC721Receiver implementer");
1597         } else {
1598           assembly {
1599             revert(add(32, reason), mload(reason))
1600           }
1601         }
1602       }
1603     } else {
1604       return true;
1605     }
1606   }
1607 
1608   /**
1609    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1610    *
1611    * startTokenId - the first token id to be transferred
1612    * quantity - the amount to be transferred
1613    *
1614    * Calling conditions:
1615    *
1616    * - When from and to are both non-zero, from's tokenId will be
1617    * transferred to to.
1618    * - When from is zero, tokenId will be minted for to.
1619    */
1620   function _beforeTokenTransfers(
1621     address from,
1622     address to,
1623     uint256 startTokenId,
1624     uint256 quantity
1625   ) internal virtual {}
1626 
1627   /**
1628    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1629    * minting.
1630    *
1631    * startTokenId - the first token id to be transferred
1632    * quantity - the amount to be transferred
1633    *
1634    * Calling conditions:
1635    *
1636    * - when from and to are both non-zero.
1637    * - from and to are never both zero.
1638    */
1639   function _afterTokenTransfers(
1640     address from,
1641     address to,
1642     uint256 startTokenId,
1643     uint256 quantity
1644   ) internal virtual {}
1645 }
1646 
1647 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1648 // @author Mintplex.xyz (Rampp Labs Inc) (Twitter: @MintplexNFT)
1649 // @notice -- See Medium article --
1650 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1651 abstract contract ERC721ARedemption is ERC721A {
1652   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1653   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1654 
1655   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1656   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1657   
1658   uint256 public redemptionSurcharge = 0 ether;
1659   bool public redemptionModeEnabled;
1660   bool public verifiedClaimModeEnabled;
1661   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1662   mapping(address => bool) public redemptionContracts;
1663   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1664 
1665   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1666   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1667     redemptionContracts[_contractAddress] = _status;
1668   }
1669 
1670   // @dev Allow owner/team to determine if contract is accepting redemption mints
1671   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1672     redemptionModeEnabled = _newStatus;
1673   }
1674 
1675   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1676   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1677     verifiedClaimModeEnabled = _newStatus;
1678   }
1679 
1680   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1681   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1682     redemptionSurcharge = _newSurchargeInWei;
1683   }
1684 
1685   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1686   // @notice Must be a wallet address or implement IERC721Receiver.
1687   // Cannot be null address as this will break any ERC-721A implementation without a proper
1688   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1689   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1690     require(_newRedemptionAddress != address(0), "New redemption address cannot be null address.");
1691     redemptionAddress = _newRedemptionAddress;
1692   }
1693 
1694   /**
1695   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1696   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1697   * the contract owner or Team => redemptionAddress. 
1698   * @param tokenId the token to be redeemed.
1699   * Emits a {Redeemed} event.
1700   **/
1701   function redeem(address redemptionContract, uint256 tokenId) public payable {
1702     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1703     require(redemptionModeEnabled, "ERC721 Redeemable: Redemption mode is not enabled currently");
1704     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1705     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1706     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1707     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1708     
1709     IERC721 _targetContract = IERC721(redemptionContract);
1710     require(_targetContract.ownerOf(tokenId) == _msgSender(), "ERC721 Redeemable: Redeemer not owner of token to be claimed against.");
1711     require(_targetContract.getApproved(tokenId) == address(this), "ERC721 Redeemable: This contract is not approved for specific token on redempetion contract.");
1712     
1713     // Warning: Since there is no standarized return value for transfers of ERC-721
1714     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1715     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1716     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1717     // but the NFT may not have been sent to the redemptionAddress.
1718     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1719     tokenRedemptions[redemptionContract][tokenId] = true;
1720 
1721     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1722     _safeMint(_msgSender(), 1, false);
1723   }
1724 
1725   /**
1726   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1727   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1728   * @param tokenId the token to be redeemed.
1729   * Emits a {VerifiedClaim} event.
1730   **/
1731   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1732     require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1733     require(verifiedClaimModeEnabled, "ERC721 Redeemable: Verified claim mode is not enabled currently");
1734     require(redemptionContract != address(0), "ERC721 Redeemable: Redemption contract cannot be null.");
1735     require(redemptionContracts[redemptionContract], "ERC721 Redeemable: Redemption contract is not eligable for redeeming.");
1736     require(msg.value == redemptionSurcharge, "ERC721 Redeemable: Redemption fee not sent by redeemer.");
1737     require(tokenRedemptions[redemptionContract][tokenId] == false, "ERC721 Redeemable: Token has already been redeemed.");
1738     
1739     tokenRedemptions[redemptionContract][tokenId] = true;
1740     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1741     _safeMint(_msgSender(), 1, false);
1742   }
1743 }
1744 
1745 
1746   
1747   
1748 interface IERC20 {
1749   function allowance(address owner, address spender) external view returns (uint256);
1750   function transfer(address _to, uint256 _amount) external returns (bool);
1751   function balanceOf(address account) external view returns (uint256);
1752   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1753 }
1754 
1755 // File: WithdrawableV2
1756 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1757 // ERC-20 Payouts are limited to a single payout address. This feature 
1758 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1759 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1760 abstract contract WithdrawableV2 is Teams {
1761   struct acceptedERC20 {
1762     bool isActive;
1763     uint256 chargeAmount;
1764   }
1765 
1766   
1767   mapping(address => acceptedERC20) private allowedTokenContracts;
1768   address[] public payableAddresses = [0x0082feA23adE768Cb04ce46503Ad7baAf8849Cf5];
1769   address public erc20Payable = 0x0082feA23adE768Cb04ce46503Ad7baAf8849Cf5;
1770   uint256[] public payableFees = [100];
1771   uint256 public payableAddressCount = 1;
1772   bool public onlyERC20MintingMode = false;
1773   
1774 
1775   /**
1776   * @dev Calculates the true payable balance of the contract
1777   */
1778   function calcAvailableBalance() public view returns(uint256) {
1779     return address(this).balance;
1780   }
1781 
1782   function withdrawAll() public onlyTeamOrOwner {
1783       require(calcAvailableBalance() > 0);
1784       _withdrawAll();
1785   }
1786 
1787   function _withdrawAll() private {
1788       uint256 balance = calcAvailableBalance();
1789       
1790       for(uint i=0; i < payableAddressCount; i++ ) {
1791           _widthdraw(
1792               payableAddresses[i],
1793               (balance * payableFees[i]) / 100
1794           );
1795       }
1796   }
1797   
1798   function _widthdraw(address _address, uint256 _amount) private {
1799       (bool success, ) = _address.call{value: _amount}("");
1800       require(success, "Transfer failed.");
1801   }
1802 
1803   /**
1804   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1805   * in the event ERC-20 tokens are paid to the contract for mints.
1806   * @param _tokenContract contract of ERC-20 token to withdraw
1807   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1808   */
1809   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1810     require(_amountToWithdraw > 0);
1811     IERC20 tokenContract = IERC20(_tokenContract);
1812     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1813     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1814   }
1815 
1816   /**
1817   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1818   * @param _erc20TokenContract address of ERC-20 contract in question
1819   */
1820   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1821     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1822   }
1823 
1824   /**
1825   * @dev get the value of tokens to transfer for user of an ERC-20
1826   * @param _erc20TokenContract address of ERC-20 contract in question
1827   */
1828   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1829     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1830     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1831   }
1832 
1833   /**
1834   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1835   * @param _erc20TokenContract address of ERC-20 contract in question
1836   * @param _isActive default status of if contract should be allowed to accept payments
1837   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1838   */
1839   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1840     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1841     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1842   }
1843 
1844   /**
1845   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1846   * it will assume the default value of zero. This should not be used to create new payment tokens.
1847   * @param _erc20TokenContract address of ERC-20 contract in question
1848   */
1849   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1850     allowedTokenContracts[_erc20TokenContract].isActive = true;
1851   }
1852 
1853   /**
1854   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1855   * it will assume the default value of zero. This should not be used to create new payment tokens.
1856   * @param _erc20TokenContract address of ERC-20 contract in question
1857   */
1858   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1859     allowedTokenContracts[_erc20TokenContract].isActive = false;
1860   }
1861 
1862   /**
1863   * @dev Enable only ERC-20 payments for minting on this contract
1864   */
1865   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1866     onlyERC20MintingMode = true;
1867   }
1868 
1869   /**
1870   * @dev Disable only ERC-20 payments for minting on this contract
1871   */
1872   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1873     onlyERC20MintingMode = false;
1874   }
1875 
1876   /**
1877   * @dev Set the payout of the ERC-20 token payout to a specific address
1878   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1879   */
1880   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1881     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1882     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1883     erc20Payable = _newErc20Payable;
1884   }
1885 }
1886 
1887 
1888   
1889   
1890   
1891 // File: EarlyMintIncentive.sol
1892 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1893 // zero fee that can be calculated on the fly.
1894 abstract contract EarlyMintIncentive is Teams, ERC721A {
1895   uint256 public PRICE = 0.003 ether;
1896   uint256 public EARLY_MINT_PRICE = 0 ether;
1897   uint256 public earlyMintOwnershipCap = 1;
1898   bool public usingEarlyMintIncentive = true;
1899 
1900   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1901     usingEarlyMintIncentive = true;
1902   }
1903 
1904   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1905     usingEarlyMintIncentive = false;
1906   }
1907 
1908   /**
1909   * @dev Set the max token ID in which the cost incentive will be applied.
1910   * @param _newCap max number of tokens wallet may mint for incentive price
1911   */
1912   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1913     require(_newCap >= 1, "Cannot set cap to less than 1");
1914     earlyMintOwnershipCap = _newCap;
1915   }
1916 
1917   /**
1918   * @dev Set the incentive mint price
1919   * @param _feeInWei new price per token when in incentive range
1920   */
1921   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1922     EARLY_MINT_PRICE = _feeInWei;
1923   }
1924 
1925   /**
1926   * @dev Set the primary mint price - the base price when not under incentive
1927   * @param _feeInWei new price per token
1928   */
1929   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1930     PRICE = _feeInWei;
1931   }
1932 
1933   /**
1934   * @dev Get the correct price for the mint for qty and person minting
1935   * @param _count amount of tokens to calc for mint
1936   * @param _to the address which will be minting these tokens, passed explicitly
1937   */
1938   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1939     require(_count > 0, "Must be minting at least 1 token.");
1940 
1941     // short circuit function if we dont need to even calc incentive pricing
1942     // short circuit if the current wallet mint qty is also already over cap
1943     if(
1944       usingEarlyMintIncentive == false ||
1945       _numberMinted(_to) > earlyMintOwnershipCap
1946     ) {
1947       return PRICE * _count;
1948     }
1949 
1950     uint256 endingTokenQty = _numberMinted(_to) + _count;
1951     // If qty to mint results in a final qty less than or equal to the cap then
1952     // the entire qty is within incentive mint.
1953     if(endingTokenQty  <= earlyMintOwnershipCap) {
1954       return EARLY_MINT_PRICE * _count;
1955     }
1956 
1957     // If the current token qty is less than the incentive cap
1958     // and the ending token qty is greater than the incentive cap
1959     // we will be straddling the cap so there will be some amount
1960     // that are incentive and some that are regular fee.
1961     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1962     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1963 
1964     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1965   }
1966 }
1967 
1968   
1969 abstract contract RamppERC721A is 
1970     Ownable,
1971     Teams,
1972     ERC721ARedemption,
1973     WithdrawableV2,
1974     ReentrancyGuard 
1975     , EarlyMintIncentive 
1976     , Allowlist 
1977     
1978 {
1979   constructor(
1980     string memory tokenName,
1981     string memory tokenSymbol
1982   ) ERC721A(tokenName, tokenSymbol, 20, 1000) { }
1983     uint8 public CONTRACT_VERSION = 2;
1984     string public _baseTokenURI = "https://api.madnesstrader.wtf/";
1985     string public _baseTokenExtension = ".json";
1986 
1987     bool public mintingOpen = false;
1988     
1989     
1990     uint256 public MAX_WALLET_MINTS = 20;
1991 
1992   
1993     /////////////// Admin Mint Functions
1994     /**
1995      * @dev Mints a token to an address with a tokenURI.
1996      * This is owner only and allows a fee-free drop
1997      * @param _to address of the future owner of the token
1998      * @param _qty amount of tokens to drop the owner
1999      */
2000      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2001          require(_qty > 0, "Must mint at least 1 token.");
2002          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1000");
2003          _safeMint(_to, _qty, true);
2004      }
2005 
2006   
2007     /////////////// PUBLIC MINT FUNCTIONS
2008     /**
2009     * @dev Mints tokens to an address in batch.
2010     * fee may or may not be required*
2011     * @param _to address of the future owner of the token
2012     * @param _amount number of tokens to mint
2013     */
2014     function mintToMultiple(address _to, uint256 _amount) public payable {
2015         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2016         require(_amount >= 1, "Must mint at least 1 token");
2017         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2018         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2019         
2020         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2021         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2022         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
2023 
2024         _safeMint(_to, _amount, false);
2025     }
2026 
2027     /**
2028      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2029      * fee may or may not be required*
2030      * @param _to address of the future owner of the token
2031      * @param _amount number of tokens to mint
2032      * @param _erc20TokenContract erc-20 token contract to mint with
2033      */
2034     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2035       require(_amount >= 1, "Must mint at least 1 token");
2036       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2037       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2038       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2039       
2040       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2041 
2042       // ERC-20 Specific pre-flight checks
2043       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2044       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2045       IERC20 payableToken = IERC20(_erc20TokenContract);
2046 
2047       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2048       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2049 
2050       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2051       require(transferComplete, "ERC-20 token was unable to be transferred");
2052       
2053       _safeMint(_to, _amount, false);
2054     }
2055 
2056     function openMinting() public onlyTeamOrOwner {
2057         mintingOpen = true;
2058     }
2059 
2060     function stopMinting() public onlyTeamOrOwner {
2061         mintingOpen = false;
2062     }
2063 
2064   
2065     ///////////// ALLOWLIST MINTING FUNCTIONS
2066     /**
2067     * @dev Mints tokens to an address using an allowlist.
2068     * fee may or may not be required*
2069     * @param _to address of the future owner of the token
2070     * @param _amount number of tokens to mint
2071     * @param _merkleProof merkle proof array
2072     */
2073     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2074         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2075         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2076         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2077         require(_amount >= 1, "Must mint at least 1 token");
2078         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2079 
2080         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2081         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2082         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
2083         
2084 
2085         _safeMint(_to, _amount, false);
2086     }
2087 
2088     /**
2089     * @dev Mints tokens to an address using an allowlist.
2090     * fee may or may not be required*
2091     * @param _to address of the future owner of the token
2092     * @param _amount number of tokens to mint
2093     * @param _merkleProof merkle proof array
2094     * @param _erc20TokenContract erc-20 token contract to mint with
2095     */
2096     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2097       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2098       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2099       require(_amount >= 1, "Must mint at least 1 token");
2100       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2101       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2102       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1000");
2103       
2104     
2105       // ERC-20 Specific pre-flight checks
2106       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2107       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2108       IERC20 payableToken = IERC20(_erc20TokenContract);
2109     
2110       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2111       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2112       
2113       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2114       require(transferComplete, "ERC-20 token was unable to be transferred");
2115       
2116       _safeMint(_to, _amount, false);
2117     }
2118 
2119     /**
2120      * @dev Enable allowlist minting fully by enabling both flags
2121      * This is a convenience function for the Rampp user
2122      */
2123     function openAllowlistMint() public onlyTeamOrOwner {
2124         enableAllowlistOnlyMode();
2125         mintingOpen = true;
2126     }
2127 
2128     /**
2129      * @dev Close allowlist minting fully by disabling both flags
2130      * This is a convenience function for the Rampp user
2131      */
2132     function closeAllowlistMint() public onlyTeamOrOwner {
2133         disableAllowlistOnlyMode();
2134         mintingOpen = false;
2135     }
2136 
2137 
2138   
2139     /**
2140     * @dev Check if wallet over MAX_WALLET_MINTS
2141     * @param _address address in question to check if minted count exceeds max
2142     */
2143     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2144         require(_amount >= 1, "Amount must be greater than or equal to 1");
2145         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2146     }
2147 
2148     /**
2149     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2150     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2151     */
2152     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2153         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2154         MAX_WALLET_MINTS = _newWalletMax;
2155     }
2156     
2157 
2158   
2159     /**
2160      * @dev Allows owner to set Max mints per tx
2161      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2162      */
2163      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2164          require(_newMaxMint >= 1, "Max mint must be at least 1");
2165          maxBatchSize = _newMaxMint;
2166      }
2167     
2168 
2169   
2170 
2171   function _baseURI() internal view virtual override returns(string memory) {
2172     return _baseTokenURI;
2173   }
2174 
2175   function _baseURIExtension() internal view virtual override returns(string memory) {
2176     return _baseTokenExtension;
2177   }
2178 
2179   function baseTokenURI() public view returns(string memory) {
2180     return _baseTokenURI;
2181   }
2182 
2183   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2184     _baseTokenURI = baseURI;
2185   }
2186 
2187   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2188     _baseTokenExtension = baseExtension;
2189   }
2190 
2191   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2192     return ownershipOf(tokenId);
2193   }
2194 }
2195 
2196 
2197   
2198 // File: contracts/MadnessTraderbyCryptoNoblesContract.sol
2199 //SPDX-License-Identifier: MIT
2200 
2201 pragma solidity ^0.8.0;
2202 
2203 contract MadnessTraderbyCryptoNoblesContract is RamppERC721A {
2204     constructor() RamppERC721A("Madness Trader by CryptoNobles", "MD"){}
2205 }
2206   