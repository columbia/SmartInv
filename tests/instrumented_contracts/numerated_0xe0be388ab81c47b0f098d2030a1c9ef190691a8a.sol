1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
66 
67 
68 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Interface of the ERC20 standard as defined in the EIP.
74  */
75 interface IERC20 {
76     /**
77      * @dev Returns the amount of tokens in existence.
78      */
79     function totalSupply() external view returns (uint256);
80 
81     /**
82      * @dev Returns the amount of tokens owned by `account`.
83      */
84     function balanceOf(address account) external view returns (uint256);
85 
86     /**
87      * @dev Moves `amount` tokens from the caller's account to `to`.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transfer(address to, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Returns the remaining number of tokens that `spender` will be
97      * allowed to spend on behalf of `owner` through {transferFrom}. This is
98      * zero by default.
99      *
100      * This value changes when {approve} or {transferFrom} are called.
101      */
102     function allowance(address owner, address spender) external view returns (uint256);
103 
104     /**
105      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * IMPORTANT: Beware that changing an allowance with this method brings the risk
110      * that someone may use both the old and the new allowance by unfortunate
111      * transaction ordering. One possible solution to mitigate this race
112      * condition is to first reduce the spender's allowance to 0 and set the
113      * desired value afterwards:
114      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
115      *
116      * Emits an {Approval} event.
117      */
118     function approve(address spender, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Moves `amount` tokens from `from` to `to` using the
122      * allowance mechanism. `amount` is then deducted from the caller's
123      * allowance.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transferFrom(
130         address from,
131         address to,
132         uint256 amount
133     ) external returns (bool);
134 
135     /**
136      * @dev Emitted when `value` tokens are moved from one account (`from`) to
137      * another (`to`).
138      *
139      * Note that `value` may be zero.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     /**
144      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
145      * a call to {approve}. `value` is the new allowance.
146      */
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 // File: @openzeppelin/contracts/interfaces/IERC20.sol
151 
152 
153 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
154 
155 pragma solidity ^0.8.0;
156 
157 
158 // File: @openzeppelin/contracts/utils/Strings.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
173      */
174     function toString(uint256 value) internal pure returns (string memory) {
175         // Inspired by OraclizeAPI's implementation - MIT licence
176         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
177 
178         if (value == 0) {
179             return "0";
180         }
181         uint256 temp = value;
182         uint256 digits;
183         while (temp != 0) {
184             digits++;
185             temp /= 10;
186         }
187         bytes memory buffer = new bytes(digits);
188         while (value != 0) {
189             digits -= 1;
190             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
191             value /= 10;
192         }
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
198      */
199     function toHexString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0x00";
202         }
203         uint256 temp = value;
204         uint256 length = 0;
205         while (temp != 0) {
206             length++;
207             temp >>= 8;
208         }
209         return toHexString(value, length);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
214      */
215     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
216         bytes memory buffer = new bytes(2 * length + 2);
217         buffer[0] = "0";
218         buffer[1] = "x";
219         for (uint256 i = 2 * length + 1; i > 1; --i) {
220             buffer[i] = _HEX_SYMBOLS[value & 0xf];
221             value >>= 4;
222         }
223         require(value == 0, "Strings: hex length insufficient");
224         return string(buffer);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/Context.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _transferOwnership(_msgSender());
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view virtual returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(owner() == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         _transferOwnership(address(0));
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         _transferOwnership(newOwner);
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      * Internal function without access restriction.
325      */
326     function _transferOwnership(address newOwner) internal virtual {
327         address oldOwner = _owner;
328         _owner = newOwner;
329         emit OwnershipTransferred(oldOwner, newOwner);
330     }
331 }
332 
333 // File: @openzeppelin/contracts/utils/Address.sol
334 
335 
336 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
337 
338 pragma solidity ^0.8.1;
339 
340 /**
341  * @dev Collection of functions related to the address type
342  */
343 library Address {
344     /**
345      * @dev Returns true if `account` is a contract.
346      *
347      * [IMPORTANT]
348      * ====
349      * It is unsafe to assume that an address for which this function returns
350      * false is an externally-owned account (EOA) and not a contract.
351      *
352      * Among others, `isContract` will return false for the following
353      * types of addresses:
354      *
355      *  - an externally-owned account
356      *  - a contract in construction
357      *  - an address where a contract will be created
358      *  - an address where a contract lived, but was destroyed
359      * ====
360      *
361      * [IMPORTANT]
362      * ====
363      * You shouldn't rely on `isContract` to protect against flash loan attacks!
364      *
365      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
366      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
367      * constructor.
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies on extcodesize/address.code.length, which returns 0
372         // for contracts in construction, since the code is only stored at the end
373         // of the constructor execution.
374 
375         return account.code.length > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         (bool success, ) = recipient.call{value: amount}("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain `call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420         return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(
430         address target,
431         bytes memory data,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         return functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value
452     ) internal returns (bytes memory) {
453         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
458      * with `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCallWithValue(
463         address target,
464         bytes memory data,
465         uint256 value,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         require(address(this).balance >= value, "Address: insufficient balance for call");
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
482         return functionStaticCall(target, data, "Address: low-level static call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.delegatecall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
531      * revert reason using the provided one.
532      *
533      * _Available since v4.3._
534      */
535     function verifyCallResult(
536         bool success,
537         bytes memory returndata,
538         string memory errorMessage
539     ) internal pure returns (bytes memory) {
540         if (success) {
541             return returndata;
542         } else {
543             // Look for revert reason and bubble it up if present
544             if (returndata.length > 0) {
545                 // The easiest way to bubble the revert reason is using memory via assembly
546 
547                 assembly {
548                     let returndata_size := mload(returndata)
549                     revert(add(32, returndata), returndata_size)
550                 }
551             } else {
552                 revert(errorMessage);
553             }
554         }
555     }
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 /**
566  * @title ERC721 token receiver interface
567  * @dev Interface for any contract that wants to support safeTransfers
568  * from ERC721 asset contracts.
569  */
570 interface IERC721Receiver {
571     /**
572      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
573      * by `operator` from `from`, this function is called.
574      *
575      * It must return its Solidity selector to confirm the token transfer.
576      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
577      *
578      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
579      */
580     function onERC721Received(
581         address operator,
582         address from,
583         uint256 tokenId,
584         bytes calldata data
585     ) external returns (bytes4);
586 }
587 
588 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev Interface of the ERC165 standard, as defined in the
597  * https://eips.ethereum.org/EIPS/eip-165[EIP].
598  *
599  * Implementers can declare support of contract interfaces, which can then be
600  * queried by others ({ERC165Checker}).
601  *
602  * For an implementation, see {ERC165}.
603  */
604 interface IERC165 {
605     /**
606      * @dev Returns true if this contract implements the interface defined by
607      * `interfaceId`. See the corresponding
608      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
609      * to learn more about how these ids are created.
610      *
611      * This function call must use less than 30 000 gas.
612      */
613     function supportsInterface(bytes4 interfaceId) external view returns (bool);
614 }
615 
616 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev Implementation of the {IERC165} interface.
626  *
627  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
628  * for the additional interface id that will be supported. For example:
629  *
630  * ```solidity
631  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
632  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
633  * }
634  * ```
635  *
636  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
637  */
638 abstract contract ERC165 is IERC165 {
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
643         return interfaceId == type(IERC165).interfaceId;
644     }
645 }
646 
647 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 
655 /**
656  * @dev Required interface of an ERC721 compliant contract.
657  */
658 interface IERC721 is IERC165 {
659     /**
660      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
661      */
662     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
663 
664     /**
665      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
666      */
667     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
668 
669     /**
670      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
671      */
672     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
673 
674     /**
675      * @dev Returns the number of tokens in ``owner``'s account.
676      */
677     function balanceOf(address owner) external view returns (uint256 balance);
678 
679     /**
680      * @dev Returns the owner of the `tokenId` token.
681      *
682      * Requirements:
683      *
684      * - `tokenId` must exist.
685      */
686     function ownerOf(uint256 tokenId) external view returns (address owner);
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
690      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
691      *
692      * Requirements:
693      *
694      * - `from` cannot be the zero address.
695      * - `to` cannot be the zero address.
696      * - `tokenId` token must exist and be owned by `from`.
697      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
698      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
699      *
700      * Emits a {Transfer} event.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external;
707 
708     /**
709      * @dev Transfers `tokenId` token from `from` to `to`.
710      *
711      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must be owned by `from`.
718      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
719      *
720      * Emits a {Transfer} event.
721      */
722     function transferFrom(
723         address from,
724         address to,
725         uint256 tokenId
726     ) external;
727 
728     /**
729      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
730      * The approval is cleared when the token is transferred.
731      *
732      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
733      *
734      * Requirements:
735      *
736      * - The caller must own the token or be an approved operator.
737      * - `tokenId` must exist.
738      *
739      * Emits an {Approval} event.
740      */
741     function approve(address to, uint256 tokenId) external;
742 
743     /**
744      * @dev Returns the account approved for `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function getApproved(uint256 tokenId) external view returns (address operator);
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool _approved) external;
763 
764     /**
765      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
766      *
767      * See {setApprovalForAll}
768      */
769     function isApprovedForAll(address owner, address operator) external view returns (bool);
770 
771     /**
772      * @dev Safely transfers `tokenId` token from `from` to `to`.
773      *
774      * Requirements:
775      *
776      * - `from` cannot be the zero address.
777      * - `to` cannot be the zero address.
778      * - `tokenId` token must exist and be owned by `from`.
779      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function safeTransferFrom(
785         address from,
786         address to,
787         uint256 tokenId,
788         bytes calldata data
789     ) external;
790 }
791 
792 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
793 
794 
795 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
796 
797 pragma solidity ^0.8.0;
798 
799 
800 /**
801  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
802  * @dev See https://eips.ethereum.org/EIPS/eip-721
803  */
804 interface IERC721Enumerable is IERC721 {
805     /**
806      * @dev Returns the total amount of tokens stored by the contract.
807      */
808     function totalSupply() external view returns (uint256);
809 
810     /**
811      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
812      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
813      */
814     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
815 
816     /**
817      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
818      * Use along with {totalSupply} to enumerate all tokens.
819      */
820     function tokenByIndex(uint256 index) external view returns (uint256);
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
824 
825 
826 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
833  * @dev See https://eips.ethereum.org/EIPS/eip-721
834  */
835 interface IERC721Metadata is IERC721 {
836     /**
837      * @dev Returns the token collection name.
838      */
839     function name() external view returns (string memory);
840 
841     /**
842      * @dev Returns the token collection symbol.
843      */
844     function symbol() external view returns (string memory);
845 
846     /**
847      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
848      */
849     function tokenURI(uint256 tokenId) external view returns (string memory);
850 }
851 
852 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
853 
854 
855 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 
860 
861 
862 
863 
864 
865 
866 /**
867  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
868  * the Metadata extension, but not including the Enumerable extension, which is available separately as
869  * {ERC721Enumerable}.
870  */
871 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
872     using Address for address;
873     using Strings for uint256;
874 
875     // Token name
876     string private _name;
877 
878     // Token symbol
879     string private _symbol;
880 
881     // Mapping from token ID to owner address
882     mapping(uint256 => address) private _owners;
883 
884     // Mapping owner address to token count
885     mapping(address => uint256) private _balances;
886 
887     // Mapping from token ID to approved address
888     mapping(uint256 => address) private _tokenApprovals;
889 
890     // Mapping from owner to operator approvals
891     mapping(address => mapping(address => bool)) private _operatorApprovals;
892 
893     /**
894      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
895      */
896     constructor(string memory name_, string memory symbol_) {
897         _name = name_;
898         _symbol = symbol_;
899     }
900 
901     /**
902      * @dev See {IERC165-supportsInterface}.
903      */
904     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
905         return
906             interfaceId == type(IERC721).interfaceId ||
907             interfaceId == type(IERC721Metadata).interfaceId ||
908             super.supportsInterface(interfaceId);
909     }
910 
911     /**
912      * @dev See {IERC721-balanceOf}.
913      */
914     function balanceOf(address owner) public view virtual override returns (uint256) {
915         require(owner != address(0), "ERC721: balance query for the zero address");
916         return _balances[owner];
917     }
918 
919     /**
920      * @dev See {IERC721-ownerOf}.
921      */
922     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
923         address owner = _owners[tokenId];
924         require(owner != address(0), "ERC721: owner query for nonexistent token");
925         return owner;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-name}.
930      */
931     function name() public view virtual override returns (string memory) {
932         return _name;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-symbol}.
937      */
938     function symbol() public view virtual override returns (string memory) {
939         return _symbol;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-tokenURI}.
944      */
945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
946         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
947 
948         string memory baseURI = _baseURI();
949         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
950     }
951 
952     /**
953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
955      * by default, can be overriden in child contracts.
956      */
957     function _baseURI() internal view virtual returns (string memory) {
958         return "";
959     }
960 
961     /**
962      * @dev See {IERC721-approve}.
963      */
964     function approve(address to, uint256 tokenId) public virtual override {
965         address owner = ERC721.ownerOf(tokenId);
966         require(to != owner, "ERC721: approval to current owner");
967 
968         require(
969             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
970             "ERC721: approve caller is not owner nor approved for all"
971         );
972 
973         _approve(to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-getApproved}.
978      */
979     function getApproved(uint256 tokenId) public view virtual override returns (address) {
980         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
981 
982         return _tokenApprovals[tokenId];
983     }
984 
985     /**
986      * @dev See {IERC721-setApprovalForAll}.
987      */
988     function setApprovalForAll(address operator, bool approved) public virtual override {
989         _setApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
996         return _operatorApprovals[owner][operator];
997     }
998 
999     /**
1000      * @dev See {IERC721-transferFrom}.
1001      */
1002     function transferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         //solhint-disable-next-line max-line-length
1008         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1009 
1010         _transfer(from, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-safeTransferFrom}.
1015      */
1016     function safeTransferFrom(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) public virtual override {
1021         safeTransferFrom(from, to, tokenId, "");
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-safeTransferFrom}.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) public virtual override {
1033         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1034         _safeTransfer(from, to, tokenId, _data);
1035     }
1036 
1037     /**
1038      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1039      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1040      *
1041      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1042      *
1043      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1044      * implement alternative mechanisms to perform token transfer, such as signature-based.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must exist and be owned by `from`.
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeTransfer(
1056         address from,
1057         address to,
1058         uint256 tokenId,
1059         bytes memory _data
1060     ) internal virtual {
1061         _transfer(from, to, tokenId);
1062         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1063     }
1064 
1065     /**
1066      * @dev Returns whether `tokenId` exists.
1067      *
1068      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1069      *
1070      * Tokens start existing when they are minted (`_mint`),
1071      * and stop existing when they are burned (`_burn`).
1072      */
1073     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1074         return _owners[tokenId] != address(0);
1075     }
1076 
1077     /**
1078      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must exist.
1083      */
1084     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1085         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1086         address owner = ERC721.ownerOf(tokenId);
1087         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1088     }
1089 
1090     /**
1091      * @dev Safely mints `tokenId` and transfers it to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must not exist.
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function _safeMint(address to, uint256 tokenId) internal virtual {
1101         _safeMint(to, tokenId, "");
1102     }
1103 
1104     /**
1105      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1106      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1107      */
1108     function _safeMint(
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) internal virtual {
1113         _mint(to, tokenId);
1114         require(
1115             _checkOnERC721Received(address(0), to, tokenId, _data),
1116             "ERC721: transfer to non ERC721Receiver implementer"
1117         );
1118     }
1119 
1120     /**
1121      * @dev Mints `tokenId` and transfers it to `to`.
1122      *
1123      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must not exist.
1128      * - `to` cannot be the zero address.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _mint(address to, uint256 tokenId) internal virtual {
1133         require(to != address(0), "ERC721: mint to the zero address");
1134         require(!_exists(tokenId), "ERC721: token already minted");
1135 
1136         _beforeTokenTransfer(address(0), to, tokenId);
1137 
1138         _balances[to] += 1;
1139         _owners[tokenId] = to;
1140 
1141         emit Transfer(address(0), to, tokenId);
1142 
1143         _afterTokenTransfer(address(0), to, tokenId);
1144     }
1145 
1146     /**
1147      * @dev Destroys `tokenId`.
1148      * The approval is cleared when the token is burned.
1149      *
1150      * Requirements:
1151      *
1152      * - `tokenId` must exist.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _burn(uint256 tokenId) internal virtual {
1157         address owner = ERC721.ownerOf(tokenId);
1158 
1159         _beforeTokenTransfer(owner, address(0), tokenId);
1160 
1161         // Clear approvals
1162         _approve(address(0), tokenId);
1163 
1164         _balances[owner] -= 1;
1165         delete _owners[tokenId];
1166 
1167         emit Transfer(owner, address(0), tokenId);
1168 
1169         _afterTokenTransfer(owner, address(0), tokenId);
1170     }
1171 
1172     /**
1173      * @dev Transfers `tokenId` from `from` to `to`.
1174      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {
1188         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1189         require(to != address(0), "ERC721: transfer to the zero address");
1190 
1191         _beforeTokenTransfer(from, to, tokenId);
1192 
1193         // Clear approvals from the previous owner
1194         _approve(address(0), tokenId);
1195 
1196         _balances[from] -= 1;
1197         _balances[to] += 1;
1198         _owners[tokenId] = to;
1199 
1200         emit Transfer(from, to, tokenId);
1201 
1202         _afterTokenTransfer(from, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev Approve `to` to operate on `tokenId`
1207      *
1208      * Emits a {Approval} event.
1209      */
1210     function _approve(address to, uint256 tokenId) internal virtual {
1211         _tokenApprovals[tokenId] = to;
1212         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1213     }
1214 
1215     /**
1216      * @dev Approve `operator` to operate on all of `owner` tokens
1217      *
1218      * Emits a {ApprovalForAll} event.
1219      */
1220     function _setApprovalForAll(
1221         address owner,
1222         address operator,
1223         bool approved
1224     ) internal virtual {
1225         require(owner != operator, "ERC721: approve to caller");
1226         _operatorApprovals[owner][operator] = approved;
1227         emit ApprovalForAll(owner, operator, approved);
1228     }
1229 
1230     /**
1231      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1232      * The call is not executed if the target address is not a contract.
1233      *
1234      * @param from address representing the previous owner of the given token ID
1235      * @param to target address that will receive the tokens
1236      * @param tokenId uint256 ID of the token to be transferred
1237      * @param _data bytes optional data to send along with the call
1238      * @return bool whether the call correctly returned the expected magic value
1239      */
1240     function _checkOnERC721Received(
1241         address from,
1242         address to,
1243         uint256 tokenId,
1244         bytes memory _data
1245     ) private returns (bool) {
1246         if (to.isContract()) {
1247             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1248                 return retval == IERC721Receiver.onERC721Received.selector;
1249             } catch (bytes memory reason) {
1250                 if (reason.length == 0) {
1251                     revert("ERC721: transfer to non ERC721Receiver implementer");
1252                 } else {
1253                     assembly {
1254                         revert(add(32, reason), mload(reason))
1255                     }
1256                 }
1257             }
1258         } else {
1259             return true;
1260         }
1261     }
1262 
1263     /**
1264      * @dev Hook that is called before any token transfer. This includes minting
1265      * and burning.
1266      *
1267      * Calling conditions:
1268      *
1269      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1270      * transferred to `to`.
1271      * - When `from` is zero, `tokenId` will be minted for `to`.
1272      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1273      * - `from` and `to` are never both zero.
1274      *
1275      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1276      */
1277     function _beforeTokenTransfer(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Hook that is called after any transfer of tokens. This includes
1285      * minting and burning.
1286      *
1287      * Calling conditions:
1288      *
1289      * - when `from` and `to` are both non-zero.
1290      * - `from` and `to` are never both zero.
1291      *
1292      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1293      */
1294     function _afterTokenTransfer(
1295         address from,
1296         address to,
1297         uint256 tokenId
1298     ) internal virtual {}
1299 }
1300 
1301 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1302 
1303 
1304 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1305 
1306 pragma solidity ^0.8.0;
1307 
1308 
1309 
1310 /**
1311  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1312  * enumerability of all the token ids in the contract as well as all token ids owned by each
1313  * account.
1314  */
1315 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1316     // Mapping from owner to list of owned token IDs
1317     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1318 
1319     // Mapping from token ID to index of the owner tokens list
1320     mapping(uint256 => uint256) private _ownedTokensIndex;
1321 
1322     // Array with all token ids, used for enumeration
1323     uint256[] private _allTokens;
1324 
1325     // Mapping from token id to position in the allTokens array
1326     mapping(uint256 => uint256) private _allTokensIndex;
1327 
1328     /**
1329      * @dev See {IERC165-supportsInterface}.
1330      */
1331     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1332         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1333     }
1334 
1335     /**
1336      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1337      */
1338     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1339         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1340         return _ownedTokens[owner][index];
1341     }
1342 
1343     /**
1344      * @dev See {IERC721Enumerable-totalSupply}.
1345      */
1346     function totalSupply() public view virtual override returns (uint256) {
1347         return _allTokens.length;
1348     }
1349 
1350     /**
1351      * @dev See {IERC721Enumerable-tokenByIndex}.
1352      */
1353     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1354         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1355         return _allTokens[index];
1356     }
1357 
1358     /**
1359      * @dev Hook that is called before any token transfer. This includes minting
1360      * and burning.
1361      *
1362      * Calling conditions:
1363      *
1364      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1365      * transferred to `to`.
1366      * - When `from` is zero, `tokenId` will be minted for `to`.
1367      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1368      * - `from` cannot be the zero address.
1369      * - `to` cannot be the zero address.
1370      *
1371      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1372      */
1373     function _beforeTokenTransfer(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) internal virtual override {
1378         super._beforeTokenTransfer(from, to, tokenId);
1379 
1380         if (from == address(0)) {
1381             _addTokenToAllTokensEnumeration(tokenId);
1382         } else if (from != to) {
1383             _removeTokenFromOwnerEnumeration(from, tokenId);
1384         }
1385         if (to == address(0)) {
1386             _removeTokenFromAllTokensEnumeration(tokenId);
1387         } else if (to != from) {
1388             _addTokenToOwnerEnumeration(to, tokenId);
1389         }
1390     }
1391 
1392     /**
1393      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1394      * @param to address representing the new owner of the given token ID
1395      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1396      */
1397     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1398         uint256 length = ERC721.balanceOf(to);
1399         _ownedTokens[to][length] = tokenId;
1400         _ownedTokensIndex[tokenId] = length;
1401     }
1402 
1403     /**
1404      * @dev Private function to add a token to this extension's token tracking data structures.
1405      * @param tokenId uint256 ID of the token to be added to the tokens list
1406      */
1407     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1408         _allTokensIndex[tokenId] = _allTokens.length;
1409         _allTokens.push(tokenId);
1410     }
1411 
1412     /**
1413      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1414      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1415      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1416      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1417      * @param from address representing the previous owner of the given token ID
1418      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1419      */
1420     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1421         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1422         // then delete the last slot (swap and pop).
1423 
1424         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1425         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1426 
1427         // When the token to delete is the last token, the swap operation is unnecessary
1428         if (tokenIndex != lastTokenIndex) {
1429             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1430 
1431             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1432             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1433         }
1434 
1435         // This also deletes the contents at the last position of the array
1436         delete _ownedTokensIndex[tokenId];
1437         delete _ownedTokens[from][lastTokenIndex];
1438     }
1439 
1440     /**
1441      * @dev Private function to remove a token from this extension's token tracking data structures.
1442      * This has O(1) time complexity, but alters the order of the _allTokens array.
1443      * @param tokenId uint256 ID of the token to be removed from the tokens list
1444      */
1445     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1446         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1447         // then delete the last slot (swap and pop).
1448 
1449         uint256 lastTokenIndex = _allTokens.length - 1;
1450         uint256 tokenIndex = _allTokensIndex[tokenId];
1451 
1452         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1453         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1454         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1455         uint256 lastTokenId = _allTokens[lastTokenIndex];
1456 
1457         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1458         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1459 
1460         // This also deletes the contents at the last position of the array
1461         delete _allTokensIndex[tokenId];
1462         _allTokens.pop();
1463     }
1464 }
1465 
1466 // File: contracts/ERC721A.sol
1467 
1468 
1469 
1470 
1471 
1472 
1473 
1474 pragma solidity ^0.8.0;
1475 
1476 
1477 /**
1478  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1479  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1480  *
1481  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1482  *
1483  * Does not support burning tokens to address(0).
1484  *
1485  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
1486  */
1487 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1488     using Address for address;
1489     using Strings for uint256;
1490 
1491     struct TokenOwnership {
1492         address addr;
1493         uint64 startTimestamp;
1494     }
1495 
1496     struct AddressData {
1497         uint128 balance;
1498         uint128 numberMinted;
1499     }
1500 
1501     uint256 internal currentIndex = 0;
1502 
1503     // Token name
1504     string private _name;
1505 
1506     // Token symbol
1507     string private _symbol;
1508 
1509     // Mapping from token ID to ownership details
1510     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1511     mapping(uint256 => TokenOwnership) internal _ownerships;
1512 
1513     // Mapping owner address to address data
1514     mapping(address => AddressData) private _addressData;
1515 
1516     // Mapping from token ID to approved address
1517     mapping(uint256 => address) private _tokenApprovals;
1518 
1519     // Mapping from owner to operator approvals
1520     mapping(address => mapping(address => bool)) private _operatorApprovals;
1521 
1522     constructor(string memory name_, string memory symbol_) {
1523         _name = name_;
1524         _symbol = symbol_;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-totalSupply}.
1529      */
1530     function totalSupply() public view override returns (uint256) {
1531         return currentIndex;
1532     }
1533 
1534     /**
1535      * @dev See {IERC721Enumerable-tokenByIndex}.
1536      */
1537     function tokenByIndex(uint256 index) public view override returns (uint256) {
1538         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1539         return index;
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1544      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1545      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1546      */
1547     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1548         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1549         uint256 numMintedSoFar = totalSupply();
1550         uint256 tokenIdsIdx = 0;
1551         address currOwnershipAddr = address(0);
1552         for (uint256 i = 0; i < numMintedSoFar; i++) {
1553             TokenOwnership memory ownership = _ownerships[i];
1554             if (ownership.addr != address(0)) {
1555                 currOwnershipAddr = ownership.addr;
1556             }
1557             if (currOwnershipAddr == owner) {
1558                 if (tokenIdsIdx == index) {
1559                     return i;
1560                 }
1561                 tokenIdsIdx++;
1562             }
1563         }
1564         revert('ERC721A: unable to get token of owner by index');
1565     }
1566 
1567     /**
1568      * @dev See {IERC165-supportsInterface}.
1569      */
1570     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1571         return
1572             interfaceId == type(IERC721).interfaceId ||
1573             interfaceId == type(IERC721Metadata).interfaceId ||
1574             interfaceId == type(IERC721Enumerable).interfaceId ||
1575             super.supportsInterface(interfaceId);
1576     }
1577 
1578     /**
1579      * @dev See {IERC721-balanceOf}.
1580      */
1581     function balanceOf(address owner) public view override returns (uint256) {
1582         require(owner != address(0), 'ERC721A: balance query for the zero address');
1583         return uint256(_addressData[owner].balance);
1584     }
1585 
1586     function _numberMinted(address owner) internal view returns (uint256) {
1587         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1588         return uint256(_addressData[owner].numberMinted);
1589     }
1590 
1591     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1592         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1593 
1594         for (uint256 curr = tokenId; ; curr--) {
1595             TokenOwnership memory ownership = _ownerships[curr];
1596             if (ownership.addr != address(0)) {
1597                 return ownership;
1598             }
1599         }
1600 
1601         revert('ERC721A: unable to determine the owner of token');
1602     }
1603 
1604     /**
1605      * @dev See {IERC721-ownerOf}.
1606      */
1607     function ownerOf(uint256 tokenId) public view override returns (address) {
1608         return ownershipOf(tokenId).addr;
1609     }
1610 
1611     /**
1612      * @dev See {IERC721Metadata-name}.
1613      */
1614     function name() public view virtual override returns (string memory) {
1615         return _name;
1616     }
1617 
1618     /**
1619      * @dev See {IERC721Metadata-symbol}.
1620      */
1621     function symbol() public view virtual override returns (string memory) {
1622         return _symbol;
1623     }
1624 
1625     /**
1626      * @dev See {IERC721Metadata-tokenURI}.
1627      */
1628     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1629         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1630 
1631         string memory baseURI = _baseURI();
1632         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1633     }
1634 
1635     /**
1636      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1637      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1638      * by default, can be overriden in child contracts.
1639      */
1640     function _baseURI() internal view virtual returns (string memory) {
1641         return '';
1642     }
1643 
1644     /**
1645      * @dev See {IERC721-approve}.
1646      */
1647     function approve(address to, uint256 tokenId) public override {
1648         address owner = ERC721A.ownerOf(tokenId);
1649         require(to != owner, 'ERC721A: approval to current owner');
1650 
1651         require(
1652             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1653             'ERC721A: approve caller is not owner nor approved for all'
1654         );
1655 
1656         _approve(to, tokenId, owner);
1657     }
1658 
1659     /**
1660      * @dev See {IERC721-getApproved}.
1661      */
1662     function getApproved(uint256 tokenId) public view override returns (address) {
1663         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1664 
1665         return _tokenApprovals[tokenId];
1666     }
1667 
1668     /**
1669      * @dev See {IERC721-setApprovalForAll}.
1670      */
1671     function setApprovalForAll(address operator, bool approved) public override {
1672         require(operator != _msgSender(), 'ERC721A: approve to caller');
1673 
1674         _operatorApprovals[_msgSender()][operator] = approved;
1675         emit ApprovalForAll(_msgSender(), operator, approved);
1676     }
1677 
1678     /**
1679      * @dev See {IERC721-isApprovedForAll}.
1680      */
1681     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1682         return _operatorApprovals[owner][operator];
1683     }
1684 
1685     /**
1686      * @dev See {IERC721-transferFrom}.
1687      */
1688     function transferFrom(
1689         address from,
1690         address to,
1691         uint256 tokenId
1692     ) public override {
1693         _transfer(from, to, tokenId);
1694     }
1695 
1696     /**
1697      * @dev See {IERC721-safeTransferFrom}.
1698      */
1699     function safeTransferFrom(
1700         address from,
1701         address to,
1702         uint256 tokenId
1703     ) public override {
1704         safeTransferFrom(from, to, tokenId, '');
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-safeTransferFrom}.
1709      */
1710     function safeTransferFrom(
1711         address from,
1712         address to,
1713         uint256 tokenId,
1714         bytes memory _data
1715     ) public override {
1716         _transfer(from, to, tokenId);
1717         require(
1718             _checkOnERC721Received(from, to, tokenId, _data),
1719             'ERC721A: transfer to non ERC721Receiver implementer'
1720         );
1721     }
1722 
1723     /**
1724      * @dev Returns whether `tokenId` exists.
1725      *
1726      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1727      *
1728      * Tokens start existing when they are minted (`_mint`),
1729      */
1730     function _exists(uint256 tokenId) internal view returns (bool) {
1731         return tokenId < currentIndex;
1732     }
1733 
1734     function _safeMint(address to, uint256 quantity) internal {
1735         _safeMint(to, quantity, '');
1736     }
1737 
1738     /**
1739      * @dev Mints `quantity` tokens and transfers them to `to`.
1740      *
1741      * Requirements:
1742      *
1743      * - `to` cannot be the zero address.
1744      * - `quantity` cannot be larger than the max batch size.
1745      *
1746      * Emits a {Transfer} event.
1747      */
1748     function _safeMint(
1749         address to,
1750         uint256 quantity,
1751         bytes memory _data
1752     ) internal {
1753         uint256 startTokenId = currentIndex;
1754         require(to != address(0), 'ERC721A: mint to the zero address');
1755         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1756         require(!_exists(startTokenId), 'ERC721A: token already minted');
1757         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1758 
1759         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1760 
1761         AddressData memory addressData = _addressData[to];
1762         _addressData[to] = AddressData(
1763             addressData.balance + uint128(quantity),
1764             addressData.numberMinted + uint128(quantity)
1765         );
1766         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1767 
1768         uint256 updatedIndex = startTokenId;
1769 
1770         for (uint256 i = 0; i < quantity; i++) {
1771             emit Transfer(address(0), to, updatedIndex);
1772             require(
1773                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1774                 'ERC721A: transfer to non ERC721Receiver implementer'
1775             );
1776             updatedIndex++;
1777         }
1778 
1779         currentIndex = updatedIndex;
1780         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1781     }
1782 
1783     /**
1784      * @dev Transfers `tokenId` from `from` to `to`.
1785      *
1786      * Requirements:
1787      *
1788      * - `to` cannot be the zero address.
1789      * - `tokenId` token must be owned by `from`.
1790      *
1791      * Emits a {Transfer} event.
1792      */
1793     function _transfer(
1794         address from,
1795         address to,
1796         uint256 tokenId
1797     ) private {
1798         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1799 
1800         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1801             getApproved(tokenId) == _msgSender() ||
1802             isApprovedForAll(prevOwnership.addr, _msgSender()));
1803 
1804         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1805 
1806         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1807         require(to != address(0), 'ERC721A: transfer to the zero address');
1808 
1809         _beforeTokenTransfers(from, to, tokenId, 1);
1810 
1811         // Clear approvals from the previous owner
1812         _approve(address(0), tokenId, prevOwnership.addr);
1813 
1814         // Underflow of the sender's balance is impossible because we check for
1815         // ownership above and the recipient's balance can't realistically overflow.
1816         unchecked {
1817             _addressData[from].balance -= 1;
1818             _addressData[to].balance += 1;
1819         }
1820 
1821         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1822 
1823         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1824         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1825         uint256 nextTokenId = tokenId + 1;
1826         if (_ownerships[nextTokenId].addr == address(0)) {
1827             if (_exists(nextTokenId)) {
1828                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1829             }
1830         }
1831 
1832         emit Transfer(from, to, tokenId);
1833         _afterTokenTransfers(from, to, tokenId, 1);
1834     }
1835 
1836     /**
1837      * @dev Approve `to` to operate on `tokenId`
1838      *
1839      * Emits a {Approval} event.
1840      */
1841     function _approve(
1842         address to,
1843         uint256 tokenId,
1844         address owner
1845     ) private {
1846         _tokenApprovals[tokenId] = to;
1847         emit Approval(owner, to, tokenId);
1848     }
1849 
1850     /**
1851      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1852      * The call is not executed if the target address is not a contract.
1853      *
1854      * @param from address representing the previous owner of the given token ID
1855      * @param to target address that will receive the tokens
1856      * @param tokenId uint256 ID of the token to be transferred
1857      * @param _data bytes optional data to send along with the call
1858      * @return bool whether the call correctly returned the expected magic value
1859      */
1860     function _checkOnERC721Received(
1861         address from,
1862         address to,
1863         uint256 tokenId,
1864         bytes memory _data
1865     ) private returns (bool) {
1866         if (to.isContract()) {
1867             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1868                 return retval == IERC721Receiver(to).onERC721Received.selector;
1869             } catch (bytes memory reason) {
1870                 if (reason.length == 0) {
1871                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1872                 } else {
1873                     assembly {
1874                         revert(add(32, reason), mload(reason))
1875                     }
1876                 }
1877             }
1878         } else {
1879             return true;
1880         }
1881     }
1882 
1883     /**
1884      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1885      *
1886      * startTokenId - the first token id to be transferred
1887      * quantity - the amount to be transferred
1888      *
1889      * Calling conditions:
1890      *
1891      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1892      * transferred to `to`.
1893      * - When `from` is zero, `tokenId` will be minted for `to`.
1894      */
1895     function _beforeTokenTransfers(
1896         address from,
1897         address to,
1898         uint256 startTokenId,
1899         uint256 quantity
1900     ) internal virtual {}
1901 
1902     /**
1903      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1904      * minting.
1905      *
1906      * startTokenId - the first token id to be transferred
1907      * quantity - the amount to be transferred
1908      *
1909      * Calling conditions:
1910      *
1911      * - when `from` and `to` are both non-zero.
1912      * - `from` and `to` are never both zero.
1913      */
1914     function _afterTokenTransfers(
1915         address from,
1916         address to,
1917         uint256 startTokenId,
1918         uint256 quantity
1919     ) internal virtual {}
1920 }
1921 // File: contracts/nnft.sol
1922 
1923 
1924 pragma solidity ^0.8.8;
1925 
1926 
1927 
1928 contract Unemployables is ERC721A, Ownable {
1929   using Strings for uint256;
1930 
1931   uint256 public constant maxSupply = 5001;
1932   uint256 public constant PIXELIST_SALE_PRICE = 0.025 ether;
1933   uint256 public constant PUBLIC_SALE_PRICE = 0.025 ether;
1934 
1935   uint256 public pixelistSaleEpoch;
1936   uint256 public publicSaleEpoch;
1937 
1938   bytes32 public pixelistMerkleRoot;
1939 
1940   string public baseURI;
1941   string public notRevealedUri;
1942 
1943   mapping(address => uint256) public usedAddresses;
1944 
1945   bool public revealed = false;
1946 
1947   event Revealed(uint256 _tokenId);
1948 
1949   constructor(uint256 _pixelistSaleEpoch, uint256 _publicSaleEpoch, string memory _initBaseURI, string memory _initNotRevealedUri)
1950     ERC721A("Unemployables", "UNE")
1951   {
1952     pixelistSaleEpoch = _pixelistSaleEpoch;
1953     publicSaleEpoch = _publicSaleEpoch;
1954     setBaseURI(_initBaseURI);
1955     setNotRevealedURI(_initNotRevealedUri);
1956   }
1957 
1958    function tokenURI(uint256 tokenId)
1959         public
1960         view
1961         override(ERC721A)
1962         returns (string memory)
1963     {
1964         require(_exists(tokenId), "Nonexistent token");
1965         if (revealed == false) {
1966             return notRevealedUri;
1967         }
1968 
1969         string memory currentBaseURI = baseURI;
1970         return
1971             bytes(currentBaseURI).length > 0
1972                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1973                 : "";
1974     }
1975 
1976   function pixelistMint(bytes32[] calldata merkleProof, uint256 count)
1977     external
1978     payable
1979   {
1980     require(block.timestamp >= pixelistSaleEpoch, "Too soon");
1981     require(block.timestamp < publicSaleEpoch, "Whitelist sale over");
1982     require(
1983       MerkleProof.verify(
1984         merkleProof,
1985         pixelistMerkleRoot,
1986         keccak256(abi.encodePacked(msg.sender))
1987       ),
1988       "Address not in the whitelist"
1989     );
1990     require(msg.value >= PIXELIST_SALE_PRICE * count, "Ether value sent is below the price");
1991     require(usedAddresses[msg.sender] + count <= 3, "max per wallet reached");
1992     require(count > 0 && count <= 3, "You can drop minimum 1, maximum 3 NFTs");
1993     require(totalSupply() + count <= maxSupply, "Cannot exceeds max supply");
1994 
1995     usedAddresses[msg.sender] += count;
1996 
1997     _mint(msg.sender, count);
1998   }
1999 
2000   function publicMint(uint256 count) external payable {
2001     require(block.timestamp >= publicSaleEpoch, "Too soon");
2002     require(msg.value >= PUBLIC_SALE_PRICE * count,
2003            "Ether value sent is below the price");
2004     require(totalSupply() + count <= maxSupply, "Cannot Eexceeds max supply");
2005     require(usedAddresses[msg.sender] + count <= 2, "max per wallet reached");
2006     require(count > 0 && count <= 2, "You can drop minimum 1, maximum 2 NFTs");
2007 
2008     usedAddresses[msg.sender] += count;
2009 
2010     _mint(msg.sender, count);
2011   }
2012 
2013   function reservedMint(address _addrs, uint256 count) public onlyOwner {
2014     require(count <= maxSupply, "Not enough NFTs left");
2015       _mint(_addrs, count);
2016   }
2017 
2018 
2019    /**
2020   * @dev Used by public mint functions and by owner functions.
2021   * Can only be called internally by other functions.
2022   */
2023   function _mint(address to, uint256 count) internal virtual returns (uint256){
2024     _safeMint(to, count);
2025 
2026     return count;
2027   }
2028 
2029   function reveal() public onlyOwner {
2030     revealed = true;
2031   }
2032 
2033   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2034     notRevealedUri = _notRevealedURI;
2035   }
2036 
2037   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2038     baseURI = _newBaseURI;
2039   }
2040 
2041   function setPixelistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2042     pixelistMerkleRoot = _merkleRoot;
2043   }
2044 
2045   function setPixelistSaleEpoch(uint256 _epoch) external onlyOwner {
2046     pixelistSaleEpoch = _epoch;
2047   }
2048 
2049   function setPublicSaleEpoch(uint256 _epoch) external onlyOwner {
2050     publicSaleEpoch = _epoch;
2051   }
2052 
2053   function withdraw() external onlyOwner {
2054     uint256 balance = address(this).balance;
2055     payable(msg.sender).transfer(balance);
2056   }
2057 
2058   function withdrawTokens(IERC20 token) external onlyOwner {
2059     uint256 balance = token.balanceOf(address(this));
2060     token.transfer(msg.sender, balance);
2061   }
2062 }