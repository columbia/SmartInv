1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 // ██████  ███████ ██   ██ ██████  ██ ████████ ███████ 
6 // ██   ██ ██       ██ ██  ██   ██ ██    ██    ██      
7 // ██████  █████     ███   ██████  ██    ██    ███████ 
8 // ██   ██ ██       ██ ██  ██   ██ ██    ██         ██ 
9 // ██   ██ ███████ ██   ██ ██████  ██    ██    ███████ 
10 //                                                     
11 //                                                     
12 //
13 //
14 //*********************************************************************//
15 //*********************************************************************//
16   
17 //-------------DEPENDENCIES--------------------------//
18 
19 // File: @openzeppelin/contracts/utils/Address.sol
20 
21 
22 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
23 
24 pragma solidity ^0.8.1;
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if account is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, isContract will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      *
47      * [IMPORTANT]
48      * ====
49      * You shouldn't rely on isContract to protect against flash loan attacks!
50      *
51      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
52      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
53      * constructor.
54      * ====
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies on extcodesize/address.code.length, which returns 0
58         // for contracts in construction, since the code is only stored at the end
59         // of the constructor execution.
60 
61         return account.code.length > 0;
62     }
63 
64     /**
65      * @dev Replacement for Solidity's transfer: sends amount wei to
66      * recipient, forwarding all available gas and reverting on errors.
67      *
68      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
69      * of certain opcodes, possibly making contracts go over the 2300 gas limit
70      * imposed by transfer, making them unable to receive funds via
71      * transfer. {sendValue} removes this limitation.
72      *
73      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
74      *
75      * IMPORTANT: because control is transferred to recipient, care must be
76      * taken to not create reentrancy vulnerabilities. Consider using
77      * {ReentrancyGuard} or the
78      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
79      */
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82 
83         (bool success, ) = recipient.call{value: amount}("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     /**
88      * @dev Performs a Solidity function call using a low level call. A
89      * plain call is an unsafe replacement for a function call: use this
90      * function instead.
91      *
92      * If target reverts with a revert reason, it is bubbled up by this
93      * function (like regular Solidity function calls).
94      *
95      * Returns the raw returned data. To convert to the expected return value,
96      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
97      *
98      * Requirements:
99      *
100      * - target must be a contract.
101      * - calling target with data must not revert.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
111      * errorMessage as a fallback revert reason when target reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(
116         address target,
117         bytes memory data,
118         string memory errorMessage
119     ) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
125      * but also transferring value wei to target.
126      *
127      * Requirements:
128      *
129      * - the calling contract must have an ETH balance of at least value.
130      * - the called Solidity function must be payable.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(
135         address target,
136         bytes memory data,
137         uint256 value
138     ) internal returns (bytes memory) {
139         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
144      * with errorMessage as a fallback revert reason when target reverts.
145      *
146      * _Available since v3.1._
147      */
148     function functionCallWithValue(
149         address target,
150         bytes memory data,
151         uint256 value,
152         string memory errorMessage
153     ) internal returns (bytes memory) {
154         require(address(this).balance >= value, "Address: insufficient balance for call");
155         require(isContract(target), "Address: call to non-contract");
156 
157         (bool success, bytes memory returndata) = target.call{value: value}(data);
158         return verifyCallResult(success, returndata, errorMessage);
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
168         return functionStaticCall(target, data, "Address: low-level static call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
173      * but performing a static call.
174      *
175      * _Available since v3.3._
176      */
177     function functionStaticCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal view returns (bytes memory) {
182         require(isContract(target), "Address: static call to non-contract");
183 
184         (bool success, bytes memory returndata) = target.staticcall(data);
185         return verifyCallResult(success, returndata, errorMessage);
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
195         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
196     }
197 
198     /**
199      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
200      * but performing a delegate call.
201      *
202      * _Available since v3.4._
203      */
204     function functionDelegateCall(
205         address target,
206         bytes memory data,
207         string memory errorMessage
208     ) internal returns (bytes memory) {
209         require(isContract(target), "Address: delegate call to non-contract");
210 
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     /**
216      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
217      * revert reason using the provided one.
218      *
219      * _Available since v4.3._
220      */
221     function verifyCallResult(
222         bool success,
223         bytes memory returndata,
224         string memory errorMessage
225     ) internal pure returns (bytes memory) {
226         if (success) {
227             return returndata;
228         } else {
229             // Look for revert reason and bubble it up if present
230             if (returndata.length > 0) {
231                 // The easiest way to bubble the revert reason is using memory via assembly
232 
233                 assembly {
234                     let returndata_size := mload(returndata)
235                     revert(add(32, returndata), returndata_size)
236                 }
237             } else {
238                 revert(errorMessage);
239             }
240         }
241     }
242 }
243 
244 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @title ERC721 token receiver interface
253  * @dev Interface for any contract that wants to support safeTransfers
254  * from ERC721 asset contracts.
255  */
256 interface IERC721Receiver {
257     /**
258      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
259      * by operator from from, this function is called.
260      *
261      * It must return its Solidity selector to confirm the token transfer.
262      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
263      *
264      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
265      */
266     function onERC721Received(
267         address operator,
268         address from,
269         uint256 tokenId,
270         bytes calldata data
271     ) external returns (bytes4);
272 }
273 
274 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
275 
276 
277 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Interface of the ERC165 standard, as defined in the
283  * https://eips.ethereum.org/EIPS/eip-165[EIP].
284  *
285  * Implementers can declare support of contract interfaces, which can then be
286  * queried by others ({ERC165Checker}).
287  *
288  * For an implementation, see {ERC165}.
289  */
290 interface IERC165 {
291     /**
292      * @dev Returns true if this contract implements the interface defined by
293      * interfaceId. See the corresponding
294      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
295      * to learn more about how these ids are created.
296      *
297      * This function call must use less than 30 000 gas.
298      */
299     function supportsInterface(bytes4 interfaceId) external view returns (bool);
300 }
301 
302 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Implementation of the {IERC165} interface.
312  *
313  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
314  * for the additional interface id that will be supported. For example:
315  *
316  * solidity
317  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
319  * }
320  * 
321  *
322  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
323  */
324 abstract contract ERC165 is IERC165 {
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      */
328     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
329         return interfaceId == type(IERC165).interfaceId;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
334 
335 
336 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Required interface of an ERC721 compliant contract.
343  */
344 interface IERC721 is IERC165 {
345     /**
346      * @dev Emitted when tokenId token is transferred from from to to.
347      */
348     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
349 
350     /**
351      * @dev Emitted when owner enables approved to manage the tokenId token.
352      */
353     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
354 
355     /**
356      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
357      */
358     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
359 
360     /**
361      * @dev Returns the number of tokens in owner's account.
362      */
363     function balanceOf(address owner) external view returns (uint256 balance);
364 
365     /**
366      * @dev Returns the owner of the tokenId token.
367      *
368      * Requirements:
369      *
370      * - tokenId must exist.
371      */
372     function ownerOf(uint256 tokenId) external view returns (address owner);
373 
374     /**
375      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
376      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
377      *
378      * Requirements:
379      *
380      * - from cannot be the zero address.
381      * - to cannot be the zero address.
382      * - tokenId token must exist and be owned by from.
383      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
384      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
385      *
386      * Emits a {Transfer} event.
387      */
388     function safeTransferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) external;
393 
394     /**
395      * @dev Transfers tokenId token from from to to.
396      *
397      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
398      *
399      * Requirements:
400      *
401      * - from cannot be the zero address.
402      * - to cannot be the zero address.
403      * - tokenId token must be owned by from.
404      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transferFrom(
409         address from,
410         address to,
411         uint256 tokenId
412     ) external;
413 
414     /**
415      * @dev Gives permission to to to transfer tokenId token to another account.
416      * The approval is cleared when the token is transferred.
417      *
418      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
419      *
420      * Requirements:
421      *
422      * - The caller must own the token or be an approved operator.
423      * - tokenId must exist.
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address to, uint256 tokenId) external;
428 
429     /**
430      * @dev Returns the account approved for tokenId token.
431      *
432      * Requirements:
433      *
434      * - tokenId must exist.
435      */
436     function getApproved(uint256 tokenId) external view returns (address operator);
437 
438     /**
439      * @dev Approve or remove operator as an operator for the caller.
440      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
441      *
442      * Requirements:
443      *
444      * - The operator cannot be the caller.
445      *
446      * Emits an {ApprovalForAll} event.
447      */
448     function setApprovalForAll(address operator, bool _approved) external;
449 
450     /**
451      * @dev Returns if the operator is allowed to manage all of the assets of owner.
452      *
453      * See {setApprovalForAll}
454      */
455     function isApprovedForAll(address owner, address operator) external view returns (bool);
456 
457     /**
458      * @dev Safely transfers tokenId token from from to to.
459      *
460      * Requirements:
461      *
462      * - from cannot be the zero address.
463      * - to cannot be the zero address.
464      * - tokenId token must exist and be owned by from.
465      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
466      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId,
474         bytes calldata data
475     ) external;
476 }
477 
478 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
479 
480 
481 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
482 
483 pragma solidity ^0.8.0;
484 
485 
486 /**
487  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
488  * @dev See https://eips.ethereum.org/EIPS/eip-721
489  */
490 interface IERC721Enumerable is IERC721 {
491     /**
492      * @dev Returns the total amount of tokens stored by the contract.
493      */
494     function totalSupply() external view returns (uint256);
495 
496     /**
497      * @dev Returns a token ID owned by owner at a given index of its token list.
498      * Use along with {balanceOf} to enumerate all of owner's tokens.
499      */
500     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
501 
502     /**
503      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
504      * Use along with {totalSupply} to enumerate all tokens.
505      */
506     function tokenByIndex(uint256 index) external view returns (uint256);
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Metadata is IERC721 {
522     /**
523      * @dev Returns the token collection name.
524      */
525     function name() external view returns (string memory);
526 
527     /**
528      * @dev Returns the token collection symbol.
529      */
530     function symbol() external view returns (string memory);
531 
532     /**
533      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
534      */
535     function tokenURI(uint256 tokenId) external view returns (string memory);
536 }
537 
538 // File: @openzeppelin/contracts/utils/Strings.sol
539 
540 
541 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @dev String operations.
547  */
548 library Strings {
549     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
550 
551     /**
552      * @dev Converts a uint256 to its ASCII string decimal representation.
553      */
554     function toString(uint256 value) internal pure returns (string memory) {
555         // Inspired by OraclizeAPI's implementation - MIT licence
556         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
557 
558         if (value == 0) {
559             return "0";
560         }
561         uint256 temp = value;
562         uint256 digits;
563         while (temp != 0) {
564             digits++;
565             temp /= 10;
566         }
567         bytes memory buffer = new bytes(digits);
568         while (value != 0) {
569             digits -= 1;
570             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
571             value /= 10;
572         }
573         return string(buffer);
574     }
575 
576     /**
577      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
578      */
579     function toHexString(uint256 value) internal pure returns (string memory) {
580         if (value == 0) {
581             return "0x00";
582         }
583         uint256 temp = value;
584         uint256 length = 0;
585         while (temp != 0) {
586             length++;
587             temp >>= 8;
588         }
589         return toHexString(value, length);
590     }
591 
592     /**
593      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
594      */
595     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
596         bytes memory buffer = new bytes(2 * length + 2);
597         buffer[0] = "0";
598         buffer[1] = "x";
599         for (uint256 i = 2 * length + 1; i > 1; --i) {
600             buffer[i] = _HEX_SYMBOLS[value & 0xf];
601             value >>= 4;
602         }
603         require(value == 0, "Strings: hex length insufficient");
604         return string(buffer);
605     }
606 }
607 
608 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
609 
610 
611 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @dev Contract module that helps prevent reentrant calls to a function.
617  *
618  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
619  * available, which can be applied to functions to make sure there are no nested
620  * (reentrant) calls to them.
621  *
622  * Note that because there is a single nonReentrant guard, functions marked as
623  * nonReentrant may not call one another. This can be worked around by making
624  * those functions private, and then adding external nonReentrant entry
625  * points to them.
626  *
627  * TIP: If you would like to learn more about reentrancy and alternative ways
628  * to protect against it, check out our blog post
629  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
630  */
631 abstract contract ReentrancyGuard {
632     // Booleans are more expensive than uint256 or any type that takes up a full
633     // word because each write operation emits an extra SLOAD to first read the
634     // slot's contents, replace the bits taken up by the boolean, and then write
635     // back. This is the compiler's defense against contract upgrades and
636     // pointer aliasing, and it cannot be disabled.
637 
638     // The values being non-zero value makes deployment a bit more expensive,
639     // but in exchange the refund on every call to nonReentrant will be lower in
640     // amount. Since refunds are capped to a percentage of the total
641     // transaction's gas, it is best to keep them low in cases like this one, to
642     // increase the likelihood of the full refund coming into effect.
643     uint256 private constant _NOT_ENTERED = 1;
644     uint256 private constant _ENTERED = 2;
645 
646     uint256 private _status;
647 
648     constructor() {
649         _status = _NOT_ENTERED;
650     }
651 
652     /**
653      * @dev Prevents a contract from calling itself, directly or indirectly.
654      * Calling a nonReentrant function from another nonReentrant
655      * function is not supported. It is possible to prevent this from happening
656      * by making the nonReentrant function external, and making it call a
657      * private function that does the actual work.
658      */
659     modifier nonReentrant() {
660         // On the first call to nonReentrant, _notEntered will be true
661         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
662 
663         // Any calls to nonReentrant after this point will fail
664         _status = _ENTERED;
665 
666         _;
667 
668         // By storing the original value once again, a refund is triggered (see
669         // https://eips.ethereum.org/EIPS/eip-2200)
670         _status = _NOT_ENTERED;
671     }
672 }
673 
674 // File: @openzeppelin/contracts/utils/Context.sol
675 
676 
677 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 /**
682  * @dev Provides information about the current execution context, including the
683  * sender of the transaction and its data. While these are generally available
684  * via msg.sender and msg.data, they should not be accessed in such a direct
685  * manner, since when dealing with meta-transactions the account sending and
686  * paying for execution may not be the actual sender (as far as an application
687  * is concerned).
688  *
689  * This contract is only required for intermediate, library-like contracts.
690  */
691 abstract contract Context {
692     function _msgSender() internal view virtual returns (address) {
693         return msg.sender;
694     }
695 
696     function _msgData() internal view virtual returns (bytes calldata) {
697         return msg.data;
698     }
699 }
700 
701 // File: @openzeppelin/contracts/access/Ownable.sol
702 
703 
704 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 
709 /**
710  * @dev Contract module which provides a basic access control mechanism, where
711  * there is an account (an owner) that can be granted exclusive access to
712  * specific functions.
713  *
714  * By default, the owner account will be the one that deploys the contract. This
715  * can later be changed with {transferOwnership}.
716  *
717  * This module is used through inheritance. It will make available the modifier
718  * onlyOwner, which can be applied to your functions to restrict their use to
719  * the owner.
720  */
721 abstract contract Ownable is Context {
722     address private _owner;
723 
724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
725 
726     /**
727      * @dev Initializes the contract setting the deployer as the initial owner.
728      */
729     constructor() {
730         _transferOwnership(_msgSender());
731     }
732 
733     /**
734      * @dev Returns the address of the current owner.
735      */
736     function owner() public view virtual returns (address) {
737         return _owner;
738     }
739 
740     /**
741      * @dev Throws if called by any account other than the owner.
742      */
743     function _onlyOwner() private view {
744        require(owner() == _msgSender(), "Ownable: caller is not the owner");
745     }
746 
747     modifier onlyOwner() {
748         _onlyOwner();
749         _;
750     }
751 
752     /**
753      * @dev Leaves the contract without owner. It will not be possible to call
754      * onlyOwner functions anymore. Can only be called by the current owner.
755      *
756      * NOTE: Renouncing ownership will leave the contract without an owner,
757      * thereby removing any functionality that is only available to the owner.
758      */
759     function renounceOwnership() public virtual onlyOwner {
760         _transferOwnership(address(0));
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (newOwner).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         _transferOwnership(newOwner);
770     }
771 
772     /**
773      * @dev Transfers ownership of the contract to a new account (newOwner).
774      * Internal function without access restriction.
775      */
776     function _transferOwnership(address newOwner) internal virtual {
777         address oldOwner = _owner;
778         _owner = newOwner;
779         emit OwnershipTransferred(oldOwner, newOwner);
780     }
781 }
782 
783 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
784 pragma solidity ^0.8.9;
785 
786 interface IOperatorFilterRegistry {
787     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
788     function register(address registrant) external;
789     function registerAndSubscribe(address registrant, address subscription) external;
790     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
791     function updateOperator(address registrant, address operator, bool filtered) external;
792     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
793     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
794     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
795     function subscribe(address registrant, address registrantToSubscribe) external;
796     function unsubscribe(address registrant, bool copyExistingEntries) external;
797     function subscriptionOf(address addr) external returns (address registrant);
798     function subscribers(address registrant) external returns (address[] memory);
799     function subscriberAt(address registrant, uint256 index) external returns (address);
800     function copyEntriesOf(address registrant, address registrantToCopy) external;
801     function isOperatorFiltered(address registrant, address operator) external returns (bool);
802     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
803     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
804     function filteredOperators(address addr) external returns (address[] memory);
805     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
806     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
807     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
808     function isRegistered(address addr) external returns (bool);
809     function codeHashOf(address addr) external returns (bytes32);
810 }
811 
812 // File contracts/OperatorFilter/OperatorFilterer.sol
813 pragma solidity ^0.8.9;
814 
815 abstract contract OperatorFilterer {
816     error OperatorNotAllowed(address operator);
817 
818     IOperatorFilterRegistry constant operatorFilterRegistry =
819         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
820 
821     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
822         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
823         // will not revert, but the contract will need to be registered with the registry once it is deployed in
824         // order for the modifier to filter addresses.
825         if (address(operatorFilterRegistry).code.length > 0) {
826             if (subscribe) {
827                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
828             } else {
829                 if (subscriptionOrRegistrantToCopy != address(0)) {
830                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
831                 } else {
832                     operatorFilterRegistry.register(address(this));
833                 }
834             }
835         }
836     }
837 
838     function _onlyAllowedOperator(address from) private view {
839       if (
840           !(
841               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
842               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
843           )
844       ) {
845           revert OperatorNotAllowed(msg.sender);
846       }
847     }
848 
849     modifier onlyAllowedOperator(address from) virtual {
850         // Check registry code length to facilitate testing in environments without a deployed registry.
851         if (address(operatorFilterRegistry).code.length > 0) {
852             // Allow spending tokens from addresses with balance
853             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
854             // from an EOA.
855             if (from == msg.sender) {
856                 _;
857                 return;
858             }
859             _onlyAllowedOperator(from);
860         }
861         _;
862     }
863 
864     modifier onlyAllowedOperatorApproval(address operator) virtual {
865         _checkFilterOperator(operator);
866         _;
867     }
868 
869     function _checkFilterOperator(address operator) internal view virtual {
870         // Check registry code length to facilitate testing in environments without a deployed registry.
871         if (address(operatorFilterRegistry).code.length > 0) {
872             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
873                 revert OperatorNotAllowed(operator);
874             }
875         }
876     }
877 }
878 
879 //-------------END DEPENDENCIES------------------------//
880 
881 
882   
883 error TransactionCapExceeded();
884 error PublicMintingClosed();
885 error ExcessiveOwnedMints();
886 error MintZeroQuantity();
887 error InvalidPayment();
888 error CapExceeded();
889 error IsAlreadyUnveiled();
890 error ValueCannotBeZero();
891 error CannotBeNullAddress();
892 error NoStateChange();
893 
894 error PublicMintClosed();
895 error AllowlistMintClosed();
896 
897 error AddressNotAllowlisted();
898 error AllowlistDropTimeHasNotPassed();
899 error PublicDropTimeHasNotPassed();
900 error DropTimeNotInFuture();
901 
902 error OnlyERC20MintingEnabled();
903 error ERC20TokenNotApproved();
904 error ERC20InsufficientBalance();
905 error ERC20InsufficientAllowance();
906 error ERC20TransferFailed();
907 
908 error ClaimModeDisabled();
909 error IneligibleRedemptionContract();
910 error TokenAlreadyRedeemed();
911 error InvalidOwnerForRedemption();
912 error InvalidApprovalForRedemption();
913 
914 error ERC721RestrictedApprovalAddressRestricted();
915 error NotMaintainer();
916   
917   
918 // Rampp Contracts v2.1 (Teams.sol)
919 
920 error InvalidTeamAddress();
921 error DuplicateTeamAddress();
922 pragma solidity ^0.8.0;
923 
924 /**
925 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
926 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
927 * This will easily allow cross-collaboration via Mintplex.xyz.
928 **/
929 abstract contract Teams is Ownable{
930   mapping (address => bool) internal team;
931 
932   /**
933   * @dev Adds an address to the team. Allows them to execute protected functions
934   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
935   **/
936   function addToTeam(address _address) public onlyOwner {
937     if(_address == address(0)) revert InvalidTeamAddress();
938     if(inTeam(_address)) revert DuplicateTeamAddress();
939   
940     team[_address] = true;
941   }
942 
943   /**
944   * @dev Removes an address to the team.
945   * @param _address the ETH address to remove, cannot be 0x and must be in team
946   **/
947   function removeFromTeam(address _address) public onlyOwner {
948     if(_address == address(0)) revert InvalidTeamAddress();
949     if(!inTeam(_address)) revert InvalidTeamAddress();
950   
951     team[_address] = false;
952   }
953 
954   /**
955   * @dev Check if an address is valid and active in the team
956   * @param _address ETH address to check for truthiness
957   **/
958   function inTeam(address _address)
959     public
960     view
961     returns (bool)
962   {
963     if(_address == address(0)) revert InvalidTeamAddress();
964     return team[_address] == true;
965   }
966 
967   /**
968   * @dev Throws if called by any account other than the owner or team member.
969   */
970   function _onlyTeamOrOwner() private view {
971     bool _isOwner = owner() == _msgSender();
972     bool _isTeam = inTeam(_msgSender());
973     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
974   }
975 
976   modifier onlyTeamOrOwner() {
977     _onlyTeamOrOwner();
978     _;
979   }
980 }
981 
982 
983   
984   
985 /**
986  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
987  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
988  *
989  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
990  * 
991  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
992  *
993  * Does not support burning tokens to address(0).
994  */
995 contract ERC721A is
996   Context,
997   ERC165,
998   IERC721,
999   IERC721Metadata,
1000   IERC721Enumerable,
1001   Teams
1002   , OperatorFilterer
1003 {
1004   using Address for address;
1005   using Strings for uint256;
1006 
1007   struct TokenOwnership {
1008     address addr;
1009     uint64 startTimestamp;
1010   }
1011 
1012   struct AddressData {
1013     uint128 balance;
1014     uint128 numberMinted;
1015   }
1016 
1017   uint256 private currentIndex;
1018 
1019   uint256 public immutable collectionSize;
1020   uint256 public maxBatchSize;
1021 
1022   // Token name
1023   string private _name;
1024 
1025   // Token symbol
1026   string private _symbol;
1027 
1028   // Mapping from token ID to ownership details
1029   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1030   mapping(uint256 => TokenOwnership) private _ownerships;
1031 
1032   // Mapping owner address to address data
1033   mapping(address => AddressData) private _addressData;
1034 
1035   // Mapping from token ID to approved address
1036   mapping(uint256 => address) private _tokenApprovals;
1037 
1038   // Mapping from owner to operator approvals
1039   mapping(address => mapping(address => bool)) private _operatorApprovals;
1040 
1041   /* @dev Mapping of restricted operator approvals set by contract Owner
1042   * This serves as an optional addition to ERC-721 so
1043   * that the contract owner can elect to prevent specific addresses/contracts
1044   * from being marked as the approver for a token. The reason for this
1045   * is that some projects may want to retain control of where their tokens can/can not be listed
1046   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1047   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1048   */
1049   mapping(address => bool) public restrictedApprovalAddresses;
1050 
1051   /**
1052    * @dev
1053    * maxBatchSize refers to how much a minter can mint at a time.
1054    * collectionSize_ refers to how many tokens are in the collection.
1055    */
1056   constructor(
1057     string memory name_,
1058     string memory symbol_,
1059     uint256 maxBatchSize_,
1060     uint256 collectionSize_
1061   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1062     require(
1063       collectionSize_ > 0,
1064       "ERC721A: collection must have a nonzero supply"
1065     );
1066     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1067     _name = name_;
1068     _symbol = symbol_;
1069     maxBatchSize = maxBatchSize_;
1070     collectionSize = collectionSize_;
1071     currentIndex = _startTokenId();
1072   }
1073 
1074   /**
1075   * To change the starting tokenId, please override this function.
1076   */
1077   function _startTokenId() internal view virtual returns (uint256) {
1078     return 1;
1079   }
1080 
1081   /**
1082    * @dev See {IERC721Enumerable-totalSupply}.
1083    */
1084   function totalSupply() public view override returns (uint256) {
1085     return _totalMinted();
1086   }
1087 
1088   function currentTokenId() public view returns (uint256) {
1089     return _totalMinted();
1090   }
1091 
1092   function getNextTokenId() public view returns (uint256) {
1093       return _totalMinted() + 1;
1094   }
1095 
1096   /**
1097   * Returns the total amount of tokens minted in the contract.
1098   */
1099   function _totalMinted() internal view returns (uint256) {
1100     unchecked {
1101       return currentIndex - _startTokenId();
1102     }
1103   }
1104 
1105   /**
1106    * @dev See {IERC721Enumerable-tokenByIndex}.
1107    */
1108   function tokenByIndex(uint256 index) public view override returns (uint256) {
1109     require(index < totalSupply(), "ERC721A: global index out of bounds");
1110     return index;
1111   }
1112 
1113   /**
1114    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1115    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1116    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1117    */
1118   function tokenOfOwnerByIndex(address owner, uint256 index)
1119     public
1120     view
1121     override
1122     returns (uint256)
1123   {
1124     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1125     uint256 numMintedSoFar = totalSupply();
1126     uint256 tokenIdsIdx = 0;
1127     address currOwnershipAddr = address(0);
1128     for (uint256 i = 0; i < numMintedSoFar; i++) {
1129       TokenOwnership memory ownership = _ownerships[i];
1130       if (ownership.addr != address(0)) {
1131         currOwnershipAddr = ownership.addr;
1132       }
1133       if (currOwnershipAddr == owner) {
1134         if (tokenIdsIdx == index) {
1135           return i;
1136         }
1137         tokenIdsIdx++;
1138       }
1139     }
1140     revert("ERC721A: unable to get token of owner by index");
1141   }
1142 
1143   /**
1144    * @dev See {IERC165-supportsInterface}.
1145    */
1146   function supportsInterface(bytes4 interfaceId)
1147     public
1148     view
1149     virtual
1150     override(ERC165, IERC165)
1151     returns (bool)
1152   {
1153     return
1154       interfaceId == type(IERC721).interfaceId ||
1155       interfaceId == type(IERC721Metadata).interfaceId ||
1156       interfaceId == type(IERC721Enumerable).interfaceId ||
1157       super.supportsInterface(interfaceId);
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-balanceOf}.
1162    */
1163   function balanceOf(address owner) public view override returns (uint256) {
1164     require(owner != address(0), "ERC721A: balance query for the zero address");
1165     return uint256(_addressData[owner].balance);
1166   }
1167 
1168   function _numberMinted(address owner) internal view returns (uint256) {
1169     require(
1170       owner != address(0),
1171       "ERC721A: number minted query for the zero address"
1172     );
1173     return uint256(_addressData[owner].numberMinted);
1174   }
1175 
1176   function ownershipOf(uint256 tokenId)
1177     internal
1178     view
1179     returns (TokenOwnership memory)
1180   {
1181     uint256 curr = tokenId;
1182 
1183     unchecked {
1184         if (_startTokenId() <= curr && curr < currentIndex) {
1185             TokenOwnership memory ownership = _ownerships[curr];
1186             if (ownership.addr != address(0)) {
1187                 return ownership;
1188             }
1189 
1190             // Invariant:
1191             // There will always be an ownership that has an address and is not burned
1192             // before an ownership that does not have an address and is not burned.
1193             // Hence, curr will not underflow.
1194             while (true) {
1195                 curr--;
1196                 ownership = _ownerships[curr];
1197                 if (ownership.addr != address(0)) {
1198                     return ownership;
1199                 }
1200             }
1201         }
1202     }
1203 
1204     revert("ERC721A: unable to determine the owner of token");
1205   }
1206 
1207   /**
1208    * @dev See {IERC721-ownerOf}.
1209    */
1210   function ownerOf(uint256 tokenId) public view override returns (address) {
1211     return ownershipOf(tokenId).addr;
1212   }
1213 
1214   /**
1215    * @dev See {IERC721Metadata-name}.
1216    */
1217   function name() public view virtual override returns (string memory) {
1218     return _name;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721Metadata-symbol}.
1223    */
1224   function symbol() public view virtual override returns (string memory) {
1225     return _symbol;
1226   }
1227 
1228   /**
1229    * @dev See {IERC721Metadata-tokenURI}.
1230    */
1231   function tokenURI(uint256 tokenId)
1232     public
1233     view
1234     virtual
1235     override
1236     returns (string memory)
1237   {
1238     string memory baseURI = _baseURI();
1239     string memory extension = _baseURIExtension();
1240     return
1241       bytes(baseURI).length > 0
1242         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1243         : "";
1244   }
1245 
1246   /**
1247    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1248    * token will be the concatenation of the baseURI and the tokenId. Empty
1249    * by default, can be overriden in child contracts.
1250    */
1251   function _baseURI() internal view virtual returns (string memory) {
1252     return "";
1253   }
1254 
1255   /**
1256    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1257    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1258    * by default, can be overriden in child contracts.
1259    */
1260   function _baseURIExtension() internal view virtual returns (string memory) {
1261     return "";
1262   }
1263 
1264   /**
1265    * @dev Sets the value for an address to be in the restricted approval address pool.
1266    * Setting an address to true will disable token owners from being able to mark the address
1267    * for approval for trading. This would be used in theory to prevent token owners from listing
1268    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1269    * @param _address the marketplace/user to modify restriction status of
1270    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1271    */
1272   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1273     restrictedApprovalAddresses[_address] = _isRestricted;
1274   }
1275 
1276   /**
1277    * @dev See {IERC721-approve}.
1278    */
1279   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1280     address owner = ERC721A.ownerOf(tokenId);
1281     require(to != owner, "ERC721A: approval to current owner");
1282     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1283 
1284     require(
1285       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1286       "ERC721A: approve caller is not owner nor approved for all"
1287     );
1288 
1289     _approve(to, tokenId, owner);
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-getApproved}.
1294    */
1295   function getApproved(uint256 tokenId) public view override returns (address) {
1296     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1297 
1298     return _tokenApprovals[tokenId];
1299   }
1300 
1301   /**
1302    * @dev See {IERC721-setApprovalForAll}.
1303    */
1304   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1305     require(operator != _msgSender(), "ERC721A: approve to caller");
1306     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1307 
1308     _operatorApprovals[_msgSender()][operator] = approved;
1309     emit ApprovalForAll(_msgSender(), operator, approved);
1310   }
1311 
1312   /**
1313    * @dev See {IERC721-isApprovedForAll}.
1314    */
1315   function isApprovedForAll(address owner, address operator)
1316     public
1317     view
1318     virtual
1319     override
1320     returns (bool)
1321   {
1322     return _operatorApprovals[owner][operator];
1323   }
1324 
1325   /**
1326    * @dev See {IERC721-transferFrom}.
1327    */
1328   function transferFrom(
1329     address from,
1330     address to,
1331     uint256 tokenId
1332   ) public override onlyAllowedOperator(from) {
1333     _transfer(from, to, tokenId);
1334   }
1335 
1336   /**
1337    * @dev See {IERC721-safeTransferFrom}.
1338    */
1339   function safeTransferFrom(
1340     address from,
1341     address to,
1342     uint256 tokenId
1343   ) public override onlyAllowedOperator(from) {
1344     safeTransferFrom(from, to, tokenId, "");
1345   }
1346 
1347   /**
1348    * @dev See {IERC721-safeTransferFrom}.
1349    */
1350   function safeTransferFrom(
1351     address from,
1352     address to,
1353     uint256 tokenId,
1354     bytes memory _data
1355   ) public override onlyAllowedOperator(from) {
1356     _transfer(from, to, tokenId);
1357     require(
1358       _checkOnERC721Received(from, to, tokenId, _data),
1359       "ERC721A: transfer to non ERC721Receiver implementer"
1360     );
1361   }
1362 
1363   /**
1364    * @dev Returns whether tokenId exists.
1365    *
1366    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1367    *
1368    * Tokens start existing when they are minted (_mint),
1369    */
1370   function _exists(uint256 tokenId) internal view returns (bool) {
1371     return _startTokenId() <= tokenId && tokenId < currentIndex;
1372   }
1373 
1374   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1375     _safeMint(to, quantity, isAdminMint, "");
1376   }
1377 
1378   /**
1379    * @dev Mints quantity tokens and transfers them to to.
1380    *
1381    * Requirements:
1382    *
1383    * - there must be quantity tokens remaining unminted in the total collection.
1384    * - to cannot be the zero address.
1385    * - quantity cannot be larger than the max batch size.
1386    *
1387    * Emits a {Transfer} event.
1388    */
1389   function _safeMint(
1390     address to,
1391     uint256 quantity,
1392     bool isAdminMint,
1393     bytes memory _data
1394   ) internal {
1395     uint256 startTokenId = currentIndex;
1396     require(to != address(0), "ERC721A: mint to the zero address");
1397     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1398     require(!_exists(startTokenId), "ERC721A: token already minted");
1399 
1400     // For admin mints we do not want to enforce the maxBatchSize limit
1401     if (isAdminMint == false) {
1402         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1403     }
1404 
1405     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1406 
1407     AddressData memory addressData = _addressData[to];
1408     _addressData[to] = AddressData(
1409       addressData.balance + uint128(quantity),
1410       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1411     );
1412     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1413 
1414     uint256 updatedIndex = startTokenId;
1415 
1416     for (uint256 i = 0; i < quantity; i++) {
1417       emit Transfer(address(0), to, updatedIndex);
1418       require(
1419         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1420         "ERC721A: transfer to non ERC721Receiver implementer"
1421       );
1422       updatedIndex++;
1423     }
1424 
1425     currentIndex = updatedIndex;
1426     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1427   }
1428 
1429   /**
1430    * @dev Transfers tokenId from from to to.
1431    *
1432    * Requirements:
1433    *
1434    * - to cannot be the zero address.
1435    * - tokenId token must be owned by from.
1436    *
1437    * Emits a {Transfer} event.
1438    */
1439   function _transfer(
1440     address from,
1441     address to,
1442     uint256 tokenId
1443   ) private {
1444     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1445 
1446     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1447       getApproved(tokenId) == _msgSender() ||
1448       isApprovedForAll(prevOwnership.addr, _msgSender()));
1449 
1450     require(
1451       isApprovedOrOwner,
1452       "ERC721A: transfer caller is not owner nor approved"
1453     );
1454 
1455     require(
1456       prevOwnership.addr == from,
1457       "ERC721A: transfer from incorrect owner"
1458     );
1459     require(to != address(0), "ERC721A: transfer to the zero address");
1460 
1461     _beforeTokenTransfers(from, to, tokenId, 1);
1462 
1463     // Clear approvals from the previous owner
1464     _approve(address(0), tokenId, prevOwnership.addr);
1465 
1466     _addressData[from].balance -= 1;
1467     _addressData[to].balance += 1;
1468     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1469 
1470     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1471     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1472     uint256 nextTokenId = tokenId + 1;
1473     if (_ownerships[nextTokenId].addr == address(0)) {
1474       if (_exists(nextTokenId)) {
1475         _ownerships[nextTokenId] = TokenOwnership(
1476           prevOwnership.addr,
1477           prevOwnership.startTimestamp
1478         );
1479       }
1480     }
1481 
1482     emit Transfer(from, to, tokenId);
1483     _afterTokenTransfers(from, to, tokenId, 1);
1484   }
1485 
1486   /**
1487    * @dev Approve to to operate on tokenId
1488    *
1489    * Emits a {Approval} event.
1490    */
1491   function _approve(
1492     address to,
1493     uint256 tokenId,
1494     address owner
1495   ) private {
1496     _tokenApprovals[tokenId] = to;
1497     emit Approval(owner, to, tokenId);
1498   }
1499 
1500   uint256 public nextOwnerToExplicitlySet = 0;
1501 
1502   /**
1503    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1504    */
1505   function _setOwnersExplicit(uint256 quantity) internal {
1506     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1507     require(quantity > 0, "quantity must be nonzero");
1508     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1509 
1510     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1511     if (endIndex > collectionSize - 1) {
1512       endIndex = collectionSize - 1;
1513     }
1514     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1515     require(_exists(endIndex), "not enough minted yet for this cleanup");
1516     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1517       if (_ownerships[i].addr == address(0)) {
1518         TokenOwnership memory ownership = ownershipOf(i);
1519         _ownerships[i] = TokenOwnership(
1520           ownership.addr,
1521           ownership.startTimestamp
1522         );
1523       }
1524     }
1525     nextOwnerToExplicitlySet = endIndex + 1;
1526   }
1527 
1528   /**
1529    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1530    * The call is not executed if the target address is not a contract.
1531    *
1532    * @param from address representing the previous owner of the given token ID
1533    * @param to target address that will receive the tokens
1534    * @param tokenId uint256 ID of the token to be transferred
1535    * @param _data bytes optional data to send along with the call
1536    * @return bool whether the call correctly returned the expected magic value
1537    */
1538   function _checkOnERC721Received(
1539     address from,
1540     address to,
1541     uint256 tokenId,
1542     bytes memory _data
1543   ) private returns (bool) {
1544     if (to.isContract()) {
1545       try
1546         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1547       returns (bytes4 retval) {
1548         return retval == IERC721Receiver(to).onERC721Received.selector;
1549       } catch (bytes memory reason) {
1550         if (reason.length == 0) {
1551           revert("ERC721A: transfer to non ERC721Receiver implementer");
1552         } else {
1553           assembly {
1554             revert(add(32, reason), mload(reason))
1555           }
1556         }
1557       }
1558     } else {
1559       return true;
1560     }
1561   }
1562 
1563   /**
1564    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1565    *
1566    * startTokenId - the first token id to be transferred
1567    * quantity - the amount to be transferred
1568    *
1569    * Calling conditions:
1570    *
1571    * - When from and to are both non-zero, from's tokenId will be
1572    * transferred to to.
1573    * - When from is zero, tokenId will be minted for to.
1574    */
1575   function _beforeTokenTransfers(
1576     address from,
1577     address to,
1578     uint256 startTokenId,
1579     uint256 quantity
1580   ) internal virtual {}
1581 
1582   /**
1583    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1584    * minting.
1585    *
1586    * startTokenId - the first token id to be transferred
1587    * quantity - the amount to be transferred
1588    *
1589    * Calling conditions:
1590    *
1591    * - when from and to are both non-zero.
1592    * - from and to are never both zero.
1593    */
1594   function _afterTokenTransfers(
1595     address from,
1596     address to,
1597     uint256 startTokenId,
1598     uint256 quantity
1599   ) internal virtual {}
1600 }
1601 
1602 abstract contract ProviderFees is Context {
1603   address private constant PROVIDER = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1604   uint256 public PROVIDER_FEE = 0.000777 ether;  
1605 
1606   function sendProviderFee() internal {
1607     payable(PROVIDER).transfer(PROVIDER_FEE);
1608   }
1609 
1610   function setProviderFee(uint256 _fee) public {
1611     if(_msgSender() != PROVIDER) revert NotMaintainer();
1612     PROVIDER_FEE = _fee;
1613   }
1614 }
1615 
1616 
1617 
1618   
1619   
1620 interface IERC20 {
1621   function allowance(address owner, address spender) external view returns (uint256);
1622   function transfer(address _to, uint256 _amount) external returns (bool);
1623   function balanceOf(address account) external view returns (uint256);
1624   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1625 }
1626 
1627 // File: WithdrawableV2
1628 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1629 // ERC-20 Payouts are limited to a single payout address. This feature 
1630 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1631 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1632 abstract contract WithdrawableV2 is Teams {
1633   struct acceptedERC20 {
1634     bool isActive;
1635     uint256 chargeAmount;
1636   }
1637 
1638   
1639   mapping(address => acceptedERC20) private allowedTokenContracts;
1640   address[] public payableAddresses = [0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0x678469cA566BEE59C2eE779B09976B8072B572BB];
1641   address public erc20Payable = 0x678469cA566BEE59C2eE779B09976B8072B572BB;
1642   uint256[] public payableFees = [2,98];
1643   uint256 public payableAddressCount = 2;
1644   bool public onlyERC20MintingMode;
1645   
1646 
1647   function withdrawAll() public onlyTeamOrOwner {
1648       if(address(this).balance == 0) revert ValueCannotBeZero();
1649       _withdrawAll(address(this).balance);
1650   }
1651 
1652   function _withdrawAll(uint256 balance) private {
1653       for(uint i=0; i < payableAddressCount; i++ ) {
1654           _widthdraw(
1655               payableAddresses[i],
1656               (balance * payableFees[i]) / 100
1657           );
1658       }
1659   }
1660   
1661   function _widthdraw(address _address, uint256 _amount) private {
1662       (bool success, ) = _address.call{value: _amount}("");
1663       require(success, "Transfer failed.");
1664   }
1665 
1666   /**
1667   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1668   * in the event ERC-20 tokens are paid to the contract for mints.
1669   * @param _tokenContract contract of ERC-20 token to withdraw
1670   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1671   */
1672   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1673     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1674     IERC20 tokenContract = IERC20(_tokenContract);
1675     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1676     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1677   }
1678 
1679   /**
1680   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1681   * @param _erc20TokenContract address of ERC-20 contract in question
1682   */
1683   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1684     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1685   }
1686 
1687   /**
1688   * @dev get the value of tokens to transfer for user of an ERC-20
1689   * @param _erc20TokenContract address of ERC-20 contract in question
1690   */
1691   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1692     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1693     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1694   }
1695 
1696   /**
1697   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1698   * @param _erc20TokenContract address of ERC-20 contract in question
1699   * @param _isActive default status of if contract should be allowed to accept payments
1700   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1701   */
1702   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1703     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1704     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1705   }
1706 
1707   /**
1708   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1709   * it will assume the default value of zero. This should not be used to create new payment tokens.
1710   * @param _erc20TokenContract address of ERC-20 contract in question
1711   */
1712   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1713     allowedTokenContracts[_erc20TokenContract].isActive = true;
1714   }
1715 
1716   /**
1717   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1718   * it will assume the default value of zero. This should not be used to create new payment tokens.
1719   * @param _erc20TokenContract address of ERC-20 contract in question
1720   */
1721   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1722     allowedTokenContracts[_erc20TokenContract].isActive = false;
1723   }
1724 
1725   /**
1726   * @dev Enable only ERC-20 payments for minting on this contract
1727   */
1728   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1729     onlyERC20MintingMode = true;
1730   }
1731 
1732   /**
1733   * @dev Disable only ERC-20 payments for minting on this contract
1734   */
1735   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1736     onlyERC20MintingMode = false;
1737   }
1738 
1739   /**
1740   * @dev Set the payout of the ERC-20 token payout to a specific address
1741   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1742   */
1743   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1744     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1745     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1746     erc20Payable = _newErc20Payable;
1747   }
1748 }
1749 
1750 
1751   
1752   
1753 /* File: Tippable.sol
1754 /* @dev Allows owner to set strict enforcement of payment to mint price.
1755 /* Would then allow buyers to pay _more_ than the mint fee - consider it as a tip
1756 /* when doing a free mint with opt-in pricing.
1757 /* When strict pricing is enabled => msg.value must extactly equal the expected value
1758 /* when strict pricing is disabled => msg.value must be _at least_ the expected value.
1759 /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1760 /* Pros - can take in gratituity payments during a mint. 
1761 /* Cons - However if you decrease pricing during mint txn settlement 
1762 /* it can result in mints landing who technically now have overpaid.
1763 */
1764 abstract contract Tippable is Teams {
1765   bool public strictPricing = true;
1766 
1767   function setStrictPricing(bool _newStatus) public onlyTeamOrOwner {
1768     strictPricing = _newStatus;
1769   }
1770 
1771   // @dev check if msg.value is correct according to pricing enforcement
1772   // @param _msgValue -> passed in msg.value of tx
1773   // @param _expectedPrice -> result of getPrice(...args)
1774   function priceIsRight(uint256 _msgValue, uint256 _expectedPrice) internal view returns (bool) {
1775     return strictPricing ? 
1776       _msgValue == _expectedPrice : 
1777       _msgValue >= _expectedPrice;
1778   }
1779 }
1780 
1781   
1782   
1783 // File: EarlyMintIncentive.sol
1784 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1785 // zero fee that can be calculated on the fly.
1786 abstract contract EarlyMintIncentive is Teams, ERC721A, ProviderFees {
1787   uint256 public PRICE = 0.005 ether;
1788   uint256 public EARLY_MINT_PRICE = 0 ether;
1789   uint256 public earlyMintOwnershipCap = 1;
1790   bool public usingEarlyMintIncentive = true;
1791 
1792   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1793     usingEarlyMintIncentive = true;
1794   }
1795 
1796   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1797     usingEarlyMintIncentive = false;
1798   }
1799 
1800   /**
1801   * @dev Set the max token ID in which the cost incentive will be applied.
1802   * @param _newCap max number of tokens wallet may mint for incentive price
1803   */
1804   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1805     if(_newCap == 0) revert ValueCannotBeZero();
1806     earlyMintOwnershipCap = _newCap;
1807   }
1808 
1809   /**
1810   * @dev Set the incentive mint price
1811   * @param _feeInWei new price per token when in incentive range
1812   */
1813   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1814     EARLY_MINT_PRICE = _feeInWei;
1815   }
1816 
1817   /**
1818   * @dev Set the primary mint price - the base price when not under incentive
1819   * @param _feeInWei new price per token
1820   */
1821   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1822     PRICE = _feeInWei;
1823   }
1824 
1825   /**
1826   * @dev Get the correct price for the mint for qty and person minting
1827   * @param _count amount of tokens to calc for mint
1828   * @param _to the address which will be minting these tokens, passed explicitly
1829   */
1830   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1831     if(_count == 0) revert ValueCannotBeZero();
1832 
1833     // short circuit function if we dont need to even calc incentive pricing
1834     // short circuit if the current wallet mint qty is also already over cap
1835     if(
1836       usingEarlyMintIncentive == false ||
1837       _numberMinted(_to) > earlyMintOwnershipCap
1838     ) {
1839       return (PRICE * _count) + PROVIDER_FEE;
1840     }
1841 
1842     uint256 endingTokenQty = _numberMinted(_to) + _count;
1843     // If qty to mint results in a final qty less than or equal to the cap then
1844     // the entire qty is within incentive mint.
1845     if(endingTokenQty  <= earlyMintOwnershipCap) {
1846       return (EARLY_MINT_PRICE * _count) + PROVIDER_FEE;
1847     }
1848 
1849     // If the current token qty is less than the incentive cap
1850     // and the ending token qty is greater than the incentive cap
1851     // we will be straddling the cap so there will be some amount
1852     // that are incentive and some that are regular fee.
1853     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1854     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1855 
1856     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount) + PROVIDER_FEE;
1857   }
1858 }
1859 
1860   
1861 abstract contract ERC721APlus is 
1862     Ownable,
1863     Teams,
1864     ERC721A,
1865     WithdrawableV2,
1866     ReentrancyGuard 
1867     , EarlyMintIncentive, Tippable 
1868      
1869     
1870 {
1871   constructor(
1872     string memory tokenName,
1873     string memory tokenSymbol
1874   ) ERC721A(tokenName, tokenSymbol, 20, 4321) { }
1875     uint8 constant public CONTRACT_VERSION = 2;
1876     string public _baseTokenURI = "ipfs://bafybeidlscib42wvnwh5tt2aove652xgafufi2yuvd2vqjs4bksaby7jvq/";
1877     string public _baseTokenExtension = ".json";
1878 
1879     bool public mintingOpen = false;
1880     bool public isRevealed;
1881     
1882     uint256 public MAX_WALLET_MINTS = 20;
1883 
1884   
1885     /////////////// Admin Mint Functions
1886     /**
1887      * @dev Mints a token to an address with a tokenURI.
1888      * This is owner only and allows a fee-free drop
1889      * @param _to address of the future owner of the token
1890      * @param _qty amount of tokens to drop the owner
1891      */
1892      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1893          if(_qty == 0) revert MintZeroQuantity();
1894          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1895          _safeMint(_to, _qty, true);
1896      }
1897 
1898   
1899     /////////////// PUBLIC MINT FUNCTIONS
1900     /**
1901     * @dev Mints tokens to an address in batch.
1902     * fee may or may not be required*
1903     * @param _to address of the future owner of the token
1904     * @param _amount number of tokens to mint
1905     */
1906     function mintToMultiple(address _to, uint256 _amount) public payable {
1907         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1908         if(_amount == 0) revert MintZeroQuantity();
1909         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1910         if(!mintingOpen) revert PublicMintClosed();
1911         
1912         
1913         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1914         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1915         if(!priceIsRight(msg.value, getPrice(_amount, _to))) revert InvalidPayment();
1916         sendProviderFee();
1917         _safeMint(_to, _amount, false);
1918     }
1919 
1920     /**
1921      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1922      * fee may or may not be required*
1923      * @param _to address of the future owner of the token
1924      * @param _amount number of tokens to mint
1925      * @param _erc20TokenContract erc-20 token contract to mint with
1926      */
1927     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1928       if(_amount == 0) revert MintZeroQuantity();
1929       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1930       if(!mintingOpen) revert PublicMintClosed();
1931       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1932       
1933       
1934       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1935       if(msg.value != PROVIDER_FEE) revert InvalidPayment();
1936 
1937       // ERC-20 Specific pre-flight checks
1938       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1939       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1940       IERC20 payableToken = IERC20(_erc20TokenContract);
1941 
1942       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1943       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1944 
1945       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1946       if(!transferComplete) revert ERC20TransferFailed();
1947 
1948       sendProviderFee();
1949       _safeMint(_to, _amount, false);
1950     }
1951 
1952     function openMinting() public onlyTeamOrOwner {
1953         mintingOpen = true;
1954     }
1955 
1956     function stopMinting() public onlyTeamOrOwner {
1957         mintingOpen = false;
1958     }
1959 
1960   
1961 
1962   
1963     /**
1964     * @dev Check if wallet over MAX_WALLET_MINTS
1965     * @param _address address in question to check if minted count exceeds max
1966     */
1967     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1968         if(_amount == 0) revert ValueCannotBeZero();
1969         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1970     }
1971 
1972     /**
1973     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1974     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1975     */
1976     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1977         if(_newWalletMax == 0) revert ValueCannotBeZero();
1978         MAX_WALLET_MINTS = _newWalletMax;
1979     }
1980     
1981 
1982   
1983     /**
1984      * @dev Allows owner to set Max mints per tx
1985      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1986      */
1987      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1988          if(_newMaxMint == 0) revert ValueCannotBeZero();
1989          maxBatchSize = _newMaxMint;
1990      }
1991     
1992 
1993   
1994     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
1995         if(isRevealed) revert IsAlreadyUnveiled();
1996         _baseTokenURI = _updatedTokenURI;
1997         isRevealed = true;
1998     }
1999     
2000   
2001   
2002   function contractURI() public pure returns (string memory) {
2003     return "https://metadata.mintplex.xyz/LCYo5vH4YKY23anyjFsx/contract-metadata";
2004   }
2005   
2006 
2007   function _baseURI() internal view virtual override returns(string memory) {
2008     return _baseTokenURI;
2009   }
2010 
2011   function _baseURIExtension() internal view virtual override returns(string memory) {
2012     return _baseTokenExtension;
2013   }
2014 
2015   function baseTokenURI() public view returns(string memory) {
2016     return _baseTokenURI;
2017   }
2018 
2019   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2020     _baseTokenURI = baseURI;
2021   }
2022 
2023   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2024     _baseTokenExtension = baseExtension;
2025   }
2026 }
2027 
2028 
2029   
2030 // File: contracts/RexbitsContract.sol
2031 //SPDX-License-Identifier: MIT
2032 
2033 pragma solidity ^0.8.0;
2034 
2035 contract RexbitsContract is ERC721APlus {
2036     constructor() ERC721APlus("REXBITS", "RXBT"){}
2037 }