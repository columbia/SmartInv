1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //   _ \  |  |  \ |  _ \  |  |  \ |  _ \  |  |  \ | 
5 //     /  |  | .  |    /  |  | .  |    /  |  | .  | 
6 //  _|_\ \__/ _|\_| _|_\ \__/ _|\_| _|_\ \__/ _|\_| 
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
737     function _onlyOwner() private view {
738        require(owner() == _msgSender(), "Ownable: caller is not the owner");
739     }
740 
741     modifier onlyOwner() {
742         _onlyOwner();
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
776 
777 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
778 pragma solidity ^0.8.9;
779 
780 interface IOperatorFilterRegistry {
781     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
782     function register(address registrant) external;
783     function registerAndSubscribe(address registrant, address subscription) external;
784     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
785     function updateOperator(address registrant, address operator, bool filtered) external;
786     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
787     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
788     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
789     function subscribe(address registrant, address registrantToSubscribe) external;
790     function unsubscribe(address registrant, bool copyExistingEntries) external;
791     function subscriptionOf(address addr) external returns (address registrant);
792     function subscribers(address registrant) external returns (address[] memory);
793     function subscriberAt(address registrant, uint256 index) external returns (address);
794     function copyEntriesOf(address registrant, address registrantToCopy) external;
795     function isOperatorFiltered(address registrant, address operator) external returns (bool);
796     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
797     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
798     function filteredOperators(address addr) external returns (address[] memory);
799     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
800     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
801     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
802     function isRegistered(address addr) external returns (bool);
803     function codeHashOf(address addr) external returns (bytes32);
804 }
805 
806 // File contracts/OperatorFilter/OperatorFilterer.sol
807 pragma solidity ^0.8.9;
808 
809 abstract contract OperatorFilterer {
810     error OperatorNotAllowed(address operator);
811 
812     IOperatorFilterRegistry constant operatorFilterRegistry =
813         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
814 
815     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
816         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
817         // will not revert, but the contract will need to be registered with the registry once it is deployed in
818         // order for the modifier to filter addresses.
819         if (address(operatorFilterRegistry).code.length > 0) {
820             if (subscribe) {
821                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
822             } else {
823                 if (subscriptionOrRegistrantToCopy != address(0)) {
824                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
825                 } else {
826                     operatorFilterRegistry.register(address(this));
827                 }
828             }
829         }
830     }
831 
832     function _onlyAllowedOperator(address from) private view {
833       if (
834           !(
835               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
836               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
837           )
838       ) {
839           revert OperatorNotAllowed(msg.sender);
840       }
841     }
842 
843     modifier onlyAllowedOperator(address from) virtual {
844         // Check registry code length to facilitate testing in environments without a deployed registry.
845         if (address(operatorFilterRegistry).code.length > 0) {
846             // Allow spending tokens from addresses with balance
847             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
848             // from an EOA.
849             if (from == msg.sender) {
850                 _;
851                 return;
852             }
853             _onlyAllowedOperator(from);
854         }
855         _;
856     }
857 
858     modifier onlyAllowedOperatorApproval(address operator) virtual {
859         _checkFilterOperator(operator);
860         _;
861     }
862 
863     function _checkFilterOperator(address operator) internal view virtual {
864         // Check registry code length to facilitate testing in environments without a deployed registry.
865         if (address(operatorFilterRegistry).code.length > 0) {
866             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
867                 revert OperatorNotAllowed(operator);
868             }
869         }
870     }
871 }
872 
873 //-------------END DEPENDENCIES------------------------//
874 
875 
876   
877 error TransactionCapExceeded();
878 error PublicMintingClosed();
879 error ExcessiveOwnedMints();
880 error MintZeroQuantity();
881 error InvalidPayment();
882 error CapExceeded();
883 error IsAlreadyUnveiled();
884 error ValueCannotBeZero();
885 error CannotBeNullAddress();
886 error NoStateChange();
887 
888 error PublicMintClosed();
889 error AllowlistMintClosed();
890 
891 error AddressNotAllowlisted();
892 error AllowlistDropTimeHasNotPassed();
893 error PublicDropTimeHasNotPassed();
894 error DropTimeNotInFuture();
895 
896 error OnlyERC20MintingEnabled();
897 error ERC20TokenNotApproved();
898 error ERC20InsufficientBalance();
899 error ERC20InsufficientAllowance();
900 error ERC20TransferFailed();
901 
902 error ClaimModeDisabled();
903 error IneligibleRedemptionContract();
904 error TokenAlreadyRedeemed();
905 error InvalidOwnerForRedemption();
906 error InvalidApprovalForRedemption();
907 
908 error ERC721RestrictedApprovalAddressRestricted();
909   
910   
911 // Rampp Contracts v2.1 (Teams.sol)
912 
913 error InvalidTeamAddress();
914 error DuplicateTeamAddress();
915 pragma solidity ^0.8.0;
916 
917 /**
918 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
919 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
920 * This will easily allow cross-collaboration via Mintplex.xyz.
921 **/
922 abstract contract Teams is Ownable{
923   mapping (address => bool) internal team;
924 
925   /**
926   * @dev Adds an address to the team. Allows them to execute protected functions
927   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
928   **/
929   function addToTeam(address _address) public onlyOwner {
930     if(_address == address(0)) revert InvalidTeamAddress();
931     if(inTeam(_address)) revert DuplicateTeamAddress();
932   
933     team[_address] = true;
934   }
935 
936   /**
937   * @dev Removes an address to the team.
938   * @param _address the ETH address to remove, cannot be 0x and must be in team
939   **/
940   function removeFromTeam(address _address) public onlyOwner {
941     if(_address == address(0)) revert InvalidTeamAddress();
942     if(!inTeam(_address)) revert InvalidTeamAddress();
943   
944     team[_address] = false;
945   }
946 
947   /**
948   * @dev Check if an address is valid and active in the team
949   * @param _address ETH address to check for truthiness
950   **/
951   function inTeam(address _address)
952     public
953     view
954     returns (bool)
955   {
956     if(_address == address(0)) revert InvalidTeamAddress();
957     return team[_address] == true;
958   }
959 
960   /**
961   * @dev Throws if called by any account other than the owner or team member.
962   */
963   function _onlyTeamOrOwner() private view {
964     bool _isOwner = owner() == _msgSender();
965     bool _isTeam = inTeam(_msgSender());
966     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
967   }
968 
969   modifier onlyTeamOrOwner() {
970     _onlyTeamOrOwner();
971     _;
972   }
973 }
974 
975 
976   
977   
978 /**
979  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
980  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
981  *
982  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
983  * 
984  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
985  *
986  * Does not support burning tokens to address(0).
987  */
988 contract ERC721A is
989   Context,
990   ERC165,
991   IERC721,
992   IERC721Metadata,
993   IERC721Enumerable,
994   Teams
995   , OperatorFilterer
996 {
997   using Address for address;
998   using Strings for uint256;
999 
1000   struct TokenOwnership {
1001     address addr;
1002     uint64 startTimestamp;
1003   }
1004 
1005   struct AddressData {
1006     uint128 balance;
1007     uint128 numberMinted;
1008   }
1009 
1010   uint256 private currentIndex;
1011 
1012   uint256 public immutable collectionSize;
1013   uint256 public maxBatchSize;
1014 
1015   // Token name
1016   string private _name;
1017 
1018   // Token symbol
1019   string private _symbol;
1020 
1021   // Mapping from token ID to ownership details
1022   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1023   mapping(uint256 => TokenOwnership) private _ownerships;
1024 
1025   // Mapping owner address to address data
1026   mapping(address => AddressData) private _addressData;
1027 
1028   // Mapping from token ID to approved address
1029   mapping(uint256 => address) private _tokenApprovals;
1030 
1031   // Mapping from owner to operator approvals
1032   mapping(address => mapping(address => bool)) private _operatorApprovals;
1033 
1034   /* @dev Mapping of restricted operator approvals set by contract Owner
1035   * This serves as an optional addition to ERC-721 so
1036   * that the contract owner can elect to prevent specific addresses/contracts
1037   * from being marked as the approver for a token. The reason for this
1038   * is that some projects may want to retain control of where their tokens can/can not be listed
1039   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1040   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1041   */
1042   mapping(address => bool) public restrictedApprovalAddresses;
1043 
1044   /**
1045    * @dev
1046    * maxBatchSize refers to how much a minter can mint at a time.
1047    * collectionSize_ refers to how many tokens are in the collection.
1048    */
1049   constructor(
1050     string memory name_,
1051     string memory symbol_,
1052     uint256 maxBatchSize_,
1053     uint256 collectionSize_
1054   ) OperatorFilterer(address(0), false) {
1055     require(
1056       collectionSize_ > 0,
1057       "ERC721A: collection must have a nonzero supply"
1058     );
1059     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1060     _name = name_;
1061     _symbol = symbol_;
1062     maxBatchSize = maxBatchSize_;
1063     collectionSize = collectionSize_;
1064     currentIndex = _startTokenId();
1065   }
1066 
1067   /**
1068   * To change the starting tokenId, please override this function.
1069   */
1070   function _startTokenId() internal view virtual returns (uint256) {
1071     return 1;
1072   }
1073 
1074   /**
1075    * @dev See {IERC721Enumerable-totalSupply}.
1076    */
1077   function totalSupply() public view override returns (uint256) {
1078     return _totalMinted();
1079   }
1080 
1081   function currentTokenId() public view returns (uint256) {
1082     return _totalMinted();
1083   }
1084 
1085   function getNextTokenId() public view returns (uint256) {
1086       return _totalMinted() + 1;
1087   }
1088 
1089   /**
1090   * Returns the total amount of tokens minted in the contract.
1091   */
1092   function _totalMinted() internal view returns (uint256) {
1093     unchecked {
1094       return currentIndex - _startTokenId();
1095     }
1096   }
1097 
1098   /**
1099    * @dev See {IERC721Enumerable-tokenByIndex}.
1100    */
1101   function tokenByIndex(uint256 index) public view override returns (uint256) {
1102     require(index < totalSupply(), "ERC721A: global index out of bounds");
1103     return index;
1104   }
1105 
1106   /**
1107    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1108    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1109    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1110    */
1111   function tokenOfOwnerByIndex(address owner, uint256 index)
1112     public
1113     view
1114     override
1115     returns (uint256)
1116   {
1117     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1118     uint256 numMintedSoFar = totalSupply();
1119     uint256 tokenIdsIdx = 0;
1120     address currOwnershipAddr = address(0);
1121     for (uint256 i = 0; i < numMintedSoFar; i++) {
1122       TokenOwnership memory ownership = _ownerships[i];
1123       if (ownership.addr != address(0)) {
1124         currOwnershipAddr = ownership.addr;
1125       }
1126       if (currOwnershipAddr == owner) {
1127         if (tokenIdsIdx == index) {
1128           return i;
1129         }
1130         tokenIdsIdx++;
1131       }
1132     }
1133     revert("ERC721A: unable to get token of owner by index");
1134   }
1135 
1136   /**
1137    * @dev See {IERC165-supportsInterface}.
1138    */
1139   function supportsInterface(bytes4 interfaceId)
1140     public
1141     view
1142     virtual
1143     override(ERC165, IERC165)
1144     returns (bool)
1145   {
1146     return
1147       interfaceId == type(IERC721).interfaceId ||
1148       interfaceId == type(IERC721Metadata).interfaceId ||
1149       interfaceId == type(IERC721Enumerable).interfaceId ||
1150       super.supportsInterface(interfaceId);
1151   }
1152 
1153   /**
1154    * @dev See {IERC721-balanceOf}.
1155    */
1156   function balanceOf(address owner) public view override returns (uint256) {
1157     require(owner != address(0), "ERC721A: balance query for the zero address");
1158     return uint256(_addressData[owner].balance);
1159   }
1160 
1161   function _numberMinted(address owner) internal view returns (uint256) {
1162     require(
1163       owner != address(0),
1164       "ERC721A: number minted query for the zero address"
1165     );
1166     return uint256(_addressData[owner].numberMinted);
1167   }
1168 
1169   function ownershipOf(uint256 tokenId)
1170     internal
1171     view
1172     returns (TokenOwnership memory)
1173   {
1174     uint256 curr = tokenId;
1175 
1176     unchecked {
1177         if (_startTokenId() <= curr && curr < currentIndex) {
1178             TokenOwnership memory ownership = _ownerships[curr];
1179             if (ownership.addr != address(0)) {
1180                 return ownership;
1181             }
1182 
1183             // Invariant:
1184             // There will always be an ownership that has an address and is not burned
1185             // before an ownership that does not have an address and is not burned.
1186             // Hence, curr will not underflow.
1187             while (true) {
1188                 curr--;
1189                 ownership = _ownerships[curr];
1190                 if (ownership.addr != address(0)) {
1191                     return ownership;
1192                 }
1193             }
1194         }
1195     }
1196 
1197     revert("ERC721A: unable to determine the owner of token");
1198   }
1199 
1200   /**
1201    * @dev See {IERC721-ownerOf}.
1202    */
1203   function ownerOf(uint256 tokenId) public view override returns (address) {
1204     return ownershipOf(tokenId).addr;
1205   }
1206 
1207   /**
1208    * @dev See {IERC721Metadata-name}.
1209    */
1210   function name() public view virtual override returns (string memory) {
1211     return _name;
1212   }
1213 
1214   /**
1215    * @dev See {IERC721Metadata-symbol}.
1216    */
1217   function symbol() public view virtual override returns (string memory) {
1218     return _symbol;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721Metadata-tokenURI}.
1223    */
1224   function tokenURI(uint256 tokenId)
1225     public
1226     view
1227     virtual
1228     override
1229     returns (string memory)
1230   {
1231     string memory baseURI = _baseURI();
1232     string memory extension = _baseURIExtension();
1233     return
1234       bytes(baseURI).length > 0
1235         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1236         : "";
1237   }
1238 
1239   /**
1240    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1241    * token will be the concatenation of the baseURI and the tokenId. Empty
1242    * by default, can be overriden in child contracts.
1243    */
1244   function _baseURI() internal view virtual returns (string memory) {
1245     return "";
1246   }
1247 
1248   /**
1249    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1250    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1251    * by default, can be overriden in child contracts.
1252    */
1253   function _baseURIExtension() internal view virtual returns (string memory) {
1254     return "";
1255   }
1256 
1257   /**
1258    * @dev Sets the value for an address to be in the restricted approval address pool.
1259    * Setting an address to true will disable token owners from being able to mark the address
1260    * for approval for trading. This would be used in theory to prevent token owners from listing
1261    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1262    * @param _address the marketplace/user to modify restriction status of
1263    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1264    */
1265   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1266     restrictedApprovalAddresses[_address] = _isRestricted;
1267   }
1268 
1269   /**
1270    * @dev See {IERC721-approve}.
1271    */
1272   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1273     address owner = ERC721A.ownerOf(tokenId);
1274     require(to != owner, "ERC721A: approval to current owner");
1275     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1276 
1277     require(
1278       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1279       "ERC721A: approve caller is not owner nor approved for all"
1280     );
1281 
1282     _approve(to, tokenId, owner);
1283   }
1284 
1285   /**
1286    * @dev See {IERC721-getApproved}.
1287    */
1288   function getApproved(uint256 tokenId) public view override returns (address) {
1289     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1290 
1291     return _tokenApprovals[tokenId];
1292   }
1293 
1294   /**
1295    * @dev See {IERC721-setApprovalForAll}.
1296    */
1297   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1298     require(operator != _msgSender(), "ERC721A: approve to caller");
1299     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1300 
1301     _operatorApprovals[_msgSender()][operator] = approved;
1302     emit ApprovalForAll(_msgSender(), operator, approved);
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-isApprovedForAll}.
1307    */
1308   function isApprovedForAll(address owner, address operator)
1309     public
1310     view
1311     virtual
1312     override
1313     returns (bool)
1314   {
1315     return _operatorApprovals[owner][operator];
1316   }
1317 
1318   /**
1319    * @dev See {IERC721-transferFrom}.
1320    */
1321   function transferFrom(
1322     address from,
1323     address to,
1324     uint256 tokenId
1325   ) public override onlyAllowedOperator(from) {
1326     _transfer(from, to, tokenId);
1327   }
1328 
1329   /**
1330    * @dev See {IERC721-safeTransferFrom}.
1331    */
1332   function safeTransferFrom(
1333     address from,
1334     address to,
1335     uint256 tokenId
1336   ) public override onlyAllowedOperator(from) {
1337     safeTransferFrom(from, to, tokenId, "");
1338   }
1339 
1340   /**
1341    * @dev See {IERC721-safeTransferFrom}.
1342    */
1343   function safeTransferFrom(
1344     address from,
1345     address to,
1346     uint256 tokenId,
1347     bytes memory _data
1348   ) public override onlyAllowedOperator(from) {
1349     _transfer(from, to, tokenId);
1350     require(
1351       _checkOnERC721Received(from, to, tokenId, _data),
1352       "ERC721A: transfer to non ERC721Receiver implementer"
1353     );
1354   }
1355 
1356   /**
1357    * @dev Returns whether tokenId exists.
1358    *
1359    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1360    *
1361    * Tokens start existing when they are minted (_mint),
1362    */
1363   function _exists(uint256 tokenId) internal view returns (bool) {
1364     return _startTokenId() <= tokenId && tokenId < currentIndex;
1365   }
1366 
1367   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1368     _safeMint(to, quantity, isAdminMint, "");
1369   }
1370 
1371   /**
1372    * @dev Mints quantity tokens and transfers them to to.
1373    *
1374    * Requirements:
1375    *
1376    * - there must be quantity tokens remaining unminted in the total collection.
1377    * - to cannot be the zero address.
1378    * - quantity cannot be larger than the max batch size.
1379    *
1380    * Emits a {Transfer} event.
1381    */
1382   function _safeMint(
1383     address to,
1384     uint256 quantity,
1385     bool isAdminMint,
1386     bytes memory _data
1387   ) internal {
1388     uint256 startTokenId = currentIndex;
1389     require(to != address(0), "ERC721A: mint to the zero address");
1390     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1391     require(!_exists(startTokenId), "ERC721A: token already minted");
1392 
1393     // For admin mints we do not want to enforce the maxBatchSize limit
1394     if (isAdminMint == false) {
1395         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1396     }
1397 
1398     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1399 
1400     AddressData memory addressData = _addressData[to];
1401     _addressData[to] = AddressData(
1402       addressData.balance + uint128(quantity),
1403       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1404     );
1405     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1406 
1407     uint256 updatedIndex = startTokenId;
1408 
1409     for (uint256 i = 0; i < quantity; i++) {
1410       emit Transfer(address(0), to, updatedIndex);
1411       require(
1412         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1413         "ERC721A: transfer to non ERC721Receiver implementer"
1414       );
1415       updatedIndex++;
1416     }
1417 
1418     currentIndex = updatedIndex;
1419     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1420   }
1421 
1422   /**
1423    * @dev Transfers tokenId from from to to.
1424    *
1425    * Requirements:
1426    *
1427    * - to cannot be the zero address.
1428    * - tokenId token must be owned by from.
1429    *
1430    * Emits a {Transfer} event.
1431    */
1432   function _transfer(
1433     address from,
1434     address to,
1435     uint256 tokenId
1436   ) private {
1437     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1438 
1439     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1440       getApproved(tokenId) == _msgSender() ||
1441       isApprovedForAll(prevOwnership.addr, _msgSender()));
1442 
1443     require(
1444       isApprovedOrOwner,
1445       "ERC721A: transfer caller is not owner nor approved"
1446     );
1447 
1448     require(
1449       prevOwnership.addr == from,
1450       "ERC721A: transfer from incorrect owner"
1451     );
1452     require(to != address(0), "ERC721A: transfer to the zero address");
1453 
1454     _beforeTokenTransfers(from, to, tokenId, 1);
1455 
1456     // Clear approvals from the previous owner
1457     _approve(address(0), tokenId, prevOwnership.addr);
1458 
1459     _addressData[from].balance -= 1;
1460     _addressData[to].balance += 1;
1461     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1462 
1463     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1464     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1465     uint256 nextTokenId = tokenId + 1;
1466     if (_ownerships[nextTokenId].addr == address(0)) {
1467       if (_exists(nextTokenId)) {
1468         _ownerships[nextTokenId] = TokenOwnership(
1469           prevOwnership.addr,
1470           prevOwnership.startTimestamp
1471         );
1472       }
1473     }
1474 
1475     emit Transfer(from, to, tokenId);
1476     _afterTokenTransfers(from, to, tokenId, 1);
1477   }
1478 
1479   /**
1480    * @dev Approve to to operate on tokenId
1481    *
1482    * Emits a {Approval} event.
1483    */
1484   function _approve(
1485     address to,
1486     uint256 tokenId,
1487     address owner
1488   ) private {
1489     _tokenApprovals[tokenId] = to;
1490     emit Approval(owner, to, tokenId);
1491   }
1492 
1493   uint256 public nextOwnerToExplicitlySet = 0;
1494 
1495   /**
1496    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1497    */
1498   function _setOwnersExplicit(uint256 quantity) internal {
1499     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1500     require(quantity > 0, "quantity must be nonzero");
1501     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1502 
1503     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1504     if (endIndex > collectionSize - 1) {
1505       endIndex = collectionSize - 1;
1506     }
1507     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1508     require(_exists(endIndex), "not enough minted yet for this cleanup");
1509     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1510       if (_ownerships[i].addr == address(0)) {
1511         TokenOwnership memory ownership = ownershipOf(i);
1512         _ownerships[i] = TokenOwnership(
1513           ownership.addr,
1514           ownership.startTimestamp
1515         );
1516       }
1517     }
1518     nextOwnerToExplicitlySet = endIndex + 1;
1519   }
1520 
1521   /**
1522    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1523    * The call is not executed if the target address is not a contract.
1524    *
1525    * @param from address representing the previous owner of the given token ID
1526    * @param to target address that will receive the tokens
1527    * @param tokenId uint256 ID of the token to be transferred
1528    * @param _data bytes optional data to send along with the call
1529    * @return bool whether the call correctly returned the expected magic value
1530    */
1531   function _checkOnERC721Received(
1532     address from,
1533     address to,
1534     uint256 tokenId,
1535     bytes memory _data
1536   ) private returns (bool) {
1537     if (to.isContract()) {
1538       try
1539         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1540       returns (bytes4 retval) {
1541         return retval == IERC721Receiver(to).onERC721Received.selector;
1542       } catch (bytes memory reason) {
1543         if (reason.length == 0) {
1544           revert("ERC721A: transfer to non ERC721Receiver implementer");
1545         } else {
1546           assembly {
1547             revert(add(32, reason), mload(reason))
1548           }
1549         }
1550       }
1551     } else {
1552       return true;
1553     }
1554   }
1555 
1556   /**
1557    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1558    *
1559    * startTokenId - the first token id to be transferred
1560    * quantity - the amount to be transferred
1561    *
1562    * Calling conditions:
1563    *
1564    * - When from and to are both non-zero, from's tokenId will be
1565    * transferred to to.
1566    * - When from is zero, tokenId will be minted for to.
1567    */
1568   function _beforeTokenTransfers(
1569     address from,
1570     address to,
1571     uint256 startTokenId,
1572     uint256 quantity
1573   ) internal virtual {}
1574 
1575   /**
1576    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1577    * minting.
1578    *
1579    * startTokenId - the first token id to be transferred
1580    * quantity - the amount to be transferred
1581    *
1582    * Calling conditions:
1583    *
1584    * - when from and to are both non-zero.
1585    * - from and to are never both zero.
1586    */
1587   function _afterTokenTransfers(
1588     address from,
1589     address to,
1590     uint256 startTokenId,
1591     uint256 quantity
1592   ) internal virtual {}
1593 }
1594 
1595 
1596 
1597   
1598   
1599 interface IERC20 {
1600   function allowance(address owner, address spender) external view returns (uint256);
1601   function transfer(address _to, uint256 _amount) external returns (bool);
1602   function balanceOf(address account) external view returns (uint256);
1603   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1604 }
1605 
1606 // File: WithdrawableV2
1607 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1608 // ERC-20 Payouts are limited to a single payout address. This feature 
1609 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1610 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1611 abstract contract WithdrawableV2 is Teams {
1612   struct acceptedERC20 {
1613     bool isActive;
1614     uint256 chargeAmount;
1615   }
1616 
1617   
1618   mapping(address => acceptedERC20) private allowedTokenContracts;
1619   address[] public payableAddresses = [0xed76edCDca0f5D6bB19Cb4BCA314D6B4013c8CB6];
1620   address public erc20Payable = 0xed76edCDca0f5D6bB19Cb4BCA314D6B4013c8CB6;
1621   uint256[] public payableFees = [100];
1622   uint256 public payableAddressCount = 1;
1623   bool public onlyERC20MintingMode;
1624   
1625 
1626   function withdrawAll() public onlyTeamOrOwner {
1627       if(address(this).balance == 0) revert ValueCannotBeZero();
1628       _withdrawAll(address(this).balance);
1629   }
1630 
1631   function _withdrawAll(uint256 balance) private {
1632       for(uint i=0; i < payableAddressCount; i++ ) {
1633           _widthdraw(
1634               payableAddresses[i],
1635               (balance * payableFees[i]) / 100
1636           );
1637       }
1638   }
1639   
1640   function _widthdraw(address _address, uint256 _amount) private {
1641       (bool success, ) = _address.call{value: _amount}("");
1642       require(success, "Transfer failed.");
1643   }
1644 
1645   /**
1646   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1647   * in the event ERC-20 tokens are paid to the contract for mints.
1648   * @param _tokenContract contract of ERC-20 token to withdraw
1649   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1650   */
1651   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1652     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1653     IERC20 tokenContract = IERC20(_tokenContract);
1654     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1655     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1656   }
1657 
1658   /**
1659   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1660   * @param _erc20TokenContract address of ERC-20 contract in question
1661   */
1662   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1663     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1664   }
1665 
1666   /**
1667   * @dev get the value of tokens to transfer for user of an ERC-20
1668   * @param _erc20TokenContract address of ERC-20 contract in question
1669   */
1670   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1671     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1672     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1673   }
1674 
1675   /**
1676   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1677   * @param _erc20TokenContract address of ERC-20 contract in question
1678   * @param _isActive default status of if contract should be allowed to accept payments
1679   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1680   */
1681   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1682     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1683     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1684   }
1685 
1686   /**
1687   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1688   * it will assume the default value of zero. This should not be used to create new payment tokens.
1689   * @param _erc20TokenContract address of ERC-20 contract in question
1690   */
1691   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1692     allowedTokenContracts[_erc20TokenContract].isActive = true;
1693   }
1694 
1695   /**
1696   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1697   * it will assume the default value of zero. This should not be used to create new payment tokens.
1698   * @param _erc20TokenContract address of ERC-20 contract in question
1699   */
1700   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1701     allowedTokenContracts[_erc20TokenContract].isActive = false;
1702   }
1703 
1704   /**
1705   * @dev Enable only ERC-20 payments for minting on this contract
1706   */
1707   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1708     onlyERC20MintingMode = true;
1709   }
1710 
1711   /**
1712   * @dev Disable only ERC-20 payments for minting on this contract
1713   */
1714   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1715     onlyERC20MintingMode = false;
1716   }
1717 
1718   /**
1719   * @dev Set the payout of the ERC-20 token payout to a specific address
1720   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1721   */
1722   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1723     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1724     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1725     erc20Payable = _newErc20Payable;
1726   }
1727 }
1728 
1729 
1730   
1731   
1732 /* File: Tippable.sol
1733 /* @dev Allows owner to set strict enforcement of payment to mint price.
1734 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1735 /* when doing a free mint with opt-in pricing.
1736 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1737 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1738 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1739 /* Pros - can take in gratituity payments during a mint. 
1740 /* Cons - However if you decrease pricing during mint txn settlement 
1741 /* it can result in mints landing who technically now have overpaid.
1742 */
1743 abstract contract Tippable is Teams {
1744   bool public strictPricing = true;
1745 
1746   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1747     strictPricing = _newStatus;
1748   }
1749 
1750   // @dev check if msg.value is correct according to pricing enforcement
1751   // @param _msgValue -> passed in msg.value of tx
1752   // @param _expectedPrice -> result of getPrice(...args)
1753   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1754     return strictPricing ? 
1755       _msgValue == _expectedPrice : 
1756       _msgValue >= _expectedPrice;
1757   }
1758 }
1759 
1760   
1761   
1762 // File: EarlyMintIncentive.sol
1763 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1764 // zero fee that can be calculated on the fly.
1765 abstract contract EarlyMintIncentive is Teams, ERC721A {
1766   uint256 public PRICE = 0.005 ether;
1767   uint256 public EARLY_MINT_PRICE = 0 ether;
1768   uint256 public earlyMintOwnershipCap = 1;
1769   bool public usingEarlyMintIncentive = true;
1770 
1771   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1772     usingEarlyMintIncentive = true;
1773   }
1774 
1775   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1776     usingEarlyMintIncentive = false;
1777   }
1778 
1779   /**
1780   * @dev Set the max token ID in which the cost incentive will be applied.
1781   * @param _newCap max number of tokens wallet may mint for incentive price
1782   */
1783   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1784     if(_newCap == 0) revert ValueCannotBeZero();
1785     earlyMintOwnershipCap = _newCap;
1786   }
1787 
1788   /**
1789   * @dev Set the incentive mint price
1790   * @param _feeInWei new price per token when in incentive range
1791   */
1792   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1793     EARLY_MINT_PRICE = _feeInWei;
1794   }
1795 
1796   /**
1797   * @dev Set the primary mint price - the base price when not under incentive
1798   * @param _feeInWei new price per token
1799   */
1800   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1801     PRICE = _feeInWei;
1802   }
1803 
1804   /**
1805   * @dev Get the correct price for the mint for qty and person minting
1806   * @param _count amount of tokens to calc for mint
1807   * @param _to the address which will be minting these tokens, passed explicitly
1808   */
1809   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1810     if(_count == 0) revert ValueCannotBeZero();
1811 
1812     // short circuit function if we dont need to even calc incentive pricing
1813     // short circuit if the current wallet mint qty is also already over cap
1814     if(
1815       usingEarlyMintIncentive == false ||
1816       _numberMinted(_to) > earlyMintOwnershipCap
1817     ) {
1818       return PRICE * _count;
1819     }
1820 
1821     uint256 endingTokenQty = _numberMinted(_to) + _count;
1822     // If qty to mint results in a final qty less than or equal to the cap then
1823     // the entire qty is within incentive mint.
1824     if(endingTokenQty  <= earlyMintOwnershipCap) {
1825       return EARLY_MINT_PRICE * _count;
1826     }
1827 
1828     // If the current token qty is less than the incentive cap
1829     // and the ending token qty is greater than the incentive cap
1830     // we will be straddling the cap so there will be some amount
1831     // that are incentive and some that are regular fee.
1832     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1833     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1834 
1835     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1836   }
1837 }
1838 
1839   
1840 abstract contract ERC721APlus is 
1841     Ownable,
1842     Teams,
1843     ERC721A,
1844     WithdrawableV2,
1845     ReentrancyGuard 
1846     , EarlyMintIncentive, Tippable 
1847      
1848     
1849 {
1850   constructor(
1851     string memory tokenName,
1852     string memory tokenSymbol
1853   ) ERC721A(tokenName, tokenSymbol, 8, 4300) { }
1854     uint8 constant public CONTRACT_VERSION = 2;
1855     string public _baseTokenURI = "ipfs://bafybeiguq5u25enfomdwxtuefrod2tmsnopegtq6lio3lmnkjo5zj35ya4/";
1856     string public _baseTokenExtension = ".json";
1857 
1858     bool public mintingOpen = false;
1859     
1860     
1861     uint256 public MAX_WALLET_MINTS = 8;
1862 
1863   
1864     /////////////// Admin Mint Functions
1865     /**
1866      * @dev Mints a token to an address with a tokenURI.
1867      * This is owner only and allows a fee-free drop
1868      * @param _to address of the future owner of the token
1869      * @param _qty amount of tokens to drop the owner
1870      */
1871      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1872          if(_qty == 0) revert MintZeroQuantity();
1873          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1874          _safeMint(_to, _qty, true);
1875      }
1876 
1877   
1878     /////////////// PUBLIC MINT FUNCTIONS
1879     /**
1880     * @dev Mints tokens to an address in batch.
1881     * fee may or may not be required*
1882     * @param _to address of the future owner of the token
1883     * @param _amount number of tokens to mint
1884     */
1885     function mintToMultiple(address _to, uint256 _amount) public payable {
1886         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1887         if(_amount == 0) revert MintZeroQuantity();
1888         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1889         if(!mintingOpen) revert PublicMintClosed();
1890         
1891         
1892         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1893         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1894         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
1895 
1896         _safeMint(_to, _amount, false);
1897     }
1898 
1899     /**
1900      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1901      * fee may or may not be required*
1902      * @param _to address of the future owner of the token
1903      * @param _amount number of tokens to mint
1904      * @param _erc20TokenContract erc-20 token contract to mint with
1905      */
1906     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1907       if(_amount == 0) revert MintZeroQuantity();
1908       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1909       if(!mintingOpen) revert PublicMintClosed();
1910       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1911       
1912       
1913       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1914 
1915       // ERC-20 Specific pre-flight checks
1916       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1917       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1918       IERC20 payableToken = IERC20(_erc20TokenContract);
1919 
1920       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1921       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1922 
1923       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1924       if(!transferComplete) revert ERC20TransferFailed();
1925       
1926       _safeMint(_to, _amount, false);
1927     }
1928 
1929     function openMinting() public onlyTeamOrOwner {
1930         mintingOpen = true;
1931     }
1932 
1933     function stopMinting() public onlyTeamOrOwner {
1934         mintingOpen = false;
1935     }
1936 
1937   
1938 
1939   
1940     /**
1941     * @dev Check if wallet over MAX_WALLET_MINTS
1942     * @param _address address in question to check if minted count exceeds max
1943     */
1944     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1945         if(_amount == 0) revert ValueCannotBeZero();
1946         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1947     }
1948 
1949     /**
1950     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1951     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1952     */
1953     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1954         if(_newWalletMax == 0) revert ValueCannotBeZero();
1955         MAX_WALLET_MINTS = _newWalletMax;
1956     }
1957     
1958 
1959   
1960     /**
1961      * @dev Allows owner to set Max mints per tx
1962      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1963      */
1964      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1965          if(_newMaxMint == 0) revert ValueCannotBeZero();
1966          maxBatchSize = _newMaxMint;
1967      }
1968     
1969 
1970   
1971   
1972   
1973   function contractURI() public pure returns (string memory) {
1974     return "https://metadata.mintplex.xyz/USFdxVtebYHQwqFC0bG2/contract-metadata";
1975   }
1976   
1977 
1978   function _baseURI() internal view virtual override returns(string memory) {
1979     return _baseTokenURI;
1980   }
1981 
1982   function _baseURIExtension() internal view virtual override returns(string memory) {
1983     return _baseTokenExtension;
1984   }
1985 
1986   function baseTokenURI() public view returns(string memory) {
1987     return _baseTokenURI;
1988   }
1989 
1990   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1991     _baseTokenURI = baseURI;
1992   }
1993 
1994   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
1995     _baseTokenExtension = baseExtension;
1996   }
1997 }
1998 
1999 
2000   
2001 // File: contracts/RunrunrunContract.sol
2002 //SPDX-License-Identifier: MIT
2003 
2004 pragma solidity ^0.8.0;
2005 
2006 contract RunrunrunContract is ERC721APlus {
2007     constructor() ERC721APlus("RUNRUNRUN", "RUN"){}
2008 }
2009   