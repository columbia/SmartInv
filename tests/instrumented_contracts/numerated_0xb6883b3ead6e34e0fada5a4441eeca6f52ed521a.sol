1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
64 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
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
130 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
200 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
227 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
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
305 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
530 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
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
558 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
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
589 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155Receiver.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
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
649 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol
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
776 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
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
800 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
801 
802 
803 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
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
970 
971         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
972 
973         uint256 fromBalance = _balances[id][from];
974         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
975         unchecked {
976             _balances[id][from] = fromBalance - amount;
977         }
978         _balances[id][to] += amount;
979 
980         emit TransferSingle(operator, from, to, id, amount);
981 
982         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
983     }
984 
985     /**
986      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
987      *
988      * Emits a {TransferBatch} event.
989      *
990      * Requirements:
991      *
992      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
993      * acceptance magic value.
994      */
995     function _safeBatchTransferFrom(
996         address from,
997         address to,
998         uint256[] memory ids,
999         uint256[] memory amounts,
1000         bytes memory data
1001     ) internal virtual {
1002         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1003         require(to != address(0), "ERC1155: transfer to the zero address");
1004 
1005         address operator = _msgSender();
1006 
1007         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1008 
1009         for (uint256 i = 0; i < ids.length; ++i) {
1010             uint256 id = ids[i];
1011             uint256 amount = amounts[i];
1012 
1013             uint256 fromBalance = _balances[id][from];
1014             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1015             unchecked {
1016                 _balances[id][from] = fromBalance - amount;
1017             }
1018             _balances[id][to] += amount;
1019         }
1020 
1021         emit TransferBatch(operator, from, to, ids, amounts);
1022 
1023         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1024     }
1025 
1026     /**
1027      * @dev Sets a new URI for all token types, by relying on the token type ID
1028      * substitution mechanism
1029      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1030      *
1031      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1032      * URI or any of the amounts in the JSON file at said URI will be replaced by
1033      * clients with the token type ID.
1034      *
1035      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1036      * interpreted by clients as
1037      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1038      * for token type ID 0x4cce0.
1039      *
1040      * See {uri}.
1041      *
1042      * Because these URIs cannot be meaningfully represented by the {URI} event,
1043      * this function emits no events.
1044      */
1045     function _setURI(string memory newuri) internal virtual {
1046         _uri = newuri;
1047     }
1048 
1049     /**
1050      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1051      *
1052      * Emits a {TransferSingle} event.
1053      *
1054      * Requirements:
1055      *
1056      * - `to` cannot be the zero address.
1057      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1058      * acceptance magic value.
1059      */
1060     function _mint(
1061         address to,
1062         uint256 id,
1063         uint256 amount,
1064         bytes memory data
1065     ) internal virtual {
1066         require(to != address(0), "ERC1155: mint to the zero address");
1067 
1068         address operator = _msgSender();
1069 
1070         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1071 
1072         _balances[id][to] += amount;
1073         emit TransferSingle(operator, address(0), to, id, amount);
1074 
1075         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1076     }
1077 
1078     /**
1079      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1080      *
1081      * Requirements:
1082      *
1083      * - `ids` and `amounts` must have the same length.
1084      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1085      * acceptance magic value.
1086      */
1087     function _mintBatch(
1088         address to,
1089         uint256[] memory ids,
1090         uint256[] memory amounts,
1091         bytes memory data
1092     ) internal virtual {
1093         require(to != address(0), "ERC1155: mint to the zero address");
1094         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1095 
1096         address operator = _msgSender();
1097 
1098         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1099 
1100         for (uint256 i = 0; i < ids.length; i++) {
1101             _balances[ids[i]][to] += amounts[i];
1102         }
1103 
1104         emit TransferBatch(operator, address(0), to, ids, amounts);
1105 
1106         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1107     }
1108 
1109     /**
1110      * @dev Destroys `amount` tokens of token type `id` from `from`
1111      *
1112      * Requirements:
1113      *
1114      * - `from` cannot be the zero address.
1115      * - `from` must have at least `amount` tokens of token type `id`.
1116      */
1117     function _burn(
1118         address from,
1119         uint256 id,
1120         uint256 amount
1121     ) internal virtual {
1122         require(from != address(0), "ERC1155: burn from the zero address");
1123 
1124         address operator = _msgSender();
1125 
1126         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1127 
1128         uint256 fromBalance = _balances[id][from];
1129         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1130         unchecked {
1131             _balances[id][from] = fromBalance - amount;
1132         }
1133 
1134         emit TransferSingle(operator, from, address(0), id, amount);
1135     }
1136 
1137     /**
1138      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1139      *
1140      * Requirements:
1141      *
1142      * - `ids` and `amounts` must have the same length.
1143      */
1144     function _burnBatch(
1145         address from,
1146         uint256[] memory ids,
1147         uint256[] memory amounts
1148     ) internal virtual {
1149         require(from != address(0), "ERC1155: burn from the zero address");
1150         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1151 
1152         address operator = _msgSender();
1153 
1154         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1155 
1156         for (uint256 i = 0; i < ids.length; i++) {
1157             uint256 id = ids[i];
1158             uint256 amount = amounts[i];
1159 
1160             uint256 fromBalance = _balances[id][from];
1161             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1162             unchecked {
1163                 _balances[id][from] = fromBalance - amount;
1164             }
1165         }
1166 
1167         emit TransferBatch(operator, from, address(0), ids, amounts);
1168     }
1169 
1170     /**
1171      * @dev Approve `operator` to operate on all of `owner` tokens
1172      *
1173      * Emits a {ApprovalForAll} event.
1174      */
1175     function _setApprovalForAll(
1176         address owner,
1177         address operator,
1178         bool approved
1179     ) internal virtual {
1180         require(owner != operator, "ERC1155: setting approval status for self");
1181         _operatorApprovals[owner][operator] = approved;
1182         emit ApprovalForAll(owner, operator, approved);
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before any token transfer. This includes minting
1187      * and burning, as well as batched variants.
1188      *
1189      * The same hook is called on both single and batched variants. For single
1190      * transfers, the length of the `id` and `amount` arrays will be 1.
1191      *
1192      * Calling conditions (for each `id` and `amount` pair):
1193      *
1194      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1195      * of token type `id` will be  transferred to `to`.
1196      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1197      * for `to`.
1198      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1199      * will be burned.
1200      * - `from` and `to` are never both zero.
1201      * - `ids` and `amounts` have the same, non-zero length.
1202      *
1203      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1204      */
1205     function _beforeTokenTransfer(
1206         address operator,
1207         address from,
1208         address to,
1209         uint256[] memory ids,
1210         uint256[] memory amounts,
1211         bytes memory data
1212     ) internal virtual {}
1213 
1214     function _doSafeTransferAcceptanceCheck(
1215         address operator,
1216         address from,
1217         address to,
1218         uint256 id,
1219         uint256 amount,
1220         bytes memory data
1221     ) private {
1222         if (to.isContract()) {
1223             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1224                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1225                     revert("ERC1155: ERC1155Receiver rejected tokens");
1226                 }
1227             } catch Error(string memory reason) {
1228                 revert(reason);
1229             } catch {
1230                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1231             }
1232         }
1233     }
1234 
1235     function _doSafeBatchTransferAcceptanceCheck(
1236         address operator,
1237         address from,
1238         address to,
1239         uint256[] memory ids,
1240         uint256[] memory amounts,
1241         bytes memory data
1242     ) private {
1243         if (to.isContract()) {
1244             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1245                 bytes4 response
1246             ) {
1247                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1248                     revert("ERC1155: ERC1155Receiver rejected tokens");
1249                 }
1250             } catch Error(string memory reason) {
1251                 revert(reason);
1252             } catch {
1253                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1254             }
1255         }
1256     }
1257 
1258     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1259         uint256[] memory array = new uint256[](1);
1260         array[0] = element;
1261 
1262         return array;
1263     }
1264 }
1265 
1266 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1267 
1268 
1269 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 
1274 /**
1275  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1276  *
1277  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1278  * clearly identified. Note: While a totalSupply of 1 might mean the
1279  * corresponding is an NFT, there is no guarantees that no other token with the
1280  * same id are not going to be minted.
1281  */
1282 abstract contract ERC1155Supply is ERC1155 {
1283     mapping(uint256 => uint256) private _totalSupply;
1284 
1285     /**
1286      * @dev Total amount of tokens in with a given id.
1287      */
1288     function totalSupply(uint256 id) public view virtual returns (uint256) {
1289         return _totalSupply[id];
1290     }
1291 
1292     /**
1293      * @dev Indicates whether any token exist with a given id, or not.
1294      */
1295     function exists(uint256 id) public view virtual returns (bool) {
1296         return ERC1155Supply.totalSupply(id) > 0;
1297     }
1298 
1299     /**
1300      * @dev See {ERC1155-_beforeTokenTransfer}.
1301      */
1302     function _beforeTokenTransfer(
1303         address operator,
1304         address from,
1305         address to,
1306         uint256[] memory ids,
1307         uint256[] memory amounts,
1308         bytes memory data
1309     ) internal virtual override {
1310         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1311 
1312         if (from == address(0)) {
1313             for (uint256 i = 0; i < ids.length; ++i) {
1314                 _totalSupply[ids[i]] += amounts[i];
1315             }
1316         }
1317 
1318         if (to == address(0)) {
1319             for (uint256 i = 0; i < ids.length; ++i) {
1320                 _totalSupply[ids[i]] -= amounts[i];
1321             }
1322         }
1323     }
1324 }
1325 
1326 // File: donteWalkerNft.sol
1327 
1328 pragma solidity 0.8.9;
1329 
1330 
1331 
1332 
1333 
1334 
1335 
1336 /// SPDX-License-Identifier: UNLICENSED
1337 
1338 contract DWCNFTGENESIS is ERC1155, ERC1155Supply, ReentrancyGuard, Ownable {
1339    
1340     using Strings for uint256;
1341     
1342     bytes32 public DiamondMerkleRoot = 0x54b0746df51cbbb2f9ab043955478c4824f8dccc1cbe3da00fef46609652f248;
1343     bytes32 public CarbonMerkleRoot = 0x33b71d34e9eee3cae1ce39d3fb1956ed9d977692d84fd6ec025a0b39bb3c17ad;
1344 
1345     string public baseURI;
1346     string public baseExtension = ".json";
1347 
1348     bool public diamondSaleOpen = true;
1349     bool public carbonSaleOpen = false;
1350 
1351     mapping (address => bool) public whitelistClaimedDiamond;
1352     mapping (address => bool) public whitelistClaimed;
1353     
1354     constructor(string memory _initBaseURI) ERC1155(_initBaseURI)
1355     {
1356         setBaseURI(_initBaseURI);
1357         _mint(msg.sender, 1, 1, "");
1358     }   
1359 
1360     modifier onlySender {
1361         require(msg.sender == tx.origin);
1362         _;
1363     }
1364 
1365     modifier isDiamondSaleOpen {
1366         require(diamondSaleOpen == true);
1367         _;
1368     }
1369 
1370     modifier isCarbonSaleOpen {
1371         require(carbonSaleOpen == true);
1372         _;
1373     }
1374     
1375     function setDiamondMerkleRoot(bytes32 incomingBytes) public onlyOwner
1376     {
1377         DiamondMerkleRoot = incomingBytes;
1378     }
1379     function setCarbonMerkleRoot(bytes32 incomingBytes) public onlyOwner
1380     {
1381         CarbonMerkleRoot = incomingBytes;
1382     }
1383 
1384     function flipToCarbonSale() public onlyOwner
1385     {
1386         diamondSaleOpen = false;
1387         carbonSaleOpen = true;
1388     }
1389     
1390     function diamondSale(bytes32[] calldata _merkleProof) public payable nonReentrant onlySender isDiamondSaleOpen
1391     {
1392         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1393         require(MerkleProof.verify(_merkleProof, DiamondMerkleRoot, leaf), "Invalid proof.");
1394         require(whitelistClaimedDiamond[msg.sender] == false);
1395         whitelistClaimedDiamond[msg.sender] = true;
1396 
1397         _mint(msg.sender, 1, 1, "");
1398         
1399     }
1400     
1401     function carbonSale(bytes32[] calldata _merkleProof) public payable nonReentrant onlySender isCarbonSaleOpen
1402     {
1403         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1404         require(MerkleProof.verify(_merkleProof, CarbonMerkleRoot, leaf), "Invalid proof.");
1405         require(whitelistClaimed[msg.sender] == false);
1406         whitelistClaimed[msg.sender] = true;
1407 
1408         _mint(msg.sender, 2, 1, "");
1409         
1410     }
1411    
1412     function withdrawContractEther(address payable recipient) external onlyOwner
1413     {
1414         recipient.transfer(getBalance());
1415     }
1416     function getBalance() public view returns(uint)
1417     {
1418         return address(this).balance;
1419     }
1420    
1421     function _baseURI() internal view virtual returns (string memory) {
1422         return baseURI;
1423     }
1424    
1425     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1426         baseURI = _newBaseURI;
1427     }
1428    
1429     function uri(uint256 tokenId) public view override virtual returns (string memory)
1430     {
1431         string memory currentBaseURI = _baseURI();
1432         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1433     }
1434 
1435     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1436         internal
1437         override(ERC1155, ERC1155Supply)
1438     {
1439         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1440     }
1441    
1442 
1443 }