1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Context.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev Provides information about the current execution context, including the
146  * sender of the transaction and its data. While these are generally available
147  * via msg.sender and msg.data, they should not be accessed in such a direct
148  * manner, since when dealing with meta-transactions the account sending and
149  * paying for execution may not be the actual sender (as far as an application
150  * is concerned).
151  *
152  * This contract is only required for intermediate, library-like contracts.
153  */
154 abstract contract Context {
155     function _msgSender() internal view virtual returns (address) {
156         return msg.sender;
157     }
158 
159     function _msgData() internal view virtual returns (bytes calldata) {
160         return msg.data;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/security/Pausable.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Contract module which allows children to implement an emergency stop
174  * mechanism that can be triggered by an authorized account.
175  *
176  * This module is used through inheritance. It will make available the
177  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
178  * the functions of your contract. Note that they will not be pausable by
179  * simply including this module, only once the modifiers are put in place.
180  */
181 abstract contract Pausable is Context {
182     /**
183      * @dev Emitted when the pause is triggered by `account`.
184      */
185     event Paused(address account);
186 
187     /**
188      * @dev Emitted when the pause is lifted by `account`.
189      */
190     event Unpaused(address account);
191 
192     bool private _paused;
193 
194     /**
195      * @dev Initializes the contract in unpaused state.
196      */
197     constructor() {
198         _paused = false;
199     }
200 
201     /**
202      * @dev Returns true if the contract is paused, and false otherwise.
203      */
204     function paused() public view virtual returns (bool) {
205         return _paused;
206     }
207 
208     /**
209      * @dev Modifier to make a function callable only when the contract is not paused.
210      *
211      * Requirements:
212      *
213      * - The contract must not be paused.
214      */
215     modifier whenNotPaused() {
216         require(!paused(), "Pausable: paused");
217         _;
218     }
219 
220     /**
221      * @dev Modifier to make a function callable only when the contract is paused.
222      *
223      * Requirements:
224      *
225      * - The contract must be paused.
226      */
227     modifier whenPaused() {
228         require(paused(), "Pausable: not paused");
229         _;
230     }
231 
232     /**
233      * @dev Triggers stopped state.
234      *
235      * Requirements:
236      *
237      * - The contract must not be paused.
238      */
239     function _pause() internal virtual whenNotPaused {
240         _paused = true;
241         emit Paused(_msgSender());
242     }
243 
244     /**
245      * @dev Returns to normal state.
246      *
247      * Requirements:
248      *
249      * - The contract must be paused.
250      */
251     function _unpause() internal virtual whenPaused {
252         _paused = false;
253         emit Unpaused(_msgSender());
254     }
255 }
256 
257 // File: @openzeppelin/contracts/access/Ownable.sol
258 
259 
260 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * By default, the owner account will be the one that deploys the contract. This
271  * can later be changed with {transferOwnership}.
272  *
273  * This module is used through inheritance. It will make available the modifier
274  * `onlyOwner`, which can be applied to your functions to restrict their use to
275  * the owner.
276  */
277 abstract contract Ownable is Context {
278     address private _owner;
279 
280     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
281 
282     /**
283      * @dev Initializes the contract setting the deployer as the initial owner.
284      */
285     constructor() {
286         _transferOwnership(_msgSender());
287     }
288 
289     /**
290      * @dev Returns the address of the current owner.
291      */
292     function owner() public view virtual returns (address) {
293         return _owner;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(owner() == _msgSender(), "Ownable: caller is not the owner");
301         _;
302     }
303 
304     /**
305      * @dev Leaves the contract without owner. It will not be possible to call
306      * `onlyOwner` functions anymore. Can only be called by the current owner.
307      *
308      * NOTE: Renouncing ownership will leave the contract without an owner,
309      * thereby removing any functionality that is only available to the owner.
310      */
311     function renounceOwnership() public virtual onlyOwner {
312         _transferOwnership(address(0));
313     }
314 
315     /**
316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
317      * Can only be called by the current owner.
318      */
319     function transferOwnership(address newOwner) public virtual onlyOwner {
320         require(newOwner != address(0), "Ownable: new owner is the zero address");
321         _transferOwnership(newOwner);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Internal function without access restriction.
327      */
328     function _transferOwnership(address newOwner) internal virtual {
329         address oldOwner = _owner;
330         _owner = newOwner;
331         emit OwnershipTransferred(oldOwner, newOwner);
332     }
333 }
334 
335 // File: @openzeppelin/contracts/utils/Address.sol
336 
337 
338 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // This method relies on extcodesize, which returns 0 for contracts in
365         // construction, since the code is only stored at the end of the
366         // constructor execution.
367 
368         uint256 size;
369         assembly {
370             size := extcodesize(account)
371         }
372         return size > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         (bool success, ) = recipient.call{value: amount}("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain `call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         require(isContract(target), "Address: call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.call{value: value}(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
479         return functionStaticCall(target, data, "Address: low-level static call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.staticcall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
506         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(isContract(target), "Address: delegate call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.delegatecall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
528      * revert reason using the provided one.
529      *
530      * _Available since v4.3._
531      */
532     function verifyCallResult(
533         bool success,
534         bytes memory returndata,
535         string memory errorMessage
536     ) internal pure returns (bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543 
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Interface of the ERC165 standard, as defined in the
564  * https://eips.ethereum.org/EIPS/eip-165[EIP].
565  *
566  * Implementers can declare support of contract interfaces, which can then be
567  * queried by others ({ERC165Checker}).
568  *
569  * For an implementation, see {ERC165}.
570  */
571 interface IERC165 {
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30 000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) external view returns (bool);
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Implementation of the {IERC165} interface.
593  *
594  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
595  * for the additional interface id that will be supported. For example:
596  *
597  * ```solidity
598  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
600  * }
601  * ```
602  *
603  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
604  */
605 abstract contract ERC165 is IERC165 {
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610         return interfaceId == type(IERC165).interfaceId;
611     }
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
615 
616 
617 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155Receiver.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @dev _Available since v3.1._
624  */
625 interface IERC1155Receiver is IERC165 {
626     /**
627         @dev Handles the receipt of a single ERC1155 token type. This function is
628         called at the end of a `safeTransferFrom` after the balance has been updated.
629         To accept the transfer, this must return
630         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
631         (i.e. 0xf23a6e61, or its own function selector).
632         @param operator The address which initiated the transfer (i.e. msg.sender)
633         @param from The address which previously owned the token
634         @param id The ID of the token being transferred
635         @param value The amount of tokens being transferred
636         @param data Additional data with no specified format
637         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
638     */
639     function onERC1155Received(
640         address operator,
641         address from,
642         uint256 id,
643         uint256 value,
644         bytes calldata data
645     ) external returns (bytes4);
646 
647     /**
648         @dev Handles the receipt of a multiple ERC1155 token types. This function
649         is called at the end of a `safeBatchTransferFrom` after the balances have
650         been updated. To accept the transfer(s), this must return
651         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
652         (i.e. 0xbc197c81, or its own function selector).
653         @param operator The address which initiated the batch transfer (i.e. msg.sender)
654         @param from The address which previously owned the token
655         @param ids An array containing ids of each token being transferred (order and length must match values array)
656         @param values An array containing amounts of each token being transferred (order and length must match ids array)
657         @param data Additional data with no specified format
658         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
659     */
660     function onERC1155BatchReceived(
661         address operator,
662         address from,
663         uint256[] calldata ids,
664         uint256[] calldata values,
665         bytes calldata data
666     ) external returns (bytes4);
667 }
668 
669 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 
677 /**
678  * @dev Required interface of an ERC1155 compliant contract, as defined in the
679  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
680  *
681  * _Available since v3.1._
682  */
683 interface IERC1155 is IERC165 {
684     /**
685      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
686      */
687     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
688 
689     /**
690      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
691      * transfers.
692      */
693     event TransferBatch(
694         address indexed operator,
695         address indexed from,
696         address indexed to,
697         uint256[] ids,
698         uint256[] values
699     );
700 
701     /**
702      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
703      * `approved`.
704      */
705     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
706 
707     /**
708      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
709      *
710      * If an {URI} event was emitted for `id`, the standard
711      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
712      * returned by {IERC1155MetadataURI-uri}.
713      */
714     event URI(string value, uint256 indexed id);
715 
716     /**
717      * @dev Returns the amount of tokens of token type `id` owned by `account`.
718      *
719      * Requirements:
720      *
721      * - `account` cannot be the zero address.
722      */
723     function balanceOf(address account, uint256 id) external view returns (uint256);
724 
725     /**
726      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
727      *
728      * Requirements:
729      *
730      * - `accounts` and `ids` must have the same length.
731      */
732     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
733         external
734         view
735         returns (uint256[] memory);
736 
737     /**
738      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
739      *
740      * Emits an {ApprovalForAll} event.
741      *
742      * Requirements:
743      *
744      * - `operator` cannot be the caller.
745      */
746     function setApprovalForAll(address operator, bool approved) external;
747 
748     /**
749      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
750      *
751      * See {setApprovalForAll}.
752      */
753     function isApprovedForAll(address account, address operator) external view returns (bool);
754 
755     /**
756      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
757      *
758      * Emits a {TransferSingle} event.
759      *
760      * Requirements:
761      *
762      * - `to` cannot be the zero address.
763      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
764      * - `from` must have a balance of tokens of type `id` of at least `amount`.
765      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
766      * acceptance magic value.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 id,
772         uint256 amount,
773         bytes calldata data
774     ) external;
775 
776     /**
777      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
778      *
779      * Emits a {TransferBatch} event.
780      *
781      * Requirements:
782      *
783      * - `ids` and `amounts` must have the same length.
784      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
785      * acceptance magic value.
786      */
787     function safeBatchTransferFrom(
788         address from,
789         address to,
790         uint256[] calldata ids,
791         uint256[] calldata amounts,
792         bytes calldata data
793     ) external;
794 }
795 
796 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 
804 /**
805  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
806  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
807  *
808  * _Available since v3.1._
809  */
810 interface IERC1155MetadataURI is IERC1155 {
811     /**
812      * @dev Returns the URI for token type `id`.
813      *
814      * If the `\{id\}` substring is present in the URI, it must be replaced by
815      * clients with the actual token type ID.
816      */
817     function uri(uint256 id) external view returns (string memory);
818 }
819 
820 // File: contracts/ERC1155.sol
821 
822 
823 
824 pragma solidity ^0.8.0;
825 
826 
827 
828 
829 
830 
831 
832 /**
833  * @dev Implementation of the basic standard multi-token.
834  * See https://eips.ethereum.org/EIPS/eip-1155
835  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
836  *
837  * _Available since v3.1._
838  */
839 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
840     using Address for address;
841 
842     // Mapping from token ID to account balances
843     mapping(uint256 => mapping(address => uint256)) internal _balances;
844 
845     // Mapping from account to operator approvals
846     mapping(address => mapping(address => bool)) private _operatorApprovals;
847 
848     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
849     string private _uri;
850 
851     /**
852      * @dev See {_setURI}.
853      */
854     constructor(string memory uri_) {
855         _setURI(uri_);
856     }
857 
858     /**
859      * @dev See {IERC165-supportsInterface}.
860      */
861     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
862         return
863             interfaceId == type(IERC1155).interfaceId ||
864             interfaceId == type(IERC1155MetadataURI).interfaceId ||
865             super.supportsInterface(interfaceId);
866     }
867 
868     /**
869      * @dev See {IERC1155MetadataURI-uri}.
870      *
871      * This implementation returns the same URI for *all* token types. It relies
872      * on the token type ID substitution mechanism
873      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
874      *
875      * Clients calling this function must replace the `\{id\}` substring with the
876      * actual token type ID.
877      */
878     function uri(uint256) public view virtual override returns (string memory) {
879         return _uri;
880     }
881 
882     /**
883      * @dev See {IERC1155-balanceOf}.
884      *
885      * Requirements:
886      *
887      * - `account` cannot be the zero address.
888      */
889     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
890         require(account != address(0), "ERC1155: balance query for the zero address");
891         return _balances[id][account];
892     }
893 
894     /**
895      * @dev See {IERC1155-balanceOfBatch}.
896      *
897      * Requirements:
898      *
899      * - `accounts` and `ids` must have the same length.
900      */
901     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
902         public
903         view
904         virtual
905         override
906         returns (uint256[] memory)
907     {
908         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
909 
910         uint256[] memory batchBalances = new uint256[](accounts.length);
911 
912         for (uint256 i = 0; i < accounts.length; ++i) {
913             batchBalances[i] = balanceOf(accounts[i], ids[i]);
914         }
915 
916         return batchBalances;
917     }
918 
919     /**
920      * @dev See {IERC1155-setApprovalForAll}.
921      */
922     function setApprovalForAll(address operator, bool approved) public virtual override {
923         require(_msgSender() != operator, "ERC1155: setting approval status for self");
924 
925         _operatorApprovals[_msgSender()][operator] = approved;
926         emit ApprovalForAll(_msgSender(), operator, approved);
927     }
928 
929     /**
930      * @dev See {IERC1155-isApprovedForAll}.
931      */
932     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
933         return _operatorApprovals[account][operator];
934     }
935 
936     /**
937      * @dev See {IERC1155-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 id,
943         uint256 amount,
944         bytes memory data
945     ) public virtual override {
946         require(
947             from == _msgSender() || isApprovedForAll(from, _msgSender()),
948             "ERC1155: caller is not owner nor approved"
949         );
950         _safeTransferFrom(from, to, id, amount, data);
951     }
952 
953     /**
954      * @dev See {IERC1155-safeBatchTransferFrom}.
955      */
956     function safeBatchTransferFrom(
957         address from,
958         address to,
959         uint256[] memory ids,
960         uint256[] memory amounts,
961         bytes memory data
962     ) public virtual override {
963         require(
964             from == _msgSender() || isApprovedForAll(from, _msgSender()),
965             "ERC1155: transfer caller is not owner nor approved"
966         );
967         _safeBatchTransferFrom(from, to, ids, amounts, data);
968     }
969 
970     /**
971      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
972      *
973      * Emits a {TransferSingle} event.
974      *
975      * Requirements:
976      *
977      * - `to` cannot be the zero address.
978      * - `from` must have a balance of tokens of type `id` of at least `amount`.
979      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
980      * acceptance magic value.
981      */
982     function _safeTransferFrom(
983         address from,
984         address to,
985         uint256 id,
986         uint256 amount,
987         bytes memory data
988     ) internal virtual {
989         require(to != address(0), "ERC1155: transfer to the zero address");
990 
991         address operator = _msgSender();
992 
993         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
994 
995         uint256 fromBalance = _balances[id][from];
996         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
997         unchecked {
998             _balances[id][from] = fromBalance - amount;
999         }
1000         _balances[id][to] += amount;
1001 
1002         emit TransferSingle(operator, from, to, id, amount);
1003 
1004         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1005     }
1006 
1007     /**
1008      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1009      *
1010      * Emits a {TransferBatch} event.
1011      *
1012      * Requirements:
1013      *
1014      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1015      * acceptance magic value.
1016      */
1017     function _safeBatchTransferFrom(
1018         address from,
1019         address to,
1020         uint256[] memory ids,
1021         uint256[] memory amounts,
1022         bytes memory data
1023     ) internal virtual {
1024         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1025         require(to != address(0), "ERC1155: transfer to the zero address");
1026 
1027         address operator = _msgSender();
1028 
1029         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1030 
1031         for (uint256 i = 0; i < ids.length; ++i) {
1032             uint256 id = ids[i];
1033             uint256 amount = amounts[i];
1034 
1035             uint256 fromBalance = _balances[id][from];
1036             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1037             unchecked {
1038                 _balances[id][from] = fromBalance - amount;
1039             }
1040             _balances[id][to] += amount;
1041         }
1042 
1043         emit TransferBatch(operator, from, to, ids, amounts);
1044 
1045         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1046     }
1047 
1048     /**
1049      * @dev Sets a new URI for all token types, by relying on the token type ID
1050      * substitution mechanism
1051      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1052      *
1053      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1054      * URI or any of the amounts in the JSON file at said URI will be replaced by
1055      * clients with the token type ID.
1056      *
1057      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1058      * interpreted by clients as
1059      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1060      * for token type ID 0x4cce0.
1061      *
1062      * See {uri}.
1063      *
1064      * Because these URIs cannot be meaningfully represented by the {URI} event,
1065      * this function emits no events.
1066      */
1067     function _setURI(string memory newuri) internal virtual {
1068         _uri = newuri;
1069     }
1070 
1071     /**
1072      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1073      *
1074      * Emits a {TransferSingle} event.
1075      *
1076      * Requirements:
1077      *
1078      * - `account` cannot be the zero address.
1079      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1080      * acceptance magic value.
1081      */
1082     function _mint(
1083         address account,
1084         uint256 id,
1085         uint256 amount,
1086         bytes memory data
1087     ) internal virtual {
1088         require(account != address(0), "ERC1155: mint to the zero address");
1089 
1090         address operator = _msgSender();
1091 
1092         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1093 
1094         _balances[id][account] += amount;
1095         emit TransferSingle(operator, address(0), account, id, amount);
1096 
1097         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1098     }
1099 
1100     /**
1101      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1102      *
1103      * Requirements:
1104      *
1105      * - `ids` and `amounts` must have the same length.
1106      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1107      * acceptance magic value.
1108      */
1109     function _mintBatch(
1110         address to,
1111         uint256[] memory ids,
1112         uint256[] memory amounts,
1113         bytes memory data
1114     ) internal virtual {
1115         require(to != address(0), "ERC1155: mint to the zero address");
1116         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1117 
1118         address operator = _msgSender();
1119 
1120         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1121 
1122         for (uint256 i = 0; i < ids.length; i++) {
1123             _balances[ids[i]][to] += amounts[i];
1124         }
1125 
1126         emit TransferBatch(operator, address(0), to, ids, amounts);
1127 
1128         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1129     }
1130 
1131     /**
1132      * @dev Destroys `amount` tokens of token type `id` from `account`
1133      *
1134      * Requirements:
1135      *
1136      * - `account` cannot be the zero address.
1137      * - `account` must have at least `amount` tokens of token type `id`.
1138      */
1139     function _burn(
1140         address account,
1141         uint256 id,
1142         uint256 amount
1143     ) internal virtual {
1144         require(account != address(0), "ERC1155: burn from the zero address");
1145 
1146         address operator = _msgSender();
1147 
1148         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1149 
1150         uint256 accountBalance = _balances[id][account];
1151         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1152         unchecked {
1153             _balances[id][account] = accountBalance - amount;
1154         }
1155 
1156         emit TransferSingle(operator, account, address(0), id, amount);
1157     }
1158 
1159     /**
1160      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1161      *
1162      * Requirements:
1163      *
1164      * - `ids` and `amounts` must have the same length.
1165      */
1166     function _burnBatch(
1167         address account,
1168         uint256[] memory ids,
1169         uint256[] memory amounts
1170     ) internal virtual {
1171         require(account != address(0), "ERC1155: burn from the zero address");
1172         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1173 
1174         address operator = _msgSender();
1175 
1176         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1177 
1178         for (uint256 i = 0; i < ids.length; i++) {
1179             uint256 id = ids[i];
1180             uint256 amount = amounts[i];
1181 
1182             uint256 accountBalance = _balances[id][account];
1183             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
1184             unchecked {
1185                 _balances[id][account] = accountBalance - amount;
1186             }
1187         }
1188 
1189         emit TransferBatch(operator, account, address(0), ids, amounts);
1190     }
1191 
1192     /**
1193      * @dev Hook that is called before any token transfer. This includes minting
1194      * and burning, as well as batched variants.
1195      *
1196      * The same hook is called on both single and batched variants. For single
1197      * transfers, the length of the `id` and `amount` arrays will be 1.
1198      *
1199      * Calling conditions (for each `id` and `amount` pair):
1200      *
1201      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1202      * of token type `id` will be  transferred to `to`.
1203      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1204      * for `to`.
1205      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1206      * will be burned.
1207      * - `from` and `to` are never both zero.
1208      * - `ids` and `amounts` have the same, non-zero length.
1209      *
1210      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1211      */
1212     function _beforeTokenTransfer(
1213         address operator,
1214         address from,
1215         address to,
1216         uint256[] memory ids,
1217         uint256[] memory amounts,
1218         bytes memory data
1219     ) internal virtual {}
1220 
1221     function _doSafeTransferAcceptanceCheck(
1222         address operator,
1223         address from,
1224         address to,
1225         uint256 id,
1226         uint256 amount,
1227         bytes memory data
1228     ) internal {
1229         if (to.isContract()) {
1230             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1231                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1232                     revert("ERC1155: ERC1155Receiver rejected tokens");
1233                 }
1234             } catch Error(string memory reason) {
1235                 revert(reason);
1236             } catch {
1237                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1238             }
1239         }
1240     }
1241 
1242     function _doSafeBatchTransferAcceptanceCheck(
1243         address operator,
1244         address from,
1245         address to,
1246         uint256[] memory ids,
1247         uint256[] memory amounts,
1248         bytes memory data
1249     ) internal {
1250         if (to.isContract()) {
1251             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1252                 bytes4 response
1253             ) {
1254                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1255                     revert("ERC1155: ERC1155Receiver rejected tokens");
1256                 }
1257             } catch Error(string memory reason) {
1258                 revert(reason);
1259             } catch {
1260                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1261             }
1262         }
1263     }
1264 
1265     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1266         uint256[] memory array = new uint256[](1);
1267         array[0] = element;
1268 
1269         return array;
1270     }
1271 }
1272 
1273 // File: contracts/HeartbreakBears.sol
1274 
1275 
1276 pragma solidity ^0.8.2;
1277 
1278 
1279 
1280 
1281 
1282 
1283 
1284 contract HeartbreakBears is ERC1155, Ownable, Pausable, ReentrancyGuard {
1285     constructor()
1286         ERC1155("")
1287     {
1288         name = "Heartbreak Bear Official";
1289         symbol = "HBB";
1290         notRevealedUri = "ipfs://QmabicvNRx8nh7fZNV35tmsSfvsFBffHxdXGNJjsb3Sos2/1.json";
1291     }
1292 // Reveal -  https://ipfs.io/ipfs/QmTNASKD9Y1NM81fC2rcqtv9wak87cmMjVjronrbLJReva/
1293     string public name;
1294     string public symbol;
1295     uint256 public tokenCount;
1296     string public baseUri;
1297     uint256 public cost = 0.06 ether;
1298     uint256 public maxMintAmount = 5;
1299     // uint256 public nftPerAddressLimit = 3;
1300     bool public revealed = false;
1301     string public notRevealedUri;
1302     bool public onlyWhitelisted = true;
1303     address[] public whitelistedAddresses;
1304     uint256 public nftsAvailable = 1888;
1305 
1306     function _mintChecks(uint256 amount) private {
1307         require(
1308             tokenCount + amount <= nftsAvailable,
1309             "No NFTs available for minting"
1310         );
1311 
1312         if (msg.sender != owner()) {
1313             if (onlyWhitelisted == true) {
1314                 require(isWhitelisted(msg.sender), "User is not whitelisted");
1315             }
1316             require(msg.value >= cost * amount, "Insufficient funds");
1317         }
1318     }
1319 
1320     // ADD AIRDROPS Function
1321     function airdrop(address[] memory accounts) public nonReentrant whenNotPaused onlyOwner {
1322         require(
1323             tokenCount + accounts.length <= nftsAvailable,
1324             "No NFTs available for minting"
1325         );
1326 
1327         tokenCount += 1;
1328         for (uint256 i = tokenCount; i < tokenCount + accounts.length; i++) {
1329             address account = accounts[i - tokenCount];
1330             _balances[i][account] += 1;
1331             emit TransferSingle(msg.sender, address(0), account, i, 1);
1332             _doSafeTransferAcceptanceCheck(msg.sender, address(0), account, i, 1, "");
1333         }
1334 
1335         tokenCount += accounts.length - 1;
1336 
1337     }
1338 
1339     function mintBatch(uint256 amount) public payable nonReentrant returns(uint256 id) {
1340         require(amount > 0 && amount <= maxMintAmount, "Invalid mint amount");
1341 
1342         _mintChecks(amount);
1343         if (amount > 1) {
1344             return _mintBatchV2(amount);
1345         } else {
1346             return _mintV2();
1347         }
1348     }
1349 
1350     function mint() public payable nonReentrant {
1351         _mintChecks(1);
1352         _mintV2();
1353     }
1354 
1355     function _mintV2() private whenNotPaused returns(uint256 id) {
1356         require(msg.sender != address(0), "ERC1155: mint to the zero address");
1357 
1358         tokenCount += 1;
1359         _balances[tokenCount][msg.sender] += 1;
1360         emit TransferSingle(msg.sender, address(0), msg.sender, tokenCount, 1);
1361 
1362         _doSafeTransferAcceptanceCheck(
1363             msg.sender,
1364             address(0),
1365             msg.sender,
1366             tokenCount,
1367             1,
1368             ""
1369         );
1370         return tokenCount;
1371     }
1372 
1373     function _mintBatchV2(uint256 amount) private whenNotPaused returns(uint256 id) {
1374         require(msg.sender != address(0), "ERC1155: mint to the zero address");
1375 
1376         tokenCount += 1;
1377 
1378         for (uint256 i = tokenCount; i < tokenCount + amount; i++) {
1379             _mint(msg.sender, i, 1, "");
1380         }
1381 
1382         tokenCount += amount - 1;
1383 
1384         return tokenCount; // Here we just return the last tokenId
1385     }
1386 
1387     function setCost(uint256 _newCost) public onlyOwner {
1388         cost = _newCost;
1389     }
1390 
1391     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1392         maxMintAmount = _newmaxMintAmount;
1393     }
1394 
1395     function reveal(string memory _baseUri) public onlyOwner {
1396         baseUri = _baseUri;
1397         revealed = true;
1398     }
1399 
1400     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1401         baseUri = _newBaseURI;
1402     }
1403 
1404     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1405         notRevealedUri = _notRevealedURI;
1406     }
1407 
1408     function toggleOnlyWhitelisted() public onlyOwner {
1409         if(onlyWhitelisted) {
1410             onlyWhitelisted = false;
1411         } else {
1412             onlyWhitelisted = true;
1413         }
1414         
1415     }
1416 
1417     function setNftsAvailable(uint256 _newAmountAvailable) public onlyOwner {
1418         nftsAvailable = _newAmountAvailable;
1419     }
1420 
1421     function isWhitelisted(address _user) public view returns (bool) {
1422         for (uint256 i = 0; i < whitelistedAddresses.length; i++) {
1423             if (whitelistedAddresses[i] == _user) {
1424                 return true;
1425             }
1426         }
1427         return false;
1428     }
1429 
1430     function setWhitelistUsers(address[] calldata _users) public onlyOwner {
1431         delete whitelistedAddresses;
1432         whitelistedAddresses = _users;
1433     }
1434 
1435     function uri(uint256 _tokenId)
1436         public
1437         view
1438         override
1439         returns (string memory)
1440     {
1441         if (revealed == false) {
1442             return notRevealedUri;
1443         } else {
1444             return
1445                 string(
1446                     abi.encodePacked(
1447                         baseUri,
1448                         Strings.toString(_tokenId),
1449                         ".json"
1450                     )
1451                 );
1452         }
1453     }
1454 
1455     function pause() public onlyOwner {
1456         _pause();
1457     }
1458 
1459     function unpause() public onlyOwner {
1460         _unpause();
1461     }
1462 
1463     function burn(
1464         address account,
1465         uint256 id,
1466         uint256 value
1467     ) public virtual {
1468         require(
1469             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1470             "ERC1155: caller is not owner nor approved"
1471         );
1472 
1473         _burn(account, id, value);
1474     }
1475 
1476     function burnBatch(
1477         address account,
1478         uint256[] memory ids,
1479         uint256[] memory values
1480     ) public virtual {
1481         require(
1482             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1483             "ERC1155: caller is not owner nor approved"
1484         );
1485 
1486         _burnBatch(account, ids, values);
1487     }
1488 
1489     function _beforeTokenTransfer(
1490         address operator,
1491         address from,
1492         address to,
1493         uint256[] memory ids,
1494         uint256[] memory amounts,
1495         bytes memory data
1496     ) internal override whenNotPaused {
1497         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1498     }
1499 
1500     function withdraw() public payable onlyOwner {
1501         (bool os, ) = payable( owner() ).call{ value: address(this).balance }("");
1502         require(os);
1503         // =============================================================================
1504     }
1505 }