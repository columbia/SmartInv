1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // CHUNGO CHUNGO CHUNGO
5 //
6 //*********************************************************************//
7 //*********************************************************************//
8   
9 //-------------DEPENDENCIES--------------------------//
10 
11 // File: @openzeppelin/contracts/utils/Address.sol
12 
13 
14 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
15 
16 pragma solidity ^0.8.1;
17 
18 /**
19  * @dev Collection of functions related to the address type
20  */
21 library Address {
22     /**
23      * @dev Returns true if account is a contract.
24      *
25      * [IMPORTANT]
26      * ====
27      * It is unsafe to assume that an address for which this function returns
28      * false is an externally-owned account (EOA) and not a contract.
29      *
30      * Among others, isContract will return false for the following
31      * types of addresses:
32      *
33      *  - an externally-owned account
34      *  - a contract in construction
35      *  - an address where a contract will be created
36      *  - an address where a contract lived, but was destroyed
37      * ====
38      *
39      * [IMPORTANT]
40      * ====
41      * You shouldn't rely on isContract to protect against flash loan attacks!
42      *
43      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
44      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
45      * constructor.
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // This method relies on extcodesize/address.code.length, which returns 0
50         // for contracts in construction, since the code is only stored at the end
51         // of the constructor execution.
52 
53         return account.code.length > 0;
54     }
55 
56     /**
57      * @dev Replacement for Solidity's transfer: sends amount wei to
58      * recipient, forwarding all available gas and reverting on errors.
59      *
60      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
61      * of certain opcodes, possibly making contracts go over the 2300 gas limit
62      * imposed by transfer, making them unable to receive funds via
63      * transfer. {sendValue} removes this limitation.
64      *
65      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
66      *
67      * IMPORTANT: because control is transferred to recipient, care must be
68      * taken to not create reentrancy vulnerabilities. Consider using
69      * {ReentrancyGuard} or the
70      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
71      */
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         (bool success, ) = recipient.call{value: amount}("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level call. A
81      * plain call is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If target reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
89      *
90      * Requirements:
91      *
92      * - target must be a contract.
93      * - calling target with data must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCall(target, data, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
103      * errorMessage as a fallback revert reason when target reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
117      * but also transferring value wei to target.
118      *
119      * Requirements:
120      *
121      * - the calling contract must have an ETH balance of at least value.
122      * - the called Solidity function must be payable.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
136      * with errorMessage as a fallback revert reason when target reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         require(isContract(target), "Address: call to non-contract");
148 
149         (bool success, bytes memory returndata) = target.call{value: value}(data);
150         return verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal view returns (bytes memory) {
174         require(isContract(target), "Address: static call to non-contract");
175 
176         (bool success, bytes memory returndata) = target.staticcall(data);
177         return verifyCallResult(success, returndata, errorMessage);
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
187         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
192      * but performing a delegate call.
193      *
194      * _Available since v3.4._
195      */
196     function functionDelegateCall(
197         address target,
198         bytes memory data,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(isContract(target), "Address: delegate call to non-contract");
202 
203         (bool success, bytes memory returndata) = target.delegatecall(data);
204         return verifyCallResult(success, returndata, errorMessage);
205     }
206 
207     /**
208      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
209      * revert reason using the provided one.
210      *
211      * _Available since v4.3._
212      */
213     function verifyCallResult(
214         bool success,
215         bytes memory returndata,
216         string memory errorMessage
217     ) internal pure returns (bytes memory) {
218         if (success) {
219             return returndata;
220         } else {
221             // Look for revert reason and bubble it up if present
222             if (returndata.length > 0) {
223                 // The easiest way to bubble the revert reason is using memory via assembly
224 
225                 assembly {
226                     let returndata_size := mload(returndata)
227                     revert(add(32, returndata), returndata_size)
228                 }
229             } else {
230                 revert(errorMessage);
231             }
232         }
233     }
234 }
235 
236 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
237 
238 
239 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @title ERC721 token receiver interface
245  * @dev Interface for any contract that wants to support safeTransfers
246  * from ERC721 asset contracts.
247  */
248 interface IERC721Receiver {
249     /**
250      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
251      * by operator from from, this function is called.
252      *
253      * It must return its Solidity selector to confirm the token transfer.
254      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
255      *
256      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
257      */
258     function onERC721Received(
259         address operator,
260         address from,
261         uint256 tokenId,
262         bytes calldata data
263     ) external returns (bytes4);
264 }
265 
266 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev Interface of the ERC165 standard, as defined in the
275  * https://eips.ethereum.org/EIPS/eip-165[EIP].
276  *
277  * Implementers can declare support of contract interfaces, which can then be
278  * queried by others ({ERC165Checker}).
279  *
280  * For an implementation, see {ERC165}.
281  */
282 interface IERC165 {
283     /**
284      * @dev Returns true if this contract implements the interface defined by
285      * interfaceId. See the corresponding
286      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
287      * to learn more about how these ids are created.
288      *
289      * This function call must use less than 30 000 gas.
290      */
291     function supportsInterface(bytes4 interfaceId) external view returns (bool);
292 }
293 
294 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
306  * for the additional interface id that will be supported. For example:
307  *
308  * solidity
309  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
311  * }
312  * 
313  *
314  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
315  */
316 abstract contract ERC165 is IERC165 {
317     /**
318      * @dev See {IERC165-supportsInterface}.
319      */
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 
333 /**
334  * @dev Required interface of an ERC721 compliant contract.
335  */
336 interface IERC721 is IERC165 {
337     /**
338      * @dev Emitted when tokenId token is transferred from from to to.
339      */
340     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
341 
342     /**
343      * @dev Emitted when owner enables approved to manage the tokenId token.
344      */
345     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
346 
347     /**
348      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
349      */
350     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
351 
352     /**
353      * @dev Returns the number of tokens in owner's account.
354      */
355     function balanceOf(address owner) external view returns (uint256 balance);
356 
357     /**
358      * @dev Returns the owner of the tokenId token.
359      *
360      * Requirements:
361      *
362      * - tokenId must exist.
363      */
364     function ownerOf(uint256 tokenId) external view returns (address owner);
365 
366     /**
367      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
368      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
369      *
370      * Requirements:
371      *
372      * - from cannot be the zero address.
373      * - to cannot be the zero address.
374      * - tokenId token must exist and be owned by from.
375      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
376      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
377      *
378      * Emits a {Transfer} event.
379      */
380     function safeTransferFrom(
381         address from,
382         address to,
383         uint256 tokenId
384     ) external;
385 
386     /**
387      * @dev Transfers tokenId token from from to to.
388      *
389      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
390      *
391      * Requirements:
392      *
393      * - from cannot be the zero address.
394      * - to cannot be the zero address.
395      * - tokenId token must be owned by from.
396      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) external;
405 
406     /**
407      * @dev Gives permission to to to transfer tokenId token to another account.
408      * The approval is cleared when the token is transferred.
409      *
410      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
411      *
412      * Requirements:
413      *
414      * - The caller must own the token or be an approved operator.
415      * - tokenId must exist.
416      *
417      * Emits an {Approval} event.
418      */
419     function approve(address to, uint256 tokenId) external;
420 
421     /**
422      * @dev Returns the account approved for tokenId token.
423      *
424      * Requirements:
425      *
426      * - tokenId must exist.
427      */
428     function getApproved(uint256 tokenId) external view returns (address operator);
429 
430     /**
431      * @dev Approve or remove operator as an operator for the caller.
432      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
433      *
434      * Requirements:
435      *
436      * - The operator cannot be the caller.
437      *
438      * Emits an {ApprovalForAll} event.
439      */
440     function setApprovalForAll(address operator, bool _approved) external;
441 
442     /**
443      * @dev Returns if the operator is allowed to manage all of the assets of owner.
444      *
445      * See {setApprovalForAll}
446      */
447     function isApprovedForAll(address owner, address operator) external view returns (bool);
448 
449     /**
450      * @dev Safely transfers tokenId token from from to to.
451      *
452      * Requirements:
453      *
454      * - from cannot be the zero address.
455      * - to cannot be the zero address.
456      * - tokenId token must exist and be owned by from.
457      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
458      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
459      *
460      * Emits a {Transfer} event.
461      */
462     function safeTransferFrom(
463         address from,
464         address to,
465         uint256 tokenId,
466         bytes calldata data
467     ) external;
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
471 
472 
473 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
480  * @dev See https://eips.ethereum.org/EIPS/eip-721
481  */
482 interface IERC721Enumerable is IERC721 {
483     /**
484      * @dev Returns the total amount of tokens stored by the contract.
485      */
486     function totalSupply() external view returns (uint256);
487 
488     /**
489      * @dev Returns a token ID owned by owner at a given index of its token list.
490      * Use along with {balanceOf} to enumerate all of owner's tokens.
491      */
492     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
493 
494     /**
495      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
496      * Use along with {totalSupply} to enumerate all tokens.
497      */
498     function tokenByIndex(uint256 index) external view returns (uint256);
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
502 
503 
504 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 
509 /**
510  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
511  * @dev See https://eips.ethereum.org/EIPS/eip-721
512  */
513 interface IERC721Metadata is IERC721 {
514     /**
515      * @dev Returns the token collection name.
516      */
517     function name() external view returns (string memory);
518 
519     /**
520      * @dev Returns the token collection symbol.
521      */
522     function symbol() external view returns (string memory);
523 
524     /**
525      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
526      */
527     function tokenURI(uint256 tokenId) external view returns (string memory);
528 }
529 
530 // File: @openzeppelin/contracts/utils/Strings.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev String operations.
539  */
540 library Strings {
541     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
542 
543     /**
544      * @dev Converts a uint256 to its ASCII string decimal representation.
545      */
546     function toString(uint256 value) internal pure returns (string memory) {
547         // Inspired by OraclizeAPI's implementation - MIT licence
548         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
549 
550         if (value == 0) {
551             return "0";
552         }
553         uint256 temp = value;
554         uint256 digits;
555         while (temp != 0) {
556             digits++;
557             temp /= 10;
558         }
559         bytes memory buffer = new bytes(digits);
560         while (value != 0) {
561             digits -= 1;
562             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
563             value /= 10;
564         }
565         return string(buffer);
566     }
567 
568     /**
569      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
570      */
571     function toHexString(uint256 value) internal pure returns (string memory) {
572         if (value == 0) {
573             return "0x00";
574         }
575         uint256 temp = value;
576         uint256 length = 0;
577         while (temp != 0) {
578             length++;
579             temp >>= 8;
580         }
581         return toHexString(value, length);
582     }
583 
584     /**
585      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
586      */
587     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
588         bytes memory buffer = new bytes(2 * length + 2);
589         buffer[0] = "0";
590         buffer[1] = "x";
591         for (uint256 i = 2 * length + 1; i > 1; --i) {
592             buffer[i] = _HEX_SYMBOLS[value & 0xf];
593             value >>= 4;
594         }
595         require(value == 0, "Strings: hex length insufficient");
596         return string(buffer);
597     }
598 }
599 
600 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Contract module that helps prevent reentrant calls to a function.
609  *
610  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
611  * available, which can be applied to functions to make sure there are no nested
612  * (reentrant) calls to them.
613  *
614  * Note that because there is a single nonReentrant guard, functions marked as
615  * nonReentrant may not call one another. This can be worked around by making
616  * those functions private, and then adding external nonReentrant entry
617  * points to them.
618  *
619  * TIP: If you would like to learn more about reentrancy and alternative ways
620  * to protect against it, check out our blog post
621  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
622  */
623 abstract contract ReentrancyGuard {
624     // Booleans are more expensive than uint256 or any type that takes up a full
625     // word because each write operation emits an extra SLOAD to first read the
626     // slot's contents, replace the bits taken up by the boolean, and then write
627     // back. This is the compiler's defense against contract upgrades and
628     // pointer aliasing, and it cannot be disabled.
629 
630     // The values being non-zero value makes deployment a bit more expensive,
631     // but in exchange the refund on every call to nonReentrant will be lower in
632     // amount. Since refunds are capped to a percentage of the total
633     // transaction's gas, it is best to keep them low in cases like this one, to
634     // increase the likelihood of the full refund coming into effect.
635     uint256 private constant _NOT_ENTERED = 1;
636     uint256 private constant _ENTERED = 2;
637 
638     uint256 private _status;
639 
640     constructor() {
641         _status = _NOT_ENTERED;
642     }
643 
644     /**
645      * @dev Prevents a contract from calling itself, directly or indirectly.
646      * Calling a nonReentrant function from another nonReentrant
647      * function is not supported. It is possible to prevent this from happening
648      * by making the nonReentrant function external, and making it call a
649      * private function that does the actual work.
650      */
651     modifier nonReentrant() {
652         // On the first call to nonReentrant, _notEntered will be true
653         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
654 
655         // Any calls to nonReentrant after this point will fail
656         _status = _ENTERED;
657 
658         _;
659 
660         // By storing the original value once again, a refund is triggered (see
661         // https://eips.ethereum.org/EIPS/eip-2200)
662         _status = _NOT_ENTERED;
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/Context.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Provides information about the current execution context, including the
675  * sender of the transaction and its data. While these are generally available
676  * via msg.sender and msg.data, they should not be accessed in such a direct
677  * manner, since when dealing with meta-transactions the account sending and
678  * paying for execution may not be the actual sender (as far as an application
679  * is concerned).
680  *
681  * This contract is only required for intermediate, library-like contracts.
682  */
683 abstract contract Context {
684     function _msgSender() internal view virtual returns (address) {
685         return msg.sender;
686     }
687 
688     function _msgData() internal view virtual returns (bytes calldata) {
689         return msg.data;
690     }
691 }
692 
693 // File: @openzeppelin/contracts/access/Ownable.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Contract module which provides a basic access control mechanism, where
703  * there is an account (an owner) that can be granted exclusive access to
704  * specific functions.
705  *
706  * By default, the owner account will be the one that deploys the contract. This
707  * can later be changed with {transferOwnership}.
708  *
709  * This module is used through inheritance. It will make available the modifier
710  * onlyOwner, which can be applied to your functions to restrict their use to
711  * the owner.
712  */
713 abstract contract Ownable is Context {
714     address private _owner;
715 
716     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
717 
718     /**
719      * @dev Initializes the contract setting the deployer as the initial owner.
720      */
721     constructor() {
722         _transferOwnership(_msgSender());
723     }
724 
725     /**
726      * @dev Returns the address of the current owner.
727      */
728     function owner() public view virtual returns (address) {
729         return _owner;
730     }
731 
732     /**
733      * @dev Throws if called by any account other than the owner.
734      */
735     function _onlyOwner() private view {
736        require(owner() == _msgSender(), "Ownable: caller is not the owner");
737     }
738 
739     modifier onlyOwner() {
740         _onlyOwner();
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
774 
775 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
776 pragma solidity ^0.8.9;
777 
778 interface IOperatorFilterRegistry {
779     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
780     function register(address registrant) external;
781     function registerAndSubscribe(address registrant, address subscription) external;
782     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
783     function updateOperator(address registrant, address operator, bool filtered) external;
784     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
785     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
786     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
787     function subscribe(address registrant, address registrantToSubscribe) external;
788     function unsubscribe(address registrant, bool copyExistingEntries) external;
789     function subscriptionOf(address addr) external returns (address registrant);
790     function subscribers(address registrant) external returns (address[] memory);
791     function subscriberAt(address registrant, uint256 index) external returns (address);
792     function copyEntriesOf(address registrant, address registrantToCopy) external;
793     function isOperatorFiltered(address registrant, address operator) external returns (bool);
794     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
795     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
796     function filteredOperators(address addr) external returns (address[] memory);
797     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
798     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
799     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
800     function isRegistered(address addr) external returns (bool);
801     function codeHashOf(address addr) external returns (bytes32);
802 }
803 
804 // File contracts/OperatorFilter/OperatorFilterer.sol
805 pragma solidity ^0.8.9;
806 
807 abstract contract OperatorFilterer {
808     error OperatorNotAllowed(address operator);
809 
810     IOperatorFilterRegistry constant operatorFilterRegistry =
811         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
812 
813     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
814         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
815         // will not revert, but the contract will need to be registered with the registry once it is deployed in
816         // order for the modifier to filter addresses.
817         if (address(operatorFilterRegistry).code.length > 0) {
818             if (subscribe) {
819                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
820             } else {
821                 if (subscriptionOrRegistrantToCopy != address(0)) {
822                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
823                 } else {
824                     operatorFilterRegistry.register(address(this));
825                 }
826             }
827         }
828     }
829 
830     function _onlyAllowedOperator(address from) private view {
831       if (
832           !(
833               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
834               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
835           )
836       ) {
837           revert OperatorNotAllowed(msg.sender);
838       }
839     }
840 
841     modifier onlyAllowedOperator(address from) virtual {
842         // Check registry code length to facilitate testing in environments without a deployed registry.
843         if (address(operatorFilterRegistry).code.length > 0) {
844             // Allow spending tokens from addresses with balance
845             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
846             // from an EOA.
847             if (from == msg.sender) {
848                 _;
849                 return;
850             }
851             _onlyAllowedOperator(from);
852         }
853         _;
854     }
855 
856     modifier onlyAllowedOperatorApproval(address operator) virtual {
857         _checkFilterOperator(operator);
858         _;
859     }
860 
861     function _checkFilterOperator(address operator) internal view virtual {
862         // Check registry code length to facilitate testing in environments without a deployed registry.
863         if (address(operatorFilterRegistry).code.length > 0) {
864             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
865                 revert OperatorNotAllowed(operator);
866             }
867         }
868     }
869 }
870 
871 //-------------END DEPENDENCIES------------------------//
872 
873 
874   
875 error TransactionCapExceeded();
876 error PublicMintingClosed();
877 error ExcessiveOwnedMints();
878 error MintZeroQuantity();
879 error InvalidPayment();
880 error CapExceeded();
881 error IsAlreadyUnveiled();
882 error ValueCannotBeZero();
883 error CannotBeNullAddress();
884 error NoStateChange();
885 
886 error PublicMintClosed();
887 error AllowlistMintClosed();
888 
889 error AddressNotAllowlisted();
890 error AllowlistDropTimeHasNotPassed();
891 error PublicDropTimeHasNotPassed();
892 error DropTimeNotInFuture();
893 
894 error OnlyERC20MintingEnabled();
895 error ERC20TokenNotApproved();
896 error ERC20InsufficientBalance();
897 error ERC20InsufficientAllowance();
898 error ERC20TransferFailed();
899 
900 error ClaimModeDisabled();
901 error IneligibleRedemptionContract();
902 error TokenAlreadyRedeemed();
903 error InvalidOwnerForRedemption();
904 error InvalidApprovalForRedemption();
905 
906 error ERC721RestrictedApprovalAddressRestricted();
907   
908   
909 // Rampp Contracts v2.1 (Teams.sol)
910 
911 error InvalidTeamAddress();
912 error DuplicateTeamAddress();
913 pragma solidity ^0.8.0;
914 
915 /**
916 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
917 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
918 * This will easily allow cross-collaboration via Mintplex.xyz.
919 **/
920 abstract contract Teams is Ownable{
921   mapping (address => bool) internal team;
922 
923   /**
924   * @dev Adds an address to the team. Allows them to execute protected functions
925   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
926   **/
927   function addToTeam(address _address) public onlyOwner {
928     if(_address == address(0)) revert InvalidTeamAddress();
929     if(inTeam(_address)) revert DuplicateTeamAddress();
930   
931     team[_address] = true;
932   }
933 
934   /**
935   * @dev Removes an address to the team.
936   * @param _address the ETH address to remove, cannot be 0x and must be in team
937   **/
938   function removeFromTeam(address _address) public onlyOwner {
939     if(_address == address(0)) revert InvalidTeamAddress();
940     if(!inTeam(_address)) revert InvalidTeamAddress();
941   
942     team[_address] = false;
943   }
944 
945   /**
946   * @dev Check if an address is valid and active in the team
947   * @param _address ETH address to check for truthiness
948   **/
949   function inTeam(address _address)
950     public
951     view
952     returns (bool)
953   {
954     if(_address == address(0)) revert InvalidTeamAddress();
955     return team[_address] == true;
956   }
957 
958   /**
959   * @dev Throws if called by any account other than the owner or team member.
960   */
961   function _onlyTeamOrOwner() private view {
962     bool _isOwner = owner() == _msgSender();
963     bool _isTeam = inTeam(_msgSender());
964     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
965   }
966 
967   modifier onlyTeamOrOwner() {
968     _onlyTeamOrOwner();
969     _;
970   }
971 }
972 
973 
974   
975   pragma solidity ^0.8.0;
976 
977   /**
978   * @dev These functions deal with verification of Merkle Trees proofs.
979   *
980   * The proofs can be generated using the JavaScript library
981   * https://github.com/miguelmota/merkletreejs[merkletreejs].
982   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
983   *
984   *
985   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
986   * hashing, or use a hash function other than keccak256 for hashing leaves.
987   * This is because the concatenation of a sorted pair of internal nodes in
988   * the merkle tree could be reinterpreted as a leaf value.
989   */
990   library MerkleProof {
991       /**
992       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
993       * defined by 'root'. For this, a 'proof' must be provided, containing
994       * sibling hashes on the branch from the leaf to the root of the tree. Each
995       * pair of leaves and each pair of pre-images are assumed to be sorted.
996       */
997       function verify(
998           bytes32[] memory proof,
999           bytes32 root,
1000           bytes32 leaf
1001       ) internal pure returns (bool) {
1002           return processProof(proof, leaf) == root;
1003       }
1004 
1005       /**
1006       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1007       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1008       * hash matches the root of the tree. When processing the proof, the pairs
1009       * of leafs & pre-images are assumed to be sorted.
1010       *
1011       * _Available since v4.4._
1012       */
1013       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1014           bytes32 computedHash = leaf;
1015           for (uint256 i = 0; i < proof.length; i++) {
1016               bytes32 proofElement = proof[i];
1017               if (computedHash <= proofElement) {
1018                   // Hash(current computed hash + current element of the proof)
1019                   computedHash = _efficientHash(computedHash, proofElement);
1020               } else {
1021                   // Hash(current element of the proof + current computed hash)
1022                   computedHash = _efficientHash(proofElement, computedHash);
1023               }
1024           }
1025           return computedHash;
1026       }
1027 
1028       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1029           assembly {
1030               mstore(0x00, a)
1031               mstore(0x20, b)
1032               value := keccak256(0x00, 0x40)
1033           }
1034       }
1035   }
1036 
1037 
1038   // File: Allowlist.sol
1039 
1040   pragma solidity ^0.8.0;
1041 
1042   abstract contract Allowlist is Teams {
1043     bytes32 public merkleRoot;
1044     bool public onlyAllowlistMode = false;
1045 
1046     /**
1047      * @dev Update merkle root to reflect changes in Allowlist
1048      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1049      */
1050     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1051       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1052       merkleRoot = _newMerkleRoot;
1053     }
1054 
1055     /**
1056      * @dev Check the proof of an address if valid for merkle root
1057      * @param _to address to check for proof
1058      * @param _merkleProof Proof of the address to validate against root and leaf
1059      */
1060     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1061       if(merkleRoot == 0) revert ValueCannotBeZero();
1062       bytes32 leaf = keccak256(abi.encodePacked(_to));
1063 
1064       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1065     }
1066 
1067     
1068     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1069       onlyAllowlistMode = true;
1070     }
1071 
1072     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1073         onlyAllowlistMode = false;
1074     }
1075   }
1076   
1077   
1078 /**
1079  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1080  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1081  *
1082  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1083  * 
1084  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1085  *
1086  * Does not support burning tokens to address(0).
1087  */
1088 contract ERC721A is
1089   Context,
1090   ERC165,
1091   IERC721,
1092   IERC721Metadata,
1093   IERC721Enumerable,
1094   Teams
1095   , OperatorFilterer
1096 {
1097   using Address for address;
1098   using Strings for uint256;
1099 
1100   struct TokenOwnership {
1101     address addr;
1102     uint64 startTimestamp;
1103   }
1104 
1105   struct AddressData {
1106     uint128 balance;
1107     uint128 numberMinted;
1108   }
1109 
1110   uint256 private currentIndex;
1111 
1112   uint256 public immutable collectionSize;
1113   uint256 public maxBatchSize;
1114 
1115   // Token name
1116   string private _name;
1117 
1118   // Token symbol
1119   string private _symbol;
1120 
1121   // Mapping from token ID to ownership details
1122   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1123   mapping(uint256 => TokenOwnership) private _ownerships;
1124 
1125   // Mapping owner address to address data
1126   mapping(address => AddressData) private _addressData;
1127 
1128   // Mapping from token ID to approved address
1129   mapping(uint256 => address) private _tokenApprovals;
1130 
1131   // Mapping from owner to operator approvals
1132   mapping(address => mapping(address => bool)) private _operatorApprovals;
1133 
1134   /* @dev Mapping of restricted operator approvals set by contract Owner
1135   * This serves as an optional addition to ERC-721 so
1136   * that the contract owner can elect to prevent specific addresses/contracts
1137   * from being marked as the approver for a token. The reason for this
1138   * is that some projects may want to retain control of where their tokens can/can not be listed
1139   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1140   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1141   */
1142   mapping(address => bool) public restrictedApprovalAddresses;
1143 
1144   /**
1145    * @dev
1146    * maxBatchSize refers to how much a minter can mint at a time.
1147    * collectionSize_ refers to how many tokens are in the collection.
1148    */
1149   constructor(
1150     string memory name_,
1151     string memory symbol_,
1152     uint256 maxBatchSize_,
1153     uint256 collectionSize_
1154   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1155     require(
1156       collectionSize_ > 0,
1157       "ERC721A: collection must have a nonzero supply"
1158     );
1159     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1160     _name = name_;
1161     _symbol = symbol_;
1162     maxBatchSize = maxBatchSize_;
1163     collectionSize = collectionSize_;
1164     currentIndex = _startTokenId();
1165   }
1166 
1167   /**
1168   * To change the starting tokenId, please override this function.
1169   */
1170   function _startTokenId() internal view virtual returns (uint256) {
1171     return 1;
1172   }
1173 
1174   /**
1175    * @dev See {IERC721Enumerable-totalSupply}.
1176    */
1177   function totalSupply() public view override returns (uint256) {
1178     return _totalMinted();
1179   }
1180 
1181   function currentTokenId() public view returns (uint256) {
1182     return _totalMinted();
1183   }
1184 
1185   function getNextTokenId() public view returns (uint256) {
1186       return _totalMinted() + 1;
1187   }
1188 
1189   /**
1190   * Returns the total amount of tokens minted in the contract.
1191   */
1192   function _totalMinted() internal view returns (uint256) {
1193     unchecked {
1194       return currentIndex - _startTokenId();
1195     }
1196   }
1197 
1198   /**
1199    * @dev See {IERC721Enumerable-tokenByIndex}.
1200    */
1201   function tokenByIndex(uint256 index) public view override returns (uint256) {
1202     require(index < totalSupply(), "ERC721A: global index out of bounds");
1203     return index;
1204   }
1205 
1206   /**
1207    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1208    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1209    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1210    */
1211   function tokenOfOwnerByIndex(address owner, uint256 index)
1212     public
1213     view
1214     override
1215     returns (uint256)
1216   {
1217     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1218     uint256 numMintedSoFar = totalSupply();
1219     uint256 tokenIdsIdx = 0;
1220     address currOwnershipAddr = address(0);
1221     for (uint256 i = 0; i < numMintedSoFar; i++) {
1222       TokenOwnership memory ownership = _ownerships[i];
1223       if (ownership.addr != address(0)) {
1224         currOwnershipAddr = ownership.addr;
1225       }
1226       if (currOwnershipAddr == owner) {
1227         if (tokenIdsIdx == index) {
1228           return i;
1229         }
1230         tokenIdsIdx++;
1231       }
1232     }
1233     revert("ERC721A: unable to get token of owner by index");
1234   }
1235 
1236   /**
1237    * @dev See {IERC165-supportsInterface}.
1238    */
1239   function supportsInterface(bytes4 interfaceId)
1240     public
1241     view
1242     virtual
1243     override(ERC165, IERC165)
1244     returns (bool)
1245   {
1246     return
1247       interfaceId == type(IERC721).interfaceId ||
1248       interfaceId == type(IERC721Metadata).interfaceId ||
1249       interfaceId == type(IERC721Enumerable).interfaceId ||
1250       super.supportsInterface(interfaceId);
1251   }
1252 
1253   /**
1254    * @dev See {IERC721-balanceOf}.
1255    */
1256   function balanceOf(address owner) public view override returns (uint256) {
1257     require(owner != address(0), "ERC721A: balance query for the zero address");
1258     return uint256(_addressData[owner].balance);
1259   }
1260 
1261   function _numberMinted(address owner) internal view returns (uint256) {
1262     require(
1263       owner != address(0),
1264       "ERC721A: number minted query for the zero address"
1265     );
1266     return uint256(_addressData[owner].numberMinted);
1267   }
1268 
1269   function ownershipOf(uint256 tokenId)
1270     internal
1271     view
1272     returns (TokenOwnership memory)
1273   {
1274     uint256 curr = tokenId;
1275 
1276     unchecked {
1277         if (_startTokenId() <= curr && curr < currentIndex) {
1278             TokenOwnership memory ownership = _ownerships[curr];
1279             if (ownership.addr != address(0)) {
1280                 return ownership;
1281             }
1282 
1283             // Invariant:
1284             // There will always be an ownership that has an address and is not burned
1285             // before an ownership that does not have an address and is not burned.
1286             // Hence, curr will not underflow.
1287             while (true) {
1288                 curr--;
1289                 ownership = _ownerships[curr];
1290                 if (ownership.addr != address(0)) {
1291                     return ownership;
1292                 }
1293             }
1294         }
1295     }
1296 
1297     revert("ERC721A: unable to determine the owner of token");
1298   }
1299 
1300   /**
1301    * @dev See {IERC721-ownerOf}.
1302    */
1303   function ownerOf(uint256 tokenId) public view override returns (address) {
1304     return ownershipOf(tokenId).addr;
1305   }
1306 
1307   /**
1308    * @dev See {IERC721Metadata-name}.
1309    */
1310   function name() public view virtual override returns (string memory) {
1311     return _name;
1312   }
1313 
1314   /**
1315    * @dev See {IERC721Metadata-symbol}.
1316    */
1317   function symbol() public view virtual override returns (string memory) {
1318     return _symbol;
1319   }
1320 
1321   /**
1322    * @dev See {IERC721Metadata-tokenURI}.
1323    */
1324   function tokenURI(uint256 tokenId)
1325     public
1326     view
1327     virtual
1328     override
1329     returns (string memory)
1330   {
1331     string memory baseURI = _baseURI();
1332     string memory extension = _baseURIExtension();
1333     return
1334       bytes(baseURI).length > 0
1335         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1336         : "";
1337   }
1338 
1339   /**
1340    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1341    * token will be the concatenation of the baseURI and the tokenId. Empty
1342    * by default, can be overriden in child contracts.
1343    */
1344   function _baseURI() internal view virtual returns (string memory) {
1345     return "";
1346   }
1347 
1348   /**
1349    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1350    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1351    * by default, can be overriden in child contracts.
1352    */
1353   function _baseURIExtension() internal view virtual returns (string memory) {
1354     return "";
1355   }
1356 
1357   /**
1358    * @dev Sets the value for an address to be in the restricted approval address pool.
1359    * Setting an address to true will disable token owners from being able to mark the address
1360    * for approval for trading. This would be used in theory to prevent token owners from listing
1361    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1362    * @param _address the marketplace/user to modify restriction status of
1363    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1364    */
1365   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1366     restrictedApprovalAddresses[_address] = _isRestricted;
1367   }
1368 
1369   /**
1370    * @dev See {IERC721-approve}.
1371    */
1372   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1373     address owner = ERC721A.ownerOf(tokenId);
1374     require(to != owner, "ERC721A: approval to current owner");
1375     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1376 
1377     require(
1378       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1379       "ERC721A: approve caller is not owner nor approved for all"
1380     );
1381 
1382     _approve(to, tokenId, owner);
1383   }
1384 
1385   /**
1386    * @dev See {IERC721-getApproved}.
1387    */
1388   function getApproved(uint256 tokenId) public view override returns (address) {
1389     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1390 
1391     return _tokenApprovals[tokenId];
1392   }
1393 
1394   /**
1395    * @dev See {IERC721-setApprovalForAll}.
1396    */
1397   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1398     require(operator != _msgSender(), "ERC721A: approve to caller");
1399     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1400 
1401     _operatorApprovals[_msgSender()][operator] = approved;
1402     emit ApprovalForAll(_msgSender(), operator, approved);
1403   }
1404 
1405   /**
1406    * @dev See {IERC721-isApprovedForAll}.
1407    */
1408   function isApprovedForAll(address owner, address operator)
1409     public
1410     view
1411     virtual
1412     override
1413     returns (bool)
1414   {
1415     return _operatorApprovals[owner][operator];
1416   }
1417 
1418   /**
1419    * @dev See {IERC721-transferFrom}.
1420    */
1421   function transferFrom(
1422     address from,
1423     address to,
1424     uint256 tokenId
1425   ) public override onlyAllowedOperator(from) {
1426     _transfer(from, to, tokenId);
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-safeTransferFrom}.
1431    */
1432   function safeTransferFrom(
1433     address from,
1434     address to,
1435     uint256 tokenId
1436   ) public override onlyAllowedOperator(from) {
1437     safeTransferFrom(from, to, tokenId, "");
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-safeTransferFrom}.
1442    */
1443   function safeTransferFrom(
1444     address from,
1445     address to,
1446     uint256 tokenId,
1447     bytes memory _data
1448   ) public override onlyAllowedOperator(from) {
1449     _transfer(from, to, tokenId);
1450     require(
1451       _checkOnERC721Received(from, to, tokenId, _data),
1452       "ERC721A: transfer to non ERC721Receiver implementer"
1453     );
1454   }
1455 
1456   /**
1457    * @dev Returns whether tokenId exists.
1458    *
1459    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1460    *
1461    * Tokens start existing when they are minted (_mint),
1462    */
1463   function _exists(uint256 tokenId) internal view returns (bool) {
1464     return _startTokenId() <= tokenId && tokenId < currentIndex;
1465   }
1466 
1467   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1468     _safeMint(to, quantity, isAdminMint, "");
1469   }
1470 
1471   /**
1472    * @dev Mints quantity tokens and transfers them to to.
1473    *
1474    * Requirements:
1475    *
1476    * - there must be quantity tokens remaining unminted in the total collection.
1477    * - to cannot be the zero address.
1478    * - quantity cannot be larger than the max batch size.
1479    *
1480    * Emits a {Transfer} event.
1481    */
1482   function _safeMint(
1483     address to,
1484     uint256 quantity,
1485     bool isAdminMint,
1486     bytes memory _data
1487   ) internal {
1488     uint256 startTokenId = currentIndex;
1489     require(to != address(0), "ERC721A: mint to the zero address");
1490     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1491     require(!_exists(startTokenId), "ERC721A: token already minted");
1492 
1493     // For admin mints we do not want to enforce the maxBatchSize limit
1494     if (isAdminMint == false) {
1495         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1496     }
1497 
1498     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1499 
1500     AddressData memory addressData = _addressData[to];
1501     _addressData[to] = AddressData(
1502       addressData.balance + uint128(quantity),
1503       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1504     );
1505     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1506 
1507     uint256 updatedIndex = startTokenId;
1508 
1509     for (uint256 i = 0; i < quantity; i++) {
1510       emit Transfer(address(0), to, updatedIndex);
1511       require(
1512         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1513         "ERC721A: transfer to non ERC721Receiver implementer"
1514       );
1515       updatedIndex++;
1516     }
1517 
1518     currentIndex = updatedIndex;
1519     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1520   }
1521 
1522   /**
1523    * @dev Transfers tokenId from from to to.
1524    *
1525    * Requirements:
1526    *
1527    * - to cannot be the zero address.
1528    * - tokenId token must be owned by from.
1529    *
1530    * Emits a {Transfer} event.
1531    */
1532   function _transfer(
1533     address from,
1534     address to,
1535     uint256 tokenId
1536   ) private {
1537     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1538 
1539     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1540       getApproved(tokenId) == _msgSender() ||
1541       isApprovedForAll(prevOwnership.addr, _msgSender()));
1542 
1543     require(
1544       isApprovedOrOwner,
1545       "ERC721A: transfer caller is not owner nor approved"
1546     );
1547 
1548     require(
1549       prevOwnership.addr == from,
1550       "ERC721A: transfer from incorrect owner"
1551     );
1552     require(to != address(0), "ERC721A: transfer to the zero address");
1553 
1554     _beforeTokenTransfers(from, to, tokenId, 1);
1555 
1556     // Clear approvals from the previous owner
1557     _approve(address(0), tokenId, prevOwnership.addr);
1558 
1559     _addressData[from].balance -= 1;
1560     _addressData[to].balance += 1;
1561     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1562 
1563     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1564     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1565     uint256 nextTokenId = tokenId + 1;
1566     if (_ownerships[nextTokenId].addr == address(0)) {
1567       if (_exists(nextTokenId)) {
1568         _ownerships[nextTokenId] = TokenOwnership(
1569           prevOwnership.addr,
1570           prevOwnership.startTimestamp
1571         );
1572       }
1573     }
1574 
1575     emit Transfer(from, to, tokenId);
1576     _afterTokenTransfers(from, to, tokenId, 1);
1577   }
1578 
1579   /**
1580    * @dev Approve to to operate on tokenId
1581    *
1582    * Emits a {Approval} event.
1583    */
1584   function _approve(
1585     address to,
1586     uint256 tokenId,
1587     address owner
1588   ) private {
1589     _tokenApprovals[tokenId] = to;
1590     emit Approval(owner, to, tokenId);
1591   }
1592 
1593   uint256 public nextOwnerToExplicitlySet = 0;
1594 
1595   /**
1596    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1597    */
1598   function _setOwnersExplicit(uint256 quantity) internal {
1599     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1600     require(quantity > 0, "quantity must be nonzero");
1601     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1602 
1603     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1604     if (endIndex > collectionSize - 1) {
1605       endIndex = collectionSize - 1;
1606     }
1607     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1608     require(_exists(endIndex), "not enough minted yet for this cleanup");
1609     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1610       if (_ownerships[i].addr == address(0)) {
1611         TokenOwnership memory ownership = ownershipOf(i);
1612         _ownerships[i] = TokenOwnership(
1613           ownership.addr,
1614           ownership.startTimestamp
1615         );
1616       }
1617     }
1618     nextOwnerToExplicitlySet = endIndex + 1;
1619   }
1620 
1621   /**
1622    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1623    * The call is not executed if the target address is not a contract.
1624    *
1625    * @param from address representing the previous owner of the given token ID
1626    * @param to target address that will receive the tokens
1627    * @param tokenId uint256 ID of the token to be transferred
1628    * @param _data bytes optional data to send along with the call
1629    * @return bool whether the call correctly returned the expected magic value
1630    */
1631   function _checkOnERC721Received(
1632     address from,
1633     address to,
1634     uint256 tokenId,
1635     bytes memory _data
1636   ) private returns (bool) {
1637     if (to.isContract()) {
1638       try
1639         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1640       returns (bytes4 retval) {
1641         return retval == IERC721Receiver(to).onERC721Received.selector;
1642       } catch (bytes memory reason) {
1643         if (reason.length == 0) {
1644           revert("ERC721A: transfer to non ERC721Receiver implementer");
1645         } else {
1646           assembly {
1647             revert(add(32, reason), mload(reason))
1648           }
1649         }
1650       }
1651     } else {
1652       return true;
1653     }
1654   }
1655 
1656   /**
1657    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1658    *
1659    * startTokenId - the first token id to be transferred
1660    * quantity - the amount to be transferred
1661    *
1662    * Calling conditions:
1663    *
1664    * - When from and to are both non-zero, from's tokenId will be
1665    * transferred to to.
1666    * - When from is zero, tokenId will be minted for to.
1667    */
1668   function _beforeTokenTransfers(
1669     address from,
1670     address to,
1671     uint256 startTokenId,
1672     uint256 quantity
1673   ) internal virtual {}
1674 
1675   /**
1676    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1677    * minting.
1678    *
1679    * startTokenId - the first token id to be transferred
1680    * quantity - the amount to be transferred
1681    *
1682    * Calling conditions:
1683    *
1684    * - when from and to are both non-zero.
1685    * - from and to are never both zero.
1686    */
1687   function _afterTokenTransfers(
1688     address from,
1689     address to,
1690     uint256 startTokenId,
1691     uint256 quantity
1692   ) internal virtual {}
1693 }
1694 
1695 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1696 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1697 // @notice -- See Medium article --
1698 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1699 abstract contract ERC721ARedemption is ERC721A {
1700   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1701   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1702 
1703   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1704   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1705   
1706   uint256 public redemptionSurcharge = 0 ether;
1707   bool public redemptionModeEnabled;
1708   bool public verifiedClaimModeEnabled;
1709   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1710   mapping(address => bool) public redemptionContracts;
1711   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1712 
1713   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1714   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1715     redemptionContracts[_contractAddress] = _status;
1716   }
1717 
1718   // @dev Allow owner/team to determine if contract is accepting redemption mints
1719   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1720     redemptionModeEnabled = _newStatus;
1721   }
1722 
1723   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1724   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1725     verifiedClaimModeEnabled = _newStatus;
1726   }
1727 
1728   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1729   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1730     redemptionSurcharge = _newSurchargeInWei;
1731   }
1732 
1733   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1734   // @notice Must be a wallet address or implement IERC721Receiver.
1735   // Cannot be null address as this will break any ERC-721A implementation without a proper
1736   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1737   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1738     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1739     redemptionAddress = _newRedemptionAddress;
1740   }
1741 
1742   /**
1743   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1744   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1745   * the contract owner or Team => redemptionAddress. 
1746   * @param tokenId the token to be redeemed.
1747   * Emits a {Redeemed} event.
1748   **/
1749   function redeem(address redemptionContract, uint256 tokenId) public payable {
1750     if(getNextTokenId() > collectionSize) revert CapExceeded();
1751     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1752     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1753     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1754     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1755     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1756     
1757     IERC721 _targetContract = IERC721(redemptionContract);
1758     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1759     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1760     
1761     // Warning: Since there is no standarized return value for transfers of ERC-721
1762     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1763     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1764     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1765     // but the NFT may not have been sent to the redemptionAddress.
1766     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1767     tokenRedemptions[redemptionContract][tokenId] = true;
1768 
1769     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1770     _safeMint(_msgSender(), 1, false);
1771   }
1772 
1773   /**
1774   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1775   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1776   * @param tokenId the token to be redeemed.
1777   * Emits a {VerifiedClaim} event.
1778   **/
1779   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1780     if(getNextTokenId() > collectionSize) revert CapExceeded();
1781     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1782     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1783     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1784     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1785     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1786     
1787     tokenRedemptions[redemptionContract][tokenId] = true;
1788     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1789     _safeMint(_msgSender(), 1, false);
1790   }
1791 }
1792 
1793 
1794   
1795 /** TimedDrop.sol
1796 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1797 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1798 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1799 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1800 */
1801 abstract contract TimedDrop is Teams {
1802   bool public enforcePublicDropTime = true;
1803   uint256 public publicDropTime = 1675054800;
1804   
1805   /**
1806   * @dev Allow the contract owner to set the public time to mint.
1807   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1808   */
1809   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1810     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1811     publicDropTime = _newDropTime;
1812   }
1813 
1814   function usePublicDropTime() public onlyTeamOrOwner {
1815     enforcePublicDropTime = true;
1816   }
1817 
1818   function disablePublicDropTime() public onlyTeamOrOwner {
1819     enforcePublicDropTime = false;
1820   }
1821 
1822   /**
1823   * @dev determine if the public droptime has passed.
1824   * if the feature is disabled then assume the time has passed.
1825   */
1826   function publicDropTimePassed() public view returns(bool) {
1827     if(enforcePublicDropTime == false) {
1828       return true;
1829     }
1830     return block.timestamp >= publicDropTime;
1831   }
1832   
1833   // Allowlist implementation of the Timed Drop feature
1834   bool public enforceAllowlistDropTime = true;
1835   uint256 public allowlistDropTime = 1675029600;
1836 
1837   /**
1838   * @dev Allow the contract owner to set the allowlist time to mint.
1839   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1840   */
1841   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1842     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1843     allowlistDropTime = _newDropTime;
1844   }
1845 
1846   function useAllowlistDropTime() public onlyTeamOrOwner {
1847     enforceAllowlistDropTime = true;
1848   }
1849 
1850   function disableAllowlistDropTime() public onlyTeamOrOwner {
1851     enforceAllowlistDropTime = false;
1852   }
1853 
1854   function allowlistDropTimePassed() public view returns(bool) {
1855     if(enforceAllowlistDropTime == false) {
1856       return true;
1857     }
1858 
1859     return block.timestamp >= allowlistDropTime;
1860   }
1861 }
1862 
1863   
1864 interface IERC20 {
1865   function allowance(address owner, address spender) external view returns (uint256);
1866   function transfer(address _to, uint256 _amount) external returns (bool);
1867   function balanceOf(address account) external view returns (uint256);
1868   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1869 }
1870 
1871 // File: WithdrawableV2
1872 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1873 // ERC-20 Payouts are limited to a single payout address. This feature 
1874 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1875 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1876 abstract contract WithdrawableV2 is Teams {
1877   struct acceptedERC20 {
1878     bool isActive;
1879     uint256 chargeAmount;
1880   }
1881 
1882   
1883   mapping(address => acceptedERC20) private allowedTokenContracts;
1884   address[] public payableAddresses = [0x21c87dE6AB8C127b494349Cd2dE13e4f87424CdD,0x7e5aa86d96f2F2f047afe6577033c0d6C093D924];
1885   address public erc20Payable = 0x21c87dE6AB8C127b494349Cd2dE13e4f87424CdD;
1886   uint256[] public payableFees = [75,25];
1887   uint256 public payableAddressCount = 2;
1888   bool public onlyERC20MintingMode;
1889   
1890 
1891   function withdrawAll() public onlyTeamOrOwner {
1892       if(address(this).balance == 0) revert ValueCannotBeZero();
1893       _withdrawAll(address(this).balance);
1894   }
1895 
1896   function _withdrawAll(uint256 balance) private {
1897       for(uint i=0; i < payableAddressCount; i++ ) {
1898           _widthdraw(
1899               payableAddresses[i],
1900               (balance * payableFees[i]) / 100
1901           );
1902       }
1903   }
1904   
1905   function _widthdraw(address _address, uint256 _amount) private {
1906       (bool success, ) = _address.call{value: _amount}("");
1907       require(success, "Transfer failed.");
1908   }
1909 
1910   /**
1911   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1912   * in the event ERC-20 tokens are paid to the contract for mints.
1913   * @param _tokenContract contract of ERC-20 token to withdraw
1914   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1915   */
1916   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1917     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1918     IERC20 tokenContract = IERC20(_tokenContract);
1919     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1920     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1921   }
1922 
1923   /**
1924   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1925   * @param _erc20TokenContract address of ERC-20 contract in question
1926   */
1927   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1928     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1929   }
1930 
1931   /**
1932   * @dev get the value of tokens to transfer for user of an ERC-20
1933   * @param _erc20TokenContract address of ERC-20 contract in question
1934   */
1935   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1936     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1937     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1938   }
1939 
1940   /**
1941   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1942   * @param _erc20TokenContract address of ERC-20 contract in question
1943   * @param _isActive default status of if contract should be allowed to accept payments
1944   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1945   */
1946   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1947     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1948     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1949   }
1950 
1951   /**
1952   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1953   * it will assume the default value of zero. This should not be used to create new payment tokens.
1954   * @param _erc20TokenContract address of ERC-20 contract in question
1955   */
1956   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1957     allowedTokenContracts[_erc20TokenContract].isActive = true;
1958   }
1959 
1960   /**
1961   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1962   * it will assume the default value of zero. This should not be used to create new payment tokens.
1963   * @param _erc20TokenContract address of ERC-20 contract in question
1964   */
1965   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1966     allowedTokenContracts[_erc20TokenContract].isActive = false;
1967   }
1968 
1969   /**
1970   * @dev Enable only ERC-20 payments for minting on this contract
1971   */
1972   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1973     onlyERC20MintingMode = true;
1974   }
1975 
1976   /**
1977   * @dev Disable only ERC-20 payments for minting on this contract
1978   */
1979   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1980     onlyERC20MintingMode = false;
1981   }
1982 
1983   /**
1984   * @dev Set the payout of the ERC-20 token payout to a specific address
1985   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1986   */
1987   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1988     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1989     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1990     erc20Payable = _newErc20Payable;
1991   }
1992 }
1993 
1994 
1995   
1996   
1997   
1998 // File: EarlyMintIncentive.sol
1999 // Allows the contract to have the first x tokens minted for a wallet at a discount or
2000 // zero fee that can be calculated on the fly.
2001 abstract contract EarlyMintIncentive is Teams, ERC721A {
2002   uint256 public PRICE = 0.008 ether;
2003   uint256 public EARLY_MINT_PRICE = 0 ether;
2004   uint256 public earlyMintOwnershipCap = 1;
2005   bool public usingEarlyMintIncentive = true;
2006 
2007   function enableEarlyMintIncentive() public onlyTeamOrOwner {
2008     usingEarlyMintIncentive = true;
2009   }
2010 
2011   function disableEarlyMintIncentive() public onlyTeamOrOwner {
2012     usingEarlyMintIncentive = false;
2013   }
2014 
2015   /**
2016   * @dev Set the max token ID in which the cost incentive will be applied.
2017   * @param _newCap max number of tokens wallet may mint for incentive price
2018   */
2019   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
2020     if(_newCap == 0) revert ValueCannotBeZero();
2021     earlyMintOwnershipCap = _newCap;
2022   }
2023 
2024   /**
2025   * @dev Set the incentive mint price
2026   * @param _feeInWei new price per token when in incentive range
2027   */
2028   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
2029     EARLY_MINT_PRICE = _feeInWei;
2030   }
2031 
2032   /**
2033   * @dev Set the primary mint price - the base price when not under incentive
2034   * @param _feeInWei new price per token
2035   */
2036   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
2037     PRICE = _feeInWei;
2038   }
2039 
2040   /**
2041   * @dev Get the correct price for the mint for qty and person minting
2042   * @param _count amount of tokens to calc for mint
2043   * @param _to the address which will be minting these tokens, passed explicitly
2044   */
2045   function getPrice(uint256 _count, address _to) public view returns (uint256) {
2046     if(_count == 0) revert ValueCannotBeZero();
2047 
2048     // short circuit function if we dont need to even calc incentive pricing
2049     // short circuit if the current wallet mint qty is also already over cap
2050     if(
2051       usingEarlyMintIncentive == false ||
2052       _numberMinted(_to) > earlyMintOwnershipCap
2053     ) {
2054       return PRICE * _count;
2055     }
2056 
2057     uint256 endingTokenQty = _numberMinted(_to) + _count;
2058     // If qty to mint results in a final qty less than or equal to the cap then
2059     // the entire qty is within incentive mint.
2060     if(endingTokenQty  <= earlyMintOwnershipCap) {
2061       return EARLY_MINT_PRICE * _count;
2062     }
2063 
2064     // If the current token qty is less than the incentive cap
2065     // and the ending token qty is greater than the incentive cap
2066     // we will be straddling the cap so there will be some amount
2067     // that are incentive and some that are regular fee.
2068     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
2069     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
2070 
2071     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
2072   }
2073 }
2074 
2075   
2076 abstract contract RamppERC721A is 
2077     Ownable,
2078     Teams,
2079     ERC721ARedemption,
2080     WithdrawableV2,
2081     ReentrancyGuard 
2082     , EarlyMintIncentive 
2083     , Allowlist 
2084     , TimedDrop
2085 {
2086   constructor(
2087     string memory tokenName,
2088     string memory tokenSymbol
2089   ) ERC721A(tokenName, tokenSymbol, 5, 8888) { }
2090     uint8 constant public CONTRACT_VERSION = 2;
2091     string public _baseTokenURI = "ipfs://bafybeiffpzh35wcz46kgfvqs2h4tz2jw2hv3kzmiedajaxedxp43qv6n7e/";
2092     string public _baseTokenExtension = ".json";
2093 
2094     bool public mintingOpen = false;
2095     bool public isRevealed;
2096     
2097     uint256 public MAX_WALLET_MINTS = 5;
2098 
2099   
2100     /////////////// Admin Mint Functions
2101     /**
2102      * @dev Mints a token to an address with a tokenURI.
2103      * This is owner only and allows a fee-free drop
2104      * @param _to address of the future owner of the token
2105      * @param _qty amount of tokens to drop the owner
2106      */
2107      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2108          if(_qty == 0) revert MintZeroQuantity();
2109          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2110          _safeMint(_to, _qty, true);
2111      }
2112 
2113   
2114     /////////////// PUBLIC MINT FUNCTIONS
2115     /**
2116     * @dev Mints tokens to an address in batch.
2117     * fee may or may not be required*
2118     * @param _to address of the future owner of the token
2119     * @param _amount number of tokens to mint
2120     */
2121     function mintToMultiple(address _to, uint256 _amount) public payable {
2122         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2123         if(_amount == 0) revert MintZeroQuantity();
2124         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2125         if(!mintingOpen) revert PublicMintClosed();
2126         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2127         if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
2128         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2129         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2130         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
2131 
2132         _safeMint(_to, _amount, false);
2133     }
2134 
2135     /**
2136      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2137      * fee may or may not be required*
2138      * @param _to address of the future owner of the token
2139      * @param _amount number of tokens to mint
2140      * @param _erc20TokenContract erc-20 token contract to mint with
2141      */
2142     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2143       if(_amount == 0) revert MintZeroQuantity();
2144       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2145       if(!mintingOpen) revert PublicMintClosed();
2146       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2147       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2148       if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
2149       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
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
2165     function openMinting() public onlyTeamOrOwner {
2166         mintingOpen = true;
2167     }
2168 
2169     function stopMinting() public onlyTeamOrOwner {
2170         mintingOpen = false;
2171     }
2172 
2173   
2174     ///////////// ALLOWLIST MINTING FUNCTIONS
2175     /**
2176     * @dev Mints tokens to an address using an allowlist.
2177     * fee may or may not be required*
2178     * @param _to address of the future owner of the token
2179     * @param _amount number of tokens to mint
2180     * @param _merkleProof merkle proof array
2181     */
2182     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2183         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2184         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2185         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2186         if(_amount == 0) revert MintZeroQuantity();
2187         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2188         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2189         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2190         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
2191         if(!allowlistDropTimePassed()) revert AllowlistDropTimeHasNotPassed();
2192 
2193         _safeMint(_to, _amount, false);
2194     }
2195 
2196     /**
2197     * @dev Mints tokens to an address using an allowlist.
2198     * fee may or may not be required*
2199     * @param _to address of the future owner of the token
2200     * @param _amount number of tokens to mint
2201     * @param _merkleProof merkle proof array
2202     * @param _erc20TokenContract erc-20 token contract to mint with
2203     */
2204     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2205       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2206       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2207       if(_amount == 0) revert MintZeroQuantity();
2208       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2209       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2210       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2211       if(!allowlistDropTimePassed()) revert AllowlistDropTimeHasNotPassed();
2212     
2213       // ERC-20 Specific pre-flight checks
2214       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2215       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2216       IERC20 payableToken = IERC20(_erc20TokenContract);
2217 
2218       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2219       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2220 
2221       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2222       if(!transferComplete) revert ERC20TransferFailed();
2223       
2224       _safeMint(_to, _amount, false);
2225     }
2226 
2227     /**
2228      * @dev Enable allowlist minting fully by enabling both flags
2229      * This is a convenience function for the Rampp user
2230      */
2231     function openAllowlistMint() public onlyTeamOrOwner {
2232         enableAllowlistOnlyMode();
2233         mintingOpen = true;
2234     }
2235 
2236     /**
2237      * @dev Close allowlist minting fully by disabling both flags
2238      * This is a convenience function for the Rampp user
2239      */
2240     function closeAllowlistMint() public onlyTeamOrOwner {
2241         disableAllowlistOnlyMode();
2242         mintingOpen = false;
2243     }
2244 
2245 
2246   
2247     /**
2248     * @dev Check if wallet over MAX_WALLET_MINTS
2249     * @param _address address in question to check if minted count exceeds max
2250     */
2251     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2252         if(_amount == 0) revert ValueCannotBeZero();
2253         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2254     }
2255 
2256     /**
2257     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2258     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2259     */
2260     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2261         if(_newWalletMax == 0) revert ValueCannotBeZero();
2262         MAX_WALLET_MINTS = _newWalletMax;
2263     }
2264     
2265 
2266   
2267     /**
2268      * @dev Allows owner to set Max mints per tx
2269      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2270      */
2271      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2272          if(_newMaxMint == 0) revert ValueCannotBeZero();
2273          maxBatchSize = _newMaxMint;
2274      }
2275     
2276 
2277   
2278     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2279         if(isRevealed) revert IsAlreadyUnveiled();
2280         _baseTokenURI = _updatedTokenURI;
2281         isRevealed = true;
2282     }
2283     
2284   
2285   
2286   function contractURI() public pure returns (string memory) {
2287     return "https://metadata.mintplex.xyz/y86AeB1hIL0bFKGf9Kgw/contract-metadata";
2288   }
2289   
2290 
2291   function _baseURI() internal view virtual override returns(string memory) {
2292     return _baseTokenURI;
2293   }
2294 
2295   function _baseURIExtension() internal view virtual override returns(string memory) {
2296     return _baseTokenExtension;
2297   }
2298 
2299   function baseTokenURI() public view returns(string memory) {
2300     return _baseTokenURI;
2301   }
2302 
2303   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2304     _baseTokenURI = baseURI;
2305   }
2306 
2307   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2308     _baseTokenExtension = baseExtension;
2309   }
2310 }
2311 
2312 
2313   
2314 // File: contracts/ChungosContract.sol
2315 //SPDX-License-Identifier: MIT
2316 
2317 pragma solidity ^0.8.0;
2318 
2319 contract ChungosContract is RamppERC721A {
2320     constructor() RamppERC721A("Chungos", "CHUNGO"){}
2321 }
2322   