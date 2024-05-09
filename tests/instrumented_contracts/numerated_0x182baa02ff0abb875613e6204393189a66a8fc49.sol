1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _              _                             __                  
5 // / \__  |  \/   |_) _ _|_ _    | | o  |  |    (_     __    o     _ 
6 // \_/| | |  /    | \(_| |__>    |^| |  |  |    __)|_| | \_/ | \_/(/_
7 //
8 //*********************************************************************//
9 //*********************************************************************//
10   
11 //-------------DEPENDENCIES--------------------------//
12 
13 // File: @openzeppelin/contracts/utils/Address.sol
14 
15 
16 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
17 
18 pragma solidity ^0.8.1;
19 
20 /**
21  * @dev Collection of functions related to the address type
22  */
23 library Address {
24     /**
25      * @dev Returns true if account is a contract.
26      *
27      * [IMPORTANT]
28      * ====
29      * It is unsafe to assume that an address for which this function returns
30      * false is an externally-owned account (EOA) and not a contract.
31      *
32      * Among others, isContract will return false for the following
33      * types of addresses:
34      *
35      *  - an externally-owned account
36      *  - a contract in construction
37      *  - an address where a contract will be created
38      *  - an address where a contract lived, but was destroyed
39      * ====
40      *
41      * [IMPORTANT]
42      * ====
43      * You shouldn't rely on isContract to protect against flash loan attacks!
44      *
45      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
46      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
47      * constructor.
48      * ====
49      */
50     function isContract(address account) internal view returns (bool) {
51         // This method relies on extcodesize/address.code.length, which returns 0
52         // for contracts in construction, since the code is only stored at the end
53         // of the constructor execution.
54 
55         return account.code.length > 0;
56     }
57 
58     /**
59      * @dev Replacement for Solidity's transfer: sends amount wei to
60      * recipient, forwarding all available gas and reverting on errors.
61      *
62      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
63      * of certain opcodes, possibly making contracts go over the 2300 gas limit
64      * imposed by transfer, making them unable to receive funds via
65      * transfer. {sendValue} removes this limitation.
66      *
67      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
68      *
69      * IMPORTANT: because control is transferred to recipient, care must be
70      * taken to not create reentrancy vulnerabilities. Consider using
71      * {ReentrancyGuard} or the
72      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
73      */
74     function sendValue(address payable recipient, uint256 amount) internal {
75         require(address(this).balance >= amount, "Address: insufficient balance");
76 
77         (bool success, ) = recipient.call{value: amount}("");
78         require(success, "Address: unable to send value, recipient may have reverted");
79     }
80 
81     /**
82      * @dev Performs a Solidity function call using a low level call. A
83      * plain call is an unsafe replacement for a function call: use this
84      * function instead.
85      *
86      * If target reverts with a revert reason, it is bubbled up by this
87      * function (like regular Solidity function calls).
88      *
89      * Returns the raw returned data. To convert to the expected return value,
90      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
91      *
92      * Requirements:
93      *
94      * - target must be a contract.
95      * - calling target with data must not revert.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
100         return functionCall(target, data, "Address: low-level call failed");
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
105      * errorMessage as a fallback revert reason when target reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(
110         address target,
111         bytes memory data,
112         string memory errorMessage
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
119      * but also transferring value wei to target.
120      *
121      * Requirements:
122      *
123      * - the calling contract must have an ETH balance of at least value.
124      * - the called Solidity function must be payable.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(
129         address target,
130         bytes memory data,
131         uint256 value
132     ) internal returns (bytes memory) {
133         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
138      * with errorMessage as a fallback revert reason when target reverts.
139      *
140      * _Available since v3.1._
141      */
142     function functionCallWithValue(
143         address target,
144         bytes memory data,
145         uint256 value,
146         string memory errorMessage
147     ) internal returns (bytes memory) {
148         require(address(this).balance >= value, "Address: insufficient balance for call");
149         require(isContract(target), "Address: call to non-contract");
150 
151         (bool success, bytes memory returndata) = target.call{value: value}(data);
152         return verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
162         return functionStaticCall(target, data, "Address: low-level static call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
167      * but performing a static call.
168      *
169      * _Available since v3.3._
170      */
171     function functionStaticCall(
172         address target,
173         bytes memory data,
174         string memory errorMessage
175     ) internal view returns (bytes memory) {
176         require(isContract(target), "Address: static call to non-contract");
177 
178         (bool success, bytes memory returndata) = target.staticcall(data);
179         return verifyCallResult(success, returndata, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
184      * but performing a delegate call.
185      *
186      * _Available since v3.4._
187      */
188     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
189         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
194      * but performing a delegate call.
195      *
196      * _Available since v3.4._
197      */
198     function functionDelegateCall(
199         address target,
200         bytes memory data,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(isContract(target), "Address: delegate call to non-contract");
204 
205         (bool success, bytes memory returndata) = target.delegatecall(data);
206         return verifyCallResult(success, returndata, errorMessage);
207     }
208 
209     /**
210      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
211      * revert reason using the provided one.
212      *
213      * _Available since v4.3._
214      */
215     function verifyCallResult(
216         bool success,
217         bytes memory returndata,
218         string memory errorMessage
219     ) internal pure returns (bytes memory) {
220         if (success) {
221             return returndata;
222         } else {
223             // Look for revert reason and bubble it up if present
224             if (returndata.length > 0) {
225                 // The easiest way to bubble the revert reason is using memory via assembly
226 
227                 assembly {
228                     let returndata_size := mload(returndata)
229                     revert(add(32, returndata), returndata_size)
230                 }
231             } else {
232                 revert(errorMessage);
233             }
234         }
235     }
236 }
237 
238 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
239 
240 
241 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @title ERC721 token receiver interface
247  * @dev Interface for any contract that wants to support safeTransfers
248  * from ERC721 asset contracts.
249  */
250 interface IERC721Receiver {
251     /**
252      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
253      * by operator from from, this function is called.
254      *
255      * It must return its Solidity selector to confirm the token transfer.
256      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
257      *
258      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
259      */
260     function onERC721Received(
261         address operator,
262         address from,
263         uint256 tokenId,
264         bytes calldata data
265     ) external returns (bytes4);
266 }
267 
268 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
269 
270 
271 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Interface of the ERC165 standard, as defined in the
277  * https://eips.ethereum.org/EIPS/eip-165[EIP].
278  *
279  * Implementers can declare support of contract interfaces, which can then be
280  * queried by others ({ERC165Checker}).
281  *
282  * For an implementation, see {ERC165}.
283  */
284 interface IERC165 {
285     /**
286      * @dev Returns true if this contract implements the interface defined by
287      * interfaceId. See the corresponding
288      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
289      * to learn more about how these ids are created.
290      *
291      * This function call must use less than 30 000 gas.
292      */
293     function supportsInterface(bytes4 interfaceId) external view returns (bool);
294 }
295 
296 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 
304 /**
305  * @dev Implementation of the {IERC165} interface.
306  *
307  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
308  * for the additional interface id that will be supported. For example:
309  *
310  * solidity
311  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
312  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
313  * }
314  * 
315  *
316  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
317  */
318 abstract contract ERC165 is IERC165 {
319     /**
320      * @dev See {IERC165-supportsInterface}.
321      */
322     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
323         return interfaceId == type(IERC165).interfaceId;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 
335 /**
336  * @dev Required interface of an ERC721 compliant contract.
337  */
338 interface IERC721 is IERC165 {
339     /**
340      * @dev Emitted when tokenId token is transferred from from to to.
341      */
342     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
343 
344     /**
345      * @dev Emitted when owner enables approved to manage the tokenId token.
346      */
347     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
348 
349     /**
350      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
351      */
352     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
353 
354     /**
355      * @dev Returns the number of tokens in owner's account.
356      */
357     function balanceOf(address owner) external view returns (uint256 balance);
358 
359     /**
360      * @dev Returns the owner of the tokenId token.
361      *
362      * Requirements:
363      *
364      * - tokenId must exist.
365      */
366     function ownerOf(uint256 tokenId) external view returns (address owner);
367 
368     /**
369      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
370      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
371      *
372      * Requirements:
373      *
374      * - from cannot be the zero address.
375      * - to cannot be the zero address.
376      * - tokenId token must exist and be owned by from.
377      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
378      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
379      *
380      * Emits a {Transfer} event.
381      */
382     function safeTransferFrom(
383         address from,
384         address to,
385         uint256 tokenId
386     ) external;
387 
388     /**
389      * @dev Transfers tokenId token from from to to.
390      *
391      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
392      *
393      * Requirements:
394      *
395      * - from cannot be the zero address.
396      * - to cannot be the zero address.
397      * - tokenId token must be owned by from.
398      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(
403         address from,
404         address to,
405         uint256 tokenId
406     ) external;
407 
408     /**
409      * @dev Gives permission to to to transfer tokenId token to another account.
410      * The approval is cleared when the token is transferred.
411      *
412      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
413      *
414      * Requirements:
415      *
416      * - The caller must own the token or be an approved operator.
417      * - tokenId must exist.
418      *
419      * Emits an {Approval} event.
420      */
421     function approve(address to, uint256 tokenId) external;
422 
423     /**
424      * @dev Returns the account approved for tokenId token.
425      *
426      * Requirements:
427      *
428      * - tokenId must exist.
429      */
430     function getApproved(uint256 tokenId) external view returns (address operator);
431 
432     /**
433      * @dev Approve or remove operator as an operator for the caller.
434      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
435      *
436      * Requirements:
437      *
438      * - The operator cannot be the caller.
439      *
440      * Emits an {ApprovalForAll} event.
441      */
442     function setApprovalForAll(address operator, bool _approved) external;
443 
444     /**
445      * @dev Returns if the operator is allowed to manage all of the assets of owner.
446      *
447      * See {setApprovalForAll}
448      */
449     function isApprovedForAll(address owner, address operator) external view returns (bool);
450 
451     /**
452      * @dev Safely transfers tokenId token from from to to.
453      *
454      * Requirements:
455      *
456      * - from cannot be the zero address.
457      * - to cannot be the zero address.
458      * - tokenId token must exist and be owned by from.
459      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
460      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId,
468         bytes calldata data
469     ) external;
470 }
471 
472 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 
480 /**
481  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
482  * @dev See https://eips.ethereum.org/EIPS/eip-721
483  */
484 interface IERC721Enumerable is IERC721 {
485     /**
486      * @dev Returns the total amount of tokens stored by the contract.
487      */
488     function totalSupply() external view returns (uint256);
489 
490     /**
491      * @dev Returns a token ID owned by owner at a given index of its token list.
492      * Use along with {balanceOf} to enumerate all of owner's tokens.
493      */
494     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
495 
496     /**
497      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
498      * Use along with {totalSupply} to enumerate all tokens.
499      */
500     function tokenByIndex(uint256 index) external view returns (uint256);
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
513  * @dev See https://eips.ethereum.org/EIPS/eip-721
514  */
515 interface IERC721Metadata is IERC721 {
516     /**
517      * @dev Returns the token collection name.
518      */
519     function name() external view returns (string memory);
520 
521     /**
522      * @dev Returns the token collection symbol.
523      */
524     function symbol() external view returns (string memory);
525 
526     /**
527      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
528      */
529     function tokenURI(uint256 tokenId) external view returns (string memory);
530 }
531 
532 // File: @openzeppelin/contracts/utils/Strings.sol
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @dev String operations.
541  */
542 library Strings {
543     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
544 
545     /**
546      * @dev Converts a uint256 to its ASCII string decimal representation.
547      */
548     function toString(uint256 value) internal pure returns (string memory) {
549         // Inspired by OraclizeAPI's implementation - MIT licence
550         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
551 
552         if (value == 0) {
553             return "0";
554         }
555         uint256 temp = value;
556         uint256 digits;
557         while (temp != 0) {
558             digits++;
559             temp /= 10;
560         }
561         bytes memory buffer = new bytes(digits);
562         while (value != 0) {
563             digits -= 1;
564             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
565             value /= 10;
566         }
567         return string(buffer);
568     }
569 
570     /**
571      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
572      */
573     function toHexString(uint256 value) internal pure returns (string memory) {
574         if (value == 0) {
575             return "0x00";
576         }
577         uint256 temp = value;
578         uint256 length = 0;
579         while (temp != 0) {
580             length++;
581             temp >>= 8;
582         }
583         return toHexString(value, length);
584     }
585 
586     /**
587      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
588      */
589     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
590         bytes memory buffer = new bytes(2 * length + 2);
591         buffer[0] = "0";
592         buffer[1] = "x";
593         for (uint256 i = 2 * length + 1; i > 1; --i) {
594             buffer[i] = _HEX_SYMBOLS[value & 0xf];
595             value >>= 4;
596         }
597         require(value == 0, "Strings: hex length insufficient");
598         return string(buffer);
599     }
600 }
601 
602 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev Contract module that helps prevent reentrant calls to a function.
611  *
612  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
613  * available, which can be applied to functions to make sure there are no nested
614  * (reentrant) calls to them.
615  *
616  * Note that because there is a single nonReentrant guard, functions marked as
617  * nonReentrant may not call one another. This can be worked around by making
618  * those functions private, and then adding external nonReentrant entry
619  * points to them.
620  *
621  * TIP: If you would like to learn more about reentrancy and alternative ways
622  * to protect against it, check out our blog post
623  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
624  */
625 abstract contract ReentrancyGuard {
626     // Booleans are more expensive than uint256 or any type that takes up a full
627     // word because each write operation emits an extra SLOAD to first read the
628     // slot's contents, replace the bits taken up by the boolean, and then write
629     // back. This is the compiler's defense against contract upgrades and
630     // pointer aliasing, and it cannot be disabled.
631 
632     // The values being non-zero value makes deployment a bit more expensive,
633     // but in exchange the refund on every call to nonReentrant will be lower in
634     // amount. Since refunds are capped to a percentage of the total
635     // transaction's gas, it is best to keep them low in cases like this one, to
636     // increase the likelihood of the full refund coming into effect.
637     uint256 private constant _NOT_ENTERED = 1;
638     uint256 private constant _ENTERED = 2;
639 
640     uint256 private _status;
641 
642     constructor() {
643         _status = _NOT_ENTERED;
644     }
645 
646     /**
647      * @dev Prevents a contract from calling itself, directly or indirectly.
648      * Calling a nonReentrant function from another nonReentrant
649      * function is not supported. It is possible to prevent this from happening
650      * by making the nonReentrant function external, and making it call a
651      * private function that does the actual work.
652      */
653     modifier nonReentrant() {
654         // On the first call to nonReentrant, _notEntered will be true
655         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
656 
657         // Any calls to nonReentrant after this point will fail
658         _status = _ENTERED;
659 
660         _;
661 
662         // By storing the original value once again, a refund is triggered (see
663         // https://eips.ethereum.org/EIPS/eip-2200)
664         _status = _NOT_ENTERED;
665     }
666 }
667 
668 // File: @openzeppelin/contracts/utils/Context.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev Provides information about the current execution context, including the
677  * sender of the transaction and its data. While these are generally available
678  * via msg.sender and msg.data, they should not be accessed in such a direct
679  * manner, since when dealing with meta-transactions the account sending and
680  * paying for execution may not be the actual sender (as far as an application
681  * is concerned).
682  *
683  * This contract is only required for intermediate, library-like contracts.
684  */
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes calldata) {
691         return msg.data;
692     }
693 }
694 
695 // File: @openzeppelin/contracts/access/Ownable.sol
696 
697 
698 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Contract module which provides a basic access control mechanism, where
705  * there is an account (an owner) that can be granted exclusive access to
706  * specific functions.
707  *
708  * By default, the owner account will be the one that deploys the contract. This
709  * can later be changed with {transferOwnership}.
710  *
711  * This module is used through inheritance. It will make available the modifier
712  * onlyOwner, which can be applied to your functions to restrict their use to
713  * the owner.
714  */
715 abstract contract Ownable is Context {
716     address private _owner;
717 
718     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
719 
720     /**
721      * @dev Initializes the contract setting the deployer as the initial owner.
722      */
723     constructor() {
724         _transferOwnership(_msgSender());
725     }
726 
727     /**
728      * @dev Returns the address of the current owner.
729      */
730     function owner() public view virtual returns (address) {
731         return _owner;
732     }
733 
734     /**
735      * @dev Throws if called by any account other than the owner.
736      */
737     modifier onlyOwner() {
738         require(owner() == _msgSender(), "Ownable: caller is not the owner");
739         _;
740     }
741 
742     /**
743      * @dev Leaves the contract without owner. It will not be possible to call
744      * onlyOwner functions anymore. Can only be called by the current owner.
745      *
746      * NOTE: Renouncing ownership will leave the contract without an owner,
747      * thereby removing any functionality that is only available to the owner.
748      */
749     function renounceOwnership() public virtual onlyOwner {
750         _transferOwnership(address(0));
751     }
752 
753     /**
754      * @dev Transfers ownership of the contract to a new account (newOwner).
755      * Can only be called by the current owner.
756      */
757     function transferOwnership(address newOwner) public virtual onlyOwner {
758         require(newOwner != address(0), "Ownable: new owner is the zero address");
759         _transferOwnership(newOwner);
760     }
761 
762     /**
763      * @dev Transfers ownership of the contract to a new account (newOwner).
764      * Internal function without access restriction.
765      */
766     function _transferOwnership(address newOwner) internal virtual {
767         address oldOwner = _owner;
768         _owner = newOwner;
769         emit OwnershipTransferred(oldOwner, newOwner);
770     }
771 }
772 //-------------END DEPENDENCIES------------------------//
773 
774 
775   
776 // Rampp Contracts v2.1 (Teams.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
782 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
783 * This will easily allow cross-collaboration via Mintplex.xyz.
784 **/
785 abstract contract Teams is Ownable{
786   mapping (address => bool) internal team;
787 
788   /**
789   * @dev Adds an address to the team. Allows them to execute protected functions
790   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
791   **/
792   function addToTeam(address _address) public onlyOwner {
793     require(_address != address(0), "Invalid address");
794     require(!inTeam(_address), "This address is already in your team.");
795   
796     team[_address] = true;
797   }
798 
799   /**
800   * @dev Removes an address to the team.
801   * @param _address the ETH address to remove, cannot be 0x and must be in team
802   **/
803   function removeFromTeam(address _address) public onlyOwner {
804     require(_address != address(0), "Invalid address");
805     require(inTeam(_address), "This address is not in your team currently.");
806   
807     team[_address] = false;
808   }
809 
810   /**
811   * @dev Check if an address is valid and active in the team
812   * @param _address ETH address to check for truthiness
813   **/
814   function inTeam(address _address)
815     public
816     view
817     returns (bool)
818   {
819     require(_address != address(0), "Invalid address to check.");
820     return team[_address] == true;
821   }
822 
823   /**
824   * @dev Throws if called by any account other than the owner or team member.
825   */
826   modifier onlyTeamOrOwner() {
827     bool _isOwner = owner() == _msgSender();
828     bool _isTeam = inTeam(_msgSender());
829     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
830     _;
831   }
832 }
833 
834 
835   
836   
837 /**
838  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
839  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
840  *
841  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
842  * 
843  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
844  *
845  * Does not support burning tokens to address(0).
846  */
847 contract ERC721A is
848   Context,
849   ERC165,
850   IERC721,
851   IERC721Metadata,
852   IERC721Enumerable,
853   Teams
854 {
855   using Address for address;
856   using Strings for uint256;
857 
858   struct TokenOwnership {
859     address addr;
860     uint64 startTimestamp;
861   }
862 
863   struct AddressData {
864     uint128 balance;
865     uint128 numberMinted;
866   }
867 
868   uint256 private currentIndex;
869 
870   uint256 public immutable collectionSize;
871   uint256 public maxBatchSize;
872 
873   // Token name
874   string private _name;
875 
876   // Token symbol
877   string private _symbol;
878 
879   // Mapping from token ID to ownership details
880   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
881   mapping(uint256 => TokenOwnership) private _ownerships;
882 
883   // Mapping owner address to address data
884   mapping(address => AddressData) private _addressData;
885 
886   // Mapping from token ID to approved address
887   mapping(uint256 => address) private _tokenApprovals;
888 
889   // Mapping from owner to operator approvals
890   mapping(address => mapping(address => bool)) private _operatorApprovals;
891 
892   /* @dev Mapping of restricted operator approvals set by contract Owner
893   * This serves as an optional addition to ERC-721 so
894   * that the contract owner can elect to prevent specific addresses/contracts
895   * from being marked as the approver for a token. The reason for this
896   * is that some projects may want to retain control of where their tokens can/can not be listed
897   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
898   * By default, there are no restrictions. The contract owner must deliberatly block an address 
899   */
900   mapping(address => bool) public restrictedApprovalAddresses;
901 
902   /**
903    * @dev
904    * maxBatchSize refers to how much a minter can mint at a time.
905    * collectionSize_ refers to how many tokens are in the collection.
906    */
907   constructor(
908     string memory name_,
909     string memory symbol_,
910     uint256 maxBatchSize_,
911     uint256 collectionSize_
912   ) {
913     require(
914       collectionSize_ > 0,
915       "ERC721A: collection must have a nonzero supply"
916     );
917     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
918     _name = name_;
919     _symbol = symbol_;
920     maxBatchSize = maxBatchSize_;
921     collectionSize = collectionSize_;
922     currentIndex = _startTokenId();
923   }
924 
925   /**
926   * To change the starting tokenId, please override this function.
927   */
928   function _startTokenId() internal view virtual returns (uint256) {
929     return 1;
930   }
931 
932   /**
933    * @dev See {IERC721Enumerable-totalSupply}.
934    */
935   function totalSupply() public view override returns (uint256) {
936     return _totalMinted();
937   }
938 
939   function currentTokenId() public view returns (uint256) {
940     return _totalMinted();
941   }
942 
943   function getNextTokenId() public view returns (uint256) {
944       return _totalMinted() + 1;
945   }
946 
947   /**
948   * Returns the total amount of tokens minted in the contract.
949   */
950   function _totalMinted() internal view returns (uint256) {
951     unchecked {
952       return currentIndex - _startTokenId();
953     }
954   }
955 
956   /**
957    * @dev See {IERC721Enumerable-tokenByIndex}.
958    */
959   function tokenByIndex(uint256 index) public view override returns (uint256) {
960     require(index < totalSupply(), "ERC721A: global index out of bounds");
961     return index;
962   }
963 
964   /**
965    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
966    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
967    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
968    */
969   function tokenOfOwnerByIndex(address owner, uint256 index)
970     public
971     view
972     override
973     returns (uint256)
974   {
975     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
976     uint256 numMintedSoFar = totalSupply();
977     uint256 tokenIdsIdx = 0;
978     address currOwnershipAddr = address(0);
979     for (uint256 i = 0; i < numMintedSoFar; i++) {
980       TokenOwnership memory ownership = _ownerships[i];
981       if (ownership.addr != address(0)) {
982         currOwnershipAddr = ownership.addr;
983       }
984       if (currOwnershipAddr == owner) {
985         if (tokenIdsIdx == index) {
986           return i;
987         }
988         tokenIdsIdx++;
989       }
990     }
991     revert("ERC721A: unable to get token of owner by index");
992   }
993 
994   /**
995    * @dev See {IERC165-supportsInterface}.
996    */
997   function supportsInterface(bytes4 interfaceId)
998     public
999     view
1000     virtual
1001     override(ERC165, IERC165)
1002     returns (bool)
1003   {
1004     return
1005       interfaceId == type(IERC721).interfaceId ||
1006       interfaceId == type(IERC721Metadata).interfaceId ||
1007       interfaceId == type(IERC721Enumerable).interfaceId ||
1008       super.supportsInterface(interfaceId);
1009   }
1010 
1011   /**
1012    * @dev See {IERC721-balanceOf}.
1013    */
1014   function balanceOf(address owner) public view override returns (uint256) {
1015     require(owner != address(0), "ERC721A: balance query for the zero address");
1016     return uint256(_addressData[owner].balance);
1017   }
1018 
1019   function _numberMinted(address owner) internal view returns (uint256) {
1020     require(
1021       owner != address(0),
1022       "ERC721A: number minted query for the zero address"
1023     );
1024     return uint256(_addressData[owner].numberMinted);
1025   }
1026 
1027   function ownershipOf(uint256 tokenId)
1028     internal
1029     view
1030     returns (TokenOwnership memory)
1031   {
1032     uint256 curr = tokenId;
1033 
1034     unchecked {
1035         if (_startTokenId() <= curr && curr < currentIndex) {
1036             TokenOwnership memory ownership = _ownerships[curr];
1037             if (ownership.addr != address(0)) {
1038                 return ownership;
1039             }
1040 
1041             // Invariant:
1042             // There will always be an ownership that has an address and is not burned
1043             // before an ownership that does not have an address and is not burned.
1044             // Hence, curr will not underflow.
1045             while (true) {
1046                 curr--;
1047                 ownership = _ownerships[curr];
1048                 if (ownership.addr != address(0)) {
1049                     return ownership;
1050                 }
1051             }
1052         }
1053     }
1054 
1055     revert("ERC721A: unable to determine the owner of token");
1056   }
1057 
1058   /**
1059    * @dev See {IERC721-ownerOf}.
1060    */
1061   function ownerOf(uint256 tokenId) public view override returns (address) {
1062     return ownershipOf(tokenId).addr;
1063   }
1064 
1065   /**
1066    * @dev See {IERC721Metadata-name}.
1067    */
1068   function name() public view virtual override returns (string memory) {
1069     return _name;
1070   }
1071 
1072   /**
1073    * @dev See {IERC721Metadata-symbol}.
1074    */
1075   function symbol() public view virtual override returns (string memory) {
1076     return _symbol;
1077   }
1078 
1079   /**
1080    * @dev See {IERC721Metadata-tokenURI}.
1081    */
1082   function tokenURI(uint256 tokenId)
1083     public
1084     view
1085     virtual
1086     override
1087     returns (string memory)
1088   {
1089     string memory baseURI = _baseURI();
1090     string memory extension = _baseURIExtension();
1091     return
1092       bytes(baseURI).length > 0
1093         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1094         : "";
1095   }
1096 
1097   /**
1098    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1099    * token will be the concatenation of the baseURI and the tokenId. Empty
1100    * by default, can be overriden in child contracts.
1101    */
1102   function _baseURI() internal view virtual returns (string memory) {
1103     return "";
1104   }
1105 
1106   /**
1107    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1108    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1109    * by default, can be overriden in child contracts.
1110    */
1111   function _baseURIExtension() internal view virtual returns (string memory) {
1112     return "";
1113   }
1114 
1115   /**
1116    * @dev Sets the value for an address to be in the restricted approval address pool.
1117    * Setting an address to true will disable token owners from being able to mark the address
1118    * for approval for trading. This would be used in theory to prevent token owners from listing
1119    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1120    * @param _address the marketplace/user to modify restriction status of
1121    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1122    */
1123   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1124     restrictedApprovalAddresses[_address] = _isRestricted;
1125   }
1126 
1127   /**
1128    * @dev See {IERC721-approve}.
1129    */
1130   function approve(address to, uint256 tokenId) public override {
1131     address owner = ERC721A.ownerOf(tokenId);
1132     require(to != owner, "ERC721A: approval to current owner");
1133     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1134 
1135     require(
1136       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1137       "ERC721A: approve caller is not owner nor approved for all"
1138     );
1139 
1140     _approve(to, tokenId, owner);
1141   }
1142 
1143   /**
1144    * @dev See {IERC721-getApproved}.
1145    */
1146   function getApproved(uint256 tokenId) public view override returns (address) {
1147     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1148 
1149     return _tokenApprovals[tokenId];
1150   }
1151 
1152   /**
1153    * @dev See {IERC721-setApprovalForAll}.
1154    */
1155   function setApprovalForAll(address operator, bool approved) public override {
1156     require(operator != _msgSender(), "ERC721A: approve to caller");
1157     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1158 
1159     _operatorApprovals[_msgSender()][operator] = approved;
1160     emit ApprovalForAll(_msgSender(), operator, approved);
1161   }
1162 
1163   /**
1164    * @dev See {IERC721-isApprovedForAll}.
1165    */
1166   function isApprovedForAll(address owner, address operator)
1167     public
1168     view
1169     virtual
1170     override
1171     returns (bool)
1172   {
1173     return _operatorApprovals[owner][operator];
1174   }
1175 
1176   /**
1177    * @dev See {IERC721-transferFrom}.
1178    */
1179   function transferFrom(
1180     address from,
1181     address to,
1182     uint256 tokenId
1183   ) public override {
1184     _transfer(from, to, tokenId);
1185   }
1186 
1187   /**
1188    * @dev See {IERC721-safeTransferFrom}.
1189    */
1190   function safeTransferFrom(
1191     address from,
1192     address to,
1193     uint256 tokenId
1194   ) public override {
1195     safeTransferFrom(from, to, tokenId, "");
1196   }
1197 
1198   /**
1199    * @dev See {IERC721-safeTransferFrom}.
1200    */
1201   function safeTransferFrom(
1202     address from,
1203     address to,
1204     uint256 tokenId,
1205     bytes memory _data
1206   ) public override {
1207     _transfer(from, to, tokenId);
1208     require(
1209       _checkOnERC721Received(from, to, tokenId, _data),
1210       "ERC721A: transfer to non ERC721Receiver implementer"
1211     );
1212   }
1213 
1214   /**
1215    * @dev Returns whether tokenId exists.
1216    *
1217    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1218    *
1219    * Tokens start existing when they are minted (_mint),
1220    */
1221   function _exists(uint256 tokenId) internal view returns (bool) {
1222     return _startTokenId() <= tokenId && tokenId < currentIndex;
1223   }
1224 
1225   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1226     _safeMint(to, quantity, isAdminMint, "");
1227   }
1228 
1229   /**
1230    * @dev Mints quantity tokens and transfers them to to.
1231    *
1232    * Requirements:
1233    *
1234    * - there must be quantity tokens remaining unminted in the total collection.
1235    * - to cannot be the zero address.
1236    * - quantity cannot be larger than the max batch size.
1237    *
1238    * Emits a {Transfer} event.
1239    */
1240   function _safeMint(
1241     address to,
1242     uint256 quantity,
1243     bool isAdminMint,
1244     bytes memory _data
1245   ) internal {
1246     uint256 startTokenId = currentIndex;
1247     require(to != address(0), "ERC721A: mint to the zero address");
1248     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1249     require(!_exists(startTokenId), "ERC721A: token already minted");
1250 
1251     // For admin mints we do not want to enforce the maxBatchSize limit
1252     if (isAdminMint == false) {
1253         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1254     }
1255 
1256     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1257 
1258     AddressData memory addressData = _addressData[to];
1259     _addressData[to] = AddressData(
1260       addressData.balance + uint128(quantity),
1261       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1262     );
1263     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1264 
1265     uint256 updatedIndex = startTokenId;
1266 
1267     for (uint256 i = 0; i < quantity; i++) {
1268       emit Transfer(address(0), to, updatedIndex);
1269       require(
1270         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1271         "ERC721A: transfer to non ERC721Receiver implementer"
1272       );
1273       updatedIndex++;
1274     }
1275 
1276     currentIndex = updatedIndex;
1277     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1278   }
1279 
1280   /**
1281    * @dev Transfers tokenId from from to to.
1282    *
1283    * Requirements:
1284    *
1285    * - to cannot be the zero address.
1286    * - tokenId token must be owned by from.
1287    *
1288    * Emits a {Transfer} event.
1289    */
1290   function _transfer(
1291     address from,
1292     address to,
1293     uint256 tokenId
1294   ) private {
1295     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1296 
1297     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1298       getApproved(tokenId) == _msgSender() ||
1299       isApprovedForAll(prevOwnership.addr, _msgSender()));
1300 
1301     require(
1302       isApprovedOrOwner,
1303       "ERC721A: transfer caller is not owner nor approved"
1304     );
1305 
1306     require(
1307       prevOwnership.addr == from,
1308       "ERC721A: transfer from incorrect owner"
1309     );
1310     require(to != address(0), "ERC721A: transfer to the zero address");
1311 
1312     _beforeTokenTransfers(from, to, tokenId, 1);
1313 
1314     // Clear approvals from the previous owner
1315     _approve(address(0), tokenId, prevOwnership.addr);
1316 
1317     _addressData[from].balance -= 1;
1318     _addressData[to].balance += 1;
1319     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1320 
1321     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1322     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1323     uint256 nextTokenId = tokenId + 1;
1324     if (_ownerships[nextTokenId].addr == address(0)) {
1325       if (_exists(nextTokenId)) {
1326         _ownerships[nextTokenId] = TokenOwnership(
1327           prevOwnership.addr,
1328           prevOwnership.startTimestamp
1329         );
1330       }
1331     }
1332 
1333     emit Transfer(from, to, tokenId);
1334     _afterTokenTransfers(from, to, tokenId, 1);
1335   }
1336 
1337   /**
1338    * @dev Approve to to operate on tokenId
1339    *
1340    * Emits a {Approval} event.
1341    */
1342   function _approve(
1343     address to,
1344     uint256 tokenId,
1345     address owner
1346   ) private {
1347     _tokenApprovals[tokenId] = to;
1348     emit Approval(owner, to, tokenId);
1349   }
1350 
1351   uint256 public nextOwnerToExplicitlySet = 0;
1352 
1353   /**
1354    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1355    */
1356   function _setOwnersExplicit(uint256 quantity) internal {
1357     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1358     require(quantity > 0, "quantity must be nonzero");
1359     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1360 
1361     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1362     if (endIndex > collectionSize - 1) {
1363       endIndex = collectionSize - 1;
1364     }
1365     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1366     require(_exists(endIndex), "not enough minted yet for this cleanup");
1367     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1368       if (_ownerships[i].addr == address(0)) {
1369         TokenOwnership memory ownership = ownershipOf(i);
1370         _ownerships[i] = TokenOwnership(
1371           ownership.addr,
1372           ownership.startTimestamp
1373         );
1374       }
1375     }
1376     nextOwnerToExplicitlySet = endIndex + 1;
1377   }
1378 
1379   /**
1380    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1381    * The call is not executed if the target address is not a contract.
1382    *
1383    * @param from address representing the previous owner of the given token ID
1384    * @param to target address that will receive the tokens
1385    * @param tokenId uint256 ID of the token to be transferred
1386    * @param _data bytes optional data to send along with the call
1387    * @return bool whether the call correctly returned the expected magic value
1388    */
1389   function _checkOnERC721Received(
1390     address from,
1391     address to,
1392     uint256 tokenId,
1393     bytes memory _data
1394   ) private returns (bool) {
1395     if (to.isContract()) {
1396       try
1397         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1398       returns (bytes4 retval) {
1399         return retval == IERC721Receiver(to).onERC721Received.selector;
1400       } catch (bytes memory reason) {
1401         if (reason.length == 0) {
1402           revert("ERC721A: transfer to non ERC721Receiver implementer");
1403         } else {
1404           assembly {
1405             revert(add(32, reason), mload(reason))
1406           }
1407         }
1408       }
1409     } else {
1410       return true;
1411     }
1412   }
1413 
1414   /**
1415    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1416    *
1417    * startTokenId - the first token id to be transferred
1418    * quantity - the amount to be transferred
1419    *
1420    * Calling conditions:
1421    *
1422    * - When from and to are both non-zero, from's tokenId will be
1423    * transferred to to.
1424    * - When from is zero, tokenId will be minted for to.
1425    */
1426   function _beforeTokenTransfers(
1427     address from,
1428     address to,
1429     uint256 startTokenId,
1430     uint256 quantity
1431   ) internal virtual {}
1432 
1433   /**
1434    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1435    * minting.
1436    *
1437    * startTokenId - the first token id to be transferred
1438    * quantity - the amount to be transferred
1439    *
1440    * Calling conditions:
1441    *
1442    * - when from and to are both non-zero.
1443    * - from and to are never both zero.
1444    */
1445   function _afterTokenTransfers(
1446     address from,
1447     address to,
1448     uint256 startTokenId,
1449     uint256 quantity
1450   ) internal virtual {}
1451 }
1452 
1453 
1454 
1455   
1456 abstract contract Ramppable {
1457   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1458 
1459   modifier isRampp() {
1460       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1461       _;
1462   }
1463 }
1464 
1465 
1466   
1467   
1468 interface IERC20 {
1469   function allowance(address owner, address spender) external view returns (uint256);
1470   function transfer(address _to, uint256 _amount) external returns (bool);
1471   function balanceOf(address account) external view returns (uint256);
1472   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1473 }
1474 
1475 // File: WithdrawableV2
1476 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1477 // ERC-20 Payouts are limited to a single payout address. This feature 
1478 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1479 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1480 abstract contract WithdrawableV2 is Teams, Ramppable {
1481   struct acceptedERC20 {
1482     bool isActive;
1483     uint256 chargeAmount;
1484   }
1485 
1486   
1487   mapping(address => acceptedERC20) private allowedTokenContracts;
1488   address[] public payableAddresses = [0x012D9FeddF3E484eD263008f1533b86dA2231148];
1489   address public erc20Payable = 0x012D9FeddF3E484eD263008f1533b86dA2231148;
1490   uint256[] public payableFees = [100];
1491   uint256 public payableAddressCount = 1;
1492   bool public onlyERC20MintingMode = false;
1493   
1494 
1495   /**
1496   * @dev Calculates the true payable balance of the contract
1497   */
1498   function calcAvailableBalance() public view returns(uint256) {
1499     return address(this).balance;
1500   }
1501 
1502   function withdrawAll() public onlyTeamOrOwner {
1503       require(calcAvailableBalance() > 0);
1504       _withdrawAll();
1505   }
1506   
1507   function withdrawAllRampp() public isRampp {
1508       require(calcAvailableBalance() > 0);
1509       _withdrawAll();
1510   }
1511 
1512   function _withdrawAll() private {
1513       uint256 balance = calcAvailableBalance();
1514       
1515       for(uint i=0; i < payableAddressCount; i++ ) {
1516           _widthdraw(
1517               payableAddresses[i],
1518               (balance * payableFees[i]) / 100
1519           );
1520       }
1521   }
1522   
1523   function _widthdraw(address _address, uint256 _amount) private {
1524       (bool success, ) = _address.call{value: _amount}("");
1525       require(success, "Transfer failed.");
1526   }
1527 
1528   /**
1529   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1530   * in the event ERC-20 tokens are paid to the contract for mints.
1531   * @param _tokenContract contract of ERC-20 token to withdraw
1532   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1533   */
1534   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1535     require(_amountToWithdraw > 0);
1536     IERC20 tokenContract = IERC20(_tokenContract);
1537     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1538     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1539   }
1540 
1541   /**
1542   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1543   * @param _erc20TokenContract address of ERC-20 contract in question
1544   */
1545   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1546     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1547   }
1548 
1549   /**
1550   * @dev get the value of tokens to transfer for user of an ERC-20
1551   * @param _erc20TokenContract address of ERC-20 contract in question
1552   */
1553   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1554     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1555     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1556   }
1557 
1558   /**
1559   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1560   * @param _erc20TokenContract address of ERC-20 contract in question
1561   * @param _isActive default status of if contract should be allowed to accept payments
1562   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1563   */
1564   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1565     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1566     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1567   }
1568 
1569   /**
1570   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1571   * it will assume the default value of zero. This should not be used to create new payment tokens.
1572   * @param _erc20TokenContract address of ERC-20 contract in question
1573   */
1574   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1575     allowedTokenContracts[_erc20TokenContract].isActive = true;
1576   }
1577 
1578   /**
1579   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1580   * it will assume the default value of zero. This should not be used to create new payment tokens.
1581   * @param _erc20TokenContract address of ERC-20 contract in question
1582   */
1583   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1584     allowedTokenContracts[_erc20TokenContract].isActive = false;
1585   }
1586 
1587   /**
1588   * @dev Enable only ERC-20 payments for minting on this contract
1589   */
1590   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1591     onlyERC20MintingMode = true;
1592   }
1593 
1594   /**
1595   * @dev Disable only ERC-20 payments for minting on this contract
1596   */
1597   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1598     onlyERC20MintingMode = false;
1599   }
1600 
1601   /**
1602   * @dev Set the payout of the ERC-20 token payout to a specific address
1603   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1604   */
1605   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1606     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1607     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1608     erc20Payable = _newErc20Payable;
1609   }
1610 
1611   /**
1612   * @dev Allows Rampp wallet to update its own reference.
1613   * @param _newAddress updated Rampp Address
1614   */
1615   function setRamppAddress(address _newAddress) public isRampp {
1616     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1617     RAMPPADDRESS = _newAddress;
1618   }
1619 }
1620 
1621 
1622   
1623   
1624   
1625 // File: EarlyMintIncentive.sol
1626 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1627 // zero fee that can be calculated on the fly.
1628 abstract contract EarlyMintIncentive is Teams, ERC721A {
1629   uint256 public PRICE = 0.0035 ether;
1630   uint256 public EARLY_MINT_PRICE = 0 ether;
1631   uint256 public earlyMintOwnershipCap = 1;
1632   bool public usingEarlyMintIncentive = true;
1633 
1634   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1635     usingEarlyMintIncentive = true;
1636   }
1637 
1638   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1639     usingEarlyMintIncentive = false;
1640   }
1641 
1642   /**
1643   * @dev Set the max token ID in which the cost incentive will be applied.
1644   * @param _newCap max number of tokens wallet may mint for incentive price
1645   */
1646   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1647     require(_newCap >= 1, "Cannot set cap to less than 1");
1648     earlyMintOwnershipCap = _newCap;
1649   }
1650 
1651   /**
1652   * @dev Set the incentive mint price
1653   * @param _feeInWei new price per token when in incentive range
1654   */
1655   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1656     EARLY_MINT_PRICE = _feeInWei;
1657   }
1658 
1659   /**
1660   * @dev Set the primary mint price - the base price when not under incentive
1661   * @param _feeInWei new price per token
1662   */
1663   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1664     PRICE = _feeInWei;
1665   }
1666 
1667   /**
1668   * @dev Get the correct price for the mint for qty and person minting
1669   * @param _count amount of tokens to calc for mint
1670   * @param _to the address which will be minting these tokens, passed explicitly
1671   */
1672   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1673     require(_count > 0, "Must be minting at least 1 token.");
1674 
1675     // short circuit function if we dont need to even calc incentive pricing
1676     // short circuit if the current wallet mint qty is also already over cap
1677     if(
1678       usingEarlyMintIncentive == false ||
1679       _numberMinted(_to) > earlyMintOwnershipCap
1680     ) {
1681       return PRICE * _count;
1682     }
1683 
1684     uint256 endingTokenQty = _numberMinted(_to) + _count;
1685     // If qty to mint results in a final qty less than or equal to the cap then
1686     // the entire qty is within incentive mint.
1687     if(endingTokenQty  <= earlyMintOwnershipCap) {
1688       return EARLY_MINT_PRICE * _count;
1689     }
1690 
1691     // If the current token qty is less than the incentive cap
1692     // and the ending token qty is greater than the incentive cap
1693     // we will be straddling the cap so there will be some amount
1694     // that are incentive and some that are regular fee.
1695     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1696     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1697 
1698     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1699   }
1700 }
1701 
1702   
1703 abstract contract RamppERC721A is 
1704     Ownable,
1705     Teams,
1706     ERC721A,
1707     WithdrawableV2,
1708     ReentrancyGuard 
1709     , EarlyMintIncentive 
1710      
1711     
1712 {
1713   constructor(
1714     string memory tokenName,
1715     string memory tokenSymbol
1716   ) ERC721A(tokenName, tokenSymbol, 30, 6666) { }
1717     uint8 public CONTRACT_VERSION = 2;
1718     string public _baseTokenURI = "https://api.onlyrats.live/";
1719     string public _baseTokenExtension = ".json";
1720 
1721     bool public mintingOpen = false;
1722     
1723     
1724     uint256 public MAX_WALLET_MINTS = 30;
1725 
1726   
1727     /////////////// Admin Mint Functions
1728     /**
1729      * @dev Mints a token to an address with a tokenURI.
1730      * This is owner only and allows a fee-free drop
1731      * @param _to address of the future owner of the token
1732      * @param _qty amount of tokens to drop the owner
1733      */
1734      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1735          require(_qty > 0, "Must mint at least 1 token.");
1736          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 6666");
1737          _safeMint(_to, _qty, true);
1738      }
1739 
1740   
1741     /////////////// GENERIC MINT FUNCTIONS
1742     /**
1743     * @dev Mints a single token to an address.
1744     * fee may or may not be required*
1745     * @param _to address of the future owner of the token
1746     */
1747     function mintTo(address _to) public payable {
1748         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1749         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6666");
1750         require(mintingOpen == true, "Minting is not open right now!");
1751         
1752         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1753         require(msg.value == getPrice(1, _to), "Value below required mint fee for amount");
1754 
1755         _safeMint(_to, 1, false);
1756     }
1757 
1758     /**
1759     * @dev Mints tokens to an address in batch.
1760     * fee may or may not be required*
1761     * @param _to address of the future owner of the token
1762     * @param _amount number of tokens to mint
1763     */
1764     function mintToMultiple(address _to, uint256 _amount) public payable {
1765         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1766         require(_amount >= 1, "Must mint at least 1 token");
1767         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1768         require(mintingOpen == true, "Minting is not open right now!");
1769         
1770         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1771         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 6666");
1772         require(msg.value == getPrice(_amount, _to), "Value below required mint fee for amount");
1773 
1774         _safeMint(_to, _amount, false);
1775     }
1776 
1777     /**
1778      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1779      * fee may or may not be required*
1780      * @param _to address of the future owner of the token
1781      * @param _amount number of tokens to mint
1782      * @param _erc20TokenContract erc-20 token contract to mint with
1783      */
1784     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1785       require(_amount >= 1, "Must mint at least 1 token");
1786       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1787       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 6666");
1788       require(mintingOpen == true, "Minting is not open right now!");
1789       
1790       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1791 
1792       // ERC-20 Specific pre-flight checks
1793       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1794       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1795       IERC20 payableToken = IERC20(_erc20TokenContract);
1796 
1797       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1798       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1799 
1800       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1801       require(transferComplete, "ERC-20 token was unable to be transferred");
1802       
1803       _safeMint(_to, _amount, false);
1804     }
1805 
1806     function openMinting() public onlyTeamOrOwner {
1807         mintingOpen = true;
1808     }
1809 
1810     function stopMinting() public onlyTeamOrOwner {
1811         mintingOpen = false;
1812     }
1813 
1814   
1815 
1816   
1817     /**
1818     * @dev Check if wallet over MAX_WALLET_MINTS
1819     * @param _address address in question to check if minted count exceeds max
1820     */
1821     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1822         require(_amount >= 1, "Amount must be greater than or equal to 1");
1823         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1824     }
1825 
1826     /**
1827     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1828     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1829     */
1830     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1831         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1832         MAX_WALLET_MINTS = _newWalletMax;
1833     }
1834     
1835 
1836   
1837     /**
1838      * @dev Allows owner to set Max mints per tx
1839      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1840      */
1841      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1842          require(_newMaxMint >= 1, "Max mint must be at least 1");
1843          maxBatchSize = _newMaxMint;
1844      }
1845     
1846 
1847   
1848 
1849   function _baseURI() internal view virtual override returns(string memory) {
1850     return _baseTokenURI;
1851   }
1852 
1853   function _baseURIExtension() internal view virtual override returns(string memory) {
1854     return _baseTokenExtension;
1855   }
1856 
1857   function baseTokenURI() public view returns(string memory) {
1858     return _baseTokenURI;
1859   }
1860 
1861   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1862     _baseTokenURI = baseURI;
1863   }
1864 
1865   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
1866     _baseTokenExtension = baseExtension;
1867   }
1868 
1869   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1870     return ownershipOf(tokenId);
1871   }
1872 }
1873 
1874 
1875   
1876 // File: contracts/OnlyRatsWillSurviveContract.sol
1877 //SPDX-License-Identifier: MIT
1878 
1879 pragma solidity ^0.8.0;
1880 
1881 contract OnlyRatsWillSurviveContract is RamppERC721A {
1882     constructor() RamppERC721A("Only Rats Will Survive", "ORWS"){}
1883 }
1884   