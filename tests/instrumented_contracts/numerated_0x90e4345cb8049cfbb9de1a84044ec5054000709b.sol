1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  _    _ ___________ _    ______   ___________   _    _ _   _ ________  ________ _____ _____ _____ 
5 // | |  | |  _  | ___ | |   |  _  \ |  _  |  ___| | |  | | | | |_   _|  \/  /  ___|_   _|  ___/  ___|
6 // | |  | | | | | |_/ | |   | | | | | | | | |_    | |  | | |_| | | | | .  . \ `--.  | | | |__ \ `--. 
7 // | |/\| | | | |    /| |   | | | | | | | |  _|   | |/\| |  _  | | | | |\/| |`--. \ | | |  __| `--. \
8 // \  /\  \ \_/ | |\ \| |___| |/ /  \ \_/ | |     \  /\  | | | |_| |_| |  | /\__/ /_| |_| |___/\__/ /
9 //  \/  \/ \___/\_| \_\_____|___/    \___/\_|      \/  \/\_| |_/\___/\_|  |_\____/ \___/\____/\____/ 
10 //                                                                                                   
11 // STRANGE IS JUST THE BEGINNING.
12 // TWITTER: @WORLDOFWHIMSIES
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
915   
916   
917 // Rampp Contracts v2.1 (Teams.sol)
918 
919 error InvalidTeamAddress();
920 error DuplicateTeamAddress();
921 pragma solidity ^0.8.0;
922 
923 /**
924 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
925 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
926 * This will easily allow cross-collaboration via Mintplex.xyz.
927 **/
928 abstract contract Teams is Ownable{
929   mapping (address => bool) internal team;
930 
931   /**
932   * @dev Adds an address to the team. Allows them to execute protected functions
933   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
934   **/
935   function addToTeam(address _address) public onlyOwner {
936     if(_address == address(0)) revert InvalidTeamAddress();
937     if(inTeam(_address)) revert DuplicateTeamAddress();
938   
939     team[_address] = true;
940   }
941 
942   /**
943   * @dev Removes an address to the team.
944   * @param _address the ETH address to remove, cannot be 0x and must be in team
945   **/
946   function removeFromTeam(address _address) public onlyOwner {
947     if(_address == address(0)) revert InvalidTeamAddress();
948     if(!inTeam(_address)) revert InvalidTeamAddress();
949   
950     team[_address] = false;
951   }
952 
953   /**
954   * @dev Check if an address is valid and active in the team
955   * @param _address ETH address to check for truthiness
956   **/
957   function inTeam(address _address)
958     public
959     view
960     returns (bool)
961   {
962     if(_address == address(0)) revert InvalidTeamAddress();
963     return team[_address] == true;
964   }
965 
966   /**
967   * @dev Throws if called by any account other than the owner or team member.
968   */
969   function _onlyTeamOrOwner() private view {
970     bool _isOwner = owner() == _msgSender();
971     bool _isTeam = inTeam(_msgSender());
972     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
973   }
974 
975   modifier onlyTeamOrOwner() {
976     _onlyTeamOrOwner();
977     _;
978   }
979 }
980 
981 
982   
983   
984 /**
985  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
986  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
987  *
988  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
989  * 
990  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
991  *
992  * Does not support burning tokens to address(0).
993  */
994 contract ERC721A is
995   Context,
996   ERC165,
997   IERC721,
998   IERC721Metadata,
999   IERC721Enumerable,
1000   Teams
1001   , OperatorFilterer
1002 {
1003   using Address for address;
1004   using Strings for uint256;
1005 
1006   struct TokenOwnership {
1007     address addr;
1008     uint64 startTimestamp;
1009   }
1010 
1011   struct AddressData {
1012     uint128 balance;
1013     uint128 numberMinted;
1014   }
1015 
1016   uint256 private currentIndex;
1017 
1018   uint256 public immutable collectionSize;
1019   uint256 public maxBatchSize;
1020 
1021   // Token name
1022   string private _name;
1023 
1024   // Token symbol
1025   string private _symbol;
1026 
1027   // Mapping from token ID to ownership details
1028   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1029   mapping(uint256 => TokenOwnership) private _ownerships;
1030 
1031   // Mapping owner address to address data
1032   mapping(address => AddressData) private _addressData;
1033 
1034   // Mapping from token ID to approved address
1035   mapping(uint256 => address) private _tokenApprovals;
1036 
1037   // Mapping from owner to operator approvals
1038   mapping(address => mapping(address => bool)) private _operatorApprovals;
1039 
1040   /* @dev Mapping of restricted operator approvals set by contract Owner
1041   * This serves as an optional addition to ERC-721 so
1042   * that the contract owner can elect to prevent specific addresses/contracts
1043   * from being marked as the approver for a token. The reason for this
1044   * is that some projects may want to retain control of where their tokens can/can not be listed
1045   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1046   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1047   */
1048   mapping(address => bool) public restrictedApprovalAddresses;
1049 
1050   /**
1051    * @dev
1052    * maxBatchSize refers to how much a minter can mint at a time.
1053    * collectionSize_ refers to how many tokens are in the collection.
1054    */
1055   constructor(
1056     string memory name_,
1057     string memory symbol_,
1058     uint256 maxBatchSize_,
1059     uint256 collectionSize_
1060   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1061     require(
1062       collectionSize_ > 0,
1063       "ERC721A: collection must have a nonzero supply"
1064     );
1065     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1066     _name = name_;
1067     _symbol = symbol_;
1068     maxBatchSize = maxBatchSize_;
1069     collectionSize = collectionSize_;
1070     currentIndex = _startTokenId();
1071   }
1072 
1073   /**
1074   * To change the starting tokenId, please override this function.
1075   */
1076   function _startTokenId() internal view virtual returns (uint256) {
1077     return 1;
1078   }
1079 
1080   /**
1081    * @dev See {IERC721Enumerable-totalSupply}.
1082    */
1083   function totalSupply() public view override returns (uint256) {
1084     return _totalMinted();
1085   }
1086 
1087   function currentTokenId() public view returns (uint256) {
1088     return _totalMinted();
1089   }
1090 
1091   function getNextTokenId() public view returns (uint256) {
1092       return _totalMinted() + 1;
1093   }
1094 
1095   /**
1096   * Returns the total amount of tokens minted in the contract.
1097   */
1098   function _totalMinted() internal view returns (uint256) {
1099     unchecked {
1100       return currentIndex - _startTokenId();
1101     }
1102   }
1103 
1104   /**
1105    * @dev See {IERC721Enumerable-tokenByIndex}.
1106    */
1107   function tokenByIndex(uint256 index) public view override returns (uint256) {
1108     require(index < totalSupply(), "ERC721A: global index out of bounds");
1109     return index;
1110   }
1111 
1112   /**
1113    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1114    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1115    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1116    */
1117   function tokenOfOwnerByIndex(address owner, uint256 index)
1118     public
1119     view
1120     override
1121     returns (uint256)
1122   {
1123     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1124     uint256 numMintedSoFar = totalSupply();
1125     uint256 tokenIdsIdx = 0;
1126     address currOwnershipAddr = address(0);
1127     for (uint256 i = 0; i < numMintedSoFar; i++) {
1128       TokenOwnership memory ownership = _ownerships[i];
1129       if (ownership.addr != address(0)) {
1130         currOwnershipAddr = ownership.addr;
1131       }
1132       if (currOwnershipAddr == owner) {
1133         if (tokenIdsIdx == index) {
1134           return i;
1135         }
1136         tokenIdsIdx++;
1137       }
1138     }
1139     revert("ERC721A: unable to get token of owner by index");
1140   }
1141 
1142   /**
1143    * @dev See {IERC165-supportsInterface}.
1144    */
1145   function supportsInterface(bytes4 interfaceId)
1146     public
1147     view
1148     virtual
1149     override(ERC165, IERC165)
1150     returns (bool)
1151   {
1152     return
1153       interfaceId == type(IERC721).interfaceId ||
1154       interfaceId == type(IERC721Metadata).interfaceId ||
1155       interfaceId == type(IERC721Enumerable).interfaceId ||
1156       super.supportsInterface(interfaceId);
1157   }
1158 
1159   /**
1160    * @dev See {IERC721-balanceOf}.
1161    */
1162   function balanceOf(address owner) public view override returns (uint256) {
1163     require(owner != address(0), "ERC721A: balance query for the zero address");
1164     return uint256(_addressData[owner].balance);
1165   }
1166 
1167   function _numberMinted(address owner) internal view returns (uint256) {
1168     require(
1169       owner != address(0),
1170       "ERC721A: number minted query for the zero address"
1171     );
1172     return uint256(_addressData[owner].numberMinted);
1173   }
1174 
1175   function ownershipOf(uint256 tokenId)
1176     internal
1177     view
1178     returns (TokenOwnership memory)
1179   {
1180     uint256 curr = tokenId;
1181 
1182     unchecked {
1183         if (_startTokenId() <= curr && curr < currentIndex) {
1184             TokenOwnership memory ownership = _ownerships[curr];
1185             if (ownership.addr != address(0)) {
1186                 return ownership;
1187             }
1188 
1189             // Invariant:
1190             // There will always be an ownership that has an address and is not burned
1191             // before an ownership that does not have an address and is not burned.
1192             // Hence, curr will not underflow.
1193             while (true) {
1194                 curr--;
1195                 ownership = _ownerships[curr];
1196                 if (ownership.addr != address(0)) {
1197                     return ownership;
1198                 }
1199             }
1200         }
1201     }
1202 
1203     revert("ERC721A: unable to determine the owner of token");
1204   }
1205 
1206   /**
1207    * @dev See {IERC721-ownerOf}.
1208    */
1209   function ownerOf(uint256 tokenId) public view override returns (address) {
1210     return ownershipOf(tokenId).addr;
1211   }
1212 
1213   /**
1214    * @dev See {IERC721Metadata-name}.
1215    */
1216   function name() public view virtual override returns (string memory) {
1217     return _name;
1218   }
1219 
1220   /**
1221    * @dev See {IERC721Metadata-symbol}.
1222    */
1223   function symbol() public view virtual override returns (string memory) {
1224     return _symbol;
1225   }
1226 
1227   /**
1228    * @dev See {IERC721Metadata-tokenURI}.
1229    */
1230   function tokenURI(uint256 tokenId)
1231     public
1232     view
1233     virtual
1234     override
1235     returns (string memory)
1236   {
1237     string memory baseURI = _baseURI();
1238     string memory extension = _baseURIExtension();
1239     return
1240       bytes(baseURI).length > 0
1241         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1242         : "";
1243   }
1244 
1245   /**
1246    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1247    * token will be the concatenation of the baseURI and the tokenId. Empty
1248    * by default, can be overriden in child contracts.
1249    */
1250   function _baseURI() internal view virtual returns (string memory) {
1251     return "";
1252   }
1253 
1254   /**
1255    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1256    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1257    * by default, can be overriden in child contracts.
1258    */
1259   function _baseURIExtension() internal view virtual returns (string memory) {
1260     return "";
1261   }
1262 
1263   /**
1264    * @dev Sets the value for an address to be in the restricted approval address pool.
1265    * Setting an address to true will disable token owners from being able to mark the address
1266    * for approval for trading. This would be used in theory to prevent token owners from listing
1267    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1268    * @param _address the marketplace/user to modify restriction status of
1269    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1270    */
1271   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1272     restrictedApprovalAddresses[_address] = _isRestricted;
1273   }
1274 
1275   /**
1276    * @dev See {IERC721-approve}.
1277    */
1278   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1279     address owner = ERC721A.ownerOf(tokenId);
1280     require(to != owner, "ERC721A: approval to current owner");
1281     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1282 
1283     require(
1284       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1285       "ERC721A: approve caller is not owner nor approved for all"
1286     );
1287 
1288     _approve(to, tokenId, owner);
1289   }
1290 
1291   /**
1292    * @dev See {IERC721-getApproved}.
1293    */
1294   function getApproved(uint256 tokenId) public view override returns (address) {
1295     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1296 
1297     return _tokenApprovals[tokenId];
1298   }
1299 
1300   /**
1301    * @dev See {IERC721-setApprovalForAll}.
1302    */
1303   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1304     require(operator != _msgSender(), "ERC721A: approve to caller");
1305     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1306 
1307     _operatorApprovals[_msgSender()][operator] = approved;
1308     emit ApprovalForAll(_msgSender(), operator, approved);
1309   }
1310 
1311   /**
1312    * @dev See {IERC721-isApprovedForAll}.
1313    */
1314   function isApprovedForAll(address owner, address operator)
1315     public
1316     view
1317     virtual
1318     override
1319     returns (bool)
1320   {
1321     return _operatorApprovals[owner][operator];
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-transferFrom}.
1326    */
1327   function transferFrom(
1328     address from,
1329     address to,
1330     uint256 tokenId
1331   ) public override onlyAllowedOperator(from) {
1332     _transfer(from, to, tokenId);
1333   }
1334 
1335   /**
1336    * @dev See {IERC721-safeTransferFrom}.
1337    */
1338   function safeTransferFrom(
1339     address from,
1340     address to,
1341     uint256 tokenId
1342   ) public override onlyAllowedOperator(from) {
1343     safeTransferFrom(from, to, tokenId, "");
1344   }
1345 
1346   /**
1347    * @dev See {IERC721-safeTransferFrom}.
1348    */
1349   function safeTransferFrom(
1350     address from,
1351     address to,
1352     uint256 tokenId,
1353     bytes memory _data
1354   ) public override onlyAllowedOperator(from) {
1355     _transfer(from, to, tokenId);
1356     require(
1357       _checkOnERC721Received(from, to, tokenId, _data),
1358       "ERC721A: transfer to non ERC721Receiver implementer"
1359     );
1360   }
1361 
1362   /**
1363    * @dev Returns whether tokenId exists.
1364    *
1365    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1366    *
1367    * Tokens start existing when they are minted (_mint),
1368    */
1369   function _exists(uint256 tokenId) internal view returns (bool) {
1370     return _startTokenId() <= tokenId && tokenId < currentIndex;
1371   }
1372 
1373   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1374     _safeMint(to, quantity, isAdminMint, "");
1375   }
1376 
1377   /**
1378    * @dev Mints quantity tokens and transfers them to to.
1379    *
1380    * Requirements:
1381    *
1382    * - there must be quantity tokens remaining unminted in the total collection.
1383    * - to cannot be the zero address.
1384    * - quantity cannot be larger than the max batch size.
1385    *
1386    * Emits a {Transfer} event.
1387    */
1388   function _safeMint(
1389     address to,
1390     uint256 quantity,
1391     bool isAdminMint,
1392     bytes memory _data
1393   ) internal {
1394     uint256 startTokenId = currentIndex;
1395     require(to != address(0), "ERC721A: mint to the zero address");
1396     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1397     require(!_exists(startTokenId), "ERC721A: token already minted");
1398 
1399     // For admin mints we do not want to enforce the maxBatchSize limit
1400     if (isAdminMint == false) {
1401         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1402     }
1403 
1404     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1405 
1406     AddressData memory addressData = _addressData[to];
1407     _addressData[to] = AddressData(
1408       addressData.balance + uint128(quantity),
1409       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1410     );
1411     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1412 
1413     uint256 updatedIndex = startTokenId;
1414 
1415     for (uint256 i = 0; i < quantity; i++) {
1416       emit Transfer(address(0), to, updatedIndex);
1417       require(
1418         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1419         "ERC721A: transfer to non ERC721Receiver implementer"
1420       );
1421       updatedIndex++;
1422     }
1423 
1424     currentIndex = updatedIndex;
1425     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1426   }
1427 
1428   /**
1429    * @dev Transfers tokenId from from to to.
1430    *
1431    * Requirements:
1432    *
1433    * - to cannot be the zero address.
1434    * - tokenId token must be owned by from.
1435    *
1436    * Emits a {Transfer} event.
1437    */
1438   function _transfer(
1439     address from,
1440     address to,
1441     uint256 tokenId
1442   ) private {
1443     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1444 
1445     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1446       getApproved(tokenId) == _msgSender() ||
1447       isApprovedForAll(prevOwnership.addr, _msgSender()));
1448 
1449     require(
1450       isApprovedOrOwner,
1451       "ERC721A: transfer caller is not owner nor approved"
1452     );
1453 
1454     require(
1455       prevOwnership.addr == from,
1456       "ERC721A: transfer from incorrect owner"
1457     );
1458     require(to != address(0), "ERC721A: transfer to the zero address");
1459 
1460     _beforeTokenTransfers(from, to, tokenId, 1);
1461 
1462     // Clear approvals from the previous owner
1463     _approve(address(0), tokenId, prevOwnership.addr);
1464 
1465     _addressData[from].balance -= 1;
1466     _addressData[to].balance += 1;
1467     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1468 
1469     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1470     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1471     uint256 nextTokenId = tokenId + 1;
1472     if (_ownerships[nextTokenId].addr == address(0)) {
1473       if (_exists(nextTokenId)) {
1474         _ownerships[nextTokenId] = TokenOwnership(
1475           prevOwnership.addr,
1476           prevOwnership.startTimestamp
1477         );
1478       }
1479     }
1480 
1481     emit Transfer(from, to, tokenId);
1482     _afterTokenTransfers(from, to, tokenId, 1);
1483   }
1484 
1485   /**
1486    * @dev Approve to to operate on tokenId
1487    *
1488    * Emits a {Approval} event.
1489    */
1490   function _approve(
1491     address to,
1492     uint256 tokenId,
1493     address owner
1494   ) private {
1495     _tokenApprovals[tokenId] = to;
1496     emit Approval(owner, to, tokenId);
1497   }
1498 
1499   uint256 public nextOwnerToExplicitlySet = 0;
1500 
1501   /**
1502    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1503    */
1504   function _setOwnersExplicit(uint256 quantity) internal {
1505     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1506     require(quantity > 0, "quantity must be nonzero");
1507     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1508 
1509     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1510     if (endIndex > collectionSize - 1) {
1511       endIndex = collectionSize - 1;
1512     }
1513     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1514     require(_exists(endIndex), "not enough minted yet for this cleanup");
1515     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1516       if (_ownerships[i].addr == address(0)) {
1517         TokenOwnership memory ownership = ownershipOf(i);
1518         _ownerships[i] = TokenOwnership(
1519           ownership.addr,
1520           ownership.startTimestamp
1521         );
1522       }
1523     }
1524     nextOwnerToExplicitlySet = endIndex + 1;
1525   }
1526 
1527   /**
1528    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1529    * The call is not executed if the target address is not a contract.
1530    *
1531    * @param from address representing the previous owner of the given token ID
1532    * @param to target address that will receive the tokens
1533    * @param tokenId uint256 ID of the token to be transferred
1534    * @param _data bytes optional data to send along with the call
1535    * @return bool whether the call correctly returned the expected magic value
1536    */
1537   function _checkOnERC721Received(
1538     address from,
1539     address to,
1540     uint256 tokenId,
1541     bytes memory _data
1542   ) private returns (bool) {
1543     if (to.isContract()) {
1544       try
1545         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1546       returns (bytes4 retval) {
1547         return retval == IERC721Receiver(to).onERC721Received.selector;
1548       } catch (bytes memory reason) {
1549         if (reason.length == 0) {
1550           revert("ERC721A: transfer to non ERC721Receiver implementer");
1551         } else {
1552           assembly {
1553             revert(add(32, reason), mload(reason))
1554           }
1555         }
1556       }
1557     } else {
1558       return true;
1559     }
1560   }
1561 
1562   /**
1563    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1564    *
1565    * startTokenId - the first token id to be transferred
1566    * quantity - the amount to be transferred
1567    *
1568    * Calling conditions:
1569    *
1570    * - When from and to are both non-zero, from's tokenId will be
1571    * transferred to to.
1572    * - When from is zero, tokenId will be minted for to.
1573    */
1574   function _beforeTokenTransfers(
1575     address from,
1576     address to,
1577     uint256 startTokenId,
1578     uint256 quantity
1579   ) internal virtual {}
1580 
1581   /**
1582    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1583    * minting.
1584    *
1585    * startTokenId - the first token id to be transferred
1586    * quantity - the amount to be transferred
1587    *
1588    * Calling conditions:
1589    *
1590    * - when from and to are both non-zero.
1591    * - from and to are never both zero.
1592    */
1593   function _afterTokenTransfers(
1594     address from,
1595     address to,
1596     uint256 startTokenId,
1597     uint256 quantity
1598   ) internal virtual {}
1599 }
1600 
1601 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1602 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1603 // @notice -- See Medium article --
1604 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1605 abstract contract ERC721ARedemption is ERC721A {
1606   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1607   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1608 
1609   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1610   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1611   
1612   uint256 public redemptionSurcharge = 0 ether;
1613   bool public redemptionModeEnabled;
1614   bool public verifiedClaimModeEnabled;
1615   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1616   mapping(address => bool) public redemptionContracts;
1617   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1618 
1619   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1620   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1621     redemptionContracts[_contractAddress] = _status;
1622   }
1623 
1624   // @dev Allow owner/team to determine if contract is accepting redemption mints
1625   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1626     redemptionModeEnabled = _newStatus;
1627   }
1628 
1629   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1630   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1631     verifiedClaimModeEnabled = _newStatus;
1632   }
1633 
1634   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1635   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1636     redemptionSurcharge = _newSurchargeInWei;
1637   }
1638 
1639   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1640   // @notice Must be a wallet address or implement IERC721Receiver.
1641   // Cannot be null address as this will break any ERC-721A implementation without a proper
1642   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1643   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1644     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1645     redemptionAddress = _newRedemptionAddress;
1646   }
1647 
1648   /**
1649   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1650   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1651   * the contract owner or Team => redemptionAddress. 
1652   * @param tokenId the token to be redeemed.
1653   * Emits a {Redeemed} event.
1654   **/
1655   function redeem(address redemptionContract, uint256 tokenId) public payable {
1656     if(getNextTokenId() > collectionSize) revert CapExceeded();
1657     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1658     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1659     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1660     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1661     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1662     
1663     IERC721 _targetContract = IERC721(redemptionContract);
1664     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1665     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1666     
1667     // Warning: Since there is no standarized return value for transfers of ERC-721
1668     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1669     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1670     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1671     // but the NFT may not have been sent to the redemptionAddress.
1672     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1673     tokenRedemptions[redemptionContract][tokenId] = true;
1674 
1675     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1676     _safeMint(_msgSender(), 1, false);
1677   }
1678 
1679   /**
1680   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1681   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1682   * @param tokenId the token to be redeemed.
1683   * Emits a {VerifiedClaim} event.
1684   **/
1685   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1686     if(getNextTokenId() > collectionSize) revert CapExceeded();
1687     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1688     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1689     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1690     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1691     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1692     
1693     tokenRedemptions[redemptionContract][tokenId] = true;
1694     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1695     _safeMint(_msgSender(), 1, false);
1696   }
1697 }
1698 
1699 
1700   
1701   
1702 interface IERC20 {
1703   function allowance(address owner, address spender) external view returns (uint256);
1704   function transfer(address _to, uint256 _amount) external returns (bool);
1705   function balanceOf(address account) external view returns (uint256);
1706   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1707 }
1708 
1709 // File: WithdrawableV2
1710 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1711 // ERC-20 Payouts are limited to a single payout address. This feature 
1712 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1713 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1714 abstract contract WithdrawableV2 is Teams {
1715   struct acceptedERC20 {
1716     bool isActive;
1717     uint256 chargeAmount;
1718   }
1719 
1720   
1721   mapping(address => acceptedERC20) private allowedTokenContracts;
1722   address[] public payableAddresses = [0x829D29a68f787de9d3D25434278F6515e2f9eB5D];
1723   address public erc20Payable = 0x829D29a68f787de9d3D25434278F6515e2f9eB5D;
1724   uint256[] public payableFees = [100];
1725   uint256 public payableAddressCount = 1;
1726   bool public onlyERC20MintingMode;
1727   
1728 
1729   function withdrawAll() public onlyTeamOrOwner {
1730       if(address(this).balance == 0) revert ValueCannotBeZero();
1731       _withdrawAll(address(this).balance);
1732   }
1733 
1734   function _withdrawAll(uint256 balance) private {
1735       for(uint i=0; i < payableAddressCount; i++ ) {
1736           _widthdraw(
1737               payableAddresses[i],
1738               (balance * payableFees[i]) / 100
1739           );
1740       }
1741   }
1742   
1743   function _widthdraw(address _address, uint256 _amount) private {
1744       (bool success, ) = _address.call{value: _amount}("");
1745       require(success, "Transfer failed.");
1746   }
1747 
1748   /**
1749   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1750   * in the event ERC-20 tokens are paid to the contract for mints.
1751   * @param _tokenContract contract of ERC-20 token to withdraw
1752   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1753   */
1754   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1755     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1756     IERC20 tokenContract = IERC20(_tokenContract);
1757     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1758     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1759   }
1760 
1761   /**
1762   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1763   * @param _erc20TokenContract address of ERC-20 contract in question
1764   */
1765   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1766     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1767   }
1768 
1769   /**
1770   * @dev get the value of tokens to transfer for user of an ERC-20
1771   * @param _erc20TokenContract address of ERC-20 contract in question
1772   */
1773   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1774     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1775     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1776   }
1777 
1778   /**
1779   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1780   * @param _erc20TokenContract address of ERC-20 contract in question
1781   * @param _isActive default status of if contract should be allowed to accept payments
1782   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1783   */
1784   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1785     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1786     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1787   }
1788 
1789   /**
1790   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1791   * it will assume the default value of zero. This should not be used to create new payment tokens.
1792   * @param _erc20TokenContract address of ERC-20 contract in question
1793   */
1794   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1795     allowedTokenContracts[_erc20TokenContract].isActive = true;
1796   }
1797 
1798   /**
1799   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1800   * it will assume the default value of zero. This should not be used to create new payment tokens.
1801   * @param _erc20TokenContract address of ERC-20 contract in question
1802   */
1803   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1804     allowedTokenContracts[_erc20TokenContract].isActive = false;
1805   }
1806 
1807   /**
1808   * @dev Enable only ERC-20 payments for minting on this contract
1809   */
1810   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1811     onlyERC20MintingMode = true;
1812   }
1813 
1814   /**
1815   * @dev Disable only ERC-20 payments for minting on this contract
1816   */
1817   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1818     onlyERC20MintingMode = false;
1819   }
1820 
1821   /**
1822   * @dev Set the payout of the ERC-20 token payout to a specific address
1823   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1824   */
1825   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1826     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1827     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1828     erc20Payable = _newErc20Payable;
1829   }
1830 }
1831 
1832 
1833   
1834   
1835   
1836 // File: EarlyMintIncentive.sol
1837 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1838 // zero fee that can be calculated on the fly.
1839 abstract contract EarlyMintIncentive is Teams, ERC721A {
1840   uint256 public PRICE = 0.005 ether;
1841   uint256 public EARLY_MINT_PRICE = 0 ether;
1842   uint256 public earlyMintOwnershipCap = 1;
1843   bool public usingEarlyMintIncentive = true;
1844 
1845   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1846     usingEarlyMintIncentive = true;
1847   }
1848 
1849   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1850     usingEarlyMintIncentive = false;
1851   }
1852 
1853   /**
1854   * @dev Set the max token ID in which the cost incentive will be applied.
1855   * @param _newCap max number of tokens wallet may mint for incentive price
1856   */
1857   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1858     if(_newCap == 0) revert ValueCannotBeZero();
1859     earlyMintOwnershipCap = _newCap;
1860   }
1861 
1862   /**
1863   * @dev Set the incentive mint price
1864   * @param _feeInWei new price per token when in incentive range
1865   */
1866   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1867     EARLY_MINT_PRICE = _feeInWei;
1868   }
1869 
1870   /**
1871   * @dev Set the primary mint price - the base price when not under incentive
1872   * @param _feeInWei new price per token
1873   */
1874   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1875     PRICE = _feeInWei;
1876   }
1877 
1878   /**
1879   * @dev Get the correct price for the mint for qty and person minting
1880   * @param _count amount of tokens to calc for mint
1881   * @param _to the address which will be minting these tokens, passed explicitly
1882   */
1883   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1884     if(_count == 0) revert ValueCannotBeZero();
1885 
1886     // short circuit function if we dont need to even calc incentive pricing
1887     // short circuit if the current wallet mint qty is also already over cap
1888     if(
1889       usingEarlyMintIncentive == false ||
1890       _numberMinted(_to) > earlyMintOwnershipCap
1891     ) {
1892       return PRICE * _count;
1893     }
1894 
1895     uint256 endingTokenQty = _numberMinted(_to) + _count;
1896     // If qty to mint results in a final qty less than or equal to the cap then
1897     // the entire qty is within incentive mint.
1898     if(endingTokenQty  <= earlyMintOwnershipCap) {
1899       return EARLY_MINT_PRICE * _count;
1900     }
1901 
1902     // If the current token qty is less than the incentive cap
1903     // and the ending token qty is greater than the incentive cap
1904     // we will be straddling the cap so there will be some amount
1905     // that are incentive and some that are regular fee.
1906     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
1907     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1908 
1909     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1910   }
1911 }
1912 
1913   
1914 abstract contract RamppERC721A is 
1915     Ownable,
1916     Teams,
1917     ERC721ARedemption,
1918     WithdrawableV2,
1919     ReentrancyGuard 
1920     , EarlyMintIncentive 
1921      
1922     
1923 {
1924   constructor(
1925     string memory tokenName,
1926     string memory tokenSymbol
1927   ) ERC721A(tokenName, tokenSymbol, 5, 4400) { }
1928     uint8 constant public CONTRACT_VERSION = 2;
1929     string public _baseTokenURI = "https://metadata.mintfoundry.xyz/c/6xMI8wNkggNdOm7hBLiM/token/";
1930     string public _baseTokenExtension = ".json";
1931 
1932     bool public mintingOpen = false;
1933     
1934     
1935     uint256 public MAX_WALLET_MINTS = 10;
1936 
1937   
1938     /////////////// Admin Mint Functions
1939     /**
1940      * @dev Mints a token to an address with a tokenURI.
1941      * This is owner only and allows a fee-free drop
1942      * @param _to address of the future owner of the token
1943      * @param _qty amount of tokens to drop the owner
1944      */
1945      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1946          if(_qty == 0) revert MintZeroQuantity();
1947          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1948          _safeMint(_to, _qty, true);
1949      }
1950 
1951   
1952     /////////////// PUBLIC MINT FUNCTIONS
1953     /**
1954     * @dev Mints tokens to an address in batch.
1955     * fee may or may not be required*
1956     * @param _to address of the future owner of the token
1957     * @param _amount number of tokens to mint
1958     */
1959     function mintToMultiple(address _to, uint256 _amount) public payable {
1960         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1961         if(_amount == 0) revert MintZeroQuantity();
1962         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1963         if(!mintingOpen) revert PublicMintClosed();
1964         
1965         
1966         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1967         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1968         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
1969 
1970         _safeMint(_to, _amount, false);
1971     }
1972 
1973     /**
1974      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1975      * fee may or may not be required*
1976      * @param _to address of the future owner of the token
1977      * @param _amount number of tokens to mint
1978      * @param _erc20TokenContract erc-20 token contract to mint with
1979      */
1980     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1981       if(_amount == 0) revert MintZeroQuantity();
1982       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1983       if(!mintingOpen) revert PublicMintClosed();
1984       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1985       
1986       
1987       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1988 
1989       // ERC-20 Specific pre-flight checks
1990       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1991       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1992       IERC20 payableToken = IERC20(_erc20TokenContract);
1993 
1994       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1995       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1996 
1997       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1998       if(!transferComplete) revert ERC20TransferFailed();
1999       
2000       _safeMint(_to, _amount, false);
2001     }
2002 
2003     function openMinting() public onlyTeamOrOwner {
2004         mintingOpen = true;
2005     }
2006 
2007     function stopMinting() public onlyTeamOrOwner {
2008         mintingOpen = false;
2009     }
2010 
2011   
2012 
2013   
2014     /**
2015     * @dev Check if wallet over MAX_WALLET_MINTS
2016     * @param _address address in question to check if minted count exceeds max
2017     */
2018     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2019         if(_amount == 0) revert ValueCannotBeZero();
2020         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2021     }
2022 
2023     /**
2024     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2025     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2026     */
2027     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2028         if(_newWalletMax == 0) revert ValueCannotBeZero();
2029         MAX_WALLET_MINTS = _newWalletMax;
2030     }
2031     
2032 
2033   
2034     /**
2035      * @dev Allows owner to set Max mints per tx
2036      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2037      */
2038      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2039          if(_newMaxMint == 0) revert ValueCannotBeZero();
2040          maxBatchSize = _newMaxMint;
2041      }
2042     
2043 
2044   
2045   
2046   
2047   function contractURI() public pure returns (string memory) {
2048     return "https://metadata.mintplex.xyz/ItIQOpULa4ej4tY7hkPo/contract-metadata";
2049   }
2050   
2051 
2052   function _baseURI() internal view virtual override returns(string memory) {
2053     return _baseTokenURI;
2054   }
2055 
2056   function _baseURIExtension() internal view virtual override returns(string memory) {
2057     return _baseTokenExtension;
2058   }
2059 
2060   function baseTokenURI() public view returns(string memory) {
2061     return _baseTokenURI;
2062   }
2063 
2064   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2065     _baseTokenURI = baseURI;
2066   }
2067 
2068   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2069     _baseTokenExtension = baseExtension;
2070   }
2071 }
2072 
2073 
2074   
2075 // File: contracts/WorldofWhimsiesContract.sol
2076 //SPDX-License-Identifier: MIT
2077 
2078 pragma solidity ^0.8.0;
2079 
2080 contract WorldofWhimsiesContract is RamppERC721A {
2081     constructor() RamppERC721A("World of Whimsies", "WHIMSY"){}
2082 }
2083   