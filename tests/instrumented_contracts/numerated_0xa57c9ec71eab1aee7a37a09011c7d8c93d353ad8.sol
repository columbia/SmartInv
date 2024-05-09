1 // File: contracts/IUnity.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 interface IUnity {
8     function balanceOf(address owner) external view returns (uint256 balance);
9 }
10 // File: contracts/ISurvive.sol
11 
12 
13 
14 pragma solidity ^0.8.0;
15 
16 interface ISurvive {
17     function claimToxic(address _to, uint256 amount) external;
18 }
19 // File: @openzeppelin/contracts/utils/Strings.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 
89 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Contract module that helps prevent reentrant calls to a function.
98  *
99  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
100  * available, which can be applied to functions to make sure there are no nested
101  * (reentrant) calls to them.
102  *
103  * Note that because there is a single `nonReentrant` guard, functions marked as
104  * `nonReentrant` may not call one another. This can be worked around by making
105  * those functions `private`, and then adding `external` `nonReentrant` entry
106  * points to them.
107  *
108  * TIP: If you would like to learn more about reentrancy and alternative ways
109  * to protect against it, check out our blog post
110  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
111  */
112 abstract contract ReentrancyGuard {
113     // Booleans are more expensive than uint256 or any type that takes up a full
114     // word because each write operation emits an extra SLOAD to first read the
115     // slot's contents, replace the bits taken up by the boolean, and then write
116     // back. This is the compiler's defense against contract upgrades and
117     // pointer aliasing, and it cannot be disabled.
118 
119     // The values being non-zero value makes deployment a bit more expensive,
120     // but in exchange the refund on every call to nonReentrant will be lower in
121     // amount. Since refunds are capped to a percentage of the total
122     // transaction's gas, it is best to keep them low in cases like this one, to
123     // increase the likelihood of the full refund coming into effect.
124     uint256 private constant _NOT_ENTERED = 1;
125     uint256 private constant _ENTERED = 2;
126 
127     uint256 private _status;
128 
129     constructor() {
130         _status = _NOT_ENTERED;
131     }
132 
133     /**
134      * @dev Prevents a contract from calling itself, directly or indirectly.
135      * Calling a `nonReentrant` function from another `nonReentrant`
136      * function is not supported. It is possible to prevent this from happening
137      * by making the `nonReentrant` function external, and making it call a
138      * `private` function that does the actual work.
139      */
140     modifier nonReentrant() {
141         // On the first call to nonReentrant, _notEntered will be true
142         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
143 
144         // Any calls to nonReentrant after this point will fail
145         _status = _ENTERED;
146 
147         _;
148 
149         // By storing the original value once again, a refund is triggered (see
150         // https://eips.ethereum.org/EIPS/eip-2200)
151         _status = _NOT_ENTERED;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/utils/Context.sol
156 
157 
158 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 abstract contract Context {
173     function _msgSender() internal view virtual returns (address) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view virtual returns (bytes calldata) {
178         return msg.data;
179     }
180 }
181 
182 // File: @openzeppelin/contracts/access/Ownable.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @dev Contract module which provides a basic access control mechanism, where
192  * there is an account (an owner) that can be granted exclusive access to
193  * specific functions.
194  *
195  * By default, the owner account will be the one that deploys the contract. This
196  * can later be changed with {transferOwnership}.
197  *
198  * This module is used through inheritance. It will make available the modifier
199  * `onlyOwner`, which can be applied to your functions to restrict their use to
200  * the owner.
201  */
202 abstract contract Ownable is Context {
203     address private _owner;
204 
205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207     /**
208      * @dev Initializes the contract setting the deployer as the initial owner.
209      */
210     constructor() {
211         _transferOwnership(_msgSender());
212     }
213 
214     /**
215      * @dev Returns the address of the current owner.
216      */
217     function owner() public view virtual returns (address) {
218         return _owner;
219     }
220 
221     /**
222      * @dev Throws if called by any account other than the owner.
223      */
224     modifier onlyOwner() {
225         require(owner() == _msgSender(), "Ownable: caller is not the owner");
226         _;
227     }
228 
229     /**
230      * @dev Leaves the contract without owner. It will not be possible to call
231      * `onlyOwner` functions anymore. Can only be called by the current owner.
232      *
233      * NOTE: Renouncing ownership will leave the contract without an owner,
234      * thereby removing any functionality that is only available to the owner.
235      */
236     function renounceOwnership() public virtual onlyOwner {
237         _transferOwnership(address(0));
238     }
239 
240     /**
241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
242      * Can only be called by the current owner.
243      */
244     function transferOwnership(address newOwner) public virtual onlyOwner {
245         require(newOwner != address(0), "Ownable: new owner is the zero address");
246         _transferOwnership(newOwner);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Internal function without access restriction.
252      */
253     function _transferOwnership(address newOwner) internal virtual {
254         address oldOwner = _owner;
255         _owner = newOwner;
256         emit OwnershipTransferred(oldOwner, newOwner);
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/Address.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies on extcodesize, which returns 0 for contracts in
290         // construction, since the code is only stored at the end of the
291         // constructor execution.
292 
293         uint256 size;
294         assembly {
295             size := extcodesize(account)
296         }
297         return size > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev Interface of the ERC165 standard, as defined in the
489  * https://eips.ethereum.org/EIPS/eip-165[EIP].
490  *
491  * Implementers can declare support of contract interfaces, which can then be
492  * queried by others ({ERC165Checker}).
493  *
494  * For an implementation, see {ERC165}.
495  */
496 interface IERC165 {
497     /**
498      * @dev Returns true if this contract implements the interface defined by
499      * `interfaceId`. See the corresponding
500      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
501      * to learn more about how these ids are created.
502      *
503      * This function call must use less than 30 000 gas.
504      */
505     function supportsInterface(bytes4 interfaceId) external view returns (bool);
506 }
507 
508 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Implementation of the {IERC165} interface.
518  *
519  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
520  * for the additional interface id that will be supported. For example:
521  *
522  * ```solidity
523  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
525  * }
526  * ```
527  *
528  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
529  */
530 abstract contract ERC165 is IERC165 {
531     /**
532      * @dev See {IERC165-supportsInterface}.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         return interfaceId == type(IERC165).interfaceId;
536     }
537 }
538 
539 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 
547 /**
548  * @dev _Available since v3.1._
549  */
550 interface IERC1155Receiver is IERC165 {
551     /**
552         @dev Handles the receipt of a single ERC1155 token type. This function is
553         called at the end of a `safeTransferFrom` after the balance has been updated.
554         To accept the transfer, this must return
555         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
556         (i.e. 0xf23a6e61, or its own function selector).
557         @param operator The address which initiated the transfer (i.e. msg.sender)
558         @param from The address which previously owned the token
559         @param id The ID of the token being transferred
560         @param value The amount of tokens being transferred
561         @param data Additional data with no specified format
562         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
563     */
564     function onERC1155Received(
565         address operator,
566         address from,
567         uint256 id,
568         uint256 value,
569         bytes calldata data
570     ) external returns (bytes4);
571 
572     /**
573         @dev Handles the receipt of a multiple ERC1155 token types. This function
574         is called at the end of a `safeBatchTransferFrom` after the balances have
575         been updated. To accept the transfer(s), this must return
576         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
577         (i.e. 0xbc197c81, or its own function selector).
578         @param operator The address which initiated the batch transfer (i.e. msg.sender)
579         @param from The address which previously owned the token
580         @param ids An array containing ids of each token being transferred (order and length must match values array)
581         @param values An array containing amounts of each token being transferred (order and length must match ids array)
582         @param data Additional data with no specified format
583         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
584     */
585     function onERC1155BatchReceived(
586         address operator,
587         address from,
588         uint256[] calldata ids,
589         uint256[] calldata values,
590         bytes calldata data
591     ) external returns (bytes4);
592 }
593 
594 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @dev Required interface of an ERC1155 compliant contract, as defined in the
604  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
605  *
606  * _Available since v3.1._
607  */
608 interface IERC1155 is IERC165 {
609     /**
610      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
611      */
612     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
613 
614     /**
615      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
616      * transfers.
617      */
618     event TransferBatch(
619         address indexed operator,
620         address indexed from,
621         address indexed to,
622         uint256[] ids,
623         uint256[] values
624     );
625 
626     /**
627      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
628      * `approved`.
629      */
630     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
631 
632     /**
633      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
634      *
635      * If an {URI} event was emitted for `id`, the standard
636      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
637      * returned by {IERC1155MetadataURI-uri}.
638      */
639     event URI(string value, uint256 indexed id);
640 
641     /**
642      * @dev Returns the amount of tokens of token type `id` owned by `account`.
643      *
644      * Requirements:
645      *
646      * - `account` cannot be the zero address.
647      */
648     function balanceOf(address account, uint256 id) external view returns (uint256);
649 
650     /**
651      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
652      *
653      * Requirements:
654      *
655      * - `accounts` and `ids` must have the same length.
656      */
657     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
658         external
659         view
660         returns (uint256[] memory);
661 
662     /**
663      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
664      *
665      * Emits an {ApprovalForAll} event.
666      *
667      * Requirements:
668      *
669      * - `operator` cannot be the caller.
670      */
671     function setApprovalForAll(address operator, bool approved) external;
672 
673     /**
674      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
675      *
676      * See {setApprovalForAll}.
677      */
678     function isApprovedForAll(address account, address operator) external view returns (bool);
679 
680     /**
681      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
682      *
683      * Emits a {TransferSingle} event.
684      *
685      * Requirements:
686      *
687      * - `to` cannot be the zero address.
688      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
689      * - `from` must have a balance of tokens of type `id` of at least `amount`.
690      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
691      * acceptance magic value.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 id,
697         uint256 amount,
698         bytes calldata data
699     ) external;
700 
701     /**
702      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
703      *
704      * Emits a {TransferBatch} event.
705      *
706      * Requirements:
707      *
708      * - `ids` and `amounts` must have the same length.
709      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
710      * acceptance magic value.
711      */
712     function safeBatchTransferFrom(
713         address from,
714         address to,
715         uint256[] calldata ids,
716         uint256[] calldata amounts,
717         bytes calldata data
718     ) external;
719 }
720 
721 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
731  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
732  *
733  * _Available since v3.1._
734  */
735 interface IERC1155MetadataURI is IERC1155 {
736     /**
737      * @dev Returns the URI for token type `id`.
738      *
739      * If the `\{id\}` substring is present in the URI, it must be replaced by
740      * clients with the actual token type ID.
741      */
742     function uri(uint256 id) external view returns (string memory);
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
746 
747 
748 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
749 
750 pragma solidity ^0.8.0;
751 
752 
753 
754 
755 
756 
757 
758 /**
759  * @dev Implementation of the basic standard multi-token.
760  * See https://eips.ethereum.org/EIPS/eip-1155
761  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
762  *
763  * _Available since v3.1._
764  */
765 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
766     using Address for address;
767 
768     // Mapping from token ID to account balances
769     mapping(uint256 => mapping(address => uint256)) private _balances;
770 
771     // Mapping from account to operator approvals
772     mapping(address => mapping(address => bool)) private _operatorApprovals;
773 
774     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
775     string private _uri;
776 
777     /**
778      * @dev See {_setURI}.
779      */
780     constructor(string memory uri_) {
781         _setURI(uri_);
782     }
783 
784     /**
785      * @dev See {IERC165-supportsInterface}.
786      */
787     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
788         return
789             interfaceId == type(IERC1155).interfaceId ||
790             interfaceId == type(IERC1155MetadataURI).interfaceId ||
791             super.supportsInterface(interfaceId);
792     }
793 
794     /**
795      * @dev See {IERC1155MetadataURI-uri}.
796      *
797      * This implementation returns the same URI for *all* token types. It relies
798      * on the token type ID substitution mechanism
799      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
800      *
801      * Clients calling this function must replace the `\{id\}` substring with the
802      * actual token type ID.
803      */
804     function uri(uint256) public view virtual override returns (string memory) {
805         return _uri;
806     }
807 
808     /**
809      * @dev See {IERC1155-balanceOf}.
810      *
811      * Requirements:
812      *
813      * - `account` cannot be the zero address.
814      */
815     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
816         require(account != address(0), "ERC1155: balance query for the zero address");
817         return _balances[id][account];
818     }
819 
820     /**
821      * @dev See {IERC1155-balanceOfBatch}.
822      *
823      * Requirements:
824      *
825      * - `accounts` and `ids` must have the same length.
826      */
827     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
828         public
829         view
830         virtual
831         override
832         returns (uint256[] memory)
833     {
834         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
835 
836         uint256[] memory batchBalances = new uint256[](accounts.length);
837 
838         for (uint256 i = 0; i < accounts.length; ++i) {
839             batchBalances[i] = balanceOf(accounts[i], ids[i]);
840         }
841 
842         return batchBalances;
843     }
844 
845     /**
846      * @dev See {IERC1155-setApprovalForAll}.
847      */
848     function setApprovalForAll(address operator, bool approved) public virtual override {
849         _setApprovalForAll(_msgSender(), operator, approved);
850     }
851 
852     /**
853      * @dev See {IERC1155-isApprovedForAll}.
854      */
855     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
856         return _operatorApprovals[account][operator];
857     }
858 
859     /**
860      * @dev See {IERC1155-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 id,
866         uint256 amount,
867         bytes memory data
868     ) public virtual override {
869         require(
870             from == _msgSender() || isApprovedForAll(from, _msgSender()),
871             "ERC1155: caller is not owner nor approved"
872         );
873         _safeTransferFrom(from, to, id, amount, data);
874     }
875 
876     /**
877      * @dev See {IERC1155-safeBatchTransferFrom}.
878      */
879     function safeBatchTransferFrom(
880         address from,
881         address to,
882         uint256[] memory ids,
883         uint256[] memory amounts,
884         bytes memory data
885     ) public virtual override {
886         require(
887             from == _msgSender() || isApprovedForAll(from, _msgSender()),
888             "ERC1155: transfer caller is not owner nor approved"
889         );
890         _safeBatchTransferFrom(from, to, ids, amounts, data);
891     }
892 
893     /**
894      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
895      *
896      * Emits a {TransferSingle} event.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `from` must have a balance of tokens of type `id` of at least `amount`.
902      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
903      * acceptance magic value.
904      */
905     function _safeTransferFrom(
906         address from,
907         address to,
908         uint256 id,
909         uint256 amount,
910         bytes memory data
911     ) internal virtual {
912         require(to != address(0), "ERC1155: transfer to the zero address");
913 
914         address operator = _msgSender();
915 
916         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
917 
918         uint256 fromBalance = _balances[id][from];
919         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
920         unchecked {
921             _balances[id][from] = fromBalance - amount;
922         }
923         _balances[id][to] += amount;
924 
925         emit TransferSingle(operator, from, to, id, amount);
926 
927         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
928     }
929 
930     /**
931      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
932      *
933      * Emits a {TransferBatch} event.
934      *
935      * Requirements:
936      *
937      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
938      * acceptance magic value.
939      */
940     function _safeBatchTransferFrom(
941         address from,
942         address to,
943         uint256[] memory ids,
944         uint256[] memory amounts,
945         bytes memory data
946     ) internal virtual {
947         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
948         require(to != address(0), "ERC1155: transfer to the zero address");
949 
950         address operator = _msgSender();
951 
952         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
953 
954         for (uint256 i = 0; i < ids.length; ++i) {
955             uint256 id = ids[i];
956             uint256 amount = amounts[i];
957 
958             uint256 fromBalance = _balances[id][from];
959             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
960             unchecked {
961                 _balances[id][from] = fromBalance - amount;
962             }
963             _balances[id][to] += amount;
964         }
965 
966         emit TransferBatch(operator, from, to, ids, amounts);
967 
968         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
969     }
970 
971     /**
972      * @dev Sets a new URI for all token types, by relying on the token type ID
973      * substitution mechanism
974      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
975      *
976      * By this mechanism, any occurrence of the `\{id\}` substring in either the
977      * URI or any of the amounts in the JSON file at said URI will be replaced by
978      * clients with the token type ID.
979      *
980      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
981      * interpreted by clients as
982      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
983      * for token type ID 0x4cce0.
984      *
985      * See {uri}.
986      *
987      * Because these URIs cannot be meaningfully represented by the {URI} event,
988      * this function emits no events.
989      */
990     function _setURI(string memory newuri) internal virtual {
991         _uri = newuri;
992     }
993 
994     /**
995      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
996      *
997      * Emits a {TransferSingle} event.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1003      * acceptance magic value.
1004      */
1005     function _mint(
1006         address to,
1007         uint256 id,
1008         uint256 amount,
1009         bytes memory data
1010     ) internal virtual {
1011         require(to != address(0), "ERC1155: mint to the zero address");
1012 
1013         address operator = _msgSender();
1014 
1015         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1016 
1017         _balances[id][to] += amount;
1018         emit TransferSingle(operator, address(0), to, id, amount);
1019 
1020         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1021     }
1022 
1023     /**
1024      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1025      *
1026      * Requirements:
1027      *
1028      * - `ids` and `amounts` must have the same length.
1029      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1030      * acceptance magic value.
1031      */
1032     function _mintBatch(
1033         address to,
1034         uint256[] memory ids,
1035         uint256[] memory amounts,
1036         bytes memory data
1037     ) internal virtual {
1038         require(to != address(0), "ERC1155: mint to the zero address");
1039         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1040 
1041         address operator = _msgSender();
1042 
1043         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1044 
1045         for (uint256 i = 0; i < ids.length; i++) {
1046             _balances[ids[i]][to] += amounts[i];
1047         }
1048 
1049         emit TransferBatch(operator, address(0), to, ids, amounts);
1050 
1051         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1052     }
1053 
1054     /**
1055      * @dev Destroys `amount` tokens of token type `id` from `from`
1056      *
1057      * Requirements:
1058      *
1059      * - `from` cannot be the zero address.
1060      * - `from` must have at least `amount` tokens of token type `id`.
1061      */
1062     function _burn(
1063         address from,
1064         uint256 id,
1065         uint256 amount
1066     ) internal virtual {
1067         require(from != address(0), "ERC1155: burn from the zero address");
1068 
1069         address operator = _msgSender();
1070 
1071         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1072 
1073         uint256 fromBalance = _balances[id][from];
1074         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1075         unchecked {
1076             _balances[id][from] = fromBalance - amount;
1077         }
1078 
1079         emit TransferSingle(operator, from, address(0), id, amount);
1080     }
1081 
1082     /**
1083      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1084      *
1085      * Requirements:
1086      *
1087      * - `ids` and `amounts` must have the same length.
1088      */
1089     function _burnBatch(
1090         address from,
1091         uint256[] memory ids,
1092         uint256[] memory amounts
1093     ) internal virtual {
1094         require(from != address(0), "ERC1155: burn from the zero address");
1095         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1096 
1097         address operator = _msgSender();
1098 
1099         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1100 
1101         for (uint256 i = 0; i < ids.length; i++) {
1102             uint256 id = ids[i];
1103             uint256 amount = amounts[i];
1104 
1105             uint256 fromBalance = _balances[id][from];
1106             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1107             unchecked {
1108                 _balances[id][from] = fromBalance - amount;
1109             }
1110         }
1111 
1112         emit TransferBatch(operator, from, address(0), ids, amounts);
1113     }
1114 
1115     /**
1116      * @dev Approve `operator` to operate on all of `owner` tokens
1117      *
1118      * Emits a {ApprovalForAll} event.
1119      */
1120     function _setApprovalForAll(
1121         address owner,
1122         address operator,
1123         bool approved
1124     ) internal virtual {
1125         require(owner != operator, "ERC1155: setting approval status for self");
1126         _operatorApprovals[owner][operator] = approved;
1127         emit ApprovalForAll(owner, operator, approved);
1128     }
1129 
1130     /**
1131      * @dev Hook that is called before any token transfer. This includes minting
1132      * and burning, as well as batched variants.
1133      *
1134      * The same hook is called on both single and batched variants. For single
1135      * transfers, the length of the `id` and `amount` arrays will be 1.
1136      *
1137      * Calling conditions (for each `id` and `amount` pair):
1138      *
1139      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1140      * of token type `id` will be  transferred to `to`.
1141      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1142      * for `to`.
1143      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1144      * will be burned.
1145      * - `from` and `to` are never both zero.
1146      * - `ids` and `amounts` have the same, non-zero length.
1147      *
1148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1149      */
1150     function _beforeTokenTransfer(
1151         address operator,
1152         address from,
1153         address to,
1154         uint256[] memory ids,
1155         uint256[] memory amounts,
1156         bytes memory data
1157     ) internal virtual {}
1158 
1159     function _doSafeTransferAcceptanceCheck(
1160         address operator,
1161         address from,
1162         address to,
1163         uint256 id,
1164         uint256 amount,
1165         bytes memory data
1166     ) private {
1167         if (to.isContract()) {
1168             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1169                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1170                     revert("ERC1155: ERC1155Receiver rejected tokens");
1171                 }
1172             } catch Error(string memory reason) {
1173                 revert(reason);
1174             } catch {
1175                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1176             }
1177         }
1178     }
1179 
1180     function _doSafeBatchTransferAcceptanceCheck(
1181         address operator,
1182         address from,
1183         address to,
1184         uint256[] memory ids,
1185         uint256[] memory amounts,
1186         bytes memory data
1187     ) private {
1188         if (to.isContract()) {
1189             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1190                 bytes4 response
1191             ) {
1192                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1193                     revert("ERC1155: ERC1155Receiver rejected tokens");
1194                 }
1195             } catch Error(string memory reason) {
1196                 revert(reason);
1197             } catch {
1198                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1199             }
1200         }
1201     }
1202 
1203     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1204         uint256[] memory array = new uint256[](1);
1205         array[0] = element;
1206 
1207         return array;
1208     }
1209 }
1210 
1211 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1212 
1213 
1214 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1215 
1216 pragma solidity ^0.8.0;
1217 
1218 
1219 /**
1220  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1221  *
1222  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1223  * clearly identified. Note: While a totalSupply of 1 might mean the
1224  * corresponding is an NFT, there is no guarantees that no other token with the
1225  * same id are not going to be minted.
1226  */
1227 abstract contract ERC1155Supply is ERC1155 {
1228     mapping(uint256 => uint256) private _totalSupply;
1229 
1230     /**
1231      * @dev Total amount of tokens in with a given id.
1232      */
1233     function totalSupply(uint256 id) public view virtual returns (uint256) {
1234         return _totalSupply[id];
1235     }
1236 
1237     /**
1238      * @dev Indicates whether any token exist with a given id, or not.
1239      */
1240     function exists(uint256 id) public view virtual returns (bool) {
1241         return ERC1155Supply.totalSupply(id) > 0;
1242     }
1243 
1244     /**
1245      * @dev See {ERC1155-_beforeTokenTransfer}.
1246      */
1247     function _beforeTokenTransfer(
1248         address operator,
1249         address from,
1250         address to,
1251         uint256[] memory ids,
1252         uint256[] memory amounts,
1253         bytes memory data
1254     ) internal virtual override {
1255         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1256 
1257         if (from == address(0)) {
1258             for (uint256 i = 0; i < ids.length; ++i) {
1259                 _totalSupply[ids[i]] += amounts[i];
1260             }
1261         }
1262 
1263         if (to == address(0)) {
1264             for (uint256 i = 0; i < ids.length; ++i) {
1265                 _totalSupply[ids[i]] -= amounts[i];
1266             }
1267         }
1268     }
1269 }
1270 
1271 // File: contracts/toxicPower.sol
1272 
1273 
1274 
1275 pragma solidity ^0.8.0;
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 contract ToxicPower is ERC1155Supply, Ownable, ReentrancyGuard  {
1284     using Strings for uint256;
1285 
1286     uint16[] public maxSupplyEach = [500, 100, 30];
1287     uint16[] public tokensNecessary = [2, 5, 10];
1288 
1289     // Timestamp of the start and end of sales
1290     uint256 public windowCloses = 1649617200;
1291     uint256 public burnWindowOpens = 1649620800;
1292     
1293     // Survive amount for each toxic power
1294     uint256[] public amountSurvive = [99000000000000000000, 399000000000000000000, 999000000000000000000];
1295     bool public paused = false;
1296     
1297     string public name = "Toxic Power";
1298     string public symbol = "Toxic Power";
1299 
1300     // For each address, how much was minted already
1301     mapping(address => uint256) public purchasedToxicOne;
1302     mapping(address => uint256) public purchasedToxicTwo;
1303     mapping(address => uint256) public purchasedToxicThree;
1304     mapping(address => uint256) public usedTokens;
1305 
1306     ISurvive survive;
1307     IUnity unity;
1308 
1309     constructor(
1310         string memory _uri,
1311         address _survive,
1312         address _unity
1313     ) ERC1155(_uri) {
1314         survive = ISurvive(_survive);
1315         unity = IUnity(_unity);
1316     }
1317 
1318     // Modifier to verify if contract is paused
1319     modifier whenNotPaused() {
1320         require(!paused, "Contract is currently paused");
1321         _;
1322     }
1323 
1324     function claimOne() external {
1325         require(purchasedToxicOne[msg.sender] == 0, "You've already claimed one for this categgory.");
1326         claim(0);
1327 
1328         purchasedToxicOne[msg.sender] = 1;
1329     }
1330 
1331     function claimTwo() external {
1332         require(purchasedToxicTwo[msg.sender] == 0, "You've already claimed one for this categgory.");
1333 
1334         claim(1);
1335 
1336         purchasedToxicTwo[msg.sender] = 1;
1337     }
1338 
1339     function claimThree() external {
1340         require(purchasedToxicThree[msg.sender] == 0, "You've already claimed one for this categgory.");
1341 
1342         claim(2);
1343 
1344         purchasedToxicThree[msg.sender] = 1;
1345     }
1346 
1347     function claim(uint8 toxic) private whenNotPaused {
1348         require(tx.origin == msg.sender, "No bots allowed.");
1349         require(block.timestamp <= windowCloses, "You can't claim anymore toxic power, time is up.");
1350         require(totalSupply(toxic) < maxSupplyEach[toxic], "Max supply reached for this toxic, please mint another.");
1351         uint256 unityBalance = unity.balanceOf(msg.sender);
1352         require(usedTokens[msg.sender] + tokensNecessary[toxic] <= unityBalance, "You don't have enough free tokens for mint.");
1353         
1354         _mint(msg.sender, toxic, 1, "");
1355 
1356         usedTokens[msg.sender] += tokensNecessary[toxic];
1357     }
1358     
1359     function setMaxSupply(uint16[] calldata _maxSupplyEach) external onlyOwner {
1360         maxSupplyEach = _maxSupplyEach;
1361     }
1362 
1363     // Pause the contract, so no one can call mint functions
1364     function pauseContract(bool _state) external onlyOwner {
1365         paused = _state;
1366     }
1367 
1368     function uri(uint256 _id) public view override returns (string memory) {
1369         require(exists(_id), "URI: nonexistent token");
1370         return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
1371     }
1372 
1373     function setUri(string memory newUri) external onlyOwner {
1374         super._setURI(newUri);
1375     }
1376 
1377     function setWindows(uint256 _burnWindowOpens, uint256 _windowCloses)  external onlyOwner {
1378         burnWindowOpens = _burnWindowOpens;
1379         windowCloses = _windowCloses;
1380     }
1381 
1382     function burn(uint256[] calldata tokensId) external {
1383         require(block.timestamp >= burnWindowOpens, "You can't burn your tokens yet.");
1384 
1385         for(uint8 i = 0; i < tokensId.length; i++){
1386             require(balanceOf(msg.sender, tokensId[i]) > 0, "Needs to have token, to burn it.");
1387             _burn(msg.sender, tokensId[i], 1);
1388             survive.claimToxic(msg.sender, amountSurvive[tokensId[i]]);
1389         }
1390     }
1391 
1392 }