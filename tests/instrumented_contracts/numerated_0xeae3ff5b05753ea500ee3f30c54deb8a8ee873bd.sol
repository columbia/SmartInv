1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  .-') _    ('-. .-.   ('-.          .-')   .-. .-')                                        .-')    
5 // (  OO) )  ( OO )  / _(  OO)        ( OO ). \  ( OO )                                      ( OO ).  
6 // /     '._ ,--. ,--.(,------.      (_)---\_),--. ,--.  .-'),-----.  ,--. ,--.    ,--.     (_)---\_) 
7 // |'--...__)|  | |  | |  .---'      /    _ | |  .'   / ( OO'  .-.  ' |  | |  |    |  |.-') /    _ |  
8 // '--.  .--'|   .|  | |  |          \  :` `. |      /, /   |  | |  | |  | | .-')  |  | OO )\  :` `.  
9 //    |  |   |       |(|  '--.        '..`''.)|     ' _)\_) |  |\|  | |  |_|( OO ) |  |`-' | '..`''.) 
10 //    |  |   |  .-.  | |  .--'       .-._)   \|  .   \    \ |  | |  | |  | | `-' /(|  '---.'.-._)   \ 
11 //    |  |   |  | |  | |  `---.      \       /|  |\   \    `'  '-'  '('  '-'(_.-'  |      | \       / 
12 //    `--'   `--' `--' `------'       `-----' `--' '--'      `-----'   `-----'     `------'  `-----'  
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
743     modifier onlyOwner() {
744         require(owner() == _msgSender(), "Ownable: caller is not the owner");
745         _;
746     }
747 
748     /**
749      * @dev Leaves the contract without owner. It will not be possible to call
750      * onlyOwner functions anymore. Can only be called by the current owner.
751      *
752      * NOTE: Renouncing ownership will leave the contract without an owner,
753      * thereby removing any functionality that is only available to the owner.
754      */
755     function renounceOwnership() public virtual onlyOwner {
756         _transferOwnership(address(0));
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (newOwner).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public virtual onlyOwner {
764         require(newOwner != address(0), "Ownable: new owner is the zero address");
765         _transferOwnership(newOwner);
766     }
767 
768     /**
769      * @dev Transfers ownership of the contract to a new account (newOwner).
770      * Internal function without access restriction.
771      */
772     function _transferOwnership(address newOwner) internal virtual {
773         address oldOwner = _owner;
774         _owner = newOwner;
775         emit OwnershipTransferred(oldOwner, newOwner);
776     }
777 }
778 //-------------END DEPENDENCIES------------------------//
779 
780 
781   
782 // Rampp Contracts v2.1 (Teams.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
788 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
789 * This will easily allow cross-collaboration via Mintplex.xyz.
790 **/
791 abstract contract Teams is Ownable{
792   mapping (address => bool) internal team;
793 
794   /**
795   * @dev Adds an address to the team. Allows them to execute protected functions
796   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
797   **/
798   function addToTeam(address _address) public onlyOwner {
799     require(_address != address(0), "Invalid address");
800     require(!inTeam(_address), "This address is already in your team.");
801   
802     team[_address] = true;
803   }
804 
805   /**
806   * @dev Removes an address to the team.
807   * @param _address the ETH address to remove, cannot be 0x and must be in team
808   **/
809   function removeFromTeam(address _address) public onlyOwner {
810     require(_address != address(0), "Invalid address");
811     require(inTeam(_address), "This address is not in your team currently.");
812   
813     team[_address] = false;
814   }
815 
816   /**
817   * @dev Check if an address is valid and active in the team
818   * @param _address ETH address to check for truthiness
819   **/
820   function inTeam(address _address)
821     public
822     view
823     returns (bool)
824   {
825     require(_address != address(0), "Invalid address to check.");
826     return team[_address] == true;
827   }
828 
829   /**
830   * @dev Throws if called by any account other than the owner or team member.
831   */
832   modifier onlyTeamOrOwner() {
833     bool _isOwner = owner() == _msgSender();
834     bool _isTeam = inTeam(_msgSender());
835     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
836     _;
837   }
838 }
839 
840 
841   
842   pragma solidity ^0.8.0;
843 
844   /**
845   * @dev These functions deal with verification of Merkle Trees proofs.
846   *
847   * The proofs can be generated using the JavaScript library
848   * https://github.com/miguelmota/merkletreejs[merkletreejs].
849   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
850   *
851   *
852   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
853   * hashing, or use a hash function other than keccak256 for hashing leaves.
854   * This is because the concatenation of a sorted pair of internal nodes in
855   * the merkle tree could be reinterpreted as a leaf value.
856   */
857   library MerkleProof {
858       /**
859       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
860       * defined by 'root'. For this, a 'proof' must be provided, containing
861       * sibling hashes on the branch from the leaf to the root of the tree. Each
862       * pair of leaves and each pair of pre-images are assumed to be sorted.
863       */
864       function verify(
865           bytes32[] memory proof,
866           bytes32 root,
867           bytes32 leaf
868       ) internal pure returns (bool) {
869           return processProof(proof, leaf) == root;
870       }
871 
872       /**
873       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
874       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
875       * hash matches the root of the tree. When processing the proof, the pairs
876       * of leafs & pre-images are assumed to be sorted.
877       *
878       * _Available since v4.4._
879       */
880       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
881           bytes32 computedHash = leaf;
882           for (uint256 i = 0; i < proof.length; i++) {
883               bytes32 proofElement = proof[i];
884               if (computedHash <= proofElement) {
885                   // Hash(current computed hash + current element of the proof)
886                   computedHash = _efficientHash(computedHash, proofElement);
887               } else {
888                   // Hash(current element of the proof + current computed hash)
889                   computedHash = _efficientHash(proofElement, computedHash);
890               }
891           }
892           return computedHash;
893       }
894 
895       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
896           assembly {
897               mstore(0x00, a)
898               mstore(0x20, b)
899               value := keccak256(0x00, 0x40)
900           }
901       }
902   }
903 
904 
905   // File: Allowlist.sol
906 
907   pragma solidity ^0.8.0;
908 
909   abstract contract Allowlist is Teams {
910     bytes32 public merkleRoot;
911     bool public onlyAllowlistMode = false;
912 
913     /**
914      * @dev Update merkle root to reflect changes in Allowlist
915      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
916      */
917     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
918       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
919       merkleRoot = _newMerkleRoot;
920     }
921 
922     /**
923      * @dev Check the proof of an address if valid for merkle root
924      * @param _to address to check for proof
925      * @param _merkleProof Proof of the address to validate against root and leaf
926      */
927     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
928       require(merkleRoot != 0, "Merkle root is not set!");
929       bytes32 leaf = keccak256(abi.encodePacked(_to));
930 
931       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
932     }
933 
934     
935     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
936       onlyAllowlistMode = true;
937     }
938 
939     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
940         onlyAllowlistMode = false;
941     }
942   }
943   
944   
945 /**
946  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
947  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
948  *
949  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
950  * 
951  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
952  *
953  * Does not support burning tokens to address(0).
954  */
955 contract ERC721A is
956   Context,
957   ERC165,
958   IERC721,
959   IERC721Metadata,
960   IERC721Enumerable,
961   Teams
962 {
963   using Address for address;
964   using Strings for uint256;
965 
966   struct TokenOwnership {
967     address addr;
968     uint64 startTimestamp;
969   }
970 
971   struct AddressData {
972     uint128 balance;
973     uint128 numberMinted;
974   }
975 
976   uint256 private currentIndex;
977 
978   uint256 public immutable collectionSize;
979   uint256 public maxBatchSize;
980 
981   // Token name
982   string private _name;
983 
984   // Token symbol
985   string private _symbol;
986 
987   // Mapping from token ID to ownership details
988   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
989   mapping(uint256 => TokenOwnership) private _ownerships;
990 
991   // Mapping owner address to address data
992   mapping(address => AddressData) private _addressData;
993 
994   // Mapping from token ID to approved address
995   mapping(uint256 => address) private _tokenApprovals;
996 
997   // Mapping from owner to operator approvals
998   mapping(address => mapping(address => bool)) private _operatorApprovals;
999 
1000   /* @dev Mapping of restricted operator approvals set by contract Owner
1001   * This serves as an optional addition to ERC-721 so
1002   * that the contract owner can elect to prevent specific addresses/contracts
1003   * from being marked as the approver for a token. The reason for this
1004   * is that some projects may want to retain control of where their tokens can/can not be listed
1005   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1006   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1007   */
1008   mapping(address => bool) public restrictedApprovalAddresses;
1009 
1010   /**
1011    * @dev
1012    * maxBatchSize refers to how much a minter can mint at a time.
1013    * collectionSize_ refers to how many tokens are in the collection.
1014    */
1015   constructor(
1016     string memory name_,
1017     string memory symbol_,
1018     uint256 maxBatchSize_,
1019     uint256 collectionSize_
1020   ) {
1021     require(
1022       collectionSize_ > 0,
1023       "ERC721A: collection must have a nonzero supply"
1024     );
1025     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1026     _name = name_;
1027     _symbol = symbol_;
1028     maxBatchSize = maxBatchSize_;
1029     collectionSize = collectionSize_;
1030     currentIndex = _startTokenId();
1031   }
1032 
1033   /**
1034   * To change the starting tokenId, please override this function.
1035   */
1036   function _startTokenId() internal view virtual returns (uint256) {
1037     return 1;
1038   }
1039 
1040   /**
1041    * @dev See {IERC721Enumerable-totalSupply}.
1042    */
1043   function totalSupply() public view override returns (uint256) {
1044     return _totalMinted();
1045   }
1046 
1047   function currentTokenId() public view returns (uint256) {
1048     return _totalMinted();
1049   }
1050 
1051   function getNextTokenId() public view returns (uint256) {
1052       return _totalMinted() + 1;
1053   }
1054 
1055   /**
1056   * Returns the total amount of tokens minted in the contract.
1057   */
1058   function _totalMinted() internal view returns (uint256) {
1059     unchecked {
1060       return currentIndex - _startTokenId();
1061     }
1062   }
1063 
1064   /**
1065    * @dev See {IERC721Enumerable-tokenByIndex}.
1066    */
1067   function tokenByIndex(uint256 index) public view override returns (uint256) {
1068     require(index < totalSupply(), "ERC721A: global index out of bounds");
1069     return index;
1070   }
1071 
1072   /**
1073    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1074    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1075    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1076    */
1077   function tokenOfOwnerByIndex(address owner, uint256 index)
1078     public
1079     view
1080     override
1081     returns (uint256)
1082   {
1083     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1084     uint256 numMintedSoFar = totalSupply();
1085     uint256 tokenIdsIdx = 0;
1086     address currOwnershipAddr = address(0);
1087     for (uint256 i = 0; i < numMintedSoFar; i++) {
1088       TokenOwnership memory ownership = _ownerships[i];
1089       if (ownership.addr != address(0)) {
1090         currOwnershipAddr = ownership.addr;
1091       }
1092       if (currOwnershipAddr == owner) {
1093         if (tokenIdsIdx == index) {
1094           return i;
1095         }
1096         tokenIdsIdx++;
1097       }
1098     }
1099     revert("ERC721A: unable to get token of owner by index");
1100   }
1101 
1102   /**
1103    * @dev See {IERC165-supportsInterface}.
1104    */
1105   function supportsInterface(bytes4 interfaceId)
1106     public
1107     view
1108     virtual
1109     override(ERC165, IERC165)
1110     returns (bool)
1111   {
1112     return
1113       interfaceId == type(IERC721).interfaceId ||
1114       interfaceId == type(IERC721Metadata).interfaceId ||
1115       interfaceId == type(IERC721Enumerable).interfaceId ||
1116       super.supportsInterface(interfaceId);
1117   }
1118 
1119   /**
1120    * @dev See {IERC721-balanceOf}.
1121    */
1122   function balanceOf(address owner) public view override returns (uint256) {
1123     require(owner != address(0), "ERC721A: balance query for the zero address");
1124     return uint256(_addressData[owner].balance);
1125   }
1126 
1127   function _numberMinted(address owner) internal view returns (uint256) {
1128     require(
1129       owner != address(0),
1130       "ERC721A: number minted query for the zero address"
1131     );
1132     return uint256(_addressData[owner].numberMinted);
1133   }
1134 
1135   function ownershipOf(uint256 tokenId)
1136     internal
1137     view
1138     returns (TokenOwnership memory)
1139   {
1140     uint256 curr = tokenId;
1141 
1142     unchecked {
1143         if (_startTokenId() <= curr && curr < currentIndex) {
1144             TokenOwnership memory ownership = _ownerships[curr];
1145             if (ownership.addr != address(0)) {
1146                 return ownership;
1147             }
1148 
1149             // Invariant:
1150             // There will always be an ownership that has an address and is not burned
1151             // before an ownership that does not have an address and is not burned.
1152             // Hence, curr will not underflow.
1153             while (true) {
1154                 curr--;
1155                 ownership = _ownerships[curr];
1156                 if (ownership.addr != address(0)) {
1157                     return ownership;
1158                 }
1159             }
1160         }
1161     }
1162 
1163     revert("ERC721A: unable to determine the owner of token");
1164   }
1165 
1166   /**
1167    * @dev See {IERC721-ownerOf}.
1168    */
1169   function ownerOf(uint256 tokenId) public view override returns (address) {
1170     return ownershipOf(tokenId).addr;
1171   }
1172 
1173   /**
1174    * @dev See {IERC721Metadata-name}.
1175    */
1176   function name() public view virtual override returns (string memory) {
1177     return _name;
1178   }
1179 
1180   /**
1181    * @dev See {IERC721Metadata-symbol}.
1182    */
1183   function symbol() public view virtual override returns (string memory) {
1184     return _symbol;
1185   }
1186 
1187   /**
1188    * @dev See {IERC721Metadata-tokenURI}.
1189    */
1190   function tokenURI(uint256 tokenId)
1191     public
1192     view
1193     virtual
1194     override
1195     returns (string memory)
1196   {
1197     string memory baseURI = _baseURI();
1198     return
1199       bytes(baseURI).length > 0
1200         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1201         : "";
1202   }
1203 
1204   /**
1205    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1206    * token will be the concatenation of the baseURI and the tokenId. Empty
1207    * by default, can be overriden in child contracts.
1208    */
1209   function _baseURI() internal view virtual returns (string memory) {
1210     return "";
1211   }
1212 
1213   /**
1214    * @dev Sets the value for an address to be in the restricted approval address pool.
1215    * Setting an address to true will disable token owners from being able to mark the address
1216    * for approval for trading. This would be used in theory to prevent token owners from listing
1217    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1218    * @param _address the marketplace/user to modify restriction status of
1219    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1220    */
1221   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1222     restrictedApprovalAddresses[_address] = _isRestricted;
1223   }
1224 
1225   /**
1226    * @dev See {IERC721-approve}.
1227    */
1228   function approve(address to, uint256 tokenId) public override {
1229     address owner = ERC721A.ownerOf(tokenId);
1230     require(to != owner, "ERC721A: approval to current owner");
1231     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1232 
1233     require(
1234       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1235       "ERC721A: approve caller is not owner nor approved for all"
1236     );
1237 
1238     _approve(to, tokenId, owner);
1239   }
1240 
1241   /**
1242    * @dev See {IERC721-getApproved}.
1243    */
1244   function getApproved(uint256 tokenId) public view override returns (address) {
1245     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1246 
1247     return _tokenApprovals[tokenId];
1248   }
1249 
1250   /**
1251    * @dev See {IERC721-setApprovalForAll}.
1252    */
1253   function setApprovalForAll(address operator, bool approved) public override {
1254     require(operator != _msgSender(), "ERC721A: approve to caller");
1255     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1256 
1257     _operatorApprovals[_msgSender()][operator] = approved;
1258     emit ApprovalForAll(_msgSender(), operator, approved);
1259   }
1260 
1261   /**
1262    * @dev See {IERC721-isApprovedForAll}.
1263    */
1264   function isApprovedForAll(address owner, address operator)
1265     public
1266     view
1267     virtual
1268     override
1269     returns (bool)
1270   {
1271     return _operatorApprovals[owner][operator];
1272   }
1273 
1274   /**
1275    * @dev See {IERC721-transferFrom}.
1276    */
1277   function transferFrom(
1278     address from,
1279     address to,
1280     uint256 tokenId
1281   ) public override {
1282     _transfer(from, to, tokenId);
1283   }
1284 
1285   /**
1286    * @dev See {IERC721-safeTransferFrom}.
1287    */
1288   function safeTransferFrom(
1289     address from,
1290     address to,
1291     uint256 tokenId
1292   ) public override {
1293     safeTransferFrom(from, to, tokenId, "");
1294   }
1295 
1296   /**
1297    * @dev See {IERC721-safeTransferFrom}.
1298    */
1299   function safeTransferFrom(
1300     address from,
1301     address to,
1302     uint256 tokenId,
1303     bytes memory _data
1304   ) public override {
1305     _transfer(from, to, tokenId);
1306     require(
1307       _checkOnERC721Received(from, to, tokenId, _data),
1308       "ERC721A: transfer to non ERC721Receiver implementer"
1309     );
1310   }
1311 
1312   /**
1313    * @dev Returns whether tokenId exists.
1314    *
1315    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1316    *
1317    * Tokens start existing when they are minted (_mint),
1318    */
1319   function _exists(uint256 tokenId) internal view returns (bool) {
1320     return _startTokenId() <= tokenId && tokenId < currentIndex;
1321   }
1322 
1323   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1324     _safeMint(to, quantity, isAdminMint, "");
1325   }
1326 
1327   /**
1328    * @dev Mints quantity tokens and transfers them to to.
1329    *
1330    * Requirements:
1331    *
1332    * - there must be quantity tokens remaining unminted in the total collection.
1333    * - to cannot be the zero address.
1334    * - quantity cannot be larger than the max batch size.
1335    *
1336    * Emits a {Transfer} event.
1337    */
1338   function _safeMint(
1339     address to,
1340     uint256 quantity,
1341     bool isAdminMint,
1342     bytes memory _data
1343   ) internal {
1344     uint256 startTokenId = currentIndex;
1345     require(to != address(0), "ERC721A: mint to the zero address");
1346     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1347     require(!_exists(startTokenId), "ERC721A: token already minted");
1348 
1349     // For admin mints we do not want to enforce the maxBatchSize limit
1350     if (isAdminMint == false) {
1351         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1352     }
1353 
1354     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1355 
1356     AddressData memory addressData = _addressData[to];
1357     _addressData[to] = AddressData(
1358       addressData.balance + uint128(quantity),
1359       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1360     );
1361     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1362 
1363     uint256 updatedIndex = startTokenId;
1364 
1365     for (uint256 i = 0; i < quantity; i++) {
1366       emit Transfer(address(0), to, updatedIndex);
1367       require(
1368         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1369         "ERC721A: transfer to non ERC721Receiver implementer"
1370       );
1371       updatedIndex++;
1372     }
1373 
1374     currentIndex = updatedIndex;
1375     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1376   }
1377 
1378   /**
1379    * @dev Transfers tokenId from from to to.
1380    *
1381    * Requirements:
1382    *
1383    * - to cannot be the zero address.
1384    * - tokenId token must be owned by from.
1385    *
1386    * Emits a {Transfer} event.
1387    */
1388   function _transfer(
1389     address from,
1390     address to,
1391     uint256 tokenId
1392   ) private {
1393     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1394 
1395     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1396       getApproved(tokenId) == _msgSender() ||
1397       isApprovedForAll(prevOwnership.addr, _msgSender()));
1398 
1399     require(
1400       isApprovedOrOwner,
1401       "ERC721A: transfer caller is not owner nor approved"
1402     );
1403 
1404     require(
1405       prevOwnership.addr == from,
1406       "ERC721A: transfer from incorrect owner"
1407     );
1408     require(to != address(0), "ERC721A: transfer to the zero address");
1409 
1410     _beforeTokenTransfers(from, to, tokenId, 1);
1411 
1412     // Clear approvals from the previous owner
1413     _approve(address(0), tokenId, prevOwnership.addr);
1414 
1415     _addressData[from].balance -= 1;
1416     _addressData[to].balance += 1;
1417     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1418 
1419     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1420     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1421     uint256 nextTokenId = tokenId + 1;
1422     if (_ownerships[nextTokenId].addr == address(0)) {
1423       if (_exists(nextTokenId)) {
1424         _ownerships[nextTokenId] = TokenOwnership(
1425           prevOwnership.addr,
1426           prevOwnership.startTimestamp
1427         );
1428       }
1429     }
1430 
1431     emit Transfer(from, to, tokenId);
1432     _afterTokenTransfers(from, to, tokenId, 1);
1433   }
1434 
1435   /**
1436    * @dev Approve to to operate on tokenId
1437    *
1438    * Emits a {Approval} event.
1439    */
1440   function _approve(
1441     address to,
1442     uint256 tokenId,
1443     address owner
1444   ) private {
1445     _tokenApprovals[tokenId] = to;
1446     emit Approval(owner, to, tokenId);
1447   }
1448 
1449   uint256 public nextOwnerToExplicitlySet = 0;
1450 
1451   /**
1452    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1453    */
1454   function _setOwnersExplicit(uint256 quantity) internal {
1455     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1456     require(quantity > 0, "quantity must be nonzero");
1457     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1458 
1459     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1460     if (endIndex > collectionSize - 1) {
1461       endIndex = collectionSize - 1;
1462     }
1463     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1464     require(_exists(endIndex), "not enough minted yet for this cleanup");
1465     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1466       if (_ownerships[i].addr == address(0)) {
1467         TokenOwnership memory ownership = ownershipOf(i);
1468         _ownerships[i] = TokenOwnership(
1469           ownership.addr,
1470           ownership.startTimestamp
1471         );
1472       }
1473     }
1474     nextOwnerToExplicitlySet = endIndex + 1;
1475   }
1476 
1477   /**
1478    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1479    * The call is not executed if the target address is not a contract.
1480    *
1481    * @param from address representing the previous owner of the given token ID
1482    * @param to target address that will receive the tokens
1483    * @param tokenId uint256 ID of the token to be transferred
1484    * @param _data bytes optional data to send along with the call
1485    * @return bool whether the call correctly returned the expected magic value
1486    */
1487   function _checkOnERC721Received(
1488     address from,
1489     address to,
1490     uint256 tokenId,
1491     bytes memory _data
1492   ) private returns (bool) {
1493     if (to.isContract()) {
1494       try
1495         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1496       returns (bytes4 retval) {
1497         return retval == IERC721Receiver(to).onERC721Received.selector;
1498       } catch (bytes memory reason) {
1499         if (reason.length == 0) {
1500           revert("ERC721A: transfer to non ERC721Receiver implementer");
1501         } else {
1502           assembly {
1503             revert(add(32, reason), mload(reason))
1504           }
1505         }
1506       }
1507     } else {
1508       return true;
1509     }
1510   }
1511 
1512   /**
1513    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1514    *
1515    * startTokenId - the first token id to be transferred
1516    * quantity - the amount to be transferred
1517    *
1518    * Calling conditions:
1519    *
1520    * - When from and to are both non-zero, from's tokenId will be
1521    * transferred to to.
1522    * - When from is zero, tokenId will be minted for to.
1523    */
1524   function _beforeTokenTransfers(
1525     address from,
1526     address to,
1527     uint256 startTokenId,
1528     uint256 quantity
1529   ) internal virtual {}
1530 
1531   /**
1532    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1533    * minting.
1534    *
1535    * startTokenId - the first token id to be transferred
1536    * quantity - the amount to be transferred
1537    *
1538    * Calling conditions:
1539    *
1540    * - when from and to are both non-zero.
1541    * - from and to are never both zero.
1542    */
1543   function _afterTokenTransfers(
1544     address from,
1545     address to,
1546     uint256 startTokenId,
1547     uint256 quantity
1548   ) internal virtual {}
1549 }
1550 
1551 
1552 
1553   
1554 abstract contract Ramppable {
1555   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1556 
1557   modifier isRampp() {
1558       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1559       _;
1560   }
1561 }
1562 
1563 
1564   
1565   
1566 interface IERC20 {
1567   function allowance(address owner, address spender) external view returns (uint256);
1568   function transfer(address _to, uint256 _amount) external returns (bool);
1569   function balanceOf(address account) external view returns (uint256);
1570   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1571 }
1572 
1573 // File: WithdrawableV2
1574 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1575 // ERC-20 Payouts are limited to a single payout address. This feature 
1576 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1577 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1578 abstract contract WithdrawableV2 is Teams, Ramppable {
1579   struct acceptedERC20 {
1580     bool isActive;
1581     uint256 chargeAmount;
1582   }
1583 
1584   
1585   mapping(address => acceptedERC20) private allowedTokenContracts;
1586   address[] public payableAddresses = [RAMPPADDRESS,0xF07348D37642439b584E744161F70fB2fb5162b9];
1587   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1588   address public erc20Payable = 0xF07348D37642439b584E744161F70fB2fb5162b9;
1589   uint256[] public payableFees = [5,95];
1590   uint256[] public surchargePayableFees = [100];
1591   uint256 public payableAddressCount = 2;
1592   uint256 public surchargePayableAddressCount = 1;
1593   uint256 public ramppSurchargeBalance = 0 ether;
1594   uint256 public ramppSurchargeFee = 0.001 ether;
1595   bool public onlyERC20MintingMode = false;
1596   
1597 
1598   /**
1599   * @dev Calculates the true payable balance of the contract as the
1600   * value on contract may be from ERC-20 mint surcharges and not 
1601   * public mint charges - which are not eligable for rev share & user withdrawl
1602   */
1603   function calcAvailableBalance() public view returns(uint256) {
1604     return address(this).balance - ramppSurchargeBalance;
1605   }
1606 
1607   function withdrawAll() public onlyTeamOrOwner {
1608       require(calcAvailableBalance() > 0);
1609       _withdrawAll();
1610   }
1611   
1612   function withdrawAllRampp() public isRampp {
1613       require(calcAvailableBalance() > 0);
1614       _withdrawAll();
1615   }
1616 
1617   function _withdrawAll() private {
1618       uint256 balance = calcAvailableBalance();
1619       
1620       for(uint i=0; i < payableAddressCount; i++ ) {
1621           _widthdraw(
1622               payableAddresses[i],
1623               (balance * payableFees[i]) / 100
1624           );
1625       }
1626   }
1627   
1628   function _widthdraw(address _address, uint256 _amount) private {
1629       (bool success, ) = _address.call{value: _amount}("");
1630       require(success, "Transfer failed.");
1631   }
1632 
1633   /**
1634   * @dev This function is similiar to the regular withdraw but operates only on the
1635   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1636   **/
1637   function _withdrawAllSurcharges() private {
1638     uint256 balance = ramppSurchargeBalance;
1639     if(balance == 0) { return; }
1640     
1641     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1642         _widthdraw(
1643             surchargePayableAddresses[i],
1644             (balance * surchargePayableFees[i]) / 100
1645         );
1646     }
1647     ramppSurchargeBalance = 0 ether;
1648   }
1649 
1650   /**
1651   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1652   * in the event ERC-20 tokens are paid to the contract for mints. This will
1653   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1654   * @param _tokenContract contract of ERC-20 token to withdraw
1655   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1656   */
1657   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1658     require(_amountToWithdraw > 0);
1659     IERC20 tokenContract = IERC20(_tokenContract);
1660     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1661     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1662     _withdrawAllSurcharges();
1663   }
1664 
1665   /**
1666   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1667   */
1668   function withdrawRamppSurcharges() public isRampp {
1669     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1670     _withdrawAllSurcharges();
1671   }
1672 
1673    /**
1674   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1675   */
1676   function addSurcharge() internal {
1677     ramppSurchargeBalance += ramppSurchargeFee;
1678   }
1679   
1680   /**
1681   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1682   */
1683   function hasSurcharge() internal returns(bool) {
1684     return msg.value == ramppSurchargeFee;
1685   }
1686 
1687   /**
1688   * @dev Set surcharge fee for using ERC-20 payments on contract
1689   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1690   */
1691   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1692     ramppSurchargeFee = _newSurcharge;
1693   }
1694 
1695   /**
1696   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1697   * @param _erc20TokenContract address of ERC-20 contract in question
1698   */
1699   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1700     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1701   }
1702 
1703   /**
1704   * @dev get the value of tokens to transfer for user of an ERC-20
1705   * @param _erc20TokenContract address of ERC-20 contract in question
1706   */
1707   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1708     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1709     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1710   }
1711 
1712   /**
1713   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1714   * @param _erc20TokenContract address of ERC-20 contract in question
1715   * @param _isActive default status of if contract should be allowed to accept payments
1716   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1717   */
1718   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1719     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1720     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1721   }
1722 
1723   /**
1724   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1725   * it will assume the default value of zero. This should not be used to create new payment tokens.
1726   * @param _erc20TokenContract address of ERC-20 contract in question
1727   */
1728   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1729     allowedTokenContracts[_erc20TokenContract].isActive = true;
1730   }
1731 
1732   /**
1733   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1734   * it will assume the default value of zero. This should not be used to create new payment tokens.
1735   * @param _erc20TokenContract address of ERC-20 contract in question
1736   */
1737   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1738     allowedTokenContracts[_erc20TokenContract].isActive = false;
1739   }
1740 
1741   /**
1742   * @dev Enable only ERC-20 payments for minting on this contract
1743   */
1744   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1745     onlyERC20MintingMode = true;
1746   }
1747 
1748   /**
1749   * @dev Disable only ERC-20 payments for minting on this contract
1750   */
1751   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1752     onlyERC20MintingMode = false;
1753   }
1754 
1755   /**
1756   * @dev Set the payout of the ERC-20 token payout to a specific address
1757   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1758   */
1759   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1760     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1761     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1762     erc20Payable = _newErc20Payable;
1763   }
1764 
1765   /**
1766   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1767   */
1768   function resetRamppSurchargeBalance() public isRampp {
1769     ramppSurchargeBalance = 0 ether;
1770   }
1771 
1772   /**
1773   * @dev Allows Rampp wallet to update its own reference as well as update
1774   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1775   * and since Rampp is always the first address this function is limited to the rampp payout only.
1776   * @param _newAddress updated Rampp Address
1777   */
1778   function setRamppAddress(address _newAddress) public isRampp {
1779     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1780     RAMPPADDRESS = _newAddress;
1781     payableAddresses[0] = _newAddress;
1782   }
1783 }
1784 
1785 
1786   
1787 // File: isFeeable.sol
1788 abstract contract Feeable is Teams {
1789   uint256 public PRICE = 0 ether;
1790 
1791   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1792     PRICE = _feeInWei;
1793   }
1794 
1795   function getPrice(uint256 _count) public view returns (uint256) {
1796     return PRICE * _count;
1797   }
1798 }
1799 
1800   
1801   
1802   
1803 abstract contract RamppERC721A is 
1804     Ownable,
1805     Teams,
1806     ERC721A,
1807     WithdrawableV2,
1808     ReentrancyGuard 
1809     , Feeable 
1810     , Allowlist 
1811     
1812 {
1813   constructor(
1814     string memory tokenName,
1815     string memory tokenSymbol
1816   ) ERC721A(tokenName, tokenSymbol, 10, 1500) { }
1817     uint8 public CONTRACT_VERSION = 2;
1818     string public _baseTokenURI = "ipfs://QmNgN6o1KD1k2ynXiiSsp8GTMesmj1JQozJpeXxEaxb2ow/";
1819 
1820     bool public mintingOpen = false;
1821     bool public isRevealed = false;
1822     
1823     uint256 public MAX_WALLET_MINTS = 10;
1824 
1825   
1826     /////////////// Admin Mint Functions
1827     /**
1828      * @dev Mints a token to an address with a tokenURI.
1829      * This is owner only and allows a fee-free drop
1830      * @param _to address of the future owner of the token
1831      * @param _qty amount of tokens to drop the owner
1832      */
1833      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1834          require(_qty > 0, "Must mint at least 1 token.");
1835          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 1500");
1836          _safeMint(_to, _qty, true);
1837      }
1838 
1839   
1840     /////////////// GENERIC MINT FUNCTIONS
1841     /**
1842     * @dev Mints a single token to an address.
1843     * fee may or may not be required*
1844     * @param _to address of the future owner of the token
1845     */
1846     function mintTo(address _to) public payable {
1847         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1848         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1500");
1849         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1850         
1851         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1852         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1853         
1854         _safeMint(_to, 1, false);
1855     }
1856 
1857     /**
1858     * @dev Mints tokens to an address in batch.
1859     * fee may or may not be required*
1860     * @param _to address of the future owner of the token
1861     * @param _amount number of tokens to mint
1862     */
1863     function mintToMultiple(address _to, uint256 _amount) public payable {
1864         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1865         require(_amount >= 1, "Must mint at least 1 token");
1866         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1867         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1868         
1869         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1870         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1500");
1871         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1872 
1873         _safeMint(_to, _amount, false);
1874     }
1875 
1876     /**
1877      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1878      * fee may or may not be required*
1879      * @param _to address of the future owner of the token
1880      * @param _amount number of tokens to mint
1881      * @param _erc20TokenContract erc-20 token contract to mint with
1882      */
1883     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1884       require(_amount >= 1, "Must mint at least 1 token");
1885       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1886       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1500");
1887       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1888       
1889       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1890 
1891       // ERC-20 Specific pre-flight checks
1892       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1893       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1894       IERC20 payableToken = IERC20(_erc20TokenContract);
1895 
1896       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1897       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1898       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1899       
1900       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1901       require(transferComplete, "ERC-20 token was unable to be transferred");
1902       
1903       _safeMint(_to, _amount, false);
1904       addSurcharge();
1905     }
1906 
1907     function openMinting() public onlyTeamOrOwner {
1908         mintingOpen = true;
1909     }
1910 
1911     function stopMinting() public onlyTeamOrOwner {
1912         mintingOpen = false;
1913     }
1914 
1915   
1916     ///////////// ALLOWLIST MINTING FUNCTIONS
1917 
1918     /**
1919     * @dev Mints tokens to an address using an allowlist.
1920     * fee may or may not be required*
1921     * @param _to address of the future owner of the token
1922     * @param _merkleProof merkle proof array
1923     */
1924     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1925         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1926         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1927         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1928         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 1500");
1929         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1930         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1931         
1932 
1933         _safeMint(_to, 1, false);
1934     }
1935 
1936     /**
1937     * @dev Mints tokens to an address using an allowlist.
1938     * fee may or may not be required*
1939     * @param _to address of the future owner of the token
1940     * @param _amount number of tokens to mint
1941     * @param _merkleProof merkle proof array
1942     */
1943     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1944         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1945         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1946         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1947         require(_amount >= 1, "Must mint at least 1 token");
1948         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1949 
1950         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1951         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1500");
1952         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1953         
1954 
1955         _safeMint(_to, _amount, false);
1956     }
1957 
1958     /**
1959     * @dev Mints tokens to an address using an allowlist.
1960     * fee may or may not be required*
1961     * @param _to address of the future owner of the token
1962     * @param _amount number of tokens to mint
1963     * @param _merkleProof merkle proof array
1964     * @param _erc20TokenContract erc-20 token contract to mint with
1965     */
1966     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1967       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1968       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1969       require(_amount >= 1, "Must mint at least 1 token");
1970       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1971       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1972       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 1500");
1973       
1974     
1975       // ERC-20 Specific pre-flight checks
1976       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1977       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1978       IERC20 payableToken = IERC20(_erc20TokenContract);
1979     
1980       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1981       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1982       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1983       
1984       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1985       require(transferComplete, "ERC-20 token was unable to be transferred");
1986       
1987       _safeMint(_to, _amount, false);
1988       addSurcharge();
1989     }
1990 
1991     /**
1992      * @dev Enable allowlist minting fully by enabling both flags
1993      * This is a convenience function for the Rampp user
1994      */
1995     function openAllowlistMint() public onlyTeamOrOwner {
1996         enableAllowlistOnlyMode();
1997         mintingOpen = true;
1998     }
1999 
2000     /**
2001      * @dev Close allowlist minting fully by disabling both flags
2002      * This is a convenience function for the Rampp user
2003      */
2004     function closeAllowlistMint() public onlyTeamOrOwner {
2005         disableAllowlistOnlyMode();
2006         mintingOpen = false;
2007     }
2008 
2009 
2010   
2011     /**
2012     * @dev Check if wallet over MAX_WALLET_MINTS
2013     * @param _address address in question to check if minted count exceeds max
2014     */
2015     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2016         require(_amount >= 1, "Amount must be greater than or equal to 1");
2017         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2018     }
2019 
2020     /**
2021     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2022     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2023     */
2024     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2025         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2026         MAX_WALLET_MINTS = _newWalletMax;
2027     }
2028     
2029 
2030   
2031     /**
2032      * @dev Allows owner to set Max mints per tx
2033      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2034      */
2035      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2036          require(_newMaxMint >= 1, "Max mint must be at least 1");
2037          maxBatchSize = _newMaxMint;
2038      }
2039     
2040 
2041   
2042     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2043         require(isRevealed == false, "Tokens are already unveiled");
2044         _baseTokenURI = _updatedTokenURI;
2045         isRevealed = true;
2046     }
2047     
2048 
2049   function _baseURI() internal view virtual override returns(string memory) {
2050     return _baseTokenURI;
2051   }
2052 
2053   function baseTokenURI() public view returns(string memory) {
2054     return _baseTokenURI;
2055   }
2056 
2057   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2058     _baseTokenURI = baseURI;
2059   }
2060 
2061   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2062     return ownershipOf(tokenId);
2063   }
2064 }
2065 
2066 
2067   
2068 // File: contracts/TheSkOuLsContract.sol
2069 //SPDX-License-Identifier: MIT
2070 
2071 pragma solidity ^0.8.0;
2072 
2073 contract TheSkOuLsContract is RamppERC721A {
2074     constructor() RamppERC721A("The SkOULs", "SKOUL"){}
2075 }
2076   
2077 //*********************************************************************//
2078 //*********************************************************************//  
2079 //                       Mintplex v2.1.0
2080 //
2081 //         This smart contract was generated by mintplex.xyz.
2082 //            Mintplex allows creators like you to launch 
2083 //             large scale NFT communities without code!
2084 //
2085 //    Mintplex is not responsible for the content of this contract and
2086 //        hopes it is being used in a responsible and kind way.  
2087 //       Mintplex is not associated or affiliated with this project.                                                    
2088 //             Twitter: @MintplexNFT ---- mintplex.xyz
2089 //*********************************************************************//                                                     
2090 //*********************************************************************// 
