1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ██████  █████  ██   ██ ███████ 
5 // ██      ██   ██ ██  ██  ██      
6 // ██      ███████ █████   █████   
7 // ██      ██   ██ ██  ██  ██      
8 //  ██████ ██   ██ ██   ██ ███████ 
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
776 //-------------END DEPENDENCIES------------------------//
777 
778 
779   
780 // Rampp Contracts v2.1 (Teams.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 /**
785 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
786 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
787 * This will easily allow cross-collaboration via Mintplex.xyz.
788 **/
789 abstract contract Teams is Ownable{
790   mapping (address => bool) internal team;
791 
792   /**
793   * @dev Adds an address to the team. Allows them to execute protected functions
794   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
795   **/
796   function addToTeam(address _address) public onlyOwner {
797     require(_address != address(0), "Invalid address");
798     require(!inTeam(_address), "This address is already in your team.");
799   
800     team[_address] = true;
801   }
802 
803   /**
804   * @dev Removes an address to the team.
805   * @param _address the ETH address to remove, cannot be 0x and must be in team
806   **/
807   function removeFromTeam(address _address) public onlyOwner {
808     require(_address != address(0), "Invalid address");
809     require(inTeam(_address), "This address is not in your team currently.");
810   
811     team[_address] = false;
812   }
813 
814   /**
815   * @dev Check if an address is valid and active in the team
816   * @param _address ETH address to check for truthiness
817   **/
818   function inTeam(address _address)
819     public
820     view
821     returns (bool)
822   {
823     require(_address != address(0), "Invalid address to check.");
824     return team[_address] == true;
825   }
826 
827   /**
828   * @dev Throws if called by any account other than the owner or team member.
829   */
830   modifier onlyTeamOrOwner() {
831     bool _isOwner = owner() == _msgSender();
832     bool _isTeam = inTeam(_msgSender());
833     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
834     _;
835   }
836 }
837 
838 
839   
840   
841 /**
842  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
843  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
844  *
845  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
846  * 
847  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
848  *
849  * Does not support burning tokens to address(0).
850  */
851 contract ERC721A is
852   Context,
853   ERC165,
854   IERC721,
855   IERC721Metadata,
856   IERC721Enumerable,
857   Teams
858 {
859   using Address for address;
860   using Strings for uint256;
861 
862   struct TokenOwnership {
863     address addr;
864     uint64 startTimestamp;
865   }
866 
867   struct AddressData {
868     uint128 balance;
869     uint128 numberMinted;
870   }
871 
872   uint256 private currentIndex;
873 
874   uint256 public immutable collectionSize;
875   uint256 public maxBatchSize;
876 
877   // Token name
878   string private _name;
879 
880   // Token symbol
881   string private _symbol;
882 
883   // Mapping from token ID to ownership details
884   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
885   mapping(uint256 => TokenOwnership) private _ownerships;
886 
887   // Mapping owner address to address data
888   mapping(address => AddressData) private _addressData;
889 
890   // Mapping from token ID to approved address
891   mapping(uint256 => address) private _tokenApprovals;
892 
893   // Mapping from owner to operator approvals
894   mapping(address => mapping(address => bool)) private _operatorApprovals;
895 
896   /* @dev Mapping of restricted operator approvals set by contract Owner
897   * This serves as an optional addition to ERC-721 so
898   * that the contract owner can elect to prevent specific addresses/contracts
899   * from being marked as the approver for a token. The reason for this
900   * is that some projects may want to retain control of where their tokens can/can not be listed
901   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
902   * By default, there are no restrictions. The contract owner must deliberatly block an address 
903   */
904   mapping(address => bool) public restrictedApprovalAddresses;
905 
906   /**
907    * @dev
908    * maxBatchSize refers to how much a minter can mint at a time.
909    * collectionSize_ refers to how many tokens are in the collection.
910    */
911   constructor(
912     string memory name_,
913     string memory symbol_,
914     uint256 maxBatchSize_,
915     uint256 collectionSize_
916   ) {
917     require(
918       collectionSize_ > 0,
919       "ERC721A: collection must have a nonzero supply"
920     );
921     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
922     _name = name_;
923     _symbol = symbol_;
924     maxBatchSize = maxBatchSize_;
925     collectionSize = collectionSize_;
926     currentIndex = _startTokenId();
927   }
928 
929   /**
930   * To change the starting tokenId, please override this function.
931   */
932   function _startTokenId() internal view virtual returns (uint256) {
933     return 1;
934   }
935 
936   /**
937    * @dev See {IERC721Enumerable-totalSupply}.
938    */
939   function totalSupply() public view override returns (uint256) {
940     return _totalMinted();
941   }
942 
943   function currentTokenId() public view returns (uint256) {
944     return _totalMinted();
945   }
946 
947   function getNextTokenId() public view returns (uint256) {
948       return _totalMinted() + 1;
949   }
950 
951   /**
952   * Returns the total amount of tokens minted in the contract.
953   */
954   function _totalMinted() internal view returns (uint256) {
955     unchecked {
956       return currentIndex - _startTokenId();
957     }
958   }
959 
960   /**
961    * @dev See {IERC721Enumerable-tokenByIndex}.
962    */
963   function tokenByIndex(uint256 index) public view override returns (uint256) {
964     require(index < totalSupply(), "ERC721A: global index out of bounds");
965     return index;
966   }
967 
968   /**
969    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
970    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
971    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
972    */
973   function tokenOfOwnerByIndex(address owner, uint256 index)
974     public
975     view
976     override
977     returns (uint256)
978   {
979     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
980     uint256 numMintedSoFar = totalSupply();
981     uint256 tokenIdsIdx = 0;
982     address currOwnershipAddr = address(0);
983     for (uint256 i = 0; i < numMintedSoFar; i++) {
984       TokenOwnership memory ownership = _ownerships[i];
985       if (ownership.addr != address(0)) {
986         currOwnershipAddr = ownership.addr;
987       }
988       if (currOwnershipAddr == owner) {
989         if (tokenIdsIdx == index) {
990           return i;
991         }
992         tokenIdsIdx++;
993       }
994     }
995     revert("ERC721A: unable to get token of owner by index");
996   }
997 
998   /**
999    * @dev See {IERC165-supportsInterface}.
1000    */
1001   function supportsInterface(bytes4 interfaceId)
1002     public
1003     view
1004     virtual
1005     override(ERC165, IERC165)
1006     returns (bool)
1007   {
1008     return
1009       interfaceId == type(IERC721).interfaceId ||
1010       interfaceId == type(IERC721Metadata).interfaceId ||
1011       interfaceId == type(IERC721Enumerable).interfaceId ||
1012       super.supportsInterface(interfaceId);
1013   }
1014 
1015   /**
1016    * @dev See {IERC721-balanceOf}.
1017    */
1018   function balanceOf(address owner) public view override returns (uint256) {
1019     require(owner != address(0), "ERC721A: balance query for the zero address");
1020     return uint256(_addressData[owner].balance);
1021   }
1022 
1023   function _numberMinted(address owner) internal view returns (uint256) {
1024     require(
1025       owner != address(0),
1026       "ERC721A: number minted query for the zero address"
1027     );
1028     return uint256(_addressData[owner].numberMinted);
1029   }
1030 
1031   function ownershipOf(uint256 tokenId)
1032     internal
1033     view
1034     returns (TokenOwnership memory)
1035   {
1036     uint256 curr = tokenId;
1037 
1038     unchecked {
1039         if (_startTokenId() <= curr && curr < currentIndex) {
1040             TokenOwnership memory ownership = _ownerships[curr];
1041             if (ownership.addr != address(0)) {
1042                 return ownership;
1043             }
1044 
1045             // Invariant:
1046             // There will always be an ownership that has an address and is not burned
1047             // before an ownership that does not have an address and is not burned.
1048             // Hence, curr will not underflow.
1049             while (true) {
1050                 curr--;
1051                 ownership = _ownerships[curr];
1052                 if (ownership.addr != address(0)) {
1053                     return ownership;
1054                 }
1055             }
1056         }
1057     }
1058 
1059     revert("ERC721A: unable to determine the owner of token");
1060   }
1061 
1062   /**
1063    * @dev See {IERC721-ownerOf}.
1064    */
1065   function ownerOf(uint256 tokenId) public view override returns (address) {
1066     return ownershipOf(tokenId).addr;
1067   }
1068 
1069   /**
1070    * @dev See {IERC721Metadata-name}.
1071    */
1072   function name() public view virtual override returns (string memory) {
1073     return _name;
1074   }
1075 
1076   /**
1077    * @dev See {IERC721Metadata-symbol}.
1078    */
1079   function symbol() public view virtual override returns (string memory) {
1080     return _symbol;
1081   }
1082 
1083   /**
1084    * @dev See {IERC721Metadata-tokenURI}.
1085    */
1086   function tokenURI(uint256 tokenId)
1087     public
1088     view
1089     virtual
1090     override
1091     returns (string memory)
1092   {
1093     string memory baseURI = _baseURI();
1094     string memory extension = _baseURIExtension();
1095     return
1096       bytes(baseURI).length > 0
1097         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1098         : "";
1099   }
1100 
1101   /**
1102    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1103    * token will be the concatenation of the baseURI and the tokenId. Empty
1104    * by default, can be overriden in child contracts.
1105    */
1106   function _baseURI() internal view virtual returns (string memory) {
1107     return "";
1108   }
1109 
1110   /**
1111    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1112    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1113    * by default, can be overriden in child contracts.
1114    */
1115   function _baseURIExtension() internal view virtual returns (string memory) {
1116     return "";
1117   }
1118 
1119   /**
1120    * @dev Sets the value for an address to be in the restricted approval address pool.
1121    * Setting an address to true will disable token owners from being able to mark the address
1122    * for approval for trading. This would be used in theory to prevent token owners from listing
1123    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1124    * @param _address the marketplace/user to modify restriction status of
1125    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1126    */
1127   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1128     restrictedApprovalAddresses[_address] = _isRestricted;
1129   }
1130 
1131   /**
1132    * @dev See {IERC721-approve}.
1133    */
1134   function approve(address to, uint256 tokenId) public override {
1135     address owner = ERC721A.ownerOf(tokenId);
1136     require(to != owner, "ERC721A: approval to current owner");
1137     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1138 
1139     require(
1140       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1141       "ERC721A: approve caller is not owner nor approved for all"
1142     );
1143 
1144     _approve(to, tokenId, owner);
1145   }
1146 
1147   /**
1148    * @dev See {IERC721-getApproved}.
1149    */
1150   function getApproved(uint256 tokenId) public view override returns (address) {
1151     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1152 
1153     return _tokenApprovals[tokenId];
1154   }
1155 
1156   /**
1157    * @dev See {IERC721-setApprovalForAll}.
1158    */
1159   function setApprovalForAll(address operator, bool approved) public override {
1160     require(operator != _msgSender(), "ERC721A: approve to caller");
1161     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1162 
1163     _operatorApprovals[_msgSender()][operator] = approved;
1164     emit ApprovalForAll(_msgSender(), operator, approved);
1165   }
1166 
1167   /**
1168    * @dev See {IERC721-isApprovedForAll}.
1169    */
1170   function isApprovedForAll(address owner, address operator)
1171     public
1172     view
1173     virtual
1174     override
1175     returns (bool)
1176   {
1177     return _operatorApprovals[owner][operator];
1178   }
1179 
1180   /**
1181    * @dev See {IERC721-transferFrom}.
1182    */
1183   function transferFrom(
1184     address from,
1185     address to,
1186     uint256 tokenId
1187   ) public override {
1188     _transfer(from, to, tokenId);
1189   }
1190 
1191   /**
1192    * @dev See {IERC721-safeTransferFrom}.
1193    */
1194   function safeTransferFrom(
1195     address from,
1196     address to,
1197     uint256 tokenId
1198   ) public override {
1199     safeTransferFrom(from, to, tokenId, "");
1200   }
1201 
1202   /**
1203    * @dev See {IERC721-safeTransferFrom}.
1204    */
1205   function safeTransferFrom(
1206     address from,
1207     address to,
1208     uint256 tokenId,
1209     bytes memory _data
1210   ) public override {
1211     _transfer(from, to, tokenId);
1212     require(
1213       _checkOnERC721Received(from, to, tokenId, _data),
1214       "ERC721A: transfer to non ERC721Receiver implementer"
1215     );
1216   }
1217 
1218   /**
1219    * @dev Returns whether tokenId exists.
1220    *
1221    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1222    *
1223    * Tokens start existing when they are minted (_mint),
1224    */
1225   function _exists(uint256 tokenId) internal view returns (bool) {
1226     return _startTokenId() <= tokenId && tokenId < currentIndex;
1227   }
1228 
1229   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1230     _safeMint(to, quantity, isAdminMint, "");
1231   }
1232 
1233   /**
1234    * @dev Mints quantity tokens and transfers them to to.
1235    *
1236    * Requirements:
1237    *
1238    * - there must be quantity tokens remaining unminted in the total collection.
1239    * - to cannot be the zero address.
1240    * - quantity cannot be larger than the max batch size.
1241    *
1242    * Emits a {Transfer} event.
1243    */
1244   function _safeMint(
1245     address to,
1246     uint256 quantity,
1247     bool isAdminMint,
1248     bytes memory _data
1249   ) internal {
1250     uint256 startTokenId = currentIndex;
1251     require(to != address(0), "ERC721A: mint to the zero address");
1252     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1253     require(!_exists(startTokenId), "ERC721A: token already minted");
1254 
1255     // For admin mints we do not want to enforce the maxBatchSize limit
1256     if (isAdminMint == false) {
1257         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1258     }
1259 
1260     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1261 
1262     AddressData memory addressData = _addressData[to];
1263     _addressData[to] = AddressData(
1264       addressData.balance + uint128(quantity),
1265       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1266     );
1267     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1268 
1269     uint256 updatedIndex = startTokenId;
1270 
1271     for (uint256 i = 0; i < quantity; i++) {
1272       emit Transfer(address(0), to, updatedIndex);
1273       require(
1274         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1275         "ERC721A: transfer to non ERC721Receiver implementer"
1276       );
1277       updatedIndex++;
1278     }
1279 
1280     currentIndex = updatedIndex;
1281     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1282   }
1283 
1284   /**
1285    * @dev Transfers tokenId from from to to.
1286    *
1287    * Requirements:
1288    *
1289    * - to cannot be the zero address.
1290    * - tokenId token must be owned by from.
1291    *
1292    * Emits a {Transfer} event.
1293    */
1294   function _transfer(
1295     address from,
1296     address to,
1297     uint256 tokenId
1298   ) private {
1299     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1300 
1301     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1302       getApproved(tokenId) == _msgSender() ||
1303       isApprovedForAll(prevOwnership.addr, _msgSender()));
1304 
1305     require(
1306       isApprovedOrOwner,
1307       "ERC721A: transfer caller is not owner nor approved"
1308     );
1309 
1310     require(
1311       prevOwnership.addr == from,
1312       "ERC721A: transfer from incorrect owner"
1313     );
1314     require(to != address(0), "ERC721A: transfer to the zero address");
1315 
1316     _beforeTokenTransfers(from, to, tokenId, 1);
1317 
1318     // Clear approvals from the previous owner
1319     _approve(address(0), tokenId, prevOwnership.addr);
1320 
1321     _addressData[from].balance -= 1;
1322     _addressData[to].balance += 1;
1323     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1324 
1325     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1326     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1327     uint256 nextTokenId = tokenId + 1;
1328     if (_ownerships[nextTokenId].addr == address(0)) {
1329       if (_exists(nextTokenId)) {
1330         _ownerships[nextTokenId] = TokenOwnership(
1331           prevOwnership.addr,
1332           prevOwnership.startTimestamp
1333         );
1334       }
1335     }
1336 
1337     emit Transfer(from, to, tokenId);
1338     _afterTokenTransfers(from, to, tokenId, 1);
1339   }
1340 
1341   /**
1342    * @dev Approve to to operate on tokenId
1343    *
1344    * Emits a {Approval} event.
1345    */
1346   function _approve(
1347     address to,
1348     uint256 tokenId,
1349     address owner
1350   ) private {
1351     _tokenApprovals[tokenId] = to;
1352     emit Approval(owner, to, tokenId);
1353   }
1354 
1355   uint256 public nextOwnerToExplicitlySet = 0;
1356 
1357   /**
1358    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1359    */
1360   function _setOwnersExplicit(uint256 quantity) internal {
1361     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1362     require(quantity > 0, "quantity must be nonzero");
1363     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1364 
1365     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1366     if (endIndex > collectionSize - 1) {
1367       endIndex = collectionSize - 1;
1368     }
1369     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1370     require(_exists(endIndex), "not enough minted yet for this cleanup");
1371     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1372       if (_ownerships[i].addr == address(0)) {
1373         TokenOwnership memory ownership = ownershipOf(i);
1374         _ownerships[i] = TokenOwnership(
1375           ownership.addr,
1376           ownership.startTimestamp
1377         );
1378       }
1379     }
1380     nextOwnerToExplicitlySet = endIndex + 1;
1381   }
1382 
1383   /**
1384    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1385    * The call is not executed if the target address is not a contract.
1386    *
1387    * @param from address representing the previous owner of the given token ID
1388    * @param to target address that will receive the tokens
1389    * @param tokenId uint256 ID of the token to be transferred
1390    * @param _data bytes optional data to send along with the call
1391    * @return bool whether the call correctly returned the expected magic value
1392    */
1393   function _checkOnERC721Received(
1394     address from,
1395     address to,
1396     uint256 tokenId,
1397     bytes memory _data
1398   ) private returns (bool) {
1399     if (to.isContract()) {
1400       try
1401         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1402       returns (bytes4 retval) {
1403         return retval == IERC721Receiver(to).onERC721Received.selector;
1404       } catch (bytes memory reason) {
1405         if (reason.length == 0) {
1406           revert("ERC721A: transfer to non ERC721Receiver implementer");
1407         } else {
1408           assembly {
1409             revert(add(32, reason), mload(reason))
1410           }
1411         }
1412       }
1413     } else {
1414       return true;
1415     }
1416   }
1417 
1418   /**
1419    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1420    *
1421    * startTokenId - the first token id to be transferred
1422    * quantity - the amount to be transferred
1423    *
1424    * Calling conditions:
1425    *
1426    * - When from and to are both non-zero, from's tokenId will be
1427    * transferred to to.
1428    * - When from is zero, tokenId will be minted for to.
1429    */
1430   function _beforeTokenTransfers(
1431     address from,
1432     address to,
1433     uint256 startTokenId,
1434     uint256 quantity
1435   ) internal virtual {}
1436 
1437   /**
1438    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1439    * minting.
1440    *
1441    * startTokenId - the first token id to be transferred
1442    * quantity - the amount to be transferred
1443    *
1444    * Calling conditions:
1445    *
1446    * - when from and to are both non-zero.
1447    * - from and to are never both zero.
1448    */
1449   function _afterTokenTransfers(
1450     address from,
1451     address to,
1452     uint256 startTokenId,
1453     uint256 quantity
1454   ) internal virtual {}
1455 }
1456 
1457 
1458 
1459   
1460 abstract contract Ramppable {
1461   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1462 
1463   modifier isRampp() {
1464       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1465       _;
1466   }
1467 }
1468 
1469 
1470   
1471   
1472 interface IERC20 {
1473   function allowance(address owner, address spender) external view returns (uint256);
1474   function transfer(address _to, uint256 _amount) external returns (bool);
1475   function balanceOf(address account) external view returns (uint256);
1476   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1477 }
1478 
1479 // File: WithdrawableV2
1480 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1481 // ERC-20 Payouts are limited to a single payout address. This feature 
1482 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1483 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1484 abstract contract WithdrawableV2 is Teams, Ramppable {
1485   struct acceptedERC20 {
1486     bool isActive;
1487     uint256 chargeAmount;
1488   }
1489 
1490   
1491   mapping(address => acceptedERC20) private allowedTokenContracts;
1492   address[] public payableAddresses = [0x410832aa86be79a33FD61262884ccD64C036Eb02];
1493   address public erc20Payable = 0x410832aa86be79a33FD61262884ccD64C036Eb02;
1494   uint256[] public payableFees = [100];
1495   uint256 public payableAddressCount = 1;
1496   bool public onlyERC20MintingMode = false;
1497   
1498 
1499   /**
1500   * @dev Calculates the true payable balance of the contract
1501   */
1502   function calcAvailableBalance() public view returns(uint256) {
1503     return address(this).balance;
1504   }
1505 
1506   function withdrawAll() public onlyTeamOrOwner {
1507       require(calcAvailableBalance() > 0);
1508       _withdrawAll();
1509   }
1510   
1511   function withdrawAllRampp() public isRampp {
1512       require(calcAvailableBalance() > 0);
1513       _withdrawAll();
1514   }
1515 
1516   function _withdrawAll() private {
1517       uint256 balance = calcAvailableBalance();
1518       
1519       for(uint i=0; i < payableAddressCount; i++ ) {
1520           _widthdraw(
1521               payableAddresses[i],
1522               (balance * payableFees[i]) / 100
1523           );
1524       }
1525   }
1526   
1527   function _widthdraw(address _address, uint256 _amount) private {
1528       (bool success, ) = _address.call{value: _amount}("");
1529       require(success, "Transfer failed.");
1530   }
1531 
1532   /**
1533   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1534   * in the event ERC-20 tokens are paid to the contract for mints.
1535   * @param _tokenContract contract of ERC-20 token to withdraw
1536   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1537   */
1538   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1539     require(_amountToWithdraw > 0);
1540     IERC20 tokenContract = IERC20(_tokenContract);
1541     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1542     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1543   }
1544 
1545   /**
1546   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1547   * @param _erc20TokenContract address of ERC-20 contract in question
1548   */
1549   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1550     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1551   }
1552 
1553   /**
1554   * @dev get the value of tokens to transfer for user of an ERC-20
1555   * @param _erc20TokenContract address of ERC-20 contract in question
1556   */
1557   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1558     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1559     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1560   }
1561 
1562   /**
1563   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1564   * @param _erc20TokenContract address of ERC-20 contract in question
1565   * @param _isActive default status of if contract should be allowed to accept payments
1566   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1567   */
1568   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1569     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1570     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1571   }
1572 
1573   /**
1574   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1575   * it will assume the default value of zero. This should not be used to create new payment tokens.
1576   * @param _erc20TokenContract address of ERC-20 contract in question
1577   */
1578   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1579     allowedTokenContracts[_erc20TokenContract].isActive = true;
1580   }
1581 
1582   /**
1583   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1584   * it will assume the default value of zero. This should not be used to create new payment tokens.
1585   * @param _erc20TokenContract address of ERC-20 contract in question
1586   */
1587   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1588     allowedTokenContracts[_erc20TokenContract].isActive = false;
1589   }
1590 
1591   /**
1592   * @dev Enable only ERC-20 payments for minting on this contract
1593   */
1594   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1595     onlyERC20MintingMode = true;
1596   }
1597 
1598   /**
1599   * @dev Disable only ERC-20 payments for minting on this contract
1600   */
1601   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1602     onlyERC20MintingMode = false;
1603   }
1604 
1605   /**
1606   * @dev Set the payout of the ERC-20 token payout to a specific address
1607   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1608   */
1609   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1610     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1611     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1612     erc20Payable = _newErc20Payable;
1613   }
1614 
1615   /**
1616   * @dev Allows Rampp wallet to update its own reference.
1617   * @param _newAddress updated Rampp Address
1618   */
1619   function setRamppAddress(address _newAddress) public isRampp {
1620     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1621     RAMPPADDRESS = _newAddress;
1622   }
1623 }
1624 
1625 
1626   
1627   
1628   
1629 // File: EarlyMintIncentive.sol
1630 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1631 // zero fee that can be calculated on the fly.
1632 abstract contract EarlyMintIncentive is Teams, ERC721A {
1633   uint256 public PRICE = 0.003 ether;
1634   uint256 public EARLY_MINT_PRICE = 0 ether;
1635   uint256 public earlyMintOwnershipCap = 2;
1636   bool public usingEarlyMintIncentive = true;
1637 
1638   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1639     usingEarlyMintIncentive = true;
1640   }
1641 
1642   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1643     usingEarlyMintIncentive = false;
1644   }
1645 
1646   /**
1647   * @dev Set the max token ID in which the cost incentive will be applied.
1648   * @param _newCap max number of tokens wallet may mint for incentive price
1649   */
1650   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1651     require(_newCap >= 1, "Cannot set cap to less than 1");
1652     earlyMintOwnershipCap = _newCap;
1653   }
1654 
1655   /**
1656   * @dev Set the incentive mint price
1657   * @param _feeInWei new price per token when in incentive range
1658   */
1659   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1660     EARLY_MINT_PRICE = _feeInWei;
1661   }
1662 
1663   /**
1664   * @dev Set the primary mint price - the base price when not under incentive
1665   * @param _feeInWei new price per token
1666   */
1667   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1668     PRICE = _feeInWei;
1669   }
1670 
1671   /**
1672   * @dev Get the correct price for the mint for qty and person minting
1673   * @param _count amount of tokens to calc for mint
1674   * @param _to the address which will be minting these tokens, passed explicitly
1675   */
1676   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1677     require(_count > 0, "Must be minting at least 1 token.");
1678 
1679     // short circuit function if we dont need to even calc incentive pricing
1680     // short circuit if the current wallet mint qty is also already over cap
1681     if(
1682       usingEarlyMintIncentive == false ||
1683       _numberMinted(_to) > earlyMintOwnershipCap
1684     ) {
1685       return PRICE * _count;
1686     }
1687 
1688     uint256 endingTokenQty = _numberMinted(_to) + _count;
1689     // If qty to mint results in a final qty less than or equal to the cap then
1690     // the entire qty is within incentive mint.
1691     if(endingTokenQty  <= earlyMintOwnershipCap) {
1692       return EARLY_MINT_PRICE * _count;
1693     }
1694 
1695     // If the current token qty is less than the incentive cap
1696     // and the ending token qty is greater than the incentive cap
1697     // we will be straddling the cap so there will be some amount
1698     // that are incentive and some that are regular fee.
1699     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1700     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1701 
1702     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1703   }
1704 }
1705 
1706   
1707 abstract contract RamppERC721A is 
1708     Ownable,
1709     Teams,
1710     ERC721A,
1711     WithdrawableV2,
1712     ReentrancyGuard 
1713     , EarlyMintIncentive 
1714      
1715     
1716 {
1717   constructor(
1718     string memory tokenName,
1719     string memory tokenSymbol
1720   ) ERC721A(tokenName, tokenSymbol, 20, 10000) { }
1721     uint8 public CONTRACT_VERSION = 2;
1722     string public _baseTokenURI = "https://api.cakestopsoil.xyz/";
1723     string public _baseTokenExtension = ".json";
1724 
1725     bool public mintingOpen = false;
1726     
1727     
1728     uint256 public MAX_WALLET_MINTS = 20;
1729 
1730   
1731     /////////////// Admin Mint Functions
1732     /**
1733      * @dev Mints a token to an address with a tokenURI.
1734      * This is owner only and allows a fee-free drop
1735      * @param _to address of the future owner of the token
1736      * @param _qty amount of tokens to drop the owner
1737      */
1738      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1739          require(_qty > 0, "Must mint at least 1 token.");
1740          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1741          _safeMint(_to, _qty, true);
1742      }
1743 
1744   
1745     /////////////// GENERIC MINT FUNCTIONS
1746     /**
1747     * @dev Mints a single token to an address.
1748     * fee may or may not be required*
1749     * @param _to address of the future owner of the token
1750     */
1751     function mintTo(address _to) public payable {
1752         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1753         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1754         require(mintingOpen == true, "Minting is not open right now!");
1755         
1756         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1757         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1758 
1759         _safeMint(_to, 1, false);
1760     }
1761 
1762     /**
1763     * @dev Mints tokens to an address in batch.
1764     * fee may or may not be required*
1765     * @param _to address of the future owner of the token
1766     * @param _amount number of tokens to mint
1767     */
1768     function mintToMultiple(address _to, uint256 _amount) public payable {
1769         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1770         require(_amount >= 1, "Must mint at least 1 token");
1771         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1772         require(mintingOpen == true, "Minting is not open right now!");
1773         
1774         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1775         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1776         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1777 
1778         _safeMint(_to, _amount, false);
1779     }
1780 
1781     /**
1782      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1783      * fee may or may not be required*
1784      * @param _to address of the future owner of the token
1785      * @param _amount number of tokens to mint
1786      * @param _erc20TokenContract erc-20 token contract to mint with
1787      */
1788     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1789       require(_amount >= 1, "Must mint at least 1 token");
1790       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1791       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1792       require(mintingOpen == true, "Minting is not open right now!");
1793       
1794       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1795 
1796       // ERC-20 Specific pre-flight checks
1797       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1798       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1799       IERC20 payableToken = IERC20(_erc20TokenContract);
1800 
1801       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1802       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1803 
1804       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1805       require(transferComplete, "ERC-20 token was unable to be transferred");
1806       
1807       _safeMint(_to, _amount, false);
1808     }
1809 
1810     function openMinting() public onlyTeamOrOwner {
1811         mintingOpen = true;
1812     }
1813 
1814     function stopMinting() public onlyTeamOrOwner {
1815         mintingOpen = false;
1816     }
1817 
1818   
1819 
1820   
1821     /**
1822     * @dev Check if wallet over MAX_WALLET_MINTS
1823     * @param _address address in question to check if minted count exceeds max
1824     */
1825     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1826         require(_amount >= 1, "Amount must be greater than or equal to 1");
1827         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1828     }
1829 
1830     /**
1831     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1832     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1833     */
1834     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1835         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1836         MAX_WALLET_MINTS = _newWalletMax;
1837     }
1838     
1839 
1840   
1841     /**
1842      * @dev Allows owner to set Max mints per tx
1843      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1844      */
1845      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1846          require(_newMaxMint >= 1, "Max mint must be at least 1");
1847          maxBatchSize = _newMaxMint;
1848      }
1849     
1850 
1851   
1852 
1853   function _baseURI() internal view virtual override returns(string memory) {
1854     return _baseTokenURI;
1855   }
1856 
1857   function _baseURIExtension() internal view virtual override returns(string memory) {
1858     return _baseTokenExtension;
1859   }
1860 
1861   function baseTokenURI() public view returns(string memory) {
1862     return _baseTokenURI;
1863   }
1864 
1865   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1866     _baseTokenURI = baseURI;
1867   }
1868 
1869   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
1870     _baseTokenExtension = baseExtension;
1871   }
1872 
1873   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1874     return ownershipOf(tokenId);
1875   }
1876 }
1877 
1878 
1879   
1880 // File: contracts/CakeStopsOilContract.sol
1881 //SPDX-License-Identifier: MIT
1882 
1883 pragma solidity ^0.8.0;
1884 
1885 contract CakeStopsOilContract is RamppERC721A {
1886     constructor() RamppERC721A("Cake Stops Oil", "Cake"){}
1887 }
1888   