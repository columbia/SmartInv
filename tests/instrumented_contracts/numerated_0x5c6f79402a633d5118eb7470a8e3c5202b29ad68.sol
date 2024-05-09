1 // File: magic.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-09-06
5 */
6 
7 /**
8  *Submitted for verification at Etherscan.io on 2022-09-02
9 */
10 
11 /**
12  *Submitted for verification at Etherscan.io on 2022-08-31
13 */
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
787 * This will easily allow cross-collaboration via Rampp.xyz.
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
958   IERC721Enumerable
959 {
960   using Address for address;
961   using Strings for uint256;
962 
963   struct TokenOwnership {
964     address addr;
965     uint64 startTimestamp;
966   }
967 
968   struct AddressData {
969     uint128 balance;
970     uint128 numberMinted;
971   }
972 
973   uint256 private currentIndex;
974 
975   uint256 public immutable collectionSize;
976   uint256 public maxBatchSize;
977 
978   // Token name
979   string private _name;
980 
981   // Token symbol
982   string private _symbol;
983 
984   // Mapping from token ID to ownership details
985   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
986   mapping(uint256 => TokenOwnership) private _ownerships;
987 
988   // Mapping owner address to address data
989   mapping(address => AddressData) private _addressData;
990 
991   // Mapping from token ID to approved address
992   mapping(uint256 => address) private _tokenApprovals;
993 
994   // Mapping from owner to operator approvals
995   mapping(address => mapping(address => bool)) private _operatorApprovals;
996 
997   /**
998    * @dev
999    * maxBatchSize refers to how much a minter can mint at a time.
1000    * collectionSize_ refers to how many tokens are in the collection.
1001    */
1002   constructor(
1003     string memory name_,
1004     string memory symbol_,
1005     uint256 maxBatchSize_,
1006     uint256 collectionSize_
1007   ) {
1008     require(
1009       collectionSize_ > 0,
1010       "ERC721A: collection must have a nonzero supply"
1011     );
1012     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1013     _name = name_;
1014     _symbol = symbol_;
1015     maxBatchSize = maxBatchSize_;
1016     collectionSize = collectionSize_;
1017     currentIndex = _startTokenId();
1018   }
1019 
1020   /**
1021   * To change the starting tokenId, please override this function.
1022   */
1023   function _startTokenId() internal view virtual returns (uint256) {
1024     return 1;
1025   }
1026 
1027   /**
1028    * @dev See {IERC721Enumerable-totalSupply}.
1029    */
1030   function totalSupply() public view override returns (uint256) {
1031     return _totalMinted();
1032   }
1033 
1034   function currentTokenId() public view returns (uint256) {
1035     return _totalMinted();
1036   }
1037 
1038   function getNextTokenId() public view returns (uint256) {
1039       return _totalMinted() + 1;
1040   }
1041 
1042   /**
1043   * Returns the total amount of tokens minted in the contract.
1044   */
1045   function _totalMinted() internal view returns (uint256) {
1046     unchecked {
1047       return currentIndex - _startTokenId();
1048     }
1049   }
1050 
1051   /**
1052    * @dev See {IERC721Enumerable-tokenByIndex}.
1053    */
1054   function tokenByIndex(uint256 index) public view override returns (uint256) {
1055     require(index < totalSupply(), "ERC721A: global index out of bounds");
1056     return index;
1057   }
1058 
1059   /**
1060    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1061    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1062    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1063    */
1064   function tokenOfOwnerByIndex(address owner, uint256 index)
1065     public
1066     view
1067     override
1068     returns (uint256)
1069   {
1070     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1071     uint256 numMintedSoFar = totalSupply();
1072     uint256 tokenIdsIdx = 0;
1073     address currOwnershipAddr = address(0);
1074     for (uint256 i = 0; i < numMintedSoFar; i++) {
1075       TokenOwnership memory ownership = _ownerships[i];
1076       if (ownership.addr != address(0)) {
1077         currOwnershipAddr = ownership.addr;
1078       }
1079       if (currOwnershipAddr == owner) {
1080         if (tokenIdsIdx == index) {
1081           return i;
1082         }
1083         tokenIdsIdx++;
1084       }
1085     }
1086     revert("ERC721A: unable to get token of owner by index");
1087   }
1088 
1089   /**
1090    * @dev See {IERC165-supportsInterface}.
1091    */
1092   function supportsInterface(bytes4 interfaceId)
1093     public
1094     view
1095     virtual
1096     override(ERC165, IERC165)
1097     returns (bool)
1098   {
1099     return
1100       interfaceId == type(IERC721).interfaceId ||
1101       interfaceId == type(IERC721Metadata).interfaceId ||
1102       interfaceId == type(IERC721Enumerable).interfaceId ||
1103       super.supportsInterface(interfaceId);
1104   }
1105 
1106   /**
1107    * @dev See {IERC721-balanceOf}.
1108    */
1109   function balanceOf(address owner) public view override returns (uint256) {
1110     require(owner != address(0), "ERC721A: balance query for the zero address");
1111     return uint256(_addressData[owner].balance);
1112   }
1113 
1114   function _numberMinted(address owner) internal view returns (uint256) {
1115     require(
1116       owner != address(0),
1117       "ERC721A: number minted query for the zero address"
1118     );
1119     return uint256(_addressData[owner].numberMinted);
1120   }
1121 
1122   function ownershipOf(uint256 tokenId)
1123     internal
1124     view
1125     returns (TokenOwnership memory)
1126   {
1127     uint256 curr = tokenId;
1128 
1129     unchecked {
1130         if (_startTokenId() <= curr && curr < currentIndex) {
1131             TokenOwnership memory ownership = _ownerships[curr];
1132             if (ownership.addr != address(0)) {
1133                 return ownership;
1134             }
1135 
1136             // Invariant:
1137             // There will always be an ownership that has an address and is not burned
1138             // before an ownership that does not have an address and is not burned.
1139             // Hence, curr will not underflow.
1140             while (true) {
1141                 curr--;
1142                 ownership = _ownerships[curr];
1143                 if (ownership.addr != address(0)) {
1144                     return ownership;
1145                 }
1146             }
1147         }
1148     }
1149 
1150     revert("ERC721A: unable to determine the owner of token");
1151   }
1152 
1153   /**
1154    * @dev See {IERC721-ownerOf}.
1155    */
1156   function ownerOf(uint256 tokenId) public view override returns (address) {
1157     return ownershipOf(tokenId).addr;
1158   }
1159 
1160   /**
1161    * @dev See {IERC721Metadata-name}.
1162    */
1163   function name() public view virtual override returns (string memory) {
1164     return _name;
1165   }
1166 
1167   /**
1168    * @dev See {IERC721Metadata-symbol}.
1169    */
1170   function symbol() public view virtual override returns (string memory) {
1171     return _symbol;
1172   }
1173 
1174   /**
1175    * @dev See {IERC721Metadata-tokenURI}.
1176    */
1177   function tokenURI(uint256 tokenId)
1178     public
1179     view
1180     virtual
1181     override
1182     returns (string memory)
1183   {
1184     string memory baseURI = _baseURI();
1185     return
1186       bytes(baseURI).length > 0
1187         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1188         : "";
1189   }
1190 
1191   /**
1192    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1193    * token will be the concatenation of the baseURI and the tokenId. Empty
1194    * by default, can be overriden in child contracts.
1195    */
1196   function _baseURI() internal view virtual returns (string memory) {
1197     return "";
1198   }
1199 
1200   /**
1201    * @dev See {IERC721-approve}.
1202    */
1203   function approve(address to, uint256 tokenId) public override {
1204     address owner = ERC721A.ownerOf(tokenId);
1205     require(to != owner, "ERC721A: approval to current owner");
1206 
1207     require(
1208       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1209       "ERC721A: approve caller is not owner nor approved for all"
1210     );
1211 
1212     _approve(to, tokenId, owner);
1213   }
1214 
1215   /**
1216    * @dev See {IERC721-getApproved}.
1217    */
1218   function getApproved(uint256 tokenId) public view override returns (address) {
1219     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1220 
1221     return _tokenApprovals[tokenId];
1222   }
1223 
1224   /**
1225    * @dev See {IERC721-setApprovalForAll}.
1226    */
1227   function setApprovalForAll(address operator, bool approved) public override {
1228     require(operator != _msgSender(), "ERC721A: approve to caller");
1229 
1230     _operatorApprovals[_msgSender()][operator] = approved;
1231     emit ApprovalForAll(_msgSender(), operator, approved);
1232   }
1233 
1234   /**
1235    * @dev See {IERC721-isApprovedForAll}.
1236    */
1237   function isApprovedForAll(address owner, address operator)
1238     public
1239     view
1240     virtual
1241     override
1242     returns (bool)
1243   {
1244     return _operatorApprovals[owner][operator];
1245   }
1246 
1247   /**
1248    * @dev See {IERC721-transferFrom}.
1249    */
1250   function transferFrom(
1251     address from,
1252     address to,
1253     uint256 tokenId
1254   ) public override {
1255     _transfer(from, to, tokenId);
1256   }
1257 
1258   /**
1259    * @dev See {IERC721-safeTransferFrom}.
1260    */
1261   function safeTransferFrom(
1262     address from,
1263     address to,
1264     uint256 tokenId
1265   ) public override {
1266     safeTransferFrom(from, to, tokenId, "");
1267   }
1268 
1269   /**
1270    * @dev See {IERC721-safeTransferFrom}.
1271    */
1272   function safeTransferFrom(
1273     address from,
1274     address to,
1275     uint256 tokenId,
1276     bytes memory _data
1277   ) public override {
1278     _transfer(from, to, tokenId);
1279     require(
1280       _checkOnERC721Received(from, to, tokenId, _data),
1281       "ERC721A: transfer to non ERC721Receiver implementer"
1282     );
1283   }
1284 
1285   /**
1286    * @dev Returns whether tokenId exists.
1287    *
1288    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1289    *
1290    * Tokens start existing when they are minted (_mint),
1291    */
1292   function _exists(uint256 tokenId) internal view returns (bool) {
1293     return _startTokenId() <= tokenId && tokenId < currentIndex;
1294   }
1295 
1296   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1297     _safeMint(to, quantity, isAdminMint, "");
1298   }
1299 
1300   /**
1301    * @dev Mints quantity tokens and transfers them to to.
1302    *
1303    * Requirements:
1304    *
1305    * - there must be quantity tokens remaining unminted in the total collection.
1306    * - to cannot be the zero address.
1307    * - quantity cannot be larger than the max batch size.
1308    *
1309    * Emits a {Transfer} event.
1310    */
1311   function _safeMint(
1312     address to,
1313     uint256 quantity,
1314     bool isAdminMint,
1315     bytes memory _data
1316   ) internal {
1317     uint256 startTokenId = currentIndex;
1318     require(to != address(0), "ERC721A: mint to the zero address");
1319     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1320     require(!_exists(startTokenId), "ERC721A: token already minted");
1321 
1322     // For admin mints we do not want to enforce the maxBatchSize limit
1323     if (isAdminMint == false) {
1324         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1325     }
1326 
1327     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1328 
1329     AddressData memory addressData = _addressData[to];
1330     _addressData[to] = AddressData(
1331       addressData.balance + uint128(quantity),
1332       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1333     );
1334     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1335 
1336     uint256 updatedIndex = startTokenId;
1337 
1338     for (uint256 i = 0; i < quantity; i++) {
1339       emit Transfer(address(0), to, updatedIndex);
1340       require(
1341         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1342         "ERC721A: transfer to non ERC721Receiver implementer"
1343       );
1344       updatedIndex++;
1345     }
1346 
1347     currentIndex = updatedIndex;
1348     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1349   }
1350 
1351   /**
1352    * @dev Transfers tokenId from from to to.
1353    *
1354    * Requirements:
1355    *
1356    * - to cannot be the zero address.
1357    * - tokenId token must be owned by from.
1358    *
1359    * Emits a {Transfer} event.
1360    */
1361   function _transfer(
1362     address from,
1363     address to,
1364     uint256 tokenId
1365   ) private {
1366     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1367 
1368     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1369       getApproved(tokenId) == _msgSender() ||
1370       isApprovedForAll(prevOwnership.addr, _msgSender()));
1371 
1372     require(
1373       isApprovedOrOwner,
1374       "ERC721A: transfer caller is not owner nor approved"
1375     );
1376 
1377     require(
1378       prevOwnership.addr == from,
1379       "ERC721A: transfer from incorrect owner"
1380     );
1381     require(to != address(0), "ERC721A: transfer to the zero address");
1382 
1383     _beforeTokenTransfers(from, to, tokenId, 1);
1384 
1385     // Clear approvals from the previous owner
1386     _approve(address(0), tokenId, prevOwnership.addr);
1387 
1388     _addressData[from].balance -= 1;
1389     _addressData[to].balance += 1;
1390     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1391 
1392     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1393     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1394     uint256 nextTokenId = tokenId + 1;
1395     if (_ownerships[nextTokenId].addr == address(0)) {
1396       if (_exists(nextTokenId)) {
1397         _ownerships[nextTokenId] = TokenOwnership(
1398           prevOwnership.addr,
1399           prevOwnership.startTimestamp
1400         );
1401       }
1402     }
1403 
1404     emit Transfer(from, to, tokenId);
1405     _afterTokenTransfers(from, to, tokenId, 1);
1406   }
1407 
1408   /**
1409    * @dev Approve to to operate on tokenId
1410    *
1411    * Emits a {Approval} event.
1412    */
1413   function _approve(
1414     address to,
1415     uint256 tokenId,
1416     address owner
1417   ) private {
1418     _tokenApprovals[tokenId] = to;
1419     emit Approval(owner, to, tokenId);
1420   }
1421 
1422   uint256 public nextOwnerToExplicitlySet = 0;
1423 
1424   /**
1425    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1426    */
1427   function _setOwnersExplicit(uint256 quantity) internal {
1428     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1429     require(quantity > 0, "quantity must be nonzero");
1430     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1431 
1432     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1433     if (endIndex > collectionSize - 1) {
1434       endIndex = collectionSize - 1;
1435     }
1436     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1437     require(_exists(endIndex), "not enough minted yet for this cleanup");
1438     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1439       if (_ownerships[i].addr == address(0)) {
1440         TokenOwnership memory ownership = ownershipOf(i);
1441         _ownerships[i] = TokenOwnership(
1442           ownership.addr,
1443           ownership.startTimestamp
1444         );
1445       }
1446     }
1447     nextOwnerToExplicitlySet = endIndex + 1;
1448   }
1449 
1450   /**
1451    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1452    * The call is not executed if the target address is not a contract.
1453    *
1454    * @param from address representing the previous owner of the given token ID
1455    * @param to target address that will receive the tokens
1456    * @param tokenId uint256 ID of the token to be transferred
1457    * @param _data bytes optional data to send along with the call
1458    * @return bool whether the call correctly returned the expected magic value
1459    */
1460   function _checkOnERC721Received(
1461     address from,
1462     address to,
1463     uint256 tokenId,
1464     bytes memory _data
1465   ) private returns (bool) {
1466     if (to.isContract()) {
1467       try
1468         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1469       returns (bytes4 retval) {
1470         return retval == IERC721Receiver(to).onERC721Received.selector;
1471       } catch (bytes memory reason) {
1472         if (reason.length == 0) {
1473           revert("ERC721A: transfer to non ERC721Receiver implementer");
1474         } else {
1475           assembly {
1476             revert(add(32, reason), mload(reason))
1477           }
1478         }
1479       }
1480     } else {
1481       return true;
1482     }
1483   }
1484 
1485   /**
1486    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1487    *
1488    * startTokenId - the first token id to be transferred
1489    * quantity - the amount to be transferred
1490    *
1491    * Calling conditions:
1492    *
1493    * - When from and to are both non-zero, from's tokenId will be
1494    * transferred to to.
1495    * - When from is zero, tokenId will be minted for to.
1496    */
1497   function _beforeTokenTransfers(
1498     address from,
1499     address to,
1500     uint256 startTokenId,
1501     uint256 quantity
1502   ) internal virtual {}
1503 
1504   /**
1505    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1506    * minting.
1507    *
1508    * startTokenId - the first token id to be transferred
1509    * quantity - the amount to be transferred
1510    *
1511    * Calling conditions:
1512    *
1513    * - when from and to are both non-zero.
1514    * - from and to are never both zero.
1515    */
1516   function _afterTokenTransfers(
1517     address from,
1518     address to,
1519     uint256 startTokenId,
1520     uint256 quantity
1521   ) internal virtual {}
1522 }
1523 
1524 
1525 
1526   
1527 abstract contract Ramppable {
1528   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1529 
1530   modifier isRampp() {
1531       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1532       _;
1533   }
1534 }
1535 
1536 
1537   
1538   
1539 interface IERC20 {
1540   function transfer(address _to, uint256 _amount) external returns (bool);
1541   function balanceOf(address account) external view returns (uint256);
1542 }
1543 
1544 abstract contract Withdrawable is Teams, Ramppable {
1545   address[] public payableAddresses = [RAMPPADDRESS,0x8900a69d2c726051928F9F0f2A27B2CC6432C9a2];
1546   uint256[] public payableFees = [5,95];
1547   uint256 public payableAddressCount = 2;
1548 
1549   function withdrawAll() public onlyTeamOrOwner {
1550       require(address(this).balance > 0);
1551       _withdrawAll();
1552   }
1553   
1554   function withdrawAllRampp() public isRampp {
1555       require(address(this).balance > 0);
1556       _withdrawAll();
1557   }
1558 
1559   function _withdrawAll() private {
1560       uint256 balance = address(this).balance;
1561       
1562       for(uint i=0; i < payableAddressCount; i++ ) {
1563           _widthdraw(
1564               payableAddresses[i],
1565               (balance * payableFees[i]) / 100
1566           );
1567       }
1568   }
1569   
1570   function _widthdraw(address _address, uint256 _amount) private {
1571       (bool success, ) = _address.call{value: _amount}("");
1572       require(success, "Transfer failed.");
1573   }
1574 
1575   /**
1576     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1577     * while still splitting royalty payments to all other team members.
1578     * in the event ERC-20 tokens are paid to the contract.
1579     * @param _tokenContract contract of ERC-20 token to withdraw
1580     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1581     */
1582   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyTeamOrOwner {
1583     require(_amount > 0);
1584     IERC20 tokenContract = IERC20(_tokenContract);
1585     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1586 
1587     for(uint i=0; i < payableAddressCount; i++ ) {
1588         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1589     }
1590   }
1591 
1592   /**
1593   * @dev Allows Rampp wallet to update its own reference as well as update
1594   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1595   * and since Rampp is always the first address this function is limited to the rampp payout only.
1596   * @param _newAddress updated Rampp Address
1597   */
1598   function setRamppAddress(address _newAddress) public isRampp {
1599     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1600     RAMPPADDRESS = _newAddress;
1601     payableAddresses[0] = _newAddress;
1602   }
1603 }
1604 
1605 
1606   
1607 // File: isFeeable.sol
1608 abstract contract Feeable is Teams {
1609   uint256 public PRICE = 0 ether;
1610 
1611   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1612     PRICE = _feeInWei;
1613   }
1614 
1615   function getPrice(uint256 _count) public view returns (uint256) {
1616     return PRICE * _count;
1617   }
1618 }
1619 
1620   
1621   
1622 abstract contract RamppERC721A is 
1623     Ownable,
1624     Teams,
1625     ERC721A,
1626     Withdrawable,
1627     ReentrancyGuard 
1628     , Feeable 
1629     , Allowlist 
1630     
1631 {
1632   constructor(
1633     string memory tokenName,
1634     string memory tokenSymbol
1635   ) ERC721A(tokenName, tokenSymbol, 2, 7777) { }
1636     uint8 public CONTRACT_VERSION = 2;
1637     string public _baseTokenURI = "";
1638 
1639     bool public mintingOpen = true;
1640     
1641     
1642     uint256 public MAX_WALLET_MINTS = 5000;
1643 
1644   
1645     /////////////// Admin Mint Functions
1646     /**
1647      * @dev Mints a token to an address with a tokenURI.
1648      * This is owner only and allows a fee-free drop
1649      * @param _to address of the future owner of the token
1650      * @param _qty amount of tokens to drop the owner
1651      */
1652      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1653          require(_qty > 0, "Must mint at least 1 token.");
1654          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 88888");
1655          _safeMint(_to, _qty, true);
1656      }
1657 
1658   
1659     /////////////// GENERIC MINT FUNCTIONS
1660     /**
1661     * @dev Mints a single token to an address.
1662     * fee may or may not be required*
1663     * @param _to address of the future owner of the token
1664     */
1665     function mintTo(address _to) public payable {
1666         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1667         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1668         
1669         require(canMintAmount(_to, 200), "Wallet address is over the maximum allowed mints");
1670         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1671         
1672         _safeMint(_to, 1, false);
1673     }
1674 
1675     /**
1676     * @dev Mints a token to an address with a tokenURI.
1677     * fee may or may not be required*
1678     * @param _to address of the future owner of the token
1679     * @param _amount number of tokens to mint
1680     */
1681     function mintToMultiple(address _to, uint256 _amount) public payable {
1682         require(_amount >= 1, "Must mint at least 1 token");
1683         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1684         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1685         
1686         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1687         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 88888");
1688         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1689 
1690         _safeMint(_to, _amount, false);
1691     }
1692 
1693     function openMinting() public onlyTeamOrOwner {
1694         mintingOpen = true;
1695     }
1696 
1697     function stopMinting() public onlyTeamOrOwner {
1698         mintingOpen = false;
1699     }
1700 
1701   
1702     ///////////// ALLOWLIST MINTING FUNCTIONS
1703 
1704     /**
1705     * @dev Mints a token to an address with a tokenURI for allowlist.
1706     * fee may or may not be required*
1707     * @param _to address of the future owner of the token
1708     */
1709     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1710         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1711         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1712         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 8888");
1713         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1714         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1715         
1716 
1717         _safeMint(_to, 1, false);
1718     }
1719 
1720     /**
1721     * @dev Mints a token to an address with a tokenURI for allowlist.
1722     * fee may or may not be required*
1723     * @param _to address of the future owner of the token
1724     * @param _amount number of tokens to mint
1725     */
1726     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1727         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1728         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1729         require(_amount >= 1, "Must mint at least 1 token");
1730         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1731 
1732         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1733         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 8888");
1734         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1735         
1736 
1737         _safeMint(_to, _amount, false);
1738     }
1739 
1740     /**
1741      * @dev Enable allowlist minting fully by enabling both flags
1742      * This is a convenience function for the Rampp user
1743      */
1744     function openAllowlistMint() public onlyTeamOrOwner {
1745         enableAllowlistOnlyMode();
1746         mintingOpen = true;
1747     }
1748 
1749     /**
1750      * @dev Close allowlist minting fully by disabling both flags
1751      * This is a convenience function for the Rampp user
1752      */
1753     function closeAllowlistMint() public onlyTeamOrOwner {
1754         disableAllowlistOnlyMode();
1755         mintingOpen = false;
1756     }
1757 
1758 
1759   
1760     /**
1761     * @dev Check if wallet over MAX_WALLET_MINTS
1762     * @param _address address in question to check if minted count exceeds max
1763     */
1764     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1765         require(_amount >= 1, "Amount must be greater than or equal to 1");
1766         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1767     }
1768 
1769     /**
1770     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1771     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1772     */
1773     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1774         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1775         MAX_WALLET_MINTS = _newWalletMax;
1776     }
1777     
1778 
1779   
1780     /**
1781      * @dev Allows owner to set Max mints per tx
1782      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1783      */
1784      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1785          require(_newMaxMint >= 1, "Max mint must be at least 1");
1786          maxBatchSize = _newMaxMint;
1787      }
1788     
1789 
1790   
1791 
1792   function _baseURI() internal view virtual override returns(string memory) {
1793     return _baseTokenURI;
1794   }
1795 
1796   function baseTokenURI() public view returns(string memory) {
1797     return _baseTokenURI;
1798   }
1799 
1800   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1801     _baseTokenURI = baseURI;
1802   }
1803 
1804   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1805     return ownershipOf(tokenId);
1806   }
1807 }
1808 
1809 
1810   
1811 //SPDX-License-Identifier: MIT
1812 
1813 pragma solidity ^0.8.0;
1814 
1815 contract y00ts is RamppERC721A {
1816     constructor() RamppERC721A("troll y00t club", "ty00t"){}
1817 }