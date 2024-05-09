1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin/contracts/interfaces/IERC20.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 
94 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
95 
96 
97 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev These functions deal with verification of Merkle Trees proofs.
103  *
104  * The proofs can be generated using the JavaScript library
105  * https://github.com/miguelmota/merkletreejs[merkletreejs].
106  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
107  *
108  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
109  *
110  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
111  * hashing, or use a hash function other than keccak256 for hashing leaves.
112  * This is because the concatenation of a sorted pair of internal nodes in
113  * the merkle tree could be reinterpreted as a leaf value.
114  */
115 library MerkleProof {
116     /**
117      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
118      * defined by `root`. For this, a `proof` must be provided, containing
119      * sibling hashes on the branch from the leaf to the root of the tree. Each
120      * pair of leaves and each pair of pre-images are assumed to be sorted.
121      */
122     function verify(
123         bytes32[] memory proof,
124         bytes32 root,
125         bytes32 leaf
126     ) internal pure returns (bool) {
127         return processProof(proof, leaf) == root;
128     }
129 
130     /**
131      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
132      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
133      * hash matches the root of the tree. When processing the proof, the pairs
134      * of leafs & pre-images are assumed to be sorted.
135      *
136      * _Available since v4.4._
137      */
138     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
139         bytes32 computedHash = leaf;
140         for (uint256 i = 0; i < proof.length; i++) {
141             bytes32 proofElement = proof[i];
142             if (computedHash <= proofElement) {
143                 // Hash(current computed hash + current element of the proof)
144                 computedHash = _efficientHash(computedHash, proofElement);
145             } else {
146                 // Hash(current element of the proof + current computed hash)
147                 computedHash = _efficientHash(proofElement, computedHash);
148             }
149         }
150         return computedHash;
151     }
152 
153     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
154         assembly {
155             mstore(0x00, a)
156             mstore(0x20, b)
157             value := keccak256(0x00, 0x40)
158         }
159     }
160 }
161 
162 // File: @openzeppelin/contracts/utils/Counters.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @title Counters
171  * @author Matt Condon (@shrugs)
172  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
173  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
174  *
175  * Include with `using Counters for Counters.Counter;`
176  */
177 library Counters {
178     struct Counter {
179         // This variable should never be directly accessed by users of the library: interactions must be restricted to
180         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
181         // this feature: see https://github.com/ethereum/solidity/issues/4637
182         uint256 _value; // default: 0
183     }
184 
185     function current(Counter storage counter) internal view returns (uint256) {
186         return counter._value;
187     }
188 
189     function increment(Counter storage counter) internal {
190         unchecked {
191             counter._value += 1;
192         }
193     }
194 
195     function decrement(Counter storage counter) internal {
196         uint256 value = counter._value;
197         require(value > 0, "Counter: decrement overflow");
198         unchecked {
199             counter._value = value - 1;
200         }
201     }
202 
203     function reset(Counter storage counter) internal {
204         counter._value = 0;
205     }
206 }
207 
208 // File: @openzeppelin/contracts/utils/Strings.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 /**
216  * @dev String operations.
217  */
218 library Strings {
219     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
220 
221     /**
222      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
223      */
224     function toString(uint256 value) internal pure returns (string memory) {
225         // Inspired by OraclizeAPI's implementation - MIT licence
226         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
227 
228         if (value == 0) {
229             return "0";
230         }
231         uint256 temp = value;
232         uint256 digits;
233         while (temp != 0) {
234             digits++;
235             temp /= 10;
236         }
237         bytes memory buffer = new bytes(digits);
238         while (value != 0) {
239             digits -= 1;
240             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
241             value /= 10;
242         }
243         return string(buffer);
244     }
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
248      */
249     function toHexString(uint256 value) internal pure returns (string memory) {
250         if (value == 0) {
251             return "0x00";
252         }
253         uint256 temp = value;
254         uint256 length = 0;
255         while (temp != 0) {
256             length++;
257             temp >>= 8;
258         }
259         return toHexString(value, length);
260     }
261 
262     /**
263      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
264      */
265     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
266         bytes memory buffer = new bytes(2 * length + 2);
267         buffer[0] = "0";
268         buffer[1] = "x";
269         for (uint256 i = 2 * length + 1; i > 1; --i) {
270             buffer[i] = _HEX_SYMBOLS[value & 0xf];
271             value >>= 4;
272         }
273         require(value == 0, "Strings: hex length insufficient");
274         return string(buffer);
275     }
276 }
277 
278 // File: @openzeppelin/contracts/utils/Context.sol
279 
280 
281 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
282 
283 pragma solidity ^0.8.0;
284 
285 /**
286  * @dev Provides information about the current execution context, including the
287  * sender of the transaction and its data. While these are generally available
288  * via msg.sender and msg.data, they should not be accessed in such a direct
289  * manner, since when dealing with meta-transactions the account sending and
290  * paying for execution may not be the actual sender (as far as an application
291  * is concerned).
292  *
293  * This contract is only required for intermediate, library-like contracts.
294  */
295 abstract contract Context {
296     function _msgSender() internal view virtual returns (address) {
297         return msg.sender;
298     }
299 
300     function _msgData() internal view virtual returns (bytes calldata) {
301         return msg.data;
302     }
303 }
304 
305 // File: @openzeppelin/contracts/access/Ownable.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 
313 /**
314  * @dev Contract module which provides a basic access control mechanism, where
315  * there is an account (an owner) that can be granted exclusive access to
316  * specific functions.
317  *
318  * By default, the owner account will be the one that deploys the contract. This
319  * can later be changed with {transferOwnership}.
320  *
321  * This module is used through inheritance. It will make available the modifier
322  * `onlyOwner`, which can be applied to your functions to restrict their use to
323  * the owner.
324  */
325 abstract contract Ownable is Context {
326     address private _owner;
327 
328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329 
330     /**
331      * @dev Initializes the contract setting the deployer as the initial owner.
332      */
333     constructor() {
334         _transferOwnership(_msgSender());
335     }
336 
337     /**
338      * @dev Returns the address of the current owner.
339      */
340     function owner() public view virtual returns (address) {
341         return _owner;
342     }
343 
344     /**
345      * @dev Throws if called by any account other than the owner.
346      */
347     modifier onlyOwner() {
348         require(owner() == _msgSender(), "Ownable: caller is not the owner");
349         _;
350     }
351 
352     /**
353      * @dev Leaves the contract without owner. It will not be possible to call
354      * `onlyOwner` functions anymore. Can only be called by the current owner.
355      *
356      * NOTE: Renouncing ownership will leave the contract without an owner,
357      * thereby removing any functionality that is only available to the owner.
358      */
359     function renounceOwnership() public virtual onlyOwner {
360         _transferOwnership(address(0));
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public virtual onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         _transferOwnership(newOwner);
370     }
371 
372     /**
373      * @dev Transfers ownership of the contract to a new account (`newOwner`).
374      * Internal function without access restriction.
375      */
376     function _transferOwnership(address newOwner) internal virtual {
377         address oldOwner = _owner;
378         _owner = newOwner;
379         emit OwnershipTransferred(oldOwner, newOwner);
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/Address.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
387 
388 pragma solidity ^0.8.1;
389 
390 /**
391  * @dev Collection of functions related to the address type
392  */
393 library Address {
394     /**
395      * @dev Returns true if `account` is a contract.
396      *
397      * [IMPORTANT]
398      * ====
399      * It is unsafe to assume that an address for which this function returns
400      * false is an externally-owned account (EOA) and not a contract.
401      *
402      * Among others, `isContract` will return false for the following
403      * types of addresses:
404      *
405      *  - an externally-owned account
406      *  - a contract in construction
407      *  - an address where a contract will be created
408      *  - an address where a contract lived, but was destroyed
409      * ====
410      *
411      * [IMPORTANT]
412      * ====
413      * You shouldn't rely on `isContract` to protect against flash loan attacks!
414      *
415      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
416      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
417      * constructor.
418      * ====
419      */
420     function isContract(address account) internal view returns (bool) {
421         // This method relies on extcodesize/address.code.length, which returns 0
422         // for contracts in construction, since the code is only stored at the end
423         // of the constructor execution.
424 
425         return account.code.length > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         (bool success, ) = recipient.call{value: amount}("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain `call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, 0, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but also transferring `value` wei to `target`.
490      *
491      * Requirements:
492      *
493      * - the calling contract must have an ETH balance of at least `value`.
494      * - the called Solidity function must be `payable`.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(address(this).balance >= value, "Address: insufficient balance for call");
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
532         return functionStaticCall(target, data, "Address: low-level static call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal view returns (bytes memory) {
546         require(isContract(target), "Address: static call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.staticcall(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(isContract(target), "Address: delegate call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
581      * revert reason using the provided one.
582      *
583      * _Available since v4.3._
584      */
585     function verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) internal pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
609 
610 
611 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
612 
613 pragma solidity ^0.8.0;
614 
615 /**
616  * @title ERC721 token receiver interface
617  * @dev Interface for any contract that wants to support safeTransfers
618  * from ERC721 asset contracts.
619  */
620 interface IERC721Receiver {
621     /**
622      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
623      * by `operator` from `from`, this function is called.
624      *
625      * It must return its Solidity selector to confirm the token transfer.
626      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
627      *
628      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
629      */
630     function onERC721Received(
631         address operator,
632         address from,
633         uint256 tokenId,
634         bytes calldata data
635     ) external returns (bytes4);
636 }
637 
638 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Interface of the ERC165 standard, as defined in the
647  * https://eips.ethereum.org/EIPS/eip-165[EIP].
648  *
649  * Implementers can declare support of contract interfaces, which can then be
650  * queried by others ({ERC165Checker}).
651  *
652  * For an implementation, see {ERC165}.
653  */
654 interface IERC165 {
655     /**
656      * @dev Returns true if this contract implements the interface defined by
657      * `interfaceId`. See the corresponding
658      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
659      * to learn more about how these ids are created.
660      *
661      * This function call must use less than 30 000 gas.
662      */
663     function supportsInterface(bytes4 interfaceId) external view returns (bool);
664 }
665 
666 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Implementation of the {IERC165} interface.
676  *
677  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
678  * for the additional interface id that will be supported. For example:
679  *
680  * ```solidity
681  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
683  * }
684  * ```
685  *
686  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
687  */
688 abstract contract ERC165 is IERC165 {
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
693         return interfaceId == type(IERC165).interfaceId;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
698 
699 
700 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @dev Required interface of an ERC721 compliant contract.
707  */
708 interface IERC721 is IERC165 {
709     /**
710      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
711      */
712     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
713 
714     /**
715      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
716      */
717     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
718 
719     /**
720      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
721      */
722     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
723 
724     /**
725      * @dev Returns the number of tokens in ``owner``'s account.
726      */
727     function balanceOf(address owner) external view returns (uint256 balance);
728 
729     /**
730      * @dev Returns the owner of the `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function ownerOf(uint256 tokenId) external view returns (address owner);
737 
738     /**
739      * @dev Safely transfers `tokenId` token from `from` to `to`.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes calldata data
756     ) external;
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
760      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
761      *
762      * Requirements:
763      *
764      * - `from` cannot be the zero address.
765      * - `to` cannot be the zero address.
766      * - `tokenId` token must exist and be owned by `from`.
767      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
768      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
769      *
770      * Emits a {Transfer} event.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) external;
777 
778     /**
779      * @dev Transfers `tokenId` token from `from` to `to`.
780      *
781      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
782      *
783      * Requirements:
784      *
785      * - `from` cannot be the zero address.
786      * - `to` cannot be the zero address.
787      * - `tokenId` token must be owned by `from`.
788      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
789      *
790      * Emits a {Transfer} event.
791      */
792     function transferFrom(
793         address from,
794         address to,
795         uint256 tokenId
796     ) external;
797 
798     /**
799      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
800      * The approval is cleared when the token is transferred.
801      *
802      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
803      *
804      * Requirements:
805      *
806      * - The caller must own the token or be an approved operator.
807      * - `tokenId` must exist.
808      *
809      * Emits an {Approval} event.
810      */
811     function approve(address to, uint256 tokenId) external;
812 
813     /**
814      * @dev Approve or remove `operator` as an operator for the caller.
815      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
816      *
817      * Requirements:
818      *
819      * - The `operator` cannot be the caller.
820      *
821      * Emits an {ApprovalForAll} event.
822      */
823     function setApprovalForAll(address operator, bool _approved) external;
824 
825     /**
826      * @dev Returns the account approved for `tokenId` token.
827      *
828      * Requirements:
829      *
830      * - `tokenId` must exist.
831      */
832     function getApproved(uint256 tokenId) external view returns (address operator);
833 
834     /**
835      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
836      *
837      * See {setApprovalForAll}
838      */
839     function isApprovedForAll(address owner, address operator) external view returns (bool);
840 }
841 
842 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
843 
844 
845 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
846 
847 pragma solidity ^0.8.0;
848 
849 
850 /**
851  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
852  * @dev See https://eips.ethereum.org/EIPS/eip-721
853  */
854 interface IERC721Metadata is IERC721 {
855     /**
856      * @dev Returns the token collection name.
857      */
858     function name() external view returns (string memory);
859 
860     /**
861      * @dev Returns the token collection symbol.
862      */
863     function symbol() external view returns (string memory);
864 
865     /**
866      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
867      */
868     function tokenURI(uint256 tokenId) external view returns (string memory);
869 }
870 
871 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
872 
873 
874 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 
879 
880 
881 
882 
883 
884 
885 /**
886  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
887  * the Metadata extension, but not including the Enumerable extension, which is available separately as
888  * {ERC721Enumerable}.
889  */
890 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
891     using Address for address;
892     using Strings for uint256;
893 
894     // Token name
895     string private _name;
896 
897     // Token symbol
898     string private _symbol;
899 
900     // Mapping from token ID to owner address
901     mapping(uint256 => address) private _owners;
902 
903     // Mapping owner address to token count
904     mapping(address => uint256) private _balances;
905 
906     // Mapping from token ID to approved address
907     mapping(uint256 => address) private _tokenApprovals;
908 
909     // Mapping from owner to operator approvals
910     mapping(address => mapping(address => bool)) private _operatorApprovals;
911 
912     /**
913      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
914      */
915     constructor(string memory name_, string memory symbol_) {
916         _name = name_;
917         _symbol = symbol_;
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev See {IERC721-balanceOf}.
932      */
933     function balanceOf(address owner) public view virtual override returns (uint256) {
934         require(owner != address(0), "ERC721: balance query for the zero address");
935         return _balances[owner];
936     }
937 
938     /**
939      * @dev See {IERC721-ownerOf}.
940      */
941     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
942         address owner = _owners[tokenId];
943         require(owner != address(0), "ERC721: owner query for nonexistent token");
944         return owner;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-name}.
949      */
950     function name() public view virtual override returns (string memory) {
951         return _name;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-symbol}.
956      */
957     function symbol() public view virtual override returns (string memory) {
958         return _symbol;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-tokenURI}.
963      */
964     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
965         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
966 
967         string memory baseURI = _baseURI();
968         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
969     }
970 
971     /**
972      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
973      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
974      * by default, can be overridden in child contracts.
975      */
976     function _baseURI() internal view virtual returns (string memory) {
977         return "";
978     }
979 
980     /**
981      * @dev See {IERC721-approve}.
982      */
983     function approve(address to, uint256 tokenId) public virtual override {
984         address owner = ERC721.ownerOf(tokenId);
985         require(to != owner, "ERC721: approval to current owner");
986 
987         require(
988             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
989             "ERC721: approve caller is not owner nor approved for all"
990         );
991 
992         _approve(to, tokenId);
993     }
994 
995     /**
996      * @dev See {IERC721-getApproved}.
997      */
998     function getApproved(uint256 tokenId) public view virtual override returns (address) {
999         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1000 
1001         return _tokenApprovals[tokenId];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-setApprovalForAll}.
1006      */
1007     function setApprovalForAll(address operator, bool approved) public virtual override {
1008         _setApprovalForAll(_msgSender(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public virtual override {
1026         //solhint-disable-next-line max-line-length
1027         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1028 
1029         _transfer(from, to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         safeTransferFrom(from, to, tokenId, "");
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) public virtual override {
1052         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1053         _safeTransfer(from, to, tokenId, _data);
1054     }
1055 
1056     /**
1057      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1058      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1059      *
1060      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1061      *
1062      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1063      * implement alternative mechanisms to perform token transfer, such as signature-based.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must exist and be owned by `from`.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _safeTransfer(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) internal virtual {
1080         _transfer(from, to, tokenId);
1081         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1082     }
1083 
1084     /**
1085      * @dev Returns whether `tokenId` exists.
1086      *
1087      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1088      *
1089      * Tokens start existing when they are minted (`_mint`),
1090      * and stop existing when they are burned (`_burn`).
1091      */
1092     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1093         return _owners[tokenId] != address(0);
1094     }
1095 
1096     /**
1097      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      */
1103     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1104         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1105         address owner = ERC721.ownerOf(tokenId);
1106         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1107     }
1108 
1109     /**
1110      * @dev Safely mints `tokenId` and transfers it to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must not exist.
1115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _safeMint(address to, uint256 tokenId) internal virtual {
1120         _safeMint(to, tokenId, "");
1121     }
1122 
1123     /**
1124      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1125      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1126      */
1127     function _safeMint(
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) internal virtual {
1132         _mint(to, tokenId);
1133         require(
1134             _checkOnERC721Received(address(0), to, tokenId, _data),
1135             "ERC721: transfer to non ERC721Receiver implementer"
1136         );
1137     }
1138 
1139     /**
1140      * @dev Mints `tokenId` and transfers it to `to`.
1141      *
1142      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1143      *
1144      * Requirements:
1145      *
1146      * - `tokenId` must not exist.
1147      * - `to` cannot be the zero address.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function _mint(address to, uint256 tokenId) internal virtual {
1152         require(to != address(0), "ERC721: mint to the zero address");
1153         require(!_exists(tokenId), "ERC721: token already minted");
1154 
1155         _beforeTokenTransfer(address(0), to, tokenId);
1156 
1157         _balances[to] += 1;
1158         _owners[tokenId] = to;
1159 
1160         emit Transfer(address(0), to, tokenId);
1161 
1162         _afterTokenTransfer(address(0), to, tokenId);
1163     }
1164 
1165     /**
1166      * @dev Destroys `tokenId`.
1167      * The approval is cleared when the token is burned.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _burn(uint256 tokenId) internal virtual {
1176         address owner = ERC721.ownerOf(tokenId);
1177 
1178         _beforeTokenTransfer(owner, address(0), tokenId);
1179 
1180         // Clear approvals
1181         _approve(address(0), tokenId);
1182 
1183         _balances[owner] -= 1;
1184         delete _owners[tokenId];
1185 
1186         emit Transfer(owner, address(0), tokenId);
1187 
1188         _afterTokenTransfer(owner, address(0), tokenId);
1189     }
1190 
1191     /**
1192      * @dev Transfers `tokenId` from `from` to `to`.
1193      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1194      *
1195      * Requirements:
1196      *
1197      * - `to` cannot be the zero address.
1198      * - `tokenId` token must be owned by `from`.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _transfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) internal virtual {
1207         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1208         require(to != address(0), "ERC721: transfer to the zero address");
1209 
1210         _beforeTokenTransfer(from, to, tokenId);
1211 
1212         // Clear approvals from the previous owner
1213         _approve(address(0), tokenId);
1214 
1215         _balances[from] -= 1;
1216         _balances[to] += 1;
1217         _owners[tokenId] = to;
1218 
1219         emit Transfer(from, to, tokenId);
1220 
1221         _afterTokenTransfer(from, to, tokenId);
1222     }
1223 
1224     /**
1225      * @dev Approve `to` to operate on `tokenId`
1226      *
1227      * Emits a {Approval} event.
1228      */
1229     function _approve(address to, uint256 tokenId) internal virtual {
1230         _tokenApprovals[tokenId] = to;
1231         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Approve `operator` to operate on all of `owner` tokens
1236      *
1237      * Emits a {ApprovalForAll} event.
1238      */
1239     function _setApprovalForAll(
1240         address owner,
1241         address operator,
1242         bool approved
1243     ) internal virtual {
1244         require(owner != operator, "ERC721: approve to caller");
1245         _operatorApprovals[owner][operator] = approved;
1246         emit ApprovalForAll(owner, operator, approved);
1247     }
1248 
1249     /**
1250      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1251      * The call is not executed if the target address is not a contract.
1252      *
1253      * @param from address representing the previous owner of the given token ID
1254      * @param to target address that will receive the tokens
1255      * @param tokenId uint256 ID of the token to be transferred
1256      * @param _data bytes optional data to send along with the call
1257      * @return bool whether the call correctly returned the expected magic value
1258      */
1259     function _checkOnERC721Received(
1260         address from,
1261         address to,
1262         uint256 tokenId,
1263         bytes memory _data
1264     ) private returns (bool) {
1265         if (to.isContract()) {
1266             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1267                 return retval == IERC721Receiver.onERC721Received.selector;
1268             } catch (bytes memory reason) {
1269                 if (reason.length == 0) {
1270                     revert("ERC721: transfer to non ERC721Receiver implementer");
1271                 } else {
1272                     assembly {
1273                         revert(add(32, reason), mload(reason))
1274                     }
1275                 }
1276             }
1277         } else {
1278             return true;
1279         }
1280     }
1281 
1282     /**
1283      * @dev Hook that is called before any token transfer. This includes minting
1284      * and burning.
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1292      * - `from` and `to` are never both zero.
1293      *
1294      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1295      */
1296     function _beforeTokenTransfer(
1297         address from,
1298         address to,
1299         uint256 tokenId
1300     ) internal virtual {}
1301 
1302     /**
1303      * @dev Hook that is called after any transfer of tokens. This includes
1304      * minting and burning.
1305      *
1306      * Calling conditions:
1307      *
1308      * - when `from` and `to` are both non-zero.
1309      * - `from` and `to` are never both zero.
1310      *
1311      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1312      */
1313     function _afterTokenTransfer(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) internal virtual {}
1318 }
1319 
1320 // File: contracts/catbloxpuma.sol
1321 
1322 //SPDX-License-Identifier: Unlicense
1323 pragma solidity ^0.8.0;
1324 
1325 
1326 
1327 
1328 
1329 
1330 contract CatBloxPUMACapsule is ERC721, Ownable {
1331     using Counters for Counters.Counter;
1332     using Strings for uint256;
1333 
1334     Counters.Counter private tokenCounter;
1335 
1336     string public baseURI;
1337     string public provenanceHash;
1338     bool public isClaimingActive;
1339     bytes32 public claimListMerkleRoot;
1340     uint256 public price = 0.2 ether;
1341 
1342     uint256 public immutable maxPumas;
1343 
1344     mapping(address => uint256) public claimListMintCounts;
1345 
1346     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1347 
1348     modifier claimListActive() {
1349         require(isClaimingActive, "Claim list not active");
1350         _;
1351     }
1352 
1353     modifier totalNotExceeded(uint256 numberOfTokens) {
1354         require(
1355             tokenCounter.current() + numberOfTokens <= maxPumas,
1356             "Not enough pumas remaining to claim"
1357         );
1358         _;
1359     }
1360 
1361     modifier isValidMerkleProof(
1362         bytes32[] calldata merkleProof,
1363         bytes32 root,
1364         uint256 maxClaimable
1365     ) {
1366         require(
1367             MerkleProof.verify(
1368                 merkleProof,
1369                 root,
1370                 keccak256(abi.encodePacked(msg.sender, maxClaimable))
1371             ),
1372             "Proof does not exist in tree"
1373         );
1374         _;
1375     }
1376 
1377     modifier isCorrectPayment(uint256 numberOfTokens) {
1378         require(
1379             price * numberOfTokens == msg.value,
1380             "Incorrect ETH value sent"
1381         );
1382         _;
1383     }
1384 
1385     constructor(string memory defaultBaseURI, uint256 _maxPumas)
1386         ERC721("CatBloxPUMACapsule", "CBLXPUMA")
1387     {
1388         baseURI = defaultBaseURI;
1389         maxPumas = _maxPumas;
1390     }
1391 
1392     // ============ PUBLIC FUNCTION FOR CLAIMING ============
1393 
1394     function claim(
1395         uint256 numberOfTokens,
1396         uint256 maxClaimable,
1397         bytes32[] calldata merkleProof
1398     )
1399         external
1400         payable
1401         claimListActive
1402         totalNotExceeded(numberOfTokens)
1403         isValidMerkleProof(merkleProof, claimListMerkleRoot, maxClaimable)
1404         isCorrectPayment(numberOfTokens)
1405     {
1406         uint256 numAlreadyMinted = claimListMintCounts[msg.sender];
1407         require(
1408             numAlreadyMinted + numberOfTokens <= maxClaimable,
1409             "Exceeds max claimable"
1410         );
1411         claimListMintCounts[msg.sender] = numAlreadyMinted + numberOfTokens;
1412 
1413         for (uint256 i = 0; i < numberOfTokens; i++) {
1414             _safeMint(msg.sender, nextTokenId());
1415         }
1416     }
1417 
1418     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1419 
1420     function totalSupply() external view returns (uint256) {
1421         return tokenCounter.current();
1422     }
1423 
1424     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1425 
1426     function setBaseURI(string memory newBaseURI) external onlyOwner {
1427         baseURI = newBaseURI;
1428     }
1429 
1430     function setProvenanceHash(string memory _hash) external onlyOwner {
1431         provenanceHash = _hash;
1432     }
1433 
1434     // Toggle Claiming Active / Inactive
1435 
1436     function setClaimingActive(bool _isClaimingActive) external onlyOwner {
1437         isClaimingActive = _isClaimingActive;
1438     }
1439 
1440     // Set Merkle Roots
1441 
1442     function setClaimListMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1443         claimListMerkleRoot = _merkleRoot;
1444     }
1445 
1446     // Set Price
1447 
1448     function setPrice(uint256 _price) external onlyOwner {
1449         price = _price;
1450     }
1451 
1452     // ============ SUPPORTING FUNCTIONS ============
1453 
1454     function nextTokenId() private returns (uint256) {
1455         tokenCounter.increment();
1456         return tokenCounter.current();
1457     }
1458 
1459     // ============ OVERRIDES ============
1460     function _baseURI() internal view override returns (string memory) {
1461         return baseURI;
1462     }
1463 
1464     // Withdrawal
1465     function withdraw() public onlyOwner {
1466         uint256 balance = address(this).balance;
1467         payable(msg.sender).transfer(balance);
1468     }
1469 
1470     function withdrawTokens(IERC20 token) public onlyOwner {
1471         uint256 balance = token.balanceOf(address(this));
1472         token.transfer(msg.sender, balance);
1473     }
1474 }