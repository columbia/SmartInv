1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // Sunbirds | When the moon sets, the sun rises.
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
735     modifier onlyOwner() {
736         require(owner() == _msgSender(), "Ownable: caller is not the owner");
737         _;
738     }
739 
740     /**
741      * @dev Leaves the contract without owner. It will not be possible to call
742      * onlyOwner functions anymore. Can only be called by the current owner.
743      *
744      * NOTE: Renouncing ownership will leave the contract without an owner,
745      * thereby removing any functionality that is only available to the owner.
746      */
747     function renounceOwnership() public virtual onlyOwner {
748         _transferOwnership(address(0));
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (newOwner).
753      * Can only be called by the current owner.
754      */
755     function transferOwnership(address newOwner) public virtual onlyOwner {
756         require(newOwner != address(0), "Ownable: new owner is the zero address");
757         _transferOwnership(newOwner);
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (newOwner).
762      * Internal function without access restriction.
763      */
764     function _transferOwnership(address newOwner) internal virtual {
765         address oldOwner = _owner;
766         _owner = newOwner;
767         emit OwnershipTransferred(oldOwner, newOwner);
768     }
769 }
770 //-------------END DEPENDENCIES------------------------//
771 
772 
773   
774 // Rampp Contracts v2.1 (Teams.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 /**
779 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
780 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
781 * This will easily allow cross-collaboration via Rampp.xyz.
782 **/
783 abstract contract Teams is Ownable{
784   mapping (address => bool) internal team;
785 
786   /**
787   * @dev Adds an address to the team. Allows them to execute protected functions
788   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
789   **/
790   function addToTeam(address _address) public onlyOwner {
791     require(_address != address(0), "Invalid address");
792     require(!inTeam(_address), "This address is already in your team.");
793   
794     team[_address] = true;
795   }
796 
797   /**
798   * @dev Removes an address to the team.
799   * @param _address the ETH address to remove, cannot be 0x and must be in team
800   **/
801   function removeFromTeam(address _address) public onlyOwner {
802     require(_address != address(0), "Invalid address");
803     require(inTeam(_address), "This address is not in your team currently.");
804   
805     team[_address] = false;
806   }
807 
808   /**
809   * @dev Check if an address is valid and active in the team
810   * @param _address ETH address to check for truthiness
811   **/
812   function inTeam(address _address)
813     public
814     view
815     returns (bool)
816   {
817     require(_address != address(0), "Invalid address to check.");
818     return team[_address] == true;
819   }
820 
821   /**
822   * @dev Throws if called by any account other than the owner or team member.
823   */
824   modifier onlyTeamOrOwner() {
825     bool _isOwner = owner() == _msgSender();
826     bool _isTeam = inTeam(_msgSender());
827     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
828     _;
829   }
830 }
831 
832 
833   
834   
835 /**
836  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
837  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
838  *
839  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
840  * 
841  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
842  *
843  * Does not support burning tokens to address(0).
844  */
845 contract ERC721A is
846   Context,
847   ERC165,
848   IERC721,
849   IERC721Metadata,
850   IERC721Enumerable
851 {
852   using Address for address;
853   using Strings for uint256;
854 
855   struct TokenOwnership {
856     address addr;
857     uint64 startTimestamp;
858   }
859 
860   struct AddressData {
861     uint128 balance;
862     uint128 numberMinted;
863   }
864 
865   uint256 private currentIndex;
866 
867   uint256 public immutable collectionSize;
868   uint256 public maxBatchSize;
869 
870   // Token name
871   string private _name;
872 
873   // Token symbol
874   string private _symbol;
875 
876   // Mapping from token ID to ownership details
877   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
878   mapping(uint256 => TokenOwnership) private _ownerships;
879 
880   // Mapping owner address to address data
881   mapping(address => AddressData) private _addressData;
882 
883   // Mapping from token ID to approved address
884   mapping(uint256 => address) private _tokenApprovals;
885 
886   // Mapping from owner to operator approvals
887   mapping(address => mapping(address => bool)) private _operatorApprovals;
888 
889   /**
890    * @dev
891    * maxBatchSize refers to how much a minter can mint at a time.
892    * collectionSize_ refers to how many tokens are in the collection.
893    */
894   constructor(
895     string memory name_,
896     string memory symbol_,
897     uint256 maxBatchSize_,
898     uint256 collectionSize_
899   ) {
900     require(
901       collectionSize_ > 0,
902       "ERC721A: collection must have a nonzero supply"
903     );
904     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
905     _name = name_;
906     _symbol = symbol_;
907     maxBatchSize = maxBatchSize_;
908     collectionSize = collectionSize_;
909     currentIndex = _startTokenId();
910   }
911 
912   /**
913   * To change the starting tokenId, please override this function.
914   */
915   function _startTokenId() internal view virtual returns (uint256) {
916     return 1;
917   }
918 
919   /**
920    * @dev See {IERC721Enumerable-totalSupply}.
921    */
922   function totalSupply() public view override returns (uint256) {
923     return _totalMinted();
924   }
925 
926   function currentTokenId() public view returns (uint256) {
927     return _totalMinted();
928   }
929 
930   function getNextTokenId() public view returns (uint256) {
931       return _totalMinted() + 1;
932   }
933 
934   /**
935   * Returns the total amount of tokens minted in the contract.
936   */
937   function _totalMinted() internal view returns (uint256) {
938     unchecked {
939       return currentIndex - _startTokenId();
940     }
941   }
942 
943   /**
944    * @dev See {IERC721Enumerable-tokenByIndex}.
945    */
946   function tokenByIndex(uint256 index) public view override returns (uint256) {
947     require(index < totalSupply(), "ERC721A: global index out of bounds");
948     return index;
949   }
950 
951   /**
952    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
953    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
954    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
955    */
956   function tokenOfOwnerByIndex(address owner, uint256 index)
957     public
958     view
959     override
960     returns (uint256)
961   {
962     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
963     uint256 numMintedSoFar = totalSupply();
964     uint256 tokenIdsIdx = 0;
965     address currOwnershipAddr = address(0);
966     for (uint256 i = 0; i < numMintedSoFar; i++) {
967       TokenOwnership memory ownership = _ownerships[i];
968       if (ownership.addr != address(0)) {
969         currOwnershipAddr = ownership.addr;
970       }
971       if (currOwnershipAddr == owner) {
972         if (tokenIdsIdx == index) {
973           return i;
974         }
975         tokenIdsIdx++;
976       }
977     }
978     revert("ERC721A: unable to get token of owner by index");
979   }
980 
981   /**
982    * @dev See {IERC165-supportsInterface}.
983    */
984   function supportsInterface(bytes4 interfaceId)
985     public
986     view
987     virtual
988     override(ERC165, IERC165)
989     returns (bool)
990   {
991     return
992       interfaceId == type(IERC721).interfaceId ||
993       interfaceId == type(IERC721Metadata).interfaceId ||
994       interfaceId == type(IERC721Enumerable).interfaceId ||
995       super.supportsInterface(interfaceId);
996   }
997 
998   /**
999    * @dev See {IERC721-balanceOf}.
1000    */
1001   function balanceOf(address owner) public view override returns (uint256) {
1002     require(owner != address(0), "ERC721A: balance query for the zero address");
1003     return uint256(_addressData[owner].balance);
1004   }
1005 
1006   function _numberMinted(address owner) internal view returns (uint256) {
1007     require(
1008       owner != address(0),
1009       "ERC721A: number minted query for the zero address"
1010     );
1011     return uint256(_addressData[owner].numberMinted);
1012   }
1013 
1014   function ownershipOf(uint256 tokenId)
1015     internal
1016     view
1017     returns (TokenOwnership memory)
1018   {
1019     uint256 curr = tokenId;
1020 
1021     unchecked {
1022         if (_startTokenId() <= curr && curr < currentIndex) {
1023             TokenOwnership memory ownership = _ownerships[curr];
1024             if (ownership.addr != address(0)) {
1025                 return ownership;
1026             }
1027 
1028             // Invariant:
1029             // There will always be an ownership that has an address and is not burned
1030             // before an ownership that does not have an address and is not burned.
1031             // Hence, curr will not underflow.
1032             while (true) {
1033                 curr--;
1034                 ownership = _ownerships[curr];
1035                 if (ownership.addr != address(0)) {
1036                     return ownership;
1037                 }
1038             }
1039         }
1040     }
1041 
1042     revert("ERC721A: unable to determine the owner of token");
1043   }
1044 
1045   /**
1046    * @dev See {IERC721-ownerOf}.
1047    */
1048   function ownerOf(uint256 tokenId) public view override returns (address) {
1049     return ownershipOf(tokenId).addr;
1050   }
1051 
1052   /**
1053    * @dev See {IERC721Metadata-name}.
1054    */
1055   function name() public view virtual override returns (string memory) {
1056     return _name;
1057   }
1058 
1059   /**
1060    * @dev See {IERC721Metadata-symbol}.
1061    */
1062   function symbol() public view virtual override returns (string memory) {
1063     return _symbol;
1064   }
1065 
1066   /**
1067    * @dev See {IERC721Metadata-tokenURI}.
1068    */
1069   function tokenURI(uint256 tokenId)
1070     public
1071     view
1072     virtual
1073     override
1074     returns (string memory)
1075   {
1076     string memory baseURI = _baseURI();
1077     return
1078       bytes(baseURI).length > 0
1079         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1080         : "";
1081   }
1082 
1083   /**
1084    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1085    * token will be the concatenation of the baseURI and the tokenId. Empty
1086    * by default, can be overriden in child contracts.
1087    */
1088   function _baseURI() internal view virtual returns (string memory) {
1089     return "";
1090   }
1091 
1092   /**
1093    * @dev See {IERC721-approve}.
1094    */
1095   function approve(address to, uint256 tokenId) public override {
1096     address owner = ERC721A.ownerOf(tokenId);
1097     require(to != owner, "ERC721A: approval to current owner");
1098 
1099     require(
1100       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1101       "ERC721A: approve caller is not owner nor approved for all"
1102     );
1103 
1104     _approve(to, tokenId, owner);
1105   }
1106 
1107   /**
1108    * @dev See {IERC721-getApproved}.
1109    */
1110   function getApproved(uint256 tokenId) public view override returns (address) {
1111     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1112 
1113     return _tokenApprovals[tokenId];
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-setApprovalForAll}.
1118    */
1119   function setApprovalForAll(address operator, bool approved) public override {
1120     require(operator != _msgSender(), "ERC721A: approve to caller");
1121 
1122     _operatorApprovals[_msgSender()][operator] = approved;
1123     emit ApprovalForAll(_msgSender(), operator, approved);
1124   }
1125 
1126   /**
1127    * @dev See {IERC721-isApprovedForAll}.
1128    */
1129   function isApprovedForAll(address owner, address operator)
1130     public
1131     view
1132     virtual
1133     override
1134     returns (bool)
1135   {
1136     return _operatorApprovals[owner][operator];
1137   }
1138 
1139   /**
1140    * @dev See {IERC721-transferFrom}.
1141    */
1142   function transferFrom(
1143     address from,
1144     address to,
1145     uint256 tokenId
1146   ) public override {
1147     _transfer(from, to, tokenId);
1148   }
1149 
1150   /**
1151    * @dev See {IERC721-safeTransferFrom}.
1152    */
1153   function safeTransferFrom(
1154     address from,
1155     address to,
1156     uint256 tokenId
1157   ) public override {
1158     safeTransferFrom(from, to, tokenId, "");
1159   }
1160 
1161   /**
1162    * @dev See {IERC721-safeTransferFrom}.
1163    */
1164   function safeTransferFrom(
1165     address from,
1166     address to,
1167     uint256 tokenId,
1168     bytes memory _data
1169   ) public override {
1170     _transfer(from, to, tokenId);
1171     require(
1172       _checkOnERC721Received(from, to, tokenId, _data),
1173       "ERC721A: transfer to non ERC721Receiver implementer"
1174     );
1175   }
1176 
1177   /**
1178    * @dev Returns whether tokenId exists.
1179    *
1180    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1181    *
1182    * Tokens start existing when they are minted (_mint),
1183    */
1184   function _exists(uint256 tokenId) internal view returns (bool) {
1185     return _startTokenId() <= tokenId && tokenId < currentIndex;
1186   }
1187 
1188   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1189     _safeMint(to, quantity, isAdminMint, "");
1190   }
1191 
1192   /**
1193    * @dev Mints quantity tokens and transfers them to to.
1194    *
1195    * Requirements:
1196    *
1197    * - there must be quantity tokens remaining unminted in the total collection.
1198    * - to cannot be the zero address.
1199    * - quantity cannot be larger than the max batch size.
1200    *
1201    * Emits a {Transfer} event.
1202    */
1203   function _safeMint(
1204     address to,
1205     uint256 quantity,
1206     bool isAdminMint,
1207     bytes memory _data
1208   ) internal {
1209     uint256 startTokenId = currentIndex;
1210     require(to != address(0), "ERC721A: mint to the zero address");
1211     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1212     require(!_exists(startTokenId), "ERC721A: token already minted");
1213 
1214     // For admin mints we do not want to enforce the maxBatchSize limit
1215     if (isAdminMint == false) {
1216         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1217     }
1218 
1219     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1220 
1221     AddressData memory addressData = _addressData[to];
1222     _addressData[to] = AddressData(
1223       addressData.balance + uint128(quantity),
1224       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1225     );
1226     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1227 
1228     uint256 updatedIndex = startTokenId;
1229 
1230     for (uint256 i = 0; i < quantity; i++) {
1231       emit Transfer(address(0), to, updatedIndex);
1232       require(
1233         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1234         "ERC721A: transfer to non ERC721Receiver implementer"
1235       );
1236       updatedIndex++;
1237     }
1238 
1239     currentIndex = updatedIndex;
1240     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1241   }
1242 
1243   /**
1244    * @dev Transfers tokenId from from to to.
1245    *
1246    * Requirements:
1247    *
1248    * - to cannot be the zero address.
1249    * - tokenId token must be owned by from.
1250    *
1251    * Emits a {Transfer} event.
1252    */
1253   function _transfer(
1254     address from,
1255     address to,
1256     uint256 tokenId
1257   ) private {
1258     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1259 
1260     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1261       getApproved(tokenId) == _msgSender() ||
1262       isApprovedForAll(prevOwnership.addr, _msgSender()));
1263 
1264     require(
1265       isApprovedOrOwner,
1266       "ERC721A: transfer caller is not owner nor approved"
1267     );
1268 
1269     require(
1270       prevOwnership.addr == from,
1271       "ERC721A: transfer from incorrect owner"
1272     );
1273     require(to != address(0), "ERC721A: transfer to the zero address");
1274 
1275     _beforeTokenTransfers(from, to, tokenId, 1);
1276 
1277     // Clear approvals from the previous owner
1278     _approve(address(0), tokenId, prevOwnership.addr);
1279 
1280     _addressData[from].balance -= 1;
1281     _addressData[to].balance += 1;
1282     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1283 
1284     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1285     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286     uint256 nextTokenId = tokenId + 1;
1287     if (_ownerships[nextTokenId].addr == address(0)) {
1288       if (_exists(nextTokenId)) {
1289         _ownerships[nextTokenId] = TokenOwnership(
1290           prevOwnership.addr,
1291           prevOwnership.startTimestamp
1292         );
1293       }
1294     }
1295 
1296     emit Transfer(from, to, tokenId);
1297     _afterTokenTransfers(from, to, tokenId, 1);
1298   }
1299 
1300   /**
1301    * @dev Approve to to operate on tokenId
1302    *
1303    * Emits a {Approval} event.
1304    */
1305   function _approve(
1306     address to,
1307     uint256 tokenId,
1308     address owner
1309   ) private {
1310     _tokenApprovals[tokenId] = to;
1311     emit Approval(owner, to, tokenId);
1312   }
1313 
1314   uint256 public nextOwnerToExplicitlySet = 0;
1315 
1316   /**
1317    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1318    */
1319   function _setOwnersExplicit(uint256 quantity) internal {
1320     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1321     require(quantity > 0, "quantity must be nonzero");
1322     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1323 
1324     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1325     if (endIndex > collectionSize - 1) {
1326       endIndex = collectionSize - 1;
1327     }
1328     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1329     require(_exists(endIndex), "not enough minted yet for this cleanup");
1330     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1331       if (_ownerships[i].addr == address(0)) {
1332         TokenOwnership memory ownership = ownershipOf(i);
1333         _ownerships[i] = TokenOwnership(
1334           ownership.addr,
1335           ownership.startTimestamp
1336         );
1337       }
1338     }
1339     nextOwnerToExplicitlySet = endIndex + 1;
1340   }
1341 
1342   /**
1343    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1344    * The call is not executed if the target address is not a contract.
1345    *
1346    * @param from address representing the previous owner of the given token ID
1347    * @param to target address that will receive the tokens
1348    * @param tokenId uint256 ID of the token to be transferred
1349    * @param _data bytes optional data to send along with the call
1350    * @return bool whether the call correctly returned the expected magic value
1351    */
1352   function _checkOnERC721Received(
1353     address from,
1354     address to,
1355     uint256 tokenId,
1356     bytes memory _data
1357   ) private returns (bool) {
1358     if (to.isContract()) {
1359       try
1360         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1361       returns (bytes4 retval) {
1362         return retval == IERC721Receiver(to).onERC721Received.selector;
1363       } catch (bytes memory reason) {
1364         if (reason.length == 0) {
1365           revert("ERC721A: transfer to non ERC721Receiver implementer");
1366         } else {
1367           assembly {
1368             revert(add(32, reason), mload(reason))
1369           }
1370         }
1371       }
1372     } else {
1373       return true;
1374     }
1375   }
1376 
1377   /**
1378    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1379    *
1380    * startTokenId - the first token id to be transferred
1381    * quantity - the amount to be transferred
1382    *
1383    * Calling conditions:
1384    *
1385    * - When from and to are both non-zero, from's tokenId will be
1386    * transferred to to.
1387    * - When from is zero, tokenId will be minted for to.
1388    */
1389   function _beforeTokenTransfers(
1390     address from,
1391     address to,
1392     uint256 startTokenId,
1393     uint256 quantity
1394   ) internal virtual {}
1395 
1396   /**
1397    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1398    * minting.
1399    *
1400    * startTokenId - the first token id to be transferred
1401    * quantity - the amount to be transferred
1402    *
1403    * Calling conditions:
1404    *
1405    * - when from and to are both non-zero.
1406    * - from and to are never both zero.
1407    */
1408   function _afterTokenTransfers(
1409     address from,
1410     address to,
1411     uint256 startTokenId,
1412     uint256 quantity
1413   ) internal virtual {}
1414 }
1415 
1416 
1417 
1418   
1419 abstract contract Ramppable {
1420   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1421 
1422   modifier isRampp() {
1423       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1424       _;
1425   }
1426 }
1427 
1428 
1429   
1430   
1431 interface IERC20 {
1432   function allowance(address owner, address spender) external view returns (uint256);
1433   function transfer(address _to, uint256 _amount) external returns (bool);
1434   function balanceOf(address account) external view returns (uint256);
1435   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1436 }
1437 
1438 // File: WithdrawableV2
1439 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1440 // ERC-20 Payouts are limited to a single payout address. This feature 
1441 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1442 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1443 abstract contract WithdrawableV2 is Teams, Ramppable {
1444   struct acceptedERC20 {
1445     bool isActive;
1446     uint256 chargeAmount;
1447   }
1448 
1449   mapping(address => acceptedERC20) private allowedTokenContracts;
1450   address[] public payableAddresses = [RAMPPADDRESS,0x5c498E9Ee93E055549da7880efbF6Af15319e118,0xb61B188a897f96602Ff2f63F5d9db0C8Bea418B8,0x401399fb7F2452ea658102009f8E8D157a9a826C];
1451   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1452   address public erc20Payable = 0x5c498E9Ee93E055549da7880efbF6Af15319e118;
1453   uint256[] public payableFees = [5,45,45,5];
1454   uint256[] public surchargePayableFees = [100];
1455   uint256 public payableAddressCount = 4;
1456   uint256 public surchargePayableAddressCount = 1;
1457   uint256 public ramppSurchargeBalance = 0 ether;
1458   uint256 public ramppSurchargeFee = 0.001 ether;
1459   bool public onlyERC20MintingMode = false;
1460 
1461   /**
1462   * @dev Calculates the true payable balance of the contract as the
1463   * value on contract may be from ERC-20 mint surcharges and not 
1464   * public mint charges - which are not eligable for rev share & user withdrawl
1465   */
1466   function calcAvailableBalance() public view returns(uint256) {
1467     return address(this).balance - ramppSurchargeBalance;
1468   }
1469 
1470   function withdrawAll() public onlyTeamOrOwner {
1471       require(calcAvailableBalance() > 0);
1472       _withdrawAll();
1473   }
1474   
1475   function withdrawAllRampp() public isRampp {
1476       require(calcAvailableBalance() > 0);
1477       _withdrawAll();
1478   }
1479 
1480   function _withdrawAll() private {
1481       uint256 balance = calcAvailableBalance();
1482       
1483       for(uint i=0; i < payableAddressCount; i++ ) {
1484           _widthdraw(
1485               payableAddresses[i],
1486               (balance * payableFees[i]) / 100
1487           );
1488       }
1489   }
1490   
1491   function _widthdraw(address _address, uint256 _amount) private {
1492       (bool success, ) = _address.call{value: _amount}("");
1493       require(success, "Transfer failed.");
1494   }
1495 
1496   /**
1497   * @dev This function is similiar to the regular withdraw but operates only on the
1498   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1499   **/
1500   function _withdrawAllSurcharges() private {
1501     uint256 balance = ramppSurchargeBalance;
1502     if(balance == 0) { return; }
1503     
1504     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1505         _widthdraw(
1506             surchargePayableAddresses[i],
1507             (balance * surchargePayableFees[i]) / 100
1508         );
1509     }
1510     ramppSurchargeBalance = 0 ether;
1511   }
1512 
1513   /**
1514   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1515   * in the event ERC-20 tokens are paid to the contract for mints. This will
1516   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1517   * @param _tokenContract contract of ERC-20 token to withdraw
1518   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1519   */
1520   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1521     require(_amountToWithdraw > 0);
1522     IERC20 tokenContract = IERC20(_tokenContract);
1523     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1524     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1525     _withdrawAllSurcharges();
1526   }
1527 
1528   /**
1529   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1530   */
1531   function withdrawRamppSurcharges() public isRampp {
1532     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1533     _withdrawAllSurcharges();
1534   }
1535 
1536    /**
1537   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1538   */
1539   function addSurcharge() internal {
1540     ramppSurchargeBalance += ramppSurchargeFee;
1541   }
1542   
1543   /**
1544   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1545   */
1546   function hasSurcharge() internal returns(bool) {
1547     return msg.value == ramppSurchargeFee;
1548   }
1549 
1550   /**
1551   * @dev Set surcharge fee for using ERC-20 payments on contract
1552   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1553   */
1554   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1555     ramppSurchargeFee = _newSurcharge;
1556   }
1557 
1558   /**
1559   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1560   * @param _erc20TokenContract address of ERC-20 contract in question
1561   */
1562   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1563     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1564   }
1565 
1566   /**
1567   * @dev get the value of tokens to transfer for user of an ERC-20
1568   * @param _erc20TokenContract address of ERC-20 contract in question
1569   */
1570   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1571     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1572     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1573   }
1574 
1575   /**
1576   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1577   * @param _erc20TokenContract address of ERC-20 contract in question
1578   * @param _isActive default status of if contract should be allowed to accept payments
1579   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1580   */
1581   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1582     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1583     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1584   }
1585 
1586   /**
1587   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1588   * it will assume the default value of zero. This should not be used to create new payment tokens.
1589   * @param _erc20TokenContract address of ERC-20 contract in question
1590   */
1591   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1592     allowedTokenContracts[_erc20TokenContract].isActive = true;
1593   }
1594 
1595   /**
1596   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1597   * it will assume the default value of zero. This should not be used to create new payment tokens.
1598   * @param _erc20TokenContract address of ERC-20 contract in question
1599   */
1600   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1601     allowedTokenContracts[_erc20TokenContract].isActive = false;
1602   }
1603 
1604   /**
1605   * @dev Enable only ERC-20 payments for minting on this contract
1606   */
1607   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1608     onlyERC20MintingMode = true;
1609   }
1610 
1611   /**
1612   * @dev Disable only ERC-20 payments for minting on this contract
1613   */
1614   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1615     onlyERC20MintingMode = false;
1616   }
1617 
1618   /**
1619   * @dev Set the payout of the ERC-20 token payout to a specific address
1620   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1621   */
1622   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1623     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1624     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1625     erc20Payable = _newErc20Payable;
1626   }
1627 
1628   /**
1629   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1630   */
1631   function resetRamppSurchargeBalance() public isRampp {
1632     ramppSurchargeBalance = 0 ether;
1633   }
1634 
1635   /**
1636   * @dev Allows Rampp wallet to update its own reference as well as update
1637   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1638   * and since Rampp is always the first address this function is limited to the rampp payout only.
1639   * @param _newAddress updated Rampp Address
1640   */
1641   function setRamppAddress(address _newAddress) public isRampp {
1642     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1643     RAMPPADDRESS = _newAddress;
1644     payableAddresses[0] = _newAddress;
1645   }
1646 }
1647 
1648 
1649   
1650 // File: isFeeable.sol
1651 abstract contract Feeable is Teams {
1652   uint256 public PRICE = 0 ether;
1653 
1654   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1655     PRICE = _feeInWei;
1656   }
1657 
1658   function getPrice(uint256 _count) public view returns (uint256) {
1659     return PRICE * _count;
1660   }
1661 }
1662 
1663   
1664   
1665   
1666 abstract contract RamppERC721A is 
1667     Ownable,
1668     Teams,
1669     ERC721A,
1670     WithdrawableV2,
1671     ReentrancyGuard 
1672     , Feeable 
1673      
1674     
1675 {
1676   constructor(
1677     string memory tokenName,
1678     string memory tokenSymbol
1679   ) ERC721A(tokenName, tokenSymbol, 20, 10000) { }
1680     uint8 public CONTRACT_VERSION = 2;
1681     string public _baseTokenURI = "ipfs://bafybeid2ap6inobxdedlxpmxbiu7j3bpmadxiyzohmxfbqlv5clenzikky/";
1682 
1683     bool public mintingOpen = true;
1684     bool public isRevealed = false;
1685     
1686     uint256 public MAX_WALLET_MINTS = 20;
1687 
1688   
1689     /////////////// Admin Mint Functions
1690     /**
1691      * @dev Mints a token to an address with a tokenURI.
1692      * This is owner only and allows a fee-free drop
1693      * @param _to address of the future owner of the token
1694      * @param _qty amount of tokens to drop the owner
1695      */
1696      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1697          require(_qty > 0, "Must mint at least 1 token.");
1698          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1699          _safeMint(_to, _qty, true);
1700      }
1701 
1702   
1703     /////////////// GENERIC MINT FUNCTIONS
1704     /**
1705     * @dev Mints a single token to an address.
1706     * fee may or may not be required*
1707     * @param _to address of the future owner of the token
1708     */
1709     function mintTo(address _to) public payable {
1710         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1711         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1712         require(mintingOpen == true, "Minting is not open right now!");
1713         
1714         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1715         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1716         
1717         _safeMint(_to, 1, false);
1718     }
1719 
1720     /**
1721     * @dev Mints tokens to an address in batch.
1722     * fee may or may not be required*
1723     * @param _to address of the future owner of the token
1724     * @param _amount number of tokens to mint
1725     */
1726     function mintToMultiple(address _to, uint256 _amount) public payable {
1727         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1728         require(_amount >= 1, "Must mint at least 1 token");
1729         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1730         require(mintingOpen == true, "Minting is not open right now!");
1731         
1732         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1733         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1734         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1735 
1736         _safeMint(_to, _amount, false);
1737     }
1738 
1739     /**
1740      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1741      * fee may or may not be required*
1742      * @param _to address of the future owner of the token
1743      * @param _amount number of tokens to mint
1744      * @param _erc20TokenContract erc-20 token contract to mint with
1745      */
1746     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1747       require(_amount >= 1, "Must mint at least 1 token");
1748       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1749       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1750       require(mintingOpen == true, "Minting is not open right now!");
1751       
1752       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1753 
1754       // ERC-20 Specific pre-flight checks
1755       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1756       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1757       IERC20 payableToken = IERC20(_erc20TokenContract);
1758 
1759       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1760       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1761       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1762       
1763       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1764       require(transferComplete, "ERC-20 token was unable to be transferred");
1765       
1766       _safeMint(_to, _amount, false);
1767       addSurcharge();
1768     }
1769 
1770     function openMinting() public onlyTeamOrOwner {
1771         mintingOpen = true;
1772     }
1773 
1774     function stopMinting() public onlyTeamOrOwner {
1775         mintingOpen = false;
1776     }
1777 
1778   
1779 
1780   
1781     /**
1782     * @dev Check if wallet over MAX_WALLET_MINTS
1783     * @param _address address in question to check if minted count exceeds max
1784     */
1785     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1786         require(_amount >= 1, "Amount must be greater than or equal to 1");
1787         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1788     }
1789 
1790     /**
1791     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1792     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1793     */
1794     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1795         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1796         MAX_WALLET_MINTS = _newWalletMax;
1797     }
1798     
1799 
1800   
1801     /**
1802      * @dev Allows owner to set Max mints per tx
1803      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1804      */
1805      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1806          require(_newMaxMint >= 1, "Max mint must be at least 1");
1807          maxBatchSize = _newMaxMint;
1808      }
1809     
1810 
1811   
1812     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
1813         require(isRevealed == false, "Tokens are already unveiled");
1814         _baseTokenURI = _updatedTokenURI;
1815         isRevealed = true;
1816     }
1817     
1818 
1819   function _baseURI() internal view virtual override returns(string memory) {
1820     return _baseTokenURI;
1821   }
1822 
1823   function baseTokenURI() public view returns(string memory) {
1824     return _baseTokenURI;
1825   }
1826 
1827   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1828     _baseTokenURI = baseURI;
1829   }
1830 
1831   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1832     return ownershipOf(tokenId);
1833   }
1834 }
1835 
1836 
1837   
1838 // File: contracts/SunbirdsContract.sol
1839 //SPDX-License-Identifier: MIT
1840 
1841 pragma solidity ^0.8.0;
1842 
1843 contract SunbirdsContract is RamppERC721A {
1844     constructor() RamppERC721A("Sunbirds", "Sunbirds"){}
1845 }
1846   
1847 //*********************************************************************//
1848 //*********************************************************************//  
1849 //                       Rampp v2.1.0
1850 //
1851 //         This smart contract was generated by rampp.xyz.
1852 //            Rampp allows creators like you to launch 
1853 //             large scale NFT communities without code!
1854 //
1855 //    Rampp is not responsible for the content of this contract and
1856 //        hopes it is being used in a responsible and kind way.  
1857 //       Rampp is not associated or affiliated with this project.                                                    
1858 //             Twitter: @Rampp_ ---- rampp.xyz
1859 //*********************************************************************//                                                     
1860 //*********************************************************************// 
