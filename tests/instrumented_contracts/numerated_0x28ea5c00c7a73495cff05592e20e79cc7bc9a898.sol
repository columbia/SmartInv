1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _______  _______  ______   ______   _______           _______ 
5 // (  ___  )(  ____ \(  __  \ (  ___ \ (  ___  )|\     /|(  ____ \
6 // | (   ) || (    \/| (  \  )| (   ) )| (   ) |( \   / )| (    \/
7 // | (___) || (_____ | |   ) || (__/ / | |   | | \ (_) / | (_____ 
8 // |  ___  |(_____  )| |   | ||  __ (  | |   | |  \   /  (_____  )
9 // | (   ) |      ) || |   ) || (  \ \ | |   | |   ) (         ) |
10 // | )   ( |/\____) || (__/  )| )___) )| (___) |   | |   /\____) |
11 // |/     \|\_______)(______/ |/ \___/ (_______)   \_/   \_______)
12 //                                                                
13 //
14 //*********************************************************************//
15 //*********************************************************************//
16   
17 //-------------DEPENDENCIES--------------------------//
18 
19 // File: @openzeppelin/contracts/utils/Address.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
23 
24 pragma solidity ^0.8.1;
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if account is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, isContract will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      *
47      * [IMPORTANT]
48      * ====
49      * You shouldn't rely on isContract to protect against flash loan attacks!
50      *
51      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
52      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
53      * constructor.
54      * ====
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies on extcodesize/address.code.length, which returns 0
58         // for contracts in construction, since the code is only stored at the end
59         // of the constructor execution.
60 
61         return account.code.length > 0;
62     }
63 
64     /**
65      * @dev Replacement for Solidity's transfer: sends amount wei to
66      * recipient, forwarding all available gas and reverting on errors.
67      *
68      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
69      * of certain opcodes, possibly making contracts go over the 2300 gas limit
70      * imposed by transfer, making them unable to receive funds via
71      * transfer. {sendValue} removes this limitation.
72      *
73      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
74      *
75      * IMPORTANT: because control is transferred to recipient, care must be
76      * taken to not create reentrancy vulnerabilities. Consider using
77      * {ReentrancyGuard} or the
78      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
79      */
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         (bool success, ) = recipient.call{value: amount}("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     /**
88      * @dev Performs a Solidity function call using a low level call. A
89      * plain call is an unsafe replacement for a function call: use this
90      * function instead.
91      *
92      * If target reverts with a revert reason, it is bubbled up by this
93      * function (like regular Solidity function calls).
94      *
95      * Returns the raw returned data. To convert to the expected return value,
96      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
97      *
98      * Requirements:
99      *
100      * - target must be a contract.
101      * - calling target with data must not revert.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
111      * errorMessage as a fallback revert reason when target reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(
116         address target,
117         bytes memory data,
118         string memory errorMessage
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
125      * but also transferring value wei to target.
126      *
127      * Requirements:
128      *
129      * - the calling contract must have an ETH balance of at least value.
130      * - the called Solidity function must be payable.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value
138     ) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
144      * with errorMessage as a fallback revert reason when target reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         require(address(this).balance >= value, "Address: insufficient balance for call");
155         require(isContract(target), "Address: call to non-contract");
156 
157         (bool success, bytes memory returndata) = target.call{value: value}(data);
158         return verifyCallResult(success, returndata, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
168         return functionStaticCall(target, data, "Address: low-level static call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
173      * but performing a static call.
174      *
175      * _Available since v3.3._
176      */
177     function functionStaticCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal view returns (bytes memory) {
182         require(isContract(target), "Address: static call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.staticcall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(isContract(target), "Address: delegate call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
217      * revert reason using the provided one.
218      *
219      * _Available since v4.3._
220      */
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             // Look for revert reason and bubble it up if present
230             if (returndata.length > 0) {
231                 // The easiest way to bubble the revert reason is using memory via assembly
232 
233                 assembly {
234                     let returndata_size := mload(returndata)
235                     revert(add(32, returndata), returndata_size)
236                 }
237             } else {
238                 revert(errorMessage);
239             }
240         }
241     }
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 interface IERC721Receiver {
257     /**
258      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
259      * by operator from from, this function is called.
260      *
261      * It must return its Solidity selector to confirm the token transfer.
262      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
263      *
264      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
265      */
266     function onERC721Received(
267         address operator,
268         address from,
269         uint256 tokenId,
270         bytes calldata data
271     ) external returns (bytes4);
272 }
273 
274 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Interface of the ERC165 standard, as defined in the
283  * https://eips.ethereum.org/EIPS/eip-165[EIP].
284  *
285  * Implementers can declare support of contract interfaces, which can then be
286  * queried by others ({ERC165Checker}).
287  *
288  * For an implementation, see {ERC165}.
289  */
290 interface IERC165 {
291     /**
292      * @dev Returns true if this contract implements the interface defined by
293      * interfaceId. See the corresponding
294      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
295      * to learn more about how these ids are created.
296      *
297      * This function call must use less than 30 000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) external view returns (bool);
300 }
301 
302 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Implementation of the {IERC165} interface.
312  *
313  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
314  * for the additional interface id that will be supported. For example:
315  *
316  * solidity
317  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
319  * }
320  * 
321  *
322  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
323  */
324 abstract contract ERC165 is IERC165 {
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      */
328     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
329         return interfaceId == type(IERC165).interfaceId;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Required interface of an ERC721 compliant contract.
343  */
344 interface IERC721 is IERC165 {
345     /**
346      * @dev Emitted when tokenId token is transferred from from to to.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when owner enables approved to manage the tokenId token.
352      */
353     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
354 
355     /**
356      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
357      */
358     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
359 
360     /**
361      * @dev Returns the number of tokens in owner's account.
362      */
363     function balanceOf(address owner) external view returns (uint256 balance);
364 
365     /**
366      * @dev Returns the owner of the tokenId token.
367      *
368      * Requirements:
369      *
370      * - tokenId must exist.
371      */
372     function ownerOf(uint256 tokenId) external view returns (address owner);
373 
374     /**
375      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
376      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
377      *
378      * Requirements:
379      *
380      * - from cannot be the zero address.
381      * - to cannot be the zero address.
382      * - tokenId token must exist and be owned by from.
383      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
384      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
385      *
386      * Emits a {Transfer} event.
387      */
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) external;
393 
394     /**
395      * @dev Transfers tokenId token from from to to.
396      *
397      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
398      *
399      * Requirements:
400      *
401      * - from cannot be the zero address.
402      * - to cannot be the zero address.
403      * - tokenId token must be owned by from.
404      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transferFrom(
409         address from,
410         address to,
411         uint256 tokenId
412     ) external;
413 
414     /**
415      * @dev Gives permission to to to transfer tokenId token to another account.
416      * The approval is cleared when the token is transferred.
417      *
418      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
419      *
420      * Requirements:
421      *
422      * - The caller must own the token or be an approved operator.
423      * - tokenId must exist.
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address to, uint256 tokenId) external;
428 
429     /**
430      * @dev Returns the account approved for tokenId token.
431      *
432      * Requirements:
433      *
434      * - tokenId must exist.
435      */
436     function getApproved(uint256 tokenId) external view returns (address operator);
437 
438     /**
439      * @dev Approve or remove operator as an operator for the caller.
440      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
441      *
442      * Requirements:
443      *
444      * - The operator cannot be the caller.
445      *
446      * Emits an {ApprovalForAll} event.
447      */
448     function setApprovalForAll(address operator, bool _approved) external;
449 
450     /**
451      * @dev Returns if the operator is allowed to manage all of the assets of owner.
452      *
453      * See {setApprovalForAll}
454      */
455     function isApprovedForAll(address owner, address operator) external view returns (bool);
456 
457     /**
458      * @dev Safely transfers tokenId token from from to to.
459      *
460      * Requirements:
461      *
462      * - from cannot be the zero address.
463      * - to cannot be the zero address.
464      * - tokenId token must exist and be owned by from.
465      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external;
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
479 
480 
481 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
488  * @dev See https://eips.ethereum.org/EIPS/eip-721
489  */
490 interface IERC721Enumerable is IERC721 {
491     /**
492      * @dev Returns the total amount of tokens stored by the contract.
493      */
494     function totalSupply() external view returns (uint256);
495 
496     /**
497      * @dev Returns a token ID owned by owner at a given index of its token list.
498      * Use along with {balanceOf} to enumerate all of owner's tokens.
499      */
500     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
501 
502     /**
503      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
504      * Use along with {totalSupply} to enumerate all tokens.
505      */
506     function tokenByIndex(uint256 index) external view returns (uint256);
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Metadata is IERC721 {
522     /**
523      * @dev Returns the token collection name.
524      */
525     function name() external view returns (string memory);
526 
527     /**
528      * @dev Returns the token collection symbol.
529      */
530     function symbol() external view returns (string memory);
531 
532     /**
533      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
534      */
535     function tokenURI(uint256 tokenId) external view returns (string memory);
536 }
537 
538 // File: @openzeppelin/contracts/utils/Strings.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev String operations.
547  */
548 library Strings {
549     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
550 
551     /**
552      * @dev Converts a uint256 to its ASCII string decimal representation.
553      */
554     function toString(uint256 value) internal pure returns (string memory) {
555         // Inspired by OraclizeAPI's implementation - MIT licence
556         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
557 
558         if (value == 0) {
559             return "0";
560         }
561         uint256 temp = value;
562         uint256 digits;
563         while (temp != 0) {
564             digits++;
565             temp /= 10;
566         }
567         bytes memory buffer = new bytes(digits);
568         while (value != 0) {
569             digits -= 1;
570             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
571             value /= 10;
572         }
573         return string(buffer);
574     }
575 
576     /**
577      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
578      */
579     function toHexString(uint256 value) internal pure returns (string memory) {
580         if (value == 0) {
581             return "0x00";
582         }
583         uint256 temp = value;
584         uint256 length = 0;
585         while (temp != 0) {
586             length++;
587             temp >>= 8;
588         }
589         return toHexString(value, length);
590     }
591 
592     /**
593      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
594      */
595     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
596         bytes memory buffer = new bytes(2 * length + 2);
597         buffer[0] = "0";
598         buffer[1] = "x";
599         for (uint256 i = 2 * length + 1; i > 1; --i) {
600             buffer[i] = _HEX_SYMBOLS[value & 0xf];
601             value >>= 4;
602         }
603         require(value == 0, "Strings: hex length insufficient");
604         return string(buffer);
605     }
606 }
607 
608 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Contract module that helps prevent reentrant calls to a function.
617  *
618  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
619  * available, which can be applied to functions to make sure there are no nested
620  * (reentrant) calls to them.
621  *
622  * Note that because there is a single nonReentrant guard, functions marked as
623  * nonReentrant may not call one another. This can be worked around by making
624  * those functions private, and then adding external nonReentrant entry
625  * points to them.
626  *
627  * TIP: If you would like to learn more about reentrancy and alternative ways
628  * to protect against it, check out our blog post
629  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
630  */
631 abstract contract ReentrancyGuard {
632     // Booleans are more expensive than uint256 or any type that takes up a full
633     // word because each write operation emits an extra SLOAD to first read the
634     // slot's contents, replace the bits taken up by the boolean, and then write
635     // back. This is the compiler's defense against contract upgrades and
636     // pointer aliasing, and it cannot be disabled.
637 
638     // The values being non-zero value makes deployment a bit more expensive,
639     // but in exchange the refund on every call to nonReentrant will be lower in
640     // amount. Since refunds are capped to a percentage of the total
641     // transaction's gas, it is best to keep them low in cases like this one, to
642     // increase the likelihood of the full refund coming into effect.
643     uint256 private constant _NOT_ENTERED = 1;
644     uint256 private constant _ENTERED = 2;
645 
646     uint256 private _status;
647 
648     constructor() {
649         _status = _NOT_ENTERED;
650     }
651 
652     /**
653      * @dev Prevents a contract from calling itself, directly or indirectly.
654      * Calling a nonReentrant function from another nonReentrant
655      * function is not supported. It is possible to prevent this from happening
656      * by making the nonReentrant function external, and making it call a
657      * private function that does the actual work.
658      */
659     modifier nonReentrant() {
660         // On the first call to nonReentrant, _notEntered will be true
661         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
662 
663         // Any calls to nonReentrant after this point will fail
664         _status = _ENTERED;
665 
666         _;
667 
668         // By storing the original value once again, a refund is triggered (see
669         // https://eips.ethereum.org/EIPS/eip-2200)
670         _status = _NOT_ENTERED;
671     }
672 }
673 
674 // File: @openzeppelin/contracts/utils/Context.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev Provides information about the current execution context, including the
683  * sender of the transaction and its data. While these are generally available
684  * via msg.sender and msg.data, they should not be accessed in such a direct
685  * manner, since when dealing with meta-transactions the account sending and
686  * paying for execution may not be the actual sender (as far as an application
687  * is concerned).
688  *
689  * This contract is only required for intermediate, library-like contracts.
690  */
691 abstract contract Context {
692     function _msgSender() internal view virtual returns (address) {
693         return msg.sender;
694     }
695 
696     function _msgData() internal view virtual returns (bytes calldata) {
697         return msg.data;
698     }
699 }
700 
701 // File: @openzeppelin/contracts/access/Ownable.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Contract module which provides a basic access control mechanism, where
711  * there is an account (an owner) that can be granted exclusive access to
712  * specific functions.
713  *
714  * By default, the owner account will be the one that deploys the contract. This
715  * can later be changed with {transferOwnership}.
716  *
717  * This module is used through inheritance. It will make available the modifier
718  * onlyOwner, which can be applied to your functions to restrict their use to
719  * the owner.
720  */
721 abstract contract Ownable is Context {
722     address private _owner;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev Initializes the contract setting the deployer as the initial owner.
728      */
729     constructor() {
730         _transferOwnership(_msgSender());
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view virtual returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     modifier onlyOwner() {
744         require(owner() == _msgSender(), "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * onlyOwner functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         _transferOwnership(address(0));
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (newOwner).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         _transferOwnership(newOwner);
766     }
767 
768     /**
769      * @dev Transfers ownership of the contract to a new account (newOwner).
770      * Internal function without access restriction.
771      */
772     function _transferOwnership(address newOwner) internal virtual {
773         address oldOwner = _owner;
774         _owner = newOwner;
775         emit OwnershipTransferred(oldOwner, newOwner);
776     }
777 }
778 //-------------END DEPENDENCIES------------------------//
779 
780 
781   
782 // Rampp Contracts v2.1 (Teams.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
788 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
789 * This will easily allow cross-collaboration via Rampp.xyz.
790 **/
791 abstract contract Teams is Ownable{
792   mapping (address => bool) internal team;
793 
794   /**
795   * @dev Adds an address to the team. Allows them to execute protected functions
796   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
797   **/
798   function addToTeam(address _address) public onlyOwner {
799     require(_address != address(0), "Invalid address");
800     require(!inTeam(_address), "This address is already in your team.");
801   
802     team[_address] = true;
803   }
804 
805   /**
806   * @dev Removes an address to the team.
807   * @param _address the ETH address to remove, cannot be 0x and must be in team
808   **/
809   function removeFromTeam(address _address) public onlyOwner {
810     require(_address != address(0), "Invalid address");
811     require(inTeam(_address), "This address is not in your team currently.");
812   
813     team[_address] = false;
814   }
815 
816   /**
817   * @dev Check if an address is valid and active in the team
818   * @param _address ETH address to check for truthiness
819   **/
820   function inTeam(address _address)
821     public
822     view
823     returns (bool)
824   {
825     require(_address != address(0), "Invalid address to check.");
826     return team[_address] == true;
827   }
828 
829   /**
830   * @dev Throws if called by any account other than the owner or team member.
831   */
832   modifier onlyTeamOrOwner() {
833     bool _isOwner = owner() == _msgSender();
834     bool _isTeam = inTeam(_msgSender());
835     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
836     _;
837   }
838 }
839 
840 
841   
842   pragma solidity ^0.8.0;
843 
844   /**
845   * @dev These functions deal with verification of Merkle Trees proofs.
846   *
847   * The proofs can be generated using the JavaScript library
848   * https://github.com/miguelmota/merkletreejs[merkletreejs].
849   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
850   *
851   *
852   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
853   * hashing, or use a hash function other than keccak256 for hashing leaves.
854   * This is because the concatenation of a sorted pair of internal nodes in
855   * the merkle tree could be reinterpreted as a leaf value.
856   */
857   library MerkleProof {
858       /**
859       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
860       * defined by 'root'. For this, a 'proof' must be provided, containing
861       * sibling hashes on the branch from the leaf to the root of the tree. Each
862       * pair of leaves and each pair of pre-images are assumed to be sorted.
863       */
864       function verify(
865           bytes32[] memory proof,
866           bytes32 root,
867           bytes32 leaf
868       ) internal pure returns (bool) {
869           return processProof(proof, leaf) == root;
870       }
871 
872       /**
873       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
874       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
875       * hash matches the root of the tree. When processing the proof, the pairs
876       * of leafs & pre-images are assumed to be sorted.
877       *
878       * _Available since v4.4._
879       */
880       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
881           bytes32 computedHash = leaf;
882           for (uint256 i = 0; i < proof.length; i++) {
883               bytes32 proofElement = proof[i];
884               if (computedHash <= proofElement) {
885                   // Hash(current computed hash + current element of the proof)
886                   computedHash = _efficientHash(computedHash, proofElement);
887               } else {
888                   // Hash(current element of the proof + current computed hash)
889                   computedHash = _efficientHash(proofElement, computedHash);
890               }
891           }
892           return computedHash;
893       }
894 
895       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
896           assembly {
897               mstore(0x00, a)
898               mstore(0x20, b)
899               value := keccak256(0x00, 0x40)
900           }
901       }
902   }
903 
904 
905   // File: Allowlist.sol
906 
907   pragma solidity ^0.8.0;
908 
909   abstract contract Allowlist is Teams {
910     bytes32 public merkleRoot;
911     bool public onlyAllowlistMode = false;
912 
913     /**
914      * @dev Update merkle root to reflect changes in Allowlist
915      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
916      */
917     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
918       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
919       merkleRoot = _newMerkleRoot;
920     }
921 
922     /**
923      * @dev Check the proof of an address if valid for merkle root
924      * @param _to address to check for proof
925      * @param _merkleProof Proof of the address to validate against root and leaf
926      */
927     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
928       require(merkleRoot != 0, "Merkle root is not set!");
929       bytes32 leaf = keccak256(abi.encodePacked(_to));
930 
931       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
932     }
933 
934     
935     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
936       onlyAllowlistMode = true;
937     }
938 
939     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
940         onlyAllowlistMode = false;
941     }
942   }
943   
944   
945 /**
946  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
947  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
948  *
949  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
950  * 
951  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
952  *
953  * Does not support burning tokens to address(0).
954  */
955 contract ERC721A is
956   Context,
957   ERC165,
958   IERC721,
959   IERC721Metadata,
960   IERC721Enumerable
961 {
962   using Address for address;
963   using Strings for uint256;
964 
965   struct TokenOwnership {
966     address addr;
967     uint64 startTimestamp;
968   }
969 
970   struct AddressData {
971     uint128 balance;
972     uint128 numberMinted;
973   }
974 
975   uint256 private currentIndex;
976 
977   uint256 public immutable collectionSize;
978   uint256 public maxBatchSize;
979 
980   // Token name
981   string private _name;
982 
983   // Token symbol
984   string private _symbol;
985 
986   // Mapping from token ID to ownership details
987   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
988   mapping(uint256 => TokenOwnership) private _ownerships;
989 
990   // Mapping owner address to address data
991   mapping(address => AddressData) private _addressData;
992 
993   // Mapping from token ID to approved address
994   mapping(uint256 => address) private _tokenApprovals;
995 
996   // Mapping from owner to operator approvals
997   mapping(address => mapping(address => bool)) private _operatorApprovals;
998 
999   /**
1000    * @dev
1001    * maxBatchSize refers to how much a minter can mint at a time.
1002    * collectionSize_ refers to how many tokens are in the collection.
1003    */
1004   constructor(
1005     string memory name_,
1006     string memory symbol_,
1007     uint256 maxBatchSize_,
1008     uint256 collectionSize_
1009   ) {
1010     require(
1011       collectionSize_ > 0,
1012       "ERC721A: collection must have a nonzero supply"
1013     );
1014     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1015     _name = name_;
1016     _symbol = symbol_;
1017     maxBatchSize = maxBatchSize_;
1018     collectionSize = collectionSize_;
1019     currentIndex = _startTokenId();
1020   }
1021 
1022   /**
1023   * To change the starting tokenId, please override this function.
1024   */
1025   function _startTokenId() internal view virtual returns (uint256) {
1026     return 1;
1027   }
1028 
1029   /**
1030    * @dev See {IERC721Enumerable-totalSupply}.
1031    */
1032   function totalSupply() public view override returns (uint256) {
1033     return _totalMinted();
1034   }
1035 
1036   function currentTokenId() public view returns (uint256) {
1037     return _totalMinted();
1038   }
1039 
1040   function getNextTokenId() public view returns (uint256) {
1041       return _totalMinted() + 1;
1042   }
1043 
1044   /**
1045   * Returns the total amount of tokens minted in the contract.
1046   */
1047   function _totalMinted() internal view returns (uint256) {
1048     unchecked {
1049       return currentIndex - _startTokenId();
1050     }
1051   }
1052 
1053   /**
1054    * @dev See {IERC721Enumerable-tokenByIndex}.
1055    */
1056   function tokenByIndex(uint256 index) public view override returns (uint256) {
1057     require(index < totalSupply(), "ERC721A: global index out of bounds");
1058     return index;
1059   }
1060 
1061   /**
1062    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1063    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1064    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1065    */
1066   function tokenOfOwnerByIndex(address owner, uint256 index)
1067     public
1068     view
1069     override
1070     returns (uint256)
1071   {
1072     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1073     uint256 numMintedSoFar = totalSupply();
1074     uint256 tokenIdsIdx = 0;
1075     address currOwnershipAddr = address(0);
1076     for (uint256 i = 0; i < numMintedSoFar; i++) {
1077       TokenOwnership memory ownership = _ownerships[i];
1078       if (ownership.addr != address(0)) {
1079         currOwnershipAddr = ownership.addr;
1080       }
1081       if (currOwnershipAddr == owner) {
1082         if (tokenIdsIdx == index) {
1083           return i;
1084         }
1085         tokenIdsIdx++;
1086       }
1087     }
1088     revert("ERC721A: unable to get token of owner by index");
1089   }
1090 
1091   /**
1092    * @dev See {IERC165-supportsInterface}.
1093    */
1094   function supportsInterface(bytes4 interfaceId)
1095     public
1096     view
1097     virtual
1098     override(ERC165, IERC165)
1099     returns (bool)
1100   {
1101     return
1102       interfaceId == type(IERC721).interfaceId ||
1103       interfaceId == type(IERC721Metadata).interfaceId ||
1104       interfaceId == type(IERC721Enumerable).interfaceId ||
1105       super.supportsInterface(interfaceId);
1106   }
1107 
1108   /**
1109    * @dev See {IERC721-balanceOf}.
1110    */
1111   function balanceOf(address owner) public view override returns (uint256) {
1112     require(owner != address(0), "ERC721A: balance query for the zero address");
1113     return uint256(_addressData[owner].balance);
1114   }
1115 
1116   function _numberMinted(address owner) internal view returns (uint256) {
1117     require(
1118       owner != address(0),
1119       "ERC721A: number minted query for the zero address"
1120     );
1121     return uint256(_addressData[owner].numberMinted);
1122   }
1123 
1124   function ownershipOf(uint256 tokenId)
1125     internal
1126     view
1127     returns (TokenOwnership memory)
1128   {
1129     uint256 curr = tokenId;
1130 
1131     unchecked {
1132         if (_startTokenId() <= curr && curr < currentIndex) {
1133             TokenOwnership memory ownership = _ownerships[curr];
1134             if (ownership.addr != address(0)) {
1135                 return ownership;
1136             }
1137 
1138             // Invariant:
1139             // There will always be an ownership that has an address and is not burned
1140             // before an ownership that does not have an address and is not burned.
1141             // Hence, curr will not underflow.
1142             while (true) {
1143                 curr--;
1144                 ownership = _ownerships[curr];
1145                 if (ownership.addr != address(0)) {
1146                     return ownership;
1147                 }
1148             }
1149         }
1150     }
1151 
1152     revert("ERC721A: unable to determine the owner of token");
1153   }
1154 
1155   /**
1156    * @dev See {IERC721-ownerOf}.
1157    */
1158   function ownerOf(uint256 tokenId) public view override returns (address) {
1159     return ownershipOf(tokenId).addr;
1160   }
1161 
1162   /**
1163    * @dev See {IERC721Metadata-name}.
1164    */
1165   function name() public view virtual override returns (string memory) {
1166     return _name;
1167   }
1168 
1169   /**
1170    * @dev See {IERC721Metadata-symbol}.
1171    */
1172   function symbol() public view virtual override returns (string memory) {
1173     return _symbol;
1174   }
1175 
1176   /**
1177    * @dev See {IERC721Metadata-tokenURI}.
1178    */
1179   function tokenURI(uint256 tokenId)
1180     public
1181     view
1182     virtual
1183     override
1184     returns (string memory)
1185   {
1186     string memory baseURI = _baseURI();
1187     return
1188       bytes(baseURI).length > 0
1189         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1190         : "";
1191   }
1192 
1193   /**
1194    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1195    * token will be the concatenation of the baseURI and the tokenId. Empty
1196    * by default, can be overriden in child contracts.
1197    */
1198   function _baseURI() internal view virtual returns (string memory) {
1199     return "";
1200   }
1201 
1202   /**
1203    * @dev See {IERC721-approve}.
1204    */
1205   function approve(address to, uint256 tokenId) public override {
1206     address owner = ERC721A.ownerOf(tokenId);
1207     require(to != owner, "ERC721A: approval to current owner");
1208 
1209     require(
1210       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1211       "ERC721A: approve caller is not owner nor approved for all"
1212     );
1213 
1214     _approve(to, tokenId, owner);
1215   }
1216 
1217   /**
1218    * @dev See {IERC721-getApproved}.
1219    */
1220   function getApproved(uint256 tokenId) public view override returns (address) {
1221     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1222 
1223     return _tokenApprovals[tokenId];
1224   }
1225 
1226   /**
1227    * @dev See {IERC721-setApprovalForAll}.
1228    */
1229   function setApprovalForAll(address operator, bool approved) public override {
1230     require(operator != _msgSender(), "ERC721A: approve to caller");
1231 
1232     _operatorApprovals[_msgSender()][operator] = approved;
1233     emit ApprovalForAll(_msgSender(), operator, approved);
1234   }
1235 
1236   /**
1237    * @dev See {IERC721-isApprovedForAll}.
1238    */
1239   function isApprovedForAll(address owner, address operator)
1240     public
1241     view
1242     virtual
1243     override
1244     returns (bool)
1245   {
1246     return _operatorApprovals[owner][operator];
1247   }
1248 
1249   /**
1250    * @dev See {IERC721-transferFrom}.
1251    */
1252   function transferFrom(
1253     address from,
1254     address to,
1255     uint256 tokenId
1256   ) public override {
1257     _transfer(from, to, tokenId);
1258   }
1259 
1260   /**
1261    * @dev See {IERC721-safeTransferFrom}.
1262    */
1263   function safeTransferFrom(
1264     address from,
1265     address to,
1266     uint256 tokenId
1267   ) public override {
1268     safeTransferFrom(from, to, tokenId, "");
1269   }
1270 
1271   /**
1272    * @dev See {IERC721-safeTransferFrom}.
1273    */
1274   function safeTransferFrom(
1275     address from,
1276     address to,
1277     uint256 tokenId,
1278     bytes memory _data
1279   ) public override {
1280     _transfer(from, to, tokenId);
1281     require(
1282       _checkOnERC721Received(from, to, tokenId, _data),
1283       "ERC721A: transfer to non ERC721Receiver implementer"
1284     );
1285   }
1286 
1287   /**
1288    * @dev Returns whether tokenId exists.
1289    *
1290    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1291    *
1292    * Tokens start existing when they are minted (_mint),
1293    */
1294   function _exists(uint256 tokenId) internal view returns (bool) {
1295     return _startTokenId() <= tokenId && tokenId < currentIndex;
1296   }
1297 
1298   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1299     _safeMint(to, quantity, isAdminMint, "");
1300   }
1301 
1302   /**
1303    * @dev Mints quantity tokens and transfers them to to.
1304    *
1305    * Requirements:
1306    *
1307    * - there must be quantity tokens remaining unminted in the total collection.
1308    * - to cannot be the zero address.
1309    * - quantity cannot be larger than the max batch size.
1310    *
1311    * Emits a {Transfer} event.
1312    */
1313   function _safeMint(
1314     address to,
1315     uint256 quantity,
1316     bool isAdminMint,
1317     bytes memory _data
1318   ) internal {
1319     uint256 startTokenId = currentIndex;
1320     require(to != address(0), "ERC721A: mint to the zero address");
1321     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1322     require(!_exists(startTokenId), "ERC721A: token already minted");
1323 
1324     // For admin mints we do not want to enforce the maxBatchSize limit
1325     if (isAdminMint == false) {
1326         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1327     }
1328 
1329     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1330 
1331     AddressData memory addressData = _addressData[to];
1332     _addressData[to] = AddressData(
1333       addressData.balance + uint128(quantity),
1334       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1335     );
1336     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1337 
1338     uint256 updatedIndex = startTokenId;
1339 
1340     for (uint256 i = 0; i < quantity; i++) {
1341       emit Transfer(address(0), to, updatedIndex);
1342       require(
1343         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1344         "ERC721A: transfer to non ERC721Receiver implementer"
1345       );
1346       updatedIndex++;
1347     }
1348 
1349     currentIndex = updatedIndex;
1350     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1351   }
1352 
1353   /**
1354    * @dev Transfers tokenId from from to to.
1355    *
1356    * Requirements:
1357    *
1358    * - to cannot be the zero address.
1359    * - tokenId token must be owned by from.
1360    *
1361    * Emits a {Transfer} event.
1362    */
1363   function _transfer(
1364     address from,
1365     address to,
1366     uint256 tokenId
1367   ) private {
1368     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1369 
1370     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1371       getApproved(tokenId) == _msgSender() ||
1372       isApprovedForAll(prevOwnership.addr, _msgSender()));
1373 
1374     require(
1375       isApprovedOrOwner,
1376       "ERC721A: transfer caller is not owner nor approved"
1377     );
1378 
1379     require(
1380       prevOwnership.addr == from,
1381       "ERC721A: transfer from incorrect owner"
1382     );
1383     require(to != address(0), "ERC721A: transfer to the zero address");
1384 
1385     _beforeTokenTransfers(from, to, tokenId, 1);
1386 
1387     // Clear approvals from the previous owner
1388     _approve(address(0), tokenId, prevOwnership.addr);
1389 
1390     _addressData[from].balance -= 1;
1391     _addressData[to].balance += 1;
1392     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1393 
1394     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1395     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1396     uint256 nextTokenId = tokenId + 1;
1397     if (_ownerships[nextTokenId].addr == address(0)) {
1398       if (_exists(nextTokenId)) {
1399         _ownerships[nextTokenId] = TokenOwnership(
1400           prevOwnership.addr,
1401           prevOwnership.startTimestamp
1402         );
1403       }
1404     }
1405 
1406     emit Transfer(from, to, tokenId);
1407     _afterTokenTransfers(from, to, tokenId, 1);
1408   }
1409 
1410   /**
1411    * @dev Approve to to operate on tokenId
1412    *
1413    * Emits a {Approval} event.
1414    */
1415   function _approve(
1416     address to,
1417     uint256 tokenId,
1418     address owner
1419   ) private {
1420     _tokenApprovals[tokenId] = to;
1421     emit Approval(owner, to, tokenId);
1422   }
1423 
1424   uint256 public nextOwnerToExplicitlySet = 0;
1425 
1426   /**
1427    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1428    */
1429   function _setOwnersExplicit(uint256 quantity) internal {
1430     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1431     require(quantity > 0, "quantity must be nonzero");
1432     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1433 
1434     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1435     if (endIndex > collectionSize - 1) {
1436       endIndex = collectionSize - 1;
1437     }
1438     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1439     require(_exists(endIndex), "not enough minted yet for this cleanup");
1440     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1441       if (_ownerships[i].addr == address(0)) {
1442         TokenOwnership memory ownership = ownershipOf(i);
1443         _ownerships[i] = TokenOwnership(
1444           ownership.addr,
1445           ownership.startTimestamp
1446         );
1447       }
1448     }
1449     nextOwnerToExplicitlySet = endIndex + 1;
1450   }
1451 
1452   /**
1453    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1454    * The call is not executed if the target address is not a contract.
1455    *
1456    * @param from address representing the previous owner of the given token ID
1457    * @param to target address that will receive the tokens
1458    * @param tokenId uint256 ID of the token to be transferred
1459    * @param _data bytes optional data to send along with the call
1460    * @return bool whether the call correctly returned the expected magic value
1461    */
1462   function _checkOnERC721Received(
1463     address from,
1464     address to,
1465     uint256 tokenId,
1466     bytes memory _data
1467   ) private returns (bool) {
1468     if (to.isContract()) {
1469       try
1470         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1471       returns (bytes4 retval) {
1472         return retval == IERC721Receiver(to).onERC721Received.selector;
1473       } catch (bytes memory reason) {
1474         if (reason.length == 0) {
1475           revert("ERC721A: transfer to non ERC721Receiver implementer");
1476         } else {
1477           assembly {
1478             revert(add(32, reason), mload(reason))
1479           }
1480         }
1481       }
1482     } else {
1483       return true;
1484     }
1485   }
1486 
1487   /**
1488    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1489    *
1490    * startTokenId - the first token id to be transferred
1491    * quantity - the amount to be transferred
1492    *
1493    * Calling conditions:
1494    *
1495    * - When from and to are both non-zero, from's tokenId will be
1496    * transferred to to.
1497    * - When from is zero, tokenId will be minted for to.
1498    */
1499   function _beforeTokenTransfers(
1500     address from,
1501     address to,
1502     uint256 startTokenId,
1503     uint256 quantity
1504   ) internal virtual {}
1505 
1506   /**
1507    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1508    * minting.
1509    *
1510    * startTokenId - the first token id to be transferred
1511    * quantity - the amount to be transferred
1512    *
1513    * Calling conditions:
1514    *
1515    * - when from and to are both non-zero.
1516    * - from and to are never both zero.
1517    */
1518   function _afterTokenTransfers(
1519     address from,
1520     address to,
1521     uint256 startTokenId,
1522     uint256 quantity
1523   ) internal virtual {}
1524 }
1525 
1526 
1527 
1528   
1529 abstract contract Ramppable {
1530   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1531 
1532   modifier isRampp() {
1533       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1534       _;
1535   }
1536 }
1537 
1538 
1539   
1540   
1541 interface IERC20 {
1542   function allowance(address owner, address spender) external view returns (uint256);
1543   function transfer(address _to, uint256 _amount) external returns (bool);
1544   function balanceOf(address account) external view returns (uint256);
1545   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1546 }
1547 
1548 // File: WithdrawableV2
1549 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1550 // ERC-20 Payouts are limited to a single payout address. This feature 
1551 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1552 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1553 abstract contract WithdrawableV2 is Teams, Ramppable {
1554   struct acceptedERC20 {
1555     bool isActive;
1556     uint256 chargeAmount;
1557   }
1558 
1559   mapping(address => acceptedERC20) private allowedTokenContracts;
1560   address[] public payableAddresses = [RAMPPADDRESS,0x480BD154DF8371ab5bd40779Faa6118dCfd151F5];
1561   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1562   address public erc20Payable = 0x480BD154DF8371ab5bd40779Faa6118dCfd151F5;
1563   uint256[] public payableFees = [5,95];
1564   uint256[] public surchargePayableFees = [100];
1565   uint256 public payableAddressCount = 2;
1566   uint256 public surchargePayableAddressCount = 1;
1567   uint256 public ramppSurchargeBalance = 0 ether;
1568   uint256 public ramppSurchargeFee = 0.001 ether;
1569   bool public onlyERC20MintingMode = false;
1570 
1571   /**
1572   * @dev Calculates the true payable balance of the contract as the
1573   * value on contract may be from ERC-20 mint surcharges and not 
1574   * public mint charges - which are not eligable for rev share & user withdrawl
1575   */
1576   function calcAvailableBalance() public view returns(uint256) {
1577     return address(this).balance - ramppSurchargeBalance;
1578   }
1579 
1580   function withdrawAll() public onlyTeamOrOwner {
1581       require(calcAvailableBalance() > 0);
1582       _withdrawAll();
1583   }
1584   
1585   function withdrawAllRampp() public isRampp {
1586       require(calcAvailableBalance() > 0);
1587       _withdrawAll();
1588   }
1589 
1590   function _withdrawAll() private {
1591       uint256 balance = calcAvailableBalance();
1592       
1593       for(uint i=0; i < payableAddressCount; i++ ) {
1594           _widthdraw(
1595               payableAddresses[i],
1596               (balance * payableFees[i]) / 100
1597           );
1598       }
1599   }
1600   
1601   function _widthdraw(address _address, uint256 _amount) private {
1602       (bool success, ) = _address.call{value: _amount}("");
1603       require(success, "Transfer failed.");
1604   }
1605 
1606   /**
1607   * @dev This function is similiar to the regular withdraw but operates only on the
1608   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1609   **/
1610   function _withdrawAllSurcharges() private {
1611     uint256 balance = ramppSurchargeBalance;
1612     if(balance == 0) { return; }
1613     
1614     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1615         _widthdraw(
1616             surchargePayableAddresses[i],
1617             (balance * surchargePayableFees[i]) / 100
1618         );
1619     }
1620     ramppSurchargeBalance = 0 ether;
1621   }
1622 
1623   /**
1624   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1625   * in the event ERC-20 tokens are paid to the contract for mints. This will
1626   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1627   * @param _tokenContract contract of ERC-20 token to withdraw
1628   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1629   */
1630   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1631     require(_amountToWithdraw > 0);
1632     IERC20 tokenContract = IERC20(_tokenContract);
1633     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1634     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1635     _withdrawAllSurcharges();
1636   }
1637 
1638   /**
1639   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1640   */
1641   function withdrawRamppSurcharges() public isRampp {
1642     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1643     _withdrawAllSurcharges();
1644   }
1645 
1646    /**
1647   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1648   */
1649   function addSurcharge() internal {
1650     ramppSurchargeBalance += ramppSurchargeFee;
1651   }
1652   
1653   /**
1654   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1655   */
1656   function hasSurcharge() internal returns(bool) {
1657     return msg.value == ramppSurchargeFee;
1658   }
1659 
1660   /**
1661   * @dev Set surcharge fee for using ERC-20 payments on contract
1662   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1663   */
1664   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1665     ramppSurchargeFee = _newSurcharge;
1666   }
1667 
1668   /**
1669   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1670   * @param _erc20TokenContract address of ERC-20 contract in question
1671   */
1672   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1673     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1674   }
1675 
1676   /**
1677   * @dev get the value of tokens to transfer for user of an ERC-20
1678   * @param _erc20TokenContract address of ERC-20 contract in question
1679   */
1680   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1681     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1682     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1683   }
1684 
1685   /**
1686   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1687   * @param _erc20TokenContract address of ERC-20 contract in question
1688   * @param _isActive default status of if contract should be allowed to accept payments
1689   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1690   */
1691   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1692     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1693     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1694   }
1695 
1696   /**
1697   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1698   * it will assume the default value of zero. This should not be used to create new payment tokens.
1699   * @param _erc20TokenContract address of ERC-20 contract in question
1700   */
1701   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1702     allowedTokenContracts[_erc20TokenContract].isActive = true;
1703   }
1704 
1705   /**
1706   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1707   * it will assume the default value of zero. This should not be used to create new payment tokens.
1708   * @param _erc20TokenContract address of ERC-20 contract in question
1709   */
1710   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1711     allowedTokenContracts[_erc20TokenContract].isActive = false;
1712   }
1713 
1714   /**
1715   * @dev Enable only ERC-20 payments for minting on this contract
1716   */
1717   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1718     onlyERC20MintingMode = true;
1719   }
1720 
1721   /**
1722   * @dev Disable only ERC-20 payments for minting on this contract
1723   */
1724   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1725     onlyERC20MintingMode = false;
1726   }
1727 
1728   /**
1729   * @dev Set the payout of the ERC-20 token payout to a specific address
1730   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1731   */
1732   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1733     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1734     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1735     erc20Payable = _newErc20Payable;
1736   }
1737 
1738   /**
1739   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1740   */
1741   function resetRamppSurchargeBalance() public isRampp {
1742     ramppSurchargeBalance = 0 ether;
1743   }
1744 
1745   /**
1746   * @dev Allows Rampp wallet to update its own reference as well as update
1747   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1748   * and since Rampp is always the first address this function is limited to the rampp payout only.
1749   * @param _newAddress updated Rampp Address
1750   */
1751   function setRamppAddress(address _newAddress) public isRampp {
1752     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1753     RAMPPADDRESS = _newAddress;
1754     payableAddresses[0] = _newAddress;
1755   }
1756 }
1757 
1758 
1759   
1760 // File: isFeeable.sol
1761 abstract contract Feeable is Teams {
1762   uint256 public PRICE = 0 ether;
1763 
1764   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1765     PRICE = _feeInWei;
1766   }
1767 
1768   function getPrice(uint256 _count) public view returns (uint256) {
1769     return PRICE * _count;
1770   }
1771 }
1772 
1773   
1774   
1775   
1776 abstract contract RamppERC721A is 
1777     Ownable,
1778     Teams,
1779     ERC721A,
1780     WithdrawableV2,
1781     ReentrancyGuard 
1782     , Feeable 
1783     , Allowlist 
1784     
1785 {
1786   constructor(
1787     string memory tokenName,
1788     string memory tokenSymbol
1789   ) ERC721A(tokenName, tokenSymbol, 2, 5000) { }
1790     uint8 public CONTRACT_VERSION = 2;
1791     string public _baseTokenURI = "ipfs://QmPKL3f4MSDcdUzWVgBuX3zoLR7X6oivNrvgvj6a8fqVn8/";
1792 
1793     bool public mintingOpen = false;
1794     
1795     
1796     uint256 public MAX_WALLET_MINTS = 2;
1797 
1798   
1799     /////////////// Admin Mint Functions
1800     /**
1801      * @dev Mints a token to an address with a tokenURI.
1802      * This is owner only and allows a fee-free drop
1803      * @param _to address of the future owner of the token
1804      * @param _qty amount of tokens to drop the owner
1805      */
1806      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1807          require(_qty > 0, "Must mint at least 1 token.");
1808          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5000");
1809          _safeMint(_to, _qty, true);
1810      }
1811 
1812   
1813     /////////////// GENERIC MINT FUNCTIONS
1814     /**
1815     * @dev Mints a single token to an address.
1816     * fee may or may not be required*
1817     * @param _to address of the future owner of the token
1818     */
1819     function mintTo(address _to) public payable {
1820         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1821         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1822         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1823         
1824         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1825         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1826         
1827         _safeMint(_to, 1, false);
1828     }
1829 
1830     /**
1831     * @dev Mints tokens to an address in batch.
1832     * fee may or may not be required*
1833     * @param _to address of the future owner of the token
1834     * @param _amount number of tokens to mint
1835     */
1836     function mintToMultiple(address _to, uint256 _amount) public payable {
1837         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1838         require(_amount >= 1, "Must mint at least 1 token");
1839         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1840         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1841         
1842         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1843         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1844         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1845 
1846         _safeMint(_to, _amount, false);
1847     }
1848 
1849     /**
1850      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1851      * fee may or may not be required*
1852      * @param _to address of the future owner of the token
1853      * @param _amount number of tokens to mint
1854      * @param _erc20TokenContract erc-20 token contract to mint with
1855      */
1856     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1857       require(_amount >= 1, "Must mint at least 1 token");
1858       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1859       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1860       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1861       
1862       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1863 
1864       // ERC-20 Specific pre-flight checks
1865       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1866       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1867       IERC20 payableToken = IERC20(_erc20TokenContract);
1868 
1869       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1870       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1871       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1872       
1873       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1874       require(transferComplete, "ERC-20 token was unable to be transferred");
1875       
1876       _safeMint(_to, _amount, false);
1877       addSurcharge();
1878     }
1879 
1880     function openMinting() public onlyTeamOrOwner {
1881         mintingOpen = true;
1882     }
1883 
1884     function stopMinting() public onlyTeamOrOwner {
1885         mintingOpen = false;
1886     }
1887 
1888   
1889     ///////////// ALLOWLIST MINTING FUNCTIONS
1890 
1891     /**
1892     * @dev Mints tokens to an address using an allowlist.
1893     * fee may or may not be required*
1894     * @param _to address of the future owner of the token
1895     * @param _merkleProof merkle proof array
1896     */
1897     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1898         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1899         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1900         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1901         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1902         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1903         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1904         
1905 
1906         _safeMint(_to, 1, false);
1907     }
1908 
1909     /**
1910     * @dev Mints tokens to an address using an allowlist.
1911     * fee may or may not be required*
1912     * @param _to address of the future owner of the token
1913     * @param _amount number of tokens to mint
1914     * @param _merkleProof merkle proof array
1915     */
1916     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1917         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1918         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1919         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1920         require(_amount >= 1, "Must mint at least 1 token");
1921         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1922 
1923         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1924         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1925         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1926         
1927 
1928         _safeMint(_to, _amount, false);
1929     }
1930 
1931     /**
1932     * @dev Mints tokens to an address using an allowlist.
1933     * fee may or may not be required*
1934     * @param _to address of the future owner of the token
1935     * @param _amount number of tokens to mint
1936     * @param _merkleProof merkle proof array
1937     * @param _erc20TokenContract erc-20 token contract to mint with
1938     */
1939     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1940       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1941       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1942       require(_amount >= 1, "Must mint at least 1 token");
1943       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1944       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1945       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1946       
1947     
1948       // ERC-20 Specific pre-flight checks
1949       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1950       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1951       IERC20 payableToken = IERC20(_erc20TokenContract);
1952     
1953       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1954       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1955       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1956       
1957       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1958       require(transferComplete, "ERC-20 token was unable to be transferred");
1959       
1960       _safeMint(_to, _amount, false);
1961       addSurcharge();
1962     }
1963 
1964     /**
1965      * @dev Enable allowlist minting fully by enabling both flags
1966      * This is a convenience function for the Rampp user
1967      */
1968     function openAllowlistMint() public onlyTeamOrOwner {
1969         enableAllowlistOnlyMode();
1970         mintingOpen = true;
1971     }
1972 
1973     /**
1974      * @dev Close allowlist minting fully by disabling both flags
1975      * This is a convenience function for the Rampp user
1976      */
1977     function closeAllowlistMint() public onlyTeamOrOwner {
1978         disableAllowlistOnlyMode();
1979         mintingOpen = false;
1980     }
1981 
1982 
1983   
1984     /**
1985     * @dev Check if wallet over MAX_WALLET_MINTS
1986     * @param _address address in question to check if minted count exceeds max
1987     */
1988     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1989         require(_amount >= 1, "Amount must be greater than or equal to 1");
1990         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1991     }
1992 
1993     /**
1994     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1995     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1996     */
1997     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1998         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1999         MAX_WALLET_MINTS = _newWalletMax;
2000     }
2001     
2002 
2003   
2004     /**
2005      * @dev Allows owner to set Max mints per tx
2006      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2007      */
2008      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2009          require(_newMaxMint >= 1, "Max mint must be at least 1");
2010          maxBatchSize = _newMaxMint;
2011      }
2012     
2013 
2014   
2015 
2016   function _baseURI() internal view virtual override returns(string memory) {
2017     return _baseTokenURI;
2018   }
2019 
2020   function baseTokenURI() public view returns(string memory) {
2021     return _baseTokenURI;
2022   }
2023 
2024   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2025     _baseTokenURI = baseURI;
2026   }
2027 
2028   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2029     return ownershipOf(tokenId);
2030   }
2031 }
2032 
2033 
2034   
2035 // File: contracts/AsdBoysContract.sol
2036 //SPDX-License-Identifier: MIT
2037 
2038 pragma solidity ^0.8.0;
2039 
2040 contract AsdBoysContract is RamppERC721A {
2041     constructor() RamppERC721A("asdBOYS", "BOYS"){}
2042 }
2043   
2044 //*********************************************************************//
2045 //*********************************************************************//  
2046 //                       Rampp v2.1.0
2047 //
2048 //         This smart contract was generated by rampp.xyz.
2049 //            Rampp allows creators like you to launch 
2050 //             large scale NFT communities without code!
2051 //
2052 //    Rampp is not responsible for the content of this contract and
2053 //        hopes it is being used in a responsible and kind way.  
2054 //       Rampp is not associated or affiliated with this project.                                                    
2055 //             Twitter: @Rampp_ ---- rampp.xyz
2056 //*********************************************************************//                                                     
2057 //*********************************************************************// 
