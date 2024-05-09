1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // The Final Entrance is opening...
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
975   
976 /**
977  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
978  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
979  *
980  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
981  * 
982  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
983  *
984  * Does not support burning tokens to address(0).
985  */
986 contract ERC721A is
987   Context,
988   ERC165,
989   IERC721,
990   IERC721Metadata,
991   IERC721Enumerable,
992   Teams
993   , OperatorFilterer
994 {
995   using Address for address;
996   using Strings for uint256;
997 
998   struct TokenOwnership {
999     address addr;
1000     uint64 startTimestamp;
1001   }
1002 
1003   struct AddressData {
1004     uint128 balance;
1005     uint128 numberMinted;
1006   }
1007 
1008   uint256 private currentIndex;
1009 
1010   uint256 public immutable collectionSize;
1011   uint256 public maxBatchSize;
1012 
1013   // Token name
1014   string private _name;
1015 
1016   // Token symbol
1017   string private _symbol;
1018 
1019   // Mapping from token ID to ownership details
1020   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1021   mapping(uint256 => TokenOwnership) private _ownerships;
1022 
1023   // Mapping owner address to address data
1024   mapping(address => AddressData) private _addressData;
1025 
1026   // Mapping from token ID to approved address
1027   mapping(uint256 => address) private _tokenApprovals;
1028 
1029   // Mapping from owner to operator approvals
1030   mapping(address => mapping(address => bool)) private _operatorApprovals;
1031 
1032   /* @dev Mapping of restricted operator approvals set by contract Owner
1033   * This serves as an optional addition to ERC-721 so
1034   * that the contract owner can elect to prevent specific addresses/contracts
1035   * from being marked as the approver for a token. The reason for this
1036   * is that some projects may want to retain control of where their tokens can/can not be listed
1037   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1038   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1039   */
1040   mapping(address => bool) public restrictedApprovalAddresses;
1041 
1042   /**
1043    * @dev
1044    * maxBatchSize refers to how much a minter can mint at a time.
1045    * collectionSize_ refers to how many tokens are in the collection.
1046    */
1047   constructor(
1048     string memory name_,
1049     string memory symbol_,
1050     uint256 maxBatchSize_,
1051     uint256 collectionSize_
1052   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1053     require(
1054       collectionSize_ > 0,
1055       "ERC721A: collection must have a nonzero supply"
1056     );
1057     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1058     _name = name_;
1059     _symbol = symbol_;
1060     maxBatchSize = maxBatchSize_;
1061     collectionSize = collectionSize_;
1062     currentIndex = _startTokenId();
1063   }
1064 
1065   /**
1066   * To change the starting tokenId, please override this function.
1067   */
1068   function _startTokenId() internal view virtual returns (uint256) {
1069     return 1;
1070   }
1071 
1072   /**
1073    * @dev See {IERC721Enumerable-totalSupply}.
1074    */
1075   function totalSupply() public view override returns (uint256) {
1076     return _totalMinted();
1077   }
1078 
1079   function currentTokenId() public view returns (uint256) {
1080     return _totalMinted();
1081   }
1082 
1083   function getNextTokenId() public view returns (uint256) {
1084       return _totalMinted() + 1;
1085   }
1086 
1087   /**
1088   * Returns the total amount of tokens minted in the contract.
1089   */
1090   function _totalMinted() internal view returns (uint256) {
1091     unchecked {
1092       return currentIndex - _startTokenId();
1093     }
1094   }
1095 
1096   /**
1097    * @dev See {IERC721Enumerable-tokenByIndex}.
1098    */
1099   function tokenByIndex(uint256 index) public view override returns (uint256) {
1100     require(index < totalSupply(), "ERC721A: global index out of bounds");
1101     return index;
1102   }
1103 
1104   /**
1105    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1106    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1107    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1108    */
1109   function tokenOfOwnerByIndex(address owner, uint256 index)
1110     public
1111     view
1112     override
1113     returns (uint256)
1114   {
1115     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1116     uint256 numMintedSoFar = totalSupply();
1117     uint256 tokenIdsIdx = 0;
1118     address currOwnershipAddr = address(0);
1119     for (uint256 i = 0; i < numMintedSoFar; i++) {
1120       TokenOwnership memory ownership = _ownerships[i];
1121       if (ownership.addr != address(0)) {
1122         currOwnershipAddr = ownership.addr;
1123       }
1124       if (currOwnershipAddr == owner) {
1125         if (tokenIdsIdx == index) {
1126           return i;
1127         }
1128         tokenIdsIdx++;
1129       }
1130     }
1131     revert("ERC721A: unable to get token of owner by index");
1132   }
1133 
1134   /**
1135    * @dev See {IERC165-supportsInterface}.
1136    */
1137   function supportsInterface(bytes4 interfaceId)
1138     public
1139     view
1140     virtual
1141     override(ERC165, IERC165)
1142     returns (bool)
1143   {
1144     return
1145       interfaceId == type(IERC721).interfaceId ||
1146       interfaceId == type(IERC721Metadata).interfaceId ||
1147       interfaceId == type(IERC721Enumerable).interfaceId ||
1148       super.supportsInterface(interfaceId);
1149   }
1150 
1151   /**
1152    * @dev See {IERC721-balanceOf}.
1153    */
1154   function balanceOf(address owner) public view override returns (uint256) {
1155     require(owner != address(0), "ERC721A: balance query for the zero address");
1156     return uint256(_addressData[owner].balance);
1157   }
1158 
1159   function _numberMinted(address owner) internal view returns (uint256) {
1160     require(
1161       owner != address(0),
1162       "ERC721A: number minted query for the zero address"
1163     );
1164     return uint256(_addressData[owner].numberMinted);
1165   }
1166 
1167   function ownershipOf(uint256 tokenId)
1168     internal
1169     view
1170     returns (TokenOwnership memory)
1171   {
1172     uint256 curr = tokenId;
1173 
1174     unchecked {
1175         if (_startTokenId() <= curr && curr < currentIndex) {
1176             TokenOwnership memory ownership = _ownerships[curr];
1177             if (ownership.addr != address(0)) {
1178                 return ownership;
1179             }
1180 
1181             // Invariant:
1182             // There will always be an ownership that has an address and is not burned
1183             // before an ownership that does not have an address and is not burned.
1184             // Hence, curr will not underflow.
1185             while (true) {
1186                 curr--;
1187                 ownership = _ownerships[curr];
1188                 if (ownership.addr != address(0)) {
1189                     return ownership;
1190                 }
1191             }
1192         }
1193     }
1194 
1195     revert("ERC721A: unable to determine the owner of token");
1196   }
1197 
1198   /**
1199    * @dev See {IERC721-ownerOf}.
1200    */
1201   function ownerOf(uint256 tokenId) public view override returns (address) {
1202     return ownershipOf(tokenId).addr;
1203   }
1204 
1205   /**
1206    * @dev See {IERC721Metadata-name}.
1207    */
1208   function name() public view virtual override returns (string memory) {
1209     return _name;
1210   }
1211 
1212   /**
1213    * @dev See {IERC721Metadata-symbol}.
1214    */
1215   function symbol() public view virtual override returns (string memory) {
1216     return _symbol;
1217   }
1218 
1219   /**
1220    * @dev See {IERC721Metadata-tokenURI}.
1221    */
1222   function tokenURI(uint256 tokenId)
1223     public
1224     view
1225     virtual
1226     override
1227     returns (string memory)
1228   {
1229     string memory baseURI = _baseURI();
1230     string memory extension = _baseURIExtension();
1231     return
1232       bytes(baseURI).length > 0
1233         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1234         : "";
1235   }
1236 
1237   /**
1238    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1239    * token will be the concatenation of the baseURI and the tokenId. Empty
1240    * by default, can be overriden in child contracts.
1241    */
1242   function _baseURI() internal view virtual returns (string memory) {
1243     return "";
1244   }
1245 
1246   /**
1247    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1248    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1249    * by default, can be overriden in child contracts.
1250    */
1251   function _baseURIExtension() internal view virtual returns (string memory) {
1252     return "";
1253   }
1254 
1255   /**
1256    * @dev Sets the value for an address to be in the restricted approval address pool.
1257    * Setting an address to true will disable token owners from being able to mark the address
1258    * for approval for trading. This would be used in theory to prevent token owners from listing
1259    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1260    * @param _address the marketplace/user to modify restriction status of
1261    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1262    */
1263   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1264     restrictedApprovalAddresses[_address] = _isRestricted;
1265   }
1266 
1267   /**
1268    * @dev See {IERC721-approve}.
1269    */
1270   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1271     address owner = ERC721A.ownerOf(tokenId);
1272     require(to != owner, "ERC721A: approval to current owner");
1273     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1274 
1275     require(
1276       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1277       "ERC721A: approve caller is not owner nor approved for all"
1278     );
1279 
1280     _approve(to, tokenId, owner);
1281   }
1282 
1283   /**
1284    * @dev See {IERC721-getApproved}.
1285    */
1286   function getApproved(uint256 tokenId) public view override returns (address) {
1287     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1288 
1289     return _tokenApprovals[tokenId];
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-setApprovalForAll}.
1294    */
1295   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1296     require(operator != _msgSender(), "ERC721A: approve to caller");
1297     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1298 
1299     _operatorApprovals[_msgSender()][operator] = approved;
1300     emit ApprovalForAll(_msgSender(), operator, approved);
1301   }
1302 
1303   /**
1304    * @dev See {IERC721-isApprovedForAll}.
1305    */
1306   function isApprovedForAll(address owner, address operator)
1307     public
1308     view
1309     virtual
1310     override
1311     returns (bool)
1312   {
1313     return _operatorApprovals[owner][operator];
1314   }
1315 
1316   /**
1317    * @dev See {IERC721-transferFrom}.
1318    */
1319   function transferFrom(
1320     address from,
1321     address to,
1322     uint256 tokenId
1323   ) public override onlyAllowedOperator(from) {
1324     _transfer(from, to, tokenId);
1325   }
1326 
1327   /**
1328    * @dev See {IERC721-safeTransferFrom}.
1329    */
1330   function safeTransferFrom(
1331     address from,
1332     address to,
1333     uint256 tokenId
1334   ) public override onlyAllowedOperator(from) {
1335     safeTransferFrom(from, to, tokenId, "");
1336   }
1337 
1338   /**
1339    * @dev See {IERC721-safeTransferFrom}.
1340    */
1341   function safeTransferFrom(
1342     address from,
1343     address to,
1344     uint256 tokenId,
1345     bytes memory _data
1346   ) public override onlyAllowedOperator(from) {
1347     _transfer(from, to, tokenId);
1348     require(
1349       _checkOnERC721Received(from, to, tokenId, _data),
1350       "ERC721A: transfer to non ERC721Receiver implementer"
1351     );
1352   }
1353 
1354   /**
1355    * @dev Returns whether tokenId exists.
1356    *
1357    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1358    *
1359    * Tokens start existing when they are minted (_mint),
1360    */
1361   function _exists(uint256 tokenId) internal view returns (bool) {
1362     return _startTokenId() <= tokenId && tokenId < currentIndex;
1363   }
1364 
1365   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1366     _safeMint(to, quantity, isAdminMint, "");
1367   }
1368 
1369   /**
1370    * @dev Mints quantity tokens and transfers them to to.
1371    *
1372    * Requirements:
1373    *
1374    * - there must be quantity tokens remaining unminted in the total collection.
1375    * - to cannot be the zero address.
1376    * - quantity cannot be larger than the max batch size.
1377    *
1378    * Emits a {Transfer} event.
1379    */
1380   function _safeMint(
1381     address to,
1382     uint256 quantity,
1383     bool isAdminMint,
1384     bytes memory _data
1385   ) internal {
1386     uint256 startTokenId = currentIndex;
1387     require(to != address(0), "ERC721A: mint to the zero address");
1388     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1389     require(!_exists(startTokenId), "ERC721A: token already minted");
1390 
1391     // For admin mints we do not want to enforce the maxBatchSize limit
1392     if (isAdminMint == false) {
1393         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1394     }
1395 
1396     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1397 
1398     AddressData memory addressData = _addressData[to];
1399     _addressData[to] = AddressData(
1400       addressData.balance + uint128(quantity),
1401       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1402     );
1403     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1404 
1405     uint256 updatedIndex = startTokenId;
1406 
1407     for (uint256 i = 0; i < quantity; i++) {
1408       emit Transfer(address(0), to, updatedIndex);
1409       require(
1410         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1411         "ERC721A: transfer to non ERC721Receiver implementer"
1412       );
1413       updatedIndex++;
1414     }
1415 
1416     currentIndex = updatedIndex;
1417     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1418   }
1419 
1420   /**
1421    * @dev Transfers tokenId from from to to.
1422    *
1423    * Requirements:
1424    *
1425    * - to cannot be the zero address.
1426    * - tokenId token must be owned by from.
1427    *
1428    * Emits a {Transfer} event.
1429    */
1430   function _transfer(
1431     address from,
1432     address to,
1433     uint256 tokenId
1434   ) private {
1435     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1436 
1437     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1438       getApproved(tokenId) == _msgSender() ||
1439       isApprovedForAll(prevOwnership.addr, _msgSender()));
1440 
1441     require(
1442       isApprovedOrOwner,
1443       "ERC721A: transfer caller is not owner nor approved"
1444     );
1445 
1446     require(
1447       prevOwnership.addr == from,
1448       "ERC721A: transfer from incorrect owner"
1449     );
1450     require(to != address(0), "ERC721A: transfer to the zero address");
1451 
1452     _beforeTokenTransfers(from, to, tokenId, 1);
1453 
1454     // Clear approvals from the previous owner
1455     _approve(address(0), tokenId, prevOwnership.addr);
1456 
1457     _addressData[from].balance -= 1;
1458     _addressData[to].balance += 1;
1459     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1460 
1461     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1462     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1463     uint256 nextTokenId = tokenId + 1;
1464     if (_ownerships[nextTokenId].addr == address(0)) {
1465       if (_exists(nextTokenId)) {
1466         _ownerships[nextTokenId] = TokenOwnership(
1467           prevOwnership.addr,
1468           prevOwnership.startTimestamp
1469         );
1470       }
1471     }
1472 
1473     emit Transfer(from, to, tokenId);
1474     _afterTokenTransfers(from, to, tokenId, 1);
1475   }
1476 
1477   /**
1478    * @dev Approve to to operate on tokenId
1479    *
1480    * Emits a {Approval} event.
1481    */
1482   function _approve(
1483     address to,
1484     uint256 tokenId,
1485     address owner
1486   ) private {
1487     _tokenApprovals[tokenId] = to;
1488     emit Approval(owner, to, tokenId);
1489   }
1490 
1491   uint256 public nextOwnerToExplicitlySet = 0;
1492 
1493   /**
1494    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1495    */
1496   function _setOwnersExplicit(uint256 quantity) internal {
1497     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1498     require(quantity > 0, "quantity must be nonzero");
1499     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1500 
1501     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1502     if (endIndex > collectionSize - 1) {
1503       endIndex = collectionSize - 1;
1504     }
1505     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1506     require(_exists(endIndex), "not enough minted yet for this cleanup");
1507     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1508       if (_ownerships[i].addr == address(0)) {
1509         TokenOwnership memory ownership = ownershipOf(i);
1510         _ownerships[i] = TokenOwnership(
1511           ownership.addr,
1512           ownership.startTimestamp
1513         );
1514       }
1515     }
1516     nextOwnerToExplicitlySet = endIndex + 1;
1517   }
1518 
1519   /**
1520    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1521    * The call is not executed if the target address is not a contract.
1522    *
1523    * @param from address representing the previous owner of the given token ID
1524    * @param to target address that will receive the tokens
1525    * @param tokenId uint256 ID of the token to be transferred
1526    * @param _data bytes optional data to send along with the call
1527    * @return bool whether the call correctly returned the expected magic value
1528    */
1529   function _checkOnERC721Received(
1530     address from,
1531     address to,
1532     uint256 tokenId,
1533     bytes memory _data
1534   ) private returns (bool) {
1535     if (to.isContract()) {
1536       try
1537         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1538       returns (bytes4 retval) {
1539         return retval == IERC721Receiver(to).onERC721Received.selector;
1540       } catch (bytes memory reason) {
1541         if (reason.length == 0) {
1542           revert("ERC721A: transfer to non ERC721Receiver implementer");
1543         } else {
1544           assembly {
1545             revert(add(32, reason), mload(reason))
1546           }
1547         }
1548       }
1549     } else {
1550       return true;
1551     }
1552   }
1553 
1554   /**
1555    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1556    *
1557    * startTokenId - the first token id to be transferred
1558    * quantity - the amount to be transferred
1559    *
1560    * Calling conditions:
1561    *
1562    * - When from and to are both non-zero, from's tokenId will be
1563    * transferred to to.
1564    * - When from is zero, tokenId will be minted for to.
1565    */
1566   function _beforeTokenTransfers(
1567     address from,
1568     address to,
1569     uint256 startTokenId,
1570     uint256 quantity
1571   ) internal virtual {}
1572 
1573   /**
1574    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1575    * minting.
1576    *
1577    * startTokenId - the first token id to be transferred
1578    * quantity - the amount to be transferred
1579    *
1580    * Calling conditions:
1581    *
1582    * - when from and to are both non-zero.
1583    * - from and to are never both zero.
1584    */
1585   function _afterTokenTransfers(
1586     address from,
1587     address to,
1588     uint256 startTokenId,
1589     uint256 quantity
1590   ) internal virtual {}
1591 }
1592 
1593 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1594 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1595 // @notice -- See Medium article --
1596 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1597 abstract contract ERC721ARedemption is ERC721A {
1598   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1599   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1600 
1601   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1602   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1603   
1604   uint256 public redemptionSurcharge = 0 ether;
1605   bool public redemptionModeEnabled;
1606   bool public verifiedClaimModeEnabled;
1607   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1608   mapping(address => bool) public redemptionContracts;
1609   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1610 
1611   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1612   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1613     redemptionContracts[_contractAddress] = _status;
1614   }
1615 
1616   // @dev Allow owner/team to determine if contract is accepting redemption mints
1617   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1618     redemptionModeEnabled = _newStatus;
1619   }
1620 
1621   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1622   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1623     verifiedClaimModeEnabled = _newStatus;
1624   }
1625 
1626   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1627   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1628     redemptionSurcharge = _newSurchargeInWei;
1629   }
1630 
1631   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1632   // @notice Must be a wallet address or implement IERC721Receiver.
1633   // Cannot be null address as this will break any ERC-721A implementation without a proper
1634   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1635   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1636     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1637     redemptionAddress = _newRedemptionAddress;
1638   }
1639 
1640   /**
1641   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1642   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1643   * the contract owner or Team => redemptionAddress. 
1644   * @param tokenId the token to be redeemed.
1645   * Emits a {Redeemed} event.
1646   **/
1647   function redeem(address redemptionContract, uint256 tokenId) public payable {
1648     if(getNextTokenId() > collectionSize) revert CapExceeded();
1649     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1650     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1651     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1652     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1653     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1654     
1655     IERC721 _targetContract = IERC721(redemptionContract);
1656     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1657     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1658     
1659     // Warning: Since there is no standarized return value for transfers of ERC-721
1660     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1661     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1662     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1663     // but the NFT may not have been sent to the redemptionAddress.
1664     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1665     tokenRedemptions[redemptionContract][tokenId] = true;
1666 
1667     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1668     _safeMint(_msgSender(), 1, false);
1669   }
1670 
1671   /**
1672   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1673   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1674   * @param tokenId the token to be redeemed.
1675   * Emits a {VerifiedClaim} event.
1676   **/
1677   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1678     if(getNextTokenId() > collectionSize) revert CapExceeded();
1679     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1680     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1681     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1682     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1683     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1684     
1685     tokenRedemptions[redemptionContract][tokenId] = true;
1686     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1687     _safeMint(_msgSender(), 1, false);
1688   }
1689 }
1690 
1691 
1692   
1693   
1694 interface IERC20 {
1695   function allowance(address owner, address spender) external view returns (uint256);
1696   function transfer(address _to, uint256 _amount) external returns (bool);
1697   function balanceOf(address account) external view returns (uint256);
1698   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1699 }
1700 
1701 // File: WithdrawableV2
1702 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1703 // ERC-20 Payouts are limited to a single payout address. This feature 
1704 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1705 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1706 abstract contract WithdrawableV2 is Teams {
1707   struct acceptedERC20 {
1708     bool isActive;
1709     uint256 chargeAmount;
1710   }
1711 
1712   
1713   mapping(address => acceptedERC20) private allowedTokenContracts;
1714   address[] public payableAddresses = [0x018c8CE93032b36942133dF5286032785EFf5669];
1715   address public erc20Payable = 0x018c8CE93032b36942133dF5286032785EFf5669;
1716   uint256[] public payableFees = [100];
1717   uint256 public payableAddressCount = 1;
1718   bool public onlyERC20MintingMode;
1719   
1720 
1721   function withdrawAll() public onlyTeamOrOwner {
1722       if(address(this).balance == 0) revert ValueCannotBeZero();
1723       _withdrawAll(address(this).balance);
1724   }
1725 
1726   function _withdrawAll(uint256 balance) private {
1727       for(uint i=0; i < payableAddressCount; i++ ) {
1728           _widthdraw(
1729               payableAddresses[i],
1730               (balance * payableFees[i]) / 100
1731           );
1732       }
1733   }
1734   
1735   function _widthdraw(address _address, uint256 _amount) private {
1736       (bool success, ) = _address.call{value: _amount}("");
1737       require(success, "Transfer failed.");
1738   }
1739 
1740   /**
1741   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1742   * in the event ERC-20 tokens are paid to the contract for mints.
1743   * @param _tokenContract contract of ERC-20 token to withdraw
1744   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1745   */
1746   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1747     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1748     IERC20 tokenContract = IERC20(_tokenContract);
1749     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1750     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1751   }
1752 
1753   /**
1754   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1755   * @param _erc20TokenContract address of ERC-20 contract in question
1756   */
1757   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1758     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1759   }
1760 
1761   /**
1762   * @dev get the value of tokens to transfer for user of an ERC-20
1763   * @param _erc20TokenContract address of ERC-20 contract in question
1764   */
1765   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1766     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1767     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1768   }
1769 
1770   /**
1771   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1772   * @param _erc20TokenContract address of ERC-20 contract in question
1773   * @param _isActive default status of if contract should be allowed to accept payments
1774   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1775   */
1776   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1777     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1778     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1779   }
1780 
1781   /**
1782   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1783   * it will assume the default value of zero. This should not be used to create new payment tokens.
1784   * @param _erc20TokenContract address of ERC-20 contract in question
1785   */
1786   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1787     allowedTokenContracts[_erc20TokenContract].isActive = true;
1788   }
1789 
1790   /**
1791   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1792   * it will assume the default value of zero. This should not be used to create new payment tokens.
1793   * @param _erc20TokenContract address of ERC-20 contract in question
1794   */
1795   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1796     allowedTokenContracts[_erc20TokenContract].isActive = false;
1797   }
1798 
1799   /**
1800   * @dev Enable only ERC-20 payments for minting on this contract
1801   */
1802   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1803     onlyERC20MintingMode = true;
1804   }
1805 
1806   /**
1807   * @dev Disable only ERC-20 payments for minting on this contract
1808   */
1809   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1810     onlyERC20MintingMode = false;
1811   }
1812 
1813   /**
1814   * @dev Set the payout of the ERC-20 token payout to a specific address
1815   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1816   */
1817   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1818     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1819     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1820     erc20Payable = _newErc20Payable;
1821   }
1822 }
1823 
1824 
1825   
1826   
1827   
1828 // File: EarlyMintIncentive.sol
1829 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1830 // zero fee that can be calculated on the fly.
1831 abstract contract EarlyMintIncentive is Teams, ERC721A {
1832   uint256 public PRICE = 0.001 ether;
1833   uint256 public EARLY_MINT_PRICE = 0 ether;
1834   uint256 public earlyMintOwnershipCap = 1;
1835   bool public usingEarlyMintIncentive = true;
1836 
1837   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1838     usingEarlyMintIncentive = true;
1839   }
1840 
1841   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1842     usingEarlyMintIncentive = false;
1843   }
1844 
1845   /**
1846   * @dev Set the max token ID in which the cost incentive will be applied.
1847   * @param _newCap max number of tokens wallet may mint for incentive price
1848   */
1849   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1850     if(_newCap == 0) revert ValueCannotBeZero();
1851     earlyMintOwnershipCap = _newCap;
1852   }
1853 
1854   /**
1855   * @dev Set the incentive mint price
1856   * @param _feeInWei new price per token when in incentive range
1857   */
1858   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1859     EARLY_MINT_PRICE = _feeInWei;
1860   }
1861 
1862   /**
1863   * @dev Set the primary mint price - the base price when not under incentive
1864   * @param _feeInWei new price per token
1865   */
1866   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1867     PRICE = _feeInWei;
1868   }
1869 
1870   /**
1871   * @dev Get the correct price for the mint for qty and person minting
1872   * @param _count amount of tokens to calc for mint
1873   * @param _to the address which will be minting these tokens, passed explicitly
1874   */
1875   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1876     if(_count == 0) revert ValueCannotBeZero();
1877 
1878     // short circuit function if we dont need to even calc incentive pricing
1879     // short circuit if the current wallet mint qty is also already over cap
1880     if(
1881       usingEarlyMintIncentive == false ||
1882       _numberMinted(_to) > earlyMintOwnershipCap
1883     ) {
1884       return PRICE * _count;
1885     }
1886 
1887     uint256 endingTokenQty = _numberMinted(_to) + _count;
1888     // If qty to mint results in a final qty less than or equal to the cap then
1889     // the entire qty is within incentive mint.
1890     if(endingTokenQty  <= earlyMintOwnershipCap) {
1891       return EARLY_MINT_PRICE * _count;
1892     }
1893 
1894     // If the current token qty is less than the incentive cap
1895     // and the ending token qty is greater than the incentive cap
1896     // we will be straddling the cap so there will be some amount
1897     // that are incentive and some that are regular fee.
1898     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1899     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1900 
1901     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1902   }
1903 }
1904 
1905   
1906 abstract contract RamppERC721A is 
1907     Ownable,
1908     Teams,
1909     ERC721ARedemption,
1910     WithdrawableV2,
1911     ReentrancyGuard 
1912     , EarlyMintIncentive 
1913      
1914     
1915 {
1916   constructor(
1917     string memory tokenName,
1918     string memory tokenSymbol
1919   ) ERC721A(tokenName, tokenSymbol, 20, 3333) { }
1920     uint8 constant public CONTRACT_VERSION = 2;
1921     string public _baseTokenURI = "ipfs://bafybeiedtz5mbid6l6hpty22z2rpxgpphyx4arylhjohgrniuqy4hf3wzy/";
1922     string public _baseTokenExtension = ".json";
1923 
1924     bool public mintingOpen = true;
1925     
1926     
1927 
1928   
1929     /////////////// Admin Mint Functions
1930     /**
1931      * @dev Mints a token to an address with a tokenURI.
1932      * This is owner only and allows a fee-free drop
1933      * @param _to address of the future owner of the token
1934      * @param _qty amount of tokens to drop the owner
1935      */
1936      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1937          if(_qty == 0) revert MintZeroQuantity();
1938          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1939          _safeMint(_to, _qty, true);
1940      }
1941 
1942   
1943     /////////////// PUBLIC MINT FUNCTIONS
1944     /**
1945     * @dev Mints tokens to an address in batch.
1946     * fee may or may not be required*
1947     * @param _to address of the future owner of the token
1948     * @param _amount number of tokens to mint
1949     */
1950     function mintToMultiple(address _to, uint256 _amount) public payable {
1951         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1952         if(_amount == 0) revert MintZeroQuantity();
1953         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1954         if(!mintingOpen) revert PublicMintClosed();
1955         
1956         
1957         
1958         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1959         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
1960 
1961         _safeMint(_to, _amount, false);
1962     }
1963 
1964     /**
1965      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1966      * fee may or may not be required*
1967      * @param _to address of the future owner of the token
1968      * @param _amount number of tokens to mint
1969      * @param _erc20TokenContract erc-20 token contract to mint with
1970      */
1971     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1972       if(_amount == 0) revert MintZeroQuantity();
1973       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1974       if(!mintingOpen) revert PublicMintClosed();
1975       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1976       
1977       
1978       
1979 
1980       // ERC-20 Specific pre-flight checks
1981       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1982       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1983       IERC20 payableToken = IERC20(_erc20TokenContract);
1984 
1985       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1986       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1987 
1988       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1989       if(!transferComplete) revert ERC20TransferFailed();
1990       
1991       _safeMint(_to, _amount, false);
1992     }
1993 
1994     function openMinting() public onlyTeamOrOwner {
1995         mintingOpen = true;
1996     }
1997 
1998     function stopMinting() public onlyTeamOrOwner {
1999         mintingOpen = false;
2000     }
2001 
2002   
2003 
2004   
2005 
2006   
2007     /**
2008      * @dev Allows owner to set Max mints per tx
2009      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2010      */
2011      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2012          if(_newMaxMint == 0) revert ValueCannotBeZero();
2013          maxBatchSize = _newMaxMint;
2014      }
2015     
2016 
2017   
2018   
2019   
2020   function contractURI() public pure returns (string memory) {
2021     return "https://metadata.mintplex.xyz/tboibRi719RfLlibx1vj/contract-metadata";
2022   }
2023   
2024 
2025   function _baseURI() internal view virtual override returns(string memory) {
2026     return _baseTokenURI;
2027   }
2028 
2029   function _baseURIExtension() internal view virtual override returns(string memory) {
2030     return _baseTokenExtension;
2031   }
2032 
2033   function baseTokenURI() public view returns(string memory) {
2034     return _baseTokenURI;
2035   }
2036 
2037   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2038     _baseTokenURI = baseURI;
2039   }
2040 
2041   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2042     _baseTokenExtension = baseExtension;
2043   }
2044 }
2045 
2046 
2047   
2048 // File: contracts/TheFinalEntranceContract.sol
2049 //SPDX-License-Identifier: MIT
2050 
2051 pragma solidity ^0.8.0;
2052 
2053 contract TheFinalEntranceContract is RamppERC721A {
2054     constructor() RamppERC721A("The Final Entrance", "TFE"){}
2055 }
2056   