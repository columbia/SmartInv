1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ███    ███  █████  ██████  ███    ██ ███████ ███████ ███████      █████  ██      ██ ███████ ███    ██ 
5 // ████  ████ ██   ██ ██   ██ ████   ██ ██      ██      ██          ██   ██ ██      ██ ██      ████   ██ 
6 // ██ ████ ██ ███████ ██   ██ ██ ██  ██ █████   ███████ ███████     ███████ ██      ██ █████   ██ ██  ██ 
7 // ██  ██  ██ ██   ██ ██   ██ ██  ██ ██ ██           ██      ██     ██   ██ ██      ██ ██      ██  ██ ██ 
8 // ██      ██ ██   ██ ██████  ██   ████ ███████ ███████ ███████     ██   ██ ███████ ██ ███████ ██   ████ 
9 //                                                                                                       
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
913   
914   
915 // Rampp Contracts v2.1 (Teams.sol)
916 
917 error InvalidTeamAddress();
918 error DuplicateTeamAddress();
919 pragma solidity ^0.8.0;
920 
921 /**
922 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
923 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
924 * This will easily allow cross-collaboration via Mintplex.xyz.
925 **/
926 abstract contract Teams is Ownable{
927   mapping (address => bool) internal team;
928 
929   /**
930   * @dev Adds an address to the team. Allows them to execute protected functions
931   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
932   **/
933   function addToTeam(address _address) public onlyOwner {
934     if(_address == address(0)) revert InvalidTeamAddress();
935     if(inTeam(_address)) revert DuplicateTeamAddress();
936   
937     team[_address] = true;
938   }
939 
940   /**
941   * @dev Removes an address to the team.
942   * @param _address the ETH address to remove, cannot be 0x and must be in team
943   **/
944   function removeFromTeam(address _address) public onlyOwner {
945     if(_address == address(0)) revert InvalidTeamAddress();
946     if(!inTeam(_address)) revert InvalidTeamAddress();
947   
948     team[_address] = false;
949   }
950 
951   /**
952   * @dev Check if an address is valid and active in the team
953   * @param _address ETH address to check for truthiness
954   **/
955   function inTeam(address _address)
956     public
957     view
958     returns (bool)
959   {
960     if(_address == address(0)) revert InvalidTeamAddress();
961     return team[_address] == true;
962   }
963 
964   /**
965   * @dev Throws if called by any account other than the owner or team member.
966   */
967   function _onlyTeamOrOwner() private view {
968     bool _isOwner = owner() == _msgSender();
969     bool _isTeam = inTeam(_msgSender());
970     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
971   }
972 
973   modifier onlyTeamOrOwner() {
974     _onlyTeamOrOwner();
975     _;
976   }
977 }
978 
979 
980   
981   pragma solidity ^0.8.0;
982 
983   /**
984   * @dev These functions deal with verification of Merkle Trees proofs.
985   *
986   * The proofs can be generated using the JavaScript library
987   * https://github.com/miguelmota/merkletreejs[merkletreejs].
988   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
989   *
990   *
991   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
992   * hashing, or use a hash function other than keccak256 for hashing leaves.
993   * This is because the concatenation of a sorted pair of internal nodes in
994   * the merkle tree could be reinterpreted as a leaf value.
995   */
996   library MerkleProof {
997       /**
998       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
999       * defined by 'root'. For this, a 'proof' must be provided, containing
1000       * sibling hashes on the branch from the leaf to the root of the tree. Each
1001       * pair of leaves and each pair of pre-images are assumed to be sorted.
1002       */
1003       function verify(
1004           bytes32[] memory proof,
1005           bytes32 root,
1006           bytes32 leaf
1007       ) internal pure returns (bool) {
1008           return processProof(proof, leaf) == root;
1009       }
1010 
1011       /**
1012       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1013       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1014       * hash matches the root of the tree. When processing the proof, the pairs
1015       * of leafs & pre-images are assumed to be sorted.
1016       *
1017       * _Available since v4.4._
1018       */
1019       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1020           bytes32 computedHash = leaf;
1021           for (uint256 i = 0; i < proof.length; i++) {
1022               bytes32 proofElement = proof[i];
1023               if (computedHash <= proofElement) {
1024                   // Hash(current computed hash + current element of the proof)
1025                   computedHash = _efficientHash(computedHash, proofElement);
1026               } else {
1027                   // Hash(current element of the proof + current computed hash)
1028                   computedHash = _efficientHash(proofElement, computedHash);
1029               }
1030           }
1031           return computedHash;
1032       }
1033 
1034       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1035           assembly {
1036               mstore(0x00, a)
1037               mstore(0x20, b)
1038               value := keccak256(0x00, 0x40)
1039           }
1040       }
1041   }
1042 
1043 
1044   // File: Allowlist.sol
1045 
1046   pragma solidity ^0.8.0;
1047 
1048   abstract contract Allowlist is Teams {
1049     bytes32 public merkleRoot;
1050     bool public onlyAllowlistMode = false;
1051 
1052     /**
1053      * @dev Update merkle root to reflect changes in Allowlist
1054      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1055      */
1056     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1057       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1058       merkleRoot = _newMerkleRoot;
1059     }
1060 
1061     /**
1062      * @dev Check the proof of an address if valid for merkle root
1063      * @param _to address to check for proof
1064      * @param _merkleProof Proof of the address to validate against root and leaf
1065      */
1066     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1067       if(merkleRoot == 0) revert ValueCannotBeZero();
1068       bytes32 leaf = keccak256(abi.encodePacked(_to));
1069 
1070       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1071     }
1072 
1073     
1074     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1075       onlyAllowlistMode = true;
1076     }
1077 
1078     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1079         onlyAllowlistMode = false;
1080     }
1081   }
1082   
1083   
1084 /**
1085  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1086  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1087  *
1088  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1089  * 
1090  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1091  *
1092  * Does not support burning tokens to address(0).
1093  */
1094 contract ERC721A is
1095   Context,
1096   ERC165,
1097   IERC721,
1098   IERC721Metadata,
1099   IERC721Enumerable,
1100   Teams
1101   , OperatorFilterer
1102 {
1103   using Address for address;
1104   using Strings for uint256;
1105 
1106   struct TokenOwnership {
1107     address addr;
1108     uint64 startTimestamp;
1109   }
1110 
1111   struct AddressData {
1112     uint128 balance;
1113     uint128 numberMinted;
1114   }
1115 
1116   uint256 private currentIndex;
1117 
1118   uint256 public immutable collectionSize;
1119   uint256 public maxBatchSize;
1120 
1121   // Token name
1122   string private _name;
1123 
1124   // Token symbol
1125   string private _symbol;
1126 
1127   // Mapping from token ID to ownership details
1128   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1129   mapping(uint256 => TokenOwnership) private _ownerships;
1130 
1131   // Mapping owner address to address data
1132   mapping(address => AddressData) private _addressData;
1133 
1134   // Mapping from token ID to approved address
1135   mapping(uint256 => address) private _tokenApprovals;
1136 
1137   // Mapping from owner to operator approvals
1138   mapping(address => mapping(address => bool)) private _operatorApprovals;
1139 
1140   /* @dev Mapping of restricted operator approvals set by contract Owner
1141   * This serves as an optional addition to ERC-721 so
1142   * that the contract owner can elect to prevent specific addresses/contracts
1143   * from being marked as the approver for a token. The reason for this
1144   * is that some projects may want to retain control of where their tokens can/can not be listed
1145   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1146   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1147   */
1148   mapping(address => bool) public restrictedApprovalAddresses;
1149 
1150   /**
1151    * @dev
1152    * maxBatchSize refers to how much a minter can mint at a time.
1153    * collectionSize_ refers to how many tokens are in the collection.
1154    */
1155   constructor(
1156     string memory name_,
1157     string memory symbol_,
1158     uint256 maxBatchSize_,
1159     uint256 collectionSize_
1160   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1161     require(
1162       collectionSize_ > 0,
1163       "ERC721A: collection must have a nonzero supply"
1164     );
1165     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1166     _name = name_;
1167     _symbol = symbol_;
1168     maxBatchSize = maxBatchSize_;
1169     collectionSize = collectionSize_;
1170     currentIndex = _startTokenId();
1171   }
1172 
1173   /**
1174   * To change the starting tokenId, please override this function.
1175   */
1176   function _startTokenId() internal view virtual returns (uint256) {
1177     return 1;
1178   }
1179 
1180   /**
1181    * @dev See {IERC721Enumerable-totalSupply}.
1182    */
1183   function totalSupply() public view override returns (uint256) {
1184     return _totalMinted();
1185   }
1186 
1187   function currentTokenId() public view returns (uint256) {
1188     return _totalMinted();
1189   }
1190 
1191   function getNextTokenId() public view returns (uint256) {
1192       return _totalMinted() + 1;
1193   }
1194 
1195   /**
1196   * Returns the total amount of tokens minted in the contract.
1197   */
1198   function _totalMinted() internal view returns (uint256) {
1199     unchecked {
1200       return currentIndex - _startTokenId();
1201     }
1202   }
1203 
1204   /**
1205    * @dev See {IERC721Enumerable-tokenByIndex}.
1206    */
1207   function tokenByIndex(uint256 index) public view override returns (uint256) {
1208     require(index < totalSupply(), "ERC721A: global index out of bounds");
1209     return index;
1210   }
1211 
1212   /**
1213    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1214    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1215    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1216    */
1217   function tokenOfOwnerByIndex(address owner, uint256 index)
1218     public
1219     view
1220     override
1221     returns (uint256)
1222   {
1223     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1224     uint256 numMintedSoFar = totalSupply();
1225     uint256 tokenIdsIdx = 0;
1226     address currOwnershipAddr = address(0);
1227     for (uint256 i = 0; i < numMintedSoFar; i++) {
1228       TokenOwnership memory ownership = _ownerships[i];
1229       if (ownership.addr != address(0)) {
1230         currOwnershipAddr = ownership.addr;
1231       }
1232       if (currOwnershipAddr == owner) {
1233         if (tokenIdsIdx == index) {
1234           return i;
1235         }
1236         tokenIdsIdx++;
1237       }
1238     }
1239     revert("ERC721A: unable to get token of owner by index");
1240   }
1241 
1242   /**
1243    * @dev See {IERC165-supportsInterface}.
1244    */
1245   function supportsInterface(bytes4 interfaceId)
1246     public
1247     view
1248     virtual
1249     override(ERC165, IERC165)
1250     returns (bool)
1251   {
1252     return
1253       interfaceId == type(IERC721).interfaceId ||
1254       interfaceId == type(IERC721Metadata).interfaceId ||
1255       interfaceId == type(IERC721Enumerable).interfaceId ||
1256       super.supportsInterface(interfaceId);
1257   }
1258 
1259   /**
1260    * @dev See {IERC721-balanceOf}.
1261    */
1262   function balanceOf(address owner) public view override returns (uint256) {
1263     require(owner != address(0), "ERC721A: balance query for the zero address");
1264     return uint256(_addressData[owner].balance);
1265   }
1266 
1267   function _numberMinted(address owner) internal view returns (uint256) {
1268     require(
1269       owner != address(0),
1270       "ERC721A: number minted query for the zero address"
1271     );
1272     return uint256(_addressData[owner].numberMinted);
1273   }
1274 
1275   function ownershipOf(uint256 tokenId)
1276     internal
1277     view
1278     returns (TokenOwnership memory)
1279   {
1280     uint256 curr = tokenId;
1281 
1282     unchecked {
1283         if (_startTokenId() <= curr && curr < currentIndex) {
1284             TokenOwnership memory ownership = _ownerships[curr];
1285             if (ownership.addr != address(0)) {
1286                 return ownership;
1287             }
1288 
1289             // Invariant:
1290             // There will always be an ownership that has an address and is not burned
1291             // before an ownership that does not have an address and is not burned.
1292             // Hence, curr will not underflow.
1293             while (true) {
1294                 curr--;
1295                 ownership = _ownerships[curr];
1296                 if (ownership.addr != address(0)) {
1297                     return ownership;
1298                 }
1299             }
1300         }
1301     }
1302 
1303     revert("ERC721A: unable to determine the owner of token");
1304   }
1305 
1306   /**
1307    * @dev See {IERC721-ownerOf}.
1308    */
1309   function ownerOf(uint256 tokenId) public view override returns (address) {
1310     return ownershipOf(tokenId).addr;
1311   }
1312 
1313   /**
1314    * @dev See {IERC721Metadata-name}.
1315    */
1316   function name() public view virtual override returns (string memory) {
1317     return _name;
1318   }
1319 
1320   /**
1321    * @dev See {IERC721Metadata-symbol}.
1322    */
1323   function symbol() public view virtual override returns (string memory) {
1324     return _symbol;
1325   }
1326 
1327   /**
1328    * @dev See {IERC721Metadata-tokenURI}.
1329    */
1330   function tokenURI(uint256 tokenId)
1331     public
1332     view
1333     virtual
1334     override
1335     returns (string memory)
1336   {
1337     string memory baseURI = _baseURI();
1338     string memory extension = _baseURIExtension();
1339     return
1340       bytes(baseURI).length > 0
1341         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1342         : "";
1343   }
1344 
1345   /**
1346    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1347    * token will be the concatenation of the baseURI and the tokenId. Empty
1348    * by default, can be overriden in child contracts.
1349    */
1350   function _baseURI() internal view virtual returns (string memory) {
1351     return "";
1352   }
1353 
1354   /**
1355    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1356    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1357    * by default, can be overriden in child contracts.
1358    */
1359   function _baseURIExtension() internal view virtual returns (string memory) {
1360     return "";
1361   }
1362 
1363   /**
1364    * @dev Sets the value for an address to be in the restricted approval address pool.
1365    * Setting an address to true will disable token owners from being able to mark the address
1366    * for approval for trading. This would be used in theory to prevent token owners from listing
1367    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1368    * @param _address the marketplace/user to modify restriction status of
1369    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1370    */
1371   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1372     restrictedApprovalAddresses[_address] = _isRestricted;
1373   }
1374 
1375   /**
1376    * @dev See {IERC721-approve}.
1377    */
1378   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1379     address owner = ERC721A.ownerOf(tokenId);
1380     require(to != owner, "ERC721A: approval to current owner");
1381     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1382 
1383     require(
1384       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1385       "ERC721A: approve caller is not owner nor approved for all"
1386     );
1387 
1388     _approve(to, tokenId, owner);
1389   }
1390 
1391   /**
1392    * @dev See {IERC721-getApproved}.
1393    */
1394   function getApproved(uint256 tokenId) public view override returns (address) {
1395     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1396 
1397     return _tokenApprovals[tokenId];
1398   }
1399 
1400   /**
1401    * @dev See {IERC721-setApprovalForAll}.
1402    */
1403   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1404     require(operator != _msgSender(), "ERC721A: approve to caller");
1405     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1406 
1407     _operatorApprovals[_msgSender()][operator] = approved;
1408     emit ApprovalForAll(_msgSender(), operator, approved);
1409   }
1410 
1411   /**
1412    * @dev See {IERC721-isApprovedForAll}.
1413    */
1414   function isApprovedForAll(address owner, address operator)
1415     public
1416     view
1417     virtual
1418     override
1419     returns (bool)
1420   {
1421     return _operatorApprovals[owner][operator];
1422   }
1423 
1424   /**
1425    * @dev See {IERC721-transferFrom}.
1426    */
1427   function transferFrom(
1428     address from,
1429     address to,
1430     uint256 tokenId
1431   ) public override onlyAllowedOperator(from) {
1432     _transfer(from, to, tokenId);
1433   }
1434 
1435   /**
1436    * @dev See {IERC721-safeTransferFrom}.
1437    */
1438   function safeTransferFrom(
1439     address from,
1440     address to,
1441     uint256 tokenId
1442   ) public override onlyAllowedOperator(from) {
1443     safeTransferFrom(from, to, tokenId, "");
1444   }
1445 
1446   /**
1447    * @dev See {IERC721-safeTransferFrom}.
1448    */
1449   function safeTransferFrom(
1450     address from,
1451     address to,
1452     uint256 tokenId,
1453     bytes memory _data
1454   ) public override onlyAllowedOperator(from) {
1455     _transfer(from, to, tokenId);
1456     require(
1457       _checkOnERC721Received(from, to, tokenId, _data),
1458       "ERC721A: transfer to non ERC721Receiver implementer"
1459     );
1460   }
1461 
1462   /**
1463    * @dev Returns whether tokenId exists.
1464    *
1465    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1466    *
1467    * Tokens start existing when they are minted (_mint),
1468    */
1469   function _exists(uint256 tokenId) internal view returns (bool) {
1470     return _startTokenId() <= tokenId && tokenId < currentIndex;
1471   }
1472 
1473   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1474     _safeMint(to, quantity, isAdminMint, "");
1475   }
1476 
1477   /**
1478    * @dev Mints quantity tokens and transfers them to to.
1479    *
1480    * Requirements:
1481    *
1482    * - there must be quantity tokens remaining unminted in the total collection.
1483    * - to cannot be the zero address.
1484    * - quantity cannot be larger than the max batch size.
1485    *
1486    * Emits a {Transfer} event.
1487    */
1488   function _safeMint(
1489     address to,
1490     uint256 quantity,
1491     bool isAdminMint,
1492     bytes memory _data
1493   ) internal {
1494     uint256 startTokenId = currentIndex;
1495     require(to != address(0), "ERC721A: mint to the zero address");
1496     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1497     require(!_exists(startTokenId), "ERC721A: token already minted");
1498 
1499     // For admin mints we do not want to enforce the maxBatchSize limit
1500     if (isAdminMint == false) {
1501         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1502     }
1503 
1504     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1505 
1506     AddressData memory addressData = _addressData[to];
1507     _addressData[to] = AddressData(
1508       addressData.balance + uint128(quantity),
1509       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1510     );
1511     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1512 
1513     uint256 updatedIndex = startTokenId;
1514 
1515     for (uint256 i = 0; i < quantity; i++) {
1516       emit Transfer(address(0), to, updatedIndex);
1517       require(
1518         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1519         "ERC721A: transfer to non ERC721Receiver implementer"
1520       );
1521       updatedIndex++;
1522     }
1523 
1524     currentIndex = updatedIndex;
1525     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1526   }
1527 
1528   /**
1529    * @dev Transfers tokenId from from to to.
1530    *
1531    * Requirements:
1532    *
1533    * - to cannot be the zero address.
1534    * - tokenId token must be owned by from.
1535    *
1536    * Emits a {Transfer} event.
1537    */
1538   function _transfer(
1539     address from,
1540     address to,
1541     uint256 tokenId
1542   ) private {
1543     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1544 
1545     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1546       getApproved(tokenId) == _msgSender() ||
1547       isApprovedForAll(prevOwnership.addr, _msgSender()));
1548 
1549     require(
1550       isApprovedOrOwner,
1551       "ERC721A: transfer caller is not owner nor approved"
1552     );
1553 
1554     require(
1555       prevOwnership.addr == from,
1556       "ERC721A: transfer from incorrect owner"
1557     );
1558     require(to != address(0), "ERC721A: transfer to the zero address");
1559 
1560     _beforeTokenTransfers(from, to, tokenId, 1);
1561 
1562     // Clear approvals from the previous owner
1563     _approve(address(0), tokenId, prevOwnership.addr);
1564 
1565     _addressData[from].balance -= 1;
1566     _addressData[to].balance += 1;
1567     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1568 
1569     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1570     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1571     uint256 nextTokenId = tokenId + 1;
1572     if (_ownerships[nextTokenId].addr == address(0)) {
1573       if (_exists(nextTokenId)) {
1574         _ownerships[nextTokenId] = TokenOwnership(
1575           prevOwnership.addr,
1576           prevOwnership.startTimestamp
1577         );
1578       }
1579     }
1580 
1581     emit Transfer(from, to, tokenId);
1582     _afterTokenTransfers(from, to, tokenId, 1);
1583   }
1584 
1585   /**
1586    * @dev Approve to to operate on tokenId
1587    *
1588    * Emits a {Approval} event.
1589    */
1590   function _approve(
1591     address to,
1592     uint256 tokenId,
1593     address owner
1594   ) private {
1595     _tokenApprovals[tokenId] = to;
1596     emit Approval(owner, to, tokenId);
1597   }
1598 
1599   uint256 public nextOwnerToExplicitlySet = 0;
1600 
1601   /**
1602    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1603    */
1604   function _setOwnersExplicit(uint256 quantity) internal {
1605     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1606     require(quantity > 0, "quantity must be nonzero");
1607     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1608 
1609     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1610     if (endIndex > collectionSize - 1) {
1611       endIndex = collectionSize - 1;
1612     }
1613     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1614     require(_exists(endIndex), "not enough minted yet for this cleanup");
1615     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1616       if (_ownerships[i].addr == address(0)) {
1617         TokenOwnership memory ownership = ownershipOf(i);
1618         _ownerships[i] = TokenOwnership(
1619           ownership.addr,
1620           ownership.startTimestamp
1621         );
1622       }
1623     }
1624     nextOwnerToExplicitlySet = endIndex + 1;
1625   }
1626 
1627   /**
1628    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1629    * The call is not executed if the target address is not a contract.
1630    *
1631    * @param from address representing the previous owner of the given token ID
1632    * @param to target address that will receive the tokens
1633    * @param tokenId uint256 ID of the token to be transferred
1634    * @param _data bytes optional data to send along with the call
1635    * @return bool whether the call correctly returned the expected magic value
1636    */
1637   function _checkOnERC721Received(
1638     address from,
1639     address to,
1640     uint256 tokenId,
1641     bytes memory _data
1642   ) private returns (bool) {
1643     if (to.isContract()) {
1644       try
1645         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1646       returns (bytes4 retval) {
1647         return retval == IERC721Receiver(to).onERC721Received.selector;
1648       } catch (bytes memory reason) {
1649         if (reason.length == 0) {
1650           revert("ERC721A: transfer to non ERC721Receiver implementer");
1651         } else {
1652           assembly {
1653             revert(add(32, reason), mload(reason))
1654           }
1655         }
1656       }
1657     } else {
1658       return true;
1659     }
1660   }
1661 
1662   /**
1663    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1664    *
1665    * startTokenId - the first token id to be transferred
1666    * quantity - the amount to be transferred
1667    *
1668    * Calling conditions:
1669    *
1670    * - When from and to are both non-zero, from's tokenId will be
1671    * transferred to to.
1672    * - When from is zero, tokenId will be minted for to.
1673    */
1674   function _beforeTokenTransfers(
1675     address from,
1676     address to,
1677     uint256 startTokenId,
1678     uint256 quantity
1679   ) internal virtual {}
1680 
1681   /**
1682    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1683    * minting.
1684    *
1685    * startTokenId - the first token id to be transferred
1686    * quantity - the amount to be transferred
1687    *
1688    * Calling conditions:
1689    *
1690    * - when from and to are both non-zero.
1691    * - from and to are never both zero.
1692    */
1693   function _afterTokenTransfers(
1694     address from,
1695     address to,
1696     uint256 startTokenId,
1697     uint256 quantity
1698   ) internal virtual {}
1699 }
1700 
1701 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1702 // @author Mintplex.xyz (Rampp Labs Inc) (Twitter: @MintplexNFT)
1703 // @notice -- See Medium article --
1704 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1705 abstract contract ERC721ARedemption is ERC721A {
1706   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1707   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1708 
1709   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1710   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1711   
1712   uint256 public redemptionSurcharge = 0 ether;
1713   bool public redemptionModeEnabled;
1714   bool public verifiedClaimModeEnabled;
1715   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1716   mapping(address => bool) public redemptionContracts;
1717   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1718 
1719   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1720   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1721     redemptionContracts[_contractAddress] = _status;
1722   }
1723 
1724   // @dev Allow owner/team to determine if contract is accepting redemption mints
1725   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1726     redemptionModeEnabled = _newStatus;
1727   }
1728 
1729   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1730   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1731     verifiedClaimModeEnabled = _newStatus;
1732   }
1733 
1734   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1735   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1736     redemptionSurcharge = _newSurchargeInWei;
1737   }
1738 
1739   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1740   // @notice Must be a wallet address or implement IERC721Receiver.
1741   // Cannot be null address as this will break any ERC-721A implementation without a proper
1742   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1743   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1744     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1745     redemptionAddress = _newRedemptionAddress;
1746   }
1747 
1748   /**
1749   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1750   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1751   * the contract owner or Team => redemptionAddress. 
1752   * @param tokenId the token to be redeemed.
1753   * Emits a {Redeemed} event.
1754   **/
1755   function redeem(address redemptionContract, uint256 tokenId) public payable {
1756     if(getNextTokenId() > collectionSize) revert CapExceeded();
1757     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1758     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1759     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1760     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1761     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1762     
1763     IERC721 _targetContract = IERC721(redemptionContract);
1764     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1765     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1766     
1767     // Warning: Since there is no standarized return value for transfers of ERC-721
1768     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1769     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1770     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1771     // but the NFT may not have been sent to the redemptionAddress.
1772     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1773     tokenRedemptions[redemptionContract][tokenId] = true;
1774 
1775     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1776     _safeMint(_msgSender(), 1, false);
1777   }
1778 
1779   /**
1780   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1781   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1782   * @param tokenId the token to be redeemed.
1783   * Emits a {VerifiedClaim} event.
1784   **/
1785   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1786     if(getNextTokenId() > collectionSize) revert CapExceeded();
1787     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1788     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1789     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1790     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1791     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1792     
1793     tokenRedemptions[redemptionContract][tokenId] = true;
1794     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1795     _safeMint(_msgSender(), 1, false);
1796   }
1797 }
1798 
1799 
1800   
1801   
1802 interface IERC20 {
1803   function allowance(address owner, address spender) external view returns (uint256);
1804   function transfer(address _to, uint256 _amount) external returns (bool);
1805   function balanceOf(address account) external view returns (uint256);
1806   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1807 }
1808 
1809 // File: WithdrawableV2
1810 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1811 // ERC-20 Payouts are limited to a single payout address. This feature 
1812 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1813 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1814 abstract contract WithdrawableV2 is Teams {
1815   struct acceptedERC20 {
1816     bool isActive;
1817     uint256 chargeAmount;
1818   }
1819 
1820   
1821   mapping(address => acceptedERC20) private allowedTokenContracts;
1822   address[] public payableAddresses = [0x0082feA23adE768Cb04ce46503Ad7baAf8849Cf5];
1823   address public erc20Payable = 0x0082feA23adE768Cb04ce46503Ad7baAf8849Cf5;
1824   uint256[] public payableFees = [100];
1825   uint256 public payableAddressCount = 1;
1826   bool public onlyERC20MintingMode;
1827   
1828 
1829   function withdrawAll() public onlyTeamOrOwner {
1830       if(address(this).balance == 0) revert ValueCannotBeZero();
1831       _withdrawAll(address(this).balance);
1832   }
1833 
1834   function _withdrawAll(uint256 balance) private {
1835       for(uint i=0; i < payableAddressCount; i++ ) {
1836           _widthdraw(
1837               payableAddresses[i],
1838               (balance * payableFees[i]) / 100
1839           );
1840       }
1841   }
1842   
1843   function _widthdraw(address _address, uint256 _amount) private {
1844       (bool success, ) = _address.call{value: _amount}("");
1845       require(success, "Transfer failed.");
1846   }
1847 
1848   /**
1849   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1850   * in the event ERC-20 tokens are paid to the contract for mints.
1851   * @param _tokenContract contract of ERC-20 token to withdraw
1852   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1853   */
1854   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1855     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1856     IERC20 tokenContract = IERC20(_tokenContract);
1857     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1858     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1859   }
1860 
1861   /**
1862   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1863   * @param _erc20TokenContract address of ERC-20 contract in question
1864   */
1865   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1866     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1867   }
1868 
1869   /**
1870   * @dev get the value of tokens to transfer for user of an ERC-20
1871   * @param _erc20TokenContract address of ERC-20 contract in question
1872   */
1873   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1874     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1875     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1876   }
1877 
1878   /**
1879   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1880   * @param _erc20TokenContract address of ERC-20 contract in question
1881   * @param _isActive default status of if contract should be allowed to accept payments
1882   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1883   */
1884   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1885     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1886     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1887   }
1888 
1889   /**
1890   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1891   * it will assume the default value of zero. This should not be used to create new payment tokens.
1892   * @param _erc20TokenContract address of ERC-20 contract in question
1893   */
1894   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1895     allowedTokenContracts[_erc20TokenContract].isActive = true;
1896   }
1897 
1898   /**
1899   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1900   * it will assume the default value of zero. This should not be used to create new payment tokens.
1901   * @param _erc20TokenContract address of ERC-20 contract in question
1902   */
1903   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1904     allowedTokenContracts[_erc20TokenContract].isActive = false;
1905   }
1906 
1907   /**
1908   * @dev Enable only ERC-20 payments for minting on this contract
1909   */
1910   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1911     onlyERC20MintingMode = true;
1912   }
1913 
1914   /**
1915   * @dev Disable only ERC-20 payments for minting on this contract
1916   */
1917   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1918     onlyERC20MintingMode = false;
1919   }
1920 
1921   /**
1922   * @dev Set the payout of the ERC-20 token payout to a specific address
1923   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1924   */
1925   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1926     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1927     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1928     erc20Payable = _newErc20Payable;
1929   }
1930 }
1931 
1932 
1933   
1934   
1935   
1936 // File: EarlyMintIncentive.sol
1937 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1938 // zero fee that can be calculated on the fly.
1939 abstract contract EarlyMintIncentive is Teams, ERC721A {
1940   uint256 public PRICE = 0.0035 ether;
1941   uint256 public EARLY_MINT_PRICE = 0 ether;
1942   uint256 public earlyMintOwnershipCap = 1;
1943   bool public usingEarlyMintIncentive = true;
1944 
1945   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1946     usingEarlyMintIncentive = true;
1947   }
1948 
1949   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1950     usingEarlyMintIncentive = false;
1951   }
1952 
1953   /**
1954   * @dev Set the max token ID in which the cost incentive will be applied.
1955   * @param _newCap max number of tokens wallet may mint for incentive price
1956   */
1957   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1958     if(_newCap == 0) revert ValueCannotBeZero();
1959     earlyMintOwnershipCap = _newCap;
1960   }
1961 
1962   /**
1963   * @dev Set the incentive mint price
1964   * @param _feeInWei new price per token when in incentive range
1965   */
1966   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1967     EARLY_MINT_PRICE = _feeInWei;
1968   }
1969 
1970   /**
1971   * @dev Set the primary mint price - the base price when not under incentive
1972   * @param _feeInWei new price per token
1973   */
1974   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1975     PRICE = _feeInWei;
1976   }
1977 
1978   /**
1979   * @dev Get the correct price for the mint for qty and person minting
1980   * @param _count amount of tokens to calc for mint
1981   * @param _to the address which will be minting these tokens, passed explicitly
1982   */
1983   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1984     if(_count == 0) revert ValueCannotBeZero();
1985 
1986     // short circuit function if we dont need to even calc incentive pricing
1987     // short circuit if the current wallet mint qty is also already over cap
1988     if(
1989       usingEarlyMintIncentive == false ||
1990       _numberMinted(_to) > earlyMintOwnershipCap
1991     ) {
1992       return PRICE * _count;
1993     }
1994 
1995     uint256 endingTokenQty = _numberMinted(_to) + _count;
1996     // If qty to mint results in a final qty less than or equal to the cap then
1997     // the entire qty is within incentive mint.
1998     if(endingTokenQty  <= earlyMintOwnershipCap) {
1999       return EARLY_MINT_PRICE * _count;
2000     }
2001 
2002     // If the current token qty is less than the incentive cap
2003     // and the ending token qty is greater than the incentive cap
2004     // we will be straddling the cap so there will be some amount
2005     // that are incentive and some that are regular fee.
2006     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
2007     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
2008 
2009     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
2010   }
2011 }
2012 
2013   
2014 abstract contract RamppERC721A is 
2015     Ownable,
2016     Teams,
2017     ERC721ARedemption,
2018     WithdrawableV2,
2019     ReentrancyGuard 
2020     , EarlyMintIncentive 
2021     , Allowlist 
2022     
2023 {
2024   constructor(
2025     string memory tokenName,
2026     string memory tokenSymbol
2027   ) ERC721A(tokenName, tokenSymbol, 20, 4666) { }
2028     uint8 constant public CONTRACT_VERSION = 2;
2029     string public _baseTokenURI = "https://api.madnessalien.xyz/";
2030     string public _baseTokenExtension = ".json";
2031 
2032     bool public mintingOpen = false;
2033     
2034     
2035     uint256 public MAX_WALLET_MINTS = 21;
2036 
2037   
2038     /////////////// Admin Mint Functions
2039     /**
2040      * @dev Mints a token to an address with a tokenURI.
2041      * This is owner only and allows a fee-free drop
2042      * @param _to address of the future owner of the token
2043      * @param _qty amount of tokens to drop the owner
2044      */
2045      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2046          if(_qty == 0) revert MintZeroQuantity();
2047          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2048          _safeMint(_to, _qty, true);
2049      }
2050 
2051   
2052     /////////////// PUBLIC MINT FUNCTIONS
2053     /**
2054     * @dev Mints tokens to an address in batch.
2055     * fee may or may not be required*
2056     * @param _to address of the future owner of the token
2057     * @param _amount number of tokens to mint
2058     */
2059     function mintToMultiple(address _to, uint256 _amount) public payable {
2060         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2061         if(_amount == 0) revert MintZeroQuantity();
2062         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2063         if(!mintingOpen) revert PublicMintClosed();
2064         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2065         
2066         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2067         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2068         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
2069 
2070         _safeMint(_to, _amount, false);
2071     }
2072 
2073     /**
2074      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2075      * fee may or may not be required*
2076      * @param _to address of the future owner of the token
2077      * @param _amount number of tokens to mint
2078      * @param _erc20TokenContract erc-20 token contract to mint with
2079      */
2080     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2081       if(_amount == 0) revert MintZeroQuantity();
2082       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2083       if(!mintingOpen) revert PublicMintClosed();
2084       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2085       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2086       
2087       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2088 
2089       // ERC-20 Specific pre-flight checks
2090       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2091       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2092       IERC20 payableToken = IERC20(_erc20TokenContract);
2093 
2094       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2095       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2096 
2097       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2098       if(!transferComplete) revert ERC20TransferFailed();
2099       
2100       _safeMint(_to, _amount, false);
2101     }
2102 
2103     function openMinting() public onlyTeamOrOwner {
2104         mintingOpen = true;
2105     }
2106 
2107     function stopMinting() public onlyTeamOrOwner {
2108         mintingOpen = false;
2109     }
2110 
2111   
2112     ///////////// ALLOWLIST MINTING FUNCTIONS
2113     /**
2114     * @dev Mints tokens to an address using an allowlist.
2115     * fee may or may not be required*
2116     * @param _to address of the future owner of the token
2117     * @param _amount number of tokens to mint
2118     * @param _merkleProof merkle proof array
2119     */
2120     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2121         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2122         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2123         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2124         if(_amount == 0) revert MintZeroQuantity();
2125         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2126         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2127         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2128         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
2129         
2130 
2131         _safeMint(_to, _amount, false);
2132     }
2133 
2134     /**
2135     * @dev Mints tokens to an address using an allowlist.
2136     * fee may or may not be required*
2137     * @param _to address of the future owner of the token
2138     * @param _amount number of tokens to mint
2139     * @param _merkleProof merkle proof array
2140     * @param _erc20TokenContract erc-20 token contract to mint with
2141     */
2142     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2143       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2144       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2145       if(_amount == 0) revert MintZeroQuantity();
2146       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2147       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2148       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2149       
2150     
2151       // ERC-20 Specific pre-flight checks
2152       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2153       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2154       IERC20 payableToken = IERC20(_erc20TokenContract);
2155 
2156       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2157       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2158 
2159       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2160       if(!transferComplete) revert ERC20TransferFailed();
2161       
2162       _safeMint(_to, _amount, false);
2163     }
2164 
2165     /**
2166      * @dev Enable allowlist minting fully by enabling both flags
2167      * This is a convenience function for the Rampp user
2168      */
2169     function openAllowlistMint() public onlyTeamOrOwner {
2170         enableAllowlistOnlyMode();
2171         mintingOpen = true;
2172     }
2173 
2174     /**
2175      * @dev Close allowlist minting fully by disabling both flags
2176      * This is a convenience function for the Rampp user
2177      */
2178     function closeAllowlistMint() public onlyTeamOrOwner {
2179         disableAllowlistOnlyMode();
2180         mintingOpen = false;
2181     }
2182 
2183 
2184   
2185     /**
2186     * @dev Check if wallet over MAX_WALLET_MINTS
2187     * @param _address address in question to check if minted count exceeds max
2188     */
2189     function canMintAmount(address _address, uint256 _amount) private view returns(bool) {
2190         if(_amount == 0) revert ValueCannotBeZero();
2191         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2192     }
2193 
2194     /**
2195     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2196     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2197     */
2198     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2199         if(_newWalletMax == 0) revert ValueCannotBeZero();
2200         MAX_WALLET_MINTS = _newWalletMax;
2201     }
2202     
2203 
2204   
2205     /**
2206      * @dev Allows owner to set Max mints per tx
2207      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2208      */
2209      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2210          if(_newMaxMint == 0) revert ValueCannotBeZero();
2211          maxBatchSize = _newMaxMint;
2212      }
2213     
2214 
2215   
2216 
2217   function _baseURI() internal view virtual override returns(string memory) {
2218     return _baseTokenURI;
2219   }
2220 
2221   function _baseURIExtension() internal view virtual override returns(string memory) {
2222     return _baseTokenExtension;
2223   }
2224 
2225   function baseTokenURI() public view returns(string memory) {
2226     return _baseTokenURI;
2227   }
2228 
2229   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2230     _baseTokenURI = baseURI;
2231   }
2232 
2233   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2234     _baseTokenExtension = baseExtension;
2235   }
2236 }
2237 
2238 
2239   
2240 // File: contracts/MadnessAlienContract.sol
2241 //SPDX-License-Identifier: MIT
2242 
2243 pragma solidity ^0.8.0;
2244 
2245 contract MadnessAlienContract is RamppERC721A {
2246     constructor() RamppERC721A("Madness Alien", "Alien"){}
2247 }
2248   