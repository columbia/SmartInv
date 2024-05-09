1 // SPDX-License-Identifier: MIT
2 
3 // File 1: Address.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
173      * but performing a delegate call.
174      *
175      * _Available since v3.4._
176      */
177     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
178         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(
188         address target,
189         bytes memory data,
190         string memory errorMessage
191     ) internal returns (bytes memory) {
192         require(isContract(target), "Address: delegate call to non-contract");
193 
194         (bool success, bytes memory returndata) = target.delegatecall(data);
195         return verifyCallResult(success, returndata, errorMessage);
196     }
197 
198     /**
199      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
200      * revert reason using the provided one.
201      *
202      * _Available since v4.3._
203      */
204     function verifyCallResult(
205         bool success,
206         bytes memory returndata,
207         string memory errorMessage
208     ) internal pure returns (bytes memory) {
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 assembly {
217                     let returndata_size := mload(returndata)
218                     revert(add(32, returndata), returndata_size)
219                 }
220             } else {
221                 revert(errorMessage);
222             }
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Contract module that helps prevent reentrant calls to a function.
236  *
237  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
238  * available, which can be applied to functions to make sure there are no nested
239  * (reentrant) calls to them.
240  *
241  * Note that because there is a single `nonReentrant` guard, functions marked as
242  * `nonReentrant` may not call one another. This can be worked around by making
243  * those functions `private`, and then adding `external` `nonReentrant` entry
244  * points to them.
245  *
246  * TIP: If you would like to learn more about reentrancy and alternative ways
247  * to protect against it, check out our blog post
248  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
249  */
250 abstract contract ReentrancyGuard {
251     // Booleans are more expensive than uint256 or any type that takes up a full
252     // word because each write operation emits an extra SLOAD to first read the
253     // slot's contents, replace the bits taken up by the boolean, and then write
254     // back. This is the compiler's defense against contract upgrades and
255     // pointer aliasing, and it cannot be disabled.
256 
257     // The values being non-zero value makes deployment a bit more expensive,
258     // but in exchange the refund on every call to nonReentrant will be lower in
259     // amount. Since refunds are capped to a percentage of the total
260     // transaction's gas, it is best to keep them low in cases like this one, to
261     // increase the likelihood of the full refund coming into effect.
262     uint256 private constant _NOT_ENTERED = 1;
263     uint256 private constant _ENTERED = 2;
264 
265     uint256 private _status;
266 
267     constructor() {
268         _status = _NOT_ENTERED;
269     }
270 
271     /**
272      * @dev Prevents a contract from calling itself, directly or indirectly.
273      * Calling a `nonReentrant` function from another `nonReentrant`
274      * function is not supported. It is possible to prevent this from happening
275      * by making the `nonReentrant` function external, and making it call a
276      * `private` function that does the actual work.
277      */
278     modifier nonReentrant() {
279         // On the first call to nonReentrant, _notEntered will be true
280         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
281 
282         // Any calls to nonReentrant after this point will fail
283         _status = _ENTERED;
284 
285         _;
286 
287         // By storing the original value once again, a refund is triggered (see
288         // https://eips.ethereum.org/EIPS/eip-2200)
289         _status = _NOT_ENTERED;
290     }
291 }
292 
293 // FILE 2: Context.sol
294 pragma solidity ^0.8.0;
295 
296 /*
297  * @dev Provides information about the current execution context, including the
298  * sender of the transaction and its data. While these are generally available
299  * via msg.sender and msg.data, they should not be accessed in such a direct
300  * manner, since when dealing with meta-transactions the account sending and
301  * paying for execution may not be the actual sender (as far as an application
302  * is concerned).
303  *
304  * This contract is only required for intermediate, library-like contracts.
305  */
306 abstract contract Context {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes calldata) {
312         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
313         return msg.data;
314     }
315 }
316 
317 // File 3: Strings.sol
318 
319 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev String operations.
325  */
326 library Strings {
327     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
328 
329     /**
330      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
331      */
332     function toString(uint256 value) internal pure returns (string memory) {
333         // Inspired by OraclizeAPI's implementation - MIT licence
334         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
335 
336         if (value == 0) {
337             return "0";
338         }
339         uint256 temp = value;
340         uint256 digits;
341         while (temp != 0) {
342             digits++;
343             temp /= 10;
344         }
345         bytes memory buffer = new bytes(digits);
346         while (value != 0) {
347             digits -= 1;
348             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
349             value /= 10;
350         }
351         return string(buffer);
352     }
353 
354     /**
355      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
356      */
357     function toHexString(uint256 value) internal pure returns (string memory) {
358         if (value == 0) {
359             return "0x00";
360         }
361         uint256 temp = value;
362         uint256 length = 0;
363         while (temp != 0) {
364             length++;
365             temp >>= 8;
366         }
367         return toHexString(value, length);
368     }
369 
370     /**
371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
372      */
373     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
374         bytes memory buffer = new bytes(2 * length + 2);
375         buffer[0] = "0";
376         buffer[1] = "x";
377         for (uint256 i = 2 * length + 1; i > 1; --i) {
378             buffer[i] = _HEX_SYMBOLS[value & 0xf];
379             value >>= 4;
380         }
381         require(value == 0, "Strings: hex length insufficient");
382         return string(buffer);
383     }
384 }
385 
386 
387 // File: @openzeppelin/contracts/utils/Counters.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @title Counters
396  * @author Matt Condon (@shrugs)
397  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
398  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
399  *
400  * Include with `using Counters for Counters.Counter;`
401  */
402 library Counters {
403     struct Counter {
404         // This variable should never be directly accessed by users of the library: interactions must be restricted to
405         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
406         // this feature: see https://github.com/ethereum/solidity/issues/4637
407         uint256 _value; // default: 0
408     }
409 
410     function current(Counter storage counter) internal view returns (uint256) {
411         return counter._value;
412     }
413 
414     function increment(Counter storage counter) internal {
415         unchecked {
416             counter._value += 1;
417         }
418     }
419 
420     function decrement(Counter storage counter) internal {
421         uint256 value = counter._value;
422         require(value > 0, "Counter: decrement overflow");
423         unchecked {
424             counter._value = value - 1;
425         }
426     }
427 
428     function reset(Counter storage counter) internal {
429         counter._value = 0;
430     }
431 }
432 
433 // File 4: Ownable.sol
434 
435 
436 pragma solidity ^0.8.0;
437 
438 
439 /**
440  * @dev Contract module which provides a basic access control mechanism, where
441  * there is an account (an owner) that can be granted exclusive access to
442  * specific functions.
443  *
444  * By default, the owner account will be the one that deploys the contract. This
445  * can later be changed with {transferOwnership}.
446  *
447  * This module is used through inheritance. It will make available the modifier
448  * `onlyOwner`, which can be applied to your functions to restrict their use to
449  * the owner.
450  */
451 abstract contract Ownable is Context {
452     address private _owner;
453 
454     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
455 
456     /**
457      * @dev Initializes the contract setting the deployer as the initial owner.
458      */
459     constructor () {
460         address msgSender = _msgSender();
461         _owner = msgSender;
462         emit OwnershipTransferred(address(0), msgSender);
463     }
464 
465     /**
466      * @dev Returns the address of the current owner.
467      */
468     function owner() public view virtual returns (address) {
469         return _owner;
470     }
471 
472     /**
473      * @dev Throws if called by any account other than the owner.
474      */
475     modifier onlyOwner() {
476         require(owner() == _msgSender(), "Ownable: caller is not the owner");
477         _;
478     }
479 
480     /**
481      * @dev Leaves the contract without owner. It will not be possible to call
482      * `onlyOwner` functions anymore. Can only be called by the current owner.
483      *
484      * NOTE: Renouncing ownership will leave the contract without an owner,
485      * thereby removing any functionality that is only available to the owner.
486      */
487     function renounceOwnership() public virtual onlyOwner {
488         emit OwnershipTransferred(_owner, address(0));
489         _owner = address(0);
490     }
491 
492     /**
493      * @dev Transfers ownership of the contract to a new account (`newOwner`).
494      * Can only be called by the current owner.
495      */
496     function transferOwnership(address newOwner) public virtual onlyOwner {
497         require(newOwner != address(0), "Ownable: new owner is the zero address");
498         emit OwnershipTransferred(_owner, newOwner);
499         _owner = newOwner;
500     }
501 }
502 
503 
504 
505 
506 
507 // File 5: IERC165.sol
508 
509 pragma solidity ^0.8.0;
510 
511 /**
512  * @dev Interface of the ERC165 standard, as defined in the
513  * https://eips.ethereum.org/EIPS/eip-165[EIP].
514  *
515  * Implementers can declare support of contract interfaces, which can then be
516  * queried by others ({ERC165Checker}).
517  *
518  * For an implementation, see {ERC165}.
519  */
520 interface IERC165 {
521     /**
522      * @dev Returns true if this contract implements the interface defined by
523      * `interfaceId`. See the corresponding
524      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
525      * to learn more about how these ids are created.
526      *
527      * This function call must use less than 30 000 gas.
528      */
529     function supportsInterface(bytes4 interfaceId) external view returns (bool);
530 }
531 
532 
533 // File 6: IERC721.sol
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Required interface of an ERC721 compliant contract.
540  */
541 interface IERC721 is IERC165 {
542     /**
543      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
544      */
545     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
546 
547     /**
548      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
549      */
550     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
551 
552     /**
553      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
554      */
555     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
556 
557     /**
558      * @dev Returns the number of tokens in ``owner``'s account.
559      */
560     function balanceOf(address owner) external view returns (uint256 balance);
561 
562     /**
563      * @dev Returns the owner of the `tokenId` token.
564      *
565      * Requirements:
566      *
567      * - `tokenId` must exist.
568      */
569     function ownerOf(uint256 tokenId) external view returns (address owner);
570 
571     /**
572      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
573      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(address from, address to, uint256 tokenId) external;
586 
587     /**
588      * @dev Transfers `tokenId` token from `from` to `to`.
589      *
590      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
591      *
592      * Requirements:
593      *
594      * - `from` cannot be the zero address.
595      * - `to` cannot be the zero address.
596      * - `tokenId` token must be owned by `from`.
597      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transferFrom(address from, address to, uint256 tokenId) external;
602 
603     /**
604      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
605      * The approval is cleared when the token is transferred.
606      *
607      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
608      *
609      * Requirements:
610      *
611      * - The caller must own the token or be an approved operator.
612      * - `tokenId` must exist.
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address to, uint256 tokenId) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Approve or remove `operator` as an operator for the caller.
629      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
630      *
631      * Requirements:
632      *
633      * - The `operator` cannot be the caller.
634      *
635      * Emits an {ApprovalForAll} event.
636      */
637     function setApprovalForAll(address operator, bool _approved) external;
638 
639     /**
640      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
641      *
642      * See {setApprovalForAll}
643      */
644     function isApprovedForAll(address owner, address operator) external view returns (bool);
645 
646     /**
647       * @dev Safely transfers `tokenId` token from `from` to `to`.
648       *
649       * Requirements:
650       *
651       * - `from` cannot be the zero address.
652       * - `to` cannot be the zero address.
653       * - `tokenId` token must exist and be owned by `from`.
654       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656       *
657       * Emits a {Transfer} event.
658       */
659     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
660 }
661 
662 
663 
664 // File 7: IERC721Metadata.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 interface IERC721Metadata is IERC721 {
677     /**
678      * @dev Returns the token collection name.
679      */
680     function name() external view returns (string memory);
681 
682     /**
683      * @dev Returns the token collection symbol.
684      */
685     function symbol() external view returns (string memory);
686 
687     /**
688      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
689      */
690     function tokenURI(uint256 tokenId) external returns (string memory);
691 }
692 
693 
694 
695 
696 // File 8: ERC165.sol
697 
698 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Implementation of the {IERC165} interface.
705  *
706  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
707  * for the additional interface id that will be supported. For example:
708  *
709  * ```solidity
710  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
712  * }
713  * ```
714  *
715  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
716  */
717 abstract contract ERC165 is IERC165 {
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
722         return interfaceId == type(IERC165).interfaceId;
723     }
724 }
725 
726 
727 // File 9: ERC721.sol
728 
729 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension, but not including the Enumerable extension, which is available separately as
737  * {ERC721Enumerable}.
738  */
739 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Token name
744     string private _name;
745 
746     // Token symbol
747     string private _symbol;
748 
749     // Mapping from token ID to owner address
750     mapping(uint256 => address) private _owners;
751 
752     // Mapping owner address to token count
753     mapping(address => uint256) private _balances;
754 
755     // Mapping from token ID to approved address
756     mapping(uint256 => address) private _tokenApprovals;
757 
758     // Mapping from owner to operator approvals
759     mapping(address => mapping(address => bool)) private _operatorApprovals;
760 
761     /**
762      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
763      */
764     constructor(string memory name_, string memory symbol_) {
765         _name = name_;
766         _symbol = symbol_;
767     }
768 
769     /**
770      * @dev See {IERC165-supportsInterface}.
771      */
772     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
773         return
774             interfaceId == type(IERC721).interfaceId ||
775             interfaceId == type(IERC721Metadata).interfaceId ||
776             super.supportsInterface(interfaceId);
777     }
778 
779     /**
780      * @dev See {IERC721-balanceOf}.
781      */
782     function balanceOf(address owner) public view virtual override returns (uint256) {
783         require(owner != address(0), "ERC721: balance query for the zero address");
784         return _balances[owner];
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
791         address owner = _owners[tokenId];
792         require(owner != address(0), "ERC721: owner query for nonexistent token");
793         return owner;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-name}.
798      */
799     function name() public view virtual override returns (string memory) {
800         return _name;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-symbol}.
805      */
806     function symbol() public view virtual override returns (string memory) {
807         return _symbol;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-tokenURI}.
812      */
813     function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
814         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
815 
816         string memory baseURI = _baseURI();
817         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
818     }
819 
820     /**
821      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
822      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
823      * by default, can be overridden in child contracts.
824      */
825     function _baseURI() internal view virtual returns (string memory) {
826         return "";
827     }
828 
829     /**
830      * @dev See {IERC721-approve}.
831      */
832     function approve(address to, uint256 tokenId) public virtual override {
833         address owner = ERC721.ownerOf(tokenId);
834         require(to != owner, "ERC721: approval to current owner");
835 
836         require(
837             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
838             "ERC721: approve caller is not owner nor approved for all"
839         );
840         if (to.isContract()) {
841             revert ("Token transfer to contract address is not allowed.");
842         } else {
843             _approve(to, tokenId);
844         }
845         // _approve(to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-getApproved}.
850      */
851     function getApproved(uint256 tokenId) public view virtual override returns (address) {
852         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
853 
854         return _tokenApprovals[tokenId];
855     }
856 
857     /**
858      * @dev See {IERC721-setApprovalForAll}.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         _setApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881 
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, "");
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
906         _safeTransfer(from, to, tokenId, _data);
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
911      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
912      *
913      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
914      *
915      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
916      * implement alternative mechanisms to perform token transfer, such as signature-based.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeTransfer(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _transfer(from, to, tokenId);
934         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      * and stop existing when they are burned (`_burn`).
944      */
945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
946         return _owners[tokenId] != address(0);
947     }
948 
949     /**
950      * @dev Returns whether `spender` is allowed to manage `tokenId`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
957         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
958         address owner = ERC721.ownerOf(tokenId);
959         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
960     }
961 
962     /**
963      * @dev Safely mints `tokenId` and transfers it to `to`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(address to, uint256 tokenId) internal virtual {
973         _safeMint(to, tokenId, "");
974     }
975 
976     /**
977      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
978      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
979      */
980     function _safeMint(
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) internal virtual {
985         _mint(to, tokenId);
986         require(
987             _checkOnERC721Received(address(0), to, tokenId, _data),
988             "ERC721: transfer to non ERC721Receiver implementer"
989         );
990     }
991 
992     /**
993      * @dev Mints `tokenId` and transfers it to `to`.
994      *
995      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
996      *
997      * Requirements:
998      *
999      * - `tokenId` must not exist.
1000      * - `to` cannot be the zero address.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(address to, uint256 tokenId) internal virtual {
1005         require(to != address(0), "ERC721: mint to the zero address");
1006         require(!_exists(tokenId), "ERC721: token already minted");
1007 
1008         _beforeTokenTransfer(address(0), to, tokenId);
1009 
1010         _balances[to] += 1;
1011         _owners[tokenId] = to;
1012 
1013         emit Transfer(address(0), to, tokenId);
1014 
1015         _afterTokenTransfer(address(0), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Destroys `tokenId`.
1020      * The approval is cleared when the token is burned.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _burn(uint256 tokenId) internal virtual {
1029         address owner = ERC721.ownerOf(tokenId);
1030 
1031         _beforeTokenTransfer(owner, address(0), tokenId);
1032 
1033         // Clear approvals
1034         _approve(address(0), tokenId);
1035 
1036         _balances[owner] -= 1;
1037         delete _owners[tokenId];
1038 
1039         emit Transfer(owner, address(0), tokenId);
1040 
1041         _afterTokenTransfer(owner, address(0), tokenId);
1042     }
1043 
1044     /**
1045      * @dev Transfers `tokenId` from `from` to `to`.
1046      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {
1060         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1061         require(to != address(0), "ERC721: transfer to the zero address");
1062 
1063         _beforeTokenTransfer(from, to, tokenId);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId);
1067 
1068         _balances[from] -= 1;
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(from, to, tokenId);
1073 
1074         _afterTokenTransfer(from, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Approve `to` to operate on `tokenId`
1079      *
1080      * Emits a {Approval} event.
1081      */
1082     function _approve(address to, uint256 tokenId) internal virtual {
1083         _tokenApprovals[tokenId] = to;
1084         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Approve `operator` to operate on all of `owner` tokens
1089      *
1090      * Emits a {ApprovalForAll} event.
1091      */
1092     function _setApprovalForAll(
1093         address owner,
1094         address operator,
1095         bool approved
1096     ) internal virtual {
1097         require(owner != operator, "ERC721: approve to caller");
1098         _operatorApprovals[owner][operator] = approved;
1099         emit ApprovalForAll(owner, operator, approved);
1100     }
1101 
1102     /**
1103      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1104      * The call is not executed if the target address is not a contract.
1105      *
1106      * @param from address representing the previous owner of the given token ID
1107      * @param to target address that will receive the tokens
1108      * @param tokenId uint256 ID of the token to be transferred
1109      * @param _data bytes optional data to send along with the call
1110      * @return bool whether the call correctly returned the expected magic value
1111      */
1112     function _checkOnERC721Received(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) private returns (bool) {
1118         if (to.isContract()) {
1119             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1120                 return retval == IERC721Receiver.onERC721Received.selector;
1121             } catch (bytes memory reason) {
1122                 if (reason.length == 0) {
1123                     revert("ERC721: transfer to non ERC721Receiver implementer");
1124                 } else {
1125                     assembly {
1126                         revert(add(32, reason), mload(reason))
1127                     }
1128                 }
1129             }
1130         } else {
1131             return true;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Hook that is called before any token transfer. This includes minting
1137      * and burning.
1138      *
1139      * Calling conditions:
1140      *
1141      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1142      * transferred to `to`.
1143      * - When `from` is zero, `tokenId` will be minted for `to`.
1144      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1145      * - `from` and `to` are never both zero.
1146      *
1147      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1148      */
1149     function _beforeTokenTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) internal virtual {}
1154 
1155     /**
1156      * @dev Hook that is called after any transfer of tokens. This includes
1157      * minting and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - when `from` and `to` are both non-zero.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _afterTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 }
1172 
1173 
1174 
1175 
1176 
1177 // File 10: IERC721Enumerable.sol
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 
1182 /**
1183  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1184  * @dev See https://eips.ethereum.org/EIPS/eip-721
1185  */
1186 interface IERC721Enumerable is IERC721 {
1187 
1188     /**
1189      * @dev Returns the total amount of tokens stored by the contract.
1190      */
1191     function totalSupply() external view returns (uint256);
1192 
1193     /**
1194      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1195      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1196      */
1197     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1198 
1199     /**
1200      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1201      * Use along with {totalSupply} to enumerate all tokens.
1202      */
1203     function tokenByIndex(uint256 index) external view returns (uint256);
1204 }
1205 
1206 
1207 
1208 
1209 
1210 
1211 // File 11: ERC721Enumerable.sol
1212 
1213 pragma solidity ^0.8.0;
1214 
1215 
1216 /**
1217  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1218  * enumerability of all the token ids in the contract as well as all token ids owned by each
1219  * account.
1220  */
1221 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1222     // Mapping from owner to list of owned token IDs
1223     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1224 
1225     // Mapping from token ID to index of the owner tokens list
1226     mapping(uint256 => uint256) private _ownedTokensIndex;
1227 
1228     // Array with all token ids, used for enumeration
1229     uint256[] private _allTokens;
1230 
1231     // Mapping from token id to position in the allTokens array
1232     mapping(uint256 => uint256) private _allTokensIndex;
1233 
1234     /**
1235      * @dev See {IERC165-supportsInterface}.
1236      */
1237     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1238         return interfaceId == type(IERC721Enumerable).interfaceId
1239             || super.supportsInterface(interfaceId);
1240     }
1241 
1242     /**
1243      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1244      */
1245     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1246         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1247         return _ownedTokens[owner][index];
1248     }
1249 
1250     /**
1251      * @dev See {IERC721Enumerable-totalSupply}.
1252      */
1253     function totalSupply() public view virtual override returns (uint256) {
1254         return _allTokens.length;
1255     }
1256 
1257     /**
1258      * @dev See {IERC721Enumerable-tokenByIndex}.
1259      */
1260     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1261         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1262         return _allTokens[index];
1263     }
1264 
1265     /**
1266      * @dev Hook that is called before any token transfer. This includes minting
1267      * and burning.
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` will be minted for `to`.
1274      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1275      * - `from` cannot be the zero address.
1276      * - `to` cannot be the zero address.
1277      *
1278      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1279      */
1280     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1281         super._beforeTokenTransfer(from, to, tokenId);
1282 
1283         if (from == address(0)) {
1284             _addTokenToAllTokensEnumeration(tokenId);
1285         } else if (from != to) {
1286             _removeTokenFromOwnerEnumeration(from, tokenId);
1287         }
1288         if (to == address(0)) {
1289             _removeTokenFromAllTokensEnumeration(tokenId);
1290         } else if (to != from) {
1291             _addTokenToOwnerEnumeration(to, tokenId);
1292         }
1293     }
1294 
1295     /**
1296      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1297      * @param to address representing the new owner of the given token ID
1298      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1299      */
1300     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1301         uint256 length = ERC721.balanceOf(to);
1302         _ownedTokens[to][length] = tokenId;
1303         _ownedTokensIndex[tokenId] = length;
1304     }
1305 
1306     /**
1307      * @dev Private function to add a token to this extension's token tracking data structures.
1308      * @param tokenId uint256 ID of the token to be added to the tokens list
1309      */
1310     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1311         _allTokensIndex[tokenId] = _allTokens.length;
1312         _allTokens.push(tokenId);
1313     }
1314 
1315     /**
1316      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1317      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1318      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1319      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1320      * @param from address representing the previous owner of the given token ID
1321      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1322      */
1323     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1324         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1325         // then delete the last slot (swap and pop).
1326 
1327         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1328         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1329 
1330         // When the token to delete is the last token, the swap operation is unnecessary
1331         if (tokenIndex != lastTokenIndex) {
1332             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1333 
1334             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1335             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1336         }
1337 
1338         // This also deletes the contents at the last position of the array
1339         delete _ownedTokensIndex[tokenId];
1340         delete _ownedTokens[from][lastTokenIndex];
1341     }
1342 
1343     /**
1344      * @dev Private function to remove a token from this extension's token tracking data structures.
1345      * This has O(1) time complexity, but alters the order of the _allTokens array.
1346      * @param tokenId uint256 ID of the token to be removed from the tokens list
1347      */
1348     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1349         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1350         // then delete the last slot (swap and pop).
1351 
1352         uint256 lastTokenIndex = _allTokens.length - 1;
1353         uint256 tokenIndex = _allTokensIndex[tokenId];
1354 
1355         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1356         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1357         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1358         uint256 lastTokenId = _allTokens[lastTokenIndex];
1359 
1360         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1361         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1362 
1363         // This also deletes the contents at the last position of the array
1364         delete _allTokensIndex[tokenId];
1365         _allTokens.pop();
1366     }
1367 }
1368 
1369 
1370 
1371 // File 12: IERC721Receiver.sol
1372 
1373 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1374 
1375 pragma solidity ^0.8.0;
1376 
1377 /**
1378  * @title ERC721 token receiver interface
1379  * @dev Interface for any contract that wants to support safeTransfers
1380  * from ERC721 asset contracts.
1381  */
1382 interface IERC721Receiver {
1383     /**
1384      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1385      * by `operator` from `from`, this function is called.
1386      *
1387      * It must return its Solidity selector to confirm the token transfer.
1388      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1389      *
1390      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1391      */
1392     function onERC721Received(
1393         address operator,
1394         address from,
1395         uint256 tokenId,
1396         bytes calldata data
1397     ) external returns (bytes4);
1398 }
1399 
1400 
1401 
1402 // File 13: ERC721A.sol
1403 
1404 pragma solidity ^0.8.0;
1405 
1406 
1407 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1408     using Address for address;
1409     using Strings for uint256;
1410 
1411     struct TokenOwnership {
1412         address addr;
1413         uint64 startTimestamp;
1414     }
1415 
1416     struct AddressData {
1417         uint128 balance;
1418         uint128 numberMinted;
1419     }
1420 
1421     uint256 internal currentIndex;
1422 
1423     // Token name
1424     string private _name;
1425 
1426     // Token symbol
1427     string private _symbol;
1428 
1429     // Mapping from token ID to ownership details
1430     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1431     mapping(uint256 => TokenOwnership) internal _ownerships;
1432 
1433     // Mapping owner address to address data
1434     mapping(address => AddressData) private _addressData;
1435 
1436     // Mapping from token ID to approved address
1437     mapping(uint256 => address) private _tokenApprovals;
1438 
1439     // Mapping from owner to operator approvals
1440     mapping(address => mapping(address => bool)) private _operatorApprovals;
1441 
1442     constructor(string memory name_, string memory symbol_) {
1443         _name = name_;
1444         _symbol = symbol_;
1445     }
1446 
1447     /**
1448      * @dev See {IERC721Enumerable-totalSupply}.
1449      */
1450     function totalSupply() public view override virtual returns (uint256) {
1451         return currentIndex;
1452     }
1453 
1454     /**
1455      * @dev See {IERC721Enumerable-tokenByIndex}.
1456      */
1457     function tokenByIndex(uint256 index) public view override returns (uint256) {
1458         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1459         return index;
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1464      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1465      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1466      */
1467     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1468         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1469         uint256 numMintedSoFar = totalSupply();
1470         uint256 tokenIdsIdx;
1471         address currOwnershipAddr;
1472 
1473         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1474         unchecked {
1475             for (uint256 i; i < numMintedSoFar; i++) {
1476                 TokenOwnership memory ownership = _ownerships[i];
1477                 if (ownership.addr != address(0)) {
1478                     currOwnershipAddr = ownership.addr;
1479                 }
1480                 if (currOwnershipAddr == owner) {
1481                     if (tokenIdsIdx == index) {
1482                         return i;
1483                     }
1484                     tokenIdsIdx++;
1485                 }
1486             }
1487         }
1488 
1489         revert('ERC721A: unable to get token of owner by index');
1490     }
1491 
1492     /**
1493      * @dev See {IERC165-supportsInterface}.
1494      */
1495     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1496         return
1497             interfaceId == type(IERC721).interfaceId ||
1498             interfaceId == type(IERC721Metadata).interfaceId ||
1499             interfaceId == type(IERC721Enumerable).interfaceId ||
1500             super.supportsInterface(interfaceId);
1501     }
1502 
1503     /**
1504      * @dev See {IERC721-balanceOf}.
1505      */
1506     function balanceOf(address owner) public view override returns (uint256) {
1507         require(owner != address(0), 'ERC721A: balance query for the zero address');
1508         return uint256(_addressData[owner].balance);
1509     }
1510 
1511     function _numberMinted(address owner) internal view returns (uint256) {
1512         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1513         return uint256(_addressData[owner].numberMinted);
1514     }
1515 
1516     /**
1517      * Gas spent here starts off proportional to the maximum mint batch size.
1518      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1519      */
1520     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1521         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1522 
1523         unchecked {
1524             for (uint256 curr = tokenId; curr >= 0; curr--) {
1525                 TokenOwnership memory ownership = _ownerships[curr];
1526                 if (ownership.addr != address(0)) {
1527                     return ownership;
1528                 }
1529             }
1530         }
1531 
1532         revert('ERC721A: unable to determine the owner of token');
1533     }
1534 
1535     /**
1536      * @dev See {IERC721-ownerOf}.
1537      */
1538     function ownerOf(uint256 tokenId) public view override returns (address) {
1539         return ownershipOf(tokenId).addr;
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Metadata-name}.
1544      */
1545     function name() public view virtual override returns (string memory) {
1546         return _name;
1547     }
1548 
1549     /**
1550      * @dev See {IERC721Metadata-symbol}.
1551      */
1552     function symbol() public view virtual override returns (string memory) {
1553         return _symbol;
1554     }
1555 
1556     /**
1557      * @dev See {IERC721Metadata-tokenURI}.
1558      */
1559     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1560         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1561 
1562         string memory baseURI = _baseURI();
1563         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1564     }
1565 
1566     /**
1567      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1568      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1569      * by default, can be overriden in child contracts.
1570      */
1571     function _baseURI() internal view virtual returns (string memory) {
1572         return '';
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-approve}.
1577      */
1578     function approve(address to, uint256 tokenId) public override {
1579         address owner = ERC721A.ownerOf(tokenId);
1580         require(to != owner, 'ERC721A: approval to current owner');
1581 
1582         require(
1583             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1584             'ERC721A: approve caller is not owner nor approved for all'
1585         );
1586 
1587         _approve(to, tokenId, owner);
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-getApproved}.
1592      */
1593     function getApproved(uint256 tokenId) public view override returns (address) {
1594         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1595 
1596         return _tokenApprovals[tokenId];
1597     }
1598 
1599     /**
1600      * @dev See {IERC721-setApprovalForAll}.
1601      */
1602     function setApprovalForAll(address operator, bool approved) public override {
1603         require(operator != _msgSender(), 'ERC721A: approve to caller');
1604 
1605         _operatorApprovals[_msgSender()][operator] = approved;
1606         emit ApprovalForAll(_msgSender(), operator, approved);
1607     }
1608 
1609     /**
1610      * @dev See {IERC721-isApprovedForAll}.
1611      */
1612     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1613         return _operatorApprovals[owner][operator];
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-transferFrom}.
1618      */
1619     function transferFrom(
1620         address from,
1621         address to,
1622         uint256 tokenId
1623     ) public override {
1624         _transfer(from, to, tokenId);
1625     }
1626 
1627     /**
1628      * @dev See {IERC721-safeTransferFrom}.
1629      */
1630     function safeTransferFrom(
1631         address from,
1632         address to,
1633         uint256 tokenId
1634     ) public override {
1635         safeTransferFrom(from, to, tokenId, '');
1636     }
1637 
1638     /**
1639      * @dev See {IERC721-safeTransferFrom}.
1640      */
1641     function safeTransferFrom(
1642         address from,
1643         address to,
1644         uint256 tokenId,
1645         bytes memory _data
1646     ) public override {
1647         _transfer(from, to, tokenId);
1648         require(
1649             _checkOnERC721Received(from, to, tokenId, _data),
1650             'ERC721A: transfer to non ERC721Receiver implementer'
1651         );
1652     }
1653 
1654     /**
1655      * @dev Returns whether `tokenId` exists.
1656      *
1657      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1658      *
1659      * Tokens start existing when they are minted (`_mint`),
1660      */
1661     function _exists(uint256 tokenId) internal view returns (bool) {
1662         return tokenId < currentIndex;
1663     }
1664 
1665     function _safeMint(address to, uint256 quantity) internal {
1666         _safeMint(to, quantity, '');
1667     }
1668 
1669     /**
1670      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1671      *
1672      * Requirements:
1673      *
1674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1675      * - `quantity` must be greater than 0.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _safeMint(
1680         address to,
1681         uint256 quantity,
1682         bytes memory _data
1683     ) internal {
1684         _mint(to, quantity, _data, true);
1685     }
1686 
1687     /**
1688      * @dev Mints `quantity` tokens and transfers them to `to`.
1689      *
1690      * Requirements:
1691      *
1692      * - `to` cannot be the zero address.
1693      * - `quantity` must be greater than 0.
1694      *
1695      * Emits a {Transfer} event.
1696      */
1697     function _mint(
1698         address to,
1699         uint256 quantity,
1700         bytes memory _data,
1701         bool safe
1702     ) internal {
1703         uint256 startTokenId = currentIndex;
1704         require(to != address(0), 'ERC721A: mint to the zero address');
1705         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1706 
1707         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1708 
1709         // Overflows are incredibly unrealistic.
1710         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1711         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1712         unchecked {
1713             _addressData[to].balance += uint128(quantity);
1714             _addressData[to].numberMinted += uint128(quantity);
1715 
1716             _ownerships[startTokenId].addr = to;
1717             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1718 
1719             uint256 updatedIndex = startTokenId;
1720 
1721             for (uint256 i; i < quantity; i++) {
1722                 emit Transfer(address(0), to, updatedIndex);
1723                 if (safe) {
1724                     require(
1725                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1726                         'ERC721A: transfer to non ERC721Receiver implementer'
1727                     );
1728                 }
1729 
1730                 updatedIndex++;
1731             }
1732 
1733             currentIndex = updatedIndex;
1734         }
1735 
1736         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1737     }
1738 
1739     /**
1740      * @dev Transfers `tokenId` from `from` to `to`.
1741      *
1742      * Requirements:
1743      *
1744      * - `to` cannot be the zero address.
1745      * - `tokenId` token must be owned by `from`.
1746      *
1747      * Emits a {Transfer} event.
1748      */
1749     function _transfer(
1750         address from,
1751         address to,
1752         uint256 tokenId
1753     ) private {
1754         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1755 
1756         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1757             getApproved(tokenId) == _msgSender() ||
1758             isApprovedForAll(prevOwnership.addr, _msgSender()));
1759 
1760         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1761 
1762         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1763         require(to != address(0), 'ERC721A: transfer to the zero address');
1764 
1765         _beforeTokenTransfers(from, to, tokenId, 1);
1766 
1767         // Clear approvals from the previous owner
1768         _approve(address(0), tokenId, prevOwnership.addr);
1769 
1770         // Underflow of the sender's balance is impossible because we check for
1771         // ownership above and the recipient's balance can't realistically overflow.
1772         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1773         unchecked {
1774             _addressData[from].balance -= 1;
1775             _addressData[to].balance += 1;
1776 
1777             _ownerships[tokenId].addr = to;
1778             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1779 
1780             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1781             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1782             uint256 nextTokenId = tokenId + 1;
1783             if (_ownerships[nextTokenId].addr == address(0)) {
1784                 if (_exists(nextTokenId)) {
1785                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1786                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1787                 }
1788             }
1789         }
1790 
1791         emit Transfer(from, to, tokenId);
1792         _afterTokenTransfers(from, to, tokenId, 1);
1793     }
1794 
1795     /**
1796      * @dev Approve `to` to operate on `tokenId`
1797      *
1798      * Emits a {Approval} event.
1799      */
1800     function _approve(
1801         address to,
1802         uint256 tokenId,
1803         address owner
1804     ) private {
1805         _tokenApprovals[tokenId] = to;
1806         emit Approval(owner, to, tokenId);
1807     }
1808 
1809     /**
1810      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1811      * The call is not executed if the target address is not a contract.
1812      *
1813      * @param from address representing the previous owner of the given token ID
1814      * @param to target address that will receive the tokens
1815      * @param tokenId uint256 ID of the token to be transferred
1816      * @param _data bytes optional data to send along with the call
1817      * @return bool whether the call correctly returned the expected magic value
1818      */
1819     function _checkOnERC721Received(
1820         address from,
1821         address to,
1822         uint256 tokenId,
1823         bytes memory _data
1824     ) private returns (bool) {
1825         if (to.isContract()) {
1826             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1827                 return retval == IERC721Receiver(to).onERC721Received.selector;
1828             } catch (bytes memory reason) {
1829                 if (reason.length == 0) {
1830                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1831                 } else {
1832                     assembly {
1833                         revert(add(32, reason), mload(reason))
1834                     }
1835                 }
1836             }
1837         } else {
1838             return true;
1839         }
1840     }
1841 
1842     /**
1843      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1844      *
1845      * startTokenId - the first token id to be transferred
1846      * quantity - the amount to be transferred
1847      *
1848      * Calling conditions:
1849      *
1850      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1851      * transferred to `to`.
1852      * - When `from` is zero, `tokenId` will be minted for `to`.
1853      */
1854     function _beforeTokenTransfers(
1855         address from,
1856         address to,
1857         uint256 startTokenId,
1858         uint256 quantity
1859     ) internal virtual {}
1860 
1861     /**
1862      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1863      * minting.
1864      *
1865      * startTokenId - the first token id to be transferred
1866      * quantity - the amount to be transferred
1867      *
1868      * Calling conditions:
1869      *
1870      * - when `from` and `to` are both non-zero.
1871      * - `from` and `to` are never both zero.
1872      */
1873     function _afterTokenTransfers(
1874         address from,
1875         address to,
1876         uint256 startTokenId,
1877         uint256 quantity
1878     ) internal virtual {}
1879 }
1880 
1881 // FILE 14: TheSaudisGoblin.sol
1882 
1883 pragma solidity ^0.8.0;
1884 
1885 contract TheSaudisGoblin is ERC721A, Ownable, ReentrancyGuard {
1886   using Strings for uint256;
1887   using Counters for Counters.Counter;
1888 
1889   string private uriPrefix = "";
1890   string public uriSuffix = ".json";
1891   string private hiddenMetadataUri;
1892 
1893     constructor() ERC721A("TheSaudisGoblin", "TSG") {
1894         setHiddenMetadataUri("ipfs://__CID__/hidden.json");
1895     }
1896 
1897     uint256 public price = 0.003 ether;
1898     uint256 public maxPerTx = 20;
1899     uint256 public maxPerFree = 3;    
1900     uint256 public maxFreeSupply = 3333;
1901     uint256 public maxSupply = 6666;
1902      
1903   bool public paused = true;
1904   bool public revealed = true;
1905 
1906     mapping(address => uint256) private _mintedFreeAmount;
1907 
1908     function changePrice(uint256 _newPrice) external onlyOwner {
1909         price = _newPrice;
1910     }
1911 
1912     function withdraw() external onlyOwner {
1913         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1914         require(success, "Transfer failed.");
1915     }
1916 
1917     //mint
1918     function mint(uint256 count) external payable {
1919         uint256 cost = price;
1920         require(!paused, "The contract is paused!");
1921         require(count > 0, "Minimum 1 NFT has to be minted per transaction");
1922         if (msg.sender != owner()) {
1923             bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1924                 (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1925 
1926             if (isFree) {
1927                 cost = 0;
1928                 _mintedFreeAmount[msg.sender] += count;
1929             }
1930 
1931             require(msg.value >= count * cost, "Please send the exact amount.");
1932             require(count <= maxPerTx, "Max per TX reached.");
1933         }
1934 
1935         require(totalSupply() + count <= maxSupply, "No more");
1936 
1937         _safeMint(msg.sender, count);
1938     }
1939 
1940     function walletOfOwner(address _owner)
1941         public
1942         view
1943         returns (uint256[] memory)
1944     {
1945         uint256 ownerTokenCount = balanceOf(_owner);
1946         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1947         uint256 currentTokenId = 1;
1948         uint256 ownedTokenIndex = 0;
1949 
1950         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1951         address currentTokenOwner = ownerOf(currentTokenId);
1952             if (currentTokenOwner == _owner) {
1953                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1954                 ownedTokenIndex++;
1955             }
1956         currentTokenId++;
1957         }
1958         return ownedTokenIds;
1959     }
1960   
1961   function tokenURI(uint256 _tokenId)
1962     public
1963     view
1964     virtual
1965     override
1966     returns (string memory)
1967   {
1968     require(
1969       _exists(_tokenId),
1970       "ERC721Metadata: URI query for nonexistent token"
1971     );
1972     if (revealed == false) {
1973       return hiddenMetadataUri;
1974     }
1975     string memory currentBaseURI = _baseURI();
1976     return bytes(currentBaseURI).length > 0
1977         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1978         : "";
1979   }
1980 
1981   function setPaused(bool _state) public onlyOwner {
1982     paused = _state;
1983   }
1984 
1985   function setRevealed(bool _state) public onlyOwner {
1986     revealed = _state;
1987   }  
1988 
1989   function setmaxPerTx(uint256 _maxPerTx) public onlyOwner {
1990     maxPerTx = _maxPerTx;
1991   }
1992 
1993   function setmaxPerFree(uint256 _maxPerFree) public onlyOwner {
1994     maxPerFree = _maxPerFree;
1995   }  
1996 
1997   function setmaxFreeSupply(uint256 _maxFreeSupply) public onlyOwner {
1998     maxFreeSupply = _maxFreeSupply;
1999   }
2000 
2001   function setmaxSupply(uint256 _maxSupply) public onlyOwner {
2002     maxSupply = _maxSupply;
2003   }
2004 
2005   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2006     hiddenMetadataUri = _hiddenMetadataUri;
2007   }  
2008 
2009   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2010     uriPrefix = _uriPrefix;
2011   }  
2012 
2013   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2014     uriSuffix = _uriSuffix;
2015   }
2016 
2017   function _baseURI() internal view virtual override returns (string memory) {
2018     return uriPrefix;
2019   }
2020 }