1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ▄▄▌ ▐ ▄▌▄▄▄ .     ▄ .▄ ▄▄▄· ▄▄▄▄▄▄▄▄ .    ·▄▄▄▄  ▄▄▄ . ▄▄ • ▄▄▄ . ▐ ▄ .▄▄ · 
5 // ██· █▌▐█▀▄.▀·    ██▪▐█▐█ ▀█ •██  ▀▄.▀·    ██▪ ██ ▀▄.▀·▐█ ▀ ▪▀▄.▀·•█▌▐█▐█ ▀. 
6 // ██▪▐█▐▐▌▐▀▀▪▄    ██▀▐█▄█▀▀█  ▐█.▪▐▀▀▪▄    ▐█· ▐█▌▐▀▀▪▄▄█ ▀█▄▐▀▀▪▄▐█▐▐▌▄▀▀▀█▄
7 // ▐█▌██▐█▌▐█▄▄▌    ██▌▐▀▐█ ▪▐▌ ▐█▌·▐█▄▄▌    ██. ██ ▐█▄▄▌▐█▄▪▐█▐█▄▄▌██▐█▌▐█▄▪▐█
8 //  ▀▀▀▀ ▀▪ ▀▀▀     ▀▀▀ · ▀  ▀  ▀▀▀  ▀▀▀     ▀▀▀▀▀•  ▀▀▀ ·▀▀▀▀  ▀▀▀ ▀▀ █▪ ▀▀▀▀ 
9 //
10 //*********************************************************************//
11 //*********************************************************************//
12   
13 //-------------DEPENDENCIES--------------------------//
14 
15 // File: @openzeppelin/contracts/utils/Address.sol
16 
17 
18 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
19 
20 pragma solidity ^0.8.1;
21 
22 /**
23  * @dev Collection of functions related to the address type
24  */
25 library Address {
26     /**
27      * @dev Returns true if account is a contract.
28      *
29      * [IMPORTANT]
30      * ====
31      * It is unsafe to assume that an address for which this function returns
32      * false is an externally-owned account (EOA) and not a contract.
33      *
34      * Among others, isContract will return false for the following
35      * types of addresses:
36      *
37      *  - an externally-owned account
38      *  - a contract in construction
39      *  - an address where a contract will be created
40      *  - an address where a contract lived, but was destroyed
41      * ====
42      *
43      * [IMPORTANT]
44      * ====
45      * You shouldn't rely on isContract to protect against flash loan attacks!
46      *
47      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
48      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
49      * constructor.
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize/address.code.length, which returns 0
54         // for contracts in construction, since the code is only stored at the end
55         // of the constructor execution.
56 
57         return account.code.length > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's transfer: sends amount wei to
62      * recipient, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by transfer, making them unable to receive funds via
67      * transfer. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to recipient, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level call. A
85      * plain call is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If target reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
93      *
94      * Requirements:
95      *
96      * - target must be a contract.
97      * - calling target with data must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
107      * errorMessage as a fallback revert reason when target reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
121      * but also transferring value wei to target.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least value.
126      * - the called Solidity function must be payable.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
140      * with errorMessage as a fallback revert reason when target reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 interface IERC721Receiver {
253     /**
254      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
255      * by operator from from, this function is called.
256      *
257      * It must return its Solidity selector to confirm the token transfer.
258      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
259      *
260      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
261      */
262     function onERC721Received(
263         address operator,
264         address from,
265         uint256 tokenId,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Interface of the ERC165 standard, as defined in the
279  * https://eips.ethereum.org/EIPS/eip-165[EIP].
280  *
281  * Implementers can declare support of contract interfaces, which can then be
282  * queried by others ({ERC165Checker}).
283  *
284  * For an implementation, see {ERC165}.
285  */
286 interface IERC165 {
287     /**
288      * @dev Returns true if this contract implements the interface defined by
289      * interfaceId. See the corresponding
290      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
291      * to learn more about how these ids are created.
292      *
293      * This function call must use less than 30 000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) external view returns (bool);
296 }
297 
298 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 
306 /**
307  * @dev Implementation of the {IERC165} interface.
308  *
309  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
310  * for the additional interface id that will be supported. For example:
311  *
312  * solidity
313  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
315  * }
316  * 
317  *
318  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
319  */
320 abstract contract ERC165 is IERC165 {
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      */
324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325         return interfaceId == type(IERC165).interfaceId;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 
337 /**
338  * @dev Required interface of an ERC721 compliant contract.
339  */
340 interface IERC721 is IERC165 {
341     /**
342      * @dev Emitted when tokenId token is transferred from from to to.
343      */
344     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
345 
346     /**
347      * @dev Emitted when owner enables approved to manage the tokenId token.
348      */
349     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
350 
351     /**
352      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
353      */
354     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
355 
356     /**
357      * @dev Returns the number of tokens in owner's account.
358      */
359     function balanceOf(address owner) external view returns (uint256 balance);
360 
361     /**
362      * @dev Returns the owner of the tokenId token.
363      *
364      * Requirements:
365      *
366      * - tokenId must exist.
367      */
368     function ownerOf(uint256 tokenId) external view returns (address owner);
369 
370     /**
371      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
372      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
373      *
374      * Requirements:
375      *
376      * - from cannot be the zero address.
377      * - to cannot be the zero address.
378      * - tokenId token must exist and be owned by from.
379      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
380      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
381      *
382      * Emits a {Transfer} event.
383      */
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) external;
389 
390     /**
391      * @dev Transfers tokenId token from from to to.
392      *
393      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
394      *
395      * Requirements:
396      *
397      * - from cannot be the zero address.
398      * - to cannot be the zero address.
399      * - tokenId token must be owned by from.
400      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external;
409 
410     /**
411      * @dev Gives permission to to to transfer tokenId token to another account.
412      * The approval is cleared when the token is transferred.
413      *
414      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
415      *
416      * Requirements:
417      *
418      * - The caller must own the token or be an approved operator.
419      * - tokenId must exist.
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address to, uint256 tokenId) external;
424 
425     /**
426      * @dev Returns the account approved for tokenId token.
427      *
428      * Requirements:
429      *
430      * - tokenId must exist.
431      */
432     function getApproved(uint256 tokenId) external view returns (address operator);
433 
434     /**
435      * @dev Approve or remove operator as an operator for the caller.
436      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The operator cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns if the operator is allowed to manage all of the assets of owner.
448      *
449      * See {setApprovalForAll}
450      */
451     function isApprovedForAll(address owner, address operator) external view returns (bool);
452 
453     /**
454      * @dev Safely transfers tokenId token from from to to.
455      *
456      * Requirements:
457      *
458      * - from cannot be the zero address.
459      * - to cannot be the zero address.
460      * - tokenId token must exist and be owned by from.
461      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
484  * @dev See https://eips.ethereum.org/EIPS/eip-721
485  */
486 interface IERC721Enumerable is IERC721 {
487     /**
488      * @dev Returns the total amount of tokens stored by the contract.
489      */
490     function totalSupply() external view returns (uint256);
491 
492     /**
493      * @dev Returns a token ID owned by owner at a given index of its token list.
494      * Use along with {balanceOf} to enumerate all of owner's tokens.
495      */
496     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
497 
498     /**
499      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
500      * Use along with {totalSupply} to enumerate all tokens.
501      */
502     function tokenByIndex(uint256 index) external view returns (uint256);
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
515  * @dev See https://eips.ethereum.org/EIPS/eip-721
516  */
517 interface IERC721Metadata is IERC721 {
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 }
533 
534 // File: @openzeppelin/contracts/utils/Strings.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
546 
547     /**
548      * @dev Converts a uint256 to its ASCII string decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         // Inspired by OraclizeAPI's implementation - MIT licence
552         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
553 
554         if (value == 0) {
555             return "0";
556         }
557         uint256 temp = value;
558         uint256 digits;
559         while (temp != 0) {
560             digits++;
561             temp /= 10;
562         }
563         bytes memory buffer = new bytes(digits);
564         while (value != 0) {
565             digits -= 1;
566             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
567             value /= 10;
568         }
569         return string(buffer);
570     }
571 
572     /**
573      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         if (value == 0) {
577             return "0x00";
578         }
579         uint256 temp = value;
580         uint256 length = 0;
581         while (temp != 0) {
582             length++;
583             temp >>= 8;
584         }
585         return toHexString(value, length);
586     }
587 
588     /**
589      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
590      */
591     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
592         bytes memory buffer = new bytes(2 * length + 2);
593         buffer[0] = "0";
594         buffer[1] = "x";
595         for (uint256 i = 2 * length + 1; i > 1; --i) {
596             buffer[i] = _HEX_SYMBOLS[value & 0xf];
597             value >>= 4;
598         }
599         require(value == 0, "Strings: hex length insufficient");
600         return string(buffer);
601     }
602 }
603 
604 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Contract module that helps prevent reentrant calls to a function.
613  *
614  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
615  * available, which can be applied to functions to make sure there are no nested
616  * (reentrant) calls to them.
617  *
618  * Note that because there is a single nonReentrant guard, functions marked as
619  * nonReentrant may not call one another. This can be worked around by making
620  * those functions private, and then adding external nonReentrant entry
621  * points to them.
622  *
623  * TIP: If you would like to learn more about reentrancy and alternative ways
624  * to protect against it, check out our blog post
625  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
626  */
627 abstract contract ReentrancyGuard {
628     // Booleans are more expensive than uint256 or any type that takes up a full
629     // word because each write operation emits an extra SLOAD to first read the
630     // slot's contents, replace the bits taken up by the boolean, and then write
631     // back. This is the compiler's defense against contract upgrades and
632     // pointer aliasing, and it cannot be disabled.
633 
634     // The values being non-zero value makes deployment a bit more expensive,
635     // but in exchange the refund on every call to nonReentrant will be lower in
636     // amount. Since refunds are capped to a percentage of the total
637     // transaction's gas, it is best to keep them low in cases like this one, to
638     // increase the likelihood of the full refund coming into effect.
639     uint256 private constant _NOT_ENTERED = 1;
640     uint256 private constant _ENTERED = 2;
641 
642     uint256 private _status;
643 
644     constructor() {
645         _status = _NOT_ENTERED;
646     }
647 
648     /**
649      * @dev Prevents a contract from calling itself, directly or indirectly.
650      * Calling a nonReentrant function from another nonReentrant
651      * function is not supported. It is possible to prevent this from happening
652      * by making the nonReentrant function external, and making it call a
653      * private function that does the actual work.
654      */
655     modifier nonReentrant() {
656         // On the first call to nonReentrant, _notEntered will be true
657         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
658 
659         // Any calls to nonReentrant after this point will fail
660         _status = _ENTERED;
661 
662         _;
663 
664         // By storing the original value once again, a refund is triggered (see
665         // https://eips.ethereum.org/EIPS/eip-2200)
666         _status = _NOT_ENTERED;
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/Context.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Provides information about the current execution context, including the
679  * sender of the transaction and its data. While these are generally available
680  * via msg.sender and msg.data, they should not be accessed in such a direct
681  * manner, since when dealing with meta-transactions the account sending and
682  * paying for execution may not be the actual sender (as far as an application
683  * is concerned).
684  *
685  * This contract is only required for intermediate, library-like contracts.
686  */
687 abstract contract Context {
688     function _msgSender() internal view virtual returns (address) {
689         return msg.sender;
690     }
691 
692     function _msgData() internal view virtual returns (bytes calldata) {
693         return msg.data;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/access/Ownable.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Contract module which provides a basic access control mechanism, where
707  * there is an account (an owner) that can be granted exclusive access to
708  * specific functions.
709  *
710  * By default, the owner account will be the one that deploys the contract. This
711  * can later be changed with {transferOwnership}.
712  *
713  * This module is used through inheritance. It will make available the modifier
714  * onlyOwner, which can be applied to your functions to restrict their use to
715  * the owner.
716  */
717 abstract contract Ownable is Context {
718     address private _owner;
719 
720     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
721 
722     /**
723      * @dev Initializes the contract setting the deployer as the initial owner.
724      */
725     constructor() {
726         _transferOwnership(_msgSender());
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view virtual returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(owner() == _msgSender(), "Ownable: caller is not the owner");
741         _;
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * onlyOwner functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         _transferOwnership(address(0));
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (newOwner).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public virtual onlyOwner {
760         require(newOwner != address(0), "Ownable: new owner is the zero address");
761         _transferOwnership(newOwner);
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (newOwner).
766      * Internal function without access restriction.
767      */
768     function _transferOwnership(address newOwner) internal virtual {
769         address oldOwner = _owner;
770         _owner = newOwner;
771         emit OwnershipTransferred(oldOwner, newOwner);
772     }
773 }
774 //-------------END DEPENDENCIES------------------------//
775 
776 
777   
778 // Rampp Contracts v2.1 (Teams.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 /**
783 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
784 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
785 * This will easily allow cross-collaboration via Mintplex.xyz.
786 **/
787 abstract contract Teams is Ownable{
788   mapping (address => bool) internal team;
789 
790   /**
791   * @dev Adds an address to the team. Allows them to execute protected functions
792   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
793   **/
794   function addToTeam(address _address) public onlyOwner {
795     require(_address != address(0), "Invalid address");
796     require(!inTeam(_address), "This address is already in your team.");
797   
798     team[_address] = true;
799   }
800 
801   /**
802   * @dev Removes an address to the team.
803   * @param _address the ETH address to remove, cannot be 0x and must be in team
804   **/
805   function removeFromTeam(address _address) public onlyOwner {
806     require(_address != address(0), "Invalid address");
807     require(inTeam(_address), "This address is not in your team currently.");
808   
809     team[_address] = false;
810   }
811 
812   /**
813   * @dev Check if an address is valid and active in the team
814   * @param _address ETH address to check for truthiness
815   **/
816   function inTeam(address _address)
817     public
818     view
819     returns (bool)
820   {
821     require(_address != address(0), "Invalid address to check.");
822     return team[_address] == true;
823   }
824 
825   /**
826   * @dev Throws if called by any account other than the owner or team member.
827   */
828   modifier onlyTeamOrOwner() {
829     bool _isOwner = owner() == _msgSender();
830     bool _isTeam = inTeam(_msgSender());
831     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
832     _;
833   }
834 }
835 
836 
837   
838   
839 /**
840  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
841  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
842  *
843  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
844  * 
845  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
846  *
847  * Does not support burning tokens to address(0).
848  */
849 contract ERC721A is
850   Context,
851   ERC165,
852   IERC721,
853   IERC721Metadata,
854   IERC721Enumerable,
855   Teams
856 {
857   using Address for address;
858   using Strings for uint256;
859 
860   struct TokenOwnership {
861     address addr;
862     uint64 startTimestamp;
863   }
864 
865   struct AddressData {
866     uint128 balance;
867     uint128 numberMinted;
868   }
869 
870   uint256 private currentIndex;
871 
872   uint256 public immutable collectionSize;
873   uint256 public maxBatchSize;
874 
875   // Token name
876   string private _name;
877 
878   // Token symbol
879   string private _symbol;
880 
881   // Mapping from token ID to ownership details
882   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
883   mapping(uint256 => TokenOwnership) private _ownerships;
884 
885   // Mapping owner address to address data
886   mapping(address => AddressData) private _addressData;
887 
888   // Mapping from token ID to approved address
889   mapping(uint256 => address) private _tokenApprovals;
890 
891   // Mapping from owner to operator approvals
892   mapping(address => mapping(address => bool)) private _operatorApprovals;
893 
894   /* @dev Mapping of restricted operator approvals set by contract Owner
895   * This serves as an optional addition to ERC-721 so
896   * that the contract owner can elect to prevent specific addresses/contracts
897   * from being marked as the approver for a token. The reason for this
898   * is that some projects may want to retain control of where their tokens can/can not be listed
899   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
900   * By default, there are no restrictions. The contract owner must deliberatly block an address 
901   */
902   mapping(address => bool) public restrictedApprovalAddresses;
903 
904   /**
905    * @dev
906    * maxBatchSize refers to how much a minter can mint at a time.
907    * collectionSize_ refers to how many tokens are in the collection.
908    */
909   constructor(
910     string memory name_,
911     string memory symbol_,
912     uint256 maxBatchSize_,
913     uint256 collectionSize_
914   ) {
915     require(
916       collectionSize_ > 0,
917       "ERC721A: collection must have a nonzero supply"
918     );
919     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
920     _name = name_;
921     _symbol = symbol_;
922     maxBatchSize = maxBatchSize_;
923     collectionSize = collectionSize_;
924     currentIndex = _startTokenId();
925   }
926 
927   /**
928   * To change the starting tokenId, please override this function.
929   */
930   function _startTokenId() internal view virtual returns (uint256) {
931     return 1;
932   }
933 
934   /**
935    * @dev See {IERC721Enumerable-totalSupply}.
936    */
937   function totalSupply() public view override returns (uint256) {
938     return _totalMinted();
939   }
940 
941   function currentTokenId() public view returns (uint256) {
942     return _totalMinted();
943   }
944 
945   function getNextTokenId() public view returns (uint256) {
946       return _totalMinted() + 1;
947   }
948 
949   /**
950   * Returns the total amount of tokens minted in the contract.
951   */
952   function _totalMinted() internal view returns (uint256) {
953     unchecked {
954       return currentIndex - _startTokenId();
955     }
956   }
957 
958   /**
959    * @dev See {IERC721Enumerable-tokenByIndex}.
960    */
961   function tokenByIndex(uint256 index) public view override returns (uint256) {
962     require(index < totalSupply(), "ERC721A: global index out of bounds");
963     return index;
964   }
965 
966   /**
967    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
968    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
969    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
970    */
971   function tokenOfOwnerByIndex(address owner, uint256 index)
972     public
973     view
974     override
975     returns (uint256)
976   {
977     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
978     uint256 numMintedSoFar = totalSupply();
979     uint256 tokenIdsIdx = 0;
980     address currOwnershipAddr = address(0);
981     for (uint256 i = 0; i < numMintedSoFar; i++) {
982       TokenOwnership memory ownership = _ownerships[i];
983       if (ownership.addr != address(0)) {
984         currOwnershipAddr = ownership.addr;
985       }
986       if (currOwnershipAddr == owner) {
987         if (tokenIdsIdx == index) {
988           return i;
989         }
990         tokenIdsIdx++;
991       }
992     }
993     revert("ERC721A: unable to get token of owner by index");
994   }
995 
996   /**
997    * @dev See {IERC165-supportsInterface}.
998    */
999   function supportsInterface(bytes4 interfaceId)
1000     public
1001     view
1002     virtual
1003     override(ERC165, IERC165)
1004     returns (bool)
1005   {
1006     return
1007       interfaceId == type(IERC721).interfaceId ||
1008       interfaceId == type(IERC721Metadata).interfaceId ||
1009       interfaceId == type(IERC721Enumerable).interfaceId ||
1010       super.supportsInterface(interfaceId);
1011   }
1012 
1013   /**
1014    * @dev See {IERC721-balanceOf}.
1015    */
1016   function balanceOf(address owner) public view override returns (uint256) {
1017     require(owner != address(0), "ERC721A: balance query for the zero address");
1018     return uint256(_addressData[owner].balance);
1019   }
1020 
1021   function _numberMinted(address owner) internal view returns (uint256) {
1022     require(
1023       owner != address(0),
1024       "ERC721A: number minted query for the zero address"
1025     );
1026     return uint256(_addressData[owner].numberMinted);
1027   }
1028 
1029   function ownershipOf(uint256 tokenId)
1030     internal
1031     view
1032     returns (TokenOwnership memory)
1033   {
1034     uint256 curr = tokenId;
1035 
1036     unchecked {
1037         if (_startTokenId() <= curr && curr < currentIndex) {
1038             TokenOwnership memory ownership = _ownerships[curr];
1039             if (ownership.addr != address(0)) {
1040                 return ownership;
1041             }
1042 
1043             // Invariant:
1044             // There will always be an ownership that has an address and is not burned
1045             // before an ownership that does not have an address and is not burned.
1046             // Hence, curr will not underflow.
1047             while (true) {
1048                 curr--;
1049                 ownership = _ownerships[curr];
1050                 if (ownership.addr != address(0)) {
1051                     return ownership;
1052                 }
1053             }
1054         }
1055     }
1056 
1057     revert("ERC721A: unable to determine the owner of token");
1058   }
1059 
1060   /**
1061    * @dev See {IERC721-ownerOf}.
1062    */
1063   function ownerOf(uint256 tokenId) public view override returns (address) {
1064     return ownershipOf(tokenId).addr;
1065   }
1066 
1067   /**
1068    * @dev See {IERC721Metadata-name}.
1069    */
1070   function name() public view virtual override returns (string memory) {
1071     return _name;
1072   }
1073 
1074   /**
1075    * @dev See {IERC721Metadata-symbol}.
1076    */
1077   function symbol() public view virtual override returns (string memory) {
1078     return _symbol;
1079   }
1080 
1081   /**
1082    * @dev See {IERC721Metadata-tokenURI}.
1083    */
1084   function tokenURI(uint256 tokenId)
1085     public
1086     view
1087     virtual
1088     override
1089     returns (string memory)
1090   {
1091     string memory baseURI = _baseURI();
1092     return
1093       bytes(baseURI).length > 0
1094         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1095         : "";
1096   }
1097 
1098   /**
1099    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1100    * token will be the concatenation of the baseURI and the tokenId. Empty
1101    * by default, can be overriden in child contracts.
1102    */
1103   function _baseURI() internal view virtual returns (string memory) {
1104     return "";
1105   }
1106 
1107   /**
1108    * @dev Sets the value for an address to be in the restricted approval address pool.
1109    * Setting an address to true will disable token owners from being able to mark the address
1110    * for approval for trading. This would be used in theory to prevent token owners from listing
1111    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1112    * @param _address the marketplace/user to modify restriction status of
1113    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1114    */
1115   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1116     restrictedApprovalAddresses[_address] = _isRestricted;
1117   }
1118 
1119   /**
1120    * @dev See {IERC721-approve}.
1121    */
1122   function approve(address to, uint256 tokenId) public override {
1123     address owner = ERC721A.ownerOf(tokenId);
1124     require(to != owner, "ERC721A: approval to current owner");
1125     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1126 
1127     require(
1128       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1129       "ERC721A: approve caller is not owner nor approved for all"
1130     );
1131 
1132     _approve(to, tokenId, owner);
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-getApproved}.
1137    */
1138   function getApproved(uint256 tokenId) public view override returns (address) {
1139     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1140 
1141     return _tokenApprovals[tokenId];
1142   }
1143 
1144   /**
1145    * @dev See {IERC721-setApprovalForAll}.
1146    */
1147   function setApprovalForAll(address operator, bool approved) public override {
1148     require(operator != _msgSender(), "ERC721A: approve to caller");
1149     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1150 
1151     _operatorApprovals[_msgSender()][operator] = approved;
1152     emit ApprovalForAll(_msgSender(), operator, approved);
1153   }
1154 
1155   /**
1156    * @dev See {IERC721-isApprovedForAll}.
1157    */
1158   function isApprovedForAll(address owner, address operator)
1159     public
1160     view
1161     virtual
1162     override
1163     returns (bool)
1164   {
1165     return _operatorApprovals[owner][operator];
1166   }
1167 
1168   /**
1169    * @dev See {IERC721-transferFrom}.
1170    */
1171   function transferFrom(
1172     address from,
1173     address to,
1174     uint256 tokenId
1175   ) public override {
1176     _transfer(from, to, tokenId);
1177   }
1178 
1179   /**
1180    * @dev See {IERC721-safeTransferFrom}.
1181    */
1182   function safeTransferFrom(
1183     address from,
1184     address to,
1185     uint256 tokenId
1186   ) public override {
1187     safeTransferFrom(from, to, tokenId, "");
1188   }
1189 
1190   /**
1191    * @dev See {IERC721-safeTransferFrom}.
1192    */
1193   function safeTransferFrom(
1194     address from,
1195     address to,
1196     uint256 tokenId,
1197     bytes memory _data
1198   ) public override {
1199     _transfer(from, to, tokenId);
1200     require(
1201       _checkOnERC721Received(from, to, tokenId, _data),
1202       "ERC721A: transfer to non ERC721Receiver implementer"
1203     );
1204   }
1205 
1206   /**
1207    * @dev Returns whether tokenId exists.
1208    *
1209    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1210    *
1211    * Tokens start existing when they are minted (_mint),
1212    */
1213   function _exists(uint256 tokenId) internal view returns (bool) {
1214     return _startTokenId() <= tokenId && tokenId < currentIndex;
1215   }
1216 
1217   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1218     _safeMint(to, quantity, isAdminMint, "");
1219   }
1220 
1221   /**
1222    * @dev Mints quantity tokens and transfers them to to.
1223    *
1224    * Requirements:
1225    *
1226    * - there must be quantity tokens remaining unminted in the total collection.
1227    * - to cannot be the zero address.
1228    * - quantity cannot be larger than the max batch size.
1229    *
1230    * Emits a {Transfer} event.
1231    */
1232   function _safeMint(
1233     address to,
1234     uint256 quantity,
1235     bool isAdminMint,
1236     bytes memory _data
1237   ) internal {
1238     uint256 startTokenId = currentIndex;
1239     require(to != address(0), "ERC721A: mint to the zero address");
1240     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1241     require(!_exists(startTokenId), "ERC721A: token already minted");
1242 
1243     // For admin mints we do not want to enforce the maxBatchSize limit
1244     if (isAdminMint == false) {
1245         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1246     }
1247 
1248     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1249 
1250     AddressData memory addressData = _addressData[to];
1251     _addressData[to] = AddressData(
1252       addressData.balance + uint128(quantity),
1253       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1254     );
1255     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1256 
1257     uint256 updatedIndex = startTokenId;
1258 
1259     for (uint256 i = 0; i < quantity; i++) {
1260       emit Transfer(address(0), to, updatedIndex);
1261       require(
1262         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1263         "ERC721A: transfer to non ERC721Receiver implementer"
1264       );
1265       updatedIndex++;
1266     }
1267 
1268     currentIndex = updatedIndex;
1269     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1270   }
1271 
1272   /**
1273    * @dev Transfers tokenId from from to to.
1274    *
1275    * Requirements:
1276    *
1277    * - to cannot be the zero address.
1278    * - tokenId token must be owned by from.
1279    *
1280    * Emits a {Transfer} event.
1281    */
1282   function _transfer(
1283     address from,
1284     address to,
1285     uint256 tokenId
1286   ) private {
1287     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1288 
1289     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1290       getApproved(tokenId) == _msgSender() ||
1291       isApprovedForAll(prevOwnership.addr, _msgSender()));
1292 
1293     require(
1294       isApprovedOrOwner,
1295       "ERC721A: transfer caller is not owner nor approved"
1296     );
1297 
1298     require(
1299       prevOwnership.addr == from,
1300       "ERC721A: transfer from incorrect owner"
1301     );
1302     require(to != address(0), "ERC721A: transfer to the zero address");
1303 
1304     _beforeTokenTransfers(from, to, tokenId, 1);
1305 
1306     // Clear approvals from the previous owner
1307     _approve(address(0), tokenId, prevOwnership.addr);
1308 
1309     _addressData[from].balance -= 1;
1310     _addressData[to].balance += 1;
1311     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1312 
1313     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1314     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1315     uint256 nextTokenId = tokenId + 1;
1316     if (_ownerships[nextTokenId].addr == address(0)) {
1317       if (_exists(nextTokenId)) {
1318         _ownerships[nextTokenId] = TokenOwnership(
1319           prevOwnership.addr,
1320           prevOwnership.startTimestamp
1321         );
1322       }
1323     }
1324 
1325     emit Transfer(from, to, tokenId);
1326     _afterTokenTransfers(from, to, tokenId, 1);
1327   }
1328 
1329   /**
1330    * @dev Approve to to operate on tokenId
1331    *
1332    * Emits a {Approval} event.
1333    */
1334   function _approve(
1335     address to,
1336     uint256 tokenId,
1337     address owner
1338   ) private {
1339     _tokenApprovals[tokenId] = to;
1340     emit Approval(owner, to, tokenId);
1341   }
1342 
1343   uint256 public nextOwnerToExplicitlySet = 0;
1344 
1345   /**
1346    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1347    */
1348   function _setOwnersExplicit(uint256 quantity) internal {
1349     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1350     require(quantity > 0, "quantity must be nonzero");
1351     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1352 
1353     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1354     if (endIndex > collectionSize - 1) {
1355       endIndex = collectionSize - 1;
1356     }
1357     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1358     require(_exists(endIndex), "not enough minted yet for this cleanup");
1359     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1360       if (_ownerships[i].addr == address(0)) {
1361         TokenOwnership memory ownership = ownershipOf(i);
1362         _ownerships[i] = TokenOwnership(
1363           ownership.addr,
1364           ownership.startTimestamp
1365         );
1366       }
1367     }
1368     nextOwnerToExplicitlySet = endIndex + 1;
1369   }
1370 
1371   /**
1372    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1373    * The call is not executed if the target address is not a contract.
1374    *
1375    * @param from address representing the previous owner of the given token ID
1376    * @param to target address that will receive the tokens
1377    * @param tokenId uint256 ID of the token to be transferred
1378    * @param _data bytes optional data to send along with the call
1379    * @return bool whether the call correctly returned the expected magic value
1380    */
1381   function _checkOnERC721Received(
1382     address from,
1383     address to,
1384     uint256 tokenId,
1385     bytes memory _data
1386   ) private returns (bool) {
1387     if (to.isContract()) {
1388       try
1389         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1390       returns (bytes4 retval) {
1391         return retval == IERC721Receiver(to).onERC721Received.selector;
1392       } catch (bytes memory reason) {
1393         if (reason.length == 0) {
1394           revert("ERC721A: transfer to non ERC721Receiver implementer");
1395         } else {
1396           assembly {
1397             revert(add(32, reason), mload(reason))
1398           }
1399         }
1400       }
1401     } else {
1402       return true;
1403     }
1404   }
1405 
1406   /**
1407    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1408    *
1409    * startTokenId - the first token id to be transferred
1410    * quantity - the amount to be transferred
1411    *
1412    * Calling conditions:
1413    *
1414    * - When from and to are both non-zero, from's tokenId will be
1415    * transferred to to.
1416    * - When from is zero, tokenId will be minted for to.
1417    */
1418   function _beforeTokenTransfers(
1419     address from,
1420     address to,
1421     uint256 startTokenId,
1422     uint256 quantity
1423   ) internal virtual {}
1424 
1425   /**
1426    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1427    * minting.
1428    *
1429    * startTokenId - the first token id to be transferred
1430    * quantity - the amount to be transferred
1431    *
1432    * Calling conditions:
1433    *
1434    * - when from and to are both non-zero.
1435    * - from and to are never both zero.
1436    */
1437   function _afterTokenTransfers(
1438     address from,
1439     address to,
1440     uint256 startTokenId,
1441     uint256 quantity
1442   ) internal virtual {}
1443 }
1444 
1445 
1446 
1447   
1448 abstract contract Ramppable {
1449   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1450 
1451   modifier isRampp() {
1452       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1453       _;
1454   }
1455 }
1456 
1457 
1458   
1459   
1460 interface IERC20 {
1461   function allowance(address owner, address spender) external view returns (uint256);
1462   function transfer(address _to, uint256 _amount) external returns (bool);
1463   function balanceOf(address account) external view returns (uint256);
1464   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1465 }
1466 
1467 // File: WithdrawableV2
1468 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1469 // ERC-20 Payouts are limited to a single payout address. This feature 
1470 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1471 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1472 abstract contract WithdrawableV2 is Teams, Ramppable {
1473   struct acceptedERC20 {
1474     bool isActive;
1475     uint256 chargeAmount;
1476   }
1477 
1478   
1479   mapping(address => acceptedERC20) private allowedTokenContracts;
1480   address[] public payableAddresses = [RAMPPADDRESS,0x502b65CBc776B0AdEF15EdB74A800d18870D91dF];
1481   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1482   address public erc20Payable = 0x502b65CBc776B0AdEF15EdB74A800d18870D91dF;
1483   uint256[] public payableFees = [5,95];
1484   uint256[] public surchargePayableFees = [100];
1485   uint256 public payableAddressCount = 2;
1486   uint256 public surchargePayableAddressCount = 1;
1487   uint256 public ramppSurchargeBalance = 0 ether;
1488   uint256 public ramppSurchargeFee = 0.001 ether;
1489   bool public onlyERC20MintingMode = false;
1490   
1491 
1492   /**
1493   * @dev Calculates the true payable balance of the contract as the
1494   * value on contract may be from ERC-20 mint surcharges and not 
1495   * public mint charges - which are not eligable for rev share & user withdrawl
1496   */
1497   function calcAvailableBalance() public view returns(uint256) {
1498     return address(this).balance - ramppSurchargeBalance;
1499   }
1500 
1501   function withdrawAll() public onlyTeamOrOwner {
1502       require(calcAvailableBalance() > 0);
1503       _withdrawAll();
1504   }
1505   
1506   function withdrawAllRampp() public isRampp {
1507       require(calcAvailableBalance() > 0);
1508       _withdrawAll();
1509   }
1510 
1511   function _withdrawAll() private {
1512       uint256 balance = calcAvailableBalance();
1513       
1514       for(uint i=0; i < payableAddressCount; i++ ) {
1515           _widthdraw(
1516               payableAddresses[i],
1517               (balance * payableFees[i]) / 100
1518           );
1519       }
1520   }
1521   
1522   function _widthdraw(address _address, uint256 _amount) private {
1523       (bool success, ) = _address.call{value: _amount}("");
1524       require(success, "Transfer failed.");
1525   }
1526 
1527   /**
1528   * @dev This function is similiar to the regular withdraw but operates only on the
1529   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1530   **/
1531   function _withdrawAllSurcharges() private {
1532     uint256 balance = ramppSurchargeBalance;
1533     if(balance == 0) { return; }
1534     
1535     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1536         _widthdraw(
1537             surchargePayableAddresses[i],
1538             (balance * surchargePayableFees[i]) / 100
1539         );
1540     }
1541     ramppSurchargeBalance = 0 ether;
1542   }
1543 
1544   /**
1545   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1546   * in the event ERC-20 tokens are paid to the contract for mints. This will
1547   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1548   * @param _tokenContract contract of ERC-20 token to withdraw
1549   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1550   */
1551   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1552     require(_amountToWithdraw > 0);
1553     IERC20 tokenContract = IERC20(_tokenContract);
1554     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1555     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1556     _withdrawAllSurcharges();
1557   }
1558 
1559   /**
1560   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1561   */
1562   function withdrawRamppSurcharges() public isRampp {
1563     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1564     _withdrawAllSurcharges();
1565   }
1566 
1567    /**
1568   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1569   */
1570   function addSurcharge() internal {
1571     ramppSurchargeBalance += ramppSurchargeFee;
1572   }
1573   
1574   /**
1575   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1576   */
1577   function hasSurcharge() internal returns(bool) {
1578     return msg.value == ramppSurchargeFee;
1579   }
1580 
1581   /**
1582   * @dev Set surcharge fee for using ERC-20 payments on contract
1583   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1584   */
1585   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1586     ramppSurchargeFee = _newSurcharge;
1587   }
1588 
1589   /**
1590   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1591   * @param _erc20TokenContract address of ERC-20 contract in question
1592   */
1593   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1594     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1595   }
1596 
1597   /**
1598   * @dev get the value of tokens to transfer for user of an ERC-20
1599   * @param _erc20TokenContract address of ERC-20 contract in question
1600   */
1601   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1602     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1603     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1604   }
1605 
1606   /**
1607   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1608   * @param _erc20TokenContract address of ERC-20 contract in question
1609   * @param _isActive default status of if contract should be allowed to accept payments
1610   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1611   */
1612   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1613     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1614     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1615   }
1616 
1617   /**
1618   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1619   * it will assume the default value of zero. This should not be used to create new payment tokens.
1620   * @param _erc20TokenContract address of ERC-20 contract in question
1621   */
1622   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1623     allowedTokenContracts[_erc20TokenContract].isActive = true;
1624   }
1625 
1626   /**
1627   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1628   * it will assume the default value of zero. This should not be used to create new payment tokens.
1629   * @param _erc20TokenContract address of ERC-20 contract in question
1630   */
1631   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1632     allowedTokenContracts[_erc20TokenContract].isActive = false;
1633   }
1634 
1635   /**
1636   * @dev Enable only ERC-20 payments for minting on this contract
1637   */
1638   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1639     onlyERC20MintingMode = true;
1640   }
1641 
1642   /**
1643   * @dev Disable only ERC-20 payments for minting on this contract
1644   */
1645   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1646     onlyERC20MintingMode = false;
1647   }
1648 
1649   /**
1650   * @dev Set the payout of the ERC-20 token payout to a specific address
1651   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1652   */
1653   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1654     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1655     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1656     erc20Payable = _newErc20Payable;
1657   }
1658 
1659   /**
1660   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1661   */
1662   function resetRamppSurchargeBalance() public isRampp {
1663     ramppSurchargeBalance = 0 ether;
1664   }
1665 
1666   /**
1667   * @dev Allows Rampp wallet to update its own reference as well as update
1668   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1669   * and since Rampp is always the first address this function is limited to the rampp payout only.
1670   * @param _newAddress updated Rampp Address
1671   */
1672   function setRamppAddress(address _newAddress) public isRampp {
1673     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1674     RAMPPADDRESS = _newAddress;
1675     payableAddresses[0] = _newAddress;
1676   }
1677 }
1678 
1679 
1680   
1681   
1682   
1683 // File: EarlyMintIncentive.sol
1684 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1685 // zero fee that can be calculated on the fly.
1686 abstract contract EarlyMintIncentive is Teams, ERC721A {
1687   uint256 public PRICE = 0.0033 ether;
1688   uint256 public EARLY_MINT_PRICE = 0 ether;
1689   uint256 public earlyMintOwnershipCap = 1;
1690   bool public usingEarlyMintIncentive = true;
1691 
1692   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1693     usingEarlyMintIncentive = true;
1694   }
1695 
1696   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1697     usingEarlyMintIncentive = false;
1698   }
1699 
1700   /**
1701   * @dev Set the max token ID in which the cost incentive will be applied.
1702   * @param _newCap max number of tokens wallet may mint for incentive price
1703   */
1704   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1705     require(_newCap >= 1, "Cannot set cap to less than 1");
1706     earlyMintOwnershipCap = _newCap;
1707   }
1708 
1709   /**
1710   * @dev Set the incentive mint price
1711   * @param _feeInWei new price per token when in incentive range
1712   */
1713   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1714     EARLY_MINT_PRICE = _feeInWei;
1715   }
1716 
1717   /**
1718   * @dev Set the primary mint price - the base price when not under incentive
1719   * @param _feeInWei new price per token
1720   */
1721   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1722     PRICE = _feeInWei;
1723   }
1724 
1725   function getPrice(uint256 _count) public view returns (uint256) {
1726     require(_count > 0, "Must be minting at least 1 token.");
1727 
1728     // short circuit function if we dont need to even calc incentive pricing
1729     // short circuit if the current wallet mint qty is also already over cap
1730     if(
1731       usingEarlyMintIncentive == false ||
1732       _numberMinted(msg.sender) > earlyMintOwnershipCap
1733     ) {
1734       return PRICE * _count;
1735     }
1736 
1737     uint256 endingTokenQty = _numberMinted(msg.sender) + _count;
1738     // If qty to mint results in a final qty less than or equal to the cap then
1739     // the entire qty is within incentive mint.
1740     if(endingTokenQty  <= earlyMintOwnershipCap) {
1741       return EARLY_MINT_PRICE * _count;
1742     }
1743 
1744     // If the current token qty is less than the incentive cap
1745     // and the ending token qty is greater than the incentive cap
1746     // we will be straddling the cap so there will be some amount
1747     // that are incentive and some that are regular fee.
1748     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(msg.sender);
1749     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1750 
1751     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1752   }
1753 }
1754 
1755   
1756 abstract contract RamppERC721A is 
1757     Ownable,
1758     Teams,
1759     ERC721A,
1760     WithdrawableV2,
1761     ReentrancyGuard 
1762     , EarlyMintIncentive 
1763      
1764     
1765 {
1766   constructor(
1767     string memory tokenName,
1768     string memory tokenSymbol
1769   ) ERC721A(tokenName, tokenSymbol, 20, 3333) { }
1770     uint8 public CONTRACT_VERSION = 2;
1771     string public _baseTokenURI = "https://api.wehatedegens.com/";
1772 
1773     bool public mintingOpen = false;
1774     
1775     
1776 
1777   
1778     /////////////// Admin Mint Functions
1779     /**
1780      * @dev Mints a token to an address with a tokenURI.
1781      * This is owner only and allows a fee-free drop
1782      * @param _to address of the future owner of the token
1783      * @param _qty amount of tokens to drop the owner
1784      */
1785      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1786          require(_qty > 0, "Must mint at least 1 token.");
1787          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 3333");
1788          _safeMint(_to, _qty, true);
1789      }
1790 
1791   
1792     /////////////// GENERIC MINT FUNCTIONS
1793     /**
1794     * @dev Mints a single token to an address.
1795     * fee may or may not be required*
1796     * @param _to address of the future owner of the token
1797     */
1798     function mintTo(address _to) public payable {
1799         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1800         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1801         require(mintingOpen == true, "Minting is not open right now!");
1802         
1803         
1804         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1805         
1806         _safeMint(_to, 1, false);
1807     }
1808 
1809     /**
1810     * @dev Mints tokens to an address in batch.
1811     * fee may or may not be required*
1812     * @param _to address of the future owner of the token
1813     * @param _amount number of tokens to mint
1814     */
1815     function mintToMultiple(address _to, uint256 _amount) public payable {
1816         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1817         require(_amount >= 1, "Must mint at least 1 token");
1818         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1819         require(mintingOpen == true, "Minting is not open right now!");
1820         
1821         
1822         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3333");
1823         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1824 
1825         _safeMint(_to, _amount, false);
1826     }
1827 
1828     /**
1829      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1830      * fee may or may not be required*
1831      * @param _to address of the future owner of the token
1832      * @param _amount number of tokens to mint
1833      * @param _erc20TokenContract erc-20 token contract to mint with
1834      */
1835     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1836       require(_amount >= 1, "Must mint at least 1 token");
1837       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1838       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3333");
1839       require(mintingOpen == true, "Minting is not open right now!");
1840       
1841       
1842 
1843       // ERC-20 Specific pre-flight checks
1844       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1845       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1846       IERC20 payableToken = IERC20(_erc20TokenContract);
1847 
1848       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1849       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1850       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1851       
1852       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1853       require(transferComplete, "ERC-20 token was unable to be transferred");
1854       
1855       _safeMint(_to, _amount, false);
1856       addSurcharge();
1857     }
1858 
1859     function openMinting() public onlyTeamOrOwner {
1860         mintingOpen = true;
1861     }
1862 
1863     function stopMinting() public onlyTeamOrOwner {
1864         mintingOpen = false;
1865     }
1866 
1867   
1868 
1869   
1870 
1871   
1872     /**
1873      * @dev Allows owner to set Max mints per tx
1874      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1875      */
1876      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1877          require(_newMaxMint >= 1, "Max mint must be at least 1");
1878          maxBatchSize = _newMaxMint;
1879      }
1880     
1881 
1882   
1883 
1884   function _baseURI() internal view virtual override returns(string memory) {
1885     return _baseTokenURI;
1886   }
1887 
1888   function baseTokenURI() public view returns(string memory) {
1889     return _baseTokenURI;
1890   }
1891 
1892   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1893     _baseTokenURI = baseURI;
1894   }
1895 
1896   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1897     return ownershipOf(tokenId);
1898   }
1899 }
1900 
1901 
1902   
1903 // File: contracts/WeHateDegensContract.sol
1904 //SPDX-License-Identifier: MIT
1905 
1906 pragma solidity ^0.8.0;
1907 
1908 contract WeHateDegensContract is RamppERC721A {
1909     constructor() RamppERC721A("We Hate Degens", "WHD"){}
1910 }
1911   