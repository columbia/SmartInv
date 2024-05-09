1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ██▓███   ▄▄▄       ██▀███   ▄▄▄      ▓█████▄  ▒█████  ▒██   ██▒
5 // ▓██░  ██▒▒████▄    ▓██ ▒ ██▒▒████▄    ▒██▀ ██▌▒██▒  ██▒▒▒ █ █ ▒░
6 // ▓██░ ██▓▒▒██  ▀█▄  ▓██ ░▄█ ▒▒██  ▀█▄  ░██   █▌▒██░  ██▒░░  █   ░
7 // ▒██▄█▓▒ ▒░██▄▄▄▄██ ▒██▀▀█▄  ░██▄▄▄▄██ ░▓█▄   ▌▒██   ██░ ░ █ █ ▒ 
8 // ▒██▒ ░  ░ ▓█   ▓██▒░██▓ ▒██▒ ▓█   ▓██▒░▒████▓ ░ ████▓▒░▒██▒ ▒██▒
9 // ▒▓▒░ ░  ░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░ ▒▒   ▓▒█░ ▒▒▓  ▒ ░ ▒░▒░▒░ ▒▒ ░ ░▓ ░
10 // ░▒ ░       ▒   ▒▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░ ░ ▒  ▒   ░ ▒ ▒░ ░░   ░▒ ░
11 // ░░         ░   ▒     ░░   ░   ░   ▒    ░ ░  ░ ░ ░ ░ ▒   ░    ░  
12 //                ░  ░   ░           ░  ░   ░        ░ ░   ░    ░  
13 //                                        ░                        
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
744     function _onlyOwner() private view {
745        require(owner() == _msgSender(), "Ownable: caller is not the owner");
746     }
747 
748     modifier onlyOwner() {
749         _onlyOwner();
750         _;
751     }
752 
753     /**
754      * @dev Leaves the contract without owner. It will not be possible to call
755      * onlyOwner functions anymore. Can only be called by the current owner.
756      *
757      * NOTE: Renouncing ownership will leave the contract without an owner,
758      * thereby removing any functionality that is only available to the owner.
759      */
760     function renounceOwnership() public virtual onlyOwner {
761         _transferOwnership(address(0));
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (newOwner).
766      * Can only be called by the current owner.
767      */
768     function transferOwnership(address newOwner) public virtual onlyOwner {
769         require(newOwner != address(0), "Ownable: new owner is the zero address");
770         _transferOwnership(newOwner);
771     }
772 
773     /**
774      * @dev Transfers ownership of the contract to a new account (newOwner).
775      * Internal function without access restriction.
776      */
777     function _transferOwnership(address newOwner) internal virtual {
778         address oldOwner = _owner;
779         _owner = newOwner;
780         emit OwnershipTransferred(oldOwner, newOwner);
781     }
782 }
783 
784 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
785 pragma solidity ^0.8.9;
786 
787 interface IOperatorFilterRegistry {
788     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
789     function register(address registrant) external;
790     function registerAndSubscribe(address registrant, address subscription) external;
791     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
792     function updateOperator(address registrant, address operator, bool filtered) external;
793     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
794     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
795     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
796     function subscribe(address registrant, address registrantToSubscribe) external;
797     function unsubscribe(address registrant, bool copyExistingEntries) external;
798     function subscriptionOf(address addr) external returns (address registrant);
799     function subscribers(address registrant) external returns (address[] memory);
800     function subscriberAt(address registrant, uint256 index) external returns (address);
801     function copyEntriesOf(address registrant, address registrantToCopy) external;
802     function isOperatorFiltered(address registrant, address operator) external returns (bool);
803     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
804     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
805     function filteredOperators(address addr) external returns (address[] memory);
806     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
807     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
808     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
809     function isRegistered(address addr) external returns (bool);
810     function codeHashOf(address addr) external returns (bytes32);
811 }
812 
813 // File contracts/OperatorFilter/OperatorFilterer.sol
814 pragma solidity ^0.8.9;
815 
816 abstract contract OperatorFilterer {
817     error OperatorNotAllowed(address operator);
818 
819     IOperatorFilterRegistry constant operatorFilterRegistry =
820         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
821 
822     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
823         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
824         // will not revert, but the contract will need to be registered with the registry once it is deployed in
825         // order for the modifier to filter addresses.
826         if (address(operatorFilterRegistry).code.length > 0) {
827             if (subscribe) {
828                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
829             } else {
830                 if (subscriptionOrRegistrantToCopy != address(0)) {
831                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
832                 } else {
833                     operatorFilterRegistry.register(address(this));
834                 }
835             }
836         }
837     }
838 
839     function _onlyAllowedOperator(address from) private view {
840       if (
841           !(
842               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
843               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
844           )
845       ) {
846           revert OperatorNotAllowed(msg.sender);
847       }
848     }
849 
850     modifier onlyAllowedOperator(address from) virtual {
851         // Check registry code length to facilitate testing in environments without a deployed registry.
852         if (address(operatorFilterRegistry).code.length > 0) {
853             // Allow spending tokens from addresses with balance
854             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
855             // from an EOA.
856             if (from == msg.sender) {
857                 _;
858                 return;
859             }
860             _onlyAllowedOperator(from);
861         }
862         _;
863     }
864 
865     modifier onlyAllowedOperatorApproval(address operator) virtual {
866         _checkFilterOperator(operator);
867         _;
868     }
869 
870     function _checkFilterOperator(address operator) internal view virtual {
871         // Check registry code length to facilitate testing in environments without a deployed registry.
872         if (address(operatorFilterRegistry).code.length > 0) {
873             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
874                 revert OperatorNotAllowed(operator);
875             }
876         }
877     }
878 }
879 
880 //-------------END DEPENDENCIES------------------------//
881 
882 
883   
884 error TransactionCapExceeded();
885 error PublicMintingClosed();
886 error ExcessiveOwnedMints();
887 error MintZeroQuantity();
888 error InvalidPayment();
889 error CapExceeded();
890 error IsAlreadyUnveiled();
891 error ValueCannotBeZero();
892 error CannotBeNullAddress();
893 error NoStateChange();
894 
895 error PublicMintClosed();
896 error AllowlistMintClosed();
897 
898 error AddressNotAllowlisted();
899 error AllowlistDropTimeHasNotPassed();
900 error PublicDropTimeHasNotPassed();
901 error DropTimeNotInFuture();
902 
903 error OnlyERC20MintingEnabled();
904 error ERC20TokenNotApproved();
905 error ERC20InsufficientBalance();
906 error ERC20InsufficientAllowance();
907 error ERC20TransferFailed();
908 
909 error ClaimModeDisabled();
910 error IneligibleRedemptionContract();
911 error TokenAlreadyRedeemed();
912 error InvalidOwnerForRedemption();
913 error InvalidApprovalForRedemption();
914 
915 error ERC721RestrictedApprovalAddressRestricted();
916   
917   
918 // Rampp Contracts v2.1 (Teams.sol)
919 
920 error InvalidTeamAddress();
921 error DuplicateTeamAddress();
922 pragma solidity ^0.8.0;
923 
924 /**
925 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
926 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
927 * This will easily allow cross-collaboration via Mintplex.xyz.
928 **/
929 abstract contract Teams is Ownable{
930   mapping (address => bool) internal team;
931 
932   /**
933   * @dev Adds an address to the team. Allows them to execute protected functions
934   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
935   **/
936   function addToTeam(address _address) public onlyOwner {
937     if(_address == address(0)) revert InvalidTeamAddress();
938     if(inTeam(_address)) revert DuplicateTeamAddress();
939   
940     team[_address] = true;
941   }
942 
943   /**
944   * @dev Removes an address to the team.
945   * @param _address the ETH address to remove, cannot be 0x and must be in team
946   **/
947   function removeFromTeam(address _address) public onlyOwner {
948     if(_address == address(0)) revert InvalidTeamAddress();
949     if(!inTeam(_address)) revert InvalidTeamAddress();
950   
951     team[_address] = false;
952   }
953 
954   /**
955   * @dev Check if an address is valid and active in the team
956   * @param _address ETH address to check for truthiness
957   **/
958   function inTeam(address _address)
959     public
960     view
961     returns (bool)
962   {
963     if(_address == address(0)) revert InvalidTeamAddress();
964     return team[_address] == true;
965   }
966 
967   /**
968   * @dev Throws if called by any account other than the owner or team member.
969   */
970   function _onlyTeamOrOwner() private view {
971     bool _isOwner = owner() == _msgSender();
972     bool _isTeam = inTeam(_msgSender());
973     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
974   }
975 
976   modifier onlyTeamOrOwner() {
977     _onlyTeamOrOwner();
978     _;
979   }
980 }
981 
982 
983   
984   pragma solidity ^0.8.0;
985 
986   /**
987   * @dev These functions deal with verification of Merkle Trees proofs.
988   *
989   * The proofs can be generated using the JavaScript library
990   * https://github.com/miguelmota/merkletreejs[merkletreejs].
991   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
992   *
993   *
994   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
995   * hashing, or use a hash function other than keccak256 for hashing leaves.
996   * This is because the concatenation of a sorted pair of internal nodes in
997   * the merkle tree could be reinterpreted as a leaf value.
998   */
999   library MerkleProof {
1000       /**
1001       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1002       * defined by 'root'. For this, a 'proof' must be provided, containing
1003       * sibling hashes on the branch from the leaf to the root of the tree. Each
1004       * pair of leaves and each pair of pre-images are assumed to be sorted.
1005       */
1006       function verify(
1007           bytes32[] memory proof,
1008           bytes32 root,
1009           bytes32 leaf
1010       ) internal pure returns (bool) {
1011           return processProof(proof, leaf) == root;
1012       }
1013 
1014       /**
1015       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1016       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1017       * hash matches the root of the tree. When processing the proof, the pairs
1018       * of leafs & pre-images are assumed to be sorted.
1019       *
1020       * _Available since v4.4._
1021       */
1022       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1023           bytes32 computedHash = leaf;
1024           for (uint256 i = 0; i < proof.length; i++) {
1025               bytes32 proofElement = proof[i];
1026               if (computedHash <= proofElement) {
1027                   // Hash(current computed hash + current element of the proof)
1028                   computedHash = _efficientHash(computedHash, proofElement);
1029               } else {
1030                   // Hash(current element of the proof + current computed hash)
1031                   computedHash = _efficientHash(proofElement, computedHash);
1032               }
1033           }
1034           return computedHash;
1035       }
1036 
1037       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1038           assembly {
1039               mstore(0x00, a)
1040               mstore(0x20, b)
1041               value := keccak256(0x00, 0x40)
1042           }
1043       }
1044   }
1045 
1046 
1047   // File: Allowlist.sol
1048 
1049   pragma solidity ^0.8.0;
1050 
1051   abstract contract Allowlist is Teams {
1052     bytes32 public merkleRoot;
1053     bool public onlyAllowlistMode = false;
1054 
1055     /**
1056      * @dev Update merkle root to reflect changes in Allowlist
1057      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1058      */
1059     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1060       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1061       merkleRoot = _newMerkleRoot;
1062     }
1063 
1064     /**
1065      * @dev Check the proof of an address if valid for merkle root
1066      * @param _to address to check for proof
1067      * @param _merkleProof Proof of the address to validate against root and leaf
1068      */
1069     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1070       if(merkleRoot == 0) revert ValueCannotBeZero();
1071       bytes32 leaf = keccak256(abi.encodePacked(_to));
1072 
1073       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1074     }
1075 
1076     
1077     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1078       onlyAllowlistMode = true;
1079     }
1080 
1081     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1082         onlyAllowlistMode = false;
1083     }
1084   }
1085   
1086   
1087 /**
1088  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1089  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1090  *
1091  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1092  * 
1093  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1094  *
1095  * Does not support burning tokens to address(0).
1096  */
1097 contract ERC721A is
1098   Context,
1099   ERC165,
1100   IERC721,
1101   IERC721Metadata,
1102   IERC721Enumerable,
1103   Teams
1104   , OperatorFilterer
1105 {
1106   using Address for address;
1107   using Strings for uint256;
1108 
1109   struct TokenOwnership {
1110     address addr;
1111     uint64 startTimestamp;
1112   }
1113 
1114   struct AddressData {
1115     uint128 balance;
1116     uint128 numberMinted;
1117   }
1118 
1119   uint256 private currentIndex;
1120 
1121   uint256 public immutable collectionSize;
1122   uint256 public maxBatchSize;
1123 
1124   // Token name
1125   string private _name;
1126 
1127   // Token symbol
1128   string private _symbol;
1129 
1130   // Mapping from token ID to ownership details
1131   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1132   mapping(uint256 => TokenOwnership) private _ownerships;
1133 
1134   // Mapping owner address to address data
1135   mapping(address => AddressData) private _addressData;
1136 
1137   // Mapping from token ID to approved address
1138   mapping(uint256 => address) private _tokenApprovals;
1139 
1140   // Mapping from owner to operator approvals
1141   mapping(address => mapping(address => bool)) private _operatorApprovals;
1142 
1143   /* @dev Mapping of restricted operator approvals set by contract Owner
1144   * This serves as an optional addition to ERC-721 so
1145   * that the contract owner can elect to prevent specific addresses/contracts
1146   * from being marked as the approver for a token. The reason for this
1147   * is that some projects may want to retain control of where their tokens can/can not be listed
1148   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1149   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1150   */
1151   mapping(address => bool) public restrictedApprovalAddresses;
1152 
1153   /**
1154    * @dev
1155    * maxBatchSize refers to how much a minter can mint at a time.
1156    * collectionSize_ refers to how many tokens are in the collection.
1157    */
1158   constructor(
1159     string memory name_,
1160     string memory symbol_,
1161     uint256 maxBatchSize_,
1162     uint256 collectionSize_
1163   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1164     require(
1165       collectionSize_ > 0,
1166       "ERC721A: collection must have a nonzero supply"
1167     );
1168     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1169     _name = name_;
1170     _symbol = symbol_;
1171     maxBatchSize = maxBatchSize_;
1172     collectionSize = collectionSize_;
1173     currentIndex = _startTokenId();
1174   }
1175 
1176   /**
1177   * To change the starting tokenId, please override this function.
1178   */
1179   function _startTokenId() internal view virtual returns (uint256) {
1180     return 1;
1181   }
1182 
1183   /**
1184    * @dev See {IERC721Enumerable-totalSupply}.
1185    */
1186   function totalSupply() public view override returns (uint256) {
1187     return _totalMinted();
1188   }
1189 
1190   function currentTokenId() public view returns (uint256) {
1191     return _totalMinted();
1192   }
1193 
1194   function getNextTokenId() public view returns (uint256) {
1195       return _totalMinted() + 1;
1196   }
1197 
1198   /**
1199   * Returns the total amount of tokens minted in the contract.
1200   */
1201   function _totalMinted() internal view returns (uint256) {
1202     unchecked {
1203       return currentIndex - _startTokenId();
1204     }
1205   }
1206 
1207   /**
1208    * @dev See {IERC721Enumerable-tokenByIndex}.
1209    */
1210   function tokenByIndex(uint256 index) public view override returns (uint256) {
1211     require(index < totalSupply(), "ERC721A: global index out of bounds");
1212     return index;
1213   }
1214 
1215   /**
1216    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1217    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1218    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1219    */
1220   function tokenOfOwnerByIndex(address owner, uint256 index)
1221     public
1222     view
1223     override
1224     returns (uint256)
1225   {
1226     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1227     uint256 numMintedSoFar = totalSupply();
1228     uint256 tokenIdsIdx = 0;
1229     address currOwnershipAddr = address(0);
1230     for (uint256 i = 0; i < numMintedSoFar; i++) {
1231       TokenOwnership memory ownership = _ownerships[i];
1232       if (ownership.addr != address(0)) {
1233         currOwnershipAddr = ownership.addr;
1234       }
1235       if (currOwnershipAddr == owner) {
1236         if (tokenIdsIdx == index) {
1237           return i;
1238         }
1239         tokenIdsIdx++;
1240       }
1241     }
1242     revert("ERC721A: unable to get token of owner by index");
1243   }
1244 
1245   /**
1246    * @dev See {IERC165-supportsInterface}.
1247    */
1248   function supportsInterface(bytes4 interfaceId)
1249     public
1250     view
1251     virtual
1252     override(ERC165, IERC165)
1253     returns (bool)
1254   {
1255     return
1256       interfaceId == type(IERC721).interfaceId ||
1257       interfaceId == type(IERC721Metadata).interfaceId ||
1258       interfaceId == type(IERC721Enumerable).interfaceId ||
1259       super.supportsInterface(interfaceId);
1260   }
1261 
1262   /**
1263    * @dev See {IERC721-balanceOf}.
1264    */
1265   function balanceOf(address owner) public view override returns (uint256) {
1266     require(owner != address(0), "ERC721A: balance query for the zero address");
1267     return uint256(_addressData[owner].balance);
1268   }
1269 
1270   function _numberMinted(address owner) internal view returns (uint256) {
1271     require(
1272       owner != address(0),
1273       "ERC721A: number minted query for the zero address"
1274     );
1275     return uint256(_addressData[owner].numberMinted);
1276   }
1277 
1278   function ownershipOf(uint256 tokenId)
1279     internal
1280     view
1281     returns (TokenOwnership memory)
1282   {
1283     uint256 curr = tokenId;
1284 
1285     unchecked {
1286         if (_startTokenId() <= curr && curr < currentIndex) {
1287             TokenOwnership memory ownership = _ownerships[curr];
1288             if (ownership.addr != address(0)) {
1289                 return ownership;
1290             }
1291 
1292             // Invariant:
1293             // There will always be an ownership that has an address and is not burned
1294             // before an ownership that does not have an address and is not burned.
1295             // Hence, curr will not underflow.
1296             while (true) {
1297                 curr--;
1298                 ownership = _ownerships[curr];
1299                 if (ownership.addr != address(0)) {
1300                     return ownership;
1301                 }
1302             }
1303         }
1304     }
1305 
1306     revert("ERC721A: unable to determine the owner of token");
1307   }
1308 
1309   /**
1310    * @dev See {IERC721-ownerOf}.
1311    */
1312   function ownerOf(uint256 tokenId) public view override returns (address) {
1313     return ownershipOf(tokenId).addr;
1314   }
1315 
1316   /**
1317    * @dev See {IERC721Metadata-name}.
1318    */
1319   function name() public view virtual override returns (string memory) {
1320     return _name;
1321   }
1322 
1323   /**
1324    * @dev See {IERC721Metadata-symbol}.
1325    */
1326   function symbol() public view virtual override returns (string memory) {
1327     return _symbol;
1328   }
1329 
1330   /**
1331    * @dev See {IERC721Metadata-tokenURI}.
1332    */
1333   function tokenURI(uint256 tokenId)
1334     public
1335     view
1336     virtual
1337     override
1338     returns (string memory)
1339   {
1340     string memory baseURI = _baseURI();
1341     string memory extension = _baseURIExtension();
1342     return
1343       bytes(baseURI).length > 0
1344         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1345         : "";
1346   }
1347 
1348   /**
1349    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1350    * token will be the concatenation of the baseURI and the tokenId. Empty
1351    * by default, can be overriden in child contracts.
1352    */
1353   function _baseURI() internal view virtual returns (string memory) {
1354     return "";
1355   }
1356 
1357   /**
1358    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1359    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1360    * by default, can be overriden in child contracts.
1361    */
1362   function _baseURIExtension() internal view virtual returns (string memory) {
1363     return "";
1364   }
1365 
1366   /**
1367    * @dev Sets the value for an address to be in the restricted approval address pool.
1368    * Setting an address to true will disable token owners from being able to mark the address
1369    * for approval for trading. This would be used in theory to prevent token owners from listing
1370    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1371    * @param _address the marketplace/user to modify restriction status of
1372    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1373    */
1374   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1375     restrictedApprovalAddresses[_address] = _isRestricted;
1376   }
1377 
1378   /**
1379    * @dev See {IERC721-approve}.
1380    */
1381   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1382     address owner = ERC721A.ownerOf(tokenId);
1383     require(to != owner, "ERC721A: approval to current owner");
1384     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1385 
1386     require(
1387       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1388       "ERC721A: approve caller is not owner nor approved for all"
1389     );
1390 
1391     _approve(to, tokenId, owner);
1392   }
1393 
1394   /**
1395    * @dev See {IERC721-getApproved}.
1396    */
1397   function getApproved(uint256 tokenId) public view override returns (address) {
1398     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1399 
1400     return _tokenApprovals[tokenId];
1401   }
1402 
1403   /**
1404    * @dev See {IERC721-setApprovalForAll}.
1405    */
1406   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1407     require(operator != _msgSender(), "ERC721A: approve to caller");
1408     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1409 
1410     _operatorApprovals[_msgSender()][operator] = approved;
1411     emit ApprovalForAll(_msgSender(), operator, approved);
1412   }
1413 
1414   /**
1415    * @dev See {IERC721-isApprovedForAll}.
1416    */
1417   function isApprovedForAll(address owner, address operator)
1418     public
1419     view
1420     virtual
1421     override
1422     returns (bool)
1423   {
1424     return _operatorApprovals[owner][operator];
1425   }
1426 
1427   /**
1428    * @dev See {IERC721-transferFrom}.
1429    */
1430   function transferFrom(
1431     address from,
1432     address to,
1433     uint256 tokenId
1434   ) public override onlyAllowedOperator(from) {
1435     _transfer(from, to, tokenId);
1436   }
1437 
1438   /**
1439    * @dev See {IERC721-safeTransferFrom}.
1440    */
1441   function safeTransferFrom(
1442     address from,
1443     address to,
1444     uint256 tokenId
1445   ) public override onlyAllowedOperator(from) {
1446     safeTransferFrom(from, to, tokenId, "");
1447   }
1448 
1449   /**
1450    * @dev See {IERC721-safeTransferFrom}.
1451    */
1452   function safeTransferFrom(
1453     address from,
1454     address to,
1455     uint256 tokenId,
1456     bytes memory _data
1457   ) public override onlyAllowedOperator(from) {
1458     _transfer(from, to, tokenId);
1459     require(
1460       _checkOnERC721Received(from, to, tokenId, _data),
1461       "ERC721A: transfer to non ERC721Receiver implementer"
1462     );
1463   }
1464 
1465   /**
1466    * @dev Returns whether tokenId exists.
1467    *
1468    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1469    *
1470    * Tokens start existing when they are minted (_mint),
1471    */
1472   function _exists(uint256 tokenId) internal view returns (bool) {
1473     return _startTokenId() <= tokenId && tokenId < currentIndex;
1474   }
1475 
1476   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1477     _safeMint(to, quantity, isAdminMint, "");
1478   }
1479 
1480   /**
1481    * @dev Mints quantity tokens and transfers them to to.
1482    *
1483    * Requirements:
1484    *
1485    * - there must be quantity tokens remaining unminted in the total collection.
1486    * - to cannot be the zero address.
1487    * - quantity cannot be larger than the max batch size.
1488    *
1489    * Emits a {Transfer} event.
1490    */
1491   function _safeMint(
1492     address to,
1493     uint256 quantity,
1494     bool isAdminMint,
1495     bytes memory _data
1496   ) internal {
1497     uint256 startTokenId = currentIndex;
1498     require(to != address(0), "ERC721A: mint to the zero address");
1499     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1500     require(!_exists(startTokenId), "ERC721A: token already minted");
1501 
1502     // For admin mints we do not want to enforce the maxBatchSize limit
1503     if (isAdminMint == false) {
1504         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1505     }
1506 
1507     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1508 
1509     AddressData memory addressData = _addressData[to];
1510     _addressData[to] = AddressData(
1511       addressData.balance + uint128(quantity),
1512       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1513     );
1514     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1515 
1516     uint256 updatedIndex = startTokenId;
1517 
1518     for (uint256 i = 0; i < quantity; i++) {
1519       emit Transfer(address(0), to, updatedIndex);
1520       require(
1521         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1522         "ERC721A: transfer to non ERC721Receiver implementer"
1523       );
1524       updatedIndex++;
1525     }
1526 
1527     currentIndex = updatedIndex;
1528     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1529   }
1530 
1531   /**
1532    * @dev Transfers tokenId from from to to.
1533    *
1534    * Requirements:
1535    *
1536    * - to cannot be the zero address.
1537    * - tokenId token must be owned by from.
1538    *
1539    * Emits a {Transfer} event.
1540    */
1541   function _transfer(
1542     address from,
1543     address to,
1544     uint256 tokenId
1545   ) private {
1546     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1547 
1548     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1549       getApproved(tokenId) == _msgSender() ||
1550       isApprovedForAll(prevOwnership.addr, _msgSender()));
1551 
1552     require(
1553       isApprovedOrOwner,
1554       "ERC721A: transfer caller is not owner nor approved"
1555     );
1556 
1557     require(
1558       prevOwnership.addr == from,
1559       "ERC721A: transfer from incorrect owner"
1560     );
1561     require(to != address(0), "ERC721A: transfer to the zero address");
1562 
1563     _beforeTokenTransfers(from, to, tokenId, 1);
1564 
1565     // Clear approvals from the previous owner
1566     _approve(address(0), tokenId, prevOwnership.addr);
1567 
1568     _addressData[from].balance -= 1;
1569     _addressData[to].balance += 1;
1570     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1571 
1572     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1573     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1574     uint256 nextTokenId = tokenId + 1;
1575     if (_ownerships[nextTokenId].addr == address(0)) {
1576       if (_exists(nextTokenId)) {
1577         _ownerships[nextTokenId] = TokenOwnership(
1578           prevOwnership.addr,
1579           prevOwnership.startTimestamp
1580         );
1581       }
1582     }
1583 
1584     emit Transfer(from, to, tokenId);
1585     _afterTokenTransfers(from, to, tokenId, 1);
1586   }
1587 
1588   /**
1589    * @dev Approve to to operate on tokenId
1590    *
1591    * Emits a {Approval} event.
1592    */
1593   function _approve(
1594     address to,
1595     uint256 tokenId,
1596     address owner
1597   ) private {
1598     _tokenApprovals[tokenId] = to;
1599     emit Approval(owner, to, tokenId);
1600   }
1601 
1602   uint256 public nextOwnerToExplicitlySet = 0;
1603 
1604   /**
1605    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1606    */
1607   function _setOwnersExplicit(uint256 quantity) internal {
1608     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1609     require(quantity > 0, "quantity must be nonzero");
1610     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1611 
1612     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1613     if (endIndex > collectionSize - 1) {
1614       endIndex = collectionSize - 1;
1615     }
1616     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1617     require(_exists(endIndex), "not enough minted yet for this cleanup");
1618     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1619       if (_ownerships[i].addr == address(0)) {
1620         TokenOwnership memory ownership = ownershipOf(i);
1621         _ownerships[i] = TokenOwnership(
1622           ownership.addr,
1623           ownership.startTimestamp
1624         );
1625       }
1626     }
1627     nextOwnerToExplicitlySet = endIndex + 1;
1628   }
1629 
1630   /**
1631    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1632    * The call is not executed if the target address is not a contract.
1633    *
1634    * @param from address representing the previous owner of the given token ID
1635    * @param to target address that will receive the tokens
1636    * @param tokenId uint256 ID of the token to be transferred
1637    * @param _data bytes optional data to send along with the call
1638    * @return bool whether the call correctly returned the expected magic value
1639    */
1640   function _checkOnERC721Received(
1641     address from,
1642     address to,
1643     uint256 tokenId,
1644     bytes memory _data
1645   ) private returns (bool) {
1646     if (to.isContract()) {
1647       try
1648         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1649       returns (bytes4 retval) {
1650         return retval == IERC721Receiver(to).onERC721Received.selector;
1651       } catch (bytes memory reason) {
1652         if (reason.length == 0) {
1653           revert("ERC721A: transfer to non ERC721Receiver implementer");
1654         } else {
1655           assembly {
1656             revert(add(32, reason), mload(reason))
1657           }
1658         }
1659       }
1660     } else {
1661       return true;
1662     }
1663   }
1664 
1665   /**
1666    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1667    *
1668    * startTokenId - the first token id to be transferred
1669    * quantity - the amount to be transferred
1670    *
1671    * Calling conditions:
1672    *
1673    * - When from and to are both non-zero, from's tokenId will be
1674    * transferred to to.
1675    * - When from is zero, tokenId will be minted for to.
1676    */
1677   function _beforeTokenTransfers(
1678     address from,
1679     address to,
1680     uint256 startTokenId,
1681     uint256 quantity
1682   ) internal virtual {}
1683 
1684   /**
1685    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1686    * minting.
1687    *
1688    * startTokenId - the first token id to be transferred
1689    * quantity - the amount to be transferred
1690    *
1691    * Calling conditions:
1692    *
1693    * - when from and to are both non-zero.
1694    * - from and to are never both zero.
1695    */
1696   function _afterTokenTransfers(
1697     address from,
1698     address to,
1699     uint256 startTokenId,
1700     uint256 quantity
1701   ) internal virtual {}
1702 }
1703 
1704 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1705 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1706 // @notice -- See Medium article --
1707 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1708 abstract contract ERC721ARedemption is ERC721A {
1709   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1710   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1711 
1712   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1713   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1714   
1715   uint256 public redemptionSurcharge = 0 ether;
1716   bool public redemptionModeEnabled;
1717   bool public verifiedClaimModeEnabled;
1718   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1719   mapping(address => bool) public redemptionContracts;
1720   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1721 
1722   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1723   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1724     redemptionContracts[_contractAddress] = _status;
1725   }
1726 
1727   // @dev Allow owner/team to determine if contract is accepting redemption mints
1728   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1729     redemptionModeEnabled = _newStatus;
1730   }
1731 
1732   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1733   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1734     verifiedClaimModeEnabled = _newStatus;
1735   }
1736 
1737   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1738   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1739     redemptionSurcharge = _newSurchargeInWei;
1740   }
1741 
1742   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1743   // @notice Must be a wallet address or implement IERC721Receiver.
1744   // Cannot be null address as this will break any ERC-721A implementation without a proper
1745   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1746   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1747     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1748     redemptionAddress = _newRedemptionAddress;
1749   }
1750 
1751   /**
1752   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1753   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1754   * the contract owner or Team => redemptionAddress. 
1755   * @param tokenId the token to be redeemed.
1756   * Emits a {Redeemed} event.
1757   **/
1758   function redeem(address redemptionContract, uint256 tokenId) public payable {
1759     if(getNextTokenId() > collectionSize) revert CapExceeded();
1760     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1761     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1762     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1763     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1764     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1765     
1766     IERC721 _targetContract = IERC721(redemptionContract);
1767     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1768     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1769     
1770     // Warning: Since there is no standarized return value for transfers of ERC-721
1771     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1772     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1773     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1774     // but the NFT may not have been sent to the redemptionAddress.
1775     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1776     tokenRedemptions[redemptionContract][tokenId] = true;
1777 
1778     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1779     _safeMint(_msgSender(), 1, false);
1780   }
1781 
1782   /**
1783   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1784   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1785   * @param tokenId the token to be redeemed.
1786   * Emits a {VerifiedClaim} event.
1787   **/
1788   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1789     if(getNextTokenId() > collectionSize) revert CapExceeded();
1790     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1791     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1792     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1793     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1794     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1795     
1796     tokenRedemptions[redemptionContract][tokenId] = true;
1797     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1798     _safeMint(_msgSender(), 1, false);
1799   }
1800 }
1801 
1802 
1803   
1804   
1805 interface IERC20 {
1806   function allowance(address owner, address spender) external view returns (uint256);
1807   function transfer(address _to, uint256 _amount) external returns (bool);
1808   function balanceOf(address account) external view returns (uint256);
1809   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1810 }
1811 
1812 // File: WithdrawableV2
1813 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1814 // ERC-20 Payouts are limited to a single payout address. This feature 
1815 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1816 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1817 abstract contract WithdrawableV2 is Teams {
1818   struct acceptedERC20 {
1819     bool isActive;
1820     uint256 chargeAmount;
1821   }
1822 
1823   
1824   mapping(address => acceptedERC20) private allowedTokenContracts;
1825   address[] public payableAddresses = [0x2024aBe345FC322aA76B68323Fa911C22473e324];
1826   address public erc20Payable = 0x2024aBe345FC322aA76B68323Fa911C22473e324;
1827   uint256[] public payableFees = [100];
1828   uint256 public payableAddressCount = 1;
1829   bool public onlyERC20MintingMode;
1830   
1831 
1832   function withdrawAll() public onlyTeamOrOwner {
1833       if(address(this).balance == 0) revert ValueCannotBeZero();
1834       _withdrawAll(address(this).balance);
1835   }
1836 
1837   function _withdrawAll(uint256 balance) private {
1838       for(uint i=0; i < payableAddressCount; i++ ) {
1839           _widthdraw(
1840               payableAddresses[i],
1841               (balance * payableFees[i]) / 100
1842           );
1843       }
1844   }
1845   
1846   function _widthdraw(address _address, uint256 _amount) private {
1847       (bool success, ) = _address.call{value: _amount}("");
1848       require(success, "Transfer failed.");
1849   }
1850 
1851   /**
1852   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1853   * in the event ERC-20 tokens are paid to the contract for mints.
1854   * @param _tokenContract contract of ERC-20 token to withdraw
1855   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1856   */
1857   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1858     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1859     IERC20 tokenContract = IERC20(_tokenContract);
1860     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1861     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1862   }
1863 
1864   /**
1865   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1866   * @param _erc20TokenContract address of ERC-20 contract in question
1867   */
1868   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1869     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1870   }
1871 
1872   /**
1873   * @dev get the value of tokens to transfer for user of an ERC-20
1874   * @param _erc20TokenContract address of ERC-20 contract in question
1875   */
1876   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1877     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1878     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1879   }
1880 
1881   /**
1882   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1883   * @param _erc20TokenContract address of ERC-20 contract in question
1884   * @param _isActive default status of if contract should be allowed to accept payments
1885   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1886   */
1887   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1888     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1889     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1890   }
1891 
1892   /**
1893   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1894   * it will assume the default value of zero. This should not be used to create new payment tokens.
1895   * @param _erc20TokenContract address of ERC-20 contract in question
1896   */
1897   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1898     allowedTokenContracts[_erc20TokenContract].isActive = true;
1899   }
1900 
1901   /**
1902   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1903   * it will assume the default value of zero. This should not be used to create new payment tokens.
1904   * @param _erc20TokenContract address of ERC-20 contract in question
1905   */
1906   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1907     allowedTokenContracts[_erc20TokenContract].isActive = false;
1908   }
1909 
1910   /**
1911   * @dev Enable only ERC-20 payments for minting on this contract
1912   */
1913   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1914     onlyERC20MintingMode = true;
1915   }
1916 
1917   /**
1918   * @dev Disable only ERC-20 payments for minting on this contract
1919   */
1920   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1921     onlyERC20MintingMode = false;
1922   }
1923 
1924   /**
1925   * @dev Set the payout of the ERC-20 token payout to a specific address
1926   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1927   */
1928   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1929     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1930     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1931     erc20Payable = _newErc20Payable;
1932   }
1933 }
1934 
1935 
1936   
1937   
1938 // File: EarlyMintIncentive.sol
1939 // Allows the contract to have the first x tokens have a discount or
1940 // zero fee that can be calculated on the fly.
1941 abstract contract EarlyMintIncentive is Teams, ERC721A {
1942   uint256 public PRICE = 0.0333 ether;
1943   uint256 public EARLY_MINT_PRICE = 0 ether;
1944   uint256 public earlyMintTokenIdCap = 116;
1945   bool public usingEarlyMintIncentive = true;
1946 
1947   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1948     usingEarlyMintIncentive = true;
1949   }
1950 
1951   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1952     usingEarlyMintIncentive = false;
1953   }
1954 
1955   /**
1956   * @dev Set the max token ID in which the cost incentive will be applied.
1957   * @param _newTokenIdCap max tokenId in which incentive will be applied
1958   */
1959   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1960     if(_newTokenIdCap > collectionSize) revert CapExceeded();
1961     if(_newTokenIdCap == 0) revert ValueCannotBeZero();
1962     earlyMintTokenIdCap = _newTokenIdCap;
1963   }
1964 
1965   /**
1966   * @dev Set the incentive mint price
1967   * @param _feeInWei new price per token when in incentive range
1968   */
1969   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1970     EARLY_MINT_PRICE = _feeInWei;
1971   }
1972 
1973   /**
1974   * @dev Set the primary mint price - the base price when not under incentive
1975   * @param _feeInWei new price per token
1976   */
1977   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1978     PRICE = _feeInWei;
1979   }
1980 
1981   function getPrice(uint256 _count) public view returns (uint256) {
1982     if(_count == 0) revert ValueCannotBeZero();
1983 
1984     // short circuit function if we dont need to even calc incentive pricing
1985     // short circuit if the current tokenId is also already over cap
1986     if(
1987       usingEarlyMintIncentive == false ||
1988       currentTokenId() > earlyMintTokenIdCap
1989     ) {
1990       return PRICE * _count;
1991     }
1992 
1993     uint256 endingTokenId = currentTokenId() + _count;
1994     // If qty to mint results in a final token ID less than or equal to the cap then
1995     // the entire qty is within free mint.
1996     if(endingTokenId  <= earlyMintTokenIdCap) {
1997       return EARLY_MINT_PRICE * _count;
1998     }
1999 
2000     // If the current token id is less than the incentive cap
2001     // and the ending token ID is greater than the incentive cap
2002     // we will be straddling the cap so there will be some amount
2003     // that are incentive and some that are regular fee.
2004     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
2005     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
2006 
2007     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
2008   }
2009 }
2010 
2011   
2012   
2013 abstract contract RamppERC721A is 
2014     Ownable,
2015     Teams,
2016     ERC721ARedemption,
2017     WithdrawableV2,
2018     ReentrancyGuard 
2019     , EarlyMintIncentive 
2020     , Allowlist 
2021     
2022 {
2023   constructor(
2024     string memory tokenName,
2025     string memory tokenSymbol
2026   ) ERC721A(tokenName, tokenSymbol, 2, 10000) { }
2027     uint8 constant public CONTRACT_VERSION = 2;
2028     string public _baseTokenURI = "https://metadata.mintfoundry.xyz/c/9bnQmQkBlLHHkHImpl2A/token/";
2029     string public _baseTokenExtension = ".json";
2030 
2031     bool public mintingOpen = false;
2032     
2033     
2034     uint256 public MAX_WALLET_MINTS = 3;
2035 
2036   
2037     /////////////// Admin Mint Functions
2038     /**
2039      * @dev Mints a token to an address with a tokenURI.
2040      * This is owner only and allows a fee-free drop
2041      * @param _to address of the future owner of the token
2042      * @param _qty amount of tokens to drop the owner
2043      */
2044      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2045          if(_qty == 0) revert MintZeroQuantity();
2046          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2047          _safeMint(_to, _qty, true);
2048      }
2049 
2050   
2051     /////////////// PUBLIC MINT FUNCTIONS
2052     /**
2053     * @dev Mints tokens to an address in batch.
2054     * fee may or may not be required*
2055     * @param _to address of the future owner of the token
2056     * @param _amount number of tokens to mint
2057     */
2058     function mintToMultiple(address _to, uint256 _amount) public payable {
2059         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2060         if(_amount == 0) revert MintZeroQuantity();
2061         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2062         if(!mintingOpen) revert PublicMintClosed();
2063         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2064         
2065         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2066         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2067         if(msg.value != getPrice(_amount)) revert InvalidPayment();
2068 
2069         _safeMint(_to, _amount, false);
2070     }
2071 
2072     /**
2073      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2074      * fee may or may not be required*
2075      * @param _to address of the future owner of the token
2076      * @param _amount number of tokens to mint
2077      * @param _erc20TokenContract erc-20 token contract to mint with
2078      */
2079     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2080       if(_amount == 0) revert MintZeroQuantity();
2081       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2082       if(!mintingOpen) revert PublicMintClosed();
2083       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2084       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2085       
2086       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2087 
2088       // ERC-20 Specific pre-flight checks
2089       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2090       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2091       IERC20 payableToken = IERC20(_erc20TokenContract);
2092 
2093       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2094       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2095 
2096       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2097       if(!transferComplete) revert ERC20TransferFailed();
2098       
2099       _safeMint(_to, _amount, false);
2100     }
2101 
2102     function openMinting() public onlyTeamOrOwner {
2103         mintingOpen = true;
2104     }
2105 
2106     function stopMinting() public onlyTeamOrOwner {
2107         mintingOpen = false;
2108     }
2109 
2110   
2111     ///////////// ALLOWLIST MINTING FUNCTIONS
2112     /**
2113     * @dev Mints tokens to an address using an allowlist.
2114     * fee may or may not be required*
2115     * @param _to address of the future owner of the token
2116     * @param _amount number of tokens to mint
2117     * @param _merkleProof merkle proof array
2118     */
2119     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2120         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2121         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2122         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2123         if(_amount == 0) revert MintZeroQuantity();
2124         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2125         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2126         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2127         if(msg.value != getPrice(_amount)) revert InvalidPayment();
2128         
2129 
2130         _safeMint(_to, _amount, false);
2131     }
2132 
2133     /**
2134     * @dev Mints tokens to an address using an allowlist.
2135     * fee may or may not be required*
2136     * @param _to address of the future owner of the token
2137     * @param _amount number of tokens to mint
2138     * @param _merkleProof merkle proof array
2139     * @param _erc20TokenContract erc-20 token contract to mint with
2140     */
2141     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2142       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2143       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2144       if(_amount == 0) revert MintZeroQuantity();
2145       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2146       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2147       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2148       
2149     
2150       // ERC-20 Specific pre-flight checks
2151       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2152       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2153       IERC20 payableToken = IERC20(_erc20TokenContract);
2154 
2155       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2156       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2157 
2158       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2159       if(!transferComplete) revert ERC20TransferFailed();
2160       
2161       _safeMint(_to, _amount, false);
2162     }
2163 
2164     /**
2165      * @dev Enable allowlist minting fully by enabling both flags
2166      * This is a convenience function for the Rampp user
2167      */
2168     function openAllowlistMint() public onlyTeamOrOwner {
2169         enableAllowlistOnlyMode();
2170         mintingOpen = true;
2171     }
2172 
2173     /**
2174      * @dev Close allowlist minting fully by disabling both flags
2175      * This is a convenience function for the Rampp user
2176      */
2177     function closeAllowlistMint() public onlyTeamOrOwner {
2178         disableAllowlistOnlyMode();
2179         mintingOpen = false;
2180     }
2181 
2182 
2183   
2184     /**
2185     * @dev Check if wallet over MAX_WALLET_MINTS
2186     * @param _address address in question to check if minted count exceeds max
2187     */
2188     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2189         if(_amount == 0) revert ValueCannotBeZero();
2190         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2191     }
2192 
2193     /**
2194     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2195     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2196     */
2197     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2198         if(_newWalletMax == 0) revert ValueCannotBeZero();
2199         MAX_WALLET_MINTS = _newWalletMax;
2200     }
2201     
2202 
2203   
2204     /**
2205      * @dev Allows owner to set Max mints per tx
2206      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2207      */
2208      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2209          if(_newMaxMint == 0) revert ValueCannotBeZero();
2210          maxBatchSize = _newMaxMint;
2211      }
2212     
2213 
2214   
2215   
2216   
2217   function contractURI() public pure returns (string memory) {
2218     return "https://metadata.mintplex.xyz/EnK97WPcgazy1PVL8Eu4/contract-metadata";
2219   }
2220   
2221 
2222   function _baseURI() internal view virtual override returns(string memory) {
2223     return _baseTokenURI;
2224   }
2225 
2226   function _baseURIExtension() internal view virtual override returns(string memory) {
2227     return _baseTokenExtension;
2228   }
2229 
2230   function baseTokenURI() public view returns(string memory) {
2231     return _baseTokenURI;
2232   }
2233 
2234   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2235     _baseTokenURI = baseURI;
2236   }
2237 
2238   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2239     _baseTokenExtension = baseExtension;
2240   }
2241 }
2242 
2243 
2244   
2245 // File: contracts/ParadoxTheRallyofBloodContract.sol
2246 //SPDX-License-Identifier: MIT
2247 
2248 pragma solidity ^0.8.0;
2249 
2250 contract ParadoxTheRallyofBloodContract is RamppERC721A {
2251     constructor() RamppERC721A("Paradox The Rally of Blood", "PRDX"){}
2252 }
2253   