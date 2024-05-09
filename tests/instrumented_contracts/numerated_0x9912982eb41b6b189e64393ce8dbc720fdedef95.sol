1 // SPDX-License-Identifier: MIT
2 //-------------DEPENDENCIES--------------------------//
3 
4 // File: @openzeppelin/contracts/utils/Address.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
8 
9 pragma solidity ^0.8.1;
10 
11 /**
12  * @dev Collection of functions related to the address type
13  */
14 library Address {
15     /**
16      * @dev Returns true if account is a contract.
17      *
18      * [IMPORTANT]
19      * ====
20      * It is unsafe to assume that an address for which this function returns
21      * false is an externally-owned account (EOA) and not a contract.
22      *
23      * Among others, isContract will return false for the following
24      * types of addresses:
25      *
26      *  - an externally-owned account
27      *  - a contract in construction
28      *  - an address where a contract will be created
29      *  - an address where a contract lived, but was destroyed
30      * ====
31      *
32      * [IMPORTANT]
33      * ====
34      * You shouldn't rely on isContract to protect against flash loan attacks!
35      *
36      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
37      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
38      * constructor.
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // This method relies on extcodesize/address.code.length, which returns 0
43         // for contracts in construction, since the code is only stored at the end
44         // of the constructor execution.
45 
46         return account.code.length > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's transfer: sends amount wei to
51      * recipient, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by transfer, making them unable to receive funds via
56      * transfer. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to recipient, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         (bool success, ) = recipient.call{value: amount}("");
69         require(success, "Address: unable to send value, recipient may have reverted");
70     }
71 
72     /**
73      * @dev Performs a Solidity function call using a low level call. A
74      * plain call is an unsafe replacement for a function call: use this
75      * function instead.
76      *
77      * If target reverts with a revert reason, it is bubbled up by this
78      * function (like regular Solidity function calls).
79      *
80      * Returns the raw returned data. To convert to the expected return value,
81      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
82      *
83      * Requirements:
84      *
85      * - target must be a contract.
86      * - calling target with data must not revert.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
91         return functionCall(target, data, "Address: low-level call failed");
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
96      * errorMessage as a fallback revert reason when target reverts.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(
101         address target,
102         bytes memory data,
103         string memory errorMessage
104     ) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
110      * but also transferring value wei to target.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least value.
115      * - the called Solidity function must be payable.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(
120         address target,
121         bytes memory data,
122         uint256 value
123     ) internal returns (bytes memory) {
124         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
129      * with errorMessage as a fallback revert reason when target reverts.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(
134         address target,
135         bytes memory data,
136         uint256 value,
137         string memory errorMessage
138     ) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         require(isContract(target), "Address: call to non-contract");
141 
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
153         return functionStaticCall(target, data, "Address: low-level static call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
158      * but performing a static call.
159      *
160      * _Available since v3.3._
161      */
162     function functionStaticCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal view returns (bytes memory) {
167         require(isContract(target), "Address: static call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.delegatecall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
202      * revert reason using the provided one.
203      *
204      * _Available since v4.3._
205      */
206     function verifyCallResult(
207         bool success,
208         bytes memory returndata,
209         string memory errorMessage
210     ) internal pure returns (bytes memory) {
211         if (success) {
212             return returndata;
213         } else {
214             // Look for revert reason and bubble it up if present
215             if (returndata.length > 0) {
216                 // The easiest way to bubble the revert reason is using memory via assembly
217 
218                 assembly {
219                     let returndata_size := mload(returndata)
220                     revert(add(32, returndata), returndata_size)
221                 }
222             } else {
223                 revert(errorMessage);
224             }
225         }
226     }
227 }
228 
229 
230 // File: @openzeppelin/contracts/proxy/utils/Initializable.sol
231 // OpenZeppelin Contracts v4.7.3 (v4.7.3/contracts/proxy/utils/Initializable.sol)
232 
233 abstract contract Initializable {
234     /**
235      * @dev Indicates that the contract has been initialized.
236      * @custom:oz-retyped-from bool
237      */
238     uint8 private _initialized;
239 
240     /**
241      * @dev Indicates that the contract is in the process of being initialized.
242      */
243     bool private _initializing;
244 
245     /**
246      * @dev Triggered when the contract has been initialized or reinitialized.
247      */
248     event Initialized(uint8 version);
249 
250     /**
251      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
252      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
253      */
254     modifier initializer() {
255         bool isTopLevelCall = !_initializing;
256         require(
257             (isTopLevelCall && _initialized < 1) || (!Address.isContract(address(this)) && _initialized == 1),
258             "Initializable: contract is already initialized"
259         );
260         _initialized = 1;
261         if (isTopLevelCall) {
262             _initializing = true;
263         }
264         _;
265         if (isTopLevelCall) {
266             _initializing = false;
267             emit Initialized(1);
268         }
269     }
270 
271     /**
272      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
273      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
274      * used to initialize parent contracts.
275      *
276      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
277      * initialization step. This is essential to configure modules that are added through upgrades and that require
278      * initialization.
279      *
280      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
281      * a contract, executing them in the right order is up to the developer or operator.
282      */
283     modifier reinitializer(uint8 version) {
284         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
285         _initialized = version;
286         _initializing = true;
287         _;
288         _initializing = false;
289         emit Initialized(version);
290     }
291 
292     /**
293      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
294      * {initializer} and {reinitializer} modifiers, directly or indirectly.
295      */
296     modifier onlyInitializing() {
297         require(_initializing, "Initializable: contract is not initializing");
298         _;
299     }
300 
301     /**
302      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
303      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
304      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
305      * through proxies.
306      */
307     function _disableInitializers() internal virtual {
308         require(!_initializing, "Initializable: contract is initializing");
309         if (_initialized < type(uint8).max) {
310             _initialized = type(uint8).max;
311             emit Initialized(type(uint8).max);
312         }
313     }
314 }
315 
316 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @title ERC721 token receiver interface
325  * @dev Interface for any contract that wants to support safeTransfers
326  * from ERC721 asset contracts.
327  */
328 interface IERC721Receiver {
329     /**
330      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
331      * by operator from from, this function is called.
332      *
333      * It must return its Solidity selector to confirm the token transfer.
334      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
335      *
336      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
337      */
338     function onERC721Received(
339         address operator,
340         address from,
341         uint256 tokenId,
342         bytes calldata data
343     ) external returns (bytes4);
344 }
345 
346 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
350 
351 pragma solidity ^0.8.0;
352 
353 /**
354  * @dev Interface of the ERC165 standard, as defined in the
355  * https://eips.ethereum.org/EIPS/eip-165[EIP].
356  *
357  * Implementers can declare support of contract interfaces, which can then be
358  * queried by others ({ERC165Checker}).
359  *
360  * For an implementation, see {ERC165}.
361  */
362 interface IERC165 {
363     /**
364      * @dev Returns true if this contract implements the interface defined by
365      * interfaceId. See the corresponding
366      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
367      * to learn more about how these ids are created.
368      *
369      * This function call must use less than 30 000 gas.
370      */
371     function supportsInterface(bytes4 interfaceId) external view returns (bool);
372 }
373 
374 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
375 
376 
377 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 
382 /**
383  * @dev Implementation of the {IERC165} interface.
384  *
385  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
386  * for the additional interface id that will be supported. For example:
387  *
388  * solidity
389  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
390  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
391  * }
392  * 
393  *
394  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
395  */
396 abstract contract ERC165 is IERC165 {
397     /**
398      * @dev See {IERC165-supportsInterface}.
399      */
400     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401         return interfaceId == type(IERC165).interfaceId;
402     }
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @dev Required interface of an ERC721 compliant contract.
415  */
416 interface IERC721 is IERC165 {
417     /**
418      * @dev Emitted when tokenId token is transferred from from to to.
419      */
420     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
421 
422     /**
423      * @dev Emitted when owner enables approved to manage the tokenId token.
424      */
425     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
426 
427     /**
428      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
429      */
430     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
431 
432     /**
433      * @dev Returns the number of tokens in owner's account.
434      */
435     function balanceOf(address owner) external view returns (uint256 balance);
436 
437     /**
438      * @dev Returns the owner of the tokenId token.
439      *
440      * Requirements:
441      *
442      * - tokenId must exist.
443      */
444     function ownerOf(uint256 tokenId) external view returns (address owner);
445 
446     /**
447      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
448      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
449      *
450      * Requirements:
451      *
452      * - from cannot be the zero address.
453      * - to cannot be the zero address.
454      * - tokenId token must exist and be owned by from.
455      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
456      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
457      *
458      * Emits a {Transfer} event.
459      */
460     function safeTransferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Transfers tokenId token from from to to.
468      *
469      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
470      *
471      * Requirements:
472      *
473      * - from cannot be the zero address.
474      * - to cannot be the zero address.
475      * - tokenId token must be owned by from.
476      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external;
485 
486     /**
487      * @dev Gives permission to to to transfer tokenId token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
491      *
492      * Requirements:
493      *
494      * - The caller must own the token or be an approved operator.
495      * - tokenId must exist.
496      *
497      * Emits an {Approval} event.
498      */
499     function approve(address to, uint256 tokenId) external;
500 
501     /**
502      * @dev Returns the account approved for tokenId token.
503      *
504      * Requirements:
505      *
506      * - tokenId must exist.
507      */
508     function getApproved(uint256 tokenId) external view returns (address operator);
509 
510     /**
511      * @dev Approve or remove operator as an operator for the caller.
512      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
513      *
514      * Requirements:
515      *
516      * - The operator cannot be the caller.
517      *
518      * Emits an {ApprovalForAll} event.
519      */
520     function setApprovalForAll(address operator, bool _approved) external;
521 
522     /**
523      * @dev Returns if the operator is allowed to manage all of the assets of owner.
524      *
525      * See {setApprovalForAll}
526      */
527     function isApprovedForAll(address owner, address operator) external view returns (bool);
528 
529     /**
530      * @dev Safely transfers tokenId token from from to to.
531      *
532      * Requirements:
533      *
534      * - from cannot be the zero address.
535      * - to cannot be the zero address.
536      * - tokenId token must exist and be owned by from.
537      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
538      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
539      *
540      * Emits a {Transfer} event.
541      */
542     function safeTransferFrom(
543         address from,
544         address to,
545         uint256 tokenId,
546         bytes calldata data
547     ) external;
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
551 
552 
553 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
560  * @dev See https://eips.ethereum.org/EIPS/eip-721
561  */
562 interface IERC721Enumerable is IERC721 {
563     /**
564      * @dev Returns the total amount of tokens stored by the contract.
565      */
566     function totalSupply() external view returns (uint256);
567 
568     /**
569      * @dev Returns a token ID owned by owner at a given index of its token list.
570      * Use along with {balanceOf} to enumerate all of owner's tokens.
571      */
572     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
573 
574     /**
575      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
576      * Use along with {totalSupply} to enumerate all tokens.
577      */
578     function tokenByIndex(uint256 index) external view returns (uint256);
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
591  * @dev See https://eips.ethereum.org/EIPS/eip-721
592  */
593 interface IERC721Metadata is IERC721 {
594     /**
595      * @dev Returns the token collection name.
596      */
597     function name() external view returns (string memory);
598 
599     /**
600      * @dev Returns the token collection symbol.
601      */
602     function symbol() external view returns (string memory);
603 
604     /**
605      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
606      */
607     function tokenURI(uint256 tokenId) external view returns (string memory);
608 }
609 
610 // File: @openzeppelin/contracts/utils/Strings.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 /**
618  * @dev String operations.
619  */
620 library Strings {
621     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
622 
623     /**
624      * @dev Converts a uint256 to its ASCII string decimal representation.
625      */
626     function toString(uint256 value) internal pure returns (string memory) {
627         // Inspired by OraclizeAPI's implementation - MIT licence
628         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
629 
630         if (value == 0) {
631             return "0";
632         }
633         uint256 temp = value;
634         uint256 digits;
635         while (temp != 0) {
636             digits++;
637             temp /= 10;
638         }
639         bytes memory buffer = new bytes(digits);
640         while (value != 0) {
641             digits -= 1;
642             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
643             value /= 10;
644         }
645         return string(buffer);
646     }
647 
648     /**
649      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
650      */
651     function toHexString(uint256 value) internal pure returns (string memory) {
652         if (value == 0) {
653             return "0x00";
654         }
655         uint256 temp = value;
656         uint256 length = 0;
657         while (temp != 0) {
658             length++;
659             temp >>= 8;
660         }
661         return toHexString(value, length);
662     }
663 
664     /**
665      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
666      */
667     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
668         bytes memory buffer = new bytes(2 * length + 2);
669         buffer[0] = "0";
670         buffer[1] = "x";
671         for (uint256 i = 2 * length + 1; i > 1; --i) {
672             buffer[i] = _HEX_SYMBOLS[value & 0xf];
673             value >>= 4;
674         }
675         require(value == 0, "Strings: hex length insufficient");
676         return string(buffer);
677     }
678 }
679 
680 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
681 
682 
683 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
684 
685 pragma solidity ^0.8.0;
686 
687 /**
688  * @dev Contract module that helps prevent reentrant calls to a function.
689  *
690  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
691  * available, which can be applied to functions to make sure there are no nested
692  * (reentrant) calls to them.
693  *
694  * Note that because there is a single nonReentrant guard, functions marked as
695  * nonReentrant may not call one another. This can be worked around by making
696  * those functions private, and then adding external nonReentrant entry
697  * points to them.
698  *
699  * TIP: If you would like to learn more about reentrancy and alternative ways
700  * to protect against it, check out our blog post
701  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
702  */
703 abstract contract ReentrancyGuard {
704     // Booleans are more expensive than uint256 or any type that takes up a full
705     // word because each write operation emits an extra SLOAD to first read the
706     // slot's contents, replace the bits taken up by the boolean, and then write
707     // back. This is the compiler's defense against contract upgrades and
708     // pointer aliasing, and it cannot be disabled.
709 
710     // The values being non-zero value makes deployment a bit more expensive,
711     // but in exchange the refund on every call to nonReentrant will be lower in
712     // amount. Since refunds are capped to a percentage of the total
713     // transaction's gas, it is best to keep them low in cases like this one, to
714     // increase the likelihood of the full refund coming into effect.
715     uint256 private constant _NOT_ENTERED = 1;
716     uint256 private constant _ENTERED = 2;
717 
718     uint256 private _status;
719 
720     constructor() {
721         _status = _NOT_ENTERED;
722     }
723 
724     /**
725      * @dev Prevents a contract from calling itself, directly or indirectly.
726      * Calling a nonReentrant function from another nonReentrant
727      * function is not supported. It is possible to prevent this from happening
728      * by making the nonReentrant function external, and making it call a
729      * private function that does the actual work.
730      */
731     modifier nonReentrant() {
732         // On the first call to nonReentrant, _notEntered will be true
733         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
734 
735         // Any calls to nonReentrant after this point will fail
736         _status = _ENTERED;
737 
738         _;
739 
740         // By storing the original value once again, a refund is triggered (see
741         // https://eips.ethereum.org/EIPS/eip-2200)
742         _status = _NOT_ENTERED;
743     }
744 }
745 
746 // File: @openzeppelin/contracts/utils/Context.sol
747 
748 
749 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 /**
754  * @dev Provides information about the current execution context, including the
755  * sender of the transaction and its data. While these are generally available
756  * via msg.sender and msg.data, they should not be accessed in such a direct
757  * manner, since when dealing with meta-transactions the account sending and
758  * paying for execution may not be the actual sender (as far as an application
759  * is concerned).
760  *
761  * This contract is only required for intermediate, library-like contracts.
762  */
763 abstract contract Context {
764     function _msgSender() internal view virtual returns (address) {
765         return msg.sender;
766     }
767 
768     function _msgData() internal view virtual returns (bytes calldata) {
769         return msg.data;
770     }
771 }
772 
773 // File: @openzeppelin/contracts/access/Ownable.sol
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 
781 /**
782  * @dev Contract module which provides a basic access control mechanism, where
783  * there is an account (an owner) that can be granted exclusive access to
784  * specific functions.
785  *
786  * By default, the owner account will be the one that deploys the contract. This
787  * can later be changed with {transferOwnership}.
788  *
789  * This module is used through inheritance. It will make available the modifier
790  * onlyOwner, which can be applied to your functions to restrict their use to
791  * the owner.
792  */
793 abstract contract Ownable is Context {
794     address private _owner;
795 
796     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
797 
798     /**
799      * @dev Initializes the contract setting the deployer as the initial owner.
800      */
801     constructor() {
802         _transferOwnership(_msgSender());
803     }
804 
805     /**
806      * @dev Returns the address of the current owner.
807      */
808     function owner() public view virtual returns (address) {
809         return _owner;
810     }
811 
812     /**
813      * @dev Throws if called by any account other than the owner.
814      */
815     function _onlyOwner() private view {
816        require(owner() == _msgSender(), "Ownable: caller is not the owner");
817     }
818 
819     modifier onlyOwner() {
820         _onlyOwner();
821         _;
822     }
823 
824     /**
825      * @dev Leaves the contract without owner. It will not be possible to call
826      * onlyOwner functions anymore. Can only be called by the current owner.
827      *
828      * NOTE: Renouncing ownership will leave the contract without an owner,
829      * thereby removing any functionality that is only available to the owner.
830      */
831     function renounceOwnership() public virtual onlyOwner {
832         _transferOwnership(address(0));
833     }
834 
835     /**
836      * @dev Transfers ownership of the contract to a new account (newOwner).
837      * Can only be called by the current owner.
838      */
839     function transferOwnership(address newOwner) public virtual onlyOwner {
840         require(newOwner != address(0), "Ownable: new owner is the zero address");
841         _transferOwnership(newOwner);
842     }
843 
844     /**
845      * @dev Transfers ownership of the contract to a new account (newOwner).
846      * Internal function without access restriction.
847      */
848     function _transferOwnership(address newOwner) internal virtual {
849         address oldOwner = _owner;
850         _owner = newOwner;
851         emit OwnershipTransferred(oldOwner, newOwner);
852     }
853 }
854 
855 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
856 pragma solidity ^0.8.9;
857 
858 interface IOperatorFilterRegistry {
859     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
860     function register(address registrant) external;
861     function registerAndSubscribe(address registrant, address subscription) external;
862     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
863     function updateOperator(address registrant, address operator, bool filtered) external;
864     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
865     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
866     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
867     function subscribe(address registrant, address registrantToSubscribe) external;
868     function unsubscribe(address registrant, bool copyExistingEntries) external;
869     function subscriptionOf(address addr) external returns (address registrant);
870     function subscribers(address registrant) external returns (address[] memory);
871     function subscriberAt(address registrant, uint256 index) external returns (address);
872     function copyEntriesOf(address registrant, address registrantToCopy) external;
873     function isOperatorFiltered(address registrant, address operator) external returns (bool);
874     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
875     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
876     function filteredOperators(address addr) external returns (address[] memory);
877     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
878     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
879     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
880     function isRegistered(address addr) external returns (bool);
881     function codeHashOf(address addr) external returns (bytes32);
882 }
883 
884 // File contracts/OperatorFilter/OperatorFilterer.sol
885 pragma solidity ^0.8.9;
886 
887 abstract contract OperatorFilterer {
888     error OperatorNotAllowed(address operator);
889 
890     IOperatorFilterRegistry constant operatorFilterRegistry =
891         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
892 
893     constructor() {}
894     function _init(address subscriptionOrRegistrantToCopy, bool subscribe) internal {
895         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
896         // will not revert, but the contract will need to be registered with the registry once it is deployed in
897         // order for the modifier to filter addresses.
898         if (address(operatorFilterRegistry).code.length > 0) {
899             if (subscribe) {
900                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
901             } else {
902                 if (subscriptionOrRegistrantToCopy != address(0)) {
903                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
904                 } else {
905                     operatorFilterRegistry.register(address(this));
906                 }
907             }
908         }
909     }
910 
911     function _onlyAllowedOperator(address from) private view {
912       if (
913           !(
914               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
915               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
916           )
917       ) {
918           revert OperatorNotAllowed(msg.sender);
919       }
920     }
921 
922     modifier onlyAllowedOperator(address from) virtual {
923         // Check registry code length to facilitate testing in environments without a deployed registry.
924         if (address(operatorFilterRegistry).code.length > 0) {
925             // Allow spending tokens from addresses with balance
926             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
927             // from an EOA.
928             if (from == msg.sender) {
929                 _;
930                 return;
931             }
932             _onlyAllowedOperator(from);
933         }
934         _;
935     }
936 
937     modifier onlyAllowedOperatorApproval(address operator) virtual {
938         _checkFilterOperator(operator);
939         _;
940     }
941 
942     function _checkFilterOperator(address operator) internal view virtual {
943         // Check registry code length to facilitate testing in environments without a deployed registry.
944         if (address(operatorFilterRegistry).code.length > 0) {
945             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
946                 revert OperatorNotAllowed(operator);
947             }
948         }
949     }
950 }
951 
952 //-------------END DEPENDENCIES------------------------//
953 
954 
955   
956 error TransactionCapExceeded();
957 error PublicMintingClosed();
958 error ExcessiveOwnedMints();
959 error MintZeroQuantity();
960 error InvalidPayment();
961 error CapExceeded();
962 error IsAlreadyUnveiled();
963 error ValueCannotBeZero();
964 error CannotBeNullAddress();
965 error NoStateChange();
966 
967 error PublicMintClosed();
968 error AllowlistMintClosed();
969 
970 error AddressNotAllowlisted();
971 error AllowlistDropTimeHasNotPassed();
972 error PublicDropTimeHasNotPassed();
973 error DropTimeNotInFuture();
974 
975 error OnlyERC20MintingEnabled();
976 error ERC20TokenNotApproved();
977 error ERC20InsufficientBalance();
978 error ERC20InsufficientAllowance();
979 error ERC20TransferFailed();
980 
981 error ClaimModeDisabled();
982 error IneligibleRedemptionContract();
983 error TokenAlreadyRedeemed();
984 error InvalidOwnerForRedemption();
985 error InvalidApprovalForRedemption();
986 
987 error ERC721RestrictedApprovalAddressRestricted();
988 error NotMaintainer();
989 error PayablePayoutMisMatch();
990 error PayoutsNot100();
991   
992   
993 // Rampp Contracts v2.1 (Teams.sol)
994 
995 error InvalidTeamAddress();
996 error DuplicateTeamAddress();
997 pragma solidity ^0.8.0;
998 
999 /**
1000 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
1001 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
1002 * This will easily allow cross-collaboration via Mintplex.xyz.
1003 **/
1004 abstract contract Teams is Ownable{
1005   mapping (address => bool) internal team;
1006 
1007   /**
1008   * @dev Adds an address to the team. Allows them to execute protected functions
1009   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
1010   **/
1011   function addToTeam(address _address) public onlyOwner {
1012     if(_address == address(0)) revert InvalidTeamAddress();
1013     if(inTeam(_address)) revert DuplicateTeamAddress();
1014   
1015     team[_address] = true;
1016   }
1017 
1018   /**
1019   * @dev Removes an address to the team.
1020   * @param _address the ETH address to remove, cannot be 0x and must be in team
1021   **/
1022   function removeFromTeam(address _address) public onlyOwner {
1023     if(_address == address(0)) revert InvalidTeamAddress();
1024     if(!inTeam(_address)) revert InvalidTeamAddress();
1025   
1026     team[_address] = false;
1027   }
1028 
1029   /**
1030   * @dev Check if an address is valid and active in the team
1031   * @param _address ETH address to check for truthiness
1032   **/
1033   function inTeam(address _address)
1034     public
1035     view
1036     returns (bool)
1037   {
1038     if(_address == address(0)) revert InvalidTeamAddress();
1039     return team[_address] == true;
1040   }
1041 
1042   /**
1043   * @dev Throws if called by any account other than the owner or team member.
1044   */
1045   function _onlyTeamOrOwner() private view {
1046     bool _isOwner = owner() == _msgSender();
1047     bool _isTeam = inTeam(_msgSender());
1048     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
1049   }
1050 
1051   modifier onlyTeamOrOwner() {
1052     _onlyTeamOrOwner();
1053     _;
1054   }
1055 }
1056 
1057 
1058   
1059   pragma solidity ^0.8.0;
1060 
1061   /**
1062   * @dev These functions deal with verification of Merkle Trees proofs.
1063   *
1064   * The proofs can be generated using the JavaScript library
1065   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1066   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1067   *
1068   *
1069   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1070   * hashing, or use a hash function other than keccak256 for hashing leaves.
1071   * This is because the concatenation of a sorted pair of internal nodes in
1072   * the merkle tree could be reinterpreted as a leaf value.
1073   */
1074   library MerkleProof {
1075       /**
1076       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1077       * defined by 'root'. For this, a 'proof' must be provided, containing
1078       * sibling hashes on the branch from the leaf to the root of the tree. Each
1079       * pair of leaves and each pair of pre-images are assumed to be sorted.
1080       */
1081       function verify(
1082           bytes32[] memory proof,
1083           bytes32 root,
1084           bytes32 leaf
1085       ) internal pure returns (bool) {
1086           return processProof(proof, leaf) == root;
1087       }
1088 
1089       /**
1090       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1091       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1092       * hash matches the root of the tree. When processing the proof, the pairs
1093       * of leafs & pre-images are assumed to be sorted.
1094       *
1095       * _Available since v4.4._
1096       */
1097       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1098           bytes32 computedHash = leaf;
1099           for (uint256 i = 0; i < proof.length; i++) {
1100               bytes32 proofElement = proof[i];
1101               if (computedHash <= proofElement) {
1102                   // Hash(current computed hash + current element of the proof)
1103                   computedHash = _efficientHash(computedHash, proofElement);
1104               } else {
1105                   // Hash(current element of the proof + current computed hash)
1106                   computedHash = _efficientHash(proofElement, computedHash);
1107               }
1108           }
1109           return computedHash;
1110       }
1111 
1112       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1113           assembly {
1114               mstore(0x00, a)
1115               mstore(0x20, b)
1116               value := keccak256(0x00, 0x40)
1117           }
1118       }
1119   }
1120 
1121 
1122   // File: Allowlist.sol
1123 
1124   pragma solidity ^0.8.0;
1125 
1126   abstract contract Allowlist is Teams {
1127     bytes32 public merkleRoot;
1128     bool public onlyAllowlistMode;
1129 
1130     /**
1131      * @dev Update merkle root to reflect changes in Allowlist
1132      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1133      */
1134     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1135       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1136       merkleRoot = _newMerkleRoot;
1137     }
1138 
1139     /**
1140      * @dev Check the proof of an address if valid for merkle root
1141      * @param _to address to check for proof
1142      * @param _merkleProof Proof of the address to validate against root and leaf
1143      */
1144     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1145       if(merkleRoot == 0) revert ValueCannotBeZero();
1146       bytes32 leaf = keccak256(abi.encodePacked(_to));
1147 
1148       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1149     }
1150 
1151     
1152     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1153       onlyAllowlistMode = true;
1154     }
1155 
1156     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1157         onlyAllowlistMode = false;
1158     }
1159   }
1160   
1161   
1162 /**
1163  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1164  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1165  *
1166  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1167  * 
1168  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1169  *
1170  * Does not support burning tokens to address(0).
1171  */
1172 abstract contract ERC721A is
1173   Context,
1174   ERC165,
1175   IERC721,
1176   IERC721Metadata,
1177   IERC721Enumerable,
1178   Teams,
1179   OperatorFilterer
1180 {
1181   using Address for address;
1182   using Strings for uint256;
1183 
1184   struct TokenOwnership {
1185     address addr;
1186     uint64 startTimestamp;
1187   }
1188 
1189   struct AddressData {
1190     uint128 balance;
1191     uint128 numberMinted;
1192   }
1193 
1194   uint256 private currentIndex;
1195 
1196   uint256 public collectionSize;
1197   uint256 public maxBatchSize;
1198 
1199   // Token name
1200   string private _name;
1201 
1202   // Token symbol
1203   string private _symbol;
1204 
1205   // Mapping from token ID to ownership details
1206   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1207   mapping(uint256 => TokenOwnership) private _ownerships;
1208 
1209   // Mapping owner address to address data
1210   mapping(address => AddressData) private _addressData;
1211 
1212   // Mapping from token ID to approved address
1213   mapping(uint256 => address) private _tokenApprovals;
1214 
1215   // Mapping from owner to operator approvals
1216   mapping(address => mapping(address => bool)) private _operatorApprovals;
1217 
1218   /* @dev Mapping of restricted operator approvals set by contract Owner
1219   * This serves as an optional addition to ERC-721 so
1220   * that the contract owner can elect to prevent specific addresses/contracts
1221   * from being marked as the approver for a token. The reason for this
1222   * is that some projects may want to retain control of where their tokens can/can not be listed
1223   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1224   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1225   */
1226   mapping(address => bool) public restrictedApprovalAddresses;
1227 
1228   /**
1229    * @dev
1230    * maxBatchSize refers to how much a minter can mint at a time.
1231    * collectionSize_ refers to how many tokens are in the collection.
1232    */
1233    constructor(){}
1234    function _init(
1235     string memory name_,
1236     string memory symbol_,
1237     uint256 maxBatchSize_,
1238     uint256 collectionSize_
1239   ) internal {
1240     require(
1241       collectionSize_ > 0,
1242       "ERC721A: collection must have a nonzero supply"
1243     );
1244     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1245     _name = name_;
1246     _symbol = symbol_;
1247     maxBatchSize = maxBatchSize_;
1248     collectionSize = collectionSize_;
1249     currentIndex = _startTokenId();
1250     OperatorFilterer._init(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true);
1251   }
1252 
1253   /**
1254   * To change the starting tokenId, please override this function.
1255   */
1256   function _startTokenId() internal view virtual returns (uint256) {
1257     return 1;
1258   }
1259 
1260   /**
1261    * @dev See {IERC721Enumerable-totalSupply}.
1262    */
1263   function totalSupply() public view override returns (uint256) {
1264     return _totalMinted();
1265   }
1266 
1267   function currentTokenId() public view returns (uint256) {
1268     return _totalMinted();
1269   }
1270 
1271   function getNextTokenId() public view returns (uint256) {
1272       return _totalMinted() + 1;
1273   }
1274 
1275   /**
1276   * Returns the total amount of tokens minted in the contract.
1277   */
1278   function _totalMinted() internal view returns (uint256) {
1279     unchecked {
1280       return currentIndex - _startTokenId();
1281     }
1282   }
1283 
1284   /**
1285    * @dev See {IERC721Enumerable-tokenByIndex}.
1286    */
1287   function tokenByIndex(uint256 index) public view override returns (uint256) {
1288     require(index < totalSupply(), "ERC721A: global index out of bounds");
1289     return index;
1290   }
1291 
1292   /**
1293    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1294    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1295    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1296    */
1297   function tokenOfOwnerByIndex(address owner, uint256 index)
1298     public
1299     view
1300     override
1301     returns (uint256)
1302   {
1303     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1304     uint256 numMintedSoFar = totalSupply();
1305     uint256 tokenIdsIdx = 0;
1306     address currOwnershipAddr = address(0);
1307     for (uint256 i = 0; i < numMintedSoFar; i++) {
1308       TokenOwnership memory ownership = _ownerships[i];
1309       if (ownership.addr != address(0)) {
1310         currOwnershipAddr = ownership.addr;
1311       }
1312       if (currOwnershipAddr == owner) {
1313         if (tokenIdsIdx == index) {
1314           return i;
1315         }
1316         tokenIdsIdx++;
1317       }
1318     }
1319     revert("ERC721A: unable to get token of owner by index");
1320   }
1321 
1322   /**
1323    * @dev See {IERC165-supportsInterface}.
1324    */
1325   function supportsInterface(bytes4 interfaceId)
1326     public
1327     view
1328     virtual
1329     override(ERC165, IERC165)
1330     returns (bool)
1331   {
1332     return
1333       interfaceId == type(IERC721).interfaceId ||
1334       interfaceId == type(IERC721Metadata).interfaceId ||
1335       interfaceId == type(IERC721Enumerable).interfaceId ||
1336       super.supportsInterface(interfaceId);
1337   }
1338 
1339   /**
1340    * @dev See {IERC721-balanceOf}.
1341    */
1342   function balanceOf(address owner) public view override returns (uint256) {
1343     require(owner != address(0), "ERC721A: balance query for the zero address");
1344     return uint256(_addressData[owner].balance);
1345   }
1346 
1347   function _numberMinted(address owner) internal view returns (uint256) {
1348     require(
1349       owner != address(0),
1350       "ERC721A: number minted query for the zero address"
1351     );
1352     return uint256(_addressData[owner].numberMinted);
1353   }
1354 
1355   function ownershipOf(uint256 tokenId)
1356     internal
1357     view
1358     returns (TokenOwnership memory)
1359   {
1360     uint256 curr = tokenId;
1361 
1362     unchecked {
1363         if (_startTokenId() <= curr && curr < currentIndex) {
1364             TokenOwnership memory ownership = _ownerships[curr];
1365             if (ownership.addr != address(0)) {
1366                 return ownership;
1367             }
1368 
1369             // Invariant:
1370             // There will always be an ownership that has an address and is not burned
1371             // before an ownership that does not have an address and is not burned.
1372             // Hence, curr will not underflow.
1373             while (true) {
1374                 curr--;
1375                 ownership = _ownerships[curr];
1376                 if (ownership.addr != address(0)) {
1377                     return ownership;
1378                 }
1379             }
1380         }
1381     }
1382 
1383     revert("ERC721A: unable to determine the owner of token");
1384   }
1385 
1386   /**
1387    * @dev See {IERC721-ownerOf}.
1388    */
1389   function ownerOf(uint256 tokenId) public view override returns (address) {
1390     return ownershipOf(tokenId).addr;
1391   }
1392 
1393   /**
1394    * @dev See {IERC721Metadata-name}.
1395    */
1396   function name() public view virtual override returns (string memory) {
1397     return _name;
1398   }
1399 
1400   /**
1401    * @dev See {IERC721Metadata-symbol}.
1402    */
1403   function symbol() public view virtual override returns (string memory) {
1404     return _symbol;
1405   }
1406 
1407   /**
1408    * @dev See {IERC721Metadata-tokenURI}.
1409    */
1410   function tokenURI(uint256 tokenId)
1411     public
1412     view
1413     virtual
1414     override
1415     returns (string memory)
1416   {
1417     string memory baseURI = _baseURI();
1418     string memory extension = _baseURIExtension();
1419     return
1420       bytes(baseURI).length > 0
1421         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1422         : "";
1423   }
1424 
1425   /**
1426    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1427    * token will be the concatenation of the baseURI and the tokenId. Empty
1428    * by default, can be overriden in child contracts.
1429    */
1430   function _baseURI() internal view virtual returns (string memory) {
1431     return "";
1432   }
1433 
1434   /**
1435    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1436    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1437    * by default, can be overriden in child contracts.
1438    */
1439   function _baseURIExtension() internal view virtual returns (string memory) {
1440     return "";
1441   }
1442 
1443   /**
1444    * @dev Sets the value for an address to be in the restricted approval address pool.
1445    * Setting an address to true will disable token owners from being able to mark the address
1446    * for approval for trading. This would be used in theory to prevent token owners from listing
1447    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1448    * @param _address the marketplace/user to modify restriction status of
1449    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1450    */
1451   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1452     restrictedApprovalAddresses[_address] = _isRestricted;
1453   }
1454 
1455   /**
1456    * @dev See {IERC721-approve}.
1457    */
1458   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1459     address owner = ERC721A.ownerOf(tokenId);
1460     require(to != owner, "ERC721A: approval to current owner");
1461     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1462 
1463     require(
1464       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1465       "ERC721A: approve caller is not owner nor approved for all"
1466     );
1467 
1468     _approve(to, tokenId, owner);
1469   }
1470 
1471   /**
1472    * @dev See {IERC721-getApproved}.
1473    */
1474   function getApproved(uint256 tokenId) public view override returns (address) {
1475     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1476 
1477     return _tokenApprovals[tokenId];
1478   }
1479 
1480   /**
1481    * @dev See {IERC721-setApprovalForAll}.
1482    */
1483   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1484     require(operator != _msgSender(), "ERC721A: approve to caller");
1485     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1486 
1487     _operatorApprovals[_msgSender()][operator] = approved;
1488     emit ApprovalForAll(_msgSender(), operator, approved);
1489   }
1490 
1491   /**
1492    * @dev See {IERC721-isApprovedForAll}.
1493    */
1494   function isApprovedForAll(address owner, address operator)
1495     public
1496     view
1497     virtual
1498     override
1499     returns (bool)
1500   {
1501     return _operatorApprovals[owner][operator];
1502   }
1503 
1504   /**
1505    * @dev See {IERC721-transferFrom}.
1506    */
1507   function transferFrom(
1508     address from,
1509     address to,
1510     uint256 tokenId
1511   ) public override onlyAllowedOperator(from) {
1512     _transfer(from, to, tokenId);
1513   }
1514 
1515   /**
1516    * @dev See {IERC721-safeTransferFrom}.
1517    */
1518   function safeTransferFrom(
1519     address from,
1520     address to,
1521     uint256 tokenId
1522   ) public override onlyAllowedOperator(from) {
1523     safeTransferFrom(from, to, tokenId, "");
1524   }
1525 
1526   /**
1527    * @dev See {IERC721-safeTransferFrom}.
1528    */
1529   function safeTransferFrom(
1530     address from,
1531     address to,
1532     uint256 tokenId,
1533     bytes memory _data
1534   ) public override onlyAllowedOperator(from) {
1535     _transfer(from, to, tokenId);
1536     require(
1537       _checkOnERC721Received(from, to, tokenId, _data),
1538       "ERC721A: transfer to non ERC721Receiver implementer"
1539     );
1540   }
1541 
1542   /**
1543    * @dev Returns whether tokenId exists.
1544    *
1545    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1546    *
1547    * Tokens start existing when they are minted (_mint),
1548    */
1549   function _exists(uint256 tokenId) internal view returns (bool) {
1550     return _startTokenId() <= tokenId && tokenId < currentIndex;
1551   }
1552 
1553   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1554     _safeMint(to, quantity, isAdminMint, "");
1555   }
1556 
1557   /**
1558    * @dev Mints quantity tokens and transfers them to to.
1559    *
1560    * Requirements:
1561    *
1562    * - there must be quantity tokens remaining unminted in the total collection.
1563    * - to cannot be the zero address.
1564    * - quantity cannot be larger than the max batch size.
1565    *
1566    * Emits a {Transfer} event.
1567    */
1568   function _safeMint(
1569     address to,
1570     uint256 quantity,
1571     bool isAdminMint,
1572     bytes memory _data
1573   ) internal {
1574     uint256 startTokenId = currentIndex;
1575     require(to != address(0), "ERC721A: mint to the zero address");
1576     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1577     require(!_exists(startTokenId), "ERC721A: token already minted");
1578 
1579     // For admin mints we do not want to enforce the maxBatchSize limit
1580     if (isAdminMint == false) {
1581         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1582     }
1583 
1584     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1585 
1586     AddressData memory addressData = _addressData[to];
1587     _addressData[to] = AddressData(
1588       addressData.balance + uint128(quantity),
1589       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1590     );
1591     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1592 
1593     uint256 updatedIndex = startTokenId;
1594 
1595     for (uint256 i = 0; i < quantity; i++) {
1596       emit Transfer(address(0), to, updatedIndex);
1597       require(
1598         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1599         "ERC721A: transfer to non ERC721Receiver implementer"
1600       );
1601       updatedIndex++;
1602     }
1603 
1604     currentIndex = updatedIndex;
1605     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1606   }
1607 
1608   /**
1609    * @dev Transfers tokenId from from to to.
1610    *
1611    * Requirements:
1612    *
1613    * - to cannot be the zero address.
1614    * - tokenId token must be owned by from.
1615    *
1616    * Emits a {Transfer} event.
1617    */
1618   function _transfer(
1619     address from,
1620     address to,
1621     uint256 tokenId
1622   ) private {
1623     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1624 
1625     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1626       getApproved(tokenId) == _msgSender() ||
1627       isApprovedForAll(prevOwnership.addr, _msgSender()));
1628 
1629     require(
1630       isApprovedOrOwner,
1631       "ERC721A: transfer caller is not owner nor approved"
1632     );
1633 
1634     require(
1635       prevOwnership.addr == from,
1636       "ERC721A: transfer from incorrect owner"
1637     );
1638     require(to != address(0), "ERC721A: transfer to the zero address");
1639 
1640     _beforeTokenTransfers(from, to, tokenId, 1);
1641 
1642     // Clear approvals from the previous owner
1643     _approve(address(0), tokenId, prevOwnership.addr);
1644 
1645     _addressData[from].balance -= 1;
1646     _addressData[to].balance += 1;
1647     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1648 
1649     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1650     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1651     uint256 nextTokenId = tokenId + 1;
1652     if (_ownerships[nextTokenId].addr == address(0)) {
1653       if (_exists(nextTokenId)) {
1654         _ownerships[nextTokenId] = TokenOwnership(
1655           prevOwnership.addr,
1656           prevOwnership.startTimestamp
1657         );
1658       }
1659     }
1660 
1661     emit Transfer(from, to, tokenId);
1662     _afterTokenTransfers(from, to, tokenId, 1);
1663   }
1664 
1665   /**
1666    * @dev Approve to to operate on tokenId
1667    *
1668    * Emits a {Approval} event.
1669    */
1670   function _approve(
1671     address to,
1672     uint256 tokenId,
1673     address owner
1674   ) private {
1675     _tokenApprovals[tokenId] = to;
1676     emit Approval(owner, to, tokenId);
1677   }
1678 
1679   uint256 public nextOwnerToExplicitlySet = 0;
1680 
1681   /**
1682    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1683    */
1684   function _setOwnersExplicit(uint256 quantity) internal {
1685     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1686     require(quantity > 0, "quantity must be nonzero");
1687     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1688 
1689     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1690     if (endIndex > collectionSize - 1) {
1691       endIndex = collectionSize - 1;
1692     }
1693     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1694     require(_exists(endIndex), "not enough minted yet for this cleanup");
1695     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1696       if (_ownerships[i].addr == address(0)) {
1697         TokenOwnership memory ownership = ownershipOf(i);
1698         _ownerships[i] = TokenOwnership(
1699           ownership.addr,
1700           ownership.startTimestamp
1701         );
1702       }
1703     }
1704     nextOwnerToExplicitlySet = endIndex + 1;
1705   }
1706 
1707   /**
1708    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1709    * The call is not executed if the target address is not a contract.
1710    *
1711    * @param from address representing the previous owner of the given token ID
1712    * @param to target address that will receive the tokens
1713    * @param tokenId uint256 ID of the token to be transferred
1714    * @param _data bytes optional data to send along with the call
1715    * @return bool whether the call correctly returned the expected magic value
1716    */
1717   function _checkOnERC721Received(
1718     address from,
1719     address to,
1720     uint256 tokenId,
1721     bytes memory _data
1722   ) private returns (bool) {
1723     if (to.isContract()) {
1724       try
1725         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1726       returns (bytes4 retval) {
1727         return retval == IERC721Receiver(to).onERC721Received.selector;
1728       } catch (bytes memory reason) {
1729         if (reason.length == 0) {
1730           revert("ERC721A: transfer to non ERC721Receiver implementer");
1731         } else {
1732           assembly {
1733             revert(add(32, reason), mload(reason))
1734           }
1735         }
1736       }
1737     } else {
1738       return true;
1739     }
1740   }
1741 
1742   /**
1743    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1744    *
1745    * startTokenId - the first token id to be transferred
1746    * quantity - the amount to be transferred
1747    *
1748    * Calling conditions:
1749    *
1750    * - When from and to are both non-zero, from's tokenId will be
1751    * transferred to to.
1752    * - When from is zero, tokenId will be minted for to.
1753    */
1754   function _beforeTokenTransfers(
1755     address from,
1756     address to,
1757     uint256 startTokenId,
1758     uint256 quantity
1759   ) internal virtual {}
1760 
1761   /**
1762    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1763    * minting.
1764    *
1765    * startTokenId - the first token id to be transferred
1766    * quantity - the amount to be transferred
1767    *
1768    * Calling conditions:
1769    *
1770    * - when from and to are both non-zero.
1771    * - from and to are never both zero.
1772    */
1773   function _afterTokenTransfers(
1774     address from,
1775     address to,
1776     uint256 startTokenId,
1777     uint256 quantity
1778   ) internal virtual {}
1779 }
1780 
1781 abstract contract ProviderFees is Context {
1782   address private PROVIDER;
1783   uint256 public PROVIDER_FEE;
1784   
1785   constructor() {}
1786   function init() internal {
1787     PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1788     PROVIDER_FEE = 0.000777 ether;
1789   }
1790 
1791   function sendProviderFee() internal {
1792     payable(PROVIDER).transfer(PROVIDER_FEE);
1793   }
1794 
1795   function setProviderFee(uint256 _fee) public {
1796     if(_msgSender() != PROVIDER) revert NotMaintainer();
1797     PROVIDER_FEE = _fee;
1798   }
1799 }
1800 
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
1825   address[] public payableAddresses;
1826   address public erc20Payable;
1827   uint256[] public payableFees;
1828   uint256 public payableAddressCount;
1829   bool public onlyERC20MintingMode;
1830   
1831   function resetPayables(address[] memory _newPayables, uint256[] memory _newPayouts) public onlyTeamOrOwner {
1832     if(_newPayables.length != _newPayouts.length) revert PayablePayoutMisMatch();
1833 
1834     uint sum;
1835     for(uint i=0; i < _newPayouts.length; i++ ) {
1836         sum += _newPayouts[i];
1837     }
1838     if(sum != 100) revert PayoutsNot100();
1839 
1840     payableAddresses = _newPayables;
1841     payableFees = _newPayouts;
1842     payableAddressCount = _newPayables.length;
1843   }
1844 
1845   function withdrawAll() public onlyTeamOrOwner {
1846       if(address(this).balance == 0) revert ValueCannotBeZero();
1847       _withdrawAll(address(this).balance);
1848   }
1849 
1850   function _withdrawAll(uint256 balance) private {
1851       for(uint i=0; i < payableAddressCount; i++ ) {
1852           _widthdraw(
1853               payableAddresses[i],
1854               (balance * payableFees[i]) / 100
1855           );
1856       }
1857   }
1858   
1859   function _widthdraw(address _address, uint256 _amount) private {
1860       (bool success, ) = _address.call{value: _amount}("");
1861       require(success, "Transfer failed.");
1862   }
1863 
1864   /**
1865   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1866   * in the event ERC-20 tokens are paid to the contract for mints.
1867   * @param _tokenContract contract of ERC-20 token to withdraw
1868   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1869   */
1870   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1871     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1872     IERC20 tokenContract = IERC20(_tokenContract);
1873     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1874     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1875   }
1876 
1877   /**
1878   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1879   * @param _erc20TokenContract address of ERC-20 contract in question
1880   */
1881   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1882     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1883   }
1884 
1885   /**
1886   * @dev get the value of tokens to transfer for user of an ERC-20
1887   * @param _erc20TokenContract address of ERC-20 contract in question
1888   */
1889   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1890     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1891     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1892   }
1893 
1894   /**
1895   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1896   * @param _erc20TokenContract address of ERC-20 contract in question
1897   * @param _isActive default status of if contract should be allowed to accept payments
1898   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1899   */
1900   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1901     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1902     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1903   }
1904 
1905   /**
1906   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1907   * it will assume the default value of zero. This should not be used to create new payment tokens.
1908   * @param _erc20TokenContract address of ERC-20 contract in question
1909   */
1910   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1911     allowedTokenContracts[_erc20TokenContract].isActive = true;
1912   }
1913 
1914   /**
1915   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1916   * it will assume the default value of zero. This should not be used to create new payment tokens.
1917   * @param _erc20TokenContract address of ERC-20 contract in question
1918   */
1919   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1920     allowedTokenContracts[_erc20TokenContract].isActive = false;
1921   }
1922 
1923   /**
1924   * @dev Enable only ERC-20 payments for minting on this contract
1925   */
1926   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1927     onlyERC20MintingMode = true;
1928   }
1929 
1930   /**
1931   * @dev Disable only ERC-20 payments for minting on this contract
1932   */
1933   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1934     onlyERC20MintingMode = false;
1935   }
1936 
1937   /**
1938   * @dev Set the payout of the ERC-20 token payout to a specific address
1939   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1940   */
1941   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1942     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1943     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1944     erc20Payable = _newErc20Payable;
1945   }
1946 }
1947 
1948 
1949   
1950 // File: isFeeable.sol
1951 abstract contract Feeable is Teams, ProviderFees {
1952   uint256 public PRICE;
1953 
1954   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1955     PRICE = _feeInWei;
1956   }
1957 
1958   function getPrice(uint256 _count) public view returns (uint256) {
1959     return (PRICE * _count) + PROVIDER_FEE;
1960   }
1961 }
1962 
1963   
1964 /* File: Tippable.sol
1965 /* @dev Allows owner to set strict enforcement of payment to mint price.
1966 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1967 /* when doing a free mint with opt-in pricing.
1968 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1969 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1970 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1971 /* Pros - can take in gratituity payments during a mint. 
1972 /* Cons - However if you decrease pricing during mint txn settlement 
1973 /* it can result in mints landing who technically now have overpaid.
1974 */
1975 abstract contract Tippable is Teams {
1976   bool public strictPricing;
1977 
1978   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1979     strictPricing = _newStatus;
1980   }
1981 
1982   // @dev check if msg.value is correct according to pricing enforcement
1983   // @param _msgValue -> passed in msg.value of tx
1984   // @param _expectedPrice -> result of getPrice(...args)
1985   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1986     return strictPricing ? 
1987       _msgValue == _expectedPrice : 
1988       _msgValue >= _expectedPrice;
1989   }
1990 }
1991   
1992 contract MintplexERC721A is 
1993     Ownable,
1994     Teams,
1995     ERC721A,
1996     Initializable,
1997     WithdrawableV2,
1998     ReentrancyGuard, 
1999     Feeable,
2000     Tippable,
2001     Allowlist 
2002 {
2003     constructor() {_disableInitializers();}
2004     function initialize(
2005         address _owner,
2006         address[] memory _payables,
2007         uint256[] memory _payouts,
2008         string memory tokenName,
2009         string memory tokenSymbol,
2010         string[2] memory uris, // [basetokenURI, collectionURI]
2011         uint256[2] memory _collectionSettings, // [maxMintsPerTxn, collectionSize]
2012         uint256[2] memory _settings //[mintPrice, maxWalletMints]
2013     ) initializer public {
2014         erc20Payable = _owner;
2015     
2016         payableAddresses = _payables;
2017         payableFees = _payouts;
2018         payableAddressCount = _payables.length;
2019 
2020         _baseTokenURI = uris[0];
2021         _contractURI = uris[1];
2022 
2023         PRICE = _settings[0];
2024         MAX_WALLET_MINTS = _settings[1];
2025 
2026         // Contract-wide presets
2027         strictPricing = true;
2028         _baseTokenExtension = ".json";
2029 
2030         Ownable._transferOwnership(_owner);
2031         ERC721A._init(tokenName, tokenSymbol, _collectionSettings[0], _collectionSettings[1]);
2032         ProviderFees.init();
2033     }
2034 
2035     uint8 constant public CONTRACT_VERSION = 2;
2036     string public _contractURI;
2037     string public _baseTokenURI;
2038     string public _baseTokenExtension;
2039     bool public mintingOpen;
2040     uint256 public MAX_WALLET_MINTS;
2041   
2042     /////////////// Admin Mint Functions
2043     /**
2044      * @dev Mints a token to an address with a tokenURI.
2045      * This is owner only and allows a fee-free drop
2046      * @param _to address of the future owner of the token
2047      * @param _qty amount of tokens to drop the owner
2048      */
2049      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2050          if(_qty == 0) revert MintZeroQuantity();
2051          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2052          _safeMint(_to, _qty, true);
2053      }
2054 
2055   
2056     /////////////// PUBLIC MINT FUNCTIONS
2057     /**
2058     * @dev Mints tokens to an address in batch.
2059     * fee may or may not be required*
2060     * @param _to address of the future owner of the token
2061     * @param _amount number of tokens to mint
2062     */
2063     function mintToMultiple(address _to, uint256 _amount) public payable {
2064         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2065         if(_amount == 0) revert MintZeroQuantity();
2066         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2067         if(!mintingOpen) revert PublicMintClosed();
2068         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2069         
2070         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2071         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2072         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2073         sendProviderFee();
2074         _safeMint(_to, _amount, false);
2075     }
2076 
2077     /**
2078      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2079      * fee may or may not be required*
2080      * @param _to address of the future owner of the token
2081      * @param _amount number of tokens to mint
2082      * @param _erc20TokenContract erc-20 token contract to mint with
2083      */
2084     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2085       if(_amount == 0) revert MintZeroQuantity();
2086       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2087       if(!mintingOpen) revert PublicMintClosed();
2088       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2089       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2090       
2091       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2092       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2093 
2094       // ERC-20 Specific pre-flight checks
2095       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2096       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2097       IERC20 payableToken = IERC20(_erc20TokenContract);
2098 
2099       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2100       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2101 
2102       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2103       if(!transferComplete) revert ERC20TransferFailed();
2104 
2105       sendProviderFee();
2106       _safeMint(_to, _amount, false);
2107     }
2108 
2109     function openMinting() public onlyTeamOrOwner {
2110         mintingOpen = true;
2111     }
2112 
2113     function stopMinting() public onlyTeamOrOwner {
2114         mintingOpen = false;
2115     }
2116 
2117   
2118     ///////////// ALLOWLIST MINTING FUNCTIONS
2119     /**
2120     * @dev Mints tokens to an address using an allowlist.
2121     * fee may or may not be required*
2122     * @param _to address of the future owner of the token
2123     * @param _amount number of tokens to mint
2124     * @param _merkleProof merkle proof array
2125     */
2126     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2127         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2128         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2129         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2130         if(_amount == 0) revert MintZeroQuantity();
2131         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2132         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2133         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2134         if(!priceIsRight(msg.value, getPrice(_amount))) revert InvalidPayment();
2135         
2136 
2137         sendProviderFee();
2138         _safeMint(_to, _amount, false);
2139     }
2140 
2141     /**
2142     * @dev Mints tokens to an address using an allowlist.
2143     * fee may or may not be required*
2144     * @param _to address of the future owner of the token
2145     * @param _amount number of tokens to mint
2146     * @param _merkleProof merkle proof array
2147     * @param _erc20TokenContract erc-20 token contract to mint with
2148     */
2149     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2150       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2151       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2152       if(_amount == 0) revert MintZeroQuantity();
2153       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2154       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2155       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2156       
2157       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
2158 
2159       // ERC-20 Specific pre-flight checks
2160       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2161       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2162       IERC20 payableToken = IERC20(_erc20TokenContract);
2163 
2164       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2165       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2166 
2167       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2168       if(!transferComplete) revert ERC20TransferFailed();
2169       
2170       sendProviderFee();
2171       _safeMint(_to, _amount, false);
2172     }
2173 
2174     /**
2175      * @dev Enable allowlist minting fully by enabling both flags
2176      * This is a convenience function for the Rampp user
2177      */
2178     function openAllowlistMint() public onlyTeamOrOwner {
2179         enableAllowlistOnlyMode();
2180         mintingOpen = true;
2181     }
2182 
2183     /**
2184      * @dev Close allowlist minting fully by disabling both flags
2185      * This is a convenience function for the Rampp user
2186      */
2187     function closeAllowlistMint() public onlyTeamOrOwner {
2188         disableAllowlistOnlyMode();
2189         mintingOpen = false;
2190     }
2191 
2192 
2193   
2194     /**
2195     * @dev Check if wallet over MAX_WALLET_MINTS
2196     * @param _address address in question to check if minted count exceeds max
2197     */
2198     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2199         if(_amount == 0) revert ValueCannotBeZero();
2200         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2201     }
2202 
2203     /**
2204     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2205     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2206     */
2207     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2208         if(_newWalletMax == 0) revert ValueCannotBeZero();
2209         MAX_WALLET_MINTS = _newWalletMax;
2210     }
2211     
2212 
2213   
2214     /**
2215      * @dev Allows owner to set Max mints per tx
2216      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2217      */
2218      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2219          if(_newMaxMint == 0) revert ValueCannotBeZero();
2220          maxBatchSize = _newMaxMint;
2221      }
2222     
2223 
2224   function contractURI() public view returns (string memory) {
2225     return _contractURI;
2226   }
2227   
2228 
2229   function _baseURI() internal view virtual override returns(string memory) {
2230     return _baseTokenURI;
2231   }
2232 
2233   function _baseURIExtension() internal view virtual override returns(string memory) {
2234     return _baseTokenExtension;
2235   }
2236 
2237   function baseTokenURI() public view returns(string memory) {
2238     return _baseTokenURI;
2239   }
2240 
2241   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2242     _baseTokenURI = baseURI;
2243   }
2244 
2245   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2246     _baseTokenExtension = baseExtension;
2247   }
2248 }
2249 
2250 //*********************************************************************//
2251 //*********************************************************************//  
2252 //                       Mintplex v3.0.0
2253 //
2254 //         This smart contract was generated by mintplex.xyz.
2255 //            Mintplex allows creators like you to launch 
2256 //             large scale NFT communities without code!
2257 //
2258 //    Mintplex is not responsible for the content of this contract and
2259 //        hopes it is being used in a responsible and kind way.  
2260 //       Mintplex is not associated or affiliated with this project.                                                    
2261 //             Twitter: @MintplexNFT ---- mintplex.xyz
2262 //*********************************************************************//                                                     
2263 //*********************************************************************//