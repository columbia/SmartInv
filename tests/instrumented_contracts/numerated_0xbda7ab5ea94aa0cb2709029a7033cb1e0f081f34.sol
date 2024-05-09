1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Contract module that helps prevent reentrant calls to a function.
73  *
74  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
75  * available, which can be applied to functions to make sure there are no nested
76  * (reentrant) calls to them.
77  *
78  * Note that because there is a single `nonReentrant` guard, functions marked as
79  * `nonReentrant` may not call one another. This can be worked around by making
80  * those functions `private`, and then adding `external` `nonReentrant` entry
81  * points to them.
82  *
83  * TIP: If you would like to learn more about reentrancy and alternative ways
84  * to protect against it, check out our blog post
85  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
86  */
87 abstract contract ReentrancyGuard {
88     // Booleans are more expensive than uint256 or any type that takes up a full
89     // word because each write operation emits an extra SLOAD to first read the
90     // slot's contents, replace the bits taken up by the boolean, and then write
91     // back. This is the compiler's defense against contract upgrades and
92     // pointer aliasing, and it cannot be disabled.
93 
94     // The values being non-zero value makes deployment a bit more expensive,
95     // but in exchange the refund on every call to nonReentrant will be lower in
96     // amount. Since refunds are capped to a percentage of the total
97     // transaction's gas, it is best to keep them low in cases like this one, to
98     // increase the likelihood of the full refund coming into effect.
99     uint256 private constant _NOT_ENTERED = 1;
100     uint256 private constant _ENTERED = 2;
101 
102     uint256 private _status;
103 
104     constructor() {
105         _status = _NOT_ENTERED;
106     }
107 
108     /**
109      * @dev Prevents a contract from calling itself, directly or indirectly.
110      * Calling a `nonReentrant` function from another `nonReentrant`
111      * function is not supported. It is possible to prevent this from happening
112      * by making the `nonReentrant` function external, and making it call a
113      * `private` function that does the actual work.
114      */
115     modifier nonReentrant() {
116         // On the first call to nonReentrant, _notEntered will be true
117         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
118 
119         // Any calls to nonReentrant after this point will fail
120         _status = _ENTERED;
121 
122         _;
123 
124         // By storing the original value once again, a refund is triggered (see
125         // https://eips.ethereum.org/EIPS/eip-2200)
126         _status = _NOT_ENTERED;
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Strings.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev String operations.
139  */
140 library Strings {
141     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
145      */
146     function toString(uint256 value) internal pure returns (string memory) {
147         // Inspired by OraclizeAPI's implementation - MIT licence
148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
149 
150         if (value == 0) {
151             return "0";
152         }
153         uint256 temp = value;
154         uint256 digits;
155         while (temp != 0) {
156             digits++;
157             temp /= 10;
158         }
159         bytes memory buffer = new bytes(digits);
160         while (value != 0) {
161             digits -= 1;
162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
163             value /= 10;
164         }
165         return string(buffer);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
170      */
171     function toHexString(uint256 value) internal pure returns (string memory) {
172         if (value == 0) {
173             return "0x00";
174         }
175         uint256 temp = value;
176         uint256 length = 0;
177         while (temp != 0) {
178             length++;
179             temp >>= 8;
180         }
181         return toHexString(value, length);
182     }
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
186      */
187     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
188         bytes memory buffer = new bytes(2 * length + 2);
189         buffer[0] = "0";
190         buffer[1] = "x";
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192             buffer[i] = _HEX_SYMBOLS[value & 0xf];
193             value >>= 4;
194         }
195         require(value == 0, "Strings: hex length insufficient");
196         return string(buffer);
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Context.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Provides information about the current execution context, including the
209  * sender of the transaction and its data. While these are generally available
210  * via msg.sender and msg.data, they should not be accessed in such a direct
211  * manner, since when dealing with meta-transactions the account sending and
212  * paying for execution may not be the actual sender (as far as an application
213  * is concerned).
214  *
215  * This contract is only required for intermediate, library-like contracts.
216  */
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         return msg.data;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/access/Ownable.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Address.sol
306 
307 
308 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
309 
310 pragma solidity ^0.8.1;
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      *
333      * [IMPORTANT]
334      * ====
335      * You shouldn't rely on `isContract` to protect against flash loan attacks!
336      *
337      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
338      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
339      * constructor.
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize/address.code.length, which returns 0
344         // for contracts in construction, since the code is only stored at the end
345         // of the constructor execution.
346 
347         return account.code.length > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(address(this).balance >= amount, "Address: insufficient balance");
368 
369         (bool success, ) = recipient.call{value: amount}("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 
373     /**
374      * @dev Performs a Solidity function call using a low level `call`. A
375      * plain `call` is an unsafe replacement for a function call: use this
376      * function instead.
377      *
378      * If `target` reverts with a revert reason, it is bubbled up by this
379      * function (like regular Solidity function calls).
380      *
381      * Returns the raw returned data. To convert to the expected return value,
382      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
383      *
384      * Requirements:
385      *
386      * - `target` must be a contract.
387      * - calling `target` with `data` must not revert.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionCall(target, data, "Address: low-level call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
397      * `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         require(isContract(target), "Address: call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.call{value: value}(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.staticcall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         require(isContract(target), "Address: delegate call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
503      * revert reason using the provided one.
504      *
505      * _Available since v4.3._
506      */
507     function verifyCallResult(
508         bool success,
509         bytes memory returndata,
510         string memory errorMessage
511     ) internal pure returns (bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             // Look for revert reason and bubble it up if present
516             if (returndata.length > 0) {
517                 // The easiest way to bubble the revert reason is using memory via assembly
518 
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Interface of the ERC165 standard, as defined in the
539  * https://eips.ethereum.org/EIPS/eip-165[EIP].
540  *
541  * Implementers can declare support of contract interfaces, which can then be
542  * queried by others ({ERC165Checker}).
543  *
544  * For an implementation, see {ERC165}.
545  */
546 interface IERC165 {
547     /**
548      * @dev Returns true if this contract implements the interface defined by
549      * `interfaceId`. See the corresponding
550      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
551      * to learn more about how these ids are created.
552      *
553      * This function call must use less than 30 000 gas.
554      */
555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
556 }
557 
558 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Implementation of the {IERC165} interface.
568  *
569  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
570  * for the additional interface id that will be supported. For example:
571  *
572  * ```solidity
573  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
575  * }
576  * ```
577  *
578  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
579  */
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
590 
591 
592 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 /**
598  * @dev _Available since v3.1._
599  */
600 interface IERC1155Receiver is IERC165 {
601     /**
602      * @dev Handles the receipt of a single ERC1155 token type. This function is
603      * called at the end of a `safeTransferFrom` after the balance has been updated.
604      *
605      * NOTE: To accept the transfer, this must return
606      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
607      * (i.e. 0xf23a6e61, or its own function selector).
608      *
609      * @param operator The address which initiated the transfer (i.e. msg.sender)
610      * @param from The address which previously owned the token
611      * @param id The ID of the token being transferred
612      * @param value The amount of tokens being transferred
613      * @param data Additional data with no specified format
614      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
615      */
616     function onERC1155Received(
617         address operator,
618         address from,
619         uint256 id,
620         uint256 value,
621         bytes calldata data
622     ) external returns (bytes4);
623 
624     /**
625      * @dev Handles the receipt of a multiple ERC1155 token types. This function
626      * is called at the end of a `safeBatchTransferFrom` after the balances have
627      * been updated.
628      *
629      * NOTE: To accept the transfer(s), this must return
630      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
631      * (i.e. 0xbc197c81, or its own function selector).
632      *
633      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
634      * @param from The address which previously owned the token
635      * @param ids An array containing ids of each token being transferred (order and length must match values array)
636      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
637      * @param data Additional data with no specified format
638      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
639      */
640     function onERC1155BatchReceived(
641         address operator,
642         address from,
643         uint256[] calldata ids,
644         uint256[] calldata values,
645         bytes calldata data
646     ) external returns (bytes4);
647 }
648 
649 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 
657 /**
658  * @dev Required interface of an ERC1155 compliant contract, as defined in the
659  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
660  *
661  * _Available since v3.1._
662  */
663 interface IERC1155 is IERC165 {
664     /**
665      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
666      */
667     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
668 
669     /**
670      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
671      * transfers.
672      */
673     event TransferBatch(
674         address indexed operator,
675         address indexed from,
676         address indexed to,
677         uint256[] ids,
678         uint256[] values
679     );
680 
681     /**
682      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
683      * `approved`.
684      */
685     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
686 
687     /**
688      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
689      *
690      * If an {URI} event was emitted for `id`, the standard
691      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
692      * returned by {IERC1155MetadataURI-uri}.
693      */
694     event URI(string value, uint256 indexed id);
695 
696     /**
697      * @dev Returns the amount of tokens of token type `id` owned by `account`.
698      *
699      * Requirements:
700      *
701      * - `account` cannot be the zero address.
702      */
703     function balanceOf(address account, uint256 id) external view returns (uint256);
704 
705     /**
706      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
707      *
708      * Requirements:
709      *
710      * - `accounts` and `ids` must have the same length.
711      */
712     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
713         external
714         view
715         returns (uint256[] memory);
716 
717     /**
718      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
719      *
720      * Emits an {ApprovalForAll} event.
721      *
722      * Requirements:
723      *
724      * - `operator` cannot be the caller.
725      */
726     function setApprovalForAll(address operator, bool approved) external;
727 
728     /**
729      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
730      *
731      * See {setApprovalForAll}.
732      */
733     function isApprovedForAll(address account, address operator) external view returns (bool);
734 
735     /**
736      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
737      *
738      * Emits a {TransferSingle} event.
739      *
740      * Requirements:
741      *
742      * - `to` cannot be the zero address.
743      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
744      * - `from` must have a balance of tokens of type `id` of at least `amount`.
745      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
746      * acceptance magic value.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 id,
752         uint256 amount,
753         bytes calldata data
754     ) external;
755 
756     /**
757      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
758      *
759      * Emits a {TransferBatch} event.
760      *
761      * Requirements:
762      *
763      * - `ids` and `amounts` must have the same length.
764      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
765      * acceptance magic value.
766      */
767     function safeBatchTransferFrom(
768         address from,
769         address to,
770         uint256[] calldata ids,
771         uint256[] calldata amounts,
772         bytes calldata data
773     ) external;
774 }
775 
776 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
777 
778 
779 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 /**
785  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
786  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
787  *
788  * _Available since v3.1._
789  */
790 interface IERC1155MetadataURI is IERC1155 {
791     /**
792      * @dev Returns the URI for token type `id`.
793      *
794      * If the `\{id\}` substring is present in the URI, it must be replaced by
795      * clients with the actual token type ID.
796      */
797     function uri(uint256 id) external view returns (string memory);
798 }
799 
800 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
801 
802 
803 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
804 
805 pragma solidity ^0.8.0;
806 
807 
808 
809 
810 
811 
812 
813 /**
814  * @dev Implementation of the basic standard multi-token.
815  * See https://eips.ethereum.org/EIPS/eip-1155
816  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
817  *
818  * _Available since v3.1._
819  */
820 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
821     using Address for address;
822 
823     // Mapping from token ID to account balances
824     mapping(uint256 => mapping(address => uint256)) private _balances;
825 
826     // Mapping from account to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
830     string private _uri;
831 
832     /**
833      * @dev See {_setURI}.
834      */
835     constructor(string memory uri_) {
836         _setURI(uri_);
837     }
838 
839     /**
840      * @dev See {IERC165-supportsInterface}.
841      */
842     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
843         return
844             interfaceId == type(IERC1155).interfaceId ||
845             interfaceId == type(IERC1155MetadataURI).interfaceId ||
846             super.supportsInterface(interfaceId);
847     }
848 
849     /**
850      * @dev See {IERC1155MetadataURI-uri}.
851      *
852      * This implementation returns the same URI for *all* token types. It relies
853      * on the token type ID substitution mechanism
854      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
855      *
856      * Clients calling this function must replace the `\{id\}` substring with the
857      * actual token type ID.
858      */
859     function uri(uint256) public view virtual override returns (string memory) {
860         return _uri;
861     }
862 
863     /**
864      * @dev See {IERC1155-balanceOf}.
865      *
866      * Requirements:
867      *
868      * - `account` cannot be the zero address.
869      */
870     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
871         require(account != address(0), "ERC1155: balance query for the zero address");
872         return _balances[id][account];
873     }
874 
875     /**
876      * @dev See {IERC1155-balanceOfBatch}.
877      *
878      * Requirements:
879      *
880      * - `accounts` and `ids` must have the same length.
881      */
882     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
883         public
884         view
885         virtual
886         override
887         returns (uint256[] memory)
888     {
889         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
890 
891         uint256[] memory batchBalances = new uint256[](accounts.length);
892 
893         for (uint256 i = 0; i < accounts.length; ++i) {
894             batchBalances[i] = balanceOf(accounts[i], ids[i]);
895         }
896 
897         return batchBalances;
898     }
899 
900     /**
901      * @dev See {IERC1155-setApprovalForAll}.
902      */
903     function setApprovalForAll(address operator, bool approved) public virtual override {
904         _setApprovalForAll(_msgSender(), operator, approved);
905     }
906 
907     /**
908      * @dev See {IERC1155-isApprovedForAll}.
909      */
910     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
911         return _operatorApprovals[account][operator];
912     }
913 
914     /**
915      * @dev See {IERC1155-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 id,
921         uint256 amount,
922         bytes memory data
923     ) public virtual override {
924         require(
925             from == _msgSender() || isApprovedForAll(from, _msgSender()),
926             "ERC1155: caller is not owner nor approved"
927         );
928         _safeTransferFrom(from, to, id, amount, data);
929     }
930 
931     /**
932      * @dev See {IERC1155-safeBatchTransferFrom}.
933      */
934     function safeBatchTransferFrom(
935         address from,
936         address to,
937         uint256[] memory ids,
938         uint256[] memory amounts,
939         bytes memory data
940     ) public virtual override {
941         require(
942             from == _msgSender() || isApprovedForAll(from, _msgSender()),
943             "ERC1155: transfer caller is not owner nor approved"
944         );
945         _safeBatchTransferFrom(from, to, ids, amounts, data);
946     }
947 
948     /**
949      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
950      *
951      * Emits a {TransferSingle} event.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `from` must have a balance of tokens of type `id` of at least `amount`.
957      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
958      * acceptance magic value.
959      */
960     function _safeTransferFrom(
961         address from,
962         address to,
963         uint256 id,
964         uint256 amount,
965         bytes memory data
966     ) internal virtual {
967         require(to != address(0), "ERC1155: transfer to the zero address");
968 
969         address operator = _msgSender();
970         uint256[] memory ids = _asSingletonArray(id);
971         uint256[] memory amounts = _asSingletonArray(amount);
972 
973         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
974 
975         uint256 fromBalance = _balances[id][from];
976         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
977         unchecked {
978             _balances[id][from] = fromBalance - amount;
979         }
980         _balances[id][to] += amount;
981 
982         emit TransferSingle(operator, from, to, id, amount);
983 
984         _afterTokenTransfer(operator, from, to, ids, amounts, data);
985 
986         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
987     }
988 
989     /**
990      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
991      *
992      * Emits a {TransferBatch} event.
993      *
994      * Requirements:
995      *
996      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
997      * acceptance magic value.
998      */
999     function _safeBatchTransferFrom(
1000         address from,
1001         address to,
1002         uint256[] memory ids,
1003         uint256[] memory amounts,
1004         bytes memory data
1005     ) internal virtual {
1006         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1007         require(to != address(0), "ERC1155: transfer to the zero address");
1008 
1009         address operator = _msgSender();
1010 
1011         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1012 
1013         for (uint256 i = 0; i < ids.length; ++i) {
1014             uint256 id = ids[i];
1015             uint256 amount = amounts[i];
1016 
1017             uint256 fromBalance = _balances[id][from];
1018             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1019             unchecked {
1020                 _balances[id][from] = fromBalance - amount;
1021             }
1022             _balances[id][to] += amount;
1023         }
1024 
1025         emit TransferBatch(operator, from, to, ids, amounts);
1026 
1027         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1028 
1029         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1030     }
1031 
1032     /**
1033      * @dev Sets a new URI for all token types, by relying on the token type ID
1034      * substitution mechanism
1035      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1036      *
1037      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1038      * URI or any of the amounts in the JSON file at said URI will be replaced by
1039      * clients with the token type ID.
1040      *
1041      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1042      * interpreted by clients as
1043      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1044      * for token type ID 0x4cce0.
1045      *
1046      * See {uri}.
1047      *
1048      * Because these URIs cannot be meaningfully represented by the {URI} event,
1049      * this function emits no events.
1050      */
1051     function _setURI(string memory newuri) internal virtual {
1052         _uri = newuri;
1053     }
1054 
1055     /**
1056      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1057      *
1058      * Emits a {TransferSingle} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `to` cannot be the zero address.
1063      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1064      * acceptance magic value.
1065      */
1066     function _mint(
1067         address to,
1068         uint256 id,
1069         uint256 amount,
1070         bytes memory data
1071     ) internal virtual {
1072         require(to != address(0), "ERC1155: mint to the zero address");
1073 
1074         address operator = _msgSender();
1075         uint256[] memory ids = _asSingletonArray(id);
1076         uint256[] memory amounts = _asSingletonArray(amount);
1077 
1078         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1079 
1080         _balances[id][to] += amount;
1081         emit TransferSingle(operator, address(0), to, id, amount);
1082 
1083         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1084 
1085         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1086     }
1087 
1088     /**
1089      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1090      *
1091      * Requirements:
1092      *
1093      * - `ids` and `amounts` must have the same length.
1094      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1095      * acceptance magic value.
1096      */
1097     function _mintBatch(
1098         address to,
1099         uint256[] memory ids,
1100         uint256[] memory amounts,
1101         bytes memory data
1102     ) internal virtual {
1103         require(to != address(0), "ERC1155: mint to the zero address");
1104         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1105 
1106         address operator = _msgSender();
1107 
1108         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1109 
1110         for (uint256 i = 0; i < ids.length; i++) {
1111             _balances[ids[i]][to] += amounts[i];
1112         }
1113 
1114         emit TransferBatch(operator, address(0), to, ids, amounts);
1115 
1116         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1117 
1118         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1119     }
1120 
1121     /**
1122      * @dev Destroys `amount` tokens of token type `id` from `from`
1123      *
1124      * Requirements:
1125      *
1126      * - `from` cannot be the zero address.
1127      * - `from` must have at least `amount` tokens of token type `id`.
1128      */
1129     function _burn(
1130         address from,
1131         uint256 id,
1132         uint256 amount
1133     ) internal virtual {
1134         require(from != address(0), "ERC1155: burn from the zero address");
1135 
1136         address operator = _msgSender();
1137         uint256[] memory ids = _asSingletonArray(id);
1138         uint256[] memory amounts = _asSingletonArray(amount);
1139 
1140         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1141 
1142         uint256 fromBalance = _balances[id][from];
1143         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1144         unchecked {
1145             _balances[id][from] = fromBalance - amount;
1146         }
1147 
1148         emit TransferSingle(operator, from, address(0), id, amount);
1149 
1150         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1151     }
1152 
1153     /**
1154      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1155      *
1156      * Requirements:
1157      *
1158      * - `ids` and `amounts` must have the same length.
1159      */
1160     function _burnBatch(
1161         address from,
1162         uint256[] memory ids,
1163         uint256[] memory amounts
1164     ) internal virtual {
1165         require(from != address(0), "ERC1155: burn from the zero address");
1166         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1167 
1168         address operator = _msgSender();
1169 
1170         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1171 
1172         for (uint256 i = 0; i < ids.length; i++) {
1173             uint256 id = ids[i];
1174             uint256 amount = amounts[i];
1175 
1176             uint256 fromBalance = _balances[id][from];
1177             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1178             unchecked {
1179                 _balances[id][from] = fromBalance - amount;
1180             }
1181         }
1182 
1183         emit TransferBatch(operator, from, address(0), ids, amounts);
1184 
1185         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1186     }
1187 
1188     /**
1189      * @dev Approve `operator` to operate on all of `owner` tokens
1190      *
1191      * Emits a {ApprovalForAll} event.
1192      */
1193     function _setApprovalForAll(
1194         address owner,
1195         address operator,
1196         bool approved
1197     ) internal virtual {
1198         require(owner != operator, "ERC1155: setting approval status for self");
1199         _operatorApprovals[owner][operator] = approved;
1200         emit ApprovalForAll(owner, operator, approved);
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before any token transfer. This includes minting
1205      * and burning, as well as batched variants.
1206      *
1207      * The same hook is called on both single and batched variants. For single
1208      * transfers, the length of the `id` and `amount` arrays will be 1.
1209      *
1210      * Calling conditions (for each `id` and `amount` pair):
1211      *
1212      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1213      * of token type `id` will be  transferred to `to`.
1214      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1215      * for `to`.
1216      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1217      * will be burned.
1218      * - `from` and `to` are never both zero.
1219      * - `ids` and `amounts` have the same, non-zero length.
1220      *
1221      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1222      */
1223     function _beforeTokenTransfer(
1224         address operator,
1225         address from,
1226         address to,
1227         uint256[] memory ids,
1228         uint256[] memory amounts,
1229         bytes memory data
1230     ) internal virtual {}
1231 
1232     /**
1233      * @dev Hook that is called after any token transfer. This includes minting
1234      * and burning, as well as batched variants.
1235      *
1236      * The same hook is called on both single and batched variants. For single
1237      * transfers, the length of the `id` and `amount` arrays will be 1.
1238      *
1239      * Calling conditions (for each `id` and `amount` pair):
1240      *
1241      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1242      * of token type `id` will be  transferred to `to`.
1243      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1244      * for `to`.
1245      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1246      * will be burned.
1247      * - `from` and `to` are never both zero.
1248      * - `ids` and `amounts` have the same, non-zero length.
1249      *
1250      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1251      */
1252     function _afterTokenTransfer(
1253         address operator,
1254         address from,
1255         address to,
1256         uint256[] memory ids,
1257         uint256[] memory amounts,
1258         bytes memory data
1259     ) internal virtual {}
1260 
1261     function _doSafeTransferAcceptanceCheck(
1262         address operator,
1263         address from,
1264         address to,
1265         uint256 id,
1266         uint256 amount,
1267         bytes memory data
1268     ) private {
1269         if (to.isContract()) {
1270             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1271                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1272                     revert("ERC1155: ERC1155Receiver rejected tokens");
1273                 }
1274             } catch Error(string memory reason) {
1275                 revert(reason);
1276             } catch {
1277                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1278             }
1279         }
1280     }
1281 
1282     function _doSafeBatchTransferAcceptanceCheck(
1283         address operator,
1284         address from,
1285         address to,
1286         uint256[] memory ids,
1287         uint256[] memory amounts,
1288         bytes memory data
1289     ) private {
1290         if (to.isContract()) {
1291             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1292                 bytes4 response
1293             ) {
1294                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1295                     revert("ERC1155: ERC1155Receiver rejected tokens");
1296                 }
1297             } catch Error(string memory reason) {
1298                 revert(reason);
1299             } catch {
1300                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1301             }
1302         }
1303     }
1304 
1305     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1306         uint256[] memory array = new uint256[](1);
1307         array[0] = element;
1308 
1309         return array;
1310     }
1311 }
1312 
1313 // File: contracts/KPKBanners.sol
1314 
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 contract KPKBanners is ERC1155, Ownable,ReentrancyGuard {
1319   
1320 
1321      //To concatenate the URL of an NFT
1322     using Strings for uint256;
1323 
1324     //To check the addresses in the whitelist
1325     bytes32 private mR;   
1326 
1327     //name of the collection
1328     string public name = "KPK Relics"; 
1329    
1330     uint256 private constant sizeMapping = 7;
1331 
1332     //Number of NFTs in the collection
1333     uint256 public constant MAX_SUPPLY = 1000;
1334 
1335     uint256 public numberTokenSold;
1336     
1337     //Is the contract paused ?
1338     bool public paused = false;
1339     
1340 
1341     //The different stages of selling the collection
1342     enum Steps {
1343         Before,
1344         Claim,
1345         SoldOut
1346     }
1347     mapping(address => uint256) nftsPerWallet;
1348     mapping(address => mapping(uint256=>uint256)) nftsBurnPerWallet;
1349     mapping(uint256 => uint256) banners;
1350 
1351     Steps public sellingStep;
1352 
1353     constructor() ERC1155("https://kopokostudio.s3.eu-west-3.amazonaws.com/metadataBanner/{id}.json") {
1354 
1355         transferOwnership(msg.sender);
1356         sellingStep = Steps.Before;
1357         banners[1] = 48;
1358         banners[2] = 150;
1359         banners[3] = 200;
1360         banners[4] = 300;
1361         banners[5] = 300;
1362         banners[6] = 1;
1363         banners[7] = 1;
1364     }
1365     /**
1366     * @notice Edit the Merkle Root 
1367     *
1368     * @param _newMerkleRoot The new Merkle Root
1369     **/
1370     function changeMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
1371         mR = _newMerkleRoot;
1372     }
1373 
1374     function uri(uint256 _tokenid) override public pure returns (string memory) {
1375         return string(
1376             abi.encodePacked(
1377                 "https://kopokostudio.s3.eu-west-3.amazonaws.com/metadataBanner/",
1378                 Strings.toString(_tokenid),".json"
1379             )
1380         );
1381     }
1382 
1383     function getMappingValue() public view returns (uint256[] memory) {
1384         uint256[] memory memoryArray = new uint256[](sizeMapping+1);
1385         for(uint i = 1; i <= sizeMapping; i++) {
1386             memoryArray[i] = banners[i];
1387         }
1388         return memoryArray;
1389     }
1390 
1391     function getMappingValueBurn(address account) public view returns (uint[] memory) {
1392         uint256[] memory memoryArray = new uint256[](sizeMapping+1);
1393         for(uint256 i = 1; i <= sizeMapping; i++) {
1394             memoryArray[i] = nftsBurnPerWallet[account][i];
1395         }
1396         return memoryArray;
1397     }
1398     
1399 
1400     /** 
1401     * @notice Set pause to true or false
1402     *
1403     * @param _paused True or false if you want the contract to be paused or not
1404     **/
1405     function setPaused(bool _paused) external onlyOwner {
1406         paused = _paused;
1407     }
1408 
1409    
1410     /** 
1411     * @notice Allows to change the sellinStep to Claim
1412     **/
1413     function setUpClaim() external onlyOwner {
1414         sellingStep = Steps.Claim;
1415     }
1416 
1417     /**
1418     * @notice Allows to mint one NFT if whitelisted
1419     *
1420     * 
1421     * @param _proof The Merkle Proof
1422     * @param _amount The ammount of NFTs the user wants to mint
1423     **/
1424     function mintBanner(bytes32[] calldata _proof,uint256 _amount, uint256 maxMint) external payable nonReentrant {
1425         
1426         //Are we in Claim ?
1427         require(sellingStep != Steps.SoldOut, "All claimed !");
1428         require(sellingStep == Steps.Claim, "Claim has not started yet.");
1429         require(nftsPerWallet[msg.sender] + _amount <= maxMint, "You can't mint anymore");
1430         //If the user try to mint any non-existent token
1431         require(numberTokenSold + _amount <= MAX_SUPPLY, "Sale is almost done and we don't have enought NFTs left.");
1432         //Is this user on the whitelist ?
1433         require(isWhiteListed(msg.sender, _proof), "You are not on the whitelist");
1434  
1435         uint256 tokenID;
1436         for(uint256 i = 0; i < _amount;i++){
1437             if(numberTokenSold == 167){
1438                 //Mint the user NFT
1439                 _mint(msg.sender, 6, 1, "");
1440                 banners[6]--;
1441                 numberTokenSold += 1;
1442 
1443             }else if(numberTokenSold == 776){
1444                 //Mint the user NFT
1445                 _mint(msg.sender, 7, 1, "");
1446                 banners[7]--;
1447                 numberTokenSold += 1;
1448 
1449             }else{
1450                 tokenID = random(i);
1451                 for(uint256 j = 1; j <= 5; j++){
1452                     if(tokenID == 6){
1453                         tokenID = 1;
1454                     }
1455                     if(banners[tokenID] > 0){ 
1456                         break;
1457                     }else{
1458                         tokenID++;
1459                     }
1460                 }
1461                 //Mint the user NFT
1462                 _mint(msg.sender, tokenID, 1, "");
1463                 banners[tokenID]--;
1464                 numberTokenSold += 1;
1465             }
1466 
1467         }
1468         //Increment the number of NFTs this user minted
1469         nftsPerWallet[msg.sender] += _amount;
1470         if(numberTokenSold == MAX_SUPPLY){
1471             sellingStep = Steps.SoldOut;
1472         }
1473     }   
1474 
1475 
1476     /**
1477     * @notice Allows to burn one NFT to an address
1478     *
1479     * @return number between 1 and 8
1480     **/
1481     function random(uint256 i) public view returns(uint256){
1482     
1483         uint256 randomnumber = uint256(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
1484         msg.sender,i))) % 5;
1485         randomnumber = randomnumber + 1;
1486         return randomnumber;
1487     }
1488 
1489      
1490     /**
1491     * @notice Allows to burn one NFT to an address
1492     *
1493     * @param tokenID The id of the token
1494     * @param amount The amount to burn
1495     **/
1496     function burn(uint256 tokenID, uint256 amount) external {
1497         _burn(msg.sender, tokenID, amount);
1498         nftsBurnPerWallet[msg.sender][tokenID] += amount;
1499        
1500     }
1501 
1502 
1503     /**
1504     * @notice Allows to gift one NFT to an address
1505     *
1506     * @param _account The account of the happy new owner of one NFT
1507     **/
1508     function gift(address _account,uint256 tokenID) external onlyOwner {
1509         require(banners[tokenID] > 0, "No one left !");
1510         //Mint the user NFT
1511         _mint(_account, tokenID, 1, "");
1512         banners[tokenID]--;
1513 
1514         //Increment the number of NFTs this user minted
1515         nftsPerWallet[_account] += 1;
1516         numberTokenSold += 1;
1517 
1518     }
1519 
1520     /**
1521     * @notice Return true or false if the account is whitelisted or not
1522     *
1523     * @param account The account of the user
1524     * @param proof The Merkle Proof
1525     *
1526     * @return true or false if the account is whitelisted or not
1527     **/
1528     function isWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
1529            
1530         return _verify(_leaf(account),proof);
1531     }
1532 
1533     /**
1534     * @notice Return the account hashed
1535     *
1536     * @param account The account to hash
1537     *
1538     * @return The account hashed
1539     **/
1540     function _leaf(address account) internal pure returns(bytes32) {
1541         return keccak256(abi.encodePacked(account));
1542     }
1543 
1544     /** 
1545     * @notice Returns true if a leaf can be proved to be a part of a Merkle tree defined by root
1546     *
1547     * @param leaf The leaf
1548     * @param proof The Merkle Proof
1549     *
1550     * @return True if a leaf can be provded to be a part of a Merkle tree defined by root
1551     **/
1552     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
1553         return MerkleProof.verify(proof, mR, leaf);
1554     }
1555 
1556     
1557 }