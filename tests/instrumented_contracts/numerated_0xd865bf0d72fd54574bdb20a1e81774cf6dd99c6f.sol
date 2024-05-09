1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 // ▄▀█ █▀█ █▀▀ █░█ █▀▀ █▀█ █▀ █▀▀   █▀▀ █▀▀ █▄░█ █▀▀ █▀ █ █▀
6 // █▀█ █▀▀ ██▄ ▀▄▀ ██▄ █▀▄ ▄█ ██▄   █▄█ ██▄ █░▀█ ██▄ ▄█ █ ▄█
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
783 * This will easily allow cross-collaboration via Rampp.xyz.
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
852   IERC721Enumerable
853 {
854   using Address for address;
855   using Strings for uint256;
856 
857   struct TokenOwnership {
858     address addr;
859     uint64 startTimestamp;
860   }
861 
862   struct AddressData {
863     uint128 balance;
864     uint128 numberMinted;
865   }
866 
867   uint256 private currentIndex;
868 
869   uint256 public immutable collectionSize;
870   uint256 public maxBatchSize;
871 
872   // Token name
873   string private _name;
874 
875   // Token symbol
876   string private _symbol;
877 
878   // Mapping from token ID to ownership details
879   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
880   mapping(uint256 => TokenOwnership) private _ownerships;
881 
882   // Mapping owner address to address data
883   mapping(address => AddressData) private _addressData;
884 
885   // Mapping from token ID to approved address
886   mapping(uint256 => address) private _tokenApprovals;
887 
888   // Mapping from owner to operator approvals
889   mapping(address => mapping(address => bool)) private _operatorApprovals;
890 
891   /**
892    * @dev
893    * maxBatchSize refers to how much a minter can mint at a time.
894    * collectionSize_ refers to how many tokens are in the collection.
895    */
896   constructor(
897     string memory name_,
898     string memory symbol_,
899     uint256 maxBatchSize_,
900     uint256 collectionSize_
901   ) {
902     require(
903       collectionSize_ > 0,
904       "ERC721A: collection must have a nonzero supply"
905     );
906     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
907     _name = name_;
908     _symbol = symbol_;
909     maxBatchSize = maxBatchSize_;
910     collectionSize = collectionSize_;
911     currentIndex = _startTokenId();
912   }
913 
914   /**
915   * To change the starting tokenId, please override this function.
916   */
917   function _startTokenId() internal view virtual returns (uint256) {
918     return 1;
919   }
920 
921   /**
922    * @dev See {IERC721Enumerable-totalSupply}.
923    */
924   function totalSupply() public view override returns (uint256) {
925     return _totalMinted();
926   }
927 
928   function currentTokenId() public view returns (uint256) {
929     return _totalMinted();
930   }
931 
932   function getNextTokenId() public view returns (uint256) {
933       return _totalMinted() + 1;
934   }
935 
936   /**
937   * Returns the total amount of tokens minted in the contract.
938   */
939   function _totalMinted() internal view returns (uint256) {
940     unchecked {
941       return currentIndex - _startTokenId();
942     }
943   }
944 
945   /**
946    * @dev See {IERC721Enumerable-tokenByIndex}.
947    */
948   function tokenByIndex(uint256 index) public view override returns (uint256) {
949     require(index < totalSupply(), "ERC721A: global index out of bounds");
950     return index;
951   }
952 
953   /**
954    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
955    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
956    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
957    */
958   function tokenOfOwnerByIndex(address owner, uint256 index)
959     public
960     view
961     override
962     returns (uint256)
963   {
964     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
965     uint256 numMintedSoFar = totalSupply();
966     uint256 tokenIdsIdx = 0;
967     address currOwnershipAddr = address(0);
968     for (uint256 i = 0; i < numMintedSoFar; i++) {
969       TokenOwnership memory ownership = _ownerships[i];
970       if (ownership.addr != address(0)) {
971         currOwnershipAddr = ownership.addr;
972       }
973       if (currOwnershipAddr == owner) {
974         if (tokenIdsIdx == index) {
975           return i;
976         }
977         tokenIdsIdx++;
978       }
979     }
980     revert("ERC721A: unable to get token of owner by index");
981   }
982 
983   /**
984    * @dev See {IERC165-supportsInterface}.
985    */
986   function supportsInterface(bytes4 interfaceId)
987     public
988     view
989     virtual
990     override(ERC165, IERC165)
991     returns (bool)
992   {
993     return
994       interfaceId == type(IERC721).interfaceId ||
995       interfaceId == type(IERC721Metadata).interfaceId ||
996       interfaceId == type(IERC721Enumerable).interfaceId ||
997       super.supportsInterface(interfaceId);
998   }
999 
1000   /**
1001    * @dev See {IERC721-balanceOf}.
1002    */
1003   function balanceOf(address owner) public view override returns (uint256) {
1004     require(owner != address(0), "ERC721A: balance query for the zero address");
1005     return uint256(_addressData[owner].balance);
1006   }
1007 
1008   function _numberMinted(address owner) internal view returns (uint256) {
1009     require(
1010       owner != address(0),
1011       "ERC721A: number minted query for the zero address"
1012     );
1013     return uint256(_addressData[owner].numberMinted);
1014   }
1015 
1016   function ownershipOf(uint256 tokenId)
1017     internal
1018     view
1019     returns (TokenOwnership memory)
1020   {
1021     uint256 curr = tokenId;
1022 
1023     unchecked {
1024         if (_startTokenId() <= curr && curr < currentIndex) {
1025             TokenOwnership memory ownership = _ownerships[curr];
1026             if (ownership.addr != address(0)) {
1027                 return ownership;
1028             }
1029 
1030             // Invariant:
1031             // There will always be an ownership that has an address and is not burned
1032             // before an ownership that does not have an address and is not burned.
1033             // Hence, curr will not underflow.
1034             while (true) {
1035                 curr--;
1036                 ownership = _ownerships[curr];
1037                 if (ownership.addr != address(0)) {
1038                     return ownership;
1039                 }
1040             }
1041         }
1042     }
1043 
1044     revert("ERC721A: unable to determine the owner of token");
1045   }
1046 
1047   /**
1048    * @dev See {IERC721-ownerOf}.
1049    */
1050   function ownerOf(uint256 tokenId) public view override returns (address) {
1051     return ownershipOf(tokenId).addr;
1052   }
1053 
1054   /**
1055    * @dev See {IERC721Metadata-name}.
1056    */
1057   function name() public view virtual override returns (string memory) {
1058     return _name;
1059   }
1060 
1061   /**
1062    * @dev See {IERC721Metadata-symbol}.
1063    */
1064   function symbol() public view virtual override returns (string memory) {
1065     return _symbol;
1066   }
1067 
1068   /**
1069    * @dev See {IERC721Metadata-tokenURI}.
1070    */
1071   function tokenURI(uint256 tokenId)
1072     public
1073     view
1074     virtual
1075     override
1076     returns (string memory)
1077   {
1078     string memory baseURI = _baseURI();
1079     return
1080       bytes(baseURI).length > 0
1081         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1082         : "";
1083   }
1084 
1085   /**
1086    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1087    * token will be the concatenation of the baseURI and the tokenId. Empty
1088    * by default, can be overriden in child contracts.
1089    */
1090   function _baseURI() internal view virtual returns (string memory) {
1091     return "";
1092   }
1093 
1094   /**
1095    * @dev See {IERC721-approve}.
1096    */
1097   function approve(address to, uint256 tokenId) public override {
1098     address owner = ERC721A.ownerOf(tokenId);
1099     require(to != owner, "ERC721A: approval to current owner");
1100 
1101     require(
1102       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1103       "ERC721A: approve caller is not owner nor approved for all"
1104     );
1105 
1106     _approve(to, tokenId, owner);
1107   }
1108 
1109   /**
1110    * @dev See {IERC721-getApproved}.
1111    */
1112   function getApproved(uint256 tokenId) public view override returns (address) {
1113     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1114 
1115     return _tokenApprovals[tokenId];
1116   }
1117 
1118   /**
1119    * @dev See {IERC721-setApprovalForAll}.
1120    */
1121   function setApprovalForAll(address operator, bool approved) public override {
1122     require(operator != _msgSender(), "ERC721A: approve to caller");
1123 
1124     _operatorApprovals[_msgSender()][operator] = approved;
1125     emit ApprovalForAll(_msgSender(), operator, approved);
1126   }
1127 
1128   /**
1129    * @dev See {IERC721-isApprovedForAll}.
1130    */
1131   function isApprovedForAll(address owner, address operator)
1132     public
1133     view
1134     virtual
1135     override
1136     returns (bool)
1137   {
1138     return _operatorApprovals[owner][operator];
1139   }
1140 
1141   /**
1142    * @dev See {IERC721-transferFrom}.
1143    */
1144   function transferFrom(
1145     address from,
1146     address to,
1147     uint256 tokenId
1148   ) public override {
1149     _transfer(from, to, tokenId);
1150   }
1151 
1152   /**
1153    * @dev See {IERC721-safeTransferFrom}.
1154    */
1155   function safeTransferFrom(
1156     address from,
1157     address to,
1158     uint256 tokenId
1159   ) public override {
1160     safeTransferFrom(from, to, tokenId, "");
1161   }
1162 
1163   /**
1164    * @dev See {IERC721-safeTransferFrom}.
1165    */
1166   function safeTransferFrom(
1167     address from,
1168     address to,
1169     uint256 tokenId,
1170     bytes memory _data
1171   ) public override {
1172     _transfer(from, to, tokenId);
1173     require(
1174       _checkOnERC721Received(from, to, tokenId, _data),
1175       "ERC721A: transfer to non ERC721Receiver implementer"
1176     );
1177   }
1178 
1179   /**
1180    * @dev Returns whether tokenId exists.
1181    *
1182    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1183    *
1184    * Tokens start existing when they are minted (_mint),
1185    */
1186   function _exists(uint256 tokenId) internal view returns (bool) {
1187     return _startTokenId() <= tokenId && tokenId < currentIndex;
1188   }
1189 
1190   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1191     _safeMint(to, quantity, isAdminMint, "");
1192   }
1193 
1194   /**
1195    * @dev Mints quantity tokens and transfers them to to.
1196    *
1197    * Requirements:
1198    *
1199    * - there must be quantity tokens remaining unminted in the total collection.
1200    * - to cannot be the zero address.
1201    * - quantity cannot be larger than the max batch size.
1202    *
1203    * Emits a {Transfer} event.
1204    */
1205   function _safeMint(
1206     address to,
1207     uint256 quantity,
1208     bool isAdminMint,
1209     bytes memory _data
1210   ) internal {
1211     uint256 startTokenId = currentIndex;
1212     require(to != address(0), "ERC721A: mint to the zero address");
1213     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1214     require(!_exists(startTokenId), "ERC721A: token already minted");
1215 
1216     // For admin mints we do not want to enforce the maxBatchSize limit
1217     if (isAdminMint == false) {
1218         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1219     }
1220 
1221     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1222 
1223     AddressData memory addressData = _addressData[to];
1224     _addressData[to] = AddressData(
1225       addressData.balance + uint128(quantity),
1226       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1227     );
1228     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1229 
1230     uint256 updatedIndex = startTokenId;
1231 
1232     for (uint256 i = 0; i < quantity; i++) {
1233       emit Transfer(address(0), to, updatedIndex);
1234       require(
1235         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1236         "ERC721A: transfer to non ERC721Receiver implementer"
1237       );
1238       updatedIndex++;
1239     }
1240 
1241     currentIndex = updatedIndex;
1242     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1243   }
1244 
1245   /**
1246    * @dev Transfers tokenId from from to to.
1247    *
1248    * Requirements:
1249    *
1250    * - to cannot be the zero address.
1251    * - tokenId token must be owned by from.
1252    *
1253    * Emits a {Transfer} event.
1254    */
1255   function _transfer(
1256     address from,
1257     address to,
1258     uint256 tokenId
1259   ) private {
1260     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1261 
1262     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1263       getApproved(tokenId) == _msgSender() ||
1264       isApprovedForAll(prevOwnership.addr, _msgSender()));
1265 
1266     require(
1267       isApprovedOrOwner,
1268       "ERC721A: transfer caller is not owner nor approved"
1269     );
1270 
1271     require(
1272       prevOwnership.addr == from,
1273       "ERC721A: transfer from incorrect owner"
1274     );
1275     require(to != address(0), "ERC721A: transfer to the zero address");
1276 
1277     _beforeTokenTransfers(from, to, tokenId, 1);
1278 
1279     // Clear approvals from the previous owner
1280     _approve(address(0), tokenId, prevOwnership.addr);
1281 
1282     _addressData[from].balance -= 1;
1283     _addressData[to].balance += 1;
1284     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1285 
1286     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1287     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1288     uint256 nextTokenId = tokenId + 1;
1289     if (_ownerships[nextTokenId].addr == address(0)) {
1290       if (_exists(nextTokenId)) {
1291         _ownerships[nextTokenId] = TokenOwnership(
1292           prevOwnership.addr,
1293           prevOwnership.startTimestamp
1294         );
1295       }
1296     }
1297 
1298     emit Transfer(from, to, tokenId);
1299     _afterTokenTransfers(from, to, tokenId, 1);
1300   }
1301 
1302   /**
1303    * @dev Approve to to operate on tokenId
1304    *
1305    * Emits a {Approval} event.
1306    */
1307   function _approve(
1308     address to,
1309     uint256 tokenId,
1310     address owner
1311   ) private {
1312     _tokenApprovals[tokenId] = to;
1313     emit Approval(owner, to, tokenId);
1314   }
1315 
1316   uint256 public nextOwnerToExplicitlySet = 0;
1317 
1318   /**
1319    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1320    */
1321   function _setOwnersExplicit(uint256 quantity) internal {
1322     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1323     require(quantity > 0, "quantity must be nonzero");
1324     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1325 
1326     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1327     if (endIndex > collectionSize - 1) {
1328       endIndex = collectionSize - 1;
1329     }
1330     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1331     require(_exists(endIndex), "not enough minted yet for this cleanup");
1332     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1333       if (_ownerships[i].addr == address(0)) {
1334         TokenOwnership memory ownership = ownershipOf(i);
1335         _ownerships[i] = TokenOwnership(
1336           ownership.addr,
1337           ownership.startTimestamp
1338         );
1339       }
1340     }
1341     nextOwnerToExplicitlySet = endIndex + 1;
1342   }
1343 
1344   /**
1345    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1346    * The call is not executed if the target address is not a contract.
1347    *
1348    * @param from address representing the previous owner of the given token ID
1349    * @param to target address that will receive the tokens
1350    * @param tokenId uint256 ID of the token to be transferred
1351    * @param _data bytes optional data to send along with the call
1352    * @return bool whether the call correctly returned the expected magic value
1353    */
1354   function _checkOnERC721Received(
1355     address from,
1356     address to,
1357     uint256 tokenId,
1358     bytes memory _data
1359   ) private returns (bool) {
1360     if (to.isContract()) {
1361       try
1362         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1363       returns (bytes4 retval) {
1364         return retval == IERC721Receiver(to).onERC721Received.selector;
1365       } catch (bytes memory reason) {
1366         if (reason.length == 0) {
1367           revert("ERC721A: transfer to non ERC721Receiver implementer");
1368         } else {
1369           assembly {
1370             revert(add(32, reason), mload(reason))
1371           }
1372         }
1373       }
1374     } else {
1375       return true;
1376     }
1377   }
1378 
1379   /**
1380    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1381    *
1382    * startTokenId - the first token id to be transferred
1383    * quantity - the amount to be transferred
1384    *
1385    * Calling conditions:
1386    *
1387    * - When from and to are both non-zero, from's tokenId will be
1388    * transferred to to.
1389    * - When from is zero, tokenId will be minted for to.
1390    */
1391   function _beforeTokenTransfers(
1392     address from,
1393     address to,
1394     uint256 startTokenId,
1395     uint256 quantity
1396   ) internal virtual {}
1397 
1398   /**
1399    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1400    * minting.
1401    *
1402    * startTokenId - the first token id to be transferred
1403    * quantity - the amount to be transferred
1404    *
1405    * Calling conditions:
1406    *
1407    * - when from and to are both non-zero.
1408    * - from and to are never both zero.
1409    */
1410   function _afterTokenTransfers(
1411     address from,
1412     address to,
1413     uint256 startTokenId,
1414     uint256 quantity
1415   ) internal virtual {}
1416 }
1417 
1418 
1419 
1420   
1421 abstract contract Ramppable {
1422   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1423 
1424   modifier isRampp() {
1425       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1426       _;
1427   }
1428 }
1429 
1430 
1431   
1432   
1433 interface IERC20 {
1434   function allowance(address owner, address spender) external view returns (uint256);
1435   function transfer(address _to, uint256 _amount) external returns (bool);
1436   function balanceOf(address account) external view returns (uint256);
1437   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1438 }
1439 
1440 // File: WithdrawableV2
1441 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1442 // ERC-20 Payouts are limited to a single payout address. This feature 
1443 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1444 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1445 abstract contract WithdrawableV2 is Teams, Ramppable {
1446   struct acceptedERC20 {
1447     bool isActive;
1448     uint256 chargeAmount;
1449   }
1450 
1451   
1452   mapping(address => acceptedERC20) private allowedTokenContracts;
1453   address[] public payableAddresses = [RAMPPADDRESS,0xe4665D8b8ecd97D61a7EF40c05eB41B4D4eACC52];
1454   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1455   address public erc20Payable = 0xe4665D8b8ecd97D61a7EF40c05eB41B4D4eACC52;
1456   uint256[] public payableFees = [5,95];
1457   uint256[] public surchargePayableFees = [100];
1458   uint256 public payableAddressCount = 2;
1459   uint256 public surchargePayableAddressCount = 1;
1460   uint256 public ramppSurchargeBalance = 0 ether;
1461   uint256 public ramppSurchargeFee = 0.001 ether;
1462   bool public onlyERC20MintingMode = false;
1463   
1464 
1465   /**
1466   * @dev Calculates the true payable balance of the contract as the
1467   * value on contract may be from ERC-20 mint surcharges and not 
1468   * public mint charges - which are not eligable for rev share & user withdrawl
1469   */
1470   function calcAvailableBalance() public view returns(uint256) {
1471     return address(this).balance - ramppSurchargeBalance;
1472   }
1473 
1474   function withdrawAll() public onlyTeamOrOwner {
1475       require(calcAvailableBalance() > 0);
1476       _withdrawAll();
1477   }
1478   
1479   function withdrawAllRampp() public isRampp {
1480       require(calcAvailableBalance() > 0);
1481       _withdrawAll();
1482   }
1483 
1484   function _withdrawAll() private {
1485       uint256 balance = calcAvailableBalance();
1486       
1487       for(uint i=0; i < payableAddressCount; i++ ) {
1488           _widthdraw(
1489               payableAddresses[i],
1490               (balance * payableFees[i]) / 100
1491           );
1492       }
1493   }
1494   
1495   function _widthdraw(address _address, uint256 _amount) private {
1496       (bool success, ) = _address.call{value: _amount}("");
1497       require(success, "Transfer failed.");
1498   }
1499 
1500   /**
1501   * @dev This function is similiar to the regular withdraw but operates only on the
1502   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1503   **/
1504   function _withdrawAllSurcharges() private {
1505     uint256 balance = ramppSurchargeBalance;
1506     if(balance == 0) { return; }
1507     
1508     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1509         _widthdraw(
1510             surchargePayableAddresses[i],
1511             (balance * surchargePayableFees[i]) / 100
1512         );
1513     }
1514     ramppSurchargeBalance = 0 ether;
1515   }
1516 
1517   /**
1518   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1519   * in the event ERC-20 tokens are paid to the contract for mints. This will
1520   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1521   * @param _tokenContract contract of ERC-20 token to withdraw
1522   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1523   */
1524   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1525     require(_amountToWithdraw > 0);
1526     IERC20 tokenContract = IERC20(_tokenContract);
1527     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1528     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1529     _withdrawAllSurcharges();
1530   }
1531 
1532   /**
1533   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1534   */
1535   function withdrawRamppSurcharges() public isRampp {
1536     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1537     _withdrawAllSurcharges();
1538   }
1539 
1540    /**
1541   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1542   */
1543   function addSurcharge() internal {
1544     ramppSurchargeBalance += ramppSurchargeFee;
1545   }
1546   
1547   /**
1548   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1549   */
1550   function hasSurcharge() internal returns(bool) {
1551     return msg.value == ramppSurchargeFee;
1552   }
1553 
1554   /**
1555   * @dev Set surcharge fee for using ERC-20 payments on contract
1556   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1557   */
1558   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1559     ramppSurchargeFee = _newSurcharge;
1560   }
1561 
1562   /**
1563   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1564   * @param _erc20TokenContract address of ERC-20 contract in question
1565   */
1566   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1567     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1568   }
1569 
1570   /**
1571   * @dev get the value of tokens to transfer for user of an ERC-20
1572   * @param _erc20TokenContract address of ERC-20 contract in question
1573   */
1574   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1575     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1576     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1577   }
1578 
1579   /**
1580   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1581   * @param _erc20TokenContract address of ERC-20 contract in question
1582   * @param _isActive default status of if contract should be allowed to accept payments
1583   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1584   */
1585   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1586     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1587     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1588   }
1589 
1590   /**
1591   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1592   * it will assume the default value of zero. This should not be used to create new payment tokens.
1593   * @param _erc20TokenContract address of ERC-20 contract in question
1594   */
1595   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1596     allowedTokenContracts[_erc20TokenContract].isActive = true;
1597   }
1598 
1599   /**
1600   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1601   * it will assume the default value of zero. This should not be used to create new payment tokens.
1602   * @param _erc20TokenContract address of ERC-20 contract in question
1603   */
1604   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1605     allowedTokenContracts[_erc20TokenContract].isActive = false;
1606   }
1607 
1608   /**
1609   * @dev Enable only ERC-20 payments for minting on this contract
1610   */
1611   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1612     onlyERC20MintingMode = true;
1613   }
1614 
1615   /**
1616   * @dev Disable only ERC-20 payments for minting on this contract
1617   */
1618   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1619     onlyERC20MintingMode = false;
1620   }
1621 
1622   /**
1623   * @dev Set the payout of the ERC-20 token payout to a specific address
1624   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1625   */
1626   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1627     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1628     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1629     erc20Payable = _newErc20Payable;
1630   }
1631 
1632   /**
1633   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1634   */
1635   function resetRamppSurchargeBalance() public isRampp {
1636     ramppSurchargeBalance = 0 ether;
1637   }
1638 
1639   /**
1640   * @dev Allows Rampp wallet to update its own reference as well as update
1641   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1642   * and since Rampp is always the first address this function is limited to the rampp payout only.
1643   * @param _newAddress updated Rampp Address
1644   */
1645   function setRamppAddress(address _newAddress) public isRampp {
1646     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1647     RAMPPADDRESS = _newAddress;
1648     payableAddresses[0] = _newAddress;
1649   }
1650 }
1651 
1652 
1653   
1654   
1655   
1656   
1657 abstract contract RamppERC721A is 
1658     Ownable,
1659     Teams,
1660     ERC721A,
1661     WithdrawableV2,
1662     ReentrancyGuard 
1663      
1664      
1665     
1666 {
1667   constructor(
1668     string memory tokenName,
1669     string memory tokenSymbol
1670   ) ERC721A(tokenName, tokenSymbol, 2, 3000) { }
1671     uint8 public CONTRACT_VERSION = 2;
1672     string public _baseTokenURI = "ipfs://bafybeigcvhwy6f625h4gtxaqh5aplaz57dpriopg7ecbebk3bawwapf62i/";
1673 
1674     bool public mintingOpen = false;
1675     
1676     
1677     uint256 public MAX_WALLET_MINTS = 2;
1678 
1679   
1680     /////////////// Admin Mint Functions
1681     /**
1682      * @dev Mints a token to an address with a tokenURI.
1683      * This is owner only and allows a fee-free drop
1684      * @param _to address of the future owner of the token
1685      * @param _qty amount of tokens to drop the owner
1686      */
1687      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1688          require(_qty > 0, "Must mint at least 1 token.");
1689          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 3000");
1690          _safeMint(_to, _qty, true);
1691      }
1692 
1693   
1694     /////////////// GENERIC MINT FUNCTIONS
1695     /**
1696     * @dev Mints a single token to an address.
1697     * fee may or may not be required*
1698     * @param _to address of the future owner of the token
1699     */
1700     function mintTo(address _to) public payable {
1701         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1702         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3000");
1703         require(mintingOpen == true, "Minting is not open right now!");
1704         
1705         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1706         
1707         
1708         _safeMint(_to, 1, false);
1709     }
1710 
1711     /**
1712     * @dev Mints tokens to an address in batch.
1713     * fee may or may not be required*
1714     * @param _to address of the future owner of the token
1715     * @param _amount number of tokens to mint
1716     */
1717     function mintToMultiple(address _to, uint256 _amount) public payable {
1718         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1719         require(_amount >= 1, "Must mint at least 1 token");
1720         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1721         require(mintingOpen == true, "Minting is not open right now!");
1722         
1723         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1724         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 3000");
1725         
1726 
1727         _safeMint(_to, _amount, false);
1728     }
1729 
1730     /**
1731      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1732      * fee may or may not be required*
1733      * @param _to address of the future owner of the token
1734      * @param _amount number of tokens to mint
1735      * @param _erc20TokenContract erc-20 token contract to mint with
1736      */
1737     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1738       require(_amount >= 1, "Must mint at least 1 token");
1739       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1740       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 3000");
1741       require(mintingOpen == true, "Minting is not open right now!");
1742       
1743       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1744 
1745       // ERC-20 Specific pre-flight checks
1746       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1747       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1748       IERC20 payableToken = IERC20(_erc20TokenContract);
1749 
1750       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1751       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1752       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1753       
1754       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1755       require(transferComplete, "ERC-20 token was unable to be transferred");
1756       
1757       _safeMint(_to, _amount, false);
1758       addSurcharge();
1759     }
1760 
1761     function openMinting() public onlyTeamOrOwner {
1762         mintingOpen = true;
1763     }
1764 
1765     function stopMinting() public onlyTeamOrOwner {
1766         mintingOpen = false;
1767     }
1768 
1769   
1770 
1771   
1772     /**
1773     * @dev Check if wallet over MAX_WALLET_MINTS
1774     * @param _address address in question to check if minted count exceeds max
1775     */
1776     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1777         require(_amount >= 1, "Amount must be greater than or equal to 1");
1778         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1779     }
1780 
1781     /**
1782     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1783     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1784     */
1785     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1786         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1787         MAX_WALLET_MINTS = _newWalletMax;
1788     }
1789     
1790 
1791   
1792     /**
1793      * @dev Allows owner to set Max mints per tx
1794      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1795      */
1796      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1797          require(_newMaxMint >= 1, "Max mint must be at least 1");
1798          maxBatchSize = _newMaxMint;
1799      }
1800     
1801 
1802   
1803 
1804   function _baseURI() internal view virtual override returns(string memory) {
1805     return _baseTokenURI;
1806   }
1807 
1808   function baseTokenURI() public view returns(string memory) {
1809     return _baseTokenURI;
1810   }
1811 
1812   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1813     _baseTokenURI = baseURI;
1814   }
1815 
1816   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1817     return ownershipOf(tokenId);
1818   }
1819 }
1820 
1821 
1822   
1823 // File: contracts/ApeVerseGenesisContract.sol
1824 //SPDX-License-Identifier: MIT
1825 
1826 pragma solidity ^0.8.0;
1827 
1828 contract ApeVerseGenesisContract is RamppERC721A {
1829     constructor() RamppERC721A("ApeVerse Genesis", "APEVERSE"){}
1830 }
1831   
1832 //*********************************************************************//
1833 //*********************************************************************//  
1834 //                       Rampp v2.1.0
1835 //
1836 //         This smart contract was generated by rampp.xyz.
1837 //            Rampp allows creators like you to launch 
1838 //             large scale NFT communities without code!
1839 //
1840 //    Rampp is not responsible for the content of this contract and
1841 //        hopes it is being used in a responsible and kind way.  
1842 //       Rampp is not associated or affiliated with this project.                                                    
1843 //             Twitter: @Rampp_ ---- rampp.xyz
1844 //*********************************************************************//                                                     
1845 //*********************************************************************// 
