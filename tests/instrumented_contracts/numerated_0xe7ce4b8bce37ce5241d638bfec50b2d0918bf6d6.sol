1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ▄▄▄▄    ▄▄▄       ███▄    █ ▒███████▒ ▄▄▄       ██▓
5 // ▓█████▄ ▒████▄     ██ ▀█   █ ▒ ▒ ▒ ▄▀░▒████▄    ▓██▒
6 // ▒██▒ ▄██▒██  ▀█▄  ▓██  ▀█ ██▒░ ▒ ▄▀▒░ ▒██  ▀█▄  ▒██▒
7 // ▒██░█▀  ░██▄▄▄▄██ ▓██▒  ▐▌██▒  ▄▀▒   ░░██▄▄▄▄██ ░██░
8 // ░▓█  ▀█▓ ▓█   ▓██▒▒██░   ▓██░▒███████▒ ▓█   ▓██▒░██░
9 // ░▒▓███▀▒ ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░▒▒ ▓░▒░▒ ▒▒   ▓▒█░░▓  
10 // ▒░▒   ░   ▒   ▒▒ ░░ ░░   ░ ▒░░░▒ ▒ ░ ▒  ▒   ▒▒ ░ ▒ ░
11 //  ░    ░   ░   ▒      ░   ░ ░ ░ ░ ░ ░ ░  ░   ▒    ▒ ░
12 //  ░            ░  ░         ░   ░ ░          ░  ░ ░  
13 //       ░                      ░                      
14 //
15 //*********************************************************************//
16 //*********************************************************************//
17   
18 //-------------DEPENDENCIES--------------------------//
19 
20 // File: @openzeppelin/contracts/utils/Address.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
24 
25 pragma solidity ^0.8.1;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if account is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, isContract will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      *
48      * [IMPORTANT]
49      * ====
50      * You shouldn't rely on isContract to protect against flash loan attacks!
51      *
52      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
53      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
54      * constructor.
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // This method relies on extcodesize/address.code.length, which returns 0
59         // for contracts in construction, since the code is only stored at the end
60         // of the constructor execution.
61 
62         return account.code.length > 0;
63     }
64 
65     /**
66      * @dev Replacement for Solidity's transfer: sends amount wei to
67      * recipient, forwarding all available gas and reverting on errors.
68      *
69      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
70      * of certain opcodes, possibly making contracts go over the 2300 gas limit
71      * imposed by transfer, making them unable to receive funds via
72      * transfer. {sendValue} removes this limitation.
73      *
74      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
75      *
76      * IMPORTANT: because control is transferred to recipient, care must be
77      * taken to not create reentrancy vulnerabilities. Consider using
78      * {ReentrancyGuard} or the
79      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
80      */
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83 
84         (bool success, ) = recipient.call{value: amount}("");
85         require(success, "Address: unable to send value, recipient may have reverted");
86     }
87 
88     /**
89      * @dev Performs a Solidity function call using a low level call. A
90      * plain call is an unsafe replacement for a function call: use this
91      * function instead.
92      *
93      * If target reverts with a revert reason, it is bubbled up by this
94      * function (like regular Solidity function calls).
95      *
96      * Returns the raw returned data. To convert to the expected return value,
97      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
98      *
99      * Requirements:
100      *
101      * - target must be a contract.
102      * - calling target with data must not revert.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
112      * errorMessage as a fallback revert reason when target reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCall(
117         address target,
118         bytes memory data,
119         string memory errorMessage
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
126      * but also transferring value wei to target.
127      *
128      * Requirements:
129      *
130      * - the calling contract must have an ETH balance of at least value.
131      * - the called Solidity function must be payable.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value
139     ) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
145      * with errorMessage as a fallback revert reason when target reverts.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         require(isContract(target), "Address: call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.call{value: value}(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
169         return functionStaticCall(target, data, "Address: low-level static call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
174      * but performing a static call.
175      *
176      * _Available since v3.3._
177      */
178     function functionStaticCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal view returns (bytes memory) {
183         require(isContract(target), "Address: static call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.staticcall(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(isContract(target), "Address: delegate call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.delegatecall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
218      * revert reason using the provided one.
219      *
220      * _Available since v4.3._
221      */
222     function verifyCallResult(
223         bool success,
224         bytes memory returndata,
225         string memory errorMessage
226     ) internal pure returns (bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             // Look for revert reason and bubble it up if present
231             if (returndata.length > 0) {
232                 // The easiest way to bubble the revert reason is using memory via assembly
233 
234                 assembly {
235                     let returndata_size := mload(returndata)
236                     revert(add(32, returndata), returndata_size)
237                 }
238             } else {
239                 revert(errorMessage);
240             }
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by operator from from, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Interface of the ERC165 standard, as defined in the
284  * https://eips.ethereum.org/EIPS/eip-165[EIP].
285  *
286  * Implementers can declare support of contract interfaces, which can then be
287  * queried by others ({ERC165Checker}).
288  *
289  * For an implementation, see {ERC165}.
290  */
291 interface IERC165 {
292     /**
293      * @dev Returns true if this contract implements the interface defined by
294      * interfaceId. See the corresponding
295      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
296      * to learn more about how these ids are created.
297      *
298      * This function call must use less than 30 000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId) external view returns (bool);
301 }
302 
303 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev Implementation of the {IERC165} interface.
313  *
314  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
315  * for the additional interface id that will be supported. For example:
316  *
317  * solidity
318  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
319  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
320  * }
321  * 
322  *
323  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
324  */
325 abstract contract ERC165 is IERC165 {
326     /**
327      * @dev See {IERC165-supportsInterface}.
328      */
329     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
330         return interfaceId == type(IERC165).interfaceId;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Required interface of an ERC721 compliant contract.
344  */
345 interface IERC721 is IERC165 {
346     /**
347      * @dev Emitted when tokenId token is transferred from from to to.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
350 
351     /**
352      * @dev Emitted when owner enables approved to manage the tokenId token.
353      */
354     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
358      */
359     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
360 
361     /**
362      * @dev Returns the number of tokens in owner's account.
363      */
364     function balanceOf(address owner) external view returns (uint256 balance);
365 
366     /**
367      * @dev Returns the owner of the tokenId token.
368      *
369      * Requirements:
370      *
371      * - tokenId must exist.
372      */
373     function ownerOf(uint256 tokenId) external view returns (address owner);
374 
375     /**
376      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
377      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
378      *
379      * Requirements:
380      *
381      * - from cannot be the zero address.
382      * - to cannot be the zero address.
383      * - tokenId token must exist and be owned by from.
384      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
385      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
386      *
387      * Emits a {Transfer} event.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external;
394 
395     /**
396      * @dev Transfers tokenId token from from to to.
397      *
398      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
399      *
400      * Requirements:
401      *
402      * - from cannot be the zero address.
403      * - to cannot be the zero address.
404      * - tokenId token must be owned by from.
405      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(
410         address from,
411         address to,
412         uint256 tokenId
413     ) external;
414 
415     /**
416      * @dev Gives permission to to to transfer tokenId token to another account.
417      * The approval is cleared when the token is transferred.
418      *
419      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
420      *
421      * Requirements:
422      *
423      * - The caller must own the token or be an approved operator.
424      * - tokenId must exist.
425      *
426      * Emits an {Approval} event.
427      */
428     function approve(address to, uint256 tokenId) external;
429 
430     /**
431      * @dev Returns the account approved for tokenId token.
432      *
433      * Requirements:
434      *
435      * - tokenId must exist.
436      */
437     function getApproved(uint256 tokenId) external view returns (address operator);
438 
439     /**
440      * @dev Approve or remove operator as an operator for the caller.
441      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
442      *
443      * Requirements:
444      *
445      * - The operator cannot be the caller.
446      *
447      * Emits an {ApprovalForAll} event.
448      */
449     function setApprovalForAll(address operator, bool _approved) external;
450 
451     /**
452      * @dev Returns if the operator is allowed to manage all of the assets of owner.
453      *
454      * See {setApprovalForAll}
455      */
456     function isApprovedForAll(address owner, address operator) external view returns (bool);
457 
458     /**
459      * @dev Safely transfers tokenId token from from to to.
460      *
461      * Requirements:
462      *
463      * - from cannot be the zero address.
464      * - to cannot be the zero address.
465      * - tokenId token must exist and be owned by from.
466      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external;
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 
487 /**
488  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
489  * @dev See https://eips.ethereum.org/EIPS/eip-721
490  */
491 interface IERC721Enumerable is IERC721 {
492     /**
493      * @dev Returns the total amount of tokens stored by the contract.
494      */
495     function totalSupply() external view returns (uint256);
496 
497     /**
498      * @dev Returns a token ID owned by owner at a given index of its token list.
499      * Use along with {balanceOf} to enumerate all of owner's tokens.
500      */
501     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
502 
503     /**
504      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
505      * Use along with {totalSupply} to enumerate all tokens.
506      */
507     function tokenByIndex(uint256 index) external view returns (uint256);
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
520  * @dev See https://eips.ethereum.org/EIPS/eip-721
521  */
522 interface IERC721Metadata is IERC721 {
523     /**
524      * @dev Returns the token collection name.
525      */
526     function name() external view returns (string memory);
527 
528     /**
529      * @dev Returns the token collection symbol.
530      */
531     function symbol() external view returns (string memory);
532 
533     /**
534      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
535      */
536     function tokenURI(uint256 tokenId) external view returns (string memory);
537 }
538 
539 // File: @openzeppelin/contracts/utils/Strings.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev String operations.
548  */
549 library Strings {
550     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
551 
552     /**
553      * @dev Converts a uint256 to its ASCII string decimal representation.
554      */
555     function toString(uint256 value) internal pure returns (string memory) {
556         // Inspired by OraclizeAPI's implementation - MIT licence
557         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
558 
559         if (value == 0) {
560             return "0";
561         }
562         uint256 temp = value;
563         uint256 digits;
564         while (temp != 0) {
565             digits++;
566             temp /= 10;
567         }
568         bytes memory buffer = new bytes(digits);
569         while (value != 0) {
570             digits -= 1;
571             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
572             value /= 10;
573         }
574         return string(buffer);
575     }
576 
577     /**
578      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
579      */
580     function toHexString(uint256 value) internal pure returns (string memory) {
581         if (value == 0) {
582             return "0x00";
583         }
584         uint256 temp = value;
585         uint256 length = 0;
586         while (temp != 0) {
587             length++;
588             temp >>= 8;
589         }
590         return toHexString(value, length);
591     }
592 
593     /**
594      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
595      */
596     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
597         bytes memory buffer = new bytes(2 * length + 2);
598         buffer[0] = "0";
599         buffer[1] = "x";
600         for (uint256 i = 2 * length + 1; i > 1; --i) {
601             buffer[i] = _HEX_SYMBOLS[value & 0xf];
602             value >>= 4;
603         }
604         require(value == 0, "Strings: hex length insufficient");
605         return string(buffer);
606     }
607 }
608 
609 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Contract module that helps prevent reentrant calls to a function.
618  *
619  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
620  * available, which can be applied to functions to make sure there are no nested
621  * (reentrant) calls to them.
622  *
623  * Note that because there is a single nonReentrant guard, functions marked as
624  * nonReentrant may not call one another. This can be worked around by making
625  * those functions private, and then adding external nonReentrant entry
626  * points to them.
627  *
628  * TIP: If you would like to learn more about reentrancy and alternative ways
629  * to protect against it, check out our blog post
630  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
631  */
632 abstract contract ReentrancyGuard {
633     // Booleans are more expensive than uint256 or any type that takes up a full
634     // word because each write operation emits an extra SLOAD to first read the
635     // slot's contents, replace the bits taken up by the boolean, and then write
636     // back. This is the compiler's defense against contract upgrades and
637     // pointer aliasing, and it cannot be disabled.
638 
639     // The values being non-zero value makes deployment a bit more expensive,
640     // but in exchange the refund on every call to nonReentrant will be lower in
641     // amount. Since refunds are capped to a percentage of the total
642     // transaction's gas, it is best to keep them low in cases like this one, to
643     // increase the likelihood of the full refund coming into effect.
644     uint256 private constant _NOT_ENTERED = 1;
645     uint256 private constant _ENTERED = 2;
646 
647     uint256 private _status;
648 
649     constructor() {
650         _status = _NOT_ENTERED;
651     }
652 
653     /**
654      * @dev Prevents a contract from calling itself, directly or indirectly.
655      * Calling a nonReentrant function from another nonReentrant
656      * function is not supported. It is possible to prevent this from happening
657      * by making the nonReentrant function external, and making it call a
658      * private function that does the actual work.
659      */
660     modifier nonReentrant() {
661         // On the first call to nonReentrant, _notEntered will be true
662         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
663 
664         // Any calls to nonReentrant after this point will fail
665         _status = _ENTERED;
666 
667         _;
668 
669         // By storing the original value once again, a refund is triggered (see
670         // https://eips.ethereum.org/EIPS/eip-2200)
671         _status = _NOT_ENTERED;
672     }
673 }
674 
675 // File: @openzeppelin/contracts/utils/Context.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Provides information about the current execution context, including the
684  * sender of the transaction and its data. While these are generally available
685  * via msg.sender and msg.data, they should not be accessed in such a direct
686  * manner, since when dealing with meta-transactions the account sending and
687  * paying for execution may not be the actual sender (as far as an application
688  * is concerned).
689  *
690  * This contract is only required for intermediate, library-like contracts.
691  */
692 abstract contract Context {
693     function _msgSender() internal view virtual returns (address) {
694         return msg.sender;
695     }
696 
697     function _msgData() internal view virtual returns (bytes calldata) {
698         return msg.data;
699     }
700 }
701 
702 // File: @openzeppelin/contracts/access/Ownable.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * By default, the owner account will be the one that deploys the contract. This
716  * can later be changed with {transferOwnership}.
717  *
718  * This module is used through inheritance. It will make available the modifier
719  * onlyOwner, which can be applied to your functions to restrict their use to
720  * the owner.
721  */
722 abstract contract Ownable is Context {
723     address private _owner;
724 
725     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
726 
727     /**
728      * @dev Initializes the contract setting the deployer as the initial owner.
729      */
730     constructor() {
731         _transferOwnership(_msgSender());
732     }
733 
734     /**
735      * @dev Returns the address of the current owner.
736      */
737     function owner() public view virtual returns (address) {
738         return _owner;
739     }
740 
741     /**
742      * @dev Throws if called by any account other than the owner.
743      */
744     modifier onlyOwner() {
745         require(owner() == _msgSender(), "Ownable: caller is not the owner");
746         _;
747     }
748 
749     /**
750      * @dev Leaves the contract without owner. It will not be possible to call
751      * onlyOwner functions anymore. Can only be called by the current owner.
752      *
753      * NOTE: Renouncing ownership will leave the contract without an owner,
754      * thereby removing any functionality that is only available to the owner.
755      */
756     function renounceOwnership() public virtual onlyOwner {
757         _transferOwnership(address(0));
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (newOwner).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         _transferOwnership(newOwner);
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (newOwner).
771      * Internal function without access restriction.
772      */
773     function _transferOwnership(address newOwner) internal virtual {
774         address oldOwner = _owner;
775         _owner = newOwner;
776         emit OwnershipTransferred(oldOwner, newOwner);
777     }
778 }
779 //-------------END DEPENDENCIES------------------------//
780 
781 
782   
783 // Rampp Contracts v2.1 (Teams.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
789 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
790 * This will easily allow cross-collaboration via Rampp.xyz.
791 **/
792 abstract contract Teams is Ownable{
793   mapping (address => bool) internal team;
794 
795   /**
796   * @dev Adds an address to the team. Allows them to execute protected functions
797   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
798   **/
799   function addToTeam(address _address) public onlyOwner {
800     require(_address != address(0), "Invalid address");
801     require(!inTeam(_address), "This address is already in your team.");
802   
803     team[_address] = true;
804   }
805 
806   /**
807   * @dev Removes an address to the team.
808   * @param _address the ETH address to remove, cannot be 0x and must be in team
809   **/
810   function removeFromTeam(address _address) public onlyOwner {
811     require(_address != address(0), "Invalid address");
812     require(inTeam(_address), "This address is not in your team currently.");
813   
814     team[_address] = false;
815   }
816 
817   /**
818   * @dev Check if an address is valid and active in the team
819   * @param _address ETH address to check for truthiness
820   **/
821   function inTeam(address _address)
822     public
823     view
824     returns (bool)
825   {
826     require(_address != address(0), "Invalid address to check.");
827     return team[_address] == true;
828   }
829 
830   /**
831   * @dev Throws if called by any account other than the owner or team member.
832   */
833   modifier onlyTeamOrOwner() {
834     bool _isOwner = owner() == _msgSender();
835     bool _isTeam = inTeam(_msgSender());
836     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
837     _;
838   }
839 }
840 
841 
842   
843   pragma solidity ^0.8.0;
844 
845   /**
846   * @dev These functions deal with verification of Merkle Trees proofs.
847   *
848   * The proofs can be generated using the JavaScript library
849   * https://github.com/miguelmota/merkletreejs[merkletreejs].
850   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
851   *
852   *
853   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
854   * hashing, or use a hash function other than keccak256 for hashing leaves.
855   * This is because the concatenation of a sorted pair of internal nodes in
856   * the merkle tree could be reinterpreted as a leaf value.
857   */
858   library MerkleProof {
859       /**
860       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
861       * defined by 'root'. For this, a 'proof' must be provided, containing
862       * sibling hashes on the branch from the leaf to the root of the tree. Each
863       * pair of leaves and each pair of pre-images are assumed to be sorted.
864       */
865       function verify(
866           bytes32[] memory proof,
867           bytes32 root,
868           bytes32 leaf
869       ) internal pure returns (bool) {
870           return processProof(proof, leaf) == root;
871       }
872 
873       /**
874       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
875       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
876       * hash matches the root of the tree. When processing the proof, the pairs
877       * of leafs & pre-images are assumed to be sorted.
878       *
879       * _Available since v4.4._
880       */
881       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
882           bytes32 computedHash = leaf;
883           for (uint256 i = 0; i < proof.length; i++) {
884               bytes32 proofElement = proof[i];
885               if (computedHash <= proofElement) {
886                   // Hash(current computed hash + current element of the proof)
887                   computedHash = _efficientHash(computedHash, proofElement);
888               } else {
889                   // Hash(current element of the proof + current computed hash)
890                   computedHash = _efficientHash(proofElement, computedHash);
891               }
892           }
893           return computedHash;
894       }
895 
896       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
897           assembly {
898               mstore(0x00, a)
899               mstore(0x20, b)
900               value := keccak256(0x00, 0x40)
901           }
902       }
903   }
904 
905 
906   // File: Allowlist.sol
907 
908   pragma solidity ^0.8.0;
909 
910   abstract contract Allowlist is Teams {
911     bytes32 public merkleRoot;
912     bool public onlyAllowlistMode = false;
913 
914     /**
915      * @dev Update merkle root to reflect changes in Allowlist
916      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
917      */
918     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
919       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
920       merkleRoot = _newMerkleRoot;
921     }
922 
923     /**
924      * @dev Check the proof of an address if valid for merkle root
925      * @param _to address to check for proof
926      * @param _merkleProof Proof of the address to validate against root and leaf
927      */
928     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
929       require(merkleRoot != 0, "Merkle root is not set!");
930       bytes32 leaf = keccak256(abi.encodePacked(_to));
931 
932       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
933     }
934 
935     
936     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
937       onlyAllowlistMode = true;
938     }
939 
940     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
941         onlyAllowlistMode = false;
942     }
943   }
944   
945   
946 /**
947  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
948  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
949  *
950  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
951  * 
952  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
953  *
954  * Does not support burning tokens to address(0).
955  */
956 contract ERC721A is
957   Context,
958   ERC165,
959   IERC721,
960   IERC721Metadata,
961   IERC721Enumerable
962 {
963   using Address for address;
964   using Strings for uint256;
965 
966   struct TokenOwnership {
967     address addr;
968     uint64 startTimestamp;
969   }
970 
971   struct AddressData {
972     uint128 balance;
973     uint128 numberMinted;
974   }
975 
976   uint256 private currentIndex;
977 
978   uint256 public immutable collectionSize;
979   uint256 public maxBatchSize;
980 
981   // Token name
982   string private _name;
983 
984   // Token symbol
985   string private _symbol;
986 
987   // Mapping from token ID to ownership details
988   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
989   mapping(uint256 => TokenOwnership) private _ownerships;
990 
991   // Mapping owner address to address data
992   mapping(address => AddressData) private _addressData;
993 
994   // Mapping from token ID to approved address
995   mapping(uint256 => address) private _tokenApprovals;
996 
997   // Mapping from owner to operator approvals
998   mapping(address => mapping(address => bool)) private _operatorApprovals;
999 
1000   /**
1001    * @dev
1002    * maxBatchSize refers to how much a minter can mint at a time.
1003    * collectionSize_ refers to how many tokens are in the collection.
1004    */
1005   constructor(
1006     string memory name_,
1007     string memory symbol_,
1008     uint256 maxBatchSize_,
1009     uint256 collectionSize_
1010   ) {
1011     require(
1012       collectionSize_ > 0,
1013       "ERC721A: collection must have a nonzero supply"
1014     );
1015     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1016     _name = name_;
1017     _symbol = symbol_;
1018     maxBatchSize = maxBatchSize_;
1019     collectionSize = collectionSize_;
1020     currentIndex = _startTokenId();
1021   }
1022 
1023   /**
1024   * To change the starting tokenId, please override this function.
1025   */
1026   function _startTokenId() internal view virtual returns (uint256) {
1027     return 1;
1028   }
1029 
1030   /**
1031    * @dev See {IERC721Enumerable-totalSupply}.
1032    */
1033   function totalSupply() public view override returns (uint256) {
1034     return _totalMinted();
1035   }
1036 
1037   function currentTokenId() public view returns (uint256) {
1038     return _totalMinted();
1039   }
1040 
1041   function getNextTokenId() public view returns (uint256) {
1042       return _totalMinted() + 1;
1043   }
1044 
1045   /**
1046   * Returns the total amount of tokens minted in the contract.
1047   */
1048   function _totalMinted() internal view returns (uint256) {
1049     unchecked {
1050       return currentIndex - _startTokenId();
1051     }
1052   }
1053 
1054   /**
1055    * @dev See {IERC721Enumerable-tokenByIndex}.
1056    */
1057   function tokenByIndex(uint256 index) public view override returns (uint256) {
1058     require(index < totalSupply(), "ERC721A: global index out of bounds");
1059     return index;
1060   }
1061 
1062   /**
1063    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1064    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1065    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1066    */
1067   function tokenOfOwnerByIndex(address owner, uint256 index)
1068     public
1069     view
1070     override
1071     returns (uint256)
1072   {
1073     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1074     uint256 numMintedSoFar = totalSupply();
1075     uint256 tokenIdsIdx = 0;
1076     address currOwnershipAddr = address(0);
1077     for (uint256 i = 0; i < numMintedSoFar; i++) {
1078       TokenOwnership memory ownership = _ownerships[i];
1079       if (ownership.addr != address(0)) {
1080         currOwnershipAddr = ownership.addr;
1081       }
1082       if (currOwnershipAddr == owner) {
1083         if (tokenIdsIdx == index) {
1084           return i;
1085         }
1086         tokenIdsIdx++;
1087       }
1088     }
1089     revert("ERC721A: unable to get token of owner by index");
1090   }
1091 
1092   /**
1093    * @dev See {IERC165-supportsInterface}.
1094    */
1095   function supportsInterface(bytes4 interfaceId)
1096     public
1097     view
1098     virtual
1099     override(ERC165, IERC165)
1100     returns (bool)
1101   {
1102     return
1103       interfaceId == type(IERC721).interfaceId ||
1104       interfaceId == type(IERC721Metadata).interfaceId ||
1105       interfaceId == type(IERC721Enumerable).interfaceId ||
1106       super.supportsInterface(interfaceId);
1107   }
1108 
1109   /**
1110    * @dev See {IERC721-balanceOf}.
1111    */
1112   function balanceOf(address owner) public view override returns (uint256) {
1113     require(owner != address(0), "ERC721A: balance query for the zero address");
1114     return uint256(_addressData[owner].balance);
1115   }
1116 
1117   function _numberMinted(address owner) internal view returns (uint256) {
1118     require(
1119       owner != address(0),
1120       "ERC721A: number minted query for the zero address"
1121     );
1122     return uint256(_addressData[owner].numberMinted);
1123   }
1124 
1125   function ownershipOf(uint256 tokenId)
1126     internal
1127     view
1128     returns (TokenOwnership memory)
1129   {
1130     uint256 curr = tokenId;
1131 
1132     unchecked {
1133         if (_startTokenId() <= curr && curr < currentIndex) {
1134             TokenOwnership memory ownership = _ownerships[curr];
1135             if (ownership.addr != address(0)) {
1136                 return ownership;
1137             }
1138 
1139             // Invariant:
1140             // There will always be an ownership that has an address and is not burned
1141             // before an ownership that does not have an address and is not burned.
1142             // Hence, curr will not underflow.
1143             while (true) {
1144                 curr--;
1145                 ownership = _ownerships[curr];
1146                 if (ownership.addr != address(0)) {
1147                     return ownership;
1148                 }
1149             }
1150         }
1151     }
1152 
1153     revert("ERC721A: unable to determine the owner of token");
1154   }
1155 
1156   /**
1157    * @dev See {IERC721-ownerOf}.
1158    */
1159   function ownerOf(uint256 tokenId) public view override returns (address) {
1160     return ownershipOf(tokenId).addr;
1161   }
1162 
1163   /**
1164    * @dev See {IERC721Metadata-name}.
1165    */
1166   function name() public view virtual override returns (string memory) {
1167     return _name;
1168   }
1169 
1170   /**
1171    * @dev See {IERC721Metadata-symbol}.
1172    */
1173   function symbol() public view virtual override returns (string memory) {
1174     return _symbol;
1175   }
1176 
1177   /**
1178    * @dev See {IERC721Metadata-tokenURI}.
1179    */
1180   function tokenURI(uint256 tokenId)
1181     public
1182     view
1183     virtual
1184     override
1185     returns (string memory)
1186   {
1187     string memory baseURI = _baseURI();
1188     return
1189       bytes(baseURI).length > 0
1190         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1191         : "";
1192   }
1193 
1194   /**
1195    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1196    * token will be the concatenation of the baseURI and the tokenId. Empty
1197    * by default, can be overriden in child contracts.
1198    */
1199   function _baseURI() internal view virtual returns (string memory) {
1200     return "";
1201   }
1202 
1203   /**
1204    * @dev See {IERC721-approve}.
1205    */
1206   function approve(address to, uint256 tokenId) public override {
1207     address owner = ERC721A.ownerOf(tokenId);
1208     require(to != owner, "ERC721A: approval to current owner");
1209 
1210     require(
1211       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1212       "ERC721A: approve caller is not owner nor approved for all"
1213     );
1214 
1215     _approve(to, tokenId, owner);
1216   }
1217 
1218   /**
1219    * @dev See {IERC721-getApproved}.
1220    */
1221   function getApproved(uint256 tokenId) public view override returns (address) {
1222     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1223 
1224     return _tokenApprovals[tokenId];
1225   }
1226 
1227   /**
1228    * @dev See {IERC721-setApprovalForAll}.
1229    */
1230   function setApprovalForAll(address operator, bool approved) public override {
1231     require(operator != _msgSender(), "ERC721A: approve to caller");
1232 
1233     _operatorApprovals[_msgSender()][operator] = approved;
1234     emit ApprovalForAll(_msgSender(), operator, approved);
1235   }
1236 
1237   /**
1238    * @dev See {IERC721-isApprovedForAll}.
1239    */
1240   function isApprovedForAll(address owner, address operator)
1241     public
1242     view
1243     virtual
1244     override
1245     returns (bool)
1246   {
1247     return _operatorApprovals[owner][operator];
1248   }
1249 
1250   /**
1251    * @dev See {IERC721-transferFrom}.
1252    */
1253   function transferFrom(
1254     address from,
1255     address to,
1256     uint256 tokenId
1257   ) public override {
1258     _transfer(from, to, tokenId);
1259   }
1260 
1261   /**
1262    * @dev See {IERC721-safeTransferFrom}.
1263    */
1264   function safeTransferFrom(
1265     address from,
1266     address to,
1267     uint256 tokenId
1268   ) public override {
1269     safeTransferFrom(from, to, tokenId, "");
1270   }
1271 
1272   /**
1273    * @dev See {IERC721-safeTransferFrom}.
1274    */
1275   function safeTransferFrom(
1276     address from,
1277     address to,
1278     uint256 tokenId,
1279     bytes memory _data
1280   ) public override {
1281     _transfer(from, to, tokenId);
1282     require(
1283       _checkOnERC721Received(from, to, tokenId, _data),
1284       "ERC721A: transfer to non ERC721Receiver implementer"
1285     );
1286   }
1287 
1288   /**
1289    * @dev Returns whether tokenId exists.
1290    *
1291    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1292    *
1293    * Tokens start existing when they are minted (_mint),
1294    */
1295   function _exists(uint256 tokenId) internal view returns (bool) {
1296     return _startTokenId() <= tokenId && tokenId < currentIndex;
1297   }
1298 
1299   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1300     _safeMint(to, quantity, isAdminMint, "");
1301   }
1302 
1303   /**
1304    * @dev Mints quantity tokens and transfers them to to.
1305    *
1306    * Requirements:
1307    *
1308    * - there must be quantity tokens remaining unminted in the total collection.
1309    * - to cannot be the zero address.
1310    * - quantity cannot be larger than the max batch size.
1311    *
1312    * Emits a {Transfer} event.
1313    */
1314   function _safeMint(
1315     address to,
1316     uint256 quantity,
1317     bool isAdminMint,
1318     bytes memory _data
1319   ) internal {
1320     uint256 startTokenId = currentIndex;
1321     require(to != address(0), "ERC721A: mint to the zero address");
1322     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1323     require(!_exists(startTokenId), "ERC721A: token already minted");
1324 
1325     // For admin mints we do not want to enforce the maxBatchSize limit
1326     if (isAdminMint == false) {
1327         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1328     }
1329 
1330     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1331 
1332     AddressData memory addressData = _addressData[to];
1333     _addressData[to] = AddressData(
1334       addressData.balance + uint128(quantity),
1335       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1336     );
1337     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1338 
1339     uint256 updatedIndex = startTokenId;
1340 
1341     for (uint256 i = 0; i < quantity; i++) {
1342       emit Transfer(address(0), to, updatedIndex);
1343       require(
1344         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1345         "ERC721A: transfer to non ERC721Receiver implementer"
1346       );
1347       updatedIndex++;
1348     }
1349 
1350     currentIndex = updatedIndex;
1351     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1352   }
1353 
1354   /**
1355    * @dev Transfers tokenId from from to to.
1356    *
1357    * Requirements:
1358    *
1359    * - to cannot be the zero address.
1360    * - tokenId token must be owned by from.
1361    *
1362    * Emits a {Transfer} event.
1363    */
1364   function _transfer(
1365     address from,
1366     address to,
1367     uint256 tokenId
1368   ) private {
1369     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1370 
1371     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1372       getApproved(tokenId) == _msgSender() ||
1373       isApprovedForAll(prevOwnership.addr, _msgSender()));
1374 
1375     require(
1376       isApprovedOrOwner,
1377       "ERC721A: transfer caller is not owner nor approved"
1378     );
1379 
1380     require(
1381       prevOwnership.addr == from,
1382       "ERC721A: transfer from incorrect owner"
1383     );
1384     require(to != address(0), "ERC721A: transfer to the zero address");
1385 
1386     _beforeTokenTransfers(from, to, tokenId, 1);
1387 
1388     // Clear approvals from the previous owner
1389     _approve(address(0), tokenId, prevOwnership.addr);
1390 
1391     _addressData[from].balance -= 1;
1392     _addressData[to].balance += 1;
1393     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1394 
1395     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1396     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1397     uint256 nextTokenId = tokenId + 1;
1398     if (_ownerships[nextTokenId].addr == address(0)) {
1399       if (_exists(nextTokenId)) {
1400         _ownerships[nextTokenId] = TokenOwnership(
1401           prevOwnership.addr,
1402           prevOwnership.startTimestamp
1403         );
1404       }
1405     }
1406 
1407     emit Transfer(from, to, tokenId);
1408     _afterTokenTransfers(from, to, tokenId, 1);
1409   }
1410 
1411   /**
1412    * @dev Approve to to operate on tokenId
1413    *
1414    * Emits a {Approval} event.
1415    */
1416   function _approve(
1417     address to,
1418     uint256 tokenId,
1419     address owner
1420   ) private {
1421     _tokenApprovals[tokenId] = to;
1422     emit Approval(owner, to, tokenId);
1423   }
1424 
1425   uint256 public nextOwnerToExplicitlySet = 0;
1426 
1427   /**
1428    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1429    */
1430   function _setOwnersExplicit(uint256 quantity) internal {
1431     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1432     require(quantity > 0, "quantity must be nonzero");
1433     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1434 
1435     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1436     if (endIndex > collectionSize - 1) {
1437       endIndex = collectionSize - 1;
1438     }
1439     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1440     require(_exists(endIndex), "not enough minted yet for this cleanup");
1441     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1442       if (_ownerships[i].addr == address(0)) {
1443         TokenOwnership memory ownership = ownershipOf(i);
1444         _ownerships[i] = TokenOwnership(
1445           ownership.addr,
1446           ownership.startTimestamp
1447         );
1448       }
1449     }
1450     nextOwnerToExplicitlySet = endIndex + 1;
1451   }
1452 
1453   /**
1454    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1455    * The call is not executed if the target address is not a contract.
1456    *
1457    * @param from address representing the previous owner of the given token ID
1458    * @param to target address that will receive the tokens
1459    * @param tokenId uint256 ID of the token to be transferred
1460    * @param _data bytes optional data to send along with the call
1461    * @return bool whether the call correctly returned the expected magic value
1462    */
1463   function _checkOnERC721Received(
1464     address from,
1465     address to,
1466     uint256 tokenId,
1467     bytes memory _data
1468   ) private returns (bool) {
1469     if (to.isContract()) {
1470       try
1471         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1472       returns (bytes4 retval) {
1473         return retval == IERC721Receiver(to).onERC721Received.selector;
1474       } catch (bytes memory reason) {
1475         if (reason.length == 0) {
1476           revert("ERC721A: transfer to non ERC721Receiver implementer");
1477         } else {
1478           assembly {
1479             revert(add(32, reason), mload(reason))
1480           }
1481         }
1482       }
1483     } else {
1484       return true;
1485     }
1486   }
1487 
1488   /**
1489    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1490    *
1491    * startTokenId - the first token id to be transferred
1492    * quantity - the amount to be transferred
1493    *
1494    * Calling conditions:
1495    *
1496    * - When from and to are both non-zero, from's tokenId will be
1497    * transferred to to.
1498    * - When from is zero, tokenId will be minted for to.
1499    */
1500   function _beforeTokenTransfers(
1501     address from,
1502     address to,
1503     uint256 startTokenId,
1504     uint256 quantity
1505   ) internal virtual {}
1506 
1507   /**
1508    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1509    * minting.
1510    *
1511    * startTokenId - the first token id to be transferred
1512    * quantity - the amount to be transferred
1513    *
1514    * Calling conditions:
1515    *
1516    * - when from and to are both non-zero.
1517    * - from and to are never both zero.
1518    */
1519   function _afterTokenTransfers(
1520     address from,
1521     address to,
1522     uint256 startTokenId,
1523     uint256 quantity
1524   ) internal virtual {}
1525 }
1526 
1527 
1528 
1529   
1530 abstract contract Ramppable {
1531   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1532 
1533   modifier isRampp() {
1534       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1535       _;
1536   }
1537 }
1538 
1539 
1540   
1541   
1542 interface IERC20 {
1543   function allowance(address owner, address spender) external view returns (uint256);
1544   function transfer(address _to, uint256 _amount) external returns (bool);
1545   function balanceOf(address account) external view returns (uint256);
1546   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1547 }
1548 
1549 // File: WithdrawableV2
1550 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1551 // ERC-20 Payouts are limited to a single payout address. This feature 
1552 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1553 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1554 abstract contract WithdrawableV2 is Teams, Ramppable {
1555   struct acceptedERC20 {
1556     bool isActive;
1557     uint256 chargeAmount;
1558   }
1559 
1560   mapping(address => acceptedERC20) private allowedTokenContracts;
1561   address[] public payableAddresses = [RAMPPADDRESS,0x28Ac82dF573997b684ced24388cCa17B46247712];
1562   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1563   address public erc20Payable = 0x28Ac82dF573997b684ced24388cCa17B46247712;
1564   uint256[] public payableFees = [5,95];
1565   uint256[] public surchargePayableFees = [100];
1566   uint256 public payableAddressCount = 2;
1567   uint256 public surchargePayableAddressCount = 1;
1568   uint256 public ramppSurchargeBalance = 0 ether;
1569   uint256 public ramppSurchargeFee = 0.001 ether;
1570   bool public onlyERC20MintingMode = false;
1571 
1572   /**
1573   * @dev Calculates the true payable balance of the contract as the
1574   * value on contract may be from ERC-20 mint surcharges and not 
1575   * public mint charges - which are not eligable for rev share & user withdrawl
1576   */
1577   function calcAvailableBalance() public view returns(uint256) {
1578     return address(this).balance - ramppSurchargeBalance;
1579   }
1580 
1581   function withdrawAll() public onlyTeamOrOwner {
1582       require(calcAvailableBalance() > 0);
1583       _withdrawAll();
1584   }
1585   
1586   function withdrawAllRampp() public isRampp {
1587       require(calcAvailableBalance() > 0);
1588       _withdrawAll();
1589   }
1590 
1591   function _withdrawAll() private {
1592       uint256 balance = calcAvailableBalance();
1593       
1594       for(uint i=0; i < payableAddressCount; i++ ) {
1595           _widthdraw(
1596               payableAddresses[i],
1597               (balance * payableFees[i]) / 100
1598           );
1599       }
1600   }
1601   
1602   function _widthdraw(address _address, uint256 _amount) private {
1603       (bool success, ) = _address.call{value: _amount}("");
1604       require(success, "Transfer failed.");
1605   }
1606 
1607   /**
1608   * @dev This function is similiar to the regular withdraw but operates only on the
1609   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1610   **/
1611   function _withdrawAllSurcharges() private {
1612     uint256 balance = ramppSurchargeBalance;
1613     if(balance == 0) { return; }
1614     
1615     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1616         _widthdraw(
1617             surchargePayableAddresses[i],
1618             (balance * surchargePayableFees[i]) / 100
1619         );
1620     }
1621     ramppSurchargeBalance = 0 ether;
1622   }
1623 
1624   /**
1625   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1626   * in the event ERC-20 tokens are paid to the contract for mints. This will
1627   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1628   * @param _tokenContract contract of ERC-20 token to withdraw
1629   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1630   */
1631   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1632     require(_amountToWithdraw > 0);
1633     IERC20 tokenContract = IERC20(_tokenContract);
1634     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1635     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1636     _withdrawAllSurcharges();
1637   }
1638 
1639   /**
1640   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1641   */
1642   function withdrawRamppSurcharges() public isRampp {
1643     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1644     _withdrawAllSurcharges();
1645   }
1646 
1647    /**
1648   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1649   */
1650   function addSurcharge() internal {
1651     ramppSurchargeBalance += ramppSurchargeFee;
1652   }
1653   
1654   /**
1655   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1656   */
1657   function hasSurcharge() internal returns(bool) {
1658     return msg.value == ramppSurchargeFee;
1659   }
1660 
1661   /**
1662   * @dev Set surcharge fee for using ERC-20 payments on contract
1663   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1664   */
1665   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1666     ramppSurchargeFee = _newSurcharge;
1667   }
1668 
1669   /**
1670   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1671   * @param _erc20TokenContract address of ERC-20 contract in question
1672   */
1673   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1674     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1675   }
1676 
1677   /**
1678   * @dev get the value of tokens to transfer for user of an ERC-20
1679   * @param _erc20TokenContract address of ERC-20 contract in question
1680   */
1681   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1682     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1683     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1684   }
1685 
1686   /**
1687   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1688   * @param _erc20TokenContract address of ERC-20 contract in question
1689   * @param _isActive default status of if contract should be allowed to accept payments
1690   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1691   */
1692   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1693     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1694     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1695   }
1696 
1697   /**
1698   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1699   * it will assume the default value of zero. This should not be used to create new payment tokens.
1700   * @param _erc20TokenContract address of ERC-20 contract in question
1701   */
1702   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1703     allowedTokenContracts[_erc20TokenContract].isActive = true;
1704   }
1705 
1706   /**
1707   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1708   * it will assume the default value of zero. This should not be used to create new payment tokens.
1709   * @param _erc20TokenContract address of ERC-20 contract in question
1710   */
1711   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1712     allowedTokenContracts[_erc20TokenContract].isActive = false;
1713   }
1714 
1715   /**
1716   * @dev Enable only ERC-20 payments for minting on this contract
1717   */
1718   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1719     onlyERC20MintingMode = true;
1720   }
1721 
1722   /**
1723   * @dev Disable only ERC-20 payments for minting on this contract
1724   */
1725   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1726     onlyERC20MintingMode = false;
1727   }
1728 
1729   /**
1730   * @dev Set the payout of the ERC-20 token payout to a specific address
1731   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1732   */
1733   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1734     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1735     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1736     erc20Payable = _newErc20Payable;
1737   }
1738 
1739   /**
1740   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1741   */
1742   function resetRamppSurchargeBalance() public isRampp {
1743     ramppSurchargeBalance = 0 ether;
1744   }
1745 
1746   /**
1747   * @dev Allows Rampp wallet to update its own reference as well as update
1748   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1749   * and since Rampp is always the first address this function is limited to the rampp payout only.
1750   * @param _newAddress updated Rampp Address
1751   */
1752   function setRamppAddress(address _newAddress) public isRampp {
1753     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1754     RAMPPADDRESS = _newAddress;
1755     payableAddresses[0] = _newAddress;
1756   }
1757 }
1758 
1759 
1760   
1761 // File: isFeeable.sol
1762 abstract contract Feeable is Teams {
1763   uint256 public PRICE = 0 ether;
1764 
1765   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1766     PRICE = _feeInWei;
1767   }
1768 
1769   function getPrice(uint256 _count) public view returns (uint256) {
1770     return PRICE * _count;
1771   }
1772 }
1773 
1774   
1775   
1776   
1777 abstract contract RamppERC721A is 
1778     Ownable,
1779     Teams,
1780     ERC721A,
1781     WithdrawableV2,
1782     ReentrancyGuard 
1783     , Feeable 
1784     , Allowlist 
1785     
1786 {
1787   constructor(
1788     string memory tokenName,
1789     string memory tokenSymbol
1790   ) ERC721A(tokenName, tokenSymbol, 1, 999) { }
1791     uint8 public CONTRACT_VERSION = 2;
1792     string public _baseTokenURI = "ipfs://QmXybAo8PXy3gHZH76w2F9xLH4FjHwWqByjjMtoZMNQm18/";
1793 
1794     bool public mintingOpen = false;
1795     bool public isRevealed = false;
1796     
1797     uint256 public MAX_WALLET_MINTS = 1;
1798 
1799   
1800     /////////////// Admin Mint Functions
1801     /**
1802      * @dev Mints a token to an address with a tokenURI.
1803      * This is owner only and allows a fee-free drop
1804      * @param _to address of the future owner of the token
1805      * @param _qty amount of tokens to drop the owner
1806      */
1807      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1808          require(_qty > 0, "Must mint at least 1 token.");
1809          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 999");
1810          _safeMint(_to, _qty, true);
1811      }
1812 
1813   
1814     /////////////// GENERIC MINT FUNCTIONS
1815     /**
1816     * @dev Mints a single token to an address.
1817     * fee may or may not be required*
1818     * @param _to address of the future owner of the token
1819     */
1820     function mintTo(address _to) public payable {
1821         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1822         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1823         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1824         
1825         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1826         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1827         
1828         _safeMint(_to, 1, false);
1829     }
1830 
1831     /**
1832     * @dev Mints tokens to an address in batch.
1833     * fee may or may not be required*
1834     * @param _to address of the future owner of the token
1835     * @param _amount number of tokens to mint
1836     */
1837     function mintToMultiple(address _to, uint256 _amount) public payable {
1838         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1839         require(_amount >= 1, "Must mint at least 1 token");
1840         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1841         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1842         
1843         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1844         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1845         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1846 
1847         _safeMint(_to, _amount, false);
1848     }
1849 
1850     /**
1851      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1852      * fee may or may not be required*
1853      * @param _to address of the future owner of the token
1854      * @param _amount number of tokens to mint
1855      * @param _erc20TokenContract erc-20 token contract to mint with
1856      */
1857     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1858       require(_amount >= 1, "Must mint at least 1 token");
1859       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1860       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1861       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1862       
1863       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1864 
1865       // ERC-20 Specific pre-flight checks
1866       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1867       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1868       IERC20 payableToken = IERC20(_erc20TokenContract);
1869 
1870       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1871       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1872       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1873       
1874       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1875       require(transferComplete, "ERC-20 token was unable to be transferred");
1876       
1877       _safeMint(_to, _amount, false);
1878       addSurcharge();
1879     }
1880 
1881     function openMinting() public onlyTeamOrOwner {
1882         mintingOpen = true;
1883     }
1884 
1885     function stopMinting() public onlyTeamOrOwner {
1886         mintingOpen = false;
1887     }
1888 
1889   
1890     ///////////// ALLOWLIST MINTING FUNCTIONS
1891 
1892     /**
1893     * @dev Mints tokens to an address using an allowlist.
1894     * fee may or may not be required*
1895     * @param _to address of the future owner of the token
1896     * @param _merkleProof merkle proof array
1897     */
1898     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1899         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1900         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1901         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1902         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1903         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1904         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1905         
1906 
1907         _safeMint(_to, 1, false);
1908     }
1909 
1910     /**
1911     * @dev Mints tokens to an address using an allowlist.
1912     * fee may or may not be required*
1913     * @param _to address of the future owner of the token
1914     * @param _amount number of tokens to mint
1915     * @param _merkleProof merkle proof array
1916     */
1917     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1918         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1919         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1920         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1921         require(_amount >= 1, "Must mint at least 1 token");
1922         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1923 
1924         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1925         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1926         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1927         
1928 
1929         _safeMint(_to, _amount, false);
1930     }
1931 
1932     /**
1933     * @dev Mints tokens to an address using an allowlist.
1934     * fee may or may not be required*
1935     * @param _to address of the future owner of the token
1936     * @param _amount number of tokens to mint
1937     * @param _merkleProof merkle proof array
1938     * @param _erc20TokenContract erc-20 token contract to mint with
1939     */
1940     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1941       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1942       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1943       require(_amount >= 1, "Must mint at least 1 token");
1944       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1945       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1946       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1947       
1948     
1949       // ERC-20 Specific pre-flight checks
1950       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1951       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1952       IERC20 payableToken = IERC20(_erc20TokenContract);
1953     
1954       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1955       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1956       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1957       
1958       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1959       require(transferComplete, "ERC-20 token was unable to be transferred");
1960       
1961       _safeMint(_to, _amount, false);
1962       addSurcharge();
1963     }
1964 
1965     /**
1966      * @dev Enable allowlist minting fully by enabling both flags
1967      * This is a convenience function for the Rampp user
1968      */
1969     function openAllowlistMint() public onlyTeamOrOwner {
1970         enableAllowlistOnlyMode();
1971         mintingOpen = true;
1972     }
1973 
1974     /**
1975      * @dev Close allowlist minting fully by disabling both flags
1976      * This is a convenience function for the Rampp user
1977      */
1978     function closeAllowlistMint() public onlyTeamOrOwner {
1979         disableAllowlistOnlyMode();
1980         mintingOpen = false;
1981     }
1982 
1983 
1984   
1985     /**
1986     * @dev Check if wallet over MAX_WALLET_MINTS
1987     * @param _address address in question to check if minted count exceeds max
1988     */
1989     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1990         require(_amount >= 1, "Amount must be greater than or equal to 1");
1991         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1992     }
1993 
1994     /**
1995     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1996     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1997     */
1998     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1999         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2000         MAX_WALLET_MINTS = _newWalletMax;
2001     }
2002     
2003 
2004   
2005     /**
2006      * @dev Allows owner to set Max mints per tx
2007      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2008      */
2009      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2010          require(_newMaxMint >= 1, "Max mint must be at least 1");
2011          maxBatchSize = _newMaxMint;
2012      }
2013     
2014 
2015   
2016     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2017         require(isRevealed == false, "Tokens are already unveiled");
2018         _baseTokenURI = _updatedTokenURI;
2019         isRevealed = true;
2020     }
2021     
2022 
2023   function _baseURI() internal view virtual override returns(string memory) {
2024     return _baseTokenURI;
2025   }
2026 
2027   function baseTokenURI() public view returns(string memory) {
2028     return _baseTokenURI;
2029   }
2030 
2031   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2032     _baseTokenURI = baseURI;
2033   }
2034 
2035   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2036     return ownershipOf(tokenId);
2037   }
2038 }
2039 
2040 
2041   
2042 // File: contracts/BanzaiContract.sol
2043 //SPDX-License-Identifier: MIT
2044 
2045 pragma solidity ^0.8.0;
2046 
2047 contract BanzaiContract is RamppERC721A {
2048     constructor() RamppERC721A("BANZAI", "BANZAI"){}
2049 }
2050   
2051 //*********************************************************************//
2052 //*********************************************************************//  
2053 //                       Rampp v2.1.0
2054 //
2055 //         This smart contract was generated by rampp.xyz.
2056 //            Rampp allows creators like you to launch 
2057 //             large scale NFT communities without code!
2058 //
2059 //    Rampp is not responsible for the content of this contract and
2060 //        hopes it is being used in a responsible and kind way.  
2061 //       Rampp is not associated or affiliated with this project.                                                    
2062 //             Twitter: @Rampp_ ---- rampp.xyz
2063 //*********************************************************************//                                                     
2064 //*********************************************************************// 
