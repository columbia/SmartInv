1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ██████   █████  ██   ██ ███    ███ ███████ ██████  
5 // ██   ██ ██   ██ ██   ██ ████  ████ ██      ██   ██ 
6 // ██   ██ ███████ ███████ ██ ████ ██ █████   ██████  
7 // ██   ██ ██   ██ ██   ██ ██  ██  ██ ██      ██   ██ 
8 // ██████  ██   ██ ██   ██ ██      ██ ███████ ██   ██ 
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
840   pragma solidity ^0.8.0;
841 
842   /**
843   * @dev These functions deal with verification of Merkle Trees proofs.
844   *
845   * The proofs can be generated using the JavaScript library
846   * https://github.com/miguelmota/merkletreejs[merkletreejs].
847   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
848   *
849   *
850   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
851   * hashing, or use a hash function other than keccak256 for hashing leaves.
852   * This is because the concatenation of a sorted pair of internal nodes in
853   * the merkle tree could be reinterpreted as a leaf value.
854   */
855   library MerkleProof {
856       /**
857       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
858       * defined by 'root'. For this, a 'proof' must be provided, containing
859       * sibling hashes on the branch from the leaf to the root of the tree. Each
860       * pair of leaves and each pair of pre-images are assumed to be sorted.
861       */
862       function verify(
863           bytes32[] memory proof,
864           bytes32 root,
865           bytes32 leaf
866       ) internal pure returns (bool) {
867           return processProof(proof, leaf) == root;
868       }
869 
870       /**
871       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
872       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
873       * hash matches the root of the tree. When processing the proof, the pairs
874       * of leafs & pre-images are assumed to be sorted.
875       *
876       * _Available since v4.4._
877       */
878       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
879           bytes32 computedHash = leaf;
880           for (uint256 i = 0; i < proof.length; i++) {
881               bytes32 proofElement = proof[i];
882               if (computedHash <= proofElement) {
883                   // Hash(current computed hash + current element of the proof)
884                   computedHash = _efficientHash(computedHash, proofElement);
885               } else {
886                   // Hash(current element of the proof + current computed hash)
887                   computedHash = _efficientHash(proofElement, computedHash);
888               }
889           }
890           return computedHash;
891       }
892 
893       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
894           assembly {
895               mstore(0x00, a)
896               mstore(0x20, b)
897               value := keccak256(0x00, 0x40)
898           }
899       }
900   }
901 
902 
903   // File: Allowlist.sol
904 
905   pragma solidity ^0.8.0;
906 
907   abstract contract Allowlist is Teams {
908     bytes32 public merkleRoot;
909     bool public onlyAllowlistMode = false;
910 
911     /**
912      * @dev Update merkle root to reflect changes in Allowlist
913      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
914      */
915     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
916       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
917       merkleRoot = _newMerkleRoot;
918     }
919 
920     /**
921      * @dev Check the proof of an address if valid for merkle root
922      * @param _to address to check for proof
923      * @param _merkleProof Proof of the address to validate against root and leaf
924      */
925     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
926       require(merkleRoot != 0, "Merkle root is not set!");
927       bytes32 leaf = keccak256(abi.encodePacked(_to));
928 
929       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
930     }
931 
932     
933     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
934       onlyAllowlistMode = true;
935     }
936 
937     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
938         onlyAllowlistMode = false;
939     }
940   }
941   
942   
943 /**
944  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
945  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
946  *
947  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
948  * 
949  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
950  *
951  * Does not support burning tokens to address(0).
952  */
953 contract ERC721A is
954   Context,
955   ERC165,
956   IERC721,
957   IERC721Metadata,
958   IERC721Enumerable,
959   Teams
960 {
961   using Address for address;
962   using Strings for uint256;
963 
964   struct TokenOwnership {
965     address addr;
966     uint64 startTimestamp;
967   }
968 
969   struct AddressData {
970     uint128 balance;
971     uint128 numberMinted;
972   }
973 
974   uint256 private currentIndex;
975 
976   uint256 public immutable collectionSize;
977   uint256 public maxBatchSize;
978 
979   // Token name
980   string private _name;
981 
982   // Token symbol
983   string private _symbol;
984 
985   // Mapping from token ID to ownership details
986   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
987   mapping(uint256 => TokenOwnership) private _ownerships;
988 
989   // Mapping owner address to address data
990   mapping(address => AddressData) private _addressData;
991 
992   // Mapping from token ID to approved address
993   mapping(uint256 => address) private _tokenApprovals;
994 
995   // Mapping from owner to operator approvals
996   mapping(address => mapping(address => bool)) private _operatorApprovals;
997 
998   /* @dev Mapping of restricted operator approvals set by contract Owner
999   * This serves as an optional addition to ERC-721 so
1000   * that the contract owner can elect to prevent specific addresses/contracts
1001   * from being marked as the approver for a token. The reason for this
1002   * is that some projects may want to retain control of where their tokens can/can not be listed
1003   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1004   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1005   */
1006   mapping(address => bool) public restrictedApprovalAddresses;
1007 
1008   /**
1009    * @dev
1010    * maxBatchSize refers to how much a minter can mint at a time.
1011    * collectionSize_ refers to how many tokens are in the collection.
1012    */
1013   constructor(
1014     string memory name_,
1015     string memory symbol_,
1016     uint256 maxBatchSize_,
1017     uint256 collectionSize_
1018   ) {
1019     require(
1020       collectionSize_ > 0,
1021       "ERC721A: collection must have a nonzero supply"
1022     );
1023     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1024     _name = name_;
1025     _symbol = symbol_;
1026     maxBatchSize = maxBatchSize_;
1027     collectionSize = collectionSize_;
1028     currentIndex = _startTokenId();
1029   }
1030 
1031   /**
1032   * To change the starting tokenId, please override this function.
1033   */
1034   function _startTokenId() internal view virtual returns (uint256) {
1035     return 1;
1036   }
1037 
1038   /**
1039    * @dev See {IERC721Enumerable-totalSupply}.
1040    */
1041   function totalSupply() public view override returns (uint256) {
1042     return _totalMinted();
1043   }
1044 
1045   function currentTokenId() public view returns (uint256) {
1046     return _totalMinted();
1047   }
1048 
1049   function getNextTokenId() public view returns (uint256) {
1050       return _totalMinted() + 1;
1051   }
1052 
1053   /**
1054   * Returns the total amount of tokens minted in the contract.
1055   */
1056   function _totalMinted() internal view returns (uint256) {
1057     unchecked {
1058       return currentIndex - _startTokenId();
1059     }
1060   }
1061 
1062   /**
1063    * @dev See {IERC721Enumerable-tokenByIndex}.
1064    */
1065   function tokenByIndex(uint256 index) public view override returns (uint256) {
1066     require(index < totalSupply(), "ERC721A: global index out of bounds");
1067     return index;
1068   }
1069 
1070   /**
1071    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1072    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1073    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1074    */
1075   function tokenOfOwnerByIndex(address owner, uint256 index)
1076     public
1077     view
1078     override
1079     returns (uint256)
1080   {
1081     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1082     uint256 numMintedSoFar = totalSupply();
1083     uint256 tokenIdsIdx = 0;
1084     address currOwnershipAddr = address(0);
1085     for (uint256 i = 0; i < numMintedSoFar; i++) {
1086       TokenOwnership memory ownership = _ownerships[i];
1087       if (ownership.addr != address(0)) {
1088         currOwnershipAddr = ownership.addr;
1089       }
1090       if (currOwnershipAddr == owner) {
1091         if (tokenIdsIdx == index) {
1092           return i;
1093         }
1094         tokenIdsIdx++;
1095       }
1096     }
1097     revert("ERC721A: unable to get token of owner by index");
1098   }
1099 
1100   /**
1101    * @dev See {IERC165-supportsInterface}.
1102    */
1103   function supportsInterface(bytes4 interfaceId)
1104     public
1105     view
1106     virtual
1107     override(ERC165, IERC165)
1108     returns (bool)
1109   {
1110     return
1111       interfaceId == type(IERC721).interfaceId ||
1112       interfaceId == type(IERC721Metadata).interfaceId ||
1113       interfaceId == type(IERC721Enumerable).interfaceId ||
1114       super.supportsInterface(interfaceId);
1115   }
1116 
1117   /**
1118    * @dev See {IERC721-balanceOf}.
1119    */
1120   function balanceOf(address owner) public view override returns (uint256) {
1121     require(owner != address(0), "ERC721A: balance query for the zero address");
1122     return uint256(_addressData[owner].balance);
1123   }
1124 
1125   function _numberMinted(address owner) internal view returns (uint256) {
1126     require(
1127       owner != address(0),
1128       "ERC721A: number minted query for the zero address"
1129     );
1130     return uint256(_addressData[owner].numberMinted);
1131   }
1132 
1133   function ownershipOf(uint256 tokenId)
1134     internal
1135     view
1136     returns (TokenOwnership memory)
1137   {
1138     uint256 curr = tokenId;
1139 
1140     unchecked {
1141         if (_startTokenId() <= curr && curr < currentIndex) {
1142             TokenOwnership memory ownership = _ownerships[curr];
1143             if (ownership.addr != address(0)) {
1144                 return ownership;
1145             }
1146 
1147             // Invariant:
1148             // There will always be an ownership that has an address and is not burned
1149             // before an ownership that does not have an address and is not burned.
1150             // Hence, curr will not underflow.
1151             while (true) {
1152                 curr--;
1153                 ownership = _ownerships[curr];
1154                 if (ownership.addr != address(0)) {
1155                     return ownership;
1156                 }
1157             }
1158         }
1159     }
1160 
1161     revert("ERC721A: unable to determine the owner of token");
1162   }
1163 
1164   /**
1165    * @dev See {IERC721-ownerOf}.
1166    */
1167   function ownerOf(uint256 tokenId) public view override returns (address) {
1168     return ownershipOf(tokenId).addr;
1169   }
1170 
1171   /**
1172    * @dev See {IERC721Metadata-name}.
1173    */
1174   function name() public view virtual override returns (string memory) {
1175     return _name;
1176   }
1177 
1178   /**
1179    * @dev See {IERC721Metadata-symbol}.
1180    */
1181   function symbol() public view virtual override returns (string memory) {
1182     return _symbol;
1183   }
1184 
1185   /**
1186    * @dev See {IERC721Metadata-tokenURI}.
1187    */
1188   function tokenURI(uint256 tokenId)
1189     public
1190     view
1191     virtual
1192     override
1193     returns (string memory)
1194   {
1195     string memory baseURI = _baseURI();
1196     return
1197       bytes(baseURI).length > 0
1198         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1199         : "";
1200   }
1201 
1202   /**
1203    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1204    * token will be the concatenation of the baseURI and the tokenId. Empty
1205    * by default, can be overriden in child contracts.
1206    */
1207   function _baseURI() internal view virtual returns (string memory) {
1208     return "";
1209   }
1210 
1211   /**
1212    * @dev Sets the value for an address to be in the restricted approval address pool.
1213    * Setting an address to true will disable token owners from being able to mark the address
1214    * for approval for trading. This would be used in theory to prevent token owners from listing
1215    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1216    * @param _address the marketplace/user to modify restriction status of
1217    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1218    */
1219   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1220     restrictedApprovalAddresses[_address] = _isRestricted;
1221   }
1222 
1223   /**
1224    * @dev See {IERC721-approve}.
1225    */
1226   function approve(address to, uint256 tokenId) public override {
1227     address owner = ERC721A.ownerOf(tokenId);
1228     require(to != owner, "ERC721A: approval to current owner");
1229     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1230 
1231     require(
1232       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1233       "ERC721A: approve caller is not owner nor approved for all"
1234     );
1235 
1236     _approve(to, tokenId, owner);
1237   }
1238 
1239   /**
1240    * @dev See {IERC721-getApproved}.
1241    */
1242   function getApproved(uint256 tokenId) public view override returns (address) {
1243     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1244 
1245     return _tokenApprovals[tokenId];
1246   }
1247 
1248   /**
1249    * @dev See {IERC721-setApprovalForAll}.
1250    */
1251   function setApprovalForAll(address operator, bool approved) public override {
1252     require(operator != _msgSender(), "ERC721A: approve to caller");
1253     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1254 
1255     _operatorApprovals[_msgSender()][operator] = approved;
1256     emit ApprovalForAll(_msgSender(), operator, approved);
1257   }
1258 
1259   /**
1260    * @dev See {IERC721-isApprovedForAll}.
1261    */
1262   function isApprovedForAll(address owner, address operator)
1263     public
1264     view
1265     virtual
1266     override
1267     returns (bool)
1268   {
1269     return _operatorApprovals[owner][operator];
1270   }
1271 
1272   /**
1273    * @dev See {IERC721-transferFrom}.
1274    */
1275   function transferFrom(
1276     address from,
1277     address to,
1278     uint256 tokenId
1279   ) public override {
1280     _transfer(from, to, tokenId);
1281   }
1282 
1283   /**
1284    * @dev See {IERC721-safeTransferFrom}.
1285    */
1286   function safeTransferFrom(
1287     address from,
1288     address to,
1289     uint256 tokenId
1290   ) public override {
1291     safeTransferFrom(from, to, tokenId, "");
1292   }
1293 
1294   /**
1295    * @dev See {IERC721-safeTransferFrom}.
1296    */
1297   function safeTransferFrom(
1298     address from,
1299     address to,
1300     uint256 tokenId,
1301     bytes memory _data
1302   ) public override {
1303     _transfer(from, to, tokenId);
1304     require(
1305       _checkOnERC721Received(from, to, tokenId, _data),
1306       "ERC721A: transfer to non ERC721Receiver implementer"
1307     );
1308   }
1309 
1310   /**
1311    * @dev Returns whether tokenId exists.
1312    *
1313    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1314    *
1315    * Tokens start existing when they are minted (_mint),
1316    */
1317   function _exists(uint256 tokenId) internal view returns (bool) {
1318     return _startTokenId() <= tokenId && tokenId < currentIndex;
1319   }
1320 
1321   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1322     _safeMint(to, quantity, isAdminMint, "");
1323   }
1324 
1325   /**
1326    * @dev Mints quantity tokens and transfers them to to.
1327    *
1328    * Requirements:
1329    *
1330    * - there must be quantity tokens remaining unminted in the total collection.
1331    * - to cannot be the zero address.
1332    * - quantity cannot be larger than the max batch size.
1333    *
1334    * Emits a {Transfer} event.
1335    */
1336   function _safeMint(
1337     address to,
1338     uint256 quantity,
1339     bool isAdminMint,
1340     bytes memory _data
1341   ) internal {
1342     uint256 startTokenId = currentIndex;
1343     require(to != address(0), "ERC721A: mint to the zero address");
1344     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1345     require(!_exists(startTokenId), "ERC721A: token already minted");
1346 
1347     // For admin mints we do not want to enforce the maxBatchSize limit
1348     if (isAdminMint == false) {
1349         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1350     }
1351 
1352     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1353 
1354     AddressData memory addressData = _addressData[to];
1355     _addressData[to] = AddressData(
1356       addressData.balance + uint128(quantity),
1357       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1358     );
1359     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1360 
1361     uint256 updatedIndex = startTokenId;
1362 
1363     for (uint256 i = 0; i < quantity; i++) {
1364       emit Transfer(address(0), to, updatedIndex);
1365       require(
1366         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1367         "ERC721A: transfer to non ERC721Receiver implementer"
1368       );
1369       updatedIndex++;
1370     }
1371 
1372     currentIndex = updatedIndex;
1373     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1374   }
1375 
1376   /**
1377    * @dev Transfers tokenId from from to to.
1378    *
1379    * Requirements:
1380    *
1381    * - to cannot be the zero address.
1382    * - tokenId token must be owned by from.
1383    *
1384    * Emits a {Transfer} event.
1385    */
1386   function _transfer(
1387     address from,
1388     address to,
1389     uint256 tokenId
1390   ) private {
1391     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1392 
1393     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1394       getApproved(tokenId) == _msgSender() ||
1395       isApprovedForAll(prevOwnership.addr, _msgSender()));
1396 
1397     require(
1398       isApprovedOrOwner,
1399       "ERC721A: transfer caller is not owner nor approved"
1400     );
1401 
1402     require(
1403       prevOwnership.addr == from,
1404       "ERC721A: transfer from incorrect owner"
1405     );
1406     require(to != address(0), "ERC721A: transfer to the zero address");
1407 
1408     _beforeTokenTransfers(from, to, tokenId, 1);
1409 
1410     // Clear approvals from the previous owner
1411     _approve(address(0), tokenId, prevOwnership.addr);
1412 
1413     _addressData[from].balance -= 1;
1414     _addressData[to].balance += 1;
1415     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1416 
1417     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1418     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1419     uint256 nextTokenId = tokenId + 1;
1420     if (_ownerships[nextTokenId].addr == address(0)) {
1421       if (_exists(nextTokenId)) {
1422         _ownerships[nextTokenId] = TokenOwnership(
1423           prevOwnership.addr,
1424           prevOwnership.startTimestamp
1425         );
1426       }
1427     }
1428 
1429     emit Transfer(from, to, tokenId);
1430     _afterTokenTransfers(from, to, tokenId, 1);
1431   }
1432 
1433   /**
1434    * @dev Approve to to operate on tokenId
1435    *
1436    * Emits a {Approval} event.
1437    */
1438   function _approve(
1439     address to,
1440     uint256 tokenId,
1441     address owner
1442   ) private {
1443     _tokenApprovals[tokenId] = to;
1444     emit Approval(owner, to, tokenId);
1445   }
1446 
1447   uint256 public nextOwnerToExplicitlySet = 0;
1448 
1449   /**
1450    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1451    */
1452   function _setOwnersExplicit(uint256 quantity) internal {
1453     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1454     require(quantity > 0, "quantity must be nonzero");
1455     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1456 
1457     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1458     if (endIndex > collectionSize - 1) {
1459       endIndex = collectionSize - 1;
1460     }
1461     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1462     require(_exists(endIndex), "not enough minted yet for this cleanup");
1463     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1464       if (_ownerships[i].addr == address(0)) {
1465         TokenOwnership memory ownership = ownershipOf(i);
1466         _ownerships[i] = TokenOwnership(
1467           ownership.addr,
1468           ownership.startTimestamp
1469         );
1470       }
1471     }
1472     nextOwnerToExplicitlySet = endIndex + 1;
1473   }
1474 
1475   /**
1476    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1477    * The call is not executed if the target address is not a contract.
1478    *
1479    * @param from address representing the previous owner of the given token ID
1480    * @param to target address that will receive the tokens
1481    * @param tokenId uint256 ID of the token to be transferred
1482    * @param _data bytes optional data to send along with the call
1483    * @return bool whether the call correctly returned the expected magic value
1484    */
1485   function _checkOnERC721Received(
1486     address from,
1487     address to,
1488     uint256 tokenId,
1489     bytes memory _data
1490   ) private returns (bool) {
1491     if (to.isContract()) {
1492       try
1493         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1494       returns (bytes4 retval) {
1495         return retval == IERC721Receiver(to).onERC721Received.selector;
1496       } catch (bytes memory reason) {
1497         if (reason.length == 0) {
1498           revert("ERC721A: transfer to non ERC721Receiver implementer");
1499         } else {
1500           assembly {
1501             revert(add(32, reason), mload(reason))
1502           }
1503         }
1504       }
1505     } else {
1506       return true;
1507     }
1508   }
1509 
1510   /**
1511    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1512    *
1513    * startTokenId - the first token id to be transferred
1514    * quantity - the amount to be transferred
1515    *
1516    * Calling conditions:
1517    *
1518    * - When from and to are both non-zero, from's tokenId will be
1519    * transferred to to.
1520    * - When from is zero, tokenId will be minted for to.
1521    */
1522   function _beforeTokenTransfers(
1523     address from,
1524     address to,
1525     uint256 startTokenId,
1526     uint256 quantity
1527   ) internal virtual {}
1528 
1529   /**
1530    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1531    * minting.
1532    *
1533    * startTokenId - the first token id to be transferred
1534    * quantity - the amount to be transferred
1535    *
1536    * Calling conditions:
1537    *
1538    * - when from and to are both non-zero.
1539    * - from and to are never both zero.
1540    */
1541   function _afterTokenTransfers(
1542     address from,
1543     address to,
1544     uint256 startTokenId,
1545     uint256 quantity
1546   ) internal virtual {}
1547 }
1548 
1549 
1550 
1551   
1552 abstract contract Ramppable {
1553   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1554 
1555   modifier isRampp() {
1556       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1557       _;
1558   }
1559 }
1560 
1561 
1562   
1563   
1564 interface IERC20 {
1565   function allowance(address owner, address spender) external view returns (uint256);
1566   function transfer(address _to, uint256 _amount) external returns (bool);
1567   function balanceOf(address account) external view returns (uint256);
1568   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1569 }
1570 
1571 // File: WithdrawableV2
1572 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1573 // ERC-20 Payouts are limited to a single payout address. This feature 
1574 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1575 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1576 abstract contract WithdrawableV2 is Teams, Ramppable {
1577   struct acceptedERC20 {
1578     bool isActive;
1579     uint256 chargeAmount;
1580   }
1581 
1582   
1583   mapping(address => acceptedERC20) private allowedTokenContracts;
1584   address[] public payableAddresses = [RAMPPADDRESS,0xb32dfe230669f756073735171866D70447D59c4d];
1585   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1586   address public erc20Payable = 0xb32dfe230669f756073735171866D70447D59c4d;
1587   uint256[] public payableFees = [5,95];
1588   uint256[] public surchargePayableFees = [100];
1589   uint256 public payableAddressCount = 2;
1590   uint256 public surchargePayableAddressCount = 1;
1591   uint256 public ramppSurchargeBalance = 0 ether;
1592   uint256 public ramppSurchargeFee = 0.001 ether;
1593   bool public onlyERC20MintingMode = false;
1594   
1595 
1596   /**
1597   * @dev Calculates the true payable balance of the contract as the
1598   * value on contract may be from ERC-20 mint surcharges and not 
1599   * public mint charges - which are not eligable for rev share & user withdrawl
1600   */
1601   function calcAvailableBalance() public view returns(uint256) {
1602     return address(this).balance - ramppSurchargeBalance;
1603   }
1604 
1605   function withdrawAll() public onlyTeamOrOwner {
1606       require(calcAvailableBalance() > 0);
1607       _withdrawAll();
1608   }
1609   
1610   function withdrawAllRampp() public isRampp {
1611       require(calcAvailableBalance() > 0);
1612       _withdrawAll();
1613   }
1614 
1615   function _withdrawAll() private {
1616       uint256 balance = calcAvailableBalance();
1617       
1618       for(uint i=0; i < payableAddressCount; i++ ) {
1619           _widthdraw(
1620               payableAddresses[i],
1621               (balance * payableFees[i]) / 100
1622           );
1623       }
1624   }
1625   
1626   function _widthdraw(address _address, uint256 _amount) private {
1627       (bool success, ) = _address.call{value: _amount}("");
1628       require(success, "Transfer failed.");
1629   }
1630 
1631   /**
1632   * @dev This function is similiar to the regular withdraw but operates only on the
1633   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1634   **/
1635   function _withdrawAllSurcharges() private {
1636     uint256 balance = ramppSurchargeBalance;
1637     if(balance == 0) { return; }
1638     
1639     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1640         _widthdraw(
1641             surchargePayableAddresses[i],
1642             (balance * surchargePayableFees[i]) / 100
1643         );
1644     }
1645     ramppSurchargeBalance = 0 ether;
1646   }
1647 
1648   /**
1649   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1650   * in the event ERC-20 tokens are paid to the contract for mints. This will
1651   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1652   * @param _tokenContract contract of ERC-20 token to withdraw
1653   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1654   */
1655   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1656     require(_amountToWithdraw > 0);
1657     IERC20 tokenContract = IERC20(_tokenContract);
1658     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1659     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1660     _withdrawAllSurcharges();
1661   }
1662 
1663   /**
1664   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1665   */
1666   function withdrawRamppSurcharges() public isRampp {
1667     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1668     _withdrawAllSurcharges();
1669   }
1670 
1671    /**
1672   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1673   */
1674   function addSurcharge() internal {
1675     ramppSurchargeBalance += ramppSurchargeFee;
1676   }
1677   
1678   /**
1679   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1680   */
1681   function hasSurcharge() internal returns(bool) {
1682     return msg.value == ramppSurchargeFee;
1683   }
1684 
1685   /**
1686   * @dev Set surcharge fee for using ERC-20 payments on contract
1687   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1688   */
1689   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1690     ramppSurchargeFee = _newSurcharge;
1691   }
1692 
1693   /**
1694   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1695   * @param _erc20TokenContract address of ERC-20 contract in question
1696   */
1697   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1698     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1699   }
1700 
1701   /**
1702   * @dev get the value of tokens to transfer for user of an ERC-20
1703   * @param _erc20TokenContract address of ERC-20 contract in question
1704   */
1705   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1706     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1707     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1708   }
1709 
1710   /**
1711   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1712   * @param _erc20TokenContract address of ERC-20 contract in question
1713   * @param _isActive default status of if contract should be allowed to accept payments
1714   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1715   */
1716   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1717     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1718     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1719   }
1720 
1721   /**
1722   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1723   * it will assume the default value of zero. This should not be used to create new payment tokens.
1724   * @param _erc20TokenContract address of ERC-20 contract in question
1725   */
1726   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1727     allowedTokenContracts[_erc20TokenContract].isActive = true;
1728   }
1729 
1730   /**
1731   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1732   * it will assume the default value of zero. This should not be used to create new payment tokens.
1733   * @param _erc20TokenContract address of ERC-20 contract in question
1734   */
1735   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1736     allowedTokenContracts[_erc20TokenContract].isActive = false;
1737   }
1738 
1739   /**
1740   * @dev Enable only ERC-20 payments for minting on this contract
1741   */
1742   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1743     onlyERC20MintingMode = true;
1744   }
1745 
1746   /**
1747   * @dev Disable only ERC-20 payments for minting on this contract
1748   */
1749   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1750     onlyERC20MintingMode = false;
1751   }
1752 
1753   /**
1754   * @dev Set the payout of the ERC-20 token payout to a specific address
1755   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1756   */
1757   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1758     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1759     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1760     erc20Payable = _newErc20Payable;
1761   }
1762 
1763   /**
1764   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1765   */
1766   function resetRamppSurchargeBalance() public isRampp {
1767     ramppSurchargeBalance = 0 ether;
1768   }
1769 
1770   /**
1771   * @dev Allows Rampp wallet to update its own reference as well as update
1772   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1773   * and since Rampp is always the first address this function is limited to the rampp payout only.
1774   * @param _newAddress updated Rampp Address
1775   */
1776   function setRamppAddress(address _newAddress) public isRampp {
1777     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1778     RAMPPADDRESS = _newAddress;
1779     payableAddresses[0] = _newAddress;
1780   }
1781 }
1782 
1783 
1784   
1785   
1786   
1787 // File: EarlyMintIncentive.sol
1788 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1789 // zero fee that can be calculated on the fly.
1790 abstract contract EarlyMintIncentive is Teams, ERC721A {
1791   uint256 public PRICE = 0.004 ether;
1792   uint256 public EARLY_MINT_PRICE = 0 ether;
1793   uint256 public earlyMintOwnershipCap = 1;
1794   bool public usingEarlyMintIncentive = true;
1795 
1796   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1797     usingEarlyMintIncentive = true;
1798   }
1799 
1800   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1801     usingEarlyMintIncentive = false;
1802   }
1803 
1804   /**
1805   * @dev Set the max token ID in which the cost incentive will be applied.
1806   * @param _newCap max number of tokens wallet may mint for incentive price
1807   */
1808   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1809     require(_newCap >= 1, "Cannot set cap to less than 1");
1810     earlyMintOwnershipCap = _newCap;
1811   }
1812 
1813   /**
1814   * @dev Set the incentive mint price
1815   * @param _feeInWei new price per token when in incentive range
1816   */
1817   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1818     EARLY_MINT_PRICE = _feeInWei;
1819   }
1820 
1821   /**
1822   * @dev Set the primary mint price - the base price when not under incentive
1823   * @param _feeInWei new price per token
1824   */
1825   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1826     PRICE = _feeInWei;
1827   }
1828 
1829   /**
1830   * @dev Get the correct price for the mint for qty and person minting
1831   * @param _count amount of tokens to calc for mint
1832   * @param _to the address which will be minting these tokens, passed explicitly
1833   */
1834   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1835     require(_count > 0, "Must be minting at least 1 token.");
1836 
1837     // short circuit function if we dont need to even calc incentive pricing
1838     // short circuit if the current wallet mint qty is also already over cap
1839     if(
1840       usingEarlyMintIncentive == false ||
1841       _numberMinted(_to) > earlyMintOwnershipCap
1842     ) {
1843       return PRICE * _count;
1844     }
1845 
1846     uint256 endingTokenQty = _numberMinted(_to) + _count;
1847     // If qty to mint results in a final qty less than or equal to the cap then
1848     // the entire qty is within incentive mint.
1849     if(endingTokenQty  <= earlyMintOwnershipCap) {
1850       return EARLY_MINT_PRICE * _count;
1851     }
1852 
1853     // If the current token qty is less than the incentive cap
1854     // and the ending token qty is greater than the incentive cap
1855     // we will be straddling the cap so there will be some amount
1856     // that are incentive and some that are regular fee.
1857     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1858     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1859 
1860     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1861   }
1862 }
1863 
1864   
1865 abstract contract RamppERC721A is 
1866     Ownable,
1867     Teams,
1868     ERC721A,
1869     WithdrawableV2,
1870     ReentrancyGuard 
1871     , EarlyMintIncentive 
1872     , Allowlist 
1873     
1874 {
1875   constructor(
1876     string memory tokenName,
1877     string memory tokenSymbol
1878   ) ERC721A(tokenName, tokenSymbol, 6, 6666) { }
1879     uint8 public CONTRACT_VERSION = 2;
1880     string public _baseTokenURI = "https://api.dahmer.monster/";
1881 
1882     bool public mintingOpen = false;
1883     
1884     
1885     uint256 public MAX_WALLET_MINTS = 6;
1886 
1887   
1888     /////////////// Admin Mint Functions
1889     /**
1890      * @dev Mints a token to an address with a tokenURI.
1891      * This is owner only and allows a fee-free drop
1892      * @param _to address of the future owner of the token
1893      * @param _qty amount of tokens to drop the owner
1894      */
1895      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1896          require(_qty > 0, "Must mint at least 1 token.");
1897          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 6666");
1898          _safeMint(_to, _qty, true);
1899      }
1900 
1901   
1902     /////////////// GENERIC MINT FUNCTIONS
1903     /**
1904     * @dev Mints a single token to an address.
1905     * fee may or may not be required*
1906     * @param _to address of the future owner of the token
1907     */
1908     function mintTo(address _to) public payable {
1909         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1910         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6666");
1911         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1912         
1913         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1914         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1915 
1916         _safeMint(_to, 1, false);
1917     }
1918 
1919     /**
1920     * @dev Mints tokens to an address in batch.
1921     * fee may or may not be required*
1922     * @param _to address of the future owner of the token
1923     * @param _amount number of tokens to mint
1924     */
1925     function mintToMultiple(address _to, uint256 _amount) public payable {
1926         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1927         require(_amount >= 1, "Must mint at least 1 token");
1928         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1929         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1930         
1931         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1932         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6666");
1933         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1934 
1935         _safeMint(_to, _amount, false);
1936     }
1937 
1938     /**
1939      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1940      * fee may or may not be required*
1941      * @param _to address of the future owner of the token
1942      * @param _amount number of tokens to mint
1943      * @param _erc20TokenContract erc-20 token contract to mint with
1944      */
1945     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1946       require(_amount >= 1, "Must mint at least 1 token");
1947       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1948       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6666");
1949       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1950       
1951       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1952 
1953       // ERC-20 Specific pre-flight checks
1954       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1955       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1956       IERC20 payableToken = IERC20(_erc20TokenContract);
1957 
1958       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1959       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1960       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1961       
1962       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1963       require(transferComplete, "ERC-20 token was unable to be transferred");
1964       
1965       _safeMint(_to, _amount, false);
1966       addSurcharge();
1967     }
1968 
1969     function openMinting() public onlyTeamOrOwner {
1970         mintingOpen = true;
1971     }
1972 
1973     function stopMinting() public onlyTeamOrOwner {
1974         mintingOpen = false;
1975     }
1976 
1977   
1978     ///////////// ALLOWLIST MINTING FUNCTIONS
1979 
1980     /**
1981     * @dev Mints tokens to an address using an allowlist.
1982     * fee may or may not be required*
1983     * @param _to address of the future owner of the token
1984     * @param _merkleProof merkle proof array
1985     */
1986     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1987         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1988         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1989         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1990         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6666");
1991         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1992         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1993         
1994 
1995         _safeMint(_to, 1, false);
1996     }
1997 
1998     /**
1999     * @dev Mints tokens to an address using an allowlist.
2000     * fee may or may not be required*
2001     * @param _to address of the future owner of the token
2002     * @param _amount number of tokens to mint
2003     * @param _merkleProof merkle proof array
2004     */
2005     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2006         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2007         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2008         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2009         require(_amount >= 1, "Must mint at least 1 token");
2010         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2011 
2012         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2013         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6666");
2014         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
2015         
2016 
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
2029       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2030       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2031       require(_amount >= 1, "Must mint at least 1 token");
2032       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2033       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2034       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6666");
2035       
2036     
2037       // ERC-20 Specific pre-flight checks
2038       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2039       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2040       IERC20 payableToken = IERC20(_erc20TokenContract);
2041     
2042       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2043       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2044       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2045       
2046       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2047       require(transferComplete, "ERC-20 token was unable to be transferred");
2048       
2049       _safeMint(_to, _amount, false);
2050       addSurcharge();
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
2078         require(_amount >= 1, "Amount must be greater than or equal to 1");
2079         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2080     }
2081 
2082     /**
2083     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2084     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2085     */
2086     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2087         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
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
2098          require(_newMaxMint >= 1, "Max mint must be at least 1");
2099          maxBatchSize = _newMaxMint;
2100      }
2101     
2102 
2103   
2104 
2105   function _baseURI() internal view virtual override returns(string memory) {
2106     return _baseTokenURI;
2107   }
2108 
2109   function baseTokenURI() public view returns(string memory) {
2110     return _baseTokenURI;
2111   }
2112 
2113   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2114     _baseTokenURI = baseURI;
2115   }
2116 
2117   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2118     return ownershipOf(tokenId);
2119   }
2120 }
2121 
2122 
2123   
2124 // File: contracts/DahmermonsterContract.sol
2125 //SPDX-License-Identifier: MIT
2126 
2127 pragma solidity ^0.8.0;
2128 
2129 contract DahmermonsterContract is RamppERC721A {
2130     constructor() RamppERC721A("DAHMER MONSTER", "DAHMER"){}
2131 }
2132   