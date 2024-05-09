1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ███████╗ ██████╗██████╗  ██████╗ ████████╗ ██████╗     ███████╗ ██████╗██╗  ██╗██╗███████╗ ██████╗ ███████╗           ██╗ ██████╗ ███╗   ██╗███████╗██╗  ██╗ ██████╗ 
5 // ██╔════╝██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██╔═══██╗    ██╔════╝██╔════╝██║  ██║██║╚══███╔╝██╔═══██╗██╔════╝          ███║██╔═████╗████╗  ██║██╔════╝██║ ██╔╝██╔═══██╗
6 // ███████╗██║     ██████╔╝██║   ██║   ██║   ██║   ██║    ███████╗██║     ███████║██║  ███╔╝ ██║   ██║███████╗    █████╗╚██║██║██╔██║██╔██╗ ██║█████╗  █████╔╝ ██║   ██║
7 // ╚════██║██║     ██╔══██╗██║   ██║   ██║   ██║   ██║    ╚════██║██║     ██╔══██║██║ ███╔╝  ██║   ██║╚════██║    ╚════╝ ██║████╔╝██║██║╚██╗██║██╔══╝  ██╔═██╗ ██║   ██║
8 // ███████║╚██████╗██║  ██║╚██████╔╝   ██║   ╚██████╔╝    ███████║╚██████╗██║  ██║██║███████╗╚██████╔╝███████║           ██║╚██████╔╝██║ ╚████║███████╗██║  ██╗╚██████╔╝
9 // ╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝     ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚══════╝           ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ 
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
741     function _onlyOwner() private view {
742        require(owner() == _msgSender(), "Ownable: caller is not the owner");
743     }
744 
745     modifier onlyOwner() {
746         _onlyOwner();
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
780 
781 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
782 pragma solidity ^0.8.9;
783 
784 interface IOperatorFilterRegistry {
785     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
786     function register(address registrant) external;
787     function registerAndSubscribe(address registrant, address subscription) external;
788     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
789     function updateOperator(address registrant, address operator, bool filtered) external;
790     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
791     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
792     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
793     function subscribe(address registrant, address registrantToSubscribe) external;
794     function unsubscribe(address registrant, bool copyExistingEntries) external;
795     function subscriptionOf(address addr) external returns (address registrant);
796     function subscribers(address registrant) external returns (address[] memory);
797     function subscriberAt(address registrant, uint256 index) external returns (address);
798     function copyEntriesOf(address registrant, address registrantToCopy) external;
799     function isOperatorFiltered(address registrant, address operator) external returns (bool);
800     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
801     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
802     function filteredOperators(address addr) external returns (address[] memory);
803     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
804     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
805     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
806     function isRegistered(address addr) external returns (bool);
807     function codeHashOf(address addr) external returns (bytes32);
808 }
809 
810 // File contracts/OperatorFilter/OperatorFilterer.sol
811 pragma solidity ^0.8.9;
812 
813 abstract contract OperatorFilterer {
814     error OperatorNotAllowed(address operator);
815 
816     IOperatorFilterRegistry constant operatorFilterRegistry =
817         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
818 
819     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
820         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
821         // will not revert, but the contract will need to be registered with the registry once it is deployed in
822         // order for the modifier to filter addresses.
823         if (address(operatorFilterRegistry).code.length > 0) {
824             if (subscribe) {
825                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
826             } else {
827                 if (subscriptionOrRegistrantToCopy != address(0)) {
828                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
829                 } else {
830                     operatorFilterRegistry.register(address(this));
831                 }
832             }
833         }
834     }
835 
836     function _onlyAllowedOperator(address from) private view {
837       if (
838           !(
839               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
840               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
841           )
842       ) {
843           revert OperatorNotAllowed(msg.sender);
844       }
845     }
846 
847     modifier onlyAllowedOperator(address from) virtual {
848         // Check registry code length to facilitate testing in environments without a deployed registry.
849         if (address(operatorFilterRegistry).code.length > 0) {
850             // Allow spending tokens from addresses with balance
851             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
852             // from an EOA.
853             if (from == msg.sender) {
854                 _;
855                 return;
856             }
857             _onlyAllowedOperator(from);
858         }
859         _;
860     }
861 
862     modifier onlyAllowedOperatorApproval(address operator) virtual {
863         _checkFilterOperator(operator);
864         _;
865     }
866 
867     function _checkFilterOperator(address operator) internal view virtual {
868         // Check registry code length to facilitate testing in environments without a deployed registry.
869         if (address(operatorFilterRegistry).code.length > 0) {
870             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
871                 revert OperatorNotAllowed(operator);
872             }
873         }
874     }
875 }
876 
877 //-------------END DEPENDENCIES------------------------//
878 
879 
880   
881 error TransactionCapExceeded();
882 error PublicMintingClosed();
883 error ExcessiveOwnedMints();
884 error MintZeroQuantity();
885 error InvalidPayment();
886 error CapExceeded();
887 error IsAlreadyUnveiled();
888 error ValueCannotBeZero();
889 error CannotBeNullAddress();
890 error NoStateChange();
891 
892 error PublicMintClosed();
893 error AllowlistMintClosed();
894 
895 error AddressNotAllowlisted();
896 error AllowlistDropTimeHasNotPassed();
897 error PublicDropTimeHasNotPassed();
898 error DropTimeNotInFuture();
899 
900 error OnlyERC20MintingEnabled();
901 error ERC20TokenNotApproved();
902 error ERC20InsufficientBalance();
903 error ERC20InsufficientAllowance();
904 error ERC20TransferFailed();
905 
906 error ClaimModeDisabled();
907 error IneligibleRedemptionContract();
908 error TokenAlreadyRedeemed();
909 error InvalidOwnerForRedemption();
910 error InvalidApprovalForRedemption();
911 
912 error ERC721RestrictedApprovalAddressRestricted();
913 error NotMaintainer();
914   
915   
916 // Rampp Contracts v2.1 (Teams.sol)
917 
918 error InvalidTeamAddress();
919 error DuplicateTeamAddress();
920 pragma solidity ^0.8.0;
921 
922 /**
923 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
924 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
925 * This will easily allow cross-collaboration via Mintplex.xyz.
926 **/
927 abstract contract Teams is Ownable{
928   mapping (address => bool) internal team;
929 
930   /**
931   * @dev Adds an address to the team. Allows them to execute protected functions
932   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
933   **/
934   function addToTeam(address _address) public onlyOwner {
935     if(_address == address(0)) revert InvalidTeamAddress();
936     if(inTeam(_address)) revert DuplicateTeamAddress();
937   
938     team[_address] = true;
939   }
940 
941   /**
942   * @dev Removes an address to the team.
943   * @param _address the ETH address to remove, cannot be 0x and must be in team
944   **/
945   function removeFromTeam(address _address) public onlyOwner {
946     if(_address == address(0)) revert InvalidTeamAddress();
947     if(!inTeam(_address)) revert InvalidTeamAddress();
948   
949     team[_address] = false;
950   }
951 
952   /**
953   * @dev Check if an address is valid and active in the team
954   * @param _address ETH address to check for truthiness
955   **/
956   function inTeam(address _address)
957     public
958     view
959     returns (bool)
960   {
961     if(_address == address(0)) revert InvalidTeamAddress();
962     return team[_address] == true;
963   }
964 
965   /**
966   * @dev Throws if called by any account other than the owner or team member.
967   */
968   function _onlyTeamOrOwner() private view {
969     bool _isOwner = owner() == _msgSender();
970     bool _isTeam = inTeam(_msgSender());
971     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
972   }
973 
974   modifier onlyTeamOrOwner() {
975     _onlyTeamOrOwner();
976     _;
977   }
978 }
979 
980 
981   
982   pragma solidity ^0.8.0;
983 
984   /**
985   * @dev These functions deal with verification of Merkle Trees proofs.
986   *
987   * The proofs can be generated using the JavaScript library
988   * https://github.com/miguelmota/merkletreejs[merkletreejs].
989   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
990   *
991   *
992   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
993   * hashing, or use a hash function other than keccak256 for hashing leaves.
994   * This is because the concatenation of a sorted pair of internal nodes in
995   * the merkle tree could be reinterpreted as a leaf value.
996   */
997   library MerkleProof {
998       /**
999       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1000       * defined by 'root'. For this, a 'proof' must be provided, containing
1001       * sibling hashes on the branch from the leaf to the root of the tree. Each
1002       * pair of leaves and each pair of pre-images are assumed to be sorted.
1003       */
1004       function verify(
1005           bytes32[] memory proof,
1006           bytes32 root,
1007           bytes32 leaf
1008       ) internal pure returns (bool) {
1009           return processProof(proof, leaf) == root;
1010       }
1011 
1012       /**
1013       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1014       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1015       * hash matches the root of the tree. When processing the proof, the pairs
1016       * of leafs & pre-images are assumed to be sorted.
1017       *
1018       * _Available since v4.4._
1019       */
1020       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1021           bytes32 computedHash = leaf;
1022           for (uint256 i = 0; i < proof.length; i++) {
1023               bytes32 proofElement = proof[i];
1024               if (computedHash <= proofElement) {
1025                   // Hash(current computed hash + current element of the proof)
1026                   computedHash = _efficientHash(computedHash, proofElement);
1027               } else {
1028                   // Hash(current element of the proof + current computed hash)
1029                   computedHash = _efficientHash(proofElement, computedHash);
1030               }
1031           }
1032           return computedHash;
1033       }
1034 
1035       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1036           assembly {
1037               mstore(0x00, a)
1038               mstore(0x20, b)
1039               value := keccak256(0x00, 0x40)
1040           }
1041       }
1042   }
1043 
1044 
1045   // File: Allowlist.sol
1046 
1047   pragma solidity ^0.8.0;
1048 
1049   abstract contract Allowlist is Teams {
1050     bytes32 public merkleRoot;
1051     bool public onlyAllowlistMode = false;
1052 
1053     /**
1054      * @dev Update merkle root to reflect changes in Allowlist
1055      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1056      */
1057     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1058       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1059       merkleRoot = _newMerkleRoot;
1060     }
1061 
1062     /**
1063      * @dev Check the proof of an address if valid for merkle root
1064      * @param _to address to check for proof
1065      * @param _merkleProof Proof of the address to validate against root and leaf
1066      */
1067     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1068       if(merkleRoot == 0) revert ValueCannotBeZero();
1069       bytes32 leaf = keccak256(abi.encodePacked(_to));
1070 
1071       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1072     }
1073 
1074     
1075     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1076       onlyAllowlistMode = true;
1077     }
1078 
1079     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1080         onlyAllowlistMode = false;
1081     }
1082   }
1083   
1084   
1085 /**
1086  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1087  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1088  *
1089  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1090  * 
1091  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1092  *
1093  * Does not support burning tokens to address(0).
1094  */
1095 contract ERC721A is
1096   Context,
1097   ERC165,
1098   IERC721,
1099   IERC721Metadata,
1100   IERC721Enumerable,
1101   Teams
1102   , OperatorFilterer
1103 {
1104   using Address for address;
1105   using Strings for uint256;
1106 
1107   struct TokenOwnership {
1108     address addr;
1109     uint64 startTimestamp;
1110   }
1111 
1112   struct AddressData {
1113     uint128 balance;
1114     uint128 numberMinted;
1115   }
1116 
1117   uint256 private currentIndex;
1118 
1119   uint256 public immutable collectionSize;
1120   uint256 public maxBatchSize;
1121 
1122   // Token name
1123   string private _name;
1124 
1125   // Token symbol
1126   string private _symbol;
1127 
1128   // Mapping from token ID to ownership details
1129   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1130   mapping(uint256 => TokenOwnership) private _ownerships;
1131 
1132   // Mapping owner address to address data
1133   mapping(address => AddressData) private _addressData;
1134 
1135   // Mapping from token ID to approved address
1136   mapping(uint256 => address) private _tokenApprovals;
1137 
1138   // Mapping from owner to operator approvals
1139   mapping(address => mapping(address => bool)) private _operatorApprovals;
1140 
1141   /* @dev Mapping of restricted operator approvals set by contract Owner
1142   * This serves as an optional addition to ERC-721 so
1143   * that the contract owner can elect to prevent specific addresses/contracts
1144   * from being marked as the approver for a token. The reason for this
1145   * is that some projects may want to retain control of where their tokens can/can not be listed
1146   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1147   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1148   */
1149   mapping(address => bool) public restrictedApprovalAddresses;
1150 
1151   /**
1152    * @dev
1153    * maxBatchSize refers to how much a minter can mint at a time.
1154    * collectionSize_ refers to how many tokens are in the collection.
1155    */
1156   constructor(
1157     string memory name_,
1158     string memory symbol_,
1159     uint256 maxBatchSize_,
1160     uint256 collectionSize_
1161   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1162     require(
1163       collectionSize_ > 0,
1164       "ERC721A: collection must have a nonzero supply"
1165     );
1166     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1167     _name = name_;
1168     _symbol = symbol_;
1169     maxBatchSize = maxBatchSize_;
1170     collectionSize = collectionSize_;
1171     currentIndex = _startTokenId();
1172   }
1173 
1174   /**
1175   * To change the starting tokenId, please override this function.
1176   */
1177   function _startTokenId() internal view virtual returns (uint256) {
1178     return 1;
1179   }
1180 
1181   /**
1182    * @dev See {IERC721Enumerable-totalSupply}.
1183    */
1184   function totalSupply() public view override returns (uint256) {
1185     return _totalMinted();
1186   }
1187 
1188   function currentTokenId() public view returns (uint256) {
1189     return _totalMinted();
1190   }
1191 
1192   function getNextTokenId() public view returns (uint256) {
1193       return _totalMinted() + 1;
1194   }
1195 
1196   /**
1197   * Returns the total amount of tokens minted in the contract.
1198   */
1199   function _totalMinted() internal view returns (uint256) {
1200     unchecked {
1201       return currentIndex - _startTokenId();
1202     }
1203   }
1204 
1205   /**
1206    * @dev See {IERC721Enumerable-tokenByIndex}.
1207    */
1208   function tokenByIndex(uint256 index) public view override returns (uint256) {
1209     require(index < totalSupply(), "ERC721A: global index out of bounds");
1210     return index;
1211   }
1212 
1213   /**
1214    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1215    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1216    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1217    */
1218   function tokenOfOwnerByIndex(address owner, uint256 index)
1219     public
1220     view
1221     override
1222     returns (uint256)
1223   {
1224     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1225     uint256 numMintedSoFar = totalSupply();
1226     uint256 tokenIdsIdx = 0;
1227     address currOwnershipAddr = address(0);
1228     for (uint256 i = 0; i < numMintedSoFar; i++) {
1229       TokenOwnership memory ownership = _ownerships[i];
1230       if (ownership.addr != address(0)) {
1231         currOwnershipAddr = ownership.addr;
1232       }
1233       if (currOwnershipAddr == owner) {
1234         if (tokenIdsIdx == index) {
1235           return i;
1236         }
1237         tokenIdsIdx++;
1238       }
1239     }
1240     revert("ERC721A: unable to get token of owner by index");
1241   }
1242 
1243   /**
1244    * @dev See {IERC165-supportsInterface}.
1245    */
1246   function supportsInterface(bytes4 interfaceId)
1247     public
1248     view
1249     virtual
1250     override(ERC165, IERC165)
1251     returns (bool)
1252   {
1253     return
1254       interfaceId == type(IERC721).interfaceId ||
1255       interfaceId == type(IERC721Metadata).interfaceId ||
1256       interfaceId == type(IERC721Enumerable).interfaceId ||
1257       super.supportsInterface(interfaceId);
1258   }
1259 
1260   /**
1261    * @dev See {IERC721-balanceOf}.
1262    */
1263   function balanceOf(address owner) public view override returns (uint256) {
1264     require(owner != address(0), "ERC721A: balance query for the zero address");
1265     return uint256(_addressData[owner].balance);
1266   }
1267 
1268   function _numberMinted(address owner) internal view returns (uint256) {
1269     require(
1270       owner != address(0),
1271       "ERC721A: number minted query for the zero address"
1272     );
1273     return uint256(_addressData[owner].numberMinted);
1274   }
1275 
1276   function ownershipOf(uint256 tokenId)
1277     internal
1278     view
1279     returns (TokenOwnership memory)
1280   {
1281     uint256 curr = tokenId;
1282 
1283     unchecked {
1284         if (_startTokenId() <= curr && curr < currentIndex) {
1285             TokenOwnership memory ownership = _ownerships[curr];
1286             if (ownership.addr != address(0)) {
1287                 return ownership;
1288             }
1289 
1290             // Invariant:
1291             // There will always be an ownership that has an address and is not burned
1292             // before an ownership that does not have an address and is not burned.
1293             // Hence, curr will not underflow.
1294             while (true) {
1295                 curr--;
1296                 ownership = _ownerships[curr];
1297                 if (ownership.addr != address(0)) {
1298                     return ownership;
1299                 }
1300             }
1301         }
1302     }
1303 
1304     revert("ERC721A: unable to determine the owner of token");
1305   }
1306 
1307   /**
1308    * @dev See {IERC721-ownerOf}.
1309    */
1310   function ownerOf(uint256 tokenId) public view override returns (address) {
1311     return ownershipOf(tokenId).addr;
1312   }
1313 
1314   /**
1315    * @dev See {IERC721Metadata-name}.
1316    */
1317   function name() public view virtual override returns (string memory) {
1318     return _name;
1319   }
1320 
1321   /**
1322    * @dev See {IERC721Metadata-symbol}.
1323    */
1324   function symbol() public view virtual override returns (string memory) {
1325     return _symbol;
1326   }
1327 
1328   /**
1329    * @dev See {IERC721Metadata-tokenURI}.
1330    */
1331   function tokenURI(uint256 tokenId)
1332     public
1333     view
1334     virtual
1335     override
1336     returns (string memory)
1337   {
1338     string memory baseURI = _baseURI();
1339     string memory extension = _baseURIExtension();
1340     return
1341       bytes(baseURI).length > 0
1342         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1343         : "";
1344   }
1345 
1346   /**
1347    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1348    * token will be the concatenation of the baseURI and the tokenId. Empty
1349    * by default, can be overriden in child contracts.
1350    */
1351   function _baseURI() internal view virtual returns (string memory) {
1352     return "";
1353   }
1354 
1355   /**
1356    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1357    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1358    * by default, can be overriden in child contracts.
1359    */
1360   function _baseURIExtension() internal view virtual returns (string memory) {
1361     return "";
1362   }
1363 
1364   /**
1365    * @dev Sets the value for an address to be in the restricted approval address pool.
1366    * Setting an address to true will disable token owners from being able to mark the address
1367    * for approval for trading. This would be used in theory to prevent token owners from listing
1368    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1369    * @param _address the marketplace/user to modify restriction status of
1370    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1371    */
1372   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1373     restrictedApprovalAddresses[_address] = _isRestricted;
1374   }
1375 
1376   /**
1377    * @dev See {IERC721-approve}.
1378    */
1379   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1380     address owner = ERC721A.ownerOf(tokenId);
1381     require(to != owner, "ERC721A: approval to current owner");
1382     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1383 
1384     require(
1385       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1386       "ERC721A: approve caller is not owner nor approved for all"
1387     );
1388 
1389     _approve(to, tokenId, owner);
1390   }
1391 
1392   /**
1393    * @dev See {IERC721-getApproved}.
1394    */
1395   function getApproved(uint256 tokenId) public view override returns (address) {
1396     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1397 
1398     return _tokenApprovals[tokenId];
1399   }
1400 
1401   /**
1402    * @dev See {IERC721-setApprovalForAll}.
1403    */
1404   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1405     require(operator != _msgSender(), "ERC721A: approve to caller");
1406     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1407 
1408     _operatorApprovals[_msgSender()][operator] = approved;
1409     emit ApprovalForAll(_msgSender(), operator, approved);
1410   }
1411 
1412   /**
1413    * @dev See {IERC721-isApprovedForAll}.
1414    */
1415   function isApprovedForAll(address owner, address operator)
1416     public
1417     view
1418     virtual
1419     override
1420     returns (bool)
1421   {
1422     return _operatorApprovals[owner][operator];
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-transferFrom}.
1427    */
1428   function transferFrom(
1429     address from,
1430     address to,
1431     uint256 tokenId
1432   ) public override onlyAllowedOperator(from) {
1433     _transfer(from, to, tokenId);
1434   }
1435 
1436   /**
1437    * @dev See {IERC721-safeTransferFrom}.
1438    */
1439   function safeTransferFrom(
1440     address from,
1441     address to,
1442     uint256 tokenId
1443   ) public override onlyAllowedOperator(from) {
1444     safeTransferFrom(from, to, tokenId, "");
1445   }
1446 
1447   /**
1448    * @dev See {IERC721-safeTransferFrom}.
1449    */
1450   function safeTransferFrom(
1451     address from,
1452     address to,
1453     uint256 tokenId,
1454     bytes memory _data
1455   ) public override onlyAllowedOperator(from) {
1456     _transfer(from, to, tokenId);
1457     require(
1458       _checkOnERC721Received(from, to, tokenId, _data),
1459       "ERC721A: transfer to non ERC721Receiver implementer"
1460     );
1461   }
1462 
1463   /**
1464    * @dev Returns whether tokenId exists.
1465    *
1466    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1467    *
1468    * Tokens start existing when they are minted (_mint),
1469    */
1470   function _exists(uint256 tokenId) internal view returns (bool) {
1471     return _startTokenId() <= tokenId && tokenId < currentIndex;
1472   }
1473 
1474   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1475     _safeMint(to, quantity, isAdminMint, "");
1476   }
1477 
1478   /**
1479    * @dev Mints quantity tokens and transfers them to to.
1480    *
1481    * Requirements:
1482    *
1483    * - there must be quantity tokens remaining unminted in the total collection.
1484    * - to cannot be the zero address.
1485    * - quantity cannot be larger than the max batch size.
1486    *
1487    * Emits a {Transfer} event.
1488    */
1489   function _safeMint(
1490     address to,
1491     uint256 quantity,
1492     bool isAdminMint,
1493     bytes memory _data
1494   ) internal {
1495     uint256 startTokenId = currentIndex;
1496     require(to != address(0), "ERC721A: mint to the zero address");
1497     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1498     require(!_exists(startTokenId), "ERC721A: token already minted");
1499 
1500     // For admin mints we do not want to enforce the maxBatchSize limit
1501     if (isAdminMint == false) {
1502         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1503     }
1504 
1505     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1506 
1507     AddressData memory addressData = _addressData[to];
1508     _addressData[to] = AddressData(
1509       addressData.balance + uint128(quantity),
1510       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1511     );
1512     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1513 
1514     uint256 updatedIndex = startTokenId;
1515 
1516     for (uint256 i = 0; i < quantity; i++) {
1517       emit Transfer(address(0), to, updatedIndex);
1518       require(
1519         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1520         "ERC721A: transfer to non ERC721Receiver implementer"
1521       );
1522       updatedIndex++;
1523     }
1524 
1525     currentIndex = updatedIndex;
1526     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1527   }
1528 
1529   /**
1530    * @dev Transfers tokenId from from to to.
1531    *
1532    * Requirements:
1533    *
1534    * - to cannot be the zero address.
1535    * - tokenId token must be owned by from.
1536    *
1537    * Emits a {Transfer} event.
1538    */
1539   function _transfer(
1540     address from,
1541     address to,
1542     uint256 tokenId
1543   ) private {
1544     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1545 
1546     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1547       getApproved(tokenId) == _msgSender() ||
1548       isApprovedForAll(prevOwnership.addr, _msgSender()));
1549 
1550     require(
1551       isApprovedOrOwner,
1552       "ERC721A: transfer caller is not owner nor approved"
1553     );
1554 
1555     require(
1556       prevOwnership.addr == from,
1557       "ERC721A: transfer from incorrect owner"
1558     );
1559     require(to != address(0), "ERC721A: transfer to the zero address");
1560 
1561     _beforeTokenTransfers(from, to, tokenId, 1);
1562 
1563     // Clear approvals from the previous owner
1564     _approve(address(0), tokenId, prevOwnership.addr);
1565 
1566     _addressData[from].balance -= 1;
1567     _addressData[to].balance += 1;
1568     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1569 
1570     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1571     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1572     uint256 nextTokenId = tokenId + 1;
1573     if (_ownerships[nextTokenId].addr == address(0)) {
1574       if (_exists(nextTokenId)) {
1575         _ownerships[nextTokenId] = TokenOwnership(
1576           prevOwnership.addr,
1577           prevOwnership.startTimestamp
1578         );
1579       }
1580     }
1581 
1582     emit Transfer(from, to, tokenId);
1583     _afterTokenTransfers(from, to, tokenId, 1);
1584   }
1585 
1586   /**
1587    * @dev Approve to to operate on tokenId
1588    *
1589    * Emits a {Approval} event.
1590    */
1591   function _approve(
1592     address to,
1593     uint256 tokenId,
1594     address owner
1595   ) private {
1596     _tokenApprovals[tokenId] = to;
1597     emit Approval(owner, to, tokenId);
1598   }
1599 
1600   uint256 public nextOwnerToExplicitlySet = 0;
1601 
1602   /**
1603    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1604    */
1605   function _setOwnersExplicit(uint256 quantity) internal {
1606     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1607     require(quantity > 0, "quantity must be nonzero");
1608     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1609 
1610     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1611     if (endIndex > collectionSize - 1) {
1612       endIndex = collectionSize - 1;
1613     }
1614     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1615     require(_exists(endIndex), "not enough minted yet for this cleanup");
1616     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1617       if (_ownerships[i].addr == address(0)) {
1618         TokenOwnership memory ownership = ownershipOf(i);
1619         _ownerships[i] = TokenOwnership(
1620           ownership.addr,
1621           ownership.startTimestamp
1622         );
1623       }
1624     }
1625     nextOwnerToExplicitlySet = endIndex + 1;
1626   }
1627 
1628   /**
1629    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1630    * The call is not executed if the target address is not a contract.
1631    *
1632    * @param from address representing the previous owner of the given token ID
1633    * @param to target address that will receive the tokens
1634    * @param tokenId uint256 ID of the token to be transferred
1635    * @param _data bytes optional data to send along with the call
1636    * @return bool whether the call correctly returned the expected magic value
1637    */
1638   function _checkOnERC721Received(
1639     address from,
1640     address to,
1641     uint256 tokenId,
1642     bytes memory _data
1643   ) private returns (bool) {
1644     if (to.isContract()) {
1645       try
1646         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1647       returns (bytes4 retval) {
1648         return retval == IERC721Receiver(to).onERC721Received.selector;
1649       } catch (bytes memory reason) {
1650         if (reason.length == 0) {
1651           revert("ERC721A: transfer to non ERC721Receiver implementer");
1652         } else {
1653           assembly {
1654             revert(add(32, reason), mload(reason))
1655           }
1656         }
1657       }
1658     } else {
1659       return true;
1660     }
1661   }
1662 
1663   /**
1664    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1665    *
1666    * startTokenId - the first token id to be transferred
1667    * quantity - the amount to be transferred
1668    *
1669    * Calling conditions:
1670    *
1671    * - When from and to are both non-zero, from's tokenId will be
1672    * transferred to to.
1673    * - When from is zero, tokenId will be minted for to.
1674    */
1675   function _beforeTokenTransfers(
1676     address from,
1677     address to,
1678     uint256 startTokenId,
1679     uint256 quantity
1680   ) internal virtual {}
1681 
1682   /**
1683    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1684    * minting.
1685    *
1686    * startTokenId - the first token id to be transferred
1687    * quantity - the amount to be transferred
1688    *
1689    * Calling conditions:
1690    *
1691    * - when from and to are both non-zero.
1692    * - from and to are never both zero.
1693    */
1694   function _afterTokenTransfers(
1695     address from,
1696     address to,
1697     uint256 startTokenId,
1698     uint256 quantity
1699   ) internal virtual {}
1700 }
1701 
1702 abstract contract ProviderFees is Context {
1703   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1704   uint256 public PROVIDER_FEE = 0.000777 ether;  
1705 
1706   function sendProviderFee() internal {
1707     payable(PROVIDER).transfer(PROVIDER_FEE);
1708   }
1709 
1710   function setProviderFee(uint256 _fee) public {
1711     if(_msgSender() != PROVIDER) revert NotMaintainer();
1712     PROVIDER_FEE = _fee;
1713   }
1714 }
1715 
1716 
1717 
1718   
1719   
1720 interface IERC20 {
1721   function allowance(address owner, address spender) external view returns (uint256);
1722   function transfer(address _to, uint256 _amount) external returns (bool);
1723   function balanceOf(address account) external view returns (uint256);
1724   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1725 }
1726 
1727 // File: WithdrawableV2
1728 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1729 // ERC-20 Payouts are limited to a single payout address. This feature 
1730 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1731 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1732 abstract contract WithdrawableV2 is Teams {
1733   struct acceptedERC20 {
1734     bool isActive;
1735     uint256 chargeAmount;
1736   }
1737 
1738   
1739   mapping(address => acceptedERC20) private allowedTokenContracts;
1740   address[] public payableAddresses = [0x67B7155Bf117B6a3e4989667Cc6a7512d6dB3542];
1741   address public erc20Payable = 0x67B7155Bf117B6a3e4989667Cc6a7512d6dB3542;
1742   uint256[] public payableFees = [100];
1743   uint256 public payableAddressCount = 1;
1744   bool public onlyERC20MintingMode;
1745   
1746 
1747   function withdrawAll() public onlyTeamOrOwner {
1748       if(address(this).balance == 0) revert ValueCannotBeZero();
1749       _withdrawAll(address(this).balance);
1750   }
1751 
1752   function _withdrawAll(uint256 balance) private {
1753       for(uint i=0; i < payableAddressCount; i++ ) {
1754           _widthdraw(
1755               payableAddresses[i],
1756               (balance * payableFees[i]) / 100
1757           );
1758       }
1759   }
1760   
1761   function _widthdraw(address _address, uint256 _amount) private {
1762       (bool success, ) = _address.call{value: _amount}("");
1763       require(success, "Transfer failed.");
1764   }
1765 
1766   /**
1767   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1768   * in the event ERC-20 tokens are paid to the contract for mints.
1769   * @param _tokenContract contract of ERC-20 token to withdraw
1770   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1771   */
1772   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1773     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1774     IERC20 tokenContract = IERC20(_tokenContract);
1775     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1776     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1777   }
1778 
1779   /**
1780   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1781   * @param _erc20TokenContract address of ERC-20 contract in question
1782   */
1783   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1784     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1785   }
1786 
1787   /**
1788   * @dev get the value of tokens to transfer for user of an ERC-20
1789   * @param _erc20TokenContract address of ERC-20 contract in question
1790   */
1791   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1792     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1793     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1794   }
1795 
1796   /**
1797   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1798   * @param _erc20TokenContract address of ERC-20 contract in question
1799   * @param _isActive default status of if contract should be allowed to accept payments
1800   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1801   */
1802   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1803     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1804     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1805   }
1806 
1807   /**
1808   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1809   * it will assume the default value of zero. This should not be used to create new payment tokens.
1810   * @param _erc20TokenContract address of ERC-20 contract in question
1811   */
1812   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1813     allowedTokenContracts[_erc20TokenContract].isActive = true;
1814   }
1815 
1816   /**
1817   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1818   * it will assume the default value of zero. This should not be used to create new payment tokens.
1819   * @param _erc20TokenContract address of ERC-20 contract in question
1820   */
1821   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1822     allowedTokenContracts[_erc20TokenContract].isActive = false;
1823   }
1824 
1825   /**
1826   * @dev Enable only ERC-20 payments for minting on this contract
1827   */
1828   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1829     onlyERC20MintingMode = true;
1830   }
1831 
1832   /**
1833   * @dev Disable only ERC-20 payments for minting on this contract
1834   */
1835   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1836     onlyERC20MintingMode = false;
1837   }
1838 
1839   /**
1840   * @dev Set the payout of the ERC-20 token payout to a specific address
1841   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1842   */
1843   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1844     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1845     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1846     erc20Payable = _newErc20Payable;
1847   }
1848 }
1849 
1850 
1851   
1852 // File: isFeeable.sol
1853 abstract contract Feeable is Teams, ProviderFees {
1854   uint256 public PRICE = 0.01 ether;
1855 
1856   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1857     PRICE = _feeInWei;
1858   }
1859 
1860   function getPrice(uint256 _count) public view returns (uint256) {
1861     return (PRICE * _count) + PROVIDER_FEE;
1862   }
1863 }
1864 
1865   
1866 /* File: Tippable.sol
1867 /* @dev Allows owner to set strict enforcement of payment to mint price.
1868 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1869 /* when doing a free mint with opt-in pricing.
1870 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1871 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1872 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1873 /* Pros - can take in gratituity payments during a mint. 
1874 /* Cons - However if you decrease pricing during mint txn settlement 
1875 /* it can result in mints landing who technically now have overpaid.
1876 */
1877 abstract contract Tippable is Teams {
1878   bool public strictPricing = true;
1879 
1880   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1881     strictPricing = _newStatus;
1882   }
1883 
1884   // @dev check if msg.value is correct according to pricing enforcement
1885   // @param _msgValue -> passed in msg.value of tx
1886   // @param _expectedPrice -> result of getPrice(...args)
1887   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1888     return strictPricing ? 
1889       _msgValue == _expectedPrice : 
1890       _msgValue >= _expectedPrice;
1891   }
1892 }
1893 
1894   
1895   
1896   
1897 abstract contract ERC721APlus is 
1898     Ownable,
1899     Teams,
1900     ERC721A,
1901     WithdrawableV2,
1902     ReentrancyGuard 
1903     , Feeable, Tippable 
1904     , Allowlist 
1905     
1906 {
1907   constructor(
1908     string memory tokenName,
1909     string memory tokenSymbol
1910   ) ERC721A(tokenName, tokenSymbol, 10, 6969) { }
1911     uint8 constant public CONTRACT_VERSION = 2;
1912     string public _baseTokenURI = "ipfs://QmeR8J37Ng5P2zXK7CQhrf8P64ZfHjA5gA37L3kaXZhFg5/";
1913     string public _baseTokenExtension = ".json";
1914 
1915     bool public mintingOpen = false;
1916     
1917     
1918     uint256 public MAX_WALLET_MINTS = 20;
1919 
1920   
1921     /////////////// Admin Mint Functions
1922     /**
1923      * @dev Mints a token to an address with a tokenURI.
1924      * This is owner only and allows a fee-free drop
1925      * @param _to address of the future owner of the token
1926      * @param _qty amount of tokens to drop the owner
1927      */
1928      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1929          if(_qty == 0) revert MintZeroQuantity();
1930          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1931          _safeMint(_to, _qty, true);
1932      }
1933 
1934   
1935     /////////////// PUBLIC MINT FUNCTIONS
1936     /**
1937     * @dev Mints tokens to an address in batch.
1938     * fee may or may not be required*
1939     * @param _to address of the future owner of the token
1940     * @param _amount number of tokens to mint
1941     */
1942     function mintToMultiple(address _to, uint256 _amount) public payable {
1943         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1944         if(_amount == 0) revert MintZeroQuantity();
1945         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1946         if(!mintingOpen) revert PublicMintClosed();
1947         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
1948         
1949         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1950         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1951         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
1952         sendProviderFee();
1953         _safeMint(_to, _amount, false);
1954     }
1955 
1956     /**
1957      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1958      * fee may or may not be required*
1959      * @param _to address of the future owner of the token
1960      * @param _amount number of tokens to mint
1961      * @param _erc20TokenContract erc-20 token contract to mint with
1962      */
1963     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1964       if(_amount == 0) revert MintZeroQuantity();
1965       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1966       if(!mintingOpen) revert PublicMintClosed();
1967       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1968       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
1969       
1970       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1971       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
1972 
1973       // ERC-20 Specific pre-flight checks
1974       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1975       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1976       IERC20 payableToken = IERC20(_erc20TokenContract);
1977 
1978       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1979       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1980 
1981       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1982       if(!transferComplete) revert ERC20TransferFailed();
1983 
1984       sendProviderFee();
1985       _safeMint(_to, _amount, false);
1986     }
1987 
1988     function openMinting() public onlyTeamOrOwner {
1989         mintingOpen = true;
1990     }
1991 
1992     function stopMinting() public onlyTeamOrOwner {
1993         mintingOpen = false;
1994     }
1995 
1996   
1997     ///////////// ALLOWLIST MINTING FUNCTIONS
1998     /**
1999     * @dev Mints tokens to an address using an allowlist.
2000     * fee may or may not be required*
2001     * @param _to address of the future owner of the token
2002     * @param _amount number of tokens to mint
2003     * @param _merkleProof merkle proof array
2004     */
2005     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2006         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2007         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2008         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2009         if(_amount == 0) revert MintZeroQuantity();
2010         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2011         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2012         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2013         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2014         
2015 
2016         sendProviderFee();
2017         _safeMint(_to, _amount, false);
2018     }
2019 
2020     /**
2021     * @dev Mints tokens to an address using an allowlist.
2022     * fee may or may not be required*
2023     * @param _to address of the future owner of the token
2024     * @param _amount number of tokens to mint
2025     * @param _merkleProof merkle proof array
2026     * @param _erc20TokenContract erc-20 token contract to mint with
2027     */
2028     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2029       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2030       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2031       if(_amount == 0) revert MintZeroQuantity();
2032       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2033       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2034       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2035       
2036       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2037 
2038       // ERC-20 Specific pre-flight checks
2039       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2040       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2041       IERC20 payableToken = IERC20(_erc20TokenContract);
2042 
2043       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2044       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2045 
2046       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2047       if(!transferComplete) revert ERC20TransferFailed();
2048       
2049       sendProviderFee();
2050       _safeMint(_to, _amount, false);
2051     }
2052 
2053     /**
2054      * @dev Enable allowlist minting fully by enabling both flags
2055      * This is a convenience function for the Rampp user
2056      */
2057     function openAllowlistMint() public onlyTeamOrOwner {
2058         enableAllowlistOnlyMode();
2059         mintingOpen = true;
2060     }
2061 
2062     /**
2063      * @dev Close allowlist minting fully by disabling both flags
2064      * This is a convenience function for the Rampp user
2065      */
2066     function closeAllowlistMint() public onlyTeamOrOwner {
2067         disableAllowlistOnlyMode();
2068         mintingOpen = false;
2069     }
2070 
2071 
2072   
2073     /**
2074     * @dev Check if wallet over MAX_WALLET_MINTS
2075     * @param _address address in question to check if minted count exceeds max
2076     */
2077     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2078         if(_amount == 0) revert ValueCannotBeZero();
2079         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2080     }
2081 
2082     /**
2083     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2084     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2085     */
2086     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2087         if(_newWalletMax == 0) revert ValueCannotBeZero();
2088         MAX_WALLET_MINTS = _newWalletMax;
2089     }
2090     
2091 
2092   
2093     /**
2094      * @dev Allows owner to set Max mints per tx
2095      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2096      */
2097      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2098          if(_newMaxMint == 0) revert ValueCannotBeZero();
2099          maxBatchSize = _newMaxMint;
2100      }
2101     
2102 
2103   
2104   
2105   
2106   function contractURI() public pure returns (string memory) {
2107     return "https://metadata.mintplex.xyz/0vydTO6fos6gJYUW3ozi/contract-metadata";
2108   }
2109   
2110 
2111   function _baseURI() internal view virtual override returns(string memory) {
2112     return _baseTokenURI;
2113   }
2114 
2115   function _baseURIExtension() internal view virtual override returns(string memory) {
2116     return _baseTokenExtension;
2117   }
2118 
2119   function baseTokenURI() public view returns(string memory) {
2120     return _baseTokenURI;
2121   }
2122 
2123   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2124     _baseTokenURI = baseURI;
2125   }
2126 
2127   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2128     _baseTokenExtension = baseExtension;
2129   }
2130 }
2131 
2132 
2133   
2134 // File: contracts/ScrotoSchizos10NekoContract.sol
2135 //SPDX-License-Identifier: MIT
2136 
2137 pragma solidity ^0.8.0;
2138 
2139 contract ScrotoSchizos10NekoContract is ERC721APlus {
2140     constructor() ERC721APlus("Scroto Schizos 10Neko", "SCROTO"){}
2141 }
2142   