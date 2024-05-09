1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-06
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-02
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-31
11 */
12 
13 //-------------DEPENDENCIES--------------------------//
14 
15 // File: @openzeppelin/contracts/utils/Address.sol
16 
17 
18 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
19 
20 pragma solidity ^0.8.1;
21 
22 /**
23  * @dev Collection of functions related to the address type
24  */
25 library Address {
26     /**
27      * @dev Returns true if account is a contract.
28      *
29      * [IMPORTANT]
30      * ====
31      * It is unsafe to assume that an address for which this function returns
32      * false is an externally-owned account (EOA) and not a contract.
33      *
34      * Among others, isContract will return false for the following
35      * types of addresses:
36      *
37      *  - an externally-owned account
38      *  - a contract in construction
39      *  - an address where a contract will be created
40      *  - an address where a contract lived, but was destroyed
41      * ====
42      *
43      * [IMPORTANT]
44      * ====
45      * You shouldn't rely on isContract to protect against flash loan attacks!
46      *
47      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
48      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
49      * constructor.
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize/address.code.length, which returns 0
54         // for contracts in construction, since the code is only stored at the end
55         // of the constructor execution.
56 
57         return account.code.length > 0;
58     }
59 
60     /**
61      * @dev Replacement for Solidity's transfer: sends amount wei to
62      * recipient, forwarding all available gas and reverting on errors.
63      *
64      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
65      * of certain opcodes, possibly making contracts go over the 2300 gas limit
66      * imposed by transfer, making them unable to receive funds via
67      * transfer. {sendValue} removes this limitation.
68      *
69      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
70      *
71      * IMPORTANT: because control is transferred to recipient, care must be
72      * taken to not create reentrancy vulnerabilities. Consider using
73      * {ReentrancyGuard} or the
74      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
75      */
76     function sendValue(address payable recipient, uint256 amount) internal {
77         require(address(this).balance >= amount, "Address: insufficient balance");
78 
79         (bool success, ) = recipient.call{value: amount}("");
80         require(success, "Address: unable to send value, recipient may have reverted");
81     }
82 
83     /**
84      * @dev Performs a Solidity function call using a low level call. A
85      * plain call is an unsafe replacement for a function call: use this
86      * function instead.
87      *
88      * If target reverts with a revert reason, it is bubbled up by this
89      * function (like regular Solidity function calls).
90      *
91      * Returns the raw returned data. To convert to the expected return value,
92      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
93      *
94      * Requirements:
95      *
96      * - target must be a contract.
97      * - calling target with data must not revert.
98      *
99      * _Available since v3.1._
100      */
101     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
102         return functionCall(target, data, "Address: low-level call failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
107      * errorMessage as a fallback revert reason when target reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCall(
112         address target,
113         bytes memory data,
114         string memory errorMessage
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
121      * but also transferring value wei to target.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least value.
126      * - the called Solidity function must be payable.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value
134     ) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
140      * with errorMessage as a fallback revert reason when target reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(
145         address target,
146         bytes memory data,
147         uint256 value,
148         string memory errorMessage
149     ) internal returns (bytes memory) {
150         require(address(this).balance >= value, "Address: insufficient balance for call");
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(data);
154         return verifyCallResult(success, returndata, errorMessage);
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
159      * but performing a static call.
160      *
161      * _Available since v3.3._
162      */
163     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
164         return functionStaticCall(target, data, "Address: low-level static call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
169      * but performing a static call.
170      *
171      * _Available since v3.3._
172      */
173     function functionStaticCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal view returns (bytes memory) {
178         require(isContract(target), "Address: static call to non-contract");
179 
180         (bool success, bytes memory returndata) = target.staticcall(data);
181         return verifyCallResult(success, returndata, errorMessage);
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
186      * but performing a delegate call.
187      *
188      * _Available since v3.4._
189      */
190     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
196      * but performing a delegate call.
197      *
198      * _Available since v3.4._
199      */
200     function functionDelegateCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         require(isContract(target), "Address: delegate call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.delegatecall(data);
208         return verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
213      * revert reason using the provided one.
214      *
215      * _Available since v4.3._
216      */
217     function verifyCallResult(
218         bool success,
219         bytes memory returndata,
220         string memory errorMessage
221     ) internal pure returns (bytes memory) {
222         if (success) {
223             return returndata;
224         } else {
225             // Look for revert reason and bubble it up if present
226             if (returndata.length > 0) {
227                 // The easiest way to bubble the revert reason is using memory via assembly
228 
229                 assembly {
230                     let returndata_size := mload(returndata)
231                     revert(add(32, returndata), returndata_size)
232                 }
233             } else {
234                 revert(errorMessage);
235             }
236         }
237     }
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
241 
242 
243 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @title ERC721 token receiver interface
249  * @dev Interface for any contract that wants to support safeTransfers
250  * from ERC721 asset contracts.
251  */
252 interface IERC721Receiver {
253     /**
254      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
255      * by operator from from, this function is called.
256      *
257      * It must return its Solidity selector to confirm the token transfer.
258      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
259      *
260      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
261      */
262     function onERC721Received(
263         address operator,
264         address from,
265         uint256 tokenId,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Interface of the ERC165 standard, as defined in the
279  * https://eips.ethereum.org/EIPS/eip-165[EIP].
280  *
281  * Implementers can declare support of contract interfaces, which can then be
282  * queried by others ({ERC165Checker}).
283  *
284  * For an implementation, see {ERC165}.
285  */
286 interface IERC165 {
287     /**
288      * @dev Returns true if this contract implements the interface defined by
289      * interfaceId. See the corresponding
290      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
291      * to learn more about how these ids are created.
292      *
293      * This function call must use less than 30 000 gas.
294      */
295     function supportsInterface(bytes4 interfaceId) external view returns (bool);
296 }
297 
298 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
299 
300 
301 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
302 
303 pragma solidity ^0.8.0;
304 
305 
306 /**
307  * @dev Implementation of the {IERC165} interface.
308  *
309  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
310  * for the additional interface id that will be supported. For example:
311  *
312  * solidity
313  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
315  * }
316  * 
317  *
318  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
319  */
320 abstract contract ERC165 is IERC165 {
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      */
324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325         return interfaceId == type(IERC165).interfaceId;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
330 
331 
332 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 
337 /**
338  * @dev Required interface of an ERC721 compliant contract.
339  */
340 interface IERC721 is IERC165 {
341     /**
342      * @dev Emitted when tokenId token is transferred from from to to.
343      */
344     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
345 
346     /**
347      * @dev Emitted when owner enables approved to manage the tokenId token.
348      */
349     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
350 
351     /**
352      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
353      */
354     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
355 
356     /**
357      * @dev Returns the number of tokens in owner's account.
358      */
359     function balanceOf(address owner) external view returns (uint256 balance);
360 
361     /**
362      * @dev Returns the owner of the tokenId token.
363      *
364      * Requirements:
365      *
366      * - tokenId must exist.
367      */
368     function ownerOf(uint256 tokenId) external view returns (address owner);
369 
370     /**
371      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
372      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
373      *
374      * Requirements:
375      *
376      * - from cannot be the zero address.
377      * - to cannot be the zero address.
378      * - tokenId token must exist and be owned by from.
379      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
380      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
381      *
382      * Emits a {Transfer} event.
383      */
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId
388     ) external;
389 
390     /**
391      * @dev Transfers tokenId token from from to to.
392      *
393      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
394      *
395      * Requirements:
396      *
397      * - from cannot be the zero address.
398      * - to cannot be the zero address.
399      * - tokenId token must be owned by from.
400      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external;
409 
410     /**
411      * @dev Gives permission to to to transfer tokenId token to another account.
412      * The approval is cleared when the token is transferred.
413      *
414      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
415      *
416      * Requirements:
417      *
418      * - The caller must own the token or be an approved operator.
419      * - tokenId must exist.
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address to, uint256 tokenId) external;
424 
425     /**
426      * @dev Returns the account approved for tokenId token.
427      *
428      * Requirements:
429      *
430      * - tokenId must exist.
431      */
432     function getApproved(uint256 tokenId) external view returns (address operator);
433 
434     /**
435      * @dev Approve or remove operator as an operator for the caller.
436      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
437      *
438      * Requirements:
439      *
440      * - The operator cannot be the caller.
441      *
442      * Emits an {ApprovalForAll} event.
443      */
444     function setApprovalForAll(address operator, bool _approved) external;
445 
446     /**
447      * @dev Returns if the operator is allowed to manage all of the assets of owner.
448      *
449      * See {setApprovalForAll}
450      */
451     function isApprovedForAll(address owner, address operator) external view returns (bool);
452 
453     /**
454      * @dev Safely transfers tokenId token from from to to.
455      *
456      * Requirements:
457      *
458      * - from cannot be the zero address.
459      * - to cannot be the zero address.
460      * - tokenId token must exist and be owned by from.
461      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
462      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
463      *
464      * Emits a {Transfer} event.
465      */
466     function safeTransferFrom(
467         address from,
468         address to,
469         uint256 tokenId,
470         bytes calldata data
471     ) external;
472 }
473 
474 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
484  * @dev See https://eips.ethereum.org/EIPS/eip-721
485  */
486 interface IERC721Enumerable is IERC721 {
487     /**
488      * @dev Returns the total amount of tokens stored by the contract.
489      */
490     function totalSupply() external view returns (uint256);
491 
492     /**
493      * @dev Returns a token ID owned by owner at a given index of its token list.
494      * Use along with {balanceOf} to enumerate all of owner's tokens.
495      */
496     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
497 
498     /**
499      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
500      * Use along with {totalSupply} to enumerate all tokens.
501      */
502     function tokenByIndex(uint256 index) external view returns (uint256);
503 }
504 
505 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 
513 /**
514  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
515  * @dev See https://eips.ethereum.org/EIPS/eip-721
516  */
517 interface IERC721Metadata is IERC721 {
518     /**
519      * @dev Returns the token collection name.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the token collection symbol.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
530      */
531     function tokenURI(uint256 tokenId) external view returns (string memory);
532 }
533 
534 // File: @openzeppelin/contracts/utils/Strings.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev String operations.
543  */
544 library Strings {
545     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
546 
547     /**
548      * @dev Converts a uint256 to its ASCII string decimal representation.
549      */
550     function toString(uint256 value) internal pure returns (string memory) {
551         // Inspired by OraclizeAPI's implementation - MIT licence
552         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
553 
554         if (value == 0) {
555             return "0";
556         }
557         uint256 temp = value;
558         uint256 digits;
559         while (temp != 0) {
560             digits++;
561             temp /= 10;
562         }
563         bytes memory buffer = new bytes(digits);
564         while (value != 0) {
565             digits -= 1;
566             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
567             value /= 10;
568         }
569         return string(buffer);
570     }
571 
572     /**
573      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
574      */
575     function toHexString(uint256 value) internal pure returns (string memory) {
576         if (value == 0) {
577             return "0x00";
578         }
579         uint256 temp = value;
580         uint256 length = 0;
581         while (temp != 0) {
582             length++;
583             temp >>= 8;
584         }
585         return toHexString(value, length);
586     }
587 
588     /**
589      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
590      */
591     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
592         bytes memory buffer = new bytes(2 * length + 2);
593         buffer[0] = "0";
594         buffer[1] = "x";
595         for (uint256 i = 2 * length + 1; i > 1; --i) {
596             buffer[i] = _HEX_SYMBOLS[value & 0xf];
597             value >>= 4;
598         }
599         require(value == 0, "Strings: hex length insufficient");
600         return string(buffer);
601     }
602 }
603 
604 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
605 
606 
607 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 /**
612  * @dev Contract module that helps prevent reentrant calls to a function.
613  *
614  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
615  * available, which can be applied to functions to make sure there are no nested
616  * (reentrant) calls to them.
617  *
618  * Note that because there is a single nonReentrant guard, functions marked as
619  * nonReentrant may not call one another. This can be worked around by making
620  * those functions private, and then adding external nonReentrant entry
621  * points to them.
622  *
623  * TIP: If you would like to learn more about reentrancy and alternative ways
624  * to protect against it, check out our blog post
625  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
626  */
627 abstract contract ReentrancyGuard {
628     // Booleans are more expensive than uint256 or any type that takes up a full
629     // word because each write operation emits an extra SLOAD to first read the
630     // slot's contents, replace the bits taken up by the boolean, and then write
631     // back. This is the compiler's defense against contract upgrades and
632     // pointer aliasing, and it cannot be disabled.
633 
634     // The values being non-zero value makes deployment a bit more expensive,
635     // but in exchange the refund on every call to nonReentrant will be lower in
636     // amount. Since refunds are capped to a percentage of the total
637     // transaction's gas, it is best to keep them low in cases like this one, to
638     // increase the likelihood of the full refund coming into effect.
639     uint256 private constant _NOT_ENTERED = 1;
640     uint256 private constant _ENTERED = 2;
641 
642     uint256 private _status;
643 
644     constructor() {
645         _status = _NOT_ENTERED;
646     }
647 
648     /**
649      * @dev Prevents a contract from calling itself, directly or indirectly.
650      * Calling a nonReentrant function from another nonReentrant
651      * function is not supported. It is possible to prevent this from happening
652      * by making the nonReentrant function external, and making it call a
653      * private function that does the actual work.
654      */
655     modifier nonReentrant() {
656         // On the first call to nonReentrant, _notEntered will be true
657         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
658 
659         // Any calls to nonReentrant after this point will fail
660         _status = _ENTERED;
661 
662         _;
663 
664         // By storing the original value once again, a refund is triggered (see
665         // https://eips.ethereum.org/EIPS/eip-2200)
666         _status = _NOT_ENTERED;
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/Context.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Provides information about the current execution context, including the
679  * sender of the transaction and its data. While these are generally available
680  * via msg.sender and msg.data, they should not be accessed in such a direct
681  * manner, since when dealing with meta-transactions the account sending and
682  * paying for execution may not be the actual sender (as far as an application
683  * is concerned).
684  *
685  * This contract is only required for intermediate, library-like contracts.
686  */
687 abstract contract Context {
688     function _msgSender() internal view virtual returns (address) {
689         return msg.sender;
690     }
691 
692     function _msgData() internal view virtual returns (bytes calldata) {
693         return msg.data;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/access/Ownable.sol
698 
699 
700 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Contract module which provides a basic access control mechanism, where
707  * there is an account (an owner) that can be granted exclusive access to
708  * specific functions.
709  *
710  * By default, the owner account will be the one that deploys the contract. This
711  * can later be changed with {transferOwnership}.
712  *
713  * This module is used through inheritance. It will make available the modifier
714  * onlyOwner, which can be applied to your functions to restrict their use to
715  * the owner.
716  */
717 abstract contract Ownable is Context {
718     address private _owner;
719 
720     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
721 
722     /**
723      * @dev Initializes the contract setting the deployer as the initial owner.
724      */
725     constructor() {
726         _transferOwnership(_msgSender());
727     }
728 
729     /**
730      * @dev Returns the address of the current owner.
731      */
732     function owner() public view virtual returns (address) {
733         return _owner;
734     }
735 
736     /**
737      * @dev Throws if called by any account other than the owner.
738      */
739     modifier onlyOwner() {
740         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
774 //-------------END DEPENDENCIES------------------------//
775 
776 
777   
778 // Rampp Contracts v2.1 (Teams.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 /**
783 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
784 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
785 * This will easily allow cross-collaboration via Rampp.xyz.
786 **/
787 abstract contract Teams is Ownable{
788   mapping (address => bool) internal team;
789 
790   /**
791   * @dev Adds an address to the team. Allows them to execute protected functions
792   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
793   **/
794   function addToTeam(address _address) public onlyOwner {
795     require(_address != address(0), "Invalid address");
796     require(!inTeam(_address), "This address is already in your team.");
797   
798     team[_address] = true;
799   }
800 
801   /**
802   * @dev Removes an address to the team.
803   * @param _address the ETH address to remove, cannot be 0x and must be in team
804   **/
805   function removeFromTeam(address _address) public onlyOwner {
806     require(_address != address(0), "Invalid address");
807     require(inTeam(_address), "This address is not in your team currently.");
808   
809     team[_address] = false;
810   }
811 
812   /**
813   * @dev Check if an address is valid and active in the team
814   * @param _address ETH address to check for truthiness
815   **/
816   function inTeam(address _address)
817     public
818     view
819     returns (bool)
820   {
821     require(_address != address(0), "Invalid address to check.");
822     return team[_address] == true;
823   }
824 
825   /**
826   * @dev Throws if called by any account other than the owner or team member.
827   */
828   modifier onlyTeamOrOwner() {
829     bool _isOwner = owner() == _msgSender();
830     bool _isTeam = inTeam(_msgSender());
831     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
832     _;
833   }
834 }
835 
836 
837   
838   pragma solidity ^0.8.0;
839 
840   /**
841   * @dev These functions deal with verification of Merkle Trees proofs.
842   *
843   * The proofs can be generated using the JavaScript library
844   * https://github.com/miguelmota/merkletreejs[merkletreejs].
845   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
846   *
847   *
848   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
849   * hashing, or use a hash function other than keccak256 for hashing leaves.
850   * This is because the concatenation of a sorted pair of internal nodes in
851   * the merkle tree could be reinterpreted as a leaf value.
852   */
853   library MerkleProof {
854       /**
855       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
856       * defined by 'root'. For this, a 'proof' must be provided, containing
857       * sibling hashes on the branch from the leaf to the root of the tree. Each
858       * pair of leaves and each pair of pre-images are assumed to be sorted.
859       */
860       function verify(
861           bytes32[] memory proof,
862           bytes32 root,
863           bytes32 leaf
864       ) internal pure returns (bool) {
865           return processProof(proof, leaf) == root;
866       }
867 
868       /**
869       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
870       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
871       * hash matches the root of the tree. When processing the proof, the pairs
872       * of leafs & pre-images are assumed to be sorted.
873       *
874       * _Available since v4.4._
875       */
876       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
877           bytes32 computedHash = leaf;
878           for (uint256 i = 0; i < proof.length; i++) {
879               bytes32 proofElement = proof[i];
880               if (computedHash <= proofElement) {
881                   // Hash(current computed hash + current element of the proof)
882                   computedHash = _efficientHash(computedHash, proofElement);
883               } else {
884                   // Hash(current element of the proof + current computed hash)
885                   computedHash = _efficientHash(proofElement, computedHash);
886               }
887           }
888           return computedHash;
889       }
890 
891       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
892           assembly {
893               mstore(0x00, a)
894               mstore(0x20, b)
895               value := keccak256(0x00, 0x40)
896           }
897       }
898   }
899 
900 
901   // File: Allowlist.sol
902 
903   pragma solidity ^0.8.0;
904 
905   abstract contract Allowlist is Teams {
906     bytes32 public merkleRoot;
907     bool public onlyAllowlistMode = false;
908 
909     /**
910      * @dev Update merkle root to reflect changes in Allowlist
911      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
912      */
913     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
914       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
915       merkleRoot = _newMerkleRoot;
916     }
917 
918     /**
919      * @dev Check the proof of an address if valid for merkle root
920      * @param _to address to check for proof
921      * @param _merkleProof Proof of the address to validate against root and leaf
922      */
923     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
924       require(merkleRoot != 0, "Merkle root is not set!");
925       bytes32 leaf = keccak256(abi.encodePacked(_to));
926 
927       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
928     }
929 
930     
931     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
932       onlyAllowlistMode = true;
933     }
934 
935     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
936         onlyAllowlistMode = false;
937     }
938   }
939   
940   
941 /**
942  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
943  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
944  *
945  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
946  * 
947  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
948  *
949  * Does not support burning tokens to address(0).
950  */
951 contract ERC721A is
952   Context,
953   ERC165,
954   IERC721,
955   IERC721Metadata,
956   IERC721Enumerable
957 {
958   using Address for address;
959   using Strings for uint256;
960 
961   struct TokenOwnership {
962     address addr;
963     uint64 startTimestamp;
964   }
965 
966   struct AddressData {
967     uint128 balance;
968     uint128 numberMinted;
969   }
970 
971   uint256 private currentIndex;
972 
973   uint256 public immutable collectionSize;
974   uint256 public maxBatchSize;
975 
976   // Token name
977   string private _name;
978 
979   // Token symbol
980   string private _symbol;
981 
982   // Mapping from token ID to ownership details
983   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
984   mapping(uint256 => TokenOwnership) private _ownerships;
985 
986   // Mapping owner address to address data
987   mapping(address => AddressData) private _addressData;
988 
989   // Mapping from token ID to approved address
990   mapping(uint256 => address) private _tokenApprovals;
991 
992   // Mapping from owner to operator approvals
993   mapping(address => mapping(address => bool)) private _operatorApprovals;
994 
995   /**
996    * @dev
997    * maxBatchSize refers to how much a minter can mint at a time.
998    * collectionSize_ refers to how many tokens are in the collection.
999    */
1000   constructor(
1001     string memory name_,
1002     string memory symbol_,
1003     uint256 maxBatchSize_,
1004     uint256 collectionSize_
1005   ) {
1006     require(
1007       collectionSize_ > 0,
1008       "ERC721A: collection must have a nonzero supply"
1009     );
1010     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1011     _name = name_;
1012     _symbol = symbol_;
1013     maxBatchSize = maxBatchSize_;
1014     collectionSize = collectionSize_;
1015     currentIndex = _startTokenId();
1016   }
1017 
1018   /**
1019   * To change the starting tokenId, please override this function.
1020   */
1021   function _startTokenId() internal view virtual returns (uint256) {
1022     return 1;
1023   }
1024 
1025   /**
1026    * @dev See {IERC721Enumerable-totalSupply}.
1027    */
1028   function totalSupply() public view override returns (uint256) {
1029     return _totalMinted();
1030   }
1031 
1032   function currentTokenId() public view returns (uint256) {
1033     return _totalMinted();
1034   }
1035 
1036   function getNextTokenId() public view returns (uint256) {
1037       return _totalMinted() + 1;
1038   }
1039 
1040   /**
1041   * Returns the total amount of tokens minted in the contract.
1042   */
1043   function _totalMinted() internal view returns (uint256) {
1044     unchecked {
1045       return currentIndex - _startTokenId();
1046     }
1047   }
1048 
1049   /**
1050    * @dev See {IERC721Enumerable-tokenByIndex}.
1051    */
1052   function tokenByIndex(uint256 index) public view override returns (uint256) {
1053     require(index < totalSupply(), "ERC721A: global index out of bounds");
1054     return index;
1055   }
1056 
1057   /**
1058    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1059    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1060    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1061    */
1062   function tokenOfOwnerByIndex(address owner, uint256 index)
1063     public
1064     view
1065     override
1066     returns (uint256)
1067   {
1068     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1069     uint256 numMintedSoFar = totalSupply();
1070     uint256 tokenIdsIdx = 0;
1071     address currOwnershipAddr = address(0);
1072     for (uint256 i = 0; i < numMintedSoFar; i++) {
1073       TokenOwnership memory ownership = _ownerships[i];
1074       if (ownership.addr != address(0)) {
1075         currOwnershipAddr = ownership.addr;
1076       }
1077       if (currOwnershipAddr == owner) {
1078         if (tokenIdsIdx == index) {
1079           return i;
1080         }
1081         tokenIdsIdx++;
1082       }
1083     }
1084     revert("ERC721A: unable to get token of owner by index");
1085   }
1086 
1087   /**
1088    * @dev See {IERC165-supportsInterface}.
1089    */
1090   function supportsInterface(bytes4 interfaceId)
1091     public
1092     view
1093     virtual
1094     override(ERC165, IERC165)
1095     returns (bool)
1096   {
1097     return
1098       interfaceId == type(IERC721).interfaceId ||
1099       interfaceId == type(IERC721Metadata).interfaceId ||
1100       interfaceId == type(IERC721Enumerable).interfaceId ||
1101       super.supportsInterface(interfaceId);
1102   }
1103 
1104   /**
1105    * @dev See {IERC721-balanceOf}.
1106    */
1107   function balanceOf(address owner) public view override returns (uint256) {
1108     require(owner != address(0), "ERC721A: balance query for the zero address");
1109     return uint256(_addressData[owner].balance);
1110   }
1111 
1112   function _numberMinted(address owner) internal view returns (uint256) {
1113     require(
1114       owner != address(0),
1115       "ERC721A: number minted query for the zero address"
1116     );
1117     return uint256(_addressData[owner].numberMinted);
1118   }
1119 
1120   function ownershipOf(uint256 tokenId)
1121     internal
1122     view
1123     returns (TokenOwnership memory)
1124   {
1125     uint256 curr = tokenId;
1126 
1127     unchecked {
1128         if (_startTokenId() <= curr && curr < currentIndex) {
1129             TokenOwnership memory ownership = _ownerships[curr];
1130             if (ownership.addr != address(0)) {
1131                 return ownership;
1132             }
1133 
1134             // Invariant:
1135             // There will always be an ownership that has an address and is not burned
1136             // before an ownership that does not have an address and is not burned.
1137             // Hence, curr will not underflow.
1138             while (true) {
1139                 curr--;
1140                 ownership = _ownerships[curr];
1141                 if (ownership.addr != address(0)) {
1142                     return ownership;
1143                 }
1144             }
1145         }
1146     }
1147 
1148     revert("ERC721A: unable to determine the owner of token");
1149   }
1150 
1151   /**
1152    * @dev See {IERC721-ownerOf}.
1153    */
1154   function ownerOf(uint256 tokenId) public view override returns (address) {
1155     return ownershipOf(tokenId).addr;
1156   }
1157 
1158   /**
1159    * @dev See {IERC721Metadata-name}.
1160    */
1161   function name() public view virtual override returns (string memory) {
1162     return _name;
1163   }
1164 
1165   /**
1166    * @dev See {IERC721Metadata-symbol}.
1167    */
1168   function symbol() public view virtual override returns (string memory) {
1169     return _symbol;
1170   }
1171 
1172   /**
1173    * @dev See {IERC721Metadata-tokenURI}.
1174    */
1175   function tokenURI(uint256 tokenId)
1176     public
1177     view
1178     virtual
1179     override
1180     returns (string memory)
1181   {
1182     string memory baseURI = _baseURI();
1183     return
1184       bytes(baseURI).length > 0
1185         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1186         : "";
1187   }
1188 
1189   /**
1190    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1191    * token will be the concatenation of the baseURI and the tokenId. Empty
1192    * by default, can be overriden in child contracts.
1193    */
1194   function _baseURI() internal view virtual returns (string memory) {
1195     return "";
1196   }
1197 
1198   /**
1199    * @dev See {IERC721-approve}.
1200    */
1201   function approve(address to, uint256 tokenId) public override {
1202     address owner = ERC721A.ownerOf(tokenId);
1203     require(to != owner, "ERC721A: approval to current owner");
1204 
1205     require(
1206       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1207       "ERC721A: approve caller is not owner nor approved for all"
1208     );
1209 
1210     _approve(to, tokenId, owner);
1211   }
1212 
1213   /**
1214    * @dev See {IERC721-getApproved}.
1215    */
1216   function getApproved(uint256 tokenId) public view override returns (address) {
1217     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1218 
1219     return _tokenApprovals[tokenId];
1220   }
1221 
1222   /**
1223    * @dev See {IERC721-setApprovalForAll}.
1224    */
1225   function setApprovalForAll(address operator, bool approved) public override {
1226     require(operator != _msgSender(), "ERC721A: approve to caller");
1227 
1228     _operatorApprovals[_msgSender()][operator] = approved;
1229     emit ApprovalForAll(_msgSender(), operator, approved);
1230   }
1231 
1232   /**
1233    * @dev See {IERC721-isApprovedForAll}.
1234    */
1235   function isApprovedForAll(address owner, address operator)
1236     public
1237     view
1238     virtual
1239     override
1240     returns (bool)
1241   {
1242     return _operatorApprovals[owner][operator];
1243   }
1244 
1245   /**
1246    * @dev See {IERC721-transferFrom}.
1247    */
1248   function transferFrom(
1249     address from,
1250     address to,
1251     uint256 tokenId
1252   ) public override {
1253     _transfer(from, to, tokenId);
1254   }
1255 
1256   /**
1257    * @dev See {IERC721-safeTransferFrom}.
1258    */
1259   function safeTransferFrom(
1260     address from,
1261     address to,
1262     uint256 tokenId
1263   ) public override {
1264     safeTransferFrom(from, to, tokenId, "");
1265   }
1266 
1267   /**
1268    * @dev See {IERC721-safeTransferFrom}.
1269    */
1270   function safeTransferFrom(
1271     address from,
1272     address to,
1273     uint256 tokenId,
1274     bytes memory _data
1275   ) public override {
1276     _transfer(from, to, tokenId);
1277     require(
1278       _checkOnERC721Received(from, to, tokenId, _data),
1279       "ERC721A: transfer to non ERC721Receiver implementer"
1280     );
1281   }
1282 
1283   /**
1284    * @dev Returns whether tokenId exists.
1285    *
1286    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1287    *
1288    * Tokens start existing when they are minted (_mint),
1289    */
1290   function _exists(uint256 tokenId) internal view returns (bool) {
1291     return _startTokenId() <= tokenId && tokenId < currentIndex;
1292   }
1293 
1294   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1295     _safeMint(to, quantity, isAdminMint, "");
1296   }
1297 
1298   /**
1299    * @dev Mints quantity tokens and transfers them to to.
1300    *
1301    * Requirements:
1302    *
1303    * - there must be quantity tokens remaining unminted in the total collection.
1304    * - to cannot be the zero address.
1305    * - quantity cannot be larger than the max batch size.
1306    *
1307    * Emits a {Transfer} event.
1308    */
1309   function _safeMint(
1310     address to,
1311     uint256 quantity,
1312     bool isAdminMint,
1313     bytes memory _data
1314   ) internal {
1315     uint256 startTokenId = currentIndex;
1316     require(to != address(0), "ERC721A: mint to the zero address");
1317     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1318     require(!_exists(startTokenId), "ERC721A: token already minted");
1319 
1320     // For admin mints we do not want to enforce the maxBatchSize limit
1321     if (isAdminMint == false) {
1322         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1323     }
1324 
1325     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1326 
1327     AddressData memory addressData = _addressData[to];
1328     _addressData[to] = AddressData(
1329       addressData.balance + uint128(quantity),
1330       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1331     );
1332     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1333 
1334     uint256 updatedIndex = startTokenId;
1335 
1336     for (uint256 i = 0; i < quantity; i++) {
1337       emit Transfer(address(0), to, updatedIndex);
1338       require(
1339         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1340         "ERC721A: transfer to non ERC721Receiver implementer"
1341       );
1342       updatedIndex++;
1343     }
1344 
1345     currentIndex = updatedIndex;
1346     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1347   }
1348 
1349   /**
1350    * @dev Transfers tokenId from from to to.
1351    *
1352    * Requirements:
1353    *
1354    * - to cannot be the zero address.
1355    * - tokenId token must be owned by from.
1356    *
1357    * Emits a {Transfer} event.
1358    */
1359   function _transfer(
1360     address from,
1361     address to,
1362     uint256 tokenId
1363   ) private {
1364     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1365 
1366     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1367       getApproved(tokenId) == _msgSender() ||
1368       isApprovedForAll(prevOwnership.addr, _msgSender()));
1369 
1370     require(
1371       isApprovedOrOwner,
1372       "ERC721A: transfer caller is not owner nor approved"
1373     );
1374 
1375     require(
1376       prevOwnership.addr == from,
1377       "ERC721A: transfer from incorrect owner"
1378     );
1379     require(to != address(0), "ERC721A: transfer to the zero address");
1380 
1381     _beforeTokenTransfers(from, to, tokenId, 1);
1382 
1383     // Clear approvals from the previous owner
1384     _approve(address(0), tokenId, prevOwnership.addr);
1385 
1386     _addressData[from].balance -= 1;
1387     _addressData[to].balance += 1;
1388     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1389 
1390     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1391     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1392     uint256 nextTokenId = tokenId + 1;
1393     if (_ownerships[nextTokenId].addr == address(0)) {
1394       if (_exists(nextTokenId)) {
1395         _ownerships[nextTokenId] = TokenOwnership(
1396           prevOwnership.addr,
1397           prevOwnership.startTimestamp
1398         );
1399       }
1400     }
1401 
1402     emit Transfer(from, to, tokenId);
1403     _afterTokenTransfers(from, to, tokenId, 1);
1404   }
1405 
1406   /**
1407    * @dev Approve to to operate on tokenId
1408    *
1409    * Emits a {Approval} event.
1410    */
1411   function _approve(
1412     address to,
1413     uint256 tokenId,
1414     address owner
1415   ) private {
1416     _tokenApprovals[tokenId] = to;
1417     emit Approval(owner, to, tokenId);
1418   }
1419 
1420   uint256 public nextOwnerToExplicitlySet = 0;
1421 
1422   /**
1423    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1424    */
1425   function _setOwnersExplicit(uint256 quantity) internal {
1426     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1427     require(quantity > 0, "quantity must be nonzero");
1428     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1429 
1430     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1431     if (endIndex > collectionSize - 1) {
1432       endIndex = collectionSize - 1;
1433     }
1434     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1435     require(_exists(endIndex), "not enough minted yet for this cleanup");
1436     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1437       if (_ownerships[i].addr == address(0)) {
1438         TokenOwnership memory ownership = ownershipOf(i);
1439         _ownerships[i] = TokenOwnership(
1440           ownership.addr,
1441           ownership.startTimestamp
1442         );
1443       }
1444     }
1445     nextOwnerToExplicitlySet = endIndex + 1;
1446   }
1447 
1448   /**
1449    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1450    * The call is not executed if the target address is not a contract.
1451    *
1452    * @param from address representing the previous owner of the given token ID
1453    * @param to target address that will receive the tokens
1454    * @param tokenId uint256 ID of the token to be transferred
1455    * @param _data bytes optional data to send along with the call
1456    * @return bool whether the call correctly returned the expected magic value
1457    */
1458   function _checkOnERC721Received(
1459     address from,
1460     address to,
1461     uint256 tokenId,
1462     bytes memory _data
1463   ) private returns (bool) {
1464     if (to.isContract()) {
1465       try
1466         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1467       returns (bytes4 retval) {
1468         return retval == IERC721Receiver(to).onERC721Received.selector;
1469       } catch (bytes memory reason) {
1470         if (reason.length == 0) {
1471           revert("ERC721A: transfer to non ERC721Receiver implementer");
1472         } else {
1473           assembly {
1474             revert(add(32, reason), mload(reason))
1475           }
1476         }
1477       }
1478     } else {
1479       return true;
1480     }
1481   }
1482 
1483   /**
1484    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1485    *
1486    * startTokenId - the first token id to be transferred
1487    * quantity - the amount to be transferred
1488    *
1489    * Calling conditions:
1490    *
1491    * - When from and to are both non-zero, from's tokenId will be
1492    * transferred to to.
1493    * - When from is zero, tokenId will be minted for to.
1494    */
1495   function _beforeTokenTransfers(
1496     address from,
1497     address to,
1498     uint256 startTokenId,
1499     uint256 quantity
1500   ) internal virtual {}
1501 
1502   /**
1503    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1504    * minting.
1505    *
1506    * startTokenId - the first token id to be transferred
1507    * quantity - the amount to be transferred
1508    *
1509    * Calling conditions:
1510    *
1511    * - when from and to are both non-zero.
1512    * - from and to are never both zero.
1513    */
1514   function _afterTokenTransfers(
1515     address from,
1516     address to,
1517     uint256 startTokenId,
1518     uint256 quantity
1519   ) internal virtual {}
1520 }
1521 
1522 
1523 
1524   
1525 abstract contract Ramppable {
1526   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1527 
1528   modifier isRampp() {
1529       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1530       _;
1531   }
1532 }
1533 
1534 
1535   
1536   
1537 interface IERC20 {
1538   function transfer(address _to, uint256 _amount) external returns (bool);
1539   function balanceOf(address account) external view returns (uint256);
1540 }
1541 
1542 abstract contract Withdrawable is Teams, Ramppable {
1543   address[] public payableAddresses = [RAMPPADDRESS,0x8900a69d2c726051928F9F0f2A27B2CC6432C9a2];
1544   uint256[] public payableFees = [5,95];
1545   uint256 public payableAddressCount = 2;
1546 
1547   function withdrawAll() public onlyTeamOrOwner {
1548       require(address(this).balance > 0);
1549       _withdrawAll();
1550   }
1551   
1552   function withdrawAllRampp() public isRampp {
1553       require(address(this).balance > 0);
1554       _withdrawAll();
1555   }
1556 
1557   function _withdrawAll() private {
1558       uint256 balance = address(this).balance;
1559       
1560       for(uint i=0; i < payableAddressCount; i++ ) {
1561           _widthdraw(
1562               payableAddresses[i],
1563               (balance * payableFees[i]) / 100
1564           );
1565       }
1566   }
1567   
1568   function _widthdraw(address _address, uint256 _amount) private {
1569       (bool success, ) = _address.call{value: _amount}("");
1570       require(success, "Transfer failed.");
1571   }
1572 
1573   /**
1574     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1575     * while still splitting royalty payments to all other team members.
1576     * in the event ERC-20 tokens are paid to the contract.
1577     * @param _tokenContract contract of ERC-20 token to withdraw
1578     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1579     */
1580   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1581     require(_amount > 0);
1582     IERC20 tokenContract = IERC20(_tokenContract);
1583     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1584 
1585     for(uint i=0; i < payableAddressCount; i++ ) {
1586         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1587     }
1588   }
1589 
1590   /**
1591   * @dev Allows Rampp wallet to update its own reference as well as update
1592   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1593   * and since Rampp is always the first address this function is limited to the rampp payout only.
1594   * @param _newAddress updated Rampp Address
1595   */
1596   function setRamppAddress(address _newAddress) public isRampp {
1597     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1598     RAMPPADDRESS = _newAddress;
1599     payableAddresses[0] = _newAddress;
1600   }
1601 }
1602 
1603 
1604   
1605 // File: isFeeable.sol
1606 abstract contract Feeable is Teams {
1607   uint256 public PRICE = 0 ether;
1608 
1609   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1610     PRICE = _feeInWei;
1611   }
1612 
1613   function getPrice(uint256 _count) public view returns (uint256) {
1614     return PRICE * _count;
1615   }
1616 }
1617 
1618   
1619   
1620 abstract contract RamppERC721A is 
1621     Ownable,
1622     Teams,
1623     ERC721A,
1624     Withdrawable,
1625     ReentrancyGuard 
1626     , Feeable 
1627     , Allowlist 
1628     
1629 {
1630   constructor(
1631     string memory tokenName,
1632     string memory tokenSymbol
1633   ) ERC721A(tokenName, tokenSymbol, 2, 7777) { }
1634     uint8 public CONTRACT_VERSION = 2;
1635     string public _baseTokenURI = "";
1636 
1637     bool public mintingOpen = true;
1638     
1639     
1640     uint256 public MAX_WALLET_MINTS = 5000;
1641 
1642   
1643     /////////////// Admin Mint Functions
1644     /**
1645      * @dev Mints a token to an address with a tokenURI.
1646      * This is owner only and allows a fee-free drop
1647      * @param _to address of the future owner of the token
1648      * @param _qty amount of tokens to drop the owner
1649      */
1650      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1651          require(_qty > 0, "Must mint at least 1 token.");
1652          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 88888");
1653          _safeMint(_to, _qty, true);
1654      }
1655 
1656   
1657     /////////////// GENERIC MINT FUNCTIONS
1658     /**
1659     * @dev Mints a single token to an address.
1660     * fee may or may not be required*
1661     * @param _to address of the future owner of the token
1662     */
1663     function mintTo(address _to) public payable {
1664         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1665         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1666         
1667         require(canMintAmount(_to, 200), "Wallet address is over the maximum allowed mints");
1668         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1669         
1670         _safeMint(_to, 1, false);
1671     }
1672 
1673     /**
1674     * @dev Mints a token to an address with a tokenURI.
1675     * fee may or may not be required*
1676     * @param _to address of the future owner of the token
1677     * @param _amount number of tokens to mint
1678     */
1679     function mintToMultiple(address _to, uint256 _amount) public payable {
1680         require(_amount >= 1, "Must mint at least 1 token");
1681         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1682         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1683         
1684         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1685         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 88888");
1686         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1687 
1688         _safeMint(_to, _amount, false);
1689     }
1690 
1691     function openMinting() public onlyTeamOrOwner {
1692         mintingOpen = true;
1693     }
1694 
1695     function stopMinting() public onlyTeamOrOwner {
1696         mintingOpen = false;
1697     }
1698 
1699   
1700     ///////////// ALLOWLIST MINTING FUNCTIONS
1701 
1702     /**
1703     * @dev Mints a token to an address with a tokenURI for allowlist.
1704     * fee may or may not be required*
1705     * @param _to address of the future owner of the token
1706     */
1707     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1708         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1709         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1710         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 8888");
1711         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1712         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1713         
1714 
1715         _safeMint(_to, 1, false);
1716     }
1717 
1718     /**
1719     * @dev Mints a token to an address with a tokenURI for allowlist.
1720     * fee may or may not be required*
1721     * @param _to address of the future owner of the token
1722     * @param _amount number of tokens to mint
1723     */
1724     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1725         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1726         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1727         require(_amount >= 1, "Must mint at least 1 token");
1728         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1729 
1730         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1731         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 8888");
1732         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1733         
1734 
1735         _safeMint(_to, _amount, false);
1736     }
1737 
1738     /**
1739      * @dev Enable allowlist minting fully by enabling both flags
1740      * This is a convenience function for the Rampp user
1741      */
1742     function openAllowlistMint() public onlyTeamOrOwner {
1743         enableAllowlistOnlyMode();
1744         mintingOpen = true;
1745     }
1746 
1747     /**
1748      * @dev Close allowlist minting fully by disabling both flags
1749      * This is a convenience function for the Rampp user
1750      */
1751     function closeAllowlistMint() public onlyTeamOrOwner {
1752         disableAllowlistOnlyMode();
1753         mintingOpen = false;
1754     }
1755 
1756 
1757   
1758     /**
1759     * @dev Check if wallet over MAX_WALLET_MINTS
1760     * @param _address address in question to check if minted count exceeds max
1761     */
1762     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1763         require(_amount >= 1, "Amount must be greater than or equal to 1");
1764         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1765     }
1766 
1767     /**
1768     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1769     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1770     */
1771     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1772         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1773         MAX_WALLET_MINTS = _newWalletMax;
1774     }
1775     
1776 
1777   
1778     /**
1779      * @dev Allows owner to set Max mints per tx
1780      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1781      */
1782      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1783          require(_newMaxMint >= 1, "Max mint must be at least 1");
1784          maxBatchSize = _newMaxMint;
1785      }
1786     
1787 
1788   
1789 
1790   function _baseURI() internal view virtual override returns(string memory) {
1791     return _baseTokenURI;
1792   }
1793 
1794   function baseTokenURI() public view returns(string memory) {
1795     return _baseTokenURI;
1796   }
1797 
1798   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1799     _baseTokenURI = baseURI;
1800   }
1801 
1802   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1803     return ownershipOf(tokenId);
1804   }
1805 }
1806 
1807 
1808   
1809 //SPDX-License-Identifier: MIT
1810 
1811 pragma solidity ^0.8.0;
1812 
1813 contract OgreWorld is RamppERC721A {
1814     constructor() RamppERC721A("Ogre World NFT", "OGRE"){}
1815 }