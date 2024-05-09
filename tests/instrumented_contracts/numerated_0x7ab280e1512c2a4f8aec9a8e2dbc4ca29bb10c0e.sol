1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ▄████▄   ▄▄▄     ▄▄▄█████▓▄▄▄█████▓ ▄▄▄        ██████ ▄▄▄█████▓ ██▓ ▄████▄   ▐██▌ 
5 // ▒██▀ ▀█  ▒████▄   ▓  ██▒ ▓▒▓  ██▒ ▓▒▒████▄    ▒██    ▒ ▓  ██▒ ▓▒▓██▒▒██▀ ▀█   ▐██▌ 
6 // ▒▓█    ▄ ▒██  ▀█▄ ▒ ▓██░ ▒░▒ ▓██░ ▒░▒██  ▀█▄  ░ ▓██▄   ▒ ▓██░ ▒░▒██▒▒▓█    ▄  ▐██▌ 
7 // ▒▓▓▄ ▄██▒░██▄▄▄▄██░ ▓██▓ ░ ░ ▓██▓ ░ ░██▄▄▄▄██   ▒   ██▒░ ▓██▓ ░ ░██░▒▓▓▄ ▄██▒ ▓██▒ 
8 // ▒ ▓███▀ ░ ▓█   ▓██▒ ▒██▒ ░   ▒██▒ ░  ▓█   ▓██▒▒██████▒▒  ▒██▒ ░ ░██░▒ ▓███▀ ░ ▒▄▄  
9 // ░ ░▒ ▒  ░ ▒▒   ▓▒█░ ▒ ░░     ▒ ░░    ▒▒   ▓▒█░▒ ▒▓▒ ▒ ░  ▒ ░░   ░▓  ░ ░▒ ▒  ░ ░▀▀▒ 
10 //   ░  ▒     ▒   ▒▒ ░   ░        ░      ▒   ▒▒ ░░ ░▒  ░ ░    ░     ▒ ░  ░  ▒    ░  ░ 
11 // ░          ░   ▒    ░        ░        ░   ▒   ░  ░  ░    ░       ▒ ░░            ░ 
12 // ░ ░            ░  ░                       ░  ░      ░            ░  ░ ░       ░    
13 // ░                                                                   ░              
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
916 error NotMaintainer();
917   
918   
919 // Rampp Contracts v2.1 (Teams.sol)
920 
921 error InvalidTeamAddress();
922 error DuplicateTeamAddress();
923 pragma solidity ^0.8.0;
924 
925 /**
926 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
927 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
928 * This will easily allow cross-collaboration via Mintplex.xyz.
929 **/
930 abstract contract Teams is Ownable{
931   mapping (address => bool) internal team;
932 
933   /**
934   * @dev Adds an address to the team. Allows them to execute protected functions
935   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
936   **/
937   function addToTeam(address _address) public onlyOwner {
938     if(_address == address(0)) revert InvalidTeamAddress();
939     if(inTeam(_address)) revert DuplicateTeamAddress();
940   
941     team[_address] = true;
942   }
943 
944   /**
945   * @dev Removes an address to the team.
946   * @param _address the ETH address to remove, cannot be 0x and must be in team
947   **/
948   function removeFromTeam(address _address) public onlyOwner {
949     if(_address == address(0)) revert InvalidTeamAddress();
950     if(!inTeam(_address)) revert InvalidTeamAddress();
951   
952     team[_address] = false;
953   }
954 
955   /**
956   * @dev Check if an address is valid and active in the team
957   * @param _address ETH address to check for truthiness
958   **/
959   function inTeam(address _address)
960     public
961     view
962     returns (bool)
963   {
964     if(_address == address(0)) revert InvalidTeamAddress();
965     return team[_address] == true;
966   }
967 
968   /**
969   * @dev Throws if called by any account other than the owner or team member.
970   */
971   function _onlyTeamOrOwner() private view {
972     bool _isOwner = owner() == _msgSender();
973     bool _isTeam = inTeam(_msgSender());
974     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
975   }
976 
977   modifier onlyTeamOrOwner() {
978     _onlyTeamOrOwner();
979     _;
980   }
981 }
982 
983 
984   
985   pragma solidity ^0.8.0;
986 
987   /**
988   * @dev These functions deal with verification of Merkle Trees proofs.
989   *
990   * The proofs can be generated using the JavaScript library
991   * https://github.com/miguelmota/merkletreejs[merkletreejs].
992   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
993   *
994   *
995   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
996   * hashing, or use a hash function other than keccak256 for hashing leaves.
997   * This is because the concatenation of a sorted pair of internal nodes in
998   * the merkle tree could be reinterpreted as a leaf value.
999   */
1000   library MerkleProof {
1001       /**
1002       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1003       * defined by 'root'. For this, a 'proof' must be provided, containing
1004       * sibling hashes on the branch from the leaf to the root of the tree. Each
1005       * pair of leaves and each pair of pre-images are assumed to be sorted.
1006       */
1007       function verify(
1008           bytes32[] memory proof,
1009           bytes32 root,
1010           bytes32 leaf
1011       ) internal pure returns (bool) {
1012           return processProof(proof, leaf) == root;
1013       }
1014 
1015       /**
1016       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1017       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1018       * hash matches the root of the tree. When processing the proof, the pairs
1019       * of leafs & pre-images are assumed to be sorted.
1020       *
1021       * _Available since v4.4._
1022       */
1023       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1024           bytes32 computedHash = leaf;
1025           for (uint256 i = 0; i < proof.length; i++) {
1026               bytes32 proofElement = proof[i];
1027               if (computedHash <= proofElement) {
1028                   // Hash(current computed hash + current element of the proof)
1029                   computedHash = _efficientHash(computedHash, proofElement);
1030               } else {
1031                   // Hash(current element of the proof + current computed hash)
1032                   computedHash = _efficientHash(proofElement, computedHash);
1033               }
1034           }
1035           return computedHash;
1036       }
1037 
1038       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1039           assembly {
1040               mstore(0x00, a)
1041               mstore(0x20, b)
1042               value := keccak256(0x00, 0x40)
1043           }
1044       }
1045   }
1046 
1047 
1048   // File: Allowlist.sol
1049 
1050   pragma solidity ^0.8.0;
1051 
1052   abstract contract Allowlist is Teams {
1053     bytes32 public merkleRoot;
1054     bool public onlyAllowlistMode = false;
1055 
1056     /**
1057      * @dev Update merkle root to reflect changes in Allowlist
1058      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1059      */
1060     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1061       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1062       merkleRoot = _newMerkleRoot;
1063     }
1064 
1065     /**
1066      * @dev Check the proof of an address if valid for merkle root
1067      * @param _to address to check for proof
1068      * @param _merkleProof Proof of the address to validate against root and leaf
1069      */
1070     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1071       if(merkleRoot == 0) revert ValueCannotBeZero();
1072       bytes32 leaf = keccak256(abi.encodePacked(_to));
1073 
1074       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1075     }
1076 
1077     
1078     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1079       onlyAllowlistMode = true;
1080     }
1081 
1082     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1083         onlyAllowlistMode = false;
1084     }
1085   }
1086   
1087   
1088 /**
1089  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1090  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1091  *
1092  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1093  * 
1094  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1095  *
1096  * Does not support burning tokens to address(0).
1097  */
1098 contract ERC721A is
1099   Context,
1100   ERC165,
1101   IERC721,
1102   IERC721Metadata,
1103   IERC721Enumerable,
1104   Teams
1105   , OperatorFilterer
1106 {
1107   using Address for address;
1108   using Strings for uint256;
1109 
1110   struct TokenOwnership {
1111     address addr;
1112     uint64 startTimestamp;
1113   }
1114 
1115   struct AddressData {
1116     uint128 balance;
1117     uint128 numberMinted;
1118   }
1119 
1120   uint256 private currentIndex;
1121 
1122   uint256 public immutable collectionSize;
1123   uint256 public maxBatchSize;
1124 
1125   // Token name
1126   string private _name;
1127 
1128   // Token symbol
1129   string private _symbol;
1130 
1131   // Mapping from token ID to ownership details
1132   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1133   mapping(uint256 => TokenOwnership) private _ownerships;
1134 
1135   // Mapping owner address to address data
1136   mapping(address => AddressData) private _addressData;
1137 
1138   // Mapping from token ID to approved address
1139   mapping(uint256 => address) private _tokenApprovals;
1140 
1141   // Mapping from owner to operator approvals
1142   mapping(address => mapping(address => bool)) private _operatorApprovals;
1143 
1144   /* @dev Mapping of restricted operator approvals set by contract Owner
1145   * This serves as an optional addition to ERC-721 so
1146   * that the contract owner can elect to prevent specific addresses/contracts
1147   * from being marked as the approver for a token. The reason for this
1148   * is that some projects may want to retain control of where their tokens can/can not be listed
1149   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1150   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1151   */
1152   mapping(address => bool) public restrictedApprovalAddresses;
1153 
1154   /**
1155    * @dev
1156    * maxBatchSize refers to how much a minter can mint at a time.
1157    * collectionSize_ refers to how many tokens are in the collection.
1158    */
1159   constructor(
1160     string memory name_,
1161     string memory symbol_,
1162     uint256 maxBatchSize_,
1163     uint256 collectionSize_
1164   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1165     require(
1166       collectionSize_ > 0,
1167       "ERC721A: collection must have a nonzero supply"
1168     );
1169     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1170     _name = name_;
1171     _symbol = symbol_;
1172     maxBatchSize = maxBatchSize_;
1173     collectionSize = collectionSize_;
1174     currentIndex = _startTokenId();
1175   }
1176 
1177   /**
1178   * To change the starting tokenId, please override this function.
1179   */
1180   function _startTokenId() internal view virtual returns (uint256) {
1181     return 1;
1182   }
1183 
1184   /**
1185    * @dev See {IERC721Enumerable-totalSupply}.
1186    */
1187   function totalSupply() public view override returns (uint256) {
1188     return _totalMinted();
1189   }
1190 
1191   function currentTokenId() public view returns (uint256) {
1192     return _totalMinted();
1193   }
1194 
1195   function getNextTokenId() public view returns (uint256) {
1196       return _totalMinted() + 1;
1197   }
1198 
1199   /**
1200   * Returns the total amount of tokens minted in the contract.
1201   */
1202   function _totalMinted() internal view returns (uint256) {
1203     unchecked {
1204       return currentIndex - _startTokenId();
1205     }
1206   }
1207 
1208   /**
1209    * @dev See {IERC721Enumerable-tokenByIndex}.
1210    */
1211   function tokenByIndex(uint256 index) public view override returns (uint256) {
1212     require(index < totalSupply(), "ERC721A: global index out of bounds");
1213     return index;
1214   }
1215 
1216   /**
1217    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1218    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1219    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1220    */
1221   function tokenOfOwnerByIndex(address owner, uint256 index)
1222     public
1223     view
1224     override
1225     returns (uint256)
1226   {
1227     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1228     uint256 numMintedSoFar = totalSupply();
1229     uint256 tokenIdsIdx = 0;
1230     address currOwnershipAddr = address(0);
1231     for (uint256 i = 0; i < numMintedSoFar; i++) {
1232       TokenOwnership memory ownership = _ownerships[i];
1233       if (ownership.addr != address(0)) {
1234         currOwnershipAddr = ownership.addr;
1235       }
1236       if (currOwnershipAddr == owner) {
1237         if (tokenIdsIdx == index) {
1238           return i;
1239         }
1240         tokenIdsIdx++;
1241       }
1242     }
1243     revert("ERC721A: unable to get token of owner by index");
1244   }
1245 
1246   /**
1247    * @dev See {IERC165-supportsInterface}.
1248    */
1249   function supportsInterface(bytes4 interfaceId)
1250     public
1251     view
1252     virtual
1253     override(ERC165, IERC165)
1254     returns (bool)
1255   {
1256     return
1257       interfaceId == type(IERC721).interfaceId ||
1258       interfaceId == type(IERC721Metadata).interfaceId ||
1259       interfaceId == type(IERC721Enumerable).interfaceId ||
1260       super.supportsInterface(interfaceId);
1261   }
1262 
1263   /**
1264    * @dev See {IERC721-balanceOf}.
1265    */
1266   function balanceOf(address owner) public view override returns (uint256) {
1267     require(owner != address(0), "ERC721A: balance query for the zero address");
1268     return uint256(_addressData[owner].balance);
1269   }
1270 
1271   function _numberMinted(address owner) internal view returns (uint256) {
1272     require(
1273       owner != address(0),
1274       "ERC721A: number minted query for the zero address"
1275     );
1276     return uint256(_addressData[owner].numberMinted);
1277   }
1278 
1279   function ownershipOf(uint256 tokenId)
1280     internal
1281     view
1282     returns (TokenOwnership memory)
1283   {
1284     uint256 curr = tokenId;
1285 
1286     unchecked {
1287         if (_startTokenId() <= curr && curr < currentIndex) {
1288             TokenOwnership memory ownership = _ownerships[curr];
1289             if (ownership.addr != address(0)) {
1290                 return ownership;
1291             }
1292 
1293             // Invariant:
1294             // There will always be an ownership that has an address and is not burned
1295             // before an ownership that does not have an address and is not burned.
1296             // Hence, curr will not underflow.
1297             while (true) {
1298                 curr--;
1299                 ownership = _ownerships[curr];
1300                 if (ownership.addr != address(0)) {
1301                     return ownership;
1302                 }
1303             }
1304         }
1305     }
1306 
1307     revert("ERC721A: unable to determine the owner of token");
1308   }
1309 
1310   /**
1311    * @dev See {IERC721-ownerOf}.
1312    */
1313   function ownerOf(uint256 tokenId) public view override returns (address) {
1314     return ownershipOf(tokenId).addr;
1315   }
1316 
1317   /**
1318    * @dev See {IERC721Metadata-name}.
1319    */
1320   function name() public view virtual override returns (string memory) {
1321     return _name;
1322   }
1323 
1324   /**
1325    * @dev See {IERC721Metadata-symbol}.
1326    */
1327   function symbol() public view virtual override returns (string memory) {
1328     return _symbol;
1329   }
1330 
1331   /**
1332    * @dev See {IERC721Metadata-tokenURI}.
1333    */
1334   function tokenURI(uint256 tokenId)
1335     public
1336     view
1337     virtual
1338     override
1339     returns (string memory)
1340   {
1341     string memory baseURI = _baseURI();
1342     string memory extension = _baseURIExtension();
1343     return
1344       bytes(baseURI).length > 0
1345         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1346         : "";
1347   }
1348 
1349   /**
1350    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1351    * token will be the concatenation of the baseURI and the tokenId. Empty
1352    * by default, can be overriden in child contracts.
1353    */
1354   function _baseURI() internal view virtual returns (string memory) {
1355     return "";
1356   }
1357 
1358   /**
1359    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1360    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1361    * by default, can be overriden in child contracts.
1362    */
1363   function _baseURIExtension() internal view virtual returns (string memory) {
1364     return "";
1365   }
1366 
1367   /**
1368    * @dev Sets the value for an address to be in the restricted approval address pool.
1369    * Setting an address to true will disable token owners from being able to mark the address
1370    * for approval for trading. This would be used in theory to prevent token owners from listing
1371    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1372    * @param _address the marketplace/user to modify restriction status of
1373    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1374    */
1375   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1376     restrictedApprovalAddresses[_address] = _isRestricted;
1377   }
1378 
1379   /**
1380    * @dev See {IERC721-approve}.
1381    */
1382   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1383     address owner = ERC721A.ownerOf(tokenId);
1384     require(to != owner, "ERC721A: approval to current owner");
1385     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1386 
1387     require(
1388       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1389       "ERC721A: approve caller is not owner nor approved for all"
1390     );
1391 
1392     _approve(to, tokenId, owner);
1393   }
1394 
1395   /**
1396    * @dev See {IERC721-getApproved}.
1397    */
1398   function getApproved(uint256 tokenId) public view override returns (address) {
1399     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1400 
1401     return _tokenApprovals[tokenId];
1402   }
1403 
1404   /**
1405    * @dev See {IERC721-setApprovalForAll}.
1406    */
1407   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1408     require(operator != _msgSender(), "ERC721A: approve to caller");
1409     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1410 
1411     _operatorApprovals[_msgSender()][operator] = approved;
1412     emit ApprovalForAll(_msgSender(), operator, approved);
1413   }
1414 
1415   /**
1416    * @dev See {IERC721-isApprovedForAll}.
1417    */
1418   function isApprovedForAll(address owner, address operator)
1419     public
1420     view
1421     virtual
1422     override
1423     returns (bool)
1424   {
1425     return _operatorApprovals[owner][operator];
1426   }
1427 
1428   /**
1429    * @dev See {IERC721-transferFrom}.
1430    */
1431   function transferFrom(
1432     address from,
1433     address to,
1434     uint256 tokenId
1435   ) public override onlyAllowedOperator(from) {
1436     _transfer(from, to, tokenId);
1437   }
1438 
1439   /**
1440    * @dev See {IERC721-safeTransferFrom}.
1441    */
1442   function safeTransferFrom(
1443     address from,
1444     address to,
1445     uint256 tokenId
1446   ) public override onlyAllowedOperator(from) {
1447     safeTransferFrom(from, to, tokenId, "");
1448   }
1449 
1450   /**
1451    * @dev See {IERC721-safeTransferFrom}.
1452    */
1453   function safeTransferFrom(
1454     address from,
1455     address to,
1456     uint256 tokenId,
1457     bytes memory _data
1458   ) public override onlyAllowedOperator(from) {
1459     _transfer(from, to, tokenId);
1460     require(
1461       _checkOnERC721Received(from, to, tokenId, _data),
1462       "ERC721A: transfer to non ERC721Receiver implementer"
1463     );
1464   }
1465 
1466   /**
1467    * @dev Returns whether tokenId exists.
1468    *
1469    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1470    *
1471    * Tokens start existing when they are minted (_mint),
1472    */
1473   function _exists(uint256 tokenId) internal view returns (bool) {
1474     return _startTokenId() <= tokenId && tokenId < currentIndex;
1475   }
1476 
1477   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1478     _safeMint(to, quantity, isAdminMint, "");
1479   }
1480 
1481   /**
1482    * @dev Mints quantity tokens and transfers them to to.
1483    *
1484    * Requirements:
1485    *
1486    * - there must be quantity tokens remaining unminted in the total collection.
1487    * - to cannot be the zero address.
1488    * - quantity cannot be larger than the max batch size.
1489    *
1490    * Emits a {Transfer} event.
1491    */
1492   function _safeMint(
1493     address to,
1494     uint256 quantity,
1495     bool isAdminMint,
1496     bytes memory _data
1497   ) internal {
1498     uint256 startTokenId = currentIndex;
1499     require(to != address(0), "ERC721A: mint to the zero address");
1500     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1501     require(!_exists(startTokenId), "ERC721A: token already minted");
1502 
1503     // For admin mints we do not want to enforce the maxBatchSize limit
1504     if (isAdminMint == false) {
1505         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1506     }
1507 
1508     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1509 
1510     AddressData memory addressData = _addressData[to];
1511     _addressData[to] = AddressData(
1512       addressData.balance + uint128(quantity),
1513       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1514     );
1515     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1516 
1517     uint256 updatedIndex = startTokenId;
1518 
1519     for (uint256 i = 0; i < quantity; i++) {
1520       emit Transfer(address(0), to, updatedIndex);
1521       require(
1522         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1523         "ERC721A: transfer to non ERC721Receiver implementer"
1524       );
1525       updatedIndex++;
1526     }
1527 
1528     currentIndex = updatedIndex;
1529     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1530   }
1531 
1532   /**
1533    * @dev Transfers tokenId from from to to.
1534    *
1535    * Requirements:
1536    *
1537    * - to cannot be the zero address.
1538    * - tokenId token must be owned by from.
1539    *
1540    * Emits a {Transfer} event.
1541    */
1542   function _transfer(
1543     address from,
1544     address to,
1545     uint256 tokenId
1546   ) private {
1547     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1548 
1549     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1550       getApproved(tokenId) == _msgSender() ||
1551       isApprovedForAll(prevOwnership.addr, _msgSender()));
1552 
1553     require(
1554       isApprovedOrOwner,
1555       "ERC721A: transfer caller is not owner nor approved"
1556     );
1557 
1558     require(
1559       prevOwnership.addr == from,
1560       "ERC721A: transfer from incorrect owner"
1561     );
1562     require(to != address(0), "ERC721A: transfer to the zero address");
1563 
1564     _beforeTokenTransfers(from, to, tokenId, 1);
1565 
1566     // Clear approvals from the previous owner
1567     _approve(address(0), tokenId, prevOwnership.addr);
1568 
1569     _addressData[from].balance -= 1;
1570     _addressData[to].balance += 1;
1571     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1572 
1573     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1574     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1575     uint256 nextTokenId = tokenId + 1;
1576     if (_ownerships[nextTokenId].addr == address(0)) {
1577       if (_exists(nextTokenId)) {
1578         _ownerships[nextTokenId] = TokenOwnership(
1579           prevOwnership.addr,
1580           prevOwnership.startTimestamp
1581         );
1582       }
1583     }
1584 
1585     emit Transfer(from, to, tokenId);
1586     _afterTokenTransfers(from, to, tokenId, 1);
1587   }
1588 
1589   /**
1590    * @dev Approve to to operate on tokenId
1591    *
1592    * Emits a {Approval} event.
1593    */
1594   function _approve(
1595     address to,
1596     uint256 tokenId,
1597     address owner
1598   ) private {
1599     _tokenApprovals[tokenId] = to;
1600     emit Approval(owner, to, tokenId);
1601   }
1602 
1603   uint256 public nextOwnerToExplicitlySet = 0;
1604 
1605   /**
1606    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1607    */
1608   function _setOwnersExplicit(uint256 quantity) internal {
1609     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1610     require(quantity > 0, "quantity must be nonzero");
1611     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1612 
1613     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1614     if (endIndex > collectionSize - 1) {
1615       endIndex = collectionSize - 1;
1616     }
1617     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1618     require(_exists(endIndex), "not enough minted yet for this cleanup");
1619     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1620       if (_ownerships[i].addr == address(0)) {
1621         TokenOwnership memory ownership = ownershipOf(i);
1622         _ownerships[i] = TokenOwnership(
1623           ownership.addr,
1624           ownership.startTimestamp
1625         );
1626       }
1627     }
1628     nextOwnerToExplicitlySet = endIndex + 1;
1629   }
1630 
1631   /**
1632    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1633    * The call is not executed if the target address is not a contract.
1634    *
1635    * @param from address representing the previous owner of the given token ID
1636    * @param to target address that will receive the tokens
1637    * @param tokenId uint256 ID of the token to be transferred
1638    * @param _data bytes optional data to send along with the call
1639    * @return bool whether the call correctly returned the expected magic value
1640    */
1641   function _checkOnERC721Received(
1642     address from,
1643     address to,
1644     uint256 tokenId,
1645     bytes memory _data
1646   ) private returns (bool) {
1647     if (to.isContract()) {
1648       try
1649         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1650       returns (bytes4 retval) {
1651         return retval == IERC721Receiver(to).onERC721Received.selector;
1652       } catch (bytes memory reason) {
1653         if (reason.length == 0) {
1654           revert("ERC721A: transfer to non ERC721Receiver implementer");
1655         } else {
1656           assembly {
1657             revert(add(32, reason), mload(reason))
1658           }
1659         }
1660       }
1661     } else {
1662       return true;
1663     }
1664   }
1665 
1666   /**
1667    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1668    *
1669    * startTokenId - the first token id to be transferred
1670    * quantity - the amount to be transferred
1671    *
1672    * Calling conditions:
1673    *
1674    * - When from and to are both non-zero, from's tokenId will be
1675    * transferred to to.
1676    * - When from is zero, tokenId will be minted for to.
1677    */
1678   function _beforeTokenTransfers(
1679     address from,
1680     address to,
1681     uint256 startTokenId,
1682     uint256 quantity
1683   ) internal virtual {}
1684 
1685   /**
1686    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1687    * minting.
1688    *
1689    * startTokenId - the first token id to be transferred
1690    * quantity - the amount to be transferred
1691    *
1692    * Calling conditions:
1693    *
1694    * - when from and to are both non-zero.
1695    * - from and to are never both zero.
1696    */
1697   function _afterTokenTransfers(
1698     address from,
1699     address to,
1700     uint256 startTokenId,
1701     uint256 quantity
1702   ) internal virtual {}
1703 }
1704 
1705 abstract contract ProviderFees is Context {
1706   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1707   uint256 public PROVIDER_FEE = 0.000777 ether;  
1708 
1709   function sendProviderFee() internal {
1710     payable(PROVIDER).transfer(PROVIDER_FEE);
1711   }
1712 
1713   function setProviderFee(uint256 _fee) public {
1714     if(_msgSender() != PROVIDER) revert NotMaintainer();
1715     PROVIDER_FEE = _fee;
1716   }
1717 }
1718 
1719 
1720 
1721   
1722   
1723 interface IERC20 {
1724   function allowance(address owner, address spender) external view returns (uint256);
1725   function transfer(address _to, uint256 _amount) external returns (bool);
1726   function balanceOf(address account) external view returns (uint256);
1727   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1728 }
1729 
1730 // File: WithdrawableV2
1731 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1732 // ERC-20 Payouts are limited to a single payout address. This feature 
1733 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1734 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1735 abstract contract WithdrawableV2 is Teams {
1736   struct acceptedERC20 {
1737     bool isActive;
1738     uint256 chargeAmount;
1739   }
1740 
1741   
1742   mapping(address => acceptedERC20) private allowedTokenContracts;
1743   address[] public payableAddresses = [0x556a47b5d128b55892dAdE4999b419D249F468b5];
1744   address public erc20Payable = 0x556a47b5d128b55892dAdE4999b419D249F468b5;
1745   uint256[] public payableFees = [100];
1746   uint256 public payableAddressCount = 1;
1747   bool public onlyERC20MintingMode;
1748   
1749 
1750   function withdrawAll() public onlyTeamOrOwner {
1751       if(address(this).balance == 0) revert ValueCannotBeZero();
1752       _withdrawAll(address(this).balance);
1753   }
1754 
1755   function _withdrawAll(uint256 balance) private {
1756       for(uint i=0; i < payableAddressCount; i++ ) {
1757           _widthdraw(
1758               payableAddresses[i],
1759               (balance * payableFees[i]) / 100
1760           );
1761       }
1762   }
1763   
1764   function _widthdraw(address _address, uint256 _amount) private {
1765       (bool success, ) = _address.call{value: _amount}("");
1766       require(success, "Transfer failed.");
1767   }
1768 
1769   /**
1770   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1771   * in the event ERC-20 tokens are paid to the contract for mints.
1772   * @param _tokenContract contract of ERC-20 token to withdraw
1773   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1774   */
1775   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1776     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1777     IERC20 tokenContract = IERC20(_tokenContract);
1778     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1779     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1780   }
1781 
1782   /**
1783   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1784   * @param _erc20TokenContract address of ERC-20 contract in question
1785   */
1786   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1787     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1788   }
1789 
1790   /**
1791   * @dev get the value of tokens to transfer for user of an ERC-20
1792   * @param _erc20TokenContract address of ERC-20 contract in question
1793   */
1794   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1795     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1796     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1797   }
1798 
1799   /**
1800   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1801   * @param _erc20TokenContract address of ERC-20 contract in question
1802   * @param _isActive default status of if contract should be allowed to accept payments
1803   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1804   */
1805   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1806     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1807     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1808   }
1809 
1810   /**
1811   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1812   * it will assume the default value of zero. This should not be used to create new payment tokens.
1813   * @param _erc20TokenContract address of ERC-20 contract in question
1814   */
1815   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1816     allowedTokenContracts[_erc20TokenContract].isActive = true;
1817   }
1818 
1819   /**
1820   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1821   * it will assume the default value of zero. This should not be used to create new payment tokens.
1822   * @param _erc20TokenContract address of ERC-20 contract in question
1823   */
1824   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1825     allowedTokenContracts[_erc20TokenContract].isActive = false;
1826   }
1827 
1828   /**
1829   * @dev Enable only ERC-20 payments for minting on this contract
1830   */
1831   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1832     onlyERC20MintingMode = true;
1833   }
1834 
1835   /**
1836   * @dev Disable only ERC-20 payments for minting on this contract
1837   */
1838   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1839     onlyERC20MintingMode = false;
1840   }
1841 
1842   /**
1843   * @dev Set the payout of the ERC-20 token payout to a specific address
1844   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1845   */
1846   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1847     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1848     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1849     erc20Payable = _newErc20Payable;
1850   }
1851 }
1852 
1853 
1854   
1855   
1856 /* File: Tippable.sol
1857 /* @dev Allows owner to set strict enforcement of payment to mint price.
1858 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1859 /* when doing a free mint with opt-in pricing.
1860 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1861 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1862 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1863 /* Pros - can take in gratituity payments during a mint. 
1864 /* Cons - However if you decrease pricing during mint txn settlement 
1865 /* it can result in mints landing who technically now have overpaid.
1866 */
1867 abstract contract Tippable is Teams {
1868   bool public strictPricing = true;
1869 
1870   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1871     strictPricing = _newStatus;
1872   }
1873 
1874   // @dev check if msg.value is correct according to pricing enforcement
1875   // @param _msgValue -> passed in msg.value of tx
1876   // @param _expectedPrice -> result of getPrice(...args)
1877   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1878     return strictPricing ? 
1879       _msgValue == _expectedPrice : 
1880       _msgValue >= _expectedPrice;
1881   }
1882 }
1883 
1884   
1885   
1886 // File: EarlyMintIncentive.sol
1887 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1888 // zero fee that can be calculated on the fly.
1889 abstract contract EarlyMintIncentive is Teams, ERC721A, ProviderFees {
1890   uint256 public PRICE = 0.0025 ether;
1891   uint256 public EARLY_MINT_PRICE = 0 ether;
1892   uint256 public earlyMintOwnershipCap = 1;
1893   bool public usingEarlyMintIncentive = true;
1894 
1895   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1896     usingEarlyMintIncentive = true;
1897   }
1898 
1899   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1900     usingEarlyMintIncentive = false;
1901   }
1902 
1903   /**
1904   * @dev Set the max token ID in which the cost incentive will be applied.
1905   * @param _newCap max number of tokens wallet may mint for incentive price
1906   */
1907   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1908     if(_newCap == 0) revert ValueCannotBeZero();
1909     earlyMintOwnershipCap = _newCap;
1910   }
1911 
1912   /**
1913   * @dev Set the incentive mint price
1914   * @param _feeInWei new price per token when in incentive range
1915   */
1916   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1917     EARLY_MINT_PRICE = _feeInWei;
1918   }
1919 
1920   /**
1921   * @dev Set the primary mint price - the base price when not under incentive
1922   * @param _feeInWei new price per token
1923   */
1924   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1925     PRICE = _feeInWei;
1926   }
1927 
1928   /**
1929   * @dev Get the correct price for the mint for qty and person minting
1930   * @param _count amount of tokens to calc for mint
1931   * @param _to the address which will be minting these tokens, passed explicitly
1932   */
1933   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1934     if(_count == 0) revert ValueCannotBeZero();
1935 
1936     // short circuit function if we dont need to even calc incentive pricing
1937     // short circuit if the current wallet mint qty is also already over cap
1938     if(
1939       usingEarlyMintIncentive == false ||
1940       _numberMinted(_to) > earlyMintOwnershipCap
1941     ) {
1942       return (PRICE * _count) + PROVIDER_FEE;
1943     }
1944 
1945     uint256 endingTokenQty = _numberMinted(_to) + _count;
1946     // If qty to mint results in a final qty less than or equal to the cap then
1947     // the entire qty is within incentive mint.
1948     if(endingTokenQty  <= earlyMintOwnershipCap) {
1949       return (EARLY_MINT_PRICE * _count) + PROVIDER_FEE;
1950     }
1951 
1952     // If the current token qty is less than the incentive cap
1953     // and the ending token qty is greater than the incentive cap
1954     // we will be straddling the cap so there will be some amount
1955     // that are incentive and some that are regular fee.
1956     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1957     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1958 
1959     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount) + PROVIDER_FEE;
1960   }
1961 }
1962 
1963   
1964 abstract contract ERC721APlus is 
1965     Ownable,
1966     Teams,
1967     ERC721A,
1968     WithdrawableV2,
1969     ReentrancyGuard 
1970     , EarlyMintIncentive, Tippable 
1971     , Allowlist 
1972     
1973 {
1974   constructor(
1975     string memory tokenName,
1976     string memory tokenSymbol
1977   ) ERC721A(tokenName, tokenSymbol, 25, 1333) { }
1978     uint8 constant public CONTRACT_VERSION = 2;
1979     string public _baseTokenURI = "https://api.cattastic.xyz/";
1980     string public _baseTokenExtension = ".json";
1981 
1982     bool public mintingOpen = false;
1983     
1984     
1985 
1986   
1987     /////////////// Admin Mint Functions
1988     /**
1989      * @dev Mints a token to an address with a tokenURI.
1990      * This is owner only and allows a fee-free drop
1991      * @param _to address of the future owner of the token
1992      * @param _qty amount of tokens to drop the owner
1993      */
1994      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1995          if(_qty == 0) revert MintZeroQuantity();
1996          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1997          _safeMint(_to, _qty, true);
1998      }
1999 
2000   
2001     /////////////// PUBLIC MINT FUNCTIONS
2002     /**
2003     * @dev Mints tokens to an address in batch.
2004     * fee may or may not be required*
2005     * @param _to address of the future owner of the token
2006     * @param _amount number of tokens to mint
2007     */
2008     function mintToMultiple(address _to, uint256 _amount) public payable {
2009         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2010         if(_amount == 0) revert MintZeroQuantity();
2011         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2012         if(!mintingOpen) revert PublicMintClosed();
2013         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2014         
2015         
2016         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2017         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
2018         sendProviderFee();
2019         _safeMint(_to, _amount, false);
2020     }
2021 
2022     /**
2023      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2024      * fee may or may not be required*
2025      * @param _to address of the future owner of the token
2026      * @param _amount number of tokens to mint
2027      * @param _erc20TokenContract erc-20 token contract to mint with
2028      */
2029     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2030       if(_amount == 0) revert MintZeroQuantity();
2031       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2032       if(!mintingOpen) revert PublicMintClosed();
2033       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2034       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2035       
2036       
2037       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2038 
2039       // ERC-20 Specific pre-flight checks
2040       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2041       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2042       IERC20 payableToken = IERC20(_erc20TokenContract);
2043 
2044       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2045       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2046 
2047       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2048       if(!transferComplete) revert ERC20TransferFailed();
2049 
2050       sendProviderFee();
2051       _safeMint(_to, _amount, false);
2052     }
2053 
2054     function openMinting() public onlyTeamOrOwner {
2055         mintingOpen = true;
2056     }
2057 
2058     function stopMinting() public onlyTeamOrOwner {
2059         mintingOpen = false;
2060     }
2061 
2062   
2063     ///////////// ALLOWLIST MINTING FUNCTIONS
2064     /**
2065     * @dev Mints tokens to an address using an allowlist.
2066     * fee may or may not be required*
2067     * @param _to address of the future owner of the token
2068     * @param _amount number of tokens to mint
2069     * @param _merkleProof merkle proof array
2070     */
2071     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2072         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2073         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2074         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2075         if(_amount == 0) revert MintZeroQuantity();
2076         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2077         
2078         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2079         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
2080         
2081 
2082         sendProviderFee();
2083         _safeMint(_to, _amount, false);
2084     }
2085 
2086     /**
2087     * @dev Mints tokens to an address using an allowlist.
2088     * fee may or may not be required*
2089     * @param _to address of the future owner of the token
2090     * @param _amount number of tokens to mint
2091     * @param _merkleProof merkle proof array
2092     * @param _erc20TokenContract erc-20 token contract to mint with
2093     */
2094     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2095       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2096       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2097       if(_amount == 0) revert MintZeroQuantity();
2098       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2099       
2100       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2101       
2102       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2103 
2104       // ERC-20 Specific pre-flight checks
2105       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2106       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2107       IERC20 payableToken = IERC20(_erc20TokenContract);
2108 
2109       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2110       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2111 
2112       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2113       if(!transferComplete) revert ERC20TransferFailed();
2114       
2115       sendProviderFee();
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
2139 
2140   
2141     /**
2142      * @dev Allows owner to set Max mints per tx
2143      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2144      */
2145      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2146          if(_newMaxMint == 0) revert ValueCannotBeZero();
2147          maxBatchSize = _newMaxMint;
2148      }
2149     
2150 
2151   
2152   
2153   
2154   function contractURI() public pure returns (string memory) {
2155     return "https://metadata.mintplex.xyz/L4y93oDEwwEfuBV5H4h6/contract-metadata";
2156   }
2157   
2158 
2159   function _baseURI() internal view virtual override returns(string memory) {
2160     return _baseTokenURI;
2161   }
2162 
2163   function _baseURIExtension() internal view virtual override returns(string memory) {
2164     return _baseTokenExtension;
2165   }
2166 
2167   function baseTokenURI() public view returns(string memory) {
2168     return _baseTokenURI;
2169   }
2170 
2171   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2172     _baseTokenURI = baseURI;
2173   }
2174 
2175   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2176     _baseTokenExtension = baseExtension;
2177   }
2178 }
2179 
2180 
2181   
2182 // File: contracts/CattasticContract.sol
2183 //SPDX-License-Identifier: MIT
2184 
2185 pragma solidity ^0.8.0;
2186 
2187 contract CattasticContract is ERC721APlus {
2188     constructor() ERC721APlus("Cattastic", "Cattastic"){}
2189 }
2190   